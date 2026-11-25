using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using Zatod.Combat;
using Zatod.Heroes;

static partial class Program
{
    static int WriteFarmPlaythrough(int seed, int budget, string directory, string targetRank)
    {
        var heroes = ImportedCatalog(directory);
        var campaign = new CampaignCatalog(Read<CampaignDefinition>(Path.Combine(directory, "Campaigns.txt")), heroes);
        var progression = new ProgressionCatalog(Read<ProgressionDefinition>(Path.Combine(directory, "Progression.txt")));
        if (targetRank != null)
        {
            var missingPaths = campaign.Data.StarterHeroIds.Where(id =>
                !heroes.RankPath(heroes.Hero(id), null).Any(rank => rank.Id == targetRank)).ToArray();
            if (missingPaths.Length > 0)
                throw new ArgumentException("Target rank " + targetRank + " is absent from starter paths: " + string.Join(", ", missingPaths));
        }
        var crafting = new CraftingCatalog(heroes);
        var stages = campaign.Data.Chapters.SelectMany(c => c.Stages).ToArray();
        var encounterRandom = new Random(seed);
        var lootRandom = new Random(seed ^ 0x51ef);
        const long start = 1_000_000;
        long now = start, waited = 0, earnedGold = 0, spentGold = 0;
        int spentStamina = 0, farmBeforeRetry = 0;
        string Id() => Guid.NewGuid().ToString("D");
        var session = new ZatodPlayerSession(heroes, campaign, Id(),
            rollLoot: stage => ZatodCampaignLoot.Roll(stage, lootRandom.Next, lootRandom.NextDouble),
            progression: progression, clock: () => now);
        var account = session.Account;
        var attempts = new List<object>();
        var actions = new List<object>();
        var clears = new HashSet<string>(StringComparer.Ordinal);
        // A first clear may be lucky. Do not keep farming an encounter that
        // subsequently defeats this same team while safer cleared stages exist.
        var farmBlockedAtLevel = new Dictionary<string,int>(StringComparer.Ordinal);
        var farmRetryAtBattle = new Dictionary<string,int>(StringComparer.Ordinal);
        string firstLoss = null, stop = null;
        Check(account.Inventory.Count == 0 && account.HeroDesk.Select(h => h.HeroDefinitionId)
            .SequenceEqual(campaign.Data.StarterHeroIds), "Playthrough requires the untouched starter account.");

        for (int battle = 1; battle <= budget; battle++)
        {
            if(clears.Count==stages.Length && (targetRank==null || account.HeroDesk.All(ReachedRank)))
            {stop=targetRank==null?"catalog-complete":"catalog-and-rank-complete";break;}
            EquipAndPromote(battle);
            int staminaCap = progression.Player(account.Level).MaxStamina;
            var open = stages.Where(s => !clears.Contains(s.Id) && session.Run.IsUnlocked(s.Id)).ToArray();
            var next = open.FirstOrDefault(s => s.VitalityCost <= staminaCap) ?? open.FirstOrDefault();
            bool campaignComplete = clears.Count == stages.Length;
            if (next == null && (!campaignComplete || targetRank == null || account.HeroDesk.All(ReachedRank)))
            {
                stop = campaignComplete ? (targetRank == null ? "catalog-complete" : "catalog-and-rank-complete") : "no-unlocked-encounter";
                break;
            }
            bool capBlocksFrontier = next != null && next.VitalityCost > staminaCap;
            if (capBlocksFrontier && !progression.Data.PlayerLevels.Any(level =>
                level.Level >= account.Level && open.Any(s => s.VitalityCost <= level.MaxStamina)))
            {
                stop = "entry-exceeds-maximum-stamina";
                break;
            }
            var stage = next == null || capBlocksFrontier || farmBeforeRetry > 0 ? FarmStage(capBlocksFrontier) ?? next : next;
            if (stage == null || stage.VitalityCost > staminaCap)
            {
                stop = capBlocksFrontier ? "entry-exceeds-stamina-cap" : "no-farmable-encounter";
                break;
            }
            bool farming = stage != next;
            if (farming) farmBeforeRetry = Math.Max(0, farmBeforeRetry - 1);
            else if (firstLoss != null) UpgradeOneSkillPerHero(battle);

            session.RefreshEconomy();
            int staminaBefore = account.Stamina;
            if (staminaBefore < stage.VitalityCost)
            {
                long resume = checked(account.StaminaRecoveryTimestamp +
                    (stage.VitalityCost - staminaBefore) * (long)progression.Data.StaminaRecoverySeconds);
                waited += resume - now;
                now = resume;
                Check(session.RefreshEconomy() && account.Stamina >= stage.VitalityCost, "Recovery wait failed to pay the entry cost.");
            }
            int staminaAtEntry = account.Stamina;
            long goldBefore = CurrencyBalance.GetGold(account);
            uint battleSeed = (uint)encounterRandom.NextInt64(1, 1L << 32);
            var match = session.BeginCampaign(stage.Id, null, battleSeed, Id());
            var sim = new ZatodBattleSimulation(match);
            while (!sim.Finished)
            {
                foreach (var actor in sim.Frame().Units.Where(u => u.Team == 0 && u.Alive))
                    sim.RequestUltimate(actor.EntityId);
                sim.Step();
            }
            var claim = sim.Replay();
            now += (long)Math.Ceiling(claim.EndTick * ZatodBattleSimulation.StepSeconds);
            var accepted = session.ValidateCampaign(claim);
            var reward = session.LastCampaignReward.Economy;
            bool won = accepted.Winner == 0;
            Check(accepted.Digest == claim.Digest && reward.StaminaSpent == stage.VitalityCost - (won ? 0 : stage.VitalityReturn),
                "Campaign validation did not settle the simulated match and its stamina cost.");
            Check(reward.Gold == (won ? stage.GoldReward : 0) && CurrencyBalance.GetGold(account) == goldBefore + reward.Gold &&
                (won ? reward.Items.Count <= stage.MaxDropAmount && reward.Items.All(item => ExpectedDrops(stage, item.ItemId) > 0) : reward.Items.Count == 0),
                "Unexpected gold or loot from Campaign settlement.");
            Check(account.HeroDesk.All(h => h.Level <= progression.Player(account.Level).MaxHeroLevel),
                "Hero EXP passed the account level cap.");
            spentStamina += reward.StaminaSpent;
            earnedGold += reward.Gold;
            if (won) clears.Add(stage.Id);
            else
            {
                if(farming){farmBlockedAtLevel[stage.Id]=account.HeroDesk.Min(h=>h.Level);farmRetryAtBattle[stage.Id]=battle+64;}
                firstLoss ??= stage.Id;
                if (!farming) farmBeforeRetry = 3;
            }
            attempts.Add(new { Battle = battle, Stage = stage.Id, Target = next?.Id, Farming = farming,
                FarmingForRank = next == null, FarmingForStaminaCap = capBlocksFrontier,
                Won = won, accepted.Stars, Tick = accepted.EndTick, Seed = battleSeed,
                StaminaBeforeWait = staminaBefore, StaminaAtEntry = staminaAtEntry, StaminaAfter = account.Stamina,
                StaminaSpent = reward.StaminaSpent, reward.Gold, GoldAfter = CurrencyBalance.GetGold(account),
                PlayerLevel = account.Level, PlayerExpGranted = reward.Player.Granted,
                Heroes = account.HeroDesk.Select(h => new { h.HeroDefinitionId, h.Level, h.RankId }).ToArray(),
                HeroExpGranted = reward.Heroes.Select(h => h.Granted).ToArray(), Loot = reward.Items.Select(item => item.ItemId).ToArray() });
            if(battle%250==0)Console.Error.WriteLine($"Battle {battle}: cleared {clears.Count}/{stages.Length}, level {account.Level}, next {next?.Id}, gold {CurrencyBalance.GetGold(account)}, played {stage.Id}, won {won}, farming {farming}, min Hero {account.HeroDesk.Min(h=>h.Level)}");
        }
        EquipAndPromote(attempts.Count + 1);
        Check(CurrencyBalance.GetGold(account) == progression.Data.InitialGold + earnedGold - spentGold,
            "Gold reconciliation failed across farming and upgrades.");
        bool catalogComplete = clears.Count == stages.Length;
        bool rankComplete = targetRank == null || account.HeroDesk.All(ReachedRank);
        string result = catalogComplete && rankComplete
            ? (targetRank == null ? "catalog-complete" : "catalog-and-rank-complete")
            : stop ?? "battle-budget";
        var output = new
        {
            Seed = seed, BattleBudget = budget, Stop = result, CatalogComplete = catalogComplete,
            TargetRank = targetRank, ReachedTargetRank = targetRank == null ? (bool?)null : rankComplete,
            Chapters = campaign.Data.Chapters.Count, TotalStages = stages.Length, Cleared = clears.Count, FirstLoss = firstLoss,
            NextStage = stages.FirstOrDefault(s => !clears.Contains(s.Id) && session.Run.IsUnlocked(s.Id))?.Id,
            PlayerLevel = account.Level, PlayerExp = account.Exp, HeroCap = progression.Player(account.Level).MaxHeroLevel,
            GoldEarned = earnedGold, GoldSpent = spentGold, Gold = CurrencyBalance.GetGold(account), StaminaSpent = spentStamina,
            Stamina = account.Stamina, SimulatedSeconds = now - start, WaitingSeconds = waited,
            Heroes = account.HeroDesk.Select(h => new { h.HeroDefinitionId, h.Level, h.Exp, h.RankId,
                EquipmentCount = h.EquippedItems.Count, AbsorbedCount = h.AbsorbedItems.Count,
                SkillLevels = h.Skills.Select(s => s.Level), Missing = Missing(h).Select(slot => new { slot.Id, slot.RequiredItemId,
                    heroes.Item(slot.RequiredItemId).LevelRequirement,
                    Sources = stages.Where(s => ExpectedDrops(s, slot.RequiredItemId) > 0).Select(s => s.Id),
                    Recipe = crafting.ForItem(slot.RequiredItemId)?.Id }) }),
            Attempts = attempts, Actions = actions, UnreliableFarmStages=farmBlockedAtLevel.Keys.ToArray(),
            Policy = "Untouched starter Heroes with normal Campaign rewards, Auto Ultimate and legal waits. After a frontier defeat, farm three cleared encounters and retry. A cleared encounter that defeats the farming team is skipped for farming until the lowest-level Hero gains a level or 64 other battles pass; use earlier cleared encounters instead. Reserve Gold for gear whose crafting materials are ready before upgrading skills. Continue equipping the final rank while clearing the Campaign, without promoting above the requested rank. Prioritize needed drops, then Hero EXP and Gold. A target run requires all stages cleared and every starter at the target rank."
        };
        Console.WriteLine(JsonSerializer.Serialize(output, new JsonSerializerOptions { WriteIndented = true }));
        return targetRank == null || catalogComplete && rankComplete ? 0 : 1;

        bool ReachedRank(HeroData hero) => targetRank != null &&
            heroes.RankPath(heroes.Hero(hero.HeroDefinitionId), hero.RankId).Any(rank => rank.Id == targetRank);

        IEnumerable<EquipmentSlotDefinition> Missing(HeroData h) => HeroProgression.CurrentRank(h, heroes).EquipmentSlots
            .Where(slot => h.EquippedItems.All(item => item.SlotId != slot.Id));

        void EquipAndPromote(int battle)
        {
            foreach (var hero in account.HeroDesk)
            {
                bool promoted;
                do
                {
                    foreach (var slot in Missing(hero).ToArray())
                    {
                        string item = slot.RequiredItemId;
                        if (hero.Level < heroes.Item(item).LevelRequirement) continue;
                        if (!account.Inventory.Any(i => i.ItemId == item) && TryPlanCraft(item, out var plan))
                            foreach (var recipe in plan)
                            {
                                var receipt = session.Craft(recipe.Id, Id());
                                spentGold += receipt.GoldCharged;
                                actions.Add(new { BeforeBattle = battle, Kind = "craft", Hero = hero.HeroDefinitionId, Item = recipe.OutputItemId, Gold = receipt.GoldCharged });
                            }
                        var owned = account.Inventory.FirstOrDefault(i => i.ItemId == item);
                        if (owned == null) continue;
                        session.EquipItem(hero.HeroInstanceId, slot.Id, owned.Id, Id());
                        actions.Add(new { BeforeBattle = battle, Kind = "equip", Hero = hero.HeroDefinitionId, Item = item });
                    }
                    promoted = !ReachedRank(hero) && HeroProgression.CanPromote(hero, heroes);
                    if (promoted)
                    {
                        session.PromoteHero(hero.HeroInstanceId, account.Revision, Id());
                        actions.Add(new { BeforeBattle = battle, Kind = "promote", Hero = hero.HeroDefinitionId, Rank = hero.RankId });
                    }
                } while (promoted && !ReachedRank(hero));
            }
        }

        bool TryPlanCraft(string item, out List<CraftRecipeDefinition> plan,bool futureGold=false)
        {
            var available = account.Inventory.GroupBy(i => i.ItemId).ToDictionary(group => group.Key, group => group.Count());
            long gold = futureGold?long.MaxValue:CurrencyBalance.GetGold(account);
            var recipes = new List<CraftRecipeDefinition>();
            plan = recipes;
            return Reserve(item, 1);

            bool Reserve(string itemId, int count)
            {
                int stock = available.GetValueOrDefault(itemId);
                var recipe = crafting.ForItem(itemId);
                while (stock < count)
                {
                    if (recipe == null || gold < recipe.GoldCost) return false;
                    gold -= recipe.GoldCost;
                    foreach (var needed in CraftingCatalog.Requirements(recipe))
                        if (!Reserve(needed.Key, needed.Value)) return false;
                    recipes.Add(recipe);
                    stock += recipe.OutputAmount;
                }
                available[itemId] = stock - count;
                return true;
            }
        }

        CampaignStageDefinition FarmStage(bool forStaminaCap)
        {
            int minimumLevel=account.HeroDesk.Min(h=>h.Level);
            var cleared = stages.Where(s => clears.Contains(s.Id) && s.VitalityCost <= progression.Player(account.Level).MaxStamina);
            var eligible=cleared.Where(s=>!farmBlockedAtLevel.TryGetValue(s.Id,out int blocked) || minimumLevel>blocked || attempts.Count>=farmRetryAtBattle[s.Id]).ToArray();
            if(eligible.Length==0)eligible=cleared.Take(1).ToArray();
            if (forStaminaCap)
                return eligible.OrderByDescending(s => s.PlayerExpReward / (double)Math.Max(1, s.VitalityCost))
                    .ThenByDescending(s => s.HeroExpReward / (double)Math.Max(1, s.VitalityCost)).FirstOrDefault();

            var wanted = new HashSet<string>(StringComparer.Ordinal);
            var stock = account.Inventory.GroupBy(i => i.ItemId).ToDictionary(group => group.Key, group => group.Count());
            foreach (var slots in account.HeroDesk.SelectMany(Missing).GroupBy(slot => slot.RequiredItemId))
                AddWanted(slots.Key, slots.Count());
            return eligible
                .OrderByDescending(s => wanted.Sum(item => ExpectedDrops(s, item)) / Math.Max(1, s.VitalityCost))
                .ThenByDescending(s => s.HeroExpReward / (double)Math.Max(1, s.VitalityCost))
                .ThenByDescending(s => s.GoldReward).FirstOrDefault();

            void AddWanted(string item, int quantity)
            {
                int available = stock.GetValueOrDefault(item);
                int reserved = Math.Min(quantity, available);
                stock[item] = available - reserved;
                int missing = quantity - reserved;
                if (missing == 0) return;
                wanted.Add(item);
                var recipe = crafting.ForItem(item);
                if (recipe == null) return;
                int batches = (missing - 1) / recipe.OutputAmount + 1;
                foreach (var ingredient in CraftingCatalog.Requirements(recipe))
                    AddWanted(ingredient.Key, checked(ingredient.Value * batches));
                stock[item] += checked(recipe.OutputAmount * batches - missing);
            }
        }

        void UpgradeOneSkillPerHero(int battle)
        {
            long reserve=0;
            foreach(var hero in account.HeroDesk)
            foreach(var slot in Missing(hero).Where(s=>heroes.Item(s.RequiredItemId).LevelRequirement<=hero.Level))
                if(TryPlanCraft(slot.RequiredItemId,out var plan,true) && plan.Count>0)
                {long price=plan.Sum(p=>p.GoldCost);if(reserve==0 || price<reserve)reserve=price;}
            foreach (var hero in account.HeroDesk)
            {
                var unlocked = HeroProgression.UnlockedSkills(hero, heroes).Select(slot => slot.Id).ToHashSet();
                var skill = hero.Skills.Where(s => unlocked.Contains(s.SlotId) && s.Level < SkillProgression.Cap(hero, heroes))
                    .OrderBy(s => s.Level).FirstOrDefault();
                if (skill == null) continue;
                var cost = heroes.Data.SkillProgression.GoldUpgradeCurve.FirstOrDefault(row => row.FromLevel == skill.Level);
                if (cost == null || cost.Gold+reserve > CurrencyBalance.GetGold(account)) continue;
                var receipt = session.UpgradeSkill(hero.HeroInstanceId, skill.SlotId, skill.Level, 1, account.Revision, Id());
                spentGold += receipt.GoldCharged;
                actions.Add(new { BeforeBattle = battle, Kind = "skill", Hero = hero.HeroDefinitionId,
                    Slot = skill.SlotId, Level = receipt.SkillLevel, Gold = receipt.GoldCharged });
            }
        }
    }

    static double ExpectedDrops(CampaignStageDefinition stage, string item) => stage.DropItems
        .Where(drop => drop.ItemId == item).Sum(drop => drop.DropChancePercent) * stage.MaxDropAmount / 200.0;
}
