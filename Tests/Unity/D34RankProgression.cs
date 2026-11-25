// Run through Unity Pipeline in Play Mode in the isolated workspace.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

public static class D34RankProgression
{
    static string Id() => Guid.NewGuid().ToString("D");

    public static object Run(string report) => RunCore(report,null);
    public static object RunNative(string baselineData,string report) => RunCore(report,baselineData);
    static object RunCore(string report,string baselineData)
    {
        if (!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))
            throw new InvalidOperationException("Use the isolated validation Editor in Play Mode.");

        int checks = 0;
        void Check(bool condition, string message)
        {
            checks++;
            if (!condition) throw new InvalidOperationException(message);
        }

        var expanded=baselineData==null?null:HeroDataJson.LoadBundledCatalog();
        var documents=new HeroConfigDocuments();
        if(baselineData!=null)foreach(var section in HeroDataJson.Sections)documents.Set(section,File.ReadAllText(Path.Combine(baselineData,section+".txt")));
        var baseline = baselineData==null?HeroDataJson.LoadBundledCatalog():HeroDataJson.ReadDocuments(documents);
        var definition = baseline.Data.Heroes.First(hero => hero.Ranks.Last().Id == "blue");
        var hero = baseline.CreateHero(definition.Id, Id());
        hero.Level = 60;
        hero.Skills[0].Level = 55;
        while (hero.RankId != "blue")
        {
            foreach (var slot in HeroProgression.CurrentRank(hero, baseline).EquipmentSlots)
                HeroProgression.Equip(hero, baseline, slot.Id, slot.RequiredItemId);
            HeroProgression.Promote(hero, baseline);
        }
        var account = new CharacterData { CharacterId = Id(), HeroDesk = { hero } };
        string oldSave = HeroDataJson.WriteCharacter(account, baseline);
        var oldItems = hero.AbsorbedItems.Select(item => item.Id).ToArray();
        var oldLevels = hero.Skills.Select(slot => slot.Level).ToArray();

