# ---------- Build Stage ----------
FROM golang:1.25 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go mod tidy && go build -o app .

# ---------- Runtime Stage ----------
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/app .

CMD ["./app"]
