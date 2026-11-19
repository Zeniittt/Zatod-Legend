"""Copy only selected backgrounds/voices/timeline audio; report original missing references."""
from pathlib import Path
import json,shutil,zipfile,sys,hashlib
ROOT=Path(__file__).resolve().parent.parent
REF=ROOT/'Crystal Legend/recovered'
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
DEST=ROOT/'Unity/Assets/Zatod/Resources/Crystal'
apply='--apply' in sys.argv
report={'Applied':apply,'Backgrounds':[],'Audio':[],'MissingOriginalAudio':[]}
campaign=json.loads((DATA/'CrystalCampaigns.txt').read_text(encoding='utf8'))
for background in sorted({w['BackgroundResource'] for s in campaign['Chapters'][0]['Stages'] for w in s['Waves']}):
 source=REF/'assets/install_time_pack/remake/UI/alpha/1080P'/background
 if not source.exists():raise FileNotFoundError(source)
 target=DEST/'Backgrounds'/Path(background).name
 if apply:target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,target)
 report['Backgrounds'].append({'Resource':background,'Sha256':hashlib.sha256(source.read_bytes()).hexdigest()})
resources={u['SourceResource'] for section in ['Heroes','Monsters'] for u in json.loads((DATA/(section+'.txt')).read_text(encoding='utf8'))[section] if u.get('SourceUnitId')}
resources.update(p.parent.name for p in (ROOT/'Unity/Assets/Zatod/Art/Crystal').glob('eff_*/bake-manifest.txt'))
wanted=set()
for resource in resources:
 animation=json.loads((REF/'heroes'/resource/'animation.json').read_text(encoding='utf8'))
 wanted.update(e['argument'] for action in animation['actions'] for frame in action['frames'] for e in frame['events'] if e['type']==1 and e['argument'])
for name in sorted(wanted):
 source=REF/'assets/install_time_pack/remake/sound'/name
 if not source.exists():report['MissingOriginalAudio'].append(name);continue
 target=DEST/'Audio'/name
 if apply:target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,target)
 report['Audio'].append({'Name':name,'Sha256':hashlib.sha256(source.read_bytes()).hexdigest()})
(ROOT/'Artifacts/CrystalPhaseChecks/static-art-audio.json').write_text(json.dumps(report,indent=2),encoding='utf8')
print(json.dumps({'Applied':apply,'Backgrounds':len(report['Backgrounds']),'NativeAudio':len(report['Audio']),'MissingOriginalAudio':report['MissingOriginalAudio']}))
