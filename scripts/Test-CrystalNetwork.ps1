param([string]$Build="Builds/ZatodPrototype/ZatodLegend.exe",[int]$Port=17888)
& (Join-Path $PSScriptRoot "Test-ZatodNetwork.ps1") -Build $Build -Port $Port
