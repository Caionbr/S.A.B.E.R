// app.js — LED de atividade + GO/STOP + relatório de páginas
(() => {
  function renderReport() {
    const cont = document.getElementById("report");
    if (!cont || !window.ECG) return;
    cont.innerHTML = "";

    const imgs = window.ECG.getReportImages(true);
    for (const src of imgs) {
      const el = new Image();
      el.src = src;
      el.className = "page";
      cont.appendChild(el);
    }
    cont.classList.remove("hidden");
    // rola até o relatório
    try { window.scrollTo({ top: cont.offsetTop, behavior: "smooth" }); } catch {}
  }

  function clearReport() {
    const cont = document.getElementById("report");
    if (!cont) return;
    cont.innerHTML = "";
    cont.classList.add("hidden");
  }

  window.addEventListener("DOMContentLoaded", () => {
    const led = document.getElementById("status-led");
    const blink = () => {
      if (!led) return;
      led.classList.add("on");
      setTimeout(() => led.classList.remove("on"), 140);
    };

    // pisca ao receber dados
    const orig = window.ECG?.pushSamples?.bind(window.ECG);
    if (orig) {
      window.ECG.pushSamples = (...args) => { blink(); return orig(...args); };
    }

    // GO: limpa relatório, zera gravação e inicia polling
    document.getElementById("btn-go")?.addEventListener("click", () => {
      clearReport();
      if (window.ECG) { window.ECG.resetRecording(); window.ECG.clear(); }
      try { window.LivePoll?.start(); } catch {}
      fetch("/api/fpga/go", { method: "POST" }).catch(()=>{});
    });

    // STOP: para polling, pede STOP à FPGA e mostra relatório empilhado
    document.getElementById("btn-stop")?.addEventListener("click", () => {
      try { window.LivePoll?.stop(); } catch {}
      fetch("/api/fpga/stop", { method: "POST" }).catch(()=>{});
      // monta relatório com as páginas capturadas (inclui a página parcial)
      renderReport();
    });
  });
})();
