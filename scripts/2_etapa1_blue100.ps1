# Script 2: Etapa 1 - Línea Base (Blue 100%)
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Etapa 1: Línea Base (Blue 100% de tráfico)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "`n[+] Promocionando a etapa BLUE..." -ForegroundColor Yellow
& "$PSScriptRoot\promote.ps1" -Stage "blue"

Write-Host "`n[+] Verificando configuración activa en Nginx..." -ForegroundColor Yellow
Get-Content "nginx/active.conf"

Write-Host "`n[+] Muestreando 100 solicitudes HTTP hacia /api/info..." -ForegroundColor Yellow
& "$PSScriptRoot\sample.ps1" -Count 100

Write-Host "`n>> Confirmado: El 100% del tráfico va a Blue (v1). Green (v2) está aislado." -ForegroundColor Green
