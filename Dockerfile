FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM node:18-alpine
WORKDIR /app
ENV DISABLE_PROFILER=1
COPY --from=builder /app .
CMD ["node", "index.js"]
