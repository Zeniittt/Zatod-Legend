using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem.UI;
using Zatod.Heroes;
using Zatod.Networking;

namespace Zatod.Presentation
{
    [Serializable]
    public sealed class FormationRosterTab
    {
        public string Id = "owned", Title = "Hero";
        // Empty means the entire owned roster. Future tabs can supply a subset of definition IDs.
        public List<string> HeroDefinitionIds = new List<string>();
    }

    [DefaultExecutionOrder(20)]
    [RequireComponent(typeof(ArenaView))]
    public sealed class FormationView : MonoBehaviour
    {
        public TMP_FontAsset Font;
        public List<FormationRosterTab> Tabs = new List<FormationRosterTab> { new FormationRosterTab() };
        public HeroFormation Selection { get; private set; }
        public bool IsVisible { get { return canvas != null && canvas.activeSelf; } }
        public HeroPosition? Filter { get; private set; }
        public string ActiveTab { get; private set; } = "owned";
        public event Action<HeroFormationData> BattleRequested;
        public Action<HeroFormationData> BattleOverride;
        public Action BackOverride;
        UnityEngine.UI.Button backButton;
        TextMeshProUGUI contextTitle;
        public int VisibleHeroCount { get; private set; }
        public UnityEngine.UI.ScrollRect RosterScroll { get; private set; }
        GameObject canvas;
        RectTransform root, content, selectedArea;
        TextMeshProUGUI count, hint, rosterCount;
        UnityEngine.UI.Button battle;
        ArenaView arena;
        readonly Dictionary<string, Card> cards = new Dictionary<string, Card>();
        readonly Dictionary<int, FormationFrame> filterFrames = new Dictionary<int, FormationFrame>();
        readonly Dictionary<string, FormationFrame> tabFrames = new Dictionary<string, FormationFrame>();
        static readonly Color Gold = Hex("E6C780"), Silver = Hex("8F9480"), Text = Hex("F0EADB"), Muted = Hex("A3AD9D");
        static readonly Color Panel = Hex("242C28"), Deep = Hex("141E1C"), Amber = Hex("9A642D"), Green = Hex("82C699");
        sealed class Card { public FormationFrame Frame; public GameObject Selected; }

        void Start()
        {
            var connection = GetComponent<ArenaConnection>();
            if ((connection != null && connection.IsServer) || (Array.IndexOf(Environment.GetCommandLineArgs(), "--arena-smoke") >= 0 || Array.IndexOf(Environment.GetCommandLineArgs(), "--campaign-smoke") >= 0))
            { enabled = false; return; }
            arena = GetComponent<ArenaView>();
            if (Font == null) Font = Resources.Load<TMP_FontAsset>("UI/FormationFont") ?? arena.Font;
            try
            {
                var catalog = HeroDataJson.LoadBundledCatalog();
                Bind(CreateDemoCharacter(catalog), catalog);
            }
            catch (Exception error)
            {
                Debug.LogError("[Formation] Could not load owned Hero preview: " + error.Message);
                arena.SetVisible(true); enabled = false;
            }
        }

        // Replace this prototype profile with the authenticated character when account loading exists.
        public static CharacterData CreateDemoCharacter(HeroCatalog catalog)
        {
            var data = new CharacterData { CharacterId = "formation-preview", Name = "Preview" };
            int index = 0;
            foreach (var definition in catalog.Data.Heroes.OrderBy(h => string.IsNullOrEmpty(h.BodyPrefabResource) ? 1 : 0))
            {
                var hero = catalog.CreateHero(definition.Id, "preview-" + definition.Id);
                bool realHero = !string.IsNullOrEmpty(definition.BodyPrefabResource);
                for (int i = 0; i < (realHero ? 0 : index % 4) && !string.IsNullOrEmpty(HeroProgression.CurrentRank(hero, catalog).NextRankId); i++)
                {
                    foreach (var slot in HeroProgression.CurrentRank(hero, catalog).EquipmentSlots)
                        HeroProgression.Equip(hero, catalog, slot.Id, slot.RequiredItemId);
                    HeroProgression.Promote(hero, catalog);
                }
                data.HeroDesk.Add(hero); if (!realHero) index++;
            }
            return data;
        }

        public void Bind(CharacterData data, HeroCatalog catalog)
        {
            Selection = new HeroFormation(data, catalog);
            if (canvas == null) Build();
            RebuildRoster(); RefreshSelection();
        }

