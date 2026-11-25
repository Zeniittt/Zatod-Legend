using System.Linq;
using UnityEngine;
namespace Zatod.Presentation
{
    public sealed class ZatodWorldIdleVisual:MonoBehaviour
    {
        ZatodBattleSprite sprite;string state;float scale,offset;double started;
        public void Initialize(string resource,float height)
        {
            var data=JsonUtility.FromJson<Zatod.Animation.HeroAnimationSetData>(Resources.Load<TextAsset>(resource).text);
            state=data.Clips.FirstOrDefault(c=>c.State=="Idle")?.State??data.Clips.FirstOrDefault(c=>c.State=="Loop")?.State??data.Clips.First().State;
            sprite=gameObject.AddComponent<ZatodBattleSprite>();sprite.Initialize(resource,state);sprite.Sample(state,0,true,1);
            var bounds=sprite.Renderer.bounds;scale=height/Mathf.Max(.01f,bounds.size.y);offset=-bounds.min.y*scale+transform.position.y*scale;
            // The wrapper remains the world interaction anchor; animation has its native pivot.
            sprite.Renderer.transform.localPosition+=new Vector3(0,offset,0);
            foreach(var t in GetComponentsInChildren<Transform>(true))t.gameObject.layer=ZatodWorldView.WorldLayer;
            started=Time.unscaledTimeAsDouble;
        }
        void Update(){if(sprite==null)return;sprite.Sample(state,(float)(Time.unscaledTimeAsDouble-started),true,scale);sprite.Renderer.transform.localPosition+=new Vector3(0,offset,0);}
    }
}
