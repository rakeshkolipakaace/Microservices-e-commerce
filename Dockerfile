# ---------- Build Stage ----------
FROM python:3.11 AS builder

WORKDIR /app
COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --user --no-cache-dir -r requirements.txt

COPY . .

# ---------- Runtime Stage ----------
FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app .

ENV PATH=/root/.local/bin:$PATH

CMD ["python", "main.py"]
