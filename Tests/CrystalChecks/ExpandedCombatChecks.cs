using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.Combat;

static partial class Program
{
    static object InvokeCore(ZatodBattleSimulation simulation,string method,params object[] args)
    {
        var target=typeof(ZatodBattleSimulation).GetMethod(method,BindingFlags.Instance|BindingFlags.Static|BindingFlags.NonPublic);
        try{return target.Invoke(simulation,args.Concat(target.GetParameters().Skip(args.Length).Select(p=>p.DefaultValue)).ToArray());}
        catch(TargetInvocationException error){throw error.InnerException;}
    }
    static HeroData ExpandedHero(HeroCatalog catalog,string id,int skillLevel)
    {
        var hero=catalog.CreateHero(id,"expanded-"+id);hero.Level=80;hero.Stars=3;
        while(hero.RankId!="purple")
        {
            foreach(var slot in HeroProgression.CurrentRank(hero,catalog).EquipmentSlots)HeroProgression.Equip(hero,catalog,slot.Id,slot.RequiredItemId);
            HeroProgression.Promote(hero,catalog);
        }
        foreach(var skill in hero.Skills)skill.Level=skillLevel;
        return hero;
    }
    static ZatodBattleSimulation ExpandedFixture(HeroCatalog catalog,string id,int level=80,bool realtime=false)
    {
        var match=ZatodMatchFactory.Versus(catalog,new[]{ExpandedHero(catalog,id,level),ExpandedHero(catalog,"coco",level)},new[]{ExpandedHero(catalog,"dr",level),ExpandedHero(catalog,"coco",level)},117,"expanded-"+id,realtime);
        foreach(var unit in match.Players.Concat(match.Waves[0].Enemies))unit.InitialEnergy=1000;
        var sim=new ZatodBattleSimulation(match);
        return sim;
    }
    static BattleSkillData NativeSkill(object unit,int id)=>((List<BattleSkillData>)Member(unit,"Skills")).Single(s=>s.Definition.Crystal.SourceId==id);
    static void SuppressAi(ZatodBattleSimulation sim)
    {
        foreach(var unit in Units(sim))
        {
            unit.GetType().GetField("GlobalCooldown").SetValue(unit,100000d);
            foreach(string id in ((Dictionary<string,double>)Member(unit,"Cooldowns")).Keys.ToArray())((Dictionary<string,double>)Member(unit,"Cooldowns"))[id]=100000;
        }
    }
    static void ExpandedCombatChecks(string directory)
    {
        int checksBeforeNative=checks;
        var catalog=ImportedCatalog(directory);
        Check(catalog.Data.Heroes.Count>=40,"D34 catalog needs approved roster");
        var baseline=ImportedCatalog();
        foreach(var old in baseline.Data.Skills.Where(s=>s.Evolutions.Count>0))
        {
            var current=catalog.Skill(old.Id).Copy();current.Crystal.EnemyUnlockRank=old.Crystal.EnemyUnlockRank;current.Crystal.IgnoreTargetType=old.Crystal.IgnoreTargetType;
            Check(JsonSerializer.Serialize(old,Json)==JsonSerializer.Serialize(current,Json),"Prior D35 skill was overwritten: "+old.Id);
        }
        int boundaryCases=0;
        foreach(var hero in catalog.Data.Heroes)
        foreach(var slot in hero.SkillSlots)
        foreach(int level in new[]{60,80})
        {
            string text=SkillDescription.Describe(catalog.Skill(slot.SkillId),level,catalog);
            Check(!string.IsNullOrWhiteSpace(text) && !text.Contains("%Skill&") && !text.Contains("%Buff&") && !text.Contains("<lable") && !text.Contains("\\n"),"Incomplete rendered skill description: "+slot.SkillId+"/"+level);
        }
        foreach(var hero in catalog.Data.Heroes.Take(40))
        foreach(var slot in hero.SkillSlots)
        {
            var skill=catalog.Skill(slot.SkillId);
            Check(skill.Evolutions.Count==3,"Three source milestones: "+skill.Id);
            foreach(var evo in skill.Evolutions)
            foreach(int level in new[]{evo.RequiredSkillLevel-1,evo.RequiredSkillLevel})
            {
                Check(SkillEvolution.Active(skill,level).Contains(evo)==(level>=evo.RequiredSkillLevel),"Evolution boundary: "+evo.Id);
                var detached=skill.Copy();SkillEvolution.ApplyParameters(detached,level);boundaryCases++;
            }
        }
        foreach(var hero in catalog.Data.Heroes)
        foreach(int level in new[]{60,80})
        {
            var simulation=ExpandedFixture(catalog,hero.Id,level);
            var initial=simulation.Replay().Initial;
            Check(initial.RulesVersion==ZatodMatchDefinition.ExpandedRulesV7,"Native content must select V7: "+hero.Id);
            for(int tick=0;tick<160 && !simulation.Finished;tick++)simulation.Step();
            var replay=simulation.Replay();var reproduced=ZatodBattleSimulation.Resimulate(replay);
            Check(replay.Digest==reproduced.Digest && replay.EndTick==reproduced.EndTick,"V7 replay drift: "+hero.Id+"/"+level);
            foreach(var unit in Units(simulation))
                Check(double.IsFinite(UnitState(unit).Hp) && UnitState(unit).Hp>=0 && double.IsFinite(UnitState(unit).X),"Invalid native state: "+hero.Id);
        }
        {
            var sim=ExpandedFixture(catalog,"coco",60);var actor=Units(sim)[0];
            double hp=(double)InvokeCore(sim,"Get",actor,"health",0d),damage=(double)InvokeCore(sim,"Get",actor,"damage",0d);
            var passive=NativeSkill(actor,14);var baseStats=(Dictionary<string,double>)Member(actor,"Base");
            double amount=(double)InvokeCore(sim,"BasicAmount",passive);
            Check(Math.Abs(hp-baseStats["health"]-amount*18)<.00001,"STR passive converted to direct HP");
            Check(damage>baseStats["damage"],"STR passive converted to direct attack");
        }
        {
            var sim=ExpandedFixture(catalog,"snk",60);SuppressAi(sim);var target=Units(sim)[0];var source=Units(sim)[2];var state=UnitState(target);
            InvokeCore(sim,"Damage",source,target,1e9,"Holy",0d);
            Check(state.Alive && state.Hp==1 && state.Action=="Death","SNK first lethal enters delayed rebirth");
            for(int tick=0;tick<19;tick++)sim.Step();Check(state.Hp==1,"SNK must wait 2.5 seconds");
            sim.Step();var skill=NativeSkill(target,195);
            double expected=Math.Min(state.MaxHp,.1*state.MaxHp+(double)InvokeCore(sim,"BasicAmount",skill));
            Check(Math.Abs(state.Hp-expected)<.0001,"SNK source rebirth HP");
            Check(state.Action=="Birth" && !(bool)InvokeCore(sim,"CanAct",target),"SNK holds native Birth action");
            for(int tick=0;tick<19;tick++)sim.Step();
            Check((bool)InvokeCore(sim,"CanAct",target),"SNK resumes after native Birth duration");
        }
        {
            var sim=ExpandedFixture(catalog,"kotl",60,true);SuppressAi(sim);var actor=Units(sim)[0];var target=Units(sim)[1];var skill=NativeSkill(actor,392);
            UnitState(target).Energy=0;double hp=UnitState(target).Hp;
            InvokeCore(sim,"ApplySkill",actor,target,skill,false,1d);
            Check(UnitState(target).Energy>0 && UnitState(target).Hp==hp,"Chakra restores energy, not HP before third Evo");
            sim=ExpandedFixture(catalog,"kotl",60,true);actor=Units(sim)[0];
            Check(sim.RequestUltimate(UnitState(actor).EntityId),"KOTL initial intent");sim.Step();
            for(int tick=0;tick<10;tick++)sim.Step();
            Check(sim.CanActivateUltimate(UnitState(actor).EntityId),"KOTL second tap during charge");
            Check(sim.RequestUltimate(UnitState(actor).EntityId),"KOTL charge trigger");sim.Step();
            var shots=Members(sim,"shots");Check(shots.Count>0,"Charge trigger launches projectile");
            double ratio=(double)Member(shots.Last(),"DamageMultiplier");Check(ratio>0 && ratio<1,"Early release preserves partial charge on shot");
            var replay=sim.Replay();Check(ZatodBattleSimulation.Resimulate(replay).Digest==replay.Digest,"Charge trigger input replay");
        }
        {
            var sim=ExpandedFixture(catalog,"kotl",60,true);var actor=Units(sim)[0];
            Check(sim.RequestUltimate(UnitState(actor).EntityId),"KOTL interruption setup");
            for(int i=0;i<12;i++)sim.Step();
            InvokeCore(sim,"InterruptCast",actor);
            var shots=Members(sim,"shots");
            Check(shots.Count==1 && (double)Member(shots[0],"DamageMultiplier")>0 && (double)Member(shots[0],"DamageMultiplier")<1,"KOTL interruption releases partial wave once");
        }
        {
            var sim=ExpandedFixture(catalog,"wr",60);SuppressAi(sim);var actor=Units(sim)[0];var target=Units(sim)[2];
            ((Dictionary<string,double>)Member(target,"Base"))["mdodg"]=100;
            double hp=UnitState(target).Hp;
            InvokeCore(sim,"ApplySkill",actor,target,NativeSkill(actor,112));
            Check(UnitState(target).Hp==hp && !((System.Collections.IEnumerable)Member(target,"Buffs")).Cast<object>().Any(),"Missed shackle applies no stun");
            sim=ExpandedFixture(catalog,"vs",60);SuppressAi(sim);actor=Units(sim)[0];target=Units(sim)[2];
            ((ZatodUnitData)Member(target,"Data")).Level=60; // Isolate damage dodge from the separate level-based buff check.
            ((Dictionary<string,double>)Member(target,"Base"))["mdodg"]=100;hp=UnitState(target).Hp;
            InvokeCore(sim,"ApplySkill",actor,target,NativeSkill(actor,322));
            Check(UnitState(target).Hp<hp && (bool)InvokeCore(sim,"Controlled",target,"stun"),"VS second evolution cannot be dodged");
        }
        {
            var sim=ExpandedFixture(catalog,"av",60);SuppressAi(sim);var actor=Units(sim)[0];var target=Units(sim)[2];
            var source=catalog.Data.Skills.Single(s=>s.Crystal.SourceId==368);
            var region=new BattleSkillData{Level=60,Definition=source.Copy()};
            double hp=UnitState(target).Hp;
            InvokeCore(sim,"CreateRegion",actor,target,region);
            Check(!((System.Collections.IEnumerable)Member(target,"Buffs")).Cast<object>().Any(),"Region waits its birth tick");
            sim.Step();Check(((System.Collections.IEnumerable)Member(target,"Buffs")).Cast<object>().Any(),"Region applies buff inside its source shape");
            Check(UnitState(target).Hp==hp,"A buff region does not deal direct damage");
            UnitState(target).X=3000;sim.Step();
            Check(!((System.Collections.IEnumerable)Member(target,"Buffs")).Cast<object>().Any(),"Leaving a region removes its own buff");
            UnitState(target).X=UnitState(actor).X;UnitState(target).Y=UnitState(actor).Y;
            for(int i=0;i<10;i++)sim.Step();
            Check(Members(sim,"regions").Count==0,"Expired regions are removed");
        }
        int encounterMilestones=0;
        {
            var sim=ExpandedFixture(catalog,"coco",60);SuppressAi(sim);var target=Units(sim)[0];var attacker=Units(sim)[2];var state=UnitState(target);
            InvokeCore(sim,"Damage",attacker,target,state.MaxHp*.079,"Holy",0d);
            Check((bool)InvokeCore(sim,"CanAct",target),"Subthreshold damage does not cause Hurt");
            InvokeCore(sim,"Damage",attacker,target,state.MaxHp*.081,"Holy",0d);
            Check(state.Action=="Damaged" && !(bool)InvokeCore(sim,"CanAct",target),"Native Hurt also interrupts an idle unit");
            for(int i=0;i<40;i++)sim.Step();
            Check((bool)InvokeCore(sim,"CanAct",target),"Native Damaged action releases after its source duration");
            sim=ExpandedFixture(catalog,"coco",60);SuppressAi(sim);target=Units(sim)[0];attacker=Units(sim)[2];
            ((Dictionary<string,double>)Member(target,"Base"))["reshurt"]=1000;
            InvokeCore(sim,"Damage",attacker,target,UnitState(target).MaxHp*.1,"Holy",0d);
            Check((bool)InvokeCore(sim,"CanAct",target) && UnitState(target).DamageReactionTick<0,"RESHURT can suppress the native reaction");
            sim=ExpandedFixture(catalog,"cm",80);SuppressAi(sim);var actor=Units(sim)[0];target=Units(sim)[2];
            InvokeCore(sim,"ApplySkill",actor,target,NativeSkill(actor,123));
            Check(sim.Frame().Units.Single(u=>u.EntityId==UnitState(target).EntityId).Shader==ZatodBuffShader.Frozen,"Buff shader travels through the match snapshot");
            var invalid=NativeSkill(actor,124).Definition.Copy();invalid.Crystal.ExpandedRules=true;
            invalid.Evolutions[0].ParameterChanges.Add(new SkillParameterChange{Field="GhostLeechRatio",Value=.5});
            bool rejected=false;try{SkillEvolution.Validate(invalid,catalog.Data);}catch(ArgumentException){rejected=true;}
            Check(rejected,"A native evolution parameter cannot be assigned to an unrelated skill");
            sim=ExpandedFixture(catalog,"cm",80);SuppressAi(sim);actor=Units(sim)[0];target=Units(sim)[2];
            UnitState(target).Action="Move";UnitState(target).ActionElapsed=.375;
            InvokeCore(sim,"ApplyBuff",actor,target,NativeSkill(actor,122));
            var frozen=sim.Frame().Units.Single(u=>u.EntityId==UnitState(target).EntityId);
            Check(frozen.Icebound && frozen.FrozenAction=="Move" && frozen.FrozenActionElapsed==.375,"Freeze captures the exact preceding pose");
            for(int i=0;i<8;i++)sim.Step();
            frozen=sim.Frame().Units.Single(u=>u.EntityId==UnitState(target).EntityId);
            Check(frozen.FrozenAction=="Move" && frozen.FrozenActionElapsed==.375,"Frozen pose stays fixed independently of the live action clock");
            sim=ExpandedFixture(catalog,"od",80);SuppressAi(sim);actor=Units(sim)[0];target=Units(sim)[2];
            UnitState(actor).Energy=0;double hp=UnitState(target).Hp;
            InvokeCore(sim,"ApplySkill",actor,target,NativeSkill(actor,213));
            Check(UnitState(target).Hp<hp && UnitState(actor).Energy>0 && (bool)InvokeCore(sim,"Controlled",target,"invulnerable"),"OD independent third Evo lands before imprisonment invulnerability");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==400).Evolutions.Count==3)
        {
            foreach(var definition in catalog.Data.Heroes.Skip(40).SelectMany(h=>h.SkillSlots).Select(s=>catalog.Skill(s.SkillId)).Where(s=>s.Evolutions.Count>0))
            foreach(var evo in definition.Evolutions)
            {
                Check(!SkillEvolution.Active(definition,evo.RequiredSkillLevel-1).Contains(evo) && SkillEvolution.Active(definition,evo.RequiredSkillLevel).Contains(evo),"Encounter Evo boundary: "+evo.Id);
                encounterMilestones++;
            }
            var sim=ExpandedFixture(catalog,"dp",80);SuppressAi(sim);var actor=Units(sim)[0];var state=UnitState(actor);
            foreach(var enemyUnit in Units(sim).Skip(2)){UnitState(enemyUnit).X=state.X+200;UnitState(enemyUnit).Y=state.Y;}
            state.Hp/=2;var ult=NativeSkill(actor,400);InvokeCore(sim,"ApplySkill",actor,actor,ult);
            var ghosts=((System.Collections.IEnumerable)Member(actor,"Buffs")).Cast<object>().Single();
            for(int i=0;i<4;i++)sim.Step();
            Check((double)Member(ghosts,"NativeDamage")>0,"DP ghosts pulse damage through the native buff");
            sim=ExpandedFixture(catalog,"loa",80);SuppressAi(sim);actor=Units(sim)[0];var enemy=Units(sim)[2];state=UnitState(actor);state.Hp/=2;
            InvokeCore(sim,"ApplySkill",actor,actor,NativeSkill(actor,420));double before=state.Hp;
            InvokeCore(sim,"Damage",enemy,actor,250d,"Holy",0d);
            Check(Math.Abs(state.Hp-before-250)<.0001,"LOA converts absorbed damage into direct HP");
            double enemyHp=UnitState(enemy).Hp;InvokeCore(sim,"ApplySkill",actor,enemy,NativeSkill(actor,422));
            Check(UnitState(enemy).Hp<enemyHp,"LOA coil damages enemies instead of healing them");
            sim=ExpandedFixture(catalog,"troll",80);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];
            InvokeCore(sim,"ApplySkill",actor,actor,NativeSkill(actor,410));InvokeCore(sim,"Damage",enemy,actor,1e9,"Holy",0d);
            Check(UnitState(actor).Hp==1,"Troll third ultimate evolution prevents lethal damage during its first buff");
            var buff=((System.Collections.IEnumerable)Member(actor,"Buffs")).Cast<object>().Single();InvokeCore(sim,"RemoveEvolutionBuff",actor,buff,true);
            InvokeCore(sim,"Damage",enemy,actor,1e9,"Holy",0d);Check(!UnitState(actor).Alive,"Troll immortality ends with its first ultimate buff");
            sim=ExpandedFixture(catalog,"bb",80);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];
            UnitState(enemy).X=UnitState(actor).X+25;UnitState(enemy).Y=UnitState(actor).Y;enemyHp=UnitState(enemy).Hp;
            InvokeCore(sim,"Damage",enemy,actor,UnitState(actor).MaxHp*.25,"Holy",0d);sim.Step();
            Check(UnitState(enemy).Hp<enemyHp,"BB emits reactive quills after the source damage threshold");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==430).Crystal.Summon?.Enabled==true)
        {
            var original=ExpandedFixture(catalog,"wl",60,true).Replay().Initial;
            foreach(var unit in original.Players.Concat(original.Waves[0].Enemies))
            {
                unit.Battle.NormalAttack.Crystal.InitialCooldown=9999;
                foreach(var skill in unit.Battle.Skills)skill.Definition.Crystal.InitialCooldown=9999;
            }
            var sim=new ZatodBattleSimulation(original);var owner=Units(sim)[0];int ownerId=UnitState(owner).EntityId;
            for(int i=0;i<160 && !sim.CanActivateUltimate(ownerId);i++)sim.Step();
            Check(sim.CanActivateUltimate(ownerId) && sim.RequestUltimate(ownerId),"WL native summon intent");
            for(int i=0;i<60 && Members(sim,"shots").Count==0;i++)sim.Step();
            Check(Members(sim,"shots").Count>0 && !Units(sim).Any(u=>Member(u,"Summoner")!=null),"WL waits until projectile impact to summon");
            for(int i=0;i<60 && !Units(sim).Any(u=>Member(u,"Summoner")!=null);i++)sim.Step();
            var minion=Units(sim).Single(u=>Member(u,"Summoner")!=null);var state=UnitState(minion);
            Check(state.SourceId==128 && ((ZatodUnitData)Member(minion,"Data")).SummonerId==ownerId && state.MaxHp>1,"WL Infernal inherits direct combat stats");
            Check(((ZatodUnitData)Member(minion,"Data")).Level==80 && NativeSkill(minion,10035).Level==60,"WL template inherits Hero and dependent skill levels independently");
            Check((int)Member(minion,"SummonTicks")==int.MaxValue,"Infernal persists until replacement or owner death");
            Check(sim.Replay().Digest==ZatodBattleSimulation.Resimulate(sim.Replay()).Digest,"Native Infernal snapshot/replay");
            InvokeCore(sim,"Damage",Units(sim).First(u=>UnitState(u).Team==1),owner,1e9,"Holy",0d);sim.Step();
            Check(!Units(sim).Any(u=>Member(u,"Summoner")==owner && UnitState(u).Alive),"WL owner death kills its Infernal");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==512).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"ta",80);SuppressAi(sim);var actor=Units(sim)[0];var enemy=Units(sim)[2];var skill=NativeSkill(actor,512);
            UnitState(actor).Energy=0;InvokeCore(sim,"ApplySkill",actor,actor,skill);
            var shield=((System.Collections.IEnumerable)Member(actor,"Buffs")).Cast<object>().Single(b=>((ZatodBuffDefinition)Member(b,"Definition")).SourceId==10005101);
            Check((int)Member(shield,"NativeCharges")==4,"TA refraction starts with evolved charges");
            double hp=UnitState(actor).Hp;InvokeCore(sim,"Damage",enemy,actor,10d,"Holy",0d);
            Check(UnitState(actor).Hp==hp && (int)Member(shield,"NativeCharges")==3 && UnitState(actor).Energy>0,"TA consumes one refraction layer and gains energy per absorbed hit");
            InvokeCore(sim,"ApplySkill",actor,actor,skill);
            Check((int)Member(shield,"NativeCharges")==7,"TA recast adds charges up to the source maximum");
            sim=ExpandedFixture(catalog,"panda",80);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];
            for(int i=0;i<7;i++)sim.Step();
            actor.GetType().GetField("CycloneTimer").SetValue(actor,.125);sim.Step();
            Check(Units(sim).Skip(2).Any(u=>(bool)InvokeCore(sim,"Controlled",u,"imprisonment")),"Panda fourth skill triggers cyclone independently of AI cooldowns");
            Check((double)Member(actor,"CycloneTimer")>0,"Panda cyclone resets its evolved interval");
            sim=ExpandedFixture(catalog,"ta",80);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];
            for(int i=0;i<7;i++)sim.Step();
            double x=UnitState(actor).X,y=UnitState(actor).Y;
            InvokeCore(sim,"Start",actor,NativeSkill(actor,510),enemy);
            Check((bool)InvokeCore(sim,"Controlled",actor,"untargetable"),"TA vanishes at ultimate startup");
            for(int i=0;i<50 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check(Math.Abs(UnitState(actor).X-x)<.0001 && Math.Abs(UnitState(actor).Y-y)<.0001 && !(bool)InvokeCore(sim,"Controlled",actor,"untargetable"),"TA returns to its original position and removes the startup guard");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==610).Crystal.NativeForm?.Enabled==true)
        {
            var sim=ExpandedFixture(catalog,"pa",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();
            var actor=Units(sim)[0];var enemy=Units(sim)[2];var ult=NativeSkill(actor,610);
            InvokeCore(sim,"Start",actor,ult,enemy);
            for(int i=0;i<40 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check(Member(actor,"NativeForm")!=null && ((List<BattleSkillData>)Member(actor,"Skills")).Count==2,"PA transforms into its normal source melee form");
            Check(sim.Frame().Units.Single(u=>u.EntityId==UnitState(actor).EntityId).Action=="Idle2","PA form applies the source Puppet action aliases");
            var basic=NativeSkill(actor,611);Check(basic.Definition.Crystal.Cooldown==0 && (int)Member(actor,"PhantomSureCrit")==3,"PA form grants three initial critical attacks without a basic cooldown");
            Check(Math.Abs((double)InvokeCore(sim,"Get",actor,"attack_range",0d)-(basic.Definition.Crystal.MaxRange-5)*10)<.00001,"PA changes movement stopping distance to its melee basic range");
            InvokeCore(sim,"Start",actor,basic,enemy);
            Check((int)Member(Member(actor,"Cast"),"Phase")==2 && (bool)Member(actor,"PhantomCritical"),"PA guaranteed critical selects its critical animation phase");
            InvokeCore(sim,"ApplySkill",actor,enemy,basic);
            Check(sim.Frame().CombatEvents.Any(e=>e.SourceActorId==UnitState(actor).EntityId && e.Kind=="damage" && e.Critical),"PA critical attacks force the source critical damage outcome");
            var buff=((System.Collections.IEnumerable)Member(actor,"Buffs")).Cast<object>().Single(b=>((ZatodBuffDefinition)Member(b,"Definition")).SourceId==10006101);
            InvokeCore(sim,"RemoveEvolutionBuff",actor,buff,true);
            Check(Member(actor,"NativeForm")==null && ((List<BattleSkillData>)Member(actor,"Skills")).Any(s=>s.Definition.Crystal.SourceId==610),"PA restores its ranged skill list when the transformation expires");
            var detached=catalog.Skill(ult.Definition.Id).Copy();detached.Crystal.NativeForm.ActiveSkillSourceIds.Clear();
            Check(catalog.Skill(ult.Definition.Id).Crystal.NativeForm.ActiveSkillSourceIds.Count==2,"Form definitions are detached from live catalog data");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==524).Crystal.TriggerOnly)
        {
            var sim=ExpandedFixture(catalog,"phoenix",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();
            var actor=Units(sim)[0];var enemy=Units(sim)[2];
            InvokeCore(sim,"Damage",enemy,actor,1e9,"Holy",0d);
            Check(UnitState(actor).Alive && (bool)Member(actor,"PhoenixEgg") && UnitState(actor).Hp==6,"Phoenix first evolved egg has six hit points");
            sim.Step();double hp=UnitState(actor).Hp;InvokeCore(sim,"Damage",enemy,actor,1e9,"AP",0d);
            Check(UnitState(actor).Hp==hp,"Phoenix egg ignores magic damage");
            InvokeCore(sim,"Damage",enemy,actor,1e9,"Holy",0d);
            Check(UnitState(actor).Hp==hp-1,"Phoenix egg loses exactly one hit point per nonmagic hit");
            for(int i=0;i<41;i++)sim.Step();
            Check(UnitState(actor).Hp>100 && !(bool)Member(actor,"PhoenixEgg"),"Surviving Phoenix egg revives after the native five seconds");
            InvokeCore(sim,"Damage",enemy,actor,1e9,"Holy",0d);sim.Step();
            Check((bool)Member(actor,"PhoenixEgg") && UnitState(actor).Hp==5,"Phoenix second egg has one fewer hit point");
            for(int i=0;i<5;i++)InvokeCore(sim,"Damage",enemy,actor,100d,"Holy",0d);
            Check(!UnitState(actor).Alive && (int)Member(actor,"PhoenixRebirths")==2,"Destroying an egg kills Phoenix without starting another egg");
            sim=ExpandedFixture(catalog,"phoenix",80,true);SuppressAi(sim);actor=Units(sim)[0];
            var ember=NativeSkill(actor,522);var basic=NativeSkill(actor,521);string projectile=basic.Definition.Crystal.ProjectileArt;
            InvokeCore(sim,"ApplyBuff",actor,actor,ember);
            Check(basic.Definition.Crystal.DamageType=="AP" && basic.Definition.Crystal.PlusRatio==1,"Evolved Ember Spirit turns basic attacks into magic splash");
            var buff=((System.Collections.IEnumerable)Member(actor,"Buffs")).Cast<object>().Single(b=>((ZatodBuffDefinition)Member(b,"Definition")).SourceId==10005201);
            InvokeCore(sim,"RemoveEvolutionBuff",actor,buff,true);
            Check(basic.Definition.Crystal.DamageType=="AD" && basic.Definition.Crystal.ProjectileArt==projectile,"Ember Spirit expiry restores the original basic attack");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==650).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"doom",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();
            var actor=Units(sim)[0];var enemy=Units(sim)[2];UnitState(enemy).X=UnitState(actor).X+100;UnitState(enemy).Y=UnitState(actor).Y;
            UnitState(actor).Energy=499;Check(!sim.CanActivateUltimate(UnitState(actor).EntityId) && !sim.RequestUltimate(UnitState(actor).EntityId),"DOOM needs at least 500 energy even though the initial cost is zero");
            UnitState(actor).Energy=500;Check(sim.CanActivateUltimate(UnitState(actor).EntityId),"DOOM ultimate becomes available at 500 energy");
            InvokeCore(sim,"ApplySkill",actor,enemy,NativeSkill(actor,650));
            Check((bool)Member(actor,"DoomActive") && (bool)InvokeCore(sim,"Controlled",enemy,"doom") && (double)InvokeCore(sim,"Get",actor,"energy_regen",0d)<0,"DOOM attaches its target curse and caster energy drain");
            Check(!(bool)InvokeCore(sim,"ExpandedCanCast",enemy,NativeSkill(enemy,20)),"Doom blocks the victim's nonbasic skills");
            UnitState(enemy).Hp=1;InvokeCore(sim,"DoomNativeTick",enemy);
            Check(!UnitState(enemy).Alive && !(bool)Member(actor,"DoomActive"),"DOOM can finish a victim at one HP and target death ends the channel");
            sim=ExpandedFixture(catalog,"doom",80,true);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];
            for(int i=0;i<7;i++)sim.Step();UnitState(enemy).X=UnitState(actor).X+100;UnitState(enemy).Y=UnitState(actor).Y;
            InvokeCore(sim,"ApplySkill",actor,enemy,NativeSkill(actor,650));UnitState(actor).Energy=0;InvokeCore(sim,"DoomNativeTick",enemy);InvokeCore(sim,"DoomNativeTick",actor);
            sim.Step();
            Check(!(bool)InvokeCore(sim,"Controlled",enemy,"doom") && !(bool)Member(actor,"DoomActive") && (double)InvokeCore(sim,"Get",actor,"energy_regen",0d)>=0,"DOOM removes both curse and drain when energy runs out");
            Check(InvokeCore(sim,"Target",actor,NativeSkill(actor,654).Definition.Crystal,enemy)==null,"Devour cannot target ordinary Heroes");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==810).Crystal.NativeForm?.Enabled==true)
        {
            var hero=ExpandedHero(catalog,"lyc",80);hero.Skills.Single(s=>s.SlotId=="skill_2").Level=40;hero.Skills.Single(s=>s.SlotId=="skill_3").Level=55;hero.Skills.Single(s=>s.SlotId=="skill_4").Level=60;
            var match=ZatodMatchFactory.Versus(catalog,new[]{hero},new[]{ExpandedHero(catalog,"coco",80)},117,"lycan-form",true);match.Players[0].InitialEnergy=1000;
            var sim=new ZatodBattleSimulation(match);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[1];
            UnitState(actor).Hp/=2;double hp=UnitState(actor).Hp;var ult=NativeSkill(actor,810);
            InvokeCore(sim,"Start",actor,ult,actor);for(int i=0;i<80 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check(UnitState(actor).Resource=="LYCb" && Member(actor,"NativeForm")!=null && UnitState(actor).Hp>hp && UnitState(actor).EnergyCostSinceTick>=0,"LYC changes to its native wolf puppet and heals after transformation");
            Check(NativeSkill(actor,817).Level==40 && NativeSkill(actor,818).Level==55 && NativeSkill(actor,819).Level==60,"Wolf skills inherit each corresponding parent skill level");
            Check(NativeSkill(actor,818).Definition.Crystal.Phases[0].AttackTimes.Count==3,"Wolf rush uses wolf attack frames instead of the human puppet timeline");
            UnitState(actor).Energy=0;SuppressAi(sim);for(int i=0;i<8;i++)sim.Step();
            Check(UnitState(actor).Resource=="LYCb","LYC stays in wolf form after energy is drained, as in the recovered hook");
            var shotSkill=NativeSkill(actor,817);UnitState(enemy).X=UnitState(actor).X+200;
            var shot=InvokeCore(sim,"CreateShot",actor,enemy,shotSkill,0,false);
            Check((int)Member(shot,"Bounces")==9 && (bool)Member(shot,"TrackTarget"),"Wolf projectile carries its native nine-jump and target tracking state");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==470).Crystal.NativeForm?.Enabled==true)
        {
            var hero=ExpandedHero(catalog,"tb",80);hero.Skills.Single(s=>s.SlotId=="skill_2").Level=60;
            var match=ZatodMatchFactory.Versus(catalog,new[]{hero},new[]{ExpandedHero(catalog,"coco",80)},117,"terror-mirrors",true);match.Players[0].InitialEnergy=1000;
            var sim=new ZatodBattleSimulation(match);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[1];var mirror=NativeSkill(actor,472);int count=mirror.Definition.Crystal.Summon.Count;
            InvokeCore(sim,"Release",actor,actor,mirror,0);
            var minions=Units(sim).Where(u=>Member(u,"Summoner")==actor && UnitState(u).Alive).ToArray();
            Check(minions.Length==count && minions.All(u=>UnitState(u).SourceId==129 && ((ZatodUnitData)Member(u,"Data")).Level==60),"TB mirrors use the summoning skill level and normal mirror template");
            Check(sim.Frame().Units.Where(u=>u.SummonerId==UnitState(actor).EntityId).All(u=>u.Shader==ZatodBuffShader.Mirror && u.MaxHp>100),"TB mirrors inherit stats and the native mirror shader");
            InvokeCore(sim,"Release",actor,actor,mirror,0);
            Check(Units(sim).Count(u=>Member(u,"Summoner")==actor && UnitState(u).Alive)==2*count,"Each TB mirror cast can add another set of living mirrors");
            var ult=NativeSkill(actor,470);InvokeCore(sim,"Start",actor,ult,actor);for(int i=0;i<80 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check(UnitState(actor).Resource=="TBult" && (bool)Member(actor,"TerrorDemon") && UnitState(actor).EnergyCostSinceTick>=0,"TB transformation changes its native puppet");
            Check(!Units(sim).Any(u=>UnitState(u).Alive && UnitState(u).SourceId==129) && Units(sim).Count(u=>UnitState(u).Alive && UnitState(u).SourceId==130)==3*count,"TB evolution converts previous melee mirrors and creates its transformation mirrors");
            var basic=NativeSkill(actor,471);Check(basic.Definition.Crystal.TrackType=="projectile" && basic.Definition.Crystal.PlusRatio==1.6 && basic.Definition.Crystal.GainEnergy==60,"TB demon basic attacks use the native ranged parameters");
            UnitState(actor).Energy=0;InvokeCore(sim,"TerrorNativeTick",actor);
            Check(UnitState(actor).Resource=="TB" && !(bool)Member(actor,"TerrorDemon") && UnitState(actor).Action=="Birth" && UnitState(actor).EnergyCostSinceTick==-1,"TB returns to its original puppet and birth pose when energy empties");
            sim=ExpandedFixture(catalog,"tb",80,true);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];UnitState(actor).Hp=UnitState(actor).MaxHp*.2;UnitState(enemy).Hp=UnitState(enemy).MaxHp*.9;
            double old=UnitState(enemy).Hp;var sunder=NativeSkill(actor,473);InvokeCore(sim,"Release",actor,enemy,sunder,0);
            Check(UnitState(actor).Hp>UnitState(actor).MaxHp*.2 && UnitState(enemy).Hp<old && old-UnitState(enemy).Hp<=sunder.Definition.Crystal.ScriptArgs[3]+.001,"TB Sunder exchanges HP ratios within its native damage cap");
            var beam=Members(sim,"shots").Cast<object>().First();var beamSkill=(BattleSkillData)Member(beam,"Skill");old=UnitState(enemy).Hp;InvokeCore(sim,"ApplySkill",actor,enemy,beamSkill);
            Check(beamSkill.Definition.Crystal.VisualOnly && UnitState(enemy).Hp==old && (bool)Member(actor,"TerrorSunderUsed"),"Sunder beams do not apply the HP exchange again at impact");
            sim=ExpandedFixture(catalog,"tb",80,true);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];UnitState(actor).Hp=UnitState(actor).MaxHp*.2;UnitState(enemy).Hp=UnitState(enemy).MaxHp*.05;((ZatodUnitData)Member(enemy,"Data")).Boss=true;old=UnitState(enemy).Hp;
            InvokeCore(sim,"Release",actor,enemy,NativeSkill(actor,473),0);Check(UnitState(enemy).Hp==old,"Sunder does not heal a boss target");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==730).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"pudge",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();
            var actor=Units(sim)[0];var enemy=Units(sim)[2];var state=UnitState(actor);var victim=UnitState(enemy);
            victim.X=state.X+220;victim.Y=state.Y;double hp=victim.Hp;
            var hook=NativeSkill(actor,730);InvokeCore(sim,"Start",actor,hook,enemy);
            Check((bool)InvokeCore(sim,"Controlled",actor,"uncontrollable"),"Pudge hook Evo guards its cast");
            for(int i=0;i<40 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check(victim.Hp<hp && Math.Abs(victim.X-state.X)<=90,"Pudge hook contacts and pulls its selected target");
            Check(!(bool)InvokeCore(sim,"Controlled",actor,"uncontrollable") && ((Dictionary<string,double>)Member(actor,"Cooldowns"))[NativeSkill(actor,733).Definition.Id]==0,"Hook finish removes guard and resets evolved bite cooldown");
            var rot=NativeSkill(actor,732);InvokeCore(sim,"ApplyBuff",actor,actor,rot);
            Check((double)InvokeCore(sim,"Get",actor,"health_regen",0d)>=0 && (double)InvokeCore(sim,"Get",actor,"magic_immunity",0d)>=15,"Evolved rot removes self poison and adds magic immunity");
            victim.X=state.X+80;victim.Y=state.Y;InvokeCore(sim,"PudgeTick",actor); // first pulse waits a full source second
            Check(!Members(enemy,"Buffs").Cast<object>().Any(b=>((ZatodBuffDefinition)Member(b,"Definition")).SourceId==10007302),"Rot does not pulse immediately");
            for(int i=0;i<8;i++)InvokeCore(sim,"PudgeTick",actor);
            Check((double)InvokeCore(sim,"Get",enemy,"health_regen",0d)<-Math.Min(state.Hp*.03,2000),"Rot applies source poison plus capped current-health damage");
            sim=ExpandedFixture(catalog,"pudge",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();actor=Units(sim)[0];enemy=Units(sim)[2];state=UnitState(actor);victim=UnitState(enemy);
            state.Hp=state.MaxHp*.2;victim.X=state.X+80;victim.Y=state.Y;hp=state.Hp;
            InvokeCore(sim,"Start",actor,NativeSkill(actor,733),enemy);for(int i=0;i<9;i++)sim.Step();
            Check(state.Hp>hp && (bool)InvokeCore(sim,"Controlled",enemy,"stun"),"Pudge bite heals by actual damage and holds its victim");
            InvokeCore(sim,"InterruptCast",actor);sim.Step();
            Check(!(bool)InvokeCore(sim,"Controlled",enemy,"stun") && !(bool)InvokeCore(sim,"Controlled",actor,"uncontrollable"),"Interrupting Pudge cleans up victim hold and caster guard");
            var baseStats=(Dictionary<string,double>)Member(actor,"Base");double maximum=state.MaxHp;baseStats["health"]+=500;InvokeCore(sim,"RefreshNativeHealth",actor);
            Check(state.MaxHp==maximum+500 && state.Hp<state.MaxHp,"Increasing native maximum health does not grant an implicit heal");
            baseStats["health"]=1;state.Hp=state.MaxHp;InvokeCore(sim,"RefreshNativeHealth",actor);
            Check(state.Hp==state.MaxHp && state.MaxHp<maximum,"Native maximum-health reduction clamps current HP");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==684).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"lc",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();
            var actor=Units(sim)[0];var enemy=Units(sim)[2];var state=UnitState(actor);var victim=UnitState(enemy);
            var charge=NativeSkill(actor,684);for(int i=0;i<9;i++)InvokeCore(sim,"Damage",enemy,actor,1d,"Holy",0d);
            Check((double)Member(actor,"LegionChargePower")==0,"LC counter waits for ten incoming damage calls");
            InvokeCore(sim,"Damage",enemy,actor,1d,"Holy",0d);
            Check((double)Member(actor,"LegionChargePower")==10*((double)InvokeCore(sim,"BasicAmount",charge)+50) && ((Dictionary<string,double>)Member(actor,"Cooldowns"))[charge.Definition.Id]==.1,"LC tenth damage call scales its next charge by cumulative damage count");
            victim.X=state.X+70;victim.Y=state.Y;double hp=victim.Hp;
            InvokeCore(sim,"Start",actor,charge,enemy);for(int i=0;i<13;i++)sim.Step();
            Check((bool)Member(actor,"LegionCharging") && victim.Hp<hp,"LC charge skips duplicate windup and hits each crossing contact");
            for(int i=0;i<40 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check(!(bool)Member(actor,"LegionCharging") && Members(actor,"Buffs").Cast<object>().Any(b=>((ZatodBuffDefinition)Member(b,"Definition")).SourceId==10006801),"LC charge finishes with its source buff and clears movement");
            sim=ExpandedFixture(catalog,"lc",80,true);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];state=UnitState(actor);victim=UnitState(enemy);victim.X=state.X+100;victim.Y=state.Y;
            InvokeCore(sim,"Start",actor,NativeSkill(actor,682),enemy);for(int i=0;i<16;i++)sim.Step();
            Check((double)InvokeCore(sim,"Get",actor,"haste",0d)>=2,"LC successful area hit grants count-scaled team haste");
            var ally=Units(sim)[1];InvokeCore(sim,"ApplyBuff",actor,ally,NativeSkill(actor,683));
            Check((double)InvokeCore(sim,"Get",ally,"health_regen",0d)>=1000 && (double)InvokeCore(sim,"Get",ally,"haste",0d)>=20,"LC recovery evolution includes healer-scaled regen and third-milestone haste");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==1110).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"tusk",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[2];
            var passive=NativeSkill(actor,1114);for(int i=0;i<100;i++)InvokeCore(sim,"TuskTick",actor);
            Check((bool)Member(actor,"TuskCharged") && (double)InvokeCore(sim,"Get",actor,"armor_penetration",0d)>=200,"Tusk charges its guaranteed crit and evolved penetration after the reduced interval");
            var charged=InvokeCore(sim,"TuskForceCritical",actor,NativeSkill(actor,1113));Check((bool)charged,"Tusk charge forces the eligible shot to crit");
            InvokeCore(sim,"TuskConsumeCritical",actor);Check(!(bool)Member(actor,"TuskCharged"),"Eligible shot consumes Tusk's charged crit");
            var state=UnitState(actor);var victim=UnitState(enemy);victim.X=state.X+200;victim.Y=state.Y;double hp=victim.Hp;
            InvokeCore(sim,"Start",actor,NativeSkill(actor,1110),enemy);for(int i=0;i<80;i++)sim.Step();
            Check(victim.Hp<hp && Math.Abs(state.X-victim.X)<150,"Tusk's tracked snowball reaches its target and moves caster into punch range");
            Check(!(bool)InvokeCore(sim,"Controlled",actor,"untargetable") && !(bool)InvokeCore(sim,"Controlled",actor,"stunbyself"),"Snowball and uppercut leave no permanent self control");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==1140).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"cg",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[2];var state=UnitState(actor);var victim=UnitState(enemy);
            victim.X=state.X+200;victim.Y=state.Y;var missiles=NativeSkill(actor,1143);InvokeCore(sim,"Start",actor,missiles,enemy);
            for(int i=0;i<20;i++)sim.Step();
            Check((int)Member(actor,"ClockwerkMissiles")>0,"CG's first-stage missile splits after traveling its native 100 units");
            Check(sim.Frame().Visuals.Any(v=>v.Resource=="eff_tile_CG_atk3b.cha") || victim.Hp<victim.MaxHp,"CG split missiles have actual native visual or impact state");
            sim=ExpandedFixture(catalog,"cg",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();actor=Units(sim)[0];enemy=Units(sim)[2];state=UnitState(actor);victim=UnitState(enemy);victim.X=state.X+100;victim.Y=state.Y;
            for(int i=0;i<3;i++){InvokeCore(sim,"Start",actor,NativeSkill(actor,1140),actor);InvokeCore(sim,"InterruptCast",actor);}
            Check((int)Member(actor,"ClockwerkHeat")==3 && sim.Frame().Visuals.Any(v=>v.Resource=="eff_buff_CG_heat_3.cha"),"Three finished CG skills accumulate heat and select its third native glow");
            InvokeCore(sim,"Start",actor,NativeSkill(actor,1141),enemy);InvokeCore(sim,"ClockwerkTick",actor);
            Check((bool)Member(actor,"ClockwerkOverheat") && (bool)InvokeCore(sim,"Controlled",actor,"uncontrollable"),"CG interrupts a nonultimate cast to enter guarded overheat");
            double hp=victim.Hp;InvokeCore(sim,"Damage",enemy,actor,100d,"AD",0d);
            Check(victim.Hp<hp,"Evolved overheat reflects physical damage to its attacker");
            InvokeCore(sim,"InterruptCast",actor);sim.Step();
            Check(!(bool)Member(actor,"ClockwerkOverheat") && (int)Member(actor,"ClockwerkHeat")==0 && !(bool)InvokeCore(sim,"Controlled",actor,"uncontrollable"),"Overheat finish clears its guard and heat even when interrupted");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==1220).Evolutions.Count==3)
        {
            var hero=ExpandedHero(catalog,"ud",80);hero.Skills.Single(s=>s.SlotId=="skill_2").Level=60;
            var match=ZatodMatchFactory.Versus(catalog,new[]{hero},new[]{ExpandedHero(catalog,"coco",80)},117,"undying-native",true);match.Players[0].InitialEnergy=1000;
            var sim=new ZatodBattleSimulation(match);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[1];var state=UnitState(actor);
            var summon=NativeSkill(actor,1222);InvokeCore(sim,"Release",actor,enemy,summon,0);
            var tomb=Units(sim).Single(u=>UnitState(u).SourceId==214);var tombState=UnitState(tomb);
            Check(tombState.X==150 && (bool)InvokeCore(sim,"Controlled",tomb,"building") && ((ZatodUnitData)Member(tomb,"Data")).Level==60 && ((ZatodUnitData)Member(tomb,"Data")).Stars==1,"UD summons its stationary source tombstone at skill level and one star");
            double hp=tombState.Hp;InvokeCore(sim,"Release",tomb,tomb,NativeSkill(tomb,21401),0);
            var zombie=Units(sim).Single(u=>UnitState(u).SourceId==215);var zombieState=UnitState(zombie);
            Check(zombieState.Hp==3 && zombieState.MaxHp==3 && tombState.Hp==hp-1 && (bool)InvokeCore(sim,"Controlled",zombie,"untargetable"),"Tombstone spends one HP to create a three-hit native zombie");
            InvokeCore(sim,"Damage",enemy,zombie,1e6,"Holy",0d);Check(zombieState.Hp==2,"Native zombie loses one HP per damage call");
            InvokeCore(sim,"Heal",zombie,1e6,actor);Check(zombieState.Hp==3,"Native zombie healing is also counted in individual HP");
            state.Hp=state.MaxHp*.5;state.Energy=0;hp=state.Hp;InvokeCore(sim,"KillNativeSummon",zombie);
            Check(state.Hp>hp && state.Energy>=25,"Zombie death returns source HP and evolved MP rewards to UD");
            state.Energy=1000;InvokeCore(sim,"Start",actor,NativeSkill(actor,1220),actor);
            for(int i=0;i<50 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check(state.Resource=="UDult" && NativeSkill(actor,1221).Definition.Crystal.PlusRatio==1.2 && state.EnergyCostSinceTick>=0,"UD switches to its native puppet and empowered basic attack");
            state.Energy=0;SuppressAi(sim);for(int i=0;i<40;i++)sim.Step();
            Check(state.Resource=="UD" && Member(actor,"NativeForm")==null && !(bool)InvokeCore(sim,"Controlled",actor,"unmanual"),"UD casts its switch animation and returns to normal when drained");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==11100).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"titan_mars",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[2];var state=UnitState(actor);var victim=UnitState(enemy);
            victim.X=state.X+100;victim.Y=state.Y;state.FacingRight=true;double hp=state.Hp;
            InvokeCore(sim,"Damage",enemy,actor,100d,"AD",0d);double front=hp-state.Hp;
            state.Hp=hp;victim.X=state.X-100;InvokeCore(sim,"Damage",enemy,actor,100d,"AD",0d);double back=hp-state.Hp;
            Check(front<back && (double)Member(actor,"MarsParriedDamage")>0,"Mars shields physical attacks from the front and accumulates native parry damage");
            victim.X=state.X+100;state.FacingRight=true;InvokeCore(sim,"Start",actor,NativeSkill(actor,11104),enemy);for(int i=0;i<19;i++)sim.Step();
            Check((bool)InvokeCore(sim,"Controlled",enemy,"taunt") && (bool)InvokeCore(sim,"Controlled",enemy,"doom") && InvokeCore(sim,"ClosestEnemy",enemy)==actor,"Mars taunt directs enemy attacks to its caster and blocks other skills");
            Check((double)InvokeCore(sim,"Get",actor,"damage",0d)>((Dictionary<string,double>)Member(actor,"Base"))["damage"]+300 && (bool)InvokeCore(sim,"Controlled",actor,"stable"),"Mars taunt grants its source attack/defense buff and evolved guard");
            sim=ExpandedFixture(catalog,"titan_mars",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();actor=Units(sim)[0];enemy=Units(sim)[2];var second=Units(sim)[3];state=UnitState(actor);victim=UnitState(enemy);victim.X=state.X+100;victim.Y=state.Y;UnitState(second).X=victim.X+50;UnitState(second).Y=victim.Y;
            hp=UnitState(second).Hp;var shot=InvokeCore(sim,"CreateShot",actor,enemy,NativeSkill(actor,11100),0,true);InvokeCore(sim,"MarsProjectileHit",actor,enemy,shot);
            Check(UnitState(second).Hp<hp && Members(sim,"regions").Count==1 && sim.Frame().Visuals.Any(v=>v.Resource=="eff_buff_TitanMars_ult.cha"),"Mars spear hits a secondary enemy behind its target and creates its native five-second region");
            for(int i=0;i<42;i++)sim.Step();Check(Members(sim,"regions").Count==0,"Mars ultimate region expires and removes its persistent visual");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==1280).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"monk",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[2];
            for(int i=0;i<120;i++)InvokeCore(sim,"MonkTick",actor);
            Check((int)Member(actor,"MonkQi")==5,"Monk charges five Qi levels at the evolved three-second interval");
            double damage=(double)InvokeCore(sim,"Get",actor,"damage",0d);var state=UnitState(actor);var victim=UnitState(enemy);victim.X=state.X+80;victim.Y=state.Y;
            InvokeCore(sim,"Start",actor,NativeSkill(actor,1282),enemy);for(int i=0;i<80 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check((int)Member(actor,"MonkQi")==4,"Monk empowered secondary skill spends one Qi level");
            var ult=NativeSkill(actor,1280);double ratio=ult.Definition.Crystal.PlusRatio;InvokeCore(sim,"Start",actor,ult,enemy);
            Check(UnitState(actor).Action=="ults" && ult.Definition.Crystal.NoDodge && ult.Definition.Crystal.PlusRatio==3.6,"Monk's four-Qi ultimate selects its empowered phase and exact ratio");
            for(int i=0;i<100 && Member(actor,"Cast")!=null;i++)sim.Step();
            Check((int)Member(actor,"MonkQi")==0 && ult.Definition.Crystal.PlusRatio==ratio,"Monk ultimate consumes Qi and restores its ordinary skill parameters");
            sim.Step();Check(!(bool)InvokeCore(sim,"Controlled",actor,"uncontrollable"),"Monk ultimate guard expires after its finish callback");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==1430).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"dancer",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var ally=Units(sim)[1];var enemy=Units(sim)[2];var other=Units(sim)[3];
            foreach(var unit in Units(sim))((Dictionary<string,double>)Member(unit,"Base"))["move_speed"]=0;
            UnitState(actor).X=170;UnitState(ally).X=200;UnitState(enemy).X=450;UnitState(other).X=240;
            foreach(var unit in Units(sim))UnitState(unit).Y=0;
            InvokeCore(sim,"ApplyBuff",actor,ally,NativeSkill(actor,1433));for(int i=0;i<9;i++)sim.Step();
            Check(UnitState(ally).X>450 && UnitState(ally).Height>0 && UnitState(other).X==520,"Dancer transports its ally to the far line and a nearby enemy away after preparation");
            for(int i=0;i<88;i++)sim.Step();
            Check(UnitState(ally).X==200,"Dancer returns its ally to the recorded starting point after ten seconds and the return preparation");
            sim=ExpandedFixture(catalog,"dancer",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();actor=Units(sim)[0];enemy=Units(sim)[2];other=Units(sim)[3];
            int team=UnitState(enemy).Team;InvokeCore(sim,"ApplySkill",actor,enemy,NativeSkill(actor,1430));
            Check(UnitState(enemy).Team==team && InvokeCore(sim,"ClosestEnemy",enemy)==other,"Native charm makes its victim attack its own camp without changing team ownership");
            for(int i=0;i<34;i++)sim.Step();
            Check(!(bool)InvokeCore(sim,"Controlled",enemy,"enchanted") && Members(enemy,"Buffs").Cast<object>().Any(b=>((ZatodBuffDefinition)Member(b,"Definition")).SourceId==11004308),"Expired Dancer charm applies its native attack and magic-attack debuff");
            sim=ExpandedFixture(catalog,"dancer",80,true);SuppressAi(sim);actor=Units(sim)[0];enemy=Units(sim)[2];InvokeCore(sim,"Release",actor,enemy,NativeSkill(actor,1430),0);
            Check(Members(sim,"shots").Count==2,"Dancer ultimate fires separately targeted projectiles at two source-selected enemies");
            InvokeCore(sim,"Start",actor,NativeSkill(actor,1434),enemy);Check((bool)InvokeCore(sim,"Controlled",actor,"invulnerable"),"Dancer's evolved combo receives its native guard");
            InvokeCore(sim,"InterruptCast",actor);Check(!(bool)InvokeCore(sim,"Controlled",actor,"invulnerable"),"Dancer combo interruption removes its guard");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==1760).Evolutions.Count==3)
        {
            var hero=ExpandedHero(catalog,"titan_druid",80);hero.Skills.Single(s=>s.SlotId=="skill_2").Level=60;hero.Skills.Single(s=>s.SlotId=="skill_3").Level=45;
            var match=ZatodMatchFactory.Versus(catalog,new[]{hero},new[]{ExpandedHero(catalog,"coco",80)},117,"native-druid-bear",true);match.Players[0].InitialEnergy=1000;
            var sim=new ZatodBattleSimulation(match);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[1];var parent=NativeSkill(actor,1762);
            InvokeCore(sim,"Start",actor,parent,actor);for(int i=0;i<80 && Member(actor,"Cast")!=null;i++)sim.Step();
            var bear=Units(sim).Single(u=>UnitState(u).SourceId==266);var state=UnitState(bear);
            Check(((ZatodUnitData)Member(bear,"Data")).Level==60 && NativeSkill(bear,26601).Level==45 && state.Hp>100,"Druid bear inherits summon skill level, each bear skill uses the separate passive level, and stats inherit from its owner");
            Check((int)Member(bear,"DruidBearStage")==1 && ((List<BattleSkillData>)Member(bear,"Skills")).Count==2,"Druid bear begins in its source first-stage skill list");
            for(int stage=2;stage<=5;stage++)
            {
                InvokeCore(sim,"Start",actor,parent,actor);for(int i=0;i<80 && Member(actor,"Cast")!=null;i++)sim.Step();for(int i=0;i<16;i++)sim.Step();
                Check((int)Member(bear,"DruidBearStage")==stage,"Druid upgrade advances one bear stage");
            }
            Check(state.Resource=="DruidBear__DruidBear5" && ((List<BattleSkillData>)Member(bear,"Skills")).Count==5,"Druid's final bear stage uses its source component variant and complete skill list");
            SuppressAi(sim);double hp=UnitState(actor).Hp,bearHp=state.Hp;InvokeCore(sim,"Damage",enemy,actor,100d,"Holy",0d);
            Check(UnitState(actor).Hp>hp-100 && state.Hp<bearHp,"Living Druid bear takes half its owner's damage");
            InvokeCore(sim,"Damage",enemy,bear,1e9,"Holy",0d);
            Check(state.Alive && state.Hp==1 && (bool)Member(bear,"DruidBearDying") && sim.Frame().Units.Single(u=>u.EntityId==state.EntityId).Shader==ZatodBuffShader.Stone,"Lethal bear damage enters protected stone recovery instead of death");
            for(int i=0;i<100;i++)sim.Step();
            Check(state.Hp==state.MaxHp && !(bool)Member(bear,"DruidBearDying"),"Bear recovers to full HP and resumes after its source healing state");
            SuppressAi(sim);foreach(var unit in Units(sim))((Dictionary<string,double>)Member(unit,"Base"))["move_speed"]=0;
            InvokeCore(sim,"Release",actor,enemy,NativeSkill(actor,1760),0);for(int i=0;i<24;i++)sim.Step();
            Check(!(bool)InvokeCore(sim,"Controlled",enemy,"stun"),"Druid's ultimate waits for its native 25-tick delay");sim.Step();
            Check((bool)InvokeCore(sim,"Controlled",enemy,"stun"),"Druid's delayed ultimate applies its area hit at tick 25");
        }
        if(catalog.Data.Skills.Single(s=>s.Crystal.SourceId==1490).Evolutions.Count==3)
        {
            var sim=ExpandedFixture(catalog,"br",80,true);SuppressAi(sim);for(int i=0;i<7;i++)sim.Step();var actor=Units(sim)[0];var enemy=Units(sim)[2];var state=UnitState(actor);
            InvokeCore(sim,"Release",actor,enemy,NativeSkill(actor,1490),0);
            var nest=Units(sim).Single(u=>UnitState(u).SourceId==249);Check((bool)Member(actor,"BroodHasNest") && (bool)InvokeCore(sim,"Controlled",nest,"building") && (bool)InvokeCore(sim,"Controlled",nest,"invulnerable"),"BR's first ultimate creates its protected source nest");
            Check(!(bool)InvokeCore(sim,"ExpandedCanCast",actor,NativeSkill(actor,1490)),"BR cannot recast its nest ultimate");
            sim.Step();double broodBaseline=(double)Member(actor,"BroodBaselineDamage");
            Check((double)InvokeCore(sim,"Get",actor,"damage",0d)>broodBaseline && sim.Frame().Visuals.Any(v=>v.Resource=="eff_point_BR_ult_2.cha"),"BR nest applies the source team-count aura and persistent web visual");
            state.Energy=1000;InvokeCore(sim,"BroodTick",actor);for(int i=0;i<30 && !Units(sim).Any(u=>UnitState(u).SourceId==250);i++)sim.Step();
            var spider=Units(sim).First(u=>UnitState(u).SourceId==250);Check(state.Energy<1000 && (bool)InvokeCore(sim,"Controlled",spider,"untargetable"),"Nest spends BR energy to create its invulnerable source spider");
            InvokeCore(sim,"Start",spider,NativeSkill(spider,25002),enemy);InvokeCore(sim,"InterruptCast",spider);
            Check(!UnitState(spider).Alive && UnitState(spider).Action=="Death","Spider finishes its one attack with native death cleanup");
            InvokeCore(sim,"Damage",enemy,actor,1e9,"Holy",0d);sim.Step();
            Check(!UnitState(nest).Alive && Members(sim,"regions").Count==0,"BR death clears the nest and its persistent aura region");
        }
        {
            var low=ZatodMatchFactory.Versus(catalog,new[]{catalog.CreateHero("coco","white-left")},new[]{catalog.CreateHero("dr","white-right")},117,"d34-white",false);
            Check(low.RulesVersion==ZatodMatchDefinition.ExpandedRulesV7,"New D34 matches use V7 even before a fourth skill or a new Hero is unlocked");
            var sim=ExpandedFixture(catalog,"coco",80,true);SuppressAi(sim);var actor=Units(sim)[0];var target=Units(sim)[2];var skill=NativeSkill(actor,10);
            var buff=new ZatodBuffDefinition{LevelCheckDice=20};uint before=(uint)Member(sim,"random");
            Check((bool)InvokeCore(sim,"NativeBuffEligible",actor,target,skill,buff) && (uint)Member(sim,"random")==before,"Equal-level buff accuracy passes without drawing RNG");
            var lowSkill=new BattleSkillData{Level=1,Definition=skill.Definition.Copy()};int landed=0;
            for(int i=0;i<500;i++)if((bool)InvokeCore(sim,"NativeBuffEligible",actor,target,lowSkill,buff))landed++;
            Check(landed>100 && landed<200,"Underlevel buff accuracy retains its source thirty-percent floor");
            ((Dictionary<string,double>)Member(target,"Base"))["silence_resistance"]=100;buff.LevelCheckDice=0;buff.ResistAttribute="silence_resistance";
            Check(!(bool)InvokeCore(sim,"NativeBuffEligible",actor,target,skill,buff) && sim.Frame().CombatEvents.Any(e=>e.Kind=="resist"),"Silence resistance rejects the buff and emits the native resist feedback");
            var meta=new ZatodSkillDefinition{KnockUp=1,KnockBack=100};var victim=UnitState(target);victim.X=UnitState(actor).X+100;
            ((ZatodUnitData)Member(target,"Data")).IsTitan=true;((ZatodUnitData)Member(target,"Data")).Stars=5;((ZatodUnitData)Member(actor,"Data")).Stars=3;
            InvokeCore(sim,"NativeSkillKnock",actor,target,meta,true);
            Check(Math.Abs((double)Member(target,"VerticalSpeed")-900/Math.Sqrt(12))<.00001 && Math.Abs((double)Member(target,"KnockVelocity")*(double)Member(target,"KnockRemaining")-100d/12)<.00001,"Titan knock reduction includes the target's star advantage");
            ((Dictionary<string,double>)Member(target,"Base"))["knockres"]=0;target.GetType().GetField("VerticalSpeed").SetValue(target,0d);target.GetType().GetField("KnockRemaining").SetValue(target,0d);
            InvokeCore(sim,"NativeSkillKnock",actor,target,meta,true);
            Check((double)Member(target,"VerticalSpeed")==0 && (double)Member(target,"KnockRemaining")==0,"Zero KnockRES prevents native knock movement");
            var holy=new BattleSkillData{Level=80,Definition=NativeSkill(actor,11).Definition.Copy()};holy.Definition.Crystal.DamageType="Holy";holy.Definition.Crystal.BuffId=0;
            ((Dictionary<string,double>)Member(target,"Base"))["mdodg"]=100;double hp=victim.Hp;InvokeCore(sim,"ApplySkill",actor,target,holy);
            Check(victim.Hp<hp,"Holy damage does not perform an AP dodge check");
        }
        Console.WriteLine(JsonSerializer.Serialize(new{State="PASS",Checks=checks-checksBeforeNative,BoundaryCases=boundaryCases,Heroes=40,SmokeHeroes=catalog.Data.Heroes.Count,EncounterMilestones=encounterMilestones,SkillLevels=new[]{60,80},Rules=ZatodMatchDefinition.ExpandedRulesV7},new JsonSerializerOptions{WriteIndented=true}));
    }
}
