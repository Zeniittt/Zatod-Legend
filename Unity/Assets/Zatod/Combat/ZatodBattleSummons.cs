using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        const int TeamSummonCap=12;
        int nextSummonEntityId;
        bool SummonsEnabled=>initial.RulesVersion==ZatodMatchDefinition.SummonRulesV6 || ExpandedRules;

        void ReleaseSummon(Unit caster,string skillId,ZatodSummonDefinition config,double x=double.NaN,double y=double.NaN)
        {
            if(caster.Summoner!=null || !caster.State.Alive)return;
            if(ExpandedRules && config.ReplaceExisting)
                foreach(var previous in units.Where(u=>u.Summoner==caster && u.SummonSkillId==skillId && u.State.Alive).ToArray())KillNativeSummon(previous);
            int team=caster.State.Team;
            int activeForSkill=units.Count(unit=>unit.Summoner==caster && unit.SummonSkillId==skillId && unit.State.Alive);
            int activeForTeam=units.Count(unit=>unit.Summoner!=null && unit.State.Team==team && unit.State.Alive);
            int count=Math.Min(config.Count-(ExpandedRules && config.StackOnRecast?0:activeForSkill),(ExpandedRules?int.MaxValue:TeamSummonCap)-activeForTeam);
            if(count<=0)return;

            bool clone=string.IsNullOrEmpty(config.MonsterId);
            var template=clone?caster.Data:initial.SummonUnits.FirstOrDefault(unit=>unit.DefinitionId==config.MonsterId &&
                (!ExpandedRules || !config.InheritLevelAndStars || unit.TemplateCasterId==caster.State.EntityId && unit.TemplateSkillId==skillId));
            if(template==null)throw new ArgumentException("Missing combat summon in match: "+config.MonsterId);
            if(nextSummonEntityId==0)
                nextSummonEntityId=initial.Players.Concat(initial.Waves.SelectMany(w=>w.Enemies)).Max(unit=>unit.EntityId);

            for(int index=0;index<count;index++)
            {
                var data=template.Copy();
                data.EntityId=checked(++nextSummonEntityId);
                data.SummonerId=caster.State.EntityId;
                data.Team=team;
                data.InitialEnergy=0;
                data.InitialHealth=-1;
                data.DamageMultiplier*=config.DamageMultiplier;
                data.DeathPresentation=ZatodDeathPresentation.FadeWithoutHold;
                data.Boss=false;
                data.Hero=false;
                data.AllowAutomaticUltimate=false;
                if(!ExpandedRules || !config.IncludeSkills)data.Battle.Skills.Clear();
                if(ExpandedRules)PrepareNativeSummonData(caster,skillId,data);
                if(data.Battle.HasNormalAttack)data.Battle.NormalAttack.Crystal.Summon=null;

                var unit=Create(data);
                unit.Summoner=caster;
                unit.SummonSkillId=skillId;
                unit.SummonTicks=ExpandedRules && config.Persistent?int.MaxValue:(int)Math.Ceiling(config.DurationSeconds/StepSeconds);
                unit.State.FacingRight=caster.State.FacingRight;
                unit.State.X=caster.State.X+Math.Max(24,caster.Data.Radius+data.Radius)*(unit.State.FacingRight?1:-1);
                unit.State.Y=caster.State.Y+(index-(count-1)/2d)*30;
                if(ExpandedRules && !double.IsNaN(x)){unit.State.X=x;unit.State.Y=y;}
                unit.PreviousX=unit.State.X;
                if(unit.Base.TryGetValue("health",out double health))unit.Base["health"]=health*config.HealthMultiplier;
                unit.State.MaxHp=unit.State.Hp=Math.Max(1,Get(unit,"health"));
                units.Add(unit);
                if(ExpandedRules)NpcSummoned(caster,skillId,unit);
            }
        }

        void AdvanceSummonLifetimes()
        {
            if(!SummonsEnabled)return;
            foreach(var unit in units)
                if(unit.Summoner!=null && unit.State.Alive && unit.SummonTicks!=int.MaxValue)unit.SummonTicks--;
            PruneSummons();
        }

        void PruneSummons()
        {
            if(!SummonsEnabled)return;
            if(ExpandedRules)
                foreach(var unit in units.Where(u=>u.Summoner!=null && u.State.Alive && (!u.Summoner.State.Alive || u.SummonTicks<=0)).ToArray())KillNativeSummon(unit);
            var gone=units.Where(unit=>unit.Summoner!=null &&
                ((!ExpandedRules && !unit.Summoner.State.Alive) || (unit.State.Alive?unit.SummonTicks<=0:unit.State.DeathElapsed>=unit.Data.DeathSeconds+1)))
                .Select(unit=>unit.State.EntityId).ToHashSet();
            if(gone.Count==0)return;
            units.RemoveAll(unit=>gone.Contains(unit.State.EntityId));
            shots.RemoveAll(shot=>gone.Contains(shot.ActorId));
            chains.RemoveAll(chain=>gone.Contains(chain.ActorId) || gone.Contains(chain.PreviousId));
            landings.RemoveAll(landing=>gone.Contains(landing.ActorId) || gone.Contains(landing.TargetId));
        }
        void KillNativeSummon(Unit unit)
        {
            if(!unit.State.Alive)return;
            unit.State.Hp=0;unit.State.Energy=0;unit.State.Action="Death";unit.State.ActionElapsed=unit.State.DeathElapsed=0;
            unit.State.DeathWave=wave+1;InterruptCast(unit);
            foreach(var buff in unit.Buffs.Where(b=>b.Definition.ClearOnDeath).ToArray())RemoveEvolutionBuff(unit,buff,false);
            UndyingSummonDied(unit);
            if(EvolutionRules)SoulOnDeath();RecordDeath(null,unit);
        }
    }
}
