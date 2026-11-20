param([string]$Profile="player1",[string]$Server="127.0.0.1",[int]$Port=7788)
& (Join-Path $PSScriptRoot "Start-ZatodClient.ps1") -Profile $Profile -Server $Server -Port $Port
