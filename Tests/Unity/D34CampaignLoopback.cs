// Run through Unity Pipeline script run in the isolated build workspace.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Mirror;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
using Zatod.World;

public static class D34CampaignLoopback
{
    const BindingFlags Private = BindingFlags.Instance | BindingFlags.NonPublic;

    static void Require(bool condition, string message)
    {
        if (!condition) throw new InvalidOperationException(message);
    }

    static async Task Until(Func<bool> ready, double timeout, string message)
    {
        var limit = EditorApplication.timeSinceStartup + timeout;
        while (!ready())
        {
            if (!EditorApplication.isPlaying || EditorApplication.timeSinceStartup > limit) throw new TimeoutException(message);
            await Task.Delay(40);
        }
    }

    public static string Arm(string output, int port)
    {
        Require(EditorApplication.isPlaying && Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"), "Use the isolated validation Editor in Play Mode.");
        Require(!NetworkServer.active && !NetworkClient.active, "The isolated Editor must be disconnected.");
        var connection = UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();
        Require(connection != null && connection.GetComponent<ZatodPrototypeView>() != null &&
            connection.GetComponent<ZatodBattleSceneController>() != null && connection.GetComponent<TelepathyTransport>() != null,
            "Open the ZatodPrototype scene before starting the Campaign fixture.");
        Directory.CreateDirectory(output);
        var report = Path.Combine(output, "campaign-loopback.json");
        File.WriteAllText(report, "{\"State\":\"RUNNING\"}");
        Run(output, report, (ushort)port, connection);
        return report;
    }

    static async void Run(string output, string report, ushort port, ZatodConnection c)
    {
        var view = c.GetComponent<ZatodPrototypeView>();
        var scenes = c.GetComponent<ZatodBattleSceneController>();
        var transport = c.GetComponent<TelepathyTransport>();
        var profile = "d34-campaign-" + Guid.NewGuid().ToString("N");
        var accountId = Guid.NewGuid().ToString("D");
        var prefsEffective = ZatodConnection.Argument("--zatod-profile", ZatodConnection.Argument("--zatod-smoke", profile));
        string prefsKey = "ZatodPrototype.Account."+prefsEffective;
        var priorPrefs = PlayerPrefs.HasKey(prefsKey) ? PlayerPrefs.GetString(prefsKey) : null;
        var oldProfile = c.DevelopmentProfile;
        var oldPort = c.Port;
        var oldTransportPort = transport.port;
        var oldAuto = c.AutoUltimate;
        var archiveDirectory = Path.Combine(output, profile);
        var entries = new Dictionary<int, List<ZatodFrame>>();
        bool sawEntryOnStage = false;
        int portalTransitions=0,stagePreviews=0;
        string phase = "startup";
        EditorApplication.CallbackFunction pump = null;
        Action observe = null;
        try
        {
            Require(prefsEffective == profile || prefsEffective.StartsWith("d35-",StringComparison.Ordinal), "Unknown command-line profile in the validation Editor.");
            c.DevelopmentProfile = profile;
            PlayerPrefs.SetString(prefsKey, accountId);
            c.Port = transport.port = port;
            Directory.CreateDirectory(archiveDirectory);
            typeof(ZatodConnection).GetMethod("StartServer", Private).Invoke(c,null);
            typeof(ZatodConnection).GetField("archiveDirectory", Private).SetValue(c, archiveDirectory);
            pump = () =>
            {
                if (NetworkServer.active)
                {
                    typeof(ZatodConnection).GetMethod("UpdateWorldServer",Private).Invoke(c,null);
                    typeof(ZatodConnection).GetMethod("UpdateEconomyServer",Private).Invoke(c,null);
                }
            };
            EditorApplication.update += pump;

            phase = "login";
            c.JoinLan("D34 Campaign fixture", "127.0.0.1");
            await Until(() => c.Connected && c.Snapshot?.Account.CharacterId==accountId, 12, "Loopback login failed: "+c.Status);
            Require(c.Snapshot.Account.HeroDesk.Count==5 && c.Snapshot.Account.HeroDesk.All(h=>h.Level==1), "Expected five level-1 starters.");
            Require(c.Snapshot.Account.Inventory.Count==0, "Expected a fresh inventory.");
            string[] heroes=c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray();
            var nativeCatalog=HeroDataJson.LoadBundledCatalog();
            if(nativeCatalog.Data.UseExpandedCombatRules)
            {
                phase="world routes and previews";
                var campaign=CampaignDataJson.LoadZatod(nativeCatalog);var worlds=WorldDataJson.Load(campaign);
                await Until(()=>c.WorldSelf!=null,8,"Missing live world membership");
                var route=campaign.Data.Chapters.Select(ch=>ch.WorldMapId).ToArray();
                foreach(string destination in route.Concat(route.Reverse().Skip(1)))
                {
                    string current=c.WorldSelf.MapId;
                    var portal=worlds.Map(current).Interactions.Single(point=>point.Kind==WorldInteractionKind.Portal && point.TargetId==destination);
                    uint revision=c.WorldSelf.MapRevision;c.WorldTravel(portal.Id);
                    await Until(()=>c.WorldSelf?.MapId==destination && c.WorldSelf.MapRevision>revision,8,"Portal did not transfer the player to "+destination);
                    var spawn=worlds.Spawn(destination,portal.DestinationSpawnId);
                    Require(Math.Abs(c.WorldSelf.X-spawn.X)<2 && Math.Abs(c.WorldSelf.Y-spawn.Y)<2,"Portal used an incorrect return spawn");
                    portalTransitions++;
                }
                var open=typeof(ZatodPrototypeView).GetMethod("OpenStagePreview",Private);
                var preview=(ZatodStagePreviewView)typeof(ZatodPrototypeView).GetField("stagePreview",Private).GetValue(view);
                foreach(var stage in campaign.Data.Chapters.SelectMany(ch=>ch.Stages))
                {
                    open.Invoke(view,new object[]{stage.Id});
                    Require(preview.Title.text==stage.Name,"Native stage preview selected the wrong encounter: "+stage.Id);
                    stagePreviews++;
                }
                typeof(ZatodPrototypeView).GetMethod("Show",Private).Invoke(view,new object[]{"campaign"});
            }
            observe = () =>
            {
                if (c.Battle==null) return;
                var frame=c.Battle.Frame();
                if (frame.WaveEntryRemaining<=0) return;
                if (!entries.TryGetValue(frame.Wave,out var frames)) entries[frame.Wave]=frames=new List<ZatodFrame>();
                if (frames.All(f=>f.Tick!=frame.Tick)) frames.Add(frame);
                sawEntryOnStage |= scenes.Phase==ZatodScenePhase.InBattle && scenes.Stage.UnitCount>0;
            };
            c.FrameReceived += observe;
            c.AutoUltimate=true;

            phase = "campaign";
            c.Campaign("chapter_one_stage_1",heroes);
            await Until(() => c.Battle?.Mode==ZatodMode.Campaign && scenes.Phase==ZatodScenePhase.InBattle, 12, "Campaign scene failed: "+c.Status);
            File.WriteAllText(report, "{\"State\":\"RUNNING\",\"Phase\":\"Campaign scene loaded\"}");
            await Until(() => c.LastReplay?.Initial.Mode==ZatodMode.Campaign && c.Snapshot.LastCampaignReward?.BattleId==c.LastReplay.Initial.BattleId,
                100, "Campaign failed to settle: "+c.Status);

            phase = "verify";
            var replay=c.LastReplay;
            var local=c.Battle.Replay();
            Require(replay.Initial.RulesVersion==(HeroDataJson.LoadBundledCatalog().Data.UseExpandedCombatRules?ZatodMatchDefinition.ExpandedRulesV7:ZatodMatchDefinition.WaveEntryRulesV5) && replay.Winner==0, "Expected a validated campaign win under the catalog rules.");
            Require(replay.Digest==local.Digest && replay.EndTick==local.EndTick, "Server result differs from the client.");
            Require(entries.Keys.OrderBy(x=>x).SequenceEqual(new[]{2,3}) && sawEntryOnStage, "Did not observe both wave transitions on the live stage.");
            foreach(var frames in entries.Values)
            {
                Require(frames.Count==6 && frames[0].WaveEntryRemaining==.75 && frames[5].WaveEntryRemaining==.125 &&
                    frames.All(f=>f.TimeRemaining==frames[0].TimeRemaining && f.Units.Where(u=>u.Team==1).All(u=>u.Hp==u.MaxHp)),
                    "Expected all six entry ticks with no combat or timer movement.");
            }
            Require(c.Snapshot.Cleared.Contains("chapter_one_stage_1"), "Validated win did not unlock progression.");
            var reward=c.Snapshot.LastCampaignReward;
            var gold=CurrencyBalance.GetGold(c.Snapshot.Account);
            Require(gold>0 && reward.Economy.Heroes.Count==5, "Missing natural campaign rewards.");

            phase = "replay";
            var hud=(ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud",Private).GetValue(view);
            Require(hud.WatchReplay.interactable,"Replay button was not enabled after validation.");
            hud.WatchReplay.onClick.Invoke();
            var seek=(UnityEngine.UI.Slider)typeof(ZatodPrototypeView).GetField("seek",Private).GetValue(view);
            var introTick=entries[2].First().Tick;
            var remainder=typeof(ZatodPrototypeView).GetField("replayElapsed",Private);
            var label=(TMPro.TextMeshProUGUI)typeof(ZatodPrototypeView).GetField("playLabel",Private).GetValue(view);
            remainder.SetValue(view,.09f);
            seek.value=introTick/(float)replay.EndTick;
            Require(label.text=="Phát" && (float)remainder.GetValue(view)==0,"Seek retained a stale playback label or time remainder.");
            var visibleReplay=(ZatodBattleSimulation)typeof(ZatodPrototypeView).GetField("replay",Private).GetValue(view);
            Require(visibleReplay.CurrentTick==introTick && visibleReplay.Frame().WaveEntryRemaining==.75, "Replay did not seek to the first wave entry tick.");
            await Task.Delay(280);
            Require(visibleReplay.CurrentTick==introTick, "Replay advanced while paused.");
            var speed=hud.ReplayControls.GetComponentsInChildren<UnityEngine.UI.Button>(true).Single(b=>b.name=="Tốc độ");
            speed.onClick.Invoke();speed.onClick.Invoke();
            Require((float)typeof(ZatodPrototypeView).GetField("speed",Private).GetValue(view)==4,"Replay did not set x4.");
            var toggle=(UnityEngine.UI.Button)typeof(ZatodPrototypeView).GetField("playbackButton",Private).GetValue(view);
            toggle.onClick.Invoke();
            Require(label.text=="Tạm dừng","Resume did not update the replay control.");
            await Until(()=>visibleReplay.CurrentTick>=introTick+10, 5, "Replay did not resume at x4.");

            File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                State="PASS", Destination="127.0.0.1:"+port, PortalTransitions=portalTransitions, StagePreviews=stagePreviews, Rule=replay.Initial.RulesVersion, replay.EndTick,
                Digest=replay.Digest.ToString(), replay.Winner, EntryWaves=entries.ToDictionary(p=>p.Key,p=>p.Value.Count),
                Gold=gold, Starters=heroes.Length, CampaignRewards=c.Snapshot.Account.CampaignRewards.Count, ReplaySeekTick=introTick,
                ReplayPaused=true, Replay4x=true
            },Newtonsoft.Json.Formatting.Indented));
        }
        catch(Exception error)
        {
            File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Phase=phase,Error=error.ToString()},Newtonsoft.Json.Formatting.Indented));
        }
        finally
        {
            if(observe!=null)c.FrameReceived-=observe;
            if(pump!=null)EditorApplication.update-=pump;
            c.Disconnect();
            if(NetworkServer.active)NetworkServer.Shutdown();
            c.Port=oldPort;transport.port=oldTransportPort;c.AutoUltimate=oldAuto;c.DevelopmentProfile=oldProfile;
            if(priorPrefs==null)PlayerPrefs.DeleteKey(prefsKey);else PlayerPrefs.SetString(prefsKey,priorPrefs);
            PlayerPrefs.Save();
        }
    }
}
