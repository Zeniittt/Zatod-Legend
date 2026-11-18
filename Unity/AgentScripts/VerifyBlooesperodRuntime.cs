using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyBlooesperodRuntime
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string message){checks++;if(!ok)throw new Exception(message);}
        string Hash(string path){using(var sha=SHA256.Create())return Convert.ToBase64String(sha.ComputeHash(File.ReadAllBytes(path)));}
        var catalog=HeroDataJson.LoadBundledCatalog();string config=JsonUtility.ToJson(catalog.Data);
        var definition=catalog.Hero("blooesperod");Check(definition.Name=="Blooesperod" && definition.Position==HeroPosition.Front,"Hero identity");
        var manifest=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(definition.AnimationSetResource).text);int frames=0;
        foreach(var entry in manifest.Clips.Where(c=>c.State!="SoulReturn"))
        {
            var source=JObject.Parse(File.ReadAllText(entry.SourceFolder+"/animation.json"));var sourceFrames=(JArray)source["frames"];
            var clip=Resources.Load<AnimationClip>(entry.ClipResource);
            var keys=AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
            Check(keys.Length==sourceFrames.Count && keys.Length==entry.SourceFrames.Count,"Frame count "+entry.State);
            for(int i=0;i<keys.Length;i++)
            {
                var sprite=(Sprite)keys[i].value;string path=AssetDatabase.GetAssetPath(sprite);
                Check(Hash(entry.SourceFolder+"/"+(string)sourceFrames[i]["file"])==Hash(path),"Source pixels changed "+entry.State);
                Check(Mathf.Abs(keys[i].time-(float)sourceFrames[i]["time_seconds"])<.0001f && sprite.pixelsPerUnit==25,"Timing/PPU "+entry.State);
                Check(((TextureImporter)AssetImporter.GetAtPath(path)).textureCompression==TextureImporterCompression.Uncompressed,"Compression "+entry.State);
            }
            frames+=keys.Length;
        }
        Check(frames==344 && manifest.Clips.Count==20,"Animation totals");
        Check(Resources.Load<Sprite>("HeroPortraits/blooesperod")!=null && Resources.Load<GameObject>(definition.BodyPrefabResource)!=null,"Hero assets");
        var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();var formation=arena.GetComponent<FormationView>();
        Check(formation.Selection.Character.HeroDesk.Any(h=>h.HeroDefinitionId=="blooesperod"),"Hero missing from roster");
        string owned=JsonUtility.ToJson(formation.Selection.Character);
        var window=EditorWindow.GetWindow<HeroCombatSandboxWindow>();window.CreateGUI();var root=window.rootVisualElement;
        var hero=root.Q<DropdownField>("sandbox-hero");hero.value=hero.choices.Single(c=>c.EndsWith("(blooesperod)"));
        root.Q<IntegerField>("sandbox-duration").value=30;root.Q<IntegerField>("sandbox-hp").value=50;root.Q<IntegerField>("sandbox-energy").value=100;
        root.Q<IntegerField>("sandbox-casts").value=1;root.Q<IntegerField>("sandbox-distance").value=600;root.Q<IntegerField>("sandbox-spacing").value=300;
        root.Q<IntegerField>("sandbox-target-hp").value=10000;root.Q<IntegerField>("sandbox-target-count").value=3;
        for(int i=0;i<3;i++){var dropdown=root.Q<DropdownField>("sandbox-monster-"+i);dropdown.value=dropdown.choices.Single(c=>c.EndsWith("(guardian)"));}
        async Task Click(string name)
        {
            string previous=arena.Record?.battleId;var button=root.Q<Button>(name);Check(button!=null && button.enabledInHierarchy,"Missing/disabled "+name);
            using(var e=NavigationSubmitEvent.GetPooled()){e.target=button;button.SendEvent(e);}
            var until=DateTime.UtcNow.AddSeconds(15);while((arena.Record==null || arena.Record.battleId==previous)&&DateTime.UtcNow<until)await Task.Delay(25);
            Check(arena.Record!=null && arena.Record.battleId!=previous,"UI failed: "+root.Q<Label>("sandbox-status").text);
            if(arena.Playing)arena.TogglePlayback();await Task.Delay(40);
        }
        ReplaySprite[] Sprites()=>UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Include);
        ReplaySprite Body()=>Sprites().Single(s=>s.transform.parent.name=="Fighter_1");
        void Drawn(ReplaySprite sprite,string label)
        {Canvas.ForceUpdateCanvases();var image=sprite.GetComponent<UnityEngine.UI.Image>();Check(sprite.gameObject.activeInHierarchy && image.enabled && image.sprite!=null && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount>=4,label);}
        await Click("sandbox-basic");var normal=arena.Record.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill(definition.NormalAttackSkillId).Name);
        arena.Seek((normal.tick+7)/20f);Drawn(Body(),"Normal body");Check(Body().CurrentState=="NormalAttack","Normal state");
        Check(!arena.Record.visualEffects.Any(v=>v.state=="BloodSlash3"),"Third normal slash remains");
        await Click("sandbox-cast-ultimate");var ultimate=arena.Record;Check(ultimate.projectiles.Count(p=>p.actorId==1)==5,"Five souls");
        var soul=ultimate.projectiles.First(p=>p.actorId==1 && p.endTick>p.startTick+2);arena.Seek((soul.startTick+2)/20f);
        Check(soul.path.Count>2 && soul.path[0].tick==soul.startTick && soul.path.Last().tick==soul.endTick,"Missing recorded tracking samples");
        var flight=Sprites().First(s=>s.name=="Projectile_1" && s.gameObject.activeInHierarchy);Drawn(flight,"Soul flight");
        Check(flight.CurrentState=="SoulFlight","Soul state");
        var returning=ultimate.visualEffects.First(v=>v.state=="SoulReturn");arena.Seek((returning.startTick+1)/20f);
        Drawn(Sprites().First(s=>s.CurrentState=="SoulReturn" && s.gameObject.activeInHierarchy),"Return soul");
        Check(ultimate.events.Any(e=>e.kind==BattleEventKind.Heal && e.targetId==1),"Lifesteal runtime");
        await Click("sandbox-cast-skill_2");var grab=arena.Record;
        var held=grab.events.First(e=>e.kind==BattleEventKind.Stun && e.actorId==1 && e.controlKind==ControlKind.Stun);
        Check(held.targetId==103,"Grab wrong target");arena.Seek((held.tick+2)/20f);Drawn(Body(),"Grab body");
        Check(Body().CurrentState=="Skill2","Grab animation");
        var toss=grab.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Stun && e.controlKind==ControlKind.KnockUp);arena.Seek((toss.tick+2)/20f);
        Drawn(Sprites().Single(s=>s.transform.parent.name=="Fighter_"+toss.targetId),"Thrown victim");
        var returned=grab.events.Single(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.ability.EndsWith(" / Return"));
        arena.Seek(returned.tick/20f);var original=grab.initial.Single(f=>f.id==1);
        Check(arena.Timeline.States[1].x==original.x && arena.Timeline.States[1].y==original.y,"Skill2 did not return to original position");
        Drawn(Body(),"Returned caster");arena.Seek((returned.tick-1)/20f);arena.Seek(returned.tick/20f);
        Check(arena.Timeline.States[1].x==original.x && arena.Timeline.States[1].y==original.y,"Return changed on backward seek");
        System.IO.Directory.CreateDirectory("../Artifacts/BlooesperodChecks");
        System.IO.File.WriteAllBytes("../Artifacts/BlooesperodChecks/skill2-return.arena.gz",ReplayArchive.Encode(grab));
        root.Q<IntegerField>("sandbox-target-count").value=1;root.Q<IntegerField>("sandbox-target-hp").value=1;
        await Click("sandbox-cast-skill_2");var winningGrab=arena.Record;
        var finalReturn=winningGrab.events.Single(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.ability.EndsWith(" / Return"));
        Check(winningGrab.winner==0 && finalReturn.tick>winningGrab.combatEndTick,"Final kill omitted return");
        arena.Seek(finalReturn.tick/20f);Check(arena.Timeline.States[1].x==winningGrab.initial.Single(f=>f.id==1).x,"Outro return missing on screen");Drawn(Body(),"Victory return body");
        File.WriteAllBytes("../Artifacts/BlooesperodChecks/skill2-return-victory.arena.gz",ReplayArchive.Encode(winningGrab));
        root.Q<IntegerField>("sandbox-target-count").value=3;root.Q<IntegerField>("sandbox-target-hp").value=10000;
        await Click("sandbox-cast-skill_3");var sweep=arena.Record;var strike=sweep.visualEffects.First(v=>v.state=="BloodSlash3");
        arena.Seek((strike.startTick+1)/20f);Drawn(Body(),"Sweep body");Drawn(Sprites().First(s=>s.CurrentState=="BloodSlash3" && s.gameObject.activeInHierarchy),"Sweep FX");
        Check(!sweep.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Move),"Sweep moved caster");
        root.Q<IntegerField>("sandbox-hp").value=1;root.Q<IntegerField>("sandbox-distance").value=200;
        await Click("sandbox-cast-skill_4");var resurrection=arena.Record;
        var dead=resurrection.events.First(e=>e.targetId==1 && e.kind==BattleEventKind.Death);var rise=resurrection.events.Single(e=>e.kind==BattleEventKind.Revive);
        Check(rise.tick-dead.tick==40 && rise.state.hp==rise.state.maxHp/2,"Revive timing/HP");
        arena.Seek((dead.tick+24)/20f);Drawn(Body(),"Shadow during dead interval");
        Check(Body().CurrentState=="Skill4" && Body().GetComponentInParent<CanvasGroup>().alpha==1,"Shadow faded or Death state replaced revive");
        Check(!arena.Timeline.States[1].Alive && arena.Timeline.States[1].reviveAtTick==rise.tick,"Dead shadow target state");
        arena.Seek(rise.tick/20f);Drawn(Body(),"Rise body");Check(Body().CurrentState=="Skill4" && arena.Timeline.States[1].Alive,"Rise animation/HP");
        var roundtrip=ReplayArchive.Decode(ReplayArchive.Encode(resurrection));Check(roundtrip.events.Single(e=>e.kind==BattleEventKind.Revive).state.lifestealBasisPoints==1000,"Unity JSON lost resurrection");
        var flightArchive=ReplayArchive.Decode(ReplayArchive.Encode(ultimate));Check(flightArchive.projectiles.Zip(ultimate.projectiles,(a,b)=>a.path.Count==b.path.Count &&
            a.path.Zip(b.path,(x,y)=>x.tick==y.tick && x.x==y.x && x.y==y.y && x.height==y.height).All(equal=>equal)).All(equal=>equal),"Unity JSON changed seeking path");
        arena.Seek((dead.tick+24)/20f);string before=JsonUtility.ToJson(arena.Timeline.States[1]);arena.Seek((rise.tick+25)/20f);arena.Seek((dead.tick+24)/20f);
        Check(JsonUtility.ToJson(arena.Timeline.States[1])==before && Body().CurrentState=="Skill4","Backward resurrection seek");
        string output=Path.GetFullPath("../Artifacts/BlooesperodChecks/resurrection.arena.gz");Directory.CreateDirectory(Path.GetDirectoryName(output));File.WriteAllBytes(output,ReplayArchive.Encode(resurrection));
        root.Q<IntegerField>("sandbox-hp").value=100;root.Q<IntegerField>("sandbox-duration").value=45;
        await Click("sandbox-test-all");
        foreach(string skill in new[]{"blooesperod_ultimate","blooesperod_skill2","blooesperod_skill3"})Check(arena.Record.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill(skill).Name),"Auto kit missing "+skill);
        Check(JsonUtility.ToJson(catalog.Data)==config && JsonUtility.ToJson(formation.Selection.Character)==owned,"Changed config or HeroDesk");
        Check(!Mirror.NetworkClient.active && !Mirror.NetworkServer.active,"Started Mirror host/client");
        File.WriteAllBytes(Path.Combine(Path.GetDirectoryName(output),"all-skills.arena.gz"),ReplayArchive.Encode(arena.Record));arena.Seek(1.8f);
        return new{passed=true,checks,frames,hero="Blooesperod",archive=output};
    }
}
