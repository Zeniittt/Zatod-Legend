using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;
public static class VerifyZatodPvpSceneLive
{
    public static object Run()
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var host=c.GetComponent<ZatodPrototypeView>();var scenes=c.GetComponent<ZatodBattleSceneController>();
        var world=c.GetComponent<ZatodWorldView>();var flags=BindingFlags.Instance|BindingFlags.NonPublic;
        var folder=Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/pvp-live");Directory.CreateDirectory(folder);
        string peerResult=Path.Combine(folder,"peer.result");if(File.Exists(peerResult))File.Delete(peerResult);
        var args=new[]{"-batchmode","-nographics","--zatod-port","17996","--zatod-smoke","right","--zatod-profile","battle-pvp-peer-"+Guid.NewGuid().ToString("N"),"--smoke-output",peerResult,"-logFile",Path.Combine(folder,"peer.log")};
        var info=new System.Diagnostics.ProcessStartInfo(Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/Player/ZatodLegend.exe")){UseShellExecute=false,CreateNoWindow=true,WindowStyle=System.Diagnostics.ProcessWindowStyle.Hidden,Arguments=string.Join(" ",args.Select(a=>"\""+a+"\""))};
        var peer=System.Diagnostics.Process.Start(info);int phase=0,checks=0,frame=-1,inputs=0;double started=EditorApplication.timeSinceStartup,at=started;bool finished=false;string digest=null;
        void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        c.FindPvp(c.Snapshot.Account.HeroDesk.Take(5).Select(h=>h.HeroInstanceId));
        EditorApplication.CallbackFunction callback=null;
        void Finish(string error=null)
        {
            if(finished)return;finished=true;EditorApplication.update-=callback;if(!peer.HasExited)peer.Kill();
            File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{Result=error==null?"PASS":"FAIL",Error=error,Checks=checks,Phase=phase,Inputs=inputs,Digest=digest,Seconds=EditorApplication.timeSinceStartup-started},Newtonsoft.Json.Formatting.Indented));
        }
        callback=()=>
        {
            try
            {
                if(!Application.isPlaying || EditorApplication.timeSinceStartup-started>200)throw new Exception("PvP live timeout/interrupted: "+phase+" "+c.Status);
                if(frame==Time.frameCount)return;frame=Time.frameCount;
                if(c.Battle?.Mode==ZatodMode.RealtimePvp && !c.Battle.Finished)
                    foreach(var unit in c.Battle.Frame().Units.Where(u=>u.Team==c.Team && u.Alive && u.Energy>=u.MaxEnergy))if(c.Ultimate(unit.EntityId))inputs++;
                if(phase==0 && c.Battle?.Mode==ZatodMode.RealtimePvp && scenes.Phase==ZatodScenePhase.InBattle && c.Battle.CurrentTick>15)
                {
                    Check(SceneManager.sceneCount==2 && scenes.Stage.UnitCount>0,"PvP scene/renderers missing");Check(world.Suspended,"World input not locked during PvP");
                    ScreenCapture.CaptureScreenshot(Path.Combine(folder,"01-pvp.png"));phase=1;
                }
                if(phase==1 && c.LastReplay?.Initial.Mode==ZatodMode.RealtimePvp && File.Exists(peerResult))
                {
                    digest=c.LastReplay.Digest.ToString();Check(File.ReadAllText(peerResult).Contains("pvp digest="+digest+" "),"PvP peer/checker digest mismatch");Check(inputs>0,"No manual PvP input exercised");
                    typeof(ZatodPrototypeView).GetMethod("Show",flags).Invoke(host,new object[]{"campaign"});c.Cancel();phase=2;
                }
                if(phase==2 && scenes.Phase==ZatodScenePhase.World)
                {
                    Check(SceneManager.sceneCount==1 && !world.Suspended,"PvP did not return world");scenes.Enter();at=EditorApplication.timeSinceStartup;phase=3;
                }
                if(phase==3 && scenes.Phase==ZatodScenePhase.InBattle)
                {c.Disconnect();phase=4;}
                if(phase==4 && !c.Connected && scenes.Phase==ZatodScenePhase.World)
                {Check(SceneManager.sceneCount==1,"Disconnect leaked battle scene");Check(!world.Suspended,"Disconnect left world suspended");c.Connect();phase=5;}
                if(phase==5 && c.Connected && c.WorldSelf!=null)
                {Check(world.MapId=="town","Reconnect did not restore world");Finish();}
            }
            catch(Exception e){Finish(e.ToString());}
        };
        File.WriteAllText(Path.Combine(folder,"result.json"),"{\"Result\":\"RUNNING\"}");EditorApplication.update+=callback;return new{Status="ARMED",Folder=folder};
    }
}
