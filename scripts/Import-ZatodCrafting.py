"""Import Crystal recipes/dependencies and original UI art without rewriting owned progress."""
from pathlib import Path
import json,re,sys,hashlib,shutil
ROOT=Path(__file__).resolve().parent.parent;DATA=ROOT/'Unity/Assets/Zatod/Resources/Data';REF=ROOT/'Crystal Legend';ART=REF/'recovered/assets/install_time_pack/remake'
sys.path.insert(0,str(REF/'recovery_tools'))
from lua_data import read_table,named_row,Reader
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p,x):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def slug(x):return re.sub('[^a-z0-9]+','_',re.sub(r'([a-z0-9])([A-Z])',r'\1_\2',x).lower()).strip('_')
def main():
    table=read_table('equip');equip={i:named_row(table,v) for i,v in table[1].items()};table=read_table('equipcraft');recipes={i:named_row(table,v) for i,v in table[1].items()}
    docs={n:read(DATA/(n+'.txt')) for n in ['Stats','Items','Skills','Heroes','Monsters','Buffs']};mapping=read(ROOT/'Artifacts/CrystalPhaseChecks/zatod-id-mapping.json');aliases=mapping['Aliases'];current={int(k.rsplit('_',1)[1]) for k,v in aliases.items() if k.startswith('crystal_item_') and v in {x['ItemId'] for x in docs['Items']['Items']}}
    seen=set()
    def visit(i):
        if i in seen:return
        seen.add(i)
        for k in range(1,5):
            j=recipes.get(i,{}).get('Component'+str(k),0)
            if j:visit(j)
    for i in current:visit(i)
    text=(REF/'recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/texttable/texttable.lua').read_text(encoding='utf-8-sig');text=re.sub(r'\[(=*)\[(.*?)\]\1\]',lambda m:json.dumps(m.group(2),ensure_ascii=False),text,flags=re.S);translations=Reader(text.replace('ed.textConfig =','return ',1)).parse()
    source=(ROOT/'scripts/Import-CrystalConfig.py').read_text(encoding='utf-8-sig');env={'__file__':str(ROOT/'scripts/Import-CrystalConfig.py')};exec(compile(source[:source.index('units={')],'conversion-only','exec'),env)
    ut=read_table('Unit');units={i:named_row(ut,v) for i,v in ut[1].items()};items=docs['Items']['Items'];existing={x['ItemId']:x for x in items};added=[]
    for i in sorted(seen):
        src=equip[i];key='crystal_item_'+str(i)
        if key not in aliases:
            name=translations[src['Name']]['nil']['en'];ident=slug(name);assert ident not in existing,ident;aliases[key]=ident
        ident=aliases[key]
        if ident not in existing:
            item={'ItemId':ident,'Name':translations[src['Name']]['nil']['en'],'IconResource':src['Icon'],'LevelRequirement':src['Level Requirement'],'Quality':src['Quality'],'Stats':[],'PreciseStats':env['amounts'](env['direct'](src)),'HeroStats':[]}
            for h in docs['Heroes']['Heroes']:
                extra=float(src.get(units[h['SourceUnitId']]['Main Attrib']) or 0)
                if extra:item['HeroStats'].append({'HeroId':h['Id'],'Stats':[{'StatId':'damage','Value':extra}]})
            existing[ident]=item;items.append(item);added.append(ident)
        existing[ident]['ItemKind']=1 if src['Category']=='碎片' else (2 if '卷轴' in src['Name'] else 0)
    rows=[]
    for i in sorted(seen):
        if i not in recipes:continue
        row=recipes[i];needs={}
        for n in range(1,5):
            child=row.get('Component'+str(n),0)
            if child:
                ident=aliases['crystal_item_'+str(child)];needs[ident]=needs.get(ident,0)+max(row.get('Component'+str(n)+' Count') or 1,1)
        if needs:rows.append({'Id':aliases['crystal_item_'+str(i)]+'_recipe','SourceItemId':i,'OutputItemId':aliases['crystal_item_'+str(i)],'OutputAmount':1,'Ingredients':[{'ItemId':k,'Amount':v} for k,v in needs.items()],'GoldCost':row['Expense']})
    for n,doc in docs.items():doc['ConfigVersion']='zatod-prototype-crafting-1';write(DATA/(n+'.txt'),doc)
    write(DATA/'CraftRecipes.txt',{'SchemaVersion':1,'ConfigVersion':'zatod-prototype-crafting-1','CraftRecipes':rows})
    mapping['Aliases']=aliases;mapping['Counts']={n:len(d[n]) for n,d in docs.items()};mapping['Counts']['CraftRecipes']=len(rows);write(ROOT/'Artifacts/CrystalPhaseChecks/zatod-id-mapping.json',mapping)
    lines=['using System;','using System.Collections.Generic;','namespace Zatod.Heroes { public static class ZatodContentIds {','static readonly Dictionary<string,string> aliases=new Dictionary<string,string>(StringComparer.Ordinal) {']+[ '{'+json.dumps(k)+','+json.dumps(v)+'},' for k,v in sorted(aliases.items())]+['};','public static string Canonical(string id)=>id!=null && aliases.TryGetValue(id,out var v)?v:id;','public static string Unit(int id)=>Canonical("crystal_"+id);','public static string Stage(int id)=>Canonical("crystal_stage_"+id);','}}'];(ROOT/'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs').write_text('\n'.join(lines)+'\n')
    assets=[]
    def copy(a,b):
        b.parent.mkdir(parents=True,exist_ok=True)
        if not b.exists() or a.read_bytes()!=b.read_bytes():shutil.copyfile(a,b)
        assets.append({'Source':str(a.relative_to(ROOT)),'Target':str(b.relative_to(ROOT)),'Sha256':hashlib.sha256(b.read_bytes()).hexdigest()})
    for x in items:copy(ART/x['IconResource'],ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/StagePreview/Items'/(x['ItemId']+Path(x['IconResource']).suffix))
    audit=read(ROOT/'Artifacts/ZatodEquipmentReview/audit.json')
    for x in audit['Assets']:
        path=x['File']
        if path.startswith('UI/alpha/1080P/'):copy(ART/path,ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/Crafting'/path.removeprefix('UI/alpha/1080P/'))
    report={'AddedItems':added,'Items':len(items),'Recipes':len(rows),'GoldBypassed':True,'Assets':assets};write(ROOT/'Artifacts/ZatodCraftChecks/import.json',report);print(json.dumps({'Added':len(added),'Items':len(items),'Recipes':len(rows),'Images':len(assets)}))
if __name__=='__main__':main()
