"""Collect exact timeline sounds from repeatable actor/effect bake manifests.

No basename correction or replacement. Native source files are hash-checked by
the Unity importer. Missing original clips are recorded for the resource audit.
"""
from pathlib import Path
import argparse,hashlib,importlib.util
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('heroes',ROOT/'scripts/Import-ZatodD34Heroes.py');base=importlib.util.module_from_spec(spec);spec.loader.exec_module(base)
def apply(data,manifest):
    resources=set()
    for section in ('Heroes','Monsters'):
        resources.update(r['SourceResource'] for r in base.read(data/(section+'.txt'))[section])
    for skill in base.read(data/'Skills.txt')['Skills']:
        info=skill['Crystal']
        resources.update(Path(name).stem for name in info.get('AdditionalEffectResources',[]))
        resources.update(f['Resource'] for f in base.battle_forms([skill]))
        for key in ('ProjectileArt','ImpactEffect','ChainEffect','LaunchEffect','PointEffect'):
            if info.get(key):resources.add(Path(info[key]).stem)
    for buff in base.read(data/'Buffs.txt')['Buffs']:
        for key in ('Effect','ImpactEffect'):
            if buff.get(key):resources.add(Path(buff[key]).stem)
    resources.update(('eff_UI_battle_skill_will_ready','eff_UI_battle_skill_cast','eff_UI_battle_skill_activate','eff_UI_full_power','eff_UI_battle_skill_cost'))
    sounds={}
    for path in (base.ART/'sound').rglob('*'):
        if path.is_file():sounds.setdefault(path.stem,[]).append(path)
    assets={r['Target']:r for r in manifest['AudioAssets']};missing={Path(name).stem for name in manifest['MissingNativeAudio']};pending=[]
    for resource in sorted(resources):
        path=ROOT/'Unity/Assets/Zatod/Art/Imported'/resource/'bake-manifest.txt'
        if not path.is_file():pending.append(resource);continue
        for action in base.read(path)['Actions']:
            for cue in action.get('AudioCues',[]):
                name=Path(cue['Resource']).name;choices=sounds.get(name,[])
                if not choices:missing.add(name);continue
                if len(choices)!=1:raise ValueError('Ambiguous native audio resource: '+name)
                source=choices[0];target='Zatod/Audio/'+source.name
                row=dict(Source=source.relative_to(ROOT).as_posix(),Target=target,Sha256=hashlib.sha256(source.read_bytes()).hexdigest())
                if target in assets and assets[target]!=row:raise ValueError('Native audio resource collision: '+target)
                assets[target]=row
    manifest['AudioAssets']=sorted(assets.values(),key=lambda row:row['Target'])
    manifest['MissingNativeAudio']=sorted(missing);manifest['PendingMediaBakes']=pending
    return manifest
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--data',type=Path,required=True);p.add_argument('--manifest',type=Path,required=True);a=p.parse_args()
    base.write(a.manifest,apply(a.data.resolve(),base.read(a.manifest)))
