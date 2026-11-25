using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void EnterNativeForm(Unit actor,BattleSkillData owner,ZatodBattleFormDefinition formOverride=null)
        {
            var form=formOverride??owner.Definition.Crystal.NativeForm;if(form?.Enabled!=true)throw new InvalidOperationException("Missing source battle form.");
            actor.NativeOriginalSkills=actor.Skills;actor.NativeForm=form.Copy();
            int formSkill=owner.Definition.Crystal.SourceId;
            if(actor.Data.Hero && (formSkill==470 || formSkill==810 || formSkill==1220))actor.State.EnergyCostSinceTick=tick;
            actor.NativeOriginalRange=Get(actor,"attack_range");
            actor.NativeOriginalDeathSeconds=actor.Data.DeathSeconds;actor.NativeOriginalHurtSeconds=actor.Data.HurtSeconds;
            var active=new List<BattleSkillData>();
            foreach(int source in form.ActiveSkillSourceIds)
            {
                var previous=actor.NativeOriginalSkills.FirstOrDefault(s=>s.Definition.Crystal.SourceId==source);
                BattleSkillData skill;
                if(previous!=null)skill=new BattleSkillData{SlotId=previous.SlotId,IsUltimate=previous.IsUltimate,Level=previous.Level,Definition=previous.Definition.Copy()};
                else
                {
                    var definition=initial.SkillDependencies.Single(s=>s.Crystal.SourceId==source).Copy();
                    var parent=actor.NativeOriginalSkills.FirstOrDefault(s=>s.Definition.Crystal.SourceId==definition.Crystal.LevelSourceId);
                    if(parent==null)continue;
                    skill=new BattleSkillData{Level=parent.Level,Definition=definition};
                    foreach(var growth in skill.Definition.Crystal.Growth)
                        if(growth.Field.StartsWith("Script Arg",StringComparison.Ordinal) && int.TryParse(growth.Field.Substring(10),out int arg) && arg>0 && arg<=skill.Definition.Crystal.ScriptArgs.Count)
                            skill.Definition.Crystal.ScriptArgs[arg-1]+=(skill.Level-1)*growth.Amount;
                    SkillEvolution.ApplyParameters(skill.Definition,skill.Level);
                }
                PrepareNativeFormSkill(actor,skill);
                var phases=form.SkillPhases.FirstOrDefault(p=>p.SourceId==source);
                if(phases!=null)skill.Definition.Crystal.Phases=phases.Phases.ConvertAll(p=>p.Copy());
                if(source==form.BasicSourceId)skill.SlotId="basic";
                actor.Cooldowns[skill.Definition.Id]=skill.Definition.Crystal.InitialCooldown;active.Add(skill);
            }
            actor.Skills=active.OrderByDescending(s=>s.Definition.Crystal.Priority).ThenBy(s=>s.Definition.Crystal.Slot).ToList();
            actor.Base["attack_range"]=Math.Max(0,actor.Skills.Single(s=>s.SlotId=="basic").Definition.Crystal.MaxRange-5)*10;
            actor.State.Resource=form.Resource;actor.State.AnimationSetResource=form.AnimationSetResource;actor.State.ArtScale=form.ArtScale;
            if(form.DeathSeconds>0)actor.Data.DeathSeconds=form.DeathSeconds;
            if(form.HurtSeconds>0)actor.Data.HurtSeconds=form.HurtSeconds;
        }
        void ExitNativeForm(Unit actor)
        {
            if(actor.NativeOriginalSkills==null)return;
            FinishSpecial(actor);InterruptCast(actor);actor.Skills=actor.NativeOriginalSkills;actor.NativeOriginalSkills=null;actor.NativeForm=null;
            actor.State.EnergyCostSinceTick=-1;
            foreach(var skill in actor.Skills)actor.Cooldowns[skill.Definition.Id]=skill.Definition.Crystal.InitialCooldown;
            actor.Base["attack_range"]=actor.NativeOriginalRange;
            actor.Data.DeathSeconds=actor.NativeOriginalDeathSeconds;actor.Data.HurtSeconds=actor.NativeOriginalHurtSeconds;
            var ult=Native(actor,610);if(ult!=null)actor.Cooldowns[ult.Definition.Id]=0;
            actor.State.Resource=actor.Data.Resource;actor.State.AnimationSetResource=actor.Data.AnimationSetResource;actor.State.ArtScale=actor.Data.ArtScale;
            if(actor.State.Alive){actor.State.Action="Idle";actor.State.ActionElapsed=0;}
            actor.PhantomSureCrit=0;
        }
        void NpcFormStart(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==810)ApplyBuff(actor,actor,skill,10008102);
            if(id==817)SceneEffect("eff_point_Luna_night.cha",actor,400,0,ZatodBuffEffectLayer.WorldActors);
            if(id==610)ApplyBuff(actor,actor,skill,10006103);
            if(id!=611)return;
            bool critical=actor.PhantomSureCrit>0;
            if(critical)actor.PhantomSureCrit--;
            else
            {
                double defense=Math.Max(0,Get(target,"defense")-Get(actor,"armor_penetration"));
                double extra=actor.Buffs.Sum(b=>b.Modifiers.GetValueOrDefault("physical_crit"));
                critical=Random()<(Get(actor,"physical_crit")+extra-Get(target,"physical_crit_resistance"))/(100+defense*8);
            }
            actor.PhantomCritical=critical;actor.Cast.Phase=critical?2:Random()<.5?0:1;
            skill.Definition.Crystal.ImpactEffect=critical?initial.SkillDependencies.Single(s=>s.Crystal.SourceId==611).Crystal.ImpactEffect:"eff_impact_slash.cha";
            actor.State.Action=skill.Definition.Crystal.Phases[actor.Cast.Phase].Action;
        }
        void NpcPhaseFinished(Unit actor,BattleSkillData skill,int phase)
        {
            if(skill.Definition.Crystal.SourceId==684)
            {
                if(phase==1){actor.LegionCharging=true;actor.LegionVelocity=(actor.State.FacingRight?1:-1)*480;}
                if(phase==2)actor.LegionCharging=false;
            }
            if(skill.Definition.Crystal.SourceId!=610 || phase!=0)return;
            var target=Find(actor.Cast.TargetId)??ClosestEnemy(actor);if(target==null)return;
            double direction=target.State.X>actor.State.X?1:-1,x=target.State.X+direction*70;
            if(Controlled(target,"stable") || x>799 || x<1)x=Math.Clamp(x-direction*140,1,799);
            actor.State.X=x;actor.State.Y=target.State.Y;actor.PhantomTransformPending=true;
            ApplyBuff(actor,actor,skill);
            if(Evo(skill,"PhantomGuardBuff")>0)ApplyBuff(actor,actor,skill,(int)Evo(skill,"PhantomGuardBuff"));
        }
        void NpcFormFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            LycanFinish(actor,skill);
            if(id==611)actor.PhantomCritical=false;
            if(id!=610)return;
            if(actor.PhantomTransformPending)
            {
                actor.PhantomTransformPending=false;EnterNativeForm(actor,skill);
                var basic=actor.Skills.Single(s=>s.SlotId=="basic");basic.Definition.Crystal.Cooldown=basic.Definition.Crystal.GlobalCooldown=0;
                actor.Cooldowns[basic.Definition.Id]=0;actor.GlobalCooldown=0;actor.PhantomSureCrit=3;
            }
            foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10006103).ToArray())RemoveEvolutionBuff(actor,buff,false);
        }
    }
}
