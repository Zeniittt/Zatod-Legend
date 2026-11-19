using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyBerthaxe
{
    public static object Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();string unchanged=JsonUtility.ToJson(catalog.Data);var hero=catalog.Hero("berthaxe");
        var set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(hero.AnimationSetResource).text);
        Check(hero.Name=="Berthaxe" && hero.Position==HeroPosition.Front && set.Clips.Count==14,"Hero identity/clips");
        int frames=0;
        foreach(var clip in set.Clips)
        {
            var keys=AnimationUtility.GetObjectReferenceCurve(Resources.Load<AnimationClip>(clip.ClipResource),EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
            var source=JObject.Parse(File.ReadAllText(clip.SourceFolder+"/animation.json"));
            Check(keys.Length==clip.SourceFrames.Count,"Frame count: "+clip.State);
            for(int i=0;i<keys.Length;i++)
            {
                var path="Assets/Zatod/Art/Berthaxe/"+clip.State+"/"+clip.SourceFrames[i];
                Check(File.ReadAllBytes(path).SequenceEqual(File.ReadAllBytes(clip.SourceFolder+"/"+clip.SourceFrames[i])),"Changed source PNG: "+path);
                Check(Math.Abs(keys[i].time-(float)source["frames"][i]["time_seconds"])<.00001f,"Source timing changed: "+clip.State);
                var importer=(TextureImporter)AssetImporter.GetAtPath(path);Check(importer.spritePixelsPerUnit==25 && importer.filterMode==FilterMode.Point && !importer.mipmapEnabled,"Pixel import");frames++;
            }
        }
        Check(frames==293 && set.Clips.Single(c=>c.State=="Skill2").SourceFrames.Count==62,"Expected v4 key selection");
        foreach(var rank in new[]{("white",1),("green",2),("blue",3),("purple",4)})
            Check(HeroBattleFactory.Create(HeroCombatSandbox.TemporaryHero(catalog,"berthaxe",rank.Item1),catalog).Skills.Count==rank.Item2,"Unlock "+rank.Item1);
        SandboxBattleSetup Setup(string slot,int[] positions,bool mirror=false)
        {
            var settings=new HeroSandboxSettings{HeroId="berthaxe",RankId="purple",Mode=slot==null?SandboxTestMode.BasicAttack:SandboxTestMode.SingleSkill,
                SkillSlotId=slot,StartingEnergy=100,HpPercent=100,DurationSeconds=12,TargetHp=500000,TargetDistance=0,TargetSpacing=0,
                MonsterIds=Enumerable.Repeat("fighter_goblin",positions.Length).ToList()};
            var setup=HeroCombatSandbox.Prepare(catalog,settings);
            for(int i=0;i<positions.Length;i++){var f=setup.Fighters[i+1];f.x=mirror?-positions[i]:positions[i];f.y=i%2==0?120:-140;f.armor=0;f.range=0;f.moveSpeed=1;}
            foreach(var l in setup.Loadouts.Where(l=>l.kind==CombatantKind.Monster)){l.disableBasicAttacks=true;l.Data.Skills.Clear();}
            return setup;
        }
        var records=new List<BattleRecord>();
        var normal=Setup(null,new[]{1500,2000,6000}).Run();records.Add(normal);
        Check(normal.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).Select(e=>e.targetId).Distinct().SequenceEqual(new[]{101}),"Basic attack cleaved");
        BattleEvent[] Hits(BattleRecord r)=>r.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).ToArray();
        foreach(bool mirror in new[]{false,true})
        {
            var earth=Setup("ultimate",new[]{1200,1700,2300,3100,4500},mirror).Run();records.Add(earth);var hits=Hits(earth);
            Check(hits.Length==5 && hits.Select(e=>e.targetId).SequenceEqual(new[]{101,102,103,104,105}),"Earth wave did not cover both depths: "+mirror);
            Check(hits.Zip(hits.Skip(1),(a,b)=>b.tick>a.tick).All(ok=>ok),"Earth wave damage was simultaneous");
            foreach(var h in hits)
            {
                var cc=earth.events.Last(e=>e.actorId==1 && e.targetId==h.targetId && e.kind==BattleEventKind.Stun && e.tick==h.tick);
                Check(cc.state.knockUpUntil-h.tick==6 && cc.state.stunUntil-h.tick==22,"Earth knock-up + landing stun timing");
            }
            Check(earth.visualEffects.Count(v=>v.state=="EarthEruption")>=30,"Ground wave columns missing");
            Check(earth.initial[0].hp==earth.events.Last(e=>e.hasState && e.state.id==1).state.hp,"Ultimate hit self");
        }
        var spin=Setup("skill_2",new[]{1500,2500,7000}).Run();records.Add(spin);var spinHits=Hits(spin);
        Check(spinHits.Length==20 && spinHits.Select(e=>e.targetId).Distinct().OrderBy(x=>x).SequenceEqual(new[]{101,102}),"Spin radius/tick count");
        foreach(int id in new[]{101,102})
        {
            var hits=spinHits.Where(e=>e.targetId==id).ToArray();Check(hits.Length==10,"Nine spins plus one finisher");
            Check(hits.Last().amount>hits.Take(9).Max(e=>e.amount)*2,"Finisher not stronger");
            Check(hits.Take(9).Zip(hits.Skip(1).Take(8),(a,b)=>b.tick-a.tick).All(delta=>delta==6),"Spin pauses between loops");
        }
        var slam=Setup("skill_3",new[]{3000,3600,6500}).Run();records.Add(slam);
        Check(Hits(slam).Length==2 && Hits(slam).All(e=>e.tick==31 && e.targetId<103),"Slam AOE/damage timing");
        Check(slam.events.Any(e=>e.hasState && e.state.id==1 && e.state.presentationHeight>0),"No jump motion");
        Check(slam.events.Any(e=>e.kind==BattleEventKind.Stun && e.state.knockUpUntil-e.tick==10),"No slam knock-up");
        Check(slam.visualEffects.Any(v=>v.state=="EarthExplosion" && v.x==3000),"Slam visual off area center");
        var wave=Setup("skill_4",new[]{1500,2500,7000}).Run();records.Add(wave);
        Check(Hits(wave).Length==3 && Hits(wave).Select(e=>e.tick).Distinct().Count()==3,"Shock wave did not travel/pierce");
        Check(!wave.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Stun),"Shock wave added unrequested CC");
        foreach(int windup in new[]{400,900})
        {
            var interrupted=Setup("ultimate",new[]{1200,1700,2300,3100,4500});
            interrupted.Loadouts.Single(l=>l.fighterId==101).Data.Skills.Add(new BattleSkillData{SlotId="interrupt",Definition=new SkillDefinition{Id="interrupt",Name="Enemy interrupt",CastRange=20000,
                Target=SkillTarget.NearestEnemy,CooldownMilliseconds=100000,WindupMilliseconds=windup,Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Stun,DurationMilliseconds=1000}}}});
            var r=interrupted.Run();records.Add(r);
            Check(windup<600?r.projectiles.Count==0:Hits(r).Length==5,"Ultimate interruption/released wave independence");
        }
        foreach(var record in records)
        {
            var loaded=ReplayArchive.Decode(ReplayArchive.Encode(record));var timeline=new ReplayTimeline(loaded);
            for(int tick=loaded.durationTicks;tick>=0;tick-=3)
            {
                timeline.Seek(tick);foreach(var initial in loaded.initial)
                {var expected=loaded.events.LastOrDefault(e=>e.hasState && e.state.id==initial.id && e.tick<=tick)?.state??initial;
                    Check(JsonUtility.ToJson(timeline.States[initial.id])==JsonUtility.ToJson(expected),"Replay changed tick "+tick);}
            }
        }
        var campaign=CampaignDataJson.Load(catalog);var account=campaign.CreateDemoCharacter(catalog);
        Check(account.HeroDesk.Count==6 && account.HeroDesk.Single(h=>h.HeroDefinitionId=="berthaxe").RankId=="purple","Campaign demo missing Berthaxe");
        bool rejected=false;try{CampaignBattleFactory.Prepare(campaign,catalog,account,"chapter_1_stage_1",account.HeroDesk.Select(h=>h.HeroInstanceId));}catch(ArgumentException){rejected=true;}Check(rejected,"Accepted six selected Heroes");
        Check(Zatod.Presentation.FormationView.CreateDemoCharacter(catalog).HeroDesk.Any(h=>h.HeroDefinitionId=="berthaxe" && h.RankId=="white"),"Ordinary roster starting rank");
        Check(JsonUtility.ToJson(catalog.Data)==unchanged,"Tests changed source config");
        Directory.CreateDirectory("../Artifacts/BerthaxeChecks");File.WriteAllBytes("../Artifacts/BerthaxeChecks/ultimate.arena.gz",ReplayArchive.Encode(records[1]));
        File.WriteAllBytes("../Artifacts/BerthaxeChecks/spin.arena.gz",ReplayArchive.Encode(spin));File.WriteAllBytes("../Artifacts/BerthaxeChecks/slam.arena.gz",ReplayArchive.Encode(slam));
        return new{passed=true,checks,hero="Berthaxe",frames,clips=set.Clips.Count,matches=records.Count};
    }
}
