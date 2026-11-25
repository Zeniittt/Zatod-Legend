using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    public enum SpawnKind { Hero, Monster }
    public enum WaveHookAction { AddEnergy, SetEnergy, SetUltimateIntent }
    [Serializable] public sealed class WaveHookDefinition
    {
        public string Id, TargetDefinitionId;
        public WaveHookAction Action;
        public bool BossOnly, PlayerSide;
        public double Amount;
    }
    [Serializable] public sealed class WaveSpawnDefinition
    {
        public string Id, DefinitionId, RankId;
        public SpawnKind Kind;
        public int SourceUnitId, Level = 1, Stars = 1;
        public double InitialEnergy;
        public bool Boss, EstimateRank;
        public double HpMultiplier = 1, DamageMultiplier = 1, ArmorMultiplier = 1, MagicResistanceMultiplier = 1, SizeMultiplier = 1;

        public double ResolveRank(HeroCatalog catalog,CombatantDefinition definition,out List<HeroRankDefinition> path)
        {
            path=definition is HeroDefinition hero && !EstimateRank && !string.IsNullOrEmpty(RankId)
                ?catalog.RankPath(hero,RankId):null;
            return EstimateRank?Math.Floor((Level+9)/10d)+(Level-1)%10/10d:path?.Count??1;
        }
    }
    [Serializable] public sealed class WaveDefinition
    {
        public string Id, BackgroundResource;
        public int Index, TimeLimitSeconds = 90;
        public bool FlipBackground;
        public List<WaveSpawnDefinition> Enemies = new List<WaveSpawnDefinition>();
        public List<WaveHookDefinition> Hooks = new List<WaveHookDefinition>();
    }
    public static class WaveValidation
    {
        public static void Validate(CampaignStageDefinition stage, HeroCatalog catalog)
        {
            HeroCatalog.Require(stage.Waves != null && stage.Waves.Count > 0, "A wave stage needs at least one wave.");
            var ids = new HashSet<string>(StringComparer.Ordinal);
            for (int i = 0; i < stage.Waves.Count; i++)
            {
                var wave = stage.Waves[i];
                HeroCatalog.Require(wave != null && !string.IsNullOrWhiteSpace(wave.Id) && ids.Add(wave.Id) && wave.Index == i + 1, "Wave IDs/order must be unique and contiguous.");
                HeroCatalog.Require(wave.TimeLimitSeconds > 0 && wave.Enemies != null && wave.Enemies.Count >= 1 && wave.Enemies.Count <= 5, "Invalid wave time/enemy count.");
                var spawnIds = new HashSet<string>(StringComparer.Ordinal);
                foreach (var spawn in wave.Enemies)
                {
                    HeroCatalog.Require(spawn != null && !string.IsNullOrWhiteSpace(spawn.Id) && spawnIds.Add(spawn.Id) && Enum.IsDefined(typeof(SpawnKind),spawn.Kind), "Invalid/duplicate spawn identity.");
                    HeroCatalog.Require(spawn.Level >= 1 && spawn.Stars >= 1 && spawn.Stars <= 5 && spawn.InitialEnergy >= 0 && Finite(spawn.InitialEnergy), "Invalid spawn level/stars/energy.");
                    foreach (var value in new[]{spawn.HpMultiplier,spawn.DamageMultiplier,spawn.ArmorMultiplier,spawn.MagicResistanceMultiplier,spawn.SizeMultiplier})
                        HeroCatalog.Require(Finite(value) && value > 0, "Spawn multipliers must be finite and positive.");
                    if (spawn.Kind == SpawnKind.Hero)
                    {
                        var hero = catalog.Hero(spawn.DefinitionId);
                        if (!string.IsNullOrEmpty(spawn.RankId)) catalog.RankPath(hero,spawn.RankId);
                    }
                    else catalog.Monster(spawn.DefinitionId);
                }
                HeroCatalog.Require(wave.Hooks != null && wave.Hooks.All(h=>h!=null && !string.IsNullOrWhiteSpace(h.Id) && Enum.IsDefined(typeof(WaveHookAction),h.Action) && Finite(h.Amount)), "Invalid wave hook.");
                HeroCatalog.Require(wave.Hooks.Select(h=>h.Id).Distinct(StringComparer.Ordinal).Count()==wave.Hooks.Count, "Duplicate hook ID.");
            }
        }
        static bool Finite(double value) => !double.IsNaN(value) && !double.IsInfinity(value);
    }
    // Working Campaign state. The owning player commits its capture together with rewards.
    public sealed class CampaignRun
    {
        readonly CampaignCatalog catalog;
        readonly Dictionary<string,int> stars = new Dictionary<string,int>(StringComparer.Ordinal);
        public CampaignRun(CampaignCatalog catalog) { this.catalog = catalog ?? throw new ArgumentNullException(nameof(catalog)); }
        public IReadOnlyDictionary<string,int> Stars => stars;
        public bool IsUnlocked(string stageId) => catalog.IsUnlocked(stageId,stars.Keys);
        public CampaignProgressData Capture() => new CampaignProgressData
        { Stages = stars.OrderBy(s=>s.Key,StringComparer.Ordinal).Select(s=>new CampaignStageProgress{StageId=s.Key,Stars=s.Value}).ToList() };
        public void Restore(CampaignProgressData progress)
        {
            var restored=new Dictionary<string,int>(StringComparer.Ordinal);
            foreach(var row in progress?.Stages ?? throw new ArgumentException("Campaign progress is missing."))
            {
                HeroCatalog.Require(row!=null && !string.IsNullOrEmpty(row.StageId) && row.Stars>=1 && row.Stars<=3 && !restored.ContainsKey(row.StageId),"Invalid Campaign progress.");
                catalog.Stage(row.StageId);restored.Add(row.StageId,row.Stars);
            }
            stars.Clear();foreach(var row in restored)stars.Add(row.Key,row.Value);
        }
        public void AcceptValidated(string stageId, bool won, int starCount)
        {
            HeroCatalog.Require(IsUnlocked(stageId), "Stage is locked in this run.");
            HeroCatalog.Require(starCount >= 0 && starCount <= 3 && (won ? starCount >= 1 : starCount == 0), "Invalid validated star count.");
            if (won) stars[stageId] = Math.Max(stars.TryGetValue(stageId,out int previous) ? previous : 0,starCount);
        }
    }
}
