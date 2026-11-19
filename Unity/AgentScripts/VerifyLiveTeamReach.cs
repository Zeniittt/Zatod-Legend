using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyLiveTeamReach
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var view=UnityEngine.Object.FindAnyObjectByType<CampaignView>();var connection=view.GetComponent<ArenaConnection>();var arena=view.GetComponent<ArenaView>();var formation=view.GetComponent<FormationView>();
        async Task Wait(Func<bool> predicate,string why,int seconds=25)
        {var end=DateTime.UtcNow.AddSeconds(seconds);while(!predicate() && DateTime.UtcNow<end)await Task.Delay(40);Check(predicate(),why+" / "+connection.Status);}
        connection.Connect();await Wait(()=>connection.Connected && connection.CampaignProgressReady,"Connection failed");
        view.Show();view.SelectStage("chapter_1_stage_1");view.ShowFormation();
        foreach(var hero in view.Character.HeroDesk)if(!formation.Selection.Contains(hero.HeroInstanceId))formation.ToggleHero(hero.HeroInstanceId);
        string old=connection.LastBattleId;
        UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>(FindObjectsInactive.Include).Single(b=>b.name=="FormationBattle").onClick.Invoke();
        await Wait(()=>arena.LiveMode && connection.LastBattleId!=old,"No live battle");
        Check(arena.HeroHudCount==5 && arena.Record.initial.Count(f=>f.team==0)==5,"Five-Hero party missing");
        Check(view.Character.HeroDesk.All(h=>h.RankId=="purple"),"Campaign UI still shows White Heroes");
        Check(arena.Record.loadouts.Where(l=>l.kind==CombatantKind.Hero).All(l=>l.hero.ConfigVersion.EndsWith("-team-reach-1-skill-reach-1") && l.hero.Skills.Count==4),"Server uses old Hero config or locked skills");
        foreach(var hero in arena.Record.initial.Where(f=>f.team==0))
        {
            Check(hero.x==-(2300+hero.slot*1400) && hero.y==(hero.slot%2==0?120:-140),"Formation was changed");
            var skills=arena.Record.loadouts.Single(l=>l.fighterId==hero.id).hero.Skills.Where(s=>!s.IsUltimate && s.Definition.Kind==Zatod.Heroes.SkillKind.Active).Select(s=>s.Definition.Name).ToArray();
            await Wait(()=>arena.Record.events.Any(e=>e.actorId==hero.id && e.kind==BattleEventKind.Action && skills.Any(name=>e.ability.StartsWith(name))),"Hero cast no automatic unlocked skill: "+hero.name,15);
        }
        await Wait(()=>!arena.LiveMode && !connection.Busy,"Battle did not finish",100);
        var record=arena.Record;var report=record.initial.Where(f=>f.team==0).Select(f=>new{hero=f.name,range=f.range,
            attackActions=record.events.Count(e=>e.actorId==f.id && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Attack),
            abilities=record.events.Where(e=>e.actorId==f.id && e.kind==BattleEventKind.Action).Select(e=>e.ability).Distinct().ToArray(),
            damageHits=record.events.Count(e=>e.actorId==f.id && e.kind==BattleEventKind.Damage),
            maxEnergy=record.events.Where(e=>e.hasState && e.state.id==f.id).Max(e=>e.state.energy)}).ToArray();
        Check(!Mirror.NetworkServer.active,"Client became a host");
        Check(record.events.First(e=>e.actorId==4 && e.kind==BattleEventKind.Action).state.animationState=="Skill3","Enchantx did not open with Skill3");
        Directory.CreateDirectory("../Artifacts/CampaignSkillAudit");File.WriteAllBytes("../Artifacts/CampaignSkillAudit/ui-live-five.arena.gz",ReplayArchive.Encode(record));
        File.WriteAllText("../Artifacts/CampaignSkillAudit/ui-live-five.json",Newtonsoft.Json.JsonConvert.SerializeObject(report,Newtonsoft.Json.Formatting.Indented));
        await Wait(()=>view.ResultVisible,"Result view missing");view.Show();view.SelectStage("chapter_1_stage_1");view.ShowFormation();
        return new{passed=true,checks,battle=record.battleId,winner=record.winner,heroes=report};
    }
}
