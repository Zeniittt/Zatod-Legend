"""Repair derived manifests left pointing at the pre-migration Art/Crystal folder.

Verifies existing sheets, rectangles and frame names before changing paths only.
No texture, clip, metadata, source reference or saved progression is changed.
"""
import argparse,hashlib,json
from pathlib import Path
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
def repair(unity,report):
    pending=[]
    for path in sorted((unity/'Assets/Zatod/Art/Imported').glob('*/bake-manifest.txt')):
        original=path.read_bytes();doc=json.loads(original);resource=path.parent.name
        prefix='Assets/Zatod/Art/Imported/'+resource+'/';old_prefix='Assets/Zatod/Art/Crystal/'+resource+'/'
        mapping={};names={};hashes={}
        for sheet in doc['Sheets']:
            old=sheet['Path'];new=prefix+Path(old).name
            if old!=new and not old.startswith(old_prefix):raise ValueError('Unrecognized bake root: '+old)
            target=unity/new
            with Image.open(target) as image:
                for frame in sheet['Frames']:
                    assert frame['X']>=0 and frame['Y']>=0 and frame['X']+frame['Width']<=image.width and frame['Y']+frame['Height']<=image.height,(resource,frame['Name'])
                names[old]={f['Name'] for f in sheet['Frames']}
            mapping[old]=new
            if old!=new:hashes[new]=hashlib.sha256(target.read_bytes()).hexdigest()
        for action in doc['Actions']:
            for frame in action['Frames']:
                if frame['Name'] not in names[frame['Sheet']]:raise ValueError('Unknown frame: '+str(frame))
        if all(k==v for k,v in mapping.items()):continue
        for sheet in doc['Sheets']:sheet['Path']=mapping[sheet['Path']]
        for action in doc['Actions']:
            for frame in action['Frames']:frame['Sheet']=mapping[frame['Sheet']]
        pending.append((path,original,doc,hashes))
    # Validate the whole set before writing any manifest.
    records=[]
    for path,original,doc,hashes in pending:
        path.write_text(json.dumps(doc,ensure_ascii=False,indent=2)+'\n')
        records.append(dict(Resource=path.parent.name,Before=hashlib.sha256(original).hexdigest(),After=hashlib.sha256(path.read_bytes()).hexdigest(),UnchangedSheets=hashes))
    report.parent.mkdir(parents=True,exist_ok=True);report.write_text(json.dumps(dict(Repaired=len(records),Records=records),indent=2)+'\n')
    print('Repaired',len(records),'derived manifests; textures and Unity GUIDs unchanged.')
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--unity-project',type=Path,default=ROOT/'Unity');p.add_argument('--report',type=Path,required=True);a=p.parse_args();repair(a.unity_project.resolve(),a.report.resolve())
