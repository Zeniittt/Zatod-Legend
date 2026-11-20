param([int]$Port=7788,[string]$DataDirectory="Artifacts/ZatodServer")
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$exe=Join-Path $root 'Builds/ZatodPrototype/ZatodLegend.exe'
if(-not (Test-Path -LiteralPath $exe)){throw 'Build the Zatod prototype from Unity first: Zatod > Tools > Build Windows Prototype.'}
$data=[IO.Path]::GetFullPath((Join-Path $root $DataDirectory));New-Item -ItemType Directory -Path $data -Force|Out-Null
$legacyData=Join-Path $root 'Artifacts/CrystalServer'
if($DataDirectory -eq 'Artifacts/ZatodServer' -and (Test-Path -LiteralPath $legacyData) -and -not (Test-Path -LiteralPath (Join-Path $data '.legacy-copied'))){
  Copy-Item -LiteralPath $legacyData -Destination (Join-Path $data 'LegacyBackup') -Recurse -Force
  $legacyOwned=Join-Path $legacyData 'Owned'
  if(Test-Path -LiteralPath $legacyOwned){$ownedDest=Join-Path $data 'Owned';New-Item -ItemType Directory -Path $ownedDest -Force|Out-Null;Get-ChildItem -LiteralPath $legacyOwned -File|ForEach-Object{$target=Join-Path $ownedDest $_.Name;if(-not(Test-Path -LiteralPath $target)){Copy-Item -LiteralPath $_.FullName -Destination $target}}}
  Get-ChildItem -LiteralPath $legacyData -Filter '*.crystal.gz' -File | Copy-Item -Destination $data
  Set-Content -LiteralPath (Join-Path $data '.legacy-copied') -Value 'Legacy source copied; original retained.'
}
$log=Join-Path $data 'server.log'
$process=Start-Process -FilePath $exe -ArgumentList @('-batchmode','-nographics','--zatod-server','--zatod-port',"$Port",'--data-dir',"`"$data`"",'-logFile',"`"$log`"") -WindowStyle Hidden -PassThru
Write-Output "Zatod server PID=$($process.Id), TCP=$Port, data=$data, log=$log"
