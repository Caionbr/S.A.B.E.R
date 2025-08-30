// ecg.js — strip chart com opção de grid (desligado por padrão)
(() => {
  class ECGStrip {
    constructor(canvas, { showGrid = false } = {}) {
      this.canvas = canvas;
      this.ctx = canvas.getContext("2d");
      this.dpr = Math.max(1, window.devicePixelRatio || 1);

      this.w = 0; this.h = 0;
      this.x = 0; this.prevY = null;

      this.showGrid = showGrid;      // << grid opcional

      this.colors = {
        bg: "#ffffff",
        gridFine: "#e9eef6",
        gridBold: "#d7e2f0",
        trace: "#10b981",
      };

      this.resize();
      window.addEventListener("resize", () => this.resize(), { passive:true });
    }

    resize() {
      const cssW = this.canvas.clientWidth || 1200;
      const cssH = this.canvas.clientHeight || 360;
      this.canvas.width  = Math.round(cssW * this.dpr);
      this.canvas.height = Math.round(cssH * this.dpr);
      this.ctx.setTransform(this.dpr,0,0,this.dpr,0,0);
      this.w = cssW; this.h = cssH;
      this.x = 0; this.prevY = null;
      this._drawGridFull();
    }

    _drawGridFull() {
      const { ctx, w, h, colors } = this;
      ctx.fillStyle = colors.bg;
      ctx.fillRect(0, 0, w, h);

      if (!this.showGrid) return;    // << sem linhas de grade

      const big = 25, fine = 5;
      ctx.strokeStyle = colors.gridFine; ctx.lineWidth = 1;
      for (let x=0; x<=w; x+=fine) { ctx.beginPath(); ctx.moveTo(x,0); ctx.lineTo(x,h); ctx.stroke(); }
      for (let y=0; y<=h; y+=fine) { ctx.beginPath(); ctx.moveTo(0,y); ctx.lineTo(w,y); ctx.stroke(); }

      ctx.strokeStyle = colors.gridBold; ctx.lineWidth = 1.3;
      for (let x=0; x<=w; x+=big) { ctx.beginPath(); ctx.moveTo(x,0); ctx.lineTo(x,h); ctx.stroke(); }
      for (let y=0; y<=h; y+=big) { ctx.beginPath(); ctx.moveTo(0,y); ctx.lineTo(w,y); ctx.stroke(); }
    }

    _mapByte(v) {
      const y = this.h - (v / 255) * this.h;
      return Math.max(1, Math.min(this.h - 2, y));
    }

    pushSamples(arr) {
      const { ctx, w, h, colors } = this;

      for (const v of arr) {
        const y = this._mapByte(v);

        // limpa a coluna atual
        ctx.fillStyle = colors.bg;
        ctx.fillRect(this.x, 0, 1, h);

        // (se quiser grid, redesenha só a linha do grid nesta coluna)
        if (this.showGrid) {
          if (this.x % 25 === 0) {
            ctx.strokeStyle = colors.gridBold;
            ctx.beginPath(); ctx.moveTo(this.x,0); ctx.lineTo(this.x,h); ctx.stroke();
          } else if (this.x % 5 === 0) {
            ctx.strokeStyle = colors.gridFine;
            ctx.beginPath(); ctx.moveTo(this.x,0); ctx.lineTo(this.x,h); ctx.stroke();
          }
        }

        // traço do ECG
        ctx.strokeStyle = colors.trace;
        ctx.lineWidth = 2;
        ctx.beginPath();
        if (this.prevY == null) {
          ctx.moveTo(this.x, y);
        } else {
          const px = this.x === 0 ? (w - 1) : (this.x - 1);
          ctx.moveTo(px, this.prevY);
        }
        ctx.lineTo(this.x, y);
        ctx.stroke();

        this.prevY = y;
        this.x = (this.x + 1) % w;

        // ao “voltar” ao início, zera e redesenha fundo
        if (this.x === 0) {
          this._drawGridFull();
          this.prevY = null;
        }
      }
    }

    clear() {
      this.prevY = null;
      this.x = 0;
      this._drawGridFull();
    }
  }

  window.addEventListener("DOMContentLoaded", () => {
    const canvas = document.getElementById("ecgCanvas");
    if (!canvas) return;
    // GRID DESLIGADO → só o traçado
    window.ECG = new ECGStrip(canvas, { showGrid: false });
  });
})();
