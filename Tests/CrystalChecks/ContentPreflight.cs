using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.World;

static partial class Program
{
    sealed record ContentDraft(HeroCatalog Heroes, CampaignCatalog Campaign, WorldCatalog World);

    static ContentDraft LoadContentDraft(string directory)
    {
        string data = Path.GetFullPath(directory);
        T Table<T>(string name) => Read<T>(Path.Combine(data, name + ".txt"));
        var heroes = ImportedCatalog(data);
        var campaign = new CampaignCatalog(Table<CampaignDefinition>("Campaigns"), heroes);
        _ = new ProgressionCatalog(Table<ProgressionDefinition>("Progression"));
        var world = new WorldCatalog(Table<WorldDefinition>("Worlds"), campaign, resource =>
        {
            const string prefix = "Data/WorldMaps/";
            if (resource == null || !resource.StartsWith(prefix, StringComparison.Ordinal) || resource.Length == prefix.Length)
                throw new ArgumentException("Invalid island resource: " + resource);
            string islands = Path.Combine(data, "WorldMaps") + Path.DirectorySeparatorChar;
            string file = Path.GetFullPath(Path.Combine(islands, resource.Substring(prefix.Length) + ".txt"));
            if (!file.StartsWith(islands, StringComparison.Ordinal))
                throw new ArgumentException("Island resource escapes the draft directory: " + resource);
            return Read<WorldMapDefinition>(file);
        });
        return new ContentDraft(heroes, campaign, world);
    }

    static int CheckContentDraft(string baselineDirectory, string candidateDirectory)
    {
        var baseline = LoadContentDraft(baselineDirectory);
        var candidate = LoadContentDraft(candidateDirectory);
        var changes = RetainedContentIssues(baseline, candidate);
        var chapters = candidate.Campaign.Data.Chapters;
        var stages = chapters.SelectMany(chapter => chapter.Stages).ToArray();
        var existingStages = baseline.Campaign.Data.Chapters.SelectMany(chapter => chapter.Stages)
            .Select(stage => stage.Id).ToHashSet(StringComparer.Ordinal);
        foreach (var stage in stages.Where(stage => !existingStages.Contains(stage.Id)))
        {
            if (stage.MaxDropAmount != 5)
                changes.Add("New stage must allow up to five drops: " + stage.Id);
            decimal low = stage.DropItems.Min(item => (decimal)item.DropChancePercent);
            decimal high = stage.DropItems.Max(item => (decimal)item.DropChancePercent);
            // Percentages such as thirds may differ by the last decimal to sum to 100.
            if (high - low > .01m)
                changes.Add("New stage must use equal drop probabilities: " + stage.Id);
        }
        var baselineHeroes = baseline.Heroes.Data.Heroes;
        var heroIds = candidate.Heroes.Data.Heroes.Select(hero => hero.Id).ToHashSet(StringComparer.Ordinal);
        var report = new
        {
            ConfigValid = changes.Count == 0,
            Issues = changes,
            MeasuredCoverage = new
            {
                Heroes = heroIds.Count,
                NewHeroes = heroIds.Except(baselineHeroes.Select(hero => hero.Id)).Count(),
                ExistingHeroesWithFourSkillsAtPurple = baselineHeroes.Count(hero => heroIds.Contains(hero.Id) &&
                    FourSkillsAtPurple(candidate.Heroes, candidate.Heroes.Hero(hero.Id))),
                FreePvpHeroes = candidate.Heroes.FreePvp.HeroIds.Count,
                SkillLevelCap = candidate.Heroes.Data.SkillProgression.SkillLevelCap,
                Chapters = chapters.Count,
                Stages = stages.Length,
                Waves = stages.Sum(stage => stage.Waves?.Count ?? 0),
                WorldMapsIncludingTown = candidate.World.Data.Maps.Count
            }
        };
        Console.WriteLine(JsonSerializer.Serialize(report, new JsonSerializerOptions { WriteIndented = true }));
        return changes.Count == 0 ? 0 : 1;
    }

    static bool FourSkillsAtPurple(HeroCatalog catalog, HeroDefinition definition)
    {
        if (!definition.Ranks.Any(rank => rank.Id == FreePvpRoster.RankId)) return false;
        var hero = catalog.CreateHero(definition.Id, definition.Id);
        hero.RankId = FreePvpRoster.RankId;
        return HeroProgression.UnlockedSkills(hero, catalog).Count == 4;
    }

