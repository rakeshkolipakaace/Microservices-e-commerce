FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt
COPY . .

FROM python:3.11-slim
WORKDIR /app
ENV PROJECT_ID=mock
ENV REGION=us-central1
ENV ALLOYDB_DATABASE_NAME=mock
ENV ALLOYDB_TABLE_NAME=mock
ENV ALLOYDB_CLUSTER_NAME=mock
ENV ALLOYDB_INSTANCE_NAME=mock
ENV ALLOYDB_SECRET_NAME=mock
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "shoppingassistantservice.py"]
