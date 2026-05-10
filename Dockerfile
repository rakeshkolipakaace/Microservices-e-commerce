# ---------- Build Stage ----------
FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go mod tidy && CGO_ENABLED=0 go build -o app .

# ---------- Runtime Stage ----------
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/app .

CMD ["./app"]
