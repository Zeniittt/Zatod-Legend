// Source-backed D34 art checks. Run only in the isolated validation workspace.
using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Presentation;

public static class D34HeroImport
{
    static void Isolated()
    {
        if(!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new InvalidOperationException("Use the isolated validation project.");
    }
    public static object PrepareAnimations(string manifestPath,string report)
    {
        Isolated();
        var manifest=Newtonsoft.Json.JsonConvert.DeserializeObject<ZatodHeroImportArt.Manifest>(File.ReadAllText(manifestPath));
        int completed=0;
        foreach(var hero in manifest.Actors.GroupBy(h=>h.SourceResource).Select(g=>g.First()))
        {
            ZatodEvolutionArt.ImportBakedResource(hero.SourceResource,true);
            completed++;
            File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{Completed=completed,Total=manifest.Actors.Select(h=>h.SourceResource).Distinct().Count(),Last=hero.Id}));
        }
        AssetDatabase.SaveAssets();return new{Completed=completed};
    }
    public static object Audit(string manifestPath,string draftData,string report)
    {
        Isolated();
        var manifest=Newtonsoft.Json.JsonConvert.DeserializeObject<ZatodHeroImportArt.Manifest>(File.ReadAllText(manifestPath));
        var documents=new HeroConfigDocuments();
        foreach(var section in HeroDataJson.Sections)documents.Set(section,File.ReadAllText(Path.Combine(draftData,section+".txt")));
        var catalog=HeroDataJson.ReadDocuments(documents);
        int checks=0,frames=0,actions=0;
        void Check(bool value,string message){checks++;if(!value)throw new InvalidOperationException(message);}
        foreach(var hero in manifest.Actors)
        {
            var monster=catalog.Data.Monsters.FirstOrDefault(m=>m.Id==hero.Id);
            if(!hero.Form && (monster==null || !string.IsNullOrEmpty(monster.PortraitKey)))Check(Resources.Load<Sprite>("Zatod/UI/Formation/Portraits/"+hero.Id)!=null,"Missing portrait: "+hero.Id);
            var definition=catalog.Data.Heroes.FirstOrDefault(h=>h.Id==hero.Id);
            if(definition!=null)
            {
                Check(Resources.Load<Sprite>("Zatod/UI/Hero/Illustrations/"+hero.Id)!=null,"Missing illustration: "+hero.Id);
                foreach(var slot in definition.SkillSlots)
                    Check(Resources.Load<Sprite>("Zatod/UI/Hero/Skills/Icons/"+slot.SkillId)!=null,"Missing skill icon: "+slot.SkillId);
            }
            var manifestAsset=JsonUtility.FromJson<ZatodBakeManifest>(File.ReadAllText("Assets/Zatod/Art/Imported/"+hero.SourceResource+"/bake-manifest.txt"));
            var asset=Resources.Load<TextAsset>(hero.AnimationSetResource);
            Check(asset!=null,"Missing animation set: "+hero.Id);
            var set=JsonUtility.FromJson<HeroAnimationSetData>(asset.text);
            foreach(var action in manifestAsset.Actions)
            {
                var entry=set.Clips.Single(c=>c.State==action.Name);
                Check(Math.Abs(entry.SourceDurationSeconds-action.Duration)<.00001,"Duration mismatch: "+hero.Id+"/"+action.Name);
                Check(entry.FrameTimes.Count==action.Frames.Length,"Lost frames: "+hero.Id+"/"+action.Name);
                var clip=Resources.Load<AnimationClip>(entry.ClipResource);
                Check(clip!=null,"Missing clip: "+entry.ClipResource);
                Check(Math.Abs(clip.frameRate-action.Fps)<.0001,"FPS mismatch: "+hero.Id+"/"+action.Name);
                var keys=AnimationUtility.GetObjectReferenceCurve(clip,new EditorCurveBinding{path="",type=typeof(SpriteRenderer),propertyName="m_Sprite"});
                Check(keys.Length==action.Frames.Length+1,"Lost sprite keys");
                foreach(var key in keys)Check(key.value is Sprite,"Null baked sprite: "+hero.Id+"/"+action.Name);
                actions++;frames+=action.Frames.Length;
            }
            foreach(var sheet in manifestAsset.Sheets)
            {
                var sprites=AssetDatabase.LoadAllAssetsAtPath(sheet.Path).OfType<Sprite>().ToDictionary(sprite=>sprite.name);
                var importer=(TextureImporter)AssetImporter.GetAtPath(sheet.Path);
                foreach(string platform in new[]{"Android","iPhone"})
                {
                    var settings=importer.GetPlatformTextureSettings(platform);
                    Check(settings.overridden && settings.format==TextureImporterFormat.ASTC_6x6,"Missing mobile texture override: "+sheet.Path);
                }
                foreach(var frame in sheet.Frames)
                {
                    var sprite=sprites[frame.Name];
                    Check(sprite.rect==new Rect(frame.X,frame.Y,frame.Width,frame.Height),"Frame rectangle changed");
                    Check(Math.Abs(sprite.pivot.x/frame.Width-frame.PivotX)<.0001 && Math.Abs(sprite.pivot.y/frame.Height-frame.PivotY)<.0001,"Frame pivot changed");
                }
            }
        }
        foreach(var asset in manifest.AudioAssets??Array.Empty<ZatodHeroImportArt.NativeAsset>())
            Check(Resources.Load<AudioClip>(asset.Target.Substring(0,asset.Target.LastIndexOf('.')))!=null,"Missing audio: "+asset.Target);
        var result=new{State="PASS",Checks=checks,Heroes=manifest.Heroes.Length,Actions=actions,Frames=frames,CatalogHeroes=catalog.Data.Heroes.Count,ActiveHeroes=HeroDataJson.LoadBundledCatalog().Data.Heroes.Count,NativeCombatVerified=false};
        File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
    public static object SampleSprites(string manifestPath,string report)
    {
        Isolated();
        var manifest=Newtonsoft.Json.JsonConvert.DeserializeObject<ZatodHeroImportArt.Manifest>(File.ReadAllText(manifestPath));
        int samples=0;
        foreach(var hero in manifest.Actors)
        {
            var go=new GameObject("D34 art sample");
            try
            {
                var visual=go.AddComponent<ZatodBattleSprite>();visual.Initialize(hero.AnimationSetResource);
                foreach(var action in visual.Set.Clips)
                foreach(float progress in new[]{0f,.5f,.99f})
                {
                    visual.Sample(action.State,action.DurationSeconds*progress,true,1);
                    if(visual.Renderer.sprite==null || !visual.Renderer.enabled)throw new InvalidOperationException("Empty sprite: "+hero.Id+"/"+action.State);
                    samples++;
                }
            }
            finally{UnityEngine.Object.DestroyImmediate(go);}
        }
        var result=new{State="PASS",Heroes=manifest.Heroes.Length,Samples=samples,NativeCombatVerified=false};
        File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
    public static object Gallery(string manifestPath,string imagePath)
    {
        Isolated();
        var manifest=Newtonsoft.Json.JsonConvert.DeserializeObject<ZatodHeroImportArt.Manifest>(File.ReadAllText(manifestPath));
        var scene=UnityEditor.SceneManagement.EditorSceneManager.NewPreviewScene();
        var oldActive=RenderTexture.active;
        var texture=new RenderTexture(1600,1000,24);
        var pixels=new Texture2D(1600,1000,TextureFormat.RGB24,false);
        try
        {
            var cameraObject=new GameObject("D34 gallery camera",typeof(Camera));
            UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(cameraObject,scene);
            var camera=cameraObject.GetComponent<Camera>();camera.cameraType=CameraType.Preview;
            camera.scene=scene;camera.orthographic=true;camera.orthographicSize=5.3f;camera.transform.position=new Vector3(0,0,-10);
            camera.clearFlags=CameraClearFlags.SolidColor;camera.backgroundColor=new Color(.10f,.13f,.18f);camera.targetTexture=texture;
            for(int i=0;i<manifest.Heroes.Length;i++)
            {
                var hero=manifest.Heroes[i];var go=new GameObject(hero.Id);
                UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(go,scene);
                var visual=go.AddComponent<ZatodBattleSprite>();visual.Initialize(hero.AnimationSetResource);
                visual.Sample("Idle",.25f,true,1);
                var size=visual.Renderer.bounds.size;
                float scale=2.4f/Mathf.Max(size.x,size.y);
                visual.Sample("Idle",.25f,true,scale);
                go.transform.position=new Vector3((i%5-2)*3.2f,(1-i/5)*3.3f-.2f,0);
                var bounds=visual.Renderer.bounds;
                go.transform.position+=new Vector3(go.transform.position.x-bounds.center.x,go.transform.position.y-bounds.center.y+.25f,0);
                var label=new GameObject("Name",typeof(TextMesh));
                UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(label,scene);
                label.transform.position=new Vector3((i%5-2)*3.2f,(1-i/5)*3.3f-1.25f,-.5f);
                var text=label.GetComponent<TextMesh>();text.text=hero.Id.ToUpperInvariant();text.fontSize=40;text.characterSize=.095f;text.anchor=TextAnchor.MiddleCenter;text.color=Color.white;
            }
            camera.Render();RenderTexture.active=texture;pixels.ReadPixels(new Rect(0,0,1600,1000),0,0);pixels.Apply();
            File.WriteAllBytes(imagePath,pixels.EncodeToPNG());return new{Path=imagePath,Heroes=manifest.Heroes.Length};
        }
        finally
        {
            RenderTexture.active=oldActive;UnityEditor.SceneManagement.EditorSceneManager.ClosePreviewScene(scene);
            UnityEngine.Object.DestroyImmediate(pixels);texture.Release();UnityEngine.Object.DestroyImmediate(texture);
        }
    }

}
