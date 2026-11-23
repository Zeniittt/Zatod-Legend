param([string]$Profile="player1",[string]$Server="",[int]$Port=7788)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$exe=Join-Path ([Environment]::GetFolderPath('DesktopDirectory')) 'Zatod Legend LAN Test/Windows/ZatodLegend.exe'
if(-not(Test-Path -LiteralPath $exe)){$exe=Join-Path $root 'Builds/ZatodPrototype/ZatodLegend.exe'}
if(-not (Test-Path -LiteralPath $exe)){throw 'Build the Zatod prototype from Unity first: Zatod > Tools > Build Windows Prototype.'}
$clientArguments=@('--zatod-profile',"`"$Profile`"",'--zatod-port',"$Port")
if(-not [string]::IsNullOrWhiteSpace($Server)){$clientArguments+=@('--server',$Server)}
$process=Start-Process -FilePath $exe -ArgumentList $clientArguments -PassThru
Write-Output "Zatod client PID=$($process.Id), profile=$Profile. Enter a name and click Connect; an empty Server parameter uses LAN discovery."
