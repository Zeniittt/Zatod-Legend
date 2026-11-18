using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyLilinaRuntime
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        string owned=JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character),config=JsonUtility.ToJson(catalog.Data);
        Check(arena.GetComponent<FormationView>().Selection.Character.HeroDesk.Any(h=>h.HeroDefinitionId=="lilina"),"Lilina missing from roster");
        var window=EditorWindow.GetWindow<HeroCombatSandboxWindow>();window.CreateGUI();var root=window.rootVisualElement;
        var hero=root.Q<DropdownField>("sandbox-hero");hero.value=hero.choices.Single(c=>c.EndsWith("(lilina)"));
        root.Q<IntegerField>("sandbox-hp").value=100;root.Q<IntegerField>("sandbox-duration").value=15;root.Q<IntegerField>("sandbox-target-count").value=3;
        root.Q<IntegerField>("sandbox-target-hp").value=10000;root.Q<IntegerField>("sandbox-distance").value=1800;root.Q<IntegerField>("sandbox-spacing").value=220;
        root.Q<IntegerField>("sandbox-casts").value=1;
        for(int i=0;i<3;i++){var d=root.Q<DropdownField>("sandbox-monster-"+i);d.value=d.choices.Single(c=>c.EndsWith("(guardian)"));}
        ReplaySprite[] Sprites()=>UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Include);
        async Task Click(string id)
        {
            var previous=arena.Record?.battleId;var b=root.Q<Button>(id);Check(b!=null && b.enabledInHierarchy,"Missing/disabled "+id);
            using(var e=NavigationSubmitEvent.GetPooled()){e.target=b;b.SendEvent(e);}
            var until=DateTime.UtcNow.AddSeconds(10);while((arena.Record==null || arena.Record.battleId==previous)&&DateTime.UtcNow<until)await Task.Delay(25);
            Check(arena.Record!=null && arena.Record.battleId!=previous,"No new preview "+id);if(arena.Playing)arena.TogglePlayback();await Task.Delay(40);
        }
        void Drawn(ReplaySprite sprite,string label)
        {Canvas.ForceUpdateCanvases();var image=sprite.GetComponent<UnityEngine.UI.Image>();Check(sprite.gameObject.activeInHierarchy && image.enabled && image.sprite!=null && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount>=4,label);}
        void State(string state)
        {var sprite=Sprites().FirstOrDefault(s=>s.CurrentState==state && s.gameObject.activeInHierarchy);Check(sprite!=null,"Missing state "+state);Drawn(sprite,state);}
        await Click("sandbox-basic");Check(arena.GetComponent<CampaignView>()==null || !arena.GetComponent<CampaignView>().IsVisible,"Campaign covers Sandbox");var shot=arena.Record.projectiles.First(p=>p.actorId==1 && p.endTick>p.startTick+1);arena.Seek((shot.startTick+1)/20f);State("FireFlight");
        await Click("sandbox-cast-ultimate");var dragon=arena.Record;var start=dragon.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill("lilina_ultimate").Name);
        arena.Seek((start.tick+45)/20f);State("Ultimate");State("DragonBreath");
        Check(dragon.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Damage),"Dragon damage missing");
        await Click("sandbox-cast-skill_2");var bolt=arena.Record.projectiles.Single(p=>p.actorId==1);arena.Seek((bolt.startTick+1)/20f);State("BoltFlight");
        Check(arena.Record.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).Select(e=>e.targetId).Distinct().Count()>1,"Bolt did not pierce live enemies");
        await Click("sandbox-cast-skill_3");var twins=arena.Record.projectiles.Where(p=>p.actorId==1).ToArray();Check(twins.Length==2,"Twin projectile count");
        arena.Seek((twins.Max(p=>p.startTick)+1)/20f);State("TwinsFlight");
        Check(Sprites().Count(s=>s.name=="Projectile_1" && s.gameObject.activeInHierarchy)>=2,"Both orbs not visible");
        await Click("sandbox-cast-skill_4");var flame=arena.Record;var fireStart=flame.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill("lilina_skill4").Name);
        arena.Seek((fireStart.tick+16)/20f);State("Skill4");State("FlamerBreath");
        var burn=flame.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Damage && e.ability.EndsWith(" / Burn"));
        arena.Seek((burn.tick+1)/20f);State("BurnEmbers");Check(arena.Timeline.States[burn.targetId].burnUntil>burn.tick,"Burn state missing");
        var loaded=ReplayArchive.Decode(ReplayArchive.Encode(flame));var replay=new ReplayTimeline(loaded);replay.Seek(burn.tick);var snapshot=JsonUtility.ToJson(replay.States[burn.targetId]);
        replay.Seek(burn.tick+50);replay.Seek(burn.tick);Check(JsonUtility.ToJson(replay.States[burn.targetId])==snapshot,"Burn backward replay");
        Check(JsonUtility.ToJson(catalog.Data)==config && JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character)==owned,"Changed owned/config data");
        Check(!Mirror.NetworkClient.active && !Mirror.NetworkServer.active,"Sandbox started network host/client");
        Directory.CreateDirectory("../Artifacts/LilinaChecks");File.WriteAllBytes("../Artifacts/LilinaChecks/dragon.arena.gz",ReplayArchive.Encode(dragon));File.WriteAllBytes("../Artifacts/LilinaChecks/burn.arena.gz",ReplayArchive.Encode(flame));
        root.Q<IntegerField>("sandbox-duration").value=35;await Click("sandbox-test-all");
        foreach(string id in new[]{"ultimate","skill2","skill3","skill4"})Check(arena.Record.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill("lilina_"+id).Name),"Auto kit missing "+id);
        arena.Seek(2.3f);return new{passed=true,checks,hero="Lilina"};
    }
}
