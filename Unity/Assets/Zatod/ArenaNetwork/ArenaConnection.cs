using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;
using Mirror;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;

namespace Zatod.Networking
{
    [DefaultExecutionOrder(-200)]
    [RequireComponent(typeof(TelepathyTransport))]
    public sealed partial class ArenaConnection : MonoBehaviour
    {
        public const int ChunkSize = 8192;
        public string Address = "127.0.0.1";
        public ushort Port = 7777;
        public bool IsServer { get; private set; }
        public bool Connected { get { return !IsServer && NetworkClient.isConnected; } }
        public bool Busy { get; private set; }
        public string Status { get; private set; } = "Connect to a dedicated server to begin.";
        public string LastBattleId { get; private set; }
        public ReplaySummary[] Catalog { get; private set; } = Array.Empty<ReplaySummary>();
        public BattleRecord LastRecord { get; private set; }
        public event Action<BattleRecord> ReplayReceived;
        public event Action CatalogChanged;
        public event Action StatusChanged;
        public event Action CampaignProgressChanged;
        public string[] CampaignClearedStageIds{get;private set;}=Array.Empty<string>();
        public bool CampaignProgressReady { get; private set; }
        ReplayRepository repository;
        readonly HashSet<string> inFlight = new HashSet<string>();
        readonly Dictionary<int, double> lastRequest = new Dictionary<int, double>();
        byte[] incoming;
        ReplayBegin transfer;
        int nextChunk;
        float deadline;
        string pendingRequestId;
        HeroCatalog serverCatalog;
        CampaignServerState campaignState;
        bool shuttingDownClient;
        public string[] SelectedHeroInstanceIds { get; set; }

        void Start()
        {
            Application.runInBackground = true;
            var transport = GetComponent<TelepathyTransport>();
            transport.port = Port = ReadPort();
            Transport.active = transport;
            IsServer = Array.IndexOf(Environment.GetCommandLineArgs(), "--arena-server") >= 0;
#if UNITY_SERVER
            IsServer = true;
#endif
            Application.targetFrameRate = IsServer ? 30 : 60;
            if (IsServer) StartDedicatedServer();
            else
            {
                Address = Argument("--server", Address);
                if (Array.IndexOf(Environment.GetCommandLineArgs(), "--arena-smoke") >= 0)
                { gameObject.AddComponent<ArenaSmokeClient>(); Connect(); }
                else if (Array.IndexOf(Environment.GetCommandLineArgs(), "--campaign-smoke") >= 0)
                { gameObject.AddComponent<CampaignSmokeClient>(); Connect(); }
            }
        }

        void Update()
        {
            if (!IsServer && Busy && Time.realtimeSinceStartup > deadline)
            {
                Busy = false; incoming = null;
                SetStatus("Request timed out. Reconnect and load server history; committed results remain saved.");
            }
        }

        void StartDedicatedServer()
        {
            serverCatalog = HeroDataJson.LoadBundledCatalog();
            repository = new ReplayRepository(Argument("--data-dir", Path.Combine(Application.persistentDataPath, "ArenaServer")));
            campaignState=new CampaignServerState(CampaignDataJson.Load(serverCatalog),serverCatalog,repository);
            NetworkServer.RegisterHandler<ChallengeRequest>(OnChallenge, false);
            NetworkServer.RegisterHandler<CampaignChallengeRequest>(OnCampaignChallenge,false);
            NetworkServer.RegisterHandler<UltimateRequest>(OnUltimateRequest,false);
            NetworkServer.RegisterHandler<ReplayRequest>(OnReplayRequest, false);
            NetworkServer.RegisterHandler<CatalogRequest>((conn, _) => SendCatalog(conn), false);
            NetworkServer.OnDisconnectedEvent += conn => lastRequest.Remove(conn.connectionId);
            NetworkServer.Listen(32);
            SetStatus("Dedicated server listening on TCP " + Port);
            Debug.Log("[ArenaServer] READY port=" + Port + " data=" + repository.DirectoryPath + " localClient=" + NetworkClient.active);
        }

