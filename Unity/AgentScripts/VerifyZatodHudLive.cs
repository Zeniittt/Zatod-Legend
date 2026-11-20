using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using Zatod.Networking;
using Zatod.Combat;
using Zatod.Presentation;
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var v=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();var hud=(ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud",BindingFlags.Instance|BindingFlags.NonPublic).GetValue(v);
var flags=BindingFlags.Instance|BindingFlags.NonPublic;string folder=Path.GetFullPath("../Artifacts/ZatodPhaseChecks/hud-live");Directory.CreateDirectory(folder);
c.DevelopmentProfile="hud-check-"+Guid.NewGuid().ToString("N");c.Port=17990;c.GetComponent<Mirror.TelepathyTransport>().port=17990;c.Connect();
int phase=0,lastFrame=-1,frames=0,damageTexts=0,healTexts=0,energyTexts=0;bool portraits=false,lootZero=true,autoSent=false,validated=false,pauseStable=false,seekCorrect=false;double started=EditorApplication.timeSinceStartup,phaseStart=started;Vector2 paused=default;RectTransform root=null;int pauseFrame=0;
EditorApplication.CallbackFunction callback=null;
void Finish(string error=null)
{
    EditorApplication.update-=callback;
    var result=new{Result=error==null?"PASS":"FAIL",Error=error,Seconds=EditorApplication.timeSinceStartup-started,Frames=frames,Portraits=portraits,GoldChestZero=lootZero,DamageTexts=damageTexts,HealTexts=healTexts,EnergyTexts=energyTexts,AutoInputCount=c.LastReplay?.Inputs.Count??0,AutoSent=autoSent,ServerValidated=validated,PauseStable=pauseStable,SeekCorrect=seekCorrect};
    File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
}
callback=()=>
{
    try
    {
        if(!Application.isPlaying || EditorApplication.timeSinceStartup-started>140)throw new Exception("HUD test interrupted/timeout phase "+phase+" "+c.Status);
        if(lastFrame==Time.frameCount)return;lastFrame=Time.frameCount;frames++;
        if(phase==0 && c.Snapshot!=null){c.Campaign("chapter_one_stage_1",c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId));phase=1;return;}
        if(phase==1)
        {
            if(c.Battle==null)return;
            portraits=hud.Cards.All(card=>card.Portrait.sprite!=null);lootZero&=hud.GoldValue.text=="0" && hud.ChestValue.text=="0";
            foreach(Transform child in hud.Floating){if(child.name.StartsWith("Combat_damage"))damageTexts++;if(child.name.StartsWith("Combat_heal"))healTexts++;if(child.name.StartsWith("Combat_energy") || child.name.StartsWith("Combat_last_hit"))energyTexts++;}
            if(!autoSent && c.Battle.Frame().Units.Any(u=>u.EntityId<100 && u.Alive && u.Energy>=u.MaxEnergy))
            {ScreenCapture.CaptureScreenshot(Path.Combine(folder,"hud-ready.png"));hud.Auto.onClick.Invoke();autoSent=true;}
            if(c.Battle.Finished && c.LastReplay!=null)
            {
                validated=c.LastReplay.Completed && c.LastReplay.Digest==c.Battle.Replay().Digest;
                if(!portraits || !lootZero || !autoSent || !validated || c.LastReplay.Inputs.Count<1 || damageTexts<1 || energyTexts<1)throw new Exception("Incomplete HUD/Auto evidence");
                ScreenCapture.CaptureScreenshot(Path.Combine(folder,"hud-result.png"));phase=2;phaseStart=EditorApplication.timeSinceStartup;return;
            }
        }
        else if(phase==2 && EditorApplication.timeSinceStartup-phaseStart>.5)
        {hud.WatchReplay.onClick.Invoke();phase=3;phaseStart=EditorApplication.timeSinceStartup;return;}
        else if(phase==3 && EditorApplication.timeSinceStartup-phaseStart>2)
        {
            if(!hud.ReplayControls.gameObject.activeSelf)throw new Exception("Replay controls hidden");
            UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name=="Tạm dừng").onClick.Invoke();
            v.GetType().GetMethod("DrawBattle",flags).Invoke(v,null);
            root=(RectTransform)hud.Actors.GetChild(0);paused=root.anchoredPosition;pauseFrame=Time.frameCount;phase=4;return;
        }
        else if(phase==4 && Time.frameCount-pauseFrame>15)
        {
            pauseStable=(root.anchoredPosition-paused).sqrMagnitude<.000001;
            var slider=UnityEngine.Object.FindAnyObjectByType<UnityEngine.UI.Slider>();slider.value=.5f;
            var replay=(ZatodBattleSimulation)v.GetType().GetField("replay",flags).GetValue(v);seekCorrect=replay.CurrentTick==Mathf.RoundToInt(c.LastReplay.EndTick*.5f);
            var speed=UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name=="Tốc độ");speed.onClick.Invoke();speed.onClick.Invoke();
            UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name=="Tạm dừng").onClick.Invoke();phase=5;phaseStart=EditorApplication.timeSinceStartup;return;
        }
        else if(phase==5 && EditorApplication.timeSinceStartup-phaseStart>2)
        {if(!pauseStable || !seekCorrect || (float)v.GetType().GetField("speed",flags).GetValue(v)!=4)throw new Exception("Replay controls regression");Finish();}
    }
    catch(Exception e){Finish(e.ToString());}
};
EditorApplication.update+=callback;return new{Started=true,Output=folder};
