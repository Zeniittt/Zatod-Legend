using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;
return await VerifyZatodInventoryUi.Run();
public static class VerifyZatodInventoryUi
{
 const BindingFlags F=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
 public static async Task<object> Run()
 {
  if(!Application.isPlaying)throw new Exception("Enter Play first.");
  var client=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(client.Connected)throw new Exception("Disconnected fixture required.");
  var host=client.GetComponent<ZatodPrototypeView>();var c=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(c);var a=campaign.CreateDemoCharacter(c);var rules=ProgressionDataJson.LoadBundled();rules.Initialize(a,1000);CurrencyBalance.AddGold(a,9999999);
  foreach(var h in a.HeroDesk){h.Level=1;h.Exp=0;}
  var inventory=new ItemInventory(a,c);
  foreach(var item in c.Data.Items)inventory.AddItemByItemId(item.DefinitionId,item.ItemKind==ItemKind.Fragment?12:item.ItemKind==ItemKind.Soulstone?40:2);
  foreach(var id in new[]{"snk","tk","sp","med","om","sf"})if(!a.HeroDesk.Any(h=>h.HeroDefinitionId==id))a.HeroDesk.Add(c.CreateHero(id,Guid.NewGuid().ToString("D")));
  a.Level=38;int number=0;foreach(var hero in a.HeroDesk){hero.Level=number==2?8:number==3?26:30+number%8;hero.Stars=hero.HeroDefinitionId=="lina"||hero.HeroDefinitionId=="snk"?1:2+number%2;hero.RankId=c.Hero(hero.HeroDefinitionId).Ranks[Math.Min(3,number%4)].Id;number++;}
  a.Inventory.RemoveAll(i=>c.Item(i.ItemId).ItemKind==ItemKind.Soulstone&&!a.HeroDesk.Any(h=>c.Hero(h.HeroDefinitionId).SoulstoneItemId==i.ItemId));
  inventory.AddItemByItemId(c.Hero("bone").SoulstoneItemId,3);inventory.AddItemByItemId(c.Hero("axe").SoulstoneItemId,4);
  inventory.AddItemByItemId("exp_potion",100);inventory.AddItemByItemId("boxing_gloves_of_strength",100);
  typeof(ZatodConnection).GetProperty("Snapshot",F).SetValue(client,new ZatodAccountSnapshot{Account=a,ServerTime=1000});
  host.OpenInventory();var v=UnityEngine.Object.FindAnyObjectByType<ZatodInventoryView>();
  int checks=0;void Check(bool yes,string why){checks++;if(!yes)throw new Exception(why);}
  var asm=typeof(Editor).Assembly;var vt=asm.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(vt);var selected=vt.GetProperty("selectedSizeIndex",F);int old=(int)selected.GetValue(view);
  var sizes=asm.GetType("UnityEditor.GameViewSizes");var singleton=sizes.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);
  var group=sizes.GetMethod("GetGroup").Invoke(singleton,new[]{Enum.Parse(asm.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});var gt=group.GetType();int initial=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);
  string folder=Path.GetFullPath("../Artifacts/ZatodInventoryChecks/ui");Directory.CreateDirectory(folder);string error=null;
  try
  {
   foreach(var profile in new[]{new[]{1600,900},new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
   {
    var size=Activator.CreateInstance(asm.GetType("UnityEditor.GameViewSize"),F,null,new object[]{Enum.Parse(asm.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),profile[0],profile[1],"ZatodInventoryTest"},null);
    int index=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);gt.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,index);view.Repaint();
    await Unity.Pipeline.Scripting.Wait.Until(()=>Screen.width==profile[0]&&Screen.height==profile[1],timeoutMs:8000,because:"Inventory responsive resize");
    foreach(InventoryTab tab in Enum.GetValues(typeof(InventoryTab)))
    {
     v.SelectTab(tab);await Task.Delay(180);Canvas.ForceUpdateCanvases();
     Check(v.VisibleItemCount==(tab==InventoryTab.Soulstones?c.Data.Heroes.Count:a.Inventory.Where(x=>c.Item(x.ItemId).InventoryTab==tab).Select(x=>x.ItemId).Distinct().Count()),"Each item type must get one stack cell");
     Check(v.PooledCellCount<=56,"Grid must virtualize");Check(v.TotalItemCount==a.Inventory.Count(x=>c.Item(x.ItemId).InventoryTab==tab),"Stack counts must retain every owned GUID");Check(v.Description.text.Length>0,"Item detail missing");if(tab==InventoryTab.Soulstones){Check(v.OwnedHeroCardCount==a.HeroDesk.Count,"Owned Hero section missing");Check(v.GridContent.Find("HeroesNotOwned")!=null,"Unowned Hero separator missing");Check(v.GridContent.GetComponentsInChildren<Transform>().Any(t=>t.name=="HeroCard"),"Soulstones must show Hero cards");}
     foreach(var rect in new[]{v.Board,v.Detail,(RectTransform)v.Grid.transform,v.CurrencyRow})
     {var corners=new Vector3[4];rect.GetWorldCorners(corners);foreach(var corner in corners)Check(new Rect(((RectTransform)v.transform).rect.xMin-1,((RectTransform)v.transform).rect.yMin-1,((RectTransform)v.transform).rect.width+2,((RectTransform)v.transform).rect.height+2).Contains(v.transform.InverseTransformPoint(corner)),"Inventory control outside safe area: "+rect.name);}
     foreach(var image in v.GetComponentsInChildren<UnityEngine.UI.Image>().Where(i=>i.name=="Quality"||i.name=="Icon"))Check(image.sprite!=null,"Native icon missing: "+image.transform.parent.name);
     if(profile[0]==1600&&profile[1]==900){ScreenCapture.CaptureScreenshot(Path.Combine(folder,"reference-final-"+tab+".png"));await Task.Delay(160);}
    }
    v.Grid.verticalNormalizedPosition=0;await Task.Delay(100);Check(v.PooledCellCount<=56,"Scroll allocated all inventory cells");
    v.SelectTab(InventoryTab.Gears);v.ShowSell(2);Check(v.Board.Find("InventoryModal/Panel/Amount").GetComponent<TMPro.TextMeshProUGUI>().text=="2","Stack sale quantity selector missing");v.Board.Find("InventoryModal/Panel/Close").GetComponent<UnityEngine.UI.Button>().onClick.Invoke();
    v.SelectTab(InventoryTab.Items);v.ShowExp(a.HeroDesk[0].HeroInstanceId);await Task.Delay(150);
    Check(v.Board.Find("InventoryModal/Panel/HeroAndTarget/Target")!=null,"EXP level selector missing");Check(v.Board.Find("InventoryModal/Panel").GetComponentsInChildren<Transform>().Any(t=>t.name.StartsWith("Exp_")),"EXP consumption preview missing");
    if(profile[0]==1600&&profile[1]==900){ScreenCapture.CaptureScreenshot(Path.Combine(folder,"reference-final-exp.png"));await Task.Delay(160);}
    v.Board.Find("InventoryModal/Panel/Close").GetComponent<UnityEngine.UI.Button>().onClick.Invoke();v.SelectTab(InventoryTab.Shards);
    v.Board.Find("Filters/QuickCraft").GetComponent<UnityEngine.UI.Button>().onClick.Invoke();Check(v.Board.Find("InventoryModal/Panel/SelectAll")!=null,"Quick Craft selector missing");
    if(profile[0]==1600&&profile[1]==900){ScreenCapture.CaptureScreenshot(Path.Combine(folder,"reference-final-quickcraft.png"));await Task.Delay(160);}
    v.Board.Find("InventoryModal/Panel/Close").GetComponent<UnityEngine.UI.Button>().onClick.Invoke();
   }
   v.SelectTab(InventoryTab.Soulstones);int before=a.Inventory.Count;
   var zero=c.Data.Heroes.First(d=>!a.HeroDesk.Any(h=>h.HeroDefinitionId==d.Id)&&!a.Inventory.Any(i=>i.ItemId==d.SoulstoneItemId));
   var entries=(System.Collections.IEnumerable)typeof(ZatodInventoryView).GetField("items",F).GetValue(v);
   var zeroEntry=entries.Cast<object>().First(e=>(string)e.GetType().GetField("ItemId").GetValue(e)==zero.SoulstoneItemId);
   Check(zeroEntry.GetType().GetField("Id").GetValue(zeroEntry)==null,"Catalog card must not invent a GUID");Check(v.DisplayedAmount(zero.SoulstoneItemId)==0,"Zero-stone Hero count must remain zero");
   var ready=v.GridContent.GetComponentsInChildren<Transform>().First(t=>t.name=="ReadyText").GetComponent<TMPro.TextMeshProUGUI>();
   Check(ready.text=="Star-Up","Owned ready Hero banner missing");var cell=ready.GetComponentsInParent<UnityEngine.UI.Button>().First(b=>b.name=="InventoryCell");cell.onClick.Invoke();cell.onClick.Invoke();
   Check(v.Board.Find("InventoryModal/Panel/Confirm")!=null,"Ready Hero must open upgrade confirmation");v.Board.Find("InventoryModal/Panel/Close").GetComponent<UnityEngine.UI.Button>().onClick.Invoke();
   Check(a.Inventory.Count==before,"Catalog UI must not mutate raw Inventory");
   selected.SetValue(view,initial);view.Repaint();await Unity.Pipeline.Scripting.Wait.Until(()=>Screen.width==1600&&Screen.height==900,timeoutMs:8000,because:"Roster reference capture");
   host.OpenHeroRoster();var roster=UnityEngine.Object.FindAnyObjectByType<ZatodHeroRosterView>();await Task.Delay(160);
   var planned=new InventoryCatalog(c);int expected=a.HeroDesk.Count(h=>planned.HasUpgradeStones(a,h));
   Check(roster.Content.GetComponentsInChildren<Transform>().Count(t=>t.name=="StarReady")==expected,"Roster Star-Up count must match real stones");
   ScreenCapture.CaptureScreenshot(Path.Combine(folder,"reference-final-hero-roster.png"));await Task.Delay(160);
   var upgraded=a.HeroDesk.First(h=>planned.HasUpgradeStones(a,h));string stone=c.Hero(upgraded.HeroDefinitionId).SoulstoneItemId;var saved=a.Inventory.Where(i=>i.ItemId==stone).ToArray();a.Inventory.RemoveAll(i=>i.ItemId==stone);a.Revision++;roster.Refresh(a);await Task.Delay(100);
   Check(roster.Content.Find("Hero_"+upgraded.HeroInstanceId+"/Portrait/Icon/StarReady")==null,"Roster badge must disappear after stones consumed");
   a.Inventory.AddRange(saved);a.Revision++;roster.Refresh(a);await Task.Delay(100);Check(roster.Content.Find("Hero_"+upgraded.HeroInstanceId+"/Portrait/Icon/StarReady")!=null,"Roster badge must return after stones received");
   int previous=upgraded.Stars;upgraded.Stars=planned.MaxStars;a.Revision++;roster.Refresh(a);await Task.Delay(100);Check(roster.Content.Find("Hero_"+upgraded.HeroInstanceId+"/Portrait/Icon/StarReady")==null,"Max star Hero must not show Star-Up");upgraded.Stars=previous;roster.gameObject.SetActive(false);
   v.gameObject.SetActive(true);
   a.Inventory.Clear();a.Revision++;v.Refresh(a);v.SelectTab(InventoryTab.Items);Check(v.VisibleItemCount==0&&v.Description.text=="No items","Empty inventory must not fabricate cells");
   v.gameObject.SetActive(false);host.OpenHeroDetail(a.HeroDesk[0].HeroInstanceId);host.OpenHeroExperience(a.HeroDesk[0].HeroInstanceId);await Task.Delay(150);Check(v.ExperienceOnly&&!v.transform.Find("Background").gameObject.activeSelf,"Hero EXP popup has wrong backdrop");
  }
  catch(Exception e){error=e.ToString();}
  finally
  {v.gameObject.SetActive(false);selected.SetValue(view,old);for(int n=(int)gt.GetMethod("GetTotalCount").Invoke(group,null)-1;n>=initial;n--)gt.GetMethod("RemoveCustomSize").Invoke(group,new object[]{n});view.Repaint();typeof(ZatodConnection).GetProperty("Snapshot",F).SetValue(client,null);}
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error};File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return result;
 }
}