        public void Connect()
        {
            if (IsServer || NetworkClient.active) return;
            GetComponent<TelepathyTransport>().port = Port;
            CampaignProgressReady = false;
            NetworkClient.OnConnectedEvent += OnConnected;
            NetworkClient.OnDisconnectedEvent += OnDisconnected;
            NetworkClient.OnErrorEvent += OnClientError;
            NetworkClient.RegisterHandler<ArenaFailure>(OnFailure, false);
            NetworkClient.RegisterHandler<UltimateResponse>(message=>UltimateResponded?.Invoke(message),false);
            NetworkClient.RegisterHandler<CampaignProgressResponse>(message=>{CampaignClearedStageIds=message.clearedStageIds??Array.Empty<string>();CampaignProgressReady=true;CampaignProgressChanged?.Invoke();},false);
            NetworkClient.RegisterHandler<CatalogResponse>(message => { Catalog = message.replays ?? Array.Empty<ReplaySummary>(); CatalogChanged?.Invoke(); }, false);
            NetworkClient.RegisterHandler<ReplayBegin>(OnReplayBegin, false);
            NetworkClient.RegisterHandler<ReplayChunk>(OnReplayChunk, false);
            SetStatus("Connecting to " + Address + ":" + Port + "...");
            Busy = true; deadline = Time.realtimeSinceStartup + 20;
            NetworkClient.Connect(Address);
        }

        public void Disconnect() { if (!IsServer) NetworkClient.Disconnect(); }

        public string Challenge(string opponentId, string requestId = null)
        {
            if (!Connected || Busy) return null;
            pendingRequestId = requestId ?? Guid.NewGuid().ToString("N");
            Busy = true; deadline = Time.realtimeSinceStartup + 30;
            SetStatus("Server is resolving the complete battle...");
            NetworkClient.Send(new ChallengeRequest { requestId = pendingRequestId, opponentId = opponentId, heroInstanceIds = SelectedHeroInstanceIds });
            return pendingRequestId;
        }

        public void LoadReplay(string id)
        {
            if (!Connected || Busy) return;
            Busy = true; deadline = Time.realtimeSinceStartup + 20;
            SetStatus("Loading saved replay from server...");
            NetworkClient.Send(new ReplayRequest { battleId = id });
        }

        public string ChallengeCampaign(string stageId,string[] selected,string requestId=null,bool manualUltimates=false)
        {
            if(!Connected || Busy)return null;
            pendingRequestId=requestId??Guid.NewGuid().ToString("N");Busy=true;deadline=Time.realtimeSinceStartup+30;
            SetStatus("Đang chuẩn bị trận Campaign...");
            NetworkClient.Send(new CampaignChallengeRequest{requestId=pendingRequestId,stageId=stageId,heroInstanceIds=selected,manualUltimates=manualUltimates});return pendingRequestId;
        }

        public void RefreshCatalog() { if (Connected) NetworkClient.Send(new CatalogRequest()); }
        void OnConnected() { Busy = false; SetStatus("Connected to dedicated server. Choose an opponent."); RefreshCatalog(); }
        void OnDisconnected()
        {
            if(shuttingDownClient)return;
            Busy=false;incoming=null;LiveBattleId=null;shuttingDownClient=true;
            try{NetworkClient.Shutdown();}finally{shuttingDownClient=false;}
            SetStatus("Disconnected. Loaded replay can still be viewed.");
        }
        void OnClientError(TransportError error, string reason) { Busy = false; SetStatus("Connection error: " + reason); }
        void OnFailure(ArenaFailure message) { Busy = false; incoming = null; SetStatus(message.message); }

        void OnChallenge(NetworkConnectionToClient conn, ChallengeRequest request)
        {
            try
            {
                if(liveCampaigns.ContainsKey(conn.connectionId))throw new ArgumentException("Finish the current Campaign battle first.");
                string id = ReplayArchive.CanonicalId(request.requestId);
                if (Array.IndexOf(PrototypeTeams.OpponentIds, request.opponentId) < 0) throw new ArgumentException("Unknown opponent.");
                if (repository.Contains(id))
                {
                    byte[] existing = repository.Read(id);
                    if (ReplayArchive.Decode(existing).opponentId != request.opponentId) throw new ArgumentException("Request ID already belongs to another opponent.");
                    SendReplay(conn, id, existing); return;
                }
                if (inFlight.Contains(id)) throw new ArgumentException("This battle is still being resolved. Load history shortly.");
                if (inFlight.Count >= 8) throw new ArgumentException("Server busy. Please try again shortly.");
                double now = Time.realtimeSinceStartupAsDouble;
                if (lastRequest.TryGetValue(conn.connectionId, out double previous) && now - previous < 1)
                    throw new ArgumentException("Please wait a moment before another challenge.");
                lastRequest[conn.connectionId] = now;
                var initial = ServerHeroTeams.Create(request.opponentId, request.heroInstanceIds, serverCatalog, out var loadouts);
                inFlight.Add(id);
                StartCoroutine(ResolveBattle(conn, id, request.opponentId, initial, loadouts));
            }
            catch (Exception e) { Fail(conn, e); }
        }

