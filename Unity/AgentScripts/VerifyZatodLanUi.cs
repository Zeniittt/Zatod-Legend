using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEngine;
using UnityEditor;
using TMPro;
using Zatod.Networking;
using Zatod.Presentation;
using Zatod.Heroes;
using Zatod.World;
return await VerifyZatodLanUi.Run();
public static class VerifyZatodLanUi
{
 const BindingFlags F=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
 public static async Task<object> Run()
 {
  if(!Application.isPlaying)throw new Exception("Enter Play first");
  var client=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(client.Connected)throw new Exception("Isolated disconnected client required");
  var login=UnityEngine.Object.FindAnyObjectByType<ZatodLoginView>();var host=client.GetComponent<ZatodPrototypeView>();
  string oldProfile=client.DevelopmentProfile;ushort oldPort=client.Port;string profile="lan-ui-"+Guid.NewGuid().ToString("N");client.DevelopmentProfile=profile;
  var discovery=client.GetComponent<ZatodLanDiscovery>();var portField=discovery.GetType().BaseType.GetField("serverBroadcastListenPort",F);int oldDiscovery=(int)portField.GetValue(discovery);portField.SetValue(discovery,47779);
  var asm=typeof(Editor).Assembly;var vt=asm.GetType("UnityEditor.GameView");var game=EditorWindow.GetWindow(vt);var selected=vt.GetProperty("selectedSizeIndex",F);int oldSize=(int)selected.GetValue(game);
  var sizes=asm.GetType("UnityEditor.GameViewSizes");var singleton=sizes.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);var group=sizes.GetMethod("GetGroup").Invoke(singleton,new[]{Enum.Parse(asm.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});var gt=group.GetType();int initial=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);
  string folder=Path.GetFullPath("../Artifacts/ZatodLanLoginChecks/ui");Directory.CreateDirectory(folder);int checks=0;string error=null;
  void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
  async Task Wait(Func<bool> ok,string why)=>await Unity.Pipeline.Scripting.Wait.Until(ok,timeoutMs:20000,because:why);
  void Bounds(RectTransform rect){var points=new Vector3[4];rect.GetWorldCorners(points);var canvas=rect.GetComponentInParent<Canvas>();var area=((RectTransform)canvas.transform).rect;foreach(var p in points){var q=canvas.transform.InverseTransformPoint(p);Check(q.x>=area.xMin-1&&q.x<=area.xMax+1&&q.y>=area.yMin-1&&q.y<=area.yMax+1,"Control outside Canvas: "+rect.name);}}
  try
  {
   foreach(var profileSize in new[]{new[]{1600,900},new[]{2436,1125},new[]{2000,1200}})
   {
    var size=Activator.CreateInstance(asm.GetType("UnityEditor.GameViewSize"),F,null,new object[]{Enum.Parse(asm.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),profileSize[0],profileSize[1],"ZatodLanUiCheck"},null);int n=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);gt.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(game,n);game.Repaint();await Wait(()=>Screen.width==profileSize[0]&&Screen.height==profileSize[1],"login resize");
    login.PlayerName.text="   ";login.Refresh();Check(!login.ConnectButton.interactable,"Whitespace name should not connect");login.PlayerName.text="An Nguyễn";login.Refresh();Check(login.ConnectButton.interactable,"Valid guest name should connect");
    await Task.Delay(150);Canvas.ForceUpdateCanvases();Bounds(login.Board);Bounds((RectTransform)login.PlayerName.transform);Bounds((RectTransform)login.ConnectButton.transform);
    Check(!host.transform.GetComponentsInChildren<Transform>().Any(t=>t.name=="ConnectionAndFeatureControls"&&t.gameObject.activeInHierarchy),"Prototype connection screen still visible");
    ScreenCapture.CaptureScreenshot(Path.Combine(folder,"login-"+profileSize[0]+"x"+profileSize[1]+".png"));await Task.Delay(150);
   }
   login.ConnectButton.onClick.Invoke();await Wait(()=>client.Snapshot!=null&&client.WorldSelf!=null&&client.WorldSelf.Name=="An Nguyễn","LAN discovery and guest hello");
   Check(client.Port==17999,"Discovery ignored server-advertised port");Check(client.Address!="127.0.0.1","Discovery kept loopback instead of LAN sender");Check(!login.gameObject.activeSelf,"Login did not close after hello");
   var world=client.GetComponent<ZatodWorldView>();await Task.Delay(180);Check(world.MapId=="town","Guest did not enter shared town");Check(UnityEngine.Object.FindObjectsByType<TextMeshPro>().Any(t=>t.text=="An Nguyễn (You)"),"World name not shown");
   var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);var town=WorldDataJson.Load(campaign).Map("town");
   foreach(var id in new[]{"arena","pvp","history"})
   {
    var point=town.Interactions.Single(p=>p.TargetId==id);Check(point.VisualResource.StartsWith("npc_"),"Feature is not an NPC: "+id);world.Interact(point);await Task.Delay(160);
    Check(world.InputLocked(),"Feature did not lock avatar input");
    if(id=="history")
    {
     var feature=UnityEngine.Object.FindAnyObjectByType<ZatodFeatureView>();Check(feature.gameObject.activeSelf,"Replay NPC did not open archive");Bounds(feature.Board);
     ScreenCapture.CaptureScreenshot(Path.Combine(folder,"npc-"+id+".png"));await Task.Delay(150);feature.Back.onClick.Invoke();
    }
    else
    {
     var formation=UnityEngine.Object.FindAnyObjectByType<ZatodFormationView>();Check(formation.gameObject.activeSelf&&formation.SelectionMode==id,"Arena/PvP must use Campaign Formation view");
     Check(formation.StageId==null,"Duel UI must not invent a Campaign stage");Check(formation.Cost.text==""&&formation.Rewards.text==""&&formation.Description.text==""&&formation.Power.text=="","Unavailable duel fields must be blank");
     Check(formation.EnemyCards.All(c=>!c.Root.gameObject.activeSelf)&&!formation.PreviousWave.gameObject.activeSelf&&!formation.NextWave.gameObject.activeSelf,"Unavailable enemy/waves must be blank");
     Check(formation.RosterCards.Count==client.Snapshot.Account.HeroDesk.Count,"Shared roster lost owned Heroes");Bounds(formation.DesignRoot);
     formation.SetFilter(HeroPosition.Front);Check(formation.RosterCards.All(c=>catalog.Hero(client.Snapshot.Account.HeroDesk.Single(h=>h.HeroInstanceId==c.InstanceId).HeroDefinitionId).Position==HeroPosition.Front),"Shared position filter");formation.SetFilter(null);
     ScreenCapture.CaptureScreenshot(Path.Combine(folder,"npc-"+id+".png"));await Task.Delay(150);
     if(id=="pvp"){formation.Battle.onClick.Invoke();await Wait(()=>client.FindingPvp,"PvP queue from shared formation");Check(formation.Pending,"Queued team should remain locked");}
     formation.Back.onClick.Invoke();
    }
    await Task.Delay(100);Check(!client.FindingPvp,"Leaving NPC did not cancel queue");
   }
   Check(!client.LoginBusy,"Guest login remained busy");
  }
  catch(Exception e){error=e.ToString();}
  finally
  {
   client.Disconnect();await Task.Delay(150);client.DevelopmentProfile=oldProfile;client.Port=oldPort;client.GetComponent<Mirror.TelepathyTransport>().port=oldPort;discovery.StopDiscovery();portField.SetValue(discovery,oldDiscovery);
   PlayerPrefs.DeleteKey("ZatodPrototype.Account."+profile);PlayerPrefs.DeleteKey("ZatodPrototype.Name."+profile);PlayerPrefs.Save();
   selected.SetValue(game,oldSize);for(int n=(int)gt.GetMethod("GetTotalCount").Invoke(group,null)-1;n>=initial;n--)gt.GetMethod("RemoveCustomSize").Invoke(group,new object[]{n});game.Repaint();
  }
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error};File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return result;
 }
}
