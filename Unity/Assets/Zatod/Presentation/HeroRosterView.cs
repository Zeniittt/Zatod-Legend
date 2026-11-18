using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using Zatod.Heroes;
using Zatod.Networking;

namespace Zatod.Presentation
{
    [DefaultExecutionOrder(40)]
    [RequireComponent(typeof(FormationView))]
    public sealed class HeroRosterView : MonoBehaviour
    {
        public long PreviewGold = 620444897, PreviewDiamonds = 105434, PreviewPower = 10222;
        public int PreviewStamina = 95, PreviewMaxStamina = 140;
        public CharacterData Character { get; private set; }
        public HeroCatalog Catalog { get; private set; }
        public HeroDetailView Detail { get; private set; }
        public bool IsVisible { get { return canvas != null && canvas.activeSelf; } }
        public HeroPosition? Filter { get; private set; }
        public int VisibleHeroCount { get; private set; }
        public UnityEngine.UI.ScrollRect RosterScroll { get; private set; }
        // Account/inventory integration may supply the actual fragment count later.
        public Func<HeroData, long> SoulCountProvider;
        GameObject canvas;
        HeroUi ui;
        FormationView formation;
        RectTransform root, content;
        TextMeshProUGUI rosterCount;
        readonly Dictionary<int, FormationFrame> filters = new Dictionary<int, FormationFrame>();

        void Start()
        {
            var connection = GetComponent<ArenaConnection>();
            if ((connection != null && connection.IsServer) || (Array.IndexOf(Environment.GetCommandLineArgs(), "--arena-smoke") >= 0 || Array.IndexOf(Environment.GetCommandLineArgs(), "--campaign-smoke") >= 0))
            { enabled = false; return; }
            formation = GetComponent<FormationView>();
            if (formation.Selection == null) { enabled = false; return; }
            Bind(formation.Selection.Character, formation.Selection.Catalog);
            Show();
        }

        public void Bind(CharacterData character, HeroCatalog catalog)
        {
            catalog.Bind(character); Character = character; Catalog = catalog;
            if (formation == null) formation = GetComponent<FormationView>();
            if (canvas == null) Build();
            RebuildRoster();
        }

        void Build()
        {
            ui = new HeroUi(formation.Font);
            canvas = ui.Canvas("HeroRosterCanvas", 20, out root);
            var back = ui.Button(root, "HeroRosterBack", 40, 28, 74, 66, () => formation.Show());
            ui.Glyph(back.transform, "BackArrow", 13, 8, 48, 48, 6, HeroUi.Gold);
            ui.Label(root, "HeroRosterTitle", "DANH SÁCH HERO", 132, 34, 480, 52, 29, HeroUi.Gold, bold: true);
            Currency(root, "Gold", PreviewGold.ToString("N0"), 670, 270, HeroHudGlyph.Kind.Gold, HeroUi.Gold);
            Currency(root, "Diamond", PreviewDiamonds.ToString("N0"), 960, 240, HeroHudGlyph.Kind.Diamond, HeroUi.Hex("7ACFE2"));
            Currency(root, "Stamina", PreviewStamina + "/" + PreviewMaxStamina, 1220, 300, HeroHudGlyph.Kind.Stamina, HeroUi.Hex("E6AC70"));
            ui.Frame(root, "HeroRosterPanel", 46, 124, 1508, 732, HeroUi.Panel, HeroUi.Edge);
            rosterCount = ui.Label(root, "HeroRosterCount", "", 68, 132, 1298, 32, 14, HeroUi.Muted, TextAlignmentOptions.Right);
            RosterScroll = ui.Scroll(root, "OwnedHeroList", 64, 178, 1320, 654, out content);
            var grid = content.gameObject.AddComponent<UnityEngine.UI.GridLayoutGroup>();
            grid.constraint = UnityEngine.UI.GridLayoutGroup.Constraint.FixedColumnCount; grid.constraintCount = 2;
            grid.cellSize = new Vector2(644, 174); grid.spacing = new Vector2(16, 16); grid.padding = new RectOffset(8, 8, 4, 12);
            content.gameObject.AddComponent<UnityEngine.UI.ContentSizeFitter>().verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize;
            string[] titles = { "All", "Trước", "Giữa", "Sau" };
            for (int i = 0; i < titles.Length; i++)
            {
                int key = i;
                var button = ui.Button(root, "HeroListFilter-" + i, 1400, 186 + i * 100, 130, 76, () => SetFilter(key == 0 ? (HeroPosition?)null : (HeroPosition)(key - 1)));
                ui.Label(button.transform, "Title", titles[i], 5, 12, 120, 50, 24, HeroUi.Text, TextAlignmentOptions.Center);
                filters.Add(i, button.GetComponent<FormationFrame>());
            }
            Detail = new HeroDetailView(ui, CloseDetail, PreviewGold);
            RefreshFilters();
        }

