using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Playables;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyZatodWorldBattleLive
{
    public static object Run()
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var host=c.GetComponent<ZatodPrototypeView>();var world=c.GetComponent<ZatodWorldView>();
        var flags=BindingFlags.Instance|BindingFlags.NonPublic;
        var controller=c.GetComponent<ZatodBattleSceneController>();var worldCamera=GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        var hud=(ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud",flags).GetValue(host);
        string folder=Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/live");Directory.CreateDirectory(folder);
        int phase=0,checks=0,frame=-1,cycles=0;double start=EditorApplication.timeSinceStartup,at=start;bool finished=false;
        string[] roots=null;string[] heroes=null;Zatod.Combat.ZatodReplay recorded=null;PlayableGraph[] graphs=Array.Empty<PlayableGraph>();
        float lastPeer=float.NaN;int peerMoves=0;System.Diagnostics.Process peerProcess=null;
        c.DevelopmentProfile="world-battle-ui-"+Guid.NewGuid().ToString("N");c.Port=17996;c.GetComponent<Mirror.TelepathyTransport>().port=17996;c.AutoUltimate=true;c.Connect();
        void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
        void Next(int value){phase=value;at=EditorApplication.timeSinceStartup;}
        void Capture(string name)=>ScreenCapture.CaptureScreenshot(Path.Combine(folder,name+".png"));
        string[] RootIds()=>world.GetComponentsInChildren<Transform>(true).Where(t=>t.name.StartsWith("ZatodMap_")).OrderBy(t=>t.name).Select(t=>t.GetEntityId().ToString()).ToArray();
        void CheckRoots(){Check(RootIds().SequenceEqual(roots),"Travel/battle recreated island roots");Check(roots.Length==3,"Three islands required");}
        void BeginReplay(){typeof(ZatodPrototypeView).GetMethod("LoadReplay",flags).Invoke(host,new object[]{recorded});Next(12);}
        EditorApplication.CallbackFunction tick=null;
        void Finish(string error=null)
        {
            if(finished)return;finished=true;EditorApplication.update-=tick;
            if(peerProcess!=null && !peerProcess.HasExited)peerProcess.Kill();
            File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{Result=error==null?"PASS":"FAIL",Error=error,Checks=checks,Phase=phase,Cycles=cycles,PeerMoves=peerMoves,Seconds=EditorApplication.timeSinceStartup-start,SceneCount=SceneManager.sceneCount,ScenePhase=controller.Phase.ToString()},Newtonsoft.Json.Formatting.Indented));
        }
        tick=()=>
        {
            try
            {
                if(!Application.isPlaying || EditorApplication.timeSinceStartup-start>210)throw new Exception("Live test timeout/interrupted phase="+phase+" "+c.Status);
                if(frame==Time.frameCount)return;frame=Time.frameCount;
                if(phase==0 && c.WorldSelf!=null && c.Snapshot!=null)
                {
                    roots=RootIds();CheckRoots();Check(world.MapId=="town","Town missing");Capture("01-town");
                    heroes=c.Snapshot.Account.HeroDesk.Take(5).Select(h=>h.HeroInstanceId).ToArray();foreach(var h in heroes)c.DevLevel(h,40);
                    c.WorldTravel("campaign");Next(1);
                }
                if(phase==1 && world.MapId=="chapter_one")
                {CheckRoots();Check(Math.Abs(world.Position.x-116)<.01f,"Chapter1 spawn offset wrong");Capture("02-chapter-one");c.WorldTravel("next");Next(2);}
                if(phase==2 && world.MapId=="chapter_two")
                {CheckRoots();Check(Math.Abs(world.Position.x-226)<.01f,"Chapter2 spawn offset wrong");Capture("03-chapter-two");c.WorldTravel("previous");Next(3);}
                if(phase==3 && world.MapId=="chapter_one")
                {CheckRoots();Check(Math.Abs(world.Position.x-163)<.01f,"Return spawn offset wrong");c.WorldTravel("town");Next(4);}
                if(phase==4 && world.MapId=="town" && c.Snapshot.Account.HeroDesk.All(h=>h.Level==40))
                {
                    var exe=Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/Player/ZatodLegend.exe");
                    var info=new System.Diagnostics.ProcessStartInfo(exe){UseShellExecute=false,CreateNoWindow=true,WindowStyle=System.Diagnostics.ProcessWindowStyle.Hidden};
                    var args=new[]{"-batchmode","-nographics","--zatod-port","17996","--zatod-smoke","world_right","--zatod-profile","world-battle-spectator-"+Guid.NewGuid().ToString("N"),"-logFile",Path.Combine(folder,"peer.log")};info.Arguments=string.Join(" ",args.Select(arg=>"\""+arg+"\""));
                    peerProcess=System.Diagnostics.Process.Start(info);Next(5);
                }
                if(phase==5 && c.WorldPlayers.Length>1){c.Campaign("chapter_one_stage_1",heroes);Next(6);}
                if(phase==6 && controller.Phase==ZatodScenePhase.InBattle && controller.Stage.UnitCount>0)
                {
                    CheckRoots();Check(SceneManager.sceneCount==2,"Battle is not an additive scene");Check(!worldCamera.enabled,"World camera still renders during battle");
                    Check(controller.Stage.GetComponentsInChildren<UnityEngine.UI.Image>(true).Length==0,"Combat actors still rendered as UI Images");
                    Check(controller.Stage.GetComponentsInChildren<SpriteRenderer>(true).Any(r=>r.enabled && r.sprite!=null),"Battle world renderers missing");
                    Check(world.transform.Find("ZatodMap_town").gameObject.activeInHierarchy,"Battle disabled world root");Capture("04-campaign-battle");Next(7);
                }
                if(phase==7)
                {
                    var peer=c.WorldPlayers.FirstOrDefault(p=>p.ConnectionId!=c.WorldSelfId);
                    if(peer!=null){if(!float.IsNaN(lastPeer) && Math.Abs(peer.Y-lastPeer)>.00001f)peerMoves++;lastPeer=peer.Y;}
                    if(c.LastReplay!=null && c.Battle?.Finished==true)
                    {recorded=c.LastReplay;Check(recorded.Winner==0,"Campaign failed");Check(peerMoves>1,"Other player/world did not continue during battle");Check(c.Snapshot.StarsFor("chapter_one_stage_1")==3,"Campaign checker/stars missing");Capture("05-validated");hud.Continue.onClick.Invoke();Next(8);}
                }
                if(phase==8 && controller.Phase==ZatodScenePhase.World)
                {
                    CheckRoots();Check(SceneManager.sceneCount==1,"Battle scene not unloaded");Check(worldCamera.enabled && world.MapId=="town","World camera/map not restored");
                    Check(UnityEngine.Object.FindObjectsByType<ZatodBattleSprite>().Length==0,"Battle renderer leaked after return");Capture("06-return");c.Arena(heroes);Next(9);
                }
                if(phase==9 && controller.Phase==ZatodScenePhase.InBattle && controller.Stage.UnitCount>0)
                {Capture("07-arena");CheckRoots();Next(10);}
                if(phase==10 && EditorApplication.timeSinceStartup-at>2)
                {typeof(ZatodPrototypeView).GetMethod("Show",flags).Invoke(host,new object[]{"campaign"});c.Cancel();Next(11);}
                if(phase==11 && controller.Phase==ZatodScenePhase.World)BeginReplay();
                if(phase==12 && controller.Phase==ZatodScenePhase.InBattle && controller.Stage.UnitCount>0)
                {
                    graphs=controller.Stage.GetComponentsInChildren<ZatodBattleSprite>(true).Select(s=>(PlayableGraph)typeof(ZatodBattleSprite).GetField("graph",flags).GetValue(s)).ToArray();
                    Check(graphs.Length>0 && graphs.All(g=>g.IsValid()),"Live battle animation graphs missing");Capture("08-replay-"+cycles);Next(13);
                }
                if(phase==13 && EditorApplication.timeSinceStartup-at>.6)
                {typeof(ZatodPrototypeView).GetMethod("Show",flags).Invoke(host,new object[]{"campaign"});Next(14);}
                if(phase==14 && controller.Phase==ZatodScenePhase.World)
                {
                    CheckRoots();Check(graphs.All(g=>!g.IsValid()),"Animation graph leaked after scene unload");Check(SceneManager.sceneCount==1,"Replay scene leak");
                    cycles++;if(cycles<3)BeginReplay();else{controller.Enter();controller.Leave();Next(15);}
                }
                if(phase==15 && controller.Phase==ZatodScenePhase.World && EditorApplication.timeSinceStartup-at>.8)
                {CheckRoots();Check(SceneManager.sceneCount==1,"Cancel-during-load leaked battle scene");Check(worldCamera.enabled,"Cancel-during-load lost world camera");Finish();}
            }
            catch(Exception e){Finish(e.ToString());}
        };
        File.WriteAllText(Path.Combine(folder,"result.json"),"{\"Result\":\"RUNNING\"}");EditorApplication.update+=tick;
        return new{Status="ARMED",Folder=folder};
    }
}
