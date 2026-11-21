using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;
using static Zatod.Presentation.ZatodHeroUi;

namespace Zatod.Presentation
{
    public sealed class ZatodHeroRosterView : MonoBehaviour
    {
        public TMP_FontAsset Font;
        public RectTransform Panel,CurrencyRow,Heading,Content,FilterRow;
        public ScrollRect RosterScroll;
        public UnityEngine.UI.Button Back;
        public UnityEngine.UI.Button[] Filters;
        public HeroPosition? PositionFilter {get;private set;}
        public Action<string,string> OnEquipment;
        public int VisibleCount=>cards.Count;
        public IReadOnlyList<string> VisibleHeroIds=>ids;
        readonly List<RectTransform> cards=new List<RectTransform>();
        readonly List<string> ids=new List<string>();
        HeroCatalog catalog;CharacterData account;Action back;Action<string> select;Vector2 size;
        void Awake()
        {
            Back.onClick.AddListener(()=>back?.Invoke());
            for(int n=0;n<Filters.Length;n++){int index=n;Filters[n].onClick.AddListener(()=>SetFilter(index==0?(HeroPosition?)null:(HeroPosition)(index-1)));}
        }
        public void Open(HeroCatalog definitions,CharacterData owned,Action onBack,Action<string> onSelect)
        {catalog=definitions;account=owned;back=onBack;select=onSelect;gameObject.SetActive(true);Refresh(owned);Fit();}
        public void Refresh(CharacterData owned)
        {
            account=owned;float scroll=RosterScroll.verticalNormalizedPosition;
            foreach(var card in cards){card.gameObject.SetActive(false);Destroy(card.gameObject);}cards.Clear();ids.Clear();
            foreach(var hero in account.HeroDesk.Where(h=>!PositionFilter.HasValue || catalog.Hero(h.HeroDefinitionId).Position==PositionFilter))
            {
                var definition=catalog.Hero(hero.HeroDefinitionId);string id=hero.HeroInstanceId;
                var b=Button(Content,"Hero_"+id,"bg_hero_normal",()=>select?.Invoke(id));var r=(RectTransform)b.transform;cards.Add(r);ids.Add(id);
                var portrait=ZatodFormationView.CreateCard(r,"Portrait",135,Font);portrait.Root.anchoredPosition=new Vector2(18,-18);
                portrait.Portrait.sprite=ZatodFormationView.Art("Portraits/"+definition.Id);portrait.Frame.sprite=ZatodFormationView.Art("hero_icon_frame_"+Rank(hero,catalog));portrait.Level.text=hero.Level.ToString();portrait.Selected.gameObject.SetActive(false);
                portrait.Button.interactable=true;portrait.Button.onClick.AddListener(()=>select?.Invoke(id));
                for(int n=0;n<5;n++){portrait.Stars[n].gameObject.SetActive(n<hero.Stars);portrait.Stars[n].rectTransform.anchoredPosition=new Vector2((108-Math.Clamp(hero.Stars,1,5)*17)/2+n*17,-86);}
                Picture(r,"NameBackground","bg_name",172,15,365,48);
                var name=Text(r,"HeroName",definition.Name,Font,27);Place(name.rectTransform,178,16,352,46);name.alignment=TextAlignmentOptions.Center;
                Picture(r,"Astrolabe","astrolabe_herolist_bg_1",178,74,352,28);
                Picture(r,"AstrolabeLock","astrolabe_herolist_lock",342,72,27,28,aspect:true);
                int index=0;foreach(var slot in HeroProgression.CurrentRank(hero,catalog).EquipmentSlots.Take(6))Equipment(r,hero,slot,account,catalog,178+index++*58,116,49,()=>OnEquipment?.Invoke(hero.HeroInstanceId,slot.Id));
            }
            ApplyFilterArt();LayoutCards();RosterScroll.verticalNormalizedPosition=scroll;
        }
        public void SetFilter(HeroPosition? value)
        {if(PositionFilter==value)return;PositionFilter=value;Refresh(account);RosterScroll.verticalNormalizedPosition=1;}
        void ApplyFilterArt(){for(int n=0;n<Filters.Length;n++)Filters[n].image.sprite=Art((!PositionFilter.HasValue?n==0:n==(int)PositionFilter.Value+1)?"tab_selected":"tab_unselected");}
        void LateUpdate(){Fit();}
        public void Fit()
        {
            Vector2 now=((RectTransform)transform).rect.size;if(now==size)return;size=now;
            Place((RectTransform)Back.transform,24,20,62,62);Place(Heading,102,20,Mathf.Max(210,size.x-830),62);
            Place(CurrencyRow,size.x-714,24,690,54);
            float header=size.x<1400?144:102;if(size.x<1400){Place(CurrencyRow,size.x-714,87,690,54);Place(Heading,102,20,size.x-140,62);}
            Place(Panel,24,header,size.x-48,size.y-header-24);
            Fill((RectTransform)RosterScroll.transform,Vector2.zero,Vector2.one,new Vector2(22,22),new Vector2(-132,-22));
            Place(FilterRow,Panel.rect.width-110,22,90,400);LayoutCards();
        }
        void LayoutCards()
        {
            float width=RosterScroll.viewport.rect.width;int columns=width<800?1:2;float cardWidth=(width-(columns-1)*14)/columns;
            float scale=Mathf.Min(1.3f,cardWidth/558f),height=184*scale;
            for(int n=0;n<cards.Count;n++){Place(cards[n],n%columns*(cardWidth+14),n/columns*(height+14),558,184);cards[n].localScale=Vector3.one*scale;}
            Content.sizeDelta=new Vector2(0,Mathf.Max(RosterScroll.viewport.rect.height,Mathf.CeilToInt(cards.Count/(float)columns)*(height+14)));
        }
        public static ZatodHeroRosterView Create(Transform parent,TMP_FontAsset font)
        {
            var root=Box(parent,"ZatodHeroRosterView");Stretch(root);var v=root.gameObject.AddComponent<ZatodHeroRosterView>();v.Font=font;
            var bg=Picture(root,"Backdrop","formation_forest");Stretch(bg.rectTransform);bg.color=new Color(.8f,.85f,.9f);bg.gameObject.AddComponent<ZatodFullScreenArt>();
            v.Back=Button(root,"Back","break_butt_bj");Picture(v.Back.transform,"Arrow","break_butt",8,9,46,44,aspect:true);v.Back.onClick.AddListener(()=>v.back?.Invoke());
            v.Heading=Text(root,"Title","List of Heroes",font,37).rectTransform;v.CurrencyRow=Currencies(root,font);
            v.Panel=Picture(root,"Frame","frame_common1",hit:true).rectTransform;
            var shade=Picture(v.Panel,"PanelFill","battle_prepare_9bg_2");Stretch(shade.rectTransform,12);
            v.RosterScroll=Scroll(v.Panel,"HeroScroll",out v.Content);v.FilterRow=Box(v.Panel,"Filters");v.Filters=new UnityEngine.UI.Button[4];
            string[] labels={"All","Front","Mid","Rear"};for(int n=0;n<4;n++){int index=n;var b=Button(v.FilterRow,labels[n],n==0?"tab_selected":"tab_unselected",()=>v.SetFilter(index==0?(HeroPosition?)null:(HeroPosition)(index-1)));Place((RectTransform)b.transform,0,n*92,82,82);Caption(b,labels[n],font,24);v.Filters[n]=b;}
            return v;
        }
    }
}
