using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;
using Zatod.Networking;
using static Zatod.Presentation.ZatodHeroUi;
namespace Zatod.Presentation
{
    // Native Crystal art; only transient selection/scroll state lives in this view.
    public sealed class ZatodInventoryView:MonoBehaviour
    {
        public TMP_FontAsset Font;
        public RectTransform Board,Detail,GridContent,CurrencyRow;
        public ScrollRect Grid, DetailScroll;
        public RectTransform DetailContent;
        public TextMeshProUGUI UnitPrice;
        RectTransform soulSeparator;
        readonly List<float> rowY=new List<float>();
        int ownedCards;
        const int Columns=8;
        sealed class Entry { public string Id,ItemId; }
        public TextMeshProUGUI Title,Description,Owned,Notice;
        public bool ExperienceOnly;
        public void HideInventoryChrome(){transform.Find("Background").gameObject.SetActive(false);foreach(Transform child in Board)if(child!=modal)child.gameObject.SetActive(false);}
        public InventoryTab CurrentTab {get;private set;}
        public InventoryFilter CurrentFilter {get;private set;}
        public string SelectedGuid {get;private set;}
        public int VisibleItemCount=>items.Count;
        public int OwnedHeroCardCount=>ownedCards;
        public int UnownedHeroCardCount=>CurrentTab==InventoryTab.Soulstones?items.Count-ownedCards:0;
        public string SelectedItemId=>selectedType;
        public int PooledCellCount=>pool.Count;
        public int TotalItemCount=>counts.Values.Sum();
        public int DisplayedAmount(string itemId)=>counts.TryGetValue(itemId,out int n)?n:0;
        readonly Dictionary<string,int> counts=new Dictionary<string,int>(StringComparer.Ordinal);string selectedType;
        HeroCatalog catalog;CampaignCatalog campaign;CharacterData account;ZatodConnection client;InventoryCatalog planner;
        Action close;RectTransform detailIcon,actions,filters,modal;TextMeshProUGUI modalMessage;UnityEngine.UI.Button modalConfirm;
        readonly List<Entry> items=new List<Entry>();readonly List<Cell> pool=new List<Cell>();
        sealed class Cell {public RectTransform Root,Art;public TextMeshProUGUI Progress,Amount;public UnityEngine.UI.Image Highlight,ProgressBg,ProgressFill;public Entry Item;public ZatodFormationCard HeroCard;public UnityEngine.UI.Image Ready,Mark;}
        readonly List<UnityEngine.UI.Button> tabs=new List<UnityEngine.UI.Button>();
        Vector2 lastSize;long revision=-1;CharacterData lastAccount;string lastStatus;
        public static Sprite Native(string key)=>Resources.Load<Sprite>("Zatod/UI/Inventory/Native/UI/alpha/1080P/"+key) ?? Resources.Load<Sprite>(ZatodEquipmentView.ArtPath+key);
        public static UnityEngine.UI.Image Pic(Transform parent,string name,string key,float x,float y,float w,float h,bool hit=false)
        {
            var image=Box(parent,name,x,y,w,h).gameObject.AddComponent<UnityEngine.UI.Image>();image.sprite=Native(key);image.raycastTarget=hit;
            if(image.sprite!=null&&image.sprite.border.sqrMagnitude>0)image.type=UnityEngine.UI.Image.Type.Sliced;return image;
        }
        public static TextMeshProUGUI Label(Transform p,string name,string value,TMP_FontAsset font,float x,float y,float w,float h,int size=25,bool dark=false)
        {var t=Text(p,name,value,font,size);Place(t.rectTransform,x,y,w,h);t.alignment=TextAlignmentOptions.Center;if(dark){t.color=new Color(.263f,.23f,.22f);t.outlineWidth=0;}
            if(name=="ItemName"){t.font=font;t.color=Color.white;t.outlineWidth=.18f;t.outlineColor=new Color(.12f,.1f,.08f);}
            return t;}
        public static UnityEngine.UI.Button NativeButton(Transform p,string name,string caption,TMP_FontAsset font,float x,float y,float w,float h,Action click,string art="common/buttion_big")
        {var i=Pic(p,name,art,x,y,w,h,true);var b=i.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=i;b.onClick.AddListener(()=>click?.Invoke());Caption(b,caption,font,25);var text=b.GetComponentInChildren<TextMeshProUGUI>();text.outlineWidth=.16f;text.outlineColor=new Color(.15f,.12f,.1f);return b;}
        public static UnityEngine.UI.Image DrawSoulstoneReady(ZatodFormationCard card,TMP_FontAsset font,string caption)
        {
            var inside=card.Root.Find("Icon");var glow=Pic(inside,"ReadyGlow","effects/evolve_bg",-4,48,118,63);glow.transform.SetSiblingIndex(1);
            var banner=Box(inside,"StarReady",w:108,h:108);Pic(banner,"ReadyTitleGlow","effects/evolve_title",-7,-7,124,49);
            var label=Label(banner,"ReadyText",caption,font,-4,-2,118,35,24);label.color=new Color(1,.95f,.58f);label.outlineWidth=.18f;label.outlineColor=new Color(.58f,.29f,.05f);return glow;
        }
        public static void Clear(Transform root){foreach(Transform child in root){child.gameObject.SetActive(false);Destroy(child.gameObject);}}
        public static ZatodInventoryView Create(Transform parent,TMP_FontAsset font)
        {
            font=Resources.Load<TMP_FontAsset>("Zatod/UI/Inventory/Fonts/InventoryRegular")??font;
            var root=Box(parent,"ZatodInventoryView");Stretch(root);var v=root.gameObject.AddComponent<ZatodInventoryView>();v.Font=font;
            var bg=Pic(root,"Background","bg/herolist_bg",0,0,1600,900,true);Stretch(bg.rectTransform);
            v.Board=Box(root,"InventoryBoard",w:1600,h:900);v.Board.anchorMin=v.Board.anchorMax=v.Board.pivot=new Vector2(.5f,.5f);
            NativeButton(v.Board,"Back","",font,48,22,68,68,()=>v.close?.Invoke(),"common/break_butt_bj");Picture(v.Board.Find("Back"),"Arrow","break_butt",14,14,40,40,aspect:true);
            
            v.CurrencyRow=Currencies(v.Board,font);Place(v.CurrencyRow,848,18,700,54);
            v.Detail=Pic(v.Board,"Detail","common/com_new_1",85,110,365,748).rectTransform;
            Pic(v.Detail,"DescriptionBackground","package/bg_deso",13,262,339,350);
            Pic(v.Detail,"NameBand","package/bg_number",0,163,365,59);
            Pic(v.Detail,"BottomDecoration","package/bg_bottom_deco",25,606,315,22);
            v.Title=Label(v.Detail,"ItemName","",font,10,170,345,52,27,true);
            v.Owned=Label(v.Detail,"Owned","",font,10,222,345,40,23,true);
            v.DetailScroll=Scroll(v.Detail,"DescriptionScroll",out v.DetailContent);var dc=v.DetailContent;Place((RectTransform)v.DetailScroll.transform,25,273,315,324);
            v.Description=Label(dc,"Description","",font,0,0,309,330,23,true);v.Description.alignment=TextAlignmentOptions.TopLeft;v.Description.textWrappingMode=TextWrappingModes.Normal;v.Description.overflowMode=TextOverflowModes.Overflow;
            v.UnitPrice=Label(v.Detail,"UnitPrice","",font,105,627,155,36,25,true);
            v.actions=Box(v.Detail,"Actions",9,673,347,62);
            Pic(v.Board,"GridBoard","common/com_new_2",450,110,1000,748);
            v.Grid=Scroll(v.Board,"ItemScroll",out v.GridContent);Place((RectTransform)v.Grid.transform,470,133,951,607);
            v.Grid.onValueChanged.AddListener(_=>v.DrawCells());
            v.filters=Box(v.Board,"Filters",478,756,944,78);
            for(int n=0;n<4;n++)
            {
                var tab=(InventoryTab)n;var b=NativeButton(v.Board,"Tab_"+tab,tab.ToString(),font,1445,140+n*144,128,128,()=>v.SelectTab(tab),"common/battle_prepare_lift_but_1");v.tabs.Add(b);
                string[] icons={"icon_item","icon_fragment","icon_skin","icon_soul"};var icon=Pic(b.transform,"Icon","package/"+icons[n],42,14,44,48);if(n==2)icon.sprite=Native("hero/icon_skin");
                Place(b.GetComponentInChildren<TextMeshProUGUI>().rectTransform,0,76,128,42);
            }
            Pic(v.Board,"EmptyState","package/fox",745,270,360,350).gameObject.SetActive(false);
            v.Notice=Label(v.Board,"Notice","",font,460,844,980,42,22);v.Notice.color=new Color(1,.75f,.3f);
            root.gameObject.SetActive(false);return v;
        }
        public void Open(HeroCatalog c,CampaignCatalog stages,CharacterData a,ZatodConnection connection,Action onClose)
        {ExperienceOnly=false;transform.Find("Background").gameObject.SetActive(true);foreach(Transform child in Board)child.gameObject.SetActive(true);catalog=c;campaign=stages;planner=new InventoryCatalog(c);client=connection;close=onClose;revision=-1;gameObject.SetActive(true);transform.SetAsLastSibling();Refresh(a);SelectTab(CurrentTab);Fit();}
        public void Refresh(CharacterData a)
        {
            account=a;RefreshCurrencies(CurrencyRow,a,client?.ServerNow??0);
            if(lastAccount==a&&revision==a.Revision){return;}lastAccount=a;revision=a.Revision;if(ExperienceOnly){CloseModal();close?.Invoke();return;}CloseModal();Rebuild();
        }
        public void SelectTab(InventoryTab tab)
        {CurrentTab=tab;CurrentFilter=InventoryFilter.All;SelectedGuid=null;selectedType=null;Grid.verticalNormalizedPosition=1;CloseModal();Rebuild();}
        bool ReadyHero(HeroDefinition d)
        {var h=account.HeroDesk.FirstOrDefault(x=>x.HeroDefinitionId==d.Id);if(h!=null&&h.Stars>=planner.MaxStars)return false;if(h!=null)return planner.HasUpgradeStones(account,h);var r=planner.Rule(d.InitialStars);return account.Inventory.Count(x=>x.ItemId==d.SoulstoneItemId)>=r.SummonStones;}
        void Rebuild()
        {
            if(account==null)return;items.Clear();counts.Clear();rowY.Clear();ownedCards=0;
            if(soulSeparator!=null){soulSeparator.gameObject.SetActive(false);Destroy(soulSeparator.gameObject);soulSeparator=null;}
            foreach(var stack in InventoryCatalog.Stacks(account))
            {var d=catalog.Item(stack.ItemId);if(d.InventoryTab!=CurrentTab||(CurrentFilter!=InventoryFilter.All&&d.InventoryFilter!=CurrentFilter))continue;counts[stack.ItemId]=stack.Amount;items.Add(new Entry{ItemId=stack.ItemId,Id=stack.InstanceIds[0]});}
            float row=CurrentTab==InventoryTab.Shards?145:130;float height;
            if(CurrentTab==InventoryTab.Soulstones)
            {
                items.Clear();var own=catalog.Data.Heroes.Where(d=>account.HeroDesk.Any(h=>h.HeroDefinitionId==d.Id)).OrderByDescending(ReadyHero).ThenBy(d=>d.SourceUnitId).ToArray();
                var missing=catalog.Data.Heroes.Where(d=>!account.HeroDesk.Any(h=>h.HeroDefinitionId==d.Id)).OrderByDescending(ReadyHero).ThenByDescending(d=>account.Inventory.Count(i=>i.ItemId==d.SoulstoneItemId)/(double)planner.Rule(d.InitialStars).SummonStones).ThenBy(d=>d.SourceUnitId).ToArray();
                ownedCards=own.Length;row=166;float separator=Mathf.Ceil(own.Length/(float)Columns)*row+14;float unownedStart=separator+64;
                foreach(var d in own.Concat(missing))
                {int n=items.Count;var members=account.Inventory.Where(i=>i.ItemId==d.SoulstoneItemId).OrderBy(i=>i.Id,StringComparer.Ordinal).ToArray();counts[d.SoulstoneItemId]=members.Length;items.Add(new Entry{ItemId=d.SoulstoneItemId,Id=members.FirstOrDefault()?.Id});rowY.Add(n<ownedCards?n/Columns*row:unownedStart+(n-ownedCards)/Columns*row);}
                if(missing.Length>0)
                {
                    soulSeparator=Box(GridContent,"HeroesNotOwned",0,separator,944,52);var title=Label(soulSeparator,"Title","Heroes Not Owned",Font,210,0,524,52,29);title.color=new Color(.91f,.90f,.84f);
                    var line=Pic(soulSeparator,"Left","common/battle_prepare_lins_1",140,16,130,22);line.rectTransform.localScale=new Vector3(-1,1,1);Pic(soulSeparator,"Right","common/battle_prepare_lins_1",674,16,130,22);
                }
                height=missing.Length>0?unownedStart+Mathf.Ceil(missing.Length/(float)Columns)*row:Mathf.Ceil(own.Length/(float)Columns)*row;
            }
            else
            {var sorted=items.OrderByDescending(x=>catalog.Item(x.ItemId).Quality).ThenBy(x=>catalog.Item(x.ItemId).Name,StringComparer.Ordinal).ToArray();items.Clear();items.AddRange(sorted);for(int n=0;n<items.Count;n++)rowY.Add(n/Columns*row);height=Mathf.Ceil(items.Count/(float)Columns)*row;}
            var choice=items.FirstOrDefault(x=>x.ItemId==selectedType)??items.FirstOrDefault();SelectedGuid=choice?.Id;selectedType=choice?.ItemId;
            for(int n=0;n<tabs.Count;n++)
            {bool active=n==(int)CurrentTab;var t=tabs[n];t.image.sprite=Native(active?"common/battle_prepare_lift_but_4":"common/battle_prepare_lift_but_1");t.image.color=Color.white;
                var text=t.GetComponentInChildren<TextMeshProUGUI>();text.color=active?new Color(.26f,.23f,.21f):new Color(1,.98f,.90f);text.outlineColor=active?new Color(1,.98f,.91f):new Color(.18f,.14f,.12f);
                string[] keys={"package/icon_item","package/icon_fragment","hero/icon_skin","package/icon_soul"};t.transform.Find("Icon").GetComponent<UnityEngine.UI.Image>().sprite=Native(keys[n]+(active?"":"_unavailable"));}
            float viewport=CurrentTab==InventoryTab.Soulstones?700:607;Place((RectTransform)Grid.transform,470,133,951,viewport);GridContent.sizeDelta=new Vector2(0,Mathf.Max(viewport,height));
            Clear(filters);filters.gameObject.SetActive(CurrentTab!=InventoryTab.Soulstones);
            var options=CurrentTab==InventoryTab.Items?new[]{InventoryFilter.All,InventoryFilter.Common,InventoryFilter.Events,InventoryFilter.Precious,InventoryFilter.Cosmetic,InventoryFilter.Develop}:CurrentTab==InventoryTab.Gears?new[]{InventoryFilter.All,InventoryFilter.Forged,InventoryFilter.Primal,InventoryFilter.Scroll}:Array.Empty<InventoryFilter>();
            if(options.Length>0)
            {Pic(filters,"Background","package/bg_sub_tag",147,-8,650,86);float start=(940-options.Length*80)/2;
             for(int n=0;n<options.Length;n++){var f=options[n];var b=NativeButton(filters,"Filter_"+f,f.ToString(),Font,start+n*80+5,0,70,70,()=>{CurrentFilter=f;Grid.verticalNormalizedPosition=1;Rebuild();},f==CurrentFilter?"battle/battle_prepare_shai_xuan_but_2":"battle/battle_prepare_shai_xuan_but_1");var label=b.GetComponentInChildren<TextMeshProUGUI>();label.fontSizeMin=11;label.fontSizeMax=18;label.textWrappingMode=TextWrappingModes.NoWrap;}}
            Board.Find("EmptyState").gameObject.SetActive(items.Count==0);
            if(CurrentTab==InventoryTab.Shards)NativeButton(filters,"QuickCraft","Quick Craft",Font,353,3,240,65,ShowQuickCraft);
            foreach(var c in pool)c.Item=null;DrawCells();DrawDetail();
        }
        void DrawCells()
        {
            if(account==null)return;int start=0;float top=GridContent.anchoredPosition.y;
            while(start<items.Count&&rowY[start]+180<top)start++;
            int count=Math.Min(56,Math.Max(0,items.Count-start));
            while(pool.Count<count)
            {
                var c=new Cell{Root=Box(GridContent,"InventoryCell",w:114,h:160)};var hit=c.Root.gameObject.AddComponent<UnityEngine.UI.Image>();hit.color=Color.clear;
                var b=c.Root.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=hit;b.onClick.AddListener(()=>{if(c.Item==null)return;bool again=selectedType==c.Item.ItemId;SelectedGuid=c.Item.Id;selectedType=c.Item.ItemId;DrawDetail();DrawCells();if(again&&CurrentTab==InventoryTab.Soulstones){var d=planner.StoneHero(c.Item.ItemId);if(ReadyHero(d))Guard(()=>ShowPlan(planner.Stone(account,d.Id,!account.HeroDesk.Any(h=>h.HeroDefinitionId==d.Id)),d.Id,0));}});
                c.ProgressBg=Pic(c.Root,"ProgressBackground","package/bg_progress_bar",1,112,110,20);c.ProgressFill=Pic(c.ProgressBg.transform,"Fill","package/progress_bar1",2,2,106,16);c.ProgressFill.type=UnityEngine.UI.Image.Type.Filled;c.ProgressFill.fillMethod=UnityEngine.UI.Image.FillMethod.Horizontal;
                c.Mark=Pic(c.ProgressBg.transform,"Soulstone","icon/herodetail_soulstone_icon",-9,-4,23,26);c.Progress=Label(c.Root,"Progress","",Font,1,111,110,23,18);c.Progress.outlineColor=new Color(.14f,.11f,.1f);c.Progress.outlineWidth=.15f;
                c.Amount=Label(c.Root,"StackAmount","",Font,35,80,72,28,23);c.Amount.alignment=TextAlignmentOptions.MidlineRight;c.Amount.outlineColor=Color.black;c.Amount.outlineWidth=.15f;
                c.Highlight=Pic(c.Root,"Selection","package/icon_selected",-3,-3,118,118);pool.Add(c);
            }
            for(int n=0;n<pool.Count;n++)
            {
                var c=pool[n];c.Root.gameObject.SetActive(n<count);if(n>=count)continue;int index=start+n;var item=items[index];int col=CurrentTab==InventoryTab.Soulstones&&index>=ownedCards?(index-ownedCards)%Columns:index%Columns;
                Place(c.Root,col*118.5f+2,rowY[index],114,160);
                if(c.Item?.ItemId!=item.ItemId||c.Item?.Id!=item.Id)
                {
                    if(c.Art!=null){c.Art.gameObject.SetActive(false);Destroy(c.Art.gameObject);}c.HeroCard=null;c.Ready=null;
                    if(CurrentTab==InventoryTab.Soulstones)
                    {
                        var d=planner.StoneHero(item.ItemId);var h=account.HeroDesk.FirstOrDefault(x=>x.HeroDefinitionId==d.Id);int stars=h?.Stars??d.InitialStars;
                        c.HeroCard=ZatodFormationView.CreateCard(c.Root,"HeroCard",110,Font);c.Art=c.HeroCard.Root;c.HeroCard.Button.enabled=false;foreach(var im in c.Art.GetComponentsInChildren<UnityEngine.UI.Image>())im.raycastTarget=false;
                        c.HeroCard.Portrait.sprite=ZatodFormationView.Art("Portraits/"+d.Id)??Art("Items/"+d.SoulstoneItemId);c.HeroCard.Portrait.color=h==null&&!ReadyHero(d)?new Color(.30f,.30f,.30f):Color.white;
                        c.HeroCard.Frame.sprite=ZatodFormationView.Art("hero_icon_frame_"+(h==null?1:Rank(h,catalog)));c.HeroCard.Frame.color=h==null&&!ReadyHero(d)?new Color(.48f,.48f,.48f):Color.white;
                        c.HeroCard.Level.text=h==null?"":h.Level.ToString();c.Art.Find("Icon/LevelBackground").gameObject.SetActive(h!=null);
                        for(int k=0;k<c.HeroCard.Stars.Length;k++){c.HeroCard.Stars[k].gameObject.SetActive(k<stars);Place(c.HeroCard.Stars[k].rectTransform,(108-stars*17)/2+k*17,86,17,17);c.HeroCard.Stars[k].color=h==null&&!ReadyHero(d)?new Color(.48f,.48f,.48f):Color.white;}
                        if(ReadyHero(d))
                        {c.Ready=DrawSoulstoneReady(c.HeroCard,Font,h==null?"Recruit":"Star-Up");}
                    }
                    else
                    {c.Art=ZatodEquipmentView.ItemIcon(c.Root,"Item",catalog.Item(item.ItemId),1,0,110);if(CurrentTab==InventoryTab.Shards){var r=catalog.Data.CraftRecipes.FirstOrDefault(x=>x.Ingredients.Count==1&&x.Ingredients[0].ItemId==item.ItemId);if(r!=null&&counts[item.ItemId]>=r.Ingredients[0].Amount)c.Ready=Pic(c.Art,"CraftReady","package/selected",13,49,70,60);}}
                    c.Item=item;
                }
                c.Highlight.sprite=Native(CurrentTab==InventoryTab.Soulstones?"package/hero_selected":CurrentTab==InventoryTab.Shards?"package/fragment_selected":"package/icon_selected");c.Highlight.gameObject.SetActive(item.ItemId==selectedType);c.Highlight.transform.SetAsLastSibling();
                c.Amount.text=CurrentTab==InventoryTab.Items||CurrentTab==InventoryTab.Gears?counts[item.ItemId]>1?counts[item.ItemId].ToString():"":"";c.Amount.transform.SetAsLastSibling();
                c.ProgressBg.gameObject.SetActive(CurrentTab==InventoryTab.Shards||CurrentTab==InventoryTab.Soulstones);c.Mark.gameObject.SetActive(CurrentTab==InventoryTab.Soulstones);c.Progress.text="";
                if(CurrentTab==InventoryTab.Shards)
                {var r=catalog.Data.CraftRecipes.FirstOrDefault(x=>x.Ingredients.Count==1&&x.Ingredients[0].ItemId==item.ItemId);if(r!=null){c.Progress.text=counts[item.ItemId]+"/"+r.Ingredients[0].Amount;c.ProgressFill.sprite=Native("package/progress_bar1");c.ProgressFill.fillAmount=Mathf.Clamp01((float)counts[item.ItemId]/r.Ingredients[0].Amount);}}
                else if(CurrentTab==InventoryTab.Soulstones)
                {var d=planner.StoneHero(item.ItemId);var h=account.HeroDesk.FirstOrDefault(x=>x.HeroDefinitionId==d.Id);c.ProgressFill.sprite=Native("package/progress_bar2");if(h!=null&&h.Stars>=planner.MaxStars){c.Progress.text=counts[item.ItemId].ToString();c.ProgressFill.fillAmount=0;}else{var r=planner.Rule(h==null?d.InitialStars:h.Stars+1);int need=h==null?r.SummonStones:r.UpgradeStones;c.Progress.text=counts[item.ItemId]+"/"+need;c.ProgressFill.fillAmount=Mathf.Clamp01((float)counts[item.ItemId]/need);}}
                c.ProgressBg.transform.SetAsLastSibling();c.Progress.transform.SetAsLastSibling();
            }
        }
        void DrawDetail()
        {
            Clear(actions);if(detailIcon!=null){detailIcon.gameObject.SetActive(false);Destroy(detailIcon.gameObject);}Clear(DetailContent);UnitPrice.text="";
            var selected=account.Inventory.FirstOrDefault(x=>x.Id==SelectedGuid);var item=selected!=null?catalog.Item(selected.ItemId):CurrentTab==InventoryTab.Soulstones&&!string.IsNullOrEmpty(selectedType)?catalog.Item(selectedType):null;
            if(item==null){Title.text="";Owned.text="";Description=Label(DetailContent,"Description","No items",Font,0,0,309,60,23,true);return;}
            detailIcon=ZatodEquipmentView.ItemIcon(Detail,"SelectedItem",item,106,20,152);Title.text=item.Name;int amount=account.Inventory.Count(x=>x.ItemId==item.DefinitionId);Owned.text="Owned: <color=#276CD0>"+amount+"</color>";
            float y=0;int n=0;foreach(var stat in item.PreciseStats.Where(x=>x.Value!=0))
            {var row=Pic(DetailContent,"Stat_"+stat.StatId,"hero/equip/equip_prop_bg_"+(1+n%2),0,y,309,42);var label=Label(row.transform,"Name",ZatodHeroDetailView.StatName(stat.StatId),Font,12,0,208,42,23,true);label.alignment=TextAlignmentOptions.MidlineLeft;var value=Label(row.transform,"Value","+"+stat.Value.ToString("0.##",System.Globalization.CultureInfo.InvariantCulture),Font,221,0,80,42,23,true);value.alignment=TextAlignmentOptions.MidlineRight;y+=42;n++;}
            string description=string.Join("\n",new[]{item.Description,item.Comment}.Where(x=>!string.IsNullOrEmpty(x)));if(item.HeroExpValue>0)description="Hero EXP +"+item.HeroExpValue+"\n\n"+description;
            Description=Label(DetailContent,"Description",description,Font,0,y+(n>0?16:0),309,160,23,true);Description.alignment=TextAlignmentOptions.TopLeft;Description.textWrappingMode=TextWrappingModes.Normal;Description.overflowMode=TextOverflowModes.Overflow;Description.enableAutoSizing=false;
            float dh=Mathf.Max(36,Description.GetPreferredValues(description,309,10000).y);Description.rectTransform.sizeDelta=new Vector2(309,dh);y+=dh+(n>0?28:8);
            var sources=campaign.Data.Chapters.SelectMany(c=>c.Stages).Where(st=>st.DropItems.Any(d=>d.ItemId==item.DefinitionId)).ToArray();
            if(sources.Length>0)
            {Pic(DetailContent,"SourceIcon","package/source",0,y,25,25);var source=Label(DetailContent,"SourceLabel","Source",Font,31,y-2,200,34,24,true);source.alignment=TextAlignmentOptions.MidlineLeft;y+=40;
             foreach(var stage in sources){bool unlocked=campaign.IsUnlocked(stage.Id,client?.Snapshot?.Cleared??new List<string>());var row=Pic(DetailContent,"Source_"+stage.Id,"package/access_"+(unlocked?"normal":"unlock"),0,y,309,64);var label=Label(row.transform,"Stage",stage.Name,Font,15,3,225,58,21,true);label.alignment=TextAlignmentOptions.MidlineLeft;if(unlocked)Pic(row.transform,"Arrow","package/access_arrow",270,15,23,31);else Label(row.transform,"Locked","Not\nAvailable",Font,243,7,60,50,15,true);y+=70;}}
            DetailContent.sizeDelta=new Vector2(0,Mathf.Max(324,y+12));DetailScroll.verticalNormalizedPosition=1;
            if(CurrentTab==InventoryTab.Soulstones)return; // Hero cards perform Recruit/Star Up; left panel follows Crystal.
            bool sell=item.SellPrice>0;bool recipe=false;var craft=catalog.Data.CraftRecipes.FirstOrDefault(x=>x.OutputItemId==item.DefinitionId||x.Ingredients.Count==1&&x.Ingredients[0].ItemId==item.DefinitionId);recipe=craft!=null;
            if(sell){Pic(actions,"Gold","common/goldicon_small",95,-45,28,28);UnitPrice.text=item.SellPrice.ToString();UnitPrice.color=new Color(.76f,.46f,.06f);UnitPrice.outlineWidth=.12f;UnitPrice.outlineColor=new Color(1,.98f,.91f);}
            bool use=item.HeroExpValue>0;bool secondary=use||recipe;
            if(sell)NativeButton(actions,"Sell","Sell",Font,secondary?0:87,0,168,59,()=>Guard(()=>ShowSell()));
            if(use)NativeButton(actions,"Use","Use",Font,sell?178:87,0,168,59,ShowHeroPicker);
            else if(recipe)NativeButton(actions,"Recipe",CurrentTab==InventoryTab.Shards?"Craft":"Recipe",Font,sell?178:87,0,168,59,()=>OnRecipe?.Invoke(craft.OutputItemId));
        }
        public Action<string> OnRecipe;
        void Guard(Action action){try{action();}catch(Exception e){Notice.text=e.Message;if(modalMessage!=null)modalMessage.text=e.Message;}}
        void CloseModal(){if(modal!=null){modal.gameObject.SetActive(false);Destroy(modal.gameObject);modal=null;}modalMessage=null;modalConfirm=null;}
        RectTransform NewModal(string title,float width=1000,float height=660)
        {
            CloseModal();modal=Box(Board,"InventoryModal",0,0,1600,900);var hit=modal.gameObject.AddComponent<UnityEngine.UI.Image>();hit.color=Color.clear;hit.raycastTarget=true;
            var dim=Box(modal,"Dim");var dimImage=dim.gameObject.AddComponent<UnityEngine.UI.Image>();dimImage.color=new Color(0,0,0,.72f);dimImage.raycastTarget=true;
            var canvas=GetComponentInParent<Canvas>();var corners=new Vector3[4];((RectTransform)canvas.transform).GetWorldCorners(corners);var lo=(Vector2)modal.InverseTransformPoint(corners[0]);var hi=(Vector2)modal.InverseTransformPoint(corners[2]);dim.anchorMin=dim.anchorMax=dim.pivot=Vector2.zero;dim.anchoredPosition=lo-modal.rect.min;dim.sizeDelta=hi-lo;
            var panel=Pic(modal,"Panel","package/bg_normal",(1600-width)/2,(900-height)/2,width,height).rectTransform;
            Pic(panel,"Frame","battle/battle_prepare_9bg_big",0,0,width,height);Label(panel,"Title",title,Font,50,20,width-100,54,32,true);
            var closeButton=NativeButton(panel,"Close","",Font,width-74,0,70,70,()=>{CloseModal();if(ExperienceOnly)close?.Invoke();},"common/break_butt_bj");Pic(closeButton.transform,"CloseIcon","common/butt_off",14,14,42,42);
            modalMessage=Label(panel,"Message","",Font,35,height-126,width-70,42,22,true);return panel;
        }
        public void ShowSell(int amount=1)
        {
            var selected=account.Inventory.FirstOrDefault(x=>x.Id==SelectedGuid);if(selected==null)return;var item=catalog.Item(selected.ItemId);int max=account.Inventory.Count(x=>x.ItemId==item.DefinitionId);amount=Math.Clamp(amount,1,max);
            var plan=planner.Sell(account,SelectedGuid,amount);var panel=NewModal("Sell "+item.Name,860,530);ZatodEquipmentView.ItemIcon(panel,"SellItem",item,375,92,110);
            Label(panel,"Owned","Owned: "+max,Font,200,205,460,42,24,true);Label(panel,"SaleAmount","Amount",Font,200,250,460,42,24,true);
            int current=amount;
            NativeButton(panel,"Minus","−",Font,210,300,65,65,()=>ShowSell(current-1),"package/btn_package1");
            Pic(panel,"AmountBackground","package/bg_soldout",290,300,190,65);Label(panel,"Amount",amount.ToString(),Font,290,300,190,65,28);
            NativeButton(panel,"Plus","+",Font,495,300,65,65,()=>ShowSell(current+1),"package/btn_package1");NativeButton(panel,"Max","Max",Font,590,300,140,65,()=>ShowSell(max));
            modalMessage.text="Receive: "+plan.GoldReward+" Gold";modalConfirm=NativeButton(panel,"Confirm","Sell",Font,280,435,300,76,()=>{if(!client.ItemOperationBusy)client.InventoryAction("sell",SelectedGuid,current,InventoryCatalog.Signature(plan));});
        }
        void ShowPlan(InventoryPlan p,string target,int level)
        {
            var panel=NewModal(p.Command=="sell"?"Sell item":p.Command=="recruit"?"Recruit Hero":p.Command=="star_up"?"Star Up":"Confirm");
            var content=Scroll(panel,"PlanScroll",out var rows);Place((RectTransform)content.transform,36,94,928,360);
            var groups=p.Consumed.GroupBy(x=>x.ItemId).ToArray();int n=0;
            foreach(var g in groups){ZatodEquipmentView.ItemIcon(rows,"Consume_"+g.Key,catalog.Item(g.Key),8,n*100,82);Label(rows,"Amount_"+g.Key,catalog.Item(g.Key).Name+" × "+g.Count(),Font,108,n*100,770,85,24,true);n++;}
            foreach(var output in p.Outputs){Label(rows,"Output_"+output.ItemId,"Receive: "+catalog.Item(output.ItemId).Name+" × "+output.Amount,Font,10,n++*100,890,85,24,true);}
            rows.sizeDelta=new Vector2(0,n*100);modalMessage.text=p.GoldReward>0?"Receive "+p.GoldReward+" Gold":"Cost: "+p.GoldCost+" Gold";
            modalConfirm=NativeButton(panel,"Confirm","Confirm",Font,350,563,300,76,()=>{if(client.ItemOperationBusy)return;client.InventoryAction(p.Command,target,level,InventoryCatalog.Signature(p));});
        }
        void ShowQuickCraft()
        {
            var recipes=catalog.Data.CraftRecipes.Where(r=>r.Ingredients.Count==1&&catalog.Item(r.Ingredients[0].ItemId).ItemKind==ItemKind.Fragment&&account.Inventory.Count(x=>x.ItemId==r.Ingredients[0].ItemId)>=r.Ingredients[0].Amount).ToArray();
            if(recipes.Length==0){Notice.text="Not enough fragments";return;}
            var chosen=new HashSet<string>(recipes.Select(x=>x.Id));var panel=NewModal("Quick Craft");
            var scroll=Scroll(panel,"Recipes",out var rows);Place((RectTransform)scroll.transform,35,94,930,350);
            Action refresh=()=>{var p=planner.QuickCraft(account,chosen);modalMessage.text="Cost: "+p.GoldCost+" Gold";};
            var marks=new Dictionary<string,UnityEngine.UI.Image>(StringComparer.Ordinal);
            for(int n=0;n<recipes.Length;n++)
            {
                var r=recipes[n];int have=account.Inventory.Count(x=>x.ItemId==r.Ingredients[0].ItemId);int amount=have/r.Ingredients[0].Amount;
                var cell=Box(rows,"Choose_"+r.Id,12+n%7*130,n/7*154,122,150);var hit=cell.gameObject.AddComponent<UnityEngine.UI.Image>();hit.color=Color.clear;hit.raycastTarget=true;var b=cell.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=hit;
                ZatodEquipmentView.ItemIcon(cell,"Fragment",catalog.Item(r.Ingredients[0].ItemId),5,0,110);
                var mark=Pic(cell,"Selected","package/selected",16,10,88,88);marks.Add(r.Id,mark);
                var bar=Pic(cell,"Progress","package/bg_progress_bar",2,112,118,22);var fill=Pic(bar.transform,"Fill","package/progress_bar1",2,2,114,18);fill.type=UnityEngine.UI.Image.Type.Filled;fill.fillMethod=UnityEngine.UI.Image.FillMethod.Horizontal;fill.fillAmount=1;
                Label(cell,"Amount",have+"/"+r.Ingredients[0].Amount,Font,2,112,118,22,18);
                Label(cell,"Output","Receive x"+amount,Font,0,134,122,24,18,true);
                b.onClick.AddListener(()=>{if(!chosen.Remove(r.Id))chosen.Add(r.Id);mark.gameObject.SetActive(chosen.Contains(r.Id));if(chosen.Count>0)refresh();else modalMessage.text="Select fragment types";});
            }
            rows.sizeDelta=new Vector2(0,Mathf.Ceil(recipes.Length/7f)*154);refresh();
            NativeButton(panel,"SelectAll","All / None",Font,35,563,270,76,()=>{bool all=chosen.Count==recipes.Length;chosen.Clear();if(!all)foreach(var r in recipes)chosen.Add(r.Id);foreach(var pair in marks)pair.Value.gameObject.SetActive(!all);if(chosen.Count>0)refresh();else modalMessage.text="Select fragment types";});
            modalConfirm=NativeButton(panel,"Preview","Preview",Font,560,563,300,76,()=>Guard(()=>{var p=planner.QuickCraft(account,chosen);ShowPlan(p,p.TargetId,0);}));
        }
        public void ShowStarUpgrade(string heroId)
        {
            var h=account.HeroDesk.Single(x=>x.HeroInstanceId==heroId);var d=catalog.Hero(h.HeroDefinitionId);var panel=NewModal("Star Up",860,530);
            if(h.Stars>=planner.MaxStars){modalMessage.text="Maximum stars reached";return;}
            var rule=planner.Rule(h.Stars+1);int have=account.Inventory.Count(x=>x.ItemId==d.SoulstoneItemId);
            Label(panel,"HeroName",d.Name+" · "+h.Stars+" → "+(h.Stars+1)+" stars",Font,60,100,740,55,30,true);
            ZatodEquipmentView.ItemIcon(panel,"Soulstone",catalog.Item(d.SoulstoneItemId),375,175,110);
            Label(panel,"Required",have+" / "+rule.UpgradeStones+" Soulstones",Font,100,300,660,45,26,true);
            modalMessage.text="Cost: "+rule.UpgradeGold+" Gold";
            modalConfirm=NativeButton(panel,"ConfirmStar","Star Up",Font,280,435,300,76,()=>Guard(()=>{var plan=planner.Stone(account,d.Id,false);client.InventoryAction("star_up",d.Id,0,InventoryCatalog.Signature(plan));}));
            if(have<rule.UpgradeStones||CurrencyBalance.GetGold(account)<rule.UpgradeGold){modalMessage.text=have<rule.UpgradeStones?"Not enough Soulstones":"Not enough gold";modalConfirm.interactable=false;modalConfirm.name="Unavailable";}
        }
        public void ShowHeroPicker()
        {
            var panel=NewModal("Choose Hero");var scroll=Scroll(panel,"Heroes",out var rows);Place((RectTransform)scroll.transform,40,94,920,465);
            int n=0;foreach(var h in account.HeroDesk){var hero=h;NativeButton(rows,"Hero_"+h.HeroInstanceId,catalog.Hero(h.HeroDefinitionId).Name+" · Lv "+h.Level,Font,20,n++*80,860,72,()=>ShowExp(hero.HeroInstanceId));}rows.sizeDelta=new Vector2(0,n*80);
        }
        public void ShowExp(string heroId,int target=0)
        {
            var h=account.HeroDesk.Single(x=>x.HeroInstanceId==heroId);var progression=ProgressionDataJson.LoadBundled();int cap=progression.Player(account.Level).MaxHeroLevel;
            if(target==0)
            {
                long available=0;foreach(var item in account.Inventory){var d=catalog.Item(item.ItemId);if(d.ItemKind==ItemKind.Consumable&&d.HeroExpValue>0)available=checked(available+d.HeroExpValue);}
                long exp=checked(h.Exp+available);target=h.Level;
                while(target<cap&&progression.Hero(target).NextLevelExp>0&&exp>=progression.Hero(target).NextLevelExp){exp-=progression.Hero(target).NextLevelExp;target++;}
                if(target<=h.Level)target=h.Level+1;
            }
            InventoryPlan plan=null;string error="";
            try{plan=planner.Exp(account,heroId,target,progression);target=plan.TargetLevel;}catch(Exception e){error=e.Message;}
            var panel=NewModal("Level Up",860,530);var main=Pic(panel,"HeroAndTarget","scale9/box_bg",22,100,816,168).rectTransform;
            var portrait=Picture(main,"Portrait","Portraits/"+h.HeroDefinitionId,18,12,144,144,aspect:true);
            if(portrait.sprite==null)portrait.sprite=Resources.Load<Sprite>("Zatod/UI/StagePreview/Items/"+catalog.Hero(h.HeroDefinitionId).SoulstoneItemId);
            Label(main,"CurrentLevel","Lv "+h.Level,Font,20,126,140,32,22);
            Label(main,"TargetLabel","Target Level",Font,220,4,300,42,25,true);
            int t=target;
            NativeButton(main,"Minus","−",Font,230,62,62,62,()=>ShowExp(heroId,Math.Max(h.Level+1,t-1)),"package/btn_package1");
            Pic(main,"TargetBackground","package/bg_soldout",305,62,140,62);Label(main,"Target",target.ToString(),Font,305,62,140,62,28);
            NativeButton(main,"Plus","+",Font,458,62,62,62,()=>ShowExp(heroId,Math.Min(cap,t+1)),"package/btn_package1");
            modalConfirm=NativeButton(main,"Use","Use",Font,560,62,225,76,()=>{if(plan!=null&&!client.ItemOperationBusy)client.InventoryAction("use_exp",heroId,plan.TargetLevel,InventoryCatalog.Signature(plan));});modalConfirm.interactable=plan!=null;
            Label(panel,"Consumes","Consumes",Font,260,280,340,44,25,true);
            if(plan!=null)
            {var groups=plan.Consumed.GroupBy(x=>x.ItemId).ToArray();for(int n=0;n<groups.Length;n++){float x=430+(n-(groups.Length-1)/2f)*126-55;ZatodEquipmentView.ItemIcon(panel,"Exp_"+groups[n].Key,catalog.Item(groups[n].Key),x,340,110);Label(panel,"Count_"+n,"× "+groups[n].Count(),Font,x,452,110,34,24,true);}}
            else modalMessage.text=error;
        }
        void Update()
        {
            Fit();if(client==null)return;RefreshCurrencies(CurrencyRow,account,client.ServerNow);
            if(lastStatus!=client.Status){lastStatus=client.Status;Notice.text=client.ItemOperationBusy?"Updating items...":client.Status.StartsWith("Connected")||!client.Connected?"":client.Status;}
            if(modalConfirm!=null)modalConfirm.interactable=modalConfirm.name!="Unavailable"&&!client.ItemOperationBusy&&client.Connected&&!(modalConfirm.name=="Use"&&modalMessage!=null&&!string.IsNullOrEmpty(modalMessage.text));
        }
        void Fit()
        {
            var root=(RectTransform)transform;var size=root.rect.size;
            if(size!=lastSize){lastSize=size;Board.anchoredPosition=Vector2.zero;Board.localScale=Vector3.one*Mathf.Max(.1f,Mathf.Min(size.x/1600,size.y/900));}
            var canvas=GetComponentInParent<Canvas>();if(canvas==null)return;var corners=new Vector3[4];((RectTransform)canvas.transform).GetWorldCorners(corners);
            FitCanvas((RectTransform)transform.Find("Background"),root,corners);
            if(modal!=null){var dim=modal.Find("Dim") as RectTransform;if(dim!=null)FitCanvas(dim,modal,corners);}
        }
        static void FitCanvas(RectTransform rect,RectTransform parent,Vector3[] corners)
        {
            var lo=(Vector2)parent.InverseTransformPoint(corners[0]);var hi=(Vector2)parent.InverseTransformPoint(corners[2]);rect.anchorMin=rect.anchorMax=rect.pivot=Vector2.zero;rect.anchoredPosition=lo-parent.rect.min;rect.sizeDelta=hi-lo;
        }
    }
}
