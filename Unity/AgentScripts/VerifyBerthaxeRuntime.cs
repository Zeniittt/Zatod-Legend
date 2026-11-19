using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyBerthaxeRuntime
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();var formation=arena.GetComponent<FormationView>();
        string owned=JsonUtility.ToJson(formation.Selection.Character),config=JsonUtility.ToJson(catalog.Data);
        Check(formation.Selection.Character.HeroDesk.Any(h=>h.HeroDefinitionId=="berthaxe"),"Hero list missing Berthaxe");
        Check(arena.GetComponent<CampaignView>().Character.HeroDesk.Single(h=>h.HeroDefinitionId=="berthaxe").RankId=="purple","Campaign demo rank missing");
        var window=EditorWindow.GetWindow<HeroCombatSandboxWindow>();window.CreateGUI();var root=window.rootVisualElement;
        var choice=root.Q<DropdownField>("sandbox-hero");choice.value=choice.choices.Single(c=>c.EndsWith("(berthaxe)"));
        var rank=root.Q<DropdownField>("sandbox-rank");rank.value=rank.choices.Single(c=>c.EndsWith("(purple)"));
        root.Q<IntegerField>("sandbox-hp").value=100;root.Q<IntegerField>("sandbox-duration").value=15;root.Q<IntegerField>("sandbox-target-count").value=5;
        root.Q<IntegerField>("sandbox-target-hp").value=100000;root.Q<IntegerField>("sandbox-distance").value=1800;root.Q<IntegerField>("sandbox-spacing").value=500;
        root.Q<IntegerField>("sandbox-casts").value=1;
        for(int i=0;i<5;i++){var d=root.Q<DropdownField>("sandbox-monster-"+i);d.value=d.choices.Single(c=>c.EndsWith("(guardian)"));}
        ReplaySprite[] Sprites()=>UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Exclude);
        async Task Click(string id)
        {
            string previous=arena.Record?.battleId;var button=root.Q<Button>(id);Check(button!=null && button.enabledInHierarchy,"Missing button "+id);
            using(var e=NavigationSubmitEvent.GetPooled()){e.target=button;button.SendEvent(e);}
            var until=DateTime.UtcNow.AddSeconds(10);while((arena.Record==null || arena.Record.battleId==previous) && DateTime.UtcNow<until)await Task.Delay(30);
            Check(arena.Record!=null && arena.Record.battleId!=previous,"No preview "+id);if(arena.Playing)arena.TogglePlayback();await Task.Delay(60);
        }
        ReplaySprite Drawn(string state)
        {
            var visual=Sprites().FirstOrDefault(s=>s.CurrentState==state);Check(visual!=null,"Missing visible "+state);Canvas.ForceUpdateCanvases();
            var image=visual.GetComponent<UnityEngine.UI.Image>();Check(image.enabled && image.sprite!=null && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount>=4,"Undrawn "+state);return visual;
        }
        await Click("sandbox-basic");arena.Seek(1.1f);Drawn("NormalAttack");Check(!arena.GetComponent<CampaignView>().IsVisible,"Campaign covers Sandbox");
        Check(arena.Record.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).Select(e=>e.targetId).Distinct().Count()==1,"Normal attack splashed");
        await Click("sandbox-cast-ultimate");var earth=arena.Record;var first=earth.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Damage);
        arena.Seek(first.tick/20f);Drawn("Ultimate");Drawn("EarthEruption");Check(earth.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).Select(e=>e.targetId).Distinct().Count()==5,"Ultimate missed a depth row");
        await Click("sandbox-cast-skill_2");var spin=arena.Record;arena.Seek(2.35f);var body=Drawn("Skill2");var sprite=body.GetComponent<UnityEngine.UI.Image>().sprite;
        arena.Seek(3.7f);Drawn("Skill2");arena.Seek(2.35f);Check(body.GetComponent<UnityEngine.UI.Image>().sprite==sprite,"Spin seek changed source frame");
        await Click("sandbox-cast-skill_3");arena.Seek(1.05f);Drawn("Skill3");Check(arena.Timeline.States[1].presentationHeight>0,"No airborne presentation");
        var land=arena.Record.events.First(e=>e.actorId==1 && e.kind==BattleEventKind.Damage);arena.Seek((land.tick+2)/20f);Drawn("EarthExplosion");Drawn("EarthEruption");
        await Click("sandbox-cast-skill_4");var shock=arena.Record.projectiles.First(p=>p.actorId==1);arena.Seek((shock.startTick+2)/20f);Drawn("ShockWave");
        Check(arena.Record.events.Where(e=>e.actorId==1 && e.kind==BattleEventKind.Damage).Select(e=>e.targetId).Distinct().Count()>1,"Shock wave did not pierce");
        root.Q<IntegerField>("sandbox-duration").value=45;await Click("sandbox-test-all");
        foreach(string slot in new[]{"ultimate","skill2","skill3","skill4"})Check(arena.Record.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability==catalog.Skill("berthaxe_"+slot).Name),"Auto kit missing "+slot);
        Check(JsonUtility.ToJson(catalog.Data)==config && JsonUtility.ToJson(formation.Selection.Character)==owned,"Changed owned/config data");
        Check(!Mirror.NetworkClient.active && !Mirror.NetworkServer.active,"Sandbox started networking");
        Directory.CreateDirectory("../Artifacts/BerthaxeChecks");File.WriteAllBytes("../Artifacts/BerthaxeChecks/ui-auto.arena.gz",ReplayArchive.Encode(arena.Record));
        arena.Seek(2f);return new{passed=true,checks,hero="Berthaxe",spriteMeshes=true,skillButtons=true};
    }
}
