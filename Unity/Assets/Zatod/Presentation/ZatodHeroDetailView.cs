using System;
using System.Linq;
using System.Globalization;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;
using static Zatod.Presentation.ZatodHeroUi;

namespace Zatod.Presentation
{
    public sealed class ZatodHeroDetailView : MonoBehaviour
    {
        public TMP_FontAsset Font;
        public RectTransform Tabs,Body,ArtPanel,CenterPanel,InfoPanel,EquipmentLayer,StatsContent,CurrencyRow;
        public UnityEngine.UI.Image Illustration,RankFrame;
        public TextMeshProUGUI HeroName,ArtName,Level,Exp,Shards,Power;
        public UnityEngine.UI.Button Close,QuickEquip,LevelUp,StarUp;
        public UnityEngine.UI.Button[] TabButtons;
        public UnityEngine.UI.Image[] Stars;
        public ScrollRect StatsScroll;
        public Action<string,string> OnEquipment;
        public string HeroId{get;private set;}
        public HeroStatResult DisplayedStats{get;private set;}
        HeroCatalog catalog;CharacterData account;HeroData hero;Action close;Vector2 size;
        RectTransform idleRoot;ReplaySprite idle;float opened;Vector2 idleNativeSize=new Vector2(250,300);
        void Awake(){Close.onClick.AddListener(()=>close?.Invoke());}
        public void Open(HeroCatalog definitions,CharacterData owned,string id,Action onClose)
        {
            catalog=definitions;close=onClose;HeroId=id;account=owned;RefreshCurrencies(CurrencyRow,owned);hero=owned.HeroDesk.Single(h=>h.HeroInstanceId==id);
            gameObject.SetActive(true);Refresh(owned);opened=Time.unscaledTime;
            if(idleRoot!=null){idleRoot.gameObject.SetActive(false);Destroy(idleRoot.gameObject);}
            idleRoot=Box(CenterPanel,"HeroIdle");idle=idleRoot.gameObject.AddComponent<ReplaySprite>();idle.Initialize(catalog.Hero(hero.HeroDefinitionId).AnimationSetResource);
            var set=JsonUtility.FromJson<Zatod.Animation.HeroAnimationSetData>(Resources.Load<TextAsset>(catalog.Hero(hero.HeroDefinitionId).AnimationSetResource).text);
            var clip=set.Clips.First(c=>c.State=="Idle");if(clip.ContentBounds!=null && clip.ContentBounds.Count>0)idleNativeSize=new Vector2(clip.ContentBounds.Max(b=>b.Width),clip.ContentBounds.Max(b=>b.Height))*(100f/set.PixelsPerUnit);
            size=Vector2.zero;Fit();
        }
        public void Refresh(CharacterData owned)
        {
            account=owned;RefreshCurrencies(CurrencyRow,owned);hero=owned.HeroDesk.SingleOrDefault(h=>h.HeroInstanceId==HeroId);if(hero==null){close?.Invoke();return;}
            var definition=catalog.Hero(hero.HeroDefinitionId);var rank=HeroProgression.CurrentRank(hero,catalog);
            HeroName.text=definition.Name+" · "+rank.Name;ArtName.text=definition.Name;Level.text="Level "+hero.Level;Exp.text=hero.Exp+" / "+ProgressionDataJson.LoadBundled().Hero(hero.Level).NextLevelExp;var starRule=hero.Stars>=catalog.Data.MaxHeroStars?null:catalog.Data.StarRules.FirstOrDefault(r=>r.Stars==hero.Stars+1);Shards.text=starRule==null?"Max stars":owned.Inventory.Count(i=>i.ItemId==definition.SoulstoneItemId)+" / "+starRule.UpgradeStones;Power.text="Power: ??";
            var rail=InfoPanel.Find("ExpRail");var fill=rail.Find("ProgressionFill")?.GetComponent<UnityEngine.UI.Image>();
            if(fill==null){fill=Picture(rail,"ProgressionFill","hero_exp_progress");Stretch(fill.rectTransform,2);fill.type=UnityEngine.UI.Image.Type.Filled;fill.fillMethod=UnityEngine.UI.Image.FillMethod.Horizontal;}
            long required=ProgressionDataJson.LoadBundled().Hero(hero.Level).NextLevelExp;fill.fillAmount=required>0?Mathf.Clamp01((float)((double)hero.Exp/required)):1;
            Illustration.sprite=Art("Illustrations/"+definition.Id);RankFrame.sprite=Art("hero_rank_"+Rank(hero,catalog));
            for(int n=0;n<Stars.Length;n++)Stars[n].sprite=Art(n<hero.Stars?"hero_star_1":"hero_star_bg");
            foreach(Transform child in EquipmentLayer){child.gameObject.SetActive(false);Destroy(child.gameObject);}
            int i=0;foreach(var slot in rank.EquipmentSlots.Take(6)){Equipment(EquipmentLayer,hero,slot,account,catalog,i<3?0:420,90+(i%3)*142,98,()=>OnEquipment?.Invoke(hero.HeroInstanceId,slot.Id));i++;}
            foreach(Transform child in StatsContent){child.gameObject.SetActive(false);Destroy(child.gameObject);}
            DisplayedStats=HeroStatCalculator.Calculate(hero,catalog);int index=0;
            foreach(var stat in catalog.Data.Stats)
            {
                double value=DisplayedStats.PreciseStats.FirstOrDefault(s=>s.StatId==stat.Id)?.Value??DisplayedStats.Get(stat.Id);
                var row=Picture(StatsContent,"Stat_"+stat.Id,"hero_info_bg_3",0,index*49,440,48);row.color=index%2==0?new Color(1,1,1,.5f):new Color(1,1,1,.25f);
                var label=Text(row.transform,"Name",StatName(stat.Id),Font,21);Fill(label.rectTransform,Vector2.zero,Vector2.one,new Vector2(12,0),new Vector2(-115,0));
                var number=Text(row.transform,"Value",StatValue(stat.Id,value),Font,22);Fill(number.rectTransform,new Vector2(1,0),Vector2.one,new Vector2(-110,0),new Vector2(-12,0));number.alignment=TextAlignmentOptions.MidlineRight;
                index++;
            }
            StatsContent.sizeDelta=new Vector2(0,index*49);size=Vector2.zero;Fit();
        }
        public static string StatName(string id)
        {
            switch(id)
            {
                case "health":return "Max HP";case "damage":return "Physical ATK";case "ability_power":return "Magic Intensity";
                case "defense":return "Physical Armor";case "magic_resistance":return "Magic Resist";case "action_speed":return "Action Speed (MSPD)";
                case "haste":return "Cooldown Haste (HAST)";case "attack_interval":return "Attack Interval (s)";case "move_speed":return "Move Speed";
                case "attack_range":return "Attack Range";case "energy_max":return "Max Energy";case "wave_health_regen":return "HP Regen / Wave";case "wave_energy_regen":return "Energy / Wave";
                case "damage_energy_rate":return "Damage Energy Rate";case "interrupt_health_ratio":return "Interrupt HP Ratio";
                default:return CultureInfo.InvariantCulture.TextInfo.ToTitleCase(id.Replace('_',' '));
            }
        }
        static string StatValue(string id,double value)=>((id=="attack_interval"?value/20d:value)).ToString("0.##",CultureInfo.InvariantCulture);
        void LateUpdate()
        {
            Fit();if(idle==null)return;
            // Uses the same baked combat sprite keys and authored pivot as the battle presentation.
            float fit=Mathf.Min(CenterPanel.rect.height*.44f/Mathf.Max(1,idleNativeSize.y),CenterPanel.rect.width*.48f/Mathf.Max(1,idleNativeSize.x));
            idle.Sample("Idle",Time.unscaledTime-opened,true,fit);
        }
        public void Fit()
        {
            Vector2 now=((RectTransform)transform).rect.size;if(size==now)return;size=now;
            Place(Tabs,32,18,810,70);Place(CurrencyRow,size.x-714,18,690,54);
            float top=size.x<1500?150:98;if(size.x<1500)Place(CurrencyRow,size.x-714,88,690,54);
            Place(Body,24,top,size.x-48,size.y-top-24);
            Fill(ArtPanel,Vector2.zero,new Vector2(.265f,1),new Vector2(12,12),new Vector2(-4,-12));
            Fill(CenterPanel,new Vector2(.265f,0),new Vector2(.715f,1),new Vector2(4,12),new Vector2(-4,-12));
            Fill(InfoPanel,new Vector2(.715f,0),Vector2.one,new Vector2(4,12),new Vector2(-12,-12));
            float cw=CenterPanel.rect.width,ch=CenterPanel.rect.height;float fit=Mathf.Min(cw/558f,ch/700f);
            Place(EquipmentLayer,(cw-518*fit)/2,60,518,550);EquipmentLayer.localScale=Vector3.one*fit;
            Place(RankFrame.rectTransform,20,12,cw-40,64);Place(HeroName.rectTransform,24,14,cw-48,60);
            Place((RectTransform)QuickEquip.transform,cw*.28f,ch-148,cw*.44f,58);Place(Power.rectTransform,20,ch-77,cw-40,54);
            if(idleRoot!=null){idleRoot.anchorMin=idleRoot.anchorMax=new Vector2(.5f,0);idleRoot.anchoredPosition=new Vector2(0,Mathf.Max(150,ch*.3f));}
            float iw=InfoPanel.rect.width;var children=InfoPanel.Cast<Transform>().ToArray();
            Place(Level.rectTransform,22,15,iw-40,48);
            Place(Exp.rectTransform,48,80,Mathf.Max(85,iw-190),34);Place(Shards.rectTransform,48,132,Mathf.Max(85,iw-190),34);
            Place((RectTransform)LevelUp.transform,iw-125,77,115,42);Place((RectTransform)StarUp.transform,iw-125,129,115,42);
            var expbg=(RectTransform)InfoPanel.Find("ExpRail");Place(expbg,48,82,Mathf.Max(85,iw-190),32);expbg.SetSiblingIndex(1);
            var shardbg=(RectTransform)InfoPanel.Find("ShardRail");Place(shardbg,48,132,Mathf.Max(85,iw-190),34);shardbg.SetSiblingIndex(2);
            for(int n=0;n<5;n++)Place(Stars[n].rectTransform,(iw-235)/2+n*47,193,43,44);
            var title=(RectTransform)InfoPanel.Find("StatsHeading");Place(title,18,255,iw-36,45);
            Fill((RectTransform)StatsScroll.transform,Vector2.zero,Vector2.one,new Vector2(8,15),new Vector2(-8,-310));
            foreach(RectTransform row in StatsContent){row.anchorMin=Vector2.up;row.anchorMax=Vector2.one;row.sizeDelta=new Vector2(0,48);}
            Place((RectTransform)Close.transform,size.x-80,top-22,60,60);
        }
        public static ZatodHeroDetailView Create(Transform parent,TMP_FontAsset font)
        {
            var root=Box(parent,"ZatodHeroDetailView");Stretch(root);var v=root.gameObject.AddComponent<ZatodHeroDetailView>();v.Font=font;
            var backdrop=Picture(root,"Backdrop","formation_forest",hit:true);Stretch(backdrop.rectTransform);backdrop.gameObject.AddComponent<ZatodFullScreenArt>();
            v.Tabs=Box(root,"Tabs");string[] names={"Base","Skill","Astrolabe","Skin"},icons={"icon_hero","icon_skill","icon_accessory","icon_skin"};v.TabButtons=new UnityEngine.UI.Button[4];
            for(int n=0;n<4;n++){var b=Button(v.Tabs,names[n],n==0?"hero_tab_choose":"hero_tab_unchoose");Place((RectTransform)b.transform,n*195,0,190,68);Picture(b.transform,"Icon",icons[n],12,9,42,46,aspect:true);var t=Text(b.transform,"Caption",names[n],font,26);Place(t.rectTransform,58,8,123,48);v.TabButtons[n]=b;}
            v.CurrencyRow=Currencies(root,font);v.Body=Picture(root,"Frame","frame_common1").rectTransform;
            var shade=Picture(v.Body,"PanelFill","battle_prepare_9bg_2");Stretch(shade.rectTransform,12);
            v.ArtPanel=Picture(v.Body,"HeroIllustrationFrame","frame_common1").rectTransform;
            v.Illustration=Picture(v.ArtPanel,"Illustration","Illustrations/lina",aspect:true);Stretch(v.Illustration.rectTransform,10);
            v.ArtName=Text(v.ArtPanel,"ArtName","Hero",font,26);Fill(v.ArtName.rectTransform,Vector2.zero,Vector2.right,new Vector2(16,12),new Vector2(-16,68));v.ArtName.alignment=TextAlignmentOptions.Center;
            v.CenterPanel=Picture(v.Body,"HeroBase","hero_bg_mid_1").rectTransform;
            var floor=Picture(v.CenterPanel,"Floor","hero_bg_mid_2",aspect:true);Fill(floor.rectTransform,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);
            v.EquipmentLayer=Box(v.CenterPanel,"Equipment");v.RankFrame=Picture(v.CenterPanel,"Rank","hero_rank_1");v.HeroName=Text(v.CenterPanel,"NameAndRank","Hero",font,26);v.HeroName.alignment=TextAlignmentOptions.Center;
            v.QuickEquip=Button(v.CenterPanel,"QuickEquip","buttion_big");Caption(v.QuickEquip,"Quick Equip",font,25);
            var powerbg=Picture(v.CenterPanel,"PowerBackground","hero_gs_bg");Fill(powerbg.rectTransform,new Vector2(0,0),new Vector2(1,0),new Vector2(18,20),new Vector2(-18,80));
            v.Power=Text(v.CenterPanel,"Power","Power: ??",font,27);v.Power.alignment=TextAlignmentOptions.Center;
            v.InfoPanel=Picture(v.Body,"HeroInformation","hero_info_bg_0").rectTransform;
            v.Level=Text(v.InfoPanel,"Level","Level",font,29);Picture(v.InfoPanel,"ExpRail","hero_exp_progress_bg");Picture(v.InfoPanel,"ShardRail","hero_soulstone_progress_bg");
            Picture(v.InfoPanel,"ExpIcon","hero_exp_icon",12,81,32,30,aspect:true);Picture(v.InfoPanel,"ShardIcon","icon_stone",12,130,32,36,aspect:true);
            v.Exp=Text(v.InfoPanel,"Exp","0 / ??",font,22);v.Shards=Text(v.InfoPanel,"Shards","?? / ??",font,22);v.Exp.alignment=v.Shards.alignment=TextAlignmentOptions.Center;
            v.LevelUp=Button(v.InfoPanel,"LevelUp","buttion_big");Caption(v.LevelUp,"Lvl Up",font,21);v.StarUp=Button(v.InfoPanel,"StarUp","buttion_big");Caption(v.StarUp,"Star Up",font,21);
            v.Stars=new UnityEngine.UI.Image[5];for(int n=0;n<5;n++)v.Stars[n]=Picture(v.InfoPanel,"Star_"+n,"hero_star_bg",aspect:true);
            Text(v.InfoPanel,"StatsHeading","Hero Stats",font,26);v.StatsScroll=Scroll(v.InfoPanel,"StatsScroll",out v.StatsContent);
            v.Close=Button(root,"Close","break_butt_bj",()=>v.close?.Invoke());Picture(v.Close.transform,"X","butt_off",12,12,36,36,aspect:true);
            return v;
        }
    }
}
