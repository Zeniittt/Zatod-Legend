using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.UIElements;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Presentation;

public static class VerifyKavernRuntime
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var window=EditorWindow.GetWindow<HeroCombatSandboxWindow>();
        var root=window.rootVisualElement;var heroes=root.Q<DropdownField>("sandbox-hero");
        heroes.value=heroes.choices.Single(c=>c.EndsWith("(kavern)"));
        Check(root.Q<IntegerField>("sandbox-distance").value==600,"Ranged test distance not selected");
        root.Q<IntegerField>("sandbox-target-count").value=3;
        root.Q<IntegerField>("sandbox-casts").value=1;
        root.Q<IntegerField>("sandbox-casts").value=1;
        var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        string owned=JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character);
        async Task Cast(string slot)
        {
            string previous=arena.Record?.battleId;
            var button=root.Q<UnityEngine.UIElements.Button>("sandbox-cast-"+slot);
            Check(button!=null && button.enabledInHierarchy,"Skill button missing/locked: "+slot);
            using(var e=NavigationSubmitEvent.GetPooled()){e.target=button;button.SendEvent(e);}
            var until=DateTime.UtcNow.AddSeconds(10);
            while((arena.Record==null || arena.Record.battleId==previous) && DateTime.UtcNow<until)await Task.Delay(30);
            Check(arena.Record!=null && arena.Record.battleId!=previous && arena.Record.initial[0].heroDefinitionId=="kavern","Button did not load Kavern: "+slot);
            if(arena.Playing)arena.TogglePlayback();await Task.Delay(50);
        }
        ReplaySprite[] Visuals(){return UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Include);}
        foreach(string slot in new[]{"ultimate","skill_2","skill_4","skill_3"})
        {
            await Cast(slot);var r=arena.Record;
            var effect=r.visualEffects.First(v=>v.targetId!=0 || v.stretchToRange);
            float time=(effect.startTick+2)/(float)r.tickRate;
            arena.Seek(time);Canvas.ForceUpdateCanvases();await Task.Delay(60);
            var visible=Visuals().Where(v=>v.gameObject.activeInHierarchy && v.name.StartsWith("FX_"+effect.state+"_")).ToArray();
            Check(visible.Length==(slot=="skill_3"?2:1),"Wrong active effect count: "+slot);
            foreach(var visual in visible)
            {
                var image=visual.GetComponent<UnityEngine.UI.Image>();
                Check(image.enabled && image.sprite!=null && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount>=4,"Effect has no drawn geometry: "+slot);
                float sample=visual.SampleSeconds;await Task.Delay(50);
                Check(visual.SampleSeconds==sample,"Paused effect advanced");
            }
            if(slot=="skill_3")foreach(var fx in r.visualEffects)
            {
                var visual=visible.Single(v=>v.name.StartsWith("FX_"+fx.state+"_"+fx.targetId+"_"));
                var target=GameObject.Find("Fighter_"+fx.targetId).GetComponent<RectTransform>();
                var rect=visual.GetComponent<RectTransform>();
                Check(Mathf.Abs(rect.position.x-target.position.x)<.01f,"ArrowShower not at target X");
                // Fighter root is 20 canvas units above its shared foot plane.
                Check(Mathf.Abs((rect.anchoredPosition.y-target.anchoredPosition.y)+20)<.01f,"ArrowShower not at target foot plane");
            }
            arena.Seek((effect.startTick-1)/(float)r.tickRate);
            Check(visible.All(v=>!v.gameObject.activeSelf),"Effect visible before start");
            arena.Seek((effect.endTick+1)/(float)r.tickRate);
            Check(visible.All(v=>!v.gameObject.activeSelf),"Effect did not expire");
            arena.Seek(time);Check(visible.All(v=>v.gameObject.activeSelf),"Backward seek did not restore effect");
            if(slot=="skill_2" || slot=="skill_4")
            {
                var p=r.projectiles.Single();var flight=Visuals().Single(v=>v.name=="Projectile_1");
                arena.Seek((p.startTick+1)/(float)r.tickRate);
                Check(flight.gameObject.activeSelf && flight.CurrentState==p.flightState,"Flight phase missing");
                arena.Seek(p.endTick/(float)r.tickRate);
                Check(!flight.gameObject.activeSelf,"Flight continued after impact");
                if(slot=="skill_4")
                {
                    var body=Visuals().Single(v=>v.transform.parent.name=="Fighter_1");
                    arena.Seek((p.startTick-1)/(float)r.tickRate);
                    Check(body.CurrentState=="Skill4" && body.PresentationHeight==156,"Air attack body height missing");
                }
            }
        }
        Check(!Mirror.NetworkClient.active && !Mirror.NetworkServer.active,"Sandbox created network host/client");
        Check(JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character)==owned,"Sandbox mutated owned HeroDesk");
        arena.Seek(2.2f);
        return new{passed=true,checks,hero="Kavern",pausedAt=arena.Playhead,arrowShowers=arena.Record.visualEffects.Count};
    }
}
