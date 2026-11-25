"""Compile a fresh Zatod Xcode export and package an unsigned device IPA.

No signing, installation or upload. Run after Unity/content acceptance.
"""
import argparse
import hashlib
import json
import mmap
import os
from pathlib import Path
import plistlib
import subprocess
import zipfile


def sha(path):
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build-root', type=Path, required=True)
    parser.add_argument('--data', type=Path, required=True)
    parser.add_argument('--artifact-name', default='ZatodLegend-D34Complete-unsigned.ipa', help='Output IPA basename for this milestone.')
    parser.add_argument('--package-only', action='store_true', help='Reuse this task\'s successful native build; reverify the product and package with ZIP64.')
    args = parser.parse_args()
    root, data = args.build_root.resolve(), args.data.resolve()
    export = root / 'Xcode'
    if not (export / 'Unity-iPhone.xcodeproj').is_dir():
        raise ValueError('Expected an accepted Unity export under <build-root>/Xcode.')
    if not args.package_only and ((root / 'DerivedData').exists() or (root / 'Package').exists()):
        raise ValueError('Use a fresh build root; preserve previous products and packages.')
    heroes = json.loads((data / 'Heroes.txt').read_text(encoding='utf-8-sig'))
    if not heroes.get('UseExpandedCombatRules') or len(heroes['Heroes']) != 66 or sum(h.get('AvailableInFreePvp', False) for h in heroes['Heroes']) != 40:
        raise ValueError('The final D34 package requires the accepted 66-Hero/40-free V7 catalog.')
    command = ['xcodebuild', '-project', str(export / 'Unity-iPhone.xcodeproj'),
               '-scheme', 'Unity-iPhone', '-configuration', 'Release', '-sdk', 'iphoneos',
               '-destination', 'generic/platform=iOS', '-derivedDataPath', str(root / 'DerivedData'),
               'ARCHS=arm64', 'CODE_SIGNING_ALLOWED=NO', 'CODE_SIGNING_REQUIRED=NO', 'CODE_SIGN_IDENTITY=']
    if args.package_only:
        assert '** BUILD SUCCEEDED **' in (root / 'native-build.log').read_text(errors='replace')
        settings = (root / 'build-settings.json').read_text()
    else:
        with (root / 'native-build.log').open('w') as log:
            subprocess.run(command + ['build'], stdout=log, stderr=subprocess.STDOUT, check=True)
        settings = subprocess.check_output(command + ['-showBuildSettings', '-json'], text=True)
        (root / 'build-settings.json').write_text(settings)
    app = next(row['buildSettings'] for row in json.loads(settings) if row['buildSettings'].get('WRAPPER_EXTENSION') == 'app')
    product = Path(app['TARGET_BUILD_DIR']) / app['FULL_PRODUCT_NAME']
    info = plistlib.loads((product / 'Info.plist').read_bytes())
    assert info['CFBundleIdentifier'] == 'com.zatodlegend.lantest'
    assert info['MinimumOSVersion'] == '15.0' and info.get('NSLocalNetworkUsageDescription')
    assert not (product / 'Frameworks/UnityRuntime.framework').exists()
    binaries = []
    for executable in [product / info['CFBundleExecutable'], product / 'Frameworks/UnityFramework.framework/UnityFramework']:
        arch = subprocess.check_output(['lipo', '-archs', str(executable)], text=True).strip()
        assert arch == 'arm64', arch
        signature = subprocess.run(['codesign', '-dv', str(executable)], capture_output=True, text=True)
        assert signature.returncode != 0 and 'not signed' in signature.stderr.lower(), signature.stderr
        assert 'UnityRuntime' not in subprocess.check_output(['otool', '-L', str(executable)], text=True)
        assert 'platform IOS' in subprocess.check_output(['vtool', '-show-build', str(executable)], text=True)
        binaries.append(dict(Path=str(executable.relative_to(product)), Architecture=arch, Signed=False, Sha256=sha(executable)))
    exported = []
    for path in sorted((export / 'Data').rglob('*')):
        if path.is_file():
            target = product / 'Data' / path.relative_to(export / 'Data')
            assert target.is_file() and sha(path) == sha(target), target
            exported.append(str(path.relative_to(export / 'Data')))
    assert exported, 'The native product contains no verified Unity Data.'
    # Verify the actual packed TextAsset bytes, not just the editor-side catalog.
    pending = {p.relative_to(data).as_posix(): p.read_bytes() for p in data.rglob('*.txt')}
    locations = {}
    for path in (product / 'Data').rglob('*'):
        if not pending:
            break
        if not path.is_file() or not path.stat().st_size:
            continue
        with path.open('rb') as stream, mmap.mmap(stream.fileno(), 0, access=mmap.ACCESS_READ) as packed:
            for name, content in list(pending.items()):
                if packed.find(content) >= 0:
                    locations[name] = str(path.relative_to(product))
                    del pending[name]
    assert not pending, 'Expected Data TextAssets absent from the device product: ' + ', '.join(pending)
    payload = root / 'Package/Payload'
    if payload.exists():
        assert args.package_only and (payload / product.name).is_dir()
        for path in product.rglob('*'):
            copied = payload / product.name / path.relative_to(product)
            if path.is_symlink():
                assert copied.is_symlink() and os.readlink(path) == os.readlink(copied)
            elif path.is_file():
                assert copied.is_file() and sha(path) == sha(copied), copied
    else:
        payload.mkdir(parents=True, exist_ok=False)
        subprocess.run(['ditto', str(product), str(payload / product.name)], check=True)
    if Path(args.artifact_name).name != args.artifact_name or not args.artifact_name.endswith('.ipa'):
        raise ValueError('Artifact name must be an IPA basename.')
    ipa = root / args.artifact_name
    assert not ipa.exists(), 'Preserve or move the previous IPA before repackaging.'
    # ditto's ZIP32 size field wraps for resources.assets.resS above 4 GiB.
    # zipfile writes ZIP64 headers and streams files while preserving Unix modes.
    with zipfile.ZipFile(ipa, 'w', compression=zipfile.ZIP_DEFLATED, allowZip64=True) as archive:
        archive.write(payload, 'Payload/')
        for path in sorted(payload.rglob('*')):
            name = path.relative_to(payload.parent).as_posix()
            if path.is_symlink():
                info = zipfile.ZipInfo(name)
                info.create_system = 3
                info.external_attr = (0o120777 << 16)
                archive.writestr(info, os.readlink(path).encode('utf-8'))
            else:
                archive.write(path, name)
    with zipfile.ZipFile(ipa) as archive:
        bad = archive.testzip()
        assert bad is None, 'Invalid ZIP CRC: ' + str(bad)
        assert 'Payload/' + product.name + '/Info.plist' in archive.namelist()
        assert 'Payload/' + product.name + '/' + info['CFBundleExecutable'] in archive.namelist()
    result = dict(Result='PASS', Ipa=str(ipa), ContainingFolder=str(root), Bytes=ipa.stat().st_size,
                  Sha256=sha(ipa), Unsigned=True, Installed=False, DeviceRunVerified=False,
                  BundleId=info['CFBundleIdentifier'], MinimumOSVersion=info['MinimumOSVersion'],
                  LocalNetworkPrompt=True, Binaries=binaries, ExportedDataFilesCompared=len(exported),
                  PackedTextAssets=locations, ConfigVersion=heroes['ConfigVersion'], Heroes=66, FreePvp=40, Zip64=True)
    (root / 'ipa-verification.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(result, ensure_ascii=False, indent=2), flush=True)


if __name__ == '__main__':
    main()
