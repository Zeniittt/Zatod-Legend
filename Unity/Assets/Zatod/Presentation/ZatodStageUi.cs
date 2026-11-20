using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;
namespace Zatod.Presentation
{
    public static class ZatodStageUi
    {
        public const string ResourcesPath="Zatod/UI/StagePreview/";
        public static Sprite Art(string name)=>Resources.Load<Sprite>(ResourcesPath+name) ?? ZatodFormationView.Art(name);
        public static RectTransform Box(Transform parent,string name,float x,float y,float w,float h)
        {
            var r=new GameObject(name,typeof(RectTransform)).GetComponent<RectTransform>();r.SetParent(parent,false);
            r.anchorMin=r.anchorMax=r.pivot=Vector2.up;r.anchoredPosition=new Vector2(x,-y);r.sizeDelta=new Vector2(w,h);return r;
        }
        public static UnityEngine.UI.Image Image(RectTransform rect,string asset,bool hit=false)
        {
            var image=rect.gameObject.AddComponent<UnityEngine.UI.Image>();image.sprite=Art(asset);image.raycastTarget=hit;
            if(image.sprite.border.sqrMagnitude>0)image.type=UnityEngine.UI.Image.Type.Sliced;return image;
        }
        public static TextMeshProUGUI Text(Transform parent,string name,string value,float x,float y,float w,float h,int size,TMP_FontAsset font)
        {
            var t=Box(parent,name,x,y,w,h).gameObject.AddComponent<TextMeshProUGUI>();t.font=font;t.text=value;t.fontSize=size;
            t.color=new Color(1,.97f,.87f);t.raycastTarget=false;t.alignment=TextAlignmentOptions.MidlineLeft;
            t.textWrappingMode=TextWrappingModes.NoWrap;t.outlineWidth=.16f;t.outlineColor=new Color32(35,28,26,255);return t;
        }
        public static UnityEngine.UI.Button Button(Transform parent,string name,string art,float x,float y,float w,float h)
        {
            var r=Box(parent,name,x,y,w,h);var i=Image(r,art,true);var b=r.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=i;return b;
        }
        public static void DrawDrops(RectTransform row,CampaignStageDefinition stage,HeroCatalog catalog,float size,float gap,int columns)
        {
            foreach(Transform child in row){child.gameObject.SetActive(false);UnityEngine.Object.Destroy(child.gameObject);}
            string[] colors={"white","green","blue","purple","purple","orange","red","pink","prismatic"};int n=0;
            foreach(var drop in stage.DropItems)
            {
                var item=catalog.Item(drop.ItemId);var r=Box(row,"Item_"+drop.ItemId,(n%columns)*(size+gap),(n/columns)*(size+gap),size,size);
                var mask=Image(Box(r,"Mask",0,0,size,size),"equip_frame_mask");mask.gameObject.AddComponent<Mask>().showMaskGraphic=false;
                Image(Box(mask.transform,"Icon",3,3,size-6,size-6),"Items/"+drop.ItemId);
                Image(Box(r,"QualityFrame",0,0,size,size),"equip_frame_"+colors[Math.Clamp(item.Quality,1,9)-1]);n++;
            }
        }
    }
}
