param([int]$Port=7788,[string]$DataDirectory="ZatodServerData",[string]$Executable="")
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if([string]::IsNullOrWhiteSpace($Executable)){
  $exe=Join-Path ([Environment]::GetFolderPath('DesktopDirectory')) 'Zatod Legend LAN Test/Windows/ZatodLegend.exe'
  if(-not(Test-Path -LiteralPath $exe)){$exe=Join-Path $root 'Builds/ZatodPrototype/ZatodLegend.exe'}
}else{
  $exe=[IO.Path]::GetFullPath($(if([IO.Path]::IsPathRooted($Executable)){$Executable}else{Join-Path $root $Executable}))
}
if(-not (Test-Path -LiteralPath $exe)){throw 'Build the Zatod prototype from Unity first: Zatod > Tools > Build Windows Prototype.'}
if(Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue){throw "TCP port $Port is already in use. Stop the previous server first."}
$data=[IO.Path]::GetFullPath($(if([IO.Path]::IsPathRooted($DataDirectory)){$DataDirectory}else{Join-Path $root $DataDirectory}));New-Item -ItemType Directory -Path $data -Force|Out-Null
$log=Join-Path $data 'server.log'
$process=Start-Process -FilePath $exe -ArgumentList @('-batchmode','-nographics','--zatod-server','--zatod-port',"$Port",'--data-dir',"`"$data`"",'--player-data-dir',"`"$data`"",'-logFile',"`"$log`"") -WindowStyle Hidden -PassThru
Write-Output "Zatod server PID=$($process.Id), TCP=$Port, executable=$exe, players=$(Join-Path $data 'datas.json'), log=$log"
