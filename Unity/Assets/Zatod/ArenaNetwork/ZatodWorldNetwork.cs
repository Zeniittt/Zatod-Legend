using System;
using System.Collections.Generic;
using System.Linq;
using Mirror;
using UnityEngine;
using Zatod.Combat;
using Zatod.World;
namespace Zatod.Networking
{
    public struct ZatodWorldPose : NetworkMessage {public string MapId;public uint MapRevision;public float X,Y,Facing;public bool Walking;}
    public struct ZatodWorldSnapshot : NetworkMessage {public int SelfId;public double ServerTime;public WorldPlayerState[] Players;}
    public sealed partial class ZatodConnection
    {
        WorldCatalog worldCatalog;
        GameObject serverWorldRoot;
        readonly Dictionary<int,WorldPlayerState> worldPlayers=new Dictionary<int,WorldPlayerState>();
        double nextWorldSnapshot;
        public WorldPlayerState[] WorldPlayers{get;private set;}=Array.Empty<WorldPlayerState>();
        public int WorldSelfId{get;private set;}=-1;
        public WorldPlayerState WorldSelf=>WorldPlayers.FirstOrDefault(p=>p.ConnectionId==WorldSelfId);
        public event Action WorldChanged;
        void RegisterWorldClient()=>NetworkClient.RegisterHandler<ZatodWorldSnapshot>(message=>
        {
            WorldSelfId=message.SelfId;WorldPlayers=message.Players??Array.Empty<WorldPlayerState>();WorldChanged?.Invoke();
        },false);
        void RegisterWorldServer()
        {
            worldCatalog=WorldDataJson.Load(campaign);
            serverWorldRoot=ZatodWorldMapRuntime.Create(worldCatalog,transform);
            NetworkServer.RegisterHandler<ZatodWorldPose>((connection,message)=>
            {
                if(!worldPlayers.TryGetValue(connection.connectionId,out var player) || player.MapId!=message.MapId || player.MapRevision!=message.MapRevision || !WorldCatalog.Finite(message.X,message.Y,message.Facing))return;
                // Avatar movement is cosmetic and owner-driven in this prototype. Server owns map membership.
                var map=worldCatalog.Map(player.MapId);player.X=Math.Clamp(message.X,map.MinX+WorldMovement.Radius,map.MaxX-WorldMovement.Radius);player.Y=Math.Clamp(message.Y,map.MinY+WorldMovement.Radius,map.MaxY-WorldMovement.Radius);
                player.Facing=message.Facing<0?-1:1;player.Walking=message.Walking;
            },false);
        }
        void JoinWorld(NetworkConnectionToClient connection,ZatodPlayerSession session)
        {
            var spawn=worldCatalog.Spawn("town","entry");
            worldPlayers[connection.connectionId]=new WorldPlayerState{ConnectionId=connection.connectionId,AccountId=session.Account.CharacterId,Name="Player "+session.Account.CharacterId.Substring(0,5),MapId="town",MapRevision=1,X=spawn.X,Y=spawn.Y};
            nextWorldSnapshot=0;
        }
        void UpdateWorldServer()
        {
            if(NetworkTime.time<nextWorldSnapshot)return;nextWorldSnapshot=NetworkTime.time+.1;
            foreach(var group in worldPlayers.Values.GroupBy(p=>p.MapId))
            {
                var players=group.OrderBy(p=>p.ConnectionId).ToArray();
                foreach(var player in players)if(NetworkServer.connections.TryGetValue(player.ConnectionId,out var peer))
                {
                    var visible=players.Where(p=>WorldInterest.Visible(player,p,worldCatalog.Map(player.MapId).InterestRadius)).ToArray();
                    peer.Send(new ZatodWorldSnapshot{SelfId=player.ConnectionId,ServerTime=NetworkTime.time,Players=visible});
                }
            }
        }
        void UseWorldPortal(NetworkConnectionToClient connection,string interactionId)
        {
            if(!worldPlayers.TryGetValue(connection.connectionId,out var player))throw new ArgumentException("World player is missing.");
            var point=worldCatalog.Interaction(player.MapId,interactionId);
            if(point.Kind!=WorldInteractionKind.Portal)throw new ArgumentException("This point is not a portal.");
            var destination=worldCatalog.Spawn(point.TargetId,point.DestinationSpawnId);player.MapId=point.TargetId;player.X=destination.X;player.Y=destination.Y;player.Walking=false;player.MapRevision++;nextWorldSnapshot=0;
        }
        public void WorldTravel(string portalId)=>Request(new ZatodRequest{Command="world_portal",A=portalId});
        public void SendWorldPose(float x,float y,float facing,bool walking)
        {
            var self=WorldSelf;if(!Connected || self==null)return;
            NetworkClient.Send(new ZatodWorldPose{MapId=self.MapId,MapRevision=self.MapRevision,X=x,Y=y,Facing=facing,Walking=walking});
        }
        void ClearClientWorld(){WorldPlayers=Array.Empty<WorldPlayerState>();WorldSelfId=-1;WorldChanged?.Invoke();}
    }
}
