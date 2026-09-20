param([string]$Browser = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$temp = Join-Path $root '.tools\result-capture'
New-Item -ItemType Directory -Path $temp -Force | Out-Null
$cases = @(
    @{ Name='5 VU'; File='run-05vu.txt'; Command='k6 run --no-color --quiet --vus 5 --duration 1m script.js'; Detail='5 VU | 1 minute | baseline' },
    @{ Name='PASS'; File='threshold-pass.txt'; Command='k6 run --no-color --quiet -e SLO_P95_MS=477.555 threshold-pass.js'; Detail='30 VU | 1 minute | SLO p95 < 477.555 ms' }
)
foreach ($case in $cases) {
    $source = Join-Path $root ('results\' + $case.File)
    $content = Get-Content -LiteralPath $source -Raw
    $encoded = [System.Net.WebUtility]::HtmlEncode($content.Trim())
    $html = '<!doctype html><meta charset="utf-8"><title>k6 saved output</title><style>body{margin:32px;background:#fff;color:#111;font-family:Arial}h1{font-size:24px}p{font-size:16px}pre{font:16px/1.5 Consolas,monospace;white-space:pre-wrap;border-top:1px solid #bbb;padding-top:18px}</style><h1>k6 saved output: ' + $case.Name + '</h1><p>' + $case.Detail + '</p><p>Source: results/' + $case.File + ' | Browser capture of actual saved output</p><p>Executed command: <code>' + [System.Net.WebUtility]::HtmlEncode($case.Command) + '</code></p><pre>' + $encoded + '</pre>'
    $page = Join-Path $temp ($case.Name.Replace(' ','-') + '.html')
    [IO.File]::WriteAllText($page,$html,[Text.UTF8Encoding]::new($false))
    $imagePath = Join-Path $root ('screenshots\' + $case.Name + '.png')
    $uri = [Uri]::new($page).AbsoluteUri
    $profile = Join-Path $temp 'edge-profile'
    $height = if ($case.Name -eq 'PASS') { 1450 } else { 1150 }
    $ErrorActionPreference = 'Continue'
    & $Browser --headless --disable-gpu --no-first-run --hide-scrollbars "--user-data-dir=$profile" "--window-size=1500,$height" "--screenshot=$imagePath" $uri 2>&1 | Out-Null
    $browserExit = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    if ($browserExit -ne 0) { throw 'Browser screenshot failed' }
    if (!(Test-Path -LiteralPath $imagePath)) { throw "Screenshot missing: $imagePath" }
    Write-Output $imagePath
}
