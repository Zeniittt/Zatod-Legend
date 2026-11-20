using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Mirror;
using UnityEngine;
using Zatod.Heroes;
using Zatod.Combat;
namespace Zatod.Networking
{
    [DefaultExecutionOrder(-210)]
    [RequireComponent(typeof(TelepathyTransport))]
    public sealed partial class ZatodConnection : MonoBehaviour
    {
        public string Address="127.0.0.1";
        public string DevelopmentProfile="default";
        public ushort Port=7788;
        public bool IsServer {get;private set;}
        public bool AutoUltimate {get;set;}
        public bool Connected=>!IsServer && NetworkClient.isConnected;
        public string Status {get;private set;}="Connect to a Zatod server.";
        public ZatodAccountSnapshot Snapshot {get;private set;}
        public ZatodBattleSimulation Battle {get;private set;}
        public ZatodReplay LastReplay {get;private set;}
        public int Team {get;private set;}
        public event Action Changed;
        public event Action MatchStarted;
        public event Action FrameReceived;
        public event Action ReplayReceived;
        readonly string launchId=Guid.NewGuid().ToString("D");
        readonly Dictionary<int,Incoming> uploads=new Dictionary<int,Incoming>();
        Incoming download;
        HeroCatalog catalog;
        CampaignCatalog campaign;
        readonly Dictionary<int,ZatodPlayerSession> sessions=new Dictionary<int,ZatodPlayerSession>();
        readonly Dictionary<string,ZatodPlayerSession> launches=new Dictionary<string,ZatodPlayerSession>(StringComparer.Ordinal);
        readonly Dictionary<string,ZatodReplay> archives=new Dictionary<string,ZatodReplay>(StringComparer.Ordinal);
        string archiveDirectory;
        readonly List<int> queue=new List<int>();
        readonly List<RealtimeRoom> rooms=new List<RealtimeRoom>();
        readonly HashSet<int> intents=new HashSet<int>();
        float elapsed;
        bool submitted;
        const int Chunk=8192;
        sealed class Incoming {public string Id,Kind;public int Length,Next;public MemoryStream Bytes=new MemoryStream();public double Started;}
        sealed class RealtimeRoom
        {
            public int Left,Right;
            public ZatodBattleSimulation Simulation;
            public double NextTime;
            public Dictionary<int,ZatodOperation> Operations=new Dictionary<int,ZatodOperation>();
        }
        public static string Argument(string key,string fallback)
        {var args=Environment.GetCommandLineArgs();int i=Array.IndexOf(args,key);if(i<0 && key.StartsWith("--zatod-",StringComparison.Ordinal))i=Array.IndexOf(args,key.Replace("--zatod-","--crystal-"));return i>=0 && i+1<args.Length?args[i+1]:fallback;}
        public static bool HasArgument(string key)=>Environment.GetCommandLineArgs().Contains(key) || key.StartsWith("--zatod-",StringComparison.Ordinal) && Environment.GetCommandLineArgs().Contains(key.Replace("--zatod-","--crystal-"));
        void Start()
        {
            Application.runInBackground=true;
            if(ushort.TryParse(Argument("--zatod-port",Port.ToString()),out var port))Port=port;
            var transport=GetComponent<TelepathyTransport>();transport.port=Port;Transport.active=transport;
            IsServer=HasArgument("--zatod-server");
#if UNITY_SERVER
            IsServer=true;
#endif
            Address=Argument("--server",Address);
            if(IsServer)StartServer();
            else if(HasArgument("--zatod-smoke")){gameObject.AddComponent<ZatodSmokeClient>();Connect();}
        }
        void SetStatus(string value){Status=value;Changed?.Invoke();}
        public void Connect()
        {
            if(IsServer || NetworkClient.active)return;
            NetworkClient.RegisterHandler<ZatodPacket>(OnClientPacket,false);
            NetworkClient.OnConnectedEvent+=OnConnected;
            NetworkClient.OnDisconnectedEvent+=OnDisconnected;
            NetworkClient.OnErrorEvent+=OnError;
            NetworkClient.Connect(Address);SetStatus("Connecting to "+Address+":"+Port);
        }
        string AccountKey()
        {
            string profile=Argument("--zatod-profile",Argument("--zatod-smoke",DevelopmentProfile));
            string key="ZatodPrototype.Account."+profile;
            string account=PlayerPrefs.GetString(key,PlayerPrefs.GetString("CrystalPrototype.Account."+profile,""));
            if(!Guid.TryParseExact(account,"D",out _)){account=Guid.NewGuid().ToString("D");PlayerPrefs.SetString(key,account);PlayerPrefs.Save();}
            if(!PlayerPrefs.HasKey(key)){PlayerPrefs.SetString(key,account);PlayerPrefs.Save();}
            return account;
        }
        void OnConnected(){Request(new ZatodRequest{Command="hello",A=launchId,B=AccountKey()});}
        void OnDisconnected(){Battle=null;SetStatus("Disconnected. Reconnect within this launch to keep its campaign run.");}
        void OnError(TransportError error,string reason){SetStatus(error+": "+reason);}
        public void Disconnect(){if(!IsServer)NetworkClient.Disconnect();}
        public void Request(ZatodRequest request)
        {
            if(!Connected)return;Send(null,"request",request);
        }
        public void Campaign(string stageId,IEnumerable<string> heroes)=>Request(new ZatodRequest{Command="campaign",A=stageId,Heroes=heroes.ToArray()});
        public void Arena(IEnumerable<string> heroes)=>Request(new ZatodRequest{Command="arena",Heroes=heroes.ToArray()});
        public void FindPvp(IEnumerable<string> heroes)=>Request(new ZatodRequest{Command="queue",Heroes=heroes.ToArray()});
        public void Cancel()
        {
            Request(new ZatodRequest{Command="cancel"});Battle=null;intents.Clear();submitted=false;Changed?.Invoke();
        }
        public void AddItemByItemId(string itemId,int amount=1)=>Request(new ZatodRequest{Command="item",A=itemId,Number=amount});
        public void Equip(string heroId,string slotId,string guid)=>Request(new ZatodRequest{Command="equip",A=heroId,B=slotId,C=guid});
        public void Promote(string heroId)=>Request(new ZatodRequest{Command="promote",A=heroId});
        public void DevLevel(string heroId,int level)=>Request(new ZatodRequest{Command="level",A=heroId,Number=level});
        public bool Ultimate(int actorId)
        {
            if(Battle==null || Battle.Finished)return false;
            if(Battle.Mode==ZatodMode.RealtimePvp)
            {
                var actor=Battle.Frame().Units.FirstOrDefault(u=>u.EntityId==actorId);
                if(actor==null || actor.Team!=Team || !actor.Alive || actor.Energy<actor.MaxEnergy)return false;
                return intents.Add(actorId);
            }
            return Battle.RequestUltimate(actorId);
        }
        public void SubmitCampaign()
        {
            if(Battle==null || !Battle.Finished || submitted)return;
            submitted=true;Send(null,"claim",Battle.Replay());SetStatus("Server is validating the complete input log...");
        }
        void Update()
        {
            if(IsServer){UpdateRooms();return;}
            if(Battle==null || Battle.Finished || Battle.Mode==ZatodMode.RealtimePvp)return;
            elapsed+=Time.unscaledDeltaTime;
            int budget=16;
            while(elapsed>=ZatodBattleSimulation.StepSeconds && !Battle.Finished && budget-->0)
            {elapsed-=(float)ZatodBattleSimulation.StepSeconds;if(AutoUltimate && Battle.Mode==ZatodMode.Campaign)foreach(var actor in Battle.Frame().Units.Where(u=>u.Team==Team && u.Alive))Battle.RequestUltimate(actor.EntityId);Battle.Step();FrameReceived?.Invoke();}
            if(Battle.Finished && !submitted)SubmitCampaign();
        }
        void OnClientPacket(ZatodPacket packet)
        {
            try
            {
                var bytes=Assemble(ref download,packet);if(bytes==null)return;
                switch(packet.kind)
                {
                    case "account":Snapshot=ReplayArchive.DecodePayload<ZatodAccountSnapshot>(bytes);SetStatus("Connected. Campaign progress belongs to this app launch.");break;
                    case "start":
                        var start=ReplayArchive.DecodePayload<ZatodStart>(bytes);Battle=new ZatodBattleSimulation(start.Match);Team=start.Team;elapsed=0;submitted=false;intents.Clear();LastReplay=null;
                        SetStatus(start.Match.Mode+" Â· "+start.Match.BattleId);MatchStarted?.Invoke();FrameReceived?.Invoke();
                        if(start.Match.Mode==ZatodMode.RealtimePvp)SendOperation(1);break;
                    case "tick":
                        var tick=ReplayArchive.DecodePayload<ZatodTick>(bytes);
                        if(Battle==null || Battle.BattleId!=tick.BattleId || tick.Tick!=Battle.CurrentTick+1)throw new InvalidDataException("Realtime tick sequence mismatch.");
                        foreach(var input in tick.Inputs)Battle.QueueInput(input);Battle.Step();
                        if(Battle.Frame().Digest!=tick.Digest)throw new InvalidDataException("Realtime simulation digest mismatch.");
                        FrameReceived?.Invoke();if(!Battle.Finished)SendOperation(tick.Tick+1);break;
                    case "replay":LastReplay=ReplayArchive.DecodePayload<ZatodReplay>(bytes);SetStatus("Validated replay: winner "+LastReplay.Winner+", stars "+LastReplay.Stars);ReplayReceived?.Invoke();break;
                    case "notice":SetStatus(ReplayArchive.DecodePayload<ZatodNotice>(bytes).Text);break;
                    case "abort":Battle=null;SetStatus(ReplayArchive.DecodePayload<ZatodNotice>(bytes).Text);break;
                    case "error":submitted=false;SetStatus(ReplayArchive.DecodePayload<ZatodNotice>(bytes).Text);break;
                    default:throw new InvalidDataException("Unknown Crystal message.");
                }
            }
            catch(Exception error){Debug.LogError("[ZatodClient] "+error);Battle=null;SetStatus(error.Message);}
        }
        void SendOperation(int tick)
        {
            Send(null,"operation",new ZatodOperation{BattleId=Battle.BattleId,Tick=tick,Actors=intents.OrderBy(x=>x).ToList()});intents.Clear();
        }
        static byte[] Assemble(ref Incoming incoming,ZatodPacket packet)
        {
            if(packet.bytes==null || packet.bytes.Length<1 || packet.bytes.Length>Chunk || packet.length<1 || packet.length>ReplayArchive.MaxCompressedBytes || packet.id==null || packet.id.Length>40 || packet.kind==null || packet.kind.Length>20)throw new InvalidDataException("Invalid packet bounds.");
            if(packet.index==0){if(incoming!=null)throw new InvalidDataException("Overlapping transfer.");incoming=new Incoming{Id=packet.id,Kind=packet.kind,Length=packet.length,Started=NetworkTime.time};}
            if(incoming==null || incoming.Id!=packet.id || incoming.Kind!=packet.kind || incoming.Length!=packet.length || incoming.Next++!=packet.index || NetworkTime.time-incoming.Started>30 || incoming.Bytes.Length+packet.bytes.Length>incoming.Length)throw new InvalidDataException("Invalid packet sequence.");
            incoming.Bytes.Write(packet.bytes,0,packet.bytes.Length);
            if(incoming.Bytes.Length<incoming.Length)return null;
            var result=incoming.Bytes.ToArray();incoming.Bytes.Dispose();incoming=null;return result;
        }
        static void Send<T>(NetworkConnectionToClient connection,string kind,T value)
        {
            byte[] bytes=ReplayArchive.EncodePayload(value);if(bytes.Length>ReplayArchive.MaxCompressedBytes)throw new InvalidDataException("Payload too large.");
            string id=Guid.NewGuid().ToString("N");
            for(int offset=0,index=0;offset<bytes.Length;offset+=Chunk,index++)
            {
                var part=new byte[Math.Min(Chunk,bytes.Length-offset)];Buffer.BlockCopy(bytes,offset,part,0,part.Length);
                var packet=new ZatodPacket{id=id,kind=kind,index=index,length=bytes.Length,bytes=part};
                if(connection==null)NetworkClient.Send(packet);else connection.Send(packet);
            }
        }
        void OnDestroy()
        {
            if(IsServer){NetworkServer.OnDisconnectedEvent-=ServerDisconnected;NetworkServer.Shutdown();}
            else{NetworkClient.OnConnectedEvent-=OnConnected;NetworkClient.OnDisconnectedEvent-=OnDisconnected;NetworkClient.OnErrorEvent-=OnError;if(NetworkClient.active)NetworkClient.Disconnect();}
        }
    }
}
