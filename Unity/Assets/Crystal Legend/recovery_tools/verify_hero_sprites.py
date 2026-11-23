"""Verify every exported part against the decoded atlas pixel fingerprint."""
import hashlib
import json
from PIL import Image
from hero_animation import HEROES, OUT, write

def main():
    errors = []
    checked = 0
    atlases = 0
    for index, folder in enumerate(sorted(p.parent for p in HEROES.glob('*/atlas.json')), 1):
        records = json.loads((folder / 'atlas.json').read_text(encoding='utf-8'))
        for atlas in records:
            atlases += 1
            for sprite in atlas['sprites']:
                try:
                    path = folder / 'sprites' / sprite['name']
                    with Image.open(path) as image:
                        image.load()
                        if list(image.size) != sprite['restored_size']:
                            raise ValueError('Restored dimensions mismatch')
                        if hashlib.sha256(image.tobytes()).hexdigest() != sprite['pixel_sha256']:
                            raise ValueError('Exported sprite pixel hash mismatch')
                    checked += 1
                except Exception as exc:
                    errors.append({'hero': folder.name, 'sprite': sprite['name'], 'error': str(exc)})
        if index % 50 == 0:
            print(f'Sprite pixel verification {index}/314 characters; {checked} sprites', flush=True)
    report = {'characters': index, 'atlases': atlases, 'verified_sprites': checked, 'errors': errors}
    write(OUT / 'reports/hero_sprite_verification.json', json.dumps(report, ensure_ascii=False, indent=2).encode())
    print(json.dumps(report), flush=True)

if __name__ == '__main__':
    main()
