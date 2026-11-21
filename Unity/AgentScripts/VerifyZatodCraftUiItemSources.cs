using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Zatod.Heroes;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;
public static class VerifyZatodCraftUiItemSources
{
 const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Static|BindingFlags.Public|BindingFlags.NonPublic;
 public static async Task<object> Run()
 {
  if(!Application.isPlaying)throw new Exception("Enter Play first.");var connection=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(connection.Connected)throw new Exception("Disconnect for UI fixture.");
  var host=connection.GetComponent<ZatodPrototypeView>();var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);var session=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"));var account=session.Account;
  var inventory=new ItemInventory(account,catalog);var crafting=new CraftingCatalog(catalog);int checks=0;void Check(bool v,string why){checks++;if(!v)throw new Exception(why);}
  string folder=Path.GetFullPath("../Artifacts/ZatodItemSourcesChecks/craft-regression");Directory.CreateDirectory(folder);async Task Shot(string n){ScreenCapture.CaptureScreenshot(Path.Combine(folder,n+".png"));await Task.Delay(200);}
  HeroData Setup(string itemId)
  {
   var def=catalog.Data.Heroes.First(h=>h.Ranks.Any(r=>r.EquipmentSlots.Any(s=>s.RequiredItemId==itemId)));var hero=account.HeroDesk.FirstOrDefault(h=>h.HeroDefinitionId==def.Id);
   if(hero==null){hero=catalog.CreateHero(def.Id,Guid.NewGuid().ToString("D"));account.HeroDesk.Add(hero);}hero.Level=40;hero.RankId=def.Ranks.First(r=>r.EquipmentSlots.Any(s=>s.RequiredItemId==itemId)).Id;return hero;
  }
  var target=Setup("green_boots");var slot=HeroProgression.CurrentRank(target,catalog).EquipmentSlots.First(s=>s.RequiredItemId=="green_boots");var recipe=crafting.ForItem("green_boots");foreach(var i in recipe.Ingredients)inventory.AddItemByItemId(i.ItemId,i.Amount);
  typeof(ZatodConnection).GetProperty("Snapshot",Flags).SetValue(connection,new ZatodAccountSnapshot{Account=account});
        var assembly=typeof(Editor).Assembly;var viewType=assembly.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(viewType);var selected=viewType.GetProperty("selectedSizeIndex",Flags);int oldIndex=(int)selected.GetValue(view);
        var sizesType=assembly.GetType("UnityEditor.GameViewSizes");var sizes=sizesType.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);
        var group=sizesType.GetMethod("GetGroup").Invoke(sizes,new[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});var groupType=group.GetType();int initialCount=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);
        async Task Resize(int w,int h)
        {
            var size=Activator.CreateInstance(assembly.GetType("UnityEditor.GameViewSize"),Flags,null,new object[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),w,h,"ZatodResultReview "+w+"x"+h},null);
            int index=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);groupType.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,index);view.Repaint();
            await Unity.Pipeline.Scripting.Wait.Until(()=>Screen.width==w && Screen.height==h,timeoutMs:8000,because:"result UI resolution");await Task.Delay(200);
        }

  string error=null;
  try
  {
   await Resize(1600,900);host.OpenHeroDetail(target.HeroInstanceId);await Task.Delay(220);
   var detail=(ZatodHeroDetailView)typeof(ZatodPrototypeView).GetField("heroDetail",Flags).GetValue(host);detail.EquipmentLayer.Find("Equipment_"+slot.Id).GetComponent<UnityEngine.UI.Button>().onClick.Invoke();await Task.Delay(220);
   var modal=(ZatodEquipmentView)typeof(ZatodPrototypeView).GetField("equipmentWindow",Flags).GetValue(host);Check(modal.gameObject.activeSelf && modal.DisplayedItemId=="green_boots","Slot click did not open item popup");Check(modal.ItemName.text=="Green Boots" && !modal.RecipeVisible,"Wrong initial item card");Check(modal.TreeBack.transform.Find("Arrow")!=null && ((RectTransform)modal.StatsScroll.transform).sizeDelta.y<250,"Prefab layout is stale");
   modal.ActionButton.onClick.Invoke();await Task.Delay(180);Check(modal.RecipeVisible && modal.IngredientButtons.Count==3 && modal.Cost.text=="0","Recipe panel contents");await Shot("01-recipe");
   var pointer=new PointerEventData(EventSystem.current){position=new Vector2(Screen.width/2,Screen.height/2)};var hits=new System.Collections.Generic.List<RaycastResult>();EventSystem.current.RaycastAll(pointer,hits);Check(hits.Count>0 && hits[0].gameObject.transform.IsChildOf(modal.transform),"Modal did not block underlying UI");
   modal.IngredientButtons[0].onClick.Invoke();await Task.Delay(150);Check(modal.CurrentTreeItem==recipe.Ingredients[0].ItemId,"Ingredient navigation did not drill down");Check(modal.SourcesVisible,"Leaf item did not show sources");modal.TreeBack.onClick.Invoke();Check(modal.CurrentTreeItem=="green_boots","Tree back failed");
   var receipt=session.Craft(recipe.Id,Guid.NewGuid().ToString("D"));modal.Refresh(account);Check(modal.Owned.text=="Owned: 1" && modal.ActionButton.GetComponentInChildren<TMPro.TextMeshProUGUI>().text=="Equip","Craft result did not enable equip");await Shot("02-crafted");
   session.EquipItem(target.HeroInstanceId,slot.Id,receipt.Created[0].Id,Guid.NewGuid().ToString("D"));detail.Refresh(account);modal.Refresh(account);Check(modal.ActionButton.GetComponentInChildren<TMPro.TextMeshProUGUI>().text=="OK" && target.EquippedItems.Any(i=>i.Id==receipt.Created[0].Id),"Equipped state mismatch");
   modal.Hide();detail.EquipmentLayer.Find("Equipment_"+slot.Id).GetComponent<UnityEngine.UI.Button>().onClick.Invoke();await Task.Delay(150);Check(modal.DisplayedItemId=="green_boots","Equipped item click failed");await Shot("03-equipped");modal.Hide();
   var fragmentHero=Setup("shortsword");var fragmentSlot=HeroProgression.CurrentRank(fragmentHero,catalog).EquipmentSlots.First(s=>s.RequiredItemId=="shortsword");var fragments=crafting.ForItem("shortsword");inventory.AddItemByItemId(fragments.Ingredients[0].ItemId,3);host.OpenEquipment(fragmentHero.HeroInstanceId,fragmentSlot.Id);modal.RecipeButton.onClick.Invoke();await Task.Delay(160);
   Check(modal.IngredientButtons.Count==1 && modal.Tree.Find("Amount_"+fragments.Ingredients[0].ItemId).GetComponent<TMPro.TextMeshProUGUI>().text=="3/5","Fragment amount display");Check(modal.IngredientButtons[0].GetComponentsInChildren<UnityEngine.UI.Image>().Any(i=>i.name=="FragmentTag"&&i.sprite!=null),"Native fragment tag missing");await Shot("04-fragments");
   foreach(var profile in new[]{new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
   {
    await Resize(profile[0],profile[1]);modal.Fit();await Task.Delay(100);var safe=(RectTransform)modal.transform;
    foreach(var control in new[]{modal.Close,modal.ActionButton,modal.CraftButton,modal.RecipeButton,modal.TreeBack})
    {var corners=new Vector3[4];((RectTransform)control.transform).GetWorldCorners(corners);foreach(var c in corners)Check(safe.rect.Contains(safe.InverseTransformPoint(c)),"Control outside safe area: "+control.name);}
    await Shot("05-"+profile[0]+"x"+profile[1]);
   }
   modal.Close.onClick.Invoke();Check(!modal.gameObject.activeSelf,"Close failed");
  }
  catch(Exception e){error=e.ToString();}
  finally
  {
   var modal=(ZatodEquipmentView)typeof(ZatodPrototypeView).GetField("equipmentWindow",Flags).GetValue(host);modal.Hide();selected.SetValue(view,oldIndex);int total=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);for(int i=total-1;i>=initialCount;i--)groupType.GetMethod("RemoveCustomSize").Invoke(group,new object[]{i});view.Repaint();
  }
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error};File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return result;
 }
}
