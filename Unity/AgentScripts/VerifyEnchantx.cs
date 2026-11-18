using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyEnchantx
{
    public static BattleRecord Build(string slot,int casts=1,int seconds=25,int spacing=20)
    {
        return BuildIsolated(HeroDataJson.LoadBundledCatalog(),new HeroSandboxSettings{HeroId="enchantx",RankId="purple",
            Mode=slot=="normal"?SandboxTestMode.BasicAttack:SandboxTestMode.SingleSkill,SkillSlotId=slot,SingleSkillCasts=casts,
            TargetDistance=1410,TargetSpacing=spacing,DurationSeconds=seconds});
    }
    public static object Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();string before=JsonUtility.ToJson(catalog.Data);var hero=catalog.Hero("enchantx");
        var manifest=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(hero.AnimationSetResource).text);
        Check(hero.Position==HeroPosition.Rear && manifest.Clips.Count==27,"Rear Hero/animation manifest");
        Check(HeroProgression.UnlockedSkills(catalog.CreateHero("enchantx","white"),catalog).Count==1,"White skills");
        var pngs=Directory.GetFiles("Assets/Zatod/Art/Enchantx","*.png",SearchOption.AllDirectories);
        Check(pngs.Length==339,"Source PNG count");
        foreach(var path in pngs)
        {
            string relative=path.Substring("Assets/Zatod/Art/Enchantx/".Length).Replace('\\','/');
            Check(File.ReadAllBytes(path).SequenceEqual(File.ReadAllBytes("C:/Users/tinnq/OneDrive/Desktop/CentaurLady_HeroKit_v4/CentaurLady_HeroKit/"+relative)),"PNG bytes changed: "+relative);
            var importer=(TextureImporter)AssetImporter.GetAtPath(path);
            Check(importer.spritePixelsPerUnit==25 && !importer.mipmapEnabled && importer.filterMode==FilterMode.Point,"Pixel import settings");
        }
        foreach(var entry in manifest.Clips)
        {
            var clip=Resources.Load<AnimationClip>(entry.ClipResource);
            var keys=AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
            Check(entry.FrameTimes.Count==entry.SourceFrames.Count && keys.Length==entry.SourceFrames.Count,"Variable-duration metadata: "+entry.State);
            for(int i=0;i<keys.Length;i++)Check(Mathf.Abs(keys[i].time-entry.FrameTimes[i])<.0001f && ((Sprite)keys[i].value).name==Path.GetFileNameWithoutExtension(entry.SourceFrames[i]),"Key order/time: "+entry.State);
        }
        Check(manifest.Clips.Single(c=>c.State=="Idle").SourceFrames.Count==18,"Idle 1–18");
        Check(manifest.Clips.Single(c=>c.State=="Skill3").SourceFrames.Count==57 && manifest.Clips.Single(c=>c.State=="Skill3Repeat").SourceFrames.Count==20,"Opening/repeat clips");
        var records=new List<BattleRecord>();
        foreach(string slot in new[]{"normal","ultimate","skill_2","skill_4"})
        {
            var r=Build(slot);records.Add(r);var hits=r.events.Where(e=>e.kind==BattleEventKind.Damage).ToArray();
            Check(hits.Length>0 && hits.All(e=>e.actorId==1 && e.targetId>=101),"Enemy-only damage: "+slot);
            if(slot=="ultimate")Check(hits.Length==3 && hits.Select(e=>e.targetId).Distinct().Count()==3 && !r.events.Any(e=>e.kind==BattleEventKind.Stun),"Piercing ultimate; tornado currently VFX only");
            if(slot=="skill_2")Check(hits.Length==12 && hits.Select(e=>e.tick).Distinct().Count()==4,"Rain must have four damage pulses");
            if(slot=="skill_4")Check(r.projectiles.Count==3 && r.projectiles.Select(p=>p.startTick-1).SequenceEqual(new[]{2,14,25}) && hits.Length==3,"Triple-shot release/contact timing");
            var repeat=Build(slot);
            Check(r.events.Select(e=>JsonUtility.ToJson(e)).SequenceEqual(repeat.events.Select(e=>JsonUtility.ToJson(e))),"Repeatable seed: "+slot);
        }
        var rain=Build("skill_2",spacing:150);
        Check(rain.events.Count(e=>e.kind==BattleEventKind.Damage)==8 && !rain.events.Any(e=>e.kind==BattleEventKind.Damage && e.targetId==103),"Rain radius boundary");
        var summon=Build("skill_3",2,30);
        // A normal attacker proves the modifier changes actual outgoing damage and later expires.
        summon.initial.Add(new FighterState{id=2,team=0,slot=1,name="Ally",hp=10000,maxHp=10000,attack=100,range=5000,attackInterval=5,x=-300});
        summon.loadouts.Add(new FighterLoadout{fighterId=2,hero=new HeroBattleData{HasNormalAttack=true,NormalAttack=new SkillDefinition{Id="ally-basic",Name="Ally attack",Target=SkillTarget.NearestEnemy,
            Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=10000}}}}});
        var buffed=new BattleSimulation(Guid.NewGuid().ToString("N"),"buff behavior",123,summon.initial,summon.loadouts,600).RunToCompletion();records.Add(buffed);
        var casts=buffed.events.Where(e=>e.kind==BattleEventKind.Action && e.actorId==1 && e.ability==catalog.Skill("enchantx_skill3").Name).ToArray();
        Check(casts.Length==2 && casts[0].tick==1 && casts[0].state.animationState=="Skill3" && casts[1].state.animationState=="Skill3Repeat","Opening is immediate, then repeat variant");
        Check(casts[1].tick-casts[0].tick>=200,"Opening starts shared cooldown");
        Check(buffed.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.state.presentationHeight>0),"Jump height absent");
        Check(!buffed.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.tick>=casts[1].tick),"Repeat moved/jumped again");
        var buffs=buffed.events.Where(e=>e.kind==BattleEventKind.Buff && e.ability==catalog.Skill("enchantx_skill3").Name).ToArray();
        Check(buffs.Length==4 && buffs.All(e=>e.targetId==1 || e.targetId==2),"Buff must reach both allies, no enemies");
        Check(buffs.All(e=>e.state.damageBonusBasisPoints==2000),"Repeated buff stacked instead of refreshing");
        int first=buffs[0].tick,last=buffs.Last().state.damageBuffUntil;
        var attacks=buffed.events.Where(e=>e.kind==BattleEventKind.Damage && e.actorId==2 && !e.critical).ToArray();
        Check(attacks.Any(e=>e.tick<first && e.amount==100) && attacks.Any(e=>e.tick>=first && e.tick<last && e.amount==120) && attacks.Any(e=>e.tick>=last && e.amount==100),"Actual damage does not gain/lose timed modifier");
        Check(buffed.snapshots.Last().fighters.Single(f=>f.id==2).attack==100 && buffed.snapshots.Last().fighters.Single(f=>f.id==2).damageBonusBasisPoints==0,"Buff changed base attack or failed to expire");
        foreach(string rank in new[]{"white","green"})
        {
            var r=BuildIsolated(catalog,new HeroSandboxSettings{HeroId="enchantx",RankId=rank,TargetDistance=1410,DurationSeconds=5});
            Check(!r.events.Any(e=>e.hasState && e.state.animationState=="Skill3"),"Locked rank ran Skill3 opening");
        }
        BattleRecord Interrupt(string slot,int milliseconds)
        {
            var r=Build(slot,1,12);var victim=r.loadouts.Single(l=>l.fighterId==101);
            victim.disableBasicAttacks=true;victim.skillCastLimit=1;
            victim.Data.Skills.Add(new BattleSkillData{SlotId="interrupt",Definition=new SkillDefinition{Id="interrupt",Name="Enemy stun",CastRange=10000,Target=SkillTarget.NearestEnemy,
                WindupMilliseconds=milliseconds,Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Stun,DurationMilliseconds=1000}}}});
            return new BattleSimulation(Guid.NewGuid().ToString("N"),"interruption",123,r.initial,r.loadouts,240).RunToCompletion();
        }
        var beforeRelease=Interrupt("skill_3",500);
        Check(!beforeRelease.visualEffects.Any(v=>v.state.StartsWith("FlameWings")) && !beforeRelease.events.Any(e=>e.kind==BattleEventKind.Buff),"Unreleased summon survived interruption");
        var afterRelease=Interrupt("skill_3",3500);
        Check(afterRelease.events.Any(e=>e.kind==BattleEventKind.Buff && e.targetId==1),"Released FlameWings lost its buff after caster stun");
        var burstInterrupted=Interrupt("skill_4",300);
        Check(burstInterrupted.projectiles.Count==1 && burstInterrupted.projectiles[0].hit,"Stun did not cancel remaining shots / canceled released arrow");
        var retarget=Build("skill_4");retarget.initial.Single(f=>f.id==101).hp=1;retarget.initial.Single(f=>f.id==102).hp=1;
        retarget=new BattleSimulation(Guid.NewGuid().ToString("N"),"burst retarget",123,retarget.initial,retarget.loadouts,500).RunToCompletion();
        Check(retarget.projectiles.Select(p=>p.targetId).SequenceEqual(new[]{101,102,103}),"Unfired arrows did not retarget after victim death");
        var death=Build("skill_3",seconds:12);death.initial.Single(f=>f.id==1).hp=1;
        death.initial.Add(new FighterState{id=2,team=0,slot=1,name="Surviving ally",hp=10000,maxHp=10000,x=-200});
        death.loadouts.Add(new FighterLoadout{fighterId=2,disableBasicAttacks=true,hero=new HeroBattleData()});
        var killer=death.loadouts.Single(l=>l.fighterId==101);killer.skillCastLimit=1;
        killer.Data.Skills.Add(new BattleSkillData{SlotId="kill",Definition=new SkillDefinition{Id="kill",Name="Enemy hit",Target=SkillTarget.NearestEnemy,CastRange=10000,WindupMilliseconds=3500,
            Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Damage,Amount=10}}}});
        death=new BattleSimulation(Guid.NewGuid().ToString("N"),"released bird after death",123,death.initial,death.loadouts,240).RunToCompletion();
        Check(death.events.Any(e=>e.kind==BattleEventKind.Death && e.targetId==1),"Caster-death scenario failed");
        Check(death.events.Any(e=>e.kind==BattleEventKind.Buff && e.targetId==2) && !death.events.Any(e=>e.kind==BattleEventKind.Buff && e.targetId==1),"Released bird must buff surviving allies after caster death");
        foreach(var r in records.Concat(new[]{beforeRelease,afterRelease,burstInterrupted,retarget,death}))
        {
            var loaded=ReplayArchive.Decode(ReplayArchive.Encode(r));var timeline=new ReplayTimeline(loaded);
            Check(loaded.visualEffects.Select(v=>JsonUtility.ToJson(v)).SequenceEqual(r.visualEffects.Select(v=>JsonUtility.ToJson(v))),"VFX archive changed");
            for(int t=loaded.durationTicks;t>=0;t--)
            {
                timeline.Seek(t);var expected=loaded.initial.ToDictionary(f=>f.id,f=>f.Copy());
                foreach(var e in loaded.events.Where(e=>e.tick<=t && e.hasState))expected[e.state.id]=e.state;
                foreach(var state in expected.Values)Check(JsonUtility.ToJson(timeline.States[state.id])==JsonUtility.ToJson(state),"Replay mismatch tick "+t);
            }
        }
        var frozen=Build("skill_3");var simulation=new BattleSimulation(Guid.NewGuid().ToString("N"),"snapshot freeze",123,frozen.initial,frozen.loadouts,240);
        frozen.loadouts[0].hero.Skills[0].Definition.CastSequences[0].Actions[0].DelayMilliseconds=99999;
        Check(simulation.RunToCompletion().events.Any(e=>e.kind==BattleEventKind.Buff),"Sequence config was not detached");
        Check(JsonUtility.ToJson(catalog.Data)==before,"Tests changed saved config");
        Check(Zatod.Presentation.FormationView.CreateDemoCharacter(catalog).HeroDesk.Any(h=>h.HeroDefinitionId=="enchantx" && h.RankId=="white"),"Owned roster missing Enchantx");
        return new{passed=true,checks,hero="Enchantx",frames=pngs.Length,clips=manifest.Clips.Count,openingTick=casts[0].tick,repeatTick=casts[1].tick};
    }
    static Zatod.Combat.BattleRecord BuildIsolated(Zatod.Heroes.HeroCatalog catalog, Zatod.Editor.HeroSandboxSettings settings)
    {
        settings.MonsterIds = System.Linq.Enumerable.Repeat("fighter_goblin", settings.TargetCount).ToList();
        if (settings.TargetHp == 0) settings.TargetHp = 100000;
        if (settings.TargetSpacing == 220) settings.TargetSpacing = 20;
        var setup = Zatod.Editor.HeroCombatSandbox.Prepare(catalog, settings);
        foreach (var loadout in setup.Loadouts.Where(l => l.fighterId != 1))
        { loadout.disableBasicAttacks = true; loadout.Data.Skills.Clear(); loadout.Data.Stats.Single(s => s.StatId == "defense").Value = 0; }
        foreach (var fighter in setup.Fighters.Where(f => f.id != 1))
        { fighter.armor = 0; fighter.range = 0; fighter.projectileHurtboxHeight = 100; }
        return setup.Run();
    }
}