        IEnumerator ResolveBattle(NetworkConnectionToClient conn, string id, string opponent, List<FighterState> initial, List<FighterLoadout> loadouts)
        {return ResolveBattle(conn,id,opponent,initial,loadouts,null);}

        void OnCampaignChallenge(NetworkConnectionToClient conn,CampaignChallengeRequest request)
        {
            try
            {
                if(liveCampaigns.ContainsKey(conn.connectionId))throw new ArgumentException("A Campaign battle is already running.");
                string id=ReplayArchive.CanonicalId(request.requestId);
                if(repository.Contains(id))
                {
                    byte[] existing=repository.Read(id);var record=ReplayArchive.Decode(existing);
                    var requested=request.heroInstanceIds??Array.Empty<string>();
                    var recorded=record.loadouts.Where(l=>l.kind==CombatantKind.Hero).Select(l=>l.hero.HeroInstanceId).OrderBy(x=>x,StringComparer.Ordinal);
                    if(record.campaignStageId!=request.stageId || (record.manualUltimateTeams!=0)!=request.manualUltimates || !recorded.SequenceEqual(requested.OrderBy(x=>x,StringComparer.Ordinal)))throw new ArgumentException("Request ID belongs to another Campaign battle.");
                    SendReplay(conn,id,existing);SendCatalog(conn);return;
                }
                if(inFlight.Contains(id))throw new ArgumentException("This battle is still being resolved.");
                if(inFlight.Count>=8)throw new ArgumentException("Server busy. Try again shortly.");
                double now=Time.realtimeSinceStartupAsDouble;
                if(lastRequest.TryGetValue(conn.connectionId,out double previous) && now-previous<1)throw new ArgumentException("Please wait before another challenge.");
                var setup=campaignState.Prepare(request.stageId,request.heroInstanceIds);lastRequest[conn.connectionId]=now;inFlight.Add(id);
                if(request.manualUltimates)StartCoroutine(RunLiveCampaign(conn,id,setup));
                else StartCoroutine(ResolveBattle(conn,id,"campaign:"+request.stageId,setup.Fighters,setup.Loadouts,setup));
            }
            catch(Exception e){Fail(conn,e);}
        }

        IEnumerator ResolveBattle(NetworkConnectionToClient conn,string id,string opponent,List<FighterState> initial,List<FighterLoadout> loadouts,CampaignBattleSetup campaign)
        {
            uint seed;
            using (var rng = RandomNumberGenerator.Create()) { var bytes = new byte[4]; rng.GetBytes(bytes); seed = BitConverter.ToUInt32(bytes, 0); }
            var task = Task.Run(() => campaign!=null?campaign.Run(id,seed):new BattleSimulation(id, opponent, seed, initial, loadouts).RunToCompletion());
            while (!task.IsCompleted) yield return null;
            try
            {
                if (task.IsFaulted) throw task.Exception.GetBaseException();
                var record = task.Result;
                record.createdUtc = DateTime.UtcNow.ToString("O");
                byte[] bytes = ReplayArchive.Encode(record);
                repository.Save(id, bytes); // Durable commit precedes every successful response.
                campaignState?.AcceptCommitted(record);
                Debug.Log("[ArenaServer] COMMITTED id=" + id + " winner=" + record.winner + " ticks=" + record.durationTicks + " bytes=" + bytes.Length);
                if (StillConnected(conn)) { SendReplay(conn, id, bytes); SendCatalog(conn); }
            }
            catch (Exception e) { Debug.LogException(e); if (StillConnected(conn)) Fail(conn, e); }
            finally { inFlight.Remove(id); }
        }

        void OnReplayRequest(NetworkConnectionToClient conn, ReplayRequest request)
        {
            try { if(liveCampaigns.ContainsKey(conn.connectionId))throw new ArgumentException("Finish the current Campaign battle first.");string id = ReplayArchive.CanonicalId(request.battleId); SendReplay(conn, id, repository.Read(id)); }
            catch (Exception e) { Fail(conn, e); }
        }

        void SendCatalog(NetworkConnectionToClient conn)
        {
            conn.Send(new CatalogResponse { replays = repository.Recent() });
            if(campaignState!=null)conn.Send(new CampaignProgressResponse{clearedStageIds=campaignState.Cleared});
        }
        static bool StillConnected(NetworkConnectionToClient conn) { return NetworkServer.connections.TryGetValue(conn.connectionId, out var current) && ReferenceEquals(conn, current); }
        static void Fail(NetworkConnectionToClient conn, Exception error)
        {
            string message = error is FileNotFoundException ? "Replay not found on this server." :
                error is ArgumentException ? error.Message : "Server could not complete this request. Check server logs.";
            conn.Send(new ArenaFailure { message = message });
        }

