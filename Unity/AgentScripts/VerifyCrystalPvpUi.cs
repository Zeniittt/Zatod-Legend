using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Networking;
using Zatod.Combat;
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();
if(c.Snapshot==null)throw new Exception("Connect the UI PvP profile first.");
int phase=0,clicks=0,maxSprites=0;double started=EditorApplication.timeSinceStartup;
foreach(var hero in c.Snapshot.Account.HeroDesk)c.DevLevel(hero.HeroInstanceId,40);
EditorApplication.CallbackFunction callback=null;
callback=()=>
{
    try
    {
        if(EditorApplication.timeSinceStartup-started>150)throw new Exception("UI PvP timeout: "+c.Status);
        if(phase==0 && c.Snapshot.Account.HeroDesk.All(h=>h.Level==40))
        {
            UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name=="PvP online").onClick.Invoke();phase=1;return;
        }
        if(phase==1){UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name=="Tìm trận").onClick.Invoke();phase=2;return;}
        if(c.Battle!=null && c.Battle.Mode==ZatodMode.RealtimePvp && !c.Battle.Finished)
        {
            maxSprites=Math.Max(maxSprites,UnityEngine.Object.FindObjectsByType<Zatod.Presentation.ReplaySprite>().Length);
            foreach(var button in UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Where(b=>b.name.StartsWith("Actor ") && b.interactable)){button.onClick.Invoke();clicks++;}
        }
        if(phase==2 && c.LastReplay!=null && c.LastReplay.Initial.Mode==ZatodMode.RealtimePvp)
        {
            var replay=c.LastReplay;
            if(ZatodBattleSimulation.Resimulate(replay).Digest!=replay.Digest || !replay.Inputs.Any(i=>i.Team==c.Team) || !replay.Inputs.Any(i=>i.Team!=c.Team) || maxSprites<10)throw new Exception("Rendered PvP/replay/input coverage incomplete");
            File.WriteAllText("../Artifacts/CrystalPhaseChecks/ui-pvp-final/ui.result","PASS digest="+replay.Digest+" team="+c.Team+" inputClicks="+clicks+" committed="+replay.Inputs.Count+" maxSprites="+maxSprites);
            EditorApplication.update-=callback;
        }
    }
    catch(Exception error){EditorApplication.update-=callback;File.WriteAllText("../Artifacts/CrystalPhaseChecks/ui-pvp-final/ui-error.txt",error.ToString());}
};
EditorApplication.update+=callback;
return "Rendered PvP UI test queued";
