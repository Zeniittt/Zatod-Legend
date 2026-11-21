"""Copy audited native UI art and bake the original result effects for Zatod D27."""
from pathlib import Path
import concurrent.futures,hashlib,json,shutil,sys
ROOT=Path(__file__).resolve().parent.parent
sys.path.insert(0,str(Path(__file__).parent))
from Bake_CrystalSupport import REF,bake,recover_effect

def main():
    audit=json.loads((ROOT/'Artifacts/ZatodLootPresentationReview/asset-audit.json').read_text())
    art=REF/'recovered/assets/install_time_pack/remake'
    target=ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/BattleResult'
    copied=[]
    for row in audit['StaticImages']:
        source=art/row['File'];out=target/row['File'].removeprefix('UI/alpha/1080P/')
        out.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,out)
        copied.append({'Source':str(source.relative_to(ROOT)),'Target':str(out.relative_to(ROOT)),'Sha256':hashlib.sha256(out.read_bytes()).hexdigest()})
    def effect(row):
        name=row['Name'];manifest=ROOT/'Unity/Assets/Zatod/Art/Imported'/name/'bake-manifest.txt'
        if manifest.exists():return {'Resource':name,'AlreadyBaked':True}
        if not (REF/'recovered/heroes'/name/'animation.json').exists():recover_effect('patch/pfca/effect/'+name+'.fca')
        return bake({'Id':'effect_'+name,'SourceResource':name})
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:effects=list(pool.map(effect,audit['Effects']))
    folder=ROOT/'Artifacts/ZatodBattleResultChecks';folder.mkdir(exist_ok=True)
    (folder/'native-art.json').write_text(json.dumps({'ByteIdentical':True,'Files':copied,'Effects':effects},indent=2))
    print(json.dumps({'Images':len(copied),'Effects':len(effects)}),flush=True)
if __name__=='__main__':main()
