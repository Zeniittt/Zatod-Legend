// Product presentation checks against the complete native catalog in Play Mode.
using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

public static class D34NativeVisuals
{
    const BindingFlags Private=BindingFlags.Instance|BindingFlags.NonPublic;
    public static object ShaderGallery(string output)
    {
        if(EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new InvalidOperationException("Use isolated Edit Mode.");
        var scene=UnityEditor.SceneManagement.EditorSceneManager.NewPreviewScene();
        var target=new RenderTexture(1600,1000,24);var pixels=new Texture2D(1600,1000,TextureFormat.RGB24,false);var previous=RenderTexture.active;
        try
        {
            var cameraRoot=new GameObject("Native shader gallery",typeof(Camera));UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(cameraRoot,scene);
            var camera=cameraRoot.GetComponent<Camera>();camera.scene=scene;camera.cameraType=CameraType.Preview;camera.orthographic=true;camera.orthographicSize=5.3f;camera.transform.position=new Vector3(0,0,-10);camera.clearFlags=CameraClearFlags.SolidColor;camera.backgroundColor=new Color(.10f,.13f,.18f);camera.targetTexture=target;
            int index=0;
            foreach(ZatodBuffShader shader in Enum.GetValues(typeof(ZatodBuffShader)))
            {
                float x=(index%4-1.5f)*4,y=(1-index/4)*3.3f;
                var go=new GameObject(shader.ToString());UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(go,scene);var sprite=go.AddComponent<ZatodBattleSprite>();sprite.Initialize(HeroDataJson.LoadBundledCatalog().Hero("coco").AnimationSetResource);sprite.Sample("Idle",.25f,true,1);
                var size=sprite.Renderer.bounds.size;float scale=2.4f/Mathf.Max(size.x,size.y);sprite.Sample("Idle",.25f,true,scale);
                go.transform.position=new Vector3(x,y,0);var bounds=sprite.Renderer.bounds;go.transform.position+=new Vector3(x-bounds.center.x,y-bounds.center.y+.3f,0);
                if(shader!=ZatodBuffShader.None)sprite.Renderer.sharedMaterial=Resources.Load<Material>("Zatod/World/ZatodBuffSprite");
                var props=new MaterialPropertyBlock();props.SetFloat("_NativeBuff",(int)shader);sprite.Renderer.SetPropertyBlock(props);
                var label=new GameObject("Name",typeof(TextMesh));UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(label,scene);label.transform.position=new Vector3(x,y-1.15f,-.5f);var text=label.GetComponent<TextMesh>();text.text=((int)shader)+" "+shader;text.fontSize=40;text.characterSize=.095f;text.anchor=TextAnchor.MiddleCenter;text.color=Color.white;index++;
            }
            camera.Render();RenderTexture.active=target;pixels.ReadPixels(new Rect(0,0,1600,1000),0,0);pixels.Apply();File.WriteAllBytes(output,pixels.EncodeToPNG());return new{Path=output,Shaders=11};
        }
        finally{RenderTexture.active=previous;UnityEditor.SceneManagement.EditorSceneManager.ClosePreviewScene(scene);UnityEngine.Object.DestroyImmediate(target);UnityEngine.Object.DestroyImmediate(pixels);}
    }
    public static async Task<object> Run(string report)
    {
        if(!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new InvalidOperationException("Use isolated Play Mode.");
        int checks=0;void Check(bool value,string why){checks++;if(!value)throw new InvalidDataException(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();
        var match=ZatodMatchFactory.Versus(catalog,catalog.FreePvp.Team(new[]{"kotl"}),catalog.FreePvp.Team(new[]{"cm"}),117,"native-visuals",false);
        var sim=new ZatodBattleSimulation(match);var frame=sim.Frame();var unit=frame.Units.First();
        var host=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
        typeof(ZatodPrototypeView).GetMethod("LoadReplay",Private).Invoke(host,new object[]{sim.Replay()});
        typeof(ZatodPrototypeView).GetMethod("SetReplayPlaying",Private).Invoke(host,new object[]{false});
        var scene=host.GetComponent<ZatodBattleSceneController>();
        double limit=EditorApplication.timeSinceStartup+8;
        while(scene.Phase!=ZatodScenePhase.InBattle && EditorApplication.timeSinceStartup<limit)await Task.Delay(30);
        Check(scene.Phase==ZatodScenePhase.InBattle,"Native visual replay scene did not open");
        var root=new GameObject("Native presentation verification");
        var stage=root.AddComponent<ZatodBattleStage>();
        try
        {
            void Draw(double interpolation=0)=>stage.Draw(frame,sim,interpolation,0,false,false);
            Draw();
            ZatodBattleSprite Actor()=>stage.transform.Find("Hero_"+unit.EntityId).GetComponent<ZatodBattleSprite>();
            var props=new MaterialPropertyBlock();
            foreach(ZatodBuffShader shader in Enum.GetValues(typeof(ZatodBuffShader)))
            {
                unit.Shader=shader;Draw();var renderer=Actor().Renderer;renderer.GetPropertyBlock(props);
                Check(renderer.enabled && renderer.sprite!=null,"Shader lost actor sprite: "+shader);
                Check(renderer.sharedMaterial!=null && renderer.sharedMaterial.shader.isSupported,"Unsupported native material: "+shader);
                Check(props.GetFloat("_NativeBuff")== (int)shader,"Incorrect per-actor shader: "+shader);
            }
            unit.Shader=ZatodBuffShader.Frozen;unit.Icebound=true;unit.Action="Move";unit.FrozenAction="Idle";unit.FrozenActionElapsed=.25;
            Draw();var frozen=Actor().Renderer.sprite;Draw(.1);
            Check(Actor().CurrentState=="Idle" && Actor().Renderer.sprite==frozen,"Frozen pose advanced between ticks");
            unit.Icebound=false;unit.Shader=ZatodBuffShader.None;unit.Action="Idle";
            var forms=catalog.Data.Skills.SelectMany(s=>(s.Crystal.NativeForm?.Enabled==true?new[]{s.Crystal.NativeForm}:Array.Empty<ZatodBattleFormDefinition>()).Concat(s.Crystal.Summon?.Forms??new System.Collections.Generic.List<ZatodBattleFormDefinition>())).GroupBy(f=>f.Resource).Select(g=>g.First()).ToArray();
            string normal=unit.AnimationSetResource;
            foreach(var form in forms)
            {
                var old=Actor().Renderer;unit.AnimationSetResource=form.AnimationSetResource;Draw();
                Check(Actor().Resource==form.AnimationSetResource && Actor().Renderer.sprite!=null,"Form sprite missing: "+form.Resource);
                Check(old!=Actor().Renderer && !old.enabled,"Form left the old renderer active");
            }
            unit.AnimationSetResource=normal;Draw();
            Check(Actor().Resource==normal && Actor().Renderer.sharedMaterial.name.Contains("ZatodWorldSprite"),"Form exit did not restore the ordinary renderer");
            int id=6000;
            foreach(var pair in new[]{("eff_point_DOOM_ult.cha",ZatodBuffEffectLayer.BehindBattlefieldActors,-9000),("eff_point_Luna_night.cha",ZatodBuffEffectLayer.WorldActors,1000),("eff_point_Luna_moon.cha",ZatodBuffEffectLayer.AboveBattlefield,19000)})
            {
                frame.Visuals.Clear();frame.Visuals.Add(new ZatodVisualState{Id=++id,Resource=pair.Item1,Kind="effect",Layer=pair.Item2,Scale=1,Elapsed=.125});Draw();
                var fx=stage.transform.Find("Effect_"+id).GetComponent<ZatodBattleSprite>();
                Check(fx.Renderer.sprite!=null && fx.Renderer.sortingOrder==pair.Item3,"Incorrect scene-effect layer: "+pair.Item1);
            }
            frame.Visuals.Clear();
            unit.Hp=0;unit.Action="Death";unit.DeathElapsed=0;unit.ActionElapsed=0;Draw();
            Check(Actor().Renderer.color.a==1,"Corpse vanished before its hold");
            unit.DeathElapsed=unit.ActionElapsed=20;Draw();
            Check(Actor().Renderer.color.a==0,"Corpse did not finish fading");
            unit.Hp=unit.MaxHp*.1;unit.Action="Idle";unit.ActionElapsed=0;unit.DeathElapsed=0;frame.Tick=40;
            var hud=(ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud",Private).GetValue(host);
            var drawHud=typeof(ZatodPrototypeView).GetMethod("DrawHud",Private);
            void Hud()=>drawHud.Invoke(host,new object[]{frame,sim,0d});
            unit.Energy=unit.MaxEnergy;unit.CanActivateUltimate=true;unit.UltimateReadySinceTick=36;unit.FullEnergySinceTick=35;Hud();
            var card=hud.Cards[0];
            Check(card.ReadyCue.GetComponent<Image>().enabled && card.FullEnergyCue.GetComponent<Image>().enabled && card.LowHealth.gameObject.activeSelf,"Ready/full-energy/low-HP feedback missing");
            var ready=card.ReadyCue.GetComponent<Image>().sprite;Hud();
            Check(card.ReadyCue.GetComponent<Image>().sprite==ready,"Paused ready cue changed at an identical snapshot");
            unit.Action="ult";Hud();
            Check(card.TriggerCue.GetComponent<Image>().enabled && !card.ReadyCue.GetComponent<Image>().enabled,"KOTL channel did not show its activation cue / source="+unit.SourceId+" / cast="+unit.UltimateCastTick+" / ready="+card.ReadyCue.GetComponent<Image>().enabled+" / trigger="+card.TriggerCue.GetComponent<Image>().enabled+" / castcue="+card.CastCue.GetComponent<Image>().enabled);
            unit.Action="Idle";unit.CanActivateUltimate=false;unit.UltimateCastTick=40;Hud();
            Check(card.CastCue.GetComponent<Image>().enabled,"Cast confirmation missing");
            unit.Energy=unit.MaxEnergy*.25;unit.EnergyCostSinceTick=35;Hud();
            Check(card.EnergyCostCue.GetComponent<Image>().enabled && Mathf.Abs(((RectTransform)card.EnergyCostCue.transform).anchoredPosition.x+28.5f)<.01,"Energy-drain marker did not track the current energy edge");
            unit.EnergyCostSinceTick=-1;unit.UltimateCastTick=-1;Hud();
            Check(!card.EnergyCostCue.GetComponent<Image>().enabled && !card.CastCue.GetComponent<Image>().enabled,"Ended channel retained its HUD effects");
            var result=new{State="PASS",Checks=checks,Shaders=Enum.GetValues(typeof(ZatodBuffShader)).Length,Forms=forms.Length};
            File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        finally{UnityEngine.Object.Destroy(root);}
    }
}
