using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Mirror;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
public static class D38ReplayUi
{
    const BindingFlags Private=BindingFlags.Instance|BindingFlags.Static|BindingFlags.NonPublic;
    static object Call(object value,string name,params object[] args)=>value.GetType().GetMethod(name,Private).Invoke(value,args);
    static T Field<T>(object value,string name)=>(T)value.GetType().GetField(name,Private).GetValue(value);
    static ZatodReplay Read(string path)=>(ZatodReplay)typeof(ReplayArchive).GetMethod("DecodePayload",Private).MakeGenericMethod(typeof(ZatodReplay)).Invoke(null,new object[]{File.ReadAllBytes(path)});
    public static string Arm(string output,string[] archives)
    {
        if(!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/") || NetworkServer.active || NetworkClient.active)throw new InvalidOperationException("Use the disconnected isolated Editor");
        Directory.CreateDirectory(output);string report=Path.Combine(output,"replay-ui.json");File.WriteAllText(report,"{\"State\":\"RUNNING\"}");Run(output,report,archives);return report;
    }
    static async void Run(string output,string report,string[] archives)
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var view=c.GetComponent<ZatodPrototypeView>();var scene=c.GetComponent<ZatodBattleSceneController>();var transport=c.GetComponent<TelepathyTransport>();
        string profile="d38-replay-"+Guid.NewGuid().ToString("N"),account=Guid.NewGuid().ToString("D"),directory=Path.Combine(output,"Server");Directory.CreateDirectory(directory);
        var oldProfile=c.DevelopmentProfile;ushort oldPort=c.Port,oldTransport=transport.port;EditorApplication.CallbackFunction pump=null;var rows=new List<object>();int checks=0;
        void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
        async Task Until(Func<bool> predicate,string why){var end=EditorApplication.timeSinceStartup+12;while(!predicate()){if(EditorApplication.timeSinceStartup>end)throw new TimeoutException(why+" / "+c.Status);await Task.Delay(30);}}
        try
        {
            Call(view,"Show","campaign");await Until(()=>scene.Phase==ZatodScenePhase.World,"Start in world");Field<Dictionary<string,ZatodPlayerSession>>(c,"launches").Clear();Field<Dictionary<int,ZatodPlayerSession>>(c,"sessions").Clear();var oldWorld=Field<GameObject>(c,"serverWorldRoot");if(oldWorld!=null)UnityEngine.Object.Destroy(oldWorld);
            c.DevelopmentProfile=profile;c.Port=transport.port=17941;PlayerPrefs.SetString("ZatodPrototype.Account."+profile,account);Call(c,"StartServer");typeof(ZatodConnection).GetField("archiveDirectory",Private).SetValue(c,directory);
            pump=()=>{if(NetworkServer.active){Call(c,"UpdateWorldServer");Call(c,"UpdateEconomyServer");}};EditorApplication.update+=pump;c.JoinLan("D38 replay fixture","127.0.0.1");await Until(()=>c.Snapshot?.Account.CharacterId==account,"Login");
            var rewards=c.Snapshot.Account.CampaignRewards.Count;var cleared=c.Snapshot.Cleared.Count;
            foreach(string path in archives)
            {
                var record=Read(path);Call(view,"LoadReplay",record);await Until(()=>scene.Phase==ZatodScenePhase.InBattle,"Replay scene");
                foreach(int tick in new[]{Math.Min(record.EndTick,16),record.EndTick/2,2,Math.Max(0,record.EndTick-1),record.EndTick})
                {
                    Call(view,"Seek",tick);await Task.Delay(90);var simulation=Field<ZatodBattleSimulation>(view,"replay");Check(simulation.CurrentTick==tick,"Seek tick");Check(!Field<bool>(view,"playing"),"Seek pauses playback");
                    var expected=new ZatodBattleSimulation(record.Initial);while(expected.CurrentTick<tick){foreach(var input in record.Inputs.Where(i=>i.Tick==expected.CurrentTick+1))expected.QueueInput(input);expected.Step();}
                    Check(simulation.Frame().Digest==expected.Frame().Digest,"Seek uses snapshot rules");Check(scene.Stage.Pool.ActiveCount==scene.Stage.EffectCount,"Seek releases old effect leases");Check(scene.Stage.UnitCount>0,"Replay has native actors");
                }
                Check(Field<ZatodBattleSimulation>(view,"replay").Replay().Digest==record.Digest,"Archive outcome preserved");rows.Add(new{Rules=record.Initial.RulesVersion,record.EndTick,Digest=record.Digest.ToString(),Reused=scene.Stage.Pool.Reused});
                Call(view,"Show","campaign");await Until(()=>scene.Phase==ZatodScenePhase.World,"Replay scene unload");Check((Field<ZatodPoolManager>(view,"floatingPool")?.ActiveCount??0)==0,"Replay exit releases floating text");
            }
            Check(c.Snapshot.Account.CampaignRewards.Count==rewards && c.Snapshot.Cleared.Count==cleared,"Replay cannot award or unlock a new launch");
            File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="PASS",Checks=checks,Archives=rows,NoRewardsOrUnlocks=true},Newtonsoft.Json.Formatting.Indented));
        }
        catch(Exception e){File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Checks=checks,Error=e.ToString()},Newtonsoft.Json.Formatting.Indented));}
        finally{Call(view,"Show","campaign");if(pump!=null)EditorApplication.update-=pump;c.Disconnect();if(NetworkServer.active)NetworkServer.Shutdown();c.DevelopmentProfile=oldProfile;c.Port=oldPort;transport.port=oldTransport;foreach(var part in new[]{"Account","Name","Server"})PlayerPrefs.DeleteKey("ZatodPrototype."+part+"."+profile);PlayerPrefs.Save();}
    }
}
