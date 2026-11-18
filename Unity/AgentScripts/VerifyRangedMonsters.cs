using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyRangedMonsters
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        string Hash(string path){using(var sha=SHA256.Create())return Convert.ToBase64String(sha.ComputeHash(File.ReadAllBytes(path)));}
        var catalog=HeroDataJson.LoadBundledCatalog();string config=JsonUtility.ToJson(catalog.Data);int frames=0;
        string[] ids={"archer","huntress","evil_wizard"};
        foreach(string id in ids)
        {
            var monster=catalog.Monster(id);Check(monster.SkillIds.Count==0,"Unexpected monster skills");
            Check(Resources.Load<GameObject>(monster.BodyPrefabResource)!=null && Resources.Load<Sprite>("MonsterPortraits/"+id)!=null,"Missing body/portrait: "+id);
            var set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(monster.AnimationSetResource).text);
            Check(new[]{"Idle","Run","NormalAttack","Death","TakeHit","Stun","ProjectileFlight"}.All(s=>set.Clips.Any(c=>c.State==s)),"Missing state: "+id);
            foreach(var entry in set.Clips.Where(c=>c.State!="Stun"))
            {
                var clip=Resources.Load<AnimationClip>(entry.ClipResource);
                var keys=AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
                Check(keys.Length==entry.SourceFrames.Count && keys.Length==entry.FrameTimes.Count,"Key count: "+entry.State);
                var first=(Sprite)keys[0].value;string path=AssetDatabase.GetAssetPath(first);
                Check(Hash(entry.SourceFolder)==Hash(path),"Modified source bytes: "+entry.State);
                var importer=(TextureImporter)AssetImporter.GetAtPath(path);var texture=AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                Check(importer.textureCompression==TextureImporterCompression.Uncompressed && texture.format==TextureFormat.RGBA32 && texture.width==first.rect.width*keys.Length,"Compression/rescale: "+path);
                Check(entry.Loop==(entry.State=="Idle"||entry.State=="Run"||entry.State=="ProjectileFlight"),"Loop: "+entry.State);
                for(int i=0;i<keys.Length;i++)
                {var sprite=(Sprite)keys[i].value;Check(Mathf.Abs(keys[i].time-i/12f)<.0001f && sprite.pixelsPerUnit==25,"Timing/PPU: "+id+"/"+entry.State);}
                var flip=AnimationUtility.GetEditorCurve(clip,EditorCurveBinding.FloatCurve("",typeof(SpriteRenderer),"m_FlipX"));
                Check((flip!=null && flip.Evaluate(.1f)>.5f)==(id=="evil_wizard" && entry.State=="ProjectileFlight"),"Source flip: "+id+"/"+entry.State);
                frames+=keys.Length;
            }
        }
        Check(frames==140,"Source frame count");
        var window=EditorWindow.GetWindow<HeroCombatSandboxWindow>();var root=window.rootVisualElement;
        var field=root.Q<DropdownField>("sandbox-hero");field.value=field.choices.Single(c=>c.EndsWith("(leenald)"));
        root.Q<IntegerField>("sandbox-hp").value=100;root.Q<IntegerField>("sandbox-target-hp").value=5000;
        root.Q<IntegerField>("sandbox-duration").value=30;root.Q<IntegerField>("sandbox-distance").value=2200;root.Q<IntegerField>("sandbox-spacing").value=220;
        root.Q<IntegerField>("sandbox-target-count").value=3;
        for(int i=0;i<ids.Length;i++){var choice=root.Q<DropdownField>("sandbox-monster-"+i);choice.value=choice.choices.Single(c=>c.EndsWith("("+ids[i]+")"));}
        var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();string owned=JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character);
        var button=root.Q<Button>("sandbox-basic");using(var e=NavigationSubmitEvent.GetPooled()){e.target=button;button.SendEvent(e);}
        var until=DateTime.UtcNow.AddSeconds(15);
        while((arena.Record==null || !arena.Record.initial.Any(f=>f.monsterDefinitionId=="evil_wizard")) && DateTime.UtcNow<until)await Task.Delay(25);
        Check(arena.Record!=null && arena.Record.initial.Count==4 && arena.SandboxMode,"UI test did not start");
        if(arena.Playing)arena.TogglePlayback();var record=arena.Record;
        foreach(string id in ids)
        {
            int actor=record.initial.Single(f=>f.monsterDefinitionId==id).id;
            var move=record.events.First(e=>e.actorId==actor && e.kind==BattleEventKind.Move);
            arena.Seek((move.tick+1)/20f);Canvas.ForceUpdateCanvases();
            var body=UnityEngine.Object.FindObjectsByType<ReplaySprite>().Single(s=>s.transform.parent.name=="Fighter_"+actor);
            Check(body.CurrentState=="Run" && body.GetComponent<UnityEngine.UI.Image>().canvasRenderer.GetMesh().vertexCount>=4,"Run mesh: "+id);
            var attack=record.events.First(e=>e.actorId==actor && e.kind==BattleEventKind.Action && e.state.animationState=="NormalAttack");
            arena.Seek((attack.tick+1)/20f);Canvas.ForceUpdateCanvases();
            Check(body.CurrentState=="NormalAttack" && body.GetComponent<UnityEngine.UI.Image>().sprite!=null,"Attack sprite: "+id);
            var p=record.projectiles.First(p=>p.actorId==actor && p.hit && p.endTick>p.startTick+1);
            arena.Seek((p.startTick+1)/20f);Canvas.ForceUpdateCanvases();
            var visual=UnityEngine.Object.FindObjectsByType<ReplaySprite>().Single(s=>s.name=="Projectile_"+actor && s.gameObject.activeInHierarchy);
            var image=visual.GetComponent<UnityEngine.UI.Image>();
            Check(visual.CurrentState=="ProjectileFlight" && image.enabled && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount>=4 && image.mainTexture.width>1,"Projectile mesh/texture: "+id);
            Check(Mathf.Sign(visual.transform.localScale.x)==((p.direction>0)!=(id=="evil_wizard")?1:-1),"Projectile facing: "+id);
            Check(p.hasSpawnPoint && p.spawnPointId=="weapon" && p.spawnHeight==catalog.Monster(id).SpawnPoints.Single().Height,"Spawn point: "+id);
            Check(record.events.Any(e=>e.actorId==actor && e.kind==BattleEventKind.Damage && e.targetId==1),"No real damage: "+id);
            if(id=="evil_wizard")
            {
                arena.Seek((p.endTick+1)/20f);Canvas.ForceUpdateCanvases();
                var effect=UnityEngine.Object.FindObjectsByType<ReplaySprite>().FirstOrDefault(s=>s.gameObject.activeInHierarchy && s.CurrentState=="ProjectileImpact");
                Check(effect!=null && effect.GetComponent<UnityEngine.UI.Image>().canvasRenderer.GetMesh().vertexCount>=4,"Wizard explosion");
            }
        }
        // ReplaySprite samples the clip's flip curve; subsequent non-flipped clips must reset it.
        var sampleObject=new GameObject("WizardFacingCheck",typeof(RectTransform));sampleObject.transform.SetParent(arena.transform,false);
        try
        {
            var sample=sampleObject.AddComponent<ReplaySprite>();sample.Initialize(catalog.Monster("evil_wizard").AnimationSetResource);
            sample.Sample("ProjectileFlight",.15f,true,.9f,true);Check(sampleObject.transform.localScale.x<0,"Wizard right-flight source orientation");
            sample.Sample("ProjectileFlight",.15f,false,.9f,true);Check(sampleObject.transform.localScale.x>0,"Wizard left-flight source orientation");
            sample.Sample("Idle",.15f,true,.9f);Check(sampleObject.transform.localScale.x>0,"Flip leaked into next body clip");
        }
        finally{UnityEngine.Object.DestroyImmediate(sampleObject);}
        var loaded=ReplayArchive.Decode(ReplayArchive.Encode(record));var replay=new ReplayTimeline(loaded);
        replay.Seek(100);string state=JsonUtility.ToJson(replay.States[101]);replay.Seek(200);replay.Seek(100);
        Check(JsonUtility.ToJson(replay.States[101])==state,"Backward seek");
        Check(loaded.loadouts.Count(l=>l.kind==CombatantKind.Monster)==3,"Archive monster data");
        Check(JsonUtility.ToJson(catalog.Data)==config && JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character)==owned,"Runtime mutated saved data");
        Check(!Mirror.NetworkClient.active && !Mirror.NetworkServer.active,"Sandbox started networking");
        arena.Seek(record.projectiles.First(p=>record.initial.Single(f=>f.id==p.actorId).monsterDefinitionId=="evil_wizard" && p.hit).startTick/20f+.1f);
        string pathOut=Path.GetFullPath("../Artifacts/RangedMonsterChecks/ranged-monsters.arena.gz");Directory.CreateDirectory(Path.GetDirectoryName(pathOut));File.WriteAllBytes(pathOut,ReplayArchive.Encode(record));
        return new{passed=true,checks,frames,archive=pathOut};
    }
}
