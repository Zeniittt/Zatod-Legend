using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEngine;
using Zatod.Heroes;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;
return await VerifyZatodInventoryNetwork.Run();
public static class VerifyZatodInventoryNetwork
{
 const BindingFlags F=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
 public static async Task<object> Run()
 {
  if(!Application.isPlaying)throw new Exception("Enter Play first.");var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(c.Connected)throw new Exception("Use isolated client.");
  var catalog=HeroDataJson.LoadBundledCatalog();var planner=new InventoryCatalog(catalog);var campaign=CampaignDataJson.LoadZatod(catalog);var owned=campaign.CreateDemoCharacter(catalog);owned.CharacterId=Guid.NewGuid().ToString("D");
  var rules=ProgressionDataJson.LoadBundled();rules.Initialize(owned,DateTimeOffset.UtcNow.ToUnixTimeSeconds());CurrencyBalance.AddGold(owned,9999999);owned.Level=5;foreach(var h in owned.HeroDesk){h.Level=1;h.Exp=0;}
  var inv=new ItemInventory(owned,catalog);inv.AddItemByItemId("exp_potion",30);var sale=inv.AddItemByItemId("boxing_gloves_of_strength",3)[0];
  var recipe=catalog.Data.CraftRecipes.First(r=>r.Ingredients.Count==1&&catalog.Item(r.Ingredients[0].ItemId).ItemKind==ItemKind.Fragment);inv.AddItemByItemId(recipe.Ingredients[0].ItemId,recipe.Ingredients[0].Amount*2+1);
  var def=catalog.Data.Heroes.First(h=>!owned.HeroDesk.Any(x=>x.HeroDefinitionId==h.Id));inv.AddItemByItemId(def.SoulstoneItemId,planner.Rule(def.InitialStars).SummonStones+planner.Rule(def.InitialStars+1).UpgradeStones);
  string folder=Path.GetFullPath("../Artifacts/ZatodInventoryChecks/network");Directory.CreateDirectory(Path.Combine(folder,"server","Owned"));string ownedPath=Path.Combine(folder,"server","Owned",owned.CharacterId+".json");File.WriteAllText(ownedPath,HeroDataJson.WriteCharacter(owned,catalog));
  string previousProfile=c.DevelopmentProfile;ushort oldPort=c.Port;string profile="inventory-check-"+Guid.NewGuid().ToString("N");PlayerPrefs.SetString("ZatodPrototype.Account."+profile,owned.CharacterId);PlayerPrefs.Save();c.DevelopmentProfile=profile;c.Port=17996;c.GetComponent<Mirror.TelepathyTransport>().port=17996;
  int checks=0;string error=null;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
  async Task Until(Func<bool> ok,string why){await Unity.Pipeline.Scripting.Wait.Until(ok,timeoutMs:12000,because:why);}
  async Task<ItemOperationReceipt> Execute(InventoryPlan plan,string target,int level=0)
  {
   int count=c.Snapshot.Account.ItemOperations.Count;c.InventoryAction(plan.Command,target,level,InventoryCatalog.Signature(plan));
   await Until(()=>!c.ItemOperationBusy&&c.Snapshot.Account.ItemOperations.Count==count+1,"receipt for "+plan.Command);return c.Snapshot.Account.ItemOperations.Last();
  }
  try
  {
   c.Connect();await Until(()=>c.Connected&&c.Snapshot?.Account.CharacterId==owned.CharacterId,"isolated inventory account");Check(c.Snapshot.Account.Inventory.Count==owned.Inventory.Count,"Server fixture mismatch");
   var host=c.GetComponent<ZatodPrototypeView>();host.OpenInventory();var view=UnityEngine.Object.FindAnyObjectByType<ZatodInventoryView>();Check(view.gameObject.activeSelf,"Inventory shortcut flow");
   var p=planner.Sell(c.Snapshot.Account,sale.Id,2);long gold=CurrencyBalance.GetGold(c.Snapshot.Account);var receipt=await Execute(p,sale.Id,2);
   Check(!c.Snapshot.Account.Inventory.Any(x=>x.Id==sale.Id)&&CurrencyBalance.GetGold(c.Snapshot.Account)==gold+p.GoldReward,"Server Sell gold/GUID");
   var snapshot=c.Snapshot;c.Request(new ZatodRequest{Command="sell",A=sale.Id,B=InventoryCatalog.Signature(p),Number=2,OperationId=receipt.OperationId});await Until(()=>!ReferenceEquals(c.Snapshot,snapshot),"duplicate Sell reply");Check(c.Snapshot.Account.ItemOperations.Count==1&&CurrencyBalance.GetGold(c.Snapshot.Account)==gold+p.GoldReward,"Sell duplicate credited twice");
   p=planner.QuickCraft(c.Snapshot.Account,new[]{recipe.Id});receipt=await Execute(p,p.TargetId);Check(receipt.Created.Count==2*recipe.OutputAmount&&receipt.Created.Select(x=>x.Id).Distinct().Count()==receipt.Created.Count,"Quick Craft output distinct GUIDs");Check(c.Snapshot.Account.Inventory.Count(x=>x.ItemId==recipe.Ingredients[0].ItemId)==1,"Quick Craft remainder");
   string heroId=c.Snapshot.Account.HeroDesk[0].HeroInstanceId;p=planner.Exp(c.Snapshot.Account,heroId,2,rules);receipt=await Execute(p,heroId,p.TargetLevel);Check(receipt.Experience!=null&&c.Snapshot.Account.HeroDesk[0].Level==p.TargetLevel,"Server Hero EXP result");Check(receipt.Consumed.All(x=>x.ItemId=="exp_potion"),"EXP priority changed");
   p=planner.Stone(c.Snapshot.Account,def.Id,true);receipt=await Execute(p,def.Id);var hero=c.Snapshot.Account.HeroDesk.Single(x=>x.HeroDefinitionId==def.Id);Check(hero.Stars==def.InitialStars&&hero.Level==1&&hero.Exp==0,"Server Recruit progress");
   int stars=hero.Stars;p=planner.Stone(c.Snapshot.Account,def.Id,false);receipt=await Execute(p,def.Id);hero=c.Snapshot.Account.HeroDesk.Single(x=>x.HeroDefinitionId==def.Id);Check(hero.Stars==stars+1,"Server Star Up");
   var disk=HeroDataJson.ReadCharacter(File.ReadAllText(ownedPath),catalog);Check(disk.HeroDesk.Single(x=>x.HeroDefinitionId==def.Id).Stars==stars+1&&disk.ItemOperations.Count==5,"Saved Hero/receipts");
   string[] guids=c.Snapshot.Account.Inventory.Select(x=>x.Id).ToArray();gold=CurrencyBalance.GetGold(c.Snapshot.Account);string signature=InventoryCatalog.Signature(p);var finalReceipt=receipt;
   c.Disconnect();await Until(()=>!c.Connected,"disconnect");await Task.Delay(250);c.Connect();await Until(()=>c.Connected&&c.Status.StartsWith("Connected")&&c.Snapshot.Account.CharacterId==owned.CharacterId,"reconnect");Check(c.Snapshot.Account.Inventory.Select(x=>x.Id).SequenceEqual(guids)&&CurrencyBalance.GetGold(c.Snapshot.Account)==gold,"Reconnect preserved inventory and gold");
   snapshot=c.Snapshot;c.Request(new ZatodRequest{Command="star_up",A=def.Id,B=signature,OperationId=finalReceipt.OperationId});await Until(()=>!ReferenceEquals(c.Snapshot,snapshot),"Star Up retry after reconnect");Check(c.Snapshot.Account.ItemOperations.Count==5&&c.Snapshot.Account.HeroDesk.Single(x=>x.HeroDefinitionId==def.Id).Stars==stars+1&&CurrencyBalance.GetGold(c.Snapshot.Account)==gold,"Star Up retry consumed again");
   p=planner.Sell(c.Snapshot.Account,c.Snapshot.Account.Inventory.First().Id);string stale=InventoryCatalog.Signature(p);c.AddItemByItemId("boxing_gloves_of_strength");await Until(()=>c.Snapshot.Account.Inventory.Count==guids.Length+1,"dev grant for stale preview");
   c.InventoryAction("sell",p.ItemInstanceId,0,stale);await Until(()=>!c.ItemOperationBusy&&c.Status.Contains("Inventory changed"),"stale preview rejected");Check(c.Snapshot.Account.Inventory.Any(x=>x.Id==p.ItemInstanceId),"Stale preview consumed item");
   Check(c.Snapshot.Account.HeroDesk.Select(x=>x.HeroInstanceId).Distinct().Count()==c.Snapshot.Account.HeroDesk.Count,"Recruit produced duplicate identity");
  }
  catch(Exception e){error=e+"\nStatus: "+c.Status;}
  finally{c.Disconnect();c.DevelopmentProfile=previousProfile;c.Port=oldPort;c.GetComponent<Mirror.TelepathyTransport>().port=oldPort;PlayerPrefs.DeleteKey("ZatodPrototype.Account."+profile);PlayerPrefs.Save();}
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error,CharacterId=owned.CharacterId};File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return result;
 }
}
