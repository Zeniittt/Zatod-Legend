// Joins the D38 isolated server with independent TCP guests; no main profile mutation.
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
using Zatod.World;
public static class D38WorldPeers
{
    const BindingFlags Private=BindingFlags.Static|BindingFlags.Instance|BindingFlags.NonPublic;
    static readonly MethodInfo Encode=typeof(ReplayArchive).GetMethod("EncodePayload",Private),Decode=typeof(ReplayArchive).GetMethod("DecodePayload",Private),Assemble=typeof(ZatodConnection).GetMethod("Assemble",Private);
    static int checks;static void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
    sealed class Peer
    {
        readonly Telepathy.Client socket;readonly Batcher batcher;readonly Unbatcher unbatcher=new Unbatcher();object incoming;
        public readonly string Id=Guid.NewGuid().ToString("D");public ZatodAccountSnapshot Account;public ZatodWorldSnapshot World;public ZatodNotice Error;public Exception Failure;public ZatodStart Start;
        public WorldPlayerState Self=>World.Players?.FirstOrDefault(p=>p.AccountId==Id);
        public Peer(TelepathyTransport transport)
        {
            int size=transport.GetMaxPacketSize(Channels.Reliable);socket=new Telepathy.Client(size);batcher=new Batcher(size);
            socket.OnConnected=()=>Request(new ZatodRequest{Command="hello",A=Guid.NewGuid().ToString("D"),B=Id,C="D38 peer"});
            socket.OnData=bytes=>{try{Receive(bytes);}catch(Exception e){Failure=e;}};
        }
        public void Connect(int port)=>socket.Connect("127.0.0.1",port);public void Tick()=>socket.Tick(1024);public void Close()=>socket.Disconnect();
        public void Request(ZatodRequest request)
        {
            var bytes=(byte[])Encode.Invoke(null,new object[]{request});Send(new ZatodPacket{id=Guid.NewGuid().ToString("N"),kind="request",length=bytes.Length,index=0,bytes=bytes});
        }
        public void Send<T>(T value) where T:struct,NetworkMessage
        {
            using var message=NetworkWriterPool.Get();using var batch=NetworkWriterPool.Get();NetworkMessages.Pack(value,message);batcher.AddMessage(message.ToArraySegment(),NetworkTime.localTime);
            while(batcher.GetBatch(batch)){Check(socket.Send(batch.ToArraySegment()),"TCP send");batch.Reset();}
        }
        static T Read<T>(byte[] bytes)=>(T)Decode.MakeGenericMethod(typeof(T)).Invoke(null,new object[]{bytes});
        void Receive(ArraySegment<byte> bytes)
        {
            Check(unbatcher.AddBatch(bytes),"Mirror batch");
            while(unbatcher.GetNextMessage(out var message,out _))
            {
                var reader=new NetworkReader(message);Check(NetworkMessages.UnpackId(reader,out ushort id),"Mirror type");
                if(id==NetworkMessageId<ZatodWorldSnapshot>.Id){World=reader.Read<ZatodWorldSnapshot>();continue;}
                if(id!=NetworkMessageId<ZatodPacket>.Id)continue;
                var packet=reader.Read<ZatodPacket>();var args=new object[]{incoming,packet};var body=(byte[])Assemble.Invoke(null,args);incoming=args[0];if(body==null)continue;
                if(packet.kind=="account")Account=Read<ZatodAccountSnapshot>(body);else if(packet.kind=="error")Error=Read<ZatodNotice>(body);else if(packet.kind=="start")Start=Read<ZatodStart>(body);
            }
        }
        public void Chapter(string id)=>Request(new ZatodRequest{Command="world_chapter",A=id,Number=(int)Self.MapRevision});
    }
    public static async Task<object> Run(string output)
    {
        if(!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/") || !NetworkServer.active)throw new InvalidOperationException("Use the running isolated D38 server");
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();string mainId=c.Snapshot.Account.CharacterId;var peers=new List<Peer>();
        var one=new Peer(c.GetComponent<TelepathyTransport>());var two=new Peer(c.GetComponent<TelepathyTransport>());peers.Add(one);peers.Add(two);
        EditorApplication.CallbackFunction pump=()=>{foreach(var peer in peers)peer.Tick();};EditorApplication.update+=pump;
        async Task Until(Func<bool> predicate,string why){double end=EditorApplication.timeSinceStartup+10;while(!predicate()){foreach(var peer in peers)if(peer.Failure!=null)throw peer.Failure;if(EditorApplication.timeSinceStartup>end)throw new TimeoutException(why);await Task.Delay(30);}}
        bool Has(Peer p,Peer target)=>p.World.Players?.Any(x=>x.AccountId==target.Id)==true;
        try
        {
            one.Connect(c.Port);two.Connect(c.Port);await Until(()=>one.Self!=null && two.Self!=null && Has(one,two) && Has(two,one),"Guests in shared Town");
            string[] before=one.World.Players.Select(x=>x.AccountId).ToArray();two.Chapter("chapter_two");await Until(()=>two.Error!=null,"Gate reject");Check(two.Error.Text.Contains("Lv5") && two.Error.Text.Contains("Complete"),"Both gate reasons from server");Check(two.Self.MapId=="town" && two.Self.MapRevision==1,"Gate reject does not travel");two.Error=null;
            one.Chapter("chapter_one");await Until(()=>one.Self?.MapId=="chapter_one" && !Has(two,one),"Different-map interest");Check(!Has(one,two),"Chapter interest hides Town guest");
            var late=new Peer(c.GetComponent<TelepathyTransport>());peers.Add(late);late.Connect(c.Port);await Until(()=>late.Self!=null && Has(late,two) && Has(two,late),"Late join Town interest");Check(!Has(late,one),"Late join cannot see other island");
            two.Chapter("chapter_one");await Until(()=>Has(one,two) && Has(two,one),"Guests reunite on chapter island");
            uint revision=one.Self.MapRevision;one.Request(new ZatodRequest{Command="world_portal",A="town",Number=(int)revision-1});await Until(()=>one.Error!=null,"Stale travel reject");Check(one.Self.MapRevision==revision && one.Self.MapId=="chapter_one","Stale request preserves map/revision");one.Error=null;
            var sessions=(Dictionary<int,ZatodPlayerSession>)typeof(ZatodConnection).GetField("sessions",Private).GetValue(c);var server=sessions.Values.Single(s=>s.Account.CharacterId==one.Id);var campaign=CampaignDataJson.Load(HeroDataJson.LoadBundledCatalog());var minor=campaign.Data.Chapters[0].Stages.First(s=>!s.KeyStage);server.Run.AcceptValidated(campaign.Prerequisite(minor.Id),true,3);server.Run.AcceptValidated(minor.Id,true,3);
            typeof(ZatodConnection).GetMethod("SendAccount",Private).Invoke(c,new object[]{NetworkServer.connections[one.Self.ConnectionId],server,false});await Until(()=>one.Account.Cleared.Contains(minor.Id),"Personal progress snapshot");Check(!two.Account.Cleared.Contains(minor.Id) && Has(one,two),"Same world, different personal Passed state");
            int stamina=one.Account.Account.Stamina;long ownedRevision=one.Account.Account.Revision;one.Request(new ZatodRequest{Command="campaign",A=minor.Id,Heroes=one.Account.Account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray()});await Until(()=>one.Error!=null,"Minor begin reject");Check(one.Error.Text.Contains("Passed") && !server.CampaignInProgress && server.Account.Stamina==stamina && server.Account.Revision==ownedRevision,"Direct minor reject without resource changes");one.Error=null;
            one.Request(new ZatodRequest{Command="campaign",A="chapter_one_stage_1",Heroes=one.Account.Account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray()});await Until(()=>one.Start!=null,"Key replay begins after clear");Check(server.CampaignInProgress,"Key stage remains farmable");
            one.Request(new ZatodRequest{Command="world_portal",A="town",Number=(int)revision});await Until(()=>one.Error!=null,"Travel while battle must reject");Check(one.Self.MapId=="chapter_one","Battle cannot change map");one.Request(new ZatodRequest{Command="cancel"});await Until(()=>!server.CampaignInProgress,"Cancel peer fixture battle");
            Check(c.Snapshot.Account.CharacterId==mainId,"Live soak profile remains unchanged");
            var result=new{State="PASS",Checks=checks,Peers=3,SameAndDifferentMaps=true,LateJoin=true,PersonalProgress=true,StaleTravelRejected=true,MinorRejected=true,KeyReplay=true};File.WriteAllText(output,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        catch(Exception e){File.WriteAllText(output,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Checks=checks,Error=e.ToString()},Newtonsoft.Json.Formatting.Indented));throw;}
        finally{EditorApplication.update-=pump;foreach(var peer in peers)peer.Close();}
    }
}
