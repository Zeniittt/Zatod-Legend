$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
& dotnet run --project (Join-Path $prototypeRoot 'Tests/MonsterChecks/MonsterChecks.csproj')
if ($LASTEXITCODE -ne 0) { throw 'Monster combat checks failed.' }
