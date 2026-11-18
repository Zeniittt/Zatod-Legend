using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Security.Cryptography;
using Newtonsoft.Json.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyLilina
{
    public static object Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        string Hash(string path){using(var sha=SHA256.Create())return Convert.ToBase64String(sha.ComputeHash(File.ReadAllBytes(path)));}
        var catalog=HeroDataJson.LoadBundledCatalog();string unchanged=JsonUtility.ToJson(catalog.Data);
        var hero=catalog.Hero("lilina");Check(hero.Name=="Lilina" && hero.Position==HeroPosition.Rear,"Hero identity");
        Check(catalog.Data.Heroes.Count(h=>!string.IsNullOrEmpty(h.BodyPrefabResource))==5,"Expected five illustrated Heroes");
        var set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(hero.AnimationSetResource).text);int frames=0;
        foreach(var entry in set.Clips)
        {
            var source=JObject.Parse(File.ReadAllText(entry.SourceFolder+"/animation.json"));var f=(JArray)source["frames"];
            var keys=AnimationUtility.GetObjectReferenceCurve(Resources.Load<AnimationClip>(entry.ClipResource),EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
            Check(keys.Length==f.Count && entry.SourceFrames.Count==f.Count,"Frame count "+entry.State);
            for(int i=0;i<keys.Length;i++)
            {
                var sprite=(Sprite)keys[i].value;string path=AssetDatabase.GetAssetPath(sprite);
                Check(Hash(path)==Hash(entry.SourceFolder+"/"+(string)f[i]["file"]),"Changed art bytes "+entry.State);
                Check(Math.Abs(keys[i].time-(float)f[i]["time_seconds"])<.0001f && sprite.pixelsPerUnit==25,"Timing/PPU "+entry.State);
            }
            frames+=keys.Length;
        }
        Check(Resources.Load<Sprite>("HeroPortraits/lilina")!=null && Resources.Load<GameObject>(hero.BodyPrefabResource)!=null,"Missing Hero assets");
        BattleRecord Build(string slot,int count=3,string rank="purple",int[] hp=null)
        {
            var settings=new HeroSandboxSettings{HeroId="lilina",RankId=rank,Mode=slot==null?SandboxTestMode.BasicAttack:SandboxTestMode.SingleSkill,SkillSlotId=slot,
                HpPercent=100,StartingEnergy=100,DurationSeconds=8,TargetHp=100000,TargetDistance=800,TargetSpacing=600,
                MonsterIds=Enumerable.Repeat("fighter_goblin",count).ToList()};
            var setup=HeroCombatSandbox.Prepare(catalog,settings);
            foreach(var loadout in setup.Loadouts.Where(l=>l.kind==CombatantKind.Monster)){loadout.disableBasicAttacks=true;loadout.monster.Skills.Clear();}
            if(hp!=null)for(int i=0;i<hp.Length;i++)setup.Fighters[i+1].hp=hp[i];
            return setup.Run();
        }
        var records=new List<BattleRecord>();
        var normal=Build(null);records.Add(normal);var first=normal.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill(hero.NormalAttackSkillId).Name);
        Check(normal.projectiles.Count(p=>p.actorId==1 && p.startTick<first.tick+30)==2,"Two normal fireballs");
        var ult=Build("ultimate");records.Add(ult);Check(ult.events.Count(e=>e.actorId==1 && e.kind==BattleEventKind.Damage)==18,"Dragon six pulses across three enemies");
        Check(ult.visualEffects.Any(v=>v.state=="DragonBreath"),"Dragon breath visual");
        var bolt=Build("skill_2",5);records.Add(bolt);Check(bolt.projectiles.Count(p=>p.actorId==1)==1,"One piercing bolt");
        var boltHits=bolt.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).ToArray();
        Check(boltHits.Select(e=>e.targetId).Distinct().Count()==5 && boltHits.Length==5,"Bolt should pierce each enemy once");
        Check(boltHits.Last().tick>boltHits.First().tick,"Bolt damage did not follow travel");
        var twins=Build("skill_3",3,hp:new[]{90000,60000,80000});records.Add(twins);
        Check(twins.projectiles.Count==2 && twins.projectiles.Select(p=>p.targetId).OrderBy(id=>id).SequenceEqual(new[]{102,103}),"Twins did not pick two lowest HP enemies");
        Check(twins.projectiles.All(p=>p.hit && p.path.Count>0),"Seeking twins missing recorded path/hit");
        var single=Build("skill_3",1);records.Add(single);Check(single.projectiles.Count==2 && single.projectiles.All(p=>p.targetId==101 && p.hit),"One enemy should receive both orbs");
        var fire=Build("skill_4");records.Add(fire);string name=catalog.Skill("lilina_skill4").Name;
        var direct=fire.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage && e.ability==name).ToArray();
        var burn=fire.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage && e.ability==name+" / Burn").ToArray();
        Check(direct.Length==4 && burn.Length==4,"Four fire ticks and four lingering burn ticks");
        Check(burn.First().tick>direct.Last().tick && burn.All(e=>e.targetId==101) && direct.All(e=>e.targetId==101),"Fire/Burn hit wrong targets or timing");
        Check(burn.Zip(burn.Skip(1),(a,b)=>b.tick-a.tick).All(delta=>delta==8),"Burn intervals");
        foreach(var rank in new[]{("white",1),("green",2),("blue",3),("purple",4)})
        {var owned=HeroCombatSandbox.TemporaryHero(catalog,"lilina",rank.Item1);Check(HeroBattleFactory.Create(owned,catalog).Skills.Count==rank.Item2,"Rank unlock "+rank.Item1);}
        foreach(var record in records)
        {
            var loaded=ReplayArchive.Decode(ReplayArchive.Encode(record));var timeline=new ReplayTimeline(loaded);
            for(int tick=0;tick<=record.durationTicks;tick++)
            {timeline.Seek(tick);foreach(var initial in record.initial){var expected=record.events.LastOrDefault(e=>e.hasState && e.state.id==initial.id && e.tick<=tick)?.state??initial;
                Check(JsonUtility.ToJson(timeline.States[initial.id])==JsonUtility.ToJson(expected),"Replay mismatch "+tick);}}
            for(int tick=record.durationTicks;tick>=0;tick-=11){timeline.Seek(tick);Check(timeline.Tick==tick,"Backward seek");}
        }
        Check(JsonUtility.ToJson(catalog.Data)==unchanged,"Combat changed config");
        return new{passed=true,checks,frames,clips=set.Clips.Count,hero="Lilina"};
    }
}
