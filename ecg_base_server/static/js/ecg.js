// ecg.js — strip chart com “gravação” em páginas para relatório ao parar
(() => {
  class ECGStrip {
    constructor(canvas, { showGrid = false } = {}) {
      this.canvas = canvas;
      this.ctx = canvas.getContext("2d");
      this.dpr = Math.max(1, window.devicePixelRatio || 1);

      this.w = 0; this.h = 0;
      this.x = 0; this.prevY = null;

      this.showGrid = showGrid;      // grade opcional (default: desligada)
      this.pages = [];               // páginas gravadas (cada volta completa)

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

      if (!this.showGrid) return;

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

    /** salva a página atual antes de limpar (usada no wrap e no STOP) */
    _snapshotPage() {
      const c = document.createElement("canvas");
      c.width = this.canvas.width;
      c.height = this.canvas.height;
      const g = c.getContext("2d");
      g.drawImage(this.canvas, 0, 0);
      this.pages.push(c);
    }

    pushSamples(arr) {
      const { ctx, w, h, colors } = this;

      for (const v of arr) {
        const y = this._mapByte(v);

        // limpa a coluna atual
        ctx.fillStyle = colors.bg;
        ctx.fillRect(this.x, 0, 1, h);

        // redesenha grade apenas se habilitada
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

        // Ao completar uma volta: salva página e recomeça “limpo”
        if (this.x === 0) {
          this._snapshotPage();
          this._drawGridFull();
          this.prevY = null;
        }
      }
    }

    /** páginas como dataURLs; includeCurrent inclui a tela parcial atual */
    getReportImages(includeCurrent = true) {
      const out = this.pages.map(c => c.toDataURL("image/png"));
      if (includeCurrent) out.push(this.canvas.toDataURL("image/png"));
      return out;
    }

    /** limpa só a gravação (para novo GO) */
    resetRecording() { this.pages.length = 0; }

    /** limpa a tela e reinicia o desenho do zero */
    clear() {
      this.prevY = null;
      this.x = 0;
      this._drawGridFull();
    }
  }

  window.addEventListener("DOMContentLoaded", () => {
    const canvas = document.getElementById("ecgCanvas");
    if (!canvas) return;
    window.ECG = new ECGStrip(canvas, { showGrid: false }); // grid desligado
  });
})();
