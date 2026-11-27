"""Copy Crystal UI art and localized presentation metadata; never change gameplay or Owned."""
from pathlib import Path
import json, re, sys, shutil
ROOT=Path(__file__).resolve().parent.parent
REF=ROOT/'Crystal Legend'
sys.path.insert(0,str(REF/'recovery_tools'))
from lua_data import read_table,named_row,Reader
art=REF/'recovered/assets/install_time_pack/remake'
out=ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/Hero/Skills'
out.mkdir(parents=True,exist_ok=True)
for p in (art/'UI/alpha/1080P/skill').glob('*.png'): shutil.copyfile(p,out/p.name)
for p in (art/'UI/alpha/1080P/skill/new').glob('*.png'): shutil.copyfile(p,out/p.name)
text=(REF/'recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/texttable/texttable.lua').read_text(encoding='utf-8-sig')
text=re.sub(r'\[(=*)\[(.*?)\]\1\]',lambda m:json.dumps(m.group(2),ensure_ascii=False),text,flags=re.S)
translations=Reader(text.replace('ed.textConfig =','return ',1)).parse()
def en(key):return translations.get(key,{}).get('nil',{}).get('en') or ''
groups=read_table('SkillGroup');skills=read_table('Skill')
heroes=json.loads((ROOT/'Unity/Assets/Zatod/Resources/Data/Heroes.txt').read_text())['Heroes']
entries=[]
for h in heroes:
 for v in groups[1][h['SourceUnitId']].values():
  g=named_row(groups,v)
  if g['Slot'] not in (1,2,3,4):continue
  info=named_row(skills,skills[1][g['Skill Group ID']][0])
  entry=dict(HeroId=h['Id'],Slot=g['Slot'],Intro=en(info.get('Description')),Name=en(g['Display Name']))
  if g['Slot']==4:
   p=art/g['Icon']
   if not p.exists():p=p.with_suffix('.jpg')
   target=out/'Icons'/('locked_'+h['Id']+p.suffix);shutil.copyfile(p,target)
  entries.append(entry)
(out/'Presentation.txt').write_text(json.dumps({'Entries':entries},ensure_ascii=False,indent=2)+'\n')
print('Presentation rows:',len(entries),'Locked fourth slots:',sum(x['Slot']==4 for x in entries))
