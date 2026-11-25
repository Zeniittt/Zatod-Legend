using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    // Crystal's model clock is independent of Unity frames and the legacy 20 Hz simulator.
    public sealed partial class ZatodBattleSimulation
    {
        const int WaveEntryTicks=6;
        public const double WaveEntrySeconds=WaveEntryTicks*StepSeconds;
        public const int TickRate=8;
        public const double StepSeconds=.125;
        sealed class Cast
        {
            public BattleSkillData Skill;
            public int TargetId,Phase,Event,AttackCounter;
            public double OriginX,OriginY;
            public bool SpecialVisual;
            public double Elapsed, CapturedHp, ChargeBegin, ChargeRatio=-1;
            public bool ManualStartup;
            public bool NativeFinished;
            public bool PudgeHookHit,PudgeHolding;
            public bool MonkSuper;
            public ZatodSkillDefinition MonkOriginalInfo;
            public int NativeHitCount;
            public readonly HashSet<int> NativeAffected=new HashSet<int>();
        }
        sealed class ActiveBuff
        {
            public ZatodBuffDefinition Definition;
            public int CasterId,OriginalTeam,VisualId,Stacks=1;
            public double Elapsed;
            public double PulseTimer,NativeDamage,NativeShieldCapacity;
            public int NativeCharges;
            public bool NativeTravelPoint;
            public double NativeDestinationX,NativeDestinationY,NativeReturnX,NativeReturnY;
            public double Remaining;
            public Dictionary<string,double> Modifiers;
            public BattleSkillData SourceSkill;
            public bool MainSkillBuff;
            public double FearX,FearY;
        }
        sealed class Unit
        {
            public ZatodUnitData Data;
            public ZatodUnitState State;
            public Dictionary<string,double> Base;
            public List<BattleSkillData> Skills;
            public Dictionary<string,double> Cooldowns=new Dictionary<string,double>(StringComparer.Ordinal);
            public List<ActiveBuff> Buffs=new List<ActiveBuff>();
            public Cast Cast;
            public Unit Summoner;
            public string SummonSkillId;
            public int SummonTicks;
            public bool TerrorSunderUsed,TerrorTransforming,TerrorDemon;
            public int LegionDamageCount,LegionDamageCycle;
            public double LegionChargePower,LegionVelocity;
            public bool LegionCharging,LegionCrossed;
            public bool TuskCharged,TuskCriticalUsed;
            public double TuskChargeElapsed;
            public int ClockwerkHeat,ClockwerkMissiles,ClockwerkBlinkTarget,ClockwerkHeatVisual;
            public bool ClockwerkOverheat;
            public double ClockwerkTargetX,ClockwerkTargetY;
            public double UndyingReceivedDamage,UndyingDrainDamage;
            public int UndyingZombieCount;
            public double MarsParriedDamage;
            public double MonkQiElapsed;
            public int MonkQi,MonkBasics;
            public bool DancerLeading;
            public int DruidBearStage,DruidUltimateTick=-1;
            public bool DruidBearDying;
            public double DruidBearBaseDamage,DruidBearDamageReservoir,DruidBearBonusDamage;
            public bool BroodHasNest,BroodBaselineCaptured,BroodAbove;
            public double BroodBaselineDamage,BroodSlamX,BroodSlamY;
            public int BroodPreferredTarget;
            public readonly HashSet<int> BroodFirstTargets=new HashSet<int>();
            public double GlobalCooldown,VerticalSpeed,KnockRemaining,KnockVelocity,PreviousX;
            public bool QueuedUltimate, LifeInsightUsed;
            public double CounterCooldown;
            public int MagicHits;
            public bool RebirthUsed,AuraInitialized;
            public bool TrollUndeadUsed;
            public double BristleDamage;
            public double CycloneTimer=-1,NativeEntryElapsed;
            public bool NativeEntryRefractionUsed;
            public List<BattleSkillData> NativeOriginalSkills;
            public ZatodBattleFormDefinition NativeForm;
            public double NativeOriginalRange;
            public double NativeOriginalDeathSeconds,NativeOriginalHurtSeconds;
            public int PhantomSureCrit;
            public bool PhantomCritical,PhantomTransformPending;
            public int PhoenixRebirths;
            public bool PhoenixEgg;
            public SkillDefinition PhoenixBasic;
            public bool DoomActive;
            public double AuraExtraDamage;
            public double RebirthRemaining=-1, BirthRemaining, HurtRemaining, DispelAnchorHp, BerserkTimer=1, DashTime, DashX, DashY;
            public readonly HashSet<int> RepeatSkills=new HashSet<int>();
            public readonly HashSet<int> HiddenBuffEffects=new HashSet<int>();
            public readonly Dictionary<int,double> SavedCooldowns=new Dictionary<int,double>();
            public readonly Dictionary<string,int> HitCounts=new Dictionary<string,int>();
        }
        sealed class Shot
        {
            public double DamageMultiplier=1;
            public int ActorId,TargetId,PhaseEvent,VisualId,BirthTick,Bounces,BounceIndex;
            public double Elapsed;
            public BattleSkillData Skill;
            public double X,Y,Height,VX,VY,VZ,Remaining,NativeSummonX,NativeSummonY;
            public bool SummonSpawned;
            public double NativePreviousTargetX;
            public double NativeOriginX;
            public HashSet<int> Hit=new HashSet<int>();
            public bool TrackTarget,Tinker;
            public Dictionary<int,int> NativeBounceHits=new Dictionary<int,int>();
        }
        readonly ZatodMatchDefinition initial;
        readonly List<Unit> units=new List<Unit>();
        readonly List<Shot> shots=new List<Shot>();
        readonly List<ZatodInput> inputs=new List<ZatodInput>();
        readonly List<ZatodInput> pending=new List<ZatodInput>();
        readonly Dictionary<int,ZatodBuffDefinition> buffs;
        uint random;
        int tick,wave,waveEntryTicks;
        double waveRemaining;
        bool finished;
        int winner=-1,stars;
        public int CurrentTick=>tick;
        public string BattleId=>initial.BattleId;
        public ZatodMode Mode=>initial.Mode;
        public string BackgroundResource=>initial.Waves[wave].Background;
        public string MusicResource=>initial.MusicResource;
        public bool FlipBackground=>initial.Waves[wave].FlipBackground;
        public bool Finished=>finished;
        public int WaveIndex=>wave+1;
        public int TotalWaves=>initial.Waves.Count;
        public ZatodBattleSimulation(ZatodMatchDefinition definition)
        {
            if(definition==null || !ZatodMatchDefinition.SupportedRules(definition.RulesVersion) || definition.Players==null || definition.Players.Count<1 || definition.Waves==null || definition.Waves.Count<1)
                throw new ArgumentException("Invalid Crystal match definition.");
            initial=Freeze(definition);random=initial.Seed==0?1u:initial.Seed;
            buffs=initial.Buffs.ToDictionary(x=>x.SourceId);
            foreach(var player in initial.Players)units.Add(Create(player));
            SpawnWave();
            foreach(var actor in units)UpdateHudReadiness(actor);
        }
        static ZatodMatchDefinition Freeze(ZatodMatchDefinition value)
            =>new ZatodMatchDefinition
            {
                BattleId=value.BattleId, StageId=value.StageId, ConfigVersion=value.ConfigVersion, RulesVersion=value.RulesVersion,
                MusicResource=value.MusicResource, Seed=value.Seed, Mode=value.Mode,
                EnergyGainMultiplier=value.EnergyGainMultiplier, EnergySupplyPercent=value.EnergySupplyPercent,
                Players=value.Players.ConvertAll(x=>x.Copy()), SummonUnits=value.SummonUnits?.ConvertAll(x=>x.Copy())??new List<ZatodUnitData>(),
                Buffs=value.Buffs.ConvertAll(ZatodMatchFactory.CopyBuff),
                SkillDependencies=value.SkillDependencies?.ConvertAll(x=>x.Copy())??new List<SkillDefinition>(),
                LootDrops=value.LootDrops?.ConvertAll(d=>d.Copy())??new List<ZatodLootDrop>(),
                Waves=value.Waves.ConvertAll(w=>new ZatodWaveData
                {
                    Id=w.Id, Background=w.Background, FlipBackground=w.FlipBackground, TimeLimitSeconds=w.TimeLimitSeconds,
                    Enemies=w.Enemies.ConvertAll(x=>x.Copy()),
                    Hooks=w.Hooks.ConvertAll(h=>new WaveHookDefinition
                    {
                        Id=h.Id, TargetDefinitionId=h.TargetDefinitionId, Action=h.Action, BossOnly=h.BossOnly, PlayerSide=h.PlayerSide, Amount=h.Amount
                    })
                })
            };
        Unit Create(ZatodUnitData data)
        {
            var stats=data.Battle.PreciseStats.Count>0?data.Battle.PreciseStats.ToDictionary(x=>x.StatId,x=>x.Value,StringComparer.Ordinal):data.Battle.Stats.ToDictionary(x=>x.StatId,x=>(double)x.Value,StringComparer.Ordinal);
            var runtime=new Unit{Data=data.Copy(),Base=stats,State=new ZatodUnitState{EntityId=data.EntityId,Team=data.Team,SourceId=data.SourceId,DefinitionId=data.DefinitionId,Name=data.Name,Resource=data.Resource,AnimationSetResource=data.AnimationSetResource?.Replace("Crystal/","Zatod/"),ArtScale=data.ArtScale,FacingRight=data.Team==0},Skills=data.Battle.Skills.ConvertAll(s=>new BattleSkillData{SlotId=s.SlotId,Level=s.Level,IsUltimate=s.IsUltimate,Definition=s.Definition.Copy()})};
            if(data.Battle.HasNormalAttack)runtime.Skills.Add(new BattleSkillData{SlotId="basic",Level=1,Definition=data.Battle.NormalAttack.Copy()});
            runtime.Skills=runtime.Skills.OrderByDescending(x=>x.Definition.Crystal.Priority).ThenBy(x=>x.Definition.Crystal.Slot).ToList();
            foreach(var skill in runtime.Skills)
            {
                if(skill.Definition.Crystal==null || skill.Definition.Crystal.SourceId<=0)throw new ArgumentException("Crystal runtime requires imported skill metadata.");
                foreach(var growth in skill.Definition.Crystal.Growth)
                    if(growth.Field.StartsWith("Script Arg",StringComparison.Ordinal) && int.TryParse(growth.Field.Substring(10),out int arg) && arg>0 && arg<=skill.Definition.Crystal.ScriptArgs.Count)
                        skill.Definition.Crystal.ScriptArgs[arg-1]+=(skill.Level-1)*growth.Amount;
                if(EvolutionRules)SkillEvolution.ApplyParameters(skill.Definition,skill.Level,SummonsEnabled);
                runtime.Cooldowns[skill.Definition.Id]=skill.Definition.Crystal.InitialCooldown;
            }
            runtime.State.MaxHp=Get(runtime,"health");runtime.State.Hp=data.InitialHealth<0?runtime.State.MaxHp:Math.Min(runtime.State.MaxHp,data.InitialHealth);
            runtime.State.HealthBar=new ZatodHealthBarState(HealthFraction(runtime.State,runtime.State.Hp));
            runtime.State.MaxEnergy=Get(runtime,"energy_max",1000);runtime.State.Energy=Math.Min(runtime.State.MaxEnergy,data.InitialEnergy);
            if(EvolutionRules)
            {
                // These source skills are triggered/replacements, not autonomous extra casts.
                if(Native(runtime,162)!=null)runtime.Skills.RemoveAll(x=>x.SlotId=="basic");
                var counter=Native(runtime,283);if(counter!=null)counter.Definition.Crystal.Cooldown=999;
            }
            ExpandedSetup(runtime);RegisterStatistics(data);return runtime;
        }
        Unit Find(int id)=>units.FirstOrDefault(x=>x.State.EntityId==id);
        double Random()
        {
            random^=random<<13;random^=random>>17;random^=random<<5;return random/4294967296d;
        }
        static double Factor(double value)=>value>=0?(100+value)/100:100/(100-value);
        void RefreshNativeHealth(Unit unit)
        {
            if(!ExpandedRules)return;
            unit.State.MaxHp=unit.Data.SourceId==215?3:Math.Max(1,Get(unit,"health"));
            unit.State.Hp=Math.Min(unit.State.Hp,unit.State.MaxHp);
        }
        double Get(Unit unit,string stat,double fallback=0)
        {
            double value=unit.Base.TryGetValue(stat,out double raw)?raw:fallback;
            foreach(var skill in unit.Skills.Where(s=>s.Definition.Crystal.ActiveType=="passive"))
                value+=PassiveContribution(unit,skill,stat);
            foreach(var source in units.Where(u=>u.State.Alive))
            foreach(var skill in source.Skills)
            {
                var info=skill.Definition.Crystal;
                if((info.ActiveType=="aura" && source.State.Team==unit.State.Team || info.ActiveType=="negative_aura" && source.State.Team!=unit.State.Team) )value+=PassiveContribution(unit,skill,stat,source);
            }
            foreach(var buff in unit.Buffs)if(buff.Modifiers.TryGetValue(stat,out double change))value+=change;
            return value;
        }
        bool Controlled(Unit unit,string effect)=>unit.Buffs.Any(b=>(b.Definition.Control??"").Split(new[]{',',' ',';'},StringSplitOptions.RemoveEmptyEntries)
            .Any(control=>control==effect || ExpandedRules && NativeControlIncludes(control,effect)));
        void InterruptCast(Unit unit)
        {
            if(unit.Cast!=null){unit.State.CastInterruptedTick=tick;if(ExpandedRules){NpcInterrupted(unit,unit.Cast);ExpandedFinish(unit,unit.Cast.Skill);} }
            unit.Cast=null;
        }
        bool CanAct(Unit unit)=>unit.State.Alive && (!ExpandedRules || unit.RebirthRemaining<0 && unit.BirthRemaining<=0 && unit.HurtRemaining<=0) && !Controlled(unit,"stun") && !Controlled(unit,"stone") && !Controlled(unit,"sleep") && (!EvolutionRules || !Controlled(unit,"frozen") && !Controlled(unit,"icefrozen") && !Controlled(unit,"fear")) && unit.State.Height<=.0001;
        bool Manual(Unit unit)=>unit.Summoner==null &&
            (initial.Mode==ZatodMode.RealtimePvp || initial.Mode==ZatodMode.Campaign && unit.Data.Team==0);
        public bool UltimateRequested(int actorId)=>pending.Any(x=>x.ActorId==actorId);
        public bool CanActivateUltimate(int actorId)=>CanActivateUltimate(Find(actorId));
        public bool CanActivateUltimate(int actorId,int team)
        {
            var actor=Find(actorId);
            return actor?.State.Team==team && CanActivateUltimate(actor);
        }
        bool CanActivateUltimate(Unit actor)
        {
            if(CanReleaseCharge(actor))return !UltimateRequested(actor.State.EntityId);
            if(finished || waveEntryTicks>0 || actor==null || !Manual(actor) || !CanAct(actor) || !ExpandedRules && Controlled(actor,"silence") || ExpandedRules && Controlled(actor,"unmanual") ||
               actor.QueuedUltimate || UltimateRequested(actor.State.EntityId) ||
               units.Any(u=>u.Cast?.ManualStartup==true))return false;
            var runtimeSkill=actor.Skills.FirstOrDefault(s=>s.IsUltimate);var skill=runtimeSkill?.Definition.Crystal;
            if(skill==null || skill.ActiveType!="active" || actor.State.Energy<skill.CostEnergy)return false;
            if(ExpandedRules && !ExpandedCanCast(actor,runtimeSkill))return false;
            if(skill.TargetType=="self")return true;
            if(skill.TargetType=="target")
            {
                var target=ClosestEnemy(actor);
                return target!=null && InRange(actor,target,skill);
            }
            // Inspect possible targets without drawing from the combat RNG.
            return TargetOptions(actor,skill).Any();
        }
        public bool RequestUltimate(int actorId)
        {
            var actor=Find(actorId);
            if(CanReleaseCharge(actor) && !UltimateRequested(actorId)){pending.Add(new ZatodInput{Tick=tick+1,ActorId=actorId,Team=actor.Data.Team});return true;}
            if(ExpandedRules && !CanActivateUltimate(actor))return false;
            if(finished || waveEntryTicks>0 || actor==null || !Manual(actor) || !CanAct(actor) || actor.QueuedUltimate || pending.Any(x=>x.ActorId==actorId))return false;
            var skill=actor.Skills.FirstOrDefault(s=>s.IsUltimate);
            if(skill==null || actor.State.Energy<skill.Definition.Crystal.CostEnergy || !ExpandedRules && Controlled(actor,"silence"))return false;
            var input=new ZatodInput{Tick=tick+1,ActorId=actorId,Team=actor.Data.Team};pending.Add(input);return true;
        }
        public void QueueInput(ZatodInput input)
        {
            if(waveEntryTicks>0 || input==null || input.Operation!=0 || input.Tick!=tick+1 || pending.Any(x=>x.Tick==input.Tick && x.ActorId==input.ActorId))throw new ArgumentException("Input must target the next uncommitted combat tick exactly once.");
            var actor=Find(input.ActorId);if(actor==null || actor.Data.Team!=input.Team || !Manual(actor))throw new ArgumentException("Input does not belong to a manual actor.");
            var ultimate=actor.Skills.FirstOrDefault(s=>s.IsUltimate);
            if(!CanReleaseCharge(actor) && (ExpandedRules?!CanActivateUltimate(actor):!CanAct(actor) || actor.QueuedUltimate || ultimate==null || actor.State.Energy<ultimate.Definition.Crystal.CostEnergy || Controlled(actor,"silence")))throw new ArgumentException("Ultimate intent is illegal in this state.");
            pending.Add(input.Copy());
        }
        void SpawnWave()
        {
            if(ExpandedRules)ClearRegions();
            units.RemoveAll(x=>x.Data.Team==1 || x.Summoner!=null);shots.Clear();chains.Clear();landings.Clear();visualEffects.Clear();
            var definition=initial.Waves[wave];waveRemaining=definition.TimeLimitSeconds;
            foreach(var enemy in definition.Enemies)units.Add(Create(enemy));
            units.Sort((a,b)=>a.State.EntityId.CompareTo(b.State.EntityId));
            foreach(var team in new[]{0,1})
            {
                var row=units.Where(x=>x.Data.Team==team).OrderBy(x=>Get(x,"attack_range")).ThenBy(x=>x.Data.SourceId).ToArray();
                for(int i=0;i<row.Length;i++)
                {
                    row[i].State.X=team==0?-i*80:800+i*80;row[i].State.Y=i%2==0?0:-40;row[i].State.Height=0;row[i].PreviousX=row[i].State.X;
                    row[i].Cast=null;row[i].QueuedUltimate=false;row[i].GlobalCooldown=0;
                    foreach(var skill in row[i].Skills)row[i].Cooldowns[skill.Definition.Id]=skill.Definition.Crystal.InitialCooldown;
                    row[i].State.Action=row[i].State.Alive?"Idle":"Death";row[i].State.ActionElapsed=0;
                }
            }
            foreach(var hook in definition.Hooks)
            foreach(var actor in units.Where(u=>hook.PlayerSide?u.Data.Team==0:u.Data.Team==1))
            {
                if(hook.BossOnly && !actor.Data.Boss || !string.IsNullOrEmpty(hook.TargetDefinitionId) && actor.Data.DefinitionId!=hook.TargetDefinitionId)continue;
                if(hook.Action==WaveHookAction.AddEnergy)GainEnergy(actor,hook.Amount);
                else if(hook.Action==WaveHookAction.SetEnergy)actor.State.Energy=Math.Clamp(hook.Amount,0,actor.State.MaxEnergy);
                else actor.Data.AllowAutomaticUltimate=hook.Amount!=0;
            }
            ExpandedBeginWave();
        }
        public bool Step()
        {
            if(finished)return false;
            tick++;combatEvents.RemoveAll(e=>tick-e.Tick>12);
            if(waveEntryTicks>0)
            {
                waveEntryTicks--;
                UpdateHealthBars();
                return true;
            }
            foreach(var input in pending.OrderBy(x=>x.ActorId))
            {
                var actor=Find(input.ActorId);var skill=actor?.Skills.FirstOrDefault(x=>x.IsUltimate);
                if(CanReleaseCharge(actor)){ReleaseCharge(actor);continue;}
                if(actor!=null && skill!=null && CanAct(actor))
                {
                    var target=Target(actor,skill.Definition.Crystal,ClosestEnemy(actor));
                    if(target!=null && InRange(actor,target,skill.Definition.Crystal))Start(actor,skill,target,true);
                }
            }
            bool frozen=units.Any(u=>u.Cast!=null && u.Cast.ManualStartup);
            if(!frozen)waveRemaining-=StepSeconds;
            foreach(var input in pending.OrderBy(x=>x.ActorId))
            {
                var actor=Find(input.ActorId);
                if(actor==null || actor.Data.Team!=input.Team || !Manual(actor))throw new ArgumentException("Input actor missing.");
                actor.QueuedUltimate=!CanReleaseCharge(actor) && (actor.Cast==null || !actor.Cast.ManualStartup);inputs.Add(input.Copy());
            }
            pending.Clear();
            if(!frozen)
            {
                AdvanceSummonLifetimes();
                foreach(var dead in units.Where(u=>!u.State.Alive))
                {
                    dead.State.ActionElapsed+=StepSeconds;
                    dead.State.DeathElapsed+=StepSeconds;
                }
                AdvanceVisualEffects();AdvanceBuffs();ExpandedTick();AdvanceRegions();
            }
            foreach(var actor in units.ToArray())
            {
                if(!actor.State.Alive || actor.Summoner?.State.Alive==false)continue;
                if(units.Any(u=>u.Cast!=null && u.Cast.ManualStartup) && (actor.Cast==null || !actor.Cast.ManualStartup)){actor.State.ActionSpeed=0;continue;}
                actor.PreviousX=actor.State.X;
                if(actor.State.Height>0 || actor.VerticalSpeed!=0)
                {
                    actor.State.Height=Math.Max(0,actor.State.Height+actor.VerticalSpeed*StepSeconds);
                    actor.VerticalSpeed-=1800*StepSeconds;if(actor.State.Height==0)actor.VerticalSpeed=0;
                }
                if(actor.KnockRemaining>0){actor.State.X+=actor.KnockVelocity*StepSeconds;actor.KnockRemaining-=StepSeconds;}
                double dtAction=StepSeconds*Factor(Math.Max(actor.Data.Boss?-75:double.MinValue,Get(actor,"action_speed")));
                if(ExpandedRules && actor.BirthRemaining>0)
                {actor.BirthRemaining=Math.Max(0,actor.BirthRemaining-dtAction);actor.State.ActionElapsed+=dtAction;continue;}
                if(ExpandedRules && actor.HurtRemaining>0)
                {
                    if(!Controlled(actor,"frozen") && !Controlled(actor,"icefrozen"))
                    {actor.HurtRemaining=Math.Max(0,actor.HurtRemaining-dtAction);actor.State.ActionElapsed+=dtAction;}
                    continue;
                }
                double dtCooldown=StepSeconds*Factor(Math.Max(actor.Data.Boss?-50:double.MinValue,Get(actor,"haste")));actor.State.ActionSpeed=dtAction/StepSeconds;
                actor.GlobalCooldown-=dtCooldown;
                if(EvolutionRules)actor.CounterCooldown-=StepSeconds;
                foreach(var skill in actor.Skills)
                    if(actor.Cast==null || actor.Cast.Skill!=skill)actor.Cooldowns[skill.Definition.Id]-=dtCooldown;
                if(EvolutionRules && MoveInFear(actor,dtAction))continue;
                if(!CanAct(actor)){actor.State.ActionElapsed+=dtAction;continue;}
                if(actor.Cast!=null){AdvanceCast(actor,dtAction);continue;}
                var enemy=ClosestEnemy(actor);if(enemy==null)continue;
                BattleSkillData selected=null;Unit target=null;
                if(actor.GlobalCooldown<=0)
                foreach(var skill in actor.Skills)
                {
                    var info=skill.Definition.Crystal;
                    if(info.ActiveType!="active" || !ExpandedCanCast(actor,skill) || actor.Cooldowns[skill.Definition.Id]>0 || actor.State.Energy<info.CostEnergy)continue;
                    if(skill.IsUltimate && (Manual(actor)?!actor.QueuedUltimate:!actor.Data.AllowAutomaticUltimate))continue;
                    if(!ExpandedRules && (skill.SlotId=="basic"?Controlled(actor,"disarm"):Controlled(actor,"silence")))continue;
                    var victim=Target(actor,info,enemy);
                    if(victim==null || !InRange(actor,victim,info))continue;
                    if(info.DamageType=="Heal" && victim.State.Hp>=victim.State.MaxHp && string.IsNullOrEmpty(info.AoeShape) && !(ExpandedRules && info.SourceId==1762))continue;
                    selected=skill;target=victim;break;
                }
                if(selected!=null)Start(actor,selected,target,selected.IsUltimate);
                else if(Distance(actor,enemy)>Math.Max(0,Get(actor,"attack_range")/10) && !Controlled(actor,"immoblilize") && (!ExpandedRules || !Controlled(actor,"fix")))
                {
                    double dx=enemy.State.X-actor.State.X,dy=enemy.State.Y-actor.State.Y;dx*=Math.Abs(dx);dy*=Math.Abs(dy);
                    double length=Math.Max(.00001,Math.Sqrt(dx*dx+dy*dy)),delta=Get(actor,"move_speed")/10*dtAction;
                    if(dx!=0)actor.State.FacingRight=dx>0;
                    actor.State.X+=dx/length*delta;actor.State.Y+=dy/length*delta;
                    if(actor.State.Action!="Move")actor.State.ActionElapsed=0;else actor.State.ActionElapsed+=dtAction;actor.State.Action="Move";
                }
                else {if(actor.State.Action!="Idle")actor.State.ActionElapsed=0;else actor.State.ActionElapsed+=dtAction;actor.State.Action="Idle";}
            }
            PruneSummons();
            if(!units.Any(u=>u.Cast!=null && u.Cast.ManualStartup)){AdvanceChains();AdvanceShots();}
            PruneSummons();
            if((tick-1)%4==0)PushApart();
            if(!units.Any(x=>x.Summoner==null && x.Data.Team==0 && x.State.Alive)){finished=true;winner=1;}
            else if(!units.Any(x=>x.Summoner==null && x.Data.Team==1 && x.State.Alive))
            {
                if(wave+1<initial.Waves.Count)
                {
                    Supply();wave++;SpawnWave();
                    if(initial.Mode==ZatodMode.Campaign && (initial.RulesVersion==ZatodMatchDefinition.WaveEntryRulesV5 || SummonsEnabled))
                        waveEntryTicks=WaveEntryTicks;
                }
                else {finished=true;winner=0;stars=Math.Max(1,3-units.Count(x=>x.Summoner==null && x.Data.Team==0 && !x.State.Alive));}
            }
            else if(waveRemaining<=0){finished=true;winner=initial.Mode==ZatodMode.Campaign?1:-1;}
            UpdateHealthBars();
            return !finished;
        }
        void PushApart()
        {
            foreach(int team in new[]{0,1})
            {
                var row=units.Where(u=>u.State.Alive && u.State.Team==team).ToArray();
                for(int i=0;i<row.Length;i++)
                {
                    var actor=row[i];if(actor.Cast!=null || !CanAct(actor) || Controlled(actor,"immoblilize"))continue;
                    double velocity=0;
                    for(int j=i+1;j<row.Length;j++)if(Distance(actor,row[j])<actor.Data.Radius+row[j].Data.Radius)velocity+=actor.State.Y>row[j].State.Y?30:-30;
                    if(actor.State.Y>120 && velocity>0 || actor.State.Y< -120 && velocity<0)velocity=0;
                    actor.State.Y+=velocity*StepSeconds;
                    if(velocity!=0)actor.State.Action="Move";
                }
            }
        }
        void Supply()
        {
            foreach(var actor in units.Where(x=>x.Summoner==null && x.Data.Team==0 && x.State.Alive))
            {
                Heal(actor,Math.Max(0,Get(actor,"wave_health_regen")));
                double ratio=initial.EnergySupplyPercent>0?initial.EnergySupplyPercent/100:1;
                GainEnergy(actor,Math.Max(0,Get(actor,"wave_energy_regen"))*ratio);
                actor.Buffs.Clear();
            }
        }
        static double Distance(Unit a,Unit b)=>Math.Sqrt(Math.Pow(a.State.X-b.State.X,2)+Math.Pow(a.State.Y-b.State.Y,2));
        Unit ClosestEnemy(Unit actor)=>(ExpandedRules && actor.Data.SourceId==250?BroodSpiderTarget(actor):null)??NativeTaunter(actor)??units.Where(x=>x!=actor && x.State.Alive && CampMatches(actor,x,-1) && !Controlled(x,"untargetable") && !HiddenFrom(actor,x)).OrderBy(x=>Distance(actor,x)).ThenBy(x=>x.State.EntityId).FirstOrDefault();
        bool InRange(Unit a,Unit b,ZatodSkillDefinition skill)=>a==b || (Distance(a,b)>=skill.MinRange && (skill.MaxRange<=0 || Distance(a,b)<=skill.MaxRange));
        Unit Target(Unit actor,ZatodSkillDefinition skill,Unit current)
        {
            if(ExpandedRules && skill.SourceId==1280 && actor.Cast?.AttackCounter>=1)return Find(actor.Cast.TargetId);
            if(ExpandedRules && skill.SourceId==510 && actor.Cast?.AttackCounter>=1)return Find(actor.Cast.TargetId);
            var selected=DefaultTarget(actor,skill,current);
            if(!ExpandedRules || skill.SourceId!=510 || selected==null)return selected;
            var ability=Native(actor,510);double damage=2*Power(actor,ability);
            if(damage<=selected.State.Hp)return selected;
            return TargetOptions(actor,skill).Where(u=>u.Summoner==null && !Controlled(u,"invulnerable") &&
                u.State.Hp<=damage*(1-Get(u,"all_immunity")/100) && u.State.Hp>=selected.State.Hp).OrderByDescending(u=>u.State.Hp).FirstOrDefault()??selected;
        }
        Unit DefaultTarget(Unit actor,ZatodSkillDefinition skill,Unit current)
        {
            if(skill.TargetType=="self")return actor;
            if(skill.TargetType=="target")return ExpandedRules && current!=null && !CampMatches(actor,current,skill.TargetCamp)?null:current;
            var options=TargetOptions(actor,skill).OrderBy(x=>x.State.EntityId).ToList();
            if(options.Count==0)return null;
            if(ExpandedRules && skill.TargetType=="nearestnotcaster")return options.Where(u=>u!=actor).OrderBy(u=>Distance(actor,u)).FirstOrDefault();
            if(ExpandedRules && skill.TargetType=="maxadinscreen")return options.OrderByDescending(u=>Get(u,"damage")).First();
            if(ExpandedRules && skill.TargetType=="maxmp")return options.OrderByDescending(x=>x.State.Energy).First();
            if(ExpandedRules && skill.SourceId==554)
            {
                Unit selected=null;double maximum=double.NegativeInfinity;
                foreach(var candidate in options)
                {
                    double value=-Distance(actor,candidate);
                    if(selected?.Summoner!=null && candidate.Summoner==null || value>maximum){selected=candidate;maximum=value;}
                }
                return selected;
            }
            if(ExpandedRules && skill.TargetType=="maxmpnotfull")return options.OrderByDescending(x=>Math.Max(x.State.Energy,1)%1000).First();
            if(skill.TargetType=="random")
            {
                if(ExpandedRules)return options.Select(u=>new{Unit=u,Score=Random()}).OrderByDescending(x=>x.Score).ThenBy(x=>x.Unit.State.EntityId).First().Unit;
                return options[Math.Min(options.Count-1,(int)(Random()*options.Count))];
            }
            if(ExpandedRules && skill.TargetType=="weakest")return options.OrderBy(x=>x.State.Hp/x.State.MaxHp).First();
            if(ExpandedRules && skill.TargetType=="strongest")return options.OrderByDescending(x=>x.State.Hp/x.State.MaxHp).First();
            if(skill.TargetType=="weakest" || skill.TargetType=="minhp")return options.OrderBy(x=>x.State.Hp).First();
            if(skill.TargetType=="maxhpinscreen" || skill.TargetType=="maxhp")return options.OrderByDescending(x=>x.State.Hp).First();
            if(skill.TargetType=="farthest" || ExpandedRules && skill.TargetType=="farthestinscreen")return options.OrderByDescending(x=>Distance(actor,x)).First();
            return options.OrderBy(x=>Distance(actor,x)).First();
        }
        bool NativeIgnoresTarget(Unit actor,Unit target,string filter)
        {
            if(!ExpandedRules)return false;
            return filter=="summon" && target.Summoner!=null || filter=="self" && actor==target || filter=="building" && Controlled(target,"building") ||
                filter is "uncontrollbale" or "uncontrollbalesummon" && Controlled(target,"uncontrollable") || filter=="uncontrollbalesummon" && target.Summoner!=null;
        }
        IEnumerable<Unit> TargetOptions(Unit actor,ZatodSkillDefinition skill)
            =>units.Where(u=>u.State.Alive && CampMatches(actor,u,skill.TargetCamp) &&
                (u.State.Team==actor.State.Team || !Controlled(u,"untargetable")) && !HiddenFrom(actor,u) && !NativeIgnoresTarget(actor,u,skill.IgnoreTargetType) &&
                (!ExpandedRules || !Controlled(actor,"enchanted") || u!=actor) &&
                (!ExpandedRules || skill.SourceId is not (950 or 953) || u.Summoner==null) &&
                (!ExpandedRules || skill.SourceId!=654 || u.Summoner!=null) &&
                (!ExpandedRules || skill.SourceId!=1280 || u.State.X>=0 && u.State.X<=800) &&
                (!ExpandedRules || skill.SourceId!=650 || !Controlled(u,"undoom") && !Controlled(u,"invulnerable")) && InRange(actor,u,skill));
        void Start(Unit actor,BattleSkillData skill,Unit target,bool manual=false)
        {
            var info=skill.Definition.Crystal;
            if(info.Phases.Count==0)throw new InvalidOperationException("Active Crystal skill has no phase: "+info.SourceId);
            if(actor.Cast!=null)FinishSpecial(actor);
            if(target!=actor && target.State.X!=actor.State.X)actor.State.FacingRight=target.State.X>actor.State.X;
            actor.Cast=new Cast{Skill=skill,TargetId=target.State.EntityId,ManualStartup=manual,OriginX=actor.State.X,OriginY=actor.State.Y};actor.State.Action=info.Phases[0].Action;actor.State.ActionElapsed=0;
            if(manual && skill.IsUltimate && Manual(actor))actor.State.UltimateCastTick=tick;
            actor.Cooldowns[skill.Definition.Id]=info.Cooldown;actor.GlobalCooldown=info.GlobalCooldown;
            actor.State.Energy=Math.Max(0,actor.State.Energy-info.CostEnergy*(1-Math.Min(50,Get(actor,"energy_cost_reduction"))/100));
            Effect(info.LaunchEffect,"launch",actor);
            if(info.SourceId==73)SpecialBuff(actor,actor,skill,10000701);
            if(info.SourceId==100){SpecialBuff(actor,target,skill,10001004);Effect("eff_point_Sniper_ult.cha","point",target);}
            if(info.SourceId==200)SpecialBuff(actor,target,skill,10002001);
            if(info.SourceId==40)foreach(var enemy in units.Where(u=>u.State.Alive && u.State.Team!=actor.State.Team))SpecialBuff(actor,enemy,skill,10000402);
            ExpandedStart(actor,target,skill);
            if(EvolutionRules)EvolutionEvent(actor,target,skill,SkillEvolutionEvent.CastStart);
            if(skill.IsUltimate)actor.QueuedUltimate=false;
        }
        void AdvanceCast(Unit actor,double dt)
        {
            var cast=actor.Cast;var info=cast.Skill.Definition.Crystal;var phase=info.Phases[cast.Phase];
            if(ExpandedRules && info.SourceId==390){dt=StepSeconds;actor.State.ActionSpeed=1;}
            ExpandedAdvanceCast(actor,dt);cast.Elapsed+=dt;actor.State.ActionElapsed=cast.Elapsed;
            if(info.SourceId==200 && cast.Elapsed>.1 && !cast.SpecialVisual){var target=Find(cast.TargetId);if(target!=null)Effect("eff_point_NEC_ult.cha","point",target);cast.SpecialVisual=true;}
            while(cast.Event<phase.AttackTimes.Count && phase.AttackTimes[cast.Event]<=cast.Elapsed+.0000001)
            {
                var target=Target(actor,info,Find(cast.TargetId) is Unit old && old.State.Alive?old:ClosestEnemy(actor));
                cast.AttackCounter++;
                if(target!=null)Release(actor,target,cast.Skill,cast.Event);
                else if(ExpandedRules && info.SourceId==654)NpcDevourUnavailable(actor,cast.Skill);
                if(!(ExpandedRules && info.SourceId==1760 && actor.DruidUltimateTick>=0))cast.ManualStartup=false;
                cast.Event++;
            }
            if(cast.Elapsed+1e-8<phase.Duration)return;
            if(ExpandedRules)NpcPhaseFinished(actor,cast.Skill,cast.Phase);
            if(cast.Phase+1<info.Phases.Count && !(ExpandedRules && info.SourceId is 611 or 613 or 21502 or 11101 or 1280 or 1281 or 1282 or 1283))
            {
                if(ExpandedRules && info.SourceId==462 && cast.Phase==0)actor.Buffs.RemoveAll(b=>b.Definition.SourceId==10004602);
                cast.Phase++;cast.Elapsed=0;cast.Event=0;actor.State.Action=info.Phases[cast.Phase].Action;actor.State.ActionElapsed=0;
            }
            else {if(EvolutionRules)EvolutionCastFinished(actor,cast.Skill);FinishSpecial(actor);actor.Cast=null;if(!ExpandedRules || actor.State.Alive){actor.State.Action="Idle";actor.State.ActionElapsed=0;}}
        }
        double Power(Unit actor,BattleSkillData skill)
        {
            var info=skill.Definition.Crystal;double value=info.BasicAmount;
            foreach(var field in info.Growth)if(field.Field=="Basic Num")value+=(skill.Level-1)*field.Amount;
            return value+info.PlusRatio*Get(actor,Attribute(info.PlusAttribute));
        }
        static double BasicAmount(BattleSkillData skill)
        {
            var info=skill.Definition.Crystal;
            return info.BasicAmount+info.Growth.Where(g=>g.Field=="Basic Num").Sum(g=>(skill.Level-1)*g.Amount);
        }
        static readonly Dictionary<string,string> attributes=new Dictionary<string,string>(StringComparer.Ordinal)
        {
            {"HP","health"},
            {"MP","energy_max"},
            {"AD","damage"},
            {"AP","ability_power"},
            {"ARM","defense"},
            {"MR","magic_resistance"},
            {"CRIT","physical_crit"},
            {"MCRIT","magic_crit"},
            {"LFS","lifesteal"},
            {"HAST","haste"},
            {"MSPD","action_speed"},
            {"TEN","tenacity"},
            {"SILR","silence_resistance"},
            {"HPR","health_regen"},
            {"MPR","energy_regen"},
            {"HIT","accuracy"},
            {"DODG","dodge"},
            {"ARMP","armor_penetration"},
            {"MRI","magic_penetration"},
            {"HEAL","healing_bonus"},
            {"HealRatio","heal_ratio"},
            {"CDR","energy_cost_reduction"},
            {"DOTRES","dot_resistance"},
            {"CRITRES","physical_crit_resistance"},
            {"MCRITRES","magic_crit_resistance"},
            {"PIMU","physical_immunity"},
            {"MIMU","magic_immunity"},
            {"ALLIMU","all_immunity"},
            {"KMPR","kill_energy"},
            {"HPS","wave_health_regen"},
            {"MPS","wave_energy_regen"}
        };
        static string Attribute(string source)=>source!=null && attributes.TryGetValue(source,out var mapped)?mapped:(source??"").ToLowerInvariant();
        public ZatodFrame Frame()
        {
            var frame=new ZatodFrame{Tick=tick,Wave=wave+1,Finished=finished,Winner=winner,Stars=stars,DimForUltimate=!finished && units.Any(IsUltimateStartup),Units=units.Select(PresentationUnit).ToList(),Visuals=Visuals(),TimeRemaining=Math.Max(0,waveRemaining),CombatEvents=combatEvents.ConvertAll(e=>e.Copy())};
            frame.WaveEntryRemaining=waveEntryTicks*StepSeconds;
            frame.Digest=Digest(frame);return frame;
        }
        public ZatodReplay Replay()=>new ZatodReplay{Initial=Freeze(initial),Inputs=inputs.ConvertAll(x=>x.Copy()),EndTick=tick,Winner=winner,Stars=stars,Completed=finished,Digest=Frame().Digest,Statistics=Statistics()};
        public ZatodReplay RunToCompletion(){while(!finished)Step();return Replay();}
        static ulong Digest(ZatodFrame frame)
        {
            ulong hash=14695981039346656037UL;
            Action<long> add=value=>{unchecked{for(int i=0;i<8;i++){hash^=(byte)(value>>(i*8));hash*=1099511628211UL;}}};
            add(frame.Tick);add(frame.Wave);add(frame.Winner);add(frame.Stars);
            foreach(var u in frame.Units.OrderBy(x=>x.EntityId))
            {
                add(u.EntityId);add(u.Team);add(u.FacingRight?1:0);add(BitConverter.DoubleToInt64Bits(u.Hp));add(BitConverter.DoubleToInt64Bits(u.Energy));add(BitConverter.DoubleToInt64Bits(u.X));add(BitConverter.DoubleToInt64Bits(u.Y));add(BitConverter.DoubleToInt64Bits(u.Height));add(BitConverter.DoubleToInt64Bits(u.ActionElapsed));
                if(u.SummonerId!=0){add(u.SummonerId);add(u.SummonTicks);}
            }
            return hash;
        }
    }
}
