# Script 1: Preparación y levantamiento del entorno
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Paso 1: Preparación y Levantamiento Canary Release" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "`n[+] Verificando archivo .env..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Archivo .env creado desde .env.example." -ForegroundColor Green
}

Write-Host "`n[+] Ejecutando pruebas unitarias de Node.js..." -ForegroundColor Yellow
node --test test/*.test.js

Write-Host "`n[+] Construyendo imágenes e iniciando servicios con Docker Compose..." -ForegroundColor Yellow
docker compose up -d --build

Write-Host "`n[+] Verificando estado de los contenedores..." -ForegroundColor Yellow
docker compose ps

Write-Host "`n[+] Comprobando conectividad HTTP en http://127.0.0.1:8080/api/info..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
try {
    $res = curl.exe -s http://127.0.0.1:8080/api/info
    Write-Host "Respuesta: $res" -ForegroundColor Green
} catch {
    Write-Host "Error al conectar: $_" -ForegroundColor Red
}
