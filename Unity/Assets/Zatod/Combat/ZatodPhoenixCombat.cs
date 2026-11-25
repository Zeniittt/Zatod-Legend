using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        bool PhoenixLethal(Unit actor)
        {
            var passive=Native(actor,524);
            if(passive==null || actor.PhoenixEgg || actor.PhoenixRebirths>=3 || actor.Buffs.Any(b=>b.Definition.SourceId is 1099 or 4125))return false;
            FinishSpecial(actor);InterruptCast(actor);actor.QueuedUltimate=false;actor.PhoenixRebirths++;actor.PhoenixEgg=true;
            actor.State.Hp=(Evo(passive,"PhoenixEggHitBonus")>0?7:6)-actor.PhoenixRebirths;actor.State.Energy=0;
            foreach(var buff in actor.Buffs.Where(b=>b.CasterId!=actor.State.EntityId || b.Definition.SourceId==10005205).ToArray())RemoveEvolutionBuff(actor,buff,false);
            foreach(int id in new[]{10005209,10005206,10005203,10005207,10006509,10005208})ApplyBuff(actor,actor,passive,id);
            Start(actor,passive,Target(actor,passive.Definition.Crystal,actor)??actor);return true;
        }
        void PhoenixBuffAdded(Unit actor,ActiveBuff buff)
        {
            if(buff.Definition.SourceId==10005205)buff.Modifiers["health_regen"]=-actor.State.MaxHp*.15;
            if(buff.Definition.SourceId!=10005201)return;
            var basic=Native(actor,521);if(basic==null)return;
            actor.PhoenixBasic=basic.Definition.Copy();
            var info=basic.Definition.Crystal;info.ProjectileArt="eff_tile_Phoenix_atk2.cha";info.AoeOrigin="target";info.AoeShape="circle";info.ShapeArg1=100;
            info.PointEffect="eff_point_burst.cha";info.DamageType="AP";info.PlusAttribute="AP";info.PlusRatio=Evo(buff.SourceSkill,"PhoenixBasicRatio",.6);
        }
        void PhoenixBuffRemoved(Unit actor,ActiveBuff buff)
        {
            if(buff.Definition.SourceId==10005201 && actor.PhoenixBasic!=null)
            {var basic=Native(actor,521);if(basic!=null)basic.Definition=actor.PhoenixBasic;actor.PhoenixBasic=null;}
            if(buff.Definition.SourceId==10005206)
            {
                actor.PhoenixEgg=false;
                if(actor.State.Alive)
                {
                    var skill=Native(actor,524);double previous=actor.State.Hp;
                    actor.State.Hp=Math.Clamp((Arg(skill.Definition.Crystal,2)+Evo(skill,"PhoenixRebirthHealth"))*actor.Data.HpMultiplier,1,actor.State.MaxHp);
                    RecordHealing(actor,actor.State.Hp-previous);
                }
                foreach(var old in actor.Buffs.Where(b=>b.Definition.SourceId is 10006509 or 10006503 or 10006508))old.Remaining=0;
            }
            if(buff.Definition.SourceId==10005208 && actor.State.Alive && !actor.PhoenixEgg && Native(actor,523) is BattleSkillData impact)
            {
                var target=Target(actor,impact.Definition.Crystal,ClosestEnemy(actor));
                if(target!=null){FinishSpecial(actor);InterruptCast(actor);Start(actor,impact,target);}
            }
        }
    }
}
