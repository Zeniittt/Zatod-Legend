"""Bake the five native town containers; paths are from the current extracted source."""
from pathlib import Path
import json,hashlib
from Bake_CrystalSupport import ROOT,REF,recover_effect,bake
resources=['eff_UI_Main_Pve','eff_UI_Main_Guild','eff_UI_Main_Pvp','eff_UI_Main_fancytower','eff_UI_Main_Pvp_fort']
report=[]
for resource in resources:
    container=REF/'recovered/assets/install_time_pack/remake/pfca/effect'/(resource+'.fca')
    if not container.is_file():container=REF/'recovered/downloads/aab_1.1.100312/patch/pfca/effect'/(resource+'.fca')
    existing=ROOT/'Unity/Assets/Zatod/Art/Imported'/resource/'bake-manifest.txt'
    if existing.is_file():
        manifest=json.loads(existing.read_text());report.append(dict(Resource=resource,Actions=len(manifest['Actions']),Frames=sum(len(a['Frames']) for a in manifest['Actions']),Manifest=existing.relative_to(ROOT).as_posix(),Source=container.relative_to(ROOT).as_posix(),SourceSha256=hashlib.sha256(container.read_bytes()).hexdigest()));continue
    output=ROOT/'Artifacts/D38Checks/RecoveredBuildings'/resource
    recover_effect(str(container),output)
    row=bake(dict(Id='world_'+resource,SourceResource=resource,RecoveredFolder=str(output)))
    row.update(Source=container.relative_to(ROOT).as_posix(),SourceSha256=hashlib.sha256(container.read_bytes()).hexdigest());report.append(row);print(resource,row,flush=True)
(ROOT/'Artifacts/D38Checks/building-bake.json').write_text(json.dumps(report,indent=2)+'\n')
