"""Copy verified native stage-preview art and drop icons; do not alter source images."""
from pathlib import Path
import json,hashlib,shutil
ROOT=Path(__file__).resolve().parent.parent
SOURCE=ROOT/'Crystal Legend/recovered/assets/install_time_pack/remake'
DEST=ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/StagePreview'
def main():
    inv=json.loads((ROOT/'Artifacts/ZatodStagePreviewReview/asset-data-inventory.json').read_text(encoding='utf-8'))
    pairs=[(r['Path'],Path(r['Path']).name) for r in inv['Assets']]
    pairs += [(r['Resource'],'Items/'+item+'.jpg') for item,r in inv['DropIcons'].items()]
    pairs += [('UI/alpha/1080P/common/frame/equip_frame_'+color+'.png','equip_frame_'+color+'.png') for color in ['white','green','blue','purple','orange','red','pink','prismatic','mask']]
    pairs += [('UI/alpha/1080P/campaign/campaign_detail_line_1.png','campaign_detail_line_1.png')]
    audit=[]
    for source,target in pairs:
        a=SOURCE/source;b=DEST/target;b.parent.mkdir(parents=True,exist_ok=True)
        if not b.exists() or a.read_bytes()!=b.read_bytes():shutil.copyfile(a,b)
        assert a.read_bytes()==b.read_bytes()
        audit.append({'Source':source,'Target':str(b.relative_to(ROOT)).replace('\\','/'),'Sha256':hashlib.sha256(b.read_bytes()).hexdigest()})
    path=ROOT/'Artifacts/ZatodStagePreviewChecks/native-art.json';path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text(json.dumps({'Files':audit,'Count':len(audit),'ByteIdentical':True},indent=2)+'\n',encoding='utf-8')
    print('Copied native stage preview assets:',len(audit))
if __name__=='__main__':main()
