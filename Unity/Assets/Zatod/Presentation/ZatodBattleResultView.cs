using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using static Zatod.Presentation.ZatodResultUi;

namespace Zatod.Presentation
{
    public sealed class ZatodBattleResultView : MonoBehaviour
    {
        public TMP_FontAsset Font;
        public RectTransform Panel,Banner,Crest,HeroRow,RewardRow,TeamBar,TeamLabelRect,GoldRect;
        public UnityEngine.UI.Image[] Stars;
        public UnityEngine.UI.Button Continue,StatisticsButton;
        public TextMeshProUGUI TeamLabel,TeamExp,RewardLabel,GoldValue;
        public ZatodBattleStatisticsView StatisticsView;
        public string BattleId {get;private set;}
        public int RewardCount {get;private set;}
        public IReadOnlyList<ZatodUnitStatistics> Report=>report;
        readonly List<ZatodUnitStatistics> report=new List<ZatodUnitStatistics>();
        readonly List<RectTransform> heroRoots=new List<RectTransform>(),rewardRoots=new List<RectTransform>();
        readonly List<TextMeshProUGUI> heroExp=new List<TextMeshProUGUI>();
        readonly List<UnityEngine.UI.Image> heroBars=new List<UnityEngine.UI.Image>();
        readonly List<TextMeshProUGUI> heroLevels=new List<TextMeshProUGUI>();
        EconomyBattleReceipt economy;UnityEngine.UI.Image playerBar;
        readonly List<ReplaySprite> effects=new List<ReplaySprite>();
        Action onContinue;HeroCatalog catalog;ZatodReplay replay;Vector2 size;float opened;
        void Awake()
        {
            Continue.onClick.AddListener(()=>onContinue?.Invoke());
            StatisticsButton.onClick.AddListener(()=>StatisticsView.Open(report,catalog,Font));
        }
        public void Open(ZatodReplay record,ZatodCampaignReward receipt,HeroCatalog definitions,CharacterData account,Action close)
        {
            replay=record;catalog=definitions;onContinue=close;BattleId=record.Initial.BattleId;opened=Time.unscaledTime;
            report.Clear();report.AddRange((record.Statistics??new List<ZatodUnitStatistics>()).Select(s=>s.Copy()));
            Clear(HeroRow);Clear(RewardRow);heroRoots.Clear();heroExp.Clear();rewardRoots.Clear();heroBars.Clear();heroLevels.Clear();
            economy=receipt!=null && receipt.BattleId==BattleId?receipt.Economy:null;
            playerBar=TeamBar.Find("ProgressionFill")?.GetComponent<UnityEngine.UI.Image>();if(playerBar==null)playerBar=MakeExpBar(TeamBar,"team_expbar");
            foreach(var unit in record.Initial.Players.Take(5))
            {
                var hero=account.HeroDesk.FirstOrDefault(h=>h.HeroDefinitionId==unit.DefinitionId);
                var card=ZatodFormationView.CreateCard(HeroRow,"Hero_"+unit.EntityId,108,Font);
                ConfigureCard(card,unit.DefinitionId,unit.Level,hero?.Stars??1,hero==null?1:ZatodHeroUi.Rank(hero,catalog));heroRoots.Add(card.Root);
                var bg=Picture(card.Root,"ExpBackground","battleresult/heroexp_bg");Place(bg.rectTransform,0,114,108,10);heroBars.Add(MakeExpBar(bg.rectTransform,"expbar"));heroLevels.Add(card.Level);
                var exp=Text(card.Root,"Exp","0/0",Font,19);Place(exp.rectTransform,0,128,108,25);exp.alignment=TextAlignmentOptions.Center;heroExp.Add(exp);
            }
            bool settled=receipt!=null && receipt.BattleId==BattleId;
            var items=settled?receipt.Items:new List<ItemData>();RewardCount=items.Count;
            foreach(var group in items.GroupBy(i=>i.ItemId))
            {
                var rect=Box(RewardRow,"Reward_"+group.Key);rewardRoots.Add(rect);
                var item=catalog.Item(group.Key);var icon=ZatodHeroUi.Picture(rect,"Icon","Items/"+group.Key,aspect:true);ZatodHeroUi.Stretch(icon.rectTransform,5);
                string[] ranks={"white","green","blue","purple","purple","orange","red","pink","prismatic"};
                var frame=ZatodHeroUi.Picture(rect,"Quality","equip_frame_"+ranks[Math.Clamp(item.Quality,1,9)-1]);ZatodHeroUi.Stretch(frame.rectTransform);
                var amount=Text(rect,"Amount","×"+group.Count(),Font,24);ZatodHeroUi.Fill(amount.rectTransform,new Vector2(.25f,0),Vector2.one,new Vector2(0,0),new Vector2(-5,-42));amount.alignment=TextAlignmentOptions.BottomRight;
            }
            TeamLabel.text="Squad Level: "+account.Level;TeamExp.text=economy==null?"Replay":"EXP +"+economy.Player.Granted;GoldValue.text=economy==null?"—":economy.Gold.ToString("N0");
            RefreshExperience(0);
            RewardLabel.text=settled?"Rewards:":"Replay";
            for(int i=0;i<Stars.Length;i++)Stars[i].sprite=Art("battleresult/new_resource/"+(i<record.Stars?"star":"star_1"));
            StatisticsView.gameObject.SetActive(false);gameObject.SetActive(true);size=Vector2.zero;Fit();PlayResultEffects(record.Stars);
            var audio=GetComponent<AudioSource>();if(audio==null)audio=gameObject.AddComponent<AudioSource>();var clip=Resources.Load<AudioClip>("Zatod/Audio/battle_win");if(clip!=null)audio.PlayOneShot(clip,.5f);
        }
        void PlayResultEffects(int stars)
        {
            foreach(var effect in effects)if(effect!=null)Destroy(effect.gameObject);effects.Clear();
            if(stars<1)return;
            var rect=Box(transform,"NativeStarAnimation");rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,1);rect.anchoredPosition=new Vector2(0,-((RectTransform)transform).rect.height*.16f);
            var visual=rect.gameObject.AddComponent<ReplaySprite>();visual.Initialize("Zatod/eff_UI_pve_victory_star_"+Math.Clamp(stars,1,3)+"/AnimationSet");effects.Add(visual);rect.SetSiblingIndex(Banner.GetSiblingIndex()+1);
        }
        public void Hide(){StatisticsView.gameObject.SetActive(false);gameObject.SetActive(false);BattleId=null;}
        static void Clear(Transform parent){foreach(Transform child in parent){child.gameObject.SetActive(false);UnityEngine.Object.Destroy(child.gameObject);}}
        void LateUpdate()
        {
            Fit();float elapsed=Time.unscaledTime-opened;RefreshExperience(Mathf.Clamp01(elapsed/1.4f));
            foreach(var effect in effects)if(effect!=null){float duration=effect.ClipDuration("Start");effect.gameObject.SetActive(elapsed<duration);if(elapsed<duration)effect.Sample("Start",elapsed,true,.55f);}
            for(int i=0;i<Stars.Length;i++){float scale=Mathf.Clamp01((elapsed-.10f-i*.12f)*5);Stars[i].transform.localScale=Vector3.one*scale;}
        }
        UnityEngine.UI.Image MakeExpBar(RectTransform parent,string art)
        {
            var image=Picture(parent,"ProgressionFill","battleresult/"+art);ZatodHeroUi.Stretch(image.rectTransform,1);
            image.type=UnityEngine.UI.Image.Type.Filled;image.fillMethod=UnityEngine.UI.Image.FillMethod.Horizontal;image.fillAmount=0;return image;
        }
        void RefreshExperience(float t)
        {
            if(economy==null){if(playerBar!=null)playerBar.fillAmount=0;foreach(var bar in heroBars)bar.fillAmount=0;return;}
            var rules=ProgressionDataJson.LoadBundled();
            void Apply(ExperienceChange change,UnityEngine.UI.Image bar,TextMeshProUGUI label,TextMeshProUGUI levelLabel,bool player)
            {
                if(change==null)return;int level=change.BeforeLevel;long exp=change.BeforeExp+(long)(change.Granted*t);
                Func<int,long> required=lv=>player?rules.PlayerRequired(lv):rules.Hero(lv).NextLevelExp;
                while(level<change.AfterLevel&&required(level)>0&&exp>=required(level)){exp-=required(level);level++;}
                if(t>=1){level=change.AfterLevel;exp=change.AfterExp;}
                long cap=required(level);bar.fillAmount=cap>0?Mathf.Clamp01((float)((double)exp/cap)):1;
                label.text=(player?"EXP +":"+")+change.Granted+(cap>0?"  ("+exp+"/"+cap+")":"  MAX");
                levelLabel.text=player?"Squad Level: "+level:level.ToString();
            }
            Apply(economy.Player,playerBar,TeamExp,TeamLabel,true);
            for(int i=0;i<heroBars.Count&&i<economy.Heroes.Count;i++)Apply(economy.Heroes[i],heroBars[i],heroExp[i],heroLevels[i],false);
        }
        public void Fit()
        {
            var rect=(RectTransform)transform;Vector2 next=rect.rect.size;if(next==size)return;size=next;float w=size.x,h=size.y;if(w<1||h<1)return;
            Place(Panel,w*.045f,h*.245f,w*.91f,h*.655f);
            float bw=Math.Min(w*.60f,1000),bh=bw*190/1056;Place(Banner,(w-bw)/2,h*.09f,bw,bh);Place(Crest,(w-bw*.79f)/2,h*.012f,bw*.79f,bw*.79f*272/815);
            float star=Math.Min(bh*.80f,115),gap=star*.08f;float sw=3*star+2*gap;
            for(int i=0;i<3;i++)Place(Stars[i].rectTransform,(w-sw)/2+i*(star+gap),h*.09f+bh*.02f,star,star);
            Place(TeamLabelRect,w*.28f,h*.32f,w*.45f,h*.045f);Place(TeamBar,w*.28f,h*.375f,w*.43f,h*.025f);Place(TeamExp.rectTransform,w*.72f,h*.36f,w*.18f,h*.05f);
            float card=Math.Min(h*.155f,w*.105f),spacing=card*.16f,total=heroRoots.Count*card+Math.Max(0,heroRoots.Count-1)*spacing;
            Place(HeroRow,(w-total)/2,h*.445f,total,card*1.5f);
            for(int i=0;i<heroRoots.Count;i++){Place(heroRoots[i],i*(card+spacing),0,108,108);heroRoots[i].localScale=Vector3.one*(card/108);}
            Place(RewardLabel.rectTransform,w*.08f,h*.755f,w*.12f,h*.06f);Place(RewardRow,w*.20f,h*.71f,w*.53f,h*.15f);
            float rewardSize=Math.Min(h*.13f,w*.082f),rewardGap=rewardSize*.12f;Place(GoldRect,w*.20f,h*.71f,rewardSize,rewardSize);
            for(int i=0;i<rewardRoots.Count;i++)Place(rewardRoots[i],(i+1)*(rewardSize+rewardGap),0,rewardSize,rewardSize);
            Place(Continue.GetComponent<RectTransform>(),w*.78f,h*.77f,w*.17f,h*.09f);Place(StatisticsButton.GetComponent<RectTransform>(),w*.85f,h*.15f,h*.085f,h*.085f);
        }
        public static ZatodBattleResultView Create(Transform parent,TMP_FontAsset font)
        {
            var root=Box(parent,"ZatodBattleResultView");ZatodHeroUi.Stretch(root);root.gameObject.SetActive(false);
            var v=root.gameObject.AddComponent<ZatodBattleResultView>();v.Font=font;
            var dim=ZatodHeroUi.Box(root,"Dim");ZatodHeroUi.Stretch(dim);var shade=dim.gameObject.AddComponent<UnityEngine.UI.Image>();shade.color=new Color(0,0,0,.57f);shade.raycastTarget=true;dim.offsetMin=Vector2.one*-2048;dim.offsetMax=Vector2.one*2048;
            v.Panel=Picture(root,"RewardPanel","battleresult/victory_bg").rectTransform;
            v.Crest=Picture(root,"Crest","battleresult/new_resource/victory_bg_1",aspect:true).rectTransform;
            v.Banner=Picture(root,"Banner","battleresult/new_resource/victory_bg",aspect:true).rectTransform;
            v.Stars=Enumerable.Range(0,3).Select(i=>Picture(root,"Star_"+(i+1),"battleresult/new_resource/star",aspect:true)).ToArray();
            v.TeamLabel=Text(root,"TeamLevel","Squad Level",font,27);v.TeamLabelRect=v.TeamLabel.rectTransform;
            v.TeamBar=Picture(root,"TeamExpBackground","battleresult/progressbar_bg").rectTransform;v.TeamExp=Text(root,"TeamExp","EXP 0/0",font,25);v.TeamExp.color=new Color(.45f,1,.18f);
            v.HeroRow=Box(root,"Heroes");v.RewardLabel=Text(root,"RewardsLabel","Rewards:",font,25);v.RewardLabel.color=new Color(1,.7f,.2f);
            v.RewardRow=Box(root,"Rewards");v.GoldRect=Box(root,"Gold");
            var gold=ZatodHeroUi.Picture(v.GoldRect,"GoldIcon","goldicon",aspect:true);ZatodHeroUi.Stretch(gold.rectTransform,9);
            v.GoldValue=Text(v.GoldRect,"GoldAmount","?",font,26);ZatodHeroUi.Stretch(v.GoldValue.rectTransform,3);v.GoldValue.alignment=TextAlignmentOptions.BottomRight;
            v.Continue=Button(root,"Continue","common/button_com_big");Caption(v.Continue,"Continue",font,26);
            v.StatisticsButton=Button(root,"Statistics","common/break_butt_bj");
            var statsIcon=Picture(v.StatisticsButton.transform,"StatisticsIcon","crusade/btn_statics",aspect:true);ZatodHeroUi.Stretch(statsIcon.rectTransform,8);
            v.StatisticsView=ZatodBattleStatisticsView.Create(root,font);
            return v;
        }
    }
}
