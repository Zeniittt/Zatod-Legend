using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using Zatod.Combat;
using Zatod.Heroes;

static class Program
{
    static int checks;
    static readonly JsonSerializerOptions Json=new(){IncludeFields=true,IgnoreReadOnlyProperties=true};
    static string Encode(object value)=>JsonSerializer.Serialize(value,value.GetType(),Json);
    static void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
    static void Main()
    {
        var root=new DirectoryInfo(Directory.GetCurrentDirectory());while(root!=null && !Directory.Exists(Path.Combine(root.FullName,"Unity/Assets/Zatod")))root=root.Parent;
        if(root==null)throw new DirectoryNotFoundException("Run inside the Zatod workspace.");
        string dataPath=Path.Combine(root.FullName,"Unity/Assets/Zatod/Resources/Data");
        T Read<T>(string name)=>JsonSerializer.Deserialize<T>(File.ReadAllText(Path.Combine(dataPath,name+".txt")),Json);
        var stats=Read<StatsConfigData>("Stats");var items=Read<ItemsConfigData>("Items");var skills=Read<SkillsConfigData>("Skills");
        var heroes=Read<HeroesConfigData>("Heroes");var monsters=Read<MonstersConfigData>("Monsters");
        Check(new[]{items.ConfigVersion,skills.ConfigVersion,heroes.ConfigVersion,monsters.ConfigVersion}.All(v=>v==stats.ConfigVersion),"Config version mismatch");
        var catalog=new HeroCatalog(new HeroCatalogData{ConfigVersion=stats.ConfigVersion,Stats=stats.Stats,Items=items.Items,Skills=skills.Skills,Heroes=heroes.Heroes,Monsters=monsters.Monsters});
        string original=Encode(catalog.Data);
        Check(new[]{"fighter_goblin","skeleton_knight","goblin_mage","guardian","archer","huntress","evil_wizard"}.All(id=>catalog.Monster(id).SkillIds.Count==0),"Missing normal-attack-only starter monster");
        var first=MonsterBattleFactory.Create("fighter_goblin","first",catalog);var second=MonsterBattleFactory.Create("fighter_goblin","second",catalog);
        first.CurrentHp=1;first.NormalAttack.Effects[0].DamageScaleBasisPoints=1;
        Check(second.CurrentHp==900 && second.NormalAttack.Effects[0].DamageScaleBasisPoints==10000 && catalog.Skill("fighter_goblin_normal_attack").Effects[0].DamageScaleBasisPoints==10000,"Repeated monsters share mutable data");
        (List<FighterState> fighters,List<FighterLoadout> loadouts) Setup(string heroId,string[] ids)
        {
            var owned=catalog.CreateHero(heroId,"test-hero");
            while(owned.RankId!="purple")
            {foreach(var slot in HeroProgression.CurrentRank(owned,catalog).EquipmentSlots)HeroProgression.Equip(owned,catalog,slot.Id,slot.RequiredItemId);HeroProgression.Promote(owned,catalog);}
            var battle=HeroBattleFactory.Create(owned,catalog);var def=catalog.Hero(heroId);int Stat(string id)=>battle.Stats.Single(s=>s.StatId==id).Value;
            var fighter=new FighterState{id=1,team=0,slot=0,name=def.Name,maxHp=Stat("health"),hp=battle.CurrentHp,attack=Stat("damage"),armor=Stat("defense"),range=Stat("attack_range"),
                moveSpeed=Stat("move_speed"),attackInterval=Stat("attack_interval"),formationSpacing=850,heroDefinitionId=heroId,animationSetResource=def.AnimationSetResource,
                energy=100,projectileHurtboxHeight=def.ProjectileHurtboxHeight};
            var fighters=new List<FighterState>{fighter};var loadouts=new List<FighterLoadout>{new(){fighterId=1,hero=battle}};
            for(int i=0;i<ids.Length;i++)
            {
                var d=catalog.Monster(ids[i]);var b=MonsterBattleFactory.Create(d.Id,"monster-"+i,catalog);var f=MonsterBattleFactory.CreateFighter(d,b,1,i);
                // Start beyond the configured bow/spell reach so this scenario still tests chasing.
                f.x=3600+i*220;f.y=(i-1)*300;f.formationSpacing=220;f.energy=100;
                fighters.Add(f);loadouts.Add(new FighterLoadout{fighterId=f.id,kind=CombatantKind.Monster,monster=b});
            }
            return (fighters,loadouts);
        }
        var compositions=new[]{new[]{"fighter_goblin"},new[]{"fighter_goblin","skeleton_knight","goblin_mage"},new[]{"fighter_goblin","fighter_goblin","skeleton_knight","goblin_mage","goblin_mage"},new[]{"guardian","guardian","goblin_mage"},new[]{"archer","huntress","evil_wizard"},new[]{"guardian","archer","archer","huntress","evil_wizard"}};
        int matches=0;
        foreach(string hero in new[]{"leenald","kavern","enchantx"})foreach(var composition in compositions)
        {
            var setup=Setup(hero,composition);setup.loadouts[0].hero.Skills.Clear();var simulation=new BattleSimulation(Guid.NewGuid().ToString("N"),"monster-test",123,setup.fighters,setup.loadouts,900);
            setup.loadouts[1].monster.NormalAttack.Effects[0].DamageScaleBasisPoints=99999;
            var record=simulation.RunToCompletion();matches++;
            Check(record.loadouts[1].monster.NormalAttack.Effects[0].DamageScaleBasisPoints==10000,"Simulation accepted post-snapshot edits");
            Check(record.initial.Where(f=>f.team==1).Select(f=>f.monsterInstanceId).Distinct().Count()==composition.Length,"Duplicate runtime monster identity");
            Check(record.events.Any(e=>e.kind==BattleEventKind.Move && e.actorId>=101),"Monsters did not chase: "+hero);
            Check(record.events.Any(e=>e.kind==BattleEventKind.Damage && e.actorId>=101 && e.targetId==1),"Monsters did not fight back: "+hero);
            Check(!record.events.Any(e=>e.kind==BattleEventKind.Action && e.actorId>=101 && e.state.action==BattleAction.Ultimate),"Monster gained a legacy role ultimate at 100 energy");
            Check(record.events.Where(e=>e.kind==BattleEventKind.Damage).All(e=>record.initial.Single(f=>f.id==e.actorId).team!=record.initial.Single(f=>f.id==e.targetId).team),"Friendly normal attack damage");
            if(composition.Contains("goblin_mage"))Check(record.projectiles.Any(p=>record.initial.Single(f=>f.id==p.actorId).monsterDefinitionId=="goblin_mage" && p.hit),"Mage projectile missing/hit failed");
            foreach(string id in composition.Distinct().Where(id=>catalog.Skill(catalog.Monster(id).NormalAttackSkillId).Delivery==SkillDelivery.Projectile))
                Check(record.projectiles.Any(p=>record.initial.Single(f=>f.id==p.actorId).monsterDefinitionId==id && p.hit),"Ranged monster projectile missing/hit failed: "+id+" vs "+hero);
            var loaded=JsonSerializer.Deserialize<BattleRecord>(Encode(record),Json);
            Check(loaded.loadouts.Count(l=>l.hero!=null)==1 && loaded.loadouts.Count(l=>l.monster!=null)==composition.Length,"JSON lost loadout subtypes");
            Check(loaded.loadouts.Where(l=>l.monster!=null).All(l=>l.monster.Stats.Count==6 && l.monster.HasNormalAttack),"Inherited monster battle data lost in JSON");
            var timeline=new ReplayTimeline(loaded);var expected=loaded.initial.ToDictionary(f=>f.id,f=>f.Copy());int cursor=0;
            for(int tick=0;tick<=loaded.durationTicks;tick++)
            {
                while(cursor<loaded.events.Count && loaded.events[cursor].tick<=tick){var e=loaded.events[cursor++];if(e.hasState)expected[e.state.id]=e.state;}
                timeline.Seek(tick);foreach(var state in expected.Values)Check(Encode(timeline.States[state.id])==Encode(state),"Monster replay mismatch "+tick);
            }
            for(int tick=loaded.durationTicks;tick>=0;tick-=17)
            {
                timeline.Seek(tick);foreach(var f in loaded.initial)
                {var state=loaded.events.LastOrDefault(e=>e.hasState && e.state.id==f.id && e.tick<=tick)?.state??f;Check(Encode(timeline.States[f.id])==Encode(state),"Backward monster seek mismatch");}
            }
        }
        var retarget=Setup("kavern",new[]{"fighter_goblin","fighter_goblin"});retarget.loadouts[0].hero.Skills.Clear();
        retarget.fighters[1].hp=1;retarget.fighters[1].x=600;retarget.fighters[2].x=1000;
        var switched=new BattleSimulation(Guid.NewGuid().ToString("N"),"retarget",123,retarget.fighters,retarget.loadouts,500).RunToCompletion();
        Check(switched.events.Any(e=>e.kind==BattleEventKind.Death && e.targetId==101) && switched.events.Any(e=>e.kind==BattleEventKind.Target && e.actorId==1 && e.state.targetId==102),"Hero did not switch after monster death");
        foreach(int direction in new[]{1,-1})
        {
            var close=Setup("kavern",new[]{"fighter_goblin"});
            close.fighters[1].x=50*direction;
            if(direction<0)foreach(var f in close.fighters)f.team=1-f.team;
            close.loadouts[0].hero.Skills=close.loadouts[0].hero.Skills.Where(s=>s.SlotId=="skill_4").ToList();
            close.loadouts[0].disableBasicAttacks=true;close.loadouts[0].skillCastLimit=1;
            var hit=new BattleSimulation(Guid.NewGuid().ToString("N"),"close airborne arrow",123,close.fighters,close.loadouts,100).RunToCompletion();
            Check(hit.projectiles.Single(p=>p.actorId==1).hit,"Close descending arrow missed behind muzzle");
            Check(hit.events.Any(e=>e.kind==BattleEventKind.Stun && e.actorId==1 && e.state.stunUntil-e.tick==20),"Close Skill4 failed to stun");
        }
        Check(Encode(catalog.Data)==original,"Battle mutated catalog definitions");
        Console.WriteLine($"[MonsterChecks] PASS / {checks:N0} assertions, {matches} real fights: AI, repeated units, melee/projectiles, no implicit ultimate, death/retarget, detached data and replay ticks.");
    }
}