        public void Show()
        {
            if (canvas == null) return;
            GetComponent<HeroRosterView>()?.Hide();
            arena.SetVisible(false); canvas.SetActive(true); if(backButton!=null)backButton.interactable=BackOverride!=null;RefreshSelection();
        }

        public void Hide() { if (canvas != null) canvas.SetActive(false); }
        public void SetBattleContext(string title,Action<HeroFormationData> battleHandler,Action backHandler)
        {BattleOverride=battleHandler;BackOverride=backHandler;if(contextTitle!=null)contextTitle.text=title??"CHỌN ĐỘI HÌNH";if(backButton!=null)backButton.interactable=backHandler!=null;}

        void Build()
        {
            canvas = new GameObject("FormationCanvas", typeof(RectTransform), typeof(Canvas), typeof(UnityEngine.UI.CanvasScaler), typeof(UnityEngine.UI.GraphicRaycaster));
            canvas.GetComponent<Canvas>().renderMode = RenderMode.ScreenSpaceOverlay;
            canvas.GetComponent<Canvas>().sortingOrder = 10;
            var scaler = canvas.GetComponent<UnityEngine.UI.CanvasScaler>();
            scaler.uiScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1600, 900); scaler.screenMatchMode = UnityEngine.UI.CanvasScaler.ScreenMatchMode.Expand;
            canvas.AddComponent<FormationBackdrop>().raycastTarget = false;
            root = Rect(canvas.transform, "FormationLayout", 0, 0, 1600, 900);
            root.anchorMin = root.anchorMax = root.pivot = new Vector2(.5f, .5f); root.anchoredPosition = Vector2.zero;
            if (FindAnyObjectByType<EventSystem>() == null) new GameObject("EventSystem", typeof(EventSystem), typeof(InputSystemUIInputModule));

            var back = MakeButton(root, "FormationBack", 34, 30, 92, 72, () => BackOverride?.Invoke(), Panel, Silver);backButton=back;
            back.interactable = false; Icon(back.transform, "BackArrow", 18, 9, 56, 54, 6, Gold);
            if (GetComponent<HeroRosterView>() != null)
            {
                var roster = MakeButton(root, "OpenHeroRoster", 34, 790, 130, 62, () => GetComponent<HeroRosterView>().Show(), Panel, Silver);
                Label(roster.transform, "HEROES", 6, 9, 118, 44, 18, Gold, TextAlignmentOptions.Center, true);
            }
            Frame(root, "SquadPanel", 174, 24, 1010, 850, Panel, Silver, 14);
            Frame(root, "RecommendationsReserved", 190, 40, 978, 106, Deep, Silver, 12);
            Frame(root, "DetailsReserved", 1204, 24, 366, 734, new Color(.10f, .15f, .13f, .82f), Silver, 12);
            contextTitle=Label(root, "CHỌN ĐỘI HÌNH", 206, 165, 650, 30, 22, Gold, TextAlignmentOptions.Left, true);
            rosterCount = Label(root, "", 888, 165, 260, 30, 14, Muted, TextAlignmentOptions.Right);
            BuildTabs();

            var scrollRoot = Rect(root, "HeroRoster", 202, 210, 950, 392);
            RosterScroll = scrollRoot.gameObject.AddComponent<UnityEngine.UI.ScrollRect>();
            RosterScroll.horizontal = false; RosterScroll.vertical = true;
            RosterScroll.movementType = UnityEngine.UI.ScrollRect.MovementType.Clamped;
            RosterScroll.scrollSensitivity = 35;
            var viewport = Rect(scrollRoot, "Viewport", 0, 0, 950, 392);
            viewport.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            var hit = viewport.gameObject.AddComponent<UnityEngine.UI.Image>(); hit.color = new Color(1, 1, 1, .001f); hit.raycastTarget = true;
            content = Rect(viewport, "Content", 0, 0, 950, 0);
            content.anchorMin = new Vector2(0, 1); content.anchorMax = Vector2.one;
            content.pivot = new Vector2(.5f, 1); content.offsetMin = content.offsetMax = Vector2.zero;
            var grid = content.gameObject.AddComponent<UnityEngine.UI.GridLayoutGroup>();
            grid.cellSize = new Vector2(144, 164); grid.spacing = new Vector2(14, 16);
            grid.padding = new RectOffset(3, 3, 3, 12); grid.constraint = UnityEngine.UI.GridLayoutGroup.Constraint.FixedColumnCount; grid.constraintCount = 6;
            var fitter = content.gameObject.AddComponent<UnityEngine.UI.ContentSizeFitter>(); fitter.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize;
            RosterScroll.viewport = viewport; RosterScroll.content = content;
            BuildFilters();
            Frame(root, "SelectionPanel", 190, 690, 978, 166, Deep, Silver, 12);
            count = Label(root, "", 210, 662, 420, 24, 15, Gold, TextAlignmentOptions.Left, true);
            hint = Label(root, "", 630, 662, 514, 24, 13, Muted, TextAlignmentOptions.Right);
            selectedArea = Rect(root, "SelectedHeroes", 212, 703, 936, 142);
            battle = MakeButton(root, "FormationBattle", 1214, 782, 346, 80, BeginBattle, Amber, Gold);
            Icon(battle.transform, "BattleIcon", 40, 11, 58, 58, 2, Gold);
            Label(battle.transform, "Battle", 110, 12, 208, 56, 30, Gold, TextAlignmentOptions.Center, true);
        }

