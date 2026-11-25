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
    public sealed class ZatodEquipmentView:MonoBehaviour
    {
        public TMP_FontAsset Font;
        public RectTransform Group,Left,Right,Stats,Tree,IngredientRow;
        public ScrollRect StatsScroll,SourceScroll;
        public GameObject CraftDecoration;
        public readonly List<RectTransform> SourceCells=new List<RectTransform>();
        public bool SourcesVisible=>SourceScroll!=null && SourceScroll.gameObject.activeSelf;
        public TextMeshProUGUI ItemName,Owned,Requirement,Remark,Message,TreeName,Cost,RecipeTitle;
        public UnityEngine.UI.Button Close,RecipeButton,ActionButton,CraftButton,TreeBack;
        public bool RecipeVisible=>Right.gameObject.activeSelf;
        public string DisplayedItemId {get;private set;}
        public string CurrentTreeItem=>history.Count>0?history[history.Count-1]:DisplayedItemId;
        public readonly List<UnityEngine.UI.Button> IngredientButtons=new List<UnityEngine.UI.Button>();
        HeroCatalog catalog;CharacterData account;ZatodConnection connection;HeroData hero;string heroId,slotId;
        CampaignCatalog campaign;readonly List<string> history=new List<string>();CraftingCatalog crafting;bool equipped;bool inventoryContext;
        int context;int equipContext;string equipOperation,equipGuid;
        RectTransform icon,sourceIcon;Vector2 lastSize;int lastHistory=-1;
        public const string ArtPath="Zatod/UI/Crafting/";
        public static Sprite Native(string key)=>Resources.Load<Sprite>(ArtPath+key) ?? ZatodInventoryView.Native(key);
        void Awake()
        {
            Close.onClick.AddListener(Hide);RecipeButton.onClick.AddListener(ToggleRecipe);ActionButton.onClick.AddListener(Act);CraftButton.onClick.AddListener(Craft);
            TreeBack.onClick.AddListener(()=>{if(history.Count>1){history.RemoveAt(history.Count-1);DrawTree();}else ToggleRecipe();});
        }
        public void Open(HeroCatalog definitions,CharacterData owned,ZatodConnection client,CampaignCatalog stages,string ownedHeroId,string slot)
        {
            context++;equipOperation=null;inventoryContext=false;catalog=definitions;account=owned;connection=client;campaign=stages;heroId=ownedHeroId;slotId=slot;crafting=new CraftingCatalog(catalog);history.Clear();Right.gameObject.SetActive(false);Message.text="";
            gameObject.SetActive(true);transform.SetAsLastSibling();Refresh(owned);Fit();
        }
        public void OpenItem(HeroCatalog definitions,CharacterData owned,ZatodConnection client,CampaignCatalog stages,string itemId)
        {
            context++;equipOperation=null;inventoryContext=true;catalog=definitions;account=owned;connection=client;campaign=stages;crafting=new CraftingCatalog(catalog);hero=null;DisplayedItemId=itemId;history.Clear();history.Add(itemId);Right.gameObject.SetActive(true);gameObject.SetActive(true);transform.SetAsLastSibling();Refresh(owned);
        }
        public void Hide(){context++;equipOperation=null;gameObject.SetActive(false);history.Clear();}
        static void ClearChildren(Transform root){foreach(Transform c in root){c.gameObject.SetActive(false);Destroy(c.gameObject);}}
        public void Refresh(CharacterData owned)
        {
            account=owned;
            if(!inventoryContext && equipOperation!=null && equipContext==context && gameObject.activeSelf)
            {
                var receipt=account.ItemOperations?.SingleOrDefault(r=>r.OperationId==equipOperation && r.Command=="equip" && r.HeroId==heroId && r.SlotId==slotId && r.ItemInstanceId==equipGuid);
                var equippedNow=account.HeroDesk.SingleOrDefault(h=>h.HeroInstanceId==heroId)?.EquippedItems.SingleOrDefault(i=>i.SlotId==slotId);
                if(receipt!=null && equippedNow?.Id==equipGuid){Hide();return;}
            }
            if(inventoryContext){RefreshInventoryItem();return;}hero=account.HeroDesk.SingleOrDefault(h=>h.HeroInstanceId==heroId);if(hero==null){Hide();return;}
            var slot=HeroProgression.CurrentRank(hero,catalog).EquipmentSlots.SingleOrDefault(s=>s.Id==slotId);if(slot==null){Hide();return;}
            var current=hero.EquippedItems.SingleOrDefault(i=>i.SlotId==slotId);equipped=current!=null;DisplayedItemId=current?.ItemId??slot.RequiredItemId;var item=catalog.Item(DisplayedItemId);
            if(icon!=null){icon.gameObject.SetActive(false);Destroy(icon.gameObject);}icon=ItemIcon(Left,"SelectedItem",item,178,28,164);
            ItemName.text=item.Name;Owned.text="Owned: "+account.Inventory.Count(i=>i.ItemId==DisplayedItemId);Requirement.text="Required hero level: "+item.LevelRequirement;
            Remark.text=equipped?"Equipped":hero.Level<item.LevelRequirement?"Hero level is too low":"Binds to this hero when equipped";
            ClearChildren(Stats);var stats=new Dictionary<string,double>();foreach(var stat in item.PreciseStats)stats[stat.StatId]=stat.Value;
            foreach(var stat in item.Stats)if(!stats.ContainsKey(stat.StatId))stats[stat.StatId]=stat.Value;
            int n=0;foreach(var stat in stats.Where(s=>Math.Abs(s.Value)>.000001))
            {
                var row=NativePicture(Stats,"Stat_"+stat.Key,"hero/equip/equip_prop_bg_"+(1+n%2),0,n*54,460,54);var label=Text(row.transform,"Name",ZatodHeroDetailView.StatName(stat.Key),Font,27);Place(label.rectTransform,20,2,318,50);label.color=new Color(.23f,.18f,.13f);
                var value=Text(row.transform,"Amount","+"+stat.Value.ToString("0.##",System.Globalization.CultureInfo.InvariantCulture),Font,27);value.color=new Color(.10f,.37f,.05f);Place(value.rectTransform,335,2,107,50);value.alignment=TextAlignmentOptions.MidlineRight;n++;
            }
            if(n==0){var label=Text(Stats,"MaterialNote",item.ItemKind==ItemKind.Fragment?"Equipment fragment":"Crafting material",Font,26);Place(label.rectTransform,10,5,440,55);label.color=new Color(.3f,.26f,.2f);n++;}
            Stats.sizeDelta=new Vector2(0,Mathf.Max(285,n*54));
            bool has=account.Inventory.Any(i=>i.ItemId==DisplayedItemId);SetCaption(ActionButton,equipped?"OK":has?"Equip":crafting.ForItem(DisplayedItemId)!=null?"Recipe":"Get Way");ActionButton.interactable=!connection.ItemOperationBusy;
            if(RecipeVisible)DrawTree();else Fit();
            Message.text=connection.ItemOperationBusy?"Updating items...":connection.Status.StartsWith("Connected")?"":connection.Status;
        }
        void RefreshInventoryItem()
        {
            var item=catalog.Item(DisplayedItemId);if(icon!=null){icon.gameObject.SetActive(false);Destroy(icon.gameObject);}icon=ItemIcon(Left,"SelectedItem",item,178,28,164);
            ItemName.text=item.Name;Owned.text="Owned: "+account.Inventory.Count(x=>x.ItemId==DisplayedItemId);Requirement.text="Required hero level: "+item.LevelRequirement;Remark.text=item.Description;
            ClearChildren(Stats);SetCaption(ActionButton,"Close");Message.text=connection.ItemOperationBusy?"Updating items...":connection.Status.StartsWith("Connected")?"":connection.Status;DrawTree();
        }
        void ToggleRecipe()
        {Right.gameObject.SetActive(!RecipeVisible);if(RecipeVisible){history.Clear();history.Add(DisplayedItemId);DrawTree();}Fit();}
        void Act()
        {
            if(inventoryContext){Hide();return;}if(connection.ItemOperationBusy)return;if(equipped){Hide();return;}
            var item=account.Inventory.OrderBy(i=>i.Id,StringComparer.Ordinal).FirstOrDefault(i=>i.ItemId==DisplayedItemId);
            if(item==null){if(!RecipeVisible)ToggleRecipe();return;}
            if(hero.Level<catalog.Item(item.ItemId).LevelRequirement){Message.text="Requires hero level "+catalog.Item(item.ItemId).LevelRequirement;return;}
            connection.Equip(heroId,slotId,item.Id);
            if(connection.ItemOperationBusy){equipOperation=connection.PendingItemOperationId;equipGuid=item.Id;equipContext=context;}
        }
        void Craft()
        {
            var recipe=crafting.ForItem(CurrentTreeItem);if(recipe==null){if(history.Count>1){history.RemoveAt(history.Count-1);DrawTree();}else ToggleRecipe();return;}
            if(connection.ItemOperationBusy)return;
            if(!crafting.CanCraft(account,recipe.Id)){Message.text=CurrencyBalance.GetGold(account)<recipe.GoldCost?"Not enough gold":"Not enough ingredients";return;}connection.Craft(recipe.Id);
        }
        void DrawTree()
        {
            if(history.Count==0)history.Add(DisplayedItemId);ClearChildren(Tree);IngredientButtons.Clear();SourceCells.Clear();ClearChildren(SourceScroll.content);
            if(sourceIcon!=null){sourceIcon.gameObject.SetActive(false);Destroy(sourceIcon.gameObject);}
            string itemId=CurrentTreeItem;var item=catalog.Item(itemId);TreeName.text=item.Name;var recipe=crafting.ForItem(itemId);SetCaption(CraftButton,recipe==null?"Back":"Craft");CraftButton.interactable=!connection.ItemOperationBusy;Cost.transform.parent.gameObject.SetActive(recipe!=null);
            bool sources=recipe==null;CraftDecoration.SetActive(!sources);Tree.gameObject.SetActive(!sources);SourceScroll.gameObject.SetActive(sources);RecipeTitle.text=sources?"Available from":"Crafting formula";
            Place(TreeName.rectTransform,sources?150:90,50,sources?405:440,50);
            if(sources)
            {
                sourceIcon=ItemIcon(Right,"SourceItem",item,80,36,70);DrawSources(itemId);return;
            }
            ItemIcon(Tree,"Product",item,222,6,144);Cost.text=recipe.GoldCost.ToString("N0");Cost.color=CurrencyBalance.GetGold(account)<recipe.GoldCost?new Color(1,.35f,.25f):new Color(.75f,.46f,.06f);
            var needs=CraftingCatalog.Requirements(recipe).ToArray();float gap=Mathf.Min(96,480f/Math.Max(1,needs.Length));
            for(int n=0;n<needs.Length;n++)
            {
                var ingredient=needs[n];float x=294+(n-(needs.Length-1)/2f)*gap-42;var button=Box(Tree,"Ingredient_"+ingredient.Key,x,270,84,84).gameObject.AddComponent<UnityEngine.UI.Button>();
                var art=ItemIcon((RectTransform)button.transform,"Item",catalog.Item(ingredient.Key),0,0,84);button.targetGraphic=art.GetComponent<UnityEngine.UI.Image>();var hit=button.gameObject.AddComponent<UnityEngine.UI.Image>();hit.color=Color.clear;button.targetGraphic=hit;
                button.onClick.AddListener(()=>{history.Add(ingredient.Key);DrawTree();});IngredientButtons.Add(button);
                int have=account.Inventory.Count(i=>i.ItemId==ingredient.Key);var count=Text(Tree,"Amount_"+ingredient.Key,have+"/"+ingredient.Value,Font,29);Place(count.rectTransform,x-9,354,102,44);count.alignment=TextAlignmentOptions.Center;count.color=have<ingredient.Value?new Color(1,.42f,.42f):new Color(1,.98f,.9f);
            }
        }
        void DrawSources(string itemId)
        {
            int chapterNumber=0,count=0;var cleared=connection?.Snapshot?.Cleared ?? new List<string>();
            if(campaign!=null)foreach(var chapter in campaign.Data.Chapters)
            {
                chapterNumber++;
                foreach(var stage in chapter.Stages.Where(s=>s.DropItems.Any(d=>d.ItemId==itemId)))
                {
                    bool unlocked=campaign.StageLockReason(stage.Id,account.Level,cleared)==null;
                    var cell=NativePicture(SourceScroll.content,"Source_"+stage.Id,"package/access_"+(unlocked?"normal":"unlock"),10,count*100,529,92).rectTransform;
                    var marker=Box(cell,"StageIcon",12,8,76,76).gameObject.AddComponent<UnityEngine.UI.Image>();marker.sprite=ZatodStageVisuals.Icon(stage,unlocked);marker.preserveAspect=true;marker.raycastTarget=false;
                    var title=Text(cell,"StageName",ZatodStageVisuals.SourceLabel(chapterNumber,stage),Font,26);Place(title.rectTransform,101,6,316,80);title.alignment=TextAlignmentOptions.MidlineLeft;title.textWrappingMode=TextWrappingModes.NoWrap;title.color=new Color(.263f,.224f,.204f);
                    if(unlocked)NativePicture(cell,"Arrow","package/access_arrow",479,23,37,47);
                    else{var locked=Text(cell,"Locked",!stage.KeyStage && cleared.Contains(stage.Id)?"Passed":account.Level<chapter.RequiredAccountLevel?"Lv"+chapter.RequiredAccountLevel:"Locked",Font,22);Place(locked.rectTransform,424,6,96,80);locked.alignment=TextAlignmentOptions.Center;locked.color=new Color(.38f,.33f,.29f);}
                    // Source rows are deliberately display-only in this phase: no Button or click handler.
                    SourceCells.Add(cell);count++;
                }
            }
            if(count==0){var empty=Text(SourceScroll.content,"NoSources","No sources available.",Font,27);Place(empty.rectTransform,18,75,516,75);empty.alignment=TextAlignmentOptions.Center;}
            SourceScroll.content.sizeDelta=new Vector2(0,Mathf.Max(380,count*100));SourceScroll.StopMovement();SourceScroll.content.anchoredPosition=Vector2.zero;
        }
        void LateUpdate(){Fit();}
        public void Fit()
        {
            var size=((RectTransform)transform).rect.size;int mode=RecipeVisible?1:0;if(size==lastSize && lastHistory==mode)return;lastSize=size;lastHistory=mode;
            float width=RecipeVisible?1110:520;Group.sizeDelta=new Vector2(width,774);float scale=Mathf.Min(1,Mathf.Min((size.x-48)/width,(size.y-56)/774));Group.localScale=Vector3.one*Mathf.Max(.1f,scale);Group.anchoredPosition=Vector2.zero;
        }
        static void SetCaption(UnityEngine.UI.Button button,string value)=>button.GetComponentInChildren<TextMeshProUGUI>().text=value;
        static UnityEngine.UI.Image NativePicture(Transform parent,string name,string key,float x,float y,float w,float h,bool hit=false)
        {
            var im=Box(parent,name,x,y,w,h).gameObject.AddComponent<UnityEngine.UI.Image>();im.sprite=Native(key);im.raycastTarget=hit;if(im.sprite!=null && im.sprite.border.sqrMagnitude>0)im.type=UnityEngine.UI.Image.Type.Sliced;return im;
        }
        public static RectTransform ItemIcon(Transform parent,string name,ItemDefinition item,float x,float y,float size)
        {
            var root=Box(parent,name,x,y,size,size);
            if(item.ItemKind==ItemKind.Fragment||item.ItemKind==ItemKind.Soulstone)
            {
                NativePicture(root,"FragmentBackground","common/frame/fragment_bg",0,0,size,size);
                var clip=NativePicture(root,"FragmentMask","common/frame/fragment_stencil",5,5,size-10,size-10);clip.gameObject.AddComponent<Mask>().showMaskGraphic=false;
                Picture(clip.transform,"Icon","Items/"+item.DefinitionId,0,0,size-10,size-10,aspect:true);
            }
            else
            {
                var clip=Picture(root,"ItemMask","equip_frame_mask",0,0,size,size);clip.gameObject.AddComponent<Mask>().showMaskGraphic=false;
                Picture(clip.transform,"Icon","Items/"+item.DefinitionId,4,4,size-8,size-8,aspect:true);
            }
            string[] colors={"white","green","blue","purple","purple","orange","red","pink","prismatic"};string color=colors[Math.Clamp(item.Quality,1,9)-1];
            NativePicture(root,"Quality","common/frame/"+(item.ItemKind==ItemKind.Fragment||item.ItemKind==ItemKind.Soulstone?"fragment":"equip")+"_frame_"+color,0,0,size,size);
            if(item.ItemKind==ItemKind.Soulstone)NativePicture(root,"SoulstoneTag","icon/herodetail_soulstone_icon",4,2,size*.28f,size*.28f);
            if(item.ItemKind==ItemKind.Fragment)NativePicture(root,"FragmentTag","icon/fragment_tag",1,1,size*.24f,size*.24f);
            return root;
        }
        static UnityEngine.UI.Button NativeButton(Transform parent,string name,string art,float x,float y,float w,float h,string caption,TMP_FontAsset font)
        {var image=NativePicture(parent,name,art,x,y,w,h,true);var b=image.gameObject.AddComponent<UnityEngine.UI.Button>();b.targetGraphic=image;Caption(b,caption,font,29);return b;}
        public static ZatodEquipmentView Create(Transform parent,TMP_FontAsset font)
        {
            var root=Box(parent,"ZatodEquipmentView");Stretch(root);root.gameObject.SetActive(false);var v=root.gameObject.AddComponent<ZatodEquipmentView>();v.Font=font;
            var dim=root.gameObject.AddComponent<UnityEngine.UI.Image>();dim.color=new Color(0,0,0,.65f);dim.raycastTarget=true;
            v.Group=Box(root,"Popup");v.Group.anchorMin=v.Group.anchorMax=v.Group.pivot=new Vector2(.5f,.5f);v.Group.anchoredPosition=Vector2.zero;
            v.Left=NativePicture(v.Group,"ItemPanel","common/com_new_1",0,0,520,774,true).rectTransform;v.Right=NativePicture(v.Group,"RecipePanel","common/com_new_1",522,0,588,774,true).rectTransform;
            NativePicture(v.Left,"TopDecor","package/bg_deso",24,4,473,336);NativePicture(v.Left,"Separator","package/seg_normal",62,285,395,19);NativePicture(v.Left,"BottomDecor","package/bg_bottom_deco",32,624,456,108);
            NativePicture(v.Right,"Inner","common/com_new_2",0,0,588,774);v.CraftDecoration=NativePicture(v.Right,"CraftDecor","hero/equip/equip_fragment_bg_1",26,130,536,585).gameObject;NativePicture(v.Right,"HistoryDecor","hero/equip/equip_fragment_bg_2",17,12,553,174);
            TextMeshProUGUI Label(Transform p,string n,string value,float x,float y,float w,float h,int size,Color? color=null){var t=Text(p,n,value,font,size);Place(t.rectTransform,x,y,w,h);t.alignment=TextAlignmentOptions.Center;if(color.HasValue)t.color=color.Value;return t;}
            v.ItemName=Label(v.Left,"ItemName","Item",14,187,492,55,33);v.ItemName.color=new Color(.23f,.18f,.13f);v.Owned=Label(v.Left,"Owned","Owned",10,239,500,48,28,new Color(.38f,.34f,.29f));
            v.StatsScroll=Scroll(v.Left,"StatsScroll",out v.Stats);Place((RectTransform)v.StatsScroll.transform,30,302,460,238);
            v.Requirement=Label(v.Left,"LevelRequirement","Level",15,570,490,38,25,new Color(.38f,.30f,.20f));v.Remark=Label(v.Left,"BindingRemark","",10,607,500,34,23,new Color(.38f,.34f,.29f));
            v.Message=Label(v.Left,"Message","",12,541,496,28,20,new Color(.5f,.18f,.1f));v.ActionButton=NativeButton(v.Left,"Equip","common/buttion_big",110,640,300,88,"Equip",font);
            v.RecipeButton=NativeButton(v.Left,"Recipe","hero/equip/equip_route_button",420,37,62,62,"",font);
            v.TreeName=Label(v.Right,"TreeName","Recipe",90,50,440,50,29);v.TreeBack=ZatodHeroUi.Button(v.Right,"TreeBack","break_butt_bj");Place((RectTransform)v.TreeBack.transform,20,48,50,50);Picture(v.TreeBack.transform,"Arrow","break_butt",8,8,34,34,aspect:true);
            v.RecipeTitle=Label(v.Right,"RecipeTitle","Crafting formula",20,144,548,48,29,new Color(1,.83f,.43f));v.Tree=Box(v.Right,"Tree",0,202,588,400);
            v.SourceScroll=Scroll(v.Right,"SourcesScroll",out var sourceContent);Place((RectTransform)v.SourceScroll.transform,18,216,552,380);v.SourceScroll.gameObject.SetActive(false);
            var money=Box(v.Right,"Gold",200,598,188,46);NativePicture(money,"GoldIcon","common/goldicon_small",0,2,40,40);v.Cost=Label(money,"Cost","0",42,0,130,46,30,new Color(.75f,.46f,.06f));
            v.CraftButton=NativeButton(v.Right,"Craft","common/button_com_mini",166,640,255,78,"Craft",font);
            v.Close=NativeButton(v.Group,"Close","common/herodetail-detail-close",490,-16,58,58,"",font);v.Right.gameObject.SetActive(false);return v;
        }
    }
}
