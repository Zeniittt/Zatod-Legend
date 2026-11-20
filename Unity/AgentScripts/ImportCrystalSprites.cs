// Manifest DTOs are populated by JsonUtility.
#pragma warning disable CS0649
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.U2D.Sprites;
using Zatod.Animation;
using Manifest = Zatod.Editor.ZatodBakeManifest;

public static class ImportCrystalSprites
{
    static string Evidence => Path.GetFullPath("../Artifacts/CrystalPhaseChecks/sprite-import");
    static void Folder(string path)
    {
        if(AssetDatabase.IsValidFolder(path))return;
        string parent=Path.GetDirectoryName(path).Replace('\\','/');Folder(parent);AssetDatabase.CreateFolder(parent,Path.GetFileName(path));
    }
    static UnityEngine.GUID StableId(string key)
    {
        using(var hash=MD5.Create())return new UnityEngine.GUID(string.Concat(hash.ComputeHash(Encoding.UTF8.GetBytes(key)).Select(x=>x.ToString("x2"))));
    }
    public static object RunNext()
    {
        Directory.CreateDirectory(Evidence);
        var paths=Directory.GetFiles("Assets/Zatod/Art/Imported","bake-manifest.txt",SearchOption.AllDirectories).OrderBy(x=>x,StringComparer.Ordinal).ToArray();
        foreach(var path in paths)
        {
            var manifest=JsonUtility.FromJson<Manifest>(File.ReadAllText(path));
            if(File.Exists(Path.Combine(Evidence,manifest.Resource+".json")))continue;
            return Run(manifest);
        }
        return new{status="COMPLETE",resources=paths.Length};
    }
    public static object Run(Manifest manifest)
    {
        var factory=new SpriteDataProviderFactories();factory.Init();
        int sprites=0;
        foreach(var sheet in manifest.Sheets)
        {
            var importer=AssetImporter.GetAtPath(sheet.Path) as TextureImporter;
            if(importer==null){AssetDatabase.ImportAsset(sheet.Path,ImportAssetOptions.ForceSynchronousImport);importer=(TextureImporter)AssetImporter.GetAtPath(sheet.Path);}
            importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
            importer.spritePixelsPerUnit=100;importer.mipmapEnabled=false;importer.alphaIsTransparency=true;
            importer.textureCompression=TextureImporterCompression.Uncompressed;importer.maxTextureSize=4096;
            importer.filterMode=FilterMode.Bilinear;importer.wrapMode=TextureWrapMode.Clamp;importer.npotScale=TextureImporterNPOTScale.None;
            importer.SaveAndReimport();
            var provider=factory.GetSpriteEditorDataProviderFromObject(importer);
            if(provider==null)throw new Exception("No sprite provider: "+sheet.Path);
            provider.InitSpriteEditorDataProvider();
            var edit=provider.GetDataProvider<ISpriteFrameEditCapability>();
            if(edit==null)throw new Exception("No sprite edit capability: "+sheet.Path);
            var capabilities=edit.GetEditCapability();
            foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditPivot,EEditCapability.EditSpriteRect,EEditCapability.EditSpriteName})
                if(!capabilities.HasCapability(required))throw new Exception("Unsupported sprite capability: "+required);
            var rectangles=sheet.Frames.Select(f=>new SpriteRect{name=f.Name,spriteID=StableId(f.Name),rect=new Rect(f.X,f.Y,f.Width,f.Height),pivot=new Vector2(f.PivotX,f.PivotY),alignment=SpriteAlignment.Custom}).ToArray();
            provider.SetSpriteRects(rectangles);
            var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();
            if(names==null)throw new Exception("No name/file ID provider: "+sheet.Path);
            names.SetNameFileIdPairs(rectangles.Select(r=>new SpriteNameFileIdPair(r.name,r.spriteID)));
            provider.Apply();importer.SaveAndReimport();
            int actual=AssetDatabase.LoadAllAssetsAtPath(sheet.Path).OfType<Sprite>().Count();
            if(actual!=sheet.Frames.Length)throw new Exception("Sprite count mismatch: "+sheet.Path+" "+actual+"/"+sheet.Frames.Length);
            sprites+=actual;
        }
        string directory="Assets/Zatod/Resources/Zatod/"+manifest.Resource;
        Folder(directory);Folder(directory+"/Animations");
        var set=new HeroAnimationSetData{HeroId=manifest.UnitId,PixelsPerUnit=100,CanvasWidth=manifest.Actions.Max(a=>a.Width),CanvasHeight=manifest.Actions.Max(a=>a.Height)};
        var bySheet=manifest.Sheets.ToDictionary(s=>s.Path,s=>AssetDatabase.LoadAllAssetsAtPath(s.Path).OfType<Sprite>().ToDictionary(x=>x.name,StringComparer.Ordinal));
        var clips=new Dictionary<string,AnimationClip>(StringComparer.Ordinal);
        foreach(var action in manifest.Actions)
        {
            string path=directory+"/Animations/"+action.Name+".anim";
            var clip=AssetDatabase.LoadAssetAtPath<AnimationClip>(path);
            if(clip==null){clip=new AnimationClip{name=action.Name};AssetDatabase.CreateAsset(clip,path);}
            clip.frameRate=action.Fps;clip.wrapMode=action.Loop?WrapMode.Loop:WrapMode.ClampForever;
            var keys=new ObjectReferenceKeyframe[action.Frames.Length+1];
            for(int i=0;i<action.Frames.Length;i++)keys[i]=new ObjectReferenceKeyframe{time=i/action.Fps,value=bySheet[action.Frames[i].Sheet][action.Frames[i].Name]};
            keys[keys.Length-1]=new ObjectReferenceKeyframe{time=action.Duration,value=keys[keys.Length-2].value};
            AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),keys);
            var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=action.Loop;AnimationUtility.SetAnimationClipSettings(clip,settings);
            EditorUtility.SetDirty(clip);clips.Add(action.Name,clip);
            var data=new HeroAnimationClipData{State=action.Name,FramesPerSecond=Mathf.RoundToInt(action.Fps),SourceDurationSeconds=action.Duration,Loop=action.Loop,SourceFolder="Zatod/"+manifest.Resource,ClipResource="Zatod/"+manifest.Resource+"/Animations/"+action.Name,PreserveSpritePivot=true};
            for(int i=0;i<action.Frames.Length;i++){data.SourceFrames.Add(action.Frames[i].Sheet+"#"+action.Frames[i].Name);data.FrameTimes.Add(i/action.Fps);data.Frames.Add(new HeroFrameBounds{X=0,Y=0,Width=action.Width,Height=action.Height});}
            if(action.AudioCues!=null)data.AudioCues.AddRange(action.AudioCues);
            set.Clips.Add(data);
        }
        File.WriteAllText(directory+"/AnimationSet.txt",JsonUtility.ToJson(set,true),new UTF8Encoding(false));AssetDatabase.ImportAsset(directory+"/AnimationSet.txt");
        string controllerPath=directory+"/"+manifest.Resource+".controller";
        var controller=AssetDatabase.LoadAssetAtPath<AnimatorController>(controllerPath);
        if(controller==null)controller=AnimatorController.CreateAnimatorControllerAtPath(controllerPath);
        var machine=controller.layers[0].stateMachine;
        foreach(var pair in clips)
        {
            var state=machine.states.Select(s=>s.state).FirstOrDefault(s=>s.name==pair.Key)??machine.AddState(pair.Key);
            state.motion=pair.Value;if(pair.Key=="Idle")machine.defaultState=state;
        }
        EditorUtility.SetDirty(controller);
        var go=new GameObject(manifest.Resource,typeof(SpriteRenderer),typeof(Animator));
        try
        {
            var first=manifest.Actions.FirstOrDefault(a=>a.Name=="Idle")??manifest.Actions[0];
            go.GetComponent<SpriteRenderer>().sprite=bySheet[first.Frames[0].Sheet][first.Frames[0].Name];
            go.GetComponent<Animator>().runtimeAnimatorController=controller;
            PrefabUtility.SaveAsPrefabAsset(go,directory+"/"+manifest.Resource+".prefab");
        }
        finally{UnityEngine.Object.DestroyImmediate(go);}
        AssetDatabase.SaveAssets();
        Directory.CreateDirectory(Evidence);
        string proof="{\"Resource\":\""+manifest.Resource+"\",\"Sprites\":"+sprites+",\"Clips\":"+clips.Count+"}";
        File.WriteAllText(Path.Combine(Evidence,manifest.Resource+".json"),proof);
        return new{status="IMPORTED",resource=manifest.Resource,sprites,clips=clips.Count,prefab=directory+"/"+manifest.Resource+".prefab"};
    }
}
return ImportCrystalSprites.RunNext();
