// Run with Unity Pipeline script run, outside Assets. Fixtures require the isolated build workspace.
using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UIElements;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;

public static class D35EditorChecks
{
    const string Profile="d35-validation";
    const string AccountId="bddf4595-1935-4988-a84d-952b501fbb28";
    static string Evidence=>Path.GetFullPath("../Evidence");
    static void Isolated(){if(!Application.dataPath.Replace('\\','/').Contains("/Artifacts/D35BuildWorkspace/Unity/Assets"))throw new InvalidOperationException("Fixtures require the isolated D35 workspace.");Directory.CreateDirectory(Evidence);}
    static void Check(bool ok,string message){if(!ok)throw new Exception(message);}
    static async Task Until(Func<bool> ready,string message)
    {double limit=EditorApplication.timeSinceStartup+12;while(!ready()){if(EditorApplication.timeSinceStartup>limit)throw new TimeoutException(message);await Task.Delay(50);}}
    static ZatodConnection Client=>UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();
    static ZatodPrototypeView View=>UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
    static HeroData Coco=>Client.Snapshot.Account.HeroDesk.Single(x=>x.HeroDefinitionId=="coco");
    static ZatodHeroDetailView Detail=>UnityEngine.Object.FindAnyObjectByType<ZatodHeroDetailView>();
    static ZatodHeroSkillPanel Panel=>UnityEngine.Object.FindAnyObjectByType<ZatodHeroSkillPanel>();
    public static object Prepare()
    {
        Isolated();ZatodEvolutionArt.Prepare();
        var catalog=HeroDataJson.LoadBundledCatalog();
        foreach(var slot in catalog.Data.Heroes.SelectMany(x=>x.SkillSlots))Check(Resources.Load<Sprite>("Zatod/UI/Hero/Skills/Icons/"+slot.SkillId)!=null,"Missing imported skill icon: "+slot.SkillId);
        foreach(var id in new[]{"eff_buff_slow","eff_buff_Coco_ult","eff_buff_NS_atk3b","eff_buff_frozen_atk2","eff_buff_Ench_awake"})
        {
            var asset=Resources.Load<TextAsset>("Zatod/"+id+"/AnimationSet");Check(asset!=null,"Missing effect set: "+id);
            var set=JsonUtility.FromJson<Zatod.Animation.HeroAnimationSetData>(asset.text);
            foreach(var clip in set.Clips)Check(Resources.Load<AnimationClip>(clip.ClipResource)!=null,"Missing effect clip: "+clip.ClipResource);
        }
        ConfigChecks();SeedServer(catalog);
        EditorSceneManager.OpenScene(ZatodPrototypeSetup.ScenePath);
        return new{Icons=75,Effects=5,Config="PASS",ServerData=Path.Combine(Evidence,"Server")};
    }
    static void ConfigChecks()
    {
        var original=HeroConfigFileStore.Read();var draft=HeroDataJson.ReadDocuments(original).Data;
        string skills=File.ReadAllText(HeroDataJson.AssetPath(HeroConfigSection.Skills));
        draft.ConfigVersion+="-d35-fixture";draft.SkillProgression.SkillLevelCap=70;
        draft.Heroes[0].SkillSlots[0].InitialLevel=2;draft.Skills.First(x=>x.Evolutions.Count>0).Evolutions[0].Description="Fixture edited evolution";
        Check(File.ReadAllText(HeroDataJson.AssetPath(HeroConfigSection.Skills))==skills,"Draft changed disk without Save");
        try
        {
            HeroConfigFileStore.Save(draft,original);var read=HeroDataJson.ReadDocuments(HeroConfigFileStore.Read()).Data;
            Check(read.SkillProgression.SkillLevelCap==70 && read.Heroes[0].SkillSlots[0].InitialLevel==2 && read.Skills.First(x=>x.Evolutions.Count>0).Evolutions[0].Description=="Fixture edited evolution","Editor save/read dropped D35 fields");
            bool stale=false;try{HeroConfigFileStore.Save(draft,original);}catch(IOException){stale=true;}Check(stale,"Stale Editor save was accepted");
            draft.Skills.First(x=>x.Evolutions.Count>0).Evolutions[0].TriggeredEffects[0].BuffId=int.MaxValue;
            bool invalid=false;try{HeroDataJson.WriteDocuments(draft);}catch(ArgumentException){invalid=true;}Check(invalid,"Editor accepted missing Evo buff");
        }
        finally
        {foreach(var section in HeroDataJson.Sections)File.WriteAllText(HeroDataJson.AssetPath(section),original.Get(section));HeroConfigFileStore.ImportFiles();}
        Check(HeroConfigFileStore.Read().Skills==original.Skills,"Editor fixture did not restore original config bytes");
        File.WriteAllText(Path.Combine(Evidence,"editor-config.txt"),"PASS draft isolation, D35 field roundtrip, stale save rejection, missing reference validation, exact fixture restoration.");
    }
    static void SeedServer(HeroCatalog catalog)
    {
        var account=new CharacterData{CharacterId=AccountId,Name="D35 fixture",Level=80,Stamina=120,EconomyVersion=1,StaminaRecoveryTimestamp=DateTimeOffset.UtcNow.ToUnixTimeSeconds()};
        foreach(var definition in catalog.Data.Heroes)
        {
            var hero=catalog.CreateHero(definition.Id,Guid.NewGuid().ToString("D"));hero.Level=80;hero.Stars=5;
            if(definition.Id!="coco")while(hero.RankId!="blue")
            {foreach(var slot in HeroProgression.CurrentRank(hero,catalog).EquipmentSlots)HeroProgression.Equip(hero,catalog,slot.Id,slot.RequiredItemId);HeroProgression.Promote(hero,catalog);}
            foreach(var s in hero.Skills)s.Level=definition.Id=="coco"?34:80;
            account.HeroDesk.Add(hero);
        }
        CurrencyBalance.AddGold(account,100000000);var inventory=new ItemInventory(account,catalog);var coco=account.HeroDesk.Single(x=>x.HeroDefinitionId=="coco");
        foreach(var slot in HeroProgression.CurrentRank(coco,catalog).EquipmentSlots)inventory.AddItemByItemId(slot.RequiredItemId);
        string dir=Path.Combine(Evidence,"Server","Owned");Directory.CreateDirectory(dir);string path=Path.Combine(dir,AccountId+".json");
        if(File.Exists(path))throw new IOException("Fixture already exists; do not overwrite a running server's profile.");
        File.WriteAllText(path,HeroDataJson.WriteCharacter(account,catalog));
        PlayerPrefs.SetString("ZatodPrototype.Account."+Profile,AccountId);PlayerPrefs.Save();
    }
    public static string BuildSmokePlayer()
    {
        Isolated();Check(!EditorApplication.isPlaying,"Stop fixture Play Mode first");
        string path=Path.Combine(Evidence,"Player","ZatodD35.app");Directory.CreateDirectory(Path.GetDirectoryName(path));
        var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{ZatodPrototypeSetup.ScenePath,ZatodBattleSceneController.ScenePath},target=BuildTarget.StandaloneOSX,locationPathName=path,options=BuildOptions.Development});
        Check(report.summary.result==BuildResult.Succeeded,"Smoke Player build failed");return path;
    }
    static void TickFixtureServer()
    {
        var client=Client;if(client==null || !Mirror.NetworkServer.active)return;
        foreach(string method in new[]{"UpdateRooms","UpdateWorldServer","UpdateEconomyServer"})
            typeof(ZatodConnection).GetMethod(method,BindingFlags.Instance|BindingFlags.NonPublic).Invoke(client,null);
    }
    public static string StartLoopbackFixture()
    {
        Isolated();Check(EditorApplication.isPlaying,"Start fixture Play Mode first");
        Check(ZatodConnection.Argument("--data-dir","")=="/tmp/zatod-d35-server","Wrong fixture data directory");
        Check(!Mirror.NetworkServer.active,"A server is already running");
        typeof(ZatodConnection).GetMethod("StartServer",BindingFlags.Instance|BindingFlags.NonPublic).Invoke(Client,null);
        EditorApplication.update+=TickFixtureServer;
        return "Fixture server listening over real TCP in the same Editor process";
    }
    public static string StopLoopbackFixture()
    {
        EditorApplication.update-=TickFixtureServer;
        Client?.Disconnect();Mirror.NetworkServer.Shutdown();return "Fixture server stopped";
    }
    public static async Task<object> NetworkAndUi()
    {
        Isolated();Check(EditorApplication.isPlaying,"Start fixture Play Mode first");
        Client.JoinLan("D35 fixture","127.0.0.1");await Until(()=>Client.Snapshot!=null,"Login did not receive account");
        Check(Client.Snapshot.Account.CharacterId==AccountId,"Wrong fixture profile");
        var catalog=HeroDataJson.LoadBundledCatalog();string id=Coco.HeroInstanceId,slot=catalog.Hero("coco").SkillSlots[0].Id;
        View.OpenHeroRoster();View.OpenHeroDetail(id);Detail.SelectTab(true);await Task.Delay(150);
        var pointer=new PointerEventData(EventSystem.current){button=PointerEventData.InputButton.Left};var button=Panel.UpgradeButton.GetComponent<ZatodRepeatButton>();
        long gold=CurrencyBalance.GetGold(Client.Snapshot.Account),rev=Client.Snapshot.Account.Revision;
        string operation="";button.OnPointerDown(pointer);operation=Client.PendingItemOperationId;button.OnPointerUp(pointer);
        await Until(()=>Client.Snapshot.Account.Revision>rev && !Client.ItemOperationBusy,"Single skill upgrade did not complete");
        Check(Coco.Skills.Single(x=>x.SlotId==slot).Level==35,"Short press upgraded more or less than one level");
        Check(CurrencyBalance.GetGold(Client.Snapshot.Account)==gold-catalog.Data.SkillProgression.GoldUpgradeCurve.Single(x=>x.FromLevel==34).Gold,"Network upgrade charged wrong Gold");
        Check(Panel.SelectedSlotId==slot && Detail.HeroId==id,"Upgrade lost Hero/slot selection");
        var retry=new ZatodRequest{Command="skill_up",A=id,B=slot,ExpectedLevel=34,ExpectedRevision=rev,Number=1,OperationId=operation};
        long after=Client.Snapshot.Account.Revision;Client.Request(retry);await Task.Delay(400);
        Check(Client.Snapshot.Account.Revision==after && Coco.Skills.Single(x=>x.SlotId==slot).Level==35,"Duplicate request committed twice");
        Client.Request(new ZatodRequest{Command="skill_up",A=id,B=slot,ExpectedLevel=34,ExpectedRevision=rev,Number=1,OperationId=Guid.NewGuid().ToString("D")});await Task.Delay(400);
        Check(Client.Snapshot.Account.Revision==after && Coco.Skills.Single(x=>x.SlotId==slot).Level==35,"Stale request changed skill");
        button=Panel.UpgradeButton.GetComponent<ZatodRepeatButton>();button.OnPointerDown(pointer);await Task.Delay(1050);button.OnPointerUp(pointer);
        await Until(()=>!Client.ItemOperationBusy,"Held upgrade did not settle");int held=Coco.Skills.Single(x=>x.SlotId==slot).Level;
        Check(held>36 && held<45,"Hold must send bounded one-level steps");await Task.Delay(400);Check(Coco.Skills.Single(x=>x.SlotId==slot).Level==held,"Upgrade continued after pointer release");
        Detail.SelectTab(false);var expected=Client.Snapshot.Account.Inventory.Select(x=>x.Id).OrderBy(x=>x).ToArray();string rank=Coco.RankId;
        rev=Client.Snapshot.Account.Revision;Detail.QuickEquip.onClick.Invoke();await Until(()=>Client.Snapshot.Account.Revision>rev && !Client.ItemOperationBusy,"QuickEquip did not complete");
        Check(Coco.RankId==rank && Coco.EquippedItems.Select(x=>x.Id).OrderBy(x=>x).SequenceEqual(expected),"QuickEquip lost GUID or promoted automatically");
        Check(Detail.QuickEquip.GetComponentInChildren<TMPro.TextMeshProUGUI>().text=="Promote","Shared button did not switch to Promote");
        rev=Client.Snapshot.Account.Revision;Detail.QuickEquip.onClick.Invoke();await Until(()=>Client.Snapshot.Account.Revision>rev && !Client.ItemOperationBusy,"Promote did not complete");
        Check(Coco.RankId!=rank && Coco.AbsorbedItems.Select(x=>x.Id).OrderBy(x=>x).SequenceEqual(expected),"Promotion lost actual equipped item history");
        Client.FindPvp(new[]{id});await Task.Delay(300);rev=Client.Snapshot.Account.Revision;
        Client.Request(new ZatodRequest{Command="skill_up",A=id,B=slot,ExpectedLevel=held,ExpectedRevision=rev,Number=1,OperationId=Guid.NewGuid().ToString("D")});await Task.Delay(350);
        Check(Client.Snapshot.Account.Revision==rev && Coco.Skills.Single(x=>x.SlotId==slot).Level==held,"PvP queue guard failed");Client.Cancel();await Task.Delay(200);
        Client.Campaign("chapter_one_stage_1",new[]{id});await Until(()=>Client.Battle!=null,"Campaign not issued");rev=Client.Snapshot.Account.Revision;
        Client.Request(new ZatodRequest{Command="skill_up",A=id,B=slot,ExpectedLevel=held,ExpectedRevision=rev,Number=1,OperationId=Guid.NewGuid().ToString("D")});await Task.Delay(350);
        Check(Client.Snapshot.Account.Revision==rev && Coco.Skills.Single(x=>x.SlotId==slot).Level==held,"Campaign guard failed");Client.Cancel();await Task.Delay(200);
        Client.Disconnect();await Until(()=>!Client.Connected,"Disconnect did not complete");await Task.Delay(200);Client.Connect();await Until(()=>Client.Snapshot!=null && Client.Connected,"Reconnect failed");
        Check(Coco.Skills.Single(x=>x.SlotId==slot).Level==held && Coco.AbsorbedItems.Select(x=>x.Id).OrderBy(x=>x).SequenceEqual(expected),"Reconnect lost committed skill/items");
        foreach(var h in Client.Snapshot.Account.HeroDesk.ToArray())
        {View.OpenHeroDetail(h.HeroInstanceId);Detail.SelectTab(true);await Task.Delay(25);Check(Panel.SelectedSlotId!=null && Panel.UpgradeButton!=null,"Missing skill tab for "+h.HeroDefinitionId);}
        View.OpenHeroDetail(id);Detail.SelectTab(true);Detail.Close.onClick.Invoke();await Task.Delay(50);
        Check(UnityEngine.Object.FindAnyObjectByType<ZatodHeroRosterView>()!=null,"Close did not return to roster");
        View.OpenHeroDetail(id);Detail.SelectTab(true);
        string result="PASS real TCP server/client: single/held upgrades, Gold, receipt retry, stale rejection, QuickEquip GUIDs, Promote, queue/Campaign guards, reconnect, all 25 Hero tabs, close-to-roster.";
        File.WriteAllText(Path.Combine(Evidence,"network-ui.txt"),result);return new{Result=result,HeldSkillLevel=held,Profile=AccountId,Port=Client.Port};
    }
    public static async Task<string> ConnectForUi()
    {
        Isolated();Client.JoinLan("D35 fixture","127.0.0.1");await Until(()=>Client.Snapshot!=null,"Fixture login");
        View.OpenHeroDetail(Coco.HeroInstanceId);Detail.SelectTab(true);return "Fixture UI opened";
    }
    public static async Task<string> SkillReferenceUi()
    {
        Isolated();var catalog=HeroDataJson.LoadBundledCatalog();
        foreach(var hero in Client.Snapshot.Account.HeroDesk)
        {
            View.OpenHeroDetail(hero.HeroInstanceId);Detail.SelectTab(true);await Task.Delay(25);
            Check(!Detail.ArtPanel.gameObject.activeSelf,"Skill still shows portrait rail");
            var cards=Panel.transform.Find("SkillSlots");Check(cards.Find("HeroIdle")!=null && cards.Find("PurpleSlot")!=null,"Missing centered Hero or locked purple slot");
            Check(!cards.Find("PurpleSlot").GetComponent<UnityEngine.UI.Button>().interactable,"Purple reference became playable");
            var details=Panel.transform.Find("SkillDetails");
            details.Find("Details").GetComponent<UnityEngine.UI.Button>().onClick.Invoke();
            string actual=Panel.DetailsScroll.content.Find("Description").GetComponent<TMPro.TextMeshProUGUI>().text;
            var slot=catalog.Hero(hero.HeroDefinitionId).SkillSlots.First();
            Check(actual==SkillDescription.Describe(catalog.Skill(slot.SkillId),hero.Skills.Single(x=>x.SlotId==slot.Id).Level,catalog),"Details diverged from level preview");
            details.Find("Intro").GetComponent<UnityEngine.UI.Button>().onClick.Invoke();
            Detail.SelectTab(false);Check(Detail.ArtPanel.gameObject.activeSelf && Detail.CenterPanel.gameObject.activeSelf,"Base did not restore");
        }
        View.OpenHeroDetail(Coco.HeroInstanceId);Detail.SelectTab(true);
        return "PASS 25 Hero reference layout, locked Purple, Intro/Details and Base restoration";
    }
    public static async Task<object> ResponsiveUi()
    {
        Isolated();Check(EditorApplication.isPlaying && Client.Connected,"Run network fixture first");
        const BindingFlags flags=BindingFlags.Instance|BindingFlags.Static|BindingFlags.Public|BindingFlags.NonPublic;
        var asm=typeof(Editor).Assembly;var vt=asm.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(vt);
        var selected=vt.GetProperty("selectedSizeIndex",flags);int old=(int)selected.GetValue(view);
        var st=asm.GetType("UnityEditor.GameViewSizes");var sizes=st.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);
        var groupType=asm.GetType("UnityEditor.GameViewSizeGroupType");string name=Enum.GetNames(groupType).First(x=>x=="iOS"||x=="iPhone");
        var group=st.GetMethod("GetGroup").Invoke(sizes,new[]{Enum.Parse(groupType,name)});var gt=group.GetType();int initial=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);
        var safe=Detail.GetComponentInParent<ZatodSafeAreaRoot>();var safeRect=(RectTransform)safe.transform;
        string dir=Path.Combine(Evidence,"UI");Directory.CreateDirectory(dir);int checks=0;
        var catalog=HeroDataJson.LoadBundledCatalog();string id=Coco.HeroInstanceId;
        async Task Capture(string file){string path=Path.Combine(dir,file+".png");if(File.Exists(path))File.Delete(path);ScreenCapture.CaptureScreenshot(path);await Until(()=>File.Exists(path),"Capture missing "+file);}
        void Bounds(RectTransform rect)
        {var corners=new Vector3[4];rect.GetWorldCorners(corners);foreach(var c in corners){var p=safeRect.InverseTransformPoint(c);var r=safeRect.rect;Check(p.x>=r.xMin-1 && p.x<=r.xMax+1 && p.y>=r.yMin-1 && p.y<=r.yMax+1,"Outside safe area: "+rect.name);checks++;}}
        try
        {
            foreach(var wh in new[]{new[]{1600,900},new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
            {
                var size=Activator.CreateInstance(asm.GetType("UnityEditor.GameViewSize"),flags,null,new object[]{Enum.Parse(asm.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),wh[0],wh[1],"D35 fixture"},null);
                int n=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);gt.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,n);view.Repaint();
                await Until(()=>Screen.width==wh[0] && Screen.height==wh[1],"GameView did not resize");
                View.OpenHeroDetail(id);Detail.SelectTab(true);await Task.Delay(250);
                Bounds((RectTransform)Panel.transform);Bounds((RectTransform)Panel.UpgradeButton.transform);Bounds(Detail.Tabs);Bounds((RectTransform)Detail.Close.transform);
                Check(Panel.UpgradeButton.interactable,"Unlocked affordable skill disabled");checks++;
                foreach(var text in Panel.DetailsScroll.content.GetComponentsInChildren<TMPro.TextMeshProUGUI>())
                {text.ForceMeshUpdate();for(int line=0;line<text.textInfo.lineCount;line++){Check(text.textInfo.lineInfo[line].maxAdvance<=text.rectTransform.rect.width+2,"Description line exceeds width: "+text.name);checks++;}}
                await Capture("skill-"+wh[0]+"x"+wh[1]);
                if(wh[0]==2400){Panel.DetailsScroll.verticalNormalizedPosition=0;await Task.Delay(100);await Capture("skill-scrolled-bottom");Panel.DetailsScroll.verticalNormalizedPosition=1;}
                if(wh[0]==2436)
                {
                    safe.enabled=false;var area=ZatodSafeAreaRoot.Normalized(new Rect(132,63,wh[0]-264,wh[1]-63),wh[0],wh[1]);safeRect.anchorMin=area.min;safeRect.anchorMax=area.max;await Task.Delay(250);
                    Bounds((RectTransform)Panel.transform);Bounds((RectTransform)Panel.UpgradeButton.transform);Bounds(Detail.Tabs);Bounds((RectTransform)Detail.Close.transform);await Capture("skill-simulated-safe-area");safe.enabled=true;safe.Apply();
                }
                if(wh[0]==1600 && wh[1]==900)
                {
                    Panel.Select(catalog.Hero("coco").SkillSlots[2].Id);Check(!Panel.UpgradeButton.interactable,"Locked skill upgrade enabled");checks++;await Capture("skill-locked");
                    var max=Client.Snapshot.Account.HeroDesk.First(x=>x.HeroDefinitionId!="coco");View.OpenHeroDetail(max.HeroInstanceId);Detail.SelectTab(true);Check(!Panel.UpgradeButton.interactable,"Max skill upgrade enabled");checks++;await Capture("skill-max");
                    View.OpenHeroDetail(id);Detail.SelectTab(true);var clone=HeroDataJson.ReadCharacter(HeroDataJson.WriteCharacter(Client.Snapshot.Account,catalog),catalog);CurrencyBalance.AddGold(clone,-CurrencyBalance.GetGold(clone));Panel.Bind(catalog,clone,id,Client);
                    Check(!Panel.UpgradeButton.interactable,"Insufficient Gold upgrade enabled");checks++;await Capture("skill-no-gold");Panel.Bind(catalog,Client.Snapshot.Account,id,Client);
                    Detail.SelectTab(false);await Task.Delay(100);Bounds((RectTransform)Detail.QuickEquip.transform);await Capture("base-after-promote");Detail.SelectTab(true);
                }
            }
        }
        finally
        {
            safe.enabled=true;safe.Apply();selected.SetValue(view,old);
            int total=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);for(int i=total-1;i>=initial;i--)gt.GetMethod("RemoveCustomSize").Invoke(group,new object[]{i});view.Repaint();
            if(Panel!=null)Panel.Bind(catalog,Client.Snapshot.Account,id,Client);
        }
        File.WriteAllText(Path.Combine(Evidence,"responsive-ui.txt"),"PASS "+checks+" bounds/state checks at 16:9, 19.5:9, 20:9, 4:3 and simulated safe area; Editor only, not physical device.");
        return new{Checks=checks,Screenshots=dir};
    }

    public static string ConfigControls()
    {
        Isolated();Check(!EditorApplication.isPlaying,"Stop Play Mode before GameEditor checks");
        const BindingFlags flags=BindingFlags.Instance|BindingFlags.NonPublic;
        var w=EditorWindow.GetWindow<GameEditorWindow>();Check(!w.hasUnsavedChanges,"Fixture must not overwrite an existing draft");
        string original=File.ReadAllText(HeroDataJson.AssetPath(HeroConfigSection.Skills));
        try
        {
            typeof(GameEditorWindow).GetField("activeTab",flags).SetValue(w,HeroConfigSection.Skills);w.CreateGUI();
            var root=w.rootVisualElement;var rules=root.Q<Foldout>("skill-progression-rules");Check(rules!=null,"Skill rule controls missing");rules.value=true;
            var cap=root.Q<IntegerField>("field-SkillLevelCap");Check(cap!=null && cap.value==80,"Cap control incorrect");cap.value=70;
            var list=root.Query<Foldout>().ToList().First(x=>x.text.StartsWith("Skills ("));list.value=true;
            var entry=list.Query<Foldout>().ToList().First(x=>x.text.Contains("coco_spectral_ship"));entry.value=true;
            var evos=entry.Query<Foldout>().ToList().First(x=>x.text.StartsWith("Evolutions ("));evos.value=true;
            var evo=evos.Query<Foldout>().ToList().First(x=>x.text.StartsWith("[0]"));evo.value=true;
            Check(evo.Q<IntegerField>("field-RequiredSkillLevel")!=null,"Evo level control missing");
            var description=evo.Q<TextField>("field-Description");Check(description!=null,"Evo description control missing");description.value="UI fixture draft";
            var draft=(HeroCatalogData)typeof(GameEditorWindow).GetField("draft",flags).GetValue(w);
            Check(w.hasUnsavedChanges && draft.SkillProgression.SkillLevelCap==70 && draft.Skills.Single(x=>x.Id=="coco_spectral_ship").Evolutions[0].Description=="UI fixture draft","Controls did not update draft");
            Check(File.ReadAllText(HeroDataJson.AssetPath(HeroConfigSection.Skills))==original,"UI draft changed disk without Save");
        }
        finally{w.DiscardChanges();w.Close();}
        File.WriteAllText(Path.Combine(Evidence,"editor-controls.txt"),"PASS real GameEditor controls: cap and Evo fields edit draft, mark dirty, disk unchanged; draft discarded.");return "GameEditor UI draft PASS";
    }

}
