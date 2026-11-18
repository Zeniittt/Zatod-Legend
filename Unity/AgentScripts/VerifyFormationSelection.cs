using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyFormationSelection
{
    static int checks;
    static void Check(bool condition, string message) { checks++; if (!condition) throw new Exception(message); }
    static UnityEngine.UI.Button Button(string name)
    {
        var result = UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().SingleOrDefault(b => b.name == name);
        Check(result != null, "Missing active button: " + name); return result;
    }
    static void Click(string name)
    {
        var button = Button(name);
        var evt = new PointerEventData(EventSystem.current) { button = PointerEventData.InputButton.Left };
        ExecuteEvents.Execute(button.gameObject, evt, ExecuteEvents.pointerClickHandler);
    }
    static async Task Wait(Func<bool> condition)
    {
        DateTime deadline = DateTime.UtcNow.AddSeconds(20);
        while (!condition()) { if (DateTime.UtcNow > deadline) throw new Exception("Formation UI wait timed out"); await Task.Delay(50); }
    }
    static Vector2 Center(RectTransform rect) { return RectTransformUtility.WorldToScreenPoint(null, rect.TransformPoint(rect.rect.center)); }

    public static async Task<object> Run()
    {
        checks = 0;
        var view = UnityEngine.Object.FindAnyObjectByType<FormationView>();
        var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        var connection = UnityEngine.Object.FindAnyObjectByType<ArenaConnection>();
        Check(view != null && view.Selection != null, "Formation not initialized");
        Check(!Mirror.NetworkServer.active, "Player unexpectedly hosts a server");
        view.Show();
        foreach (var hero in view.Selection.Selected.ToArray()) view.ToggleHero(hero.HeroInstanceId);
        Click("PositionFilter-0");
        Check(view.IsVisible && !arena.IsVisible, "Formation/Arena visibility");
        Check(view.Selection.Character.HeroDesk.Count >= 18 && view.VisibleHeroCount == view.Selection.Character.HeroDesk.Count, "All roster tab incomplete");
        Check(view.Tabs.Count == 1 && view.ActiveTab == "owned", "Unexpected extra tabs");
        Check(!Button("FormationBack").interactable, "Back should be deferred");
        Check(!Button("FormationBattle").interactable, "Empty formation Battle is enabled");
        Click("FormationBattle"); Check(view.IsVisible, "Empty formation opened battle");
        Check(GameObject.Find("RecommendationsReserved").transform.childCount == 0 && GameObject.Find("DetailsReserved").transform.childCount == 0, "Reserved panels contain content");
        Check(!UnityEngine.Object.FindObjectsByType<TextMeshProUGUI>().Any(t => new[] { "STR", "INT", "AGI", "Preset" }.Contains(t.text)), "Unrequested filters/preset");
        Check(UnityEngine.Object.FindObjectsByType<EventSystem>().Length == 1, "EventSystem duplicated");
        Check(GameObject.Find("FormationCanvas").GetComponent<UnityEngine.UI.GraphicRaycaster>() != null, "Missing raycaster");
        for (int i = 1; i <= 3; i++)
        {
            Click("PositionFilter-" + i);
            var position = (HeroPosition)(i - 1);
            Check(view.Filter == position && view.VisibleHeroCount == view.Selection.Filter(position).Count(), "Position filter did not match HeroDesk");
            Check(view.VisibleHeroCount > 0, "Position filter is empty");
        }
        Click("PositionFilter-0"); Canvas.ForceUpdateCanvases();
        var scroll = view.RosterScroll;
        Check(scroll.content.rect.height > scroll.viewport.rect.height, "Roster cannot scroll");
        scroll.OnScroll(new PointerEventData(EventSystem.current) { scrollDelta = new Vector2(0, -3) });
        await Task.Delay(100); Canvas.ForceUpdateCanvases();
        Check(scroll.content.anchoredPosition.y > 0, "Mouse-wheel scroll did not move content");
        scroll.verticalNormalizedPosition = 0; Canvas.ForceUpdateCanvases();
        string lastId = view.Selection.Character.HeroDesk.Last().HeroInstanceId;
        var last = Button("HeroCard-" + lastId);
        Check(RectTransformUtility.RectangleContainsScreenPoint(scroll.viewport, Center((RectTransform)last.transform)), "Last row cannot be reached");
        Click("PositionFilter-0");
        // Newly created Graphics receive their canvas depth on the next render frame.
        await Task.Delay(100); Canvas.ForceUpdateCanvases();
        var firstHero = view.Selection.Character.HeroDesk[0];
        var first = Button("HeroCard-" + firstHero.HeroInstanceId);
        var pointer = new PointerEventData(EventSystem.current) { position = Center((RectTransform)first.transform) };
        var hits = new List<RaycastResult>(); EventSystem.current.RaycastAll(pointer, hits);
        Check(hits.Count > 0 && hits[0].gameObject.GetComponentInParent<UnityEngine.UI.Button>() == first, "Hero card is blocked by another raycast target");
        Click(first.name);
        Check(view.Selection.Selected.Count == 1 && Button("FormationBattle").interactable, "Card selection/battle state");
        Check(GameObject.Find(first.name + "/SelectionBadge") != null, "Selected card mark missing");
        Click("SelectedSlot-0"); Check(view.Selection.Selected.Count == 0, "Selected slot did not remove hero");
        foreach (var hero in view.Selection.Character.HeroDesk.Take(5)) Click("HeroCard-" + hero.HeroInstanceId);
        Check(view.Selection.Selected.Count == 5, "Five selected slots not filled");
        Click("HeroCard-" + view.Selection.Character.HeroDesk[5].HeroInstanceId);
        Check(view.Selection.Selected.Count == 5, "Sixth hero accepted");
        Click("PositionFilter-3"); Check(view.Selection.Selected.Count == 5, "Filtering lost formation");
        Click("RosterTab-owned"); Check(view.Selection.Selected.Count == 5, "Tab switch lost formation");
        Click("PositionFilter-0");
        var saved = HeroDataJson.WriteCharacter(view.Selection.Character, view.Selection.Catalog);
        var loaded = HeroDataJson.ReadCharacter(saved, view.Selection.Catalog);
        Check(loaded.Formation.HeroInstanceIds.SequenceEqual(view.Selection.Character.Formation.HeroInstanceIds), "Formation IDs did not survive save/load");
        string previousBattle = arena.Record == null ? null : arena.Record.battleId;
        bool requested = false;
        Action<HeroFormationData> requestedHandler = data => { requested = data.HeroInstanceIds.SequenceEqual(view.Selection.Character.Formation.HeroInstanceIds); };
        view.BattleRequested += requestedHandler;
        Click("FormationBattle");
        Check(!view.IsVisible && arena.IsVisible && requested, "Battle did not open current Arena with selected IDs");
        await Wait(() => arena.Record != null && arena.Record.battleId != previousBattle && !connection.Busy);
        Check(connection.Connected && !Mirror.NetworkServer.active && arena.Record.initial.Count == 10, "Dedicated Arena transition failed");
        Check(arena.Record.rulesVersion == Zatod.Combat.BattleRecord.CurrentRules, "Old server rules");
        string battleId = arena.Record.battleId;
        view.BattleRequested -= requestedHandler; Click("SQUAD");
        await Task.Delay(100); Canvas.ForceUpdateCanvases();
        Check(view.Selection.Selected.Count == 5 && !arena.Playing, "Returning to formation lost selection/did not pause replay");
        foreach (var frame in UnityEngine.Object.FindObjectsByType<FormationFrame>())
            Check(frame.canvasRenderer.GetMesh() != null && frame.canvasRenderer.GetMesh().vertexCount > 0, "Formation frame mesh missing");
        return new { passed = true, checks, battleId, selected = view.Selection.Character.Formation.HeroInstanceIds, heroes = view.VisibleHeroCount };
    }
}
