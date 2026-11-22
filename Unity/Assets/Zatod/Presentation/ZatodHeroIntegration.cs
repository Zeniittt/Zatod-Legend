using TMPro;
using UnityEngine;
using static Zatod.Presentation.ZatodHeroUi;

namespace Zatod.Presentation
{
    public sealed partial class ZatodPrototypeView
    {
        ZatodHeroRosterView heroRoster;ZatodHeroDetailView heroDetail;ZatodEquipmentView equipmentWindow;
        ZatodInventoryView inventoryView;
        RectTransform shortcutBoard;UnityEngine.UI.Button shortcutToggle;bool shortcutsExpanded=true;
        void BuildHeroViews()
        {
            heroRoster=Instantiate(Resources.Load<GameObject>("Zatod/UI/Hero/ZatodHeroRosterView"),root,false).GetComponent<ZatodHeroRosterView>();heroRoster.gameObject.SetActive(false);
            heroDetail=Instantiate(Resources.Load<GameObject>("Zatod/UI/Hero/ZatodHeroDetailView"),root,false).GetComponent<ZatodHeroDetailView>();heroDetail.gameObject.SetActive(false);
            var equipmentPrefab=Resources.Load<GameObject>("Zatod/UI/Crafting/ZatodEquipmentView");equipmentWindow=equipmentPrefab==null?ZatodEquipmentView.Create(root,Font):Instantiate(equipmentPrefab,root,false).GetComponent<ZatodEquipmentView>();equipmentWindow.gameObject.SetActive(false);
            heroRoster.OnEquipment=OpenEquipment;heroDetail.OnEquipment=OpenEquipment;
            inventoryView=ZatodInventoryView.Create(root,world.MapLabel.font);
            inventoryView.OnRecipe=item=>equipmentWindow.OpenItem(catalog,connection.Snapshot.Account,connection,campaign,item);
            heroDetail.LevelUp.onClick.AddListener(()=>OpenHeroExperience(heroDetail.HeroId));
            heroDetail.StarUp.onClick.AddListener(()=>OpenHeroStarUpgrade(heroDetail.HeroId));
            var shortcuts=ZatodHeroUi.Box(world.Hud,"Shortcuts",w:440,h:132);shortcuts.anchorMin=shortcuts.anchorMax=shortcuts.pivot=Vector2.right;shortcuts.anchoredPosition=new Vector2(-24,22);
            shortcutBoard=Picture(shortcuts,"Board","main_shortcut_board",0,0,366,128).rectTransform;
            string[] captions={"Task","Hero","Inventory"},icons={"main_task_button","main_hero_button","main_package_button"};
            for(int n=0;n<3;n++)
            {
                var b=ZatodHeroUi.Button(shortcutBoard,captions[n],icons[n],n==1?(System.Action)OpenHeroRoster:n==2?(System.Action)OpenInventory:null);Place((RectTransform)b.transform,8+n*116,0,108,101);b.image.preserveAspect=true;
                var t=ZatodHeroUi.Text(b.transform,"Caption",captions[n],world.MapLabel.font,23);Place(t.rectTransform,0,91,108,34);t.alignment=TextAlignmentOptions.Center;
            }
            shortcutToggle=ZatodHeroUi.Button(shortcuts,"Toggle","main_bj_button",ToggleShortcuts);Place((RectTransform)shortcutToggle.transform,374,6,57,111);
            var arrow=Picture(shortcutToggle.transform,"Arrow","main_img_button",15,30,27,48,aspect:true).rectTransform;
            arrow.anchorMin=arrow.anchorMax=arrow.pivot=new Vector2(.5f,.5f);arrow.anchoredPosition=Vector2.zero;arrow.localScale=Vector3.one;
        }
        public void ToggleShortcuts()
        {
            shortcutsExpanded=!shortcutsExpanded;shortcutBoard.gameObject.SetActive(shortcutsExpanded);
            Place((RectTransform)shortcutToggle.transform,374,6,57,111);
            var arrow=shortcutToggle.transform.Find("Arrow");arrow.localScale=new Vector3(shortcutsExpanded?1:-1,1,1);
        }
        public void OpenEquipment(string heroId,string slotId)
        {if(connection.Snapshot!=null)equipmentWindow.Open(catalog,connection.Snapshot.Account,connection,campaign,heroId,slotId);}
        public void OpenInventory()
        {
            if(connection.Snapshot==null)return;equipmentWindow?.Hide();heroRoster.gameObject.SetActive(false);heroDetail.gameObject.SetActive(false);screen="inventory";
            inventoryView.Open(catalog,campaign,connection.Snapshot.Account,connection,()=>{inventoryView.gameObject.SetActive(false);Show("campaign");});RefreshWorldChrome();
        }
        public void OpenHeroStarUpgrade(string heroId)
        {
            if(connection.Snapshot==null)return;screen="inventory";inventoryView.Open(catalog,campaign,connection.Snapshot.Account,connection,()=>{inventoryView.gameObject.SetActive(false);OpenHeroDetail(heroId);});
            inventoryView.ExperienceOnly=true;inventoryView.ShowStarUpgrade(heroId);inventoryView.HideInventoryChrome();RefreshWorldChrome();
        }
        public void OpenHeroExperience(string heroId)
        {
            if(connection.Snapshot==null)return;screen="inventory";inventoryView.Open(catalog,campaign,connection.Snapshot.Account,connection,()=>{inventoryView.gameObject.SetActive(false);OpenHeroDetail(heroId);});
            inventoryView.ExperienceOnly=true;inventoryView.ShowExp(heroId);inventoryView.HideInventoryChrome();RefreshWorldChrome();
        }
        public void OpenHeroRoster()
        {
            if(connection.Snapshot==null)return;inventoryView?.gameObject.SetActive(false);equipmentWindow?.Hide();screen="hero_roster";stage.gameObject.SetActive(false);formation.gameObject.SetActive(false);stagePreview.gameObject.SetActive(false);heroDetail.gameObject.SetActive(false);
            heroRoster.Open(catalog,connection.Snapshot.Account,()=>Show("campaign"),OpenHeroDetail);RefreshWorldChrome();
        }
        public void OpenHeroDetail(string id)
        {
            if(connection.Snapshot==null)return;screen="hero_detail";heroRoster.gameObject.SetActive(false);heroDetail.Open(catalog,connection.Snapshot.Account,id,OpenHeroRoster);RefreshWorldChrome();
        }
    }
}
