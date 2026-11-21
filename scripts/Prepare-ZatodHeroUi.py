"""Import selected, byte-identical Crystal UI art; never modify source/config IDs."""
from pathlib import Path
import json, hashlib, shutil, sys

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / 'Crystal Legend/recovered/assets/install_time_pack/remake'
DEST = ROOT / 'Unity/Assets/Zatod/Resources/Zatod/UI/Hero'
sys.path.insert(0, str(ROOT / 'Crystal Legend/recovery_tools'))
from lua_data import read_table, named_row

def main():
    pairs = []
    def add(source, target=None):
        pairs.append((SOURCE / source, DEST / (target or Path(source).name)))
    base = 'UI/alpha/1080P/'
    for name in ['main_task_button','main_hero_button','main_package_button','main_shortcut_board','main_bj_button','main_img_button']:
        add(base+'main/'+name+'.png')
    for name in ['bg_hero_normal','bg_name','icon_unequip','icon_equip','tab_selected','tab_unselected']:
        add(base+'herolist/'+name+'.png')
    for name in ['hero_info_bg_0','hero_info_bg_3','hero_info_bg','hero_info_detail_bg','hero_info_detail','hero_bg_mid_1','hero_bg_mid_2','hero_bg_tattoos_1','hero_bg_tattoos_2','hero_level_bg','hero_exp_icon','hero_exp_progress_bg','hero_exp_progress','hero_soulstone_progress_bg','hero_soulstone_progress','hero_star_1','hero_star_bg','hero_star_bg_0','hero_gs_bg','hero_gs_2','hero_tab_choose','hero_tab_unchoose','icon_hero','icon_skill','icon_accessory','icon_skin']:
        add(base+'hero/'+name+'.png')
    for i in range(1,5): add(base+f'hero/rank/hero_rank_{i}.png')
    for name in ['astrolabe_herolist_bg_1','astrolabe_herolist_lock']:
        add(base+'astrolabe/'+name+'.png')
    add(base+'hero/equip/equip_add_1.png')
    for name in ['diamond','goldicon','vitality','plus','add']:
        hits=list((SOURCE/base/'common').rglob(name+'.png'))
        if hits: pairs.append((hits[0],DEST/(name+'.png')))
    for name in ['diamond','vitality']:add(base+'icon/'+name+'.png')
    add(base+'herolist/icon_stone.png')
    data=ROOT/'Unity/Assets/Zatod/Resources/Data'
    units=read_table('Unit'); rows={named_row(units,r)['ID']:named_row(units,r) for r in units[1].values()}
    for hero in json.loads((data/'Heroes.txt').read_text(encoding='utf8'))['Heroes']:
        art=rows[hero['SourceUnitId']]['Art']
        art=art[1:] if art.startswith('c') else art
        add('UI/art/'+art, 'Illustrations/'+hero['Id']+Path(art).suffix)
    for item in json.loads((data/'Items.txt').read_text(encoding='utf8'))['Items']:
        # Keep StagePreview's existing resource convention; all UI now shares these icons.
        pairs.append((SOURCE/item['IconResource'],DEST.parent/'StagePreview/Items'/(item['ItemId']+Path(item['IconResource']).suffix)))
    audit=[]
    for a,b in pairs:
        if not a.is_file(): raise FileNotFoundError(a)
        b.parent.mkdir(parents=True,exist_ok=True)
        if not b.exists() or a.read_bytes()!=b.read_bytes(): shutil.copyfile(a,b)
        assert a.read_bytes()==b.read_bytes()
        audit.append({'Source':str(a.relative_to(ROOT)),'Target':str(b.relative_to(ROOT)),'Sha256':hashlib.sha256(b.read_bytes()).hexdigest()})
    report=ROOT/'Artifacts/ZatodHeroUiChecks/native-art.json';report.parent.mkdir(parents=True,exist_ok=True)
    report.write_text(json.dumps({'Count':len(audit),'ByteIdentical':True,'Files':audit},indent=2)+'\n',encoding='utf8')
    print('Native Hero UI art:',len(audit))

if __name__=='__main__': main()
