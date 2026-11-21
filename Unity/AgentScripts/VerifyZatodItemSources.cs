using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;
using Zatod.Heroes;
using Zatod.World;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyZatodItemSources
{
 const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Static|BindingFlags.Public|BindingFlags.NonPublic;
 static readonly string Folder=Path.GetFullPath("../Artifacts/ZatodItemSourcesChecks");
 static void Save(string file,object value){Directory.CreateDirectory(Folder);File.WriteAllText(Path.Combine(Folder,file),Newtonsoft.Json.JsonConvert.SerializeObject(value,Newtonsoft.Json.Formatting.Indented));}
 public static object Editor()
 {
  if(Application.isPlaying)throw new Exception("Stop Play first.");int checks=0;void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
  var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(heroes);var world=WorldDataJson.Load(campaign);var stages=campaign.Data.Chapters.SelectMany(c=>c.Stages).ToArray();
  Check(stages.Length==39,"39 active stages");Check(stages.First(s=>s.SourceStageId==1).Name=="Embarkation","Stage1 English");Check(stages.First(s=>s.SourceStageId==23).Name=="Easy Prey","Stage23 English");
  foreach(var stage in stages)
  {
   Check(!stage.Name.Any(c=>c>=0x3400&&c<=0x9fff),"Chinese name: "+stage.Id);
   Check(ZatodStageVisuals.Icon(stage)!=null&&ZatodStageVisuals.Icon(stage,false)!=null,"Stage icons: "+stage.Id);
   var points=world.Data.Maps.SelectMany(m=>m.Interactions).Where(p=>p.Kind==WorldInteractionKind.Stage&&p.TargetId==stage.Id).ToArray();Check(points.Length==1,"World stage point: "+stage.Id);var point=points[0];
   Check(point.Label==stage.Name&&point.VisualResource=="crystal_stage_"+stage.SourceStageId,"World name/visual: "+stage.Id);
   var prefab=Resources.Load<GameObject>("Zatod/World/Visuals/"+point.VisualResource);Check(prefab!=null,"Missing prefab: "+point.VisualResource);var sr=prefab.GetComponentInChildren<SpriteRenderer>();Check(sr!=null&&sr.sprite==ZatodStageVisuals.Icon(stage),"Prefab sprite identity: "+stage.Id);
  }
  var view=Resources.Load<GameObject>("Zatod/UI/Crafting/ZatodEquipmentView").GetComponent<ZatodEquipmentView>();Check(view.SourceScroll!=null&&view.CraftDecoration!=null&&view.RecipeTitle!=null,"Source prefab serialized refs");
  Check(view.SourceScroll.viewport!=null&&view.SourceScroll.content!=null,"Source scroll wiring");Check(view.SourceScroll.GetComponentsInChildren<UnityEngine.UI.Button>(true).Length==0,"Source scroll is read-only");
  var result=new{Result="PASS",Checks=checks,Stages=stages.Length,SourcePrefab=view.name};Save("editor.json",result);return result;
 }

 public static async Task<object> UI()
 {
  if(!Application.isPlaying)throw new Exception("Enter Play first.");var client=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(client.Connected)throw new Exception("Use disconnected test Play for isolated fixture.");
  int checks=0;void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
  var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(heroes);var session=new ZatodPlayerSession(heroes,campaign,Guid.NewGuid().ToString("D"));var account=session.Account;var inventory=new ItemInventory(account,heroes);var craft=new CraftingCatalog(heroes);
  var def=heroes.Data.Heroes.First(h=>h.Ranks.Any(r=>r.EquipmentSlots.Any(s=>s.RequiredItemId=="bracer_of_strength")));var hero=account.HeroDesk.FirstOrDefault(h=>h.HeroDefinitionId==def.Id);
  if(hero==null){hero=heroes.CreateHero(def.Id,Guid.NewGuid().ToString("D"));account.HeroDesk.Add(hero);}hero.RankId=def.Ranks.First(r=>r.EquipmentSlots.Any(s=>s.RequiredItemId=="bracer_of_strength")).Id;hero.Level=40;
  var slot=HeroProgression.CurrentRank(hero,heroes).EquipmentSlots.First(s=>s.RequiredItemId=="bracer_of_strength");var recipe=craft.ForItem("bracer_of_strength");inventory.AddItemByItemId(recipe.Ingredients[1].ItemId,1);
  var cleared=campaign.Data.Chapters.SelectMany(c=>c.Stages).Where(s=>s.SourceStageId<23).Select(s=>s.Id).ToList();var snapshot=new ZatodAccountSnapshot{Account=account,Cleared=cleared,StageStars=cleared.Select(s=>new ZatodStageStars{StageId=s,Stars=3}).ToList()};
  var saved=client.Snapshot;typeof(ZatodConnection).GetProperty("Snapshot",Flags).SetValue(client,snapshot);var host=client.GetComponent<ZatodPrototypeView>();
  var gameType=typeof(UnityEditor.Editor).Assembly.GetType("UnityEditor.GameView");var game=EditorWindow.GetWindow(gameType);var indexProp=gameType.GetProperty("selectedSizeIndex",Flags);int oldIndex=(int)indexProp.GetValue(game);
  var asm=typeof(UnityEditor.Editor).Assembly;var sizesType=asm.GetType("UnityEditor.GameViewSizes");var sizes=sizesType.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);var group=sizesType.GetMethod("GetGroup").Invoke(sizes,new[]{Enum.Parse(asm.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});var groupType=group.GetType();int initialCount=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);
  async Task Resize(int w,int h)
  {
   var size=Activator.CreateInstance(asm.GetType("UnityEditor.GameViewSize"),Flags,null,new object[]{Enum.Parse(asm.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),w,h,"Item source check "+w+"x"+h},null);
   int index=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);groupType.GetMethod("AddCustomSize").Invoke(group,new[]{size});indexProp.SetValue(game,index);game.Repaint();
   await Unity.Pipeline.Scripting.Wait.Until(()=>Screen.width==w&&Screen.height==h,timeoutMs:8000,because:"source view resolution");await Task.Delay(150);
  }
  async Task Shot(string name){ScreenCapture.CaptureScreenshot(Path.Combine(Folder,name+".png"));await Task.Delay(250);}
  var modal=(ZatodEquipmentView)typeof(ZatodPrototypeView).GetField("equipmentWindow",Flags).GetValue(host);string error=null;
  try
  {
   await Resize(1600,900);host.OpenEquipment(hero.HeroInstanceId,slot.Id);modal.RecipeButton.onClick.Invoke();await Task.Delay(200);Check(!modal.SourcesVisible&&modal.CraftDecoration.activeSelf,"Recipe mode decor");await Shot("ui-recipe");
   modal.IngredientButtons.First(b=>b.name=="Ingredient_bracer_of_strength_scroll").onClick.Invoke();await Task.Delay(200);Canvas.ForceUpdateCanvases();
   Check(modal.SourcesVisible&&!modal.CraftDecoration.activeSelf&&!modal.Tree.gameObject.activeSelf,"Source mode hides tree/crafting decoration");Check(modal.RecipeTitle.text=="Available from","Source title");Check(modal.SourceCells.Count==3,"Three real scroll sources");
   var expected=new[]{"Easy Prey","Nightmare","Battle of Capture"};int sceneCount=UnityEngine.SceneManagement.SceneManager.sceneCount;string ownedBefore=Newtonsoft.Json.JsonConvert.SerializeObject(account);
   for(int i=0;i<3;i++)
   {
    var cell=modal.SourceCells[i];var label=cell.Find("StageName").GetComponent<TextMeshProUGUI>();Check(label.text.EndsWith(expected[i]),"English source name");Check(cell.Find("StageIcon").GetComponent<UnityEngine.UI.Image>().sprite!=null,"Source icon");Check(cell.GetComponentsInChildren<UnityEngine.UI.Button>(true).Length==0,"No source button component");
    Check(!ExecuteEvents.Execute<IPointerClickHandler>(cell.gameObject,new PointerEventData(EventSystem.current),ExecuteEvents.pointerClickHandler),"No source click handler");Check(i==0?cell.Find("Arrow")!=null:cell.Find("Locked")!=null,"Live unlock predicate");Check(!label.isTextTruncated,"Source name clipped");
   }
   Check(client.Battle==null&&sceneCount==UnityEngine.SceneManagement.SceneManager.sceneCount,"No battle/scene transition from source click");Check(ownedBefore==Newtonsoft.Json.JsonConvert.SerializeObject(account),"Source click mutated account");await Shot("ui-sources-mixed");
   foreach(var profile in new[]{new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
   {
    await Resize(profile[0],profile[1]);modal.Fit();Canvas.ForceUpdateCanvases();await Task.Delay(100);var safe=(RectTransform)modal.transform;
    foreach(var control in new RectTransform[]{modal.Group,(RectTransform)modal.SourceScroll.transform})
    {var corners=new Vector3[4];control.GetWorldCorners(corners);foreach(var c in corners)Check(safe.rect.Contains(safe.InverseTransformPoint(c)),"Source control outside safe area");}
    foreach(var cell in modal.SourceCells){var text=cell.Find("StageName").GetComponent<TextMeshProUGUI>();Check(!text.isTextTruncated,"Name truncated at "+Screen.width);Check(text.rectTransform.rect.width>0,"Text zero width");}
    await Shot("ui-sources-"+profile[0]+"x"+profile[1]);
   }
   await Resize(1600,900);modal.TreeBack.onClick.Invoke();Check(modal.CurrentTreeItem=="bracer_of_strength"&&!modal.SourcesVisible&&modal.CraftDecoration.activeSelf,"Back restores recipe mode");
   modal.IngredientButtons.First(b=>b.name=="Ingredient_bracer_of_strength_scroll").onClick.Invoke();snapshot.Cleared.Clear();modal.Refresh(account);Check(modal.SourceCells.All(c=>c.Find("Locked")!=null),"All source lock states refreshed");await Shot("ui-sources-locked");
   var history=(List<string>)typeof(ZatodEquipmentView).GetField("history",Flags).GetValue(modal);var draw=typeof(ZatodEquipmentView).GetMethod("DrawTree",Flags);
   var leaf=heroes.Data.Items.First(i=>craft.ForItem(i.ItemId)==null&&!campaign.Data.Chapters.SelectMany(c=>c.Stages).Any(s=>s.DropItems.Any(d=>d.ItemId==i.ItemId)));history.Add(leaf.ItemId);draw.Invoke(modal,null);await Task.Delay(150);Check(modal.SourceCells.Count==0&&modal.SourceScroll.content.Find("NoSources")!=null,"Empty-source state");await Shot("ui-no-sources");
   var many=campaign.Data.Chapters.SelectMany(c=>c.Stages).SelectMany(s=>s.DropItems.Select(d=>d.ItemId)).GroupBy(x=>x).FirstOrDefault(g=>g.Count()>4&&craft.ForItem(g.Key)==null);
   if(many!=null){history.Add(many.Key);draw.Invoke(modal,null);Check(modal.SourceCells.Count>4&&modal.SourceScroll.content.rect.height>((RectTransform)modal.SourceScroll.transform).rect.height,"Source list scrolling");}
   modal.Close.onClick.Invoke();Check(!modal.gameObject.activeSelf,"Close still works");
  }
  catch(Exception e){error=e.ToString();}
  finally
  {
   modal.Hide();typeof(ZatodConnection).GetProperty("Snapshot",Flags).SetValue(client,saved);indexProp.SetValue(game,oldIndex);int total=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);for(int i=total-1;i>=initialCount;i--)groupType.GetMethod("RemoveCustomSize").Invoke(group,new object[]{i});game.Repaint();
  }
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error,Fixture="isolated in-memory account; no Owned write"};Save("ui.json",result);if(error!=null)throw new Exception(error);return result;
 }
}
