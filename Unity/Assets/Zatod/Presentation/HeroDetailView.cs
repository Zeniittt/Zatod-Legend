using System;
using TMPro;
using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Presentation
{
    // Base tab only. Equipment/quick equip are reserved; configured body prefabs get a model preview.
    public sealed class HeroDetailView : IDisposable
    {
        readonly HeroUi ui;
        readonly GameObject canvas;
        readonly RectTransform root, portrait, summary, stats;
        readonly TextMeshProUGUI name, power;
        public HeroData Hero { get; private set; }
        public bool IsVisible { get { return canvas != null && canvas.activeSelf; } }
        public UnityEngine.UI.ScrollRect StatsScroll { get; private set; }
        public Transform UpgradeReserved { get; private set; }

        public HeroDetailView(HeroUi ui, Action close, long previewGold)
        {
            this.ui = ui;
            canvas = ui.Canvas("HeroDetailCanvas", 30, out root);
            ui.Frame(root, "HeroDetailPanel", 50, 130, 1500, 720, HeroUi.Panel, HeroUi.Edge);
            string[] tabs = { "Base", "Skill", "Skin", "Awaken" };
            for (int i = 0; i < tabs.Length; i++)
            {
                var button = ui.Button(root, "HeroDetailTab-" + tabs[i], 76 + i * 190, 70, 180, 60, () => { }, i == 0 ? HeroUi.Hex("60543A") : HeroUi.Panel);
                button.interactable = i == 0;
                ui.Label(button.transform, "Title", tabs[i], 8, 8, 164, 44, 24, i == 0 ? HeroUi.Text : HeroUi.Muted, TextAlignmentOptions.Center, true);
            }
            ui.Frame(root, "DetailGold", 1200, 64, 300, 42, HeroUi.Deep, HeroUi.Edge);
            ui.Label(root, "DetailGoldValue", previewGold.ToString("N0"), 1212, 66, 236, 38, 19, HeroUi.Gold, TextAlignmentOptions.Right);
            var coin = HeroUi.Rect(root, "DetailGoldIcon", 1454, 68, 34, 34).gameObject.AddComponent<HeroHudGlyph>();
            coin.Shape = HeroHudGlyph.Kind.Gold; coin.color = HeroUi.Gold; coin.raycastTarget = false;
            var exit = ui.Button(root, "CloseHeroDetail", 1492, 112, 58, 58, close);
            ui.Label(exit.transform, "CloseMark", "X", 4, 3, 50, 50, 31, HeroUi.Gold, TextAlignmentOptions.Center, true);

            portrait = HeroUi.Rect(root, "HeroPortrait", 72, 150, 430, 676);
            var title = ui.Frame(root, "HeroDetailNamePlate", 524, 154, 600, 66, HeroUi.Deep, HeroUi.Gold);
            name = ui.Label(title.transform, "HeroDetailName", "", 15, 7, 570, 52, 27, HeroUi.Gold, TextAlignmentOptions.Center, true);
            UpgradeReserved = ui.Frame(root, "HeroUpgradeReserved", 524, 240, 600, 466, HeroUi.Deep, HeroUi.Edge).transform;
            var powerFrame = ui.Frame(root, "HeroPowerPanel", 524, 748, 600, 66, HeroUi.Deep, HeroUi.Gold);
            power = ui.Label(powerFrame.transform, "HeroPower", "", 20, 10, 560, 46, 24, HeroUi.Gold, TextAlignmentOptions.Center, true);
            ui.Frame(root, "HeroSummaryPanel", 1158, 150, 368, 676, HeroUi.Deep, HeroUi.Edge);
            summary = HeroUi.Rect(root, "HeroSummary", 1182, 170, 320, 228);
            ui.Label(root, "HeroStatsTitle", "Hero Stats", 1184, 414, 310, 34, 22, HeroUi.Gold, bold: true);
            StatsScroll = ui.Scroll(root, "HeroStatsScroll", 1182, 466, 320, 332, out stats);
            var layout = stats.gameObject.AddComponent<UnityEngine.UI.VerticalLayoutGroup>();
            layout.spacing = 8; layout.childControlWidth = true; layout.childForceExpandWidth = true;
            layout.childControlHeight = false; layout.childForceExpandHeight = false;
            stats.gameObject.AddComponent<UnityEngine.UI.ContentSizeFitter>().verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize;
            exit.transform.SetAsLastSibling();
            canvas.SetActive(false);
        }

        public void Open(HeroData hero, HeroCatalog catalog, long previewPower, long soulCount)
        {
            var definition = catalog.Hero(hero.HeroDefinitionId);
            var calculated = HeroStatCalculator.Calculate(hero, catalog);
            Hero = hero; HeroUi.Clear(portrait); HeroUi.Clear(summary); HeroUi.Clear(stats);
            HeroUi.Clear(UpgradeReserved);
            canvas.SetActive(true);
            if (!string.IsNullOrEmpty(definition.BodyPrefabResource))
            {
                var preview = HeroUi.Rect(UpgradeReserved, "HeroModelPreview", 0, 0, 600, 466);
                preview.gameObject.AddComponent<Zatod.Animation.HeroModelPreview>().Bind(definition);
            }
            ui.Portrait(portrait, hero, definition, "HeroIllustration", 0, 0, 430, 676);
            ui.Frame(portrait, "PortraitNamePanel", 16, 594, 398, 62, HeroUi.Deep, HeroUi.RankColor(hero));
            ui.Label(portrait, "PortraitHeroName", definition.Name, 30, 600, 370, 50, 28, HeroUi.Gold, TextAlignmentOptions.Center, true);
            name.text = definition.Name + " / " + HeroProgression.CurrentRank(hero, catalog).Name;
            power.text = "POWER   " + previewPower.ToString("N0");
            ui.Label(summary, "HeroLevel", "Level " + hero.Level, 0, 0, 320, 50, 27, HeroUi.Gold, bold: true);
            ui.Frame(summary, "ExpPanel", 0, 66, 320, 38, HeroUi.Panel, HeroUi.Edge);
            ui.Label(summary, "HeroExp", "EXP   " + hero.Exp.ToString("N0"), 12, 68, 296, 34, 20);
            var soul = HeroUi.Rect(summary, "SoulIcon", 0, 122, 38, 38).gameObject.AddComponent<HeroHudGlyph>();
            soul.Shape = HeroHudGlyph.Kind.Soul; soul.color = HeroUi.Hex("CF90DC"); soul.raycastTarget = false;
            ui.Label(summary, "HeroSouls", "Soul   " + soulCount.ToString("N0"), 50, 122, 260, 38, 20, HeroUi.Hex("DFB7E7"));
            ui.Stars(summary, "HeroStars", hero.Stars, 5, 190, 34);
            foreach (var stat in calculated.Stats)
            {
                var row = ui.Frame(stats, "HeroStat-" + stat.StatId, 0, 0, 320, 58, HeroUi.Panel, HeroUi.Hex("39483C"));
                ui.Label(row.transform, "StatName", StatName(stat.StatId, catalog.Stat(stat.StatId).Name), 12, 8, 204, 42, 17);
                ui.Label(row.transform, "StatValue", StatText(stat), 216, 8, 92, 42, 18, HeroUi.Gold, TextAlignmentOptions.Right);
            }
            UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(stats);
            StatsScroll.StopMovement(); StatsScroll.verticalNormalizedPosition = 1;
        }

        static string StatName(string id, string fallback)
        {
            switch (id) { case "health": return "Max HP"; case "attack_range": return "Attack Range"; case "attack_interval": return "Attack Interval"; case "move_speed": return "Move Speed"; default: return fallback; }
        }
        static string StatText(StatValue stat)
        {
            // The existing prototype's attack interval is configured in 20 Hz combat ticks.
            return stat.StatId == "attack_interval" ? (stat.Value / 20f).ToString("0.##", System.Globalization.CultureInfo.InvariantCulture) + " s" : stat.Value.ToString("N0");
        }
        public void Hide() { if (canvas != null) canvas.SetActive(false); }
        public void Dispose() { if (canvas != null) UnityEngine.Object.Destroy(canvas); }
    }
}
