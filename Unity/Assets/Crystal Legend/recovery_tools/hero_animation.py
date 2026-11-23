"""Recover Crystal Legends FCA sprite parts and native animation timelines.

Derived from libhellolua.so readCha (0x284834) and EDFcaActor::update
(0x2817ac). No APK, native library or game Lua is executed.
"""
import argparse
import collections
import concurrent.futures
import hashlib
import io
import json
import math
from pathlib import Path
import plistlib
import re
import struct
import zipfile

from PIL import Image
from assets import pvr_image
from recover import ROOT, OUT, destination, write

PACK = OUT / 'downloads/aab_1.1.100312.zip'
HEROES = OUT / 'heroes'
TRANSLATION_SCALE = (0.157 / 1.5625) * 2.0

class ChaReader:
    def __init__(self, data):
        self.data = data
        self.pos = 0

    def read(self, fmt):
        size = struct.calcsize('<' + fmt)
        if self.pos + size > len(self.data):
            raise ValueError(f'Truncated CHA at {self.pos}')
        values = struct.unpack_from('<' + fmt, self.data, self.pos)
        self.pos += size
        if any(isinstance(v, float) and not math.isfinite(v) for v in values):
            raise ValueError('Nonfinite CHA number')
        return values

    def count(self, limit=1000000):
        value, = self.read('I')
        if value > limit:
            raise ValueError(f'Implausible CHA count {value} at {self.pos - 4}')
        return value

    def string(self):
        size = self.count(100000)
        if self.pos + size > len(self.data):
            raise ValueError('Truncated CHA string')
        raw = self.data[self.pos:self.pos + size]
        self.pos += size
        return raw.decode('utf-8')

    def parse(self):
        name = self.string()
        elements = []
        for index in range(self.count(65535)):
            elements.append({'id': index + 1, 'name': self.string(),
                             'sprite': self.string(), 'z_order': self.count()})
        actions = []
        for _ in range(self.count(10000)):
            action = {'name': self.string(), 'fps': self.read('f')[0], 'frames': []}
            if not 0 < action['fps'] <= 1000:
                raise ValueError('Invalid animation FPS')
            for frame_index in range(self.count(100000)):
                events = []
                for _ in range(self.count(10000)):
                    event_type = self.count()
                    argument = self.string()
                    values = self.read('8fI')
                    events.append({'type': event_type, 'argument': argument,
                                   'position': list(values[:2]), 'matrix': list(values[2:8]),
                                   'flags': values[8]})
                parts = []
                for _ in range(self.count(65535)):
                    part = list(self.read('HB6f'))
                    if not 1 <= part[0] <= len(elements):
                        raise ValueError(f'Element index outside table: {part[0]}')
                    parts.append(part)
                action['frames'].append({'events': events, 'elements': parts})
            action['duration_seconds'] = len(action['frames']) / action['fps']
            actions.append(action)
        if self.pos != len(self.data):
            raise ValueError(f'CHA has {len(self.data) - self.pos} unparsed bytes')
        return {'format': 'crystal-legends-fca-v1', 'name': name,
                'elements': elements, 'actions': actions,
                'frame_element_layout': ['element_id_1_based', 'alpha_0_255', 'a', 'b', 'c', 'd', 'tx', 'ty'],
                'coordinates': 'image coordinates: x right, y down; sprite origin at untrimmed center',
                'translation_scale_for_atlas_pixels': TRANSLATION_SCALE,
                'native_fca_scale': 0.157 / 1.5625, 'native_content_scale': 2.0,
                'cha_bytes': len(self.data), 'cha_bytes_consumed': self.pos}

def numbers(value):
    return [int(x) for x in re.findall(r'-?\d+', value)]

def encode_cha(animation):
    """Re-encode the parsed timeline for a byte-exact structural check."""
    output = bytearray()
    def add(fmt, *values):
        output.extend(struct.pack('<' + fmt, *values))
    def string(value):
        data = value.encode('utf-8')
        add('I', len(data))
        output.extend(data)
    string(animation['name'])
    add('I', len(animation['elements']))
    for element in animation['elements']:
        string(element['name'])
        string(element['sprite'])
        add('I', element['z_order'])
    add('I', len(animation['actions']))
    for action in animation['actions']:
        string(action['name'])
        add('fI', action['fps'], len(action['frames']))
        for frame in action['frames']:
            add('I', len(frame['events']))
            for event in frame['events']:
                add('I', event['type'])
                string(event['argument'])
                add('8fI', *event['position'], *event['matrix'], event['flags'])
            add('I', len(frame['elements']))
            for element in frame['elements']:
                add('HB6f', *element)
    return bytes(output)

