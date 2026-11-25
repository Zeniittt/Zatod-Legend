using System;
using System.Linq;
using Zatod.Combat;
using Zatod.Heroes;

static partial class Program
{
    static void BattleStatisticsChecks()
    {
        var hit=new ZatodBattleSimulation(Fixture("AD",100,12.5));for(int i=0;i<3;i++)hit.Step();
        var rows=hit.Statistics();Check(rows.Single(s=>s.Team==0).DamageDealt==50 && rows.Single(s=>s.Team==1).DamageTaken==50,"Stat counters must use mitigated HP damage");
        Check(hit.Frame().CombatEvents.Single(e=>e.Kind=="damage").SourceActorId==1,"Damage event lost source actor");
        rows[0].DamageDealt=999;Check(hit.Statistics()[0].DamageDealt!=999,"Mutable report leaked back into simulator");
        var kill=new ZatodBattleSimulation(Fixture("Holy",20000));for(int i=0;i<3;i++)kill.Step();
        Check(kill.Statistics().Single(s=>s.Team==0).DamageDealt==10000 && kill.Statistics().Single(s=>s.Team==0).Kills==1,"Overkill/kill counted incorrectly");
        Check(kill.DeathRecords().Count==1 && kill.DeathRecords()[0].SourceActorId==1,"Missing death attribution");
        var healDefinition=Fixture("Heal",2000);healDefinition.Players[0].InitialHealth=9500;var healSkill=healDefinition.Players[0].Battle.NormalAttack.Crystal;healSkill.TargetType="self";healSkill.TargetCamp=0;healSkill.AffectedCamp=0;
        var heal=new ZatodBattleSimulation(healDefinition);for(int i=0;i<3;i++)heal.Step();
        Check(heal.Statistics().Single(s=>s.Team==0).Healing==500,"Healing report included overheal or credited the target instead of caster");
        var periodic=Fixture();periodic.Players[0].Battle.PreciseStats.Add(new StatAmount{StatId="health_regen",Value=-8});var dot=new ZatodBattleSimulation(periodic);dot.Step();
        Check(dot.Statistics().Single(s=>s.Team==0).DamageTaken==1,"Periodic HP loss missing from taken damage");
        ZatodMatchDefinition Periodic(double hpr,bool self)
        {
            var definition=Fixture("",0);var skill=definition.Players[0].Battle.NormalAttack.Crystal;skill.BuffId=9001;skill.TargetType=self?"self":"target";
            definition.Buffs.Add(new ZatodBuffDefinition{Id="periodic_fixture",SourceId=9001,Duration=10,Stats=new System.Collections.Generic.List<StatAmount>{new StatAmount{StatId="health_regen",Value=hpr}}});return definition;
        }
        var hotDefinition=Periodic(8,true);hotDefinition.Players[0].InitialHealth=9999.5;var hot=new ZatodBattleSimulation(hotDefinition);for(int i=0;i<4;i++)hot.Step();
        Check(hot.Statistics().Single(s=>s.Team==0).Healing==.5,"HoT caster attribution included overheal or was omitted");
        var poison=new ZatodBattleSimulation(Periodic(-8,false));for(int i=0;i<4;i++)poison.Step();
        Check(poison.Statistics().Single(s=>s.Team==0).DamageDealt==1 && poison.Statistics().Single(s=>s.Team==1).DamageTaken==1,"DoT not attributed to buff caster");

        var catalog=ImportedCatalog();var campaign=new CampaignCatalog(Read<CampaignDefinition>((BundledData+"/Campaigns.txt")),catalog);var account=campaign.CreateDemoCharacter(catalog);foreach(var h in account.HeroDesk)h.Level=40;
        var stage=campaign.Stage("chapter_one_stage_1");var initial=ZatodMatchFactory.Campaign(campaign,catalog,account,stage.Id,account.HeroDesk.Select(h=>h.HeroInstanceId),11,"stat-report");
        var baseline=new ZatodBattleSimulation(initial);while(!baseline.Finished){foreach(var u in baseline.Frame().Units.Where(u=>u.Team==0&&u.Alive))baseline.RequestUltimate(u.EntityId);baseline.Step();}
        var replay=baseline.Replay();Check(replay.Statistics.Count==initial.Players.Count+initial.Waves.Sum(w=>w.Enemies.Count),"Prior-wave units disappeared from report");
        Check(Math.Abs(replay.Statistics.Sum(s=>s.DamageDealt)-replay.Statistics.Sum(s=>s.DamageTaken))<1e-7,"Cross-wave dealt/taken totals differ");
        Check(replay.Statistics.Sum(s=>s.Kills)==baseline.DeathRecords().Count,"Kill report differs from deaths");
        var again=ZatodBattleSimulation.Resimulate(replay);Check(again.Digest==replay.Digest && again.Statistics.Zip(replay.Statistics).All(p=>p.First.DamageDealt==p.Second.DamageDealt && p.First.DamageTaken==p.Second.DamageTaken && p.First.Healing==p.Second.Healing && p.First.Kills==p.Second.Kills),"Replay statistics diverged");
        initial.LootDrops=ZatodCampaignLoot.Assign(initial,new[]{"iron_axe","iron_axe","small_stout_shield"});
        var bosses=initial.Waves.SelectMany(w=>w.Enemies).Where(e=>e.Boss).Select(e=>e.EntityId).ToArray();
        Check(initial.LootDrops.Count==3 && initial.LootDrops.All(d=>bosses.Length==0 || bosses.Contains(d.EntityId)),"Loot did not prefer bosses");
        var withPlan=new ZatodBattleSimulation(initial);foreach(var input in replay.Inputs){while(withPlan.CurrentTick<input.Tick-1)withPlan.Step();withPlan.QueueInput(input);withPlan.Step();}while(!withPlan.Finished)withPlan.Step();
        Check(withPlan.Replay().Digest==replay.Digest,"Adding a loot plan changed combat RNG/outcome");
        Check(withPlan.Replay().Initial.LootDrops.Count==3,"Replay lost its loot placement");
        Check(baseline.DeathRecords().Count==initial.Waves.Sum(w=>w.Enemies.Count),"Death records were pruned across waves");
    }
}
