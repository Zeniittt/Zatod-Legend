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

public static class SetupBlooesperod
{
    const string Source="C:/Users/tinnq/OneDrive/Desktop/He/ExportedProject/NightLord_HeroKit";
    const string Art="Assets/Zatod/Art/Blooesperod",Root="Assets/Zatod/Resources/Heroes/Blooesperod",Key="Heroes/Blooesperod/";
    static SpriteDataProviderFactories factories;
    public static object Run()
    {
        if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before importing this Hero.");
        var before=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(before).Data;
        if(data.Heroes.Any(h=>h.Id=="blooesperod") || Directory.Exists(Art))throw new InvalidOperationException("Blooesperod exists; no overwrite.");
        factories=new SpriteDataProviderFactories();factories.Init();
        Directory.CreateDirectory(Art);Directory.CreateDirectory(Root+"/Animations");AssetDatabase.Refresh();
        var set=new HeroAnimationSetData{HeroId="blooesperod",PixelsPerUnit=25,CanvasWidth=178,CanvasHeight=97,AnchorPixelX=100,AnchorPixelY=19};
        var clips=new Dictionary<string,AnimationClip>();int frames=0;
        var groups=new[]{("Idle","Idle",true),("Run","Run",true),("Death","Death",true),("Stun","Takehit",true),
            ("NormalAttack","NormalAttack",true),("Ultimate","Ultimate",true),("Skill2","Skill2",true),("Skill3","Skill3",true),("Skill4","Skill4",true),
            ("SoulCasted","Effects/TormentedSouls/Casted",false),("SoulFlight","Effects/TormentedSouls/Triggered",false),
            ("SoulHit","Effects/TormentedSouls/Hit",false),("SoulDissipate","Effects/TormentedSouls/Dissipate",false),
            ("NightSummon","Effects/NightSummon/Casted",false),("NightDissipate","Effects/NightSummon/Dissipate",false),
            ("CapeDash","Effects/CapeFX/DashFX",false),("BloodSlash1","Effects/BloodSlash/Slash",false),
            ("BloodSlash2","Effects/BloodSlash2/Slash",false),("BloodSlash3","Effects/BloodSlash3/Slash",false)};
        foreach(var group in groups)
        {
            var json=JObject.Parse(File.ReadAllText(Source+"/"+group.Item2+"/animation.json"));
            var canvas=json["canvas"];int width=(int)canvas["width"],height=(int)canvas["height"];
            var anchor=group.Item3?new Vector2(100,19):new Vector2((float)canvas["anchor_bottom_left"][0],(float)canvas["anchor_bottom_left"][1]);
            string folder=Art+"/"+group.Item1;Directory.CreateDirectory(folder);AssetDatabase.Refresh();
            var entry=new HeroAnimationClipData{State=group.Item1,SourceFolder=Source+"/"+group.Item2,ClipResource=Key+"Animations/"+group.Item1,
                SourceDurationSeconds=(float)json["duration_seconds"],Loop=group.Item1=="Idle"||group.Item1=="Run"||group.Item1=="SoulFlight",
                Projectile=group.Item1=="SoulFlight",PreserveSpritePivot=true};
            var keys=new List<ObjectReferenceKeyframe>();
            foreach(var frame in json["frames"])
            {
                string filename=(string)frame["file"],path=folder+"/"+filename;
                File.Copy(Source+"/"+group.Item2+"/"+filename,path,false);AssetDatabase.ImportAsset(path);
                var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Multiple;
                importer.spritePixelsPerUnit=25;importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;
                importer.filterMode=FilterMode.Point;importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
                Apply(importer,new SpriteRect{name=group.Item1+"_"+Path.GetFileNameWithoutExtension(filename),spriteID=GUID.Generate(),
                    rect=new Rect(0,0,width,height),alignment=SpriteAlignment.Custom,pivot=new Vector2(anchor.x/width,anchor.y/height)});
                var sprite=AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().Single();float time=(float)frame["time_seconds"];
                keys.Add(new ObjectReferenceKeyframe{time=time,value=sprite});entry.FrameTimes.Add(time);entry.SourceFrames.Add(filename);
                entry.Frames.Add(new HeroFrameBounds{Width=width,Height=height});frames++;
            }
            var clip=new AnimationClip{name=group.Item1,frameRate=100};AssetDatabase.CreateAsset(clip,Root+"/Animations/"+group.Item1+".anim");
            AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),keys.ToArray());
            var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=entry.Loop;settings.stopTime=entry.DurationSeconds;AnimationUtility.SetAnimationClipSettings(clip,settings);
            set.Clips.Add(entry);clips.Add(entry.State,clip);File.Copy(Source+"/"+group.Item2+"/animation.json",folder+"/SourceAnimation.json",false);
        }
        var soulReturn=JsonUtility.FromJson<HeroAnimationClipData>(JsonUtility.ToJson(set.Clips.Single(c=>c.State=="SoulFlight")));
        soulReturn.State="SoulReturn";set.Clips.Add(soulReturn);
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,Root+"/BlooesperodSprite.mat");
        Prefab("Blooesperod",clips.Where(p=>groups.Single(g=>g.Item1==p.Key).Item3).ToDictionary(p=>p.Key,p=>p.Value),material,true);
        foreach(var pair in clips.Where(p=>!groups.Single(g=>g.Item1==p.Key).Item3))Prefab(pair.Key,new Dictionary<string,AnimationClip>{{pair.Key,pair.Value}},material,false);
        File.WriteAllText(Root+"/AnimationSet.txt",JsonUtility.ToJson(set,true));AssetDatabase.ImportAsset(Root+"/AnimationSet.txt");
        string icon="Assets/Zatod/Resources/HeroPortraits/blooesperod.png";File.Copy(Source+"/Idle/0001.png",icon,false);AssetDatabase.ImportAsset(icon);
        var portrait=(TextureImporter)AssetImporter.GetAtPath(icon);portrait.textureType=TextureImporterType.Sprite;portrait.spriteImportMode=SpriteImportMode.Multiple;
        portrait.filterMode=FilterMode.Point;portrait.mipmapEnabled=false;portrait.textureCompression=TextureImporterCompression.Uncompressed;portrait.SaveAndReimport();
        Apply(portrait,new SpriteRect{name="blooesperod",spriteID=GUID.Generate(),rect=new Rect(72,16,58,60),alignment=SpriteAlignment.Center,pivot=new Vector2(.5f,.5f)});
        File.Copy(Source+"/README.txt",Art+"/SourceNotes.txt",false);File.Copy(Source+"/hero_kit.json",Art+"/SourceKit.json",false);
        Configure(data);HeroConfigFileStore.Save(data,before);AssetDatabase.Refresh();LeenaldAtlasBuild.Ensure(Art,Art+"/Blooesperod.spriteatlasv2");AssetDatabase.SaveAssets();
        foreach(var window in Resources.FindObjectsOfTypeAll<GameEditorWindow>())window.ReloadIfClean();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>())window.CreateGUI();
        return new{hero="blooesperod",frames,clips=clips.Count,data.ConfigVersion};
    }
    static void Apply(TextureImporter importer,SpriteRect rect)
    {
        var provider=factories.GetSpriteEditorDataProviderFromObject(importer);if(provider==null)throw new InvalidOperationException("No sprite provider");
        provider.InitSpriteEditorDataProvider();var capability=provider.GetDataProvider<ISpriteFrameEditCapability>();
        if(capability==null)throw new InvalidOperationException("No sprite capabilities");
        foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteName,EEditCapability.EditSpriteRect,EEditCapability.EditPivot})
            if(!capability.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Unsupported sprite operation: "+required);
        var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();if(names==null)throw new InvalidOperationException("No stable sprite IDs");
        provider.SetSpriteRects(new[]{rect});names.SetNameFileIdPairs(new[]{new SpriteNameFileIdPair(rect.name,rect.spriteID)});provider.Apply();importer.SaveAndReimport();
    }
    static void Prefab(string name,Dictionary<string,AnimationClip> clips,Material material,bool body)
    {
        var controller=AnimatorController.CreateAnimatorControllerAtPath(Root+"/"+name+".controller");
        foreach(var pair in clips){var state=controller.layers[0].stateMachine.AddState(pair.Key);state.motion=pair.Value;state.writeDefaultValues=false;
            if(pair.Key=="Idle"||clips.Count==1)controller.layers[0].stateMachine.defaultState=state;}
        if(body)
        {
            var states=controller.layers[0].stateMachine.states.ToDictionary(s=>s.state.name,s=>s.state);
            foreach(var state in states.Where(p=>p.Key!="Idle" && p.Key!="Run" && p.Key!="Stun" && p.Key!="Death").Select(p=>p.Value))
            {var transition=state.AddTransition(states["Idle"]);transition.hasExitTime=true;transition.exitTime=1;transition.duration=0;}
        }
        var go=new GameObject(name);try{var renderer=go.AddComponent<SpriteRenderer>();renderer.sharedMaterial=material;
            renderer.sprite=(Sprite)AnimationUtility.GetObjectReferenceCurve(clips.ContainsKey("Idle")?clips["Idle"]:clips.Values.First(),EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;
            go.AddComponent<Animator>().runtimeAnimatorController=controller;
            if(body)go.AddComponent<HeroAnimationPlayer>().HeroId="blooesperod";else go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds=3;
            PrefabUtility.SaveAsPrefabAsset(go,Root+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(go);}
    }
    static SkillEffectDefinition Damage(int scale)=>new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=scale};
    static SkillSequenceCue A(int time,SkillSequenceAction action)=>new SkillSequenceCue{DelayMilliseconds=time,Action=action};
    static SkillVisualCue V(string state,int time,int duration,bool atTarget=false,int forward=0,int height=0)=>new SkillVisualCue{
        State=state,DelayMilliseconds=time,DurationMilliseconds=duration,AtTarget=atTarget,FollowCaster=!atTarget,Forward=forward,Height=height};
    static void Configure(HeroCatalogData data)
    {
        var hero=JsonUtility.FromJson<HeroDefinition>(JsonUtility.ToJson(data.Heroes.Single(h=>h.Id=="training_warrior")));
        hero.Id="blooesperod";hero.Name="Blooesperod";hero.PortraitKey=hero.Id;hero.Position=HeroPosition.Front;
        hero.BodyPrefabResource=Key+"Blooesperod";hero.AnimationSetResource=Key+"AnimationSet";hero.NormalAttackSkillId="blooesperod_normal_attack";
        hero.DeathAnimationMilliseconds=5201;hero.ProjectileHurtboxHeight=236;
        hero.BaseStats=new List<StatValue>{new StatValue("health",4800),new StatValue("damage",200),new StatValue("defense",45),new StatValue("attack_range",150),new StatValue("move_speed",1100),new StatValue("attack_interval",24)};
        hero.SpawnPoints=new List<HeroSpawnPointDefinition>{new HeroSpawnPointDefinition{Id="soul",Forward=40,Height=200}};
        hero.SkillSlots=new List<HeroSkillSlotDefinition>{new HeroSkillSlotDefinition{Id="ultimate",SkillId="blooesperod_ultimate",IsUltimate=true},
            new HeroSkillSlotDefinition{Id="skill_2",SkillId="blooesperod_skill2"},new HeroSkillSlotDefinition{Id="skill_3",SkillId="blooesperod_skill3"},new HeroSkillSlotDefinition{Id="skill_4",SkillId="blooesperod_skill4"}};
        data.Heroes.Add(hero);
        var normal=new SkillDefinition{Id=hero.NormalAttackSkillId,Name="Blooesperod / Huyet Lien Tram",Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,
            AnimationState="NormalAttack",CastRange=150,Effects=new List<SkillEffectDefinition>{Damage(7000)}};
        var slash1=A(310,SkillSequenceAction.Effects);slash1.RequireAttackRange=true;var slash2=A(880,SkillSequenceAction.Effects);slash2.RequireAttackRange=true;
        normal.CastSequences.Add(new SkillCastSequence{AnimationState="NormalAttack",DurationMilliseconds=1331,ReleaseMilliseconds=310,
            Actions=new List<SkillSequenceCue>{slash1,slash2},Visuals=new List<SkillVisualCue>{V("BloodSlash1",310,334,false,80,130),V("BloodSlash2",880,334,false,80,130)}});data.Skills.Add(normal);
        var ultimate=new SkillDefinition{Id="blooesperod_ultimate",Name="Blooesperod / Da Yen Linh Hon",Kind=SkillKind.Active,Activation=SkillActivation.UltimateIntent,
            Target=SkillTarget.NearestEnemy,EnergyCost=100,CastRange=6000,Delivery=SkillDelivery.Projectile,ProjectileResource=Key+"SoulFlight",ProjectileFlightState="SoulFlight",
            ProjectileImpactState="SoulHit",ProjectileImpactDurationMilliseconds=417,ProjectileSpawnPointId="soul",ProjectileSpeed=2000,ProjectileHitRadius=30,
            ProjectileLifetimeMilliseconds=4000,ProjectileVisualScaleBasisPoints=10000,DescendingProjectile=true,ProjectileTargetHeight=80,ProjectileTargetOnly=true,ProjectileTracksTarget=true,ProjectileSpawnMilliseconds=1590,
            LifestealBasisPoints=3000,LifestealReturnState="SoulReturn",Effects=new List<SkillEffectDefinition>{Damage(8000)}};
        var souls=new SkillCastSequence{AnimationState="Ultimate",DurationMilliseconds=3130,ReleaseMilliseconds=1590,
            Visuals=new List<SkillVisualCue>{V("NightSummon",0,2600),V("NightDissipate",2600,700)}};
        for(int i=0;i<5;i++){var cue=A(1590+130*i,SkillSequenceAction.Projectile);cue.SelectTargetByIndex=true;cue.TargetIndex=i%3;souls.Actions.Add(cue);}ultimate.CastSequences.Add(souls);data.Skills.Add(ultimate);
        var grab=new SkillDefinition{Id="blooesperod_skill2",Name="Blooesperod / Huyet Trao",Kind=SkillKind.Active,Target=SkillTarget.FarthestEnemy,
            CastRange=6000,EffectRadius=350,CooldownMilliseconds=12000,Effects=new List<SkillEffectDefinition>{Damage(18000)}};
        var blink=A(470,SkillSequenceAction.TeleportToTarget);blink.Distance=140;
        var hold=A(650,SkillSequenceAction.GrabTarget);hold.Distance=60;hold.DurationMilliseconds=2400;
        var toss=A(2850,SkillSequenceAction.ThrowTarget);toss.Distance=300;toss.Height=100;toss.DurationMilliseconds=600;
        var impact=A(2850,SkillSequenceAction.Effects);impact.RequiresGrab=true;
        grab.CastSequences.Add(new SkillCastSequence{AnimationState="Skill2",DurationMilliseconds=3440,ReleaseMilliseconds=650,ReturnToStartOnEnd=true,
            Actions=new List<SkillSequenceCue>{blink,hold,toss,impact},Visuals=new List<SkillVisualCue>{V("BloodSlash3",2850,834,true,0,130)}});data.Skills.Add(grab);
        var sweep=new SkillDefinition{Id="blooesperod_skill3",Name="Blooesperod / Huyet Anh Xuyen Tran",Kind=SkillKind.Active,Target=SkillTarget.LowestHealthAndBehind,
            CastRange=6000,EffectRadius=2000,CooldownMilliseconds=8000,Effects=new List<SkillEffectDefinition>{Damage(16000)}};
        sweep.CastSequences.Add(new SkillCastSequence{AnimationState="Skill3",DurationMilliseconds=870,ReleaseMilliseconds=120,
            Actions=new List<SkillSequenceCue>{A(370,SkillSequenceAction.Effects)},Visuals=new List<SkillVisualCue>{V("BloodSlash3",120,834,true,0,130)}});data.Skills.Add(sweep);
        data.Skills.Add(new SkillDefinition{Id="blooesperod_skill4",Name="Blooesperod / Tai Sinh Hac Anh",Kind=SkillKind.Passive,Activation=SkillActivation.OnDeath,
            Target=SkillTarget.Self,AnimationState="Skill4",AnimationDurationMilliseconds=3680,
            Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.Resurrect,ReviveDelayMilliseconds=2000,ReviveHealthBasisPoints=5000,
                MaxTriggersPerBattle=1,ModifierBasisPoints=1000,DurationMilliseconds=10000}}});
        data.ConfigVersion+="-blooesperod-1";
    }
}
