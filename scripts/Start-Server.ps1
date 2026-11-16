param([UInt16]$Port = 7777, [string]$DataDirectory = '')
$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
$arenaExecutable = Join-Path $prototypeRoot 'Builds\Windows\ZatodArena.exe'
if (-not (Test-Path -LiteralPath $arenaExecutable)) { throw 'Build first in Unity: Zatod > Build Windows Prototype.' }
if (-not $DataDirectory) { $DataDirectory = Join-Path $prototypeRoot 'ServerData' }
$DataDirectory = [System.IO.Path]::GetFullPath($DataDirectory)
New-Item -ItemType Directory -Force -Path $DataDirectory, (Join-Path $prototypeRoot 'Logs') | Out-Null
$serverLogPath = Join-Path $prototypeRoot ('Logs\server-' + $Port + '.log')
$serverArguments = @('-batchmode', '-nographics', '--arena-server', '--port', "$Port", '--data-dir', ('"' + $DataDirectory + '"'), '-logFile', ('"' + $serverLogPath + '"'))
$arenaServerProcess = Start-Process -FilePath $arenaExecutable -ArgumentList $serverArguments -WorkingDirectory $prototypeRoot -WindowStyle Hidden -PassThru
Write-Output ('Dedicated server PID: ' + $arenaServerProcess.Id)
Write-Output ('TCP port: ' + $Port)
Write-Output ('Replay directory: ' + $DataDirectory)
Write-Output ('Log: ' + $serverLogPath)