        void BuildTabs()
        {
            if (Tabs == null || Tabs.Count == 0) Tabs = new List<FormationRosterTab> { new FormationRosterTab() };
            if (!Tabs.Any(t => t.Id == ActiveTab)) ActiveTab = Tabs[0].Id;
            for (int i = 0; i < Tabs.Count; i++)
            {
                var tab = Tabs[i]; string id = tab.Id;
                var button = MakeButton(root, "RosterTab-" + id, 46, 158 + i * 120, 130, 108, () => SelectTab(id), Panel, Silver);
                tabFrames.Add(id, button.GetComponent<FormationFrame>());
                Icon(button.transform, "TabIcon", 39, 9, 52, 54, 1, Gold);
                Label(button.transform, tab.Title, 8, 65, 114, 30, 19, Text, TextAlignmentOptions.Center, true);
            }
            RefreshTabs();
        }

        void BuildFilters()
        {
            var names = new[] { "All", "Trước", "Giữa", "Sau" };
            for (int i = 0; i < names.Length; i++)
            {
                int key = i;
                var button = MakeButton(root, "PositionFilter-" + i, 414 + i * 148, 618, 132, 44,
                    () => SetFilter(key == 0 ? (HeroPosition?)null : (HeroPosition)(key - 1)), Panel, Silver);
                filterFrames.Add(i, button.GetComponent<FormationFrame>());
                Label(button.transform, names[i], 4, 3, 124, 38, 19, Text, TextAlignmentOptions.Center);
            }
            RefreshFilters();
        }

        public void SelectTab(string id)
        {
            if (!Tabs.Any(t => t.Id == id)) throw new ArgumentException("Unknown formation tab.");
            ActiveTab = id; RefreshTabs(); RebuildRoster();
        }

        public void SetFilter(HeroPosition? position)
        {
            Filter = position; RefreshFilters(); RebuildRoster();
        }

        void RefreshTabs()
        {
            foreach (var pair in tabFrames) { pair.Value.Fill = pair.Key == ActiveTab ? Hex("514D39") : Panel; pair.Value.Edge = pair.Key == ActiveTab ? Gold : Silver; pair.Value.SetVerticesDirty(); }
        }
        void RefreshFilters()
        {
            int key = Filter.HasValue ? (int)Filter.Value + 1 : 0;
            foreach (var pair in filterFrames) { pair.Value.Fill = pair.Key == key ? Amber : Panel; pair.Value.Edge = pair.Key == key ? Gold : Silver; pair.Value.SetVerticesDirty(); }
        }

        void RebuildRoster()
        {
            if (content == null) return;
            Clear(content); cards.Clear();
            var tab = Tabs.Single(t => t.Id == ActiveTab);
            var heroes = Selection.Filter(Filter).Where(h => tab.HeroDefinitionIds.Count == 0 || tab.HeroDefinitionIds.Contains(h.HeroDefinitionId)).ToList();
            VisibleHeroCount = heroes.Count;
            foreach (var hero in heroes)
            {
                string id = hero.HeroInstanceId;
                var card = MakeCard(content, hero, "HeroCard-" + id, 0, 0, 144, 164, false);
                card.Frame.gameObject.GetComponent<UnityEngine.UI.Button>().onClick.AddListener(() => ToggleHero(id));
                cards.Add(id, card);
            }
            rosterCount.text = heroes.Count + " HERO";
            UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(content);
            RosterScroll.StopMovement(); RosterScroll.verticalNormalizedPosition = 1;
            RefreshSelection();
        }