        var blue = definition.Ranks.Last();
        var ranks = new[] { "blue", "blue_plus_1", "blue_plus_2", "purple" };
        var names = new[] { blue.Name, "Xanh Dương+1", "Xanh Dương+2", "Tím" };
        string fourth = expanded==null?"fixture_fourth":expanded.Hero(definition.Id).SkillSlots.Last().Id;
        if(expanded==null)
        {
        definition.SkillSlots.Add(new HeroSkillSlotDefinition
        {
            Id = fourth, SkillId = definition.SkillSlots[1].SkillId, InitialLevel = 41
        });
        for (int i = 1; i < ranks.Length; i++)
        {
            definition.Ranks.Last().NextRankId = ranks[i];
            definition.Ranks.Add(new HeroRankDefinition
            {
                Id = ranks[i], Name = names[i],
                EquipmentSlots = blue.EquipmentSlots.Select(slot => new EquipmentSlotDefinition
                {
                    Id = slot.Id, RequiredItemId = slot.RequiredItemId
                }).ToList()
            });
        }
        definition.Ranks.Last().UnlockSkillSlotIds.Add(fourth);
        definition.AvailableInFreePvp = true;
        definition.Ranks.Reverse();
        }
        var catalog = expanded??new HeroCatalog(baseline.Data);
        definition=catalog.Hero(definition.Id);
        account = HeroDataJson.ReadCharacter(oldSave, catalog);
        Check(account.HeroDesk.Single().HeroInstanceId == hero.HeroInstanceId, "Migration replaced the Hero ID.");
        hero = account.HeroDesk.Single();
        Check(hero.Skills.Take(3).Select(slot => slot.Level).SequenceEqual(oldLevels) && hero.Skills.Last().Level == 41,
            "Migration changed old skills or failed to seed the fourth slot.");
        var campaign = CampaignDataJson.LoadZatod(catalog);
        var session = new ZatodPlayerSession(catalog, campaign, Id(), account);
        var before = session.BeginCampaign("chapter_one_stage_1", null, 34, Id());
        session.CancelCampaign();
        var ledger = new List<string>(oldItems);
        var root = new GameObject("D34 rank fixture", typeof(RectTransform), typeof(Canvas));
        try
        {
            var font = Resources.Load<TMP_FontAsset>("UI/FormationFont");
            var detail = ZatodHeroDetailView.Create(root.transform, font);
            var result = ZatodBattleResultView.Create(root.transform, font);
            detail.Open(catalog, account, hero.HeroInstanceId, null);
            for (int i = 0; i < ranks.Length; i++)
            {
                string rank = ranks[i];
                Check(hero.RankId == rank && hero.AbsorbedItems.Select(item => item.Id).SequenceEqual(ledger),
                    "Promotion lost rank or absorbed GUIDs at " + rank);
                var current = HeroProgression.CurrentRank(hero, catalog);
                detail.Refresh(account);
                detail.SelectTab(true);
                var panel = detail.GetComponentInChildren<ZatodHeroSkillPanel>();
                var plate = panel.transform.Find("SkillSlots/HeroRank").GetComponent<Image>();
                Check(detail.RankFrame.sprite != null && plate.sprite == detail.RankFrame.sprite && plate.color == detail.RankFrame.color,
                    "Base and Skill did not display the same rank plate at " + rank);
                Check(detail.HeroName.text.EndsWith(current.Name, StringComparison.Ordinal), "Incorrect rank label.");
                string level = panel.transform.Find("SkillSlots/Slot_" + fourth + "/Level").GetComponent<TMP_Text>().text;
                bool purple = rank == "purple";
                Check(level == (purple ? "Lvl 41" : "Tím") && HeroBattleFactory.Create(hero, catalog).Skills.Any(slot => slot.SlotId == fourth) == purple,
                    "Fourth slot lock differs between the UI and battle at " + rank);
                if (purple) break;

                var inventory = new ItemInventory(account, catalog);
                foreach (var slot in current.EquipmentSlots) inventory.AddItemByItemId(slot.RequiredItemId);
                session.QuickEquip(hero.HeroInstanceId, account.Revision, Id());
                Check(hero.EquippedItems.Count == current.EquipmentSlots.Count, "Quick Equip left slots empty at " + rank);
                ledger.AddRange(hero.EquippedItems.Select(item => item.Id));
                string operation = Id();
                long revision = account.Revision;
                var receipt = session.PromoteHero(hero.HeroInstanceId, revision, operation);
                Check(session.PromoteHero(hero.HeroInstanceId, revision, operation) == receipt && hero.EquippedItems.Count == 0,
                    "Promotion retry changed the account again.");
            }

            var saved = HeroDataJson.ReadCharacter(HeroDataJson.WriteCharacter(account, catalog), catalog).HeroDesk.Single();
            Check(saved.RankId == "purple" && saved.AbsorbedItems.Select(item => item.Id).SequenceEqual(ledger),
                "Serialized Purple save lost the absorption ledger.");
            var wire = JsonUtility.FromJson<ZatodMatchDefinition>(JsonUtility.ToJson(before));
            var unit = wire.Players.Single();
            var record = new ZatodReplay { Initial = wire };
            result.Open(record, null, catalog, account, null);
            var card = result.HeroRow.Find("Hero_" + unit.EntityId);
            Check(card.Find("Icon/RankFrame").GetComponent<Image>().sprite.name == "hero_icon_frame_4" && unit.RankId == "blue",
                "A saved Blue battle rendered the newer owned Purple rank.");
            var preset = catalog.FreePvp.CreatePreset(definition.Id);
            var pvp = ZatodMatchFactory.Versus(catalog, new[] { preset }, new[] { preset }, 34, Id(), true);
            var presetRecord = JsonUtility.FromJson<ZatodReplay>(JsonUtility.ToJson(new ZatodReplay { Initial = pvp }));
            result.Open(presetRecord, null, catalog, new CharacterData { CharacterId = Id() }, null);
            card = result.HeroRow.Cast<Transform>().Single(child => child.gameObject.activeSelf);
            Check(card.Find("Icon/RankFrame").GetComponent<Image>().sprite.name == "hero_icon_frame_7" &&
                card.Find("Icon").Cast<Transform>().Count(child => child.name.StartsWith("Star_", StringComparison.Ordinal) && child.gameObject.activeSelf) == 3,
                "An unowned snapshot lost its Purple rank or three stars.");
            unit.RankId = null;
            unit.Stars = 0;
            result.Open(record, null, catalog, account, null);
            card = result.HeroRow.Cast<Transform>().Single(child => child.gameObject.activeSelf);
            Check(card.Find("Icon/RankFrame").GetComponent<Image>().sprite.name == "hero_icon_frame_7",
                "Legacy replay without rank metadata lost its owned fallback.");

            var stage = JsonUtility.FromJson<CampaignStageDefinition>(
                JsonUtility.ToJson(campaign.Stage("chapter_one_stage_1")));
            var first = new WaveSpawnDefinition
            {
                Id = "fixture_rank_5", Kind = SpawnKind.Hero, DefinitionId = definition.Id,
                RankId = "blue_plus_1", Level = 45, Stars = 2
            };
            var last = new WaveSpawnDefinition
            {
                Id = "fixture_rank_7", Kind = SpawnKind.Hero, DefinitionId = definition.Id,
                RankId = "purple", Level = 60, Stars = 3, Boss = true
            };
            stage.Waves[0].Enemies = new List<WaveSpawnDefinition> { first };
            stage.Waves.Last().Enemies = new List<WaveSpawnDefinition> { last };
            var snapshot = ZatodMatchFactory.Spawn(last, catalog, 111);
            var preview = UnityEngine.Object.Instantiate(
                Resources.Load<GameObject>("Zatod/UI/StagePreview/ZatodStagePreviewView"), root.transform)
                .GetComponent<ZatodStagePreviewView>();
            preview.Open(stage, catalog, 0, true, null, null);
            Check(preview.Enemies[0].Frame.sprite.name == "hero_icon_frame_7" &&
                preview.Enemies[0].Level.text == snapshot.Level.ToString() &&
                preview.Enemies[0].Stars.Count(star => star.gameObject.activeSelf) == snapshot.Stars &&
                preview.BossBadges[0].activeSelf == snapshot.Boss, "Stage preview disagreed with the Purple enemy snapshot.");

            var formation = UnityEngine.Object.Instantiate(
                Resources.Load<GameObject>("Zatod/UI/Formation/ZatodFormationView"), root.transform)
                .GetComponent<ZatodFormationView>();
            formation.Open(stage, catalog, account, new List<string> { hero.HeroInstanceId }, null, null);
            Check(formation.EnemyCards[0].Frame.sprite.name == "hero_icon_frame_5" &&
                formation.EnemyCards[0].Level.text == "45" && formation.EnemyCards[0].Stars.Count(star => star.gameObject.activeSelf) == 2,
                "Formation used the serialized rank list index instead of Blue+1.");
            formation.ChangeWave(stage.Waves.Count - 1);
            Check(formation.EnemyCards[0].Frame.sprite == preview.Enemies[0].Frame.sprite &&
                formation.EnemyCards[0].InstanceId == last.Id && formation.RosterCards.Single().Frame.sprite.name == "hero_icon_frame_7",
                "Final wave or owned roster card lost the Purple rank.");
            formation.OpenTeam("pvp", catalog, account, new List<string> { preset.HeroInstanceId }, null, null, new[] { preset });
            Check(formation.TeamCards.Last().Frame.sprite.name == "hero_icon_frame_7" &&
                formation.TeamCards.Last().Stars.Count(star => star.gameObject.activeSelf) == 3,
                "The free PvP formation did not show the preset rank or stars.");
        }
        finally
        {
            UnityEngine.Object.Destroy(root);
        }
        var outcome = new { State = "PASS", Checks = checks, RankPath = ranks, RetainedItemIds = ledger.Count };
        File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(outcome));
        return outcome;
    }
}
