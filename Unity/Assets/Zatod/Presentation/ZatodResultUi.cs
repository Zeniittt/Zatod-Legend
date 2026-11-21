using System;
using TMPro;
using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Presentation
{
    public static class ZatodResultUi
    {
        public const string ResourcePath="Zatod/UI/BattleResult/";
        public static Sprite Art(string name)=>Resources.Load<Sprite>(ResourcePath+name);
        public static RectTransform Box(Transform parent,string name)=>ZatodHeroUi.Box(parent,name);
        public static void Place(RectTransform rect,float x,float y,float w,float h)=>ZatodHeroUi.Place(rect,x,y,w,h);
        public static UnityEngine.UI.Image Picture(Transform parent,string name,string art,bool hit=false,bool aspect=false)
        {
            var r=Box(parent,name);var i=r.gameObject.AddComponent<UnityEngine.UI.Image>();i.sprite=Art(art);
            if(i.sprite==null)throw new InvalidOperationException("Missing native result art: "+art);
            i.preserveAspect=aspect;i.raycastTarget=hit;
            if(!aspect && i.sprite.border.sqrMagnitude>0)i.type=UnityEngine.UI.Image.Type.Sliced;return i;
        }
        public static TextMeshProUGUI Text(Transform parent,string name,string value,TMP_FontAsset font,int size=25)
            =>ZatodHeroUi.Text(parent,name,value,font,size);
        public static UnityEngine.UI.Button Button(Transform parent,string name,string art)
        {var i=Picture(parent,name,art,true);var b=i.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=i;return b;}
        public static void Caption(UnityEngine.UI.Button button,string value,TMP_FontAsset font,int size=25)=>ZatodHeroUi.Caption(button,value,font,size);
        public static void ConfigureCard(ZatodFormationCard card,string id,int level,int stars,int rank)
        {
            card.Portrait.sprite=ZatodStageUi.Art("Portraits/"+id);card.Frame.sprite=ZatodFormationView.Art("hero_icon_frame_"+Math.Clamp(rank,1,9));card.Level.text=level.ToString();
            card.Selected.gameObject.SetActive(false);card.Button.enabled=false;card.Button.targetGraphic.raycastTarget=false;
            for(int n=0;n<5;n++)card.Stars[n].gameObject.SetActive(n<stars);
        }
    }
}
