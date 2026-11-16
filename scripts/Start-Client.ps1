param([string]$ServerAddress = '127.0.0.1', [UInt16]$Port = 7777)
$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
$arenaExecutable = Join-Path $prototypeRoot 'Builds\Windows\ZatodArena.exe'
if (-not (Test-Path -LiteralPath $arenaExecutable)) { throw 'Build first in Unity: Zatod > Build Windows Prototype.' }
if ($ServerAddress -notmatch '^[a-zA-Z0-9.:-]+$') { throw 'Enter a host name or IP address.' }
$clientLogPath = Join-Path $prototypeRoot 'Logs\client.log'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $clientLogPath) | Out-Null
# This is the interactive game window the user controls.
Start-Process -FilePath $arenaExecutable -ArgumentList @('--server', $ServerAddress, '--port', "$Port", '-screen-width', '1600', '-screen-height', '900', '-screen-fullscreen', '0', '-logFile', ('"' + $clientLogPath + '"')) -WorkingDirectory $prototypeRoot -WindowStyle Normal
