using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using Zatod.Presentation;
using Zatod.Combat;
var connection=UnityEngine.Object.FindAnyObjectByType<Zatod.Networking.CrystalConnection>();
if(connection.Snapshot==null)throw new Exception("Connect the UI verification profile first.");
int smooth=0,maxSprites=0,maxEffects=0;bool anyImage=false,validated=false;
var previous=new Dictionary<ReplaySprite,Tuple<int,string,float>>();double started=EditorApplication.timeSinceStartup;
EditorApplication.CallbackFunction callback=null;
callback=()=>
{
    try
    {
        if(connection.Battle!=null)
        {
            int tick=connection.Battle.CurrentTick;
            var sprites=UnityEngine.Object.FindObjectsByType<ReplaySprite>();maxSprites=Math.Max(maxSprites,sprites.Length);
            maxEffects=Math.Max(maxEffects,sprites.Count(s=>s.name.StartsWith("Effect ")));
            foreach(var sprite in sprites)
            {
                var image=sprite.GetComponent<UnityEngine.UI.Image>();if(image!=null && image.enabled && image.sprite!=null)anyImage=true;
                var id=sprite;
                if(previous.TryGetValue(id,out var old) && old.Item1==tick && old.Item2==sprite.CurrentState && sprite.SampleSeconds>old.Item3+.000001f && sprite.CurrentState!="Idle" && sprite.CurrentState!="Move" && sprite.CurrentState!="Death")smooth++;
                previous[id]=Tuple.Create(tick,sprite.CurrentState,sprite.SampleSeconds);
            }
            validated=connection.LastReplay!=null && connection.LastReplay.Initial.Mode==CrystalMode.Campaign && connection.LastReplay.Completed;
        }
        if(EditorApplication.timeSinceStartup-started>25)
        {
            EditorApplication.update-=callback;
            string json="{\"SmoothSamplesWithinTick\":"+smooth+",\"MaxSprites\":"+maxSprites+",\"MaxEffects\":"+maxEffects+",\"ImageRendered\":"+anyImage.ToString().ToLowerInvariant()+",\"CampaignValidated\":"+validated.ToString().ToLowerInvariant()+"}";
            File.WriteAllText("../Artifacts/CrystalPhaseChecks/ui-final/runtime.json",json);
        }
    }
    catch(Exception error){EditorApplication.update-=callback;File.WriteAllText("../Artifacts/CrystalPhaseChecks/ui-final/runtime-error.txt",error.ToString());}
};
EditorApplication.update+=callback;
UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name=="Ải 1\n3 wave").onClick.Invoke();
return "Capturing live sprite sampling and campaign UI for 25 seconds";
