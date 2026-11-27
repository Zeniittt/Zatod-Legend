"""Inspect the bundled ARM64 Lua loader without executing native code."""
import io
import pathlib
import sys
import zipfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / '.recovery-deps'))
from elftools.elf.elffile import ELFFile
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

with zipfile.ZipFile(ROOT / 'config.arm64_v8a.apk') as archive:
    DATA = archive.read('lib/arm64-v8a/libhellolua.so')
ELF = ELFFile(io.BytesIO(DATA))
SYMS = {s.name: s for s in ELF.get_section_by_name('.dynsym').iter_symbols()}
ADDRS = {s['st_value']: s.name for s in SYMS.values() if s['st_value']}
relocs = ELF.get_section_by_name('.rela.plt')
plt = ELF.get_section_by_name('.plt')
if relocs and plt:
    dynsym = ELF.get_section(relocs['sh_link'])
    for index, reloc in enumerate(relocs.iter_relocations()):
        ADDRS[plt['sh_addr'] + 32 + index * 16] = dynsym.get_symbol(reloc['r_info_sym']).name
DIS = Cs(CS_ARCH_ARM64, CS_MODE_ARM)

def read(address, size):
    for seg in ELF.iter_segments():
        if seg['p_type'] == 'PT_LOAD' and seg['p_vaddr'] <= address < seg['p_vaddr'] + seg['p_filesz']:
            off = address - seg['p_vaddr'] + seg['p_offset']
            return DATA[off:off + size]
    raise ValueError(hex(address))

def disassemble(address, size):
    for ins in DIS.disasm(read(address, size), address):
        note = ''
        if ins.mnemonic in ('bl', 'b') and ins.op_str.startswith('#'):
            target = int(ins.op_str[1:], 0)
            note = ADDRS.get(target, '')
        print(f'{ins.address:x}: {ins.mnemonic:8} {ins.op_str:42} {note}')

if __name__ == '__main__':
    for arg in sys.argv[1:]:
        if arg in SYMS:
            sym = SYMS[arg]
            print('\nSYMBOL', arg)
            disassemble(sym['st_value'], sym['st_size'])
        else:
            address, size = arg.split(':')
            disassemble(int(address, 0), int(size, 0))
