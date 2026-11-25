// Isolated real TCP peers and server database. Never touches the user's server/save directory.
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
public static class D39Network
{
    const BindingFlags All=BindingFlags.Static|BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
    static int checks;
    static void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
    static T Field<T>(object obj,string name)=>(T)obj.GetType().GetField(name,All).GetValue(obj);
    static object Call(object obj,string name,params object[] args)=>obj.GetType().GetMethod(name,All).Invoke(obj,args);
    static readonly MethodInfo Encode=typeof(ReplayArchive).GetMethod("EncodePayload",All),Decode=typeof(ReplayArchive).GetMethod("DecodePayload",All),Assemble=typeof(ZatodConnection).GetMethod("Assemble",All);
    sealed class Peer
    {
        readonly Telepathy.Client socket;readonly Batcher batcher;readonly Unbatcher unbatcher=new Unbatcher();object incoming;
        readonly ZatodRequest login;
        public ZatodAccountSnapshot Account;public ZatodWorldSnapshot World;public ZatodNotice Error;public ZatodStart Start;public ZatodReplay Replay;public Exception Failure;
        public ZatodBattleSimulation Simulation;public string RawAccount;public bool AutoOperations;
        public WorldPlayerState Self=>World.Players?.FirstOrDefault(p=>p.ConnectionId==World.SelfId);
        public Peer(TelepathyTransport t,string command,string username,string password)
        {
            login=new ZatodRequest{Command=command,A=username,B=password};int size=t.GetMaxPacketSize(Channels.Reliable);socket=new Telepathy.Client(size);batcher=new Batcher(size);
            socket.OnConnected=()=>Request(login);socket.OnData=data=>{try{Receive(data);}catch(Exception e){Failure=e;}};
        }
        public void Connect(int port)=>socket.Connect("127.0.0.1",port);public void Tick()=>socket.Tick(1024);public void Close()=>socket.Disconnect();
        public void Request(ZatodRequest r)=>Payload("request",r);
        public void Payload(string kind,object value)
        {
            var bytes=(byte[])Encode.Invoke(null,new[]{value});string id=Guid.NewGuid().ToString("N");
            for(int offset=0,index=0;offset<bytes.Length;offset+=8192,index++)
            {var part=new byte[Math.Min(8192,bytes.Length-offset)];Buffer.BlockCopy(bytes,offset,part,0,part.Length);Send(new ZatodPacket{id=id,kind=kind,length=bytes.Length,index=index,bytes=part});}
        }
        public void Send<T>(T value)where T:struct,NetworkMessage
        {
            using var msg=NetworkWriterPool.Get();using var batch=NetworkWriterPool.Get();NetworkMessages.Pack(value,msg);batcher.AddMessage(msg.ToArraySegment(),NetworkTime.localTime);
            while(batcher.GetBatch(batch)){if(!socket.Send(batch.ToArraySegment()))throw new Exception("TCP send failed");batch.Reset();}
        }
        static T Read<T>(byte[] bytes)=>(T)Decode.MakeGenericMethod(typeof(T)).Invoke(null,new object[]{bytes});
        void Receive(ArraySegment<byte> data)
        {
            if(!unbatcher.AddBatch(data))throw new Exception("Bad Mirror batch");
            while(unbatcher.GetNextMessage(out var msg,out _))
            {
                var reader=new NetworkReader(msg);if(!NetworkMessages.UnpackId(reader,out ushort id))throw new Exception("Bad Mirror header");
                if(id==NetworkMessageId<ZatodWorldSnapshot>.Id){World=reader.Read<ZatodWorldSnapshot>();continue;}
                if(id!=NetworkMessageId<ZatodPacket>.Id)continue;
                var packet=reader.Read<ZatodPacket>();var args=new object[]{incoming,packet};var bytes=(byte[])Assemble.Invoke(null,args);incoming=args[0];if(bytes==null)continue;
                switch(packet.kind)
                {
                    case "account":Account=Read<ZatodAccountSnapshot>(bytes);using(var input=new MemoryStream(bytes))using(var zip=new System.IO.Compression.GZipStream(input,System.IO.Compression.CompressionMode.Decompress))using(var text=new StreamReader(zip))RawAccount=text.ReadToEnd();break;
                    case "error":Error=Read<ZatodNotice>(bytes);break;
                    case "replay":Replay=Read<ZatodReplay>(bytes);break;
                    case "start":Start=Read<ZatodStart>(bytes);if(AutoOperations){Simulation=new ZatodBattleSimulation(Start.Match);Operation(1);}break;
                    case "tick":var tick=Read<ZatodTick>(bytes);if(AutoOperations){Check(tick.Tick==Simulation.CurrentTick+1,"Peer tick sequence");foreach(var op in tick.Inputs)Simulation.QueueInput(op);Simulation.Step();Check(Simulation.Frame().Digest==tick.Digest,"Peer digest");if(!Simulation.Finished)Operation(tick.Tick+1);}break;
                }
            }
        }
        void Operation(int tick)
        {
            var actors=Simulation.Frame().Units.Where(u=>u.Team==Start.Team&&u.SummonerId==0&&u.Alive&&Simulation.CanActivateUltimate(u.EntityId,Start.Team)).Take(1).Select(u=>u.EntityId).ToList();
            Payload("operation",new ZatodOperation{BattleId=Start.Match.BattleId,Tick=tick,Actors=actors});
        }
    }
    public static string Arm(string output)
    {
        if(!EditorApplication.isPlaying||!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/")||NetworkClient.active||NetworkServer.active)throw new Exception("Use disconnected isolated Editor Play Mode");
        Directory.CreateDirectory(output);File.WriteAllText(Path.Combine(output,"network.json"),"{\"State\":\"RUNNING\"}");Run(output);return output;
    }
    static async void Run(string output)
    {
        checks=0;string phase="initialize";var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var t=c.GetComponent<TelepathyTransport>();var view=c.GetComponent<ZatodPrototypeView>();
        var login=Field<ZatodLoginView>(view,"loginView");var peers=new List<Peer>();EditorApplication.CallbackFunction pump=null;
        var oldProfile=c.DevelopmentProfile;ushort oldPort=c.Port,oldTransport=t.port;bool oldAuto=c.AutoUltimate;
        string directory=Path.Combine(output,"Server");string file=Path.Combine(directory,"ZatodServerData/datas.json");
        async Task Until(Func<bool> condition,string why,double timeout=20)
        {double end=EditorApplication.timeSinceStartup+timeout;while(!condition()){foreach(var p in peers)if(p.Failure!=null)throw p.Failure;if(EditorApplication.timeSinceStartup>end)throw new TimeoutException(why+" / "+c.Status);await Task.Delay(30);}}
        Peer NewPeer(string command,string name,string password){var p=new Peer(t,command,name,password);peers.Add(p);p.Connect(t.port);return p;}
        Dictionary<int,ZatodPlayerSession> Sessions()=>Field<Dictionary<int,ZatodPlayerSession>>(c,"sessions");
        void StartServer(){Call(c,"InitializeServer",directory,Path.Combine(directory,"ZatodServerData"));}
        async Task Logout(){c.Disconnect();await Until(()=>!NetworkClient.active&&Sessions().Values.All(s=>s.Account.Name!="TinBo"),"Main logout");await Task.Delay(100);}
        async Task LoginMain(string password=" Keep CASE "){c.Login("TinBo",password,"127.0.0.1");await Until(()=>c.Snapshot!=null&&c.WorldSelf!=null,"Main login");}
        try
        {
            c.DevelopmentProfile="d39-"+Guid.NewGuid().ToString("N");c.Port=t.port=17939;c.AutoUltimate=true;StartServer();
            pump=()=>{foreach(var p in peers.ToArray())p.Tick();if(NetworkServer.active){Call(c,"UpdateWorldServer");Call(c,"UpdateEconomyServer");Call(c,"UpdateRooms");}};EditorApplication.update+=pump;
            phase="UI register";login.SelectTab(true);login.PlayerName.text="TinBo";login.Password.text=" Keep CASE ";login.ConfirmPassword.text="mismatch";login.ServerIp.text="127.0.0.1";login.Submit();
            Check(!NetworkClient.active&&login.Message.text.Contains("match"),"Confirm mismatch must not connect");
            login.ConfirmPassword.text=" Keep CASE ";login.Submit();await Until(()=>c.Snapshot!=null&&c.WorldSelf!=null,"Register via real LoginView");
            string id=c.Snapshot.Account.CharacterId;var heroIds=c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray();
            Check(Guid.TryParseExact(id,"D",out _)&&c.WorldSelf.MapId=="town","Server GUID and initial Town");Check(c.Snapshot.Account.HeroDesk.Count==5&&c.Snapshot.Cleared.Count==0,"New player defaults");
            Check(login.Password.text==""&&login.ConfirmPassword.text=="","Password cleared after login");Check(Field<string>(c,"requestedPassword")==null,"Client transient password cleared");
            phase="case and credentials";var lower=NewPeer("register","tinbo","second");await Until(()=>lower.Account!=null&&lower.Self!=null,"Lowercase account");
            Check(lower.Account.Account.CharacterId!=id,"TinBo and tinbo distinct GUIDs");Check(!lower.RawAccount.Contains("Password")&&!lower.RawAccount.Contains(" Keep CASE ")&&!lower.RawAccount.Contains("second"),"Credentials leaked into snapshot");
            var duplicate=NewPeer("register","TinBo","other");await Until(()=>duplicate.Error!=null,"Duplicate registration");Check(duplicate.Account==null,"Duplicate overwrote account");duplicate.Close();
            var wrong=NewPeer("login","TinBo","keep case");await Until(()=>wrong.Error!=null,"Wrong password");Check(wrong.Account==null,"Wrong password admitted");wrong.Close();
            var legacy=NewPeer("hello",Guid.NewGuid().ToString("D"),id);await Until(()=>legacy.Error!=null,"Guest GUID path rejected");Check(legacy.Account==null,"Legacy hello bypassed login");legacy.Close();
            var same=NewPeer("login","TinBo"," Keep CASE ");await Until(()=>same.Error!=null,"Duplicate active account");Check(same.Account==null&&c.Snapshot.Account.CharacterId==id,"Concurrent login disrupted original");same.Close();
            var doc=JsonUtility.FromJson<PlayerDatabase>(File.ReadAllText(file));Check(doc.Players.Count==2&&doc.Players.Single(p=>p.Username=="TinBo").Password==" Keep CASE ","Single shared JSON and exact plaintext");
            Check(Directory.GetFiles(Path.GetDirectoryName(file),"*.json").Length==1,"One main JSON only");
            phase="formation and Campaign";foreach(string heroId in heroIds)c.DevLevel(heroId,10);await Until(()=>c.Snapshot.Account.HeroDesk.All(h=>h.Level==10),"Test-only level fixture");
            c.SaveFormation(heroIds.Take(3));await Until(()=>c.Snapshot.Account.Formation.HeroInstanceIds.Count==3,"Formation commit");c.SaveFormation(heroIds);await Until(()=>c.Snapshot.Account.Formation.HeroInstanceIds.Count==5,"Restore formation");
            c.Campaign("chapter_one_stage_1",heroIds);await Until(()=>c.Battle!=null,"Begin Campaign");string battleId=c.Battle.BattleId;
            await Until(()=>c.LastReplay?.Initial.BattleId==battleId&&c.Snapshot.LastCampaignReward?.BattleId==battleId,"Validated Campaign",100);
            var replay=c.LastReplay;Check(c.Snapshot.StarsFor("chapter_one_stage_1")>0&&c.Snapshot.Account.CampaignRewards.Count==1,"Confirmed stars/reward");Check(replay.Digest==c.Battle.Replay().Digest,"Campaign replay digest");
            Call(view,"Show","campaign");await Until(()=>c.GetComponent<ZatodBattleSceneController>().Phase==ZatodScenePhase.World,"Return scene");
            int stamina=c.Snapshot.Account.Stamina;long gold=CurrencyBalance.GetGold(c.Snapshot.Account);var loot=c.Snapshot.Account.Inventory.Select(i=>i.Id).ToArray();int stars=c.Snapshot.StarsFor("chapter_one_stage_1");
            Check(!lower.Account.Cleared.Contains("chapter_one_stage_1"),"Campaign progress leaked across players");
            File.WriteAllBytes(Path.Combine(output,"campaign.zatod.gz"),(byte[])Encode.Invoke(null,new object[]{replay}));
            phase="client relogin";await Logout();c.Login("TinBo","wrong","127.0.0.1");await Until(()=>c.Status.StartsWith("Error:")&&!NetworkClient.active,"Wrong password retry on real client");Check(!c.LoginBusy,"Rejected login remains busy");await LoginMain();
            Check(c.Snapshot.Account.CharacterId==id&&c.Snapshot.StarsFor("chapter_one_stage_1")==stars&&CurrencyBalance.GetGold(c.Snapshot.Account)==gold,"Relogin lost progress");Check(c.WorldSelf.MapId=="town"&&c.Battle==null,"Relogin resumed battle or position");
            c.Request(new ZatodRequest{Command="replay",A=battleId});await Until(()=>c.LastReplay?.Initial.BattleId==battleId,"View archive");Check(c.Snapshot.Account.CampaignRewards.Count==1,"Replay rewarded twice");Call(view,"Show","campaign");
            phase="interrupted battle";c.Campaign("chapter_one_stage_1",heroIds);await Until(()=>c.Battle!=null&&c.Battle.BattleId!=battleId,"Second battle entry");int entryStamina=c.Snapshot.Account.Stamina;
            Check(entryStamina==stamina-1,"Entry cost changed");await Logout();await LoginMain();Check(c.Snapshot.Account.Stamina==entryStamina&&c.Snapshot.Account.CampaignRewards.Count==1,"Interrupted battle cost/reward");
            Check(c.Snapshot.StarsFor("chapter_one_stage_1")==stars&&!Sessions().Values.Single(s=>s.Account.CharacterId==id).CampaignInProgress,"Interrupted battle restored issued state");
            phase="server restart";await Logout();lower.Close();await Until(()=>Sessions().Count==0,"Close peers before restart");NetworkServer.Shutdown();await Task.Delay(150);StartServer();await LoginMain();
            Check(c.Snapshot.Account.CharacterId==id&&c.Snapshot.StarsFor("chapter_one_stage_1")==stars,"Server restart lost Campaign");Check(c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(loot),"Server restart changed item GUIDs");Check(c.Snapshot.Account.Formation.HeroInstanceIds.Count==5&&c.Snapshot.Account.HeroDesk.All(h=>h.Level==10),"Server restart lost Hero/formation");
            lower=NewPeer("login","tinbo","second");await Until(()=>lower.Account!=null&&lower.Self!=null,"Lower account after server restart");Check(lower.Account.Account.HeroDesk.All(h=>h.Level==1)&&lower.Account.Cleared.Count==0,"Other player overwritten on shared save");
            phase="equip rollback/retry";var session=Sessions().Values.Single(s=>s.Account.CharacterId==id);var hero=session.Account.HeroDesk[0];var slot=HeroProgression.CurrentRank(hero,HeroDataJson.LoadBundledCatalog()).EquipmentSlots.First();
            c.AddItemByItemId(slot.RequiredItemId);await Until(()=>c.Snapshot.Account.Inventory.Any(i=>i.ItemId==slot.RequiredItemId),"Test-only equip item");var item=c.Snapshot.Account.Inventory.First(i=>i.ItemId==slot.RequiredItemId);
            string before=File.ReadAllText(file);File.Move(file,file+".held");Directory.CreateDirectory(file);c.Equip(hero.HeroInstanceId,slot.Id,item.Id);await Until(()=>c.Status.StartsWith("Error:"),"Equip persist rejection");
            Check(session.Account.Inventory.Any(i=>i.Id==item.Id)&&!session.Account.HeroDesk[0].EquippedItems.Any(i=>i.SlotId==slot.Id),"Equip failure did not rollback working state");Directory.Delete(file);File.Move(file+".held",file);Check(File.ReadAllText(file)==before,"Failed equip changed committed file");
            c.Equip(hero.HeroInstanceId,slot.Id,item.Id);await Until(()=>c.Snapshot.Account.HeroDesk[0].EquippedItems.Any(i=>i.Id==item.Id),"Equip retry success");string operation=c.PendingItemOperationId;long revision=c.Snapshot.Account.Revision;
            c.Request(new ZatodRequest{Command="equip",A=hero.HeroInstanceId,B=slot.Id,C=item.Id,OperationId=operation});await Task.Delay(300);Check(c.Snapshot.Account.Revision==revision,"Equip receipt retry changed revision");
            phase="PvP persistence regression";Call(view,"Show","campaign");lower.AutoOperations=true;lower.Replay=null;string key=c.Snapshot.FreePvpRosterKey;var picks=c.Snapshot.FreePvpHeroIds.Take(5).ToArray();
            c.FindPvp(picks);lower.Request(new ZatodRequest{Command="queue",Heroes=picks,FreePvpRosterKey=key});await Until(()=>lower.Replay!=null&&c.LastReplay?.Initial.Mode==ZatodMode.RealtimePvp,"PvP finish",100);
            Check(lower.Replay.Digest==c.LastReplay.Digest&&lower.Replay.Digest==lower.Simulation.Replay().Digest,"PvP peer/server digest mismatch");Check(c.Snapshot.Account.CampaignRewards.Count==1,"PvP granted Campaign reward");
            File.WriteAllBytes(Path.Combine(output,"pvp.zatod.gz"),(byte[])Encode.Invoke(null,new object[]{c.LastReplay}));Call(view,"Show","campaign");
            var final=JsonUtility.FromJson<PlayerDatabase>(File.ReadAllText(file));Check(final.Players.Count==2&&final.Players.All(p=>Guid.TryParse(p.Player.CharacterId,out _)),"Final database identity");
            File.WriteAllText(Path.Combine(output,"network.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{State="PASS",Checks=checks,Players=2,CaseSensitive=true,Restart=true,Rollback=true,CampaignDigest=replay.Digest.ToString(),PvpDigest=c.LastReplay.Digest.ToString(),Database=file},Newtonsoft.Json.Formatting.Indented));
        }
        catch(Exception e){File.WriteAllText(Path.Combine(output,"network.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Checks=checks,Phase=phase,Error=e.ToString()},Newtonsoft.Json.Formatting.Indented));}
        finally
        {
            if(File.Exists(file+".held")){if(Directory.Exists(file))Directory.Delete(file);if(!File.Exists(file))File.Move(file+".held",file);}
            foreach(var peer in peers)peer.Close();c.Disconnect();if(pump!=null)EditorApplication.update-=pump;NetworkServer.Shutdown();
            PlayerPrefs.DeleteKey("Zatod.Username."+c.DevelopmentProfile);PlayerPrefs.DeleteKey("ZatodPrototype.Server."+c.DevelopmentProfile);PlayerPrefs.Save();c.DevelopmentProfile=oldProfile;c.Port=oldPort;t.port=oldTransport;c.AutoUltimate=oldAuto;
        }
    }
}
