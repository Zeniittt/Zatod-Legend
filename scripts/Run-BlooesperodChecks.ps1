$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
& dotnet run --project (Join-Path $prototypeRoot 'Tests/BlooesperodChecks/BlooesperodChecks.csproj')
if ($LASTEXITCODE -ne 0) { throw 'Blooesperod combat checks failed.' }
