using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Editor;
using Zatod.Heroes;
return VerifyZatodInventoryEditor.Run();
public static class VerifyZatodInventoryEditor
{
 public static object Run()
 {
  if(Application.isPlaying)throw new Exception("Stop Play first.");int checks=0;
  void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
  var c=HeroDataJson.LoadBundledCatalog();var docs=HeroDataJson.WriteDocuments(c.Data);var round=HeroDataJson.ReadDocuments(docs);
  Check(round.Data.Items.Count==142&&round.Data.StarRules.Count==5&&round.Data.MaxHeroStars==5,"Catalog JSON round trip");
  Check(typeof(ItemDefinition).GetField("HeroStats")==null,"Removed bonus remains in config authoring");
  foreach(var field in new[]{"InventoryTab","InventoryFilter","Description","SellPrice","HeroExpValue"})Check(typeof(ItemDefinition).GetField(field)!=null,"Missing item editor metadata");
  Check(c.Data.Heroes.All(h=>!string.IsNullOrEmpty(h.SoulstoneItemId)&&h.InitialStars>=1),"Missing Hero Soulstone links");
  var path=HeroDataJson.AssetPath(HeroConfigSection.StarRules);var bytes=File.ReadAllBytes(path);
  GameEditorWindow.OpenStarRules();var w=Resources.FindObjectsOfTypeAll<GameEditorWindow>().First(x=>x.rootVisualElement.Q("page-StarRules")!=null);
  Check(w.rootVisualElement.Q("tab-StarRules")!=null&&w.rootVisualElement.Q("field-MaxHeroStars")!=null,"Star config/cap missing from GameEditor");
  var flags=BindingFlags.Instance|BindingFlags.NonPublic;var draft=(HeroCatalogData)typeof(GameEditorWindow).GetField("draft",flags).GetValue(w);draft.StarRules[1].UpgradeGold++;
  typeof(GameEditorWindow).GetMethod("Edited",flags).Invoke(w,null);Check(w.hasUnsavedChanges,"Star balance edits not dirty");Check(bytes.SequenceEqual(File.ReadAllBytes(path)),"Draft edits wrote runtime config");
  w.DiscardChanges();Check(!w.hasUnsavedChanges,"Discard star draft failed");
  var migrated=0;string dir=Path.GetFullPath("../Artifacts/ZatodServer/Owned");
  foreach(var p in Directory.GetFiles(dir,"*.json"))
  {var a=HeroDataJson.ReadCharacter(File.ReadAllText(p),c);var saved=HeroDataJson.ReadCharacter(HeroDataJson.WriteCharacter(a,c),c);Check(saved.HeroDesk.Count==a.HeroDesk.Count&&saved.Inventory.Select(i=>i.Id).SequenceEqual(a.Inventory.Select(i=>i.Id)),"Owned round trip changed IDs");migrated++;}
  var result=new{Result="PASS",Checks=checks,OwnedReadOnly=migrated};File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodInventoryChecks/editor-validation.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
 }
}
