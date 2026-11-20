param([int]$Port=7788,[string]$DataDirectory="Artifacts/ZatodServer")
& (Join-Path $PSScriptRoot "Start-ZatodServer.ps1") -Port $Port -DataDirectory $DataDirectory