        public void ToggleHero(string id)
        {
            bool changed = Selection.Toggle(id);
            RefreshSelection();
            if (!changed) hint.text = "Đội hình đã đủ 5 Hero.";
        }

        void RefreshSelection()
        {
            if (selectedArea == null) return;
            Clear(selectedArea);
            var selected = Selection.Selected;
            for (int i = 0; i < HeroFormation.Capacity; i++)
            {
                if (i < selected.Count)
                {
                    var hero = selected[i]; string id = hero.HeroInstanceId;
                    var card = MakeCard(selectedArea, hero, "SelectedSlot-" + i, 24 + i * 184, 0, 144, 140, true);
                    card.Frame.gameObject.GetComponent<UnityEngine.UI.Button>().onClick.AddListener(() => ToggleHero(id));
                }
                else
                {
                    var slot = Frame(selectedArea, "SelectedSlot-" + i, 24 + i * 184, 0, 144, 140, Hex("323B34"), Silver, 8);
                    Label(slot.transform, (i + 1).ToString("00"), 4, 48, 136, 38, 24, Hex("687568"), TextAlignmentOptions.Center);
                }
            }
            foreach (var pair in cards)
            {
                bool chosen = Selection.Contains(pair.Key); pair.Value.Selected.SetActive(chosen);
                pair.Value.Frame.Edge = chosen ? Gold : RankColor(Selection.Character.HeroDesk.Single(h => h.HeroInstanceId == pair.Key));
                pair.Value.Frame.Thickness = chosen ? 4 : 2; pair.Value.Frame.SetVerticesDirty();
            }
            count.text = "ĐỘI HÌNH  " + selected.Count + " / 5";
            hint.text = selected.Count == 0 ? "Chạm Hero để thêm vào đội hình." : "Chạm Hero đã chọn để bỏ chọn.";
            battle.interactable = Selection.CanBattle;
        }

        Card MakeCard(Transform parent, HeroData hero, string name, float x, float y, float w, float h, bool selectedSlot)
        {
            var definition = Selection.Catalog.Hero(hero.HeroDefinitionId);
            var button = MakeButton(parent, name, x, y, w, h, () => { }, Deep, RankColor(hero));
            var frame = button.GetComponent<FormationFrame>();
            int index = Selection.Character.HeroDesk.IndexOf(hero);
            Color accent = PortraitColor(index);
            var inset = Frame(button.transform, "PortraitSurface", 5, 5, w - 10, h - 38, new Color(accent.r * .15f, accent.g * .15f, accent.b * .15f), new Color(accent.r, accent.g, accent.b, .3f), 6);
            var portrait = Resources.Load<Sprite>("HeroPortraits/" + definition.Id);
            if (portrait != null)
            {
                var image = Rect(inset.transform, "HeroPortrait", 4, 4, w - 18, h - 46).gameObject.AddComponent<UnityEngine.UI.Image>();
                image.sprite = portrait; image.preserveAspect = true; image.raycastTarget = false;
            }
            else Icon(inset.transform, "HeroGlyph", 14, 4, w - 38, h - 55, PortraitShape(definition), accent);
            Label(button.transform, "Lv." + hero.Level, 10, h - 60, 70, 20, 12, Text, TextAlignmentOptions.Left, true);
            Label(button.transform, "*", w - 30, h - 61, 20, 22, 20, Gold, TextAlignmentOptions.Center, true);
            Label(button.transform, definition.Name, 5, h - 30, w - 10, 25, 13, Text, TextAlignmentOptions.Center, true);
            var check = Frame(button.transform, "SelectionBadge", w - 34, 5, 29, 29, Amber, Gold, 5);
            Icon(check.transform, "SelectedCheck", 1, 1, 27, 27, selectedSlot ? 2 : 7, Gold);
            check.gameObject.SetActive(selectedSlot || Selection.Contains(hero.HeroInstanceId));
            return new Card { Frame = frame, Selected = check.gameObject };
        }

