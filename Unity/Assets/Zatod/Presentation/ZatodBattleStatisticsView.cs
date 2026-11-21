using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Combat;
using Zatod.Heroes;
using static Zatod.Presentation.ZatodResultUi;

namespace Zatod.Presentation
{
    public sealed class ZatodBattleStatisticsView : MonoBehaviour
    {
        public TMP_FontAsset Font;
        public RectTransform Panel,TitleBar,LeftContent,RightContent;
        public TextMeshProUGUI Title,LeftTitle,RightTitle;
        public ScrollRect LeftScroll,RightScroll;
        public UnityEngine.UI.Button Close;
        public UnityEngine.UI.Button[] Tabs;
        public int SelectedTab {get;private set;}
        public int RowCount=>rows.Count;
        public IReadOnlyList<ZatodUnitStatistics> Report=>data;
        readonly List<ZatodUnitStatistics> data=new List<ZatodUnitStatistics>();
        sealed class Row {public RectTransform Root,Icon,Bar;public TextMeshProUGUI Name,Number;public double Value;public int Team;}
        readonly List<Row> rows=new List<Row>();Vector2 size;
        static readonly string[] Names={"Damage dealt","Damage taken","Healing","Kills"};
        void Awake()
        {
            Close.onClick.AddListener(()=>gameObject.SetActive(false));
            for(int n=0;n<Tabs.Length;n++){int index=n;Tabs[n].onClick.AddListener(()=>SelectTab(index));}
        }
        public void Open(IEnumerable<ZatodUnitStatistics> report,HeroCatalog catalog,TMP_FontAsset font)
        {
            Font=font;data.Clear();data.AddRange(report.Select(s=>s.Copy()));gameObject.SetActive(true);SelectTab(0);
        }
        public static double Metric(ZatodUnitStatistics row,int tab)=>tab==0?row.DamageDealt:tab==1?row.DamageTaken:tab==2?row.Healing:row.Kills;
        public void SelectTab(int tab){SelectedTab=Math.Clamp(tab,0,3);Refresh();size=Vector2.zero;Fit();LeftScroll.verticalNormalizedPosition=RightScroll.verticalNormalizedPosition=1;}
        void Refresh()
        {
            foreach(var row in rows){row.Root.gameObject.SetActive(false);Destroy(row.Root.gameObject);}rows.Clear();
            Title.text="Battle Statistics · "+Names[SelectedTab];
            for(int n=0;n<Tabs.Length;n++)Tabs[n].image.sprite=Art("crusade/btn_statics_tag"+(n==SelectedTab?"_selected":"_bg"));
            double maximum=data.Count==0?0:data.Max(s=>Metric(s,SelectedTab));
            foreach(int side in new[]{0,1})
            foreach(var unit in data.Where(s=>s.Team==side).OrderByDescending(s=>Metric(s,SelectedTab)).ThenBy(s=>s.Wave).ThenBy(s=>s.EntityId))
            {
                var root=Box(side==0?LeftContent:RightContent,"Unit_"+unit.EntityId);var icon=Box(root,"Portrait");
                var card=ZatodFormationView.CreateCard(icon,"Card",54,Font);ConfigureCard(card,unit.DefinitionId,unit.Level,0,1);
                var name=Text(root,"Name",unit.Name+(side==1?" · W"+unit.Wave:""),Font,21);
                double value=Metric(unit,SelectedTab);var number=Text(root,"Value",Math.Round(value).ToString("N0"),Font,22);number.alignment=TextAlignmentOptions.TopRight;
                var bg=Picture(root,"BarBackground","crusade/bar_data_bg").rectTransform;
                var bar=Picture(bg,"Bar",side==0?"crusade/bar_self_data":"crusade/bar_enemy_data").rectTransform;
                bar.anchorMin=Vector2.zero;bar.anchorMax=new Vector2(maximum<=0?0:(float)(value/maximum),1);bar.offsetMin=bar.offsetMax=Vector2.zero;
                rows.Add(new Row{Root=root,Icon=icon,Name=name,Number=number,Bar=bg,Value=value,Team=side});
            }
        }
        void LateUpdate()=>Fit();
        public void Fit()
        {
            Vector2 next=((RectTransform)transform).rect.size;if(size==next)return;size=next;float w=size.x,h=size.y;if(w<1||h<1)return;
            Place(Panel,w*.055f,h*.10f,w*.89f,h*.80f);Place(TitleBar,w*.055f,h*.10f,w*.89f,h*.105f);
            Place(Title.rectTransform,w*.14f,h*.125f,w*.72f,h*.055f);Title.alignment=TextAlignmentOptions.Center;
            Place(Close.GetComponent<RectTransform>(),w*.89f,h*.095f,h*.075f,h*.075f);
            float tabSize=Math.Min(h*.095f,w*.105f),gap=tabSize*.38f,total=4*tabSize+3*gap;
            for(int n=0;n<Tabs.Length;n++)Place(Tabs[n].GetComponent<RectTransform>(),(w-total)/2+n*(tabSize+gap),h*.218f,tabSize,tabSize);
            Place(LeftTitle.rectTransform,w*.10f,h*.318f,w*.37f,h*.04f);Place(RightTitle.rectTransform,w*.53f,h*.318f,w*.37f,h*.04f);
            Place((RectTransform)LeftScroll.transform,w*.09f,h*.375f,w*.39f,h*.46f);Place((RectTransform)RightScroll.transform,w*.52f,h*.375f,w*.39f,h*.46f);
            float rowH=Math.Max(68,h*.105f);int[] counts={0,0};
            foreach(var row in rows)
            {
                int index=counts[row.Team]++;float rw=w*.39f;Place(row.Root,0,index*rowH,rw,rowH);
                Place(row.Icon,0,6,54,54);Place(row.Name.rectTransform,67,1,rw-145,28);Place(row.Number.rectTransform,rw-90,0,85,30);Place(row.Bar,67,37,rw-73,17);
            }
            LeftContent.sizeDelta=new Vector2(0,counts[0]*rowH);RightContent.sizeDelta=new Vector2(0,counts[1]*rowH);
        }
        public static ZatodBattleStatisticsView Create(Transform parent,TMP_FontAsset font)
        {
            var root=Box(parent,"ZatodBattleStatisticsView");ZatodHeroUi.Stretch(root);root.gameObject.SetActive(false);
            var v=root.gameObject.AddComponent<ZatodBattleStatisticsView>();v.Font=font;
            var dim=ZatodHeroUi.Box(root,"Dim");ZatodHeroUi.Stretch(dim);var shade=dim.gameObject.AddComponent<UnityEngine.UI.Image>();shade.color=new Color(0,0,0,.72f);shade.raycastTarget=true;
            v.Panel=Picture(root,"Panel","common/mail_bj9_1").rectTransform;
            var inside=Picture(v.Panel,"Interior","crusade/bg_statics_main");ZatodHeroUi.Stretch(inside.rectTransform,12);
            v.TitleBar=Picture(root,"TitleBar","crusade/bg_title_statics").rectTransform;
            v.Title=Text(root,"Title","Battle Statistics",font,28);v.Close=Button(root,"Close","common/break_butt_bj");
            var closeIcon=Picture(v.Close.transform,"CloseIcon","common/butt_off",aspect:true);ZatodHeroUi.Stretch(closeIcon.rectTransform,10);
            v.Tabs=Enumerable.Range(0,4).Select(i=>{var b=Button(root,"Tab_"+i,"crusade/btn_statics_tag_bg");b.image.preserveAspect=true;Caption(b,i<2?"Damage\n"+(i==0?"dealt":"taken"):Names[i],font,22);return b;}).ToArray();
            v.LeftTitle=Text(root,"LeftTitle","Your team",font,24);v.RightTitle=Text(root,"RightTitle","Enemies",font,24);
            v.LeftScroll=ZatodHeroUi.Scroll(root,"YourTeamScroll",out v.LeftContent);v.RightScroll=ZatodHeroUi.Scroll(root,"EnemyScroll",out v.RightContent);return v;
        }
    }
}
