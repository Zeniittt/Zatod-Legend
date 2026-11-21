using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using TMPro;
const string output="Assets/Zatod/Resources/Zatod/World/Visuals";
Directory.CreateDirectory(output);AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
const string materialPath="Assets/Zatod/Resources/Zatod/World/ZatodWorldSprite.mat";
if(AssetDatabase.LoadAssetAtPath<Material>(materialPath)==null)AssetDatabase.CreateAsset(new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default")){name="ZatodWorldSprite"},materialPath);
void Save(string name,string path)
{
 var source=AssetDatabase.LoadAssetAtPath<GameObject>(path);if(source==null)throw new Exception("Missing visual: "+path);
 var root=new GameObject(name);try{PrefabUtility.InstantiatePrefab(source,root.transform);PrefabUtility.SaveAsPrefabAsset(root,output+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(root);}
}
const string source="Assets/TreasureHunterVisualExport/";
Save("unit",source+"Characters/Unit.prefab");Save("grass_background",source+"Environment/Backgrounds/Grass Background.prefab");Save("undead_background",source+"Environment/Backgrounds/Undead Background.prefab");
Save("goddess",source+"Buildings/World/Goddess Revived.prefab");
foreach(var pair in new[]{("main_building","Main Building"),("watch_tower","Watch Tower"),("cyclone_tower","Cyclone Tower"),("blessing_tower","Blessing Tower")})Save(pair.Item1,source+"Buildings/Clan/"+pair.Item2+".prefab");
Save("npc_celeste",source+"NPC/Celeste.prefab");Save("npc_varn",source+"NPC/Varn.prefab");
var sprites=AssetDatabase.LoadAllAssetsAtPath("Assets/Content/Graphics/BG/Graphic/Jugle 1.png").OfType<Sprite>().ToArray();
void SpritePrefab(string name,Sprite sprite)
{
 if(sprite==null)throw new Exception("Missing sprite for "+name);var go=new GameObject(name);try{go.AddComponent<SpriteRenderer>().sprite=sprite;PrefabUtility.SaveAsPrefabAsset(go,output+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(go);}
}
for(int n=0;n<3;n++){SpritePrefab("grass_tree_"+n,sprites.Single(s=>s.name=="Tree"+n));SpritePrefab("undead_tree_"+n,sprites.Single(s=>s.name=="Undead_Tree"+(22+n)));}
SpritePrefab("grass_patch",sprites.Single(s=>s.name=="Flower0"));
SpritePrefab("undead_patch",sprites.Single(s=>s.name=="Undead_Flower5"));
foreach(string folder in new[]{"Assets/Zatod/Resources/Zatod/UI/Formation/Portraits","Assets/Zatod/Resources/Zatod/UI/StagePreview/Items","Assets/Zatod/Resources/Zatod/Backgrounds"})
 foreach(string file in Directory.GetFiles(folder).Where(f=>f.EndsWith(".png")||f.EndsWith(".jpg")))
 {var ti=(TextureImporter)AssetImporter.GetAtPath(file.Replace('\\','/'));ti.textureType=folder.EndsWith("Backgrounds")?TextureImporterType.Default:TextureImporterType.Sprite;ti.spriteImportMode=SpriteImportMode.Single;ti.mipmapEnabled=false;ti.filterMode=FilterMode.Bilinear;ti.textureCompression=TextureImporterCompression.Uncompressed;ti.SaveAndReimport();}
var font=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationFont.asset");
var data=Zatod.World.WorldDataJson.Load(Zatod.Heroes.CampaignDataJson.LoadZatod(Zatod.Heroes.HeroDataJson.LoadBundledCatalog()));
string labels=string.Concat(data.Data.Maps.Select(m=>m.Name+string.Concat(m.Interactions.Select(p=>p.Label))));
var campaigns=File.ReadAllText("Assets/Zatod/Resources/Data/Campaigns.txt");var json=Newtonsoft.Json.Linq.JObject.Parse(campaigns);labels+=string.Concat(json.SelectTokens("$.Chapters[*].Stages[*].Name"))+string.Concat(json.SelectTokens("$.Chapters[*].Stages[*].Description"));
string needed=new string(labels.Distinct().Where(c=>c!='—' && !font.HasCharacter(c)).ToArray());if(needed.Length>0 && !font.TryAddCharacters(needed,out var missing))throw new Exception("Missing CN glyphs: "+missing);EditorUtility.SetDirty(font);
var latin=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationLatin.asset");
needed=new string("Town Chapter Grasslands Undead Forest WASD / Arrow keys Player (You) Clan Hall Lost Tower Campaign Arena PvP Realtime Heroes Menu Coming soon Clear the previous stage first 0123456789-—".Distinct().Where(c=>!latin.HasCharacter(c)).ToArray());if(needed.Length>0 && !latin.TryAddCharacters(needed,out var lm))throw new Exception("Missing Latin glyphs: "+lm);EditorUtility.SetDirty(latin);
AssetDatabase.SaveAssets();return new{Maps=data.Data.Maps.Count,Prefabs=Directory.GetFiles(output,"*.prefab").Length};
