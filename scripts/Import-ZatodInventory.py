"""D31: import native Inventory metadata/art without touching owned data or drop pools."""
from pathlib import Path
import json,re,sys,shutil
R=Path(__file__).resolve().parents[1];sys.path.insert(0,str(R/'Crystal Legend/recovery_tools'))
from lua_data import read_table,named_row,Reader,BASE
D=R/'Unity/Assets/Zatod/Resources/Data';A=R/'Crystal Legend/recovered/assets/install_time_pack/remake'
T=R/'Unity/Assets/Zatod/Resources/Zatod/UI/Inventory/Native';T.mkdir(parents=True,exist_ok=True)
items=json.loads((D/'Items.txt').read_text(encoding='utf-8-sig'));heroes=json.loads((D/'Heroes.txt').read_text(encoding='utf-8-sig'))
audit=json.loads((R/'Artifacts/CrystalInventoryReview_20261122/audit.json').read_text(encoding='utf-8-sig'))
mapping={x['ItemId']:x['SourceId'] for x in audit['Items']}
et=read_table('equip');equip={i:named_row(et,v) for i,v in et[1].items()}
ft=read_table('fragment');ut=read_table('Unit');st=read_table('HeroStars')
translations=(BASE/'texttable/texttable.lua').read_text(encoding='utf-8-sig')
def english(value):
    if not value:return ''
    lit='"'+''.join(chr(b) if b<128 else '\\'+str(b) for b in value.encode('utf-8'))+'"'
    pos=translations.find('['+lit+']')
    if pos<0:return value
    chunk=translations[pos:pos+2500]
    match=re.search(r'\ben\s*=\s*("(?:\\.|[^"\\])*"|\[(=*)\[[\s\S]*?\]\2\])',chunk)
    if not match:return value
    token=match.group(1)
    if token.startswith('['):return re.sub(r'^\[=*\[|\]=*\]$','',token)
    return Reader('return '+token).parse()
byid={x['ItemId']:x for x in items['Items']}
for h in heroes['Heroes']:
    unit=named_row(ut,ut[1][h['SourceUnitId']]);fr=named_row(ft,ft[1][h['SourceUnitId']]);i=fr['Fragment ID'];source=equip[i]
    ident='soulstone_'+h['Id'];h['SoulstoneItemId']=ident;h['InitialStars']=unit['Initial Stars'];mapping[ident]=i
    if ident not in byid:
        item={'ItemId':ident,'Name':'Soulstone ('+h['Name']+')','IconResource':source['Icon'],'LevelRequirement':1,'Quality':source['Quality'],'ItemKind':4,'HeroExpValue':0,'Stats':[],'PreciseStats':[]}
        items['Items'].append(item);byid[ident]=item
    for dest in [R/'Unity/Assets/Zatod/Resources/Zatod/UI/StagePreview/Items',R/'Unity/Assets/Zatod/Resources/Zatod/UI/Hero/Items']:
        dest.mkdir(parents=True,exist_ok=True);shutil.copyfile(A/source['Icon'],dest/(ident+Path(source['Icon']).suffix))
groups={'消耗品':(0,5),'碎片':(1,0),'合成品':(2,6),'零件':(2,7),'卷轴':(2,8),'灵魂石':(3,0)}
for item in items['Items']:
    source=equip[mapping[item['ItemId']]];item.pop('HeroStats',None)
    tab,fil=(3,0) if item['ItemKind']==4 else groups[source['Category']]
    item.update(InventoryTab=tab,InventoryFilter=fil,Description=english(source.get('Description')),Comment=english(source.get('Comment')),SellPrice=int(source.get('Sell Price') or 0))
rules=[]
for raw in st[1].values():
    row=named_row(st,raw);rules.append({'Stars':row['Stars'],'SummonStones':row['Summon Fragments'],'SummonGold':row['Summon Price'],'UpgradeStones':row['Upgrade Fragments'],'UpgradeGold':row['Upgrade Price']})
# The active roster may use a different approved display name than source locale.
for hero in heroes['Heroes']:
    stone=byid[hero['SoulstoneItemId']];need=next(r['SummonStones'] for r in rules if r['Stars']==hero['InitialStars'])
    stone['Description']=f"Collect {need} Soulstones to recruit {hero['Name']}, or use them to star up {hero['Name']}."
version='zatod-inventory-1'
for path in D.glob('*.txt'):
    if path.stem not in ['Stats','Items','Skills','Heroes','Monsters','Buffs','CraftRecipes']:continue
    data=items if path.stem=='Items' else heroes if path.stem=='Heroes' else json.loads(path.read_text(encoding='utf-8-sig'))
    data['ConfigVersion']=version;path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(D/'StarRules.txt').write_text(json.dumps({'SchemaVersion':1,'ConfigVersion':version,'MaxHeroStars':5,'StarRules':rules},indent=2)+'\n',encoding='utf-8')
paths=set()
for name in ['package','package_item','package_fragment','package_stone','package_detail','packageSoldWin','package_quick_compose','heroUpLevelWin']:
    paths.update(re.findall(r'"(UI/[^"\n]+\.(?:png|jpg))"',(BASE/('ui_new/uieditor/'+name+'.lua')).read_text(encoding='utf-8-sig')))
paths.add("UI/alpha/1080P/icon/herodetail_soulstone_icon.png")
paths.update(['UI/alpha/1080P/bg/herolist_bg.jpg','UI/alpha/1080P/common/buttion_big.png','UI/alpha/1080P/common/button_com_mini.png','UI/alpha/1080P/package/selected.png','UI/alpha/1080P/package/bg_deso.png'])
for color in ["white","green","blue","purple","orange","red","pink","prismatic"]:
    for kind in ["equip","fragment"]:
        path="UI/alpha/1080P/common/frame/"+kind+"_frame_"+color+".png"
        if (A/path).is_file():paths.add(path)
paths.update(str(p.relative_to(A)).replace("\\","/") for p in (A/"UI/alpha/1080P/package").rglob("*") if p.is_file() and p.suffix.lower() in [".png",".jpg"])
copied=[];missing=[]
for p in paths:
    if not (A/p).is_file():missing.append(p);continue
    dest=T/p;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(A/p,dest);copied.append(p)
# Keep all dependency importers from recreating the removed Hero-specific bonus.
for name in ['Import-CrystalConfig.py','Import-ZatodCrafting.py','Import-ZatodChapterTwo.py']:
    p=R/'Scripts'/name;s=p.read_text(encoding='utf-8-sig')
    if '# D31: no Hero-specific item stats' not in s:
        # In the original converters these loops only populated item.HeroStats.
        s=re.sub(r"if extra:item\['HeroStats'\]\.append\([^\n]*\)","if extra:pass # D31: no Hero-specific item stats",s)
        s=s.replace(",'HeroStats':[]",'')
        s=s.replace("existing[key].setdefault('HeroStats',[]).append(bonus)","None # D31: no Hero-specific item stats")
        p.write_text(s,encoding='utf-8')
report={'Items':len(items['Items']),'Soulstones':len(heroes['Heroes']),'StarRules':rules,'CopiedAssets':sorted(copied),'MissingOptionalLiteralAssets':missing}
(R/'Artifacts/ZatodInventoryChecks/import.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'Items':len(items['Items']),'Soulstones':len(heroes['Heroes']),'Assets':len(copied),'MissingOptional':missing},ensure_ascii=False))
