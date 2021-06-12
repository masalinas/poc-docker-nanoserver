FROM mcr.microsoft.com/dotnet/core/runtime:3.1-nanoserver-1909 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-nanoserver-1909 AS build
WORKDIR /src
COPY ["myWebApp.csproj", "./"]
RUN dotnet restore "./myWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "myWebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "myWebApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "myWebApp.dll"]
