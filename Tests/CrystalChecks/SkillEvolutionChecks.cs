using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.Combat;

static partial class Program
{
    static object Member(object target,string name)=>target.GetType().GetField(name,BindingFlags.Public|BindingFlags.NonPublic|BindingFlags.Instance).GetValue(target);
    static List<object> Members(object target,string name)=>((IEnumerable)Member(target,name)).Cast<object>().ToList();
    static List<object> Units(ZatodBattleSimulation simulation)=>Members(simulation,"units");
    static List<object> Buffs(object unit)=>Members(unit,"Buffs");
    static object Buff(object unit,int id)=>Buffs(unit).SingleOrDefault(x=>((ZatodBuffDefinition)Member(x,"Definition")).SourceId==id);
    static Dictionary<string,double> Modifiers(object buff)=>(Dictionary<string,double>)Member(buff,"Modifiers");
    static ZatodUnitState UnitState(object unit)=>(ZatodUnitState)Member(unit,"State");
    static void Call(ZatodBattleSimulation simulation,string name,params object[] args)
    {
        try
        {
            var method=typeof(ZatodBattleSimulation).GetMethod(name,BindingFlags.NonPublic|BindingFlags.Instance);
            method.Invoke(simulation,args.Concat(method.GetParameters().Skip(args.Length).Select(p=>p.DefaultValue)).ToArray());
        }
        catch(TargetInvocationException e){throw e.InnerException;}
    }
    static HeroData EvoHero(HeroCatalog catalog,string id,int level)
    {
        var h=catalog.CreateHero(id,"evo-"+id);h.Level=80;h.Stars=5;
        while(h.RankId!="blue")
        {foreach(var s in HeroProgression.CurrentRank(h,catalog).EquipmentSlots)HeroProgression.Equip(h,catalog,s.Id,s.RequiredItemId);HeroProgression.Promote(h,catalog);}
        foreach(var s in h.Skills)s.Level=level;return h;
    }
    static ZatodMatchDefinition EvoMatch(HeroCatalog catalog,string heroId,int skillLevel)
    {
        var match=ZatodMatchFactory.Versus(catalog,new[]{EvoHero(catalog,heroId,skillLevel),EvoHero(catalog,"dr",1)},new[]{EvoHero(catalog,"coco",1),EvoHero(catalog,"dr",1)},9876,"evo-check",false);
        foreach(var u in match.Players.Concat(match.Waves[0].Enemies))
        {
            u.InitialEnergy=1000;
            foreach(var s in u.Battle.Skills)s.Definition.Crystal.InitialCooldown=9999;
            u.Battle.HasNormalAttack=false;
            foreach(var stat in u.Battle.PreciseStats)
            {if(stat.StatId=="health")stat.Value=100000;if(stat.StatId=="tenacity" || stat.StatId=="con")stat.Value=0;}
        }
        return match;
    }
    static void SkillEvolutionChecks()
    {
        var catalog=ImportedCatalog();var main=catalog.Data.Heroes.SelectMany(h=>h.SkillSlots).Select(s=>catalog.Skill(s.SkillId)).ToArray();
        Check(main.Length==75 && main.Sum(s=>s.Evolutions.Count)==225,"D35 active coverage must be 75 skills / 225 milestones");
        foreach(var source in main)
        {
            foreach(var e in source.Evolutions)
            {
                Check(!SkillEvolution.Active(source,e.RequiredSkillLevel-1).Any(x=>x.Id==e.Id),"Evolution unlocked before its threshold: "+e.Id);
                Check(SkillEvolution.Active(source,e.RequiredSkillLevel).Any(x=>x.Id==e.Id) && SkillEvolution.Active(source,e.RequiredSkillLevel+1).Any(x=>x.Id==e.Id),"Evolution threshold or retention failed: "+e.Id);
            }
            var copy=source.Copy();copy.Evolutions[0].Description="changed";
            if(copy.Evolutions[0].ParameterChanges.Count>0)copy.Evolutions[0].ParameterChanges[0].Value+=999;
            else copy.Evolutions[0].TriggeredEffects[0].Amount+=999;
            Check(JsonSerializer.Serialize(copy.Evolutions,Json)!=JsonSerializer.Serialize(source.Evolutions,Json),"Evolution copy shares configuration");
            Check(!SkillDescription.Describe(source,80,catalog).Contains("%Skill&") && !SkillDescription.Describe(source,80,catalog).Contains("%Buff&"),"Description has unresolved source tokens: "+source.Id);
        }
        foreach(int level in new[]{34,35,49,50,69,70})
        {
            var match=EvoMatch(catalog,"coco",level);var ultimate=match.Players[0].Battle.Skills.Single(x=>x.IsUltimate);ultimate.Definition.Crystal.InitialCooldown=0;
            var sim=new ZatodBattleSimulation(match);object caster=Units(sim)[0],ally=Units(sim)[1],enemy=Units(sim)[2];
            var runtime=Members(caster,"Skills").Cast<BattleSkillData>().Single(x=>x.IsUltimate);
            Check(Math.Abs(runtime.Definition.Crystal.PlusRatio-(level>=50?1.6:1.4))<1e-9,"Coco AP coefficient mismatch at "+level);
            bool rum=false,stun=false;
            for(int tick=0;tick<64;tick++)
            {
                sim.Step();var b=Buff(caster,10000104);
                if(b!=null && !rum)
                {
                    rum=true;Check(level>=35 && Buff(ally,10000104)!=null,"Rum did not include every living ally");
                    Check(((ZatodBuffDefinition)Member(b,"Definition")).Duration==9 && Modifiers(b)["physical_immunity"]==20 && Modifiers(b)["magic_immunity"]==20,"Coco rum data differs from source");
                    Check(Buff(enemy,10000104)==null,"Rum applied to enemy");
                }
                var disable=Buff(enemy,10000101);
                if(disable!=null && !stun)
                {stun=true;Check(Math.Abs(((ZatodBuffDefinition)Member(disable,"Definition")).Duration-(level>=70?5:4))<1e-9,"Coco stun duration mismatch at "+level);}
            }
            Check(rum==(level>=35) && stun,"Coco attack frame/impact fixture failed at "+level);
            Check(catalog.Data.Buffs.Single(x=>x.SourceId==10000101).Duration==4,"Coco modified shared stun definition");
            var replay=sim.Replay();var again=ZatodBattleSimulation.Resimulate(replay);Check(again.Digest==replay.Digest,"Evolution replay diverged");
            // Real time expiry, independent of rendering or config changes.
            for(int tick=0;tick<100;tick++)sim.Step();Check(Buff(caster,10000104)==null,"Rum failed to expire");
        }
        // Simulate all 25 active loadouts with high-level Evo and replay their complete results.
        foreach(var hero in catalog.Data.Heroes)
        {
            var match=ZatodMatchFactory.Versus(catalog,new[]{EvoHero(catalog,hero.Id,80)},new[]{EvoHero(catalog,"coco",80)},12345,"coverage-"+hero.Id,false);
            match.Players[0].InitialEnergy=1000;match.Waves[0].Enemies[0].InitialEnergy=1000;
            var replay=new ZatodBattleSimulation(match).RunToCompletion();var repeated=ZatodBattleSimulation.Resimulate(replay);
            Check(replay.Completed && replay.Digest==repeated.Digest && replay.Winner==repeated.Winner,"D35 deterministic battle failed: "+hero.Id);
        }
        // The frozen match must not consult live config, including dependencies and nested lists.
        var frozen=EvoMatch(catalog,"coco",70);string before=JsonSerializer.Serialize(frozen,Json);
        var owned=EvoHero(catalog,"coco",70);owned.Skills[0].Level=1;
        var original=catalog.Skill("coco_spectral_ship");original.Evolutions[0].TriggeredEffects[0].BuffId=999;
        Check(JsonSerializer.Serialize(frozen,Json)==before,"Match shares Evo/buff/dependency lists with live config");
        var restored=JsonSerializer.Deserialize<ZatodMatchDefinition>(before,Json);
        Check(restored.Players[0].Battle.Skills.Single(s=>s.IsUltimate).Definition.Evolutions.Count==3 && restored.SkillDependencies.Count==catalog.Data.Skills.Count,"Evolution serialization dropped dependencies");
        EvolutionValidationChecks();EvolutionHookChecks();
    }
    static void EvolutionValidationChecks()
    {
        void Invalid(Action<SkillDefinition> mutate)
        {var c=ImportedCatalog();mutate(c.Skill("coco_spectral_ship"));Reject(()=>new HeroCatalog(c.Data),"Invalid evolution config accepted");}
        Invalid(s=>s.Evolutions[1].Id=s.Evolutions[0].Id);
        Invalid(s=>s.Evolutions[1].RequiredSkillLevel=s.Evolutions[0].RequiredSkillLevel);
        Invalid(s=>s.Evolutions[0].RequiredSkillLevel=0);
        Invalid(s=>s.Evolutions[0].TriggeredEffects[0].BuffId=99999999);
        Invalid(s=>s.Evolutions[0].TriggeredEffects[0].Trigger=(SkillEvolutionEvent)999);
        Invalid(s=>s.Evolutions[1].ParameterChanges[0].Field="Run arbitrary Lua");
        Invalid(s=>s.Evolutions[1].ParameterChanges[0].Value=double.NaN);
        Invalid(s=>s.Evolutions[0].TriggeredEffects[0].Effect=SkillEvolutionEffect.CollectMagicHits);
        Invalid(s=>s.Evolutions[1].ParameterChanges[0].Field="CounterChance");
        var cycle=ImportedCatalog();var a=cycle.Skill("coco_spectral_ship");var b=cycle.Data.Skills.Single(s=>s.Crystal.SourceId==85);
        a.Evolutions[0].TriggeredEffects.Add(new SkillTriggeredEffect{Effect=SkillEvolutionEffect.DependentSkill,SkillId=b.Id});
        b.Evolutions.Add(new SkillEvolutionDefinition{Id="cycle",Description="Cycle fixture",RequiredSkillLevel=1,TriggeredEffects=new List<SkillTriggeredEffect>{new SkillTriggeredEffect{Effect=SkillEvolutionEffect.DependentSkill,SkillId=a.Id}}});
        Reject(()=>new HeroCatalog(cycle.Data),"Indirect skill dependency cycle accepted");
    }
    static void EvolutionHookChecks()
    {
        var catalog=ImportedCatalog();
        (ZatodBattleSimulation sim,object caster,object ally,object enemy) Fixture(string id,int level=80)
        {var s=new ZatodBattleSimulation(EvoMatch(catalog,id,level));var u=Units(s);return(s,u[0],u[1],u[2]);}
        BattleSkillData Skill(object u,int id)=>Members(u,"Skills").Cast<BattleSkillData>().Single(x=>x.Definition.Crystal.SourceId==id);
        void Apply(ZatodBattleSimulation s,object a,object t,BattleSkillData skill)=>Call(s,"ApplySkill",a,t,skill,false,1d);
        void AddBuff(ZatodBattleSimulation s,object a,object t,BattleSkillData skill,int id=0)=>Call(s,"ApplyBuff",a,t,skill,id,-1d,-1d);
        void Hit(ZatodBattleSimulation s,object a,object t,double amount)=>Call(s,"Damage",a,t,amount,"Holy",0d);
        {
            var (s,a,ally,e)=Fixture("sf");var soul=Skill(a,253);
            UnitState(e).Hp=10;Hit(s,a,e,100);var first=Buffs(a).Where(x=>((ZatodBuffDefinition)Member(x,"Definition")).SourceId==10002501).ToArray();
            Check(first.Length==1 && Modifiers(first[0])["damage"]>50,"SF did not receive its evolved soul on death");
            var other=Units(s)[3];UnitState(other).Hp=10;Hit(s,a,other,100);
            var souls=Buffs(a).Where(x=>((ZatodBuffDefinition)Member(x,"Definition")).SourceId==10002501).ToArray();
            Check(souls.Length==2 && Modifiers(souls[1])["damage"]==Modifiers(first[0])["damage"],"SF soul stacks were refreshed instead of accumulated");
        }
        {
            var (s,a,ally,e)=Fixture("sf");var ult=Skill(a,250);AddBuff(s,a,e,ult,10002503);
            double x=UnitState(e).X;s.Step();Check(UnitState(e).X>x && UnitState(e).Action=="Move","Fear must move a right-side victim backwards");
            for(int i=0;i<20;i++)s.Step();Check(Buff(e,10002503)==null,"Fear did not expire");
        }
        {
            var (s,a,ally,e)=Fixture("sp");AddBuff(s,a,ally,Skill(a,223));var grave=Buff(ally,10002202);
            Check(((ZatodBuffDefinition)Member(grave,"Definition")).Duration==12,"SP Evo duration should be twelve seconds at the final milestone");
            UnitState(ally).Hp=100;double shield=((ZatodBuffDefinition)Member(grave,"Definition")).ShieldValue;
            Hit(s,e,ally,200);Check(UnitState(ally).Hp==1 && ((ZatodBuffDefinition)Member(grave,"Definition")).ShieldValue==shield-101,"SP shallow grave did not protect/consume only the lethal excess");
            Hit(s,e,ally,100000);Check(UnitState(ally).Hp==1 && Buff(ally,10002202)==null,"SP exhaustion hit must leave one HP and remove the shield");
            Hit(s,e,ally,100);Check(!UnitState(ally).Alive,"SP expired shield still prevents death");
        }
        {
            var (s,a,ally,e)=Fixture("pugna");var drain=Skill(a,180);
            AddBuff(s,e,a,Skill(e,10));Check(Buff(a,10000101)!=null,"Control fixture missing");
            Call(s,"EvolutionEvent",a,e,drain,SkillEvolutionEvent.CastStart,0d);
            Check(Buff(a,10001803)!=null && Buff(a,10000101)==null,"Pugna channel immunity did not clear conflicting control");
            AddBuff(s,e,a,Skill(e,10));Check(Buff(a,10000101)==null,"Channel immunity accepted hostile stun");
            var exile=Skill(a,183);AddBuff(s,a,e,exile);
            for(int i=0;i<3;i++)Call(s,"Damage",ally,e,100d,"AP",0d);Check((int)Member(a,"MagicHits")==3,"Exile failed to collect ally magic hits");
            Apply(s,a,e,Skill(a,182));Check((int)Member(a,"MagicHits")==1,"Magic Burst must consume old charges before collecting its own magic hit");
        }
        {
            var (s,a,ally,e)=Fixture("snk");AddBuff(s,a,e,Skill(a,190));var stun=Buff(e,10001901);
            Check(stun!=null,"SNK source stun fixture missing");
            Call(s,"RemoveEvolutionBuff",e,stun,false);Check(Buff(e,10001904)!=null,"Dispelling SNK stun must apply the evolved burn/slow");
            var burn=Buff(e,10001904);Check(Modifiers(burn)["health_regen"]<0 && Modifiers(burn)["haste"]==-15,"SNK follow-up lost its native modifiers");
        }
        {
            var (s,a,ally,e)=Fixture("lion");UnitState(a).Energy=0;UnitState(e).Energy=500;
            Apply(s,a,e,Skill(a,63));Check(UnitState(e).Energy==400 && UnitState(a).Energy==100,"Lion disable did not steal 100 energy");
        }
        {
            var (s,a,ally,e)=Fixture("nec");UnitState(a).Hp=10;Hit(s,e,a,1000000);
            Check(UnitState(a).Hp==1 && (bool)Member(a,"LifeInsightUsed") && Buff(a,10002005)!=null,"NEC first lethal hit failed to trigger Life Insight");
            Check(((Dictionary<string,double>)Member(a,"Cooldowns"))[Skill(a,202).Definition.Id]==0,"NEC evolution did not reset Vitality Pulse");
            for(int i=0;i<5;i++)s.Step();Hit(s,e,a,1000000);Check(!UnitState(a).Alive,"NEC Life Insight triggered more than once");
        }
        {
            var (s,a,ally,e)=Fixture("qop");UnitState(a).Hp=50000;AddBuff(s,a,e,Skill(a,72));
            double hp=UnitState(a).Hp;Call(s,"AdvanceBuffs");Check(UnitState(a).Hp>hp && UnitState(e).Hp<UnitState(e).MaxHp,"QOP poison did not damage and heal its caster");
        }
        {
            var (s,a,ally,e)=Fixture("thd");var ult=Skill(a,380);AddBuff(s,a,e,ult);var slow=Buff(e,ult.Definition.Crystal.BuffId);
            Call(s,"RemoveEvolutionBuff",e,slow,true);var frozen=Buff(e,10003803);
            Check(frozen!=null && ((ZatodBuffDefinition)Member(frozen,"Definition")).Duration==3.5,"THD expiry did not create evolved freeze");
            var preview=catalog.Data.Skills.Single(x=>x.Crystal.SourceId==380).Copy();preview.Description="%Buff&Time%";
            Check(SkillDescription.Describe(preview,80,catalog)==catalog.Data.Buffs.Single(x=>x.SourceId==preview.Crystal.BuffId).Duration.ToString(System.Globalization.CultureInfo.InvariantCulture),"Freeze duration incorrectly changed slow duration in preview");
        }
    }
}
