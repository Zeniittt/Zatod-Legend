using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Combat;

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
        public int UnitCount=>units.Count;
        public int EffectCount=>effects.Count;
        sealed class UnitVisual {public Transform Root;public ZatodBattleSprite Sprite;public SpriteRenderer Health;public BoxCollider2D Hit;public string Action;public double Elapsed=-1;}
        readonly Dictionary<int,UnitVisual> units=new Dictionary<int,UnitVisual>();
        readonly Dictionary<int,ZatodBattleSprite> effects=new Dictionary<int,ZatodBattleSprite>();
        readonly Dictionary<string,Sprite> backgrounds=new Dictionary<string,Sprite>();
        SpriteRenderer background;Sprite white;AudioSource audioSource;
        RectTransform coordinateSpace;
        ZatodBattleSimulation presentationSimulation;float finishedAt=-1;
        public static Vector3 Point(double x,double y,double height)=>new Vector3(-7+(float)x*.0175f,-.7f+(float)y*.00875f+(float)height*.0175f,0);
        void Awake()
        {
            gameObject.layer=BattleLayer;
            var cam=new GameObject("ZatodBattleCamera",typeof(Camera),typeof(Physics2DRaycaster));cam.layer=BattleLayer;cam.transform.SetParent(transform,false);
            BattleCamera=cam.GetComponent<Camera>();BattleCamera.orthographic=true;BattleCamera.cullingMask=1<<BattleLayer;BattleCamera.depth=10;
            BattleCamera.clearFlags=CameraClearFlags.SolidColor;BattleCamera.backgroundColor=Color.black;BattleCamera.nearClipPlane=.1f;BattleCamera.farClipPlane=100;
            background=Picture("Background",transform,-30000);white=UnityEngine.Sprite.Create(Texture2D.whiteTexture,new Rect(0,0,1,1),new Vector2(.5f,.5f),1);
            audioSource=gameObject.AddComponent<AudioSource>();audioSource.spatialBlend=0;
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
        public void Draw(ZatodFrame frame,ZatodBattleSimulation simulation,double interpolation,int team,bool canInput,bool playAudio)
        {
            if(presentationSimulation!=simulation){presentationSimulation=simulation;finishedAt=-1;}
            if(frame.Finished && finishedAt<0)finishedAt=Time.unscaledTime;
            double finishElapsed=frame.Finished?Time.unscaledTime-finishedAt:0;
            string resource=simulation.BackgroundResource;
            if(!backgrounds.TryGetValue(resource,out var bg))
            {
                var texture=Resources.Load<Texture2D>("Zatod/Backgrounds/"+System.IO.Path.GetFileNameWithoutExtension(resource));
                if(texture==null)throw new System.IO.FileNotFoundException("Missing battle background: "+resource);
                bg=UnityEngine.Sprite.Create(texture,new Rect(0,0,texture.width,texture.height),new Vector2(.5f,.5f),100);backgrounds.Add(resource,bg);
            }
            background.sprite=bg;background.flipX=simulation.FlipBackground;
            foreach(var state in frame.Units)
            {
                if(!units.TryGetValue(state.EntityId,out var actor))
                {
                    var sprite=Sprite("Hero_"+state.EntityId,state.AnimationSetResource);
                    actor=new UnitVisual{Root=sprite.transform,Sprite=sprite,Hit=sprite.gameObject.AddComponent<BoxCollider2D>(),Health=Picture("Health",sprite.transform,20000)};
                    actor.Hit.isTrigger=true;actor.Health.sprite=white;actor.Health.color=state.Team==0?new Color(.35f,.85f,.18f):new Color(.86f,.3f,.24f);
                    int id=state.EntityId;sprite.gameObject.AddComponent<ZatodBattleActorPointer>().Click=()=>Ultimate?.Invoke(id);units.Add(id,actor);
                }
                state.Motion.Project(state.X,state.Y,state.Height,interpolation,out double x,out double y,out double height);
                actor.Root.position=Point(x,y,height);actor.Sprite.Sample(state.Action,(float)(state.ActionElapsed+interpolation*state.ActionSpeed+(!state.Alive?finishElapsed:0)),state.FacingRight,(float)state.ArtScale*.7388535f);
                actor.Sprite.Renderer.sortingOrder=1000-Mathf.RoundToInt((float)y*10);
                actor.Hit.enabled=canInput && !frame.Finished && state.Alive && state.Team==team && state.Energy>=state.MaxEnergy;
                var bounds=actor.Sprite.Renderer.bounds;actor.Hit.size=bounds.size;actor.Hit.offset=bounds.center-actor.Root.position;
                float health=.9f*(float)(state.Hp/Math.Max(1,state.MaxHp));actor.Health.transform.localScale=new Vector3(health,.05f,1);actor.Health.transform.localPosition=new Vector3(-.45f+health/2,.2f,0);
                if(playAudio)
                {
                    double previous=actor.Action==state.Action?actor.Elapsed:-.00001;
                    var clip=actor.Sprite.Set.Clips.FirstOrDefault(c=>c.State==state.Action);
                    if(clip!=null)foreach(var cue in clip.AudioCues.Where(c=>c.Time>previous && c.Time<=state.ActionElapsed))
                    {var audio=Resources.Load<AudioClip>(cue.Resource);if(audio!=null)audioSource.PlayOneShot(audio,.45f);}
                }
                actor.Action=state.Action;actor.Elapsed=state.ActionElapsed;
            }
            foreach(int id in units.Keys.Where(id=>!frame.Units.Any(u=>u.EntityId==id)).ToArray()){Destroy(units[id].Root.gameObject);units.Remove(id);}
            foreach(var state in frame.Visuals)
            {
                if(string.IsNullOrEmpty(state.Resource))continue;
                if(!effects.TryGetValue(state.Id,out var effect))
                {
                    effect=Sprite("Effect_"+state.Id,"Zatod/"+System.IO.Path.GetFileNameWithoutExtension(state.Resource)+"/AnimationSet");effects.Add(state.Id,effect);
                }
                var first=effect.Set.Clips.FirstOrDefault(c=>c.State=="Start")??effect.Set.Clips[0];var loop=effect.Set.Clips.FirstOrDefault(c=>c.State=="Loop");
                double presentationElapsed=state.Elapsed+(state.Kind=="buff"?0:finishElapsed);
                string action=presentationElapsed>=first.DurationSeconds && loop!=null?loop.State:first.State;
                double elapsed=(action==first.State?presentationElapsed:presentationElapsed-first.DurationSeconds)+interpolation*state.TimeSpeed;
                bool visible=state.Kind=="buff" || state.Kind=="projectile" && (!frame.Finished || finishElapsed<.55) || state.Kind!="projectile" && presentationElapsed<first.DurationSeconds;
                effect.gameObject.SetActive(visible);if(!visible)continue;
                state.Motion.Project(state.X,state.Y,state.Height,interpolation,out double x,out double y,out double height);
                effect.transform.position=Point(x,y,height);effect.Sample(action,(float)elapsed,state.FacingRight,(float)state.Scale*.7388535f,state.Kind=="projectile");
                effect.Renderer.sortingOrder=2000-Mathf.RoundToInt((float)y*10);
                if(state.Kind=="chain")
                {
                    float dx=(float)(state.EndX-state.X)*1.75f,dy=(float)(state.EndY-state.Y)*.875f+(float)(state.EndHeight-state.Height)*1.75f;
                    effect.StretchWidth(Mathf.Sqrt(dx*dx+dy*dy));effect.transform.localRotation=Quaternion.Euler(0,0,Mathf.Atan2(dy,dx)*Mathf.Rad2Deg);
                }
            }
            foreach(int id in effects.Keys.Where(id=>!frame.Visuals.Any(v=>v.Id==id)).ToArray()){Destroy(effects[id].gameObject);effects.Remove(id);}
        }
        public void Clear()
        {
            presentationSimulation=null;finishedAt=-1;
            GetComponent<ZatodBattleLootView>()?.Clear();
            foreach(var u in units.Values)if(u.Root!=null)Destroy(u.Root.gameObject);units.Clear();
            foreach(var e in effects.Values)if(e!=null)Destroy(e.gameObject);effects.Clear();if(audioSource!=null)audioSource.Stop();
        }
        void OnDestroy(){foreach(var sprite in backgrounds.Values)if(sprite!=null)Destroy(sprite);if(white!=null)Destroy(white);}
    }
}
