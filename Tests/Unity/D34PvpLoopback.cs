// Run with Unity Pipeline inside the isolated build workspace.
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Mirror;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class D34PvpLoopback
{
    const BindingFlags Private = BindingFlags.Instance | BindingFlags.Static | BindingFlags.NonPublic;
    static readonly MethodInfo Assemble = typeof(ZatodConnection).GetMethod("Assemble", Private);
    static readonly MethodInfo Encode = typeof(ReplayArchive).GetMethod("EncodePayload", Private);
    static readonly MethodInfo Decode = typeof(ReplayArchive).GetMethod("DecodePayload", Private);
    static readonly string[] Picks = { "lion", "qop" };
    static T Read<T>(byte[] bytes) => (T)Decode.MakeGenericMethod(typeof(T)).Invoke(null, new object[] { bytes });

    static void Require(bool ok, string message)
    {
        if (!ok) throw new InvalidOperationException(message);
    }

    // A second TCP socket exercises the same Mirror messages without creating a second
    // Unity player. Only the primary connection drives the actual formation and HUD.
    sealed class Peer
    {
        readonly Telepathy.Client socket;
        readonly Batcher batcher;
        readonly Unbatcher unbatcher = new Unbatcher();
        object incoming;

        public readonly string AccountId = Guid.NewGuid().ToString("D");
        public ZatodAccountSnapshot Snapshot;
        public ZatodReplay Record;
        public ZatodBattleSimulation Battle;
        public int Team, ObservedTicks;
        public bool SawSummon;
        public Exception Error;
        public bool ExpectRejection;
        public ZatodNotice Rejection;
        public string LocalRosterKey;

        public Peer(TelepathyTransport transport)
        {
            int max = transport.GetMaxPacketSize(Channels.Reliable);
            socket = new Telepathy.Client(max);
            batcher = new Batcher(max);
            socket.OnConnected = () => Send("request", new ZatodRequest
            {
                Command = "hello", A = Guid.NewGuid().ToString("D"), B = AccountId, C = "D34 PvP peer"
            });
            socket.OnData = data =>
            {
                try { Receive(data); }
                catch (Exception error) { Error = error; }
            };
            socket.OnDisconnected = () =>
            {
                if (Record == null && Error == null) Error = new IOException("The PvP peer disconnected.");
            };
        }

        public void Connect(int port) => socket.Connect("127.0.0.1", port);
        public void Tick() => socket.Tick(512);
        public void Disconnect() => socket.Disconnect();
        public void Queue(params string[] heroes) => Send("request", new ZatodRequest { Command = "queue", Heroes = heroes, FreePvpRosterKey = LocalRosterKey });

        void Send<T>(string kind, T value)
        {
            var bytes = (byte[])Encode.Invoke(null, new object[] { value });
            Require(bytes.Length <= 8192, "Unexpectedly large message from the test peer.");
            using var message = NetworkWriterPool.Get();
            using var batch = NetworkWriterPool.Get();
            NetworkMessages.Pack(new ZatodPacket
            {
                id = Guid.NewGuid().ToString("N"), kind = kind, length = bytes.Length, index = 0, bytes = bytes
            }, message);
            batcher.AddMessage(message.ToArraySegment(), NetworkTime.localTime);
            while (batcher.GetBatch(batch))
            {
                Require(socket.Send(batch.ToArraySegment()), "Peer could not send to the fixture server.");
                batch.Reset();
            }
        }

        void Receive(ArraySegment<byte> bytes)
        {
            Require(unbatcher.AddBatch(bytes), "Peer could not decode a Mirror batch.");
            while (unbatcher.GetNextMessage(out var message, out _))
            {
                var reader = new NetworkReader(message);
                Require(NetworkMessages.UnpackId(reader, out var id), "Missing Mirror message ID.");
                if (id != NetworkMessageId<ZatodPacket>.Id) continue;
                var args = new object[] { incoming, reader.Read<ZatodPacket>() };
                var body = (byte[])Assemble.Invoke(null, args);
                incoming = args[0];
                if (body == null) continue;
                switch (((ZatodPacket)args[1]).kind)
                {
                    case "account": Snapshot = Read<ZatodAccountSnapshot>(body); break;
                    case "start":
                        var start = Read<ZatodStart>(body);
                        Team = start.Team;
                        Battle = new ZatodBattleSimulation(start.Match);
                        SendOperation();
                        break;
                    case "tick":
                        var tick = Read<ZatodTick>(body);
                        Require(tick.Tick == Battle.CurrentTick + 1, "Peer missed a committed tick.");
                        foreach (var input in tick.Inputs) Battle.QueueInput(input);
                        Battle.Step();
                        Require(Battle.Frame().Digest == tick.Digest, "Peer digest differs at tick " + tick.Tick);
                        SawSummon |= Battle.Frame().Units.Any(unit=>unit.SummonerId!=0);
                        ObservedTicks++;
                        if (!Battle.Finished) SendOperation();
                        break;
                    case "replay": Record = Read<ZatodReplay>(body); break;
                    case "error":
                        var rejection = Read<ZatodNotice>(body);
                        if (!ExpectRejection) throw new InvalidOperationException(rejection.Text);
                        ExpectRejection = false;
                        Rejection = rejection;
                        break;
                    case "abort": throw new InvalidOperationException(Read<ZatodNotice>(body).Text);
                }
            }
        }

        void SendOperation()
        {
            Send("operation", new ZatodOperation
            {
                BattleId = Battle.BattleId, Tick = Battle.CurrentTick + 1,
                Actors = Battle.Frame().Units.Where(u => u.Team == Team && u.CanActivateUltimate).Select(u => u.EntityId).ToList()
            });
        }
    }

    static ZatodSkillDefinition FixtureAttack(int id, int damage, int energyCost, int energyGain)
        => new ZatodSkillDefinition
        {
            SourceId = id, ActiveType = "active", TargetType = "target", TargetCamp = -1, AffectedCamp = -1,
            DamageType = "Holy", BasicAmount = damage, CostEnergy = energyCost, GainEnergy = energyGain,
            MaxRange = 1200, Cooldown = .8, GlobalCooldown = .3,
            Phases = new List<ZatodActionPhase> { new ZatodActionPhase { Action = "Attack", Duration = .75, AttackTimes = new List<double> { .375 } } }
        };

    static HeroCatalog FixtureCatalog(bool useSummons,bool native=false)
    {
        var data = HeroDataJson.LoadBundledCatalog().Data;
        if(native)return new HeroCatalog(data);
        for (int i = 0; i < Picks.Length; i++)
        {
            var hero = data.Heroes.Single(h => h.Id == Picks[i]);
            hero.AvailableInFreePvp = true;
            hero.Ranks.Last().NextRankId = "purple";
            hero.Ranks.Add(new HeroRankDefinition { Id = "purple", UnlockSkillSlotIds = new List<string> { "fixture_fourth" } });
            var normal = data.Skills.Single(s => s.Id == hero.NormalAttackSkillId);
            var ultimate = data.Skills.Single(s => s.Id == hero.SkillSlots.Single(h => h.IsUltimate).SkillId);
            int source = 900100 + i * 10;
            normal.Crystal = FixtureAttack(source, 280, 0, 1000);
            normal.Evolutions.Clear();
            ultimate.Crystal = FixtureAttack(source + 1, i == 0 ? 900 : 600, 1000, 0);
            ultimate.Evolutions.Clear();
            if(useSummons && i==0)
                ultimate.Crystal.Summon=new ZatodSummonDefinition
                {
                    Enabled=true, MonsterId=data.Monsters.First().Id, DurationSeconds=1, DamageMultiplier=.1
                };
            foreach (var slot in hero.SkillSlots.Where(s => !s.IsUltimate))
            {
                var skill = data.Skills.Single(s => s.Id == slot.SkillId);
                skill.Crystal.InitialCooldown = 999;
            }
            var fourth = normal.Copy();
            fourth.Id = "fixture_fourth_" + hero.Id;
            fourth.Crystal.SourceId = source + 2;
            fourth.Crystal.InitialCooldown = 999;
            data.Skills.Add(fourth);
            hero.SkillSlots.Add(new HeroSkillSlotDefinition { Id = "fixture_fourth", SkillId = fourth.Id, InitialLevel = 41 });
        }
        return new HeroCatalog(data);
    }

    public static string Arm(string output, int port)
        =>Start(output,port,false);

    public static string ArmSummons(string output,int port)
        =>Start(output,port,true);

    public static string ArmNative(string output,int port) => Start(output,port,false,true);

    static string Start(string output, int port,bool useSummons,bool native=false)
    {
        Require(EditorApplication.isPlaying && Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"), "Use the isolated validation Editor in Play Mode.");
        Require(!NetworkServer.active && !NetworkClient.active, "The isolated Editor must be disconnected.");
        Require(UnityEngine.Object.FindAnyObjectByType<ZatodConnection>()!=null, "Open the Zatod prototype scene before the live PvP fixture.");
        Directory.CreateDirectory(output);
        var report = Path.Combine(output, "pvp-loopback.json");
        File.WriteAllText(report, "{\"State\":\"RUNNING\"}");
        Run(output, report, (ushort)port,useSummons,native);
        return report;
    }

    static async void Run(string output, string report, ushort port,bool useSummons,bool native)
    {
        string[] Picks=native?new[]{"ursa","ursa"}:D34PvpLoopback.Picks;
        var c = UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();
        var view = c.GetComponent<ZatodPrototypeView>();
        var hud = (ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud", Private).GetValue(view);
        var transport = c.GetComponent<TelepathyTransport>();
        var formation = (ZatodFormationView)typeof(ZatodPrototypeView).GetField("formation", Private).GetValue(view);
        var viewCatalog = typeof(ZatodPrototypeView).GetField("catalog", Private);
        var previousCatalog = viewCatalog.GetValue(view);
        var clientCatalog = typeof(ZatodConnection).GetField("clientCatalog", Private);
        var previousClientCatalog = clientCatalog.GetValue(c);
        var oldPort = c.Port;
        var oldTransportPort = transport.port;
        var oldProfile = c.DevelopmentProfile;
        var profile = "d34-pvp-" + Guid.NewGuid().ToString("N");
        var effectiveProfile = ZatodConnection.Argument("--zatod-profile", ZatodConnection.Argument("--zatod-smoke", profile));
        var key = "ZatodPrototype.Account." + effectiveProfile;
        var previousKey = PlayerPrefs.HasKey(key) ? PlayerPrefs.GetString(key) : null;
        var accountId = Guid.NewGuid().ToString("D");
        var phase = "startup";
        bool started = false;
        int confirmedPending = 0;
        int portraitCastTick = -1;
        float portraitCastAlpha = 0;
        bool sawLocalSummon=false;
        var peer = new Peer(transport);
        Action attemptCast = null;
        EditorApplication.CallbackFunction pump = null;

        async Task Until(Func<bool> ready, double timeout, string failure)
        {
            var limit = EditorApplication.timeSinceStartup + timeout;
            while (!ready())
            {
                if (peer.Error != null) throw peer.Error;
                if (!EditorApplication.isPlaying || EditorApplication.timeSinceStartup > limit)
                    throw new TimeoutException(failure + " / " + c.Status + " / tick " + c.Battle?.CurrentTick);
                await Task.Delay(40);
            }
        }

        try
        {
            Require(effectiveProfile == profile || effectiveProfile.StartsWith("d35-", StringComparison.Ordinal), "Unknown command-line profile in the validation Editor.");
            var catalog = FixtureCatalog(useSummons,native);
            var archive = Path.Combine(output, profile);
            Directory.CreateDirectory(archive);
            c.DevelopmentProfile = profile;
            PlayerPrefs.SetString(key, accountId);
            c.Port = transport.port = port;
            typeof(ZatodConnection).GetMethod("StartServer", Private).Invoke(c, null);
            started = true;
            typeof(ZatodConnection).GetField("archiveDirectory", Private).SetValue(c, archive);
            typeof(ZatodConnection).GetField("catalog", Private).SetValue(c, catalog);
            viewCatalog.SetValue(view, catalog);
            clientCatalog.SetValue(c, catalog);
            peer.LocalRosterKey = catalog.FreePvp.CompatibilityKey;
            var updateWorld = typeof(ZatodConnection).GetMethod("UpdateWorldServer", Private);
            var updateRooms = typeof(ZatodConnection).GetMethod("UpdateRooms", Private);
            var queue = (IList)typeof(ZatodConnection).GetField("queue", Private).GetValue(c);
            var queuedTeams = (Dictionary<int, List<HeroData>>)typeof(ZatodConnection).GetField("queuedTeams", Private).GetValue(c);
            pump = () =>
            {
                if (!NetworkServer.active) return;
                peer.Tick();
                updateWorld.Invoke(c, null);
                updateRooms.Invoke(c, null);
            };
            EditorApplication.update += pump;

            phase = "login";
            c.JoinLan("D34 PvP fixture", "127.0.0.1");
            peer.Connect(port);
            await Until(() => c.Connected && c.Snapshot?.Account.CharacterId == accountId &&
                peer.Snapshot?.Account.CharacterId == peer.AccountId, 12, "Both clients must receive their accounts");
            Require(c.Snapshot.FreePvpHeroIds.OrderBy(x => x).SequenceEqual(catalog.FreePvp.HeroIds.OrderBy(x => x)), "Server did not advertise the fixture roster.");
            Require(c.Snapshot.FreePvpRosterKey == peer.LocalRosterKey, "Server did not advertise the expected compatibility key.");
            string originalOwned = Newtonsoft.Json.JsonConvert.SerializeObject(c.Snapshot.Account.HeroDesk);
            string peerOwned = Newtonsoft.Json.JsonConvert.SerializeObject(peer.Snapshot.Account.HeroDesk);
            Require(c.Snapshot.Account.HeroDesk.All(h => !Picks.Contains(h.HeroDefinitionId)), "Fixture picks should be unowned.");

            phase = "mixed catalog";
            var show = typeof(ZatodPrototypeView).GetMethod("Show", Private);
            var staleData = FixtureCatalog(useSummons,native).Data;
            staleData.Heroes.Single(h => h.Id == Picks[1]).AvailableInFreePvp = false;
            var stale = new HeroCatalog(staleData);
            Require(stale.Data.ConfigVersion == catalog.Data.ConfigVersion && stale.FreePvp.CompatibilityKey != peer.LocalRosterKey,
                "The mixed catalog fixture did not isolate the roster difference.");
            viewCatalog.SetValue(view, stale);
            clientCatalog.SetValue(c, stale);
            show.Invoke(view, new object[] { "pvp" });
            Require(formation.RosterCards.Count == 0 && !formation.Battle.interactable && formation.Notice.text.Contains("roster differs"),
                "The UI offered a partially supported free roster.");
            c.FindPvp(new[] { Picks[0] });
            Require(queue.Count == 0 && !c.FindingPvp && c.Status.Contains("roster differs"), "The client queued with an incomplete roster.");
            clientCatalog.SetValue(c, catalog);
            viewCatalog.SetValue(view, catalog);
            int rejections = 0;
            void ObserveRejection() { if (c.Status.Contains("roster differs")) rejections++; }
            c.Changed += ObserveRejection;
            try
            {
                c.Request(new ZatodRequest { Command = "queue", Heroes = new[] { Picks[0] }, FreePvpRosterKey = stale.FreePvp.CompatibilityKey });
                await Until(() => rejections >= 1 && queue.Count == 0, 8, "Server let a stale roster join the queue");
                c.Request(new ZatodRequest { Command = "queue", Heroes = new[] { Picks[0] } });
                await Until(() => rejections >= 2 && queue.Count == 0, 8, "Server accepted an old client without a roster key");
            }
            finally { c.Changed -= ObserveRejection; }

            phase = "eligibility and cancel";
            c.FindPvp(new[] { c.Snapshot.Account.HeroDesk[0].HeroInstanceId });
            await Until(() => c.Status.Contains("outside the free PvP roster"), 8, "PvP accepted an owned-instance ID");
            Require(queue.Count == 0 && !c.FindingPvp, "Rejected pick entered the queue.");

            if(native)
            {
                int invalidTeams=0;
                void InvalidTeam(){if(c.Status.Contains("1–5 distinct"))invalidTeams++;}
                c.Changed+=InvalidTeam;
                try
                {
                    c.Request(new ZatodRequest{Command="queue",Heroes=catalog.FreePvp.HeroIds.Take(6).ToArray(),FreePvpRosterKey=peer.LocalRosterKey});
                    await Until(()=>invalidTeams>=1 && queue.Count==0,8,"Server accepted six free Heroes");
                    c.Request(new ZatodRequest{Command="queue",Heroes=new[]{Picks[0],Picks[0]},FreePvpRosterKey=peer.LocalRosterKey});
                    await Until(()=>invalidTeams>=2 && queue.Count==0,8,"Server accepted duplicate free Heroes");
                }
                finally{c.Changed-=InvalidTeam;}
            }

            var starter = c.Snapshot.Account.HeroDesk[0];
            c.Campaign("chapter_one_stage_1", new[] { starter.HeroInstanceId });
            await Until(() => c.Battle?.Mode == ZatodMode.Campaign, 12, "Campaign did not start for the queue guard");
            c.Request(new ZatodRequest { Command = "queue", Heroes = new[] { Picks[0] }, FreePvpRosterKey = peer.LocalRosterKey });
            await Until(() => c.Status.Contains("Finish or cancel Campaign before joining PvP"), 8, "Server accepted PvP during an open Campaign match");
            Require(queue.Count == 0 && c.Battle?.Mode == ZatodMode.Campaign, "Rejected queue attempt interrupted Campaign.");
            c.Cancel();
            await Until(() => c.Status.StartsWith("Connected", StringComparison.Ordinal), 8, "Campaign cancel did not finish");

            show.Invoke(view, new object[] { "pvp" });
            Require(formation.RosterCards.Count == catalog.FreePvp.HeroIds.Count && formation.RosterCards.Any(card => card.InstanceId == Picks[0]), "Formation did not show unowned picks.");
            formation.Toggle(Picks[0]);
            formation.Battle.onClick.Invoke();
            await Until(() => queue.Count == 1 && c.FindingPvp, 8, "Formation did not join PvP");
            c.Arena(new[] { starter.HeroInstanceId });
            await Until(() => c.Status.Contains("Cancel PvP before changing mode"), 8, "Arena request was not rejected while queued");
            Require(queue.Count == 1 && c.FindingPvp && formation.Pending, "Unrelated error cleared the waiting status.");
            c.Cancel();
            await Until(() => queue.Count == 0 && !c.FindingPvp, 8, "Cancel did not remove the waiting player");

            phase = "reconnect queued player";
            await Until(()=>c.Status.StartsWith("Connected",StringComparison.Ordinal),8,"Cancel acknowledgement did not arrive");
            show.Invoke(view,new object[]{"pvp"});
            formation.Battle.onClick.Invoke();
            await Until(() => queue.Count == 1 && c.FindingPvp, 8, "Could not queue before reconnect");
            c.Disconnect();
            await Until(() => !c.Connected && queue.Count == 0 && queuedTeams.Count == 0, 8, "Disconnect left stale queued presets");
            c.JoinLan("D34 PvP fixture", "127.0.0.1");
            await Until(() => c.Connected && c.WorldSelf != null && c.Snapshot?.Account.CharacterId == accountId &&
                c.Status.StartsWith("Connected", StringComparison.Ordinal), 12, "Account did not reconnect");
            Require(!c.FindingPvp && queue.Count == 0, "Reconnect restored an old queue entry.");

            phase = "failed pairing";
            show.Invoke(view, new object[] { "pvp" });
            formation.Battle.onClick.Invoke();
            await Until(() => queue.Count == 1 && c.FindingPvp, 8, "Could not enter queue for the failure test");
            queuedTeams.Values.Single().Single().RankId = "invalid_fixture_rank";
            peer.ExpectRejection = true;
            peer.Queue(Picks[1]);
            await Until(() => !c.FindingPvp && peer.Rejection != null && queue.Count == 0, 8, "Pairing failure stranded a player in the queue");
            Require(c.Status.Contains("PvP could not start") && !peer.Rejection.PvpQueued && queuedTeams.Count == 0 && peer.Battle == null,
                "Both players did not receive a retryable failure.");

            phase = "pair";
            string[] leftTeam=native?new[]{Picks[0],"naga","vs","luna","kotl"}:new[]{Picks[0]};
            string[] rightTeam=native?new[]{Picks[1],"naga","vs","luna","kotl"}:new[]{Picks[1]};
            show.Invoke(view, new object[] { "pvp" });
            foreach(string id in leftTeam.Skip(1))formation.Toggle(id);
            if(native)
            {
                formation.Toggle("od");
                Require(formation.TeamCards.Count(card=>card.Root.gameObject.activeSelf)==5 && !formation.TeamCards.Any(card=>card.InstanceId=="od"),"Formation accepted a sixth Hero");
            }
            formation.Battle.onClick.Invoke();
            await Until(() => queue.Count == 1, 8, "Main client did not rejoin");
            peer.Queue(rightTeam);
            await Until(() => c.Battle?.Mode == ZatodMode.RealtimePvp && peer.Battle != null, 12, "Players were not paired");
            Require(c.Team == 0 && peer.Team == 1 && c.Battle.BattleId == peer.Battle.BattleId, "Clients did not receive the same match.");
            var first = c.Battle.Replay().Initial;
            var picked = first.Players.Concat(first.Waves.Single().Enemies).ToArray();
            string expectedRule=native?ZatodMatchDefinition.ExpandedRulesV7:useSummons?ZatodMatchDefinition.SummonRulesV6:ZatodMatchDefinition.SkillEvolutionRulesV4;
            Require(first.RulesVersion == expectedRule &&
                picked.Select(x => x.DefinitionId).SequenceEqual(leftTeam.Concat(rightTeam)) &&
                picked.All(x => x.Level == 60 && x.Stars == 3 && x.RankId == "purple" &&
                    x.Battle.Skills.Count == 4 && x.Battle.Skills.All(s => s.Level == 60)), "The match did not get the free Purple presets.");
            Require(first.SummonUnits.Count==(useSummons?1:0),"Match payload has incorrect summon templates.");

            phase = "fight";
            File.WriteAllText(report, "{\"State\":\"RUNNING\",\"Phase\":\"Both peers entered PvP\"}");
            attemptCast = () =>
            {
                var frame=c.Battle.Frame();
                sawLocalSummon|=frame.Units.Any(unit=>unit.SummonerId!=0);
                var card = hud.Cards[0];
                var caster = frame.Units.FirstOrDefault(u => u.EntityId==first.Players[0].EntityId && u.UltimateCastTick == frame.Tick);
                if (portraitCastTick < 0 && caster != null && card.Ready.gameObject.activeInHierarchy &&
                    (native?card.CastCue.GetComponent<UnityEngine.UI.Image>().enabled:card.Portrait.rectTransform.localScale.x > 1 && card.UltimateEdges[0].color.b > .9f))
                {
                    portraitCastTick = frame.Tick;
                    portraitCastAlpha = card.UltimateSignal.alpha;
                }
                var actor = frame.Units.FirstOrDefault(u => u.EntityId==first.Players[0].EntityId && u.CanActivateUltimate);
                if (actor == null || !card.Root.gameObject.activeInHierarchy || !card.Button.interactable) return;
                var tap = new PointerEventData(EventSystem.current) { button = PointerEventData.InputButton.Left };
                card.Button.OnPointerClick(tap);
                if (c.UltimatePending(actor.EntityId) && !card.Button.interactable && !c.Ultimate(actor.EntityId) &&
                    Mathf.Approximately(card.UltimateSignal.alpha, .34f)) confirmedPending++;
            };
            c.FrameReceived += attemptCast;
            await Until(() => c.LastReplay?.Initial.Mode == ZatodMode.RealtimePvp && peer.Record != null &&
                c.Snapshot.Replays.Contains(c.LastReplay.Initial.BattleId) && peer.Snapshot.Replays.Contains(peer.Record.Initial.BattleId),
                110, "Match did not produce both final records");

            phase = "archive and ownership";
            var record = c.LastReplay;
            var stored = File.ReadAllBytes(Path.Combine(archive, record.Initial.BattleId + ".zatod.gz"));
            Require(record.Digest == peer.Record.Digest && record.Digest == peer.Battle.Frame().Digest &&
                record.Digest == c.Battle.Frame().Digest && record.Digest == ZatodBattleSimulation.Resimulate(record).Digest &&
                record.Digest == Read<ZatodReplay>(stored).Digest, "Client, peer, replay or disk archive diverged.");
            Require(peer.ObservedTicks == record.EndTick && confirmedPending > 0 &&
                record.Inputs.Select(input => input.Team).Distinct().OrderBy(team => team).SequenceEqual(new[] { 0, 1 }),
                "Realtime manual input was not exercised on both teams.");
            Require(portraitCastTick >= 0, "No cast confirmation reached the local portrait.");
            var scenes = view.GetComponent<ZatodBattleSceneController>();
            await Until(() => scenes.Phase == ZatodScenePhase.InBattle, 5, "The replay scene was not available");
            typeof(ZatodPrototypeView).GetMethod("Seek", Private).Invoke(view, new object[] { portraitCastTick });
            var replayCard = hud.Cards[0];
            Require(!replayCard.Button.interactable && replayCard.Ready.gameObject.activeInHierarchy &&
                Mathf.Abs(replayCard.UltimateSignal.alpha-portraitCastAlpha) < .015f &&
                (native?replayCard.CastCue.GetComponent<UnityEngine.UI.Image>().enabled:replayCard.Portrait.rectTransform.localScale.x > 1 && replayCard.UltimateEdges[0].color.b > .9f),
                "Seeking to the cast did not reproduce its portrait confirmation with input disabled.");
            Require(sawLocalSummon==useSummons && peer.SawSummon==useSummons,
                "The primary or peer did not observe the expected summon state.");
            Require(originalOwned == Newtonsoft.Json.JsonConvert.SerializeObject(c.Snapshot.Account.HeroDesk) &&
                peerOwned == Newtonsoft.Json.JsonConvert.SerializeObject(peer.Snapshot.Account.HeroDesk), "PvP modified owned heroes.");

            phase = "owned modes";
            var owned = c.Snapshot.Account.HeroDesk[0];
            c.Arena(new[] { owned.HeroInstanceId });
            await Until(() => c.LastReplay?.Initial.Mode == ZatodMode.Arena, 12, "Arena no longer accepts owned picks");
            Require(c.LastReplay.Initial.Players.Single().DefinitionId == owned.HeroDefinitionId &&
                c.LastReplay.Initial.Players.Single().Level == owned.Level, "Arena used the PvP preset.");
            c.Campaign("chapter_one_stage_1", new[] { owned.HeroInstanceId });
            await Until(() => c.Battle?.Mode == ZatodMode.Campaign, 12, "Campaign no longer accepts owned picks");
            var campaignHero = c.Battle.Replay().Initial.Players.Single();
            Require(campaignHero.DefinitionId == owned.HeroDefinitionId && campaignHero.Level == owned.Level,
                "Campaign used the PvP preset.");
            c.Cancel();
            await Until(() => c.Status.StartsWith("Connected",StringComparison.Ordinal), 8, "Campaign cancel was not acknowledged");

            File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                State = "PASS", NativeCatalog=native, FreeRosterCount=catalog.FreePvp.HeroIds.Count, Rule = record.Initial.RulesVersion, record.EndTick, record.Winner, Digest = record.Digest.ToString(),
                Picks, LeftTeam=leftTeam, RightTeam=rightTeam, ConfirmedLocalPendingGuards = confirmedPending, InputCountsByTeam = record.Inputs.GroupBy(i => i.Team).ToDictionary(g => g.Key,g => g.Count()),
                PortraitCastTick = portraitCastTick, ReplayPortraitCastVerified = true,
                FreeRosterEligibility = true, CancelAndRequeue = true, OwnedHeroDeskUnchanged = true,
                CampaignGuard = true, WaitingAfterRejection = true, ReconnectClearedQueue = true, BothRecoveredFromPairFailure = true,
                IncompleteRosterBlockedInUi = true, ServerRejectedOldAndStaleClients = true,
                ArenaAndCampaignUseOwnedHeroes = true, BothClientsSawSummon=sawLocalSummon && peer.SawSummon
            }, Newtonsoft.Json.Formatting.Indented));
        }
        catch (Exception error)
        {
            File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                State = "FAIL", Phase = phase, Error = error.ToString(), PeerTicks = peer.ObservedTicks, LocalTick = c.Battle?.CurrentTick, FormationActive=formation.gameObject.activeInHierarchy, formation.Pending, ButtonEnabled=formation.Battle.interactable, c.FindingPvp, Selection=((System.Collections.IEnumerable)typeof(ZatodPrototypeView).GetField("freePvpSelected",Private)?.GetValue(view))
            }, Newtonsoft.Json.Formatting.Indented));
        }
        finally
        {
            if (attemptCast != null) c.FrameReceived -= attemptCast;
            if (pump != null) EditorApplication.update -= pump;
            peer.Disconnect();
            c.Disconnect();
            if (started && NetworkServer.active) NetworkServer.Shutdown();
            viewCatalog.SetValue(view, previousCatalog);
            clientCatalog.SetValue(c, previousClientCatalog);
            c.Port = oldPort; transport.port = oldTransportPort; c.DevelopmentProfile = oldProfile;
            if (previousKey == null) PlayerPrefs.DeleteKey(key); else PlayerPrefs.SetString(key, previousKey);
            PlayerPrefs.Save();
        }
    }
}