def decode_atlas(plist, image):
    """Undo TexturePacker rotation and restore trimmed transparent margins."""
    if plist.get('metadata', {}).get('format') != 2:
        raise ValueError('Expected TexturePacker plist format 2')
    result = {}
    records = []
    for name, frame in plist['frames'].items():
        x, y, width, height = numbers(frame['frame'])
        source_w, source_h = numbers(frame['sourceSize'])
        left, top, trim_w, trim_h = numbers(frame['sourceColorRect'])
        rotated = bool(frame.get('rotated'))
        physical_w, physical_h = (height, width) if rotated else (width, height)
        if x < 0 or y < 0 or x + physical_w > image.width or y + physical_h > image.height:
            raise ValueError(f'Atlas rect out of bounds: {name}')
        cropped = image.crop((x, y, x + physical_w, y + physical_h))
        if rotated:
            cropped = cropped.transpose(Image.Transpose.ROTATE_90)
        if cropped.size != (trim_w, trim_h):
            raise ValueError(f'Trim size mismatch: {name}')
        if left < 0 or top < 0 or left + trim_w > source_w or top + trim_h > source_h:
            raise ValueError(f'Source color rect out of bounds: {name}')
        sprite = Image.new('RGBA', (source_w, source_h))
        sprite.paste(cropped, (left, top))
        # Round trip checks crop coordinates, rotation and padding exactly.
        check = sprite.crop((left, top, left + trim_w, top + trim_h))
        if rotated:
            check = check.transpose(Image.Transpose.ROTATE_270)
        if check.tobytes() != image.crop((x, y, x + physical_w, y + physical_h)).tobytes():
            raise ValueError(f'Atlas roundtrip mismatch: {name}')
        if name in result:
            raise ValueError(f'Duplicate atlas sprite: {name}')
        result[name] = sprite
        records.append({'name': name, 'frame': frame, 'restored_size': [source_w, source_h],
                        'pixel_sha256': hashlib.sha256(sprite.tobytes()).hexdigest()})
    return result, records

def recover_container(name):
    record = {'source': name, 'status': 'error'}
    try:
        with zipfile.ZipFile(PACK) as outer:
            container = outer.read(name)
        hero_name = Path(name).stem
        output = destination(HEROES, hero_name)
        all_sprites = {}
        atlas_records = []
        with zipfile.ZipFile(io.BytesIO(container)) as archive:
            for entry in archive.infolist():
                if not entry.is_dir():
                    write(destination(output / 'original', entry.filename), archive.read(entry))
            animation = ChaReader(archive.read('cha')).parse()
            if encode_cha(animation) != archive.read('cha'):
                raise ValueError('CHA parse/encode roundtrip mismatch')
            if animation['name'] != hero_name:
                raise ValueError(f'Internal CHA name {animation["name"]} != {hero_name}')
            plists = [n for n in archive.namelist() if n == 'plist' or re.fullmatch(r'\d+\.plist', n)]
            plists.sort(key=lambda n: 0 if n == 'plist' else int(n.split('.')[0]))
            sheets = []
            for plist_name in plists:
                index = 0 if plist_name == 'plist' else int(plist_name.split('.')[0])
                texture_name = 'sheet.pvr' if index == 0 else f'sheet{index}.pvr'
                image, header = pvr_image(archive.read(texture_name))
                sheet_target = output / 'sprite_sheets' / (Path(texture_name).stem + '.png')
                sheet_target.parent.mkdir(parents=True, exist_ok=True)
                image.save(sheet_target, compress_level=3)
                with Image.open(sheet_target) as check:
                    if check.tobytes() != image.tobytes():
                        raise ValueError('Sheet PNG pixel mismatch')
                atlas = plistlib.loads(archive.read(plist_name))
                sprites, sprite_records = decode_atlas(atlas, image)
                for sprite_name, sprite in sprites.items():
                    if sprite_name in all_sprites:
                        raise ValueError(f'Duplicate sprite across atlases: {sprite_name}')
                    all_sprites[sprite_name] = sprite
                    target = destination(output / 'sprites', sprite_name)
                    target.parent.mkdir(parents=True, exist_ok=True)
                    sprite.save(target, compress_level=3)
                atlas_records.append({'plist': plist_name, 'texture': texture_name,
                                      'width': image.width, 'height': image.height,
                                      'pvr_header': header, 'sprites': sprite_records})
                sheets.append(str(sheet_target.relative_to(output)))
            missing = []
            for element in animation['elements']:
                key = element['sprite'] + '.png'
                if key not in all_sprites:
                    missing.append(key)
                element['sprite_file'] = 'sprites/' + key
            if missing:
                raise ValueError(f'Missing element sprites: {missing[:10]}')
            write(output / 'animation.json', json.dumps(animation, ensure_ascii=False, separators=(',', ':')).encode())
            write(output / 'atlas.json', json.dumps(atlas_records, ensure_ascii=False, indent=2).encode())
            summary = {'name': hero_name, 'source': name, 'container_sha256': hashlib.sha256(container).hexdigest(),
                       'sprite_sheets': sheets, 'sprite_count': len(all_sprites), 'element_count': len(animation['elements']),
                       'actions': [{'name': a['name'], 'fps': a['fps'], 'frames': len(a['frames']),
                                    'duration_seconds': a['duration_seconds'],
                                    'events': sum(len(f['events']) for f in a['frames'])} for a in animation['actions']],
                       'cha_bytes': animation['cha_bytes'], 'cha_bytes_consumed': animation['cha_bytes_consumed'],
                       'atlas_pixel_roundtrip_verified': True}
            write(output / 'summary.json', json.dumps(summary, ensure_ascii=False, indent=2).encode())
            record.update(summary, status='recovered', output=str(output.relative_to(OUT)))
    except Exception as exc:
        record['error'] = str(exc)
    return record

