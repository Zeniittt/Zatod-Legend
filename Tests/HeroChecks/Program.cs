using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using Zatod.Editor;
using Zatod.Heroes;

static class Program
{
    static int checks;
    static readonly JsonSerializerOptions Json = new JsonSerializerOptions { IncludeFields = true };
    static void Check(bool ok, string message) { checks++; if (!ok) throw new Exception(message); }
    static void Reject(Action action, string message)
    {
        bool rejected = false;
        try { action(); } catch (ArgumentException) { rejected = true; }
        Check(rejected, message);
    }
    static HeroCatalog Catalog() { return new HeroCatalog(HeroCatalogSample.Create()); }
    static HeroCatalogData Copy(HeroCatalogData data) { return JsonSerializer.Deserialize<HeroCatalogData>(JsonSerializer.Serialize(data, Json), Json); }
    static void Fill(HeroData hero, HeroCatalog catalog)
    {
        foreach (var slot in HeroProgression.CurrentRank(hero, catalog).EquipmentSlots)
            if (!hero.EquippedItems.Any(i => i.SlotId == slot.Id)) HeroProgression.Equip(hero, catalog, slot.Id, slot.RequiredItemId);
    }

    static void Main()
    {
        Progression(); BalanceAndBattle(); FlexibleRanks(); Validation(); Formation(); ProjectileConfig(); SpawnPoints();
        Console.WriteLine("[HeroChecks] PASS / " + checks + " assertions: rank/gear/absorption, 20->33 rebalance, recipe history, unlocks, detached battle data, validation, owned formation/position filters.");
    }

    static void SpawnPoints()
    {
        var data = HeroCatalogSample.Create();
        data.Heroes[0].SpawnPoints.Add(new HeroSpawnPointDefinition { Id = "hand", Forward = 70, Height = 50 });
        var skill = data.Skills[0]; skill.Delivery = SkillDelivery.Projectile;
        skill.ProjectileResource = "Test/Shot"; skill.ProjectileSpeed = 1000; skill.ProjectileHitRadius = 5; skill.ProjectileLifetimeMilliseconds = 1000;
        skill.ProjectileSpawnPointId = "hand"; skill.ProjectileSpawnOffsetForward = 10;
        var catalog = new HeroCatalog(data); var hero = catalog.CreateHero(data.Heroes[0].Id, "test-points");
        var battle = HeroBattleFactory.Create(hero, catalog);
        var resolved = HeroProjectileOrigin.Resolve(battle.SpawnPoints, battle.Skills[0].Definition);
        Check(resolved.Forward == 80 && resolved.Height == 50, "Shared point resolution");
        data.Heroes[0].SpawnPoints[0].Forward = 999;
        Check(battle.SpawnPoints[0].Forward == 70, "Battle spawn points share source config");
        var bad = Copy(data); bad.Skills[0].ProjectileSpawnPointId = "missing";
        Reject(() => new HeroCatalog(bad), "Unknown spawn point accepted");
        bad = Copy(data); bad.Heroes[0].SpawnPoints.Add(bad.Heroes[0].SpawnPoints[0].Copy());
        Reject(() => new HeroCatalog(bad), "Duplicate spawn point accepted");
        bad = Copy(data); bad.Heroes[0].SpawnPoints[0].Height = -1;
        Reject(() => new HeroCatalog(bad), "Below-ground spawn point accepted");
        bad = Copy(data); bad.Heroes[0].ProjectileHurtboxHeight = 0;
        Reject(() => new HeroCatalog(bad), "Invalid hurtbox height accepted");
    }

