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
using Newtonsoft.Json;

public static class SetupEnchantx
{
    const string Source="C:/Users/tinnq/OneDrive/Desktop/CentaurLady_HeroKit_v4/CentaurLady_HeroKit";
    const string Art="Assets/Zatod/Art/Enchantx", Root="Assets/Zatod/Resources/Heroes/Enchantx", Key="Heroes/Enchantx/";
    [Serializable] public sealed class CanvasInfo { public int width,height; public float[] pivot_pixels_bottom_left,anchor_bottom_left; }
    [Serializable] public sealed class SourceFrame { public string file; public float time_seconds,duration_seconds; }
    [Serializable] public sealed class SourceAnimation { public bool loop; public float duration_seconds; public CanvasInfo canvas; public List<SourceFrame> frames; }
    [Serializable] public sealed class DemoFrame { public float time_seconds; public float[] hero_anchor_screen; }
    [Serializable] public sealed class Demo { public List<DemoFrame> frames; }
    sealed class Group { public string state,folder; public SourceAnimation data; public List<SourceFrame> frames; public Vector2 pivot; public bool body,loop; public float begin,duration; }
    static Group G(string state,string folder,bool body=false,int first=0)
    {
        var a=JsonConvert.DeserializeObject<SourceAnimation>(File.ReadAllText(Source+"/"+folder+"/animation.json"));
        var frames=a.frames.Skip(first).ToList();float begin=frames[0].time_seconds;
        var pivot=body?new Vector2(64,12):new Vector2(a.canvas.anchor_bottom_left[0],a.canvas.anchor_bottom_left[1]);
        if(state=="StormArrow")pivot=new Vector2(0,48);
        return new Group{state=state,folder=folder,data=a,frames=frames,pivot=pivot,body=body,begin=begin,duration=a.duration_seconds-begin,
            loop=state=="Idle"||state=="Run"||state=="Rain_Triggered"||state=="FlameWings_Walk"};
    }
    public static object Run()
    {
        if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before importing Enchantx.");
        var source=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(source).Data;
        if(data.Heroes.Any(h=>h.Id=="enchantx"))throw new InvalidOperationException("Enchantx exists; importer does not overwrite balanced config.");
        var groups=new List<Group>{G("Idle","Idle",true),G("Run","Run",true),G("Death","Death",true),G("Stun","Takehit",true),
            G("NormalAttack","NormalAttack",true),G("Ultimate","Ultimate",true),G("Skill2","Skill2",true),G("Skill3","Skill3",true),
            G("Skill3Repeat","Skill3",true,37),G("Skill4","Skill4",true),
            G("Arrow_Shot","Projectiles/Arrow/Shot"),G("Arrow_Idle","Projectiles/Arrow/Idle"),G("Arrow_Hit","Projectiles/Arrow/Hit"),
            G("StormArrow","Projectiles/StormArrow/Triggered")};
        foreach(string phase in new[]{"Casted","Triggered","Dissipate"})groups.Add(G("Rain_"+phase,"Projectiles/SpringRain/"+phase));
        foreach(string phase in new[]{"Entry","Idle","Walk","LightAtk","Land","Death","Dissipate"})groups.Add(G("FlameWings_"+phase,"Projectiles/FlameWings/"+phase));
        foreach(string phase in new[]{"Casted","Triggered","Dissipate"})groups.Add(G("WindStorm_"+phase,"Projectiles/WindStorm/"+phase));
        foreach(var group in groups)foreach(var frame in group.frames)if(!File.Exists(Source+"/"+group.folder+"/"+frame.file))throw new FileNotFoundException(group.folder+"/"+frame.file);
        Directory.CreateDirectory(Art);Directory.CreateDirectory(Root+"/Animations");AssetDatabase.Refresh();
        var factories=new SpriteDataProviderFactories();factories.Init();
        var sprites=new Dictionary<string,Sprite>();var clips=new Dictionary<string,AnimationClip>();
        var manifest=new HeroAnimationSetData{HeroId="enchantx",CanvasWidth=128,CanvasHeight=108,PixelsPerUnit=25,AnchorPixelX=64,AnchorPixelY=12};
        foreach(var group in groups)
        {
            var entry=new HeroAnimationClipData{State=group.state,SourceFolder=group.folder,ClipResource=Key+"Animations/"+group.state,Loop=group.loop,
                SourceDurationSeconds=group.duration,Projectile=group.state=="Arrow_Idle",UseProjectileOrigin=true,
                ProjectileOriginPixelX=group.pivot.x,ProjectileOriginPixelY=group.pivot.y,
                VisualReferenceWidthPixels=group.state=="StormArrow"?256:0};
            var keys=new List<ObjectReferenceKeyframe>();
            Directory.CreateDirectory(Art+"/"+group.folder);AssetDatabase.Refresh();
            foreach(var frame in group.frames)
            {
                string path=Art+"/"+group.folder+"/"+frame.file;
                var info=Bounds(Source+"/"+group.folder+"/"+frame.file);
                int x0=Math.Max(0,Math.Min(info.bounds.X,(int)group.pivot.x)-1),y0=Math.Max(0,Math.Min(info.bounds.Y,(int)group.pivot.y)-1);
                int x1=Math.Min(info.width-1,Math.Max(info.bounds.X+info.bounds.Width-1,(int)group.pivot.x)+1);
                int y1=Math.Min(info.height-1,Math.Max(info.bounds.Y+info.bounds.Height-1,(int)group.pivot.y)+1);
                var crop=new HeroFrameBounds{X=x0,Y=y0,Width=x1-x0+1,Height=y1-y0+1};
                if(!sprites.TryGetValue(path,out var sprite))
                {
                    File.Copy(Source+"/"+group.folder+"/"+frame.file,path,false);AssetDatabase.ImportAsset(path);
                    var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=TextureImporterType.Sprite;
                    importer.spriteImportMode=SpriteImportMode.Multiple;importer.spritePixelsPerUnit=25;importer.filterMode=FilterMode.Point;
                    importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
                    var provider=factories.GetSpriteEditorDataProviderFromObject(importer);
                    if(provider==null)throw new InvalidOperationException("Sprite provider missing: "+path);provider.InitSpriteEditorDataProvider();
                    var capability=provider.GetDataProvider<ISpriteFrameEditCapability>();
                    if(capability==null)throw new InvalidOperationException("Sprite capabilities missing: "+path);
                    foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteRect,EEditCapability.EditPivot,EEditCapability.EditSpriteName})
                        if(!capability.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Missing sprite capability "+required);
                    var rect=new SpriteRect{name=Path.GetFileNameWithoutExtension(path),spriteID=GUID.Generate(),alignment=SpriteAlignment.Custom,
                        rect=new Rect(crop.X,crop.Y,crop.Width,crop.Height),pivot=new Vector2((group.pivot.x-crop.X)/crop.Width,(group.pivot.y-crop.Y)/crop.Height)};
                    provider.SetSpriteRects(new[]{rect});var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();
                    if(names==null)throw new InvalidOperationException("Stable sprite IDs unsupported");
                    names.SetNameFileIdPairs(new[]{new SpriteNameFileIdPair(rect.name,rect.spriteID)});provider.Apply();importer.SaveAndReimport();
                    sprite=AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().Single();sprites.Add(path,sprite);
                }
                float time=frame.time_seconds-group.begin;
                keys.Add(new ObjectReferenceKeyframe{time=time,value=sprite});entry.FrameTimes.Add(time);
                entry.SourceFrames.Add(frame.file);entry.ContentBounds.Add(info.bounds);entry.Frames.Add(crop);
            }
            var clip=new AnimationClip{name=group.state,frameRate=100};AssetDatabase.CreateAsset(clip,Root+"/Animations/"+group.state+".anim");
            AnimationUtility.SetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"),keys.ToArray());
            var settings=AnimationUtility.GetAnimationClipSettings(clip);settings.loopTime=group.loop;settings.stopTime=group.duration;AnimationUtility.SetAnimationClipSettings(clip,settings);
            EditorUtility.SetDirty(clip);clips.Add(group.state,clip);manifest.Clips.Add(entry);
        }
        var material=new Material(Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default"));AssetDatabase.CreateAsset(material,Root+"/EnchantxSprite.mat");
        var body=Controller("Enchantx",groups.Where(g=>g.body).Select(g=>g.state).ToArray(),clips,true);
        Prefab("Enchantx",body,First(clips["Idle"]),material,true,0);
        foreach(var entry in manifest.Clips.Where(c=>!groups.Single(g=>g.state==c.State).body))
            Prefab(entry.State,Controller(entry.State,new[]{entry.State},clips,false),First(clips[entry.State]),material,false,Math.Max(2,entry.DurationSeconds));
        // No separate portrait was supplied. Use an unmodified Idle frame with a sprite crop as the placeholder icon.
        const string icon="Assets/Zatod/Resources/HeroPortraits/enchantx.png";
        File.Copy(Source+"/Idle/0001.png",icon,false);AssetDatabase.ImportAsset(icon);
        var portrait=(TextureImporter)AssetImporter.GetAtPath(icon);portrait.textureType=TextureImporterType.Sprite;portrait.spriteImportMode=SpriteImportMode.Single;
        portrait.filterMode=FilterMode.Point;portrait.mipmapEnabled=false;portrait.textureCompression=TextureImporterCompression.Uncompressed;portrait.SaveAndReimport();
        File.WriteAllText(Root+"/AnimationSet.txt",JsonUtility.ToJson(manifest,true));
        File.Copy(Source+"/README.txt",Art+"/SourceNotes.txt",false);File.Copy(Source+"/hero_kit.json",Art+"/SourceKit.json",false);
        AssetDatabase.Refresh();Configure(data);HeroConfigFileStore.Save(data,source);FinishPresentation();
        LeenaldAtlasBuild.Ensure(Art,Art+"/Enchantx.spriteatlasv2");AssetDatabase.SaveAssets();
        foreach(var window in Resources.FindObjectsOfTypeAll<HeroBalanceWindow>())window.ReloadIfClean();
        return new{hero="enchantx",frames=sprites.Count,clips=clips.Count,data.ConfigVersion};
    }
    static (int width,int height,HeroFrameBounds bounds) Bounds(string path)
    {
        var texture=new Texture2D(2,2);try{texture.LoadImage(File.ReadAllBytes(path));var p=texture.GetPixels32();int x0=texture.width,y0=texture.height,x1=-1,y1=-1;
            for(int y=0;y<texture.height;y++)for(int x=0;x<texture.width;x++)if(p[y*texture.width+x].a>0){x0=Math.Min(x0,x);y0=Math.Min(y0,y);x1=Math.Max(x1,x);y1=Math.Max(y1,y);}
            return (texture.width,texture.height,x1<0?new HeroFrameBounds{Width=1,Height=1,Empty=true}:new HeroFrameBounds{X=x0,Y=y0,Width=x1-x0+1,Height=y1-y0+1});
        }finally{UnityEngine.Object.DestroyImmediate(texture);}
    }
    public static object FinishPresentation()
    {
        var source=HeroConfigFileStore.Read();var data=HeroDataJson.ReadDocuments(source).Data;
        foreach(var sequence in data.Skills.Single(s=>s.Id=="enchantx_skill3").CastSequences)
        {
            foreach(var cue in sequence.Visuals)
            {
                if(cue.State=="FlameWings_Entry")cue.Height=160;
                if(cue.State=="FlameWings_Walk"){cue.Height=160;cue.MoveHeight=70;}
                if(cue.State=="FlameWings_Dissipate")cue.Height=230;
            }
            if(!sequence.Visuals.Any(v=>v.Shockwave))
            {var cue=Visual("TeamBuffBurst",sequence.Actions[0].DelayMilliseconds,900,false,310,230);cue.Shockwave=true;sequence.Visuals.Add(cue);}
        }
        data.ConfigVersion+="-presentation-1";HeroConfigFileStore.Save(data,source);
        const string icon="Assets/Zatod/Resources/HeroPortraits/enchantx.png";
        var importer=(TextureImporter)AssetImporter.GetAtPath(icon);importer.spriteImportMode=SpriteImportMode.Multiple;importer.SaveAndReimport();
        var factory=new SpriteDataProviderFactories();factory.Init();var provider=factory.GetSpriteEditorDataProviderFromObject(importer);provider.InitSpriteEditorDataProvider();
        var cap=provider.GetDataProvider<ISpriteFrameEditCapability>();if(cap==null)throw new InvalidOperationException("No portrait sprite capability");
        foreach(var required in new[]{EEditCapability.CreateAndDeleteSprite,EEditCapability.EditSpriteRect,EEditCapability.EditPivot,EEditCapability.EditSpriteName})
            if(!cap.GetEditCapability().HasCapability(required))throw new InvalidOperationException("Portrait capability missing: "+required);
        var rect=new SpriteRect{name="enchantx",spriteID=GUID.Generate(),rect=new Rect(42,11,47,43),alignment=SpriteAlignment.Center,pivot=new Vector2(.5f,.5f)};
        provider.SetSpriteRects(new[]{rect});var names=provider.GetDataProvider<ISpriteNameFileIdDataProvider>();
        if(names==null)throw new InvalidOperationException("Portrait stable IDs unsupported");
        names.SetNameFileIdPairs(new[]{new SpriteNameFileIdPair(rect.name,rect.spriteID)});provider.Apply();importer.SaveAndReimport();AssetDatabase.SaveAssets();
        return new{portrait="Idle frame crop",flameHeight=230};
    }
    static Sprite First(AnimationClip clip){return (Sprite)AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"))[0].value;}
    static AnimatorController Controller(string name,string[] states,Dictionary<string,AnimationClip> clips,bool body)
    {
        var controller=AnimatorController.CreateAnimatorControllerAtPath(Root+"/"+name+".controller");var machine=controller.layers[0].stateMachine;
        var entries=states.ToDictionary(s=>s,s=>machine.AddState(s));foreach(var pair in entries){pair.Value.motion=clips[pair.Key];pair.Value.writeDefaultValues=false;}
        machine.defaultState=entries[body?"Idle":states[0]];
        if(body)foreach(var state in states.Where(s=>s!="Idle"&&s!="Run"&&s!="Stun"&&s!="Death")){var transition=entries[state].AddTransition(entries["Idle"]);transition.hasExitTime=true;transition.exitTime=1;transition.duration=0;}
        EditorUtility.SetDirty(controller);return controller;
    }
    static void Prefab(string name,AnimatorController controller,Sprite first,Material material,bool body,float life)
    {
        var go=new GameObject(name);try{var renderer=go.AddComponent<SpriteRenderer>();renderer.sprite=first;renderer.sharedMaterial=material;
            var animator=go.AddComponent<Animator>();animator.runtimeAnimatorController=controller;animator.updateMode=AnimatorUpdateMode.UnscaledTime;
            if(body)go.AddComponent<HeroAnimationPlayer>().HeroId="enchantx";else go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds=life;
            PrefabUtility.SaveAsPrefabAsset(go,Root+"/"+name+".prefab");}finally{UnityEngine.Object.DestroyImmediate(go);}
    }
    static SkillEffectDefinition Damage(int scale){return new SkillEffectDefinition{Kind=SkillEffectKind.Damage,DamageScaleBasisPoints=scale};}
    static SkillSequenceCue Action(int time,SkillSequenceAction action){return new SkillSequenceCue{DelayMilliseconds=time,Action=action};}
    static SkillVisualCue Visual(string state,int time,int duration,bool atTarget=false,int forward=0,int height=0)
    {return new SkillVisualCue{State=state,DelayMilliseconds=time,DurationMilliseconds=duration,FollowCaster=false,AtTarget=atTarget,Forward=forward,Height=height};}
    static SkillDefinition Arrow(string id,string state,int cooldown,int scale)
    {
        return new SkillDefinition{Id=id,Name="Enchantx / "+state,Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,CastRange=3200,CooldownMilliseconds=cooldown,
            AnimationState=state,AnimationDurationMilliseconds=570,WindupMilliseconds=100,RecoveryMilliseconds=470,Delivery=SkillDelivery.Projectile,
            ProjectileResource=Key+"Arrow_Shot",ProjectileFlightState="Arrow_Shot",ProjectileImpactState="Arrow_Hit",ProjectileImpactDurationMilliseconds=417,
            ProjectileSpawnPointId="bow",ProjectileSpawnMilliseconds=100,ProjectileSpeed=2400,ProjectileHitRadius=40,ProjectileLifetimeMilliseconds=2000,
            ProjectileHitOffsetForward=200,ProjectileVisualScaleBasisPoints=10000,Effects=new List<SkillEffectDefinition>{Damage(scale)}};
    }
    static void Configure(HeroCatalogData data)
    {
        var hero=JsonUtility.FromJson<HeroDefinition>(JsonUtility.ToJson(data.Heroes.Single(h=>h.Id=="training_warrior")));
        hero.Id="enchantx";hero.Name="Enchantx";hero.Position=HeroPosition.Rear;hero.PortraitKey="enchantx";hero.BodyPrefabResource=Key+"Enchantx";hero.AnimationSetResource=Key+"AnimationSet";
        hero.NormalAttackSkillId="enchantx_normal_attack";hero.DeathAnimationMilliseconds=1200;hero.ProjectileHurtboxHeight=200;
        hero.SpawnPoints=new List<HeroSpawnPointDefinition>{new HeroSpawnPointDefinition{Id="feet"},new HeroSpawnPointDefinition{Id="bow",Forward=114,Height=128},new HeroSpawnPointDefinition{Id="wind",Forward=70,Height=152}};
        hero.BaseStats=new List<StatValue>{new StatValue("health",2800),new StatValue("damage",225),new StatValue("defense",20),new StatValue("attack_range",3200),new StatValue("move_speed",1600),new StatValue("attack_interval",26)};
        hero.SkillSlots=new List<HeroSkillSlotDefinition>{new HeroSkillSlotDefinition{Id="ultimate",SkillId="enchantx_ultimate",IsUltimate=true},new HeroSkillSlotDefinition{Id="skill_2",SkillId="enchantx_skill2"},new HeroSkillSlotDefinition{Id="skill_3",SkillId="enchantx_skill3"},new HeroSkillSlotDefinition{Id="skill_4",SkillId="enchantx_skill4"}};
        data.Heroes.Add(hero);
        data.Skills.Add(Arrow(hero.NormalAttackSkillId,"NormalAttack",0,10000));
        var ultimate=new SkillDefinition{Id="enchantx_ultimate",Name="Enchantx / Xuyen Phong",Kind=SkillKind.Active,Activation=SkillActivation.UltimateIntent,
            Target=SkillTarget.EnemiesInLine,EnergyCost=100,CastRange=3600,Delivery=SkillDelivery.Beam,ProjectileSpawnPointId="wind",ProjectileHitRadius=60,
            Effects=new List<SkillEffectDefinition>{Damage(25000)}};
        var wind=Visual("StormArrow",1800,667,false,70,152);wind.StretchToTarget=true;
        ultimate.CastSequences.Add(new SkillCastSequence{AnimationState="Ultimate",DurationMilliseconds=2200,ReleaseMilliseconds=1800,ContinueAfterRelease=true,
            Actions=new List<SkillSequenceCue>{Action(1900,SkillSequenceAction.Effects)},Visuals=new List<SkillVisualCue>{wind,
                Visual("WindStorm_Casted",2040,400,true,0,164),Visual("WindStorm_Triggered",2440,333,true,0,164),Visual("WindStorm_Dissipate",2773,500,true,0,164)}});
        data.Skills.Add(ultimate);
        var rain=new SkillDefinition{Id="enchantx_skill2",Name="Enchantx / Thien Tien",Kind=SkillKind.Active,Target=SkillTarget.NearestEnemy,CastRange=3600,EffectRadius=220,
            CooldownMilliseconds=8000,Effects=new List<SkillEffectDefinition>{Damage(4500)}};
        rain.CastSequences.Add(new SkillCastSequence{AnimationState="Skill2",DurationMilliseconds=2540,ReleaseMilliseconds=500,ContinueAfterRelease=true,
            Actions=new List<SkillSequenceCue>{Action(700,SkillSequenceAction.AreaPulse),Action(1100,SkillSequenceAction.AreaPulse),Action(1500,SkillSequenceAction.AreaPulse),Action(1900,SkillSequenceAction.AreaPulse)},
            Visuals=new List<SkillVisualCue>{Visual("Rain_Casted",500,200,true,0,148),Visual("Rain_Triggered",700,1600,true,0,148),Visual("Rain_Dissipate",2300,150,true,0,148)}});
        data.Skills.Add(rain);
        var buff=new SkillDefinition{Id="enchantx_skill3",Name="Enchantx / Hieu Lenh Xung Tran",Kind=SkillKind.Active,Target=SkillTarget.AllAllies,CastRange=10000,
            CooldownMilliseconds=10000,CastAtBattleStart=true,Effects=new List<SkillEffectDefinition>{new SkillEffectDefinition{Kind=SkillEffectKind.DamageBuff,ModifierBasisPoints=2000,DurationMilliseconds=8000}}};
        SkillCastSequence Summon(bool opening)
        {
            int shift=opening?2320:0,launch=760+shift,burst=2427+shift;
            var flight=Visual("FlameWings_Walk",launch+1000,667,false,130,160);flight.MoveForward=180;flight.MoveHeight=70;
            var burstCue=Visual("TeamBuffBurst",burst,900,false,310,230);burstCue.Shockwave=true;
            return new SkillCastSequence{Opening=opening,AnimationState=opening?"Skill3":"Skill3Repeat",DurationMilliseconds=1460+shift,ReleaseMilliseconds=launch,ContinueAfterRelease=true,
                Actions=new List<SkillSequenceCue>{Action(burst,SkillSequenceAction.Effects)},
                Visuals=new List<SkillVisualCue>{Visual("FlameWings_Entry",launch,1000,false,130,160),flight,Visual("FlameWings_Dissipate",burst,900,false,310,230),burstCue}};
        }
        var entry=Summon(true);var demo=JsonConvert.DeserializeObject<Demo>(File.ReadAllText(Source+"/Previews/Skill3/demo.json"));
        for(int time=0;time<=2300;time+=50)
        {
            var frame=demo.frames.First(f=>f.time_seconds+0.0001f>=time/1000f);
            entry.Motion.Add(new SkillMotionKey{TimeMilliseconds=time,Forward=Mathf.RoundToInt((frame.hero_anchor_screen[0]-80)*2),Height=Mathf.RoundToInt((328-frame.hero_anchor_screen[1])*2)});
        }
        entry.Motion.Add(new SkillMotionKey{TimeMilliseconds=2320,Forward=810});buff.CastSequences.Add(entry);buff.CastSequences.Add(Summon(false));data.Skills.Add(buff);
        var triple=Arrow("enchantx_skill4","Skill4",7000,8000);triple.RecoveryMilliseconds=0;
        triple.CastSequences.Add(new SkillCastSequence{AnimationState="Skill4",DurationMilliseconds=1710,
            Actions=new List<SkillSequenceCue>{Action(100,SkillSequenceAction.Projectile),Action(670,SkillSequenceAction.Projectile),Action(1240,SkillSequenceAction.Projectile)}});
        data.Skills.Add(triple);data.ConfigVersion+="-enchantx-1";
    }
}
