using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Heroes;
using Zatod.Presentation;

public static class VerifyHeroRoster
{
    static int checks;
    static void Check(bool ok, string reason) { checks++; if (!ok) throw new Exception(reason); }
    static UnityEngine.UI.Button Button(string name)
    {
        var button = UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().SingleOrDefault(b => b.name == name);
        Check(button != null, "Missing active button: " + name); return button;
    }
    static void Click(string name)
    {
        var button = Button(name);
        ExecuteEvents.Execute(button.gameObject, new PointerEventData(EventSystem.current) { button = PointerEventData.InputButton.Left }, ExecuteEvents.pointerClickHandler);
    }
    static TextMeshProUGUI Text(string name) { return GameObject.Find(name).GetComponent<TextMeshProUGUI>(); }
    static Vector2 Center(RectTransform rect) { return RectTransformUtility.WorldToScreenPoint(null, rect.TransformPoint(rect.rect.center)); }

    public static async Task<object> Run()
    {
        checks = 0;
        var view = UnityEngine.Object.FindAnyObjectByType<HeroRosterView>();
        var formation = UnityEngine.Object.FindAnyObjectByType<FormationView>();
        var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        Check(view != null && view.Character != null && view.Detail != null, "Hero roster not initialized");
        view.Show(); view.SetFilter(null); await Task.Delay(100); Canvas.ForceUpdateCanvases();
        Check(view.IsVisible && !formation.IsVisible && !arena.IsVisible && !view.Detail.IsVisible, "Initial view visibility");
        Check(ReferenceEquals(view.Character, formation.Selection.Character) && ReferenceEquals(view.Catalog, formation.Selection.Catalog), "Roster uses a separate character/catalog");
        string before = HeroDataJson.WriteCharacter(view.Character, view.Catalog);
        Check(Text("GoldValue").text == view.PreviewGold.ToString("N0") && Text("DiamondValue").text == view.PreviewDiamonds.ToString("N0")
            && Text("StaminaValue").text == view.PreviewStamina + "/" + view.PreviewMaxStamina, "Currency placeholders");
        Check(view.VisibleHeroCount == view.Character.HeroDesk.Count, "All filter is incomplete");
        Check(!UnityEngine.Object.FindObjectsByType<TextMeshProUGUI>().Any(t => new[] { "STR", "INT", "AGI" }.Contains(t.text)), "Unrequested attribute filters");
        foreach (var hero in view.Character.HeroDesk)
        {
            var row = Button("HeroListRow-" + hero.HeroInstanceId);
            var portrait = row.transform.Find("RankPortrait").GetComponent<FormationFrame>();
            Check(portrait.Edge == HeroUi.RankColor(hero), "Portrait rank frame mismatch");
            Check(row.transform.Find("HeroRowName").GetComponent<TextMeshProUGUI>().text == view.Catalog.Hero(hero.HeroDefinitionId).Name, "Row name mismatch");
            var gear = row.transform.Find("RequiredGear");
            Check(gear.childCount == 6, "Row must contain six requirement cells");
            var rank = HeroProgression.CurrentRank(hero, view.Catalog);
            for (int i = 0; i < 6; i++)
            {
                if (i < rank.EquipmentSlots.Count) Check(gear.GetChild(i).name.EndsWith("-" + rank.EquipmentSlots[i].RequiredItemId), "Wrong rank equipment requirement");
                else Check(gear.GetChild(i).childCount == 0, "Terminal rank invents equipment requirements");
            }
        }
        for (int i = 1; i <= 3; i++)
        {
            Click("HeroListFilter-" + i);
            Check(view.Filter == (HeroPosition)(i - 1) && view.VisibleHeroCount == view.Character.HeroDesk.Count(h => view.Catalog.Hero(h.HeroDefinitionId).Position == (HeroPosition)(i - 1)), "Position filter mismatch");
        }
        Click("HeroListFilter-0"); await Task.Delay(100); Canvas.ForceUpdateCanvases();
        var scroll = view.RosterScroll;
        Check(scroll.content.rect.height > scroll.viewport.rect.height, "Hero list cannot scroll");
        scroll.OnScroll(new PointerEventData(EventSystem.current) { scrollDelta = new Vector2(0, -4) });
        await Task.Delay(80); Check(scroll.content.anchoredPosition.y > 0, "Hero list wheel event ignored");
        scroll.verticalNormalizedPosition = 0; Canvas.ForceUpdateCanvases();
        var lastHero = view.Character.HeroDesk.Last(); var last = Button("HeroListRow-" + lastHero.HeroInstanceId);
        Check(RectTransformUtility.RectangleContainsScreenPoint(scroll.viewport, Center((RectTransform)last.transform)), "Last roster row unreachable");
        var hits = new List<RaycastResult>();
        EventSystem.current.RaycastAll(new PointerEventData(EventSystem.current) { position = Center((RectTransform)last.transform) }, hits);
        Check(hits.Count > 0 && hits[0].gameObject.GetComponentInParent<UnityEngine.UI.Button>() == last, "Hero row is blocked by another raycast target");
        float savedScroll = scroll.verticalNormalizedPosition;
        Click(last.name); await Task.Delay(100); Canvas.ForceUpdateCanvases();
        Check(view.Detail.IsVisible && !view.IsVisible && view.Detail.Hero == lastHero, "Click did not open matching owned Hero");
        Check(Text("HeroLevel").text == "Level " + lastHero.Level && Text("HeroExp").text == "EXP   " + lastHero.Exp.ToString("N0"), "Level/EXP not bound to HeroData");
        Check(Text("HeroSouls").text == "Soul   0", "Default soul count should be zero");
        Check(Text("HeroPower").text == "POWER   " + view.PreviewPower.ToString("N0"), "Power placeholder");
        Check(view.Detail.UpgradeReserved.childCount == 0, "Equipment/quick equip/model area must stay empty");
        Check(Button("HeroDetailTab-Base").interactable, "Base tab disabled");
        foreach (string tab in new[] { "Skill", "Skin", "Awaken" }) Check(!Button("HeroDetailTab-" + tab).interactable, "Deferred tab is active");
        foreach (var stat in HeroStatCalculator.Calculate(lastHero, view.Catalog).Stats)
        {
            var row = GameObject.Find("HeroStat-" + stat.StatId);
            Check(row != null, "Missing calculated stat: " + stat.StatId);
            string expected = stat.StatId == "attack_interval" ? (stat.Value / 20f).ToString("0.##", System.Globalization.CultureInfo.InvariantCulture) + " s" : stat.Value.ToString("N0");
            Check(row.transform.Find("StatValue").GetComponent<TextMeshProUGUI>().text == expected, "Wrong calculated stat value");
        }
        var statsScroll = view.Detail.StatsScroll;
        Check(statsScroll.content.rect.height > statsScroll.viewport.rect.height, "Stats list cannot scroll");
        statsScroll.OnScroll(new PointerEventData(EventSystem.current) { scrollDelta = new Vector2(0, -3) });
        await Task.Delay(80); Check(statsScroll.content.anchoredPosition.y > 0, "Stats wheel ignored");
        Click("CloseHeroDetail"); await Task.Delay(80);
        Check(view.IsVisible && !view.Detail.IsVisible && Mathf.Abs(scroll.verticalNormalizedPosition - savedScroll) < .01f, "Close lost roster scroll");
        Check(HeroDataJson.WriteCharacter(view.Character, view.Catalog) == before, "Read-only roster/detail mutated Hero progress or currencies");

        var heroToTest = view.Character.HeroDesk[1]; int level = heroToTest.Level, stars = heroToTest.Stars; long exp = heroToTest.Exp;
        try
        {
            heroToTest.Level = 17; heroToTest.Exp = 123; heroToTest.Stars = 3;
            view.SoulCountProvider = h => h.HeroInstanceId == heroToTest.HeroInstanceId ? 42 : 0;
            view.OpenDetail(heroToTest.HeroInstanceId); await Task.Delay(80);
            Check(Text("HeroLevel").text == "Level 17" && Text("HeroExp").text == "EXP   123" && Text("HeroSouls").text == "Soul   42", "Detail cached another Hero's progress");
            var starRoot = GameObject.Find("HeroStars").transform;
            Check(starRoot.Cast<Transform>().Count(s => s.GetComponent<HeroHudGlyph>().color == HeroUi.Gold) == 3, "Stars not bound to owned progress");
        }
        finally { heroToTest.Level = level; heroToTest.Exp = exp; heroToTest.Stars = stars; view.SoulCountProvider = null; view.CloseDetail(); }
        Click("HeroRosterBack"); Check(formation.IsVisible && !view.IsVisible, "Roster back did not open formation");
        Click("OpenHeroRoster"); Check(view.IsVisible && !formation.IsVisible, "Formation HEROES navigation");
        Check(UnityEngine.Object.FindObjectsByType<EventSystem>().Length == 1, "Duplicate EventSystem");
        Check(!Mirror.NetworkServer.active, "UI started a player host");
        view.SetFilter(null); await Task.Delay(80); Canvas.ForceUpdateCanvases();
        return new { passed = true, checks, heroes = view.VisibleHeroCount, stats = view.Catalog.Data.Stats.Count };
    }
}
