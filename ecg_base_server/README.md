# ECG Base Server (FastAPI)

Projeto mínimo para subir um servidor web com uma tela única (HTML) + endpoint `/health` e um WebSocket de eco em `/ws/echo`.

## Requisitos
- Python 3.9+
- VSCode (opcional) e terminal

## Como rodar

### 1) Abrir a pasta no VSCode
- Extraia o zip ou abra a pasta `ecg_base_server/`

### 2) Criar venv e instalar dependências
**Windows (PowerShell):**
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

**Linux/macOS:**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3) Rodar o servidor
```bash
uvicorn main:app --reload --port 8000
```

Acesse: http://localhost:8000

- A página única está em `static/index.html`.
- Teste o botão **Conectar WS** e envie uma mensagem para ver o **eco**.
- O `/health` retorna `{ "status": "ok" }`.

## Próximos passos
- Trocar o placeholder por um gráfico de ECG em tempo real (uPlot/Plotly).
- Criar endpoints REST para sessões, métricas, export.
- Migrar de `ws://` para `wss://` quando publicar atrás de TLS.
