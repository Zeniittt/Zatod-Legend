using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Heroes;
using Zatod.Presentation;
using Zatod.Networking;
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var host=c.GetComponent<ZatodPrototypeView>();var flags=BindingFlags.Instance|BindingFlags.NonPublic;
var popup=(ZatodStagePreviewView)host.GetType().GetField("stagePreview",flags).GetValue(host);var formation=(ZatodFormationView)host.GetType().GetField("formation",flags).GetValue(host);
c.Port=7793;c.GetComponent<Mirror.TelepathyTransport>().port=7793;c.DevelopmentProfile="stage-preview-network-"+Guid.NewGuid().ToString("N");c.AutoUltimate=true;c.Connect();
string folder=Path.GetFullPath("../Artifacts/ZatodStagePreviewChecks");int phase=0;double began=EditorApplication.timeSinceStartup;EditorApplication.CallbackFunction callback=null;
void Finish(bool passed,string error="")
{
    EditorApplication.update-=callback;
    File.WriteAllText(Path.Combine(folder,"network.json"),JsonUtility.ToJson(new Report{Passed=passed,Error=error,Stars=c.Snapshot?.StarsFor("chapter_one_stage_1")??0,SnapshotStars=c.Snapshot?.StageStars.Count??0,ReplayStars=c.LastReplay?.Stars??0,Digest=c.LastReplay?.Digest.ToString(),Profile=c.DevelopmentProfile},true));
}
void Check(bool ok,string why){if(!ok)throw new Exception(why);}
void Click(UnityEngine.UI.Button b){Check(b.interactable,"Disabled "+b.name);ExecuteEvents.Execute(b.gameObject,new PointerEventData(EventSystem.current){button=PointerEventData.InputButton.Left},ExecuteEvents.pointerClickHandler);}
callback=()=>
{
    try
    {
        if(EditorApplication.timeSinceStartup-began>120)throw new Exception("Network preview timeout, phase="+phase+", status="+c.Status);
        if(phase==0 && c.Connected && c.Snapshot!=null && Guid.TryParse(c.Snapshot.Account.CharacterId,out _))
        {
            Check(c.Snapshot.StarsFor("chapter_one_stage_1")==0 && c.Snapshot.StageStars.Count==0,"New launch restored old stars");
            var selected=(System.Collections.Generic.List<string>)host.GetType().GetField("selected",flags).GetValue(host);selected.Clear();selected.AddRange(c.Snapshot.Account.HeroDesk.Take(5).Select(h=>h.HeroInstanceId));
            foreach(var hero in c.Snapshot.Account.HeroDesk)c.DevLevel(hero.HeroInstanceId,40);phase=1;
        }
        else if(phase==1 && c.Snapshot.Account.HeroDesk.All(h=>h.Level==40))
        {
            host.GetType().GetMethod("Show",flags).Invoke(host,new object[]{"campaign"});
            var map=UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name.StartsWith("Ải 1\n") && b.interactable);Click(map);
            Check(popup.gameObject.activeSelf && popup.StarCount==0,"Fresh preview missing/has stars");Click(popup.Challenge);
            Check(formation.gameObject.activeSelf && c.Battle==null,"Challenge started gameplay");Click(formation.Battle);phase=2;
        }
        else if(phase==2 && c.LastReplay!=null && c.Snapshot.StarsFor("chapter_one_stage_1")>0)
        {
            Check(c.LastReplay.Winner==0,"Test party lost");Check(c.LastReplay.Stars==c.Snapshot.StarsFor("chapter_one_stage_1"),"Server star count does not match validated replay");
            host.GetType().GetMethod("Show",flags).Invoke(host,new object[]{"campaign"});host.GetType().GetMethod("OpenStagePreview",flags).Invoke(host,new object[]{"chapter_one_stage_1"});
            Check(popup.StarCount==c.LastReplay.Stars,"Popup did not use account stars");Check(popup.Raid.interactable==(popup.StarCount==3),"Raid state does not match server stars");Finish(true);
        }
    }
    catch(Exception e){Finish(false,e.ToString());}
};EditorApplication.update+=callback;return "Network scenario running with an isolated development profile.";
[Serializable] public class Report {public bool Passed;public string Error,Digest,Profile;public int Stars,SnapshotStars,ReplayStars;}
