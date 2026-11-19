param([UInt16]$Port = 17977, [switch]$UseBerthaxe)
$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
$arenaExecutable = Join-Path $prototypeRoot 'Builds\Windows\ZatodArena.exe'
$testDirectory = Join-Path $prototypeRoot ('Artifacts\CampaignSmoke\' + [Guid]::NewGuid().ToString('N'))
$testReplayDirectory = Join-Path $testDirectory 'Replays'
New-Item -ItemType Directory -Force -Path $testReplayDirectory | Out-Null
$testServer = $null
$testClient = $null
function Start-TestServer([string]$LogName) {
    $serverLog = Join-Path $testDirectory $LogName
    $process = Start-Process -FilePath $arenaExecutable -ArgumentList @('-batchmode','-nographics','--arena-server','--port',"$Port",'--data-dir',('"'+$testReplayDirectory+'"'),'-logFile',('"'+$serverLog+'"')) -WorkingDirectory $prototypeRoot -WindowStyle Hidden -PassThru
    $readyDeadline = [DateTime]::UtcNow.AddSeconds(30)
    do {
        if ($process.HasExited) { throw ('Server exited: '+$serverLog) }
        if ((Test-Path -LiteralPath $serverLog) -and (Select-String -LiteralPath $serverLog -SimpleMatch '[ArenaServer] READY' -Quiet)) { return $process }
        Start-Sleep -Milliseconds 200
    } while ([DateTime]::UtcNow -lt $readyDeadline)
    Stop-Process -Id $process.Id
    throw ('Server startup timeout: '+$serverLog)
}
function Invoke-TestClient([string]$LogName,[bool]$Resume) {
    $clientLog = Join-Path $testDirectory $LogName
    $clientArgs = @('-batchmode','-nographics','--campaign-smoke','--server','127.0.0.1','--port',"$Port",'-logFile',('"'+$clientLog+'"'))
    if ($UseBerthaxe) { $clientArgs += '--campaign-berthaxe-smoke' }
    if ($Resume) { $clientArgs += '--campaign-resume' }
    $process = Start-Process -FilePath $arenaExecutable -ArgumentList $clientArgs -WorkingDirectory $prototypeRoot -WindowStyle Hidden -PassThru
    try {
        if (-not $process.WaitForExit(115000)) { throw ('Client timeout: '+$clientLog) }
        if ($process.ExitCode -ne 0 -or -not (Select-String -LiteralPath $clientLog -Pattern '\[CampaignSmoke\] PASS stages=5 heroes=5.*serverActive=False' -Quiet)) { throw ('Campaign client failed: '+$clientLog) }
    } finally { if (-not $process.HasExited) { Stop-Process -Id $process.Id } }
}
try {
    $testServer = Start-TestServer 'server-first.log'
    Invoke-TestClient 'client-first.log' $false
    $archives = @(Get-ChildItem -LiteralPath $testReplayDirectory -Filter '*.arena.gz')
    if ($archives.Count -ne 5) { throw 'Expected exactly five archives including idempotent retries.' }
    $hashes = @{}; foreach ($archive in $archives) { $hashes[$archive.Name] = (Get-FileHash -LiteralPath $archive.FullName -Algorithm SHA256).Hash }
    Write-Output 'PASS five stages, 5v5, playback, idempotent retries, server progress'
    Stop-Process -Id $testServer.Id; $testServer.WaitForExit(); $testServer = $null
    $testServer = Start-TestServer 'server-restarted.log'
    Invoke-TestClient 'client-restarted.log' $true
    foreach ($archive in $archives) { if ((Get-FileHash -LiteralPath $archive.FullName -Algorithm SHA256).Hash -ne $hashes[$archive.Name]) { throw 'Restart changed replay bytes.' } }
    if (@(Get-ChildItem -LiteralPath $testReplayDirectory -Filter '*.arena.gz').Count -ne 5) { throw 'Reload generated extra battles.' }
    $result = [ordered]@{passed=$true; stages=5; heroes=5; monstersPerStage=5; dedicatedServer=$true; clientServerActive=$false; idempotentRetry=$true; persistedAcrossRestart=$true; archiveHashes=$hashes; directory=$testDirectory}
    $result | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $testDirectory 'result.json') -Encoding utf8
    $result | ConvertTo-Json
} finally { if ($testServer -and -not $testServer.HasExited) { Stop-Process -Id $testServer.Id; $testServer.WaitForExit() } }
