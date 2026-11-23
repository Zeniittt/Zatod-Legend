param([string]$OutputPath='')
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$project=Join-Path $root 'Unity'
$projectPattern=[regex]::Escape($project.Replace('\','/'))
$editors=@(Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" | Where-Object {
    $_.ExecutablePath -and $_.ExecutablePath.Replace('\','/') -match '/Editor/Unity.exe$' -and
    $_.CommandLine -and $_.CommandLine.Replace('\','/') -match $projectPattern -and
    $_.CommandLine -notmatch '-batchmode|-assetImportWorker'
})
if($editors.Count){throw 'Save your work and close the Zatod Unity Editor before exporting headlessly.'}
$cli=Join-Path $root 'Artifacts/Tools/UnityCLI/unity.exe'
if(-not(Test-Path -LiteralPath $cli)){throw "Unity CLI is missing: $cli"}
if([string]::IsNullOrWhiteSpace($OutputPath)){
    $OutputPath=Join-Path ([Environment]::GetFolderPath('Desktop')) ('Zatod Legend LAN Test/iOS/Xcode-'+(Get-Date -Format 'yyyyMMdd-HHmmss'))
}
$OutputPath=[IO.Path]::GetFullPath($OutputPath)
if((Test-Path -LiteralPath $OutputPath) -and (Get-ChildItem -LiteralPath $OutputPath -Force | Select-Object -First 1)){throw 'Choose an empty output folder. Existing Xcode exports will not be overwritten.'}
$checks=Join-Path $root 'Artifacts/ZatodIosChecks'
New-Item -ItemType Directory -Path $checks -Force | Out-Null
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
& $cli build $project --target iOS --execute-method Zatod.Editor.ZatodIosBuild.Export --output $OutputPath --allow-dirty-build --log-file (Join-Path $checks "ios-export-$stamp.log") --provenance-path (Join-Path $checks "ios-provenance-$stamp.json") --no-tail
if($LASTEXITCODE -ne 0){throw 'iOS export failed. See the export log; native compilation/signing has not run.'}
Write-Output "Xcode project: $OutputPath"
Write-Output 'Copy the entire folder to the Mac, then follow START-HERE.md.'
