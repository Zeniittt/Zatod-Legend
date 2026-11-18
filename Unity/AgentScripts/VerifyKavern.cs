using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyKavern
{
    public static object Run()
    {
        int checks=0;
        void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();var definition=catalog.Hero("kavern");
        string config=JsonUtility.ToJson(catalog.Data);
        var manifest=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(definition.AnimationSetResource).text);
        Check(definition.Position==HeroPosition.Rear,"Kavern is a rear ranged hero");
        Check(HeroProgression.UnlockedSkills(catalog.CreateHero("kavern","white-test"),catalog).Count==1,"White only unlocks ultimate");
        Check(HeroProgression.UnlockedSkills(HeroCombatSandbox.TemporaryHero(catalog,"kavern","purple"),catalog).Count==4,"Purple unlocks four skills");
        Check(manifest.Clips.Count==21,"Missing body/effect animation groups");
        var allFrames=Directory.GetFiles("Assets/Zatod/Art/Kavern","*.png",SearchOption.AllDirectories);
        Check(allFrames.Length==197,"Missing source PNGs");
        foreach(var file in allFrames)
        {
            string relative=file.Substring("Assets/Zatod/Art/Kavern/".Length).Replace('\\','/');
            Check(File.ReadAllBytes(file).SequenceEqual(File.ReadAllBytes("C:/Users/tinnq/Downloads/delivery_leaf_original/"+relative)),"Source art changed: "+relative);
            var importer=(TextureImporter)AssetImporter.GetAtPath(file);
            Check(importer.spritePixelsPerUnit==25 && importer.filterMode==FilterMode.Point && !importer.mipmapEnabled,"Import settings: "+relative);
        }
        Check(File.ReadAllBytes("Assets/Zatod/Resources/HeroPortraits/kavern.png").SequenceEqual(File.ReadAllBytes("C:/Users/tinnq/Downloads/delivery_leaf_original/Icon/leaf_icon_256.png")),"Icon changed");
        foreach(var entry in manifest.Clips)
        {
            var clip=Resources.Load<AnimationClip>(entry.ClipResource);
            var keys=AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
            Check(keys.Length==entry.SourceFrames.Count,"Clip frame count: "+entry.State);
            for(int i=0;i<keys.Length;i++)
                Check(((Sprite)keys[i].value).name==Path.GetFileNameWithoutExtension(entry.SourceFrames[i]),"Numeric frame order: "+entry.State);
        }
        Check(manifest.Clips.Single(c=>c.State=="Attack_Projectile").SourceFrames.Count==6 && manifest.Clips.Single(c=>c.State=="Attack_Impact").SourceFrames.Count==6,"Normal fly/hit phases");
        Check(manifest.Clips.Single(c=>c.State=="Skill2_Projectile").SourceFrames.Count==6 && manifest.Clips.Single(c=>c.State=="Skill2_Impact").SourceFrames.Count==8,"Poison fly/hit phases");
        BattleRecord Build(string slot,int targets=3,int distance=600)
        {return BuildIsolated(catalog,new HeroSandboxSettings{HeroId="kavern",RankId="purple",Mode=slot=="normal"?SandboxTestMode.BasicAttack:SandboxTestMode.SingleSkill,SkillSlotId=slot,TargetDistance=distance,TargetCount=targets,DurationSeconds=10});}
        foreach(string slot in new[]{"ultimate","skill_2","skill_3","skill_4","normal"})
        {
            var r=Build(slot);var damage=r.events.Where(e=>e.kind==BattleEventKind.Damage).ToArray();
            Check(damage.Length>0,"No damage: "+slot);
            Check(damage.All(e=>e.actorId==1 && e.targetId>=101),"Friendly/self damage: "+slot);
            if(slot=="ultimate")
            {Check(damage.Length==3 && damage.Select(e=>e.targetId).Distinct().Count()==3,"Beam must pierce all three targets");Check(r.visualEffects.Any(v=>v.state=="Ultimate_Effect_Beam"),"Beam visual missing");}
            if(slot=="skill_2")
            {
                Check(damage.Length==5 && damage.Select(e=>e.targetId).Distinct().Count()==1,"Poison must hit one enemy + four ticks");
                Check(damage.Skip(1).Select(e=>e.tick-damage[0].tick).SequenceEqual(new[]{20,40,60,80}),"Poison intervals/duration");
                Check(r.events.Count(e=>e.kind==BattleEventKind.Poison)==1,"Poison status missing");
            }
            if(slot=="skill_4")
            {
                var controls=r.events.Where(e=>e.kind==BattleEventKind.Stun).ToArray();
                Check(controls.Length==1 && controls[0].targetId==damage.Single().targetId,"Skill4 control target mismatch");
                Check(controls[0].controlKind==ControlKind.Stun && controls[0].state.stunUntil-controls[0].tick==20,"Skill4 must stun exactly one second");
                var p=r.projectiles.Single();Check(p.spawnPointId=="air_bow" && p.spawnHeight>p.endHeight,"Skill4 must descend from air bow");
                Check(r.visualEffects.Single(v=>v.targetId!=0).height==0,"Skill4 impact must be grounded");
            }
            if(slot=="normal" || slot=="skill_2" || slot=="skill_4")
                Check(r.projectiles.All(p=>p.hit && p.hasFlightPath && p.endTick>p.startTick && !string.IsNullOrEmpty(p.flightState) && !string.IsNullOrEmpty(p.impactState)),"Projectile flight/impact trace: "+slot);
            var loaded=ReplayArchive.Decode(ReplayArchive.Encode(r));
            Check(loaded.visualEffects.Count==r.visualEffects.Count && loaded.visualEffects.Select(v=>JsonUtility.ToJson(v)).SequenceEqual(r.visualEffects.Select(v=>JsonUtility.ToJson(v))),"VFX archive mismatch");
            var timeline=new ReplayTimeline(loaded);
            for(int tick=loaded.durationTicks;tick>=0;tick--)
            {
                timeline.Seek(tick);
                var expected=loaded.initial.ToDictionary(f=>f.id,f=>f.Copy());
                foreach(var e in loaded.events.Where(e=>e.tick<=tick && e.hasState))expected[e.state.id]=e.state;
                foreach(var state in expected.Values)Check(JsonUtility.ToJson(timeline.States[state.id])==JsonUtility.ToJson(state),"Replay seek mismatch: "+slot+" tick "+tick);
            }
            var repeat=Build(slot);
            Check(r.events.Select(e=>JsonUtility.ToJson(e)).SequenceEqual(repeat.events.Select(e=>JsonUtility.ToJson(e))),"Nondeterministic combat: "+slot);
            Check(r.visualEffects.Select(v=>JsonUtility.ToJson(v)).SequenceEqual(repeat.visualEffects.Select(v=>JsonUtility.ToJson(v))),"Nondeterministic VFX: "+slot);
        }
        foreach(int count in new[]{1,2,3,5})foreach(int distance in new[]{300,600,1500})
        {
            var r=Build("skill_3",count,distance);
            var damage=r.events.Where(e=>e.kind==BattleEventKind.Damage).ToArray();
            int hits=Math.Min(2,count);
            Check(damage.Length==hits && damage.Select(e=>e.targetId).SequenceEqual(Enumerable.Range(101,hits)),"Skill3 must hit nearest two only");
            Check(r.visualEffects.Count==hits && r.visualEffects.All(v=>v.followId==v.targetId && v.height==0),"One grounded ArrowShower per target");
            Check(damage.All(e=>r.visualEffects.Any(v=>v.targetId==e.targetId && v.startTick<e.tick && v.endTick>e.tick)),"Damage must occur inside target ArrowShower lifetime");
            Check(r.initial.Where(f=>f.id>=101+hits).All(f=>!r.events.Any(e=>e.hasState && e.state.id==f.id && e.state.hp!=f.hp)),"Unselected enemy took splash damage");
        }
        // A selected victim dies during the cast: never replace it with the third enemy.
        var locked=Build("skill_3");locked.initial.Single(f=>f.id==101).hp=1;
        locked.initial.Add(new FighterState{id=2,team=0,slot=1,name="Helper",hp=10000,maxHp=10000,attack=1,range=4000,attackInterval=20});
        locked.loadouts.Add(new FighterLoadout{fighterId=2,disableBasicAttacks=true,skillCastLimit=1,hero=new HeroBattleData{
            Skills=new System.Collections.Generic.List<BattleSkillData>{new BattleSkillData{SlotId="test",Definition=new SkillDefinition{
                Id="finish-first-target",Name="Helper",Target=SkillTarget.NearestEnemy,CastRange=4000,WindupMilliseconds=500,
                Effects=new System.Collections.Generic.List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Damage,Amount=10}}}}}}});
        var killed=new BattleSimulation(Guid.NewGuid().ToString("N"),"dead locked victim",123,locked.initial,locked.loadouts,200).RunToCompletion();
        Check(killed.events.Any(e=>e.kind==BattleEventKind.Death && e.targetId==101),"Dead-target scenario did not kill primary");
        Check(killed.visualEffects.Count==1 && killed.visualEffects.Single().targetId==102,"Skill3 retargeted dead victim to third enemy");
        Check(!killed.events.Any(e=>e.kind==BattleEventKind.Damage && e.targetId==103),"Third enemy took damage after locked victim died");
        var beam=Build("ultimate");beam.initial.Single(f=>f.id==103).x=-800;
        var forward=new BattleSimulation(Guid.NewGuid().ToString("N"),"beam direction",123,beam.initial,beam.loadouts,200).RunToCompletion();
        Check(!forward.events.Any(e=>e.kind==BattleEventKind.Damage && e.targetId==103),"Forward beam hit an enemy behind the caster");
        var character=Zatod.Presentation.FormationView.CreateDemoCharacter(catalog);
        Check(character.HeroDesk.Any(h=>h.HeroDefinitionId=="kavern" && h.RankId=="white"),"Kavern missing in owned roster");
        Check(JsonUtility.ToJson(catalog.Data)==config,"Combat mutated source config");
        return new{passed=true,checks,hero=definition.Name,frames=allFrames.Length,clips=manifest.Clips.Count};
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
