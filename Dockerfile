FROM python:3.11-slim AS builder
WORKDIR /app`nENV PROJECT_ID=mock`nENV REGION=us-central1`nENV ALLOYDB_DATABASE_NAME=mock`nENV ALLOYDB_TABLE_NAME=mock`nENV ALLOYDB_CLUSTER_NAME=mock`nENV ALLOYDB_INSTANCE_NAME=mock`nENV ALLOYDB_SECRET_NAME=mock
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt
COPY . .

FROM python:3.11-slim
WORKDIR /app`nENV PROJECT_ID=mock`nENV REGION=us-central1`nENV ALLOYDB_DATABASE_NAME=mock`nENV ALLOYDB_TABLE_NAME=mock`nENV ALLOYDB_CLUSTER_NAME=mock`nENV ALLOYDB_INSTANCE_NAME=mock`nENV ALLOYDB_SECRET_NAME=mock
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "shoppingassistantservice.py"]
