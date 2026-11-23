"""Refresh the inline sketch after UI edits, using the prepared local data."""
import base64
import io
import json
import sys
import zlib
from PIL import Image
from build_lina_preview import DEST, VIZ

def main():
    encoded = (DEST / 'preview_payload.txt').read_text()
    if '--compact-effects' in sys.argv:
        data = json.loads(zlib.decompress(base64.b64decode(encoded)))
        for name, asset in data['assets'].items():
            if not name.startswith('eff_'):
                continue
            for sprite_name, image_data in asset['images'].items():
                original = DEST / 'effects' / name / 'sprites' / sprite_name
                source = original if original.exists() else io.BytesIO(base64.b64decode(image_data))
                with Image.open(source) as image:
                    image = image.convert('RGBA')
                    clean = Image.new('RGBA', image.size)
                    clean.alpha_composite(image)
                    image = clean
                    if name.startswith('eff_'):
                        limit = 512 if name == 'eff_chain_lightning' else 160
                        image.thumbnail((limit, limit))
                    result = io.BytesIO()
                    image.save(result, format='WEBP', lossless=False, quality=78,
                               alpha_quality=90, method=4, exact=False)
                    asset['images'][sprite_name] = base64.b64encode(result.getvalue()).decode()
        encoded = base64.b64encode(zlib.compress(json.dumps(data,ensure_ascii=False,separators=(',', ':')).encode(),9)).decode()
        (DEST / 'preview_payload.txt').write_text(encoded)
    source = VIZ.read_text(encoding='utf-8')
    start = source.index('<!--LINA_DATA_START-->') + len('<!--LINA_DATA_START-->')
    end = source.index('<!--LINA_DATA_END-->')
    source = source[:start] + '\n<script type="application/octet-stream" id="lina-packed">' + encoded + '</script>\n' + source[end:]
    if len(source.encode()) >= 1000000:
        raise ValueError(f'Inline sketch exceeds 1 MB: {len(source.encode())}')
    VIZ.write_text(source, encoding='utf-8')
    print('Inline preview bytes:', len(source.encode()))

if __name__ == '__main__':
    main()
