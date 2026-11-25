using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Animation;

namespace Zatod.Presentation
{
    // Reuses the native frame/pivot timeline; the sampled renderer stays hidden.
    // Time comes from combat snapshots, so pause, x4 and seeking share one path.
    public sealed class ZatodHudEffect : MonoBehaviour
    {
        Image picture;
        ZatodBattleSprite sampler;
        HeroAnimationClipData start,loop;
        float pixelScale;
        public float Duration=>start.DurationSeconds;
        public static ZatodHudEffect Create(Transform parent,string resource,Vector2 origin,float width)
        {
            var go=new GameObject(resource,typeof(RectTransform),typeof(CanvasRenderer),typeof(Image),typeof(ZatodHudEffect));
            var effect=go.GetComponent<ZatodHudEffect>();go.transform.SetParent(parent,false);
            effect.picture=go.GetComponent<Image>();effect.picture.raycastTarget=false;
            var rect=effect.picture.rectTransform;rect.anchorMin=rect.anchorMax=new Vector2(.5f,.5f);rect.anchoredPosition=origin;
            var source=new GameObject("Native frame sampler");source.transform.SetParent(go.transform,false);
            effect.sampler=source.AddComponent<ZatodBattleSprite>();effect.sampler.Initialize("Zatod/"+resource+"/AnimationSet");
            effect.start=effect.sampler.Set.Clips.FirstOrDefault(c=>c.State=="Start")??effect.sampler.Set.Clips[0];
            effect.loop=effect.sampler.Set.Clips.FirstOrDefault(c=>c.State=="Loop");
            effect.pixelScale=width/effect.sampler.Set.CanvasWidth;
            effect.sampler.Renderer.enabled=false;effect.picture.enabled=false;return effect;
        }
        public void Draw(double elapsed,bool visible,bool repeat)
        {
            visible=visible && elapsed>=0 && (repeat || elapsed<Duration);
            picture.enabled=visible;if(!visible)return;
            var clip=start;double time=elapsed;
            if(repeat && loop!=null && elapsed>=Duration){clip=loop;time=(elapsed-Duration)%loop.DurationSeconds;}
            else if(repeat && loop==null)time=elapsed%Duration;
            sampler.Sample(clip.State,(float)time,true,1);
            var sprite=sampler.Renderer.sprite;sampler.Renderer.enabled=false;
            picture.sprite=sprite;
            if(sprite==null){picture.enabled=false;return;}
            picture.rectTransform.sizeDelta=sprite.rect.size*pixelScale;
            picture.rectTransform.pivot=new Vector2(sprite.pivot.x/sprite.rect.width,sprite.pivot.y/sprite.rect.height);
        }
    }
}
