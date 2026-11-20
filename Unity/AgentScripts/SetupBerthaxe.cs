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

public static class SetupBerthaxe
{
    const string Source="C:/Users/tinnq/OneDrive/Desktop/He/ExportedProject/Bertha_HeroKit";
    const string Art="Assets/Zatod/Art/Berthaxe",Root="Assets/Zatod/Resources/Heroes/Berthaxe",Key="Heroes/Berthaxe/";
    static SpriteDataProviderFactories factories;
    public static object Run()
    {
        if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play before importing.");
        if((int)JObject.Parse(File.ReadAllText(Source+"/hero_kit.json"))["version"]!=4)throw new Exception("Expected Bertha v4.");
        var before=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(before).Data;
        string campaignBefore=File.ReadAllText(CampaignDataJson.AssetPath);
        if(data.Heroes.Any(h=>h.Id=="berthaxe") || Directory.Exists(Art))throw new Exception("Berthaxe already exists; refusing overwrite.");
        factories=new SpriteDataProviderFactories();factories.Init();Directory.CreateDirectory(Art);Directory.CreateDirectory(Root+"/Animations");AssetDatabase.Refresh();
        var groups=new[]{("Idle","Idle",true),("Run","Run",true),("Stun","Takehit",true),("Death","Death",true),("NormalAttack","NormalAttack",true),
            ("Ultimate","Ultimate",true),("Skill2","Skill2",true),("Skill3","Skill3",true),("Skill4","Skill4",true),
            ("EarthEruption","Effects/EarthEruption/Cast",false),("EarthExplosion","Effects/EarthExplosion/Cast",false),
            ("ShockWave","Projectiles/ShockWave/Triggered",false),("ShockHit","Projectiles/ShockWave/Hit",false),("ShockDissipate","Projectiles/ShockWave/Dissipate",false)};
        var manifest=new HeroAnimationSetData{HeroId="berthaxe",PixelsPerUnit=25,CanvasWidth=289,CanvasHeight=174,AnchorPixelX=124,AnchorPixelY=42};
        var clips=new Dictionary<string,AnimationClip>();int frames=0;
        foreach(var group in groups)
        {
            string source=Source+"/"+group.Item2;var json=JObject.Parse(File.ReadAllText(source+"/animation.json"));
            string folder=Art+"/"+group.Item1;Directory.CreateDirectory(folder);AssetDatabase.Refresh();
            var entry=new HeroAnimationClipData{State=group.Item1,SourceFolder=source,ClipResource=Key+"Animations/"+group.Item1,
                SourceDurationSeconds=(float)json["duration_seconds"],Loop=group.Item1=="Idle"||group.Item1=="Run"||group.Item1=="ShockWave",
                Projectile=group.Item1=="ShockWave",PreserveSpritePivot=true};
            var native=new List<(JToken frame,int width,int height,HeroFrameBounds bounds)>();
            int ground=int.MaxValue;
            foreach(var frame in json["frames"])
            {
                var texture=new Texture2D(2,2,TextureFormat.RGBA32,false);
                try
                {
                    ImageConversion.LoadImage(texture,File.ReadAllBytes(source+"/"+(string)frame["file"]));
                    var pixels=texture.GetPixels32();int minX=texture.width,minY=texture.height,maxX=-1,maxY=-1;
                    for(int y=0;y<texture.height;y++)for(int x=0;x<texture.width;x++)if(pixels[y*texture.width+x].a!=0)
                    {minX=Math.Min(minX,x);minY=Math.Min(minY,y);maxX=Math.Max(maxX,x);maxY=Math.Max(maxY,y);}
                    var bounds=new HeroFrameBounds{X=minX,Y=minY,Width=Math.Max(0,maxX-minX+1),Height=Math.Max(0,maxY-minY+1),Empty=maxX<0};
                    native.Add((frame,texture.width,texture.height,bounds));if(!bounds.Empty)ground=Math.Min(ground,minY);
                }
                finally{UnityEngine.Object.DestroyImmediate(texture);}
            }
            var keys=new List<ObjectReferenceKeyframe>();
            foreach(var frame in native)
            {
                string filename=(string)frame.frame["file"],path=folder+"/"+filename;File.Copy(source+"/"+filename,path,false);AssetDatabase.ImportAsset(path);
                var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
                importer.spritePixelsPerUnit=25;importer.filterMode=FilterMode.Point;importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;
                importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
                // Move the import pivot to the shared foot/ground plane; retain every source PNG byte.
                float px=group.Item3?124:frame.width*.5f,py=group.Item3?42:ground==int.MaxValue?0:ground;
                Apply(importer,new SpriteRect{name=group.Item1+"_"+Path.GetFileNameWithoutExtension(filename),spriteID=GUID.Generate(),rect=new Rect(0,0,frame.width,frame.height),
                    alignment=SpriteAlignment.Custom,pivot=new Vector2(px/frame.width,py/frame.height)});
                var sprite=AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().Single();float time=(float)frame.frame["time_seconds"];
                keys.Add(new ObjectReferenceKeyframe{time=time,value=sprite});entry.SourceFrames.Add(filename);entry.FrameTimes.Add(time);
                entry.Frames.Add(new HeroFrameBounds{Width=frame.width,Height=frame.height});entry.ContentBounds.Add(frame.bounds);frames++;
            }
            var clip=new AnimationClip{name=group.Item1,frameRate=100};AssetDatabase.CreateAsset(clip,Root+"/Animations/"+group.Item1+".anim");
            AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),keys.ToArray());
            var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=entry.Loop;settings.stopTime=entry.DurationSeconds;AnimationUtility.SetAnimationClipSettings(clip,settings);
            clips.Add(entry.State,clip);manifest.Clips.Add(entry);File.Copy(source+"/animation.json",folder+"/SourceAnimation.json",false);
        }
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,Root+"/BerthaxeSprite.mat");
        Prefab("Berthaxe",clips.Where(p=>groups.Single(g=>g.Item1==p.Key).Item3).ToDictionary(p=>p.Key,p=>p.Value),material,true);
        foreach(var pair in clips.Where(p=>!groups.Single(g=>g.Item1==p.Key).Item3))Prefab(pair.Key,new Dictionary<string,AnimationClip>{{pair.Key,pair.Value}},material,false);
        File.WriteAllText(Root+"/AnimationSet.txt",JsonUtility.ToJson(manifest,true));AssetDatabase.ImportAsset(Root+"/AnimationSet.txt");
        string icon="Assets/Zatod/Resources/HeroPortraits/berthaxe.png";File.Copy(Source+"/Idle/0001.png",icon,false);AssetDatabase.ImportAsset(icon);
        var portrait=(TextureImporter)AssetImporter.GetAtPath(icon);portrait.textureType=TextureImporterType.Sprite;portrait.spriteImportMode=SpriteImportMode.Multiple;
        portrait.filterMode=FilterMode.Point;portrait.mipmapEnabled=false;portrait.textureCompression=TextureImporterCompression.Uncompressed;portrait.SaveAndReimport();
        Apply(portrait,new SpriteRect{name="berthaxe",spriteID=GUID.Generate(),rect=new Rect(93,70,72,72),alignment=SpriteAlignment.Center,pivot=new Vector2(.5f,.5f)});
        File.Copy(Source+"/hero_kit.json",Art+"/SourceKit.json",false);File.Copy(Source+"/README.txt",Art+"/SourceNotes.txt",false);
        Configure(data);HeroConfigFileStore.Save(data,before);
        if(File.ReadAllText(CampaignDataJson.AssetPath)!=campaignBefore)throw new IOException("Campaign changed during import; roster not overwritten.");
        var campaign=JsonUtility.FromJson<CampaignDefinition>(campaignBefore);campaign.StarterHeroIds.Add("berthaxe");campaign.ConfigVersion+="-berthaxe-1";
        _=new CampaignCatalog(campaign,new HeroCatalog(data));HeroDataJson.WriteFileAtomically(CampaignDataJson.AssetPath,JsonUtility.ToJson(campaign,true));
        AssetDatabase.Refresh();LeenaldAtlasBuild.Ensure(Art,Art+"/Berthaxe.spriteatlasv2");AssetDatabase.SaveAssets();
        foreach(var window in Resources.FindObjectsOfTypeAll<GameEditorWindow>())window.ReloadIfClean();foreach(var window in Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>())window.CreateGUI();
        return new{hero="berthaxe",frames,clips=clips.Count,data.ConfigVersion};
    }
    static void Apply(TextureImporter importer,SpriteRect rect)
    {
        var provider=factories.GetSpriteEditorDataProviderFromObject(importer);if(provider==null)throw new Exception("Sprite provider unavailable.");provider.InitSpriteEditorDataProvider();
        var cap=provider.GetDataProvider<ISpriteFrameEditCapability>();if(cap==null)throw new Exception("Sprite editing unsupported.");
        foreach(var c in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteName,EEditCapability.EditSpriteRect,EEditCapability.EditPivot})
            if(!cap.GetEditCapability().HasCapability(c))throw new Exception("Unsupported sprite capability: "+c);
        var ids=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();if(ids==null)throw new Exception("Stable IDs unavailable.");
        provider.SetSpriteRects(new[]{rect});ids.SetNameFileIdPairs(new[]{new SpriteNameFileIdPair(rect.name,rect.spriteID)});provider.Apply();importer.SaveAndReimport();
    }
    static void Prefab(string name,Dictionary<string,AnimationClip> clips,Material material,bool body)
    {
        var controller=AnimatorController.CreateAnimatorControllerAtPath(Root+"/"+name+".controller");var states=new Dictionary<string,AnimatorState>();
        foreach(var pair in clips){var s=controller.layers[0].stateMachine.AddState(pair.Key);s.motion=pair.Value;s.writeDefaultValues=false;states.Add(pair.Key,s);
            if(pair.Key=="Idle" || clips.Count==1)controller.layers[0].stateMachine.defaultState=s;}
        if(body)foreach(var pair in states.Where(p=>p.Key!="Idle" && p.Key!="Run" && p.Key!="Death" && p.Key!="Stun"))
        {var t=pair.Value.AddTransition(states["Idle"]);t.hasExitTime=true;t.exitTime=1;t.duration=0;}
        var go=new GameObject(name);try{var renderer=go.AddComponent<SpriteRenderer>();renderer.sharedMaterial=material;
            renderer.sprite=(Sprite)AnimationUtility.GetObjectReferenceCurve(clips.ContainsKey("Idle")?clips["Idle"]:clips.Values.First(),EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;
            go.AddComponent<Animator>().runtimeAnimatorController=controller;if(body)go.AddComponent<HeroAnimationPlayer>().HeroId="berthaxe";else go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds=3;
            PrefabUtility.SaveAsPrefabAsset(go,Root+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(go);}
    }
    static SkillEffectDefinition Damage(int scale)=>new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=scale};
    static SkillSequenceCue A(int time,SkillSequenceAction action)=>new SkillSequenceCue{DelayMilliseconds=time,Action=action};
    static SkillVisualCue V(string state,int time,int duration,int forward=0)=>new SkillVisualCue{State=state,DelayMilliseconds=time,DurationMilliseconds=duration,Forward=forward};
    static SkillMotionKey M(int time,int forward,int height=0)=>new SkillMotionKey{TimeMilliseconds=time,Forward=forward,Height=height};
    static void Configure(HeroCatalogData data)
    {
        var hero=JsonUtility.FromJson<HeroDefinition>(JsonUtility.ToJson(data.Heroes.Single(h=>h.Id=="training_warrior")));
        hero.Id="berthaxe";hero.Name="Berthaxe";hero.Position=HeroPosition.Front;hero.PortraitKey=hero.Id;hero.BodyPrefabResource=Key+"Berthaxe";hero.AnimationSetResource=Key+"AnimationSet";
        hero.NormalAttackSkillId="berthaxe_normal_attack";hero.ProjectileHurtboxHeight=230;hero.DeathAnimationMilliseconds=2010;
        hero.SpawnPoints=new List<HeroSpawnPointDefinition>{new HeroSpawnPointDefinition{Id="ground",Forward=200,Height=0}};
        hero.BaseStats=new List<StatValue>{new StatValue("health",5200),new StatValue("damage",240),new StatValue("defense",50),new StatValue("attack_range",3100),new StatValue("move_speed",1300),new StatValue("attack_interval",24)};
        hero.SkillSlots=new List<HeroSkillSlotDefinition>{new HeroSkillSlotDefinition{Id="ultimate",SkillId="berthaxe_ultimate",IsUltimate=true},new HeroSkillSlotDefinition{Id="skill_2",SkillId="berthaxe_skill2"},
            new HeroSkillSlotDefinition{Id="skill_3",SkillId="berthaxe_skill3"},new HeroSkillSlotDefinition{Id="skill_4",SkillId="berthaxe_skill4"}};data.Heroes.Add(hero);
        var basic=new SkillDefinition{Id=hero.NormalAttackSkillId,Name="Berthaxe / Trong Phu",AnimationState="NormalAttack",Target=SkillTarget.NearestEnemy,CastRange=3100,Effects=new List<SkillEffectDefinition>{Damage(10000)}};
        var hit=A(1100,SkillSequenceAction.Effects);hit.RequireAttackRange=true;basic.CastSequences.Add(new SkillCastSequence{AnimationState="NormalAttack",DurationMilliseconds=2600,ReleaseMilliseconds=1100,Actions=new List<SkillSequenceCue>{hit}});data.Skills.Add(basic);
        var ultimate=new SkillDefinition{Id="berthaxe_ultimate",Name="Berthaxe / Dia Chan Lien Hoan",AnimationState="Ultimate",Activation=SkillActivation.UltimateIntent,EnergyCost=100,
            Target=SkillTarget.FarthestEnemy,CastRange=12000,Delivery=SkillDelivery.Projectile,ProjectileResource=Key+"EarthEruption",ProjectileFlightState="EarthEruption",
            ProjectileSpawnPointId="ground",ProjectileAim=ProjectileAim.Forward,ProjectileSpeed=6000,ProjectileHitRadius=50,ProjectileMaxHits=5,
            ProjectileSpawnMilliseconds=600,ProjectileLifetimeMilliseconds=2100,ProjectileVisualScaleBasisPoints=10000,ImpactOnGround=true,
            Effects=new List<SkillEffectDefinition>{Damage(20000),new SkillEffectDefinition{Kind=SkillEffectKind.KnockUp,DurationMilliseconds=300,KnockUpHeight=80},
                new SkillEffectDefinition{Kind=SkillEffectKind.Stun,DurationMilliseconds=1100}}};
        var earth=new SkillCastSequence{AnimationState="Ultimate",DurationMilliseconds=2210,ReleaseMilliseconds=600,ContinueAfterRelease=true,Actions=new List<SkillSequenceCue>{A(600,SkillSequenceAction.Projectile)}};
        for(int x=200;x<=12200;x+=400){var v=V("EarthEruption",600+(x-200)*1000/6000,1000,x);v.FollowCaster=false;earth.Visuals.Add(v);}ultimate.CastSequences.Add(earth);data.Skills.Add(ultimate);
        var spin=new SkillDefinition{Id="berthaxe_skill2",Name="Berthaxe / Cuong Phong Chien Phu",AnimationState="Skill2",Target=SkillTarget.EnemiesInRange,CastRange=3400,
            EffectRadius=4100,CooldownMilliseconds=11000,Effects=new List<SkillEffectDefinition>{Damage(3000)}};
        var whirl=new SkillCastSequence{AnimationState="Skill2",DurationMilliseconds=4661,ReleaseMilliseconds=950,
            Motion=new List<SkillMotionKey>{M(0,0),M(750,0),M(1050,600),M(4661,600)}};
        for(int i=0;i<9;i++)whirl.Actions.Add(A(950+300*i,SkillSequenceAction.Effects));var finish=A(3650,SkillSequenceAction.Effects);finish.DamageMultiplierBasisPoints=45000;whirl.Actions.Add(finish);
        spin.CastSequences.Add(whirl);data.Skills.Add(spin);
        var slam=new SkillDefinition{Id="berthaxe_skill3",Name="Berthaxe / Thien Phu Giang Dia",AnimationState="Skill3",Target=SkillTarget.NearestEnemy,CastRange=3500,EffectRadius=1100,
            CooldownMilliseconds=10000,Effects=new List<SkillEffectDefinition>{Damage(20000),new SkillEffectDefinition{Kind=SkillEffectKind.KnockUp,DurationMilliseconds=500,KnockUpHeight=120}}};
        var explosion=V("EarthExplosion",1470,813);explosion.FollowCaster=false;explosion.AtTarget=true;
        var eruption=V("EarthEruption",1470,1000);eruption.FollowCaster=false;eruption.AtTarget=true;
        slam.CastSequences.Add(new SkillCastSequence{AnimationState="Skill3",DurationMilliseconds=3850,ReleaseMilliseconds=1470,Actions=new List<SkillSequenceCue>{A(1470,SkillSequenceAction.AreaPulse)},
            Motion=new List<SkillMotionKey>{M(0,0),M(580,0),M(800,140,150),M(1050,350,260),M(1250,500,190),M(1470,600),M(3850,600)},Visuals=new List<SkillVisualCue>{explosion,eruption}});data.Skills.Add(slam);
        var wave=new SkillDefinition{Id="berthaxe_skill4",Name="Berthaxe / Liet Dia Tram",AnimationState="Skill4",Target=SkillTarget.NearestEnemy,CastRange=8000,CooldownMilliseconds=8000,
            Delivery=SkillDelivery.Projectile,ProjectileResource=Key+"ShockWave",ProjectileFlightState="ShockWave",ProjectileImpactState="ShockHit",ProjectileImpactDurationMilliseconds=417,
            ProjectileSpawnPointId="ground",ProjectileAim=ProjectileAim.Forward,ProjectileSpawnMilliseconds=600,ProjectileSpeed=5000,ProjectileHitRadius=50,ProjectileMaxHits=5,
            ProjectileLifetimeMilliseconds=1700,ProjectileVisualScaleBasisPoints=10000,ImpactOnGround=true,Effects=new List<SkillEffectDefinition>{Damage(16000)}};
        wave.CastSequences.Add(new SkillCastSequence{AnimationState="Skill4",DurationMilliseconds=2201,ReleaseMilliseconds=600,ContinueAfterRelease=true,Actions=new List<SkillSequenceCue>{A(600,SkillSequenceAction.Projectile)}});data.Skills.Add(wave);
        TuneRoster(data);data.ConfigVersion+="-berthaxe-1-six-hero-reach-1";
    }
    public static object UpdateRosterRanges()
    {
        var before=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(before).Data;
        if(!data.Heroes.Any(h=>h.Id=="berthaxe"))throw new Exception("Import Berthaxe first.");
        TuneRoster(data);data.ConfigVersion+="-six-hero-reach-1";HeroConfigFileStore.Save(data,before);AssetDatabase.Refresh();
        return new{updated=true,data.ConfigVersion};
    }
    static void TuneRoster(HeroCatalogData data)
    {
        // Keep the existing fixed walking queue viable with three Front and three Rear Heroes.
        foreach(var pair in new[]{("kavern",4000),("enchantx",5000),("lilina",6000)})
            data.Heroes.Single(h=>h.Id==pair.Item1).BaseStats.Single(s=>s.StatId=="attack_range").Value=pair.Item2;
        void Range(int range,params string[] ids){foreach(string id in ids)data.Skills.Single(s=>s.Id==id).CastRange=range;}
        Range(4000,"kavern_normal_attack","kavern_skill2","kavern_skill4");Range(4800,"kavern_ultimate","kavern_skill3");
        Range(5000,"enchantx_normal_attack","enchantx_skill4");Range(5400,"enchantx_ultimate","enchantx_skill2");
        Range(6000,"lilina_normal_attack","lilina_ultimate","lilina_skill4");Range(9000,"lilina_skill2","lilina_skill3");
        foreach(string id in new[]{"kavern_normal_attack","kavern_skill2","kavern_skill4","enchantx_normal_attack","enchantx_skill4"})
            data.Skills.Single(s=>s.Id==id).ProjectileLifetimeMilliseconds=3000;
        data.Skills.Single(s=>s.Id=="lilina_skill2").ProjectileLifetimeMilliseconds=3500;
        data.Skills.Single(s=>s.Id=="lilina_skill3").ProjectileLifetimeMilliseconds=4000;
    }
}
