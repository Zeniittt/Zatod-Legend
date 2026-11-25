using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Heroes;

namespace Zatod.Presentation
{
    public sealed class ZatodBattleActorPointer : MonoBehaviour,IPointerClickHandler
    {
        public Action Click;
        public void OnPointerClick(PointerEventData data){if(data.button==PointerEventData.InputButton.Left)Click?.Invoke();}
    }
    public sealed class ZatodBattleStage : MonoBehaviour
    {
        public const int BattleLayer=9;
        public Camera BattleCamera{get;private set;}
        public Action<int> Ultimate;
        public Func<int,bool> UltimatePending;
        public int UnitCount=>units.Count;
        public int EffectCount=>effects.Count;
        sealed class AnimationAudio
        {
            public string Action;
            public double Elapsed=-1;
            public AudioSource Source;
        }
        sealed class UnitVisual
        {
            public Transform Root, HealthRoot;
            public ZatodBattleSprite Sprite;
            public SpriteRenderer Health, HealthTrail, Shield;
            public BoxCollider2D Hit;
            public readonly AnimationAudio Audio=new AnimationAudio();
            public int CastInterruptedTick=-1;
            public bool WasAlive;
        }
        sealed class EffectVisual
        {
            public ZatodPoolManager.Lease Lease;
            public ZatodBattleSprite Sprite;
            public readonly AnimationAudio Audio=new AnimationAudio();
        }
        readonly Dictionary<int,UnitVisual> units=new Dictionary<int,UnitVisual>();
        readonly Dictionary<int,EffectVisual> effects=new Dictionary<int,EffectVisual>();
        readonly Dictionary<string,Sprite> backgrounds=new Dictionary<string,Sprite>();
        readonly HashSet<string> playedCues=new HashSet<string>(StringComparer.Ordinal);
        public ZatodPoolManager Pool{get;private set;}
        MaterialPropertyBlock buffProperties;
        Material buffMaterial,normalMaterial;
        static readonly Color DimBackground=new Color(.38f,.38f,.38f);
        static readonly Color DimActor=new Color(.45f,.45f,.45f);
        const float HealthWidth=.9f;
        SpriteRenderer background;Sprite white;AudioSource audioSource,music;
        bool audioPaused;
        int audioWave;
        RectTransform coordinateSpace;
        ZatodBattleSimulation presentationSimulation;
        double lastDrawTime, finishElapsed;
        public static Vector3 Point(double x,double y,double height)=>new Vector3(-7+(float)x*.0175f,-.7f+(float)y*.00875f+(float)height*.0175f,0);
        internal static double WaveEntryOffset(int team,double remaining,double interpolation)
        {
            double progress=1-Math.Clamp(remaining-interpolation,0,ZatodBattleSimulation.WaveEntrySeconds)/ZatodBattleSimulation.WaveEntrySeconds;
            return (team==0?-1:1)*140*(1-progress*progress);
        }
        void Awake()
        {
            Pool=gameObject.AddComponent<ZatodPoolManager>();
            buffProperties=new MaterialPropertyBlock();
            gameObject.layer=BattleLayer;
            var cam=new GameObject("ZatodBattleCamera",typeof(Camera),typeof(Physics2DRaycaster));cam.layer=BattleLayer;cam.transform.SetParent(transform,false);
            BattleCamera=cam.GetComponent<Camera>();BattleCamera.orthographic=true;BattleCamera.cullingMask=1<<BattleLayer;BattleCamera.depth=10;
            BattleCamera.clearFlags=CameraClearFlags.SolidColor;BattleCamera.backgroundColor=Color.black;BattleCamera.nearClipPlane=.1f;BattleCamera.farClipPlane=100;
            background=Picture("Background",transform,-30000);white=UnityEngine.Sprite.Create(Texture2D.whiteTexture,new Rect(0,0,1,1),new Vector2(.5f,.5f),1);
            audioSource=CreateAudioSource(gameObject);
            music=CreateAudioSource(gameObject);music.volume=.35f;music.loop=true;
        }
        SpriteRenderer Picture(string name,Transform parent,int order)
        {
            var go=new GameObject(name,typeof(SpriteRenderer));go.layer=BattleLayer;go.transform.SetParent(parent,false);
            var sr=go.GetComponent<SpriteRenderer>();sr.sortingOrder=order;sr.sharedMaterial=Resources.Load<Material>("Zatod/World/ZatodWorldSprite");return sr;
        }
        public void Fit(RectTransform space)
        {
            coordinateSpace=space;FitCamera();
        }
        void LateUpdate()=>FitCamera();
        void FitCamera()
        {
            if(BattleCamera==null)return;
            if(coordinateSpace!=null)
            {
                var corners=new Vector3[4];coordinateSpace.GetWorldCorners(corners);
                var low=RectTransformUtility.WorldToScreenPoint(null,corners[0]);var high=RectTransformUtility.WorldToScreenPoint(null,corners[2]);
                float unitsPerPixel=9/Mathf.Max(1,high.y-low.y);var center=(low+high)/2;
                BattleCamera.orthographicSize=Screen.height*unitsPerPixel/2;
                BattleCamera.transform.position=new Vector3((Screen.width/2f-center.x)*unitsPerPixel,(Screen.height/2f-center.y)*unitsPerPixel,-10);
            }
            else{BattleCamera.orthographicSize=Mathf.Max(4.5f,8/Mathf.Max(.1f,BattleCamera.aspect));BattleCamera.transform.position=new Vector3(0,0,-10);}
            if(background.sprite!=null)
            {
                float height=BattleCamera.orthographicSize*2,width=height*BattleCamera.aspect;
                float scale=Mathf.Max(width/background.sprite.bounds.size.x,height/background.sprite.bounds.size.y);
                background.transform.localScale=Vector3.one*scale;background.transform.position=new Vector3(BattleCamera.transform.position.x,BattleCamera.transform.position.y,0);
            }
        }
        ZatodBattleSprite Sprite(string name,string resource)
        {
            var go=new GameObject(name,typeof(ZatodBattleSprite));go.layer=BattleLayer;go.transform.SetParent(transform,false);
            var visual=go.GetComponent<ZatodBattleSprite>();visual.Initialize(resource);return visual;
        }
        UnitVisual CreateActor(ZatodUnitState state,int viewingTeam)
        {
            var sprite=Sprite("Hero_"+state.EntityId,state.AnimationSetResource);
            var actor=new UnitVisual{Root=sprite.transform,Sprite=sprite,Hit=sprite.gameObject.AddComponent<BoxCollider2D>()};
            actor.Hit.isTrigger=true;
            var track=new GameObject("HealthBar").transform;
            track.SetParent(actor.Root,false);
            track.localPosition=new Vector3(0,.2f,0);
            actor.HealthRoot=track;
            var bar=Picture("HealthBackground",track,20000);
            bar.sprite=white;bar.color=new Color(.08f,.12f,.17f,.95f);
            bar.transform.localScale=new Vector3(HealthWidth+.04f,.085f,1);
            actor.HealthTrail=Picture("HealthTrail",track,20001);
            actor.Health=Picture("HealthFill",track,20002);
            actor.Shield=Picture("ShieldFill",track,20003);
            actor.HealthTrail.sprite=actor.Health.sprite=actor.Shield.sprite=white;
            actor.HealthTrail.color=new Color(1,.77f,.35f);
            actor.Health.color=state.Team==viewingTeam?new Color(.35f,.85f,.53f):new Color(.95f,.35f,.42f);
            actor.Shield.color=new Color(.4f,.72f,1);
            int id=state.EntityId;
            sprite.gameObject.AddComponent<ZatodBattleActorPointer>().Click=()=>Ultimate?.Invoke(id);
            return actor;
        }
        static void Fill(SpriteRenderer renderer,double value,float y=0,float height=.045f)
        {
            float width=HealthWidth*(float)value;
            renderer.transform.localScale=new Vector3(width,height,1);
            renderer.transform.localPosition=new Vector3((width-HealthWidth)/2,y,0);
        }
        static void DrawHealth(UnitVisual actor,ZatodUnitState state,double interpolation)
        {
            var bar=state.HealthBar.Project(interpolation);
            actor.HealthRoot.gameObject.SetActive(state.Alive && (state.Boss || bar.VisibleFor>0));
            Fill(actor.HealthTrail,bar.Trail);
            Fill(actor.Health,bar.Hp);
            actor.Shield.enabled=bar.Shield>0;
            Fill(actor.Shield,bar.Shield,.06f,.025f);
        }
        static AudioSource CreateAudioSource(GameObject host)
        {
            var source=host.AddComponent<AudioSource>();source.playOnAwake=false;source.spatialBlend=0;
            return source;
        }
        static string AudioPath(string resource)=>resource.StartsWith("Crystal/",StringComparison.Ordinal)
            ?"Zatod/"+resource.Substring("Crystal/".Length):resource;
        void PlayCues(AnimationAudio cursor,HeroAnimationClipData clip,double elapsed,bool playAudio,GameObject actor=null)
        {
            if(clip==null)return;
            double previous=cursor.Action==clip.State && elapsed>=cursor.Elapsed?cursor.Elapsed:-.00001;
            if(playAudio)
            {
                foreach(var cue in clip.AudioCues)
                {
                    if(cue.Time<=previous || cue.Time>elapsed || string.IsNullOrEmpty(cue.Resource))continue;
                    string resource=AudioPath(cue.Resource);
                    if(!playedCues.Add(resource))continue;
                    var audio=Resources.Load<AudioClip>(resource);
                    if(audio==null)continue;
                    var source=actor==null?audioSource:(cursor.Source??=CreateAudioSource(actor));
                    source.PlayOneShot(audio,.45f);
                }
            }
            cursor.Action=clip.State;
            cursor.Elapsed=elapsed;
        }
        void SetAudioPaused(bool paused)
        {
            if(audioPaused==paused)return;
            audioPaused=paused;
            SetPaused(audioSource);SetPaused(music);
            foreach(var actor in units.Values)SetPaused(actor.Audio.Source);
            void SetPaused(AudioSource source)
            {
                if(source==null)return;
                if(paused)source.Pause();else source.UnPause();
            }
        }
        void StopAudio()
        {
            audioSource?.Stop();music?.Stop();
            foreach(var actor in units.Values)actor.Audio.Source?.Stop();
            audioPaused=false;
        }
        public void Prewarm(ZatodBattleAssets assets)
        {
            if(assets==null)return;
            foreach(var resource in assets.Effects.Take(12))Pool.Prewarm(resource,1,()=>Sprite("Effect",resource).gameObject);
        }
        void RemoveActor(int id)
        {
            if(!units.TryGetValue(id,out var actor))return;
            actor.Audio.Source?.Stop();
            if(actor.Root!=null)Retire(actor.Root.gameObject);
            units.Remove(id);
        }
        static void Retire(GameObject visual)
        {
            visual.SetActive(false);
            Destroy(visual);
        }
        static float CorpseAlpha(ZatodUnitState state,HeroAnimationClipData clip,double elapsed)
        {
            if(state.Alive || state.DeathPresentation==ZatodDeathPresentation.Remain)return 1;
            if(state.DeathPresentation==ZatodDeathPresentation.Hide)return 0;
            double hold=state.DeathPresentation==ZatodDeathPresentation.FadeWithoutHold?0:2;
            return 1-Mathf.Clamp01((float)(elapsed-(clip?.DurationSeconds??0)-hold));
        }
        public void Draw(ZatodFrame frame,ZatodBattleSimulation simulation,double interpolation,int team,bool canInput,bool playAudio,double playbackSpeed=1)
        {
            playedCues.Clear();
            double now=Time.unscaledTimeAsDouble;
            if(presentationSimulation!=simulation)
            {
                StopAudio();
                music.clip=string.IsNullOrEmpty(simulation.MusicResource)?null:Resources.Load<AudioClip>(AudioPath(simulation.MusicResource));
                finishElapsed=0;
            }
            else if(!frame.Finished)finishElapsed=0;
            else if(playAudio)finishElapsed+=(now-lastDrawTime)*playbackSpeed;
            presentationSimulation=simulation;lastDrawTime=now;
            if(audioWave!=frame.Wave)
            {
                audioWave=frame.Wave;
                audioSource.Stop();
                foreach(var actor in units.Values)actor.Audio.Source?.Stop();
            }
            SetAudioPaused(!playAudio);
            if(music.clip!=null)
            {
                if(frame.Finished)music.Stop();
                else if(playAudio && !music.isPlaying)music.Play();
            }
            string resource=simulation.BackgroundResource;
            if(!backgrounds.TryGetValue(resource,out var bg))
            {
                var texture=Resources.Load<Texture2D>("Zatod/Backgrounds/"+System.IO.Path.GetFileNameWithoutExtension(resource));
                if(texture==null)throw new System.IO.FileNotFoundException("Missing battle background: "+resource);
                bg=UnityEngine.Sprite.Create(texture,new Rect(0,0,texture.width,texture.height),new Vector2(.5f,.5f),100);backgrounds.Add(resource,bg);
            }
            background.sprite=bg;background.flipX=simulation.FlipBackground;
            background.color=frame.DimForUltimate?DimBackground:Color.white;
            var litActors=frame.Units.Where(u=>u.UltimateStartup).Select(u=>u.EntityId).ToHashSet();
            foreach(var state in frame.Units)
            {
                if(!state.Alive && state.DeathWave>=0 && state.DeathWave<frame.Wave)
                {
                    RemoveActor(state.EntityId);
                    continue;
                }
                if(!units.TryGetValue(state.EntityId,out var actor))
                {
                    actor=CreateActor(state,team);units.Add(state.EntityId,actor);
                }
                else if(actor.Sprite.Resource!=state.AnimationSetResource)
                {
                    actor.Audio.Source?.Stop();actor.Audio.Action=null;actor.Audio.Elapsed=-1;
                    actor.Sprite.Initialize(state.AnimationSetResource);
                }
                state.Motion.Project(state.X,state.Y,state.Height,interpolation,out double x,out double y,out double height);
                string action=state.Action;
                var clip=actor.Sprite.Set.Clips.FirstOrDefault(c=>c.State==action);
                double sampleTime=state.Alive
                    ? state.ActionElapsed+interpolation*state.ActionSpeed
                    : state.DeathElapsed+finishElapsed+(state.ActionSpeed>0?interpolation:0);
                double cueTime=state.Alive?state.ActionElapsed:state.DeathElapsed+finishElapsed;
                if(state.Alive && frame.WaveEntryRemaining>0)
                {
                    double remaining=Math.Max(0,frame.WaveEntryRemaining-interpolation);
                    double progress=1-remaining/ZatodBattleSimulation.WaveEntrySeconds;
                    x+=WaveEntryOffset(state.Team,frame.WaveEntryRemaining,interpolation);
                    var move=actor.Sprite.Set.Clips.FirstOrDefault(c=>c.State=="Move");
                    if(move!=null){clip=move;action=clip.State;sampleTime=progress*ZatodBattleSimulation.WaveEntrySeconds;cueTime=ZatodBattleSimulation.WaveEntrySeconds-frame.WaveEntryRemaining;}
                }
                else if(state.Alive && frame.Finished && state.Team==frame.Winner)
                {
                    var cheer=actor.Sprite.Set.Clips.FirstOrDefault(c=>c.State=="Cheer");
                    if(cheer!=null){clip=cheer;action=clip.State;sampleTime=finishElapsed;cueTime=sampleTime;}
                }
                else if(state.Alive && state.Icebound && !string.IsNullOrEmpty(state.FrozenAction))
                {
                    var frozen=actor.Sprite.Set.Clips.FirstOrDefault(c=>c.State==state.FrozenAction);
                    if(frozen!=null){clip=frozen;action=clip.State;sampleTime=cueTime=state.FrozenActionElapsed;}
                }
                else if(state.Alive && action=="Idle" && state.DamageReactionTick>=0 && !frame.Finished && !frame.DimForUltimate)
                {
                    var reaction=actor.Sprite.Set.Clips.FirstOrDefault(c=>c.State=="Damaged");
                    double age=(frame.Tick-state.DamageReactionTick)*ZatodBattleSimulation.StepSeconds;
                    if(reaction!=null && age<Math.Min(.25,reaction.DurationSeconds))
                    {
                        clip=reaction;action=clip.State;sampleTime=age+interpolation;cueTime=age;
                    }
                }
                actor.Root.position=Point(x,y,height);actor.Sprite.Sample(action,(float)sampleTime,state.FacingRight,(float)state.ArtScale*.7388535f);
                if(normalMaterial==null)normalMaterial=Resources.Load<Material>("Zatod/World/ZatodWorldSprite");
                if(state.Shader!=ZatodBuffShader.None && buffMaterial==null)buffMaterial=Resources.Load<Material>("Zatod/World/ZatodBuffSprite");
                actor.Sprite.Renderer.sharedMaterial=state.Shader==ZatodBuffShader.None?normalMaterial:buffMaterial;
                buffProperties.Clear();buffProperties.SetFloat("_NativeBuff",(int)state.Shader);actor.Sprite.Renderer.SetPropertyBlock(buffProperties);
                actor.Sprite.Renderer.transform.localScale=Vector3.Scale(actor.Sprite.Renderer.transform.localScale,new Vector3((float)state.RenderScaleX,(float)state.RenderScaleY,1));
                var color=frame.DimForUltimate && !state.UltimateStartup?DimActor:Color.white;
                if(state.Icebound && state.Shader==ZatodBuffShader.None)color*=new Color(.66f,.84f,1);
                color.a=CorpseAlpha(state,clip,sampleTime);
                actor.Sprite.Renderer.color=color;
                actor.Sprite.Renderer.sortingOrder=1000-Mathf.RoundToInt((float)y*10);
                actor.Hit.enabled=canInput && state.Team==team && state.CanActivateUltimate && UltimatePending?.Invoke(state.EntityId)!=true;
                var bounds=actor.Sprite.Renderer.bounds;actor.Hit.size=bounds.size;actor.Hit.offset=bounds.center-actor.Root.position;
                DrawHealth(actor,state,interpolation);
                if(state.CastInterruptedTick>actor.CastInterruptedTick || actor.WasAlive && !state.Alive)actor.Audio.Source?.Stop();
                actor.CastInterruptedTick=state.CastInterruptedTick;actor.WasAlive=state.Alive;
                PlayCues(actor.Audio,clip,cueTime,playAudio,actor.Root.gameObject);
            }
            foreach(int id in units.Keys.Where(id=>!frame.Units.Any(u=>u.EntityId==id)).ToArray())
                RemoveActor(id);
            foreach(var state in frame.Visuals)
            {
                if(string.IsNullOrEmpty(state.Resource))continue;
                if(!effects.TryGetValue(state.Id,out var entry))
                {
                    string effectResource="Zatod/"+System.IO.Path.GetFileNameWithoutExtension(state.Resource)+"/AnimationSet";
                    var lease=Pool.Acquire(effectResource,transform,()=>Sprite("Effect",effectResource).gameObject);
                    var sprite=lease.Object.GetComponent<ZatodBattleSprite>();sprite.name="Effect_"+state.Id;
                    entry=new EffectVisual{Sprite=sprite,Lease=lease};effects.Add(state.Id,entry);
                }
                var effect=entry.Sprite;
                var first=effect.Set.Clips.FirstOrDefault(c=>c.State=="Start")??effect.Set.Clips[0];var loop=effect.Set.Clips.FirstOrDefault(c=>c.State=="Loop");
                double presentationElapsed=state.Elapsed+(state.Kind=="buff"?0:finishElapsed);
                string action=presentationElapsed>=first.DurationSeconds && loop!=null?loop.State:first.State;
                double cueTime=action==first.State?presentationElapsed:presentationElapsed-first.DurationSeconds;
                double elapsed=cueTime+interpolation*state.TimeSpeed;
                bool visible=state.Kind=="buff" || state.Kind=="projectile" && (!frame.Finished || finishElapsed<.55) || state.Kind!="projectile" && presentationElapsed<first.DurationSeconds;
                effect.gameObject.SetActive(visible);if(!visible)continue;
                state.Motion.Project(state.X,state.Y,state.Height,interpolation,out double x,out double y,out double height);
                effect.transform.position=Point(x,y,height+state.HeightOffset);effect.Sample(action,(float)elapsed,state.FacingRight,(float)state.Scale*.7388535f,state.Kind=="projectile");
                int depth=Mathf.RoundToInt((float)y*10);
                effect.Renderer.sortingOrder=state.Layer switch
                {
                    ZatodBuffEffectLayer.BehindActor=>999-depth,
                    ZatodBuffEffectLayer.InFrontOfActor=>1001-depth,
                    ZatodBuffEffectLayer.AboveBattlefield=>19000,
                    ZatodBuffEffectLayer.BehindBattlefieldActors=>-9000,
                    ZatodBuffEffectLayer.WorldActors=>1000-depth,
                    _=>2000-depth
                };
                effect.Renderer.color=frame.DimForUltimate && !litActors.Contains(state.ActorId)?DimActor:Color.white;
                PlayCues(entry.Audio,action==first.State?first:loop,cueTime,playAudio);
                if(state.Kind=="chain")
                {
                    float dx=(float)(state.EndX-state.X)*1.75f,dy=(float)(state.EndY-state.Y)*.875f+(float)(state.EndHeight-state.Height)*1.75f;
                    effect.StretchWidth(Mathf.Sqrt(dx*dx+dy*dy));effect.transform.localRotation=Quaternion.Euler(0,0,Mathf.Atan2(dy,dx)*Mathf.Rad2Deg);
                }
            }
            foreach(int id in effects.Keys.Where(id=>!frame.Visuals.Any(v=>v.Id==id)).ToArray()){effects[id].Audio.Source?.Stop();Pool.Release(effects[id].Lease);effects.Remove(id);}
        }
        public void Clear()
        {
            presentationSimulation=null;finishElapsed=0;audioWave=0;StopAudio();
            GetComponent<ZatodBattleLootView>()?.Clear();
            foreach(int id in units.Keys.ToArray())RemoveActor(id);
            foreach(var e in effects.Values){e.Audio.Source?.Stop();Pool.Release(e.Lease);}effects.Clear();
            if(music!=null)music.clip=null;
        }
        void OnDestroy(){foreach(var sprite in backgrounds.Values)if(sprite!=null)Destroy(sprite);if(white!=null)Destroy(white);}
    }
}
