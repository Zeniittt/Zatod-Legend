$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
& dotnet run --project (Join-Path $prototypeRoot 'Tests\CombatChecks\CombatChecks.csproj')
if ($LASTEXITCODE -ne 0) { throw 'Combat/replay checks failed.' }
