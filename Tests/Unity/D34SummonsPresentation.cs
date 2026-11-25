// Run with Unity Pipeline in the isolated build workspace while in Play Mode.
using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

public static class D34SummonsPresentation
{
    static void Require(bool passed,string message)
    {
        if(!passed)throw new InvalidOperationException(message);
    }

    public static object Run(string report) => RunCore(report,false);
    public static object RunNative(string report) => RunCore(report,true);
    static object RunCore(string report,bool native)
    {
        Require(EditorApplication.isPlaying && Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"),
            "Run this fixture in Play Mode in the isolated Zatod workspace.");
        var results=new[]{CheckSpawn(false,native),CheckSpawn(true,native)};
        var result=new{State="PASS",Native=native,Checks=results};
        File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
        return result;
    }

    [Serializable] public sealed class CheckResult
    {
        public string Kind,DefinitionId;
        public int SpawnTick,ExpiryTick,Count,SkillLevel;
        public ulong Digest;
    }

    static CheckResult CheckSpawn(bool named,bool native)
    {
        var data=HeroDataJson.LoadBundledCatalog().Data;
        data.UseExpandedCombatRules=native;
        var caster=data.Heroes.First(unit=>!string.IsNullOrEmpty(unit.AnimationSetResource));
        var opponent=data.Heroes.First(unit=>unit.Id!=caster.Id && !string.IsNullOrEmpty(unit.AnimationSetResource));
        var monster=data.Monsters.First(unit=>!string.IsNullOrEmpty(unit.AnimationSetResource));
        var basic=data.Skills.First(skill=>skill.Id==caster.NormalAttackSkillId);
        basic.Crystal.MaxRange=9000;
        basic.Crystal.MinRange=0;
        basic.Crystal.Cooldown=60;
        basic.Crystal.TargetType="target";
        basic.Crystal.TrackType=null;
        basic.Crystal.DamageType=null;
        basic.Crystal.LaunchEffect=null;
        basic.Crystal.PointEffect=null;
        basic.Crystal.ImpactEffect=null;
        basic.Crystal.Summon=new ZatodSummonDefinition{Enabled=true,MonsterId=named?monster.Id:null,DurationSeconds=.5};
        var catalog=new HeroCatalog(data);
        var left=catalog.CreateHero(caster.Id,"summon-fixture-left");
        var right=catalog.CreateHero(opponent.Id,"summon-fixture-right");
        var match=ZatodMatchFactory.Versus(catalog,new[]{left},new[]{right},117,"summon-presentation",true);
        var player=match.Players[0];
        var summoningSkill=player.Battle.NormalAttack.Copy();
        summoningSkill.Id="fixture_call";
        summoningSkill.Crystal.Priority=10000;
        summoningSkill.Evolutions.Clear();
        summoningSkill.Evolutions.Add(new SkillEvolutionDefinition
        {
            Id="fixture_count_and_lifetime",Description="Summon an extra unit for longer.",RequiredSkillLevel=60,
            ParameterChanges=
            {
                new SkillParameterChange{Field="SummonCount",Mode=SkillParameterMode.Add,Value=1},
                new SkillParameterChange{Field="SummonDurationSeconds",Mode=SkillParameterMode.Add,Value=.5}
            }
        });
        player.Battle.NormalAttack.Crystal.Summon=null;
        player.Battle.Skills.Clear();
        player.Battle.Skills.Add(new BattleSkillData{SlotId="fixture_call",Definition=summoningSkill,Level=60});
        match.Waves[0].Enemies[0].Battle.Skills.Clear();
        match.Waves[0].Enemies[0].Battle.HasNormalAttack=false;
        var wire=JsonUtility.FromJson<ZatodMatchDefinition>(JsonUtility.ToJson(match));
        Require(wire.RulesVersion==(native?ZatodMatchDefinition.ExpandedRulesV7:ZatodMatchDefinition.SummonRulesV6),"Unity snapshot did not preserve the selected summon rules.");
        if(named)Require(wire.SummonUnits.Single().DefinitionId==monster.Id,"Unity snapshot lost the named summon template.");

        var root=new GameObject("D34 summon presentation fixture");
        try
        {
            var stage=root.AddComponent<ZatodBattleStage>();
            var sim=new ZatodBattleSimulation(wire);
            stage.Draw(sim.Frame(),sim,0,0,false,false);
            Require(stage.UnitCount==2,"Expected two roster actors before the summon.");

            var summons=Array.Empty<ZatodUnitState>();
            for(int i=0;i<64 && summons.Length==0;i++)
            {
                sim.Step();
                summons=sim.Frame().Units.Where(unit=>unit.SummonerId!=0).ToArray();
            }
            Require(summons.Length==2 && summons.All(unit=>unit.SummonTicks==8),
                "The serialized level-60 evolution did not confer two summons for eight ticks.");
            int spawn=sim.CurrentTick;
            stage.Draw(sim.Frame(),sim,0,0,false,false);
            Require(stage.UnitCount==4,"The stage did not add two summon renderers.");
            foreach(var summon in summons)
            {
                var actor=stage.transform.Find("Hero_"+summon.EntityId);
                Require(actor!=null,"The stage did not add a summon renderer.");
                var sprite=actor.GetComponent<ZatodBattleSprite>();
                Require(sprite!=null && sprite.Renderer.sprite!=null && sprite.Renderer.enabled,
                    "The summon does not render its idle sprite.");
                Require(!actor.GetComponent<BoxCollider2D>().enabled,"A summon could be clicked for manual control.");
            }

            for(int i=0;i<8;i++)sim.Step();
            stage.Draw(sim.Frame(),sim,0,0,false,false);
            if(native)
            {
                var corpses=sim.Frame().Units.Where(unit=>unit.SummonerId!=0).ToArray();
                Require(corpses.Length==2 && corpses.All(unit=>!unit.Alive && unit.DeathPresentation==ZatodDeathPresentation.FadeWithoutHold),"Native summon expiry did not retain its source death/fade presentation");
                for(int i=0;i<48;i++)sim.Step();
                stage.Draw(sim.Frame(),sim,0,0,false,false);
            }
            Require(stage.UnitCount==2 && sim.Frame().Units.All(unit=>unit.SummonerId==0),"The summon was not removed after its applicable expiry/death presentation.");
            var captured=sim.Replay();
            var roundtrip=JsonUtility.FromJson<ZatodReplay>(JsonUtility.ToJson(captured));
            Require(ZatodBattleSimulation.Resimulate(roundtrip).Digest==captured.Digest,
                "A replay serialized by Unity did not preserve the summon result.");
            return new CheckResult{Kind=named?"Named monster":"Caster clone",DefinitionId=summons[0].DefinitionId,
                SpawnTick=spawn,ExpiryTick=sim.CurrentTick,Count=summons.Length,SkillLevel=60,Digest=captured.Digest};
        }
        finally
        {
            UnityEngine.Object.Destroy(root);
        }
    }
}