        void Currency(Transform parent, string name, string value, float x, float width, HeroHudGlyph.Kind kind, Color tint)
        {
            var frame = ui.Frame(parent, name + "Counter", x, 34, width, 48, HeroUi.Deep, HeroUi.Edge);
            ui.Label(frame.transform, name + "Caption", name, 10, 3, 85, 18, 12, HeroUi.Muted);
            ui.Label(frame.transform, name + "Value", value, 8, 18, width - 58, 26, 20, HeroUi.Text, TextAlignmentOptions.Right, true);
            var icon = HeroUi.Rect(frame.transform, name + "Icon", width - 46, 6, 36, 36).gameObject.AddComponent<HeroHudGlyph>();
            icon.Shape = kind; icon.color = tint; icon.raycastTarget = false;
        }

        public void SetFilter(HeroPosition? position)
        {
            Filter = position; RefreshFilters(); RebuildRoster();
        }
        void RefreshFilters()
        {
            int selected = Filter.HasValue ? (int)Filter.Value + 1 : 0;
            foreach (var pair in filters)
            {
                pair.Value.Fill = pair.Key == selected ? HeroUi.Hex("48664B") : HeroUi.Deep;
                pair.Value.Edge = pair.Key == selected ? HeroUi.Gold : HeroUi.Edge; pair.Value.SetVerticesDirty();
            }
        }

        void RebuildRoster()
        {
            HeroUi.Clear(content);
            var heroes = Character.HeroDesk.Where(h => !Filter.HasValue || Catalog.Hero(h.HeroDefinitionId).Position == Filter.Value).ToList();
            VisibleHeroCount = heroes.Count; rosterCount.text = heroes.Count + " HERO";
            foreach (var hero in heroes) MakeRow(hero);
            UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(content);
            RosterScroll.StopMovement(); RosterScroll.verticalNormalizedPosition = 1;
        }

        void MakeRow(HeroData hero)
        {
            var definition = Catalog.Hero(hero.HeroDefinitionId);
            string id = hero.HeroInstanceId;
            var row = ui.Button(content, "HeroListRow-" + id, 0, 0, 644, 174, () => OpenDetail(id), HeroUi.Hex("C6BEA0"));
            ui.Portrait(row.transform, hero, definition, "RankPortrait", 10, 14, 132, 146);
            ui.Label(row.transform, "HeroRowLevel", "Lv." + hero.Level, 20, 110, 100, 22, 13, HeroUi.Text, bold: true);
            ui.Stars(row.transform, "HeroRowStars", hero.Stars, 18, 138, 16);
            ui.Label(row.transform, "HeroRowName", definition.Name, 162, 20, 462, 38, 25, HeroUi.Hex("15221C"), bold: true);
            var rank = HeroProgression.CurrentRank(hero, Catalog);
            ui.Label(row.transform, "HeroRowRank", rank.Name, 164, 67, 452, 24, 15, HeroUi.Hex("384631"));
            var gear = HeroUi.Rect(row.transform, "RequiredGear", 162, 109, 468, 46);
            for (int i = 0; i < 6; i++)
            {
                var slot = ui.Frame(gear, "Requirement-" + i, i * 75, 0, 56, 46, HeroUi.Deep, HeroUi.Edge);
                if (i >= rank.EquipmentSlots.Count) continue;
                var requirement = rank.EquipmentSlots[i];
                var item = Catalog.Item(requirement.RequiredItemId);
                slot.name = "Requirement-" + i + "-" + item.Id;
                ui.Glyph(slot.transform, "ItemIcon", 7, 2, 42, 40, 2, HeroUi.Gold);
                bool equipped = hero.EquippedItems.Any(e => e.SlotId == requirement.Id);
                if (equipped) { slot.Edge = HeroUi.Hex("82BC83"); slot.Thickness = 3; }
            }
        }

        public void Show()
        {
            if (canvas == null) return;
            Detail.Hide(); formation.Hide(); GetComponent<ArenaView>().SetVisible(false);
            canvas.SetActive(true);
        }
        public void Hide() { if (canvas != null) canvas.SetActive(false); Detail?.Hide(); }
        public void OpenDetail(string instanceId)
        {
            var hero = Character.HeroDesk.SingleOrDefault(h => h.HeroInstanceId == instanceId);
            if (hero == null) throw new ArgumentException("Hero is not in this HeroDesk.");
            Detail.Open(hero, Catalog, PreviewPower, SoulCountProvider == null ? 0 : SoulCountProvider(hero));
            canvas.SetActive(false);
        }
        public void CloseDetail() { Detail.Hide(); canvas.SetActive(true); }
        void OnDestroy() { Detail?.Dispose(); if (canvas != null) Destroy(canvas); }
    }
}