def sprite_transform(part, sprite, translation_scale, output_scale=1.0):
    _, alpha, a, b, c, d, tx, ty = part
    tx = tx * translation_scale - a * sprite.width / 2 - c * sprite.height / 2
    ty = ty * translation_scale - b * sprite.width / 2 - d * sprite.height / 2
    return tuple(v * output_scale for v in (a, b, c, d, tx, ty))

def action_bounds(action, sprites, translation_scale, output_scale=1.0):
    points = []
    for frame in action['frames']:
        for part in frame['elements']:
            sprite = sprites[part[0]]
            if part[1] == 0:
                continue
            a, b, c, d, tx, ty = sprite_transform(part, sprite, translation_scale, output_scale)
            for x, y in [(0, 0), (sprite.width, 0), (0, sprite.height), sprite.size]:
                points.append((a * x + c * y + tx, b * x + d * y + ty))
    if not points:
        return 0, 0, 32, 32
    xs, ys = zip(*points)
    return math.floor(min(xs)) - 4, math.floor(min(ys)) - 4, math.ceil(max(xs)) + 4, math.ceil(max(ys)) + 4

def render_frame(frame, sprites, bounds, translation_scale, output_scale=1.0):
    min_x, min_y, max_x, max_y = bounds
    canvas = Image.new('RGBA', (max_x - min_x, max_y - min_y))
    # The native actor sets each sprite's Z order to its order in this frame.
    last_index = {part[0]: index for index, part in enumerate(frame['elements'])}
    for index, part in enumerate(frame['elements']):
        # Native repeatedly updates the same node when an ID occurs twice.
        # Its last transform, opacity and frame-order Z value win.
        if last_index[part[0]] != index:
            continue
        sprite = sprites[part[0]]
        if not part[1]:
            continue
        a, b, c, d, tx, ty = sprite_transform(part, sprite, translation_scale, output_scale)
        det = a * d - b * c
        if abs(det) < 1e-10:
            continue
        corners = [(a * x + c * y + tx, b * x + d * y + ty)
                   for x, y in [(0, 0), (sprite.width, 0), (0, sprite.height), sprite.size]]
        x0 = math.floor(min(p[0] for p in corners)) - 1
        y0 = math.floor(min(p[1] for p in corners)) - 1
        x1 = math.ceil(max(p[0] for p in corners)) + 1
        y1 = math.ceil(max(p[1] for p in corners)) + 1
        coeffs = (d / det, -c / det, (d * (x0 - tx) - c * (y0 - ty)) / det,
                  -b / det, a / det, (-b * (x0 - tx) + a * (y0 - ty)) / det)
        transformed = sprite.transform((x1 - x0, y1 - y0), Image.Transform.AFFINE,
                                       coeffs, Image.Resampling.BICUBIC)
        if part[1] != 255:
            transformed.putalpha(transformed.getchannel('A').point([v * part[1] // 255 for v in range(256)]))
        canvas.alpha_composite(transformed, (x0 - min_x, y0 - min_y))
    return canvas

def load_hero(hero_name):
    folder = destination(HEROES, hero_name)
    animation = json.loads((folder / 'animation.json').read_text(encoding='utf-8'))
    sprites = {}
    for element in animation['elements']:
        with Image.open(folder / element['sprite_file']) as image:
            sprites[element['id']] = image.convert('RGBA')
    return folder, animation, sprites

def render_action(hero_name, action_name, frames_png=False, max_size=640):
    folder, animation, sprites = load_hero(hero_name)
    action = next(a for a in animation['actions'] if a['name'] == action_name)
    scale = animation['translation_scale_for_atlas_pixels']
    bounds = action_bounds(action, sprites, scale)
    span = max(bounds[2] - bounds[0], bounds[3] - bounds[1])
    zoom = min(1.0, max_size / span) if max_size else 1.0
    if zoom < 1.0:
        bounds = action_bounds(action, sprites, scale, zoom)
    width, height = bounds[2] - bounds[0], bounds[3] - bounds[1]
    if width * height > 16000000:
        raise ValueError(f'Animation canvas too large: {width}x{height}')
    frames = [render_frame(f, sprites, bounds, scale, zoom) for f in action['frames']]
    if not frames:
        raise ValueError('Action has no frames')
    durations = [round((i + 1) * 1000 / action['fps']) - round(i * 1000 / action['fps'])
                 for i in range(len(frames))]
    preview = destination(folder / 'previews', action_name + '.webp')
    preview.parent.mkdir(parents=True, exist_ok=True)
    # Preview background is opaque; extracted sprites and PNG frames retain
    # their original transparency. This avoids undefined RGB in transparent
    # pixels being shown by image viewers that discard the alpha channel.
    preview_frames = []
    for frame in frames:
        background = Image.new('RGBA', frame.size, (32, 37, 48, 255))
        background.alpha_composite(frame)
        preview_frames.append(background.convert('RGB'))
    preview_frames[0].save(preview, save_all=True, append_images=preview_frames[1:], duration=durations,
                   loop=0, lossless=True, method=3, exact=True)
    still = preview.with_suffix('.png')
    frames[0].save(still)
    if frames_png:
        frame_dir = destination(folder / 'frames', action_name)
        frame_dir.mkdir(parents=True, exist_ok=True)
        for i, frame in enumerate(frames):
            frame.save(frame_dir / f'{i:04}.png', compress_level=3)
        write(frame_dir / 'timing.json', json.dumps({'fps': action['fps'], 'duration_ms': durations,
                                                  'bounds': bounds, 'origin': [-bounds[0], -bounds[1]]}, indent=2).encode())
    return {'hero': hero_name, 'action': action_name, 'frames': len(frames), 'fps': action['fps'],
            'bounds': bounds, 'preview_scale': zoom,
            'output': str(preview.relative_to(OUT)), 'status': 'rendered'}

def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest='mode', required=True)
    recover = sub.add_parser('recover')
    recover.add_argument('--hero', action='append')
    recover.add_argument('--workers', type=int, default=3)
    render = sub.add_parser('render')
    render.add_argument('hero')
    render.add_argument('action', nargs='?', default='Idle')
    render.add_argument('--frames', action='store_true')
    render.add_argument('--max-size', type=int, default=640)
    args = parser.parse_args()
    if args.mode == 'recover':
        with zipfile.ZipFile(PACK) as archive:
            names = [n for n in archive.namelist() if n.startswith('patch/pfca/')
                     and n.endswith('.fca') and n.count('/') == 2]
        if args.hero:
            names = [n for n in names if Path(n).stem in args.hero]
        records = []
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
            for record in pool.map(recover_container, names):
                records.append(record)
                if record['status'] == 'error' or len(records) % 10 == 0:
                    print(f'Hero recovery {len(records)}/{len(names)}: {record["source"]} {record["status"]} {record.get("error", "")}', flush=True)
        report = 'hero_recovery_samples.json' if args.hero else 'hero_recovery.json'
        write(OUT / 'reports' / report, json.dumps(records, ensure_ascii=False, indent=2).encode())
        print('Results:', dict(collections.Counter(r['status'] for r in records)), flush=True)
    else:
        print(json.dumps(render_action(args.hero, args.action, args.frames, args.max_size)), flush=True)

if __name__ == '__main__':
    main()
