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
    public sealed partial class CrystalConnection
    {
        readonly Dictionary<int,List<string>> queuedTeams=new Dictionary<int,List<string>>();
        void StartServer()
        {
            catalog=HeroDataJson.LoadBundledCatalog();campaign=CampaignDataJson.LoadCrystal(catalog);
            archiveDirectory=Path.GetFullPath(Argument("--data-dir",Path.Combine(Application.persistentDataPath,"CrystalPrototype")));
            Directory.CreateDirectory(archiveDirectory);
            foreach(var path in Directory.GetFiles(archiveDirectory,"*.crystal.gz"))
            {
                try {var replay=ReplayArchive.DecodePayload<CrystalReplay>(File.ReadAllBytes(path));if(replay.Completed && replay.Initial.RulesVersion==CrystalMatchDefinition.Rules)archives[replay.Initial.BattleId]=replay;}
                catch(Exception error){Debug.LogWarning("[CrystalArchive] "+Path.GetFileName(path)+": "+error.Message);}
            }
            NetworkServer.RegisterHandler<CrystalPacket>(OnServerPacket,false);
            NetworkServer.OnDisconnectedEvent+=ServerDisconnected;
            NetworkServer.Listen(32);SetStatus("Crystal server TCP "+Port);
            Debug.Log("[CrystalServer] READY port="+Port+" inputArchives="+archiveDirectory);
        }
        static uint Seed(){using(var generator=RandomNumberGenerator.Create()){var bytes=new byte[4];generator.GetBytes(bytes);return BitConverter.ToUInt32(bytes,0);}}
        void OnServerPacket(NetworkConnectionToClient connection,CrystalPacket packet)
        {
            try
            {
                uploads.TryGetValue(connection.connectionId,out var incoming);
                var bytes=Assemble(ref incoming,packet);
                if(incoming==null)uploads.Remove(connection.connectionId);else uploads[connection.connectionId]=incoming;
                if(bytes==null)return;
                if(packet.kind=="request")HandleRequest(connection,ReplayArchive.DecodePayload<CrystalRequest>(bytes));
                else
                {
                    if(!sessions.TryGetValue(connection.connectionId,out var session))throw new ArgumentException("Launch session is missing.");
                    if(packet.kind=="claim")
                    {
                        var replay=session.ValidateCampaign(ReplayArchive.DecodePayload<CrystalReplay>(bytes));Archive(replay);Send(connection,"replay",replay);SendAccount(connection,session);
                        Debug.Log("[CrystalServer] VALIDATED "+replay.Initial.BattleId+" ticks="+replay.EndTick+" inputs="+replay.Inputs.Count+" digest="+replay.Digest);
                    }
                    else if(packet.kind=="operation")AcceptOperation(connection,ReplayArchive.DecodePayload<CrystalOperation>(bytes));
                    else throw new ArgumentException("Unknown client payload.");
                }
            }
            catch(Exception error)
            {
                uploads.Remove(connection.connectionId);Send(connection,"error",new CrystalNotice{Text=error.Message});
                Debug.LogWarning("[CrystalServer] REJECTED connection="+connection.connectionId+" "+error.Message);
            }
        }
        void HandleRequest(NetworkConnectionToClient connection,CrystalRequest request)
        {
            if(request==null)throw new ArgumentException("Request is missing.");
            int id=connection.connectionId;
            if(request.Command=="hello")
            {
                if(sessions.ContainsKey(id))throw new ArgumentException("Launch already initialized.");
                if(!Guid.TryParseExact(request.B,"D",out _))throw new ArgumentException("Prototype account GUID is required.");
                if(sessions.Values.Any(x=>x.Account.CharacterId==request.B))throw new ArgumentException("This development profile is connected already.");
                if(!launches.TryGetValue(request.A,out var found))
                {
                    string accountPath=OwnedPath(request.B);
                    var owned=File.Exists(accountPath)?HeroDataJson.ReadCharacter(File.ReadAllText(accountPath),catalog):campaign.CreateDemoCharacter(catalog);
                    owned.CharacterId=request.B;found=new CrystalPlayerSession(catalog,campaign,request.A,owned);launches.Add(request.A,found);SaveOwned(found);
                }
                if(sessions.Values.Contains(found))throw new ArgumentException("This launch is connected already.");
                sessions.Add(id,found);SendAccount(connection,found);return;
            }
            if(!sessions.TryGetValue(id,out var session))throw new ArgumentException("Initialize the launch first.");
            if(request.Command=="replay")
            {
                if(!archives.TryGetValue(request.A??"",out var record))throw new ArgumentException("Replay is unavailable.");Send(connection,"replay",record);return;
            }
            if(request.Command=="cancel")
            {
                session.CancelCampaign();RemoveFromQueue(id);AbortRoom(id,"Battle cancelled by a player.");SendAccount(connection,session);return;
            }
            if(rooms.Any(r=>r.Left==id || r.Right==id) || queue.Contains(id))throw new ArgumentException("Cancel PvP before changing mode or loadout.");
            switch(request.Command)
            {
                case "campaign":
                    var match=session.BeginCampaign(request.A,request.Heroes,Seed(),Guid.NewGuid().ToString("N"));Send(connection,"start",new CrystalStart{Match=match});break;
                case "arena":
                    var left=session.Team(request.Heroes);
                    var right=campaign.CreateDemoCharacter(catalog).HeroDesk;
                    for(int i=0;i<right.Count;i++){right[i].Level=left[Math.Min(i,left.Count-1)].Level;}
                    var arena=CrystalMatchFactory.Versus(catalog,left,right,Seed(),Guid.NewGuid().ToString("N"),false);
                    var replay=new CrystalBattleSimulation(arena).RunToCompletion();Archive(replay);Send(connection,"replay",replay);SendAccount(connection,session);break;
                case "queue":
                    var selected=session.Team(request.Heroes);queuedTeams[id]=selected.Select(h=>h.HeroInstanceId).ToList();queue.Add(id);
                    Send(connection,"notice",new CrystalNotice{Text="Finding a second online player..."});Pair();break;
                case "item":if(request.Number<1 || request.Number>100)throw new ArgumentException("Dev grant amount must be 1-100.");session.DevItem(request.A,request.Number);SendAccount(connection,session);break;
                case "equip":session.Equip(request.A,request.B,request.C);SendAccount(connection,session);break;
                case "promote":session.Promote(request.A);SendAccount(connection,session);break;
                case "level":session.DevLevel(request.A,request.Number);SendAccount(connection,session);break;
                default:throw new ArgumentException("Unknown Crystal command.");
            }
        }
        string OwnedPath(string id)
        {
            if(!Guid.TryParseExact(id,"D",out _))throw new ArgumentException("Invalid account identity.");
            string folder=Path.Combine(archiveDirectory,"Owned");Directory.CreateDirectory(folder);return Path.Combine(folder,id+".json");
        }
        void SaveOwned(CrystalPlayerSession session)
        {
            string path=OwnedPath(session.Account.CharacterId),temporary=path+".tmp";
            File.WriteAllText(temporary,HeroDataJson.WriteCharacter(session.Account,catalog));
            if(File.Exists(path))File.Replace(temporary,path,null);else File.Move(temporary,path);
        }
        void SendAccount(NetworkConnectionToClient connection,CrystalPlayerSession session)
        {
            SaveOwned(session);
            Send(connection,"account",new CrystalAccountSnapshot{Account=session.Account,Cleared=session.Run.Stars.Keys.ToList(),Replays=archives.Values.OrderByDescending(x=>x.Initial.BattleId).Take(100).Select(x=>x.Initial.BattleId).ToList()});
        }
        void Archive(CrystalReplay replay)
        {
            if(!replay.Completed || !Guid.TryParseExact(replay.Initial.BattleId,"N",out _))throw new InvalidDataException("Archive needs a completed server-issued battle.");
            string path=Path.Combine(archiveDirectory,replay.Initial.BattleId+".crystal.gz");
            string temporary=path+".tmp";File.WriteAllBytes(temporary,ReplayArchive.EncodePayload(replay));File.Move(temporary,path);archives.Add(replay.Initial.BattleId,replay);
        }
        void RemoveFromQueue(int id){queue.Remove(id);queuedTeams.Remove(id);}
        void Pair()
        {
            if(queue.Count<2)return;
            int left=queue[0],right=queue[1];var lt=sessions[left].Team(queuedTeams[left]);var rt=sessions[right].Team(queuedTeams[right]);
            RemoveFromQueue(left);RemoveFromQueue(right);
            var match=CrystalMatchFactory.Versus(catalog,lt,rt,Seed(),Guid.NewGuid().ToString("N"),true);
            var room=new RealtimeRoom{Left=left,Right=right,Simulation=new CrystalBattleSimulation(match),NextTime=NetworkTime.time+CrystalBattleSimulation.StepSeconds};rooms.Add(room);
            Send(NetworkServer.connections[left],"start",new CrystalStart{Match=match,Team=0});Send(NetworkServer.connections[right],"start",new CrystalStart{Match=match,Team=1});
            Debug.Log("[CrystalServer] PVP_START "+match.BattleId+" left="+left+" right="+right);
        }
        void AcceptOperation(NetworkConnectionToClient connection,CrystalOperation operation)
        {
            int id=connection.connectionId;var room=rooms.SingleOrDefault(r=>r.Left==id || r.Right==id)??throw new ArgumentException("No active PvP room.");
            if(operation==null || operation.BattleId!=room.Simulation.BattleId || operation.Tick<1 || operation.Actors==null || operation.Actors.Count>5 || operation.Actors.Distinct().Count()!=operation.Actors.Count)throw new ArgumentException("Invalid operation envelope.");
            // The first five model ticks have implicit empty sets. Sprite loading can delay
            // a rendered client's empty envelopes until those ticks are already committed.
            if(operation.Tick<=5 && operation.Tick<=room.Simulation.CurrentTick && operation.Actors.Count==0)return;
            if(operation.Tick!=room.Simulation.CurrentTick+1 || room.Operations.ContainsKey(id))throw new ArgumentException("Operation does not belong to the next tick.");
            int team=room.Left==id?0:1;
            if(operation.Actors.Any(actor=>!room.Simulation.Frame().Units.Any(u=>u.EntityId==actor && u.Team==team)))throw new ArgumentException("Operation actor is not owned by this connection.");
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
                var committed=new List<CrystalInput>();
                foreach(int owner in new[]{room.Left,room.Right})
                {
                    if(!room.Operations.TryGetValue(owner,out var operation))continue;
                    // Recovered host priority: a host manual cast suppresses guest manual casts on the same tick.
                    if(owner==room.Right && committed.Count>0)continue;
                    foreach(int actor in operation.Actors)
                    {
                        var input=new CrystalInput{Tick=next,ActorId=actor,Team=owner==room.Left?0:1};
                        try{room.Simulation.QueueInput(input);committed.Add(input);}catch(ArgumentException){/* Illegal intents are not committed. */}
                    }
                }
                room.Simulation.Step();room.Operations.Clear();room.NextTime=NetworkTime.time+CrystalBattleSimulation.StepSeconds;
                var batch=new CrystalTick{BattleId=room.Simulation.BattleId,Tick=next,Inputs=committed,Digest=room.Simulation.Frame().Digest};
                Send(NetworkServer.connections[room.Left],"tick",batch);Send(NetworkServer.connections[room.Right],"tick",batch);
                if(room.Simulation.Finished)
                {
                    var replay=room.Simulation.Replay();Archive(replay);
                    foreach(int id in new[]{room.Left,room.Right}){Send(NetworkServer.connections[id],"replay",replay);SendAccount(NetworkServer.connections[id],sessions[id]);}
                    rooms.Remove(room);Debug.Log("[CrystalServer] PVP_END "+replay.Initial.BattleId+" ticks="+replay.EndTick+" inputs="+replay.Inputs.Count+" digest="+replay.Digest);
                }
            }
        }
        void AbortRoom(int id,string reason)
        {
            foreach(var room in rooms.Where(r=>r.Left==id || r.Right==id).ToArray())
            {
                foreach(int peer in new[]{room.Left,room.Right})if(NetworkServer.connections.TryGetValue(peer,out var connection))Send(connection,"abort",new CrystalNotice{Text=reason});
                rooms.Remove(room);
            }
        }
        void ServerDisconnected(NetworkConnectionToClient connection)
        {int id=connection.connectionId;AbortRoom(id,"Opponent disconnected. Match aborted; no result recorded.");RemoveFromQueue(id);sessions.Remove(id);uploads.Remove(id);}
    }
}
