using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        sealed class LandingImpact { public int ActorId,TargetId; public BattleSkillData Skill; }
        readonly List<LandingImpact> landings=new List<LandingImpact>();
        void Release(Unit actor,Unit target,BattleSkillData skill,int index)
        {
            var info=skill.Definition.Crystal;
            if(info.TrackType=="chain")Effect(info.ChainEffect,"chain",actor,target,48*actor.Data.ArtScale);
            int counter=actor.Cast?.AttackCounter??1;
            if(info.SourceId==73)
            {
                if(counter==1){Blink(actor);return;}
                if(counter==3){actor.State.X=actor.Cast.OriginX;actor.State.Y=actor.Cast.OriginY;return;}
            }
            if(info.SourceId==293)Effect("eff_point_Tiny_atk3.cha","point",actor);
            if(info.TrackType=="projectile")
            {
                if(info.SourceId==202)
                {
                    ApplySkill(actor,actor,skill);
                    foreach(var unit in units.Where(u=>u!=actor && u.State.Alive && Distance(actor,u)<=220 && !Controlled(u,"untargetable")).ToArray())CreateShot(actor,unit,skill,index,true);
                }
                else if(info.SourceId==20)
                {
                    int count=Math.Min(5,(int)((Arg(info,2)-counter)/5+1));
                    for(int i=0;i<count;i++)
                    {
                        var victim=i==0?target:Target(actor,info,target);if(victim==null)break;
                        var shot=CreateShot(actor,victim,skill,index,false);
                        double[] offsetsX={0,-19,5,-36,39},offsetsY={0,5,-14,28,-50};
                        Ballistic(shot,actor,victim,offsetsX[i]*(actor.State.FacingRight?1:-1),offsetsY[i]);
                    }
                }
                else
                {
                    var shot=CreateShot(actor,target,skill,index,info.SourceId==370);
                    if(info.SourceId==103)Ballistic(shot,actor,target,0,0);
                }
            }
            else
            {
                foreach(var victim in Affected(actor,target,info).ToArray())ApplySkill(actor,victim,skill);
                if(info.TrackType=="chain" && info.ChainJumps>1)
                {
                    chains.Add(new Chain{BirthTick=tick,ActorId=actor.State.EntityId,PreviousId=target.State.EntityId,Skill=skill,Remaining=info.ChainJumps-1,Timer=info.ChainGap,Hit=new HashSet<int>{target.State.EntityId}});
                }
            }
            if(info.TrackType!="projectile")Effect(info.PointEffect,"point",info.AoeOrigin=="self"?actor:target);
            GainEnergy(actor,info.GainEnergy*initial.EnergyGainMultiplier);
            if(info.MoveForward!=0)actor.State.X=Math.Clamp(actor.State.X+info.MoveForward*(actor.State.FacingRight?1:-1),20,780);
        }
        Shot CreateShot(Unit actor,Unit target,BattleSkillData skill,int index,bool track)
        {
            var info=skill.Definition.Crystal;
            if(info.SourceId==90)
            {
                skill=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};info=skill.Definition.Crystal;
                int counter=actor.Cast?.AttackCounter??1;
                info.ProjectileArt=counter%3==2?"eff_tile_TK_atk3.cha":"eff_tile_TK_atk2.cha";
                info.ProjectileOverHeight=counter%3==2?Arg(info,4):0;info.ProjectileZSpeed=counter%3==2?Arg(info,3):0;info.ProjectileSpeed=counter%3==2?Arg(info,5):Arg(info,2);
            }
            var phase=info.Phases[actor.Cast?.Phase??0];var origin=index<phase.AttackOrigins.Count?phase.AttackOrigins[index]:new ZatodAttackOrigin{Y=75};
            double direction=actor.State.FacingRight?1:-1,x=actor.State.X+origin.X*.09*actor.Data.ArtScale*direction,y=actor.State.Y,height=origin.Y*.09*actor.Data.ArtScale;
            if(info.SourceId==10){x-=400*direction;if(x<0 || x>800)x=400-400*direction;y=0;height=10;}
            double dy=info.AimTarget?target.State.Y-y:0,distance=Math.Max(.001,Math.Sqrt(Math.Pow(target.State.X-x,2)+dy*dy)),speed=Math.Max(1,info.ProjectileSpeed);
            var shot=new Shot{BirthTick=tick,VisualId=++visualId,ActorId=actor.State.EntityId,TargetId=target.State.EntityId,Skill=skill,PhaseEvent=index,X=x,Y=y,Height=height,VX=(target.State.X-x)/distance*speed,VY=dy/distance*speed,VZ=info.ProjectileZSpeed,Remaining=info.ProjectileDistance>0?info.ProjectileDistance/speed:15,TrackTarget=track,Tinker=actor.Data.SourceId==9};shots.Add(shot);return shot;
        }
        static void Ballistic(Shot shot,Unit actor,Unit target,double offsetX,double offsetY)
        {
            double gravity=shot.Skill.Definition.Crystal.Gravity;
            if(gravity>=0)return;
            double duration=(-shot.VZ-Math.Sqrt(shot.VZ*shot.VZ-2*gravity*shot.Height))/gravity;
            if(duration<=0)return;shot.VX=(target.State.X+offsetX-actor.State.X)/duration;shot.VY=(target.State.Y+offsetY-actor.State.Y)/duration;
        }
        void SpecialBuff(Unit actor,Unit target,BattleSkillData skill,int id)
        {
            var copy=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};copy.Definition.Crystal.BuffId=id;ApplyBuff(actor,target,copy);
        }
        void FinishSpecial(Unit actor)
        {
            if(actor.Cast?.Skill.Definition.Crystal.SourceId==73)
            {actor.State.X=actor.Cast.OriginX;actor.State.Y=actor.Cast.OriginY;actor.Buffs.RemoveAll(b=>b.Definition.SourceId==10000701);}
        }
        void Blink(Unit actor)
        {
            int max=0;double min=double.MaxValue,bestX=400,bestY=0;
            for(int x=0;x<=800;x+=25)for(int y=-100;y<=100;y+=25)
            {
                int count=0;double distance=0;
                foreach(var victim in units.Where(u=>u.State.Alive && u.State.Team!=actor.State.Team && !Controlled(u,"untargetable") && !Controlled(u,"invulnerable")))
                {double d=Math.Pow(x-victim.State.X,2)+Math.Pow(y-victim.State.Y,2);if(d<=130*130){count++;distance+=d;}}
                if(count>max || count==max && distance<min){max=count;min=distance;bestX=x;bestY=y;}
            }
            actor.State.X=bestX;actor.State.Y=bestY;
        }
        sealed class Chain
        {
            public int ActorId,PreviousId,Remaining,BirthTick;
            public BattleSkillData Skill;
            public double Timer;
            public HashSet<int> Hit;
        }
        readonly List<Chain> chains=new List<Chain>();
        void AdvanceChains()
        {
            foreach(var chain in chains.ToArray())
            {
                if(chain.BirthTick==tick)continue;
                chain.Timer-=StepSeconds;if(chain.Timer>0)continue;
                var caster=Find(chain.ActorId);var previous=Find(chain.PreviousId);var info=chain.Skill.Definition.Crystal;
                if(caster==null || previous==null){chains.Remove(chain);continue;}
                // Source chain.lua minimizes abs(distance squared - 6400), then range tests that value.
                var next=units.Where(u=>u.State.Alive && CampMatches(caster,u,info.TargetCamp) && !chain.Hit.Contains(u.State.EntityId) && !Controlled(u,"untargetable"))
                    .Select(u=>new{Unit=u,Distance=Math.Abs(Math.Pow(Distance(previous,u),2)-6400)})
                    .Where(x=>x.Distance>info.MinRange*info.MinRange && x.Distance<info.MaxRange*info.MaxRange)
                    .OrderBy(x=>x.Distance).ThenBy(x=>x.Unit.State.EntityId).FirstOrDefault()?.Unit;
                if(next==null){chains.Remove(chain);continue;}
                Effect(info.ChainEffect,"chain",previous,next,48*previous.Data.ArtScale);ApplySkill(caster,next,chain.Skill);chain.Hit.Add(next.State.EntityId);chain.PreviousId=next.State.EntityId;
                chain.Timer+=info.ChainGap;if(--chain.Remaining<=0)chains.Remove(chain);
            }
        }
        static bool CampMatches(Unit actor,Unit target,int camp)=>camp==0 || (camp==1?target.State.Team==actor.State.Team:target.State.Team!=actor.State.Team);
        IEnumerable<Unit> Affected(Unit actor,Unit target,ZatodSkillDefinition skill,double atX=double.NaN,double atY=double.NaN)
        {
            if(string.IsNullOrEmpty(skill.AoeOrigin))return new[]{target};
            double ox=skill.AoeOrigin=="self"?actor.State.X:double.IsNaN(atX)?target.State.X:atX;
            double oy=skill.AoeOrigin=="self"?actor.State.Y:double.IsNaN(atY)?target.State.Y:atY;
            double direction=actor.State.FacingRight?1:-1;
            ox+=skill.XShift*direction;
            return units.Where(u=>u.State.Alive && CampMatches(actor,u,skill.AffectedCamp) && !(u==actor && (skill.DamageType=="AD" || skill.DamageType=="AP"))).Where(u=>
            {
                double x=(u.State.X-ox)*direction,y=u.State.Y-oy;
                if(skill.AoeShape=="rectangle")return x>=0 && x<=skill.ShapeArg1 && Math.Abs(y)<=skill.ShapeArg2/2;
                double distance=x*x+y*y;
                if(distance>skill.ShapeArg1*skill.ShapeArg1)return false;
                if(skill.AoeShape=="halfcircle")return x>=0;
                if(skill.AoeShape=="quartercircle")return x>=Math.Abs(y);
                return true;
            }).OrderBy(u=>u.State.EntityId).ToArray();
        }
        void AdvanceShots()
        {
            foreach(var landing in landings.ToArray())
            {
                var victim=Find(landing.TargetId);var caster=Find(landing.ActorId);
                if(victim==null || caster==null){landings.Remove(landing);continue;}
                if(victim.State.Height>0 || victim.VerticalSpeed>0)continue;
                var metadata=landing.Skill.Definition.Crystal.Copy();
                metadata.DamageType="AP";metadata.BasicAmount=Arg(metadata,2);metadata.PlusRatio=Arg(metadata,3);metadata.AoeOrigin="target";metadata.KnockUp=0;metadata.KnockBack=0;metadata.BuffId=0;
                var skill=new BattleSkillData{Level=landing.Skill.Level,Definition=landing.Skill.Definition.Copy()};skill.Definition.Crystal=metadata;
                foreach(var target in Affected(caster,victim,metadata))ApplySkill(caster,target,skill);
                landings.Remove(landing);
            }
            foreach(var shot in shots.ToArray())
            {
                if(shot.BirthTick==tick)continue;
                var caster=Find(shot.ActorId);var target=Find(shot.TargetId);var info=shot.Skill.Definition.Crystal;
                if(caster==null){shots.Remove(shot);continue;}
                shot.Elapsed+=StepSeconds;double old=shot.X;shot.X+=shot.VX*StepSeconds;shot.Y+=shot.VY*StepSeconds;shot.Height+=shot.VZ*StepSeconds;shot.VZ+=info.Gravity*StepSeconds;shot.Remaining-=StepSeconds;
                if(shot.TrackTarget && (target==null || !target.State.Alive || !info.Piercing && Controlled(target,"untargetable")))shot.TrackTarget=false;
                var candidates=shot.TrackTarget?new[]{target}:units.Where(u=>u!=caster && CampMatches(caster,u,info.AffectedCamp) && u.State.Alive && (info.Piercing || !Controlled(u,"untargetable"))).ToArray();
                var hits=candidates.Where(u=>u!=null && u.State.Alive && !shot.Hit.Contains(u.State.EntityId)).Select(u=>new{Unit=u,Time=ContactTime(shot,old,u)}).Where(h=>h.Time>=0 && h.Time<=1).OrderBy(h=>info.Piercing?h.Unit.State.EntityId:h.Time).ThenBy(h=>h.Unit.State.EntityId).ToArray();
                foreach(var collision in hits)
                {
                    var victim=collision.Unit;
                    if(shot.Height>info.ProjectileOverHeight && info.ProjectileOverHeight>0)continue;
                    shot.Hit.Add(victim.State.EntityId);
                    foreach(var hit in Affected(caster,victim,info))ApplySkill(caster,hit,shot.Skill);
                    Effect(info.PointEffect,"point",victim);
                    if(!info.Piercing){if(info.SourceId==10)EffectAt("eff_impact_Coco_ult.cha","impact",caster,shot.X,shot.Y,0);shots.Remove(shot);break;}
                }
                if(!shots.Contains(shot))continue;
                if(shot.Height<=0 && !string.IsNullOrEmpty(info.AoeOrigin))
                {
                    foreach(var victim in Affected(caster,target??caster,info,shot.X,shot.Y).ToArray())ApplySkill(caster,victim,shot.Skill);
                    EffectAt(info.PointEffect,"point",caster,shot.X,shot.Y,0);shots.Remove(shot);
                }
                if(shot.Tinker && target!=null && target.State.Alive)
                {
                    shot.VZ-=info.Gravity*StepSeconds;
                    double dv=600*StepSeconds,dx=target.State.X-shot.X,dy=target.State.Y-shot.Y,dz=-shot.Height;
                    double norm=Math.Max(.001,Math.Sqrt(dx*dx+dy*dy+dz*dz));
                    if(shot.VZ>dv){shot.VZ-=dv;dv=0;}else if(shot.VZ>0){dv-=shot.VZ;shot.VZ=0;}
                    shot.VX+=dx/norm*dv*8;shot.VY+=dy/norm*dv*8;shot.VZ+=dz/norm*dv*8;
                }
                if(shot.Remaining<=0 || shot.Height<0 || shot.X<0 || shot.X>800 || shot.Y< -120 || shot.Y>120){if(info.SourceId==10)EffectAt("eff_impact_Coco_ult.cha","impact",caster,shot.X,shot.Y,0);shots.Remove(shot);}
            }
        }
        static double ContactTime(Shot shot,double previousX,Unit target)
        {
            double d=shot.X-target.State.X,old=previousX-target.PreviousX;
            if(d>0 && old>0){d-=target.Data.Radius;old-=target.Data.Radius;}else if(d<0 && old<0){d+=target.Data.Radius;old+=target.Data.Radius;}
            return Math.Abs(d-old)<1e-12?double.NaN:-old/(d-old);
        }
        static double Arg(ZatodSkillDefinition skill,int index)=>skill.ScriptArgs.Count>=index?skill.ScriptArgs[index-1]:0;
        void ApplySkill(Unit actor,Unit target,BattleSkillData skill)
        {
            if(!target.State.Alive)return;
            var info=skill.Definition.Crystal;
            if(Controlled(target,"invulnerable") && target!=actor && info.DamageType!="Heal" || target.Cast!=null && target.Cast.ManualStartup && target.State.Team!=actor.State.Team)return;
            Effect(info.ImpactEffect,"impact",target);
            if(info.BuffId>0)ApplyBuff(actor,target,skill);
            double power=Power(actor,skill);
            if(info.SourceId==200)
            {
                double missing=target.State.MaxHp-target.State.Hp;
                power=Math.Clamp(missing*Arg(info,2),Arg(info,4)+Arg(info,5)*Get(actor,"ability_power"),Arg(info,3)+Arg(info,5)*Get(actor,"ability_power"));
            }
            if(info.SourceId==202 && actor.State.Team==target.State.Team)Heal(target,power,actor);
            else if(info.DamageType=="Heal")Heal(target,power,actor);
            else if(!string.IsNullOrEmpty(info.DamageType))
            {
                double dodge=info.DamageType=="AD"?Math.Max(0,Get(target,"dodge")-Get(actor,"accuracy")):Get(target,"mdodg");
                double chance=info.DamageType=="AD"?dodge/(100+dodge):dodge/100;
                if(info.SourceId!=100 && Random()<chance)return;
                double lost=Damage(actor,target,power,info.DamageType,info.CritPercent/100);
                if(info.SourceId==100 && !target.State.Alive)GainEnergy(actor,150);
                if(info.SourceId==180)Heal(actor,lost*Arg(info,2)/100,actor);
                double lfs=Get(actor,"lifesteal");
                if(info.LifestealPercent>0 && lfs>0)Heal(actor,lost*lfs/(100+lfs+target.Data.Level)*info.LifestealPercent/100*(1+Math.Max(-100,Get(actor,"lfsratio"))/100),actor);
            }

            if(info.KnockUp>0 && target.State.Alive){target.VerticalSpeed=info.KnockUp*1800/2;target.State.Height=Math.Max(.001,target.State.Height);}
            if(info.KnockBack!=0 && target.State.Alive){target.KnockRemaining=Math.Max(StepSeconds,info.KnockUp);target.KnockVelocity=Math.Sign(target.State.X-actor.State.X)*info.KnockBack/target.KnockRemaining;}
            if(info.SourceId==290 && target.State.Alive)landings.Add(new LandingImpact{ActorId=actor.State.EntityId,TargetId=target.State.EntityId,Skill=skill});
        }
        void Heal(Unit target,double amount,Unit source=null)
        {
            if(!target.State.Alive || Controlled(target,"unheal"))return;
            if(source!=null)amount*=source.Data.DamageMultiplier*Get(source,"pdm",1)*(1+Math.Max(-1,Get(source,"healing_bonus")/100));
            amount*=1+Math.Max(-1,Get(target,"heal_ratio")/100);
            double previous=target.State.Hp;
            target.State.Hp=Math.Clamp(target.State.Hp+Math.Max(0,amount),0,target.State.MaxHp);
            CombatEvent(target,"heal",target.State.Hp-previous);
        }
        double Damage(Unit actor,Unit target,double amount,string type,double critModifier)
        {
            if(!target.State.Alive || Controlled(target,"invulnerable"))return 0;
            bool magic=type=="AP",holy=type=="Holy";
            double defense=holy?0:Math.Max(0,Get(target,magic?"magic_resistance":"defense")-Get(actor,magic?"magic_penetration":"armor_penetration"));
            double dd=defense*(magic?12:8),dc=defense*(magic?2.5:8);
            double rating=holy?0:Math.Max(0,Get(actor,magic?"magic_crit":"physical_crit")-Get(target,magic?"magic_crit_resistance":"physical_crit_resistance"));
            bool critical=Random()<rating/(100+dc)*critModifier;
            amount=Math.Max(0,amount);if(amount==0)return 0;
            amount=amount*amount/(amount+dd);
            if(critical)amount*=Math.Max(1,2+(Get(actor,magic?"mcsd":"csd")-Get(target,magic?"mcsdr":"csdr"))/100);
            amount*=actor.Data.DamageMultiplier*Get(actor,"pdm",1);
            double immunity=Get(target,"all_immunity")+(holy?0:Get(target,magic?"magic_immunity":"physical_immunity")-Get(actor,magic?"apdp":"addp"));
            if(immunity>=100)return 0;
            foreach(var shield in target.Buffs.Where(b=>b.Definition.ShieldValue>0 && (b.Definition.ShieldType=="all" || b.Definition.ShieldType==type)).OrderByDescending(b=>b.Definition.ShieldValue))
            {
                double absorbed=Math.Min(amount,shield.Definition.ShieldValue);shield.Definition.ShieldValue-=absorbed;amount-=absorbed;if(amount<=0)break;
            }
            amount*=Math.Max(0,1-immunity/100);
            double lost=Math.Min(target.State.Hp,amount);target.State.Hp-=lost;
            CombatEvent(target,"damage",lost,type,critical);
            GainEnergy(target,lost/Math.Max(1,target.State.MaxHp)*Get(target,"damage_energy_rate",1000)*(1+Get(target,"mpratio")/100)*initial.EnergyGainMultiplier);

            if(!target.State.Alive)
            {
                bool reduced=Random()<Get(target,"kill_energy")/100;
                if(actor.Data.Hero && actor.State.Alive)GainEnergy(actor,reduced?150:300,"last_hit");
                target.State.Hp=0;target.State.Energy=0;target.State.Action="Death";target.State.ActionElapsed=0;target.Cast=null;target.QueuedUltimate=false;target.Buffs.RemoveAll(b=>b.Definition.ClearOnDeath);
            }
            else if(target.Cast!=null && target.Cast.Skill.Definition.Crystal.Interruptable && !Controlled(target,"uncontrollable"))
            {
                double threshold=target.State.MaxHp*Get(target,"interrupt_health_ratio",8)/100,interruptRating=Get(target,"interrupt_rating");
                double probability=interruptRating==0?(lost>threshold?1:0):Math.Clamp((lost-threshold)/(target.State.MaxHp*interruptRating*.001),0,1);
                if(probability>=1 || probability>0 && Random()<=probability){FinishSpecial(target);target.Cast=null;target.State.Action="Idle";target.State.ActionElapsed=0;}
            }
            return lost;
        }
        void ApplyBuff(Unit actor,Unit target,BattleSkillData skill)
        {
            var info=skill.Definition.Crystal;
            if(!buffs.TryGetValue(info.BuffId,out var source))throw new InvalidOperationException("Missing Crystal buff: "+info.BuffId);
            var definition=ZatodMatchFactory.CopyBuff(source);
            if(Controlled(target,"uncontrollable") && !string.IsNullOrEmpty(definition.Control))return;
            foreach(var field in info.Growth)
            {
                double growth=(skill.Level-1)*field.Amount;
                if(field.Field=="Time")definition.Duration+=growth;
                else if(field.Field=="Shield Value")definition.ShieldValue+=growth;
                else
                {
                    string name=Attribute(field.Field);var stat=definition.Stats.FirstOrDefault(x=>x.StatId==name);
                    if(stat!=null)stat.Value+=growth;
                }
            }
            var modifiers=definition.Stats.ToDictionary(x=>x.StatId,x=>x.Value,StringComparer.Ordinal);
            foreach(var scaling in definition.Scaling)modifiers[scaling.StatId]=(modifiers.TryGetValue(scaling.StatId,out double old)?old:0)+Get(actor,scaling.Attribute)*scaling.Ratio;
            if(definition.SourceId==10001002)
            {
                double ratio=Get(target,"damage")>0?Get(actor,"damage")/Get(target,"damage"):9999;
                double coefficient=ratio>1?Math.Min(ratio*1.1,2.5):1;
                foreach(var stat in new[]{"action_speed","haste"})if(modifiers.ContainsKey(stat))modifiers[stat]*=coefficient;
            }
            if(modifiers.TryGetValue("health_regen",out double hprValue))
                modifiers["health_regen"]=hprValue*(hprValue>0?1+Math.Max(0,Get(actor,"healing_bonus"))/100:1+Get(actor,"dotdratio")/100);
            double resistance=actor.State.Team==target.State.Team?0:Get(target,Attribute(definition.Tenacity))-Get(actor,"con");
            double duration=definition.Duration>0?definition.Duration*Math.Max(.01,1-resistance/100):double.MaxValue;
            var existing=target.Buffs.FirstOrDefault(x=>x.Definition.SourceId==definition.SourceId);
            if(existing!=null)
            {
                existing.Remaining=duration;
                if(definition.StackRule=="True" && existing.Stacks<definition.MaximumStacks)foreach(var pair in modifiers)existing.Modifiers[pair.Key]=(existing.Modifiers.TryGetValue(pair.Key,out double value)?value:0)+pair.Value;
                if(definition.StackRule=="True")existing.Stacks=Math.Min(definition.MaximumStacks,existing.Stacks+1);
                return;
            }
            target.Buffs.Add(new ActiveBuff{VisualId=++visualId,Definition=definition,CasterId=actor.State.EntityId,OriginalTeam=target.State.Team,Remaining=duration,Modifiers=modifiers});
            if((definition.Control??"").Contains("stun")){target.Cast=null;target.State.Action="Idle";target.State.ActionElapsed=0;}
            if(info.SourceId==453)
            {
                target.State.Team=actor.State.Team;target.Cast=null;
                var basic=target.Skills.FirstOrDefault(s=>s.SlotId=="basic");
                if(basic!=null && target.Cooldowns[basic.Definition.Id]<90){target.Cooldowns[basic.Definition.Id]=0;target.GlobalCooldown=0;}
            }
        }
        void AdvanceBuffs()
        {
            foreach(var actor in units.Where(u=>u.State.Alive))
            {
                double hpr=Get(actor,"health_regen");
                if(hpr>0 && !Controlled(actor,"unheal"))Heal(actor,hpr*StepSeconds);
                else if(hpr<0 && !Controlled(actor,"noHPR")){double previous=actor.State.Hp;actor.State.Hp=Math.Max(1,actor.State.Hp+hpr*StepSeconds*(1-Math.Min(.99,Get(actor,"dot_resistance")/100)));CombatEvent(actor,"damage",previous-actor.State.Hp,"DOT");}
                GainEnergy(actor,Get(actor,"energy_regen")*StepSeconds*initial.EnergyGainMultiplier,"energy",true);
            }
            foreach(var actor in units)
            foreach(var buff in actor.Buffs.ToArray())
            {
                if(!actor.State.Alive && buff.Definition.ClearOnDeath){actor.Buffs.Remove(buff);continue;}
                buff.Elapsed+=StepSeconds;buff.Remaining-=StepSeconds;
                if(buff.Definition.SourceId==10001002 && buff.Remaining>0)
                {double ratio=Math.Max(0,(buff.Remaining-StepSeconds)/buff.Remaining);foreach(var stat in new[]{"action_speed","haste"})if(buff.Modifiers.ContainsKey(stat))buff.Modifiers[stat]*=ratio;}
                if(buff.Remaining<=0)
                {
                    actor.Buffs.Remove(buff);
                    if(buff.Definition.SourceId==10004501)actor.State.Team=buff.OriginalTeam;
                }
            }
        }
        public static ZatodReplay Resimulate(ZatodReplay replay)
        {
            if(replay==null || replay.Initial==null || replay.EndTick<1 || replay.EndTick>100000)throw new ArgumentException("Invalid replay.");
            var battle=new ZatodBattleSimulation(replay.Initial);var commands=replay.Inputs.OrderBy(x=>x.Tick).ThenBy(x=>x.ActorId).ToArray();int cursor=0;
            while(!battle.Finished && battle.CurrentTick<replay.EndTick)
            {
                while(cursor<commands.Length && commands[cursor].Tick==battle.CurrentTick+1)battle.QueueInput(commands[cursor++]);
                battle.Step();
            }
            if(cursor!=commands.Length)throw new ArgumentException("Replay contains inputs outside its simulated ticks.");
            return battle.Replay();
        }
        public static bool Validate(ZatodMatchDefinition trusted,IEnumerable<ZatodInput> commands,int claimedTick,int claimedWinner,int claimedStars,ulong claimedDigest)
        {
            try
            {
                var replay=Resimulate(new ZatodReplay{Initial=trusted,Inputs=commands.Select(x=>x.Copy()).ToList(),EndTick=claimedTick});
                return replay.Completed && replay.EndTick==claimedTick && replay.Winner==claimedWinner && replay.Stars==claimedStars && replay.Digest==claimedDigest;
            }
            catch(ArgumentException){return false;}
        }
    }
}
