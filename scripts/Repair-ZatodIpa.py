"""Remove Unity's build-time runtime framework before Sideloadly re-signs an IPA.

Creates a new package, preserves the input, and verifies every retained entry.
Does not sign the output or prove that an iPhone will install it.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import plistlib
import struct
import zipfile


def dylib_loads(data):
    magic = struct.unpack_from(">I", data)[0]
    if magic == 0xCAFEBABE:
        count = struct.unpack_from(">I", data, 4)[0]
        loads = []
        for i in range(count):
            _, _, offset, size, _ = struct.unpack_from(">IIIII", data, 8 + i * 20)
            loads.extend(dylib_loads(data[offset:offset + size]))
        return loads
    if magic != 0xCFFAEDFE:
        raise ValueError("Expected a little-endian 64-bit Mach-O executable")
    count = struct.unpack_from("<I", data, 16)[0]
    offset, loads = 32, []
    for _ in range(count):
        command, size = struct.unpack_from("<II", data, offset)
        if size < 8 or offset + size > len(data):
            raise ValueError("Malformed Mach-O load command")
        if command & 0x7FFFFFFF in (0xC, 0x18, 0x1F, 0x20, 0x23):
            name_offset = struct.unpack_from("<I", data, offset + 8)[0]
            loads.append(data[offset + name_offset:offset + size].split(b"\0")[0].decode())
        offset += size
    return loads


def digest_file(path):
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    source, output = args.input.resolve(), args.output.resolve()
    if source == output or output.exists():
        raise ValueError("Choose a new output filename; the input is never overwritten")
    app = "Payload/ZatodLegend.app/"
    excluded = app + "Frameworks/UnityRuntime.framework/"
    input_hash = digest_file(source)
    hashes, removed, loads = {}, [], {}
    with zipfile.ZipFile(source) as original:
        names = original.namelist()
        if len(names) != len(set(names)):
            raise ValueError("Duplicate ZIP entry names")
        plist = plistlib.loads(original.read(app + "Info.plist"))
        if plist.get("CFBundleIdentifier") != "com.zatodlegend.lantest":
            raise ValueError("Unexpected app identifier")
        for binary in (app + "ZatodLegend", app + "Frameworks/UnityFramework.framework/UnityFramework"):
            loads[binary] = dylib_loads(original.read(binary))
            if any("UnityRuntime.framework" in name for name in loads[binary]):
                raise ValueError("App dynamically depends on UnityRuntime; refusing removal")
        if excluded + "UnityRuntime" not in names:
            raise ValueError("This package does not contain the affected framework")
        output.parent.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(output, "x", allowZip64=True) as fixed:
            fixed.comment = original.comment
            for info in original.infolist():
                if info.filename.startswith(excluded):
                    removed.append(info.filename)
                    continue
                entry = copy.copy(info)
                entry._compresslevel = 1
                digest = hashlib.sha256()
                with original.open(info) as incoming, fixed.open(entry, "w") as outgoing:
                    while chunk := incoming.read(1024 * 1024):
                        digest.update(chunk)
                        outgoing.write(chunk)
                hashes[info.filename] = digest.hexdigest()
    with zipfile.ZipFile(output) as fixed:
        if set(fixed.namelist()) != set(hashes):
            raise ValueError("Output entry set mismatch")
        for name, expected in hashes.items():
            with fixed.open(name) as stream:
                if hashlib.file_digest(stream, "sha256").hexdigest() != expected:
                    raise ValueError("Changed retained entry: " + name)
    if digest_file(source) != input_hash:
        raise ValueError("Input changed during repair")
    report = dict(Input=str(source), Output=str(output), InputSHA256=input_hash,
                  OutputSHA256=digest_file(output), RemovedEntries=removed,
                  RetainedEntriesVerified=len(hashes), DynamicDependencies=loads,
                  InputUnchanged=True, NativeInstallVerified=False,
                  RequiresResigning=True)
    output.with_suffix(".report.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps({k: v for k, v in report.items() if k != "DynamicDependencies"}, indent=2))


if __name__ == "__main__":
    main()
