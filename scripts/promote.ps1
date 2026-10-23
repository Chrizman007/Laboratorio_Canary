param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("blue", "canary10", "canary50", "green")]
    [string]$Stage
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host ">>> Cambiando etapa de despliegue a: $Stage" -ForegroundColor Cyan

Copy-Item "nginx/active.conf" "nginx/previous.conf" -Force
Copy-Item "nginx/stages/$Stage.conf" "nginx/active.conf" -Force

try {
    docker compose exec -T proxy nginx -t
    if ($LASTEXITCODE -ne 0) { throw "Error de sintaxis en Nginx" }
} catch {
    Copy-Item "nginx/previous.conf" "nginx/active.conf" -Force
    Write-Error "Configuración inválida en Nginx. Se restauró la configuración anterior."
    exit 1
}

docker compose exec -T proxy nginx -s reload
Write-Host ">>> Etapa activada exitosamente: $Stage" -ForegroundColor Green
