# Script 4: Etapa 3 - Promoción Gradual (50% y 100% Green)
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Etapa 3: Promoción Gradual (Canary 50% y Green 100%)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "`n[+] Promocionando a etapa CANARY50 (50/50)..." -ForegroundColor Yellow
& "$PSScriptRoot\promote.ps1" -Stage "canary50"

Write-Host "`n[+] Muestreando 100 solicitudes HTTP hacia /api/info (Canary 50%)..." -ForegroundColor Yellow
& "$PSScriptRoot\sample.ps1" -Count 100

Write-Host "`n[+] Promocionando a etapa GREEN (100% v2)..." -ForegroundColor Yellow
& "$PSScriptRoot\promote.ps1" -Stage "green"

Write-Host "`n[+] Muestreando 30 solicitudes HTTP hacia /api/info (Green 100%)..." -ForegroundColor Yellow
& "$PSScriptRoot\sample.ps1" -Count 30

Write-Host "`n>> Confirmado: Green (v2) ha sido completamente promovida a producción." -ForegroundColor Green
