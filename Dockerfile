FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
WORKDIR /app
COPY cartservice.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish cartservice.csproj -c Release -o /app/out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=builder /app/out .
ENV ASPNETCORE_URLS=http://+:7070
ENTRYPOINT ["dotnet", "cartservice.dll"]