    static void Progression()
    {
        var catalog = Catalog();
        var hero = catalog.CreateHero("training_warrior", "hero-1");
        Check(hero.RankId == "white" && hero.Level == 1 && hero.Stars == 1, "Initial progression");
        Check(ReferenceEquals(hero.Definition, catalog.Hero(hero.HeroDefinitionId)), "Runtime definition reference");
        Check(HeroProgression.UnlockedSkills(hero, catalog).Single().IsUltimate, "White ultimate only");
        Check(HeroStatCalculator.Calculate(hero, catalog).Get("damage") == 5, "Initial base attack");
        Reject(() => HeroProgression.Equip(hero, catalog, "missing", "axe_basic"), "Unknown slot accepted");
        Reject(() => HeroProgression.Equip(hero, catalog, "gear_1", "sword_basic"), "Wrong recipe item accepted");
        Check(hero.EquippedItems.Count == 0, "Rejected equip mutated hero");
        for (int i = 1; i <= 5; i++) HeroProgression.Equip(hero, catalog, "gear_" + i, "axe_basic");
        Reject(() => HeroProgression.Equip(hero, catalog, "gear_1", "axe_basic"), "Double equip accepted");
        Reject(() => HeroProgression.Promote(hero, catalog), "Partial gear promoted");
        Check(hero.RankId == "white" && hero.AbsorbedItems.Count == 0 && hero.EquippedItems.Count == 5, "Rejected promotion mutated hero");
        HeroProgression.Equip(hero, catalog, "gear_6", "axe_basic");
        for (int promotion = 1; promotion <= 3; promotion++)
        {
            int before = HeroStatCalculator.Calculate(hero, catalog).Get("damage");
            Check(HeroProgression.CanPromote(hero, catalog), "Full gear not promotable");
            HeroProgression.Promote(hero, catalog);
            Check(hero.EquippedItems.Count == 0 && hero.AbsorbedItems.Count == promotion * 6, "Absorption duplicated/lost gear");
            Check(hero.AbsorbedItems.All(a => a.Quantity == 1 && a.ItemId == "axe_basic"), "Incorrect absorbed facts");
            Check(HeroStatCalculator.Calculate(hero, catalog).Get("damage") == before, "Promotion double-counted or lost gear stats");
            Check(HeroProgression.UnlockedSkills(hero, catalog).Count == promotion + 1, "Incorrect rank unlock");
            if (promotion < 3) Fill(hero, catalog);
        }
        Check(hero.RankId == "purple" && HeroStatCalculator.Calculate(hero, catalog).Get("damage") == 95, "Terminal rank stats");
        Check(!HeroProgression.CanPromote(hero, catalog), "Terminal rank can promote");
        Reject(() => HeroProgression.Promote(hero, catalog), "Terminal promotion accepted");
        var character = new CharacterData { CharacterId = "account-1" };
        character.HeroDesk.Add(hero);
        character.HeroDesk.Add(catalog.CreateHero("training_warrior", "hero-2"));
        catalog.Bind(character);
        Check(character.HeroDesk.Count == 2, "Same hero definition cannot have two owned instances");
        character.HeroDesk[1].HeroInstanceId = "hero-1";
        Reject(() => catalog.Bind(character), "Duplicate owned instance accepted");
        character.HeroDesk[1].HeroInstanceId = "hero-2";
        hero.Definition = null;
        character.HeroDesk[1].RankId = "missing";
        Reject(() => catalog.Bind(character), "Invalid desk accepted");
        Check(hero.Definition == null, "Failed bind partially updated desk");
    }

