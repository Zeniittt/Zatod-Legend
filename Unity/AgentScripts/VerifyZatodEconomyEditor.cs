using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Heroes;
using Zatod.Editor;
return VerifyZatodEconomyEditor.Run();
public static class VerifyZatodEconomyEditor
{
 public static object Run()
 {
  if(Application.isPlaying)throw new Exception("Run outside Play.");int checks=0;
  void Check(bool yes,string why){checks++;if(!yes)throw new Exception(why);}
  string[] ids={"exp_potion","exp_salve","exp_cheese","exp_burger","exp_pizza"};
  var paths=ids.SelectMany(id=>new[]{"Assets/Zatod/Resources/Zatod/UI/Hero/Items/"+id+".jpg","Assets/Zatod/Resources/Zatod/UI/StagePreview/Items/"+id+".jpg"}).Concat(new[]{"Assets/Zatod/Resources/Zatod/UI/BattleResult/battleresult/expbar.png","Assets/Zatod/Resources/Zatod/UI/BattleResult/battleresult/team_expbar.png"});
  foreach(var path in paths)
  {
   var importer=(TextureImporter)AssetImporter.GetAtPath(path);Check(importer!=null,"Importer: "+path);
   importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.spritePixelsPerUnit=100;importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;importer.wrapMode=TextureWrapMode.Clamp;importer.textureCompression=TextureImporterCompression.Uncompressed;importer.filterMode=FilterMode.Bilinear;importer.SaveAndReimport();
   Check(AssetDatabase.LoadAssetAtPath<Sprite>(path)!=null,"Sprite: "+path);
  }
  ProgressionDataJson.ResetCache();var rules=ProgressionDataJson.LoadBundled();var catalog=HeroDataJson.LoadBundledCatalog();
  Check(rules.Data.PlayerLevels.Count==100&&rules.Data.HeroLevels.Count==120,"Curve coverage");Check(catalog.Data.Items.Count==117,"Item coverage");
  var fields=typeof(CharacterData).GetFields().OrderBy(f=>f.MetadataToken).ToArray();int stamina=Array.FindIndex(fields,f=>f.Name=="Stamina");Check(stamina>=0&&fields[stamina+1].Name=="StaminaRecoveryTimestamp","Stamina fields are not adjacent");
  foreach(var id in ids)Check(catalog.Item(id).ItemKind==ItemKind.Consumable&&catalog.Item(id).HeroExpValue>0,"Consumable metadata");
  GameEditorWindow.OpenProgression();var window=Resources.FindObjectsOfTypeAll<GameEditorWindow>().First(w=>w.rootVisualElement.Q("page-Progression")!=null);
  Check(window.rootVisualElement.Q("tab-Progression")!=null,"Missing progression tab");
  var flags=BindingFlags.Instance|BindingFlags.NonPublic;var draft=(ProgressionDefinition)typeof(GameEditorWindow).GetField("progressionDraft",flags).GetValue(window);
  string pathProgress=ProgressionDataJson.AssetPath;var before=File.ReadAllBytes(pathProgress);draft.PlayerLevels[0].NextLevelExp++;
  typeof(GameEditorWindow).GetMethod("Edited",flags).Invoke(window,null);Check(window.hasUnsavedChanges,"Progression changes not dirty");
  Check(before.SequenceEqual(File.ReadAllBytes(pathProgress)),"Editing wrote config before save");window.DiscardChanges();
  Check(!window.hasUnsavedChanges,"Discard did not reset draft");
  var old=new CharacterData{CharacterId=Guid.NewGuid().ToString("D")};var round=JsonUtility.FromJson<CharacterData>(JsonUtility.ToJson(old));rules.Initialize(round,1000);
  Check(round.Stamina==rules.Data.InitialStamina&&round.EconomyVersion==1,"Unity JSON migration");
  var result=new{Result="PASS",Checks=checks};Directory.CreateDirectory(Path.GetFullPath("../Artifacts/ZatodEconomyChecks"));File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodEconomyChecks/editor.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
 }
}
