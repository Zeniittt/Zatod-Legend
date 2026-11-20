using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
using Zatod.Heroes;

public static class SetupKavern
{
    const string Source="C:/Users/tinnq/Downloads/delivery_leaf_original";
    const string Art="Assets/Zatod/Art/Kavern", Root="Assets/Zatod/Resources/Heroes/Kavern", Key="Heroes/Kavern/";
    sealed class Group { public string state,folder; public int first=1,last; public bool body; public Vector2 origin; public int height; }
    static Group G(string state,string folder,int first,int last,Vector2 origin,bool body=false,int height=0)
    { return new Group{state=state,folder=folder,first=first,last=last,origin=origin,body=body,height=height}; }
    static int Number(string file) { return int.Parse(Regex.Match(Path.GetFileNameWithoutExtension(file),@"_(\d+)(?:_ring|_fx)?$").Groups[1].Value); }
    public static object Run()
    {
        if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before importing Kavern.");
        var source=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(source).Data;
        if(data.Heroes.Any(h=>h.Id=="kavern"))throw new InvalidOperationException("Kavern already exists; import does not overwrite balanced data.");
        var groups=new[]{
            G("Idle","Idle",1,12,new Vector2(144,1),true),G("Run","Run",1,10,new Vector2(144,1),true),
            G("Stun","TakeHit",1,6,new Vector2(144,1),true),G("Death","Death",1,19,new Vector2(144,1),true),
            G("NormalAttack","Attack",1,15,new Vector2(144,1),true),G("Ultimate","Ultimate",1,17,new Vector2(144,1),true),
            G("Skill2","Skill2",1,15,new Vector2(144,1),true),G("Skill3","Skill3",1,12,new Vector2(144,1),true),
            G("Skill4","Skill4",1,10,new Vector2(144,1),true,156),
            G("Attack_Projectile","Attack_Projectile",1,6,new Vector2(176,32)),G("Attack_Impact","Attack_Projectile",7,12,new Vector2(238,34)),
            G("Skill2_Projectile","Skill2_Projectile",1,6,new Vector2(176,32)),G("Skill2_Impact","Skill2_Projectile",7,14,new Vector2(238,32)),
            G("Attack_Ring_FX","Attack_Ring_FX",9,11,new Vector2(144,1)),
            G("Ultimate_Effect_Sparks","Ultimate_Effect_Sparks",3,13,new Vector2(144,1)),
            G("Ultimate_Effect_Beam","Ultimate_Effect_Beam",1,5,new Vector2(288,28)),
            G("Skill3_Effect_ArrowShower","Skill3_Effect_ArrowShower",1,18,GroundAnchor("Skill3_Effect_ArrowShower")),
            G("Skill4_Effect_Arrow","Skill4_Effect_Arrow",1,1,new Vector2(175,52)),
            G("Skill4_Effect_Hit_Thorns","Skill4_Effect_Hit_Thorns",1,8,GroundAnchor("Skill4_Effect_Hit_Thorns")),
            G("Skill4_Effect_Hit_Plain","Skill4_Effect_Hit_Plain",1,6,new Vector2(220,3)),
            G("Skill4_Ring_FX","Skill4_Ring_FX",6,8,new Vector2(144,1))};
        // Preflight every source before creating assets.
        foreach(var group in groups)
        {
            var files=Files(group); if(files.Length!=group.last-group.first+1)throw new InvalidDataException("Wrong frame range: "+group.state);
            foreach(var file in files) Read(file);
        }
        Directory.CreateDirectory(Art);Directory.CreateDirectory(Root+"/Animations");AssetDatabase.Refresh();
        var manifest=new HeroAnimationSetData{HeroId="kavern",CanvasWidth=288,CanvasHeight=128,PixelsPerUnit=25,AnchorPixelX=144,AnchorPixelY=1};
        var clips=new Dictionary<string,AnimationClip>();var imported=new Dictionary<string,Sprite>();
        var factories=new SpriteDataProviderFactories();factories.Init();
        foreach(var group in groups)
        {
            Directory.CreateDirectory(Art+"/"+group.folder);AssetDatabase.Refresh();
            var entry=new HeroAnimationClipData{State=group.state,SourceFolder=group.folder,ClipResource=Key+"Animations/"+group.state,
                Loop=group.state=="Idle"||group.state=="Run",Projectile=group.state.EndsWith("Projectile")||group.state=="Skill4_Effect_Arrow",
                UseProjectileOrigin=true,ProjectileOriginPixelX=group.origin.x,ProjectileOriginPixelY=group.origin.y,PresentationHeight=group.height};
            var sprites=new List<Sprite>();
            foreach(var file in Files(group))
            {
                string path=Art+"/"+group.folder+"/"+Path.GetFileName(file);
                var info=Read(file);var content=info.bounds;
                int minX=Math.Max(0,Math.Min(content.X,(int)group.origin.x)-1),minY=Math.Max(0,Math.Min(content.Y,(int)group.origin.y)-1);
                int maxX=Math.Min(info.width-1,Math.Max(content.X+content.Width-1,(int)group.origin.x)+1),maxY=Math.Min(info.height-1,Math.Max(content.Y+content.Height-1,(int)group.origin.y)+1);
                var crop=new HeroFrameBounds{X=minX,Y=minY,Width=maxX-minX+1,Height=maxY-minY+1,Empty=content.Empty};
                if(!imported.TryGetValue(path,out var sprite))
                {
                    File.Copy(file,path,false);AssetDatabase.ImportAsset(path);
                    var importer=(TextureImporter)AssetImporter.GetAtPath(path);
                    importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
                    importer.spritePixelsPerUnit=25;importer.filterMode=FilterMode.Point;importer.mipmapEnabled=false;
                    importer.npotScale=TextureImporterNPOTScale.None;importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
                    var provider=factories.GetSpriteEditorDataProviderFromObject(importer);
                    if(provider==null)throw new InvalidOperationException("Sprite provider missing");provider.InitSpriteEditorDataProvider();
                    var cap=provider.GetDataProvider<ISpriteFrameEditCapability>();
                    if(cap==null)throw new InvalidOperationException("Sprite capabilities missing");
                    foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteRect,EEditCapability.EditPivot,EEditCapability.EditSpriteName})
                        if(!cap.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Missing capability "+required);
                    var rect=new SpriteRect{name=Path.GetFileNameWithoutExtension(path),spriteID=GUID.Generate(),alignment=SpriteAlignment.Custom,
                        rect=new Rect(crop.X,crop.Y,crop.Width,crop.Height),pivot=new Vector2((group.origin.x-crop.X)/crop.Width,(group.origin.y-crop.Y)/crop.Height)};
                    provider.SetSpriteRects(new[]{rect});var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();
                    if(names==null)throw new InvalidOperationException("Stable file ID provider missing");
                    names.SetNameFileIdPairs(new[]{new SpriteNameFileIdPair(rect.name,rect.spriteID)});provider.Apply();importer.SaveAndReimport();
                    sprite=AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().Single();imported.Add(path,sprite);
                }
                sprites.Add(sprite);entry.SourceFrames.Add(Path.GetFileName(file));entry.Frames.Add(crop);entry.ContentBounds.Add(content);
            }
            var clip=new AnimationClip{name=group.state,frameRate=12};AssetDatabase.CreateAsset(clip,Root+"/Animations/"+group.state+".anim");
            AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),sprites.Select((s,i)=>new ObjectReferenceKeyframe{time=i/12f,value=s}).ToArray());
            var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=entry.Loop;settings.stopTime=sprites.Count/12f;AnimationUtility.SetAnimationClipSettings(clip,settings);
            EditorUtility.SetDirty(clip);clips.Add(group.state,clip);manifest.Clips.Add(entry);
        }
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,Root+"/KavernSprite.mat");
        var controller=Controller("Kavern",groups.Where(g=>g.body).Select(g=>g.state).ToArray(),clips,true);
        Prefab("Kavern",controller,First(clips["Idle"]),material,true,0);
        foreach(var entry in manifest.Clips.Where(c=>!groups.Single(g=>g.state==c.State).body))
            Prefab(entry.State,Controller(entry.State,new[]{entry.State},clips,false),First(clips[entry.State]),material,false,entry.DurationSeconds);
        Directory.CreateDirectory("Assets/Zatod/Resources/HeroPortraits");
        const string icon="Assets/Zatod/Resources/HeroPortraits/kavern.png";
        File.Copy(Source+"/Icon/leaf_icon_256.png",icon,false);AssetDatabase.ImportAsset(icon);
        var iconImporter=(TextureImporter)AssetImporter.GetAtPath(icon);iconImporter.textureType=TextureImporterType.Sprite;iconImporter.spriteImportMode=SpriteImportMode.Single;
        iconImporter.filterMode=FilterMode.Point;iconImporter.mipmapEnabled=false;iconImporter.textureCompression=TextureImporterCompression.Uncompressed;iconImporter.SaveAndReimport();
        File.Copy(Source+"/README.txt",Art+"/SourceNotes.txt",false);File.Copy(Source+"/effects_manifest.json",Art+"/effects_manifest.json",false);
        File.WriteAllText(Root+"/AnimationSet.txt",JsonUtility.ToJson(manifest,true));AssetDatabase.Refresh();
        Configure(data);HeroConfigFileStore.Save(data,source);
        LeenaldAtlasBuild.Ensure(Art,Art+"/Kavern.spriteatlasv2");AssetDatabase.SaveAssets();
        foreach(var window in Resources.FindObjectsOfTypeAll<GameEditorWindow>())window.ReloadIfClean();
        return new{hero="kavern",frames=imported.Count,clips=clips.Count,data.ConfigVersion};
    }
    static string[] Files(Group group){return Directory.GetFiles(Source+"/"+group.folder,"*.png").Where(p=>Number(p)>=group.first&&Number(p)<=group.last).OrderBy(Number).ToArray();}
    static (int width,int height,HeroFrameBounds bounds) Read(string file)
    {
        var texture=new Texture2D(2,2,TextureFormat.RGBA32,false);
        try{
            if(!texture.LoadImage(File.ReadAllBytes(file)))throw new InvalidDataException(file);
            var pixels=texture.GetPixels32();int x0=texture.width,y0=texture.height,x1=-1,y1=-1;
            for(int y=0;y<texture.height;y++)for(int x=0;x<texture.width;x++)if(pixels[y*texture.width+x].a>0){x0=Math.Min(x0,x);y0=Math.Min(y0,y);x1=Math.Max(x1,x);y1=Math.Max(y1,y);}
            return (texture.width,texture.height,x1<0?new HeroFrameBounds{X=144,Y=1,Width=1,Height=1,Empty=true}:new HeroFrameBounds{X=x0,Y=y0,Width=x1-x0+1,Height=y1-y0+1});
        }finally{UnityEngine.Object.DestroyImmediate(texture);}
    }
    static Vector2 GroundAnchor(string folder)
    {
        int min=int.MaxValue,max=-1;
        foreach(var file in Directory.GetFiles(Source+"/"+folder,"*.png"))
        {var t=new Texture2D(2,2);try{t.LoadImage(File.ReadAllBytes(file));var p=t.GetPixels32();for(int y=0;y<4;y++)for(int x=0;x<t.width;x++)if(p[y*t.width+x].a>0){min=Math.Min(min,x);max=Math.Max(max,x);}}finally{UnityEngine.Object.DestroyImmediate(t);}}
        return max<0?new Vector2(220,1):new Vector2((min+max)*.5f,1);
    }
    static Sprite First(AnimationClip clip){return (Sprite)AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;}
    static AnimatorController Controller(string name,string[] states,Dictionary<string,AnimationClip> clips,bool body)
    {
        var controller=AnimatorController.CreateAnimatorControllerAtPath(Root+"/"+name+".controller");var machine=controller.layers[0].stateMachine;
        var entries=states.ToDictionary(s=>s,s=>machine.AddState(s));foreach(var pair in entries){pair.Value.motion=clips[pair.Key];pair.Value.writeDefaultValues=false;}
        machine.defaultState=entries[body?"Idle":states[0]];
        if(body)foreach(var state in new[]{"NormalAttack","Ultimate","Skill2","Skill3","Skill4"}){var transition=entries[state].AddTransition(entries["Idle"]);transition.hasExitTime=true;transition.exitTime=1;transition.duration=0;}
        EditorUtility.SetDirty(controller);return controller;
    }
    static void Prefab(string name,AnimatorController controller,Sprite first,Material material,bool body,float life)
    {
        var go=new GameObject(name);try{var renderer=go.AddComponent<SpriteRenderer>();renderer.sprite=first;renderer.sharedMaterial=material;
            var animator=go.AddComponent<Animator>();animator.runtimeAnimatorController=controller;animator.updateMode=AnimatorUpdateMode.UnscaledTime;
            if(body)go.AddComponent<HeroAnimationPlayer>().HeroId="kavern";else go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds=life;
            PrefabUtility.SaveAsPrefabAsset(go,Root+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(go);}
    }
    static SkillEffectDefinition Damage(int scale){return new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=scale};}
    static SkillVisualCue Cue(string state,int delay,int duration,int forward=0,int height=0,bool beam=false)
    {return new SkillVisualCue{State=state,DelayMilliseconds=delay,DurationMilliseconds=duration,Forward=forward,Height=height,StretchToRange=beam};}
    static SkillDefinition Arrow(string id,string animation,string flight,string impact,int cooldown,int scale)
    {
        return new SkillDefinition{Id=id,Name="Kavern / "+animation,Kind=SkillKind.Active,Activation=SkillActivation.Automatic,Target=SkillTarget.NearestEnemy,
            CastRange=3000,CooldownMilliseconds=cooldown,WindupMilliseconds=667,RecoveryMilliseconds=583,AnimationDurationMilliseconds=1250,AnimationState=animation,
            Delivery=SkillDelivery.Projectile,ProjectileResource=Key+flight,ProjectileFlightState=flight,ProjectileImpactState=impact,ProjectileImpactDurationMilliseconds=impact=="Attack_Impact"?500:667,
            ProjectileSpawnPointId="bow",ProjectileSpawnMilliseconds=667,ProjectileSpeed=1800,ProjectileHitRadius=48,ProjectileLifetimeMilliseconds=2000,
            ProjectileHitOffsetForward=112,ProjectileVisualScaleBasisPoints=10000,ProjectileAim=ProjectileAim.TargetPosition,
            Effects=new List<SkillEffectDefinition>{Damage(scale)},CasterVisuals=new List<SkillVisualCue>{Cue("Attack_Ring_FX",667,250)}};
    }
    static void Configure(HeroCatalogData data)
    {
        var hero=JsonUtility.FromJson<HeroDefinition>(JsonUtility.ToJson(data.Heroes.Single(h=>h.Id=="training_warrior")));
        hero.Id="kavern";hero.Name="Kavern";hero.Position=HeroPosition.Rear;hero.PortraitKey="kavern";hero.BodyPrefabResource=Key+"Kavern";hero.AnimationSetResource=Key+"AnimationSet";
        hero.NormalAttackSkillId="kavern_normal_attack";hero.DeathAnimationMilliseconds=1584;hero.ProjectileHurtboxHeight=172;
        hero.SpawnPoints=new List<HeroSpawnPointDefinition>{new HeroSpawnPointDefinition{Id="feet"},new HeroSpawnPointDefinition{Id="bow",Forward=128,Height=124},new HeroSpawnPointDefinition{Id="air_bow",Forward=124,Height=360},new HeroSpawnPointDefinition{Id="beam",Height=108}};
        hero.BaseStats=new List<StatValue>{new StatValue("health",3000),new StatValue("damage",240),new StatValue("defense",25),new StatValue("attack_range",3000),new StatValue("move_speed",1600),new StatValue("attack_interval",28)};
        hero.SkillSlots=new List<HeroSkillSlotDefinition>{new HeroSkillSlotDefinition{Id="ultimate",SkillId="kavern_ultimate",IsUltimate=true},new HeroSkillSlotDefinition{Id="skill_2",SkillId="kavern_skill2"},new HeroSkillSlotDefinition{Id="skill_3",SkillId="kavern_skill3"},new HeroSkillSlotDefinition{Id="skill_4",SkillId="kavern_skill4"}};
        data.Heroes.Add(hero);
        var normal=Arrow(hero.NormalAttackSkillId,"NormalAttack","Attack_Projectile","Attack_Impact",0,10000);data.Skills.Add(normal);
        var poison=Arrow("kavern_skill2","Skill2","Skill2_Projectile","Skill2_Impact",6000,10000);
        poison.Effects.Add(new SkillEffectDefinition{Kind=SkillEffectKind.Poison,DamageScaleBasisPoints=2000,DurationMilliseconds=4000,TickIntervalMilliseconds=1000});data.Skills.Add(poison);
        data.Skills.Add(new SkillDefinition{Id="kavern_ultimate",Name="Kavern / Emerald Beam",Kind=SkillKind.Active,Activation=SkillActivation.UltimateIntent,Target=SkillTarget.EnemiesInLine,
            EnergyCost=100,CastRange=3600,WindupMilliseconds=750,RecoveryMilliseconds=667,AnimationDurationMilliseconds=1417,AnimationState="Ultimate",Delivery=SkillDelivery.Beam,
            ProjectileSpawnPointId="beam",ProjectileHitRadius=60,Effects=new List<SkillEffectDefinition>{Damage(30000)},
            CasterVisuals=new List<SkillVisualCue>{Cue("Ultimate_Effect_Sparks",167,917),Cue("Ultimate_Effect_Beam",750,417,576,108,true)}});
        data.Skills.Add(new SkillDefinition{Id="kavern_skill3",Name="Kavern / Twin Arrowshower",Kind=SkillKind.Active,Activation=SkillActivation.Automatic,Target=SkillTarget.NearestEnemies,MaxTargets=2,
            CastRange=3600,CooldownMilliseconds=9000,WindupMilliseconds=1000,AnimationDurationMilliseconds=1000,AnimationState="Skill3",Delivery=SkillDelivery.TargetedEffect,
            TargetEffectDelayMilliseconds=583,TargetEffectImpactMilliseconds=500,TargetEffectDurationMilliseconds=1500,TargetEffectState="Skill3_Effect_ArrowShower",Effects=new List<SkillEffectDefinition>{Damage(18000)}});
        var jump=Arrow("kavern_skill4","Skill4","Skill4_Effect_Arrow","Skill4_Effect_Hit_Thorns",7000,14000);
        jump.AnimationDurationMilliseconds=833;jump.WindupMilliseconds=jump.ProjectileSpawnMilliseconds=417;jump.RecoveryMilliseconds=417;
        jump.ProjectileSpawnPointId="air_bow";jump.DescendingProjectile=true;jump.ProjectileTargetHeight=104;jump.ProjectileHitOffsetForward=104;jump.ProjectileHitOffsetHeight=-104;jump.ImpactOnGround=true;
        jump.Effects.Add(new SkillEffectDefinition{Kind=SkillEffectKind.Stun,DurationMilliseconds=1000});jump.CasterVisuals=new List<SkillVisualCue>{Cue("Skill4_Ring_FX",417,250,0,156)};data.Skills.Add(jump);
        data.ConfigVersion+="-kavern-1";
    }
}
