# main.py
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Request
from fastapi.responses import FileResponse, JSONResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
from pathlib import Path
from typing import Optional
import asyncio, secrets, time, re

# ====== CONFIG ======
FPGA_TCP_HOST = "0.0.0.0"
FPGA_TCP_PORT = 5000

# Logs/telemetria
PRINT_FRAME_CONTENT = False          # imprime hex do wire
PRINT_PLAINTEXT_HEX = True           # imprime plaintext quando OK
PRINT_RAW_PARSE_SUMMARY = True       # imprime resumo quando FAIL

# === CHAVE ASCON (Ascon-128) ===
KEY_HEX = "8A55114D1CB6A9A2BE263D4D7AECAAFF"
KEY = bytes.fromhex(KEY_HEX)

# === Layout do frame (modo MANUAL/RAW) ===
# [NONCE(16) | AD(8) | TAG(16) | CIPH_REV(184 = 23×8B, ordem c22..c0)]
NONCE_LEN   = 16
AD_LEN      = 8
TAG_LEN     = 16
CT_LEN      = 184
FRAME_TOTAL = NONCE_LEN + AD_LEN + TAG_LEN + CT_LEN  # 224

# === Taxa de amostragem do sinal (Hz) ===
SAMPLE_RATE_HZ = 360

# === Importa codec (MANUAL/RAW, sem padding interno) ===
from crypto.ascon_codec import decrypt_fpga_frame, FrameFormatError

BASE_DIR = Path(__file__).resolve().parent
STATIC_DIR = BASE_DIR / "static"

app = FastAPI(title="ECG Base Server")
app.mount("/static", StaticFiles(directory=str(STATIC_DIR)), name="static")

# ---------------------------
# Login simples (memória)
# ---------------------------
SESSIONS = {}
SESSION_COOKIE = "session"

def get_session_token(req: Request):
    tok = req.cookies.get(SESSION_COOKIE)
    return tok if tok in SESSIONS else None

# ---------------------------
# Páginas
# ---------------------------
@app.get("/")
async def login_page():
    return FileResponse(str(STATIC_DIR / "login.html"))

@app.post("/api/login")
async def api_login(payload: dict):
    username = (payload.get("username") or "").strip()
    password = (payload.get("password") or "").strip()
    if username == "user" and password == "user":
        token = secrets.token_urlsafe(32)
        SESSIONS[token] = {"username": username, "created": time.time()}
        resp = JSONResponse({"ok": True})
        resp.set_cookie(SESSION_COOKIE, token, httponly=True, samesite="lax")
        return resp
    return JSONResponse({"ok": False, "error": "Credenciais inválidas"}, status_code=401)

@app.post("/api/logout")
async def api_logout(request: Request):
    tok = get_session_token(request)
    if tok:
        SESSIONS.pop(tok, None)
    resp = JSONResponse({"ok": True})
    resp.delete_cookie(SESSION_COOKIE)
    return resp

@app.get("/api/session")
async def api_session(request: Request):
    tok = get_session_token(request)
    if not tok:
        return JSONResponse({"ok": False}, status_code=401)
    return JSONResponse({"ok": True, **SESSIONS[tok]})

@app.get("/app")
async def app_page(request: Request):
    tok = get_session_token(request)
    if not tok:
        return RedirectResponse(url="/", status_code=302)
    return FileResponse(str(STATIC_DIR / "index.html"))

@app.get("/health")
async def health():
    return JSONResponse({"status": "ok"})

# ---------------------------
# WebSocket de teste (eco)
# ---------------------------
@app.websocket("/ws/echo")
async def ws_echo(ws: WebSocket):
    token = ws.cookies.get(SESSION_COOKIE)
    if not token or token not in SESSIONS:
        await ws.close(code=1008)
        return
    await ws.accept()
    try:
        while True:
            msg = await ws.receive_text()
            await ws.send_text(f"echo: {msg}")
    except WebSocketDisconnect:
        pass

