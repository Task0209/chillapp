FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80/tcp

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["chillapp.csproj", "./"]
RUN dotnet restore "chillapp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "chillapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "chillapp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "chillapp.dll"]
