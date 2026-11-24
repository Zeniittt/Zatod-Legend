using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;

namespace Zatod.Editor
{
    public static class ZatodEvolutionArt
    {
        static readonly string[] Resources={"eff_buff_slow","eff_buff_Coco_ult","eff_buff_NS_atk3b","eff_buff_frozen_atk2","eff_buff_Ench_awake"};
        [MenuItem("Zatod/Tools/Prepare D35 Skill Art")]
        public static void Prepare()
        {
            ZatodSkillUiAssets.Prepare();
            foreach(string resource in Resources)ImportEffect(resource);
            AssetDatabase.SaveAssets();
        }
        static void ImportEffect(string resource)
        {
            string manifestPath="Assets/Zatod/Art/Imported/"+resource+"/bake-manifest.txt";
            var manifest=JsonUtility.FromJson<ZatodBakeManifest>(File.ReadAllText(manifestPath));
            var sprites=new Dictionary<string,Sprite>(StringComparer.Ordinal);
            var factory=new SpriteDataProviderFactories();factory.Init();
            foreach(var sheet in manifest.Sheets)
            {
                AssetDatabase.ImportAsset(sheet.Path,ImportAssetOptions.ForceSynchronousImport);
                var importer=(TextureImporter)AssetImporter.GetAtPath(sheet.Path);
                importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
                importer.spritePixelsPerUnit=100;importer.mipmapEnabled=false;importer.alphaIsTransparency=true;
                importer.maxTextureSize=4096;importer.textureCompression=TextureImporterCompression.Uncompressed;
                var provider=factory.GetSpriteEditorDataProviderFromObject(importer);provider.InitSpriteEditorDataProvider();
                var old=provider.GetSpriteRects().ToDictionary(x=>x.name,StringComparer.Ordinal);
                var rects=sheet.Frames.Select(f=>new SpriteRect{name=f.Name,rect=new Rect(f.X,f.Y,f.Width,f.Height),pivot=new Vector2(f.PivotX,f.PivotY),alignment=SpriteAlignment.Custom,spriteID=old.TryGetValue(f.Name,out var previous)?previous.spriteID:GUID.Generate()}).ToArray();
                provider.SetSpriteRects(rects);
                provider.GetDataProvider<ISpriteNameFileIdDataProvider>().SetNameFileIdPairs(rects.Select(x=>new SpriteNameFileIdPair(x.name,x.spriteID)));
                provider.Apply();importer.SaveAndReimport();
                foreach(var sprite in AssetDatabase.LoadAllAssetsAtPath(sheet.Path).OfType<Sprite>())sprites.Add(sheet.Path+"#"+sprite.name,sprite);
            }
            string folder="Assets/Zatod/Resources/Zatod/"+resource;Directory.CreateDirectory(folder+"/Animations");AssetDatabase.Refresh();
            var set=new HeroAnimationSetData{HeroId=manifest.UnitId,CanvasWidth=manifest.Actions.Max(x=>x.Width),CanvasHeight=manifest.Actions.Max(x=>x.Height),PixelsPerUnit=100};
            foreach(var action in manifest.Actions)
            {
                string path=folder+"/Animations/"+action.Name+".anim";var clip=AssetDatabase.LoadAssetAtPath<AnimationClip>(path);bool create=clip==null;
                if(create)clip=new AnimationClip{name=action.Name};clip.frameRate=action.Fps;
                var keys=action.Frames.Select((frame,index)=>new ObjectReferenceKeyframe{time=index/action.Fps,value=sprites[frame.Sheet+"#"+frame.Name]}).ToList();
                keys.Add(new ObjectReferenceKeyframe{time=action.Duration,value=keys[keys.Count-1].value});
                AnimationUtility.SetObjectReferenceCurve(clip,new EditorCurveBinding{path="",type=typeof(SpriteRenderer),propertyName="m_Sprite"},keys.ToArray());
                var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=action.Loop;AnimationUtility.SetAnimationClipSettings(clip,settings);
                if(create)AssetDatabase.CreateAsset(clip,path);else EditorUtility.SetDirty(clip);
                set.Clips.Add(new HeroAnimationClipData{State=action.Name,SourceFolder="Zatod/"+resource,ClipResource="Zatod/"+resource+"/Animations/"+action.Name,FramesPerSecond=Mathf.RoundToInt(action.Fps),Loop=action.Loop,PreserveSpritePivot=true,SourceDurationSeconds=action.Duration,SourceFrames=action.Frames.Select(x=>x.Sheet+"#"+x.Name).ToList(),FrameTimes=action.Frames.Select((x,i)=>i/action.Fps).ToList(),AudioCues=(action.AudioCues??Array.Empty<HeroAudioCue>()).Select(x=>new HeroAudioCue{Time=x.Time,Resource=x.Resource.Replace("Crystal/","Zatod/")}).ToList()});
            }
            File.WriteAllText(folder+"/AnimationSet.txt",JsonUtility.ToJson(set,true));AssetDatabase.ImportAsset(folder+"/AnimationSet.txt",ImportAssetOptions.ForceSynchronousImport);
        }
    }
}
