using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Animations;
using Zatod.Animation;

namespace Zatod.Presentation
{
    // The imported clips are sampled against simulation time. The visible output is a world renderer.
    public sealed class ZatodBattleSprite : MonoBehaviour
    {
        public SpriteRenderer Renderer{get;private set;}
        public HeroAnimationSetData Set{get;private set;}
        public string CurrentState{get;private set;}
        public string Resource{get;private set;}
        public float SampleSeconds{get;private set;}
        SpriteRenderer source;PlayableGraph graph;AnimationPlayableOutput output;
        readonly Dictionary<string,AnimationClipPlayable> playables=new Dictionary<string,AnimationClipPlayable>();
        readonly Dictionary<string,HeroAnimationClipData> definitions=new Dictionary<string,HeroAnimationClipData>();
        public void Initialize(string resource,string onlyState=null)
        {
            var asset=Resources.Load<TextAsset>(resource);if(asset==null)throw new System.IO.FileNotFoundException("Missing battle animation: "+resource);
            if(graph.IsValid())graph.Destroy();
            if(Renderer!=null){Renderer.enabled=false;ReleaseObject(Renderer.gameObject);}
            if(source!=null){source.enabled=false;ReleaseObject(source.gameObject);}
            definitions.Clear();playables.Clear();CurrentState=null;SampleSeconds=0;Resource=resource;
            Set=JsonUtility.FromJson<HeroAnimationSetData>(asset.text);
            var visual=new GameObject("Sprite",typeof(SpriteRenderer));visual.layer=ZatodBattleStage.BattleLayer;visual.transform.SetParent(transform,false);
            Renderer=visual.GetComponent<SpriteRenderer>();Renderer.sharedMaterial=Resources.Load<Material>("Zatod/World/ZatodWorldSprite");
            var sampler=new GameObject("AnimationSampler",typeof(SpriteRenderer),typeof(Animator));sampler.layer=ZatodBattleStage.BattleLayer;sampler.transform.SetParent(transform,false);
            source=sampler.GetComponent<SpriteRenderer>();source.enabled=false;var animator=sampler.GetComponent<Animator>();animator.cullingMode=AnimatorCullingMode.AlwaysAnimate;
            graph=PlayableGraph.Create("ZatodBattleSprite");graph.SetTimeUpdateMode(DirectorUpdateMode.Manual);output=AnimationPlayableOutput.Create(graph,"Sprite",animator);
            foreach(var entry in Set.Clips)
            {
                if(onlyState!=null && entry.State!=onlyState)continue;
                var clip=Resources.Load<AnimationClip>(entry.ClipResource);if(clip==null)throw new System.IO.FileNotFoundException(entry.ClipResource);
                definitions.Add(entry.State,entry);playables.Add(entry.State,AnimationClipPlayable.Create(graph,clip));
            }
            graph.Play();
        }
        public void Sample(string state,float seconds,bool facingRight,float scale,bool projectile=false)
        {
            if(!definitions.TryGetValue(state,out var d))return;
            seconds=Mathf.Max(0,seconds);
            SampleSeconds=d.Loop?Mathf.Repeat(seconds,d.DurationSeconds):Mathf.Min(seconds,Mathf.Max(0,d.DurationSeconds-.0001f));CurrentState=state;
            var playable=playables[state];source.flipX=false;output.SetSourcePlayable(playable);playable.SetTime(SampleSeconds);graph.Evaluate(0);
            var sprite=source.sprite;Renderer.sprite=sprite;Renderer.enabled=sprite!=null;if(sprite==null)return;
            Vector2 pivot=new Vector2(sprite.pivot.x/sprite.rect.width,sprite.pivot.y/sprite.rect.height);
            if(projectile && !d.PreserveSpritePivot)
            {
                int frame=d.FrameIndex(SampleSeconds);
                if(d.ContentBounds!=null && d.ContentBounds.Count==d.Frames.Count && frame<d.ContentBounds.Count)
                {
                    var content=d.ContentBounds[frame];var crop=d.Frames[frame];
                    if(d.UseProjectileOrigin)
                    {
                        float originX=d.ProjectileOriginPixelX+content.X-d.ContentBounds[0].X;
                        pivot=new Vector2((originX-crop.X)/crop.Width,(d.ProjectileOriginPixelY-crop.Y)/crop.Height);
                    }
                    else pivot=new Vector2((content.X+content.Width*.5f-crop.X)/crop.Width,pivot.y);
                }
                else pivot=new Vector2(.5f,.5f);
            }
            float direction=facingRight!=source.flipX?1:-1;
            Renderer.transform.localScale=new Vector3(direction*scale,scale,1);
            var authored=new Vector2(sprite.pivot.x/sprite.rect.width,sprite.pivot.y/sprite.rect.height);
            var shift=Vector2.Scale(authored-pivot,sprite.rect.size)/sprite.pixelsPerUnit*scale;
            Renderer.transform.localPosition=new Vector3(shift.x*direction,shift.y,0);
        }
        public void StretchWidth(float canvasWidth)
        {
            if(Renderer.sprite==null || !definitions.TryGetValue(CurrentState,out var d))return;
            float fraction=d.VisualReferenceWidthPixels>0?Renderer.sprite.rect.width/d.VisualReferenceWidthPixels:1;
            float width=Mathf.Max(.01f,canvasWidth/100*fraction);var scale=Renderer.transform.localScale;
            scale.x=Mathf.Sign(scale.x)*width/Renderer.sprite.bounds.size.x;Renderer.transform.localScale=scale;
        }
        public void ResetForReuse()
        {
            CurrentState=null;SampleSeconds=0;
            if(Renderer!=null){Renderer.enabled=false;Renderer.sprite=null;Renderer.color=Color.white;Renderer.sharedMaterial=Resources.Load<Material>("Zatod/World/ZatodWorldSprite");Renderer.SetPropertyBlock(null);Renderer.transform.localPosition=Vector3.zero;Renderer.transform.localRotation=Quaternion.identity;Renderer.transform.localScale=Vector3.one;}
            foreach(var playable in playables.Values)playable.SetTime(0);
        }
        void OnDisable(){if(graph.IsValid())graph.Stop();}
        void OnEnable(){if(graph.IsValid())graph.Play();}
        void OnDestroy(){if(graph.IsValid())graph.Destroy();}
        static void ReleaseObject(GameObject value){if(Application.isPlaying)Destroy(value);else DestroyImmediate(value);}
    }
}
