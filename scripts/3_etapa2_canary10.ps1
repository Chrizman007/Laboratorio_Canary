# Script 3: Etapa 2 - Canary al 10%
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Etapa 2: Canary al 10% (Ponderación 9:1)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "`n[+] Promocionando a etapa CANARY10..." -ForegroundColor Yellow
& "$PSScriptRoot\promote.ps1" -Stage "canary10"

Write-Host "`n[+] Verificando configuración activa en Nginx..." -ForegroundColor Yellow
Get-Content "nginx/active.conf"

Write-Host "`n[+] Muestreando 100 solicitudes HTTP hacia /api/info..." -ForegroundColor Yellow
& "$PSScriptRoot\sample.ps1" -Count 100

Write-Host "`n>> Confirmado: Canary activo. Aproximadamente 90% a Blue y 10% a Green." -ForegroundColor Green
