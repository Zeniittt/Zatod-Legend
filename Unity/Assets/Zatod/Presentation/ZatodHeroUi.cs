using System;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;

namespace Zatod.Presentation
{
    // Native art and shared read-only equipment presentation. No inventory mutations here.
    public static class ZatodHeroUi
    {
        public const string Path="Zatod/UI/Hero/";
        public static Sprite Art(string name)=>Resources.Load<Sprite>(Path+name) ?? Resources.Load<Sprite>("Zatod/UI/"+name) ?? ZatodStageUi.Art(name);
        public static RectTransform Box(Transform parent,string name,float x=0,float y=0,float w=100,float h=100)=>ZatodStageUi.Box(parent,name,x,y,w,h);
        public static void Place(RectTransform r,float x,float y,float w,float h)
        {r.anchorMin=r.anchorMax=r.pivot=Vector2.up;r.anchoredPosition=new Vector2(x,-y);r.sizeDelta=new Vector2(w,h);}
        public static void Fill(RectTransform r,Vector2 min,Vector2 max,Vector2 low,Vector2 high)
        {r.anchorMin=min;r.anchorMax=max;r.pivot=new Vector2(.5f,.5f);r.offsetMin=low;r.offsetMax=high;}
        public static void Stretch(RectTransform r,float inset=0)=>Fill(r,Vector2.zero,Vector2.one,Vector2.one*inset,-Vector2.one*inset);
        public static UnityEngine.UI.Image Picture(Transform parent,string name,string art,float x=0,float y=0,float w=100,float h=100,bool hit=false,bool aspect=false)
        {
            var image=Box(parent,name,x,y,w,h).gameObject.AddComponent<UnityEngine.UI.Image>();image.sprite=Art(art);image.raycastTarget=hit;image.preserveAspect=aspect;
            if(!aspect && image.sprite!=null && image.sprite.border.sqrMagnitude>0)image.type=UnityEngine.UI.Image.Type.Sliced;return image;
        }
        public static TextMeshProUGUI Text(Transform parent,string name,string value,TMP_FontAsset font,int size=24)
        {
            var t=ZatodStageUi.Text(parent,name,value,0,0,100,40,size,font);t.enableAutoSizing=true;t.fontSizeMin=size*.72f;t.fontSizeMax=size;
            t.overflowMode=TextOverflowModes.Ellipsis;return t;
        }
        public static UnityEngine.UI.Button Button(Transform parent,string name,string art,Action action=null)
        {
            var i=Picture(parent,name,art,hit:true);var b=i.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=i;
            if(action!=null)b.onClick.AddListener(()=>action());return b;
        }
        public static void Caption(UnityEngine.UI.Button b,string text,TMP_FontAsset font,int size=24)
        {var t=Text(b.transform,"Caption",text,font,size);Stretch(t.rectTransform,4);t.alignment=TextAlignmentOptions.Center;}
        public static ScrollRect Scroll(Transform parent,string name,out RectTransform content)
        {
            var root=Box(parent,name);var scroll=root.gameObject.AddComponent<ScrollRect>();scroll.horizontal=false;scroll.vertical=true;scroll.movementType=ScrollRect.MovementType.Clamped;scroll.scrollSensitivity=50;
            var view=Box(root,"Viewport");Stretch(view);view.gameObject.AddComponent<RectMask2D>();
            var hit=view.gameObject.AddComponent<UnityEngine.UI.Image>();hit.color=Color.clear;hit.raycastTarget=true;
            content=Box(view,"Content");content.anchorMin=Vector2.up;content.anchorMax=Vector2.one;content.pivot=new Vector2(.5f,1);content.sizeDelta=Vector2.zero;
            scroll.viewport=view;scroll.content=content;return scroll;
        }
        public static int Rank(HeroData hero,HeroCatalog catalog)=>Math.Max(1,catalog.Hero(hero.HeroDefinitionId).Ranks.FindIndex(r=>r.Id==hero.RankId)+1);
        public static string EquipmentState(HeroData hero,EquipmentSlotDefinition slot,CharacterData account)
        {if(hero.EquippedItems.Any(i=>i.SlotId==slot.Id))return "equipped";return account.Inventory.Any(i=>i.ItemId==slot.RequiredItemId)?"available":"missing";}
        public static void Equipment(Transform parent,HeroData hero,EquipmentSlotDefinition slot,CharacterData account,HeroCatalog catalog,float x,float y,float size,Action onClick=null)
        {
            string state=EquipmentState(hero,slot,account);var root=Box(parent,"Equipment_"+slot.Id,x,y,size,size);
            // A non-interactive Image allows a roster cell's parent Button to receive the click.
            // Slot clicks open the native equipment popup independently of the roster card.
            var empty=Picture(root,"Empty","icon_unequip",0,0,size,size,true,true);var block=root.gameObject.AddComponent<UnityEngine.UI.Button>();block.targetGraphic=empty;if(onClick!=null)block.onClick.AddListener(()=>onClick());
            if(state=="available")Picture(root,"Available","equip_add_1",size*.17f,size*.17f,size*.66f,size*.66f,aspect:true);
            if(state!="equipped")return;
            var actual=hero.EquippedItems.First(i=>i.SlotId==slot.Id);var item=catalog.Item(actual.ItemId);
            Picture(root,"Item_"+actual.ItemId,"Items/"+actual.ItemId,2,2,size-4,size-4,aspect:true);
            string[] colors={"white","green","blue","purple","purple","orange","red","pink","prismatic"};
            Picture(root,"Quality","equip_frame_"+colors[Math.Clamp(item.Quality,1,9)-1],0,0,size,size,aspect:true);
        }
        public static RectTransform Currencies(Transform parent,TMP_FontAsset font)
        {
            var row=Box(parent,"Currencies",w:690,h:54);
            string[] icons={"diamond","goldicon","vitality"};string[] labels={"Diamond","Gold","Stamina"};
            for(int n=0;n<3;n++)
            {
                var panel=Picture(row,labels[n],"battle_resource_bg",n*230,0,222,54);
                var b=Button(panel.transform,"Add","buttion_big");Place((RectTransform)b.transform,0,5,38,40);Caption(b,"+",font,25);
                var value=Text(panel.transform,"Value","??",font,24);Place(value.rectTransform,45,2,120,48);value.alignment=TextAlignmentOptions.MidlineRight;
                Picture(panel.transform,"Icon",icons[n],172,7,42,40,aspect:true);
            }
            return row;
        }
    }
}
