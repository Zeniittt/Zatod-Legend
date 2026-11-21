using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using Zatod.Presentation;
using Zatod.Networking;
using Zatod.Heroes;

public static class ZatodHeroUiReview
{
    const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
    static string Folder=>Path.GetFullPath("../Artifacts/ZatodHeroUiChecks/live");
    static ZatodPrototypeView Host=>UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
    static T Field<T>(string field)=>(T)typeof(ZatodPrototypeView).GetField(field,Flags).GetValue(Host);
    public static object Resize(int width,int height)
    {
        var assembly=typeof(Editor).Assembly;var windowType=assembly.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(windowType);
        var selected=windowType.GetProperty("selectedSizeIndex",Flags);if(!SessionState.GetBool("ZatodHeroReviewSaved",false)){SessionState.SetInt("ZatodHeroReviewIndex",(int)selected.GetValue(view));SessionState.SetBool("ZatodHeroReviewSaved",true);}
        var sizesType=assembly.GetType("UnityEditor.GameViewSizes");var instance=sizesType.BaseType.GetProperty("instance",BindingFlags.Static|BindingFlags.Public).GetValue(null);
        var groupType=assembly.GetType("UnityEditor.GameViewSizeGroupType");var group=sizesType.GetMethod("GetGroup").Invoke(instance,new[]{Enum.Parse(groupType,"Standalone")});
        var sizeType=assembly.GetType("UnityEditor.GameViewSize");var kind=assembly.GetType("UnityEditor.GameViewSizeType");
        var size=Activator.CreateInstance(sizeType,Flags,null,new object[]{Enum.Parse(kind,"FixedResolution"),width,height,"Zatod Review "+width+"x"+height},null);
        var groupClass=group.GetType();int count=(int)groupClass.GetMethod("GetTotalCount").Invoke(group,null);
        groupClass.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,count);view.Repaint();
        return new{Width=width,Height=height,Selected=count};
    }
    public static async Task<object> Begin()
    {
        Directory.CreateDirectory(Folder);Resize(1920,1080);int frame=Time.frameCount;
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();c.DevelopmentProfile="hero-ui-"+Guid.NewGuid().ToString("N");c.Port=17993;c.GetComponent<Mirror.TelepathyTransport>().port=17993;c.Connect();
        await Unity.Pipeline.Scripting.Wait.Until(()=>c.Snapshot!=null,timeoutMs:20000,because:"test server login");
        await Task.Delay(250);if(Time.frameCount<=frame+2)throw new Exception("No advancing Play frames");Host.OpenHeroRoster();await Task.Delay(200);
        return new{Screen.width,Screen.height,Frames=Time.frameCount-frame,Roster=Field<ZatodHeroRosterView>("heroRoster").VisibleCount,Scene=UnityEngine.SceneManagement.SceneManager.GetActiveScene().path};
    }
    public static async Task<object> Matrix()
    {
        Directory.CreateDirectory(Folder);int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var roster=Field<ZatodHeroRosterView>("heroRoster");var detail=Field<ZatodHeroDetailView>("heroDetail");var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();
        var safe=GameObject.Find("SafeAreaRoot").GetComponent<ZatodSafeAreaRoot>();var safeRect=(RectTransform)safe.transform;
        var account=c.Snapshot.Account;var catalog=HeroDataJson.LoadBundledCatalog();string before=JsonUtility.ToJson(account);string first=account.HeroDesk[0].HeroInstanceId;
        var stale=ZatodSafeAreaRoot.Normalized(new Rect(132,63,2172,1062),1920,1080);Check(stale.xMin>=0 && stale.yMin>=0 && stale.xMax<=1 && stale.yMax<=1,"Stale Simulator safe area must clamp");
        Check(UnityEngine.Object.FindObjectsByType<EventSystem>().Length==1,"EventSystem count");
        Host.OpenHeroRoster();Check(roster.VisibleCount==account.HeroDesk.Count,"Owned roster only");
        for(int n=0;n<4;n++){roster.Filters[n].onClick.Invoke();Check(roster.VisibleCount==account.HeroDesk.Count(h=>n==0 || (int)catalog.Hero(h.HeroDefinitionId).Position==n-1),"Filter "+n);}
        roster.SetFilter(null);Host.OpenHeroDetail(first);await Task.Delay(200);
        Check(detail.Illustration.sprite!=null,"Hero art");Check(detail.GetComponentInChildren<ReplaySprite>().CurrentState=="Idle","Combat Idle");
        var stat=HeroStatCalculator.Calculate(account.HeroDesk[0],catalog);Check(detail.DisplayedStats.PreciseStats.All(s=>stat.PreciseStats.Any(t=>t.StatId==s.StatId && t.Value==s.Value)),"Stats from calculator");
        detail.QuickEquip.onClick.Invoke();detail.LevelUp.onClick.Invoke();detail.StarUp.onClick.Invoke();foreach(var b in detail.TabButtons)b.onClick.Invoke();foreach(var b in detail.EquipmentLayer.GetComponentsInChildren<UnityEngine.UI.Button>())b.onClick.Invoke();
        Check(before==JsonUtility.ToJson(account),"Read-only buttons mutated account");
        var rows=new System.Collections.Generic.List<object>();
        int[,] sizes={{1920,1080},{1600,1200},{2436,1125},{2400,1080},{2520,1080}};
        for(int i=0;i<sizes.GetLength(0);i++)
        {
            Resize(sizes[i,0],sizes[i,1]);await Task.Delay(300);Check(Screen.width==sizes[i,0] && Screen.height==sizes[i,1],"Actual GameView size");
            // Test the same safe-area root with explicit left/right cutouts. Native SafeArea
            // is restored afterwards; screenshots are labelled simulated, not physical devices.
            safe.enabled=false;safeRect.anchorMin=new Vector2(i%2==0?.045f:0,.035f);safeRect.anchorMax=new Vector2(i%2==0?1:.955f,1);safeRect.offsetMin=safeRect.offsetMax=Vector2.zero;
            Host.OpenHeroRoster();await Task.Delay(120);Canvas.ForceUpdateCanvases();roster.Fit();
            InBounds(roster.Panel,safeRect,Check);InBounds((RectTransform)roster.Back.transform,safeRect,Check);InBounds(roster.CurrencyRow,safeRect,Check);
            Check(roster.RosterScroll.viewport.rect.width>0 && roster.RosterScroll.viewport.rect.height>150,"Roster viewport");
            ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"matrix-"+i+"-roster.png"));await Task.Delay(100);
            Host.OpenHeroDetail(first);await Task.Delay(120);Canvas.ForceUpdateCanvases();detail.Fit();
            InBounds(detail.Body,safeRect,Check);InBounds(detail.CurrencyRow,safeRect,Check);InBounds((RectTransform)detail.Close.transform,safeRect,Check);
            InBounds(detail.ArtPanel,detail.Body,Check);InBounds(detail.CenterPanel,detail.Body,Check);InBounds(detail.InfoPanel,detail.Body,Check);
            Check(detail.StatsScroll.viewport.rect.height>100,"Stats viewport");
            Check(detail.StatsContent.rect.height>detail.StatsScroll.viewport.rect.height,"Stats must scroll");
            detail.StatsScroll.verticalNormalizedPosition=0;await Task.Delay(100);Check(detail.StatsContent.anchoredPosition.y>0,"Stats scroll did not move");detail.StatsScroll.verticalNormalizedPosition=1;
            ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"matrix-"+i+"-detail.png"));await Task.Delay(100);
            rows.Add(new{Width=Screen.width,Height=Screen.height,SafeWidth=safeRect.rect.width,SafeHeight=safeRect.rect.height});
        }
        safe.enabled=true;Host.OpenHeroRoster();Resize(1920,1080);await Task.Delay(200);
        // Verify all definitions/art using a separate transient roster, never grant Heroes.
        var mock=new CharacterData();foreach(var h in catalog.Data.Heroes)mock.HeroDesk.Add(catalog.CreateHero(h.Id,"review-"+h.Id));
        roster.Open(catalog,mock,()=>{},id=>{});await Task.Delay(100);Check(roster.VisibleCount==25,"25 art cells");
        Check(roster.RosterScroll.content.rect.height>roster.RosterScroll.viewport.rect.height,"Long owned roster scroll");roster.RosterScroll.verticalNormalizedPosition=0;await Task.Delay(100);Check(roster.Content.anchoredPosition.y>0,"Roster scroll did not move");
        foreach(var h in mock.HeroDesk){Check(ZatodHeroUi.Art("Illustrations/"+h.HeroDefinitionId)!=null,"Missing illustration");}
        foreach(var item in catalog.Data.Items)Check(ZatodHeroUi.Art("Items/"+item.DefinitionId)!=null,"Missing item icon");
        var hero=mock.HeroDesk[0];var slots=HeroProgression.CurrentRank(hero,catalog).EquipmentSlots;Check(ZatodHeroUi.EquipmentState(hero,slots[0],mock)=="missing","Empty gear");
        mock.Inventory.Add(new ItemData{Id=Guid.NewGuid().ToString("D"),ItemId=slots[0].RequiredItemId});Check(ZatodHeroUi.EquipmentState(hero,slots[0],mock)=="available","Plus gear");
        hero.EquippedItems.Add(new EquippedItemData{Id=Guid.NewGuid().ToString("D"),SlotId=slots[0].Id,ItemId=slots[1].RequiredItemId});Check(ZatodHeroUi.EquipmentState(hero,slots[0],mock)=="equipped","Actual old item wins over recipe");
        Check(before==JsonUtility.ToJson(account),"Source account changed");Host.OpenHeroRoster();
        var world=UnityEngine.Object.FindAnyObjectByType<ZatodWorldView>();var position=world.Position;string map=world.MapId;
        Check(world.InputLocked(),"Hero list must lock world input");Host.OpenHeroDetail(first);Check(world.InputLocked(),"Detail must lock world input");
        detail.Close.onClick.Invoke();Check(roster.gameObject.activeSelf && !detail.gameObject.activeSelf,"Detail close must return to list");
        roster.Back.onClick.Invoke();await Task.Delay(120);Check(!roster.gameObject.activeSelf && !world.InputLocked(),"List back must return to world");Check(world.MapId==map && Vector2.Distance(world.Position,position)<.001f,"World map/pose changed");
        Host.ToggleShortcuts();Check(!world.Hud.Find("Shortcuts/Board").gameObject.activeSelf,"Shortcut collapse");Host.ToggleShortcuts();Check(world.Hud.Find("Shortcuts/Board").gameObject.activeSelf,"Shortcut expand");
        ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"pass2-world.png"));await Task.Delay(100);Host.OpenHeroRoster();
        var result=new{Result="PASS",Checks=checks,Responsive=rows,SimulatedSafeAreas=true,OwnedAccountUnchanged=true};File.WriteAllText(Path.Combine(Folder,"matrix.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
    static void InBounds(RectTransform child,RectTransform parent,Action<bool,string> check)
    {
        var corners=new Vector3[4];child.GetWorldCorners(corners);foreach(var c in corners){var p=parent.InverseTransformPoint(c);check(p.x>=parent.rect.xMin-.5f && p.x<=parent.rect.xMax+.5f && p.y>=parent.rect.yMin-.5f && p.y<=parent.rect.yMax+.5f,"Outside "+parent.name+": "+child.name);}
    }
    public static async Task<object> Flows()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var world=UnityEngine.Object.FindAnyObjectByType<ZatodWorldView>();
        var safe=GameObject.Find("SafeAreaRoot").GetComponent<ZatodSafeAreaRoot>();var sr=(RectTransform)safe.transform;
        var campaign=Field<CampaignCatalog>("campaign");string stage=campaign.Data.Chapters[0].Stages[0].Id;
        var preview=Field<ZatodStagePreviewView>("stagePreview");var formation=Field<ZatodFormationView>("formation");
        var show=typeof(ZatodPrototypeView).GetMethod("Show",Flags);var open=typeof(ZatodPrototypeView).GetMethod("OpenStagePreview",Flags);
        foreach(var dimensions in new[]{new[]{1600,1200},new[]{2520,1080}})
        {
            Resize(dimensions[0],dimensions[1]);await Task.Delay(200);show.Invoke(Host,new object[]{"campaign"});await Task.Delay(100);
            InBounds((RectTransform)world.Hud.Find("Town"),sr,Check);InBounds((RectTransform)world.Hud.Find("Features"),sr,Check);InBounds((RectTransform)world.Hud.Find("MapBanner"),sr,Check);InBounds((RectTransform)world.Hud.Find("Shortcuts"),sr,Check);
            open.Invoke(Host,new object[]{stage});await Task.Delay(120);preview.Fit();InBounds(preview.Layout,sr,Check);Check(preview.Challenge.interactable,"Challenge should be available");
            ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"flow-"+dimensions[0]+"-preview.png"));await Task.Delay(100);preview.Challenge.onClick.Invoke();await Task.Delay(120);
            Check(formation.gameObject.activeSelf,"Challenge to team");formation.Fit();InBounds(formation.DesignRoot,sr,Check);Check(formation.RosterCards.Count==c.Snapshot.Account.HeroDesk.Count,"Formation roster");
            ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"flow-"+dimensions[0]+"-formation.png"));await Task.Delay(100);formation.Back.onClick.Invoke();Check(preview.gameObject.activeSelf,"Formation back to preview");preview.Close.onClick.Invoke();
            foreach(string mode in new[]{"arena","pvp","history","heroes"}){show.Invoke(Host,new object[]{mode});await Task.Delay(80);var legacy=sr.Find("DevelopmentLayout").GetComponent<ZatodResponsiveLayout>();legacy.Fit();InBounds((RectTransform)legacy.transform,sr,Check);}
        }
        Resize(1920,1080);show.Invoke(Host,new object[]{"campaign"});await Task.Delay(200);c.AutoUltimate=true;open.Invoke(Host,new object[]{stage});preview.Challenge.onClick.Invoke();formation.Battle.onClick.Invoke();
        await Unity.Pipeline.Scripting.Wait.Until(()=>c.Battle!=null,timeoutMs:15000,because:"Battle button request");Check(Field<RectTransform>("stage").gameObject.activeSelf,"Battle HUD active");
        var hud=Field<ZatodBattleHudLayout>("hud");await Task.Delay(1000);Check(c.Battle.CurrentTick>0,"Battle advances");InBounds((RectTransform)hud.Auto.transform,sr,Check);InBounds((RectTransform)hud.Cards[0].Root.parent,sr,Check);InBounds(hud.Actors,sr,Check);InBounds(hud.Floating,sr,Check);
        ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"pass3-battle.png"));
        var result=new{Result="PASS",Checks=checks,Tick=c.Battle.CurrentTick,Stage=stage};File.WriteAllText(Path.Combine(Folder,"flows.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
    public static async Task<object> NativeSafeArea()
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var hud=Field<ZatodBattleHudLayout>("hud");hud.Exit.onClick.Invoke();
        Resize(2436,1125);await Task.Delay(200);var safe=GameObject.Find("SafeAreaRoot").GetComponent<ZatodSafeAreaRoot>();safe.enabled=true;safe.Apply();Host.OpenHeroRoster();await Task.Delay(200);
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var area=Screen.safeArea;Check(area.xMin>0 && area.width<Screen.width && area.xMax<=Screen.width && area.yMax<=Screen.height,"Expected valid landscape device cutouts from Unity Screen.safeArea");
        var sr=(RectTransform)safe.transform;InBounds(Field<ZatodHeroRosterView>("heroRoster").Panel,sr,Check);
        ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"native-safe-roster.png"));await Task.Delay(100);Host.OpenHeroDetail(c.Snapshot.Account.HeroDesk[2].HeroInstanceId);await Task.Delay(200);
        InBounds(Field<ZatodHeroDetailView>("heroDetail").Body,sr,Check);ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"native-safe-lina.png"));await Task.Delay(100);
        var result=new{Result="PASS",Checks=checks,Width=Screen.width,Height=Screen.height,Safe=new{area.x,area.y,area.width,area.height},Source="Unity Screen.safeArea (Simulator), not physical hardware"};
        File.WriteAllText(Path.Combine(Folder,"native-safe.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
}