        void BeginBattle()
        {
            if (!Selection.CanBattle) return;
            if(BattleOverride!=null){BattleOverride(new HeroFormationData{HeroInstanceIds=Selection.Character.Formation.HeroInstanceIds.ToList()});return;}
            BattleRequested?.Invoke(new HeroFormationData { HeroInstanceIds = Selection.Character.Formation.HeroInstanceIds.ToList() });
            GetComponent<ArenaConnection>().SelectedHeroInstanceIds = Selection.Character.Formation.HeroInstanceIds.ToArray();
            canvas.SetActive(false); arena.OpenBattle();
        }

        static int PortraitShape(HeroDefinition hero)
        {
            switch (hero.PortraitKey)
            {
                case "blades": return 2;
                case "bow": return 3;
                case "star": return 4;
                case "cross": return 5;
                default: return hero.Position == HeroPosition.Front ? 1 : hero.Position == HeroPosition.Middle ? 3 : 4;
            }
        }
        static Color PortraitColor(int index)
        {
            string[] palette = { "86C8E2", "E8AA79", "9ED3A5", "CEB383", "DCBA6E", "AEBCDD", "A2D2AA", "B7ABE2", "E692A3", "8BCBD6", "C7A3DD", "E5C67B", "C8B4E6", "F0CB8C", "99B9DB", "9BC5AA", "80C5C7", "B59BC9" };
            return Hex(palette[index % palette.Length]);
        }
        static Color RankColor(HeroData hero)
        {
            return Hex(hero.RankId == "green" ? "7BAA6A" : hero.RankId == "blue" ? "6F9FCE" : hero.RankId == "purple" ? "AF87C4" : "ADA88F");
        }

        static RectTransform Rect(Transform parent, string name, float x, float y, float w, float h)
        {
            var r = new GameObject(name, typeof(RectTransform)).GetComponent<RectTransform>(); r.SetParent(parent, false);
            r.anchorMin = r.anchorMax = r.pivot = new Vector2(0, 1); r.anchoredPosition = new Vector2(x, -y); r.sizeDelta = new Vector2(w, h); return r;
        }
        static FormationFrame Frame(Transform parent, string name, float x, float y, float w, float h, Color fill, Color edge, float bevel = 8)
        {
            var r = Rect(parent, name, x, y, w, h); var frame = r.gameObject.AddComponent<FormationFrame>();
            frame.Fill = fill; frame.Edge = edge; frame.Bevel = bevel; frame.raycastTarget = false; return frame;
        }
        static UnityEngine.UI.Button MakeButton(Transform parent, string name, float x, float y, float w, float h, Action action, Color fill, Color edge)
        {
            var frame = Frame(parent, name, x, y, w, h, fill, edge); frame.raycastTarget = true;
            var button = frame.gameObject.AddComponent<UnityEngine.UI.Button>(); button.targetGraphic = frame;
            var colors = button.colors; colors.highlightedColor = new Color(1.2f, 1.15f, 1.05f); colors.pressedColor = new Color(.7f, .7f, .7f); colors.disabledColor = new Color(.5f, .5f, .5f); button.colors = colors;
            button.onClick.AddListener(() => action()); return button;
        }
        void Icon(Transform parent, string name, float x, float y, float w, float h, int shape, Color color)
        {
            var icon = Rect(parent, name, x, y, w, h).gameObject.AddComponent<ArenaGraphic>(); icon.shape = shape; icon.color = color; icon.raycastTarget = false;
        }
        TextMeshProUGUI Label(Transform parent, string text, float x, float y, float w, float h, float size, Color color, TextAlignmentOptions alignment, bool bold = false)
        {
            var label = Rect(parent, "Text", x, y, w, h).gameObject.AddComponent<TextMeshProUGUI>();
            label.font = Font; label.text = text; label.fontSize = size; label.color = color; label.alignment = alignment;
            label.fontStyle = bold ? FontStyles.Bold : FontStyles.Normal; label.raycastTarget = false;
            label.textWrappingMode = TextWrappingModes.NoWrap; label.overflowMode = TextOverflowModes.Truncate; return label;
        }
        static void Clear(Transform parent)
        {
            foreach (Transform child in parent) { child.gameObject.SetActive(false); Destroy(child.gameObject); }
        }
        static Color Hex(string value) { ColorUtility.TryParseHtmlString("#" + value, out var color); return color; }
        void OnDestroy() { if (canvas != null) Destroy(canvas); }
    }
}
