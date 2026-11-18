using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Text.Json;
using Zatod.Combat;
using Zatod.Heroes;

static class Program
{
    static int checks;static HeroCatalog catalog;
    static readonly JsonSerializerOptions Json=new(){IncludeFields=true,IgnoreReadOnlyProperties=true};
    static string Encode(object value)=>JsonSerializer.Serialize(value,value.GetType(),Json);
    static void Check(bool ok,string message){checks++;if(!ok)throw new Exception(message);}
    sealed class Setup
    {
        public List<FighterState> fighters=new();public List<FighterLoadout> loadouts=new();
        public BattleRecord Run(int ticks=200)=>new BattleSimulation(Guid.NewGuid().ToString("N"),"blooesperod-checks",123,fighters,loadouts,ticks).RunToCompletion();
        public HeroBattleData Hero=>loadouts[0].hero;
    }
    static Setup Create(string slot=null,int count=3,string rank="purple")
    {
        var owned=catalog.CreateHero("blooesperod","owned-test");
        while(owned.RankId!=rank){foreach(var s in HeroProgression.CurrentRank(owned,catalog).EquipmentSlots)HeroProgression.Equip(owned,catalog,s.Id,s.RequiredItemId);HeroProgression.Promote(owned,catalog);}
        var hero=HeroBattleFactory.Create(owned,catalog);if(slot!=null)hero.Skills=hero.Skills.Where(s=>s.SlotId==slot).ToList();else hero.Skills.Clear();
        int Stat(string id)=>hero.Stats.Single(s=>s.StatId==id).Value;
        var setup=new Setup();setup.fighters.Add(new FighterState{id=1,team=0,slot=0,name="Blooesperod",heroDefinitionId="blooesperod",maxHp=Stat("health"),hp=Stat("health"),
            attack=Stat("damage"),armor=Stat("defense"),range=Stat("attack_range"),moveSpeed=Stat("move_speed"),attackInterval=Stat("attack_interval"),energy=100,
            animationSetResource="Heroes/Blooesperod/AnimationSet",projectileHurtboxHeight=236,deathVisualTicks=105});
        setup.loadouts.Add(new FighterLoadout{fighterId=1,hero=hero,disableBasicAttacks=slot!=null,skillCastLimit=slot!=null?1:0});
        for(int i=0;i<count;i++)
        {
            var d=catalog.Monster("guardian");var m=MonsterBattleFactory.Create("guardian","target-"+i,catalog);
            m.Stats.Single(s=>s.StatId=="health").Value=m.CurrentHp=100000;
            var f=MonsterBattleFactory.CreateFighter(d,m,1,i);f.x=100+i*600;
            setup.fighters.Add(f);setup.loadouts.Add(new FighterLoadout{fighterId=f.id,kind=CombatantKind.Monster,monster=m,disableBasicAttacks=true});
        }
        return setup;
    }
    static void EnemyAttack(Setup s,int damage,int interval=40,int windup=100)
    {
        var enemy=s.fighters[1];enemy.attack=damage;enemy.range=6000;enemy.attackInterval=interval;
        s.loadouts[1].disableBasicAttacks=false;s.loadouts[1].monster.NormalAttack=new SkillDefinition{Id="enemy-test",Name="Enemy test",Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,
            CastRange=6000,WindupMilliseconds=windup,AnimationState="NormalAttack",Effects=new(){new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=10000}}};
    }
    static void Replay(BattleRecord record)
    {
        var loaded=JsonSerializer.Deserialize<BattleRecord>(Encode(record),Json);var replay=new ReplayTimeline(loaded);
        var state=loaded.initial.ToDictionary(f=>f.id,f=>f.Copy());int cursor=0;
        for(int tick=0;tick<=loaded.durationTicks;tick++)
        {
            while(cursor<loaded.events.Count && loaded.events[cursor].tick<=tick){var e=loaded.events[cursor++];if(e.hasState)state[e.state.id]=e.state;}
            replay.Seek(tick);foreach(var f in state.Values)Check(Encode(f)==Encode(replay.States[f.id]),"Replay state mismatch tick "+tick);
        }
        for(int tick=loaded.durationTicks;tick>=0;tick-=7){replay.Seek(tick);foreach(var f in loaded.initial){var expected=loaded.events.LastOrDefault(e=>e.hasState && e.state.id==f.id && e.tick<=tick)?.state??f;Check(Encode(expected)==Encode(replay.States[f.id]),"Backward replay mismatch");}}
    }
    static void Main()
    {
        var root=new DirectoryInfo(Directory.GetCurrentDirectory());while(root!=null && !Directory.Exists(Path.Combine(root.FullName,"Unity/Assets/Zatod")))root=root.Parent;
        string path=Path.Combine(root.FullName,"Unity/Assets/Zatod/Resources/Data");T Read<T>(string file)=>JsonSerializer.Deserialize<T>(File.ReadAllText(Path.Combine(path,file+".txt")),Json);
        var stats=Read<StatsConfigData>("Stats");catalog=new HeroCatalog(new HeroCatalogData{ConfigVersion=stats.ConfigVersion,Stats=stats.Stats,Items=Read<ItemsConfigData>("Items").Items,
            Skills=Read<SkillsConfigData>("Skills").Skills,Heroes=Read<HeroesConfigData>("Heroes").Heroes,Monsters=Read<MonstersConfigData>("Monsters").Monsters});
        string original=Encode(catalog.Data);var records=new List<BattleRecord>();
        foreach(var pair in new[]{("white",1),("green",2),("blue",3),("purple",4)})
        {var hero=catalog.CreateHero("blooesperod","rank-test");while(hero.RankId!=pair.Item1){foreach(var e in HeroProgression.CurrentRank(hero,catalog).EquipmentSlots)HeroProgression.Equip(hero,catalog,e.Id,e.RequiredItemId);HeroProgression.Promote(hero,catalog);}Check(HeroBattleFactory.Create(hero,catalog).Skills.Count==pair.Item2,"Rank unlock");}
        var basic=Create(null,1);var normal=basic.Run(40);records.Add(normal);
        Check(normal.events.Count(e=>e.actorId==1 && e.kind==BattleEventKind.Damage)==2,"Normal attack must land two hits");
        Check(!normal.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Move),"Normal attack moved actor");
        Check(normal.visualEffects.All(v=>v.state!="BloodSlash3"),"Normal attack used third slash");
        var grab=Create("skill_2");var grabbed=grab.Run(90);records.Add(grabbed);
        Check(grabbed.events.First(e=>e.kind==BattleEventKind.Move && e.actorId==1).state.x==1160,"Teleport did not approach farthest enemy");
        Check(grabbed.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).Select(e=>e.targetId).SequenceEqual(new[]{103}),"Grab damaged another target");
        Check(grabbed.events.Any(e=>e.kind==BattleEventKind.Stun && e.targetId==103 && e.controlKind==ControlKind.Stun),"Grab did not control victim");
        Check(grabbed.events.Count(e=>e.targetId==103 && e.kind==BattleEventKind.Move)>10,"Pull was not recorded");
        Check(grabbed.events.Any(e=>e.kind==BattleEventKind.Stun && e.targetId==103 && e.controlKind==ControlKind.KnockUp),"Throw did not lift victim");
        var returned=grabbed.events.Single(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.ability.EndsWith(" / Return"));
        var grabStart=grabbed.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill("blooesperod_skill2").Name);
        Check(returned.state.x==grab.fighters[0].x && returned.state.y==grab.fighters[0].y && returned.tick-grabStart.tick==69,"Grab did not return to cast origin at sequence end");
        var mirrored=Create("skill_2");mirrored.fighters[0].x=350;mirrored.fighters[0].y=-147;mirrored.fighters[0].facingDirection=-1;
        foreach(var f in mirrored.fighters){f.team=1-f.team;if(f.id!=1)f.x=-f.x;}
        var mirroredGrab=mirrored.Run(90);records.Add(mirroredGrab);
        var mirroredReturn=mirroredGrab.events.Single(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.ability.EndsWith(" / Return"));
        Check(mirroredReturn.state.x==350 && mirroredReturn.state.y==-147 && mirroredReturn.state.facingDirection==-1,"Return used world zero or wrong facing for mirrored cast");
        var finalKill=Create("skill_2",1);finalKill.fighters[0].x=-350;finalKill.fighters[1].hp=1;
        var winningGrab=finalKill.Run(200);records.Add(winningGrab);
        var outroReturn=winningGrab.events.Single(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.ability.EndsWith(" / Return"));
        Check(winningGrab.winner==0 && winningGrab.combatEndTick<outroReturn.tick && outroReturn.state.x==-350,"Final kill skipped return during battle outro");
        Check(!winningGrab.events.Any(e=>e.tick>winningGrab.combatEndTick && e.kind==BattleEventKind.Damage),"Outro return ran more combat damage");
        var interrupted=Create("skill_2");EnemyAttack(interrupted,0,1000,1000);
        interrupted.loadouts[1].monster.NormalAttack.Effects=new(){new SkillEffectDefinition{Kind=SkillEffectKind.Stun,DurationMilliseconds=1500}};
        var cancelled=interrupted.Run(110);records.Add(cancelled);
        Check(!cancelled.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Damage),"Interrupted grab still damaged");
        Check(cancelled.events.Any(e=>e.kind==BattleEventKind.Cancel && e.targetId==103),"Interrupted grab retained victim");
        Check(!cancelled.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Move && e.ability.EndsWith(" / Return")),"Interrupted cast forced return during crowd control");
        var sweep=Create("skill_3");sweep.fighters[1].hp=1000;sweep.fighters[2].hp=200;sweep.fighters[3].hp=500;
        sweep.fighters[2].maxHp=1000;
        var swept=sweep.Run(50);records.Add(swept);
        Check(swept.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).Select(e=>e.targetId).SequenceEqual(new[]{102,103}),"Weakest HP + behind targeting");
        Check(!swept.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Move),"Sweep moved actor");
        var souls=Create("ultimate");souls.fighters[0].hp/=2;var ult=souls.Run(160);records.Add(ult);
        Check(ult.projectiles.Count(p=>p.actorId==1)==5,"Ultimate must release five souls");
        Check(ult.projectiles.Where(p=>p.hit).Select(p=>p.targetId).Distinct().Count()==3,"Front enemy intercepted all seeking souls");
        Check(ult.events.Any(e=>e.kind==BattleEventKind.Heal && e.targetId==1),"Ultimate did not heal");
        Check(ult.visualEffects.Count(v=>v.state=="SoulReturn")==5,"Missing return souls");
        var moving=Create("ultimate",1);moving.fighters[1].x=2000;
        moving.loadouts[1].monster.Skills.Add(new BattleSkillData{SlotId="retreat",Definition=new SkillDefinition{Id="retreat",Name="Retreat test",Kind=SkillKind.Active,
            Target=SkillTarget.NearestEnemy,CastRange=6000,CooldownMilliseconds=100000,Effects=new(){new SkillEffectDefinition{Kind=SkillEffectKind.Damage}},
            CastSequences=new(){new SkillCastSequence{AnimationState="Run",DurationMilliseconds=4000,Motion=new(){new SkillMotionKey{TimeMilliseconds=0},new SkillMotionKey{TimeMilliseconds=1600},
                new SkillMotionKey{TimeMilliseconds=2600,Forward=-1800},new SkillMotionKey{TimeMilliseconds=4000,Forward=-1800}}}}}});
        var tracked=moving.Run(180);records.Add(tracked);
        Check(tracked.projectiles.Count==5 && tracked.projectiles.All(p=>p.hit && p.path.Count>2 && p.endX>2500),"Souls did not follow a retreating target");
        foreach(var p in tracked.projectiles)
            Check(p.path.Select(s=>s.tick).SequenceEqual(p.path.Select(s=>s.tick).Distinct().OrderBy(t=>t)) && p.path[0].tick==p.startTick && p.path.Last().tick==p.endTick,"Invalid tracking sample order");
        var death=Create("skill_4",1);death.fighters[0].hp=1;EnemyAttack(death,100000);
        var revived=death.Run(400);records.Add(revived);
        var firstDeath=revived.events.First(e=>e.kind==BattleEventKind.Death && e.targetId==1);var revival=revived.events.Single(e=>e.kind==BattleEventKind.Revive);
        Check(revival.tick-firstDeath.tick==40,"Revive delay is not exactly 2 seconds from HP zero");
        Check(revival.state.hp==revival.state.maxHp/2 && revival.state.revivesUsed==1,"Wrong revive HP or count");
        Check(revival.state.lifestealBasisPoints==1000 && revival.state.lifestealUntil-revival.tick==200,"Missing temporary lifesteal");
        Check(revived.events.Count(e=>e.kind==BattleEventKind.Death && e.targetId==1)==2 && revived.winner==1,"Second death did not finish normally");
        Check(!revived.events.Any(e=>e.actorId>=101 && e.kind==BattleEventKind.Damage && e.tick>firstDeath.tick && e.tick<revival.tick),"Enemies hit the dead shadow");
        var locked=Create("ultimate",1,"white");locked.Hero.Skills.Clear();locked.loadouts[0].disableBasicAttacks=true;locked.fighters[0].hp=1;EnemyAttack(locked,100000);
        var white=locked.Run(200);records.Add(white);Check(!white.events.Any(e=>e.kind==BattleEventKind.Revive),"White rank revived");
        var buff=Create("skill_4",1);buff.loadouts[0].disableBasicAttacks=false;buff.fighters[0].hp=1;EnemyAttack(buff,100,10);
        var healed=buff.Run(360);records.Add(healed);
        Check(healed.events.Any(e=>e.kind==BattleEventKind.Heal && e.ability.Contains("Lifesteal") && e.actorId==1),"Post-revive basics did not lifesteal");
        Check(healed.events.Any(e=>e.kind==BattleEventKind.Buff && e.ability=="Lifesteal expired" && e.state.lifestealBasisPoints==0),"Lifesteal did not expire");
        var both=Create("skill_4",1);both.loadouts[0].disableBasicAttacks=both.loadouts[1].disableBasicAttacks=false;
        both.loadouts[1].monster.Skills.Add(new BattleSkillData{SlotId="on_death",Definition=catalog.Skill("blooesperod_skill4").Copy()});
        var shot=new SkillDefinition{Id="simultaneous",Name="Simultaneous shot",Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,Delivery=SkillDelivery.Projectile,
            ProjectileResource="test",ProjectileSpeed=1000,ProjectileHitRadius=30,ProjectileLifetimeMilliseconds=1000,ProjectileSpawnMilliseconds=100,
            Effects=new(){new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=10000}}};
        both.Hero.NormalAttack=shot;both.loadouts[1].monster.NormalAttack=shot.Copy();
        foreach(var f in both.fighters){f.hp=1;f.attack=100000;}
        var simultaneous=both.Run(200);records.Add(simultaneous);
        Check(simultaneous.events.Count(e=>e.kind==BattleEventKind.Revive)==2,"Both teams pending resurrection ended combat early");
        foreach(var record in records)Replay(record);
        Check(Encode(catalog.Data)==original,"Combat mutated catalog");
        Console.WriteLine($"[BlooesperodChecks] PASS / {checks:N0} assertions, {records.Count} scenarios: two-hit basics, grab/interruption, weakest+behind, souls, lifesteal, resurrection, replay.");
    }
}
