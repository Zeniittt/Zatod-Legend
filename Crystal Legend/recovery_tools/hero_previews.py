"""Create and verify an animated preview for every recovered character."""
import collections
import concurrent.futures
import json
from pathlib import Path
from PIL import Image
from hero_animation import HEROES, OUT, render_action, write

def one(folder):
    name = folder.name
    try:
        summary = json.loads((folder / 'summary.json').read_text(encoding='utf-8'))
        actions = [a for a in summary['actions'] if a['frames'] > 0]
        selected = next((a for a in actions if a['name'] == 'Idle'), actions[0])
        result = render_action(name, selected['name'])
        path = OUT / result['output']
        with Image.open(path) as image:
            duration = 0
            count = image.n_frames
            for i in range(count):
                image.seek(i)
                image.load()
                duration += image.info.get('duration', 0)
            if count > selected['frames']:
                raise ValueError('Preview has too many frames')
            if count > 1 and abs(duration - round(selected['duration_seconds'] * 1000)) > 1:
                raise ValueError('Preview duration mismatch')
        result.update(encoded_frames=count, duration_ms=duration, preview_decode_verified=True)
        return result
    except Exception as exc:
        return {'hero': name, 'status': 'error', 'error': str(exc)}

if __name__ == '__main__':
    folders = sorted(p.parent for p in HEROES.glob('*/summary.json'))
    records = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        for record in pool.map(one, folders):
            records.append(record)
            if record['status'] == 'error' or len(records) % 10 == 0:
                print(f'Character previews {len(records)}/{len(folders)}: {record["hero"]} {record["status"]} {record.get("error", "")}', flush=True)
    write(OUT / 'reports/hero_previews.json', json.dumps(records, ensure_ascii=False, indent=2).encode())
    print('Preview results:', dict(collections.Counter(r['status'] for r in records)), flush=True)
