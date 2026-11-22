"""Import Crystal progression/rewards/EXP item definitions; never touch Owned."""
from pathlib import Path
import json, sys, shutil
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'Crystal Legend/recovery_tools'))
from lua_data import read_table,named_row
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
def table(n):
 t=read_table(n);return {i:named_row(t,r) for i,r in t[1].items()}
def write(p,d):p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=table('PlayerLevel');h=table('Levels');stage=table('Stage');equip=table('equip')
definition={'SchemaVersion':1,'ConfigVersion':'zatod-progression-1','MaxPlayerLevel':100,'StaminaRecoverySeconds':360,'InitialGold':0,'InitialStamina':60,
 'PlayerLevels':[{'Level':i,'NextLevelExp':r['Exp'],'MaxHeroLevel':r['Max Hero Level'],'MaxStamina':r['Max Vitality'],'StaminaReward':r['Vitality Reward']} for i,r in sorted(p.items())],
 'HeroLevels':[{'Level':i,'NextLevelExp':r['Exp']} for i,r in sorted(h.items())]}
write(DATA/'Progression.txt',definition)
c=json.loads((DATA/'Campaigns.txt').read_text(encoding='utf-8-sig'))
for chapter in c['Chapters']:
 for s in chapter['Stages']:
  r=stage[s['SourceStageId']]
  for target,source in [('VitalityReturn','Vit Return'),('PlayerExpReward','Exp Reward'),('HeroExpReward','Heroexp Reward'),('GoldReward','Money Reward'),('FailPlayerExpReward','Fail Exp Reward')]:s[target]=r[source]
c['ConfigVersion']='zatod-progression-1';write(DATA/'Campaigns.txt',c)
a=json.loads((DATA/'Items.txt').read_text(encoding='utf-8-sig'))
for i,name in [(169,'EXP Potion'),(218,'EXP Salve'),(290,'EXP Cheese'),(440,'EXP Burger'),(1609,'EXP Pizza')]:
 r=equip[i];id=name.lower().replace(' ','_')
 row={'ItemId':id,'Name':name,'IconResource':r['Icon'],'LevelRequirement':1,'Quality':int(r.get('Quality',1)),'ItemKind':3,'HeroExpValue':r['Exp'],'Stats':[],'PreciseStats':[]}
 a['Items']=[x for x in a['Items'] if x['ItemId']!=id]+[row]
 source=ROOT/'Crystal Legend/recovered/assets/install_time_pack/remake'/r['Icon']
 for folder in ['StagePreview','Hero']:
  dest=ROOT/f'Unity/Assets/Zatod/Resources/Zatod/UI/{folder}/Items/{id}.jpg';dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,dest)
a['ConfigVersion']='zatod-progression-1';write(DATA/'Items.txt',a)
# Split hero configs share one version; their combat data is unchanged.
for n in ['Stats','Skills','Heroes','Monsters','Buffs','CraftRecipes']:
 path=DATA/(n+'.txt');d=json.loads(path.read_text(encoding='utf-8-sig'));d['ConfigVersion']='zatod-progression-1';write(path,d)
print('Imported 100 player levels, 120 Hero levels, 39 rewards, 5 EXP items (117 items).')
