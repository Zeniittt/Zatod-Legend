using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
public static class VerifyZatodCraftNetwork
{
 const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
 public static async Task<object> Run()
 {
  if(!Application.isPlaying)throw new Exception("Enter Play first.");var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(c.Connected)throw new Exception("Use isolated server.");
  string folder=Path.GetFullPath("../Artifacts/ZatodCraftChecks/network");Directory.CreateDirectory(Path.Combine(folder,"server","Owned"));int checks=0;string error=null;
  void Check(bool v,string why){checks++;if(!v)throw new Exception(why);}
  async Task Until(Func<bool> condition,string why){await Unity.Pipeline.Scripting.Wait.Until(condition,timeoutMs:10000,because:why);}
  var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);var owned=campaign.CreateDemoCharacter(catalog);owned.CharacterId=Guid.NewGuid().ToString("D");
  var def=catalog.Data.Heroes.First(h=>h.Ranks.Any(r=>r.EquipmentSlots.Any(s=>s.RequiredItemId=="green_boots")));var hero=owned.HeroDesk.FirstOrDefault(h=>h.HeroDefinitionId==def.Id);if(hero==null){hero=catalog.CreateHero(def.Id,Guid.NewGuid().ToString("D"));owned.HeroDesk.Add(hero);}hero.Level=40;hero.RankId=def.Ranks.First(r=>r.EquipmentSlots.Any(s=>s.RequiredItemId=="green_boots")).Id;
  string heroId=hero.HeroInstanceId,slot=HeroProgression.CurrentRank(hero,catalog).EquipmentSlots.First(s=>s.RequiredItemId=="green_boots").Id;
  var crafting=new CraftingCatalog(catalog);var recipe=crafting.ForItem("green_boots");var shardRecipe=crafting.ForItem("shortsword");var inventory=new ItemInventory(owned,catalog);foreach(var i in recipe.Ingredients.Concat(shardRecipe.Ingredients))inventory.AddItemByItemId(i.ItemId,i.Amount);
  string ownedPath=Path.Combine(folder,"server","Owned",owned.CharacterId+".json");File.WriteAllText(ownedPath,HeroDataJson.WriteCharacter(owned,catalog));
  string profile="craft-check-"+Guid.NewGuid().ToString("N");PlayerPrefs.SetString("ZatodPrototype.Account."+profile,owned.CharacterId);PlayerPrefs.Save();c.DevelopmentProfile=profile;c.Port=17993;c.GetComponent<Mirror.TelepathyTransport>().port=17993;
  ZatodEquipmentView modal=null;string[] finalGuids=null;string craftedGuid=null;
  try
  {
   c.Connect();await Until(()=>c.Connected && c.Snapshot?.Account.CharacterId==owned.CharacterId,"isolated account");Check(c.Snapshot.Account.Inventory.Count==owned.Inventory.Count,"Fixture inventory mismatch");
   var host=c.GetComponent<ZatodPrototypeView>();host.OpenHeroDetail(heroId);host.OpenEquipment(heroId,slot);modal=(ZatodEquipmentView)typeof(ZatodPrototypeView).GetField("equipmentWindow",Flags).GetValue(host);modal.ActionButton.onClick.Invoke();await Task.Delay(150);
   modal.CraftButton.onClick.Invoke();modal.CraftButton.onClick.Invoke();await Until(()=>c.Snapshot.Account.ItemOperations.Count==1,"craft receipt");
   var receipt=c.Snapshot.Account.ItemOperations.Single();craftedGuid=receipt.Created.Single().Id;Check(receipt.Command=="craft" && receipt.Consumed.Count==3 && receipt.GoldCharged==0,"Invalid craft receipt");Check(c.Snapshot.Account.Inventory.Count==owned.Inventory.Count-2 && c.Snapshot.Account.Currencies.Count==0,"Craft consumed incorrectly or charged gold");Check(c.Snapshot.Account.Inventory.Any(i=>i.Id==craftedGuid),"Craft output missing");Check(modal.Owned.text=="Owned: 1","UI did not refresh after server craft");
   var prior=c.Snapshot;var guids=prior.Account.Inventory.Select(i=>i.Id).ToArray();c.Request(new ZatodRequest{Command="craft",A=recipe.Id,OperationId=receipt.OperationId});await Until(()=>!ReferenceEquals(c.Snapshot,prior),"duplicate craft response");Check(c.Snapshot.Account.ItemOperations.Count==1 && c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(guids),"Duplicate craft minted items");
   modal.ActionButton.onClick.Invoke();modal.ActionButton.onClick.Invoke();await Until(()=>c.Snapshot.Account.ItemOperations.Count==2,"equip receipt");Check(c.Snapshot.Account.HeroDesk.Single(h=>h.HeroInstanceId==heroId).EquippedItems.Single(i=>i.SlotId==slot).Id==craftedGuid,"Equip did not preserve crafted GUID");Check(!c.Snapshot.Account.Inventory.Any(i=>i.Id==craftedGuid),"Equipped GUID remained in inventory");await Task.Delay(200);ScreenCapture.CaptureScreenshot(Path.Combine(folder,"equipped.png"));await Task.Delay(200);
   var equipReceipt=c.Snapshot.Account.ItemOperations.Last();prior=c.Snapshot;c.Request(new ZatodRequest{Command="equip",A=heroId,B=slot,C=craftedGuid,OperationId=equipReceipt.OperationId});await Until(()=>!ReferenceEquals(c.Snapshot,prior),"duplicate equip");Check(c.Snapshot.Account.ItemOperations.Count==2,"Duplicate equip mutated account");
   guids=c.Snapshot.Account.Inventory.Select(i=>i.Id).ToArray();c.Craft(recipe.Id);await Until(()=>!c.ItemOperationBusy && c.Status.Contains("Not enough"),"missing ingredient rejection");Check(c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(guids),"Rejected craft changed inventory");
   c.Craft(shardRecipe.Id);await Until(()=>c.Snapshot.Account.ItemOperations.Count==3,"fragment craft");var shardReceipt=c.Snapshot.Account.ItemOperations.Last();Check(shardReceipt.Consumed.Count==5 && shardReceipt.Created.Count==1 && shardReceipt.Consumed.Select(i=>i.Id).Distinct().Count()==5,"Fragment craft reused GUIDs");
   var disk=HeroDataJson.ReadCharacter(File.ReadAllText(ownedPath),catalog);Check(disk.ItemOperations.Count==3 && disk.HeroDesk.Single(h=>h.HeroInstanceId==heroId).EquippedItems.Single(i=>i.SlotId==slot).Id==craftedGuid,"Owned save lost operation ledger or equipment");finalGuids=c.Snapshot.Account.Inventory.Select(i=>i.Id).ToArray();
   c.Disconnect();await Until(()=>!c.Connected,"disconnect");await Task.Delay(300);c.Connect();await Until(()=>c.Connected && c.WorldSelf!=null && c.Status.StartsWith("Connected"),"reconnect");Check(c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(finalGuids) && c.Snapshot.Account.ItemOperations.Count==3,"Reconnect lost receipts/items");
   prior=c.Snapshot;c.Request(new ZatodRequest{Command="craft",A=shardRecipe.Id,OperationId=shardReceipt.OperationId});await Until(()=>!ReferenceEquals(c.Snapshot,prior),"retry after reconnect");Check(c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(finalGuids) && c.Snapshot.Account.ItemOperations.Count==3,"Reconnect retry minted items");
  }
  catch(Exception e){error=e.ToString();}
  finally{modal?.Hide();c.Disconnect();PlayerPrefs.DeleteKey("ZatodPrototype.Account."+profile);PlayerPrefs.Save();}
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error,CharacterId=owned.CharacterId,CraftedGuid=craftedGuid,InventoryGuids=finalGuids};File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return result;
 }
}
