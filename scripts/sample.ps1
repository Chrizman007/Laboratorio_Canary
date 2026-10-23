param (
    [int]$Count = 100
)

$port = if ($env:HOST_PORT) { $env:HOST_PORT } else { "8080" }
$url = "http://127.0.0.1:$port/api/info"

Write-Host ">>> Realizando $Count muestreos HTTP hacia $url ..." -ForegroundColor Cyan

$counts = @{ "v1" = 0; "v2" = 0; "error" = 0 }

for ($i = 1; $i -le $Count; $i++) {
    try {
        $res = curl.exe --no-keepalive -sS $url | ConvertFrom-Json
        if ($res.version -eq "v1") { $counts["v1"]++ }
        elseif ($res.version -eq "v2") { $counts["v2"]++ }
        else { $counts["error"]++ }
    } catch {
        $counts["error"]++
    }
}

Write-Host "`nResultados del muestreo ($Count solicitudes):" -ForegroundColor Yellow
$counts.GetEnumerator() | Where-Object { $_.Value -gt 0 } | ForEach-Object {
    $pct = [math]::Round(($_.Value / $Count) * 100, 1)
    Write-Host ("  {0,4} `"version`":`"{1}`" ({2}%)" -f $_.Value, $_.Key, $pct)
}
