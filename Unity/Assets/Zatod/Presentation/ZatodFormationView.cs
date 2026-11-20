using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;

namespace Zatod.Presentation
{
    [Serializable] public sealed class ZatodFormationCard
    {
        public RectTransform Root;
        public UnityEngine.UI.Button Button;
        public UnityEngine.UI.Image Portrait,Frame,Selected;
        public TextMeshProUGUI Level;
        public UnityEngine.UI.Image[] Stars;
        [NonSerialized] public string InstanceId;
    }

    // UI draft only: ownership, combat placement and Campaign validation stay in their existing systems.
    public sealed class ZatodFormationView : MonoBehaviour
    {
        public RectTransform DesignRoot,Background,Content,DropRow;
        public ScrollRect RosterScroll;
        public TextMeshProUGUI StageName,Description,WaveLabel,Power,Cost,Rewards,Notice;
        public UnityEngine.UI.Button Back,Battle,PreviousWave,NextWave,Squad,Tutorial;
        public UnityEngine.UI.Button[] Filters;
        public ZatodFormationCard[] EnemyCards,TeamCards;
        public TMP_FontAsset Font;
        public string StageId=>encounter?.Id;
        public int WaveIndex {get;private set;}
        public HeroPosition? PositionFilter {get;private set;}
        public bool Pending {get;private set;}
        public IReadOnlyList<ZatodFormationCard> RosterCards=>rosterCards;
        readonly List<ZatodFormationCard> rosterCards=new List<ZatodFormationCard>();
        HeroCatalog catalog;
        CampaignStageDefinition encounter;
        CharacterData account;
        IList<string> selection;
        Action back;
        Action<string,string[]> start;
        bool connected;
        Vector2 lastSize;

