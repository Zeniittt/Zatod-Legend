param([UInt16]$Port = 17877, [string]$BuildFolder = 'Windows', [switch]$Leenald,
    [ValidatePattern('^[a-z][a-z0-9_]{0,63}$')][string]$HeroId)
$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
$arenaExecutable = Join-Path $prototypeRoot ('Builds\' + $BuildFolder + '\ZatodArena.exe')
if (-not (Test-Path -LiteralPath $arenaExecutable)) { throw 'Build the Windows prototype first.' }
$testDirectory = Join-Path $prototypeRoot ('Artifacts\NetworkSmoke\' + [Guid]::NewGuid().ToString('N'))
$testReplayDirectory = Join-Path $testDirectory 'Replays'
New-Item -ItemType Directory -Force -Path $testReplayDirectory | Out-Null
$testServer = $null
$testClient = $null

function Start-TestServer([string]$LogName) {
    $testServerLog = Join-Path $testDirectory $LogName
    $process = Start-Process -FilePath $arenaExecutable -ArgumentList @('-batchmode', '-nographics', '--arena-server', '--port', "$Port", '--data-dir', ('"' + $testReplayDirectory + '"'), '-logFile', ('"' + $testServerLog + '"')) -WorkingDirectory $prototypeRoot -WindowStyle Hidden -PassThru
    $readyDeadline = [DateTime]::UtcNow.AddSeconds(30)
    do {
        if ($process.HasExited) { throw ('Server exited: ' + $testServerLog) }
        if ((Test-Path -LiteralPath $testServerLog) -and (Select-String -LiteralPath $testServerLog -SimpleMatch '[ArenaServer] READY' -Quiet)) { return $process }
        Start-Sleep -Milliseconds 200
    } while ([DateTime]::UtcNow -lt $readyDeadline)
    Stop-Process -Id $process.Id
    throw ('Server did not become ready: ' + $testServerLog)
}

function Invoke-SmokeClient([string]$LogName, [string]$ReplayId = '') {
    $smokeLog = Join-Path $testDirectory $LogName
    $smokeArgs = @('-batchmode', '-nographics', '--arena-smoke', '--server', '127.0.0.1', '--port', "$Port", '-logFile', ('"' + $smokeLog + '"'))
    if ($Leenald) { $smokeArgs += '--leenald-smoke' }
    if ($HeroId) { $smokeArgs += @('--hero-smoke', $HeroId) }
    if ($ReplayId) { $smokeArgs += @('--replay-id', $ReplayId) }
    $process = Start-Process -FilePath $arenaExecutable -ArgumentList $smokeArgs -WorkingDirectory $prototypeRoot -WindowStyle Hidden -PassThru
    if (-not $process.WaitForExit(55000)) { Stop-Process -Id $process.Id; throw ('Client timed out: ' + $smokeLog) }
    $pass = Select-String -LiteralPath $smokeLog -Pattern '\[ArenaSmoke\] PASS battle=([a-f0-9]{32}).*serverActive=False'
    if ($process.ExitCode -ne 0 -or -not $pass) { throw ('Client failed: ' + $smokeLog) }
    return $pass.Matches[0].Groups[1].Value
}

try {
    $testServer = Start-TestServer 'server-first.log'
    Write-Output ('Dedicated server started: PID ' + $testServer.Id)
    $battleId = Invoke-SmokeClient 'client-first.log'
    $replayFile = Join-Path $testReplayDirectory ($battleId + '.arena.gz')
    $firstHash = (Get-FileHash -LiteralPath $replayFile -Algorithm SHA256).Hash
    if (@(Get-ChildItem -LiteralPath $testReplayDirectory -Filter '*.arena.gz').Count -ne 1) { throw 'Duplicate request created extra battles.' }
    Write-Output ('PASS create + playback + reload + idempotent retry: ' + $battleId)
    Stop-Process -Id $testServer.Id
    $testServer.WaitForExit()
    $testServer = $null
    $testServer = Start-TestServer 'server-restarted.log'
    $loadedId = Invoke-SmokeClient 'client-restarted.log' $battleId
    if ($loadedId -ne $battleId -or (Get-FileHash -LiteralPath $replayFile -Algorithm SHA256).Hash -ne $firstHash) { throw 'Replay changed after server restart.' }
    if (@(Get-ChildItem -LiteralPath $testReplayDirectory -Filter '*.arena.gz').Count -ne 1) { throw 'Loading history created an extra battle.' }
    $verification = [ordered]@{ passed = $true; battleId = $battleId; sha256 = $firstHash; archiveBytes = (Get-Item -LiteralPath $replayFile).Length; dedicatedServer = $true; clientServerActive = $false; idempotentRetry = $true; persistedAcrossRestart = $true; directory = $testDirectory }
    if ($HeroId) { $verification['heroDefinitionId'] = $HeroId }
    $verification | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $testDirectory 'result.json') -Encoding utf8
    Write-Output 'PASS server restart + persisted replay + identical archive hash'
    $verification | ConvertTo-Json
}
finally {
    if ($testServer -and -not $testServer.HasExited) { Stop-Process -Id $testServer.Id; $testServer.WaitForExit() }
}
