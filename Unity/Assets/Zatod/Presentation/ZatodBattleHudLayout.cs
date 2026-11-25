using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
namespace Zatod.Presentation
{
    [Serializable] public sealed class ZatodHeroCard
    {
        public RectTransform Root;
        public UnityEngine.UI.Image Portrait,Health,Energy,Ready;
        public UnityEngine.UI.Image[] StarIcons;
        public UnityEngine.UI.Button Button;
        public TextMeshProUGUI Name,Stars;
        [NonSerialized] public CanvasGroup UltimateSignal;
        [NonSerialized] public UnityEngine.UI.Image[] UltimateEdges;
        [NonSerialized] public ZatodHudEffect ReadyCue,TriggerCue,CastCue,FullEnergyCue,EnergyCostCue;
        [NonSerialized] public UnityEngine.UI.Image LowHealth;
    }
    public sealed class ZatodBattleHudLayout : MonoBehaviour
    {
        public RectTransform Actors,Floating,ReplayControls;
        public RawImage Background;
        public TextMeshProUGUI Time,Wave,Outcome,GoldValue,ChestValue;
        public UnityEngine.UI.Button Auto,Exit,Continue,WatchReplay;
        public UnityEngine.UI.Image AutoImage;
        public TextMeshProUGUI AutoText;
        public GameObject ResultPanel;
        public ZatodHeroCard[] Cards;
        public static Sprite Art(string name)=>Resources.Load<Sprite>("Zatod/UI/"+name);
        public static Sprite Portrait(string heroId)
        {
            string name="Portraits/"+heroId;
            return Art(name)??ZatodFormationView.FindArt(name);
        }
        static RectTransform Rect(string name,Transform parent,Vector2 min,Vector2 max,Vector2 low,Vector2 high)
        {
            var r=new GameObject(name,typeof(RectTransform)).GetComponent<RectTransform>();r.SetParent(parent,false);
            r.anchorMin=min;r.anchorMax=max;r.offsetMin=low;r.offsetMax=high;return r;
        }
        static RectTransform Box(string name,Transform parent,float x,float y,float width,float height)
        {
            var r=Rect(name,parent,Vector2.up,Vector2.up,Vector2.zero,Vector2.zero);r.pivot=Vector2.up;r.anchoredPosition=new Vector2(x,-y);r.sizeDelta=new Vector2(width,height);return r;
        }
        static UnityEngine.UI.Image Picture(RectTransform r,string art,Color? tint=null,bool raycast=false)
        {
            var i=r.gameObject.AddComponent<UnityEngine.UI.Image>();i.sprite=Art(art);i.color=tint??Color.white;i.raycastTarget=raycast;
            if(i.sprite!=null && i.sprite.border.sqrMagnitude>0)i.type=UnityEngine.UI.Image.Type.Sliced;return i;
        }
        static TextMeshProUGUI Text(Transform parent,string name,string value,float x,float y,float w,float h,int size,TMP_FontAsset font)
        {
            var label=Box(name,parent,x,y,w,h).gameObject.AddComponent<TextMeshProUGUI>();label.font=font;label.text=value;label.fontSize=size;label.alignment=TextAlignmentOptions.Center;label.color=new Color(1,.94f,.77f);label.raycastTarget=false;label.textWrappingMode=TextWrappingModes.NoWrap;return label;
        }
        static UnityEngine.UI.Button Button(Transform parent,string name,string text,float x,float y,float w,float h,TMP_FontAsset font,string art="battle_auto_bg_2")
        {
            var r=Box(name,parent,x,y,w,h);var image=Picture(r,art,null,true);var b=r.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=image;
            Text(r,"Caption",text,0,0,w,h,23,font);return b;
        }
        public static ZatodBattleHudLayout Create(Transform parent,TMP_FontAsset font)
        {
            var root=Rect("ZatodBattleHUD",parent,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);
            var hud=root.gameObject.AddComponent<ZatodBattleHudLayout>();
            var bg=Rect("Background",root,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);hud.Background=bg.gameObject.AddComponent<RawImage>();hud.Background.raycastTarget=true;
            hud.Actors=Rect("Battlefield",root,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);
            hud.Floating=Rect("CombatText",root,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);
            var top=Rect("TopBar",root,Vector2.up,Vector2.one,new Vector2(0,-90),Vector2.zero);
            hud.Exit=Button(top,"Exit","Thoát",18,20,95,46,font);
            var time=Box("TimerPanel",top,125,23,130,42);Picture(time,"battle_resource_bg");hud.Time=Text(time,"TimeRemaining","01:30",0,0,130,42,23,font);
            var wave=Rect("WavePanel",top,new Vector2(.5f,1),new Vector2(.5f,1),new Vector2(-85,-66),new Vector2(85,-10));hud.Wave=Text(wave,"WaveProgress","1/3",0,0,170,56,34,font);
            var loot=Rect("ResourcePanel",top,Vector2.one,Vector2.one,new Vector2(-340,-68),new Vector2(-20,-18));Picture(loot,"battle_resource_bg");
            Picture(Box("GoldIcon",loot,15,10,32,30),"goldicon");hud.GoldValue=Text(loot,"GoldValue","0",50,2,75,45,24,font);
            Picture(Box("ChestIcon",loot,175,8,36,34),"chest1");hud.ChestValue=Text(loot,"ChestValue","0",215,2,75,45,24,font);
            var heroBar=Rect("HeroBar",root,new Vector2(.5f,0),new Vector2(.5f,0),new Vector2(-370,18),new Vector2(370,186));
            hud.Cards=new ZatodHeroCard[5];
            for(int n=0;n<5;n++)
            {
                var card=new ZatodHeroCard();hud.Cards[n]=card;card.Root=Box("HeroSlot_"+(n+1),heroBar,n*148,0,132,165);
                Picture(card.Root,"battle_hero_bg");var button=card.Root.gameObject.AddComponent<UnityEngine.UI.Button>();button.targetGraphic=card.Root.GetComponent<UnityEngine.UI.Image>();button.targetGraphic.raycastTarget=true;card.Button=button;
                card.Portrait=Picture(Box("Portrait",card.Root,9,8,114,114),"Portraits/lina");card.Portrait.preserveAspect=true;
                card.Ready=Picture(Box("EnergyReady",card.Root,0,0,132,132),"",Color.clear);
                foreach(var edge in new[]{new[]{0f,0f,132f,3f},new[]{0f,129f,132f,3f},new[]{0f,0f,3f,132f},new[]{129f,0f,3f,132f}})Picture(Box("ReadyBorder",card.Ready.transform,edge[0],edge[1],edge[2],edge[3]),"",new Color(1,.82f,.15f));
                card.Ready.gameObject.SetActive(false);
                card.Name=Text(card.Root,"HeroName","Hero",0,116,132,22,15,font);
                var stars=Box("Stars",card.Root,9,92,114,20);card.Stars=Text(stars,"StarCount","",0,0,114,20,18,font);card.StarIcons=new UnityEngine.UI.Image[5];for(int j=0;j<5;j++){card.StarIcons[j]=Picture(Box("Star_"+(j+1),stars,j*18,0,18,18),"hero_star_1");card.StarIcons[j].preserveAspect=true;}
                var hp=Box("HealthBackground",card.Root,9,139,114,8);Picture(hp,"battle_hero_progress_bg");card.Health=Picture(Box("HealthFill",hp,0,0,114,8),"battle_hero_blood_progress");
                var mp=Box("EnergyBackground",card.Root,9,151,114,8);Picture(mp,"battle_hero_progress_bg");card.Energy=Picture(Box("EnergyFill",mp,0,0,114,8),"battle_hero_energy_progress");
                card.Health.type=card.Energy.type=UnityEngine.UI.Image.Type.Filled;card.Health.fillMethod=card.Energy.fillMethod=UnityEngine.UI.Image.FillMethod.Horizontal;card.Health.fillOrigin=card.Energy.fillOrigin=0;
            }
            var controls=Rect("BattleControls",root,new Vector2(1,0),new Vector2(1,0),new Vector2(-185,35),new Vector2(-35,100));
            hud.Auto=Button(controls,"Auto","AUTO",0,0,150,65,font);hud.AutoImage=hud.Auto.GetComponent<UnityEngine.UI.Image>();hud.AutoText=hud.Auto.GetComponentInChildren<TextMeshProUGUI>();
            hud.ReplayControls=Rect("ReplayControls",root,Vector2.up,Vector2.one,new Vector2(0,-140),new Vector2(0,-80));
            var result=Rect("Result",root,new Vector2(.5f,.5f),new Vector2(.5f,.5f),new Vector2(-330,-130),new Vector2(330,130));Picture(result,"battle_resource_bg",new Color(.2f,.16f,.1f,.96f));hud.ResultPanel=result.gameObject;
            hud.Outcome=Text(result,"Outcome","",20,15,620,115,35,font);
            hud.Continue=Button(result,"Continue","Tiếp tục",80,165,220,55,font);hud.WatchReplay=Button(result,"WatchReplay","Xem lại",360,165,220,55,font);hud.ResultPanel.SetActive(false);
            return hud;
        }
    }
}
