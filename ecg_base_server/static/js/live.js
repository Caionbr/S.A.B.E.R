// live.js — polling leve / dedupe / pausa em background
(() => {
  const POLL_MS = 250;
  let polling = false;
  let controller = null;
  let lastTs = 0;

  const sleep = (ms) => new Promise(r => setTimeout(r, ms));

  async function pollLoop() {
    while (polling) {
      try {
        controller = new AbortController();
        const r = await fetch(`/api/fpga/last?t=${Date.now()}`, {
          cache: "no-store",
          signal: controller.signal,
        });
        if (!r.ok) throw new Error("HTTP "+r.status);
        const j = await r.json();

        if (j && j.ok && !j.empty && j.ts && j.ts !== lastTs && Array.isArray(j.data)) {
          lastTs = j.ts;
          if (window.ECG?.pushSamples) window.ECG.pushSamples(j.data);
        }
      } catch { /* ignore */ }
      finally { controller = null; }

      await sleep(POLL_MS);
    }
  }

  function start(){ if (!polling){ polling = true; pollLoop(); } }
  function stop (){
    polling = false;
    if (controller){ try{ controller.abort(); }catch{} controller=null; }
  }

  document.addEventListener("visibilitychange", () => {
    if (document.hidden) stop(); else start();
  });
  window.addEventListener("beforeunload", stop);
  window.addEventListener("DOMContentLoaded", start);

  window.LivePoll = { start, stop };
})();
