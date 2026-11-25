using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void PrepareNativeSummonData(Unit caster,string skillId,ZatodUnitData data)
        {
            if(data.SourceId==266)
            {
                data.DamageMultiplier=caster.Data.DamageMultiplier;
                var passive=Native(caster,1763);
                foreach(var skill in data.Battle.Skills)skill.Level=passive?.Level??Native(caster,1762).Level;
                return;
            }
            if(data.SourceId is 249 or 250)data.DamageMultiplier=caster.Data.DamageMultiplier;
            if(data.SourceId is 214 or 215)data.DamageMultiplier=caster.Data.DamageMultiplier;
            if(data.SourceId!=128)return;
            var strike=Native(caster,433);var burn=Native(caster,434);
            data.Battle.Skills.RemoveAll(s=>s.Definition.Crystal.SourceId==10035 && strike==null || s.Definition.Crystal.SourceId==10036 && burn==null);
            foreach(var skill in data.Battle.Skills)
            {
                if(skill.Definition.Crystal.SourceId==10035)
                {skill.Level=strike.Level;skill.Definition.Crystal.PlusRatio=Evo(strike,"InfernalAttackRatio",skill.Definition.Crystal.PlusRatio);}
                if(skill.Definition.Crystal.SourceId==10036){skill.Level=burn.Level;skill.Definition.Crystal.TriggerOnly=true;}
            }
        }
        void NpcSummoned(Unit caster,string skillId,Unit unit)
        {
            if(unit.Data.SourceId==266){DruidSummoned(caster,unit);return;}
            if(unit.Data.SourceId is 249 or 250){BroodSummoned(caster,skillId,unit);return;}
            if(unit.Data.SourceId is 214 or 215){UndyingSummoned(caster,skillId,unit);return;}
            if(unit.Data.SourceId is 129 or 130){TerrorMirrorStats(caster,skillId,unit);return;}
            if(unit.Data.SourceId!=128)return;
            var skill=caster.Skills.Single(s=>s.Definition.Id==skillId);
            var inherited=ZatodMatchFactory.CopyBuff(buffs[10004308]);
            foreach(var scaling in inherited.Scaling)scaling.Ratio=Arg(skill.Definition.Crystal,3)/100;
            ApplyBuff(caster,unit,skill,10004308,overrideDefinition:inherited);
            unit.State.MaxHp=unit.State.Hp=Math.Max(1,Get(unit,"health"));unit.State.MaxEnergy=Math.Max(1,Get(unit,"energy_max"));
            unit.State.HealthBar=new ZatodHealthBarState(1);
            if(Native(unit,10036)!=null)ApplyBuff(caster,unit,skill,10004305);
            if(Evo(skill,"InfernalGuard")>0)ApplyBuff(caster,unit,skill,10004307);
            if(unit.Data.BirthSeconds>0){unit.BirthRemaining=unit.Data.BirthSeconds;unit.State.Action="Birth";unit.State.ActionElapsed=0;}
        }
        void NpcCreateShot(Unit caster,Unit target,Shot shot)
        {
            TuskCreateShot(caster,target,shot);
            if(shot.Skill.Definition.Crystal.SourceId==11100){shot.Tinker=true;shot.TrackTarget=true;}
            BroodCreateShot(caster,target,shot);
            if(shot.Skill.Definition.Crystal.SourceId==553){shot.Bounces=5;shot.TrackTarget=true;}
            if(shot.Skill.Definition.Crystal.SourceId==817){shot.Bounces=9;shot.TrackTarget=true;}
            if(shot.Skill.Definition.Crystal.SourceId!=430)return;
            double direction=caster.State.FacingRight?1:-1,x=target.State.X-60*direction;
            shot.NativeSummonX=x>=800?750:x<=0?50:x;shot.NativeSummonY=target.State.Y;
            shot.X=caster.State.X;shot.Y=caster.State.Y;shot.Height=300;shot.TrackTarget=true;
            double dx=shot.NativeSummonX-shot.X,dy=shot.NativeSummonY-shot.Y,length=Math.Sqrt(dx*dx+dy*dy+90000);
            shot.VX=dx/length*900;shot.VY=dy/length*900;shot.VZ=-300/length*900;
        }
        void NpcImpact(Unit caster,Shot shot)
        {
            var config=shot.Skill.Definition.Crystal.Summon;
            if(shot.SummonSpawned || config?.Enabled!=true || !config.AtImpact)return;
            shot.SummonSpawned=true;
            ReleaseSummon(caster,shot.Skill.Definition.Id,config,shot.NativeSummonX,shot.NativeSummonY);
        }
    }
}
