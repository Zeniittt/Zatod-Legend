using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using Zatod.Networking;
using Zatod.Presentation;

public static class PreviewFormationLayout
{
    public static async Task<object> Run()
    {
        var view=UnityEngine.Object.FindAnyObjectByType<CampaignView>();var connection=view.GetComponent<ArenaConnection>();var formation=view.GetComponent<FormationView>();var arena=view.GetComponent<ArenaView>();
        var end=DateTime.UtcNow.AddSeconds(25);connection.Connect();
        while((!connection.Connected || !connection.CampaignProgressReady) && DateTime.UtcNow<end)await Task.Delay(40);
        if(!connection.Connected || connection.Busy)throw new Exception(connection.Status);
        view.Show();view.SelectStage("chapter_1_stage_1");view.ShowFormation();
        foreach(var hero in view.Character.HeroDesk)if(!formation.Selection.Contains(hero.HeroInstanceId))formation.ToggleHero(hero.HeroInstanceId);
        string old=connection.LastBattleId;
        UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>(FindObjectsInactive.Include).Single(b=>b.name=="FormationBattle").onClick.Invoke();
        while((connection.LastBattleId==old || connection.Busy || !arena.IsVisible) && DateTime.UtcNow<end)await Task.Delay(40);
        if(connection.LastBattleId==old || arena.Record.rulesVersion!=Zatod.Combat.BattleRecord.CurrentRules || arena.Record.formationLayoutVersion!=Zatod.Combat.BattleFormationLayout.Version || Mirror.NetworkServer.active)
            throw new Exception("Preview received old rules or incorrect authority: "+connection.Status);
        if(arena.Playing)arena.TogglePlayback();arena.Seek(2.1f);await Task.Delay(60);Canvas.ForceUpdateCanvases();
        if(UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Exclude).Count(s=>s.name=="HeroSprite")!=10)throw new Exception("Missing fighter sprites");
        return new{passed=true,battle=connection.LastBattleId,rules=arena.Record.rulesVersion,server=connection.Port,pausedAt=arena.Playhead,heroes=5,monsters=5};
    }
}
