using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
using Zatod.Heroes;

public static class SetupMonsters
{
    const string Export="C:/Users/tinnq/OneDrive/Desktop/He/ExportedProject";
    const string Source=Export+"/SpriteExport/01_Characters";
    const string Art="Assets/Zatod/Art/Monsters",Root="Assets/Zatod/Resources/Monsters";
    static SpriteDataProviderFactories factories;
    sealed class Imported { public MonsterDefinition definition;public SkillDefinition attack;public int sprites; }
    public static object Run()
    {
        var source=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(source).Data;
        if(data.Monsters.Count>0)throw new InvalidOperationException("Monster config already exists; importer will not overwrite balanced data.");
        factories=new SpriteDataProviderFactories();factories.Init();
        Directory.CreateDirectory(Art);Directory.CreateDirectory(Root);AssetDatabase.Refresh();
        var results=new[]{Import("fighter_goblin","FighterGoblin","Fighter Goblin","Walk","Hited",22,900,60,10,100,1000,26,500),
            Import("goblin_mage","FemaleGoblin","Goblin Mage","Walk","Hited",34,700,45,5,1300,1000,32,500),
            Import("skeleton_knight","SkeletonKnight","Skeleton Knight","Walk","Hited",32,1800,90,35,120,700,34,650)};
        foreach(var result in results){data.Monsters.Add(result.definition);data.Skills.Add(result.attack);}
        data.ConfigVersion+="-monsters-1";HeroConfigFileStore.Save(data,source);
        LeenaldAtlasBuild.Ensure(Art,Art+"/Monsters.spriteatlasv2");AssetDatabase.SaveAssets();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroBalanceWindow>())window.ReloadIfClean();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>())window.CreateGUI();
        return new{monsters=results.Select(r=>r.definition.Id).ToArray(),sprites=results.Sum(r=>r.sprites),data.ConfigVersion};
    }
    static Imported Import(string id,string character,string name,string run,string stun,int groundOffset,int hp,int damage,int defense,int range,int speed,int interval,int windup)
    {
        string source=Source+"/"+character,art=Art+"/"+character,root=Root+"/"+character,key="Monsters/"+character+"/";
        Directory.CreateDirectory(art);Directory.CreateDirectory(root+"/Animations");AssetDatabase.Refresh();
        var manifest=new HeroAnimationSetData{HeroId=id,PixelsPerUnit=25};var clips=new Dictionary<string,AnimationClip>();int count=0;
        float death=1.5f;
        foreach(var pair in new[]{("Idle","Idle"),("Run",run),("NormalAttack","LightAtk"),("Stun",stun),("Death","Death")})
        {
            var path=Directory.GetFiles(source+"/Animations/"+character,"*.json").Single(p=>(string)JObject.Parse(File.ReadAllText(p))["name"]==pair.Item2);
            var json=JObject.Parse(File.ReadAllText(path));var frames=(JArray)json["frames"];var sheets=(JArray)json["sheets"];
            var entry=new HeroAnimationClipData{State=pair.Item1,SourceFolder=character,ClipResource=key+"Animations/"+pair.Item1,
                Loop=pair.Item1=="Idle"||pair.Item1=="Run",SourceDurationSeconds=(float)json["duration"]};
            var sprites=new Dictionary<int,Sprite>();
            for(int page=0;page<sheets.Count;page++)
            {
                var sheet=sheets[page];string src=source+"/"+(string)sheet["png"],dst=art+"/"+Path.GetFileName(src);
                File.Copy(src,dst,false);AssetDatabase.ImportAsset(dst);
                var importer=Importer(dst);var texture=AssetDatabase.LoadAssetAtPath<Texture2D>(dst);
                var rects=new List<SpriteRect>();
                for(int i=0;i<frames.Count;i++)if((int)frames[i]["sheet_page"]==page)
                {
                    var r=frames[i]["sheet_rect_top_left"];float w=(float)r[2],h=(float)r[3];
                    rects.Add(new SpriteRect{name=pair.Item1+"_"+i.ToString("D4"),spriteID=GUID.Generate(),alignment=SpriteAlignment.Custom,
                        rect=new Rect((float)r[0],texture.height-(float)r[1]-h,w,h),
                        pivot=new Vector2((float)sheet["pivot_pixels_bottom_left"][0]/w,((float)sheet["pivot_pixels_bottom_left"][1]-groundOffset)/h)});
                }
                Apply(importer,rects);
                foreach(var sprite in AssetDatabase.LoadAllAssetsAtPath(dst).OfType<Sprite>())sprites.Add(int.Parse(sprite.name.Substring(sprite.name.LastIndexOf('_')+1)),sprite);
            }
            var keys=new List<ObjectReferenceKeyframe>();
            for(int i=0;i<frames.Count;i++)
            {
                var sprite=sprites[i];float time=(float)frames[i]["time"];
                keys.Add(new ObjectReferenceKeyframe{time=time,value=sprite});entry.FrameTimes.Add(time);entry.SourceFrames.Add(sprite.name);
                entry.Frames.Add(new HeroFrameBounds{Width=(int)sprite.rect.width,Height=(int)sprite.rect.height});
            }
            var clip=Clip(root,entry,keys);clips.Add(entry.State,clip);manifest.Clips.Add(entry);count+=frames.Count;
            if(pair.Item1=="Death")death=entry.DurationSeconds;
            File.Copy(path,art+"/"+pair.Item1+".json",false);
        }
        bool mage=id=="goblin_mage";
        if(mage)count+=Fireball(art,root,key,manifest,clips);
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,root+"/MonsterSprite.mat");
        Prefab(root,character,clips.Where(p=>new[]{"Idle","Run","NormalAttack","Stun","Death"}.Contains(p.Key)).ToDictionary(p=>p.Key,p=>p.Value),material);
        if(mage)foreach(string state in new[]{"Fireball_Casted","Fireball_Triggered","Fireball_Dissipate"})Prefab(root,state,new Dictionary<string,AnimationClip>{{state,clips[state]}},material);
        File.WriteAllText(root+"/AnimationSet.txt",JsonUtility.ToJson(manifest,true));
        var characterJson=JObject.Parse(File.ReadAllText(source+"/character.json"));
        var portrait=characterJson["frames"].FirstOrDefault(f=>((string)f["png"]).StartsWith("Portraits_and_Icons/"));
        string portraitSource=portrait==null?(string)JObject.Parse(File.ReadAllText(art+"/Idle.json"))["frames"][0]["png"]:(string)portrait["png"];
        Directory.CreateDirectory("Assets/Zatod/Resources/MonsterPortraits");
        string portraitPath="Assets/Zatod/Resources/MonsterPortraits/"+id+".png";
        File.Copy(source+"/"+portraitSource,portraitPath,false);AssetDatabase.ImportAsset(portraitPath);
        var icon=(TextureImporter)AssetImporter.GetAtPath(portraitPath);icon.textureType=TextureImporterType.Sprite;icon.spriteImportMode=SpriteImportMode.Single;
        icon.filterMode=FilterMode.Point;icon.mipmapEnabled=false;icon.textureCompression=TextureImporterCompression.Uncompressed;icon.SaveAndReimport();
        var definition=new MonsterDefinition{Id=id,Name=name,PortraitKey=id,BodyPrefabResource=key+character,AnimationSetResource=key+"AnimationSet",
            Position=mage?HeroPosition.Rear:HeroPosition.Front,NormalAttackSkillId=id+"_normal_attack",DeathAnimationMilliseconds=Mathf.RoundToInt(death*1000),
            ProjectileHurtboxHeight=id=="skeleton_knight"?160:100,
            BaseStats=new List<StatValue>{new StatValue("health",hp),new StatValue("damage",damage),new StatValue("defense",defense),new StatValue("attack_range",range),new StatValue("move_speed",speed),new StatValue("attack_interval",interval)}};
        var attack=new SkillDefinition{Id=definition.NormalAttackSkillId,Name=name+" / Attack",Target=SkillTarget.NearestEnemy,Kind=SkillKind.Active,
            AnimationState="NormalAttack",CastRange=range,WindupMilliseconds=windup,AnimationDurationMilliseconds=Mathf.RoundToInt(manifest.Clips.Single(c=>c.State=="NormalAttack").DurationSeconds*1000),
            Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=10000}}};
        attack.RecoveryMilliseconds=Math.Max(0,attack.AnimationDurationMilliseconds-windup);
        if(mage)
        {
            definition.SpawnPoints.Add(new HeroSpawnPointDefinition{Id="staff",Forward=96,Height=80});
            attack.Delivery=SkillDelivery.Projectile;attack.ProjectileResource=key+"Fireball_Triggered";attack.ProjectileFlightState="Fireball_Triggered";
            attack.ProjectileImpactState="Fireball_Dissipate";attack.ProjectileImpactDurationMilliseconds=350;attack.ProjectileSpawnPointId="staff";
            attack.ProjectileSpawnMilliseconds=windup;attack.ProjectileSpeed=1600;attack.ProjectileHitRadius=32;attack.ProjectileLifetimeMilliseconds=2500;attack.ProjectileVisualScaleBasisPoints=10000;
            attack.CasterVisuals.Add(new SkillVisualCue{State="Fireball_Casted",DelayMilliseconds=windup,DurationMilliseconds=175,Forward=96,Height=80});
        }
        AssetDatabase.Refresh();return new Imported{definition=definition,attack=attack,sprites=count};
    }
    static TextureImporter Importer(string path)
    {
        var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
        importer.spritePixelsPerUnit=25;importer.filterMode=FilterMode.Point;importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;
        importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();return importer;
    }
    static void Apply(TextureImporter importer,List<SpriteRect> rects)
    {
        var provider=factories.GetSpriteEditorDataProviderFromObject(importer);if(provider==null)throw new InvalidOperationException("Sprite provider missing");
        provider.InitSpriteEditorDataProvider();var capability=provider.GetDataProvider<ISpriteFrameEditCapability>();
        if(capability==null)throw new InvalidOperationException("Sprite capability missing");
        foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteRect,EEditCapability.EditPivot,EEditCapability.EditSpriteName})
            if(!capability.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Sprite operation unsupported: "+required);
        provider.SetSpriteRects(rects.ToArray());var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();
        if(names==null)throw new InvalidOperationException("Stable sprite IDs missing");
        names.SetNameFileIdPairs(rects.Select(r=>new SpriteNameFileIdPair(r.name,r.spriteID)));provider.Apply();importer.SaveAndReimport();
    }
    static AnimationClip Clip(string root,HeroAnimationClipData entry,List<ObjectReferenceKeyframe> keys)
    {
        var clip=new AnimationClip{name=entry.State,frameRate=100};AssetDatabase.CreateAsset(clip,root+"/Animations/"+entry.State+".anim");
        AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),keys.ToArray());
        var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=entry.Loop;settings.stopTime=entry.DurationSeconds;AnimationUtility.SetAnimationClipSettings(clip,settings);return clip;
    }
    static void Prefab(string root,string name,Dictionary<string,AnimationClip> clips,Material material)
    {
        var controller=AnimatorController.CreateAnimatorControllerAtPath(root+"/"+name+".controller");var machine=controller.layers[0].stateMachine;
        foreach(var pair in clips){var state=machine.AddState(pair.Key);state.motion=pair.Value;state.writeDefaultValues=false;if(pair.Key=="Idle" || clips.Count==1)machine.defaultState=state;}
        var go=new GameObject(name);try{var renderer=go.AddComponent<SpriteRenderer>();renderer.sharedMaterial=material;
            var clip=clips.ContainsKey("Idle")?clips["Idle"]:clips.Values.First();renderer.sprite=(Sprite)AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;
            go.AddComponent<Animator>().runtimeAnimatorController=controller;if(clips.Count==1)go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds=3;
            PrefabUtility.SaveAsPrefabAsset(go,root+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(go);}
    }
    static int Fireball(string art,string root,string key,HeroAnimationSetData manifest,Dictionary<string,AnimationClip> clips)
    {
        var inventory=JObject.Parse(File.ReadAllText(Export+"/SpriteExport/inventory.json"));
        var animations=inventory["controllers"]["0b167d55f34c4ed4bbb7e50fa47ed254"]["animations"].Select(id=>inventory["animations"][(string)id]).ToList();
        var all=animations.SelectMany(a=>a["tracks"].First()["frames"]).Select(f=>(string)f["guid"]).Distinct().ToList();
        var sprites=new Dictionary<string,Sprite>();Directory.CreateDirectory(art+"/Projectiles");AssetDatabase.Refresh();
        foreach(var textureGroup in all.GroupBy(id=>(string)inventory["sprites"][id]["texture"]))
        {
            string texturePath=(string)inventory["textures"][textureGroup.Key]["path"],dst=art+"/Projectiles/"+Path.GetFileName(texturePath);
            File.Copy(Export+"/"+texturePath,dst,false);AssetDatabase.ImportAsset(dst);var importer=Importer(dst);
            var rects=new List<SpriteRect>();
            foreach(string id in textureGroup)
            {
                var info=inventory["sprites"][id];var r=info["rect"];var pivot=info["pivot"];
                rects.Add(new SpriteRect{name=id,spriteID=GUID.Generate(),alignment=SpriteAlignment.Custom,
                    rect=new Rect((float)r["x"],(float)r["y"],(float)r["width"],(float)r["height"]),pivot=new Vector2((float)pivot["x"],(float)pivot["y"])});
            }
            Apply(importer,rects);foreach(var sprite in AssetDatabase.LoadAllAssetsAtPath(dst).OfType<Sprite>())sprites.Add(sprite.name,sprite);
        }
        int count=0;
        foreach(var animation in animations)
        {
            string state="Fireball_"+(string)animation["name"];
            var entry=new HeroAnimationClipData{State=state,ClipResource=key+"Animations/"+state,SourceDurationSeconds=(float)animation["stop"],Loop=(int)animation["loop"]!=0,PreserveSpritePivot=true};
            var keys=new List<ObjectReferenceKeyframe>();
            foreach(var frame in animation["tracks"].First()["frames"])
            {string id=(string)frame["guid"];float time=(float)frame["time"];keys.Add(new ObjectReferenceKeyframe{time=time,value=sprites[id]});entry.FrameTimes.Add(time);entry.SourceFrames.Add(id);}
            clips.Add(state,Clip(root,entry,keys));manifest.Clips.Add(entry);count+=keys.Count;
        }
        return count;
    }
    public static object FinalizeProjectile()
    {
        string path=Root+"/FemaleGoblin/AnimationSet.txt";
        var set=JsonUtility.FromJson<HeroAnimationSetData>(File.ReadAllText(path));
        foreach(var clip in set.Clips.Where(c=>c.State.StartsWith("Fireball_")))clip.PreserveSpritePivot=true;
        File.WriteAllText(path,JsonUtility.ToJson(set,true));AssetDatabase.ImportAsset(path);return new{updated=path};
    }
}
