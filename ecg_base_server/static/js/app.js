// app.js — LED de atividade + GO/STOP
(() => {
  window.addEventListener("DOMContentLoaded", () => {
    const led = document.getElementById("status-led");
    const blink = () => {
      if (!led) return;
      led.classList.add("on");
      setTimeout(() => led.classList.remove("on"), 140);
    };

    // sempre que o plot receber um bloco, pisca
    const orig = window.ECG?.pushSamples?.bind(window.ECG);
    if (orig) {
      window.ECG.pushSamples = (...args) => { blink(); return orig(...args); };
    }

    // GO/STOP (opcionais)
    document.getElementById("btn-go")?.addEventListener("click", () => {
      fetch("/api/fpga/go", { method: "POST" }).catch(()=>{});
    });
    document.getElementById("btn-stop")?.addEventListener("click", () => {
      fetch("/api/fpga/stop", { method: "POST" }).catch(()=>{});
      // limpa a tela imediatamente
      if (window.ECG?.clear) window.ECG.clear();
    });
  });
})();
