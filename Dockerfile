# ---------- Build Stage ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /app
COPY . .

RUN dotnet restore
RUN dotnet publish -c Release -o out

# ---------- Runtime Stage ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app
COPY --from=builder /app/out .

ENTRYPOINT ["dotnet", "cartservice.dll"]
