// live.js — polling robusto do /api/fpga/last
(() => {
  const LAST_URL = new URL('/api/fpga/last', location.origin);
  const GO_URL   = new URL('/api/fpga/go',   location.origin);
  const STOP_URL = new URL('/api/fpga/stop', location.origin);

  const POLL_MS = 250;

  let running = false;
  let ctrl = null;

  // dedupe: guardamos ts e uma “assinatura” leve do bloco
  let lastTs = 0;
  let lastSig = '';

  const sleep = (ms) => new Promise(r => setTimeout(r, ms));

  const hexToBytes = (hexStr) => {
    const s = (hexStr || '').replace(/\s+/g, '');
    if (!s || s.length % 2) return [];
    const out = new Array(s.length >> 1);
    for (let i = 0, j = 0; i < s.length; i += 2, j++) {
      out[j] = parseInt(s.slice(i, i + 2), 16) & 0xff;
    }
    return out;
  };

  function sigOf(arr) {
    if (!arr || !arr.length) return '0';
    // assinatura leve: len|a0|a1|a2|aLast
    const a0 = arr[0] ?? 0;
    const a1 = arr[1] ?? a0;
    const a2 = arr[2] ?? a1;
    const az = arr[arr.length - 1] ?? a0;
    return `${arr.length}|${a0}|${a1}|${a2}|${az}`;
  }

  async function pollLoop() {
    while (running) {
      try {
        ctrl = new AbortController();
        const r = await fetch(`${LAST_URL.href}?t=${Date.now()}`, {
          cache: 'no-store',
          credentials: 'same-origin',
          signal: ctrl.signal,
        });
        if (!r.ok) {
          // só avisa 1x
          if (!pollLoop._warned) {
            console.warn('[live] /api/fpga/last falhou:', r.status, r.statusText);
            pollLoop._warned = true;
          }
        } else {
          const j = await r.json();

          // Normaliza payload: data[] ou plaintext_hex
          let data = Array.isArray(j?.data) ? j.data
                   : (typeof j?.plaintext_hex === 'string' ? hexToBytes(j.plaintext_hex) : null);

          const ts = Number(j?.ts) || 0;

          if (data && data.length) {
            const sig = sigOf(data);
            const isNew = (ts && ts !== lastTs) || (!ts && sig !== lastSig);

            if (isNew) {
              lastTs = ts || lastTs;   // se ts==0, mantemos o último válido
              lastSig = sig;

              // envia para o traçador
              if (window.ECG?.pushSamples) {
                window.ECG.pushSamples(data);
                // notifica LED
                window.dispatchEvent(new CustomEvent('ecg-frame'));
              }
            }
          }
        }
      } catch (e) {
        // AbortError é esperado quando a aba perde o foco ou recarrega
        if (e?.name !== 'AbortError' && !pollLoop._warnedAbort) {
          console.warn('[live] erro consultando /api/fpga/last:', e?.message || e);
          pollLoop._warnedAbort = true;
        }
      } finally {
        ctrl = null;
      }
      await sleep(POLL_MS);
    }
  }

  function start() {
    if (!running) { running = true; pollLoop(); }
  }
  function stop() {
    running = false;
    try { ctrl?.abort(); } catch {}
    ctrl = null;
  }

  // expõe GO/STOP com URL absoluta
  window.LiveFPGA = {
    async go(pulseMs = 0) {
      try {
        await fetch(GO_URL, {
          method: 'POST',
          credentials: 'same-origin',
          headers: { 'Content-Type': 'application/json' },
          body: pulseMs > 0 ? JSON.stringify({ pulse_ms: pulseMs }) : null
        });
      } catch {}
    },
    async stop() {
      try { await fetch(STOP_URL, { method: 'POST', credentials: 'same-origin' }); } catch {}
    }
  };

  document.addEventListener('visibilitychange', () => document.hidden ? stop() : start());
  window.addEventListener('beforeunload', stop);
  window.addEventListener('DOMContentLoaded', start);

  window.LivePoll = { start, stop }; // debug
})();
