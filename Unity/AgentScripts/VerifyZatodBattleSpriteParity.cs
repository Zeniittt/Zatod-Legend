using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEngine;
using Zatod.Animation;
using Zatod.Presentation;
public static class VerifyZatodBattleSpriteParity
{
    public static object Run()
    {
        if(!Application.isPlaying)throw new Exception("Run parity in Play Mode.");
        int checks=0,sets=0,samples=0;
        void Check(bool ok,string message){checks++;if(!ok)throw new Exception(message);}
        var resources=Directory.GetFiles("Assets/Zatod/Resources/Zatod","AnimationSet.txt",SearchOption.AllDirectories).Select(s=>s.Replace('\\','/')).OrderBy(s=>s).ToArray();
        foreach(string file in resources)
        {
            string resource=file.Replace('\\','/').Substring("Assets/Zatod/Resources/".Length);resource=resource.Substring(0,resource.Length-4);
            var data=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(resource).text);
            if(data.Clips==null || data.Clips.Count==0)continue;
            var oldRoot=new GameObject("ParityOld",typeof(RectTransform),typeof(ReplaySprite));var newRoot=new GameObject("ParityNew",typeof(ZatodBattleSprite));
            try
            {
                var old=oldRoot.GetComponent<ReplaySprite>();var visual=newRoot.GetComponent<ZatodBattleSprite>();old.Initialize(resource);visual.Initialize(resource);sets++;
                var image=oldRoot.GetComponent<UnityEngine.UI.Image>();var rect=(RectTransform)oldRoot.transform;
                foreach(var clip in data.Clips)foreach(float t in new[]{0f,clip.DurationSeconds*.37f,Mathf.Max(0,clip.DurationSeconds-.0002f)})foreach(bool facing in new[]{true,false})foreach(bool projectile in new[]{false,true})
                {
                    float scale=.7388535f;old.Sample(clip.State,t,facing,scale,projectile);visual.Sample(clip.State,t,facing,scale,projectile);samples++;
                    Check(image.sprite==visual.Renderer.sprite,resource+" sprite mismatch "+clip.State);
                    Check(Mathf.Abs(old.SampleSeconds-visual.SampleSeconds)<.00001f,"Animation clock mismatch");
                    if(image.sprite==null)continue;
                    var sprite=image.sprite;var desired=rect.sizeDelta/100;var actual=visual.Renderer.bounds.size;
                    Check(Mathf.Abs(desired.x-actual.x)<.0001f && Mathf.Abs(desired.y-actual.y)<.0001f,"Rendered sprite size mismatch "+resource);
                    Check(Mathf.Sign(rect.localScale.x)==Mathf.Sign(visual.Renderer.transform.localScale.x),"Facing mismatch "+resource);
                    var pivot=new Vector2(sprite.pivot.x/sprite.rect.width,sprite.pivot.y/sprite.rect.height);
                    var shift=Vector2.Scale(pivot-rect.pivot,sprite.rect.size)/sprite.pixelsPerUnit*scale;shift.x*=Mathf.Sign(rect.localScale.x);
                    Check(Vector2.Distance(shift,visual.Renderer.transform.localPosition)<.0001f,"Projectile/custom pivot mismatch "+resource);
                }
            }
            finally{UnityEngine.Object.DestroyImmediate(oldRoot);UnityEngine.Object.DestroyImmediate(newRoot);}
        }
        Check(sets>20,"Expected imported Hero/effect animation sets");
        var result=new{Result="PASS",Sets=sets,Samples=samples,Checks=checks};File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/sprite-parity.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
}