    static void ProjectileConfig()
    {
        Check((int)SkillTarget.AllAllies == 5 && (int)SkillEffectKind.StatBonus == 3, "Existing serialized skill enum values changed");
        var data = HeroCatalogSample.Create();
        var skill = data.Skills[0];
        skill.Target = SkillTarget.NearestEnemy; skill.AnimationState = "Ultimate"; skill.Delivery = SkillDelivery.Projectile;
        skill.ProjectileResource = "Heroes/Test/Projectile"; skill.ProjectileAim = ProjectileAim.Forward;
        skill.ProjectileSpawnMilliseconds = 250; skill.ProjectileSpeed = 1200; skill.ProjectileHitRadius = 60;
        skill.ProjectileLifetimeMilliseconds = 1750; skill.ProjectileMaxHits = 1;
        skill.Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.KnockUp, KnockUpHeight = 100, DurationMilliseconds = 800 } };
        data.Heroes[0].NormalAttackSkillId = skill.Id;
        var catalog = new HeroCatalog(data); var hero = catalog.CreateHero("training_warrior", "projectile-copy");
        var battleData = HeroBattleFactory.Create(hero, catalog);
        Check(battleData.HasNormalAttack && battleData.NormalAttack.Id == skill.Id, "Battle copy lost configured normal attack");
        battleData.NormalAttack.Effects[0].KnockUpHeight = 999;
        Check(skill.Effects[0].KnockUpHeight == 100, "Normal attack snapshot shared with config");
        var copy = battleData.Skills.Single().Definition;
        Check(copy.AnimationState == "Ultimate" && copy.Delivery == SkillDelivery.Projectile && copy.Target == SkillTarget.NearestEnemy, "Battle snapshot lost skill delivery/animation");
        Check(copy.ProjectileResource == skill.ProjectileResource && copy.ProjectileAim == ProjectileAim.Forward
            && copy.ProjectileSpawnMilliseconds == 250 && copy.ProjectileSpeed == 1200 && copy.ProjectileHitRadius == 60
            && copy.ProjectileLifetimeMilliseconds == 1750 && copy.ProjectileMaxHits == 1, "Battle snapshot lost projectile parameters");
        copy.Effects[0].KnockUpHeight = 999;
        Check(skill.Effects[0].KnockUpHeight == 100, "Runtime control effect shared with config");
        skill.ProjectileSpeed = 0; Reject(() => new HeroCatalog(data), "Zero projectile speed accepted"); skill.ProjectileSpeed = 1200;
        skill.ProjectileMaxHits = 0; Reject(() => new HeroCatalog(data), "Unbounded/zero hit limit accepted"); skill.ProjectileMaxHits = 1;
        skill.ProjectileSpawnMilliseconds = -1; Reject(() => new HeroCatalog(data), "Negative projectile spawn time accepted"); skill.ProjectileSpawnMilliseconds = 250;
        skill.Effects[0].KnockUpHeight = 0; Reject(() => new HeroCatalog(data), "KnockUp without height accepted"); skill.Effects[0].KnockUpHeight = 100;
        skill.Effects[0].DurationMilliseconds = 0; Reject(() => new HeroCatalog(data), "KnockUp without duration accepted"); skill.Effects[0].DurationMilliseconds = 800;
        skill.Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Knockback, DisplacementDistance = 0 } };
        Reject(() => new HeroCatalog(data), "Knockback without distance accepted"); skill.Effects[0].DisplacementDistance = 100;
        _ = new HeroCatalog(data);
        data.Heroes[0].NormalAttackSkillId = "missing"; Reject(() => new HeroCatalog(data), "Missing normal attack reference accepted");
    }

    static void Formation()
    {
        var data = HeroCatalogSample.Create();
        var second = Copy(data).Heroes[0]; second.Id = "middle"; second.Position = HeroPosition.Middle; data.Heroes.Add(second);
        var third = Copy(data).Heroes[0]; third.Id = "rear"; third.Position = HeroPosition.Rear; data.Heroes.Add(third);
        var catalog = new HeroCatalog(data);
        var character = new CharacterData { CharacterId = "formation-test" };
        for (int i = 0; i < 8; i++) character.HeroDesk.Add(catalog.CreateHero(i % 3 == 0 ? "training_warrior" : i % 3 == 1 ? "middle" : "rear", "owned-" + i));
        var selection = new HeroFormation(character, catalog);
        Check(!selection.CanBattle && selection.Selected.Count == 0, "Empty formation can battle");
        Check(selection.Filter(null).Count() == 8 && selection.Filter(HeroPosition.Front).Count() == 3
            && selection.Filter(HeroPosition.Middle).Count() == 3 && selection.Filter(HeroPosition.Rear).Count() == 2, "Position filters");
        foreach (int i in new[] { 2, 1, 0, 4, 3 }) Check(selection.Toggle("owned-" + i), "Owned hero could not be selected");
        Check(selection.CanBattle && selection.Selected.Count == 5, "Formation count/battle gate");
        Check(!selection.Toggle("owned-5") && selection.Selected.Count == 5, "Sixth hero accepted");
        Check(string.Join(",", selection.Selected.Select(h => h.HeroInstanceId)) == "owned-0,owned-3,owned-1,owned-4,owned-2", "Front-to-back stable ordering");
        Check(selection.Toggle("owned-1") && !selection.Contains("owned-1") && selection.Selected.Count == 4, "Deselect failed");
        Check(selection.Toggle("owned-5") && selection.Selected.Count == 5, "Freed slot not reusable");
        Reject(() => selection.Toggle("not-owned"), "Non-owned hero accepted");
        var reloaded = new HeroFormation(character, catalog);
        Check(reloaded.Selected.Select(h => h.HeroInstanceId).SequenceEqual(selection.Selected.Select(h => h.HeroInstanceId)), "Rebinding lost selection");
        character.Formation.HeroInstanceIds.Add("owned-7"); Reject(() => new HeroFormation(character, catalog), "Oversized saved formation accepted");
        character.Formation.HeroInstanceIds = new List<string> { "owned-1", "owned-1" };
        Reject(() => new HeroFormation(character, catalog), "Duplicate saved formation accepted");
        character.Formation.HeroInstanceIds = new List<string> { "missing" };
        Reject(() => new HeroFormation(character, catalog), "Unknown saved formation accepted");
    }

    static void BalanceAndBattle()
    {
        var data = HeroCatalogSample.Create();
        data.Heroes[0].Ranks[0].EquipmentSlots = data.Heroes[0].Ranks[0].EquipmentSlots.Take(1).ToList();
        data.Heroes[0].Ranks[1].EquipmentSlots = data.Heroes[0].Ranks[1].EquipmentSlots.Take(2).ToList();
        var catalog = new HeroCatalog(data);
        var hero = catalog.CreateHero("training_warrior", "example-20-33");
        Fill(hero, catalog); HeroProgression.Promote(hero, catalog); Fill(hero, catalog);
        var result = HeroStatCalculator.Calculate(hero, catalog);
        Check(result.Get("damage") == 20, "5 base + 1 absorbed axe + 2 equipped axes must be 20");
        Check(result.Breakdown.Where(b => b.StatId == "damage").Sum(b => b.Value) == 20, "Breakdown differs from total");
        var battle = HeroBattleFactory.Create(hero, catalog);
        var secondBattle = HeroBattleFactory.Create(hero, catalog);
        Check(battle.CurrentHp == 600 && battle.Energy == 0 && battle.Skills.Count == 2, "Battle initialization");
        battle.Stats.Single(s => s.StatId == "defense").Value -= 10;
        battle.CurrentHp = 25;
        battle.Skills[0].Definition.Effects[0].Amount = 999;
        battle.Skills[0].CooldownRemainingMilliseconds = 500;
        Check(HeroStatCalculator.Calculate(hero, catalog).Get("defense") == 10, "Stage modifier changed owned stats");
        Check(secondBattle.Stats.Single(s => s.StatId == "defense").Value == 10 && secondBattle.CurrentHp == 600, "Runtime data shared between battles");
        Check(catalog.Skill("warrior_ultimate").Effects[0].Amount == 0, "Runtime effect mutated config");
        Check(secondBattle.Skills[0].Definition.Effects[0].Amount == 0 && secondBattle.Skills[0].CooldownRemainingMilliseconds == 0, "Skill effects/cooldowns shared between battles");
        var changed = Copy(data);
        changed.ConfigVersion = "heroes-prototype-2";
        changed.Heroes[0].BaseStats.Single(s => s.StatId == "damage").Value = 3;
        changed.Items.Single(i => i.Id == "axe_basic").Stats[0].Value = 10;
        changed.Skills[0].Effects[0].DamageScaleBasisPoints = 20000;
        var balanced = new HeroCatalog(changed);
        Check(HeroStatCalculator.Calculate(hero, balanced).Get("damage") == 33, "3 base + 1 absorbed axe + 2 equipped axes must be 33");
        Check(battle.Stats.Single(s => s.StatId == "damage").Value == 20 && battle.ConfigVersion == "heroes-prototype-1", "Rebalance changed existing battle stats");
        Check(battle.Skills[0].Definition.Effects[0].DamageScaleBasisPoints == 12000, "Rebalance changed existing battle skill snapshot");
        var character = new CharacterData { CharacterId = "account-1", HeroDesk = new List<HeroData> { hero } };
        balanced.Bind(character);
        Check(ReferenceEquals(hero.Definition, changed.Heroes[0]), "Config reference not refreshed on bind");

        // Recipe change is not an implicit migration. Actual absorbed/equipped item IDs survive.
        foreach (var rank in changed.Heroes[0].Ranks)
            foreach (var slot in rank.EquipmentSlots) slot.RequiredItemId = "sword_basic";
        var recipe = new HeroCatalog(changed);
        Check(HeroStatCalculator.Calculate(hero, recipe).Get("damage") == 33, "Recipe rewrote existing gear history");
        Check(HeroProgression.CanPromote(hero, recipe), "Previously equipped items not grandfathered");
        HeroProgression.Promote(hero, recipe);
        Check(hero.AbsorbedItems.Count == 3 && hero.AbsorbedItems.All(i => i.ItemId == "axe_basic"), "Promotion replaced grandfathered item IDs");
        Check(HeroStatCalculator.Calculate(hero, recipe).Get("damage") == 33, "Grandfathered gear changed on promotion");
        // Historical slot removal must not invalidate prior facts.
        changed.Heroes[0].Ranks[0].EquipmentSlots[0].Id = "new_recipe_slot";
        recipe = new HeroCatalog(changed);
        Check(HeroStatCalculator.Calculate(hero, recipe).Get("damage") == 33, "Old slot ID removal rewrote history");
        var newcomer = recipe.CreateHero("training_warrior", "newcomer");
        Reject(() => HeroProgression.Equip(newcomer, recipe, "new_recipe_slot", "axe_basic"), "New equip used obsolete recipe");
        HeroProgression.Equip(newcomer, recipe, "new_recipe_slot", "sword_basic");
        Check(HeroStatCalculator.Calculate(newcomer, recipe).Get("damage") == 10, "New equip did not use new recipe");

        var floor = HeroCatalogSample.Create();
        floor.Heroes[0].Ranks[0].BonusStats.Add(new StatValue("defense", -100));
        var floorCatalog = new HeroCatalog(floor);
        var floorHero = floorCatalog.CreateHero("training_warrior", "floor");
        Check(HeroStatCalculator.Calculate(floorHero, floorCatalog).Get("defense") == 0, "Stat minimum not applied at end");
        floor.Items[0].Stats[0].Value = int.MaxValue;
        floorHero.EquippedItems.Add(new EquippedItemData { SlotId = "gear_1", ItemId = "axe_basic" });
        bool overflow = false;
        try { HeroStatCalculator.Calculate(floorHero, floorCatalog); } catch (OverflowException) { overflow = true; }
        Check(overflow, "Overflow silently wrapped stat");
    }

    static void FlexibleRanks()
    {
        var data = HeroCatalogSample.Create();
        var oldCatalog = new HeroCatalog(data);
        var hero = oldCatalog.CreateHero("training_warrior", "rank-insertion");
        Fill(hero, oldCatalog); HeroProgression.Promote(hero, oldCatalog);
        Fill(hero, oldCatalog); HeroProgression.Promote(hero, oldCatalog);
        Check(hero.RankId == "blue", "Setup blue hero");
        var changed = Copy(data);
        changed.Heroes[0].Ranks.Single(r => r.Id == "green").NextRankId = "green_plus_1";
        changed.Heroes[0].Ranks.Add(new HeroRankDefinition
        {
            Id = "green_plus_1", Name = "Xanh Lá +1", NextRankId = "blue",
            EquipmentSlots = new List<EquipmentSlotDefinition> { new EquipmentSlotDefinition { Id = "extra_1", RequiredItemId = "axe_basic" } }
        });
        changed.Heroes[0].Ranks.Reverse();
        var catalog = new HeroCatalog(changed);
        Check(HeroStatCalculator.Calculate(hero, catalog).Get("damage") == 65 && hero.RankId == "blue", "Inserting/reordering ranks changed existing rank/history");
        Check(HeroProgression.UnlockedSkills(hero, catalog).Count == 3, "Intermediate rank unlocked unintended skill");
        var newcomer = catalog.CreateHero("training_warrior", "new-path");
        Fill(newcomer, catalog); HeroProgression.Promote(newcomer, catalog);
        Fill(newcomer, catalog); HeroProgression.Promote(newcomer, catalog);
        Check(newcomer.RankId == "green_plus_1" && HeroProgression.UnlockedSkills(newcomer, catalog).Count == 2, "Intermediate rank path/unlocks");
        Fill(newcomer, catalog); HeroProgression.Promote(newcomer, catalog);
        Check(newcomer.RankId == "blue" && HeroStatCalculator.Calculate(newcomer, catalog).Get("damage") == 70, "Intermediate gear not absorbed");
        Check(newcomer.AbsorbedItems.Count == 13, "Intermediate absorbed ledger");
    }

    static void Validation()
    {
        var bad = HeroCatalogSample.Create(); bad.Items.Add(bad.Items[0]);
        Reject(() => new HeroCatalog(bad), "Duplicate definition ID");
        bad = HeroCatalogSample.Create(); bad.SchemaVersion = 2;
        Reject(() => new HeroCatalog(bad), "Unknown config schema");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].Ranks[3].NextRankId = "white";
        Reject(() => new HeroCatalog(bad), "Rank cycle");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].Ranks[0].NextRankId = "missing";
        Reject(() => new HeroCatalog(bad), "Dangling rank");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].Ranks.Add(new HeroRankDefinition { Id = "unused" });
        Reject(() => new HeroCatalog(bad), "Unreachable rank");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].Ranks[0].EquipmentSlots[0].RequiredItemId = "missing";
        Reject(() => new HeroCatalog(bad), "Missing required item");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].BaseStats.Add(new StatValue("missing", 1));
        Reject(() => new HeroCatalog(bad), "Unknown stat");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].BaseStats.Add(new StatValue("damage", 1));
        Reject(() => new HeroCatalog(bad), "Duplicate stat");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].Ranks[0].UnlockSkillSlotIds.Clear();
        Reject(() => new HeroCatalog(bad), "Ultimate locked at starting rank");
        bad = HeroCatalogSample.Create(); bad.Heroes[0].Ranks[1].UnlockSkillSlotIds.Add("ultimate");
        Reject(() => new HeroCatalog(bad), "Duplicate unlock");
        bad = HeroCatalogSample.Create(); bad.Skills[2].Activation = SkillActivation.UltimateIntent;
        Reject(() => new HeroCatalog(bad), "Passive uses manual activation");
        bad = HeroCatalogSample.Create(); bad.Skills[0].Effects[0].DamageScaleBasisPoints = -1;
        Reject(() => new HeroCatalog(bad), "Negative skill scale");
        var catalog = Catalog();
        var hero = catalog.CreateHero("training_warrior", "invalid-progress");
        hero.RankId = null;
        Reject(() => catalog.ValidateHero(hero), "Missing rank treated as terminal rank");
        hero.RankId = "white";
        hero.AbsorbedItems.Add(new AbsorbedItemData { RankId = "white", SlotId = "gear_1", ItemId = "axe_basic" });
        Reject(() => catalog.ValidateHero(hero), "Current rank counted as absorbed");
        hero.AbsorbedItems.Clear(); Fill(hero, catalog); HeroProgression.Promote(hero, catalog);
        hero.AbsorbedItems.Add(hero.AbsorbedItems[0]);
        Reject(() => catalog.ValidateHero(hero), "Duplicate absorbed slot");
        hero.AbsorbedItems.RemoveAt(hero.AbsorbedItems.Count - 1); hero.AbsorbedItems[0].Quantity = 0;
        Reject(() => catalog.ValidateHero(hero), "Zero absorbed quantity");
        hero.AbsorbedItems[0].Quantity = 1; hero.Skills.Clear();
        Reject(() => catalog.ValidateHero(hero), "Missing skill progress");
        Reject(() => catalog.Bind(new CharacterData { CharacterId = "account", SchemaVersion = 99 }), "Unknown save schema");
    }
}
