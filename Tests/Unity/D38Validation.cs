// Explicit isolated account/port: no mutation of the user's Owned or running server.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Mirror;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
using Zatod.World;

public static class D38Validation
{
    const BindingFlags Private=BindingFlags.Instance|BindingFlags.NonPublic;
    static int checks;
    static void Require(bool value,string why){checks++;if(!value)throw new Exception(why);}
    static T Field<T>(object value,string name)=>(T)value.GetType().GetField(name,Private).GetValue(value);
    static object Call(object value,string name,params object[] args)=>value.GetType().GetMethod(name,Private).Invoke(value,args);
    static async Task Until(Func<bool> predicate,double seconds,string why)
    {
        var end=EditorApplication.timeSinceStartup+seconds;
        while(!predicate()){if(!EditorApplication.isPlaying || EditorApplication.timeSinceStartup>end)throw new TimeoutException(why);await Task.Delay(40);}
    }
    public static string Arm(string output,int cycles=20,int seconds=1200)
    {
        Require(Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/") && EditorApplication.isPlaying,"Use the isolated validation Editor");
        Require(!NetworkServer.active && !NetworkClient.active,"Start from a disconnected Editor");
        Directory.CreateDirectory(output);string report=Path.Combine(output,"validation.json");File.WriteAllText(report,"{\"State\":\"RUNNING\"}");
        Run(output,report,cycles,seconds);return report;
    }
    static async void Run(string output,string report,int cycles,int seconds)
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var view=c.GetComponent<ZatodPrototypeView>();var scenes=c.GetComponent<ZatodBattleSceneController>();var transport=c.GetComponent<TelepathyTransport>();
        var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(catalog);
        string profile="d38-"+Guid.NewGuid().ToString("N"),accountId=Guid.NewGuid().ToString("D");string key="ZatodPrototype.Account."+profile;
        var oldProfile=c.DevelopmentProfile;var oldPort=c.Port;var oldTransport=transport.port;var oldAuto=c.AutoUltimate;
        EditorApplication.CallbackFunction pump=null;int completed=0,reused=0,created=0,summonFrames=0;Action observe=null;var samples=new List<object>();string phase="startup";
        double began=EditorApplication.timeSinceStartup;
        try
        {
            Field<Dictionary<string,ZatodPlayerSession>>(c,"launches").Clear();Field<Dictionary<int,ZatodPlayerSession>>(c,"sessions").Clear();
            var previousWorld=Field<GameObject>(c,"serverWorldRoot");if(previousWorld!=null)UnityEngine.Object.Destroy(previousWorld);
            c.DevelopmentProfile=profile;c.Port=transport.port=17938;PlayerPrefs.SetString(key,accountId);
            Call(c,"StartServer");typeof(ZatodConnection).GetField("archiveDirectory",Private).SetValue(c,Path.Combine(output,"Server"));Directory.CreateDirectory(Path.Combine(output,"Server"));
            pump=()=>{if(NetworkServer.active){Call(c,"UpdateWorldServer");Call(c,"UpdateEconomyServer");}};EditorApplication.update+=pump;
            c.JoinLan("D38 fixture","127.0.0.1");await Until(()=>c.Snapshot?.Account.CharacterId==accountId && c.WorldSelf!=null,20,"Fixture login: "+c.Status);
            var session=Field<Dictionary<int,ZatodPlayerSession>>(c,"sessions").Values.Single();
            var world=Field<ZatodWorldView>(view,"world");var selector=Field<ZatodChapterSelectorView>(view,"chapterSelector");var preview=Field<ZatodStagePreviewView>(view,"stagePreview");
            phase="chapter selector";
            world.Interact(WorldDataJson.Load(campaign).Map("town").Interactions.Single(p=>p.Id=="campaign"));
            Require(selector.gameObject.activeSelf && c.WorldSelf.MapId=="town" && selector.ChapterButtons.Count==8,"Campaign must open the selector before travel");
            Require(selector.FocusedChapter==campaign.Data.Chapters[0].Id,"Fresh account focus");
            await Task.Delay(200);ScreenCapture.CaptureScreenshot(Path.Combine(output,"selector-pass1.png"));await Task.Delay(250);
            selector.ChapterButtons[1].onClick.Invoke();Require(selector.Notice.text.Contains("Account Lv5") && selector.Notice.text.Contains("Complete"),"Show both chapter lock reasons");
            selector.ChapterButtons[0].onClick.Invoke();await Until(()=>c.WorldSelf.MapId=="chapter_one",8,"Chapter selection travel");
            uint revision=c.WorldSelf.MapRevision;var pos=world.Position;
            c.WorldTravel("next");await Until(()=>c.Status.StartsWith("Error:"),8,"Locked portal must reject");Require(c.WorldSelf.MapRevision==revision && c.WorldSelf.MapId=="chapter_one","Rejected portal must preserve membership");
            phase="pool leases";
            var pg=new GameObject("D38LeaseTest");var pool=pg.AddComponent<ZatodPoolManager>();pool.MaxRetained=2;pool.MaxPerKey=2;
            var first=pool.Acquire("object",pg.transform,()=>new GameObject("Pooled"));Require(pool.Release(first) && !pool.Release(first),"Double release guard");
            var second=pool.Acquire("object",pg.transform,()=>new GameObject("Pooled"));Require(second.Object==first.Object && !pool.Release(first),"Old lease cannot release new use");pool.Release(second);UnityEngine.Object.Destroy(pg);
            phase="equip receipt";
            var equipment=Field<ZatodEquipmentView>(view,"equipmentWindow");var hero=session.Account.HeroDesk[0];var slot=HeroProgression.CurrentRank(hero,catalog).EquipmentSlots.First(s=>catalog.Item(s.RequiredItemId).LevelRequirement<=hero.Level);
            c.AddItemByItemId(slot.RequiredItemId);await Until(()=>c.Snapshot.Account.Inventory.Any(i=>i.ItemId==slot.RequiredItemId),8,"Grant separate fixture item");
            equipment.Open(catalog,c.Snapshot.Account,c,campaign,hero.HeroInstanceId,slot.Id);equipment.ActionButton.onClick.Invoke();
            await Until(()=>!c.ItemOperationBusy && c.Snapshot.Account.HeroDesk[0].EquippedItems.Any(i=>i.SlotId==slot.Id),8,"Equip confirmation");
            Require(!equipment.gameObject.activeSelf,"Successful Equip must close its panel");
            // Reopening an already equipped slot stays open until the user closes it.
            equipment.Open(catalog,c.Snapshot.Account,c,campaign,hero.HeroInstanceId,slot.Id);equipment.Refresh(c.Snapshot.Account);Require(equipment.gameObject.activeSelf,"Viewing equipped item does not auto-close");equipment.Hide();
            phase="minor policy and server reject";
            var minor=campaign.Data.Chapters[0].Stages.First(s=>!s.KeyStage);session.Run.AcceptValidated(campaign.Prerequisite(minor.Id),true,3);session.Run.AcceptValidated(minor.Id,true,3);
            Call(c,"SendAccount",NetworkServer.connections[c.WorldSelf.ConnectionId],session,false);
            await Until(()=>c.Snapshot.Cleared.Contains(minor.Id),8,"Minor fixture progress sync");Call(view,"OpenStagePreview",minor.Id);
            Require(!preview.Challenge.interactable && preview.Notice.text.Contains("Passed"),"Passed minor is previewable but Challenge is disabled");
            long ownedRevision=c.Snapshot.Account.Revision;int stamina=c.Snapshot.Account.Stamina;c.Campaign(minor.Id,c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId));
            await Until(()=>c.Status.StartsWith("Error:"),8,"Direct Passed minor reject");Require(c.Snapshot.Account.Revision==ownedRevision && c.Snapshot.Account.Stamina==stamina && !session.CampaignInProgress,"Rejected begin must preserve resources");
            Call(view,"Show","campaign");
            phase="portals";
            // Isolated fixture unlocks the route only for travel testing; farm test remains natural.
            session.Account.Level=80;foreach(var stage in campaign.Data.Chapters.SelectMany(ch=>ch.Stages))session.Run.AcceptValidated(stage.Id,true,3);
            Call(c,"SendAccount",NetworkServer.connections[c.WorldSelf.ConnectionId],session,false);await Until(()=>c.Snapshot.Account.Level==80,8,"Fixture gates sync");
            var worlds=WorldDataJson.Load(campaign);
            foreach(var chapter in campaign.Data.Chapters.Skip(1).Concat(campaign.Data.Chapters.AsEnumerable().Reverse().Skip(1)))
            {
                var portal=worlds.Map(c.WorldSelf.MapId).Interactions.Single(p=>p.Kind==WorldInteractionKind.Portal && p.TargetId==chapter.WorldMapId);
                uint before=c.WorldSelf.MapRevision;c.WorldTravel(portal.Id);await Until(()=>c.WorldSelf.MapId==chapter.WorldMapId && c.WorldSelf.MapRevision>before,8,"Portal "+chapter.Id);
                var spawn=worlds.Spawn(chapter.WorldMapId,portal.DestinationSpawnId);Require(Vector2.Distance(world.Position,new Vector2(spawn.X,spawn.Y))<2,"Portal target spawn/interpolation");
            }
            c.WorldTravel("town");await Until(()=>c.WorldSelf.MapId=="town",8,"Return Town");
            phase="cycles and soak";c.AutoUltimate=true;
            session.Account.HeroDesk=new[]{"wl","ud","tb","titan_druid","br"}.Select(id=>catalog.CreateHero(id,"d38-soak-"+id)).ToList();session.Account.Formation=new HeroFormationData();
            foreach(var member in session.Account.HeroDesk)
            {
                member.Level=60;member.Stars=3;
                while(member.RankId!="purple")
                {
                    foreach(var gear in HeroProgression.CurrentRank(member,catalog).EquipmentSlots)HeroProgression.Equip(member,catalog,gear.Id,gear.RequiredItemId);
                    HeroProgression.Promote(member,catalog);
                }
                foreach(var skill in member.Skills)skill.Level=60;
            }
            Call(c,"SendAccount",NetworkServer.connections[c.WorldSelf.ConnectionId],session,false);await Until(()=>c.Snapshot.Account.HeroDesk[0].HeroDefinitionId=="wl",8,"Summon soak roster sync");
            observe=()=>{if(c.Battle?.Frame().Units.Any(unit=>unit.SummonerId>0)==true)summonFrames++;};c.FrameReceived+=observe;
            while(completed<cycles || EditorApplication.timeSinceStartup-began<seconds)
            {
                string stageId=new[]{"chapter_one_stage_1","chapter_four_stage_8","chapter_five_stage_17"}[completed%3];var chapter=campaign.ChapterFor(stageId);
                if(c.WorldSelf.MapId=="town"){c.ChapterTravel(chapter.Id);await Until(()=>c.WorldSelf.MapId==chapter.WorldMapId,8,"Cycle travel");}
                if(c.Snapshot.Account.Stamina<campaign.Stage(stageId).VitalityCost){session.Account.Stamina=300;Call(c,"SendAccount",NetworkServer.connections[c.WorldSelf.ConnectionId],session,false);await Until(()=>c.Snapshot.Account.Stamina>=campaign.Stage(stageId).VitalityCost,8,"Soak fixture stamina");}
                string last=c.LastReplay?.Initial.BattleId;c.Campaign(stageId,c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId));
                await Until(()=>c.Battle!=null && c.Battle.BattleId!=last && scenes.Phase==ZatodScenePhase.InBattle,25,"Cycle scene/preload: "+c.Status);
                var battleId=c.Battle.BattleId;Require(c.PreparedAssets?.Count>0,"Match dependencies must be retained before battle");
                await Until(()=>c.LastReplay?.Initial.BattleId==battleId && c.Snapshot.LastCampaignReward?.BattleId==battleId,300,"Cycle settlement: "+c.Status);
                Require(c.LastReplay.Digest==c.Battle.Replay().Digest,"Client/server/checker digest after pooling");
                reused+=scenes.Stage.Pool.Reused;created+=scenes.Stage.Pool.Created;Require(scenes.Stage.Pool.ActiveCount==scenes.Stage.EffectCount,"Pool active effect accounting");
                samples.Add(new{Cycle=completed+1,Seconds=EditorApplication.timeSinceStartup-began,Managed=GC.GetTotalMemory(false),Allocated=UnityEngine.Profiling.Profiler.GetTotalAllocatedMemoryLong(),Objects=Resources.FindObjectsOfTypeAll<GameObject>().Length,scenes.Stage.Pool.Created,scenes.Stage.Pool.Reused,scenes.Stage.Pool.Retained,Fps=1/Math.Max(.001,Time.unscaledDeltaTime)});
                Call(view,"Show","campaign");await Until(()=>scenes.Phase==ZatodScenePhase.World,8,"Cycle scene cleanup");
                Require((Field<ZatodPoolManager>(view,"floatingPool")?.ActiveCount??0)==0,"Returning World releases all combat-text leases");Require(!world.Suspended,"World resumes after battle");c.WorldTravel("town");await Until(()=>c.WorldSelf.MapId=="town",8,"Cycle Town return");
                completed++;File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="RUNNING",Phase=phase,Completed=completed,Seconds=EditorApplication.timeSinceStartup-began,Checks=checks,SummonFrames=summonFrames,Samples=samples},Newtonsoft.Json.Formatting.Indented));
            }
            Require(reused>0,"Effect pool must actually reuse objects");Require(summonFrames>0,"Soak must render actual summons");
            File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="PASS",Completed=completed,Seconds=EditorApplication.timeSinceStartup-began,Checks=checks,Created=created,Reused=reused,SummonFrames=summonFrames,Samples=samples},Newtonsoft.Json.Formatting.Indented));
        }
        catch(Exception e){File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Phase=phase,Completed=completed,Checks=checks,Battle=c.Battle?.Frame(),Error=e.ToString()},Newtonsoft.Json.Formatting.Indented));}
        finally{if(observe!=null)c.FrameReceived-=observe;if(pump!=null)EditorApplication.update-=pump;c.Disconnect();if(NetworkServer.active)NetworkServer.Shutdown();c.DevelopmentProfile=oldProfile;c.Port=oldPort;transport.port=oldTransport;c.AutoUltimate=oldAuto;PlayerPrefs.DeleteKey(key);PlayerPrefs.Save();}
    }
}
