using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
using Zatod.Heroes;

public static class SetupGuardian
{
    const string Source="E:/hoc/TinIT/TinUnity/MyProject/Zatod Legend/Assets/Graphics/Enemies/Guardian";
    const string Art="Assets/Zatod/Art/Monsters/Guardian", Root="Assets/Zatod/Resources/Monsters/Guardian";
    const string Key="Monsters/Guardian/";
    public static object Run()
    {
        var before=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(before).Data;
        if(data.Monsters.Any(m=>m.Id=="guardian") || Directory.Exists(Art) || Directory.Exists(Root))
            throw new InvalidOperationException("Guardian already exists; refusing to replace assets or balance.");
        var factories=new SpriteDataProviderFactories();factories.Init();
        Directory.CreateDirectory(Art);Directory.CreateDirectory(Root+"/Animations");AssetDatabase.Refresh();
        var manifest=new HeroAnimationSetData{HeroId="guardian",PixelsPerUnit=25,CanvasHeight=64,AnchorPixelY=20};
        var clips=new Dictionary<string,AnimationClip>();int frames=0;
        foreach(var spec in new[]{("Idle","Idle",64,34),("Run","Run",96,54),("NormalAttack","Attack",144,66),("Death","Death",96,50),("TakeHit","Shield",96,50)})
        {
            string filename="noBKG_Knight"+spec.Item2+"_strip.png",path=Art+"/"+filename;
            File.Copy(Source+"/"+filename,path,false);AssetDatabase.ImportAsset(path);
            var importer=(TextureImporter)AssetImporter.GetAtPath(path);
            importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
            importer.spritePixelsPerUnit=25;importer.filterMode=FilterMode.Point;importer.mipmapEnabled=false;
            importer.npotScale=TextureImporterNPOTScale.None;importer.maxTextureSize=4096;
            importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
            var texture=AssetDatabase.LoadAssetAtPath<Texture2D>(path);
            if(texture.width%spec.Item3!=0 || texture.height!=64)throw new InvalidOperationException("Unexpected strip geometry: "+filename);
            int count=texture.width/spec.Item3;
            var provider=factories.GetSpriteEditorDataProviderFromObject(importer);
            if(provider==null)throw new InvalidOperationException("Sprite provider missing");
            provider.InitSpriteEditorDataProvider();var capabilities=provider.GetDataProvider<ISpriteFrameEditCapability>();
            if(capabilities==null)throw new InvalidOperationException("Sprite capabilities missing");
            foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteName,EEditCapability.EditSpriteRect,EEditCapability.EditPivot})
                if(!capabilities.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Unsupported sprite operation: "+required);
            var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();
            if(names==null)throw new InvalidOperationException("Stable sprite identifiers unavailable");
            var rects=Enumerable.Range(0,count).Select(i=>new SpriteRect{name=spec.Item1+"_"+i.ToString("D3"),spriteID=GUID.Generate(),
                alignment=SpriteAlignment.Custom,rect=new Rect(i*spec.Item3,0,spec.Item3,64),pivot=new Vector2((float)spec.Item4/spec.Item3,20f/64)}).ToArray();
            provider.SetSpriteRects(rects);names.SetNameFileIdPairs(rects.Select(r=>new SpriteNameFileIdPair(r.name,r.spriteID)));
            provider.Apply();importer.SaveAndReimport();
            var sprites=AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().OrderBy(s=>s.name).ToArray();
            var entry=new HeroAnimationClipData{State=spec.Item1,SourceFolder=Source,ClipResource=Key+"Animations/"+spec.Item1,
                FramesPerSecond=12,SourceDurationSeconds=count/12f,Loop=spec.Item1=="Idle"||spec.Item1=="Run"};
            var clip=new AnimationClip{name=spec.Item1,frameRate=12};AssetDatabase.CreateAsset(clip,Root+"/Animations/"+spec.Item1+".anim");
            var keys=sprites.Select((s,i)=>new ObjectReferenceKeyframe{time=i/12f,value=s}).ToArray();
            AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),keys);
            var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=entry.Loop;settings.stopTime=entry.DurationSeconds;
            AnimationUtility.SetAnimationClipSettings(clip,settings);
            for(int i=0;i<count;i++){entry.SourceFrames.Add(sprites[i].name);entry.FrameTimes.Add(i/12f);entry.Frames.Add(new HeroFrameBounds{Width=spec.Item3,Height=64});}
            clips.Add(entry.State,clip);manifest.Clips.Add(entry);frames+=count;
        }
        // Combat control playback requests Stun. Keep TakeHit as the source-facing name too.
        var hit=manifest.Clips.Single(c=>c.State=="TakeHit");
        var stun=JsonUtility.FromJson<HeroAnimationClipData>(JsonUtility.ToJson(hit));stun.State="Stun";manifest.Clips.Add(stun);clips.Add("Stun",clips["TakeHit"]);
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,Root+"/GuardianSprite.mat");
        var controller=AnimatorController.CreateAnimatorControllerAtPath(Root+"/Guardian.controller");
        foreach(var pair in clips){var state=controller.layers[0].stateMachine.AddState(pair.Key);state.motion=pair.Value;state.writeDefaultValues=false;
            if(pair.Key=="Idle")controller.layers[0].stateMachine.defaultState=state;}
        var go=new GameObject("Guardian");
        try{var renderer=go.AddComponent<SpriteRenderer>();renderer.sharedMaterial=material;
            renderer.sprite=(Sprite)AnimationUtility.GetObjectReferenceCurve(clips["Idle"],EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;
            go.AddComponent<Animator>().runtimeAnimatorController=controller;PrefabUtility.SaveAsPrefabAsset(go,Root+"/Guardian.prefab");}
        finally{UnityEngine.Object.DestroyImmediate(go);}
        File.WriteAllText(Root+"/AnimationSet.txt",JsonUtility.ToJson(manifest,true));AssetDatabase.ImportAsset(Root+"/AnimationSet.txt");
        string portrait="Assets/Zatod/Resources/MonsterPortraits/guardian.png";
        File.Copy(Source+"/noBKG_KnightIdle_strip.png",portrait,false);AssetDatabase.ImportAsset(portrait);
        var icon=(TextureImporter)AssetImporter.GetAtPath(portrait);icon.textureType=TextureImporterType.Sprite;icon.spriteImportMode=SpriteImportMode.Single;
        icon.filterMode=FilterMode.Point;icon.mipmapEnabled=false;icon.textureCompression=TextureImporterCompression.Uncompressed;icon.SaveAndReimport();
        // A portrait is a crop, not the full fifteen-frame strip.
        icon.spriteImportMode=SpriteImportMode.Multiple;icon.SaveAndReimport();
        var ip=factories.GetSpriteEditorDataProviderFromObject(icon);ip.InitSpriteEditorDataProvider();
        var ic=ip.GetDataProvider<ISpriteFrameEditCapability>();if(ic==null)throw new InvalidOperationException("Portrait capabilities missing");
        foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteName,EEditCapability.EditSpriteRect,EEditCapability.EditPivot})
            if(!ic.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Portrait operation unsupported");
        var ir=new SpriteRect{name="guardian",spriteID=GUID.Generate(),rect=new Rect(18,16,36,40),alignment=SpriteAlignment.Center,pivot=new Vector2(.5f,.5f)};
        var ids=ip.GetDataProvider<ISpriteNameFileIdDataProvider>();if(ids==null)throw new InvalidOperationException("Portrait stable IDs unavailable");
        ip.SetSpriteRects(new[]{ir});ids.SetNameFileIdPairs(new[]{new SpriteNameFileIdPair(ir.name,ir.spriteID)});ip.Apply();icon.SaveAndReimport();
        var definition=new MonsterDefinition{Id="guardian",Name="Guardian",PortraitKey="guardian",Position=HeroPosition.Front,
            BodyPrefabResource=Key+"Guardian",AnimationSetResource=Key+"AnimationSet",NormalAttackSkillId="guardian_normal_attack",
            ProjectileHurtboxHeight=120,DeathAnimationMilliseconds=1250,
            BaseStats=new List<StatValue>{new StatValue("health",1600),new StatValue("damage",100),new StatValue("defense",25),
                new StatValue("attack_range",160),new StatValue("move_speed",900),new StatValue("attack_interval",44)}};
        var attack=new SkillDefinition{Id=definition.NormalAttackSkillId,Name="Guardian / Sword Attack",Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,
            AnimationState="NormalAttack",CastRange=160,WindupMilliseconds=420,AnimationDurationMilliseconds=1834,RecoveryMilliseconds=1414,
            Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=10000}}};
        data.Monsters.Add(definition);data.Skills.Add(attack);data.ConfigVersion+="-guardian-1";
        HeroConfigFileStore.Save(data,before);LeenaldAtlasBuild.Ensure("Assets/Zatod/Art/Monsters","Assets/Zatod/Art/Monsters/Monsters.spriteatlasv2");AssetDatabase.SaveAssets();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroBalanceWindow>())window.ReloadIfClean();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>())window.CreateGUI();
        return new{monster=definition.Id,frames,clips=5,states=manifest.Clips.Count,data.ConfigVersion};
    }
}
