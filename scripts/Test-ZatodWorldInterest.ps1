param([string]$Build='Builds/ZatodPrototype/ZatodLegend.exe',[int]$Port=17998)
$ErrorActionPreference='Stop'
$interestRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$interestExe=(Resolve-Path (Join-Path $interestRoot $Build)).Path
$interestFolder=Join-Path $interestRoot ('Artifacts/ZatodWorldBattleChecks/interest-'+(Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $interestFolder -Force | Out-Null
$interestServer=$null;$interestClients=@()
try {
 $interestServer=Start-Process -FilePath $interestExe -ArgumentList @('-batchmode','-nographics','--zatod-server','--zatod-port',"$Port",'--data-dir',"`"$interestFolder/Server`"",'-logFile',"`"$interestFolder/server.log`"") -WindowStyle Hidden -PassThru
 $interestDeadline=(Get-Date).AddSeconds(35)
 while((Get-Date) -lt $interestDeadline){
  if($interestServer.HasExited){throw 'Interest server exited before ready.'}
  if((Test-Path -LiteralPath "$interestFolder/server.log") -and (Select-String -LiteralPath "$interestFolder/server.log" -SimpleMatch '[ZatodServer] READY' -Quiet)){break}
  Start-Sleep -Milliseconds 250
 }
 foreach($interestRole in @('interest_right','interest_left')){
  $interestArgs=@('-batchmode','-nographics','--zatod-port',"$Port",'--zatod-smoke',$interestRole,'--zatod-profile',([Guid]::NewGuid().ToString('N')),'--smoke-output',"`"$interestFolder/$interestRole.result`"",'-logFile',"`"$interestFolder/$interestRole.log`"")
  $interestClients+=Start-Process -FilePath $interestExe -ArgumentList $interestArgs -WindowStyle Hidden -PassThru
 }
 Write-Output "RUNNING interest evidence=$interestFolder server=$($interestServer.Id) clients=$($interestClients.Id -join ',')"
 $interestDeadline=(Get-Date).AddSeconds(70)
 while((Get-Date) -lt $interestDeadline -and @($interestClients|Where-Object {-not $_.HasExited}).Count -gt 0){Start-Sleep -Milliseconds 250}
 foreach($interestClient in $interestClients){$interestClient.Refresh();if(-not $interestClient.HasExited -or $interestClient.ExitCode -ne 0){throw 'Interest client failed or timed out.'}}
 $interestResults=@(Get-Content "$interestFolder/interest_left.result","$interestFolder/interest_right.result")
 if(@($interestResults|Where-Object {$_ -notmatch 'PASS.*far-hidden near-restored world-offset stale-pose-rejected'}).Count -gt 0){throw 'Interest evidence incomplete.'}
 $interestResults | Set-Content "$interestFolder/results.txt"
 Write-Output ($interestResults -join "`n")
 Write-Output "PASS evidence=$interestFolder"
} finally {
 foreach($interestClient in $interestClients){if(-not $interestClient.HasExited){Stop-Process -Id $interestClient.Id}}
 if($null -ne $interestServer -and -not $interestServer.HasExited){Stop-Process -Id $interestServer.Id}
}
