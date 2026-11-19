param([UInt16]$Port = 17978)
$ErrorActionPreference='Stop'
$prototypeRoot=Split-Path -Parent $PSScriptRoot
$arenaExecutable=Join-Path $prototypeRoot 'Builds\Windows\ZatodArena.exe'
$testDirectory=Join-Path $prototypeRoot ('Artifacts\CampaignLiveSmoke\'+[Guid]::NewGuid().ToString('N'))
$replays=Join-Path $testDirectory 'Replays'
New-Item -ItemType Directory -Force -Path $replays | Out-Null
$testServer=$null
function Start-TestServer([string]$LogName) {
    $log=Join-Path $testDirectory $LogName
    $process=Start-Process -FilePath $arenaExecutable -ArgumentList @('-batchmode','-nographics','--arena-server','--port',"$Port",'--data-dir',('"'+$replays+'"'),'-logFile',('"'+$log+'"')) -WorkingDirectory $prototypeRoot -WindowStyle Hidden -PassThru
    $end=[DateTime]::UtcNow.AddSeconds(30)
    do {
        if($process.HasExited){throw ('Server exited: '+$log)}
        if((Test-Path -LiteralPath $log) -and (Select-String -LiteralPath $log -SimpleMatch '[ArenaServer] READY' -Quiet)){return $process}
        Start-Sleep -Milliseconds 200
    }while([DateTime]::UtcNow -lt $end)
    Stop-Process -Id $process.Id;throw 'Server startup timed out.'
}
function Run-Client([string]$LogName,[string[]]$Extra) {
    $log=Join-Path $testDirectory $LogName
    $argsList=@('-batchmode','-nographics','--server','127.0.0.1','--port',"$Port",'-logFile',('"'+$log+'"'))+$Extra
    $process=Start-Process -FilePath $arenaExecutable -ArgumentList $argsList -WorkingDirectory $prototypeRoot -WindowStyle Hidden -PassThru
    try {
        if(-not $process.WaitForExit(125000)){throw ('Client timed out: '+$log)}
        if($process.ExitCode -ne 0){throw ('Client failed: '+$log)}
        return $log
    }finally{if(-not $process.HasExited){Stop-Process -Id $process.Id}}
}
try {
    $testServer=Start-TestServer 'server-first.log'
    $log=Run-Client 'client-live.log' @('--campaign-smoke','--campaign-live-smoke')
    $match=Select-String -LiteralPath $log -Pattern '\[CampaignLiveSmoke\] PASS battle=([a-f0-9]{32}) frames=(\d+) inputs=(\d+) winner=(-?\d+) serverActive=False'
    if(-not $match){throw ('Live smoke did not pass: '+$log)}
    $battleId=$match.Matches[0].Groups[1].Value
    $archive=Join-Path $replays ($battleId+'.arena.gz');$hash=(Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash
    Write-Output ('PASS live simulation + manual Ultimate + recorded inputs: '+$battleId)
    Stop-Process -Id $testServer.Id;$testServer.WaitForExit();$testServer=$null
    $testServer=Start-TestServer 'server-restarted.log'
    $reloadLog=Run-Client 'client-reload.log' @('--arena-smoke','--replay-id',$battleId)
    if(-not (Select-String -LiteralPath $reloadLog -Pattern '\[ArenaSmoke\] PASS.*serverActive=False' -Quiet)){throw ('Reload failed: '+$reloadLog)}
    if((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ne $hash -or @(Get-ChildItem -LiteralPath $replays -Filter '*.arena.gz').Count -ne 1){throw 'Manual replay changed after restart.'}
    $result=[ordered]@{passed=$true;battleId=$battleId;frames=[int]$match.Matches[0].Groups[2].Value;acceptedInputs=[int]$match.Matches[0].Groups[3].Value;winner=[int]$match.Matches[0].Groups[4].Value;sha256=$hash;dedicatedServer=$true;clientServerActive=$false;manualReplayPersistedAcrossRestart=$true;directory=$testDirectory}
    $result|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $testDirectory 'result.json') -Encoding utf8
    $result|ConvertTo-Json
}finally{if($testServer -and -not $testServer.HasExited){Stop-Process -Id $testServer.Id;$testServer.WaitForExit()}}
