FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["TranslationBureau.Web/TranslationBureau.Web.csproj", "TranslationBureau.Web/"]
COPY ["TranslationBureau.Application/TranslationBureau.Application.csproj", "TranslationBureau.Application/"]
COPY ["TranslationBureau.Domain/TranslationBureau.Domain.csproj", "TranslationBureau.Domain/"]
COPY ["TranslationBureau.Infrastructure/TranslationBureau.Infrastructure.csproj", "TranslationBureau.Infrastructure/"]
RUN dotnet restore "TranslationBureau.Web/TranslationBureau.Web.csproj"
COPY . .
WORKDIR "/src/TranslationBureau.Web"
RUN dotnet build "TranslationBureau.Web.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "TranslationBureau.Web.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TranslationBureau.Web.dll"] 