# ---------------------------
# Estado para dados da FPGA
# ---------------------------
app.state.fpga_server = None
app.state.fpga_clients = set()
app.state.frame_count = 0
app.state.last_received_at = 0.0
app.state.last_hex = None           # string de hex “do fio” (filtrada)
app.state.last_raw_bytes = None     # bytes crus do fio
app.state.last_plaintext = None
app.state.last_decrypt_ok = None

# fatias do último frame (para debug/inspeção)
app.state.last_nonce = None
app.state.last_ad = None
app.state.last_tag = None
app.state.last_cipher_rev = None    # 184B como veio (c22..c0)

HEX_RE = re.compile(r'[0-9a-fA-F]+')

def hex_bytes(b: bytes) -> str:
    return " ".join(f"{x:02X}" for x in b)

# ---------------------------
# Broadcast de comandos p/ FPGA (GO/STOP/RESET)
# ---------------------------
async def _broadcast_fpga(cmd: str) -> int:
    if not cmd.endswith("\n"):
        cmd = cmd + "\n"
    writers = list(app.state.fpga_clients)
    if not writers:
        return 0
    ok = 0
    for w in writers:
        try:
            w.write(cmd.encode("ascii"))
            await w.drain()
            ok += 1
        except Exception:
            try:
                w.close()
            except Exception:
                pass
            app.state.fpga_clients.discard(w)
    return ok

@app.post("/api/fpga/go")
async def api_fpga_go(payload: Optional[dict] = None):
    ms = 0
    if payload and isinstance(payload, dict):
        try:
            ms = int(payload.get("pulse_ms") or 0)
        except Exception:
            ms = 0
    cmd = f"PULSE {ms}" if ms > 0 else "GO"
    n = await _broadcast_fpga(cmd)
    return {"ok": True, "sent": n, "cmd": cmd}

@app.post("/api/fpga/stop")
async def api_fpga_stop(payload: Optional[dict] = None):
    n = await _broadcast_fpga("STOP")
    return {"ok": True, "sent": n}

@app.post("/api/fpga/reset")
async def api_fpga_reset(payload: Optional[dict] = None):
    ms = 50
    if payload and isinstance(payload, dict):
        try:
            ms_in = int(payload.get("ms"))
            if ms_in > 0:
                ms = ms_in
        except Exception:
            pass
    n = await _broadcast_fpga(f"RESET {ms}")
    return {"ok": True, "sent": n, "ms": ms}

