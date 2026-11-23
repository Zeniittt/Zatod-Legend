param([switch]$Install,[string]$DeviceSerial='')
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$project=Join-Path $root 'Unity'
$projectPattern=[regex]::Escape($project.Replace('\','/'))
$editors=@(Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" | Where-Object {
    $_.ExecutablePath -and $_.ExecutablePath.Replace('\','/') -match '/Editor/Unity.exe$' -and
    $_.CommandLine -and $_.CommandLine.Replace('\','/') -match $projectPattern -and
    $_.CommandLine -notmatch '-batchmode|-assetImportWorker'
})
if($editors.Count){throw 'Save your work and close the Zatod Unity Editor before building Android headlessly.'}
$cli=Join-Path $root 'Artifacts/Tools/UnityCLI/unity.exe'
if(-not(Test-Path -LiteralPath $cli)){throw "Unity CLI is missing: $cli"}
$checks=Join-Path $root 'Artifacts/ZatodLanLoginChecks'
New-Item -ItemType Directory -Path $checks -Force | Out-Null
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$apk=Join-Path ([IO.Path]::GetTempPath()) 'ZatodLanTestBuild/Android/ZatodLegend.apk'
& $cli build $project --target Android --execute-method Zatod.Editor.ZatodLanBuild.AndroidBatch --output $apk --allow-dirty-build --log-file (Join-Path $checks "android-headless-$stamp.log") --provenance-path (Join-Path $checks "android-provenance-$stamp.json") --no-tail
if($LASTEXITCODE -ne 0){throw 'Android build failed. See the build log; no app was installed.'}
Write-Output "APK: $apk"
if(-not $Install){return}
$versionLine=Get-Content (Join-Path $project 'ProjectSettings/ProjectVersion.txt') | Where-Object {$_ -match '^m_EditorVersion: '}
$version=($versionLine -replace '^m_EditorVersion: ','').Trim()
$adb=Join-Path $env:ProgramFiles "Unity/Hub/Editor/$version/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/platform-tools/adb.exe"
if(-not(Test-Path -LiteralPath $adb)){throw "Android platform tools not found: $adb"}
if([string]::IsNullOrWhiteSpace($DeviceSerial)){
    $devices=@(& $adb devices | Where-Object {$_ -match '^\S+\s+device$'} | ForEach-Object {($_ -split '\s+')[0]})
    if($devices.Count -ne 1){throw 'Connect and authorize exactly one Android device, or pass -DeviceSerial.'}
    $DeviceSerial=$devices[0]
}
if((& $adb -s $DeviceSerial get-state 2>&1 | Out-String).Trim() -ne 'device'){throw 'Unlock the tablet and allow USB debugging, then retry installation. The APK has been retained.'}
& $adb -s $DeviceSerial install -r $apk
if($LASTEXITCODE -ne 0){throw 'APK installation failed. Do not uninstall or clear app data to retry.'}
