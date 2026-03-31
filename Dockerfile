# ---------- Build Stage ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /app

# Copy only project files first (for caching)
COPY *.sln ./
COPY src/*.csproj ./src/
COPY tests/*.csproj ./tests/

RUN dotnet restore

# Copy full source
COPY . .

# Build only main service (skip tests)
RUN dotnet publish src/cartservice.csproj -c Release -o /app/out

# ---------- Runtime Stage ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app
COPY --from=builder /app/out .

ENTRYPOINT ["dotnet", "cartservice.dll"]
