"""Rebuild the complete D34 staging catalog from tracked source and baseline Data.

Outputs are drafts until combat, farm and Unity acceptance passes. Does not edit
active Data, save files or source reference. Derived art goes to --unity-project.
"""
import argparse,importlib.util,hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def module(name):
    spec=importlib.util.spec_from_file_location(name,ROOT/'scripts'/(name+'.py'))
    result=importlib.util.module_from_spec(spec);spec.loader.exec_module(result);return result
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--baseline',type=Path,default=ROOT/'Tests/Fixtures/D34Baseline')
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--unity-project',type=Path,default=ROOT/'Unity')
    a=p.parse_args();data=a.output.resolve();base=module('Import-ZatodD34Heroes')
    source=base.Source()
    manifest=base.build(a.baseline.resolve(),data,include_encounters=True,source=source)
    module('Import-ZatodD34Skills').apply(data,source)
    module('Import-ZatodD34EncounterSkills').apply(data,source)
    module('Import-ZatodD34Chapters').apply(data,manifest,a.unity_project.resolve(),source)
    module('Import-ZatodD34Media').apply(data,manifest)
    manifest['Forms']=[dict(Id='form_'+f['Resource'].lower(),SourceResource=f['Resource'],AnimationSetResource=f['AnimationSetResource'],SourceUnitId=0,Form=True)
        for f in {f['Resource']:f for f in base.battle_forms(base.read(data/'Skills.txt')['Skills'])}.values()]
    heroes=base.read(data/'Heroes.txt');approved=set(base.NEW_HEROES)|{h['SourceUnitId'] for h in base.read(a.baseline.resolve()/'Heroes.txt')['Heroes']}
    if len(approved)!=40:raise ValueError('Expected an explicit 25+15 baseline roster.')
    for hero in heroes['Heroes']:hero['AvailableInFreePvp']=hero['SourceUnitId'] in approved
    heroes['UseExpandedCombatRules']=True
    base.write(data/'Heroes.txt',heroes)
    final_skills={s['Crystal']['SourceId']:s for s in base.read(data/'Skills.txt')['Skills']}
    for row in manifest['Coverage']:
        mapped=len(final_skills[row['SourceSkillId']]['Evolutions'])==3
        row.update(RuntimeEvoImported=mapped,Status='Native mapping present; acceptance recorded separately' if mapped else 'Mapping incomplete')
    pending=[row for row in manifest['Coverage'] if not row['RuntimeEvoImported']]
    manifest.update(PendingNativeSkills=len(pending),PendingSourceEvolutions=sum(len(row['SourceEvolutions']) for row in pending))
    manifest['DeferredAttributeMechanics']+=base.read(data.parent/(data.name+'-encounter-native.json'))['PrimaryAttributeDeferrals']
    documents={p.relative_to(data).as_posix():base.read(p) for p in sorted(data.rglob('*.txt'))}
    for doc in documents.values():doc.pop('ConfigVersion',None)
    digest=hashlib.sha256(json.dumps(documents,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest()
    version='zatod-d34-v7-'+digest[:16]
    for path in data.rglob('*.txt'):
        doc=base.read(path)
        if 'ConfigVersion' in doc:doc['ConfigVersion']=version;base.write(path,doc)
    manifest.update(ConfigVersion=version,ContentSha256=digest,Counts={name:len(base.read(data/(name+'.txt'))[name]) for name in ('Heroes','Monsters','Items','Skills','Buffs','Stats','CraftRecipes')})
    manifest.update(Draft=True,RuntimeActivationReady=False,FreePvpSourceIds=sorted(approved),
        NativePoolSkillsMapped=85,NativePoolEvolutionsMapped=255,
        NativeEncounterSkillsMapped=104,NativeEncounterEvolutionsMapped=312,
        Remaining=['Core/Unity/network/farm and source-parity acceptance before runtime activation'])
    base.write(data.parent/(data.name+'-manifest.json'),manifest)
