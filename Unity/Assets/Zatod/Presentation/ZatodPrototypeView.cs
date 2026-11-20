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
        TMP_InputField address,itemId;
        UnityEngine.UI.RawImage background;
        readonly List<string> selected=new List<string>();
        readonly Dictionary<int,Actor> visuals=new Dictionary<int,Actor>();
        string selectedHero,screen="campaign";
        int inventoryPage;
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
        readonly Dictionary<int,EffectVisual> effects=new Dictionary<int,EffectVisual>();
        AudioSource audioSource;
        ZatodFormationView formation;
        ZatodStagePreviewView stagePreview;
        sealed class EffectVisual {public RectTransform Root;public ReplaySprite Sprite;public HeroAnimationSetData Set;}

        sealed class Actor {public RectTransform Root,Hp,Energy;public ReplaySprite Sprite;public TextMeshProUGUI Label;public UnityEngine.UI.Button Button;public HeroAnimationSetData Set;public string LastAction;public double LastElapsed=-1;}
        static readonly Color Ink=new Color(.04f,.065f,.105f),Panel=new Color(.07f,.11f,.16f),TextColor=new Color(.93f,.95f,.97f),Muted=new Color(.57f,.66f,.72f),Gold=new Color(.9f,.71f,.4f),Blue=new Color(.29f,.68f,.82f);
        void Start()
        {
            connection=GetComponent<ZatodConnection>();
            if(connection.IsServer || ZatodConnection.HasArgument("--zatod-smoke")){enabled=false;return;}
            catalog=HeroDataJson.LoadBundledCatalog();campaign=CampaignDataJson.LoadZatod(catalog);
            if(Font==null)Font=Resources.Load<TMP_FontAsset>("UI/FormationFont");
            audioSource=gameObject.AddComponent<AudioSource>();audioSource.spatialBlend=0;
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
        TMP_InputField Input(Transform parent,string value,float x,float y,float w)
        {
            var r=Box("Input",parent,x,y,w,38);var image=Image(r,new Color(.025f,.045f,.07f));image.raycastTarget=true;
            var field=r.gameObject.AddComponent<TMP_InputField>();var label=Label(r,value,8,3,w-16,32,17);field.textViewport=label.rectTransform;field.textComponent=label;field.text=value;field.targetGraphic=image;field.characterLimit=100;return field;
        }
        void Safe(Action action){try{action();}catch(Exception error){status.text=error.Message;}}
        void Build()
        {
            var canvasObject=new GameObject("ZatodPrototypeCanvas",typeof(RectTransform),typeof(Canvas),typeof(UnityEngine.UI.CanvasScaler),typeof(UnityEngine.UI.GraphicRaycaster));
            canvasObject.transform.SetParent(transform,false);canvasObject.GetComponent<Canvas>().renderMode=RenderMode.ScreenSpaceOverlay;
            var scaler=canvasObject.GetComponent<UnityEngine.UI.CanvasScaler>();scaler.uiScaleMode=UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize;scaler.referenceResolution=new Vector2(1600,900);scaler.matchWidthOrHeight=.5f;
            root=Rect("Root",canvasObject.transform,Vector2.zero,Vector2.one,Vector2.zero,Vector2.zero);Image(root,Ink);
            if(FindAnyObjectByType<EventSystem>()==null)new GameObject("EventSystem",typeof(EventSystem),typeof(InputSystemUIInputModule));
            Label(root,"ZATOD LEGEND",30,20,300,40,30,Gold);Label(root,"ZATOD PROTOTYPE",330,29,310,30,18,Muted);
            address=Input(root,connection.Address,1050,22,255);Button(root,"Kết nối",1320,22,120,38,()=>{connection.Address=address.text;connection.Connect();});
            Button(root,"Ngắt",1450,22,110,38,()=>connection.Disconnect());
            Button(root,"Phó bản",30,85,150,44,()=>Show("campaign"));Button(root,"Arena",190,85,150,44,()=>Show("arena"));Button(root,"PvP online",350,85,160,44,()=>Show("pvp"));Button(root,"Hero / Đồ",520,85,160,44,()=>Show("heroes"));Button(root,"Replay",690,85,150,44,()=>Show("history"));
            Button(root,"Dừng trận",1410,85,150,44,()=>{connection.Cancel();replay=null;record=null;playing=false;ClearBattle();RenderMenu();});
            status=Label(root,"",30,844,1530,44,17,Muted);
            menu=Box("Menu",root,30,150,1540,660);Image(menu,Panel);
            var template=Resources.Load<GameObject>("Zatod/UI/ZatodBattleHUD");
            hud=template!=null?Instantiate(template,root,false).GetComponent<ZatodBattleHudLayout>():ZatodBattleHudLayout.Create(root,Font);
            stage=(RectTransform)hud.transform;actors=hud.Actors;background=hud.Background;clock=hud.Time;result=hud.Outcome;toolbar=hud.ReplayControls;
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
            stage.gameObject.SetActive(false);
            formation=Instantiate(Resources.Load<GameObject>("Zatod/UI/Formation/ZatodFormationView"),root,false).GetComponent<ZatodFormationView>();
            formation.gameObject.SetActive(false);
            stagePreview=Instantiate(Resources.Load<GameObject>("Zatod/UI/StagePreview/ZatodStagePreviewView"),root,false).GetComponent<ZatodStagePreviewView>();
            stagePreview.gameObject.SetActive(false);
        }
        void OnChanged()
        {
            status.text=connection.Status;
            if(connection.Snapshot!=null)
            {
                if(!initializedSelection){selected.AddRange(connection.Snapshot.Account.HeroDesk.Take(5).Select(h=>h.HeroInstanceId));initializedSelection=true;}
                if(selectedHero==null)selectedHero=connection.Snapshot.Account.HeroDesk.FirstOrDefault()?.HeroInstanceId;
            }
            if(stagePreview!=null && stagePreview.gameObject.activeSelf && connection.Snapshot!=null)
                stagePreview.Refresh(connection.Snapshot.StarsFor(stagePreview.StageId),connection.Connected);
            else if(formation!=null && formation.gameObject.activeSelf && connection.Snapshot!=null)
                formation.RefreshAccount(connection.Snapshot.Account,connection.Connected,connection.Status);
            else if(!stage.gameObject.activeSelf)RenderMenu();
        }
        void Show(string mode)
        {
            screen=mode;stagePreview.gameObject.SetActive(false);playing=false;stage.gameObject.SetActive(false);formation.gameObject.SetActive(false);menu.gameObject.SetActive(true);RenderMenu();
        }
        void Clear(Transform parent){foreach(Transform child in parent){child.gameObject.SetActive(false);Destroy(child.gameObject);}}
        void RenderMenu()
        {
            Clear(menu);if(connection.Snapshot==null){Label(menu,"Kết nối server để bắt đầu. Mỗi lần mở ứng dụng tạo một phiên phó bản mới.",35,35,1300,90,24);return;}
            var account=connection.Snapshot.Account;
            if(screen=="heroes"){DrawHeroes();return;}
            if(screen=="history")
            {
                Label(menu,"REPLAY · đầu vào + dữ liệu đầu trận",30,20,1000,40,24,Gold);
                int index=0;foreach(string id in connection.Snapshot.Replays.Take(16)){string captured=id;Button(menu,id,30+(index%2)*745,85+(index/2)*64,715,48,()=>connection.Request(new ZatodRequest{Command="replay",A=captured}));index++;}return;
            }
            if(screen!="campaign")
            {
            Label(menu,"ĐỘI HÌNH · chọn 1–5 Hero",30,20,1200,40,23,Gold);
            int n=0;foreach(var hero in account.HeroDesk)
            {
                string id=hero.HeroInstanceId;var definition=catalog.Hero(hero.HeroDefinitionId);string name=definition.SourceResource.Replace("_HD","");
                var button=Button(menu,(selected.Contains(id)?"[x] ":"")+name+" · Lv "+hero.Level+" · "+hero.RankId,30+n*295,80,280,85,()=>{if(selected.Contains(id))selected.Remove(id);else if(selected.Count<5)selected.Add(id);RenderMenu();});n++;
            }
            }
            if(screen=="campaign")
            {
                Label(menu,"CHƯƠNG 1 · 18 ải / 54 wave",30,190,1200,40,23,Gold);
                var cleared=connection.Snapshot.Cleared;
                foreach(var encounter in campaign.Data.Chapters[0].Stages)
                {
                    int index=encounter.SourceStageId-1;bool unlocked=campaign.IsUnlocked(encounter.Id,cleared);string id=encounter.Id;
                    Button(menu,"Ải "+(index+1)+(cleared.Contains(id)?" · Đã qua":"")+"\n"+encounter.Waves.Count+" wave",30+(index%6)*247,250+(index/6)*115,230,95,()=>OpenStagePreview(id),unlocked);
                }
            }
            else
            {
                Label(menu,screen=="arena"?"ARENA TỰ ĐỘNG":"PVP REALTIME",30,210,1200,45,28,Gold);
                Label(menu,screen=="arena"?"Server tạo trận xác định. Client xem lại từ seed, đội hình và input.":"Hai client cùng online. Input được trao đổi theo tick 8 Hz; chờ đủ input sau năm tick đầu.",30,275,1350,100,23,Muted);
                Button(menu,screen=="arena"?"Bắt đầu Arena":"Tìm trận",30,410,300,65,()=>{if(screen=="arena")connection.Arena(selected);else connection.FindPvp(selected);},selected.Count>0);
            }
        }
        void OpenStagePreview(string stageId)
        {
            if(connection.Snapshot==null)return;
            replay=null;record=null;formation.gameObject.SetActive(false);stage.gameObject.SetActive(false);menu.gameObject.SetActive(true);
            stagePreview.Open(campaign.Stage(stageId),catalog,connection.Snapshot.StarsFor(stageId),connection.Connected,
                ()=>Show("campaign"),()=>OpenFormation(stageId));
        }
        void OpenFormation(string stageId)
        {
            replay=null;record=null;stagePreview.gameObject.SetActive(false);menu.gameObject.SetActive(false);
            formation.Open(campaign.Stage(stageId),catalog,connection.Snapshot.Account,selected,()=>OpenStagePreview(stageId),
                (id,heroes)=>connection.Campaign(id,heroes));
        }
        void DrawHeroes()
        {
            var account=connection.Snapshot.Account;int n=0;
            foreach(var hero in account.HeroDesk){string id=hero.HeroInstanceId;Button(menu,catalog.Hero(hero.HeroDefinitionId).Name+" · "+hero.RankId,20,20+n++*62,230,50,()=>{selectedHero=id;inventoryPage=0;RenderMenu();});}
            var current=account.HeroDesk.Single(h=>h.HeroInstanceId==selectedHero);var stats=HeroStatCalculator.Calculate(current,catalog);
            Label(menu,catalog.Hero(current.HeroDefinitionId).Name+" · Lv "+current.Level+" · "+current.RankId,280,20,1200,40,25,Gold);
            double Stat(string id)=>stats.PreciseStats.FirstOrDefault(x=>x.StatId==id)?.Value??stats.Get(id);
            Label(menu,"HP "+Stat("health").ToString("0.#")+"   AD "+Stat("damage").ToString("0.#")+"   AP "+Stat("ability_power").ToString("0.#")+"   ARM "+Stat("defense").ToString("0.#")+"   MR "+Stat("magic_resistance").ToString("0.#"),280,70,1200,35,19);
            Button(menu,"Dev Lv 40",280,115,160,42,()=>connection.DevLevel(current.HeroInstanceId,40));Button(menu,"Tiến bậc",455,115,160,42,()=>connection.Promote(current.HeroInstanceId));
            Label(menu,"Hấp thụ: "+current.AbsorbedItems.Count+" món · mỗi GUID chỉ tính một lần",640,120,830,35,18,Muted);
            var rank=HeroProgression.CurrentRank(current,catalog);int slotIndex=0;
            foreach(var slot in rank.EquipmentSlots)
            {
                string slotId=slot.Id;var equipped=current.EquippedItems.FirstOrDefault(x=>x.SlotId==slot.Id);var item=catalog.Item(slot.RequiredItemId);int y=185+slotIndex++*62;
                Label(menu,slot.Id+"  "+item.Name+" · Lv "+item.LevelRequirement+(equipped!=null?"  [ĐÃ MẶC]":""),280,y,750,44,18);
                if(equipped==null)
                {
                    Button(menu,"Cấp món",1040,y,125,42,()=>connection.AddItemByItemId(slot.RequiredItemId));
                    var owned=account.Inventory.FirstOrDefault(x=>x.ItemId==slot.RequiredItemId);
                    Button(menu,"Mặc",1175,y,120,42,()=>{if(owned!=null)connection.Equip(current.HeroInstanceId,slotId,owned.Id);},owned!=null);
                }
                else Label(menu,equipped.Id,1040,y,460,44,14,Muted);
            }
            Label(menu,"KHO · "+account.Inventory.Count+" instance",280,570,350,34,18,Gold);
            itemId=Input(menu,"iron_axe",640,565,300);Button(menu,"AddItemByItemId",955,565,230,38,()=>connection.AddItemByItemId(itemId.text));
            var items=account.Inventory.Skip(inventoryPage*3).Take(3).ToArray();for(int i=0;i<items.Length;i++)Label(menu,items[i].ItemId+"   "+items[i].Id,280,608+i*16,1100,18,13,Muted);
            Button(menu,"<",1390,568,45,38,()=>{inventoryPage=Math.Max(0,inventoryPage-1);RenderMenu();});Button(menu,">",1445,568,45,38,()=>{inventoryPage=Math.Min(Math.Max(0,(account.Inventory.Count-1)/3),inventoryPage+1);RenderMenu();});
        }
        void ClearBattle(){Clear(actors);visuals.Clear();effects.Clear();drawnTick=-1;drawnFrame=null;drawnSimulation=null;ClearFloating();}
        void OnMatch()
        {
            formation.gameObject.SetActive(false);stagePreview.gameObject.SetActive(false);
            replay=null;record=null;playing=false;ClearBattle();stage.gameObject.SetActive(true);menu.gameObject.SetActive(false);DrawBattle();
        }
        void OnReplay()
        {
            record=connection.LastReplay;
            bool acknowledgingCurrent=record.Initial.Mode==ZatodMode.Campaign && connection.Battle!=null && connection.Battle.BattleId==record.Initial.BattleId && replay==null && stage.gameObject.activeSelf;
            if(acknowledgingCurrent)DrawBattle();else LoadReplay(record);
        }
        void LoadReplay(ZatodReplay value)
        {
            formation.gameObject.SetActive(false);stagePreview.gameObject.SetActive(false);
            record=value;replay=new ZatodBattleSimulation(value.Initial);replayElapsed=0;playing=true;ClearBattle();stage.gameObject.SetActive(true);menu.gameObject.SetActive(false);DrawBattle();
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
            if(replay==null || !playing || replay.Finished){if(stage!=null && stage.gameObject.activeSelf)DrawBattle();return;}
            replayElapsed+=Time.unscaledDeltaTime*speed;int ticks=(int)(replayElapsed/ZatodBattleSimulation.StepSeconds);
            if(ticks>0){replayElapsed-=ticks*(float)ZatodBattleSimulation.StepSeconds;AdvanceReplay(Math.Min(record.EndTick,replay.CurrentTick+ticks));}
            DrawBattle();
        }
        void DrawBattle()
        {
            if(stage==null || !stage.gameObject.activeInHierarchy)return;
            var simulation=replay??connection.Battle;if(simulation==null)return;
            if(simulation!=drawnSimulation || simulation.CurrentTick!=drawnTick)
            {drawnSimulation=simulation;drawnTick=simulation.CurrentTick;drawnFrame=simulation.Frame();tickDrawTime=Time.unscaledTime;}
            var frame=drawnFrame;
            double interpolation=frame.Finished || replay!=null && !playing?0:Math.Clamp(replay!=null?replayElapsed:Time.unscaledTime-tickDrawTime,0,ZatodBattleSimulation.StepSeconds);
            playbackButton.interactable=replay!=null;
            string bg=simulation.BackgroundResource;var texture=Resources.Load<Texture2D>("Zatod/Backgrounds/"+System.IO.Path.GetFileNameWithoutExtension(bg));background.texture=texture;background.uvRect=new Rect(simulation.FlipBackground?1:0,0,simulation.FlipBackground?-1:1,1);background.color=texture!=null?Color.white:new Color(.1f,.16f,.2f);
            clock.text=TimeSpan.FromSeconds(Math.Ceiling(frame.TimeRemaining)).ToString(@"mm\:ss");
            result.text=frame.Finished?(frame.Winner==(replay==null?connection.Team:0)?"CHIẾN THẮNG":"THẤT BẠI")+" · "+frame.Stars+" sao"+(replay==null && simulation.Mode==ZatodMode.Campaign?"\n"+(connection.LastReplay!=null?"Đã xác nhận":"Đang xác nhận..."):""):"";
            DrawHud(frame,simulation,interpolation);
            foreach(var state in frame.Units)
            {
                if(!visuals.TryGetValue(state.EntityId,out var visual))
                {
                    var r=Box("Actor "+state.EntityId,actors,0,0,120,140);var buttonImage=Image(r,new Color(0,0,0,.001f));buttonImage.raycastTarget=false;var hit=Box("UltimateHit",r,-60,-160,120,160);var hitImage=Image(hit,new Color(0,0,0,.001f));hitImage.raycastTarget=true;
                    var button=r.gameObject.AddComponent<UnityEngine.UI.Button>();button.targetGraphic=hitImage;
                    int actorId=state.EntityId;button.onClick.AddListener(()=>{if(replay==null)connection.Ultimate(actorId);});
                    var sr=Box("Sprite",r,0,0,100,100);var sprite=sr.gameObject.AddComponent<ReplaySprite>();sprite.Initialize(state.AnimationSetResource);
                    var hp=Box("HP",r,-45,-20,90,5);Image(hp,state.Team==0?new Color(.35f,.85f,.18f):new Color(.86f,.3f,.24f));var energy=Box("Energy",r,-45,-12,90,5);Image(energy,Gold);
                    visual=new Actor{Root=r,Sprite=sprite,Hp=hp,Energy=energy,Button=button,Label=Label(r,state.Resource,-70,-48,140,25,14),Set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(state.AnimationSetResource).text)};visual.Label.alignment=TextAlignmentOptions.Center;visuals.Add(state.EntityId,visual);
                }
                state.Motion.Project(state.X,state.Y,state.Height,interpolation,out double x,out double y,out double height);
                visual.Root.anchoredPosition=BattlePoint(x,y,height);
                visual.Sprite.Sample(state.Action,(float)(state.ActionElapsed+interpolation*state.ActionSpeed),state.FacingRight,(float)state.ArtScale*.7388535f,false,false);
                visual.Hp.sizeDelta=new Vector2(90*(float)(state.Hp/Math.Max(1,state.MaxHp)),5);visual.Energy.sizeDelta=new Vector2(90*(float)(state.Energy/Math.Max(1,state.MaxEnergy)),5);
                visual.Button.interactable=replay==null && state.Alive && state.Team==connection.Team && state.Energy>=state.MaxEnergy;
                if(replay==null || playing)
                {
                    double previous=visual.LastAction==state.Action?visual.LastElapsed:-.00001;
                    var clip=visual.Set.Clips.FirstOrDefault(c=>c.State==state.Action);
                    if(clip!=null)foreach(var cue in clip.AudioCues.Where(c=>c.Time>previous && c.Time<=state.ActionElapsed))
                    {var audio=Resources.Load<AudioClip>(cue.Resource);if(audio!=null)audioSource.PlayOneShot(audio,.45f);}
                }
                visual.LastAction=state.Action;visual.LastElapsed=state.ActionElapsed;
                visual.Label.gameObject.SetActive(false);visual.Energy.gameObject.SetActive(false);
            }
            foreach(var pair in visuals)pair.Value.Root.gameObject.SetActive(frame.Units.Any(u=>u.EntityId==pair.Key));
            foreach(var state in frame.Visuals)
            {
                if(string.IsNullOrEmpty(state.Resource))continue;
                if(!effects.TryGetValue(state.Id,out var effect))
                {
                    string resource="Zatod/"+System.IO.Path.GetFileNameWithoutExtension(state.Resource)+"/AnimationSet";var text=Resources.Load<TextAsset>(resource);
                    if(text==null){Debug.LogError("Missing Zatod effect: "+resource);continue;}
                    var rect=Box("Effect "+state.Id,actors,0,0,100,100);var sprite=rect.gameObject.AddComponent<ReplaySprite>();sprite.Initialize(resource);
                    effect=new EffectVisual{Root=rect,Sprite=sprite,Set=JsonUtility.FromJson<HeroAnimationSetData>(text.text)};effects.Add(state.Id,effect);
                }
                var first=effect.Set.Clips.FirstOrDefault(x=>x.State=="Start")??effect.Set.Clips[0];var loop=effect.Set.Clips.FirstOrDefault(x=>x.State=="Loop");
                string action=state.Elapsed>=first.DurationSeconds && loop!=null?loop.State:first.State;
                double elapsed=(action==first.State?state.Elapsed:state.Elapsed-first.DurationSeconds)+interpolation*state.TimeSpeed;
                bool visible=state.Kind=="projectile" || state.Kind=="buff" || state.Elapsed<first.DurationSeconds;
                effect.Root.gameObject.SetActive(visible);if(!visible)continue;
                state.Motion.Project(state.X,state.Y,state.Height,interpolation,out double x,out double y,out double height);
                effect.Root.anchoredPosition=BattlePoint(x,y,height);
                effect.Sprite.Sample(action,(float)elapsed,state.FacingRight,(float)state.Scale*.7388535f,state.Kind=="projectile");
                if(state.Kind=="chain")
                {
                    float dx=(float)(state.EndX-state.X)*1.75f,dy=(float)(state.EndY-state.Y)*.875f+(float)(state.EndHeight-state.Height)*1.75f;
                    effect.Sprite.StretchWidth(Mathf.Sqrt(dx*dx+dy*dy));effect.Root.localRotation=Quaternion.Euler(0,0,Mathf.Atan2(dy,dx)*Mathf.Rad2Deg);
                }
            }
            foreach(var pair in effects.ToArray())if(!frame.Visuals.Any(x=>x.Id==pair.Key)){Destroy(pair.Value.Root.gameObject);effects.Remove(pair.Key);}
            if(record!=null && record.EndTick>0)seek.SetValueWithoutNotify(frame.Tick/(float)record.EndTick);
        }
        void OnDestroy()
        {
            if(connection==null)return;connection.Changed-=OnChanged;connection.MatchStarted-=OnMatch;connection.FrameReceived-=DrawBattle;connection.ReplayReceived-=OnReplay;
        }
    }
}
