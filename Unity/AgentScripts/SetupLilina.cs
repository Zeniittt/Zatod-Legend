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

public static class SetupLilina
{
    const string Source="C:/Users/tinnq/OneDrive/Desktop/He/ExportedProject/SalamanderWitch_HeroKit";
    const string Art="Assets/Zatod/Art/Lilina",Root="Assets/Zatod/Resources/Heroes/Lilina",Key="Heroes/Lilina/";
    static SpriteDataProviderFactories factories;
    public static object Run()
    {
        if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before importing Lilina.");
        var before=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(before).Data;
        if(data.Heroes.Any(h=>h.Id=="lilina") || Directory.Exists(Art))throw new InvalidOperationException("Lilina exists; will not overwrite.");
        factories=new SpriteDataProviderFactories();factories.Init();Directory.CreateDirectory(Art);Directory.CreateDirectory(Root+"/Animations");AssetDatabase.Refresh();
        var groups=new[]{("Idle","Idle",true),("Run","Run",true),("Death","Death",true),("Stun","Takehit",true),("NormalAttack","NormalAttack",true),
            ("UltimateOriginal","Ultimate",true),("Skill2","Skill2",true),("Skill3","Skill3",true),("Skill4Original","Skill4",true),
            ("Ultimate","Reference_Reconstruction/DragonActor",true),("Skill4","Reference_Reconstruction/FlamerActor",true),
            ("DragonBreath","Reference_Reconstruction/DragonBreath",false),("FlamerBreath","Reference_Reconstruction/FlamerBreath",false),
            ("FireCasted","Projectiles/FireBall/Casted",false),("FireFlight","Projectiles/FireBall/Triggered",false),("FireHit","Projectiles/FireBall/Hit",false),("FireDissipate","Projectiles/FireBall/Dissipate",false),
            ("TwinsCasted","Projectiles/ThunderTwins/Casted",false),("TwinsFlight","Projectiles/ThunderTwins/Triggered",false),("TwinsHit","Projectiles/ThunderTwins/Trigger",false),("TwinsDissipate","Projectiles/ThunderTwins/Dissipate",false),
            ("BoltCasted","Projectiles/ThunderBolt/Casted",false),("BoltFlight","Projectiles/ThunderBolt/Triggered",false),("BoltHit","Projectiles/ThunderBolt/Trigger",false),("BoltDissipate","Projectiles/ThunderBolt/Dissipate",false),
            ("BurnEmbers","Effects/Infierno/Triggered",false)};
        var manifest=new HeroAnimationSetData{HeroId="lilina",PixelsPerUnit=25,CanvasWidth=205,CanvasHeight=114,AnchorPixelX=81,AnchorPixelY=25};
        var clips=new Dictionary<string,AnimationClip>();int frames=0;
        foreach(var group in groups)
        {
            string source=Source+"/"+group.Item2;var json=JObject.Parse(File.ReadAllText(source+"/animation.json"));
            var bytes=File.ReadAllBytes(source+"/"+(string)json["frames"][0]["file"]);
            int Int(int i)=>(bytes[i]<<24)|(bytes[i+1]<<16)|(bytes[i+2]<<8)|bytes[i+3];int width=Int(16),height=Int(20);
            bool reconstructed=group.Item2.StartsWith("Reference_Reconstruction/");Vector2 pivot;
            if(reconstructed)pivot=new Vector2((float)json["pivot_pixels_top_left"][0],height-(float)json["pivot_pixels_top_left"][1]);
            else if(group.Item3)pivot=new Vector2(81,25);
            else pivot=new Vector2((float)json["canvas"]["anchor_bottom_left"][0],(float)json["canvas"]["anchor_bottom_left"][1]);
            string folder=Art+"/"+group.Item1;Directory.CreateDirectory(folder);AssetDatabase.Refresh();
            var entry=new HeroAnimationClipData{State=group.Item1,SourceFolder=source,ClipResource=Key+"Animations/"+group.Item1,
                SourceDurationSeconds=(float)json["duration_seconds"],Loop=group.Item1=="Idle"||group.Item1=="Run"||group.Item1.EndsWith("Flight")||group.Item1=="BurnEmbers",
                Projectile=group.Item1.EndsWith("Flight"),PreserveSpritePivot=true};
            var keys=new List<ObjectReferenceKeyframe>();
            foreach(var frame in json["frames"])
            {
                string filename=(string)frame["file"],path=folder+"/"+filename;File.Copy(source+"/"+filename,path,false);AssetDatabase.ImportAsset(path);
                var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
                importer.spritePixelsPerUnit=25;importer.filterMode=FilterMode.Point;importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;
                importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
                Apply(importer,new SpriteRect{name=group.Item1+"_"+Path.GetFileNameWithoutExtension(filename),spriteID=GUID.Generate(),rect=new Rect(0,0,width,height),alignment=SpriteAlignment.Custom,
                    pivot=new Vector2(pivot.x/width,pivot.y/height)});
                var sprite=AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().Single();float time=(float)frame["time_seconds"];
                keys.Add(new ObjectReferenceKeyframe{time=time,value=sprite});entry.SourceFrames.Add(filename);entry.FrameTimes.Add(time);entry.Frames.Add(new HeroFrameBounds{Width=width,Height=height});frames++;
            }
            var clip=new AnimationClip{name=group.Item1,frameRate=100};AssetDatabase.CreateAsset(clip,Root+"/Animations/"+group.Item1+".anim");
            AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),keys.ToArray());
            var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=entry.Loop;settings.stopTime=entry.DurationSeconds;AnimationUtility.SetAnimationClipSettings(clip,settings);
            clips.Add(entry.State,clip);manifest.Clips.Add(entry);File.Copy(source+"/animation.json",folder+"/SourceAnimation.json",false);
        }
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,Root+"/LilinaSprite.mat");
        Prefab("Lilina",clips.Where(p=>groups.Single(g=>g.Item1==p.Key).Item3).ToDictionary(p=>p.Key,p=>p.Value),material,true);
        foreach(var pair in clips.Where(p=>!groups.Single(g=>g.Item1==p.Key).Item3))Prefab(pair.Key,new Dictionary<string,AnimationClip>{{pair.Key,pair.Value}},material,false);
        File.WriteAllText(Root+"/AnimationSet.txt",JsonUtility.ToJson(manifest,true));AssetDatabase.ImportAsset(Root+"/AnimationSet.txt");
        string icon="Assets/Zatod/Resources/HeroPortraits/lilina.png";File.Copy(Source+"/Idle/0001.png",icon,false);AssetDatabase.ImportAsset(icon);
        var portrait=(TextureImporter)AssetImporter.GetAtPath(icon);portrait.textureType=TextureImporterType.Sprite;portrait.spriteImportMode=SpriteImportMode.Multiple;
        portrait.filterMode=FilterMode.Point;portrait.mipmapEnabled=false;portrait.textureCompression=TextureImporterCompression.Uncompressed;portrait.SaveAndReimport();
        Apply(portrait,new SpriteRect{name="lilina",spriteID=GUID.Generate(),rect=new Rect(56,23,58,65),alignment=SpriteAlignment.Center,pivot=new Vector2(.5f,.5f)});
        File.Copy(Source+"/hero_kit.json",Art+"/SourceKit.json",false);File.Copy(Source+"/README.txt",Art+"/SourceNotes.txt",false);
        Configure(data);HeroConfigFileStore.Save(data,before);AssetDatabase.Refresh();LeenaldAtlasBuild.Ensure(Art,Art+"/Lilina.spriteatlasv2");AssetDatabase.SaveAssets();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroBalanceWindow>())window.ReloadIfClean();foreach(var window in Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>())window.CreateGUI();
        return new{hero="lilina",frames,clips=clips.Count,data.ConfigVersion};
    }
    static void Apply(TextureImporter importer,SpriteRect rect)
    {
        var provider=factories.GetSpriteEditorDataProviderFromObject(importer);if(provider==null)throw new InvalidOperationException("Sprite provider unavailable");
        provider.InitSpriteEditorDataProvider();var cap=provider.GetDataProvider<ISpriteFrameEditCapability>();if(cap==null)throw new InvalidOperationException("Sprite capability unavailable");
        foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteName,EEditCapability.EditSpriteRect,EEditCapability.EditPivot})
            if(!cap.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Unsupported sprite edit: "+required);
        var ids=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();if(ids==null)throw new InvalidOperationException("Sprite stable IDs unavailable");
        provider.SetSpriteRects(new[]{rect});ids.SetNameFileIdPairs(new[]{new SpriteNameFileIdPair(rect.name,rect.spriteID)});provider.Apply();importer.SaveAndReimport();
    }
    static void Prefab(string name,Dictionary<string,AnimationClip> clips,Material material,bool body)
    {
        var controller=AnimatorController.CreateAnimatorControllerAtPath(Root+"/"+name+".controller");var states=new Dictionary<string,AnimatorState>();
        foreach(var pair in clips){var state=controller.layers[0].stateMachine.AddState(pair.Key);state.motion=pair.Value;state.writeDefaultValues=false;states.Add(pair.Key,state);
            if(pair.Key=="Idle"||clips.Count==1)controller.layers[0].stateMachine.defaultState=state;}
        if(body)foreach(var state in states.Where(p=>p.Key!="Idle"&&p.Key!="Run"&&p.Key!="Death"&&p.Key!="Stun").Select(p=>p.Value))
        {var t=state.AddTransition(states["Idle"]);t.hasExitTime=true;t.exitTime=1;t.duration=0;}
        var go=new GameObject(name);try{var r=go.AddComponent<SpriteRenderer>();r.sharedMaterial=material;
            r.sprite=(Sprite)AnimationUtility.GetObjectReferenceCurve(clips.ContainsKey("Idle")?clips["Idle"]:clips.Values.First(),EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;
            go.AddComponent<Animator>().runtimeAnimatorController=controller;if(body)go.AddComponent<HeroAnimationPlayer>().HeroId="lilina";else go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds=5;
            PrefabUtility.SaveAsPrefabAsset(go,Root+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(go);}
    }
    static SkillEffectDefinition Damage(int scale)=>new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=scale};
    static SkillSequenceCue A(int time,SkillSequenceAction action)=>new SkillSequenceCue{DelayMilliseconds=time,Action=action};
    static SkillVisualCue V(string state,int time,int duration,int forward=0,int height=0)=>new SkillVisualCue{State=state,DelayMilliseconds=time,DurationMilliseconds=duration,
        FollowCaster=true,Forward=forward,Height=height};
    static SkillDefinition Shot(string id,string name,string state,string resource,string flight,string hit,int scale)=>new SkillDefinition{Id=id,Name="Lilina / "+name,
        Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,AnimationState=state,CastRange=5000,Delivery=SkillDelivery.Projectile,ProjectileResource=Key+resource,
        ProjectileFlightState=flight,ProjectileImpactState=hit,ProjectileImpactDurationMilliseconds=584,ProjectileSpawnPointId="hand",ProjectileSpeed=2400,ProjectileHitRadius=30,
        ProjectileLifetimeMilliseconds=3000,ProjectileVisualScaleBasisPoints=10000,DescendingProjectile=true,ProjectileTargetHeight=80,Effects=new List<SkillEffectDefinition>{Damage(scale)}};
    static void Configure(HeroCatalogData data)
    {
        var hero=JsonUtility.FromJson<HeroDefinition>(JsonUtility.ToJson(data.Heroes.Single(h=>h.Id=="training_warrior")));
        hero.Id="lilina";hero.Name="Lilina";hero.Position=HeroPosition.Rear;hero.PortraitKey=hero.Id;hero.BodyPrefabResource=Key+"Lilina";hero.AnimationSetResource=Key+"AnimationSet";
        hero.NormalAttackSkillId="lilina_normal_attack";hero.ProjectileHurtboxHeight=256;hero.DeathAnimationMilliseconds=3080;
        hero.SpawnPoints=new List<HeroSpawnPointDefinition>{new HeroSpawnPointDefinition{Id="hand",Forward=120,Height=120},new HeroSpawnPointDefinition{Id="dragon",Forward=180,Height=116}};
        hero.BaseStats=new List<StatValue>{new StatValue("health",2600),new StatValue("damage",230),new StatValue("defense",15),new StatValue("attack_range",3000),new StatValue("move_speed",1300),new StatValue("attack_interval",24)};
        hero.SkillSlots=new List<HeroSkillSlotDefinition>{new HeroSkillSlotDefinition{Id="ultimate",SkillId="lilina_ultimate",IsUltimate=true},new HeroSkillSlotDefinition{Id="skill_2",SkillId="lilina_skill2"},
            new HeroSkillSlotDefinition{Id="skill_3",SkillId="lilina_skill3"},new HeroSkillSlotDefinition{Id="skill_4",SkillId="lilina_skill4"}};data.Heroes.Add(hero);
        var normal=Shot(hero.NormalAttackSkillId,"Hoa Tien","NormalAttack","FireFlight","FireFlight","FireHit",6500);
        normal.ProjectileSpawnMilliseconds=280;normal.CastSequences.Add(new SkillCastSequence{AnimationState="NormalAttack",DurationMilliseconds=1361,ReleaseMilliseconds=280,
            Actions=new List<SkillSequenceCue>{A(280,SkillSequenceAction.Projectile),A(1000,SkillSequenceAction.Projectile)}});data.Skills.Add(normal);
        var ultimate=new SkillDefinition{Id="lilina_ultimate",Name="Lilina / Long Viem Huy Diet",Kind=SkillKind.Active,Activation=SkillActivation.UltimateIntent,
            Target=SkillTarget.EnemiesInLine,EnergyCost=100,CastRange=5000,Delivery=SkillDelivery.Beam,ProjectileSpawnPointId="dragon",ProjectileHitRadius=60,
            Effects=new List<SkillEffectDefinition>{Damage(6000)}};
        var dragon=V("DragonBreath",0,4060,180,116);dragon.StretchToRange=true;
        var seq=new SkillCastSequence{AnimationState="Ultimate",DurationMilliseconds=4060,ReleaseMilliseconds=1960,Visuals=new List<SkillVisualCue>{dragon}};
        for(int i=0;i<6;i++)seq.Actions.Add(A(2150+280*i,SkillSequenceAction.Effects));ultimate.CastSequences.Add(seq);data.Skills.Add(ultimate);
        var bolt=Shot("lilina_skill2","Loi Quang Xuyen Tran","Skill2","BoltFlight","BoltFlight","BoltDissipate",16000);
        bolt.Target=SkillTarget.FarthestEnemy;bolt.CooldownMilliseconds=9000;bolt.ProjectileAim=ProjectileAim.Forward;bolt.ProjectileMaxHits=5;bolt.ProjectileHitOffsetForward=400;
        bolt.ProjectileSpawnMilliseconds=1360;bolt.ProjectileSpeed=2800;bolt.CastSequences.Add(new SkillCastSequence{AnimationState="Skill2",DurationMilliseconds=2690,ReleaseMilliseconds=1360,
            Actions=new List<SkillSequenceCue>{A(1360,SkillSequenceAction.Projectile)}});data.Skills.Add(bolt);
        var twins=Shot("lilina_skill3","Song Loi Truy Menh","Skill3","TwinsFlight","TwinsFlight","TwinsDissipate",14000);
        twins.Target=SkillTarget.LowestHealthEnemy;twins.CooldownMilliseconds=8000;twins.ProjectileTargetOnly=true;twins.ProjectileTracksTarget=true;twins.ProjectileSpawnMilliseconds=920;
        var twinSeq=new SkillCastSequence{AnimationState="Skill3",DurationMilliseconds=1761,ReleaseMilliseconds=920};
        for(int i=0;i<2;i++){var cue=A(920+i*100,SkillSequenceAction.Projectile);cue.SelectTargetByIndex=true;cue.TargetOrder=SequenceTargetOrder.LowestHealth;cue.TargetIndex=i;twinSeq.Actions.Add(cue);}twins.CastSequences.Add(twinSeq);data.Skills.Add(twins);
        var flamer=new SkillDefinition{Id="lilina_skill4",Name="Lilina / Hoa Tuc Thieu Dot",Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,CastRange=3200,CooldownMilliseconds=10000,
            Effects=new List<SkillEffectDefinition>{Damage(7000),new SkillEffectDefinition{Kind=SkillEffectKind.Burn,DamageScaleBasisPoints=2500,DurationMilliseconds=1670,
                TickIntervalMilliseconds=400,FirstTickDelayMilliseconds=470,VisualState="BurnEmbers"}}};
        var breath=V("FlamerBreath",0,1620,112,112);breath.StretchToTarget=true;
        var fireSeq=new SkillCastSequence{AnimationState="Skill4",DurationMilliseconds=1620,ReleaseMilliseconds=490,Visuals=new List<SkillVisualCue>{breath}};
        for(int i=0;i<4;i++)fireSeq.Actions.Add(A(600+i*200,SkillSequenceAction.Effects));flamer.CastSequences.Add(fireSeq);data.Skills.Add(flamer);
        data.ConfigVersion+="-lilina-1";
    }
}
