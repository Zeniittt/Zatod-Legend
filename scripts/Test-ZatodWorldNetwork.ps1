param([int]$Port=17991)
$ErrorActionPreference='Stop'
$worldRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$worldExe=Join-Path $worldRoot 'Builds/ZatodPrototype/ZatodLegend.exe'
$worldStamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$worldEvidence=Join-Path $worldRoot "Artifacts/ZatodWorldChecks/network-$worldStamp"
New-Item -ItemType Directory -Path $worldEvidence -Force | Out-Null
$worldClients=@()
try {
 foreach($worldRole in @('world_right','world_left')){
  $worldArgs=@('-batchmode','-nographics','--zatod-smoke',$worldRole,'--zatod-profile',"$worldStamp-$worldRole",'--zatod-port',"$Port",'--smoke-output',"`"$worldEvidence/$worldRole.result`"",'-logFile',"`"$worldEvidence/$worldRole.log`"")
  $worldClients+=Start-Process -FilePath $worldExe -ArgumentList $worldArgs -WindowStyle Hidden -PassThru
 }
 Write-Output "RUNNING world clients=$($worldClients.Id -join ',') evidence=$worldEvidence"
 $worldDeadline=(Get-Date).AddSeconds(250)
 while((Get-Date) -lt $worldDeadline -and @($worldClients|Where-Object {-not $_.HasExited}).Count -gt 0){Start-Sleep -Milliseconds 500}
 foreach($worldClient in $worldClients){$worldClient.Refresh();if(-not $worldClient.HasExited -or $worldClient.ExitCode -ne 0){throw 'World network client failed or timed out.'}}
 $worldResults=@(Get-Content "$worldEvidence/world_left.result","$worldEvidence/world_right.result")
 if($worldResults.Count -ne 2 -or @($worldResults|Where-Object {$_ -notmatch 'PASS.*world peers movement isolation'}).Count -gt 0){throw 'World peer movement/isolation/portal proof incomplete.'}
 $worldResults | Set-Content "$worldEvidence/results.txt"
 Write-Output ($worldResults -join "`n")
} finally {
 foreach($worldClient in $worldClients){if(-not $worldClient.HasExited){Stop-Process -Id $worldClient.Id}}
}
