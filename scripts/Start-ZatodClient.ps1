param([string]$Profile="player1",[string]$Server="127.0.0.1",[int]$Port=7788)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$exe=Join-Path $root 'Builds/ZatodPrototype/ZatodLegend.exe'
if(-not (Test-Path -LiteralPath $exe)){throw 'Build the Zatod prototype from Unity first: Zatod > Tools > Build Windows Prototype.'}
$process=Start-Process -FilePath $exe -ArgumentList @('--zatod-profile',"`"$Profile`"",'--server',$Server,'--zatod-port',"$Port") -PassThru
Write-Output "Zatod client PID=$($process.Id), profile=$Profile. Click Ket noi in the game."
