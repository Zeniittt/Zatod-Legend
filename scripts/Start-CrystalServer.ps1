param([int]$Port=7788,[string]$DataDirectory="Artifacts/CrystalServer")
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$exe=Join-Path $root 'Builds/CrystalPrototype/ZatodCrystal.exe'
if(-not (Test-Path -LiteralPath $exe)){throw 'Build the Crystal prototype from Unity first: Zatod > Crystal > Build Windows Prototype.'}
$data=[IO.Path]::GetFullPath((Join-Path $root $DataDirectory));New-Item -ItemType Directory -Path $data -Force|Out-Null
$log=Join-Path $data 'server.log'
$process=Start-Process -FilePath $exe -ArgumentList @('-batchmode','-nographics','--crystal-server','--crystal-port',"$Port",'--data-dir',"`"$data`"",'-logFile',"`"$log`"") -WindowStyle Hidden -PassThru
Write-Output "Crystal server PID=$($process.Id), TCP=$Port, data=$data, log=$log"
