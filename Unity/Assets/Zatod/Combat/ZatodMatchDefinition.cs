using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.Combat
{
    public enum ZatodMode { Campaign, Arena, RealtimePvp }
    [Serializable] public sealed class ZatodUnitData
    {
        public int SourceId, EntityId, Team, Level, Stars, SummonerId;
        public int TemplateCasterId;
        public string TemplateSkillId;
        public string DefinitionId, Name, Resource, AnimationSetResource, RankId, SourceGender;
        public double BirthSeconds,HurtSeconds;
        public List<ZatodActionRemap> ActionRemaps=new List<ZatodActionRemap>();
        public ZatodDeathPresentation DeathPresentation;
        public double ArtScale=1, DamageMultiplier=1, HpMultiplier=1, Radius=18, InitialEnergy, InitialHealth=-1;
        public double DamageStatisticsRatio=1,AlternateDeathSeconds;
        public bool IsTitan;
        public double DeathSeconds=1.5;
        public bool Boss, Hero, AllowAutomaticUltimate=true;
        public CombatantBattleData Battle;
        public ZatodUnitData Copy()
        {
            var copy=(ZatodUnitData)MemberwiseClone();copy.Battle=Battle.Copy();copy.ActionRemaps=ActionRemaps.ConvertAll(x=>x.Copy());return copy;
        }
    }
    [Serializable] public sealed class ZatodWaveData
    {
        public string Id, Background;
        public bool FlipBackground;
        public int TimeLimitSeconds=90;
        public List<ZatodUnitData> Enemies=new List<ZatodUnitData>();
        public List<WaveHookDefinition> Hooks=new List<WaveHookDefinition>();
    }
    [Serializable] public sealed class ZatodMatchDefinition
    {
        public const string SkillEvolutionRulesV4="zatod-skill-evo-4";
        public const string WaveEntryRulesV5="zatod-wave-entry-5";
        public const string SummonRulesV6="zatod-battle-summons-6";
        public const string ExpandedRulesV7="zatod-expanded-combat-7";
        public const string Rules=WaveEntryRulesV5;
        public static bool SupportedRules(string value)=>value==ExpandedRulesV7 || value==SummonRulesV6 || value==WaveEntryRulesV5 || value==SkillEvolutionRulesV4 || value=="zatod-prototype-3" || value=="crystal-prototype-3";
        public string BattleId, StageId, ConfigVersion, RulesVersion=Rules;
        public string MusicResource;
        public uint Seed;
        public ZatodMode Mode;
        public double EnergyGainMultiplier=1, EnergySupplyPercent;
        public List<ZatodUnitData> Players=new List<ZatodUnitData>();
        public List<ZatodUnitData> SummonUnits=new List<ZatodUnitData>();
        public List<ZatodWaveData> Waves=new List<ZatodWaveData>();
        public List<ZatodBuffDefinition> Buffs=new List<ZatodBuffDefinition>();
        public List<SkillDefinition> SkillDependencies=new List<SkillDefinition>();
        public List<ZatodLootDrop> LootDrops=new List<ZatodLootDrop>();
    }
    [Serializable] public sealed class ZatodInput
    {
        public int Tick, ActorId, Team;
        public int Operation; // zero: ultimate intent, as in recovered ordinary battle operations.
        public ZatodInput Copy()=>(ZatodInput)MemberwiseClone();
    }
    [Serializable] public sealed class ZatodUnitState
    {
        public int EntityId, Team, SourceId, Stars, SummonerId, SummonTicks, UltimateCastTick=-1, DamageReactionTick=-1, CastInterruptedTick=-1, DeathWave=-1;
        public int UltimateReadySinceTick=-1,FullEnergySinceTick=-1;
        public int EnergyCostSinceTick=-1;
        public string DefinitionId, Name, Resource, AnimationSetResource, RankId, Action="Idle";
        public string FrozenAction;
        public double FrozenActionElapsed;
        public double Hp, MaxHp, Energy, MaxEnergy=1000, X,Y,Height,ActionElapsed,ActionSpeed=1,ArtScale=1;
        public bool FacingRight;
        public bool CanActivateUltimate, UltimateStartup, Boss, Icebound;
        public ZatodBuffShader Shader;
        public double RenderScaleX=1,RenderScaleY=1;
        public double Shield, DeathElapsed;
        public ZatodHealthBarState HealthBar;
        public ZatodDeathPresentation DeathPresentation;
        public ZatodRenderMotion Motion;
        public bool Alive=>Hp>0;
        public ZatodUnitState Copy()=>(ZatodUnitState)MemberwiseClone();
    }
    [Serializable] public sealed class ZatodFrame
    {
        public int Tick, Wave;
        public bool Finished, DimForUltimate;
        public int Winner=-1, Stars;
        public ulong Digest;
        public double TimeRemaining;
        public double WaveEntryRemaining;
        public List<ZatodCombatEvent> CombatEvents=new List<ZatodCombatEvent>();
        public List<ZatodUnitState> Units=new List<ZatodUnitState>();
        public List<ZatodVisualState> Visuals=new List<ZatodVisualState>();
    }
    [Serializable] public sealed class ZatodReplay
    {
        public ZatodMatchDefinition Initial;
        public List<ZatodInput> Inputs=new List<ZatodInput>();
        public int EndTick, Winner=-1, Stars;
        public bool Completed;
        public ulong Digest;
        public List<ZatodUnitStatistics> Statistics=new List<ZatodUnitStatistics>();
    }
    public static class ZatodMatchFactory
    {
        static Dictionary<string,double> Stats(CombatantDefinition definition,int level,int stars)
        {
            var result=definition.PreciseBaseStats.Count>0
                ?definition.PreciseBaseStats.ToDictionary(x=>x.StatId,x=>x.Value,StringComparer.Ordinal)
                :definition.BaseStats.ToDictionary(x=>x.StatId,x=>(double)x.Value,StringComparer.Ordinal);
            var growth=definition.Growth.SingleOrDefault(x=>x.Stars==stars);
            if(growth!=null)foreach(var x in growth.PerLevel)result[x.StatId]=(result.TryGetValue(x.StatId,out double old)?old:0)+x.Value*level;
            return result;
        }
        static void AddRank(Dictionary<string,double> stats,CombatantDefinition definition,double rank,bool estimated)
        {
            int low=(int)Math.Floor(rank);double fraction=rank-low;
            var a=definition.RankStats.SingleOrDefault(x=>x.Rank==low);
            var b=definition.RankStats.SingleOrDefault(x=>x.Rank==low+1)??a;
            var av=(estimated?a?.EstimatedStats:a?.Stats)??new List<StatAmount>();
            var bv=(estimated?b?.EstimatedStats:b?.Stats)??new List<StatAmount>();
            foreach(var name in av.Select(x=>x.StatId).Concat(bv.Select(x=>x.StatId)).Distinct())
                stats[name]=(stats.TryGetValue(name,out double old)?old:0)+(av.FirstOrDefault(x=>x.StatId==name)?.Value??0)*(1-fraction)+(bv.FirstOrDefault(x=>x.StatId==name)?.Value??0)*fraction;
        }
        static ZatodUnitData Describe(CombatantDefinition definition,CombatantBattleData data,int entity,int team,int level)
            =>new ZatodUnitData{IsTitan=definition.IsTitan,DamageStatisticsRatio=definition.DamageStatisticsRatio,AlternateDeathSeconds=definition.AlternateDeathSeconds,ActionRemaps=definition.ActionRemaps.ConvertAll(x=>x.Copy()),HurtSeconds=definition.HurtSeconds,BirthSeconds=definition.BirthSeconds,SourceGender=definition.SourceGender,Hero=definition is HeroDefinition,SourceId=definition.SourceUnitId,EntityId=entity,Team=team,Level=level,DefinitionId=definition.Id,Name=definition.Name,Resource=definition.SourceResource,AnimationSetResource=definition.AnimationSetResource,ArtScale=definition.ArtScale,Radius=definition.CollideRadius,Battle=data.Copy(),DeathPresentation=definition.DeathPresentation,DeathSeconds=definition.DeathAnimationMilliseconds/1000d};
        public static ZatodUnitData Owned(HeroData hero,HeroCatalog catalog,int entity,int team)
        {
            var definition=catalog.Hero(hero.HeroDefinitionId);
            if(definition.SourceUnitId<=0)throw new ArgumentException("Crystal modes need an imported Crystal Hero.");
            var unit=Describe(definition,HeroBattleFactory.Create(hero,catalog),entity,team,hero.Level);
            unit.Stars=hero.Stars;unit.RankId=hero.RankId;return unit;
        }
        public static ZatodUnitData Spawn(WaveSpawnDefinition spawn,HeroCatalog catalog,int entity)
        {
            CombatantDefinition definition=spawn.Kind==SpawnKind.Hero?(CombatantDefinition)catalog.Hero(spawn.DefinitionId):catalog.Monster(spawn.DefinitionId);
            var hero=definition as HeroDefinition;
            double rank=spawn.ResolveRank(catalog,definition,out var rankPath);
            var stats=Stats(definition,spawn.Level,spawn.Stars);
            if(rankPath!=null && !definition.RankStats.Any(row=>row.Rank==rank))
            {
                foreach(var step in rankPath)
                {
                    foreach(var bonus in step.PreciseBonusStats)stats[bonus.StatId]=stats.GetValueOrDefault(bonus.StatId)+bonus.Value;
                    foreach(var bonus in step.BonusStats)stats[bonus.StatId]=stats.GetValueOrDefault(bonus.StatId)+bonus.Value;
                }
            }
            else AddRank(stats,definition,rank,spawn.EstimateRank);
            foreach(var pair in new[]{("health",spawn.HpMultiplier),("defense",spawn.ArmorMultiplier),("magic_resistance",spawn.MagicResistanceMultiplier)})
                if(stats.ContainsKey(pair.Item1))stats[pair.Item1]*=pair.Item2;
            var battle=new CombatantBattleData{ConfigVersion=catalog.Data.ConfigVersion,HasNormalAttack=true,NormalAttack=catalog.Skill(definition.NormalAttackSkillId).Copy(),PreciseStats=stats.Select(x=>new StatAmount{StatId=x.Key,Value=x.Value}).ToList()};
            if(hero!=null)
            {
                int integral=(int)Math.Floor(rank);
                var available=rankPath!=null?HeroProgression.UnlockedSkills(hero,rankPath)
                    :hero.SkillSlots.Where(slot=>
                    {
                        var info=catalog.Skill(slot.SkillId).Crystal;
                        return (info.EnemyUnlockRank>=0?info.EnemyUnlockRank:info.UnlockRank)<=integral;
                    });
                foreach(var slot in available)
                {
                    var skill=catalog.Skill(slot.SkillId);
                    battle.Skills.Add(new BattleSkillData{SlotId=slot.Id,IsUltimate=slot.IsUltimate,Level=spawn.Level,Definition=skill.Copy()});
                }
            }
            else if(definition is MonsterDefinition monster)
            {
                foreach(var skill in monster.SkillIds.Select(catalog.Skill).Where(skill=>skill.Id!=battle.NormalAttack.Id &&
                    (skill.Crystal.EnemyUnlockRank<0 || skill.Crystal.EnemyUnlockRank<=(int)Math.Floor(rank))))
                    battle.Skills.Add(new BattleSkillData{SlotId=skill.Id,IsUltimate=skill.Activation==SkillActivation.UltimateIntent,
                        Level=spawn.Level,Definition=skill.Copy()});
            }
            var result=Describe(definition,battle,entity,1,spawn.Level);result.Stars=spawn.Stars;result.RankId=spawn.RankId;result.InitialEnergy=spawn.InitialEnergy;result.Boss=spawn.Boss;result.DamageMultiplier=spawn.DamageMultiplier;result.HpMultiplier=spawn.HpMultiplier;result.ArtScale*=spawn.SizeMultiplier;return result;
        }
        public static ZatodMatchDefinition Campaign(CampaignCatalog campaign,HeroCatalog catalog,CharacterData account,string stageId,IEnumerable<string> selected,uint seed,string battleId)
        {
            var stage=campaign.Stage(stageId);var ids=selected?.ToList();
            if(ids==null || ids.Count<1 || ids.Count>5 || ids.Distinct().Count()!=ids.Count)throw new ArgumentException("Choose 1–5 distinct owned Heroes.");
            var match=new ZatodMatchDefinition{BattleId=battleId,StageId=stageId,Seed=seed,Mode=ZatodMode.Campaign,ConfigVersion=catalog.Data.ConfigVersion,EnergyGainMultiplier=stage.EnergyGainMultiplier,EnergySupplyPercent=stage.EnergySupplyPercent,MusicResource=campaign.BattleMusicFor(stageId)};
            int entity=1;
            foreach(var id in ids)
            {
                var hero=account.HeroDesk.SingleOrDefault(x=>x.HeroInstanceId==id);if(hero==null)throw new ArgumentException("Hero is not owned.");
                match.Players.Add(Owned(hero,catalog,entity++,0));
            }
            foreach(var wave in stage.Waves)
            {
                var data=new ZatodWaveData{Id=wave.Id,Background=wave.BackgroundResource,FlipBackground=wave.FlipBackground,TimeLimitSeconds=wave.TimeLimitSeconds,Hooks=wave.Hooks.Select(h=>new WaveHookDefinition{Id=h.Id,Action=h.Action,TargetDefinitionId=h.TargetDefinitionId,BossOnly=h.BossOnly,PlayerSide=h.PlayerSide,Amount=h.Amount}).ToList()};
                int enemyId=100+wave.Index*10;
                foreach(var spawn in wave.Enemies)data.Enemies.Add(Spawn(spawn,catalog,++enemyId));
                match.Waves.Add(data);
            }
            return WithDependencies(match,catalog);
        }
        public static ZatodMatchDefinition Versus(HeroCatalog catalog,IEnumerable<HeroData> left,IEnumerable<HeroData> right,uint seed,string id,bool realtime)
        {
            var match=new ZatodMatchDefinition{BattleId=id,Seed=seed,Mode=realtime?ZatodMode.RealtimePvp:ZatodMode.Arena,ConfigVersion=catalog.Data.ConfigVersion,RulesVersion=ZatodMatchDefinition.SkillEvolutionRulesV4};
            int actor=1;foreach(var hero in left)match.Players.Add(Owned(hero,catalog,actor++,0));
            var wave=new ZatodWaveData{Id="arena",Background="battle_bg/bbg_arena.jpg"};actor=101;foreach(var hero in right)wave.Enemies.Add(Owned(hero,catalog,actor++,1));
            if(match.Players.Count<1 || match.Players.Count>5 || wave.Enemies.Count<1 || wave.Enemies.Count>5)throw new ArgumentException("Invalid team size.");
            match.Waves.Add(wave);
            return WithDependencies(match,catalog);
        }
        static ZatodMatchDefinition WithDependencies(ZatodMatchDefinition match,HeroCatalog catalog)
        {
            match.Buffs=catalog.Data.Buffs.Select(CopyBuff).ToList();
            match.SkillDependencies=catalog.Data.Skills.Select(skill=>skill.Copy()).ToList();
            var summons=match.Players.Concat(match.Waves.SelectMany(wave=>wave.Enemies))
                .SelectMany(unit=>unit.Battle.Skills.Select(skill=>skill.Definition).Append(unit.Battle.NormalAttack))
                .Select(skill=>skill?.Crystal?.Summon).Where(summon=>summon?.Enabled==true).ToArray();
            bool expanded=catalog.Data.UseExpandedCombatRules || match.Players.Concat(match.Waves.SelectMany(w=>w.Enemies))
                .SelectMany(u=>u.Battle.Skills.Select(s=>s.Definition).Append(u.Battle.NormalAttack))
                .Any(s=>s?.Crystal?.ExpandedRules==true);
            if(expanded)match.RulesVersion=ZatodMatchDefinition.ExpandedRulesV7;
            if(summons.Length==0)return match;
            if(!expanded)match.RulesVersion=ZatodMatchDefinition.SummonRulesV6;
            foreach(var monsterId in summons.SelectMany(summon=>new[]{summon.MonsterId,summon.AlternateMonsterId}).Where(id=>!string.IsNullOrEmpty(id)).Distinct(StringComparer.Ordinal))
                match.SummonUnits.Add(Spawn(new WaveSpawnDefinition{Kind=SpawnKind.Monster,DefinitionId=monsterId},catalog,0));
            if(expanded)
            foreach(var caster in match.Players.Concat(match.Waves.SelectMany(w=>w.Enemies)))
            foreach(var skill in caster.Battle.Skills.Where(s=>s.Definition.Crystal.Summon?.Enabled==true && s.Definition.Crystal.Summon.InheritLevelAndStars))
            foreach(string monsterId in new[]{skill.Definition.Crystal.Summon.MonsterId,skill.Definition.Crystal.Summon.AlternateMonsterId}.Where(id=>!string.IsNullOrEmpty(id)).Distinct(StringComparer.Ordinal))
            {
                var template=Spawn(new WaveSpawnDefinition{Kind=SpawnKind.Monster,DefinitionId=monsterId,
                    Level=skill.Definition.Crystal.Summon.UseSkillLevel?skill.Level:caster.Level,Stars=skill.Definition.Crystal.Summon.StarsOverride>0?skill.Definition.Crystal.Summon.StarsOverride:caster.Stars,EstimateRank=true,HpMultiplier=skill.Definition.Crystal.Summon.HpMultiplierOverride>0?skill.Definition.Crystal.Summon.HpMultiplierOverride:caster.HpMultiplier},catalog,0);
                template.TemplateCasterId=caster.EntityId;template.TemplateSkillId=skill.Definition.Id;
                match.SummonUnits.Add(template);
            }
            return match;
        }
        public static ZatodBuffDefinition CopyBuff(ZatodBuffDefinition value)
            =>new ZatodBuffDefinition{LevelCheckDice=value.LevelCheckDice,ResistAttribute=value.ResistAttribute,Id=value.Id,SourceId=value.SourceId,Name=value.Name,Control=value.Control,StackRule=value.StackRule,Dispel=value.Dispel,Tenacity=value.Tenacity,Effect=value.Effect,ImpactEffect=value.ImpactEffect,Mod=value.Mod,Duration=value.Duration,ShieldValue=value.ShieldValue,ShieldType=value.ShieldType,ClearOnDeath=value.ClearOnDeath,MaximumStacks=value.MaximumStacks,Stats=value.Stats.ConvertAll(x=>x.Copy()),Scaling=value.Scaling.ConvertAll(x=>new ZatodBuffScaling{StatId=x.StatId,Attribute=x.Attribute,Ratio=x.Ratio}),EffectLayer=value.EffectLayer,EffectHeightOffset=value.EffectHeightOffset,EffectScale=value.EffectScale,Shader=value.Shader,ActorScaleX=value.ActorScaleX,ActorScaleY=value.ActorScaleY};
    }
}