# ---------------------------
# Handler TCP da FPGA
# ---------------------------
async def fpga_client_handler(reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
    addr = writer.get_extra_info('peername')
    app.state.fpga_clients.add(writer)
    print(f"[FPGA] Conectado: {addr}")
    try:
        hello = await reader.readline()
        if hello:
            s0 = hello.decode(errors='ignore').strip()
            if s0:
                print(f"[FPGA] {s0}")

        while True:
            line = await reader.readline()
            if not line:
                break
            s = line.decode(errors='ignore').strip()

            if "HEX:" in s:
                # Telemetria de fio
                line_len = len(s)

                # extrai N=<num> se existir
                exp_n = None
                mN = re.search(r'\bN\s*=\s*(\d+)', s)
                if mN:
                    try:
                        exp_n = int(mN.group(1))
                    except Exception:
                        exp_n = None

                # pega substring após "HEX:"
                hexpart = s.split("HEX:", 1)[1]
                hex_digits = "".join(HEX_RE.findall(hexpart))
                hex_span_len = len(hex_digits)

                if exp_n is not None:
                    want = exp_n * 2  # 2 hex por byte
                    if hex_span_len < want:
                        print(f"[FPGA][WIRE] TRUNC: line_len={line_len}, hex_found={hex_span_len}, want={want}")
                    hex_digits = hex_digits[:want]

                # --- timing entre frames ---
                now = time.time()
                delta_ms = None
                if app.state.last_received_at > 0:
                    delta_ms = (now - app.state.last_received_at) * 1000.0
                app.state.last_received_at = now

                # atualiza estado básico
                app.state.frame_count += 1
                app.state.last_hex = hex_digits

                # bytes do fio
                try:
                    raw = bytes.fromhex(hex_digits)
                except ValueError:
                    raw = b""
                raw_len = len(raw)
                app.state.last_raw_bytes = raw

                if PRINT_FRAME_CONTENT:
                    print(f"[FPGA] WIRE: line_len={line_len} hex_found={hex_span_len} raw_len={raw_len}")

                # zera últimas fatias
                app.state.last_nonce = None
                app.state.last_ad = None
                app.state.last_tag = None
                app.state.last_cipher_rev = None

                # Tenta decriptar apenas com frame 224 certinho
                pt = None
                dec_ok = False

                if raw_len == FRAME_TOTAL:
                    # Fatia determinística (sem heurística)
                    nonce = raw[0:NONCE_LEN]
                    aad   = raw[NONCE_LEN:NONCE_LEN + AD_LEN]
                    tag   = raw[NONCE_LEN + AD_LEN:NONCE_LEN + AD_LEN + TAG_LEN]
                    ciph_rev = raw[NONCE_LEN + AD_LEN + TAG_LEN:NONCE_LEN + AD_LEN + TAG_LEN + CT_LEN]

                    # guarda para debug/inspeção
                    app.state.last_nonce = nonce
                    app.state.last_ad = aad
                    app.state.last_tag = tag
                    app.state.last_cipher_rev = ciph_rev  # 184B como veio (c22..c0)

                    try:
                        # decrypt_fpga_frame:
                        # - reordena c22..c0 -> c0..c22
                        # - corta 3 bytes finais (c22) => 181B
                        # - usa AD efetivo de 6B (sem 80 00)
                        pt = decrypt_fpga_frame(KEY, raw, variant="Ascon-128")
                        dec_ok = (pt is not None)
                    except FrameFormatError as fe:
                        print(f"[FPGA] decriptado: FAIL (frame inválido: {fe})")
                    except Exception as e:
                        print(f"[FPGA] decriptado: FAIL (erro: {e})")
                else:
                    pass

                app.state.last_decrypt_ok = dec_ok
                app.state.last_plaintext  = pt if dec_ok else None

                if dec_ok and pt:
                    print(f"[FPGA] decriptado: OK  (raw_len={raw_len})")
                    if PRINT_PLAINTEXT_HEX:
                        print(f"[FPGA] PLAINTEXT ({len(pt)}): {hex_bytes(pt)}")
                    if delta_ms is not None:
                        print(f"[FPGA] Δt desde último frame: {delta_ms:.2f} ms")
                else:
                    print(f"[FPGA] decriptado: FAIL (raw_len={raw_len}, esperado={FRAME_TOTAL})")
                    if PRINT_RAW_PARSE_SUMMARY and raw_len >= NONCE_LEN:
                        n_hex = hex_bytes(raw[0:NONCE_LEN]) if raw_len >= NONCE_LEN else "n/a"
                        a_hex = hex_bytes(raw[NONCE_LEN:NONCE_LEN + AD_LEN]) if raw_len >= NONCE_LEN + AD_LEN else "n/a"
                        t_hex = hex_bytes(raw[NONCE_LEN + AD_LEN:NONCE_LEN + AD_LEN + TAG_LEN]) if raw_len >= NONCE_LEN + AD_LEN + TAG_LEN else "n/a"
                        c_len = max(0, min(CT_LEN, raw_len - (NONCE_LEN + AD_LEN + TAG_LEN)))
                        print(f"        nonce={('16B' if raw_len>=NONCE_LEN else 'n/a')}, ad={('8B' if raw_len>=NONCE_LEN+AD_LEN else 'n/a')}, tag={('16B' if raw_len>=NONCE_LEN+AD_LEN+TAG_LEN else 'n/a')}, cipher={c_len}B")
                        if c_len >= 16:
                            c_head = hex_bytes(raw[NONCE_LEN+AD_LEN+TAG_LEN:NONCE_LEN+AD_LEN+TAG_LEN+16])
                            c_tail = hex_bytes(raw[NONCE_LEN+AD_LEN+TAG_LEN+CT_LEN-16:NONCE_LEN+AD_LEN+TAG_LEN+CT_LEN]) if raw_len >= FRAME_TOTAL else "n/a"
                            print(f"        cipher_head: {c_head}")
                            print(f"        cipher_tail: {c_tail}")

            else:
                print(f"[FPGA] {s}")

    except Exception as e:
        print(f"[FPGA] erro {addr}: {e}")
    finally:
        try:
            writer.close()
            await writer.wait_closed()
        except Exception:
            pass
        app.state.fpga_clients.discard(writer)
        print(f"[FPGA] Desconectado: {addr}")

# ---------------------------
# Startup/Shutdown: servidor TCP
# ---------------------------
@app.on_event("startup")
async def start_fpga_tcp_server():
    server = await asyncio.start_server(fpga_client_handler, FPGA_TCP_HOST, FPGA_TCP_PORT)
    app.state.fpga_server = server
    sockets = getattr(server, "sockets", None)
    bind_info = ", ".join(str(s.getsockname()) for s in sockets) if sockets else f"{FPGA_TCP_HOST}:{FPGA_TCP_PORT}"
    print(f"[FPGA] TCP escutando em {bind_info}")

@app.on_event("shutdown")
async def stop_fpga_tcp_server():
    server = app.state.fpga_server
    if server:
        server.close()
        await server.wait_closed()
        print("[FPGA] TCP parado")

# ---------------------------
# APIs de status/debug
# ---------------------------
@app.get("/api/fpga/status")
async def fpga_status():
    pt = app.state.last_plaintext or b""
    return {
        "listening": True if app.state.fpga_server else False,
        "bind": f"{FPGA_TCP_HOST}:{FPGA_TCP_PORT}",
        "clients": len(app.state.fpga_clients),
        "frames": app.state.frame_count,
        "has_last": app.state.last_hex is not None,
        "last_received_at": app.state.last_received_at,
        "wire": {
            "hex_len": len(app.state.last_hex)//2 if app.state.last_hex else 0,
            "raw_len": len(app.state.last_raw_bytes) if app.state.last_raw_bytes else 0,
        },
        "decrypt": {
            "ok": app.state.last_decrypt_ok,
            "plaintext_len": len(pt),
        },
        "signal": {
            "sr_hz": SAMPLE_RATE_HZ,
            "frame_sec": (len(pt) / SAMPLE_RATE_HZ) if pt else 0.0,
        }
    }

@app.get("/api/fpga/last")
async def fpga_last():
    if not app.state.last_hex:
        return JSONResponse({"ok": False, "error": "Nenhum frame recebido ainda"}, status_code=404)

    pt = app.state.last_plaintext or None
    resp = {
        "ok": True,
        "hex": app.state.last_hex,
        "bytes": len(app.state.last_hex)//2,
        "raw_len": len(app.state.last_raw_bytes) if app.state.last_raw_bytes else 0,
        "decrypt_ok": app.state.last_decrypt_ok,
        "plaintext_len": len(pt) if pt else 0,
        "plaintext_hex": hex_bytes(pt) if pt else None,

        # metadados para o front
        "sr_hz": SAMPLE_RATE_HZ,
        "samples_per_frame": (len(pt) if pt else 0),
        "frame_sec": ((len(pt) / SAMPLE_RATE_HZ) if pt else 0.0),

        # fatias do último frame (debug)
        "nonce_hex":        hex_bytes(app.state.last_nonce) if app.state.last_nonce else None,
        "ad_hex":           hex_bytes(app.state.last_ad) if app.state.last_ad else None,
        "tag_hex":          hex_bytes(app.state.last_tag) if app.state.last_tag else None,
        "cipher_rev_hex":   hex_bytes(app.state.last_cipher_rev) if app.state.last_cipher_rev else None,
    }
    return resp
