# Script 5: Etapa 4 - Inyección de Fallos Funcionales y Rollback Inmediato
Write-Host "==========================================================" -ForegroundColor Red
Write-Host "   Etapa 4: Inyección de Fallos en Green y Rollback" -ForegroundColor Red
Write-Host "==========================================================" -ForegroundColor Red

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "`n[+] Restaurando línea base Blue antes del incidente..." -ForegroundColor Yellow
& "$PSScriptRoot\promote.ps1" -Stage "blue"

Write-Host "`n[+] Recreando contenedor Green con fallo funcional (GREEN_FAIL=true)..." -ForegroundColor Yellow
$env:GREEN_FAIL = "true"
docker compose up -d --force-recreate green

Write-Host "`n[+] Promocionando a etapa CANARY10 para exponer el 10% del tráfico a Green..." -ForegroundColor Yellow
& "$PSScriptRoot\promote.ps1" -Stage "canary10"

Write-Host "`n[+] Verificando endpoint /health (Comportamiento de comprobación de salud básica)..." -ForegroundColor Yellow
$health = curl.exe -s http://127.0.0.1:8080/health
Write-Host "Respuesta de /health: $health (¡Engañoso! Retorna 200 OK a pesar del error de negocio)" -ForegroundColor Magenta

Write-Host "`n[+] Verificando endpoint de negocio /api/checkout (50 solicitudes)..." -ForegroundColor Yellow
& "$PSScriptRoot\check-checkout.ps1" -Count 50

Write-Host "`n[ALERTA DE PRODUCCIÓN] Detectadas respuestas HTTP 503 Service Unavailable en /api/checkout!" -ForegroundColor Red
Write-Host "Criterio de promoción violado: Tasa de error 5xx supera el umbral permitido (0%)." -ForegroundColor Red
Write-Host "DECISIÓN: ABORTAR PROMOCIÓN Y EJECUTAR ROLLBACK INMEDIATO A BLUE." -ForegroundColor Red

Write-Host "`n[+] Ejecutando Rollback inmediato a Blue..." -ForegroundColor Yellow
& "$PSScriptRoot\promote.ps1" -Stage "blue"

Write-Host "`n[+] Verificando estabilización del servicio en /api/checkout (20 solicitudes)..." -ForegroundColor Yellow
& "$PSScriptRoot\check-checkout.ps1" -Count 20

Write-Host "`n[+] Restaurando contenedor Green a estado funcional normal (GREEN_FAIL=false)..." -ForegroundColor Yellow
$env:GREEN_FAIL = "false"
docker compose up -d --force-recreate green

Write-Host "`n>> Rollback completado con éxito. El servicio productivo está 100% restablecido y protegido." -ForegroundColor Green
