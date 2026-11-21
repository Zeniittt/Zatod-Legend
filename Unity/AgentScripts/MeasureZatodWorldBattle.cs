using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;
public static class MeasureZatodWorldBattle
{
    static async Task<object> Sample(string mode)
    {
        int frame=Time.frameCount;double at=EditorApplication.timeSinceStartup;await Task.Delay(2000);double seconds=EditorApplication.timeSinceStartup-at;
        return new{Mode=mode,Frames=Time.frameCount-frame,Seconds=seconds,EditorFps=(Time.frameCount-frame)/seconds,AllocatedBytes=UnityEngine.Profiling.Profiler.GetTotalAllocatedMemoryLong(),BattleSprites=UnityEngine.Object.FindObjectsByType<ZatodBattleSprite>().Length};
    }
    public static async Task<object> Run()
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var host=c.GetComponent<ZatodPrototypeView>();var scene=c.GetComponent<ZatodBattleSceneController>();
        c.DevelopmentProfile="world-battle-perf-"+Guid.NewGuid().ToString("N");c.Port=17996;c.GetComponent<Mirror.TelepathyTransport>().port=17996;c.Connect();
        await Unity.Pipeline.Scripting.Wait.Until(()=>c.WorldSelf!=null && c.Snapshot!=null,timeoutMs:20000,because:"measurement world ready");await Task.Delay(400);
        var before=await Sample("World");
        var flags=BindingFlags.Instance|BindingFlags.NonPublic;
        var decode=typeof(ReplayArchive).GetMethod("DecodePayload",BindingFlags.Static|BindingFlags.NonPublic).MakeGenericMethod(typeof(ZatodReplay));
        var replay=(ZatodReplay)decode.Invoke(null,new object[]{File.ReadAllBytes(Directory.GetFiles(Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/Server"),"*.zatod.gz")[0])});
        typeof(ZatodPrototypeView).GetMethod("LoadReplay",flags).Invoke(host,new object[]{replay});
        await Unity.Pipeline.Scripting.Wait.Until(()=>scene.Phase==ZatodScenePhase.InBattle,timeoutMs:10000,because:"measurement battle ready");await Task.Delay(300);
        var battle=await Sample("BattleReplay");
        typeof(ZatodPrototypeView).GetMethod("Show",flags).Invoke(host,new object[]{"campaign"});
        await Unity.Pipeline.Scripting.Wait.Until(()=>scene.Phase==ZatodScenePhase.World,timeoutMs:10000,because:"measurement world return");
        var after=await Sample("ReturnedWorld");
        var result=new{Result="PASS",Before=before,Battle=battle,After=after,Note="Short Editor samples with auto-tick; not a mobile hardware benchmark. Resource caches remain resident."};
        File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/editor-measurement.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
}