        static void SendReplay(NetworkConnectionToClient conn, string id, byte[] bytes, bool live = false)
        {
            int chunks = (bytes.Length + ChunkSize - 1) / ChunkSize;
            conn.Send(new ReplayBegin { battleId = id, length = bytes.Length, chunks = chunks, sha256 = ReplayArchive.Hash(bytes), live=live });
            for (int i = 0; i < chunks; i++)
            {
                int count = Math.Min(ChunkSize, bytes.Length - i * ChunkSize);
                var chunk = new byte[count]; Buffer.BlockCopy(bytes, i * ChunkSize, chunk, 0, count);
                conn.Send(new ReplayChunk { battleId = id, index = i, bytes = chunk });
            }
        }

        void OnReplayBegin(ReplayBegin header)
        {
            try
            {
                ReplayArchive.CanonicalId(header.battleId);
                if (header.length <= 0 || header.length > ReplayArchive.MaxCompressedBytes ||
                    header.chunks != (header.length + ChunkSize - 1) / ChunkSize || string.IsNullOrEmpty(header.sha256) || header.sha256.Length != 64)
                    throw new InvalidDataException("Invalid replay transfer header.");
                transfer = header; incoming = new byte[header.length]; nextChunk = 0;
                Busy = true; deadline = Time.realtimeSinceStartup + 20;
            }
            catch (Exception e) { OnFailure(new ArenaFailure { message = e.Message }); }
        }

        void OnReplayChunk(ReplayChunk chunk)
        {
            try
            {
                if (incoming == null || chunk.battleId != transfer.battleId || chunk.index != nextChunk || chunk.bytes == null ||
                    chunk.bytes.Length != Math.Min(ChunkSize, incoming.Length - nextChunk * ChunkSize))
                    throw new InvalidDataException("Incomplete or out-of-order replay transfer.");
                Buffer.BlockCopy(chunk.bytes, 0, incoming, nextChunk * ChunkSize, chunk.bytes.Length);
                nextChunk++; deadline = Time.realtimeSinceStartup + 20;
                if (nextChunk < transfer.chunks) return;
                byte[] complete = incoming; incoming = null;
                if (ReplayArchive.Hash(complete) != transfer.sha256) throw new InvalidDataException("Replay checksum mismatch.");
                BattleRecord record = transfer.live?LiveBattleCodec.Decode(complete,LiveBattleId==transfer.battleId?LastRecord:null):ReplayArchive.Decode(complete);
                if (record.battleId != transfer.battleId) throw new InvalidDataException("Replay ID mismatch.");
                if(transfer.live)
                {
                    if(!record.battleInProgress)throw new InvalidDataException("Invalid live battle frame.");
                    bool first=LiveBattleId!=record.battleId;
                    LastRecord=record;LastBattleId=record.battleId;LiveBattleId=record.battleId;Busy=true;
                    if(first){SetStatus("Campaign đang diễn ra · bấm chân dung khi đầy nộ.");ReplayReceived?.Invoke(record);}
                    else LiveFrameReceived?.Invoke(record);
                    return;
                }
                bool finishedLive=LiveBattleId==record.battleId;LiveBattleId=null;
                LastRecord = record; LastBattleId = record.battleId; Busy = false;
                SetStatus("Server result committed. Playing recorded outcomes.");
                Debug.Log("[ArenaClient] REPLAY id=" + record.battleId + " sha=" + transfer.sha256 + " events=" + record.events.Count);
                if(finishedLive)LiveBattleFinished?.Invoke(record);else ReplayReceived?.Invoke(record);
            }
            catch (Exception e) { OnFailure(new ArenaFailure { message = "Replay rejected: " + e.Message }); }
        }

        void SetStatus(string text) { Status = text; StatusChanged?.Invoke(); }
        public static string Argument(string key, string fallback)
        {
            string[] args = Environment.GetCommandLineArgs();
            int index = Array.IndexOf(args, key);
            return index >= 0 && index + 1 < args.Length ? args[index + 1] : fallback;
        }
        static ushort ReadPort() { return ushort.TryParse(Argument("--port", "7777"), out ushort port) && port != 0 ? port : (ushort)7777; }

        void OnDestroy()
        {
            if (IsServer) NetworkServer.Shutdown();
            else
            {
                NetworkClient.OnConnectedEvent -= OnConnected;
                NetworkClient.OnDisconnectedEvent -= OnDisconnected;
                NetworkClient.OnErrorEvent -= OnClientError;
                NetworkClient.Shutdown();
            }
        }
    }
}
