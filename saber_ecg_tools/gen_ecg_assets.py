#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generate ECG assets for both STM DAC (12-bit) and FPGA ROM (8-bit).

Outputs:
  1) ecg_dac_12b.h       → STM32 DAC header (12-bit values, 0..4095)
  2) ecg_rom_full.mem    → FPGA ROM file (8-bit, full sequence, HEX/line)
  3) ecg_rom_181.mem     → FPGA ROM file (8-bit, 181-sample window with R-peak centered)

Usage examples:
  python gen_ecg_assets.py --record data/100 --dur-min 30
  python gen_ecg_assets.py --record data/100 --dur-min 5 --fs 360 --out-dir out

Notes:
- The script auto-installs missing dependencies (wfdb, numpy).
- No plots are generated; only log messages and files.
"""

import sys, subprocess, importlib
def _ensure(pkg):
    try:
        return importlib.import_module(pkg)
    except ModuleNotFoundError:
        print(f"[INFO] Installing dependency: {pkg} ...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", pkg])
        return importlib.import_module(pkg)

np   = _ensure("numpy")
wfdb = _ensure("wfdb")
import argparse, os, textwrap

# ===================== Default parameters =====================
DEFAULT_FS      = 360          # Hz
DEFAULT_DUR_MIN = 30           # minutes
DEFAULT_OUTDIR  = "out"

# ===== STM DAC scaling (12-bit, voltage reference) =====
DAC_BITS     = 12
VREF_VOLTS   = 3.3
VPEAK_VOLTS  = 3.0
PERC_12B     = 99.5
EXTRA_12B    = 1.00

# ===== FPGA ROM scaling (8-bit, 0..255) =====
BITS8        = 8
PERC_8B      = 99.0
HEADROOM_8B  = 0.95
EXTRA_8B     = 1.20

# ===================== Utility functions =====================

def read_and_resample_wfdb(record_path: str, chan: int, fs_target: float, dur_min: int, remove_dc: bool = True):
    """Read WFDB record, resample to target fs, trim/pad to duration, remove DC if needed."""
    print("[INFO] Reading WFDB record…")
    rec = wfdb.rdrecord(record_path, channels=[chan], physical=True)
    x_full = rec.p_signal.flatten().astype(np.float64)
    fs_src = float(rec.fs)
    print(f"[OK] fs_src={fs_src} Hz | samples={len(x_full)}")

    n_dst = int(round(dur_min * 60 * fs_target))
    if abs(fs_src - fs_target) > 1e-9:
        t_src = np.arange(len(x_full)) / fs_src
        t_dst = np.arange(n_dst) / fs_target
        x = np.interp(t_dst, t_src, x_full)
    else:
        x = x_full[:n_dst] if len(x_full) >= n_dst else np.pad(x_full, (0, n_dst - len(x_full)), mode='edge')

    if remove_dc:
        x = x - np.mean(x)

    print(f"[OK] fs_out={fs_target} Hz | duration ~ {len(x)/fs_target:.1f} s")
    return x, fs_src

def scale_to_12bit_dac(x: np.ndarray):
    """Scale ECG to 12-bit (0..4095) for STM DAC with voltage mapping."""
    dac_max   = (1 << DAC_BITS) - 1
    mid_code  = dac_max // 2
    max_code_target = int(round(dac_max * (VPEAK_VOLTS / VREF_VOLTS)))
    range_codes = max_code_target - mid_code

    mag   = np.abs(x)
    pval  = np.percentile(mag, PERC_12B) if np.any(mag) else 1.0
    if pval == 0: pval = 1.0

    scale = (range_codes / pval) * EXTRA_12B
    codes = np.round(mid_code + x * scale).astype(np.int32)
    codes = np.clip(codes, 0, dac_max).astype(np.uint16)

    print("\n=== STM 12-bit ===")
    print(f"Percentile {PERC_12B}% = {pval:.6f}")
    print(f"Scale12 = {scale:.3f} codes/unit | ExtraGain={EXTRA_12B}")
    print(f"Codes: min={codes.min()}, max={codes.max()}")

    return codes, dac_max, mid_code, max_code_target

def scale_to_8bit_fpga(x: np.ndarray):
    """Scale ECG to 8-bit (0..255) for FPGA ROM with headroom and fine gain."""
    max8 = (1 << BITS8) - 1
    mid8 = max8 / 2.0

    mag  = np.abs(x)
    pval = np.percentile(mag, PERC_8B) if np.any(mag) else 1.0
    if pval == 0: pval = 1.0

    scale = (mid8 * HEADROOM_8B / pval) * EXTRA_8B
    codes = np.round(mid8 + x * scale).astype(np.int32)
    codes = np.clip(codes, 0, max8).astype(np.uint8)

    print("\n=== FPGA 8-bit ===")
    print(f"Percentile {PERC_8B}% = {pval:.6f}")
    print(f"Scale8 = {scale:.3f} codes/unit | Headroom={HEADROOM_8B} | ExtraGain={EXTRA_8B}")
    print(f"Codes: min={codes.min()}, max={codes.max()} | total={len(codes)} samples")

    return codes, max8, int(mid8)

def write_header_12b(path_out: str, codes12: np.ndarray, fs_out: int, dur_min: int,
                     dac_max: int, mid_code: int, max_code_target: int):
    """Write C header with 12-bit ECG array for STM DAC."""
    os.makedirs(os.path.dirname(path_out), exist_ok=True)
    guard = 'ECG_DAC_12B_H_'
    with open(path_out, 'w', encoding='utf-8') as f:
        f.write(textwrap.dedent(f"""\
            #ifndef {guard}
            #define {guard}

            #include <stdint.h>
            #include <stddef.h>

            /* ECG {dur_min} minutes @ {fs_out} Hz — {len(codes12)} samples
               12-bit mapping 0..{dac_max}, offset={mid_code}
               Vref={VREF_VOLTS:.2f} V, peak target ≈ {VPEAK_VOLTS:.3f} V (MAX_CODE_TARGET={max_code_target})
               DC removal=1, Percentile={PERC_12B}%, ExtraGain={EXTRA_12B} */
            static const uint32_t ECG_NSAMPLES_12B = {len(codes12)};

            static const uint16_t ecg_12b[{len(codes12)}] = {{
        """))
        for i in range(0, len(codes12), 16):
            chunk = codes12[i:i+16].tolist()
            f.write("  " + ", ".join(str(int(v)) for v in chunk) + ",\n")
        f.write(textwrap.dedent("""
            };

            #endif /* ECG_DAC_12B_H_ */
        """))
    print(f"[OK] Header STM saved: {path_out}")

def write_mem_full(path_out: str, codes8: np.ndarray):
    """Write ecg_rom_full.mem: one HEX byte per line (for $readmemh)."""
    os.makedirs(os.path.dirname(path_out), exist_ok=True)
    with open(path_out, 'w', encoding='utf-8') as f:
        for v in codes8:
            f.write(f"{int(v):02X}\n")
    print(f"[OK] ecg_rom_full.mem saved: {path_out}")

def extract_window_181(sig_8b: np.ndarray, fs: int, margin_sec: float = 1.0):
    """Extract 181-sample window centered on the largest peak within central region."""
    L = len(sig_8b)
    if L < 181:
        raise ValueError("Signal too short for 181 samples.")
    margin = int(max(0, round(fs * margin_sec)))
    i0 = max(0, margin)
    i1 = min(L, L - margin)
    if i1 - i0 < 181:
        i0, i1 = 0, L
    sub = sig_8b[i0:i1]
    peak_rel = int(np.argmax(sub))
    peak_idx = i0 + peak_rel

    half = 90
    start = max(0, peak_idx - half)
    end   = start + 181
    if end > L:
        end = L
        start = end - 181
    window = sig_8b[start:end]
    return window, peak_idx, start, end

def write_mem_181(path_out: str, window_181: np.ndarray):
    """Write ecg_rom_181.mem: 181 HEX bytes (for $readmemh)."""
    os.makedirs(os.path.dirname(path_out), exist_ok=True)
    with open(path_out, 'w', encoding='utf-8') as f:
        for v in window_181:
            f.write(f"{int(v):02X}\n")
    print(f"[OK] ecg_rom_181.mem saved: {path_out}")

# ============================ Main ============================

def main():
    ap = argparse.ArgumentParser(description="Generate ECG assets (STM 12b + FPGA 8b).")
    ap.add_argument("--record", required=True, help="WFDB record path (without extension). Ex: data/100")
    ap.add_argument("--chan", type=int, default=0, help="WFDB channel (default: 0)")
    ap.add_argument("--fs", type=int, default=DEFAULT_FS, help=f"Target sampling rate (Hz). Default: {DEFAULT_FS}")
    ap.add_argument("--dur-min", type=int, default=DEFAULT_DUR_MIN, help=f"Duration (minutes). Default: {DEFAULT_DUR_MIN}")
    ap.add_argument("--out-dir", default=DEFAULT_OUTDIR, help=f"Output directory. Default: {DEFAULT_OUTDIR}")
    args = ap.parse_args()

    out_dir = args.out_dir
    os.makedirs(out_dir, exist_ok=True)

    # 1) Read + resample
    x, fs_src = read_and_resample_wfdb(args.record, args.chan, args.fs, args.dur_min, remove_dc=True)

    # 2) STM header (12-bit)
    codes12, dac_max, mid_code, max_code_target = scale_to_12bit_dac(x)
    write_header_12b(os.path.join(out_dir, "ecg_dac_12b.h"), codes12, args.fs, args.dur_min,
                     dac_max, mid_code, max_code_target)

    # 3) FPGA ROM (8-bit)
    codes8, max8, mid8 = scale_to_8bit_fpga(x)
    write_mem_full(os.path.join(out_dir, "ecg_rom_full.mem"), codes8)
    window181, peak_idx, start, end = extract_window_181(codes8, fs=args.fs, margin_sec=1.0)
    write_mem_181(os.path.join(out_dir, "ecg_rom_181.mem"), window181)
    print(f"[INFO] Window 181: start={start}, end={end}, peak={peak_idx}, peak_val={codes8[peak_idx]}")
    print("[DONE] Files written to:", os.path.abspath(out_dir))

if __name__ == "__main__":
    main()
