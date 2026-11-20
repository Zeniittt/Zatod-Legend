using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using Zatod.Presentation;
using Zatod.Networking;
using Zatod.Combat;
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var v=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
if(c.Snapshot==null)throw new Exception("UI test profile not connected.");
UnityEngine.UI.Button Button(string name)=>UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name==name);
var flags=System.Reflection.BindingFlags.Instance|System.Reflection.BindingFlags.NonPublic;
bool Visible()=>((RectTransform)v.GetType().GetField("stage",flags).GetValue(v)).gameObject.activeSelf;
int phase=0;double started=EditorApplication.timeSinceStartup,requestedAt=0;
EditorApplication.CallbackFunction callback=null;
callback=()=>
{
    try
    {
        if(EditorApplication.timeSinceStartup-started>40)throw new Exception("UI regression timeout: "+phase+" "+c.Status);
        if(phase==0 && c.Battle!=null && c.Battle.CurrentTick>=8){Button("Hero / Đồ").onClick.Invoke();phase=1;}
        if(phase==1 && c.LastReplay!=null && c.Battle!=null && c.Battle.Finished)
        {
            Button("Replay").onClick.Invoke();phase=2;return;
        }
        if(phase==2){Button(c.LastReplay.Initial.BattleId).onClick.Invoke();requestedAt=EditorApplication.timeSinceStartup;phase=3;return;}
        if(phase==3 && EditorApplication.timeSinceStartup-requestedAt>.5)
        {
            if(!Visible())throw new Exception("History replay did not open");
            Button("Tạm dừng").onClick.Invoke();var slider=UnityEngine.Object.FindAnyObjectByType<UnityEngine.UI.Slider>();slider.value=.5f;
            var replay=(ZatodBattleSimulation)v.GetType().GetField("replay",flags).GetValue(v);
            if(replay.CurrentTick!=Mathf.RoundToInt(c.LastReplay.EndTick*.5f))throw new Exception("Replay seek mismatch");
            Button("Tốc độ").onClick.Invoke();Button("Tốc độ").onClick.Invoke();
            if((float)v.GetType().GetField("speed",flags).GetValue(v)!=4)throw new Exception("Speed control failed");
            var button=Button("Replay");var corners=new Vector3[4];((RectTransform)button.transform).GetWorldCorners(corners);
            var pointer=new UnityEngine.EventSystems.PointerEventData(UnityEngine.EventSystems.EventSystem.current){position=RectTransformUtility.WorldToScreenPoint(null,(corners[0]+corners[2])*.5f)};
            var hits=new List<UnityEngine.EventSystems.RaycastResult>();UnityEngine.EventSystems.EventSystem.current.RaycastAll(pointer,hits);
            if(hits.Count==0 || hits[0].gameObject.GetComponentInParent<UnityEngine.UI.Button>()!=button)throw new Exception("Navigation button is blocked by another graphic");
            if(UnityEngine.Object.FindObjectsByType<AudioListener>().Length!=1)throw new Exception("Audio listener coverage mismatch");
            File.WriteAllText("../Artifacts/CrystalPhaseChecks/ui-final/regression.json","{\"HiddenBattleHandled\":true,\"HistoryReplayVisible\":true,\"SeekTick\":"+replay.CurrentTick+",\"Speed\":4,\"RaycastPassed\":true,\"AudioListeners\":1}");
            EditorApplication.update-=callback;
        }
    }
    catch(Exception error){EditorApplication.update-=callback;File.WriteAllText("../Artifacts/CrystalPhaseChecks/ui-final/regression-error.txt",error.ToString());}
};
EditorApplication.update+=callback;
Button("Ải 1\n3 wave").onClick.Invoke();
return "UI regression started: hidden battle, remote history, seek, speed, raycast and audio";
