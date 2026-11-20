using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
int resources=0,spriteCount=0,clipCount=0;
var paths=Directory.GetFiles("Assets/Zatod/Art/Imported","bake-manifest.txt",SearchOption.AllDirectories);
foreach(string path in paths)
{
    var manifest=JsonUtility.FromJson<ZatodBakeManifest>(File.ReadAllText(path));
    foreach(var sheet in manifest.Sheets)
    {
        var sprites=AssetDatabase.LoadAllAssetsAtPath(sheet.Path).OfType<Sprite>().ToDictionary(s=>s.name);
        if(sprites.Count!=sheet.Frames.Length)throw new Exception("Sprite count mismatch: "+sheet.Path);
        foreach(var frame in sheet.Frames)
        {
            var sprite=sprites[frame.Name];
            if(sprite.rect.width!=frame.Width || sprite.rect.height!=frame.Height || Math.Abs(sprite.pivot.x-frame.PivotX*frame.Width)>.05 || Math.Abs(sprite.pivot.y-frame.PivotY*frame.Height)>.05)throw new Exception("Frame geometry/pivot mismatch: "+frame.Name+" actual="+sprite.pivot);
        }
        spriteCount+=sprites.Count;
    }
    var set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>("Zatod/"+manifest.Resource+"/AnimationSet").text);
    if(Resources.Load<GameObject>("Zatod/"+manifest.Resource+"/"+manifest.Resource)==null)throw new Exception("Missing prefab: "+manifest.Resource);
    foreach(var action in manifest.Actions)
    {
        var definition=set.Clips.Single(c=>c.State==action.Name);var clip=Resources.Load<AnimationClip>(definition.ClipResource);
        if(clip==null || Math.Abs(clip.frameRate-action.Fps)>.00001 || Math.Abs(definition.DurationSeconds-action.Duration)>.00001)throw new Exception("Clip timing mismatch: "+manifest.Resource+"/"+action.Name);
        var keys=AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
        if(keys.Length!=action.Frames.Length+1)throw new Exception("Clip keys missing: "+clip.name);
        for(int i=0;i<action.Frames.Length;i++)if(keys[i].value==null || keys[i].value.name!=action.Frames[i].Name || Math.Abs(keys[i].time-i/action.Fps)>.00001)throw new Exception("Frame order/time mismatch: "+clip.name+" #"+i);
        if(AnimationUtility.GetAnimationClipSettings(clip).loopTime!=action.Loop)throw new Exception("Clip loop mismatch: "+manifest.Resource+"/"+action.Name);
        clipCount++;
    }
    resources++;EditorUtility.UnloadUnusedAssetsImmediate();
}
var data=Zatod.Heroes.HeroDataJson.LoadBundledCatalog();
foreach(var unit in data.Data.Heroes.Cast<Zatod.Heroes.CombatantDefinition>().Concat(data.Data.Monsters).Where(u=>u.SourceUnitId>0))
{
    var set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(unit.AnimationSetResource).text);
    var skills=new[]{unit.NormalAttackSkillId}.Concat(unit is Zatod.Heroes.HeroDefinition hero?hero.SkillSlots.Select(s=>s.SkillId):((Zatod.Heroes.MonsterDefinition)unit).SkillIds);
    foreach(string id in skills)foreach(var phase in data.Skill(id).Crystal.Phases)if(!set.Clips.Any(c=>c.State==phase.Action))throw new Exception("Skill action unavailable: "+unit.Id+"/"+id+"/"+phase.Action);
}
File.WriteAllText("../Artifacts/CrystalPhaseChecks/unity-assets.json","{\"Resources\":"+resources+",\"Sprites\":"+spriteCount+",\"Clips\":"+clipCount+",\"Result\":\"PASS\"}");
return new{status="PASS",resources,sprites=spriteCount,clips=clipCount};
