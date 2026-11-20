using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEngine;
using Zatod.Networking;
using Zatod.Presentation;
var folder=Path.GetFullPath("../Artifacts/ZatodStagePreviewChecks");
var prior=JsonUtility.FromJson<Previous>(File.ReadAllText(Path.Combine(folder,"network.json")));
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();c.Port=7793;c.GetComponent<Mirror.TelepathyTransport>().port=7793;c.DevelopmentProfile=prior.Profile;c.Connect();
double began=Time.realtimeSinceStartupAsDouble;
while(c.Snapshot==null && Time.realtimeSinceStartupAsDouble-began<20)await UnityEngine.Awaitable.NextFrameAsync();
if(c.Snapshot==null)throw new Exception("Reset test did not connect: "+c.Status);
bool passed=c.Snapshot.Cleared.Count==0 && c.Snapshot.StageStars.Count==0 && c.Snapshot.StarsFor("chapter_one_stage_1")==0 && c.Snapshot.Account.HeroDesk.All(h=>h.Level==40);
var host=c.GetComponent<ZatodPrototypeView>();host.GetType().GetMethod("OpenStagePreview",BindingFlags.Instance|BindingFlags.NonPublic).Invoke(host,new object[]{"chapter_one_stage_1"});
var popup=UnityEngine.Object.FindAnyObjectByType<ZatodStagePreviewView>();passed &= popup.StarCount==0 && !popup.Raid.interactable;
var result=new ResetReport{Passed=passed,Stars=c.Snapshot.StarsFor("chapter_one_stage_1"),Cleared=c.Snapshot.Cleared.Count,OwnedHeroes=c.Snapshot.Account.HeroDesk.Count,OwnedLevelsPreserved=c.Snapshot.Account.HeroDesk.All(h=>h.Level==40),PreviousStars=prior.Stars,Profile=prior.Profile};
File.WriteAllText(Path.Combine(folder,"new-launch-reset.json"),JsonUtility.ToJson(result,true));if(!passed)throw new Exception("New launch did not reset stars/preserve owned Heroes");return result;
[Serializable] public class Previous {public string Profile;public int Stars;}
[Serializable] public class ResetReport {public bool Passed,OwnedLevelsPreserved;public int Stars,PreviousStars,Cleared,OwnedHeroes;public string Profile;}
