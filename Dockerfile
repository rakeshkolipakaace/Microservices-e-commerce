FROM node:18-alpine AS builder
WORKDIR /app`nENV DISABLE_PROFILER=1
COPY package*.json ./
RUN npm install
COPY . .

FROM node:18-alpine
WORKDIR /app`nENV DISABLE_PROFILER=1
COPY --from=builder /app .
CMD ["node", "index.js"]
