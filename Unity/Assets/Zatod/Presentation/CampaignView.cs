using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;

namespace Zatod.Presentation
{
    [DefaultExecutionOrder(60)]
    [RequireComponent(typeof(FormationView))]
    public sealed class CampaignView : MonoBehaviour
    {
        public bool ManualUltimates = true;
        public CampaignCatalog Catalog{get;private set;}
        public CharacterData Character{get;private set;}
        public string SelectedStageId{get;private set;}
        public bool IsVisible=>canvas!=null && canvas.activeSelf;
        public bool PreviewVisible=>preview!=null && preview.activeSelf;
        public bool ResultVisible=>resultPanel!=null && resultPanel.activeSelf;
        public int ClearedCount=>Character?.MainCampaignProgress.ClearedStageIds.Count??0;
        ArenaConnection connection;FormationView formation;ArenaView arena;HeroCatalog heroes;CharacterData regularCharacter;
        GameObject canvas,mapPanel,preview,resultPanel,loading;RectTransform root,enemyCards;
        HeroUi ui;TextMeshProUGUI progress,status,stageTitle,description,resultTitle,resultSubtitle,loadingText;
        UnityEngine.UI.Button selectButton,nextButton,connectButton;
        readonly Dictionary<string,CampaignNodeGraphic> nodes=new Dictionary<string,CampaignNodeGraphic>();
        string pendingId,pendingStage,resultBattleId;string[] pendingHeroes;bool waiting,sent,activeBattle;
        void Start()
        {
            connection=GetComponent<ArenaConnection>();
            if(connection.IsServer || HasArg("--arena-smoke") || HasArg("--campaign-smoke")){enabled=false;return;}
            formation=GetComponent<FormationView>();arena=GetComponent<ArenaView>();heroes=formation.Selection.Catalog;regularCharacter=formation.Selection.Character;
            Catalog=CampaignDataJson.Load(heroes);Character=Catalog.CreateDemoCharacter(heroes);
            ui=new HeroUi(formation.Font);Build();InstallNavigation();
            connection.CampaignProgressChanged+=RefreshProgress;connection.StatusChanged+=ConnectionChanged;connection.ReplayReceived+=Received;
            Show();
        }
        static bool HasArg(string value)=>Array.IndexOf(Environment.GetCommandLineArgs(),value)>=0;
        void Build()
        {
            canvas=ui.Canvas("CampaignCanvas",30,out root);
            mapPanel=HeroUi.Rect(root,"CampaignMap",0,0,1600,900).gameObject;
            ui.Frame(mapPanel.transform,"CampaignHeader",20,20,1560,98,HeroUi.Hex("332B22"),HeroUi.Gold);
            var back=ui.Button(mapPanel.transform,"CampaignBack",36,35,70,65,ExitToHeroes);ui.Glyph(back.transform,"Back",10,8,50,50,6,HeroUi.Gold);
            ui.Label(mapPanel.transform,"ChapterTitle",Catalog.Data.Chapters[0].Name,130,38,960,56,30,HeroUi.Gold,bold:true);
            connectButton=ui.Button(mapPanel.transform,"CampaignConnect",1260,42,280,50,()=>connection.Connect());
            ui.Label(connectButton.transform,"Title","KẾT NỐI",8,6,264,38,19,HeroUi.Text,TextAlignmentOptions.Center,true);
            var map=HeroUi.Rect(mapPanel.transform,"ChapterMap",60,146,1480,608).gameObject.AddComponent<CampaignMapGraphic>();map.raycastTarget=false;
            var stages=Catalog.Data.Chapters[0].Stages;map.Points=stages.Select(s=>new Vector2(s.MapX,s.MapY)).ToArray();
            for(int i=0;i<stages.Count;i++)
            {
                var stage=stages[i];string id=stage.Id;float x=60+stage.MapX*1480,y=146+stage.MapY*608;
                var node=HeroUi.Rect(mapPanel.transform,"CampaignStage-"+id,x-70,y-65,140,130).gameObject.AddComponent<CampaignNodeGraphic>();
                var button=node.gameObject.AddComponent<UnityEngine.UI.Button>();button.targetGraphic=node;button.onClick.AddListener(()=>SelectStage(id));nodes.Add(id,node);
                ui.Label(mapPanel.transform,"StageNumber-"+id,"1-"+(i+1),x-70,y+48,140,28,20,HeroUi.Hex("322719"),TextAlignmentOptions.Center,true);
                ui.Label(mapPanel.transform,"StageName-"+id,stage.Name,x-150,y+78,300,30,18,HeroUi.Hex("423522"),TextAlignmentOptions.Center,true);
            }
            ui.Frame(mapPanel.transform,"CampaignFooter",60,790,1480,82,HeroUi.Hex("332B22"),HeroUi.Gold);
            progress=ui.Label(mapPanel.transform,"CampaignProgress","",84,804,520,50,23,HeroUi.Gold,bold:true);
            status=ui.Label(mapPanel.transform,"CampaignStatus","",624,808,880,44,15,HeroUi.Text,TextAlignmentOptions.Right);
            preview=Overlay("StagePreview");var p=ui.Frame(preview.transform,"PreviewPanel",260,130,1080,630,HeroUi.Hex("252B2C"),HeroUi.Gold);
            stageTitle=ui.Label(p.transform,"StageTitle","",40,22,900,52,30,HeroUi.Gold,bold:true);
            Close(p.transform,"StagePreviewClose",986,20,()=>preview.SetActive(false));
            description=ui.Label(p.transform,"StageDescription","",40,92,1000,70,19,HeroUi.Text);description.textWrappingMode=TextWrappingModes.Normal;
            ui.Label(p.transform,"EnemyHeading","ĐỘI HÌNH ĐỊCH · 5 MONSTER",40,188,1000,40,21,HeroUi.Gold,bold:true);
            enemyCards=HeroUi.Rect(p.transform,"EnemyPreview",40,242,1000,174);
            selectButton=ui.Button(p.transform,"CampaignChooseSquad",570,510,464,76,ShowFormation,HeroUi.Hex("96652E"));
            ui.Label(selectButton.transform,"Title","CHỌN ĐỘI HÌNH",8,9,448,58,25,HeroUi.Gold,TextAlignmentOptions.Center,true);
            ui.Label(p.transform,"PreviewHint","Chọn từ 1 đến 5 Hero để vào trận.",40,520,500,50,17,HeroUi.Muted);
            resultPanel=Overlay("CampaignResult");var result=ui.Frame(resultPanel.transform,"ResultPanel",360,220,880,460,HeroUi.Panel,HeroUi.Gold);
            resultTitle=ui.Label(result.transform,"ResultTitle","",30,36,820,70,38,HeroUi.Gold,TextAlignmentOptions.Center,true);
            resultSubtitle=ui.Label(result.transform,"ResultSubtitle","",40,122,800,74,22,HeroUi.Text,TextAlignmentOptions.Center);resultSubtitle.textWrappingMode=TextWrappingModes.Normal;
            ButtonText(result.transform,"ResultMap","BẢN ĐỒ",40,328,240,72,Show);
            ButtonText(result.transform,"ResultReplay","XEM LẠI",316,328,240,72,()=>{resultPanel.SetActive(false);canvas.SetActive(false);resultBattleId=null;arena.Seek(0);if(!arena.Playing)arena.TogglePlayback();});
            nextButton=ButtonText(result.transform,"ResultNext","ẢI TIẾP THEO",592,328,248,72,NextStage);
            loading=Overlay("CampaignLoading");var load=ui.Frame(loading.transform,"LoadingPanel",400,310,800,260,HeroUi.Panel,HeroUi.Gold);
            loadingText=ui.Label(load.transform,"LoadingText","ĐANG CHUẨN BỊ TRẬN...",30,40,740,80,24,HeroUi.Text,TextAlignmentOptions.Center);loadingText.textWrappingMode=TextWrappingModes.Normal;
            ButtonText(load.transform,"LoadingBack","QUAY LẠI BẢN ĐỒ",190,164,420,60,()=>{waiting=false;Show();});
            preview.SetActive(false);resultPanel.SetActive(false);loading.SetActive(false);
        }
        GameObject Overlay(string name)
        {var go=HeroUi.Rect(root,name,0,0,1600,900).gameObject;var dim=go.AddComponent<UnityEngine.UI.Image>();dim.color=new Color(0,0,0,.7f);return go;}
        void Close(Transform parent,string name,float x,float y,Action action)=>ButtonText(parent,name,"X",x,y,56,48,action);
        UnityEngine.UI.Button ButtonText(Transform parent,string name,string title,float x,float y,float w,float h,Action action)
        {var button=ui.Button(parent,name,x,y,w,h,action);ui.Label(button.transform,"Title",title,5,5,w-10,h-10,19,HeroUi.Text,TextAlignmentOptions.Center,true);return button;}
        void InstallNavigation()
        {
            var roster=UnityEngine.Object.FindObjectsByType<Canvas>(FindObjectsInactive.Include).First(c=>c.name=="HeroRosterCanvas");
            ButtonText(roster.transform.GetChild(0),"OpenCampaign","CAMPAIGN",40,858,250,38,Show);
            ButtonText(arena.ViewRoot,"BattleCampaignBack","BẢN ĐỒ",550,28,180,40,Show);
        }
        public void Show()
        {
            if(canvas==null)return;waiting=false;activeBattle=false;formation.Hide();GetComponent<HeroRosterView>().Hide();arena.SetVisible(false);
            canvas.SetActive(true);mapPanel.SetActive(true);preview.SetActive(false);resultPanel.SetActive(false);loading.SetActive(false);RefreshProgress();ConnectionChanged();
        }
        public void Hide()
        {waiting=false;activeBattle=false;if(canvas!=null)canvas.SetActive(false);}
        public void SelectStage(string id)
        {
            var stage=Catalog.Stage(id);SelectedStageId=id;stageTitle.text=stage.Name;description.text=stage.Description;
            HeroUi.Clear(enemyCards);
            for(int i=0;i<stage.Monsters.Count;i++)
            {
                var monster=heroes.Monster(stage.Monsters[i].MonsterId);var frame=ui.Frame(enemyCards,"Enemy-"+i,16+i*198,0,174,170,HeroUi.Deep,HeroUi.Gold);
                var image=HeroUi.Rect(frame.transform,"MonsterPortrait",12,10,150,115).gameObject.AddComponent<UnityEngine.UI.Image>();
                image.sprite=Resources.Load<Sprite>("MonsterPortraits/"+monster.PortraitKey);image.preserveAspect=true;image.raycastTarget=false;
                ui.Label(frame.transform,"MonsterName",monster.Name,4,132,166,28,15,HeroUi.Text,TextAlignmentOptions.Center,true);
            }
            bool unlocked=Catalog.IsUnlocked(id,Character.MainCampaignProgress.ClearedStageIds);selectButton.interactable=unlocked;
            if(!unlocked)description.text+="\nHoàn thành ải trước để mở khóa.";
            preview.SetActive(true);foreach(var pair in nodes){pair.Value.Selected=pair.Key==id;pair.Value.SetVerticesDirty();}
        }
        public void ShowFormation()
        {
            if(!Catalog.IsUnlocked(SelectedStageId,Character.MainCampaignProgress.ClearedStageIds))return;
            formation.Bind(Character,heroes);GetComponent<HeroRosterView>().Bind(Character,heroes);
            formation.SetBattleContext(Catalog.Stage(SelectedStageId).Name,BeginBattle,Show);canvas.SetActive(false);formation.Show();
        }
        void BeginBattle(HeroFormationData selection)
        {
            if(waiting)return;pendingHeroes=selection.HeroInstanceIds.ToArray();pendingStage=SelectedStageId;pendingId=Guid.NewGuid().ToString("N");waiting=true;sent=false;
            formation.Hide();canvas.SetActive(true);mapPanel.SetActive(false);preview.SetActive(false);resultPanel.SetActive(false);loading.SetActive(true);
            loadingText.text="ĐANG CHUẨN BỊ TRẬN...";
            if(!connection.Connected)connection.Connect();SendPending();
        }
        void SendPending()
        {
            if(!waiting || sent || !connection.Connected || connection.Busy)return;
            sent=true;if(connection.ChallengeCampaign(pendingStage,pendingHeroes,pendingId,manualUltimates:ManualUltimates)==null)sent=false;
        }
        void ConnectionChanged()
        {
            if(status==null)return;status.text=connection.Connected?"ĐÃ KẾT NỐI":"Chưa kết nối · nhấn KẾT NỐI để thử lại";
            connectButton.interactable=!connection.Connected && !connection.Busy;
            if(waiting && !connection.Busy && connection.Connected && !sent)SendPending();
            else if(waiting && !connection.Busy && ((!connection.Connected) || (sent && connection.LastBattleId!=pendingId)))
            {waiting=false;loadingText.text="Không thể bắt đầu trận. "+connection.Status;}
        }
        void Received(BattleRecord record)
        {
            if(!waiting || record.battleId!=pendingId || record.campaignStageId!=pendingStage)return;
            waiting=false;activeBattle=true;resultBattleId=null;canvas.SetActive(false);formation.Hide();arena.SetVisible(true);arena.SetCampaignTitle(Catalog.Stage(record.campaignStageId).Name);
        }
        void RefreshProgress()
        {
            if(Character==null)return;Character.MainCampaignProgress.ClearedStageIds=connection.CampaignClearedStageIds.Where(id=>Catalog.Data.Chapters.SelectMany(c=>c.Stages).Any(s=>s.Id==id)).Distinct().ToList();
            foreach(var pair in nodes){pair.Value.Cleared=Character.MainCampaignProgress.ClearedStageIds.Contains(pair.Key);pair.Value.Locked=!Catalog.IsUnlocked(pair.Key,Character.MainCampaignProgress.ClearedStageIds);pair.Value.SetVerticesDirty();}
            progress.text="CHƯƠNG 1  ·  "+ClearedCount+" / "+nodes.Count+" ẢI HOÀN THÀNH";
        }
        void Update()
        {
            if(!activeBattle || arena.Record==null || arena.Record.battleInProgress || arena.Playhead<arena.Record.DurationSeconds || resultBattleId==arena.Record.battleId)return;
            resultBattleId=arena.Record.battleId;canvas.SetActive(true);mapPanel.SetActive(false);preview.SetActive(false);loading.SetActive(false);resultPanel.SetActive(true);
            bool won=arena.Record.winner==0;resultTitle.text=won?"CHIẾN THẮNG":"CHƯA VƯỢT QUA";
            resultSubtitle.text=Catalog.Stage(arena.Record.campaignStageId).Name+(won?(NextId(arena.Record.campaignStageId)==null?"\nĐã hoàn thành chương 1!":"\nẢi đã được hoàn thành."):"\nĐiều chỉnh đội hình và thử lại.");
            nextButton.interactable=won && NextId(arena.Record.campaignStageId)!=null;RefreshProgress();
        }
        string NextId(string id)
        {var stages=Catalog.Data.Chapters.SelectMany(c=>c.Stages).ToList();int i=stages.FindIndex(s=>s.Id==id);return i>=0 && i+1<stages.Count?stages[i+1].Id:null;}
        void NextStage(){string next=NextId(arena.Record.campaignStageId);Show();if(next!=null)SelectStage(next);}
        void ExitToHeroes()
        {
            activeBattle=false;waiting=false;canvas.SetActive(false);formation.SetBattleContext(null,null,null);formation.Bind(regularCharacter,heroes);
            var roster=GetComponent<HeroRosterView>();roster.Bind(regularCharacter,heroes);roster.Show();
        }
        void OnDestroy()
        {if(connection==null)return;connection.CampaignProgressChanged-=RefreshProgress;connection.StatusChanged-=ConnectionChanged;connection.ReplayReceived-=Received;}
    }
}
