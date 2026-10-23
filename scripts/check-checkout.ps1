param (
    [int]$Count = 30
)

$port = if ($env:HOST_PORT) { $env:HOST_PORT } else { "8080" }
$url = "http://127.0.0.1:$port/api/checkout"

Write-Host ">>> Verificando $Count llamadas al endpoint $url ..." -ForegroundColor Cyan

$statusCodes = @{}

for ($i = 1; $i -le $Count; $i++) {
    $code = (curl.exe --no-keepalive -sS -o /dev/null -w "%{http_code}`n" $url).Trim()
    if (-not $statusCodes.ContainsKey($code)) {
        $statusCodes[$code] = 0
    }
    $statusCodes[$code]++
}

Write-Host "`nResultados de verificación HTTP ($Count solicitudes):" -ForegroundColor Yellow
$statusCodes.GetEnumerator() | ForEach-Object {
    $pct = [math]::Round(($_.Value / $Count) * 100, 1)
    Write-Host ("  {0,4} Código {1} ({2}%)" -f $_.Value, $_.Key, $pct)
}
