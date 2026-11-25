using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using Mirror;
using UnityEngine;
using Zatod.Heroes;
using Zatod.Combat;
namespace Zatod.Networking
{
    public sealed partial class ZatodConnection
    {
        readonly Dictionary<int,List<HeroData>> queuedTeams=new Dictionary<int,List<HeroData>>();
        void StartServer()
        {
            string replayDirectory=Path.GetFullPath(Argument("--data-dir",Path.Combine(Application.persistentDataPath,"ZatodPrototype")));
            string playerDirectory=Path.GetFullPath(Argument("--player-data-dir",
                Path.Combine(HasArgument("--data-dir")?replayDirectory:Application.persistentDataPath,"ZatodServerData")));
            InitializeServer(replayDirectory,playerDirectory);
        }
        void InitializeServer(string replayDirectory,string playerDirectory)
        {
            sessions.Clear();archives.Clear();uploads.Clear();queue.Clear();queuedTeams.Clear();rooms.Clear();worldPlayers.Clear();
            if(serverWorldRoot!=null)Destroy(serverWorldRoot);
            catalog=HeroDataJson.LoadBundledCatalog();campaign=CampaignDataJson.LoadZatod(catalog);progression=ProgressionDataJson.LoadBundled();
            archiveDirectory=Path.GetFullPath(replayDirectory);
            Directory.CreateDirectory(archiveDirectory);
            playerStore=new PlayerDatabaseStore(Path.Combine(playerDirectory,"datas.json"),
                data=>JsonUtility.ToJson(data,true),json=>JsonUtility.FromJson<PlayerDatabase>(json),account=>
                {catalog.Bind(account);new ItemInventory(account,catalog).Validate();new HeroFormation(account,catalog);new CampaignRun(campaign).Restore(account.MainCampaignProgress);});
            Debug.Log("[ZatodServer] Player data: "+playerStore.FilePath+(playerStore.RecoveredBackup?" (backup recovered)":""));
            foreach(var path in Directory.GetFiles(archiveDirectory,"*.gz").Where(path=>path.EndsWith(".zatod.gz",StringComparison.Ordinal) || path.EndsWith(".crystal.gz",StringComparison.Ordinal)))
            {
                try {var replay=ReplayArchive.DecodePayload<ZatodReplay>(File.ReadAllBytes(path));if(replay.Completed && ZatodMatchDefinition.SupportedRules(replay.Initial.RulesVersion))archives[replay.Initial.BattleId]=replay;}
                catch(Exception error){Debug.LogWarning("[ZatodArchive] "+Path.GetFileName(path)+": "+error.Message);}
            }
            NetworkServer.RegisterHandler<ZatodPacket>(OnServerPacket,false);RegisterWorldServer();
            NetworkServer.OnDisconnectedEvent-=ServerDisconnected;NetworkServer.OnDisconnectedEvent+=ServerDisconnected;
            NetworkServer.Listen(32);SetStatus("Zatod server TCP "+Port);
            Debug.Log("[ZatodServer] READY port="+Port+" inputArchives="+archiveDirectory);
        }
        static uint Seed(){using(var generator=RandomNumberGenerator.Create()){var bytes=new byte[4];generator.GetBytes(bytes);return BitConverter.ToUInt32(bytes,0);}}
        void OnServerPacket(NetworkConnectionToClient connection,ZatodPacket packet)
        {
            try
            {
                uploads.TryGetValue(connection.connectionId,out var incoming);
                var bytes=Assemble(ref incoming,packet);
                if(incoming==null)uploads.Remove(connection.connectionId);else uploads[connection.connectionId]=incoming;
                if(bytes==null)return;
                if(packet.kind=="request")HandleRequest(connection,ReplayArchive.DecodePayload<ZatodRequest>(bytes));
                else
                {
                    if(!sessions.TryGetValue(connection.connectionId,out var session))throw new ArgumentException("Launch session is missing.");
                    if(packet.kind=="claim")
                    {
                        var replay=session.ValidateCampaign(ReplayArchive.DecodePayload<ZatodReplay>(bytes),()=>SaveOwned(session));
                        try{Archive(replay);}catch(Exception archiveError){Debug.LogWarning("[ZatodArchive] Replay could not be written: "+archiveError.GetType().Name);}
                        Send(connection,"replay",replay);SendAccount(connection,session,false);
                        Debug.Log("[ZatodServer] VALIDATED "+replay.Initial.BattleId+" ticks="+replay.EndTick+" inputs="+replay.Inputs.Count+" digest="+replay.Digest);
                    }
                    else if(packet.kind=="operation")AcceptOperation(connection,ReplayArchive.DecodePayload<ZatodOperation>(bytes));
                    else throw new ArgumentException("Unknown client payload.");
                }
            }
            catch(Exception error)
            {
                uploads.Remove(connection.connectionId);
                // A stale Hero request needs the current revision before the player can retry it.
                if(sessions.TryGetValue(connection.connectionId,out var current))
                    try{SendAccount(connection,current,false);}catch(Exception snapshotError){Debug.LogWarning("[ZatodServer] Snapshot after rejection failed: "+snapshotError.Message);}
                Send(connection,"error",new ZatodNotice{Text=error.Message,PvpQueued=queue.Contains(connection.connectionId)});
                Debug.LogWarning("[ZatodServer] REJECTED connection="+connection.connectionId+" "+error.Message);
            }
        }
        void HandleRequest(NetworkConnectionToClient connection,ZatodRequest request)
        {
            if(request==null)throw new ArgumentException("Request is missing.");
            int id=connection.connectionId;
            if(request.Command=="login" || request.Command=="register")
            {
                if(sessions.ContainsKey(id))throw new ArgumentException("This connection is already logged in.");
                var owned=request.Command=="register"?playerStore.Register(request.A,request.B,()=>
                {
                    var fresh=campaign.CreateDemoCharacter(catalog);progression.Initialize(fresh,DateTimeOffset.UtcNow.ToUnixTimeSeconds());
                    fresh.Formation.HeroInstanceIds=fresh.HeroDesk.Take(5).Select(h=>h.HeroInstanceId).ToList();return fresh;
                }):playerStore.Login(request.A,request.B);
                if(sessions.Values.Any(x=>x.Account.CharacterId==owned.CharacterId))throw new ArgumentException("This account is already logged in.");
                var found=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),owned,progression:progression);
                // Constructor applies offline recovery before the initial snapshot. Persist it before admitting the player.
                if(request.Command=="login")SaveOwned(found);
                sessions.Add(id,found);JoinWorld(connection,found);SendAccount(connection,found,false);return;
            }
            if(!sessions.TryGetValue(id,out var session))throw new ArgumentException("Initialize the launch first.");
            session.RefreshEconomy(()=>SaveOwned(session));
            if(request.Command=="world_portal" || request.Command=="world_chapter")
            {
                if(session.CampaignInProgress || rooms.Any(r=>r.Left==id || r.Right==id) || queue.Contains(id))throw new ArgumentException("Finish or cancel the battle/queue before travelling.");
                UseWorldTravel(connection,session,request);return;
            }
            if(request.Command=="replay")
            {
                if(!archives.TryGetValue(request.A??"",out var record))throw new ArgumentException("Replay is unavailable.");Send(connection,"replay",record);return;
            }
            if(request.Command=="cancel")
            {
                session.CancelCampaign();RemoveFromQueue(id);AbortRoom(id,"Battle cancelled by a player.");SendAccount(connection,session);return;
            }
            bool heroReceiptRetry=(request.Command=="equip" || request.Command=="craft" || request.Command=="skill_up" || request.Command=="quick_equip" || request.Command=="promote")
                && Guid.TryParseExact(request.OperationId,"D",out var retryId)
                && (session.Account.ItemOperations?.Any(r=>r.OperationId==retryId.ToString("D") && r.Command==request.Command)??false);
            if(!heroReceiptRetry && (rooms.Any(r=>r.Left==id || r.Right==id) || queue.Contains(id)))throw new ArgumentException("Cancel PvP before changing mode or loadout.");
            switch(request.Command)
            {
                case "campaign":
                    var match=session.BeginCampaign(request.A,request.Heroes,Seed(),Guid.NewGuid().ToString("N"),()=>SaveOwned(session));SendAccount(connection,session,false);Send(connection,"start",new ZatodStart{Match=match,LootItems=session.PendingLoot(match.BattleId)});break;
                case "arena":
                    var left=session.Team(request.Heroes);
                    var right=campaign.CreateDemoCharacter(catalog).HeroDesk;
                    for(int i=0;i<right.Count;i++){right[i].Level=left[Math.Min(i,left.Count-1)].Level;}
                    var arena=ZatodMatchFactory.Versus(catalog,left,right,Seed(),Guid.NewGuid().ToString("N"),false);
                    var replay=new ZatodBattleSimulation(arena).RunToCompletion();Archive(replay);Send(connection,"replay",replay);SendAccount(connection,session);break;
                case "queue":
                    if(session.CampaignInProgress)throw new ArgumentException("Finish or cancel Campaign before joining PvP.");
                    if(catalog.FreePvp.CompatibilityKey!=null && catalog.FreePvp.CompatibilityKey!=request.FreePvpRosterKey)
                        throw new ArgumentException(FreePvpMismatch);
                    queuedTeams.Add(id,PvpTeam(session,request.Heroes));queue.Add(id);
                    Send(connection,"notice",new ZatodNotice{Text="Finding a second online player..."});Pair();break;
                case "item":if(request.Number<1 || request.Number>100)throw new ArgumentException("Dev grant amount must be 1-100.");session.DevItem(request.A,request.Number);SendAccount(connection,session);break;
                case "equip":session.EquipItem(request.A,request.B,request.C,request.OperationId??Guid.NewGuid().ToString("D"),()=>SaveOwned(session));SendAccount(connection,session,false);break;
                case "craft":session.Craft(request.A,request.OperationId,()=>SaveOwned(session));SendAccount(connection,session,false);break;
                case "sell":case "quick_craft":case "use_exp":case "recruit":case "star_up":
                    session.ExecuteInventory(request.Command,request.A,request.Number,request.B,request.OperationId,()=>SaveOwned(session));SendAccount(connection,session,false);break;
                case "skill_up":session.UpgradeSkill(request.A,request.B,request.ExpectedLevel,request.Number,request.ExpectedRevision,request.OperationId,()=>SaveOwned(session));SendAccount(connection,session,false);break;
                case "quick_equip":session.QuickEquip(request.A,request.ExpectedRevision,request.OperationId,()=>SaveOwned(session));SendAccount(connection,session,false);break;
                case "promote":session.PromoteHero(request.A,request.ExpectedRevision,request.OperationId,()=>SaveOwned(session));SendAccount(connection,session,false);break;
                case "level":session.DevLevel(request.A,request.Number);SendAccount(connection,session);break;
                case "formation":session.SetFormation(request.Heroes,()=>SaveOwned(session));SendAccount(connection,session,false);break;
                default:throw new ArgumentException("Unknown Crystal command.");
            }
        }
        void UpdateEconomyServer()
        {
            if(NetworkTime.time<nextEconomySync)return;nextEconomySync=NetworkTime.time+1;
            foreach(var pair in sessions.ToArray())
            {
                try{if(pair.Value.RefreshEconomy(()=>SaveOwned(pair.Value)) && NetworkServer.connections.TryGetValue(pair.Key,out var client))SendAccount(client,pair.Value,false);}
                catch(Exception error){Debug.LogWarning("[ZatodEconomy] Recovery save failed: "+error.Message);}
            }
        }
        void SaveOwned(ZatodPlayerSession session)
        {
            playerStore.Save(session.Account);
        }
        void SendAccount(NetworkConnectionToClient connection,ZatodPlayerSession session,bool save=true)
        {
            if(save)SaveOwned(session);
            Send(connection,"account",new ZatodAccountSnapshot{Username=playerStore.UsernameFor(session.Account.CharacterId),ServerTime=DateTimeOffset.UtcNow.ToUnixTimeSeconds(),Account=session.Account,LastCampaignReward=session.LastCampaignReward,Cleared=session.Run.Stars.Keys.ToList(),StageStars=session.Run.Stars.OrderBy(s=>s.Key,StringComparer.Ordinal).Select(s=>new ZatodStageStars{StageId=s.Key,Stars=s.Value}).ToList(),Replays=archives.Values.OrderByDescending(x=>x.Initial.BattleId).Take(100).Select(x=>x.Initial.BattleId).ToList(),FreePvpHeroIds=catalog.FreePvp.HeroIds.ToList(),FreePvpRosterKey=catalog.FreePvp.CompatibilityKey});
        }
        void Archive(ZatodReplay replay)
        {
            if(!replay.Completed || !Guid.TryParseExact(replay.Initial.BattleId,"N",out _))throw new InvalidDataException("Archive needs a completed server-issued battle.");
            string path=Path.Combine(archiveDirectory,replay.Initial.BattleId+".zatod.gz");
            string temporary=path+".tmp";File.WriteAllBytes(temporary,ReplayArchive.EncodePayload(replay));File.Move(temporary,path);archives.Add(replay.Initial.BattleId,replay);
        }
        List<HeroData> PvpTeam(ZatodPlayerSession session,IEnumerable<string> ids)
            =>catalog.FreePvp.HeroIds.Count>0?catalog.FreePvp.Team(ids):session.Team(ids);
        void RemoveFromQueue(int id){queue.Remove(id);queuedTeams.Remove(id);}
        void Pair()
        {
            if(queue.Count<2)return;
            int left=queue[0],right=queue[1];
            ZatodMatchDefinition match;
            RealtimeRoom room;
            try
            {
                match=ZatodMatchFactory.Versus(catalog,queuedTeams[left],queuedTeams[right],Seed(),Guid.NewGuid().ToString("N"),true);
                room=new RealtimeRoom{Left=left,Right=right,Simulation=new ZatodBattleSimulation(match),NextTime=NetworkTime.time+ZatodBattleSimulation.StepSeconds};
            }
            catch
            {
                RemoveFromQueue(left);RemoveFromQueue(right);
                if(NetworkServer.connections.TryGetValue(left,out var waiting))
                    Send(waiting,"error",new ZatodNotice{Text="PvP could not start. Find another match to retry."});
                throw;
            }
            RemoveFromQueue(left);RemoveFromQueue(right);
            rooms.Add(room);
            Send(NetworkServer.connections[left],"start",new ZatodStart{Match=match,Team=0});Send(NetworkServer.connections[right],"start",new ZatodStart{Match=match,Team=1});
            Debug.Log("[ZatodServer] PVP_START "+match.BattleId+" left="+left+" right="+right);
        }
        void AcceptOperation(NetworkConnectionToClient connection,ZatodOperation operation)
        {
            int id=connection.connectionId;var room=rooms.SingleOrDefault(r=>r.Left==id || r.Right==id)??throw new ArgumentException("No active PvP room.");
            if(operation==null || operation.BattleId!=room.Simulation.BattleId || operation.Tick<1 || operation.Actors==null || operation.Actors.Count>5 || operation.Actors.Distinct().Count()!=operation.Actors.Count)throw new ArgumentException("Invalid operation envelope.");
            // The first five model ticks have implicit empty sets. Sprite loading can delay
            // a rendered client's empty envelopes until those ticks are already committed.
            if(operation.Tick<=5 && operation.Tick<=room.Simulation.CurrentTick && operation.Actors.Count==0)return;
            if(operation.Tick!=room.Simulation.CurrentTick+1 || room.Operations.ContainsKey(id))throw new ArgumentException("Operation does not belong to the next tick.");
            int team=room.Left==id?0:1;
            if(operation.Actors.Any(actor=>!room.Simulation.Frame().Units.Any(u=>u.EntityId==actor && u.Team==team && u.SummonerId==0)))throw new ArgumentException("Operation actor is not owned by this connection.");
            room.Operations.Add(id,operation);
        }
        void UpdateRooms()
        {
            foreach(var room in rooms.ToArray())
            {
                if(NetworkTime.time<room.NextTime)continue;
                int next=room.Simulation.CurrentTick+1;
                // Crystal permits the first five no-input ticks; afterward both operation sets gate progress.
                if(next>5 && (!room.Operations.ContainsKey(room.Left) || !room.Operations.ContainsKey(room.Right)))continue;
                var committed=new List<ZatodInput>();
                foreach(int owner in new[]{room.Left,room.Right})
                {
                    if(!room.Operations.TryGetValue(owner,out var operation))continue;
                    // Recovered host priority: a host manual cast suppresses guest manual casts on the same tick.
                    if(owner==room.Right && committed.Count>0)continue;
                    foreach(int actor in operation.Actors)
                    {
                        var input=new ZatodInput{Tick=next,ActorId=actor,Team=owner==room.Left?0:1};
                        try{room.Simulation.QueueInput(input);committed.Add(input);}catch(ArgumentException){/* Illegal intents are not committed. */}
                    }
                }
                room.Simulation.Step();room.Operations.Clear();room.NextTime=NetworkTime.time+ZatodBattleSimulation.StepSeconds;
                var batch=new ZatodTick{BattleId=room.Simulation.BattleId,Tick=next,Inputs=committed,Digest=room.Simulation.Frame().Digest};
                Send(NetworkServer.connections[room.Left],"tick",batch);Send(NetworkServer.connections[room.Right],"tick",batch);
                if(room.Simulation.Finished)
                {
                    var replay=room.Simulation.Replay();Archive(replay);
                    foreach(int id in new[]{room.Left,room.Right}){Send(NetworkServer.connections[id],"replay",replay);SendAccount(NetworkServer.connections[id],sessions[id]);}
                    rooms.Remove(room);Debug.Log("[ZatodServer] PVP_END "+replay.Initial.BattleId+" ticks="+replay.EndTick+" inputs="+replay.Inputs.Count+" digest="+replay.Digest);
                }
            }
        }
        void AbortRoom(int id,string reason)
        {
            foreach(var room in rooms.Where(r=>r.Left==id || r.Right==id).ToArray())
            {
                foreach(int peer in new[]{room.Left,room.Right})if(NetworkServer.connections.TryGetValue(peer,out var connection))Send(connection,"abort",new ZatodNotice{Text=reason});
                rooms.Remove(room);
            }
        }
        void ServerDisconnected(NetworkConnectionToClient connection)
        {int id=connection.connectionId;if(sessions.TryGetValue(id,out var session))session.CancelCampaign();AbortRoom(id,"Opponent disconnected. Match aborted; no result recorded.");RemoveFromQueue(id);sessions.Remove(id);uploads.Remove(id);worldPlayers.Remove(id);nextWorldSnapshot=0;}
    }
}
