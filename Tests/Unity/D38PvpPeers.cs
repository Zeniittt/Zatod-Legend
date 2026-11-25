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
using Zatod.Networking;
using Zatod.Presentation;
public static class D38PvpPeers
{
    const BindingFlags Private=BindingFlags.Static|BindingFlags.Instance|BindingFlags.NonPublic;
    static readonly MethodInfo Encode=typeof(ReplayArchive).GetMethod("EncodePayload",Private),Decode=typeof(ReplayArchive).GetMethod("DecodePayload",Private),Assemble=typeof(ZatodConnection).GetMethod("Assemble",Private);
    sealed class Peer:IDisposable
    {
        readonly Telepathy.Client socket;readonly Batcher batcher;readonly Unbatcher unbatcher=new Unbatcher();object incoming;ZatodBattleAssets assets;
        public readonly string AccountId=Guid.NewGuid().ToString("D");public ZatodAccountSnapshot Account;public ZatodBattleSimulation Battle;public ZatodReplay Record;public Exception Error;public int Team,Ticks;
        public Peer(TelepathyTransport transport)
        {
            int size=transport.GetMaxPacketSize(Channels.Reliable);socket=new Telepathy.Client(size);batcher=new Batcher(size);socket.OnConnected=()=>Send("request",new ZatodRequest{Command="hello",A=Guid.NewGuid().ToString("D"),B=AccountId,C="D38 PvP peer"});
            socket.OnData=bytes=>{try{Receive(bytes);}catch(Exception e){Error=e;}};
        }
        public void Connect(int port)=>socket.Connect("127.0.0.1",port);public void Tick()=>socket.Tick(1024);
        public void Queue()=>Send("request",new ZatodRequest{Command="queue",Heroes=Account.FreePvpHeroIds.Take(5).ToArray(),FreePvpRosterKey=Account.FreePvpRosterKey});
        void Send<T>(string kind,T value)
        {
            var bytes=(byte[])Encode.Invoke(null,new object[]{value});using var message=NetworkWriterPool.Get();using var batch=NetworkWriterPool.Get();NetworkMessages.Pack(new ZatodPacket{id=Guid.NewGuid().ToString("N"),kind=kind,length=bytes.Length,index=0,bytes=bytes},message);batcher.AddMessage(message.ToArraySegment(),NetworkTime.localTime);
            while(batcher.GetBatch(batch)){if(!socket.Send(batch.ToArraySegment()))throw new IOException("TCP send failed");batch.Reset();}
        }
        static T Read<T>(byte[] bytes)=>(T)Decode.MakeGenericMethod(typeof(T)).Invoke(null,new object[]{bytes});
        void Operation()=>Send("operation",new ZatodOperation{BattleId=Battle.BattleId,Tick=Battle.CurrentTick+1,Actors=Battle.Frame().Units.Where(u=>u.Team==Team && u.CanActivateUltimate).Select(u=>u.EntityId).ToList()});
        void Receive(ArraySegment<byte> bytes)
        {
            if(!unbatcher.AddBatch(bytes))throw new IOException("Mirror batch");
            while(unbatcher.GetNextMessage(out var message,out _))
            {
                var reader=new NetworkReader(message);if(!NetworkMessages.UnpackId(reader,out ushort id))throw new IOException("Mirror type");if(id!=NetworkMessageId<ZatodPacket>.Id)continue;
                var packet=reader.Read<ZatodPacket>();var args=new object[]{incoming,packet};var body=(byte[])Assemble.Invoke(null,args);incoming=args[0];if(body==null)continue;
                switch(packet.kind)
                {
                    case "account":Account=Read<ZatodAccountSnapshot>(body);break;
                    case "start":var start=Read<ZatodStart>(body);assets=ZatodBattleAssets.Prepare(start.Match);Team=start.Team;Battle=new ZatodBattleSimulation(start.Match);Operation();break;
                    case "tick":var tick=Read<ZatodTick>(body);if(Battle==null || tick.Tick!=Battle.CurrentTick+1)throw new Exception("Tick sequence");foreach(var input in tick.Inputs)Battle.QueueInput(input);Battle.Step();Ticks++;if(Battle.Frame().Digest!=tick.Digest)throw new Exception("Digest differs at "+tick.Tick);if(!Battle.Finished)Operation();break;
                    case "replay":Record=Read<ZatodReplay>(body);break;
                    case "error":case "abort":throw new Exception(Read<ZatodNotice>(body).Text);
                }
            }
        }
        public void Dispose(){socket.Disconnect();assets?.Dispose();}
    }
    public static string Arm(string output)
    {
        if(!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/") || !NetworkServer.active)throw new InvalidOperationException("Use the running D38 isolated server");
        Directory.CreateDirectory(output);string report=Path.Combine(output,"pvp.json");File.WriteAllText(report,"{\"State\":\"RUNNING\"}");Run(output,report);return report;
    }
    static async void Run(string output,string report)
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();using var left=new Peer(c.GetComponent<TelepathyTransport>());using var right=new Peer(c.GetComponent<TelepathyTransport>());
        var rooms=typeof(ZatodConnection).GetMethod("UpdateRooms",Private);EditorApplication.CallbackFunction pump=()=>{left.Tick();right.Tick();if(NetworkServer.active)rooms.Invoke(c,null);};EditorApplication.update+=pump;
        async Task Until(Func<bool> predicate,double seconds,string reason){var end=EditorApplication.timeSinceStartup+seconds;while(!predicate()){if(left.Error!=null)throw left.Error;if(right.Error!=null)throw right.Error;if(EditorApplication.timeSinceStartup>end)throw new TimeoutException(reason);await Task.Delay(30);}}
        try
        {
            left.Connect(c.Port);right.Connect(c.Port);await Until(()=>left.Account!=null && right.Account!=null,10,"Two accounts");
            var ownedLeft=Newtonsoft.Json.JsonConvert.SerializeObject(left.Account.Account.HeroDesk);var ownedRight=Newtonsoft.Json.JsonConvert.SerializeObject(right.Account.Account.HeroDesk);
            left.Queue();right.Queue();await Until(()=>left.Record!=null && right.Record!=null,180,"Realtime completion");var record=left.Record;
            if(record.Digest!=right.Record.Digest || record.Digest!=left.Battle.Replay().Digest || record.Digest!=right.Battle.Replay().Digest || record.Digest!=ZatodBattleSimulation.Resimulate(record).Digest)throw new Exception("Peer/server/replay digest mismatch");
            if(left.Ticks!=record.EndTick || right.Ticks!=record.EndTick || record.Inputs.Select(i=>i.Team).Distinct().Count()!=2)throw new Exception("Both peers must exercise manual inputs");
            if(ownedLeft!=Newtonsoft.Json.JsonConvert.SerializeObject(left.Account.Account.HeroDesk) || ownedRight!=Newtonsoft.Json.JsonConvert.SerializeObject(right.Account.Account.HeroDesk))throw new Exception("PvP changed Owned");
            File.WriteAllBytes(Path.Combine(output,"replay.zatod.gz"),(byte[])Encode.Invoke(null,new object[]{record}));
            File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="PASS",Mode=record.Initial.Mode.ToString(),record.EndTick,Digest=record.Digest.ToString(),Inputs=record.Inputs.Count,Teams=2,Players=record.Initial.Players.Count,EnemyPlayers=record.Initial.Waves[0].Enemies.Count,Preloaded=true,OwnedPreserved=true,Rules=record.Initial.RulesVersion},Newtonsoft.Json.Formatting.Indented));
        }
        catch(Exception e){File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Error=e.ToString()},Newtonsoft.Json.Formatting.Indented));}
        finally{EditorApplication.update-=pump;}
    }
}
