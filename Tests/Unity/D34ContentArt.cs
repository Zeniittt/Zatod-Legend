using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using Zatod.Editor;
using Zatod.Presentation;

public static class D34ContentArt
{
    static void Isolated()
    {
        if(!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new InvalidOperationException("Use the isolated validation project.");
    }
    public static object PrepareNative(string manifest,string repository,string chapters,string report)
    {
        Isolated();
        int native=ZatodHeroImportArt.PrepareNativeArt(manifest,repository),world=ZatodD34WorldArt.Prepare(chapters);
        var result=new{State="PASS",NativeAssets=native,WorldPrefabs=world};
        File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
    public static object PrepareEffects(string[] reports,string report)
    {
        Isolated();var resources=new SortedSet<string>(StringComparer.Ordinal);
        foreach(string path in reports)
        foreach(var row in Newtonsoft.Json.Linq.JArray.Parse(File.ReadAllText(path)))
            if((string)row["Status"]!="missing native source container" &&
                (row["Frames"]!=null || !File.Exists("Assets/Zatod/Resources/Zatod/"+(string)row["Resource"]+"/AnimationSet.txt")))resources.Add((string)row["Resource"]);
        int completed=0;
        foreach(string resource in resources)
        {
            ZatodEvolutionArt.ImportBakedResource(resource,true);completed++;
            File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{Completed=completed,Total=resources.Count,Last=resource}));
        }
        AssetDatabase.SaveAssets();return new{Completed=completed};
    }
    public static object AuditEffects(string[] reports,string report)
    {
        Isolated();var resources=new SortedSet<string>(StringComparer.Ordinal);
        foreach(string path in reports)
        foreach(var row in Newtonsoft.Json.Linq.JArray.Parse(File.ReadAllText(path)))
            if((string)row["Status"]!="missing native source container")resources.Add((string)row["Resource"]);
        int clips=0,samples=0,scaledChecks=0;
        foreach(string resource in resources)
        {
            var go=new GameObject("Effect sample");
            try
            {
                var visual=go.AddComponent<ZatodBattleSprite>();visual.Initialize("Zatod/"+resource+"/AnimationSet");
                var bake=Newtonsoft.Json.Linq.JObject.Parse(File.ReadAllText("Assets/Zatod/Art/Imported/"+resource+"/bake-manifest.txt"));
                foreach(var action in visual.Set.Clips)
                {
                    foreach(float progress in new[]{0f,.5f,.99f})
                    {
                        visual.Sample(action.State,action.DurationSeconds*progress,true,1);
                        if(visual.Renderer.sprite==null || !visual.Renderer.enabled)throw new InvalidDataException("Empty effect sprite: "+resource+"/"+action.State);
                        if(bake["BakeScale"]!=null)
                        {
                            var source=bake["Actions"].Single(a=>(string)a["Name"]==action.State);
                            if(Math.Abs(visual.Renderer.sprite.pixelsPerUnit-(double)bake["PixelsPerUnit"])>.0001 ||
                                Math.Abs(visual.Renderer.sprite.bounds.size.x-(double)source["SourceWidth"]/100)>.011 ||
                                Math.Abs(visual.Renderer.sprite.bounds.size.y-(double)source["SourceHeight"]/100)>.011)
                                throw new InvalidDataException("Oversized effect lost its native world size: "+resource);
                            scaledChecks++;
                        }
                        samples++;
                    }
                    clips++;
                }
            }
            finally{UnityEngine.Object.DestroyImmediate(go);}
        }
        var result=new{State="PASS",Resources=resources.Count,Clips=clips,Samples=samples,ScaledChecks=scaledChecks};
        File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
}
