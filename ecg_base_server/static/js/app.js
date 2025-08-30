// app.js — LED de atividade + GO/STOP (com URLs absolutas via LiveFPGA)
(() => {
  function bindLed(){
    const led = document.getElementById('status-led');
    if (!led) return;
    const blink = () => { led.classList.add('on'); setTimeout(() => led.classList.remove('on'), 140); };
    window.addEventListener('ecg-frame', blink);
  }

  function bindButtons(){
    const btnGo   = document.getElementById('btn-go');
    const btnStop = document.getElementById('btn-stop');

    btnGo?.addEventListener('click', () => { window.LiveFPGA?.go(20); });
    btnStop?.addEventListener('click', async () => {
      await window.LiveFPGA?.stop();
      // limpa a tela imediatamente
      window.ECG?.clear?.();
    });
  }

  // se o ECG já existir, conecta o LED; senão espera o evento
  function hookWhenReady(){
    if (window.ECG) return bindLed();
    window.addEventListener('ecg-ready', bindLed, { once:true });
  }

  window.addEventListener('DOMContentLoaded', () => {
    hookWhenReady();
    bindButtons();
  });
})();
