param([string]$Profile="player1",[string]$Server="127.0.0.1",[int]$Port=7788)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$exe=Join-Path $root 'Builds/CrystalPrototype/ZatodCrystal.exe'
if(-not (Test-Path -LiteralPath $exe)){throw 'Build the Crystal prototype from Unity first: Zatod > Crystal > Build Windows Prototype.'}
$process=Start-Process -FilePath $exe -ArgumentList @('--crystal-profile',"`"$Profile`"",'--server',$Server,'--crystal-port',"$Port") -PassThru
Write-Output "Crystal client PID=$($process.Id), profile=$Profile. Click Ket noi in the game."
