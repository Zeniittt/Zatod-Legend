using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem.UI;
using Zatod.Combat;
using Zatod.Animation;
using Zatod.Heroes;
using Zatod.Networking;
namespace Zatod.Presentation
{
    [DefaultExecutionOrder(30)]
    [RequireComponent(typeof(ZatodConnection))]
    public sealed partial class ZatodPrototypeView : MonoBehaviour
    {
        public TMP_FontAsset Font;
        ZatodConnection connection;HeroCatalog catalog;CampaignCatalog campaign;
        RectTransform root,menu,stage,actors,toolbar,detail;
        TextMeshProUGUI status,clock,result;
        UnityEngine.UI.RawImage background;
        readonly List<string> selected=new List<string>();
        string screen="campaign";
        ZatodBattleSimulation replay;
        ZatodReplay record;
        bool playing;
        float replayElapsed,speed=1;
        UnityEngine.UI.Slider seek;
        TextMeshProUGUI playLabel;
        UnityEngine.UI.Button playbackButton;
        int drawnTick=-1;float tickDrawTime;bool initializedSelection;
        ZatodBattleSimulation drawnSimulation;
        ZatodFrame drawnFrame;
        ZatodBattleSceneController battleScene;
        ZatodFormationView formation;
        ZatodStagePreviewView stagePreview;
        static readonly Color Ink=new Color(.04f,.065f,.105f),Panel=new Color(.07f,.11f,.16f),TextColor=new Color(.93f,.95f,.97f),Muted=new Color(.57f,.66f,.72f),Gold=new Color(.9f,.71f,.4f),Blue=new Color(.29f,.68f,.82f);
        void Start()
        {
            connection=GetComponent<ZatodConnection>();
            if(connection.IsServer || ZatodConnection.HasArgument("--zatod-smoke")){enabled=false;return;}
            catalog=HeroDataJson.LoadBundledCatalog();campaign=CampaignDataJson.LoadZatod(catalog);
            if(Font==null)Font=Resources.Load<TMP_FontAsset>("UI/FormationFont");
            battleScene=gameObject.AddComponent<ZatodBattleSceneController>();
            battleScene.Changed+=OnBattleSceneChanged;
            battleScene.Failed+=reason=>{connection.Cancel();status.text=reason;Show("campaign");};
            Build();connection.Changed+=OnChanged;connection.MatchStarted+=OnMatch;connection.FrameReceived+=DrawBattle;connection.ReplayReceived+=OnReplay;
            OnChanged();
        }
        RectTransform Rect(string name,Transform parent,Vector2 anchorMin,Vector2 anchorMax,Vector2 minimum,Vector2 maximum)
        {
            var go=new GameObject(name,typeof(RectTransform));var r=go.GetComponent<RectTransform>();r.SetParent(parent,false);
            r.anchorMin=anchorMin;r.anchorMax=anchorMax;r.offsetMin=minimum;r.offsetMax=maximum;return r;
        }
        RectTransform Box(string name,Transform parent,float x,float y,float w,float h)
        {
            var r=Rect(name,parent,new Vector2(0,1),new Vector2(0,1),Vector2.zero,Vector2.zero);r.pivot=new Vector2(0,1);r.anchoredPosition=new Vector2(x,-y);r.sizeDelta=new Vector2(w,h);return r;
        }
        UnityEngine.UI.Image Image(RectTransform r,Color color){var image=r.gameObject.AddComponent<UnityEngine.UI.Image>();image.color=color;image.raycastTarget=false;return image;}
        TextMeshProUGUI Label(Transform parent,string text,float x,float y,float w,float h,int size=18,Color? color=null)
        {
            var r=Box("Label",parent,x,y,w,h);var label=r.gameObject.AddComponent<TextMeshProUGUI>();label.font=Font;label.text=text;label.fontSize=size;label.color=color??TextColor;label.raycastTarget=false;label.textWrappingMode=TextWrappingModes.Normal;return label;
        }
        UnityEngine.UI.Button Button(Transform parent,string title,float x,float y,float w,float h,Action action,bool active=true)
        {
            var r=Box(title,parent,x,y,w,h);var image=Image(r,active?new Color(.12f,.2f,.27f):new Color(.08f,.12f,.16f));image.raycastTarget=true;
            var button=r.gameObject.AddComponent<UnityEngine.UI.Button>();button.targetGraphic=image;button.interactable=active;button.onClick.AddListener(()=>Safe(action));
            var text=Label(r,title,8,4,w-16,h-8,17,active?TextColor:Muted);text.alignment=TextAlignmentOptions.Center;return button;
        }
        void Safe(Action action){try{action();}catch(Exception error){status.text=error.Message;}}
        void Build()
        {
            var canvasObject=new GameObject("ZatodPrototypeCanvas",typeof(RectTransform),typeof(Canvas),typeof(UnityEngine.UI.CanvasScaler),typeof(UnityEngine.UI.GraphicRaycaster));
            canvasObject.transform.SetParent(transform,false);canvasObject.GetComponent<Canvas>().renderMode=RenderMode.ScreenSpaceOverlay;
            var scaler=canvasObject.GetComponent<UnityEngine.UI.CanvasScaler>();scaler.uiScaleMode=UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize;scaler.referenceResolution=new Vector2(1600,900);scaler.matchWidthOrHeight=.5f;
            var backdrop=Rect("Backdrop",canvasObject.transform,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);Image(backdrop,Ink);
            root=Rect("SafeAreaRoot",canvasObject.transform,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);Image(root,Ink);
            root.gameObject.AddComponent<ZatodSafeAreaRoot>();
            if(FindAnyObjectByType<EventSystem>()==null)new GameObject("EventSystem",typeof(EventSystem),typeof(InputSystemUIInputModule));
            status=Label(root,"",30,844,1530,44,17,Muted);
            menu=Box("Menu",root,30,150,1540,660);Image(menu,Panel);
            var template=Resources.Load<GameObject>("Zatod/UI/ZatodBattleHUD");
            hud=template!=null?Instantiate(template,root,false).GetComponent<ZatodBattleHudLayout>():ZatodBattleHudLayout.Create(root,Font);
            stage=(RectTransform)hud.transform;actors=hud.Actors;background=hud.Background;clock=hud.Time;result=hud.Outcome;toolbar=hud.ReplayControls;
            background.enabled=false;background.raycastTarget=false;
            actors.gameObject.AddComponent<ZatodResponsiveLayout>().Fit();hud.Floating.gameObject.AddComponent<ZatodResponsiveLayout>().Fit();
            hud.Exit.onClick.AddListener(()=>{connection.Cancel();replay=null;record=null;playing=false;ClearBattle();Show("campaign");});
            hud.Continue.onClick.AddListener(()=>Show("campaign"));
            hud.WatchReplay.onClick.AddListener(()=>{if(connection.LastReplay!=null)LoadReplay(connection.LastReplay);});
            hud.Auto.onClick.AddListener(()=>{connection.AutoUltimate=!connection.AutoUltimate;RefreshAuto();});
            playbackButton=Button(toolbar,"Tạm dừng",15,5,150,40,()=>{playing=!playing;playLabel.text=playing?"Tạm dừng":"Phát";});
            playLabel=playbackButton.GetComponentInChildren<TextMeshProUGUI>(true);
            Button(toolbar,"Tốc độ",175,5,120,40,()=>{speed=speed>=4?1:speed*2;});
            var seekRect=Box("Seek",toolbar,330,13,1200,22);seek=seekRect.gameObject.AddComponent<UnityEngine.UI.Slider>();
            var rail=Box("Rail",seekRect,0,0,1200,22);Image(rail,new Color(.13f,.22f,.3f));
            var fill=Rect("Fill",seekRect,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);Image(fill,Blue);seek.fillRect=fill;
            var handle=Box("Handle",seekRect,0,0,14,22);var handleImage=Image(handle,Gold);handleImage.raycastTarget=true;seek.handleRect=handle;seek.targetGraphic=handleImage;seek.minValue=0;seek.maxValue=1;seek.onValueChanged.AddListener(value=>{if(record!=null)Seek(Mathf.RoundToInt(value*record.EndTick));});
            seekRect.anchorMin=Vector2.zero;seekRect.anchorMax=Vector2.one;seekRect.offsetMin=new Vector2(330,14);seekRect.offsetMax=new Vector2(-20,-14);
            rail.anchorMin=Vector2.zero;rail.anchorMax=Vector2.one;rail.offsetMin=rail.offsetMax=Vector2.zero;
            stage.gameObject.SetActive(false);
            formation=Instantiate(Resources.Load<GameObject>("Zatod/UI/Formation/ZatodFormationView"),root,false).GetComponent<ZatodFormationView>();
            formation.gameObject.SetActive(false);
            stagePreview=Instantiate(Resources.Load<GameObject>("Zatod/UI/StagePreview/ZatodStagePreviewView"),root,false).GetComponent<ZatodStagePreviewView>();
            stagePreview.gameObject.SetActive(false);
            BuildWorld();
            BuildHeroViews();
            BuildBattleResultView();
            BuildLanViews();
        }
        void OnChanged()
        {
            status.text=connection.Status;
            if(equipmentWindow!=null && equipmentWindow.gameObject.activeSelf){if(connection.Snapshot==null || !connection.Connected)equipmentWindow.Hide();else equipmentWindow.Refresh(connection.Snapshot.Account);}
            if(battleScene!=null && battleScene.OccupiesClient && (!connection.Connected || connection.Battle==null && replay==null))
            {ClearBattle();Show("campaign");return;}
            if(connection.Snapshot!=null)
            {
                if(!initializedSelection){selected.AddRange(connection.Snapshot.Account.HeroDesk.Take(5).Select(h=>h.HeroInstanceId));initializedSelection=true;}
            }
            if(inventoryView!=null && inventoryView.gameObject.activeSelf && connection.Snapshot!=null){inventoryView.Refresh(connection.Snapshot.Account);RefreshWorldChrome();return;}
            if(heroRoster!=null && heroRoster.gameObject.activeSelf && connection.Snapshot!=null){heroRoster.Refresh(connection.Snapshot.Account);RefreshWorldChrome();return;}
            if(heroDetail!=null && heroDetail.gameObject.activeSelf && connection.Snapshot!=null){heroDetail.Refresh(connection.Snapshot.Account);RefreshWorldChrome();return;}
            if(stagePreview!=null && stagePreview.gameObject.activeSelf && connection.Snapshot!=null)
                stagePreview.Refresh(connection.Snapshot.StarsFor(stagePreview.StageId),connection.Connected,campaign.IsUnlocked(stagePreview.StageId,connection.Snapshot.Cleared));
            else if(formation!=null && formation.gameObject.activeSelf && connection.Snapshot!=null)
                formation.RefreshAccount(connection.Snapshot.Account,connection.Connected,connection.Status,connection.FindingPvp);
            else if(!stage.gameObject.activeSelf)RenderMenu();
        }
        void Show(string mode)
        {
            if(mode=="heroes"){OpenHeroRoster();return;}
            featureView?.gameObject.SetActive(false);
            ClearBattleResult();inventoryView?.gameObject.SetActive(false);equipmentWindow?.Hide();
            battleScene?.Leave();
            if(heroRoster!=null)heroRoster.gameObject.SetActive(false);if(heroDetail!=null)heroDetail.gameObject.SetActive(false);
            screen=mode;stagePreview.gameObject.SetActive(false);playing=false;stage.gameObject.SetActive(false);formation.gameObject.SetActive(false);menu.gameObject.SetActive(true);RenderMenu();
        }
        void Clear(Transform parent){foreach(Transform child in parent){child.gameObject.SetActive(false);Destroy(child.gameObject);}}
        void RenderMenu()
        {
            Clear(menu);menu.gameObject.SetActive(false);RefreshWorldChrome();
            if(connection.Snapshot!=null&&connection.Connected&&(screen=="arena"||screen=="pvp"||screen=="history"))OpenNpcFeature();
        }
        void OpenStagePreview(string stageId)
        {
            if(connection.Snapshot==null)return;
            replay=null;record=null;formation.gameObject.SetActive(false);stage.gameObject.SetActive(false);menu.gameObject.SetActive(true);
            RefreshWorldChrome();stagePreview.Open(campaign.Stage(stageId),catalog,connection.Snapshot.StarsFor(stageId),connection.Connected,
                ()=>Show("campaign"),()=>OpenFormation(stageId),campaign.IsUnlocked(stageId,connection.Snapshot.Cleared));
        }
        void OpenFormation(string stageId)
        {
            replay=null;record=null;stagePreview.gameObject.SetActive(false);menu.gameObject.SetActive(false);
            formation.Open(campaign.Stage(stageId),catalog,connection.Snapshot.Account,selected,()=>OpenStagePreview(stageId),
                (id,heroes)=>connection.Campaign(id,heroes));
        }
        void ClearBattle(){ClearBattleResult();battleScene?.Stage?.Clear();drawnTick=-1;drawnFrame=null;drawnSimulation=null;ClearFloating();}
        void OnMatch()
        {
            featureView?.gameObject.SetActive(false);
            equipmentWindow?.Hide();inventoryView?.gameObject.SetActive(false);heroRoster.gameObject.SetActive(false);heroDetail.gameObject.SetActive(false);
            formation.gameObject.SetActive(false);stagePreview.gameObject.SetActive(false);
            replay=null;record=null;playing=false;ClearBattle();menu.gameObject.SetActive(false);battleScene.Enter();DrawBattle();
        }
        void OnReplay()
        {
            record=connection.LastReplay;
            bool acknowledgingCurrent=record.Initial.Mode==ZatodMode.Campaign && connection.Battle!=null && connection.Battle.BattleId==record.Initial.BattleId && replay==null && battleScene.OccupiesClient;
            if(acknowledgingCurrent)DrawBattle();else LoadReplay(record);
        }
        void LoadReplay(ZatodReplay value)
        {
            featureView?.gameObject.SetActive(false);
            equipmentWindow?.Hide();inventoryView?.gameObject.SetActive(false);heroRoster.gameObject.SetActive(false);heroDetail.gameObject.SetActive(false);
            formation.gameObject.SetActive(false);stagePreview.gameObject.SetActive(false);
            record=value;replay=new ZatodBattleSimulation(value.Initial);replayElapsed=0;playing=true;ClearBattle();menu.gameObject.SetActive(false);battleScene.Enter();DrawBattle();
        }
        void Seek(int tick)
        {
            if(record==null)return;replay=new ZatodBattleSimulation(record.Initial);playing=false;ClearBattle();AdvanceReplay(tick);DrawBattle();
        }
        void AdvanceReplay(int target)
        {
            while(replay.CurrentTick<target && !replay.Finished)
            {foreach(var input in record.Inputs.Where(x=>x.Tick==replay.CurrentTick+1))replay.QueueInput(input);replay.Step();}
        }
        void Update()
        {
            if(connection?.Snapshot!=null){if(heroRoster!=null&&heroRoster.gameObject.activeSelf)ZatodHeroUi.RefreshCurrencies(heroRoster.CurrencyRow,connection.Snapshot.Account,connection.ServerNow);if(heroDetail!=null&&heroDetail.gameObject.activeSelf)ZatodHeroUi.RefreshCurrencies(heroDetail.CurrencyRow,connection.Snapshot.Account,connection.ServerNow);}
            if(replay==null || !playing || replay.Finished){if(stage!=null && stage.gameObject.activeSelf)DrawBattle();return;}
            replayElapsed+=Time.unscaledDeltaTime*speed;int ticks=(int)(replayElapsed/ZatodBattleSimulation.StepSeconds);
            if(ticks>0){replayElapsed-=ticks*(float)ZatodBattleSimulation.StepSeconds;AdvanceReplay(Math.Min(record.EndTick,replay.CurrentTick+ticks));}
            DrawBattle();
        }
        void DrawBattle()
        {
            if(stage==null || battleScene?.Stage==null || battleScene.Phase!=ZatodScenePhase.InBattle)return;
            var simulation=replay??connection.Battle;if(simulation==null)return;
            if(simulation!=drawnSimulation || simulation.CurrentTick!=drawnTick)
            {drawnSimulation=simulation;drawnTick=simulation.CurrentTick;drawnFrame=simulation.Frame();tickDrawTime=Time.unscaledTime;}
            var frame=drawnFrame;
            double interpolation=frame.Finished || replay!=null && !playing?0:Math.Clamp(replay!=null?replayElapsed:Time.unscaledTime-tickDrawTime,0,ZatodBattleSimulation.StepSeconds);
            playbackButton.interactable=replay!=null;
            clock.text=TimeSpan.FromSeconds(Math.Ceiling(frame.TimeRemaining)).ToString(@"mm\:ss");
            result.text=frame.Finished?(frame.Winner==(replay==null?connection.Team:0)?"CHIẾN THẮNG":"THẤT BẠI")+" · "+frame.Stars+" sao"+(replay==null && simulation.Mode==ZatodMode.Campaign?"\n"+(connection.LastReplay!=null?"Đã xác nhận":"Đang xác nhận..."):""):"";
            DrawHud(frame,simulation,interpolation);
            battleScene.Stage.Draw(frame,simulation,interpolation,connection.Team,replay==null,replay==null || playing);
            DrawBattleResult(frame,simulation,interpolation);
            if(record!=null && record.EndTick>0)seek.SetValueWithoutNotify(frame.Tick/(float)record.EndTick);
        }
        void OnBattleSceneChanged()
        {
            if(world==null || stage==null)return;
            world.SetSuspended(battleScene.OccupiesClient);
            stage.gameObject.SetActive(battleScene.Phase==ZatodScenePhase.InBattle);
            if(battleScene.Stage!=null){battleScene.Stage.Fit(actors);battleScene.Stage.Ultimate=id=>{if(replay==null)connection.Ultimate(id);};}
            RefreshWorldChrome();if(battleScene.Phase==ZatodScenePhase.InBattle)DrawBattle();
        }
        void OnDestroy()
        {
            if(connection==null)return;connection.Changed-=OnChanged;connection.MatchStarted-=OnMatch;connection.FrameReceived-=DrawBattle;connection.ReplayReceived-=OnReplay;
        }
    }
}
