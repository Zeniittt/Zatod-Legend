using System;
using System.Linq;
using TMPro;
using UnityEngine;
using Zatod.Heroes;
using static Zatod.Presentation.ZatodStageUi;
namespace Zatod.Presentation
{
    public sealed class ZatodStagePreviewView : MonoBehaviour
    {
        public RectTransform Layout,DropRow;
        public TextMeshProUGUI Title,Description,Cost,DailyAttempts,RaidVoucher,Notice;
        public UnityEngine.UI.Button Close,Challenge,Raid,RaidMany,Tutorial;
        public UnityEngine.UI.Image[] Stars;
        public UnityEngine.UI.Image StarBackground;
        public ZatodFormationCard[] Enemies;
        public GameObject[] BossBadges;
        public string StageId {get;private set;}
        public int StarCount {get;private set;}
        Action close,challenge;
        Vector2 lastSize;
        void Awake(){Close.onClick.AddListener(()=>close?.Invoke());Challenge.onClick.AddListener(()=>challenge?.Invoke());}
        void LateUpdate(){Fit();}
        public void Fit()
        {
            var size=((RectTransform)transform).rect.size;if(size==lastSize)return;lastSize=size;
            Layout.localScale=Vector3.one*Mathf.Min(size.x/1600,size.y/900);
        }
        public void Open(CampaignStageDefinition stage,HeroCatalog catalog,int stars,bool connected,Action onClose,Action onChallenge,bool unlocked=true)
        {
            StageId=stage.Id;close=onClose;challenge=onChallenge;Title.text=stage.Name;Description.text=stage.Description??"";
            Cost.text=stage.VitalityCost.ToString();DailyAttempts.text="Daily Attempts: ?";RaidVoucher.text="Raid Voucher: ?";
            var enemies=stage.Waves.Last().Enemies.OrderBy(e=>e.Boss).ToArray();
            for(int i=0;i<Enemies.Length;i++)
            {
                bool show=i<enemies.Length;Enemies[i].Root.gameObject.SetActive(show);BossBadges[i].SetActive(show && enemies[i].Boss);
                if(show){ZatodFormationView.DrawEnemyCard(Enemies[i],enemies[i],catalog);Enemies[i].InstanceId=enemies[i].Id;}
            }
            DrawDrops(DropRow,stage,catalog,80,22,7);Refresh(stars,connected,unlocked);
            gameObject.SetActive(true);transform.SetAsLastSibling();lastSize=Vector2.zero;Fit();
        }
        public void Refresh(int stars,bool connected,bool unlocked=true)
        {
            StarCount=Math.Clamp(stars,0,3);Challenge.interactable=connected && unlocked;Notice.text=!connected?"Disconnected":unlocked?"":"Clear the previous stage first";
            StarBackground.sprite=Art(StarCount==0?"campaign_detail_star_unlock_bg":"campaign_detail_star_lock_bg");
            for(int i=0;i<Stars.Length;i++)Stars[i].sprite=Art("campaign_stage_star_"+(i<StarCount?1:StarCount==0?2:3));
            string raidArt=StarCount==3?"button_com_big":"button_grey";
            Raid.image.sprite=RaidMany.image.sprite=Art(raidArt);
            Raid.interactable=RaidMany.interactable=StarCount==3;
            Raid.transition=RaidMany.transition=UnityEngine.UI.Selectable.Transition.None;
            // Deliberately no raid/tutorial listeners: these controls only preview their UI state.
        }
        public static ZatodStagePreviewView Create(Transform parent,TMP_FontAsset font)
        {
            var rect=Box(parent,"ZatodStagePreviewView",0,0,1600,900);rect.anchorMin=Vector2.zero;rect.anchorMax=Vector2.one;rect.offsetMin=rect.offsetMax=Vector2.zero;
            var view=rect.gameObject.AddComponent<ZatodStagePreviewView>();
            var shade=Image(rect,"campaign_detail_bg",true);shade.sprite=null;shade.color=new Color(0,0,0,.6f);
            var design=Box(rect,"Layout",0,0,1600,900);design.anchorMin=design.anchorMax=design.pivot=new Vector2(.5f,.5f);design.anchoredPosition=Vector2.zero;view.Layout=design;
            Image(Box(design,"Panel",300,125,1000,650),"battle_prepare_9bg_1",true);
            Image(Box(design,"Fill",306,131,988,638),"campaign_detail_in_bg");
            Image(Box(design,"Frame",300,125,1000,650),"frame_common1");
            Image(Box(design,"TitleBanner",250,97,1100,90),"campaign_detail_hard_title");
            view.Title=Text(design,"StageName","",490,110,620,55,34,font);view.Title.alignment=TextAlignmentOptions.Center;
            view.Close=Button(design,"Close","break_butt_bj",1265,115,53,53);Image(Box(view.Close.transform,"Cross",11,11,31,31),"butt_off");
            view.StarBackground=Image(Box(design,"StarBackground",525,171,550,70),"campaign_detail_star_unlock_bg");
            view.Stars=new UnityEngine.UI.Image[3];for(int i=0;i<3;i++)view.Stars[i]=Image(Box(design,"StageStar_"+i,713+i*59,177,55,55),"campaign_stage_star_2");
            view.Tutorial=Button(design,"Tutorial","enter_bg",1095,177,150,44);Image(Box(view.Tutorial.transform,"Icon",12,6,30,32),"icon");Text(view.Tutorial.transform,"Caption","Tutorial",47,3,98,38,21,font);
            view.Description=Text(design,"Description","",330,245,940,80,21,font);view.Description.alignment=TextAlignmentOptions.TopLeft;view.Description.textWrappingMode=TextWrappingModes.Normal;
            Text(design,"CostLabel","Cost:",330,335,130,36,22,font).color=new Color(1,.68f,.22f);view.Cost=Text(design,"Cost","",455,335,50,36,23,font);Image(Box(design,"Vitality",503,333,32,37),"vitality");
            Text(design,"EnemyLabel","Enemies:",330,424,150,38,22,font).color=new Color(1,.68f,.22f);
            view.Enemies=new ZatodFormationCard[5];view.BossBadges=new GameObject[5];
            for(int i=0;i<5;i++)
            {
                var card=ZatodFormationView.CreateCard(design,"Enemy_"+i,86,font);card.Root.anchoredPosition=new Vector2(500+i*105,-395);view.Enemies[i]=card;
                view.BossBadges[i]=Image(Box(card.Root,"Boss",33,-18,83,45),"campaign_detail_boss").gameObject;
                card.Button.interactable=false;card.Button.transition=UnityEngine.UI.Selectable.Transition.None;
            }
            Text(design,"RewardLabel","Reward",330,537,150,38,22,font).color=new Color(1,.68f,.22f);view.DropRow=Box(design,"DropItems",500,510,770,85);
            Image(Box(design,"Divider",325,627,950,3),"campaign_detail_line_1");
            view.RaidVoucher=Text(design,"RaidVoucher","Raid Voucher: ?",340,640,245,35,22,font);Image(Box(design,"RaidTicket",585,641,30,32),"raidticke");
            view.DailyAttempts=Text(design,"DailyAttempts","Daily Attempts: ?",1020,640,250,35,21,font);view.DailyAttempts.alignment=TextAlignmentOptions.MidlineRight;
            view.RaidMany=Button(design,"RaidMany","button_grey",340,688,170,61);Text(view.RaidMany.transform,"Caption","Raid x3",0,0,170,61,25,font).alignment=TextAlignmentOptions.Center;
            view.Raid=Button(design,"Raid","button_grey",530,688,170,61);Text(view.Raid.transform,"Caption","Raid",0,0,170,61,25,font).alignment=TextAlignmentOptions.Center;
            view.Challenge=Button(design,"Challenge","buttion_big",1000,683,270,70);Image(Box(view.Challenge.transform,"Swords",29,15,44,44),"battle_prepare_butt_fit_img");Text(view.Challenge.transform,"Caption","Challenge",85,10,175,50,27,font);
            view.Notice=Text(design,"Notice","",730,704,250,35,19,font);
            return view;
        }
    }
}
