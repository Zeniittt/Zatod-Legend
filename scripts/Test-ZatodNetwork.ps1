param([string]$Build="Builds/ZatodPrototype/ZatodLegend.exe",[int]$Port=17888)
$ErrorActionPreference='Stop'
$projectRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$executable=(Resolve-Path (Join-Path $projectRoot $Build)).Path
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$evidence=Join-Path $projectRoot "Artifacts/ZatodPhaseChecks/network-$stamp"
New-Item -ItemType Directory -Path $evidence -Force | Out-Null
$serverArguments=@('-batchmode','-nographics','--zatod-server','--zatod-port',"$Port",'--data-dir',"`"$evidence/Server`"",'-logFile',"`"$evidence/server.log`"")
$server=Start-Process -FilePath $executable -ArgumentList $serverArguments -WindowStyle Hidden -PassThru
$players=@()
try {
    $readyDeadline=(Get-Date).AddSeconds(40)
    while((Get-Date) -lt $readyDeadline){
        if($server.HasExited){throw 'Server exited before becoming ready.'}
        if((Test-Path "$evidence/server.log") -and (Select-String -LiteralPath "$evidence/server.log" -SimpleMatch '[ZatodServer] READY' -Quiet)){break}
        Start-Sleep -Milliseconds 500
    }
    foreach($role in @('right','left')){
        $arguments=@('-batchmode','-nographics','--zatod-smoke',$role,'--zatod-profile',"smoke-$stamp-$role",'--zatod-port',"$Port",'--smoke-output',"`"$evidence/$role.result`"",'-logFile',"`"$evidence/$role.log`"")
        $players+=Start-Process -FilePath $executable -ArgumentList $arguments -WindowStyle Hidden -PassThru
    }
    Write-Output "RUNNING evidence=$evidence server=$($server.Id) left/right=$($players.Id -join ',')"
    $deadline=(Get-Date).AddSeconds(260)
    while((Get-Date) -lt $deadline -and @($players|Where-Object {-not $_.HasExited}).Count -gt 0){Start-Sleep -Milliseconds 500}
    foreach($player in $players){$player.Refresh();if(-not $player.HasExited){throw 'Client timeout.'};if($player.ExitCode -ne 0){throw "Client failed: $($player.ExitCode)"}}
    $results=@(Get-Content "$evidence/left.result", "$evidence/right.result")
    if($results.Count -ne 2 -or @($results|Where-Object {$_ -notmatch 'PASS.*pvp digest='}).Count -gt 0){throw 'Missing successful two-client reports.'}
    $digests=@($results|ForEach-Object {if($_ -match 'digest=(\d+)'){$matches[1]}})
    if($digests.Count -ne 2 -or $digests[0] -ne $digests[1]){throw 'PvP clients returned different digests.'}
    function Read-OwnedIdentity([string]$ownedPath){
        $account=Get-Content -LiteralPath $ownedPath -Raw|ConvertFrom-Json
        $identities=@($account.Inventory|ForEach-Object {"$($_.Id):$($_.ItemId)"})
        foreach($hero in $account.HeroDesk){
            $identities+=@($hero.EquippedItems|ForEach-Object {"$($_.Id):$($_.ItemId)"})
            $identities+=@($hero.AbsorbedItems|ForEach-Object {"$($_.Id):$($_.ItemId)"})
        }
        return @($identities|Sort-Object)
    }
    $leftOwned=@(Get-ChildItem "$evidence/Server/Owned" -Filter '*.json'|Where-Object {
        $account=Get-Content -LiteralPath $_.FullName -Raw|ConvertFrom-Json
        @($account.HeroDesk|Where-Object {$_.HeroDefinitionId -eq 'lina' -and $_.RankId -eq 'blue'}).Count -eq 1
    })
    if($leftOwned.Count -ne 1){throw 'Cannot identify the persisted blue Lina profile.'}
    $beforeIdentities=Read-OwnedIdentity $leftOwned[0].FullName
    if($beforeIdentities.Count -lt 24){throw 'Persisted item provenance is incomplete.'}
    $resetArguments=@('-batchmode','-nographics','--zatod-smoke','reset','--zatod-profile',"smoke-$stamp-left",'--zatod-port',"$Port",'--smoke-output',"`"$evidence/reset.result`"",'-logFile',"`"$evidence/reset.log`"")
    $reset=Start-Process -FilePath $executable -ArgumentList $resetArguments -WindowStyle Hidden -PassThru
    $players+=$reset
    $reset.WaitForExit(40000)|Out-Null
    if(-not $reset.HasExited -or $reset.ExitCode -ne 0 -or -not (Test-Path "$evidence/reset.result")){throw 'New application launch reset check failed.'}
    $afterIdentities=Read-OwnedIdentity $leftOwned[0].FullName
    if(@(Compare-Object $beforeIdentities $afterIdentities).Count -ne 0){throw 'Relaunch changed item GUID/type identities.'}
    $results+=Get-Content "$evidence/reset.result"
    $results+="PASS exact owned GUID/type pairs retained: $($afterIdentities.Count)"
    $results | Set-Content "$evidence/results.txt"
    Write-Output ($results -join "`n")
    Write-Output "PASS evidence=$evidence"
}
finally {
    foreach($player in $players){if(-not $player.HasExited){Stop-Process -Id $player.Id -Force}}
    if(-not $server.HasExited){Stop-Process -Id $server.Id -Force}
}
