using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
using Zatod.Heroes;

public static class SetupRangedMonsters
{
    const string Source="E:/hoc/TinIT/TinUnity/MyProject/Zatod Legend/Assets/Graphics/Enemies/";
    const string Art="Assets/Zatod/Art/Monsters/",Root="Assets/Zatod/Resources/Monsters/";
    const string Staging="Assets/Zatod/RangedMonsterImportStaging";
    static SpriteDataProviderFactories factories;
    sealed class Spec
    {
        public string id,name,folder,source,body,attack,hit,flight,impact;
        public int cell,ground,anchor,flightCell,flightHeight,hp,damage,defense,range,speed,interval,release,forward,height;
        public HeroPosition position;
        public bool flipProjectile;
        public Rect portrait;
    }
    static Spec[] Specs()=>new[]{
        new Spec{id="archer",name="Archer",folder="Archer",source="Archer",body="Character/",attack="Attack.png",hit="Get Hit.png",flight="Arrow/Move.png",
            cell=100,ground=33,anchor=50,flightCell=24,flightHeight=5,hp=750,damage=65,defense=5,range=1400,speed=950,interval=30,release=250,forward=100,height=100,
            position=HeroPosition.Rear,portrait=new Rect(30,28,45,48)},
        new Spec{id="huntress",name="Huntress",folder="Huntress",source="Huntress",body="Sprites/",attack="Attack3.png",hit="Take hit.png",flight="Sprites/Spear move.png",
            cell=150,ground=53,anchor=75,flightCell=60,flightHeight=20,hp=1000,damage=85,defense=15,range=950,speed=1050,interval=32,release=333,forward=120,height=140,
            position=HeroPosition.Middle,portrait=new Rect(50,48,60,60)},
        new Spec{id="evil_wizard",name="Evil Wizard",folder="EvilWizard",source="Evil Wizard 3/Evil Wizard 3",body="Sprites/",attack="Attack.png",hit="Get hit.png",
            flight="Sprites/Projectile/Moving.png",impact="Sprites/Projectile/Explode.png",cell=140,ground=43,anchor=70,flightCell=50,flightHeight=50,
            hp=900,damage=110,defense=10,range=1200,speed=800,interval=38,release=750,forward=150,height=150,flipProjectile=true,
            position=HeroPosition.Rear,portrait=new Rect(40,38,65,65)}
    };
    public static object Run()
    {
        var before=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(before).Data;var specs=Specs();
        foreach(var spec in specs)
            if(data.Monsters.Any(m=>m.Id==spec.id) || Directory.Exists(Art+spec.folder) || Directory.Exists(Root+spec.folder))
                throw new InvalidOperationException("Refusing to replace existing monster: "+spec.id);
        if(Directory.Exists(Staging))throw new InvalidOperationException("Import staging already exists; inspect before continuing.");
        factories=new SpriteDataProviderFactories();factories.Init();
        Directory.CreateDirectory(Staging);AssetDatabase.Refresh();int frames=0;
        foreach(var spec in specs)frames+=Import(spec,data);
        data.ConfigVersion+="-ranged-monsters-1";HeroConfigFileStore.Save(data,before);
        Zatod.Editor.LeenaldAtlasBuild.Ensure("Assets/Zatod/Art/Monsters","Assets/Zatod/Art/Monsters/Monsters.spriteatlasv2");
        AssetDatabase.SaveAssets();
        if(!Directory.EnumerateFileSystemEntries(Staging).Any())AssetDatabase.DeleteAsset(Staging);
        foreach(var window in Resources.FindObjectsOfTypeAll<GameEditorWindow>())window.ReloadIfClean();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>())window.CreateGUI();
        return new{monsters=specs.Select(s=>s.id).ToArray(),frames,data.ConfigVersion};
    }
    static int Import(Spec spec,HeroCatalogData data)
    {
        string art=Art+spec.folder,root=Root+spec.folder,key="Monsters/"+spec.folder+"/";
        Directory.CreateDirectory(art);Directory.CreateDirectory(root+"/Animations");AssetDatabase.Refresh();
        var set=new HeroAnimationSetData{HeroId=spec.id,PixelsPerUnit=25,CanvasWidth=spec.cell,CanvasHeight=spec.cell,AnchorPixelX=spec.anchor,AnchorPixelY=spec.ground};
        var clips=new Dictionary<string,AnimationClip>();int count=0;
        foreach(var part in new[]{("Idle","Idle.png"),("Run","Run.png"),("NormalAttack",spec.attack),("TakeHit",spec.hit),("Death","Death.png")})
        {
            var sprites=Strip(Source+spec.source+"/"+spec.body+part.Item2,art+"/"+part.Item1+".png",part.Item1,spec.cell,spec.cell,new Vector2(spec.anchor,spec.ground));
            AddClip(root,key,set,clips,part.Item1,sprites,part.Item1=="Idle"||part.Item1=="Run",false,false,Source+spec.source+"/"+spec.body+part.Item2);count+=sprites.Length;
        }
        var hit=set.Clips.Single(c=>c.State=="TakeHit");var stun=JsonUtility.FromJson<HeroAnimationClipData>(JsonUtility.ToJson(hit));
        stun.State="Stun";set.Clips.Add(stun);clips.Add("Stun",clips["TakeHit"]);
        var flight=Strip(Source+spec.source+"/"+spec.flight,art+"/ProjectileFlight.png","ProjectileFlight",spec.flightCell,spec.flightHeight,new Vector2(spec.flightCell/2f,spec.flightHeight/2f));
        AddClip(root,key,set,clips,"ProjectileFlight",flight,true,true,spec.flipProjectile,Source+spec.source+"/"+spec.flight);count+=flight.Length;
        if(spec.impact!=null)
        {
            var impact=Strip(Source+spec.source+"/"+spec.impact,art+"/ProjectileImpact.png","ProjectileImpact",50,50,new Vector2(25,25));
            AddClip(root,key,set,clips,"ProjectileImpact",impact,false,true,false,Source+spec.source+"/"+spec.impact);count+=impact.Length;
        }
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,root+"/MonsterSprite.mat");
        Prefab(root,spec.folder,clips.Where(p=>!p.Key.StartsWith("Projectile")).ToDictionary(p=>p.Key,p=>p.Value),material);
        Prefab(root,"ProjectileFlight",new Dictionary<string,AnimationClip>{{"ProjectileFlight",clips["ProjectileFlight"]}},material);
        if(spec.impact!=null)Prefab(root,"ProjectileImpact",new Dictionary<string,AnimationClip>{{"ProjectileImpact",clips["ProjectileImpact"]}},material);
        File.WriteAllText(root+"/AnimationSet.txt",JsonUtility.ToJson(set,true));AssetDatabase.ImportAsset(root+"/AnimationSet.txt");
        Portrait(Source+spec.source+"/"+spec.body+"Idle.png",spec.id,spec.portrait);
        if(File.Exists(Source+spec.source+"/License.txt")){File.Copy(Source+spec.source+"/License.txt",art+"/License.txt",false);AssetDatabase.ImportAsset(art+"/License.txt");}
        int duration=Mathf.CeilToInt(set.Clips.Single(c=>c.State=="NormalAttack").DurationSeconds*1000);
        var definition=new MonsterDefinition{Id=spec.id,Name=spec.name,PortraitKey=spec.id,Position=spec.position,BodyPrefabResource=key+spec.folder,
            AnimationSetResource=key+"AnimationSet",NormalAttackSkillId=spec.id+"_normal_attack",ProjectileHurtboxHeight=(spec.cell-spec.ground)*4,
            DeathAnimationMilliseconds=Mathf.CeilToInt(set.Clips.Single(c=>c.State=="Death").DurationSeconds*1000),
            SpawnPoints=new List<HeroSpawnPointDefinition>{new HeroSpawnPointDefinition{Id="weapon",Forward=spec.forward,Height=spec.height}},
            BaseStats=new List<StatValue>{new StatValue("health",spec.hp),new StatValue("damage",spec.damage),new StatValue("defense",spec.defense),
                new StatValue("attack_range",spec.range),new StatValue("move_speed",spec.speed),new StatValue("attack_interval",spec.interval)}};
        // Hurtboxes follow the visible body, not the transparent sprite-cell height.
        definition.ProjectileHurtboxHeight=spec.id=="archer"?144:spec.id=="huntress"?168:212;
        var attack=new SkillDefinition{Id=definition.NormalAttackSkillId,Name=spec.name+" / Attack",Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,
            AnimationState="NormalAttack",CastRange=spec.range,WindupMilliseconds=spec.release,AnimationDurationMilliseconds=duration,RecoveryMilliseconds=duration-spec.release,
            Delivery=SkillDelivery.Projectile,ProjectileResource=key+"ProjectileFlight",ProjectileFlightState="ProjectileFlight",ProjectileSpawnPointId="weapon",
            ProjectileSpawnMilliseconds=spec.release,ProjectileSpeed=spec.id=="evil_wizard"?1400:1800,ProjectileHitRadius=24,ProjectileLifetimeMilliseconds=3000,
            DescendingProjectile=true,ProjectileTargetHeight=80,
            ProjectileVisualScaleBasisPoints=10000,ProjectileImpactState=spec.impact==null?null:"ProjectileImpact",ProjectileImpactDurationMilliseconds=spec.impact==null?0:584,
            Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=10000}}};
        data.Monsters.Add(definition);data.Skills.Add(attack);return count;
    }
    static TextureImporter Settings(string path,SpriteImportMode mode)
    {
        var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=mode;
        importer.spritePixelsPerUnit=25;importer.filterMode=FilterMode.Point;importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;
        importer.maxTextureSize=4096;importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();return importer;
    }
    static void Slice(TextureImporter importer,SpriteRect[] rects)
    {
        var provider=factories.GetSpriteEditorDataProviderFromObject(importer);if(provider==null)throw new InvalidOperationException("Sprite provider unavailable");
        provider.InitSpriteEditorDataProvider();var capability=provider.GetDataProvider<ISpriteFrameEditCapability>();
        if(capability==null)throw new InvalidOperationException("Sprite editing capabilities unavailable");
        foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteName,EEditCapability.EditSpriteRect,EEditCapability.EditPivot})
            if(!capability.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Unsupported sprite operation: "+required);
        var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();if(names==null)throw new InvalidOperationException("Stable sprite IDs unavailable");
        provider.SetSpriteRects(rects);names.SetNameFileIdPairs(rects.Select(r=>new SpriteNameFileIdPair(r.name,r.spriteID)));provider.Apply();importer.SaveAndReimport();
    }
    static Sprite[] Strip(string source,string destination,string state,int width,int height,Vector2 pivot)
    {
        // Finish importer setup outside the atlas's watched folder to avoid packing default-compressed sprites.
        string stage=Staging+"/"+Guid.NewGuid().ToString("N")+".png";File.Copy(source,stage,false);AssetDatabase.ImportAsset(stage);
        var importer=Settings(stage,SpriteImportMode.Multiple);var texture=AssetDatabase.LoadAssetAtPath<Texture2D>(stage);
        if(texture.width%width!=0 || texture.height!=height)throw new InvalidOperationException("Unexpected strip dimensions: "+source);
        Slice(importer,Enumerable.Range(0,texture.width/width).Select(i=>new SpriteRect{name=state+"_"+i.ToString("D3"),spriteID=GUID.Generate(),
            alignment=SpriteAlignment.Custom,rect=new Rect(i*width,0,width,height),pivot=new Vector2(pivot.x/width,pivot.y/height)}).ToArray());
        string error=AssetDatabase.MoveAsset(stage,destination);if(!string.IsNullOrEmpty(error))throw new InvalidOperationException(error);
        return AssetDatabase.LoadAllAssetsAtPath(destination).OfType<Sprite>().OrderBy(s=>s.name).ToArray();
    }
    static void Portrait(string source,string id,Rect crop)
    {
        string path="Assets/Zatod/Resources/MonsterPortraits/"+id+".png";File.Copy(source,path,false);AssetDatabase.ImportAsset(path);
        var importer=Settings(path,SpriteImportMode.Multiple);Slice(importer,new[]{new SpriteRect{name=id,spriteID=GUID.Generate(),alignment=SpriteAlignment.Center,rect=crop,pivot=new Vector2(.5f,.5f)}});
    }
    static void AddClip(string root,string key,HeroAnimationSetData set,Dictionary<string,AnimationClip> clips,string state,Sprite[] sprites,bool loop,bool projectile,bool flip,string source)
    {
        var entry=new HeroAnimationClipData{State=state,SourceFolder=source,ClipResource=key+"Animations/"+state,Loop=loop,Projectile=projectile,
            PreserveSpritePivot=projectile,FramesPerSecond=12,SourceDurationSeconds=sprites.Length/12f};
        var clip=new AnimationClip{name=state,frameRate=12};AssetDatabase.CreateAsset(clip,root+"/Animations/"+state+".anim");
        AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),
            sprites.Select((s,i)=>new ObjectReferenceKeyframe{time=i/12f,value=s}).ToArray());
        if(flip)AnimationUtility.SetEditorCurve(clip,EditorCurveBinding.FloatCurve("",typeof(SpriteRenderer),"m_FlipX"),AnimationCurve.Constant(0,entry.DurationSeconds,1));
        var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=loop;settings.stopTime=entry.DurationSeconds;AnimationUtility.SetAnimationClipSettings(clip,settings);
        for(int i=0;i<sprites.Length;i++){entry.SourceFrames.Add(sprites[i].name);entry.FrameTimes.Add(i/12f);entry.Frames.Add(new HeroFrameBounds{Width=(int)sprites[i].rect.width,Height=(int)sprites[i].rect.height});}
        set.Clips.Add(entry);clips.Add(state,clip);
    }
    static void Prefab(string root,string name,Dictionary<string,AnimationClip> clips,Material material)
    {
        var controller=AnimatorController.CreateAnimatorControllerAtPath(root+"/"+name+".controller");
        foreach(var pair in clips){var state=controller.layers[0].stateMachine.AddState(pair.Key);state.motion=pair.Value;state.writeDefaultValues=false;
            if(pair.Key=="Idle" || clips.Count==1)controller.layers[0].stateMachine.defaultState=state;}
        var go=new GameObject(name);
        try{var renderer=go.AddComponent<SpriteRenderer>();renderer.sharedMaterial=material;
            var clip=clips.ContainsKey("Idle")?clips["Idle"]:clips.Values.First();renderer.sprite=(Sprite)AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;
            go.AddComponent<Animator>().runtimeAnimatorController=controller;if(clips.Count==1)go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds=3;
            PrefabUtility.SaveAsPrefabAsset(go,root+"/"+name+".prefab");}
        finally{UnityEngine.Object.DestroyImmediate(go);}
    }
}
