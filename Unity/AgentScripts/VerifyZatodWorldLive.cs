using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.LowLevel;
using Zatod.Networking;
using Zatod.Presentation;
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var host=c.GetComponent<ZatodPrototypeView>();var world=c.GetComponent<ZatodWorldView>();
var flags=BindingFlags.Instance|BindingFlags.NonPublic;
var preview=(ZatodStagePreviewView)typeof(ZatodPrototypeView).GetField("stagePreview",flags).GetValue(host);
var formation=(ZatodFormationView)typeof(ZatodPrototypeView).GetField("formation",flags).GetValue(host);
var hud=(ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud",flags).GetValue(host);
string folder=Path.GetFullPath("../Artifacts/ZatodWorldChecks/live");Directory.CreateDirectory(folder);
c.DevelopmentProfile="world-ui-"+Guid.NewGuid().ToString("N");c.Port=17991;c.GetComponent<Mirror.TelepathyTransport>().port=17991;c.Connect();c.AutoUltimate=true;
int phase=0,frame=-1,checks=0,movingFrames=0;double start=EditorApplication.timeSinceStartup,at=start;Vector2 last=default,locked=default,returnPosition=default;bool completed=false;string mapId=null;
bool peerExpected=File.Exists(Path.Combine(folder,"expect-peer.flag")),peerSeen=false;int remoteInterpolatedFrames=0;float lastRemoteY=float.NaN,lastServerY=float.NaN;
void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
var inputSettings=InputSystem.settings;var oldBackground=inputSettings.backgroundBehavior;var oldEditorInput=inputSettings.editorInputBehaviorInPlayMode;
inputSettings.backgroundBehavior=InputSettings.BackgroundBehavior.IgnoreFocus;inputSettings.editorInputBehaviorInPlayMode=InputSettings.EditorInputBehaviorInPlayMode.AllDeviceInputAlwaysGoesToGameView;
Key[] heldKeys=Array.Empty<Key>();
Action applyInput=()=>{if(InputState.currentUpdateType==InputUpdateType.Dynamic && Keyboard.current!=null)InputState.Change(Keyboard.current,new KeyboardState(heldKeys),InputUpdateType.Dynamic);};
InputSystem.onAfterUpdate+=applyInput;
void Keys(params Key[] keys){heldKeys=keys;}
void Capture(string name){ScreenCapture.CaptureScreenshot(Path.Combine(folder,name+".png"));}
EditorApplication.CallbackFunction callback=null;
void Finish(string error=null){EditorApplication.update-=callback;InputSystem.onAfterUpdate-=applyInput;if(Keyboard.current!=null)InputState.Change(Keyboard.current,new KeyboardState(),InputUpdateType.Dynamic);inputSettings.backgroundBehavior=oldBackground;inputSettings.editorInputBehaviorInPlayMode=oldEditorInput;File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{Result=error==null?"PASS":"FAIL",Error=error,Checks=checks,MovingFrames=movingFrames,PeerExpected=peerExpected,PeerSeen=peerSeen,RemoteInterpolatedFrames=remoteInterpolatedFrames,Phase=phase,Map=world.MapId,Position=new{X=world.Position.x,Y=world.Position.y},Seconds=EditorApplication.timeSinceStartup-start,Completed=completed},Newtonsoft.Json.Formatting.Indented));}
void Next(int n){phase=n;at=EditorApplication.timeSinceStartup;}
callback=()=>
{
 try
 {
  if(!Application.isPlaying || EditorApplication.timeSinceStartup-start>180)throw new Exception("World live timeout/interrupted phase="+phase+" "+c.Status);
  if(frame==Time.frameCount)return;frame=Time.frameCount;
  var peer=c.WorldPlayers.FirstOrDefault(p=>p.ConnectionId!=c.WorldSelfId);
  if(peer!=null){var remote=world.transform.Find("Avatar_"+peer.ConnectionId);if(remote!=null){peerSeen=remote.GetComponentsInChildren<SpriteRenderer>().Length>0;float ry=remote.position.y;if(peer.Y==lastServerY && Math.Abs(ry-lastRemoteY)>.000001f)remoteInterpolatedFrames++;lastRemoteY=ry;lastServerY=peer.Y;}}
  if(phase==0 && c.WorldSelf!=null && c.Snapshot!=null)
  {Check(world.MapId=="town","Initial town missing");Capture("01-town");foreach(var h in c.Snapshot.Account.HeroDesk)c.DevLevel(h.HeroInstanceId,40);last=world.Position;Next(1);}
  if(phase==1)
  {
   Keys(Key.W);if(Vector2.Distance(world.Position,last)>.0001f)movingFrames++;last=world.Position;
   if(world.Nearby?.Id=="campaign"){Keys();if(peerExpected && (!peerSeen || remoteInterpolatedFrames<4))return;Check(world.InteractionButton.gameObject.activeSelf,"Near button absent");Capture("02-town-interaction");world.InteractionButton.onClick.Invoke();Next(2);}
  }
  if(phase==2 && world.MapId=="chapter_one")
  {Check(movingFrames>10,"World did not move each render frame");Capture("03-chapter-one");Next(3);}
  if(phase==3)
  {
   var target=new Vector2(9,8.1f);var d=target-world.Position;var keys=new System.Collections.Generic.List<Key>();if(d.x>.18)keys.Add(Key.D);if(d.x<-.18)keys.Add(Key.A);if(d.y>.18)keys.Add(Key.W);if(d.y<-.18)keys.Add(Key.S);Keys(keys.ToArray());
   if(d.magnitude<.35f){Keys();Check(world.Nearby?.Id=="stage_1","Stage entry proximity failed");world.InteractionButton.onClick.Invoke();Check(preview.gameObject.activeSelf && preview.Challenge.interactable,"Stage preview not opened/unlocked");locked=world.Position;Capture("04-stage-preview");Next(4);}
  }
  if(phase==4)
  {
   Keys(Key.W);Check(Vector2.Distance(world.Position,locked)<.001f,"Modal allowed avatar movement");
   if(EditorApplication.timeSinceStartup-at>.5){Keys();preview.Challenge.onClick.Invoke();Check(formation.gameObject.activeSelf,"Challenge failed to open formation");Capture("05-formation");Next(5);}
  }
  if(phase==5 && EditorApplication.timeSinceStartup-at>.4 && c.Snapshot.Account.HeroDesk.All(h=>h.Level==40))
  {returnPosition=world.Position;mapId=world.MapId;formation.Battle.onClick.Invoke();Next(6);}
  if(phase==6 && c.LastReplay!=null && c.Battle?.Finished==true && c.Snapshot.StarsFor("chapter_one_stage_1")==3)
  {completed=true;Check(c.LastReplay.Winner==0,"Private battle did not win");hud.Continue.onClick.Invoke();Next(7);}
  if(phase==7 && EditorApplication.timeSinceStartup-at>.5)
  {Check(world.MapId==mapId && Vector2.Distance(world.Position,returnPosition)<.001f,"Battle lost world return context");Capture("06-return-after-battle");Next(71);}
  if(phase==71 && EditorApplication.timeSinceStartup-at>.4){c.WorldTravel("next");Next(8);}
  if(phase==8 && world.MapId=="chapter_two")
  {Capture("07-chapter-two");Next(81);}
  if(phase==81 && EditorApplication.timeSinceStartup-at>.4){typeof(ZatodPrototypeView).GetMethod("OpenStagePreview",flags).Invoke(host,new object[]{"chapter_two_stage_1"});Check(preview.gameObject.activeSelf && !preview.Challenge.interactable,"Locked chapter2 challenge enabled");Capture("08-chapter-two-preview");Next(9);}
  if(phase==9 && EditorApplication.timeSinceStartup-at>.4){preview.Close.onClick.Invoke();Next(10);}
  if(phase==10 && EditorApplication.timeSinceStartup-at>.3){Check(world.MapId=="chapter_two" && world.Hud.gameObject.activeSelf,"Closing preview did not return world");Finish();}
 }
 catch(Exception error){Finish(error.ToString());}
};File.WriteAllText(Path.Combine(folder,"result.json"),"{\"Result\":\"RUNNING\"}");EditorApplication.update+=callback;
return new{Status="ARMED",Folder=folder};
