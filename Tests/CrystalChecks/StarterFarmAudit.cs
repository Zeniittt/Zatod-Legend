using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using Zatod.Heroes;

static partial class Program
{
    sealed record FarmRoute(int? At, string[] Sources, string[] Missing);

    // This walk assumes every prerequisite encounter can be won and repeated.
    // It establishes a loot/recipe dependency route, not actual progression or balance.
    static void WriteFarmAudit(string directory)
    {
        var heroes = ImportedCatalog(directory);
        var data = Read<CampaignDefinition>(Path.Combine(directory, "Campaigns.txt"));
        var campaign = new CampaignCatalog(data, heroes);
        var crafting = new CraftingCatalog(heroes);
        var stages = data.Chapters.SelectMany(chapter => chapter.Stages.Select(stage => (chapter.Id, Stage: stage))).ToArray();
        var stageIndices = stages.Select((entry, index) => (entry.Stage.Id, index)).ToDictionary(entry => entry.Id, entry => entry.index);
        var stageFrontiers = new Dictionary<int, int>();

        int StageFrontier(int index)
        {
            if (stageFrontiers.TryGetValue(index, out var found)) return found;
            var prerequisite = campaign.Prerequisite(stages[index].Stage.Id);
            int frontier = prerequisite == null ? index : Math.Max(index, StageFrontier(stageIndices[prerequisite]));
            stageFrontiers.Add(index, frontier);
            return frontier;
        }

        var sources = stages
            .SelectMany((entry, index) => entry.Stage.DropItems.Where(drop => drop.DropChancePercent > 0 && entry.Stage.MaxDropAmount > 0)
                .Select(drop => (drop.ItemId, entry.Stage.Id, At: StageFrontier(index))))
            .GroupBy(drop => drop.ItemId, StringComparer.Ordinal)
            .ToDictionary(group => group.Key, group => group.OrderBy(drop => drop.At).First(), StringComparer.Ordinal);
        var memo = new Dictionary<string, FarmRoute>(StringComparer.Ordinal);

        FarmRoute GetRoute(string itemId)
        {
            if (memo.TryGetValue(itemId, out var found)) return found;
            var recipe = crafting.ForItem(itemId);
            var ingredientRoutes = recipe?.Ingredients.Select(ingredient => GetRoute(ingredient.ItemId)).ToArray();
            var missing = ingredientRoutes == null ? new[] { itemId } : ingredientRoutes.SelectMany(route => route.Missing).Distinct().ToArray();
            int? craftAt = ingredientRoutes != null && missing.Length == 0 ? ingredientRoutes.Max(route => route.At) : null;
            if (sources.TryGetValue(itemId, out var direct) && (craftAt == null || direct.At <= craftAt.Value))
                found = new FarmRoute(direct.At, new[] { direct.Id }, Array.Empty<string>());
            else if (craftAt != null)
                found = new FarmRoute(craftAt, ingredientRoutes.SelectMany(route => route.Sources).Distinct().ToArray(), Array.Empty<string>());
            else
                found = new FarmRoute(null, Array.Empty<string>(), missing);
            memo.Add(itemId, found);
            return found;
        }

        var starterRanks = data.StarterHeroIds.Select(heroId =>
        {
            var path = heroes.RankPath(heroes.Hero(heroId), null)
                .SkipWhile(rank => rank.Id != data.StarterHeroRankId);
            return new
            {
                HeroId = heroId,
                Ranks = path.Select(rank => new
                {
                    RankId = rank.Id,
                    rank.NextRankId,
                    Slots = rank.EquipmentSlots.Select(slot => new
                    {
                        SlotId = slot.Id,
                        ItemId = slot.RequiredItemId,
                        heroes.Item(slot.RequiredItemId).LevelRequirement,
                        Route = GetRoute(slot.RequiredItemId)
                    }).ToArray()
                }).ToArray()
            };
        }).ToArray();
        var result = new
        {
            ChapterCount = data.Chapters.Count,
            StageCount = stages.Length,
            Stages = stages.Select((stage, index) => new { Index = index, ChapterId = stage.Id, StageId = stage.Stage.Id,
                RequiredStageId = campaign.Prerequisite(stage.Stage.Id) }),
            StarterRanks = starterRanks,
            Scope = "At is the index of the latest authored stage needed by the route. Null means no route through active Campaign loot and crafting. Assumes repeatable wins and sufficient Gold, levels and stamina. Excludes other acquisition channels."
        };
        Console.WriteLine(JsonSerializer.Serialize(result, new JsonSerializerOptions { WriteIndented = true }));
    }
}