        const string Assets="Zatod/UI/Formation/";
        public static Sprite Art(string name)
        {
            var sprite=Resources.Load<Sprite>(Assets+name);
            if(sprite==null)throw new InvalidOperationException("Missing Zatod formation art: "+name);
            return sprite;
        }
        void Awake()
        {
            Back.onClick.AddListener(()=>back?.Invoke());
            PreviousWave.onClick.AddListener(()=>ChangeWave(-1));NextWave.onClick.AddListener(()=>ChangeWave(1));
            for(int i=0;i<Filters.Length;i++){int index=i;Filters[i].onClick.AddListener(()=>SetFilter(index==0?(HeroPosition?)null:(HeroPosition)(index-1)));}
            Battle.onClick.AddListener(()=>
            {
                if(Pending || !connected || selection==null || selection.Count<1)return;
                Pending=true;Battle.interactable=false;Notice.text="";
                start?.Invoke(encounter.Id,selection.ToArray());
            });
        }
        void LateUpdate(){Fit();}
        public void Fit()
        {
            var size=((RectTransform)transform).rect.size;
            if(size==lastSize)return;lastSize=size;
            DesignRoot.localScale=Vector3.one*Mathf.Min(size.x/1600,size.y/740);
            float cover=Mathf.Max(size.x/1920,size.y/1080);Background.sizeDelta=new Vector2(1920,1080)*cover;
        }
        public void Open(CampaignStageDefinition stage,HeroCatalog definitions,CharacterData owned,IList<string> selected,Action onBack,Action<string,string[]> onBattle)
        {
            encounter=stage;catalog=definitions;account=owned;selection=selected;back=onBack;start=onBattle;
            WaveIndex=0;PositionFilter=null;Pending=false;connected=true;
            gameObject.SetActive(true);lastSize=Vector2.zero;Fit();
            StageName.text=stage.Name;Description.text=stage.Description??"";Cost.text="Cost: "+stage.VitalityCost;Rewards.text="Reward";
            ZatodStageUi.DrawDrops(DropRow,stage,catalog,64,16,3);Power.text="?";Notice.text="";
            RefreshRoster(true);DrawWave();
        }
        public void RefreshAccount(CharacterData owned,bool isConnected,string status)
        {
            if(encounter==null)return;account=owned;connected=isConnected;Pending=false;
            Notice.text=isConnected && status!=null && status.StartsWith("Error",StringComparison.OrdinalIgnoreCase)?status:!isConnected?"Disconnected":"";
            RefreshRoster(false);
        }
        public void SetFilter(HeroPosition? value)
        {
            if(PositionFilter==value)return;PositionFilter=value;RefreshRoster(true);
        }
        public void ChangeWave(int delta)
        {
            WaveIndex=Math.Clamp(WaveIndex+delta,0,encounter.Waves.Count-1);DrawWave();
        }
        void DrawWave()
        {
            var wave=encounter.Waves[WaveIndex];WaveLabel.text="Formation "+(WaveIndex+1)+"/"+encounter.Waves.Count;
            PreviousWave.interactable=WaveIndex>0;NextWave.interactable=WaveIndex+1<encounter.Waves.Count;
            for(int i=0;i<EnemyCards.Length;i++)
            {
                bool exists=i<wave.Enemies.Count;EnemyCards[i].Root.gameObject.SetActive(exists);if(!exists)continue;
                var spawn=wave.Enemies[i];DrawEnemyCard(EnemyCards[i],spawn,catalog);EnemyCards[i].InstanceId=spawn.Id;
            }
        }
        void RefreshRoster(bool resetScroll)
        {
            foreach(string id in selection.Where(id=>!account.HeroDesk.Any(h=>h.HeroInstanceId==id)).ToArray())selection.Remove(id);
            float position=Content.rect.height<=RosterScroll.viewport.rect.height+.01f?1:RosterScroll.verticalNormalizedPosition;
            foreach(var card in rosterCards){card.Root.gameObject.SetActive(false);Destroy(card.Root.gameObject);}rosterCards.Clear();
            foreach(var hero in account.HeroDesk.Where(h=>!PositionFilter.HasValue || catalog.Hero(h.HeroDefinitionId).Position==PositionFilter))
            {
                var card=CreateCard(Content,"Owned_"+hero.HeroInstanceId,108,Font);card.InstanceId=hero.HeroInstanceId;
                DrawCard(card,hero.HeroDefinitionId,hero.Level,hero.Stars,Rank(hero),selection.Contains(hero.HeroInstanceId));
                string id=hero.HeroInstanceId;card.Button.onClick.AddListener(()=>Toggle(id));rosterCards.Add(card);
            }
            for(int i=0;i<Filters.Length;i++)Filters[i].image.sprite=Art("battle_prepare_shai_xuan_but_"+((i==0 && !PositionFilter.HasValue || PositionFilter.HasValue && i==(int)PositionFilter+1)?3:1));
            LayoutRebuilder.ForceRebuildLayoutImmediate(Content);Canvas.ForceUpdateCanvases();RosterScroll.StopMovement();RosterScroll.verticalNormalizedPosition=resetScroll?1:position;DrawTeam();
        }
        int Rank(HeroData hero)=>Math.Max(1,catalog.Hero(hero.HeroDefinitionId).Ranks.FindIndex(r=>r.Id==hero.RankId)+1);
        public void Toggle(string id)
        {
            if(Pending || !account.HeroDesk.Any(h=>h.HeroInstanceId==id))return;
            if(selection.Contains(id))selection.Remove(id);else if(selection.Count<5)selection.Add(id);else return;
            foreach(var card in rosterCards){bool chosen=selection.Contains(card.InstanceId);card.Selected.gameObject.SetActive(chosen);card.Portrait.color=chosen?new Color(.4f,.4f,.4f):Color.white;}
            DrawTeam();
        }
        void DrawTeam()
        {
            var heroes=selection.Select(id=>account.HeroDesk.Single(h=>h.HeroInstanceId==id)).OrderByDescending(h=>catalog.Hero(h.HeroDefinitionId).Position).ThenBy(h=>catalog.Hero(h.HeroDefinitionId).SourceUnitId).ToArray();
            int offset=5-heroes.Length;
            for(int i=0;i<5;i++)
            {
                var card=TeamCards[i];card.Root.gameObject.SetActive(i>=offset);card.Button.onClick.RemoveAllListeners();if(i<offset){card.InstanceId=null;continue;}
                var hero=heroes[i-offset];card.InstanceId=hero.HeroInstanceId;DrawCard(card,hero.HeroDefinitionId,hero.Level,hero.Stars,Rank(hero),false);string id=hero.HeroInstanceId;card.Button.onClick.AddListener(()=>Toggle(id));
            }
            Battle.interactable=connected && !Pending && heroes.Length>0;Power.text="?";
        }
        public static void DrawEnemyCard(ZatodFormationCard card,WaveSpawnDefinition spawn,HeroCatalog catalog)
        {
            CombatantDefinition definition=spawn.Kind==SpawnKind.Hero?(CombatantDefinition)catalog.Hero(spawn.DefinitionId):catalog.Monster(spawn.DefinitionId);
            int rank=spawn.EstimateRank?(int)Math.Floor((spawn.Level+9)/10d):definition is HeroDefinition hero?Math.Max(1,hero.Ranks.FindIndex(r=>r.Id==spawn.RankId)+1):1;
            DrawCard(card,definition.Id,spawn.Level,spawn.Stars,rank,false);
        }
        static void DrawCard(ZatodFormationCard card,string id,int level,int stars,int rank,bool selected)
        {
            card.Portrait.sprite=Art("Portraits/"+id);card.Portrait.color=selected?new Color(.4f,.4f,.4f):Color.white;
            card.Frame.sprite=Art("hero_icon_frame_"+Math.Clamp(rank,1,18));card.Level.text=level.ToString();card.Selected.gameObject.SetActive(selected);
            for(int i=0;i<card.Stars.Length;i++){card.Stars[i].gameObject.SetActive(i<stars);card.Stars[i].rectTransform.anchoredPosition=new Vector2((108-Math.Clamp(stars,1,5)*17)/2+i*17,-86);}
        }
        static RectTransform Box(string name,Transform parent,float x,float y,float width,float height)
        {
            var r=new GameObject(name,typeof(RectTransform)).GetComponent<RectTransform>();r.SetParent(parent,false);r.anchorMin=r.anchorMax=r.pivot=Vector2.up;r.anchoredPosition=new Vector2(x,-y);r.sizeDelta=new Vector2(width,height);return r;
        }
        static UnityEngine.UI.Image Picture(RectTransform rect,string art,bool hit=false)
        {
            var image=rect.gameObject.AddComponent<UnityEngine.UI.Image>();image.sprite=Art(art);image.raycastTarget=hit;
            if(image.sprite.border.sqrMagnitude>0)image.type=UnityEngine.UI.Image.Type.Sliced;return image;
        }
        static TextMeshProUGUI Text(Transform parent,string name,string value,float x,float y,float w,float h,int size,TMP_FontAsset font)
        {
            var text=Box(name,parent,x,y,w,h).gameObject.AddComponent<TextMeshProUGUI>();text.font=font;text.text=value;text.fontSize=size;text.color=new Color(1,.97f,.87f);text.raycastTarget=false;text.alignment=TextAlignmentOptions.Center;text.textWrappingMode=TextWrappingModes.NoWrap;
            text.outlineWidth=.16f;text.outlineColor=new Color32(35,28,26,255);return text;
        }
        static UnityEngine.UI.Button MakeButton(Transform parent,string name,string art,float x,float y,float w,float h)
        {
            var rect=Box(name,parent,x,y,w,h);var image=Picture(rect,art,true);var button=rect.gameObject.AddComponent<UnityEngine.UI.Button>();button.targetGraphic=image;return button;
        }
        public static ZatodFormationCard CreateCard(Transform parent,string name,float length,TMP_FontAsset font)
        {
            var r=Box(name,parent,0,0,length,length);var hit=Picture(r,"hero_icon_bg",true);var card=new ZatodFormationCard{Root=r};card.Button=r.gameObject.AddComponent<UnityEngine.UI.Button>();card.Button.targetGraphic=hit;
            var inside=Box("Icon",r,0,0,108,108);inside.localScale=Vector3.one*(length/108);
            card.Portrait=Picture(Box("Portrait",inside,5,5,98,98),"Portraits/lina");
            card.Frame=Picture(Box("RankFrame",inside,0,0,108,108),"hero_icon_frame_1");
            Picture(Box("LevelBackground",inside,4,66,28,19),"heropackage_level_bg");card.Level=Text(inside,"Level","1",5,65,28,22,20,font);
            card.Stars=new UnityEngine.UI.Image[5];for(int i=0;i<5;i++)card.Stars[i]=Picture(Box("Star_"+(i+1),inside,10+i*17,86,17,17),"hero_star_1");
            card.Selected=Picture(Box("Selected",inside,60,62,45,40),"selected");card.Selected.gameObject.SetActive(false);return card;
        }
        public static ZatodFormationView Create(Transform parent,TMP_FontAsset font)
        {
            var rect=Box("ZatodFormationView",parent,0,0,1600,900);rect.anchorMin=Vector2.zero;rect.anchorMax=Vector2.one;rect.offsetMin=rect.offsetMax=Vector2.zero;
            var view=rect.gameObject.AddComponent<ZatodFormationView>();view.Font=font;
            var bg=Box("Forest",rect,0,0,1920,1080);bg.anchorMin=bg.anchorMax=bg.pivot=new Vector2(.5f,.5f);bg.anchoredPosition=Vector2.zero;Picture(bg,"formation_forest",true);view.Background=bg;
            var design=Box("Layout",rect,0,0,1600,740);design.anchorMin=design.anchorMax=design.pivot=new Vector2(.5f,.5f);design.anchoredPosition=Vector2.zero;view.DesignRoot=design;
            Picture(Box("PanelShade",design,235,13,964,714),"battle_prepare_9bg_2");
            Picture(Box("PanelFill",design,235,13,964,714),"battle_prepare_9bg_3");
            Picture(Box("EnemyPanel",design,235,13,964,96),"battle_prepare_enemy_bg");
            Picture(Box("FilterPanel",design,235,492,964,83),"battle_prepare_9bg_1");
            Picture(Box("TeamPanel",design,235,574,964,153),"battle_prepare_9bg_1");
            Picture(Box("MainFrame",design,227,3,980,734),"battle_prepare_9bg_big");
            Picture(Box("InfoPanel",design,1208,5,333,728),"battle_prepare_9bg_2");
            view.Back=MakeButton(design,"Back","break_butt_bj",48,20,58,58);Picture(Box("Arrow",view.Back.transform,7,9,43,40),"break_butt");
            view.Squad=MakeButton(design,"Squad","battle_prepare_lift_but_2",140,121,93,103);Picture(Box("Helmet",view.Squad.transform,26,5,46,46),"battle_prepare_team_1");Text(view.Squad.transform,"Caption","Squad",3,53,82,34,23,font).color=new Color(.28f,.22f,.18f);
            view.Tutorial=MakeButton(design,"Tutorial","battle_prepare_lift_but_1",140,239,89,99);Picture(Box("TutorialIcon",view.Tutorial.transform,29,8,37,39),"tutorial_book");Text(view.Tutorial.transform,"Caption","Tutorial",0,52,87,32,21,font);
            Text(design,"Enemy","Enemy",245,46,65,27,16,font).color=new Color(1,.28f,.1f);view.WaveLabel=Text(design,"Wave","Formation 1/3",310,46,133,27,17,font);view.WaveLabel.color=new Color(1,.28f,.1f);
            view.PreviousWave=MakeButton(design,"PreviousWave","battle_prepare_fx_1",444,30,38,60);view.NextWave=MakeButton(design,"NextWave","battle_prepare_fx_1",976,30,38,60);view.NextWave.image.rectTransform.localScale=new Vector3(-1,1,1);view.NextWave.image.rectTransform.anchoredPosition=new Vector2(1014,-30);
            view.EnemyCards=new ZatodFormationCard[5];for(int i=0;i<5;i++){var card=CreateCard(design,"Enemy_"+i,74,font);card.Root.anchoredPosition=new Vector2(494+i*94,-26);card.Button.interactable=false;view.EnemyCards[i]=card;}
            var scroll=Box("Roster",design,291,121,861,359);view.RosterScroll=scroll.gameObject.AddComponent<ScrollRect>();view.RosterScroll.horizontal=false;view.RosterScroll.movementType=ScrollRect.MovementType.Clamped;view.RosterScroll.scrollSensitivity=35;
            var viewport=Box("Viewport",scroll,0,0,861,359);viewport.gameObject.AddComponent<RectMask2D>();var target=Picture(viewport,"battle_prepare_9bg_3",true);target.color=new Color(1,1,1,.001f);
            var content=Box("Content",viewport,0,0,861,359);var grid=content.gameObject.AddComponent<GridLayoutGroup>();grid.cellSize=new Vector2(108,108);grid.spacing=new Vector2(16,16);grid.constraint=GridLayoutGroup.Constraint.FixedColumnCount;grid.constraintCount=7;grid.padding=new RectOffset(0,0,0,0);grid.childAlignment=TextAnchor.UpperLeft;
            var fitter=content.gameObject.AddComponent<ContentSizeFitter>();fitter.verticalFit=ContentSizeFitter.FitMode.PreferredSize;view.Content=content;view.RosterScroll.content=content;view.RosterScroll.viewport=viewport;
            view.Filters=new UnityEngine.UI.Button[4];string[] labels={"All","Ago","Middle","Rear"};for(int i=0;i<4;i++){var b=MakeButton(design,"Filter_"+labels[i],"battle_prepare_shai_xuan_but_1",460+i*93,508,58,58);Text(b.transform,"Caption",labels[i],-7,9,72,36,21,font);view.Filters[i]=b;}
            Picture(Box("PowerBadge",design,243,558,150,28),"battle_prepare_my_fitbg");Picture(Box("PowerIcon",design,252,559,26,26),"battle_prepare_fit_img");view.Power=Text(design,"Power","?",281,556,92,30,23,font);view.Power.color=new Color(1,.8f,.26f);
            Picture(Box("EmptyTeam",design,382,590,700,139),"battle_prepare_my_team_head");view.TeamCards=new ZatodFormationCard[5];for(int i=0;i<5;i++){var card=CreateCard(design,"Team_"+i,110,font);card.Root.anchoredPosition=new Vector2(397+i*140,-603);view.TeamCards[i]=card;}
            view.StageName=Text(design,"StageName","",1228,23,291,50,29,font);view.Description=Text(design,"Description","",1230,89,285,182,23,font);view.Description.alignment=TextAlignmentOptions.TopLeft;view.Description.textWrappingMode=TextWrappingModes.Normal;
            view.Cost=Text(design,"Cost","",1230,279,285,40,21,font);view.Rewards=Text(design,"Rewards","Reward",1230,335,285,35,21,font);
            view.Rewards.alignment=TextAlignmentOptions.MidlineLeft;view.Cost.alignment=TextAlignmentOptions.MidlineLeft;
            ZatodStageUi.Image(Box("VitalityIcon",design,1310,279,31,36),"vitality");
            view.DropRow=Box("DropItems",design,1230,380,285,145);
            view.Notice=Text(design,"Notice","",1230,534,285,70,18,font);view.Notice.textWrappingMode=TextWrappingModes.Normal;
            view.Battle=MakeButton(design,"Battle","buttion_big",1244,644,260,71);Picture(Box("Swords",view.Battle.transform,34,16,46,46),"battle_prepare_butt_fit_img");Text(view.Battle.transform,"Caption","Battle",93,15,145,47,29,font);
            view.Fit();return view;
        }
    }
}
