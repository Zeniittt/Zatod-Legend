using System;
using System.Collections;
using System.Reflection;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
if(UnityEditor.EditorApplication.isPlaying)throw new Exception("Run the gate check outside PlayMode.");
var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);var account=campaign.CreateDemoCharacter(catalog);
var match=ZatodMatchFactory.Versus(catalog,account.HeroDesk,account.HeroDesk,17,"warmup-probe",true);var simulation=new ZatodBattleSimulation(match);for(int i=0;i<5;i++)simulation.Step();
var type=typeof(ZatodConnection);var flags=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;var roomType=type.GetNestedType("RealtimeRoom",BindingFlags.NonPublic);var room=Activator.CreateInstance(roomType,true);
roomType.GetField("Left",flags).SetValue(room,17);roomType.GetField("Right",flags).SetValue(room,18);roomType.GetField("Simulation",flags).SetValue(room,simulation);
var go=new GameObject("WarmupGateProbe",typeof(Mirror.TelepathyTransport),typeof(ZatodConnection));int checks=0;
try
{
    var component=go.GetComponent<ZatodConnection>();((IList)type.GetField("rooms",flags).GetValue(component)).Add(room);
    var connection=new Mirror.NetworkConnectionToClient(17);var method=type.GetMethod("AcceptOperation",flags);
    void Send(int tick,params int[] actors)=>method.Invoke(component,new object[]{connection,new ZatodOperation{BattleId=match.BattleId,Tick=tick,Actors=new System.Collections.Generic.List<int>(actors)}});
    void Rejected(int tick,params int[] actors){bool rejected=false;try{Send(tick,actors);}catch(TargetInvocationException error){rejected=error.InnerException is ArgumentException;}if(!rejected)throw new Exception("Unexpectedly accepted stale/duplicate operation");checks++;}
    Send(1);checks++;Rejected(1,1);Send(6);checks++;Rejected(6);Rejected(0);
}
finally{UnityEngine.Object.DestroyImmediate(go);}
System.IO.File.WriteAllText("../Artifacts/CrystalPhaseChecks/warmup-gate.json","{\"Checks\":"+checks+",\"Result\":\"PASS\"}");
return new{status="PASS",checks};
