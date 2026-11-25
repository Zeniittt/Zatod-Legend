using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        bool EvolutionRules=>initial.RulesVersion==ZatodMatchDefinition.SkillEvolutionRulesV4 ||
            initial.RulesVersion==ZatodMatchDefinition.WaveEntryRulesV5 || SummonsEnabled;
        double Evo(BattleSkillData skill,string field,double fallback=0)=>EvolutionRules?SkillEvolution.Value(skill.Definition,skill.Level,field,fallback):fallback;
        IEnumerable<SkillTriggeredEffect> Triggers(BattleSkillData skill,SkillEvolutionEvent when)=>!EvolutionRules?Enumerable.Empty<SkillTriggeredEffect>():SkillEvolution.Active(skill.Definition,skill.Level).SelectMany(x=>x.TriggeredEffects).Where(x=>x.Trigger==when);
        BattleSkillData Native(Unit actor,int source)=>actor.Skills.FirstOrDefault(x=>x.Definition.Crystal.SourceId==source)??
            (ExpandedRules?actor.NativeOriginalSkills?.FirstOrDefault(x=>x.Definition.Crystal.SourceId==source):null);
        static bool HasControl(ZatodBuffDefinition definition,string control)=>(definition.Control??"").Split(new[]{',',' ',';'},StringSplitOptions.RemoveEmptyEntries).Contains(control);
        static bool ConflictsWithUncontrollable(ZatodBuffDefinition definition)=>new[]{"frozen","stun","immoblilize","silence","disarm","imprisonment","enchanted","fear","taunt","polymorph","icefrozen"}.Any(x=>HasControl(definition,x));
        void EvolutionBuffAdded(Unit target,ActiveBuff buff)
        {
            if(HasControl(buff.Definition,"uncontrollable"))
                foreach(var old in target.Buffs.Where(x=>x!=buff && (x.CasterId!=target.State.EntityId && ConflictsWithUncontrollable(x.Definition) || x.Definition.Dispel=="YES" && Find(x.CasterId)?.State.Team!=target.State.Team)).ToArray())RemoveEvolutionBuff(target,old,false);
            if(HasControl(buff.Definition,"fear"))
            {
                // SF uses a five-degree cone opposite the victim's facing direction.
                double angle=(Random()*2-1)*5*Math.PI/180, direction=target.State.FacingRight?1:-1;
                double x=-direction*Math.Abs(Math.Cos(angle)),y=direction*Math.Sin(angle);
                x*=Math.Abs(x);y*=Math.Abs(y);double length=Math.Sqrt(x*x+y*y);
                buff.FearX=x/length;buff.FearY=y/length;
            }
        }
        bool MoveInFear(Unit actor,double dt)
        {
            var fear=actor.Buffs.LastOrDefault(x=>HasControl(x.Definition,"fear"));
            if(fear==null || Controlled(actor,"stable") || Controlled(actor,"immoblilize") || Controlled(actor,"stun") || Controlled(actor,"frozen") || Controlled(actor,"icefrozen") || actor.State.Height>0)return false;
            actor.State.X+=fear.FearX*Get(actor,"move_speed")/10*dt;
            actor.State.Y+=fear.FearY*Get(actor,"move_speed")/10*dt;
            if(actor.State.Action!="Move")actor.State.ActionElapsed=0;else actor.State.ActionElapsed+=dt;
            actor.State.Action="Move";return true;
        }
        double ShallowGrave(Unit target,double damage,double immunity)
        {
            var grave=target.Buffs.FirstOrDefault(x=>x.Definition.ShieldType=="shallowGrave");
            if(grave==null)return damage;
            double factor=Math.Max(0,1-immunity/100),maximum=Math.Max(0,target.State.Hp-1);
            if(damage*factor<=maximum)return damage;
            if(damage>maximum)
            {
                grave.Definition.ShieldValue-=damage-maximum;
                if(grave.Definition.ShieldValue<=0)RemoveEvolutionBuff(target,grave,false);
            }
            // The hit that exhausts the source shield still leaves one HP.
            return maximum/factor;
        }
        void EvolutionEvent(Unit actor,Unit target,BattleSkillData skill,SkillEvolutionEvent when,double power=0)
        {
            foreach(var effect in Triggers(skill,when))
            {
                if(effect.Chance<100 && Random()>=effect.Chance/100)continue;
                IEnumerable<Unit> targets=effect.Target==SkillEvolutionTarget.Caster?new[]{actor}:effect.Target==SkillEvolutionTarget.LivingAllies?units.Where(x=>x.State.Alive && x.State.Team==actor.State.Team):effect.Target==SkillEvolutionTarget.LivingEnemiesAroundCaster?units.Where(x=>x.State.Alive && x.State.Team!=actor.State.Team && Distance(actor,x)<=effect.Radius):new[]{target};
                foreach(var victim in targets.Where(x=>x!=null).OrderBy(x=>x.State.EntityId).ToArray())
                {
                    switch(effect.Effect)
                    {
                        case SkillEvolutionEffect.Buff:
                            if(victim.State.Alive)ApplyEvolutionBuff(actor,victim,skill,effect);
                            break;
                        case SkillEvolutionEffect.EnergySteal:
                            if(!Controlled(victim,"invulnerable")){victim.State.Energy=Math.Max(0,victim.State.Energy-effect.Amount);GainEnergy(actor,effect.Amount);}
                            break;
                        case SkillEvolutionEffect.DispelDebuffs:
                            foreach(var buff in victim.Buffs.Where(b=>b.Definition.Dispel=="YES" && Find(b.CasterId)?.State.Team!=victim.State.Team).ToArray())RemoveEvolutionBuff(victim,buff,false);
                            break;
                        case SkillEvolutionEffect.DependentSkill:
                            var definition=initial.SkillDependencies.Single(x=>x.Id==effect.SkillId).Copy();
                            var dependent=new BattleSkillData{Level=skill.Level,Definition=definition};
                            if(ExpandedRules && definition.Crystal.TrackType=="region")
                            {CreateRegion(actor,victim,dependent);break;}
                            if(effect.UseSkillPower){definition.Crystal.BasicAmount=power*effect.Ratio;definition.Crystal.PlusRatio=0;definition.Crystal.Growth.Clear();}
                            var hits=Affected(actor,victim,definition.Crystal).Where(x=>x.State.Alive).ToArray();
                            if(effect.ScaleByEnemyCount)
                            {definition.Crystal.BasicAmount*=hits.Length;definition.Crystal.PlusRatio*=hits.Length;}
                            foreach(var hit in hits)ApplySkill(actor,hit,dependent);
                            break;
                        case SkillEvolutionEffect.BasicAttack:
                            var basic=actor.Skills.FirstOrDefault(x=>x.SlotId=="basic");
                            if(basic!=null && victim.State.Alive)ApplySkill(actor,victim,basic);
                            break;
                        case SkillEvolutionEffect.ResetCooldown:
                            if(actor.Cooldowns.ContainsKey(effect.SkillId))actor.Cooldowns[effect.SkillId]=0;
                            break;
                    }
                }
            }
        }
        void ApplyEvolutionBuff(Unit actor,Unit target,BattleSkillData skill,SkillTriggeredEffect effect)
        {
            if(Controlled(target,"invulnerable") && target.State.Team!=actor.State.Team)return;
            ApplyBuff(actor,target,skill,effect.BuffId,effect.Duration,effect.Amount!=0 || effect.Ratio!=0?effect.Amount+effect.Ratio*Get(actor,"ability_power"):-1);
        }
        void ModifyEvolutionBuff(Unit actor,BattleSkillData skill,ZatodBuffDefinition definition,Dictionary<string,double> modifiers)
        {
            foreach(var p in SkillEvolution.Active(skill.Definition,skill.Level).SelectMany(x=>x.ParameterChanges))
            {
                if(p.BuffId!=0?p.BuffId!=definition.SourceId:definition.SourceId!=skill.Definition.Crystal.BuffId)continue;
                if(p.Field=="BuffDuration")definition.Duration=p.Mode==SkillParameterMode.Add?definition.Duration+p.Value:p.Value;
                if(p.Field=="BuffDurationBonus")definition.Duration+=p.Value;
                if(p.Field=="ShieldBonus")definition.ShieldValue=p.Mode==SkillParameterMode.Add?definition.ShieldValue+p.Value:p.Value;
                if(p.Field=="BuffStat")
                {
                    double value=p.Value+(string.IsNullOrEmpty(p.ScalingAttribute)?0:Get(actor,p.ScalingAttribute)*p.ScalingRatio);
                    modifiers[p.StatId]=p.Mode==SkillParameterMode.Add?(modifiers.TryGetValue(p.StatId,out double old)?old:0)+value:value;
                }
            }
            // Serpent petrification inherits the caster's unlocked ultimate vulnerability.
            if(definition.SourceId==10001603 && Native(actor,160) is BattleSkillData stone)
                foreach(var p in SkillEvolution.Active(stone.Definition,stone.Level).SelectMany(x=>x.ParameterChanges).Where(x=>x.Field=="BuffStat" && x.StatId=="physical_immunity"))modifiers[p.StatId]=p.Value;
        }
        void RemoveEvolutionBuff(Unit target,ActiveBuff buff,bool expired)
        {
            if(!target.Buffs.Remove(buff))return;
            RefreshNativeHealth(target);
            if(ExpandedRules)NpcBuffRemoved(target,buff,expired);
            if(!ExpandedRules && buff.Definition.SourceId==10004501)target.State.Team=buff.OriginalTeam;
            var actor=Find(buff.CasterId);
            if(!EvolutionRules || actor==null || buff.SourceSkill==null || !buff.MainSkillBuff || !target.State.Alive)return;
            EvolutionEvent(actor,target,buff.SourceSkill,SkillEvolutionEvent.BuffRemoved);
            if(expired)
            {
                EvolutionEvent(actor,target,buff.SourceSkill,SkillEvolutionEvent.BuffExpired);
                if(buff.SourceSkill.Definition.Crystal.SourceId==380 && !Controlled(target,"uncontrollable"))ApplyBuff(actor,target,buff.SourceSkill,10003803);
            }
        }
        void EvolutionHeal(Unit actor,Unit target,BattleSkillData skill,double power)
        {
            foreach(var effect in Triggers(skill,SkillEvolutionEvent.Hit).Where(x=>x.Effect==SkillEvolutionEffect.OverhealShield))
            {
                if(Controlled(target,"unheal"))continue;
                double amount=power*(1+Get(actor,"healing_bonus")/100)*(1+Math.Max(-1,Get(target,"heal_ratio")/100));
                if(target.State.Hp+amount<target.State.MaxHp)continue;
                var shield=target.Buffs.FirstOrDefault(x=>x.Definition.SourceId==effect.BuffId);
                if(shield!=null)shield.Definition.ShieldValue=Math.Min(effect.Maximum,shield.Definition.ShieldValue+amount);
                else if(!Controlled(target,"invulnerable"))ApplyBuff(actor,target,skill,effect.BuffId,-1,Math.Min(effect.Maximum,Math.Max(0,target.State.Hp+amount-target.State.MaxHp)));
            }
        }
        double EvolutionPower(Unit actor,Unit target,BattleSkillData skill,double power)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==172 && target.HitCounts.TryGetValue("bone",out int hits))power*=1+Evo(skill,"RepeatHitRatio")*Math.Min(Evo(skill,"RepeatHitMaximum"),hits);
            if(id==182 && Native(actor,183) is BattleSkillData exile && actor.MagicHits>0)
            {power*=1+Evo(exile,"MagicHitRatio")*Math.Min(Evo(exile,"MagicHitMaximum"),actor.MagicHits);actor.MagicHits=0;}
            if(id==192)power+=(actor.State.MaxHp-actor.State.Hp)*Evo(skill,"MissingHealthRatio");
            if(id==250)power*=Math.Clamp(400/Math.Max(.001,Distance(actor,target)),1,Evo(skill,"DistanceDamageCap",2));
            if(id==280 && target.State.Hp/target.State.MaxHp<.3)power*=Evo(skill,"ExecuteDamageRatio",2.5);
            return power;
        }
        void EvolutionHit(Unit actor,Unit target,BattleSkillData skill,double power)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==172 && Evo(skill,"RepeatHitRatio")>0)
            {target.HitCounts["bone"]=target.HitCounts.TryGetValue("bone",out int old)?old+1:1;}
            if(id==163 && target.State.Alive && !Controlled(target,"invulnerable"))
            {double energy=Arg(skill.Definition.Crystal,2);target.State.Energy=Math.Max(0,target.State.Energy-energy);GainEnergy(actor,energy);}
            EvolutionEvent(actor,target,skill,SkillEvolutionEvent.Hit,power);
        }
        void EvolutionCastFinished(Unit actor,BattleSkillData skill)
        {
            EvolutionEvent(actor,Find(actor.Cast?.TargetId??0),skill,SkillEvolutionEvent.CastFinish);
            if(skill.Definition.Crystal.SourceId==283)
            {actor.CounterCooldown=Evo(skill,"CounterCooldown",.375);Heal(actor,actor.State.MaxHp*Evo(skill,"CounterHealPercent")/100,actor);}
        }
        void EvolutionDamaged(Unit actor,Unit target,string type)
        {
            foreach(var buff in target.Buffs.Where(x=>x.SourceSkill!=null).ToArray())
            {
                if(type=="AP" && Triggers(buff.SourceSkill,SkillEvolutionEvent.Hit).Any(x=>x.Effect==SkillEvolutionEffect.CollectMagicHits))
                {var caster=Find(buff.CasterId);if(caster!=null)caster.MagicHits++;}
            }
            if(type=="AD" && actor.State.Alive)
            {
                foreach(var skill in target.Skills)EvolutionEvent(target,actor,skill,SkillEvolutionEvent.PhysicalDamageReceived);
                var counter=Native(target,283);
                bool pending=target.Cast!=null && target.Cast.Skill.Definition.Crystal.Phases.Sum(x=>x.AttackTimes.Count)>target.Cast.AttackCounter;
                if(counter!=null && target.CounterCooldown<=0 && !pending && Random()<Evo(counter,"CounterChance",40)/100)
                {target.Cooldowns[counter.Definition.Id]=0;target.GlobalCooldown=0;}
            }
        }
        bool LifeInsight(Unit target)
        {
            var skill=Native(target,203);
            if(skill==null || target.LifeInsightUsed)return false;
            target.LifeInsightUsed=true;target.State.Hp=1;target.State.Energy=0;InterruptCast(target);
            foreach(var b in target.Buffs.Where(x=>x.CasterId!=target.State.EntityId).ToArray())RemoveEvolutionBuff(target,b,false);
            ApplyBuff(target,target,skill,10002005);
            ApplySkill(target,target,skill);
            EvolutionEvent(target,target,skill,SkillEvolutionEvent.FirstLethalDamage);
            return true;
        }
        int Multicast(BattleSkillData skill)
        {
            double roll=Random()*100,four=Evo(skill,"MulticastFourChance",10);
            return roll<40?1:roll<80-four?2:roll<100-four?3:4;
        }
        Unit[] MulticastTargets(Unit actor,BattleSkillData skill)
        {
            int count=Multicast(skill);
            return units.Where(x=>x.State.Alive && CampMatches(actor,x,skill.Definition.Crystal.AffectedCamp) && !Controlled(x,"untargetable"))
                .Select(x=>new{Unit=x,Roll=Random()}).OrderByDescending(x=>x.Roll).ThenBy(x=>x.Unit.State.EntityId).Take(count).Select(x=>x.Unit).ToArray();
        }
        void SoulOnDeath()
        {
            foreach(var unit in units.Where(x=>x.State.Alive))
            {var soul=Native(unit,253);if(soul!=null)ApplySkill(unit,unit,soul);}
        }
    }
}
