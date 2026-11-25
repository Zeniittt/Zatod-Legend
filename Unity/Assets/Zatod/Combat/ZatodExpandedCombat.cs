using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        bool ExpandedRules=>initial.RulesVersion==ZatodMatchDefinition.ExpandedRulesV7;
        bool HiddenFrom(Unit observer,Unit target)=>ExpandedRules && observer.State.Team!=target.State.Team && Controlled(target,"stealth") && !Controlled(target,"antistealth");
        static bool NativeControlIncludes(string control,string effect)
        {
            // Recovered battle/buff.lua effect_inclusions, including transitive
            // stun effects. Keep this out of the archived V3–V6 rules.
            if(control is "imprisonment" or "imprisonmentbyself")
                return effect is "stun" or "untargetable" or "invulnerable" or "immoblilize" or "silence" or "disarm" or "disableAI";
            if(control is "frozen" or "icefrozen")
                return effect is "stun" or "immoblilize" or "silence" or "disarm" or "disableAI";
            if(control is "stun" or "stunbyself")return effect is "immoblilize" or "silence" or "disarm" or "disableAI";
            if(control=="fear")return effect is "silence" or "disarm" or "disableAI";
            if(control=="building")return effect is "stable" or "fix";
            return control=="building_notfix" && effect=="stable" || control=="silencebyself" && effect=="silence";
        }
        double PassiveContribution(Unit recipient,BattleSkillData skill,string stat,Unit source=null)
        {
            var info=skill.Definition.Crystal;
            if(ExpandedRules && info.PassiveStatRatios?.Count>0)
                return BasicAmount(skill)*((info.PassiveStatRatios.FirstOrDefault(s=>s.StatId==stat)?.Value??0)+
                    (stat=="damage" && info.PassiveExtraDamageTargets?.Contains(recipient.Data.SourceId)==true?1:0));
            return Attribute(info.PassiveAttribute)==stat?BasicAmount(skill)+(ExpandedRules && info.SourceId==314?(source??recipient).AuraExtraDamage:0):0;
        }
        void ExpandedSetup(Unit unit)
        {
            if(!ExpandedRules)return;
            if(unit.Skills.Any(s=>s.Definition.Crystal.ReplacesBasic))unit.Skills.RemoveAll(s=>s.SlotId=="basic");
            foreach(var skill in unit.Skills)
            {
                int id=skill.Definition.Crystal.SourceId;
                if(id==320 && Evo(skill,"FirstCastEnergy")>0)skill.Definition.Crystal.CostEnergy=Evo(skill,"FirstCastEnergy");
                if(id is 104 or 234)
                {
                    var basic=unit.Skills.FirstOrDefault(s=>s.SlotId=="basic");
                    if(basic!=null && Evo(skill,"BasicCooldown")>0)
                    {basic.Definition.Crystal.Cooldown=Evo(skill,"BasicCooldown");basic.Definition.Crystal.GlobalCooldown=Evo(skill,"BasicGlobalCooldown");}
                }
                if(id==375 && Evo(skill,"BasicGainEnergy")>0)
                {var basic=unit.Skills.FirstOrDefault(s=>s.SlotId=="basic");if(basic!=null)basic.Definition.Crystal.GainEnergy+=Evo(skill,"BasicGainEnergy");}
            }
            unit.DispelAnchorHp=unit.State.Hp;
            NpcSetup(unit);
        }
        void ExpandedBeginWave()
        {
            if(!ExpandedRules)return;
            foreach(var actor in units.OrderBy(u=>u.State.EntityId))
                if(!actor.AuraInitialized)
                {
                    actor.AuraInitialized=true;
                    if(Native(actor,314) is BattleSkillData aura)actor.AuraExtraDamage=Get(actor,"damage")*Evo(aura,"AuraBaseStatPercent")/100;
                }
        }
        bool ExpandedCanCast(Unit unit,BattleSkillData skill)
        {
            if(!ExpandedRules)return true;
            int id=skill.Definition.Crystal.SourceId;
            if(skill.Definition.Crystal.DamageType=="AD"?Controlled(unit,"disarm"):Controlled(unit,"silence"))return false;
            if(Controlled(unit,"doom") && skill.SlotId!="basic" && !skill.Definition.Crystal.ReplacesBasic)return false;
            if(id==610 && unit.NativeForm!=null || id==614 && unit.Buffs.Any(b=>b.Definition.SourceId==10006102))return false;
            if(id==650 && (unit.DoomActive || unit.State.Energy<500))return false;
            if(id==810 && (unit.NativeForm!=null || unit.State.Energy<1000))return false;
            if(id==470 && (unit.TerrorDemon || unit.TerrorTransforming || unit.State.Energy<1000))return false;
            if(id==473 && (unit.TerrorSunderUsed || unit.State.Hp/unit.State.MaxHp>=.3))return false;
            if(id==1220 && (unit.NativeForm!=null || unit.State.Energy<700 || unit.Cast?.Skill.Definition.Crystal.SourceId==1220))return false;
            if(id==1280 && initial.Mode==ZatodMode.RealtimePvp && Native(unit,1284)!=null && unit.MonkQi<3)return false;
            if(id==1762 && DruidBear(unit)?.DruidBearDying==true)return false;
            if(id==1490 && unit.BroodHasNest)return false;
            if(id is 680 or 684 && unit.LegionCharging || id==680 && unit.Cast?.Skill.Definition.Crystal.SourceId==684)return false;
            return !skill.Definition.Crystal.TriggerOnly && (!skill.IsUltimate || !Controlled(unit,"unmanual")) && (id!=213 || units.Count(u=>u.State.Alive && u.State.Team!=unit.State.Team)>1) &&
                (id!=490 || !unit.Buffs.Any(b=>b.Definition.SourceId==10004901));
        }
        bool CanReleaseCharge(Unit actor)=>!finished && waveEntryTicks==0 && ExpandedRules && actor!=null && Manual(actor) && actor.Cast?.Skill.Definition.Crystal.SourceId==390 &&
            actor.Cast.AttackCounter==1 && CanAct(actor) && !Controlled(actor,"silence");
        void ReleaseCharge(Unit actor)
        {
            var cast=actor.Cast;var info=cast.Skill.Definition.Crystal;
            var target=Find(cast.TargetId)??ClosestEnemy(actor);
            cast.ChargeRatio=Math.Clamp((cast.Elapsed-cast.ChargeBegin)/5,0,1);
            cast.AttackCounter=2;
            if(target!=null)Release(actor,target,cast.Skill,Math.Min(1,info.Phases[cast.Phase].AttackTimes.Count-1));
            cast.Event=Math.Min(2,info.Phases[cast.Phase].AttackTimes.Count);
            if(cast.Event>0)cast.Elapsed=info.Phases[cast.Phase].AttackTimes[cast.Event-1];
            actor.State.ActionElapsed=cast.Elapsed;
        }
        void ExpandedStart(Unit actor,Unit target,BattleSkillData skill)
        {
            if(!ExpandedRules)return;
            int id=skill.Definition.Crystal.SourceId;
            NpcFormStart(actor,target,skill);
            TerrorStart(actor,skill);
            PudgeStart(actor,skill);
            LegionStart(actor,skill);
            ClockwerkStart(actor,target,skill);
            UndyingStart(actor,skill);
            MarsStart(actor,skill);
            MonkStart(actor,skill);
            DancerStart(actor,skill);
            DruidStart(actor,skill);
            BroodStart(actor,target,skill);
            if(id==520)ApplyBuff(actor,actor,skill,10005205);
            if(id==650)SceneEffect("eff_point_DOOM_ult.cha",actor,400,0,ZatodBuffEffectLayer.BehindBattlefieldActors);
            if(id==510)ApplyBuff(actor,actor,skill,10005104);
            if(id==550)ApplyBuff(actor,actor,skill,10005503);
            if(id is 950 or 953)ApplyBuff(actor,actor,skill,10009504);
            if(id==332)actor.State.X=actor.Data.Team==0?-50:850;
            if(id==503)actor.State.X=actor.Data.Team==0?-50:850;
            if(id==462)
            {
                if(Math.Abs(target.State.X-actor.State.X)>120)ApplyBuff(actor,actor,skill,10004602);
                else {actor.Cast.Phase=1;actor.State.Action=skill.Definition.Crystal.Phases[1].Action;actor.State.ActionElapsed=0;}
            }
            if(id==340)ApplyBuff(actor,actor,skill,10003406);
            if(id==342)Damage(actor,actor,actor.State.Hp*Arg(skill.Definition.Crystal,2)/100,"Holy",0);
            if(id==310)
            {
                SceneEffect("eff_point_Luna_moon.cha",actor,actor.State.X,actor.State.Y,ZatodBuffEffectLayer.AboveBattlefield,actor.State.FacingRight);
                SceneEffect("eff_point_Luna_night.cha",actor,400,0,ZatodBuffEffectLayer.WorldActors);
            }
        }
        bool ExpandedRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            if(!ExpandedRules)return false;
            if(NpcRelease(actor,target,skill))return true;
            var info=skill.Definition.Crystal;var cast=actor.Cast;
            if(info.SourceId==503 && cast.AttackCounter==1)return true;
            if(info.SourceId==460 && cast.AttackCounter==1)
            {
                double direction=actor.State.FacingRight?1:-1,x=target.State.X+direction*70;
                if(Controlled(target,"stable") || x>799 || x<1)x-=direction*140;
                actor.State.X=x;actor.State.Y=target.State.Y;return true;
            }
            if(info.SourceId==462 && cast.Phase==0)
            {actor.State.X=target.State.X-(actor.State.FacingRight?1:-1)*70;actor.State.Y=target.State.Y;return true;}
            if(info.SourceId==390)
            {
                if(cast.AttackCounter==1){cast.ChargeBegin=cast.Elapsed;return true;}
                if(cast.ChargeRatio<0)cast.ChargeRatio=Math.Clamp((cast.Elapsed-cast.ChargeBegin)/5,0,1);
            }
            if(info.SourceId==340)
            {
                if(cast.AttackCounter==1)
                {
                    double distance=Math.Max(.001,Distance(actor,target));
                    actor.DashTime=.25;actor.DashX=(target.State.X-actor.State.X)*(1-30/distance)/.25;actor.DashY=(target.State.Y-actor.State.Y)*(1-30/distance)/.25;
                    return true;
                }
                ApplyBuff(actor,actor,skill,10003403);
                var buff=actor.Buffs.Last(b=>b.Definition.SourceId==10003403);
                buff.Modifiers["damage"]=Arg(info,3);buff.Modifiers["haste"]=buff.Modifiers["action_speed"]=Arg(info,4);
                Damage(actor,actor,actor.State.Hp*Arg(info,2)/100,"Holy",0);actor.DashTime=0;
            }
            return false;
        }
        void ExpandedAttackFrame(Unit actor,BattleSkillData skill)
        {
            if(!ExpandedRules)return;
            int id=skill.Definition.Crystal.SourceId;
            if(id==31 && Native(actor,34) is BattleSkillData energy)GainEnergy(actor,Arg(energy.Definition.Crystal,2));
            if(id==11104)MarsTauntFrame(actor,skill);
            if(id==212 && Native(actor,214) is BattleSkillData essence && Evo(essence,"BasicEnergyChance")>0 && Random()<Evo(essence,"BasicEnergyChance")/100)
                GainEnergy(actor,Evo(essence,"BasicEnergyAmount"));
            if(id==330 && Evo(skill,"AttackFrameAllyEnergy")>0)
                foreach(var ally in units.Where(u=>u.State.Alive && u.State.Team==actor.State.Team && u.Data.Hero))GainEnergy(ally,Evo(skill,"AttackFrameAllyEnergy"));
            if(id==442 && Native(actor,444) is BattleSkillData affinity && Evo(affinity,"MistDefenseSkill")>0)
                ApplyBuff(actor,actor,new BattleSkillData{Level=skill.Level,Definition=initial.SkillDependencies.Single(s=>s.Crystal.SourceId==446).Copy()});
            if(id is 92 or 93 && Native(actor,94) is BattleSkillData refresh)
            {
                if(!actor.RepeatSkills.Contains(id) && Random()<Evo(refresh,"RepeatMagicChance",30)/100)
                {actor.RepeatSkills.Add(id);actor.SavedCooldowns[id]=actor.Cooldowns[skill.Definition.Id];actor.Cooldowns[skill.Definition.Id]=0;actor.GlobalCooldown=0;}
                else if(actor.RepeatSkills.Contains(id))actor.RepeatSkills.Remove(id);
            }
        }
        void ExpandedAdvanceCast(Unit actor,double dt)
        {
            if(!ExpandedRules || actor.Cast==null)return;
            PudgeAdvance(actor,dt);
            LegionAdvance(actor,dt);
            DruidAdvance(actor);
            if(actor.Cast.Skill.Definition.Crystal.SourceId==332 && actor.Cast.AttackCounter==0)
                actor.State.X+=(actor.Data.Team==0?1:-1)*240/actor.Cast.Skill.Definition.Crystal.Phases[actor.Cast.Phase].Duration*dt;
            if(actor.Cast.Skill.Definition.Crystal.SourceId==503 && actor.Cast.AttackCounter<2)
                actor.State.X+=(actor.Data.Team==0?1:-1)*250*dt;
        }
        void ExpandedFinish(Unit actor,BattleSkillData skill)
        {
            if(!ExpandedRules)return;
            if(actor.Cast?.NativeFinished==true)return;
            if(actor.Cast!=null)actor.Cast.NativeFinished=true;
            int id=skill.Definition.Crystal.SourceId;
            NpcFormFinish(actor,skill);
            TerrorFinish(actor,skill);
            PudgeFinish(actor,skill);
            LegionFinish(actor,skill);
            TuskFinish(actor,skill);
            ClockwerkFinish(actor,skill);
            UndyingFinish(actor,skill);
            MonkFinish(actor,skill);
            DancerFinish(actor,skill);
            DruidFinish(actor,skill);
            BroodFinish(actor,skill);
            if(id==520)foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10005205).ToArray())RemoveEvolutionBuff(actor,buff,false);
            if(id==390 && actor.Cast.AttackCounter==1)ReleaseCharge(actor);
            if(id==462)actor.Buffs.RemoveAll(b=>b.Definition.SourceId==10004602);
            if(id==340)actor.Buffs.RemoveAll(b=>b.Definition.SourceId==10003406);
            if(id==510)
            {
                actor.State.X=actor.Cast.OriginX;actor.State.Y=actor.Cast.OriginY;
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10005104).ToArray())RemoveEvolutionBuff(actor,buff,false);
            }
            if(id==550)foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10005503))buff.Remaining=-1;
            if(id is 950 or 953)foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10009504).ToArray())RemoveEvolutionBuff(actor,buff,false);
            if(id is 92 or 93 && actor.SavedCooldowns.TryGetValue(id,out double cd) && !actor.RepeatSkills.Contains(id))
            {actor.Cooldowns[skill.Definition.Id]=cd;actor.SavedCooldowns.Remove(id);}
        }
        double ExpandedPower(Unit actor,Unit target,BattleSkillData skill,double power)
        {
            if(!ExpandedRules)return power;
            int id=skill.Definition.Crystal.SourceId;
            power=NpcPower(actor,target,skill,power);
            if(id==113)power+=Get(actor,"ability_power")*Evo(skill,"ExtraPhysicalApRatio");
            if(id is 140 or 141 or 142 && Native(actor,143) is BattleSkillData mark && target.Buffs.Any(b=>b.Definition.SourceId==10001402))power*=Evo(mark,"MarkDamageRatio",1);
            if(id==230)
            {
                if(actor.Cast?.AttackCounter==1)actor.Cast.CapturedHp=actor.State.Hp;
                power+=Math.Min(Math.Floor((actor.Cast?.CapturedHp??actor.State.Hp)*Evo(skill,"UrsaCurrentHpRatio")),Evo(skill,"UrsaHpCap"));
            }

            if(id==371 && Native(actor,375) is BattleSkillData toxin)
                power+=Math.Max(BasicAmount(toxin),(1-target.State.Hp/target.State.MaxHp)*Arg(toxin.Definition.Crystal,2));
            return power;
        }
        void ExpandedHit(Unit actor,Unit target,BattleSkillData skill)
        {
            if(!ExpandedRules)return;
            var info=skill.Definition.Crystal;int id=info.SourceId;
            if(id==462 && target.State.Alive)target.State.Energy=Math.Max(0,target.State.Energy-Arg(info,2)-Evo(skill,"ExtraManaBurn"));
            if(id is 40 or 42 or 43 && Native(actor,44) is BattleSkillData zeus && target.State.Alive && Evo(zeus,"HolyCurrentHealthPercent")>0)
                Damage(actor,target,Math.Min(target.State.Hp*Evo(zeus,"HolyCurrentHealthPercent")/100,Get(actor,"ability_power")*Evo(zeus,"HolyCapAp")),"Holy",1);
            if(id==53 && target.State.Alive)
            {
                var stolen=target.Buffs.LastOrDefault(b=>b.Definition.SourceId==10000501);
                if(stolen!=null)
                {
                    ApplyBuff(actor,actor,skill,10000502);
                    var bonus=actor.Buffs.Last(b=>b.Definition.SourceId==10000502);
                    foreach(string stat in new[]{"damage","haste"})if(stolen.Modifiers.TryGetValue(stat,out double amount))bonus.Modifiers[stat]=-amount;
                }
                var basic=actor.Skills.FirstOrDefault(s=>s.SlotId=="basic");if(basic!=null)ApplySkill(actor,target,basic);
            }
            if(id==120 && actor.Cast?.AttackCounter==3 && Evo(skill,"ThirdWaveBuff")>0 && target.State.Alive)ApplyBuff(actor,target,skill,(int)Evo(skill,"ThirdWaveBuff"));
            if(id==263 && target.State.Alive)target.State.Energy=Math.Max(0,target.State.Energy-Arg(info,2));
            if(id==392)
            {
                GainEnergy(target,Power(actor,skill));
                double amount=Evo(skill,"AttackHealBase")+Evo(skill,"AttackHealAp")*Get(actor,"ability_power");if(amount>0)Heal(target,amount,actor);
            }
            if(id==320)
            {
                info.CostEnergy=1000;
                if(!target.State.Alive || Controlled(target,"stable"))return;
                ApplyBuff(actor,target,skill,10003201);
                var debuff=target.Buffs.Last(b=>b.Definition.SourceId==10003201);
                debuff.Modifiers["haste"]=debuff.Modifiers["action_speed"]=-Arg(info,2);debuff.Modifiers["physical_immunity"]=-Arg(info,3);
                (actor.State.X,target.State.X)=(target.State.X,actor.State.X);(actor.State.Y,target.State.Y)=(target.State.Y,actor.State.Y);
                if(Evo(skill,"SwapStunSkill")>0 && Native(actor,322) is BattleSkillData arrow)CreateShot(actor,target,arrow,0,true);
            }
        }
        void ExpandedModifyBuff(Unit actor,Unit target,BattleSkillData skill,ZatodBuffDefinition definition,Dictionary<string,double> modifiers)
        {
            if(!ExpandedRules)return;
            NpcModifyBuff(actor,target,skill,definition,modifiers);
            if(definition.SourceId==10001402 && Evo(skill,"TargetArmorPercent")>0)
                modifiers["defense"]=modifiers.GetValueOrDefault("defense")-Math.Max(0,Get(target,"defense"))*Evo(skill,"TargetArmorPercent")/100;
        }
        void ExpandedBeforeBuff(Unit actor,Unit target,BattleSkillData skill)
        {
            if(buffs.TryGetValue(skill.Definition.Crystal.BuffId,out var incoming) && HasControl(incoming,"taunt"))
                foreach(var old in target.Buffs.Where(b=>HasControl(b.Definition,"taunt")).ToArray())RemoveEvolutionBuff(target,old,false);
            // OD applies this independent Evo during createBuff(), before the
            // imprisonment's invulnerability is attached to the target.
            if(!ExpandedRules || skill.Definition.Crystal.SourceId!=213)return;
            if(Evo(skill,"ImprisonDamageAp")>0)Damage(actor,target,Get(actor,"ability_power")*Evo(skill,"ImprisonDamageAp"),"AP",1);
            double amount=Evo(skill,"ImprisonEnergy");target.State.Energy=Math.Max(0,target.State.Energy-amount);GainEnergy(actor,amount);
        }
        void ExpandedDamaged(Unit actor,Unit target,string type,double lost)
        {
            if(!ExpandedRules || lost<=0)return;
            foreach(var sleep in target.Buffs.Where(b=>HasControl(b.Definition,"sleep")).ToArray())RemoveEvolutionBuff(target,sleep,false);
            if(type=="AP" && actor.State.Alive && Native(target,54) is BattleSkillData razor)
                actor.State.Energy=Math.Max(0,actor.State.Energy-Evo(razor,"DamageTakenEnergyDrain"));
            if(type=="AD" && actor.State.Alive && Distance(actor,target)<200 && Native(target,294) is BattleSkillData stone &&
                Evo(stone,"CounterStunChance")>0 && !Controlled(actor,"uncontrollable") && Random()<Evo(stone,"CounterStunChance")/100)
                ApplyBuff(target,actor,stone,(int)Evo(stone,"CounterStunBuff"));
            foreach(var buff in target.Buffs.Where(b=>b.SourceSkill!=null).ToArray())
                if(Evo(buff.SourceSkill,"ArmorRetaliationBuff")>0 && actor.State.Alive)ApplyBuff(target,actor,buff.SourceSkill,(int)Evo(buff.SourceSkill,"ArmorRetaliationBuff"));
        }
        bool ExpandedLethal(Unit target)
        {
            if(!ExpandedRules)return false;
            if(DruidBearLethal(target))return true;
            if(PhoenixLethal(target))return true;
            if(target.RebirthUsed || Native(target,195) is not BattleSkillData skill)return false;
            target.RebirthUsed=true;target.State.Hp=1;target.State.Energy=0;InterruptCast(target);target.QueuedUltimate=false;
            foreach(var buff in target.Buffs.Where(b=>b.CasterId!=target.State.EntityId).ToArray())RemoveEvolutionBuff(target,buff,false);
            ApplyBuff(target,target,skill,10001902);
            target.RebirthRemaining=Evo(skill,"RebirthInstant")>0?0:2.5;
            target.State.Action="Death";target.State.ActionElapsed=0;
            if(target.RebirthRemaining==0)CompleteRebirth(target,skill);
            return true;
        }
        void CompleteRebirth(Unit actor,BattleSkillData skill)
        {
            double bonus=SkillEvolution.Active(skill.Definition,skill.Level).SelectMany(e=>e.ParameterChanges).Where(p=>p.Field=="BasicAmount" && p.Mode==SkillParameterMode.Add).Sum(p=>p.Value);
            double previous=actor.State.Hp;actor.State.Hp=Math.Clamp(.1*actor.State.MaxHp+(BasicAmount(skill)-bonus)*actor.Data.HpMultiplier+bonus,1,actor.State.MaxHp);
            RecordHealing(actor,actor.State.Hp-previous);actor.Buffs.RemoveAll(b=>b.Definition.SourceId==10001902);
            actor.RebirthRemaining=-1;actor.State.Action="Birth";actor.State.ActionElapsed=0;
            actor.BirthRemaining=actor.Data.BirthSeconds;
            ApplyBuff(actor,actor,skill,10001905);
            if(Evo(skill,"RebirthBuff")>0)ApplyBuff(actor,actor,skill,(int)Evo(skill,"RebirthBuff"));
        }
        void ExpandedTick()
        {
            if(!ExpandedRules)return;
            NpcTick();
            foreach(var actor in units.Where(u=>u.State.Alive).ToArray())
            {
                if(actor.DashTime>0){double dt=Math.Min(StepSeconds,actor.DashTime);actor.State.X+=actor.DashX*dt;actor.State.Y+=actor.DashY*dt;actor.DashTime-=dt;}
                if(actor.RebirthRemaining>=0)
                {actor.RebirthRemaining-=StepSeconds;actor.State.ActionElapsed+=StepSeconds;if(actor.RebirthRemaining<=0)CompleteRebirth(actor,Native(actor,195));}
                foreach(int source in actor.SavedCooldowns.Keys.ToArray())actor.SavedCooldowns[source]-=StepSeconds*Factor(Get(actor,"haste"));
                if(Native(actor,254) is BattleSkillData presence && Evo(presence,"EnergyPerEnemy")>0)
                    GainEnergy(actor,Math.Min(Evo(presence,"EnergyEnemyCap"),units.Count(u=>u.State.Alive && u.State.Team!=actor.State.Team))*Evo(presence,"EnergyPerEnemy")*StepSeconds);
                if(Native(actor,154) is BattleSkillData shell && Evo(shell,"DispelHealthStep")>0)
                {
                    if(actor.State.Hp>=actor.DispelAnchorHp)actor.DispelAnchorHp=actor.State.Hp;
                    else if(actor.DispelAnchorHp-actor.State.Hp>=actor.State.MaxHp*Evo(shell,"DispelHealthStep"))
                    {if(!Controlled(actor,"doom"))foreach(var b in actor.Buffs.Where(b=>b.Definition.Dispel=="YES" && Find(b.CasterId)?.State.Team!=actor.State.Team).ToArray())RemoveEvolutionBuff(actor,b,false);actor.DispelAnchorHp=actor.State.Hp;}
                }
                if(Native(actor,344) is BattleSkillData berserk)
                {
                    actor.BerserkTimer-=StepSeconds;
                    if(actor.BerserkTimer<=0)
                    {
                        actor.BerserkTimer+=1;double missing=Math.Floor((1-actor.State.Hp/actor.State.MaxHp)*100)/100;
                        var buff=actor.Buffs.FirstOrDefault(b=>b.Definition.SourceId==10003404);
                        if(buff==null){ApplyBuff(actor,actor,berserk,10003404);buff=actor.Buffs.Last(b=>b.Definition.SourceId==10003404);}
                        buff.Modifiers["magic_immunity"]=Arg(berserk.Definition.Crystal,2)*100*missing;
                        buff.Modifiers["haste"]=buff.Modifiers["action_speed"]=Evo(berserk,"MissingHealthHaste")*missing;
                    }
                }
            }
        }
        void ExpandedAllyDeath(Unit victim,Unit killer)
        {
            if(!ExpandedRules || killer==null || killer.State.Team==victim.State.Team || !killer.State.Alive || Controlled(killer,"invulnerable"))return;
            foreach(var source in units.Where(u=>(u.State.Alive || u==victim) && u.State.Team==victim.State.Team).ToArray())
                if((source==victim || victim.Summoner==null) && Native(source,324) is BattleSkillData vengeance && Evo(vengeance,"AllyDeathAttackReduction")>0)
                {
                    double amount=-Math.Max(0,Get(killer,"damage"))*Evo(vengeance,"AllyDeathAttackReduction")/100;
                    ApplyBuff(source,killer,vengeance,10003205);killer.Buffs.Last(b=>b.Definition.SourceId==10003205).Modifiers["damage"]=amount;
                }
        }
        bool ExpandedProjectileHit(Shot shot,Unit target)
        {
            if(!ExpandedRules || shot.Skill.Definition.Crystal.SourceId!=112)return false;
            var caster=Find(shot.ActorId);var info=shot.Skill.Definition.Crystal;
            double length=Math.Sqrt(shot.VX*shot.VX+shot.VY*shot.VY);
            var second=units.Where(u=>u.State.Alive && u!=target && u.State.Team!=caster.State.Team && !Controlled(u,"untargetable"))
                .Select(u=>new{Unit=u,X=u.State.X-target.State.X,Y=u.State.Y-target.State.Y})
                .Where(u=>u.X*u.X+u.Y*u.Y<=48400 && (u.X*shot.VX+u.Y*shot.VY)/Math.Max(.001,length*Math.Sqrt(u.X*u.X+u.Y*u.Y))>=.994)
                .OrderBy(u=>10*(u.X*u.X+u.Y*u.Y)-9*Math.Pow((u.X*shot.VX+u.Y*shot.VY)/Math.Max(.001,length),2)).ThenBy(u=>u.Unit.State.EntityId).FirstOrDefault()?.Unit;
            double duration=second==null?Evo(shot.Skill,"SingleStunDuration",.6):Evo(shot.Skill,"DoubleStunDuration",buffs[info.BuffId].Duration);
            ApplySkill(caster,target,shot.Skill,buffDurationOverride:duration);
            if(second!=null){ApplySkill(caster,second,shot.Skill,buffDurationOverride:duration);Effect(info.ChainEffect,"chain",target,second,48);}
            return true;
        }
        double ExpandedBounceBonus(Shot shot,Unit caster)=>ExpandedRules && shot.Skill.Definition.Crystal.SourceId==350?
            shot.BounceIndex*(Evo(shot.Skill,"BounceDamageBase")+Evo(shot.Skill,"BounceDamageAp")*Get(caster,"ability_power")):0;
        void ExpandedBounce(Shot shot,Unit victim)
        {
            if(!ExpandedRules || shot.Bounces<=1)return;
            var caster=Find(shot.ActorId);var info=shot.Skill.Definition.Crystal;
            shot.NativeBounceHits[victim.State.EntityId]=shot.NativeBounceHits.GetValueOrDefault(victim.State.EntityId)+1;
            var options=units.Where(u=>u.State.Alive && u!=victim && CampMatches(caster,u,info.TargetCamp) && !Controlled(u,"untargetable") && !HiddenFrom(caster,u));
            var target=info.SourceId==817?
                options.Where(u=>shot.NativeBounceHits.GetValueOrDefault(u.State.EntityId)==0 && Math.Abs(Math.Pow(Distance(victim,u),2)-6400)>info.MinRange*info.MinRange && Math.Abs(Math.Pow(Distance(victim,u),2)-6400)<info.MaxRange*info.MaxRange)
                    .OrderBy(u=>Math.Abs(Math.Pow(Distance(victim,u),2)-6400)).ThenBy(u=>u.State.EntityId).FirstOrDefault():
                options.Where(u=>Distance(victim,u)>info.MinRange && Distance(victim,u)<info.MaxRange).OrderBy(u=>Distance(victim,u)).ThenBy(u=>u.State.EntityId).FirstOrDefault();
            if(target==null)return;
            var next=CreateShot(caster,target,shot.Skill,0,true);
            next.X=victim.State.X;next.Y=victim.State.Y;next.Height=shot.Height;next.Bounces=shot.Bounces-1;next.BounceIndex=shot.BounceIndex+1;
            next.NativeBounceHits=new Dictionary<int,int>(shot.NativeBounceHits);next.Elapsed=shot.Elapsed;next.VisualId=shot.VisualId;
            double distance=Math.Max(.001,Distance(victim,target));next.VX=(target.State.X-next.X)/distance*info.ProjectileSpeed;next.VY=(target.State.Y-next.Y)/distance*info.ProjectileSpeed;next.VZ=0;
            if(info.SourceId==313 && Evo(shot.Skill,"PerfectBounce")==0)next.DamageMultiplier=Math.Pow(.85,next.BounceIndex);
        }
    }
}