    static void CheckWorldWalkingRoutes(string directory)
    {
        var draft=LoadContentDraft(directory);var rows=new List<object>();
        const float step=.5f;
        foreach(var map in draft.World.Data.Maps)
        foreach(var spawn in map.Spawns)
        {
            // Use the actual movement collision code, including player radius,
            // interaction footprints, props, bounds and world-space origins.
            var visited=new HashSet<(int X,int Y)>();var queue=new Queue<(int X,int Y)>();
            visited.Add((0,0));queue.Enqueue((0,0));
            while(queue.Count>0)
            {
                var node=queue.Dequeue();
                foreach(var direction in new[]{(1,0),(-1,0),(0,1),(0,-1)})
                {
                    var next=(X:node.X+direction.Item1,Y:node.Y+direction.Item2);
                    if(visited.Contains(next))continue;
                    float x=spawn.X+node.X*step,y=spawn.Y+node.Y*step;
                    WorldMovement.Move(map,ref x,ref y,direction.Item1,direction.Item2,step/WorldMovement.Speed);
                    if(Math.Abs(x-spawn.X-next.X*step)>.001 || Math.Abs(y-spawn.Y-next.Y*step)>.001)continue;
                    visited.Add(next);queue.Enqueue(next);
                }
            }
            foreach(var target in map.Interactions)
                Check(visited.Any(p=>Math.Pow(spawn.X+p.X*step-target.X,2)+Math.Pow(spawn.Y+p.Y*step-target.Y,2)<Math.Pow(target.Radius*.9,2)),
                    "World walking route blocked: "+map.Id+"/"+spawn.Id+" -> "+target.Id);
            rows.Add(new{Map=map.Id,Spawn=spawn.Id,ReachableCells=visited.Count,Interactions=map.Interactions.Count});
        }
        Console.WriteLine(JsonSerializer.Serialize(new{State="PASS",Checks=checks,CellSize=step,Routes=rows},new JsonSerializerOptions{WriteIndented=true}));
    }

    static List<string> RetainedContentIssues(ContentDraft baseline, ContentDraft candidate)
    {
        var issues = new List<string>();
        void Retain(string label, IEnumerable<string> previous, IEnumerable<string> current)
        {
            var ids = current.ToHashSet(StringComparer.Ordinal);
            foreach (string missing in previous.Except(ids, StringComparer.Ordinal))
                issues.Add(label + " missing existing ID " + missing);
            foreach (string id in ids.Where(id => ZatodContentIds.Canonical(id) != id).OrderBy(id => id, StringComparer.Ordinal))
                issues.Add(label + " claims legacy alias " + id + " for " + ZatodContentIds.Canonical(id));
        }

        var before = baseline.Heroes.Data;
        var after = candidate.Heroes.Data;
        Retain("Items", before.Items.Select(item => item.DefinitionId), after.Items.Select(item => item.DefinitionId));
        Retain("Monsters", before.Monsters.Select(monster => monster.Id), after.Monsters.Select(monster => monster.Id));
        Retain("Skills", before.Skills.Select(skill => skill.Id), after.Skills.Select(skill => skill.Id));
        Retain("Heroes", before.Heroes.Select(hero => hero.Id), after.Heroes.Select(hero => hero.Id));
        var currentHeroes = after.Heroes.ToDictionary(hero => hero.Id, StringComparer.Ordinal);
        foreach (var previous in before.Heroes)
        {
            if (!currentHeroes.TryGetValue(previous.Id, out var current)) continue;
            var oldRanks = baseline.Heroes.RankPath(previous, null);
            var oldIds = oldRanks.Select(rank => rank.Id).ToArray();
            var retainedOrder = candidate.Heroes.RankPath(current, null).Select(rank => rank.Id)
                .Where(id => oldIds.Contains(id, StringComparer.Ordinal));
            if (!retainedOrder.SequenceEqual(oldIds))
                issues.Add(previous.Id + " lost or reordered an existing rank.");
            Retain(previous.Id + " skill slots", previous.SkillSlots.Select(slot => slot.Id), current.SkillSlots.Select(slot => slot.Id));
            var currentRanks = current.Ranks.ToDictionary(rank => rank.Id, StringComparer.Ordinal);
            foreach (var rank in oldRanks)
                if (currentRanks.TryGetValue(rank.Id, out var retained))
                    Retain(previous.Id + "/" + rank.Id + " equipment slots", rank.EquipmentSlots.Select(slot => slot.Id),
                        retained.EquipmentSlots.Select(slot => slot.Id));
        }

        var oldChapters = baseline.Campaign.Data.Chapters;
        var newChapters = candidate.Campaign.Data.Chapters;
        Retain("Chapters", oldChapters.Select(chapter => chapter.Id), newChapters.Select(chapter => chapter.Id));
        Retain("Stages", oldChapters.SelectMany(chapter => chapter.Stages).Select(stage => stage.Id),
            newChapters.SelectMany(chapter => chapter.Stages).Select(stage => stage.Id));
        Retain("World maps", baseline.World.Data.Maps.Select(map => map.Id), candidate.World.Data.Maps.Select(map => map.Id));
        return issues;
    }
}
