$ErrorActionPreference = 'Stop'
$prototypeRoot = Split-Path -Parent $PSScriptRoot
& dotnet run --project (Join-Path $prototypeRoot 'Tests\HeroChecks\HeroChecks.csproj')
if ($LASTEXITCODE -ne 0) { throw 'Hero data checks failed.' }
