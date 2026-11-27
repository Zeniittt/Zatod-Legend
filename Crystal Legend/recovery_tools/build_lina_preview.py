"""Prepare original sprites, effects, sounds and config for a Lina sketch."""
import base64
import io
import json
from pathlib import Path
import plistlib
import zipfile
import zlib

from hero_animation import ROOT, OUT, ChaReader, encode_cha, decode_atlas, write
from assets import pvr_image
from lua_data import read_table, named_row

DEST = OUT / 'lina_preview'
VIZ = Path('C:/Users/tinnq/.codex/visualizations/2026/11/18/01a1ef46-7db9-7831-bdd8-311c39164a14/lina-full-animation.html')
EFFECTS = ['eff_launch_ult', 'eff_launch_skill_1', 'eff_impact_lightning', 'eff_chain_lightning',
           'eff_impact_burn', 'eff_point_Lina_atk2', 'eff_point_Lina_atk3', 'eff_tile_Lina_atk', 'eff_buff_stun']

def webp_data(image, max_side=None):
    buffer = io.BytesIO()
    if max_side and max(image.size) > max_side:
        image = image.copy()
        image.thumbnail((max_side, max_side))
    # Only large effect textures use viewing proxies; exports stay lossless.
    image.save(buffer, format='WEBP', lossless=not bool(max_side), quality=78,
               alpha_quality=90, method=4 if max_side else 5, exact=False)
    return base64.b64encode(buffer.getvalue()).decode()

def asset(animation, sprites, actions=None, max_side=None):
    selected = [a for a in animation['actions'] if actions is None or a['name'] in actions]
    ids = {part[0] for a in selected for f in a['frames'] for part in f['elements']}
    elements = {e['id']: e['sprite'] + '.png' for e in animation['elements'] if e['id'] in ids}
    images = {name: webp_data(sprites[name], max_side) for name in sorted(set(elements.values()))}
    image_sizes = {name: list(sprites[name].size) for name in images}
    return {'elements': elements, 'images': images,
            'image_sizes': image_sizes,
            'actions': {a['name']: {'fps': a['fps'], 'frames': a['frames']} for a in selected},
            'translation_scale': animation['translation_scale_for_atlas_pixels']}

def existing_hero(name, actions=None):
    from PIL import Image
    folder = OUT / 'heroes' / name
    animation = json.loads((folder / 'animation.json').read_text(encoding='utf-8'))
    sprites = {}
    for p in (folder / 'sprites').glob('*.png'):
        with Image.open(p) as image:
            sprites[p.name] = image.convert('RGBA')
    return asset(animation, sprites, actions)

def main():
    assets = {'Lina': existing_hero('Lina'), 'DR': existing_hero('DR', ['Idle', 'Damaged'])}
    effect_metadata = []
    with zipfile.ZipFile(OUT / 'downloads/aab_1.1.100312.zip') as outer:
        for name in EFFECTS:
            path = 'patch/pfca/effect/' + name + '.fca'
            data = outer.read(path)
            with zipfile.ZipFile(io.BytesIO(data)) as archive:
                animation = ChaReader(archive.read('cha')).parse()
                assert encode_cha(animation) == archive.read('cha')
                sprites = {}
                for plist_name in [n for n in archive.namelist() if n == 'plist' or n.endswith('.plist')]:
                    suffix = '' if plist_name == 'plist' else plist_name.split('.')[0]
                    image, header = pvr_image(archive.read('sheet' + suffix + '.pvr'))
                    decoded, records = decode_atlas(plistlib.loads(archive.read(plist_name)), image)
                    sprites.update(decoded)
                    output = DEST / 'effects' / name
                    sheet = output / ('sheet' + suffix + '.png')
                    sheet.parent.mkdir(parents=True, exist_ok=True)
                    image.save(sheet)
                    for sprite_name, sprite in decoded.items():
                        target = output / 'sprites' / sprite_name
                        target.parent.mkdir(parents=True, exist_ok=True)
                        sprite.save(target)
                write(output / 'animation.json', json.dumps(animation, ensure_ascii=False, separators=(',', ':')).encode())
                assets[name] = asset(animation, sprites, max_side=512 if name == 'eff_chain_lightning' else 160)
                effect_metadata.append({'name': name, 'source': path, 'sprites': len(sprites), 'actions': list(assets[name]['actions'])})
    sounds = {}
    filenames = ['LINA_ATK.mp3', 'LINA_ATK2.mp3', 'LINA_ATK3.mp3', 'LINA_ULT.mp3', 'LINA_DEATH.mp3',
                 'sound_eff_impact_burn.mp3', 'sound_eff_impact_lightening.mp3']
    with zipfile.ZipFile(ROOT / 'install_time_pack.apk') as archive:
        for filename in filenames:
            data = archive.read('assets/remake/sound/' + filename)
            write(DEST / 'sounds' / filename, data)
            sounds[filename] = base64.b64encode(data).decode()
    table = read_table('Skill')
    skills = {named_row(table, table[1][key][0])['Skill Name']: named_row(table, table[1][key][0])
              for key in [30, 31, 32, 33, 34]}
    attack_table = read_table('AnimAtkFrame')
    attack_events = {name: [named_row(attack_table, row) for row in frames.values()]
                     for name, frames in attack_table[1]['Lina.cha'].items()}
    buff_table = read_table('Buff')
    stun = named_row(buff_table, buff_table[1][10000302])
    bundle = {'assets': assets, 'sounds': sounds, 'skills': skills, 'attack_events': attack_events,
              'stun_seconds': stun['Time'], 'lina_scale': 0.9,
              'notes': 'Original client sprites and timings; fixed training target and simplified scene.'}
    def viewing_precision(value):
        if isinstance(value, float): return round(value, 5)
        if isinstance(value, list): return [viewing_precision(x) for x in value]
        if isinstance(value, dict): return {k:viewing_precision(v) for k,v in value.items()}
        return value
    compact = json.dumps(viewing_precision(bundle), ensure_ascii=False, separators=(',', ':')).encode()
    stats = {name: {'images_base64': sum(len(x) for x in value['images'].values()),
                    'timeline_json': len(json.dumps(value['actions']))} for name, value in assets.items()}
    write(DEST / 'bundle_stats.json', json.dumps(stats, indent=2).encode())
    encoded = base64.b64encode(zlib.compress(compact, 9)).decode()
    write(DEST / 'preview_payload.txt', encoded.encode())
    source = VIZ.read_text(encoding='utf-8')
    start = source.index('<!--LINA_DATA_START-->') + len('<!--LINA_DATA_START-->')
    end = source.index('<!--LINA_DATA_END-->')
    source = source[:start] + '\n<script type="application/octet-stream" id="lina-packed">' + encoded + '</script>\n' + source[end:]
    if len(source.encode()) >= 1000000:
        raise ValueError(f'Inline sketch exceeds 1 MB: {len(source.encode())}')
    VIZ.write_text(source, encoding='utf-8')
    manifest = {'effects': effect_metadata, 'skills': skills, 'attack_events': attack_events,
                'stun_seconds': stun['Time'], 'inline_bytes': len(source.encode()),
                'original_game_code_executed': False,
                'sketch_assumptions': ['Fixed enemy and spacing', 'No damage numbers or HP simulation',
                                       'Base Lina without skin/evolution/shard upgrades', 'Idealized collision time for the projectile']}
    write(DEST / 'manifest.json', json.dumps(manifest, ensure_ascii=False, indent=2).encode())
    print('Prepared', len(assets), 'animated assets;', len(sounds), 'sounds; inline bytes', len(source.encode()), flush=True)

if __name__ == '__main__':
    main()
