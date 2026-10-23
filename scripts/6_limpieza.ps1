# Script 6: Limpieza y apagado del entorno
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Limpieza y Apagado del Entorno Canary" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "`n[+] Deteniendo y eliminando contenedores..." -ForegroundColor Yellow
docker compose down -v

Write-Host "`n[+] Restaurando configuración inicial de Nginx a Blue..." -ForegroundColor Yellow
Copy-Item "nginx/stages/blue.conf" "nginx/active.conf" -Force

Write-Host "`n>> Entorno limpiado exitosamente." -ForegroundColor Green
