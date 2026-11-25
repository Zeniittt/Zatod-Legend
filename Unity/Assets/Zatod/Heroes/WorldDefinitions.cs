using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.World
{
    public enum WorldInteractionKind { Stage,Portal,Feature }
    [Serializable] public sealed class WorldDefinition { public int SchemaVersion=1;public string ConfigVersion="zatod-world-1";public List<string> MapResources=new List<string>();public List<WorldMapDefinition> Maps=new List<WorldMapDefinition>(); }
    [Serializable] public sealed class WorldSpawnPoint {public string Id;public float X,Y;}
    [Serializable] public sealed class WorldPropDefinition {public string Id,VisualResource;public float X,Y,Height=2,HalfWidth,HalfDepth;}
    [Serializable] public sealed class WorldInteractionDefinition
    {
        public string Id,Label,VisualResource,TargetId,DestinationSpawnId="entry";
        public WorldInteractionKind Kind;public float X,Y,Radius=2.5f,Height=1.7f,HalfWidth=.4f,HalfDepth=.25f;
    }
    [Serializable] public sealed class WorldMapDefinition
    {
        public string Id,Name,Theme,VisualResource;
        public float OriginX,OriginY,InterestRadius=48;
        public float MinX,MinY,MaxX,MaxY;
        public List<WorldSpawnPoint> Spawns=new List<WorldSpawnPoint>();
        public List<WorldPropDefinition> Props=new List<WorldPropDefinition>();
        public List<WorldInteractionDefinition> Interactions=new List<WorldInteractionDefinition>();
    }
    [Serializable] public sealed class WorldPlayerState
    {
        public int ConnectionId;public string AccountId,Name,MapId;public float X,Y,Facing=1;public bool Walking;public uint MapRevision;
        public WorldPlayerState Copy()=>(WorldPlayerState)MemberwiseClone();
    }
    public sealed class WorldCatalog
    {
        public WorldDefinition Data{get;}
        readonly Dictionary<string,WorldMapDefinition> maps;
        public WorldCatalog(WorldDefinition data,CampaignCatalog campaign,Func<string,WorldMapDefinition> loadMap=null)
        {
            if(data!=null && data.MapResources!=null && data.MapResources.Count>0)
            {
                if(loadMap==null)throw new ArgumentException("Island config loader is required.");
                data=new WorldDefinition{SchemaVersion=data.SchemaVersion,ConfigVersion=data.ConfigVersion,MapResources=data.MapResources.ToList(),Maps=data.MapResources.Select(loadMap).ToList()};
            }
            if(data==null || data.SchemaVersion!=1 || string.IsNullOrWhiteSpace(data.ConfigVersion) || data.Maps==null || data.Maps.Count==0)throw new ArgumentException("Invalid world config.");
            // Authoring positions stay local. Every consumer receives one compiled world-space copy.
            data=new WorldDefinition{SchemaVersion=data.SchemaVersion,ConfigVersion=data.ConfigVersion,MapResources=data.MapResources,Maps=data.Maps.Select(WorldCopy).ToList()};
            Data=data;maps=new Dictionary<string,WorldMapDefinition>(StringComparer.Ordinal);
            foreach(var map in data.Maps)
            {
                if(map==null || string.IsNullOrWhiteSpace(map.Id) || maps.ContainsKey(map.Id) || string.IsNullOrWhiteSpace(map.Name) || !Finite(map.MinX,map.MinY,map.MaxX,map.MaxY) || map.MaxX<=map.MinX || map.MaxY<=map.MinY || map.Spawns==null || map.Spawns.Count==0 || map.Props==null || map.Interactions==null)throw new ArgumentException("Invalid world map.");
                maps.Add(map.Id,map);var ids=new HashSet<string>(StringComparer.Ordinal);
                foreach(var spawn in map.Spawns)if(spawn==null || string.IsNullOrWhiteSpace(spawn.Id) || !ids.Add(spawn.Id) || !Inside(map,spawn.X,spawn.Y))throw new ArgumentException("Invalid world spawn: "+map.Id);
                ids.Clear();
                foreach(var prop in map.Props)if(prop==null || string.IsNullOrWhiteSpace(prop.Id) || !ids.Add(prop.Id) || !Inside(map,prop.X,prop.Y) || !Finite(prop.Height,prop.HalfWidth,prop.HalfDepth) || prop.Height<=0 || prop.HalfWidth<0 || prop.HalfDepth<0)throw new ArgumentException("Invalid world prop: "+map.Id);
                foreach(var point in map.Interactions)
                {
                    if(point==null || string.IsNullOrWhiteSpace(point.Id) || !ids.Add(point.Id) || !Inside(map,point.X,point.Y) || !Finite(point.Radius,point.Height,point.HalfWidth,point.HalfDepth) || point.Radius<=0 || point.Height<=0 || point.HalfWidth<0 || point.HalfDepth<0 || !Enum.IsDefined(typeof(WorldInteractionKind),point.Kind))throw new ArgumentException("Invalid world interaction: "+map.Id);
                }
            }
            Spawn("town","entry");
            foreach(var a in data.Maps)foreach(var b in data.Maps)
                if(a!=b && a.MinX<b.MaxX && a.MaxX>b.MinX && a.MinY<b.MaxY && a.MaxY>b.MinY)throw new ArgumentException("Overlapping islands: "+a.Id+" / "+b.Id);
            ValidateCampaignRoutes(campaign);
        }
        void ValidateCampaignRoutes(CampaignCatalog campaign)
        {
            var stageMaps=new Dictionary<string,string>(StringComparer.Ordinal);
            foreach(var chapter in campaign.Data.Chapters)
            {
                if(string.IsNullOrEmpty(chapter.WorldMapId) || !maps.ContainsKey(chapter.WorldMapId))
                    throw new ArgumentException("Campaign chapter has no world map: "+chapter.Id+" / "+chapter.WorldMapId);
                foreach(var stage in chapter.Stages)stageMaps.Add(stage.Id,chapter.WorldMapId);
            }
            var portals=new List<(string From,string To)>();
            var seenStages=new HashSet<string>(StringComparer.Ordinal);
            foreach(var map in Data.Maps)
            foreach(var point in map.Interactions)
            {
                if(point.Kind==WorldInteractionKind.Portal)
                {
                    if(point.TargetId==null || !maps.TryGetValue(point.TargetId,out var destination) ||
                        !destination.Spawns.Any(spawn=>spawn.Id==point.DestinationSpawnId))
                        throw new ArgumentException("Unknown portal destination: "+map.Id+"/"+point.Id+" → "+point.TargetId+"/"+point.DestinationSpawnId);
                    portals.Add((map.Id,point.TargetId));
                }
                else if(point.Kind==WorldInteractionKind.Stage)
                {
                    if(point.TargetId==null || !stageMaps.TryGetValue(point.TargetId,out var expected))
                        throw new ArgumentException("Unknown stage at world entrance: "+map.Id+"/"+point.Id+" → "+point.TargetId);
                    if(expected!=map.Id)throw new ArgumentException("Stage entrance on wrong island: "+point.TargetId+" is on "+map.Id+", expected "+expected);
                    if(!seenStages.Add(point.TargetId))throw new ArgumentException("Duplicate world entrance for stage: "+point.TargetId);
                }
            }
            foreach(var stage in stageMaps)
                if(!seenStages.Contains(stage.Key))throw new ArgumentException("Missing world entrance for stage: "+stage.Value+" / "+stage.Key);
            var fromTown=ReachableFromTown(portals.ToLookup(p=>p.From,p=>p.To,StringComparer.Ordinal));
            var backToTown=ReachableFromTown(portals.ToLookup(p=>p.To,p=>p.From,StringComparer.Ordinal));
            foreach(string mapId in stageMaps.Values.Distinct(StringComparer.Ordinal))
            {
                if(!fromTown.Contains(mapId))throw new ArgumentException("No portal route from Town to campaign island: "+mapId);
                if(!backToTown.Contains(mapId))throw new ArgumentException("No portal return route to Town from campaign island: "+mapId);
            }
        }
        static HashSet<string> ReachableFromTown(ILookup<string,string> portals)
        {
            var seen=new HashSet<string>(StringComparer.Ordinal){"town"};
            var pending=new Queue<string>();pending.Enqueue("town");
            while(pending.Count>0)
                foreach(string destination in portals[pending.Dequeue()])
                    if(seen.Add(destination))pending.Enqueue(destination);
            return seen;
        }
        public WorldMapDefinition Map(string id)=>id!=null && maps.TryGetValue(id,out var map)?map:throw new ArgumentException("Unknown world map: "+id);
        public WorldSpawnPoint Spawn(string map,string id)=>Map(map).Spawns.SingleOrDefault(s=>s.Id==id)??throw new ArgumentException("Unknown world spawn: "+map+"/"+id);
        public WorldInteractionDefinition Interaction(string map,string id)=>Map(map).Interactions.SingleOrDefault(p=>p.Id==id)??throw new ArgumentException("Unknown world interaction.");
        static WorldMapDefinition WorldCopy(WorldMapDefinition m)
        {
            if(m==null || !Finite(m.OriginX,m.OriginY,m.InterestRadius) || m.InterestRadius<=0)throw new ArgumentException("Invalid island origin/interest.");
            return new WorldMapDefinition{Id=m.Id,Name=m.Name,Theme=m.Theme,VisualResource=m.VisualResource,OriginX=m.OriginX,OriginY=m.OriginY,InterestRadius=m.InterestRadius,
                MinX=m.MinX+m.OriginX,MaxX=m.MaxX+m.OriginX,MinY=m.MinY+m.OriginY,MaxY=m.MaxY+m.OriginY,
                Spawns=m.Spawns?.Select(p=>p==null?null:new WorldSpawnPoint{Id=p.Id,X=p.X+m.OriginX,Y=p.Y+m.OriginY}).ToList(),
                Props=m.Props?.Select(p=>p==null?null:new WorldPropDefinition{Id=p.Id,VisualResource=p.VisualResource,X=p.X+m.OriginX,Y=p.Y+m.OriginY,Height=p.Height,HalfWidth=p.HalfWidth,HalfDepth=p.HalfDepth}).ToList(),
                Interactions=m.Interactions?.Select(p=>p==null?null:new WorldInteractionDefinition{Id=p.Id,Label=p.Label,VisualResource=p.VisualResource,TargetId=p.TargetId,DestinationSpawnId=p.DestinationSpawnId,Kind=p.Kind,X=p.X+m.OriginX,Y=p.Y+m.OriginY,Radius=p.Radius,Height=p.Height,HalfWidth=p.HalfWidth,HalfDepth=p.HalfDepth}).ToList()};
        }
        public static bool Finite(params float[] values)=>values.All(v=>!float.IsNaN(v) && !float.IsInfinity(v));
        public static bool Inside(WorldMapDefinition m,float x,float y)=>Finite(x,y) && x>=m.MinX && x<=m.MaxX && y>=m.MinY && y<=m.MaxY;
    }
    public static class WorldInterest
    {
        public static bool Visible(WorldPlayerState observer,WorldPlayerState candidate,float radius)
        {
            if(observer.ConnectionId==candidate.ConnectionId)return true;
            double dx=candidate.X-observer.X,dy=candidate.Y-observer.Y;
            return observer.MapId==candidate.MapId && dx*dx+dy*dy<=radius*radius;
        }
    }
    public static class WorldMovement
    {
        public const float Speed=4.2f,Radius=.28f;
        public static void Move(WorldMapDefinition map,ref float x,ref float y,float inputX,float inputY,float seconds)
        {
            if(!WorldCatalog.Finite(inputX,inputY,seconds) || seconds<=0)return;
            float length=(float)Math.Sqrt(inputX*inputX+inputY*inputY);if(length>1){inputX/=length;inputY/=length;}
            float distance=Speed*Math.Min(seconds,.25f);int steps=Math.Max(1,(int)Math.Ceiling(distance/.15f));
            for(int n=0;n<steps;n++)
            {
                float nx=Math.Clamp(x+inputX*distance/steps,map.MinX+Radius,map.MaxX-Radius);
                if(!Blocked(map,nx,y))x=nx;
                float ny=Math.Clamp(y+inputY*distance/steps,map.MinY+Radius,map.MaxY-Radius);
                if(!Blocked(map,x,ny))y=ny;
            }
        }
        static bool Hit(float x,float y,float px,float py,float hw,float hd)=>hw>0 && hd>0 && Math.Abs(x-px)<hw+Radius && Math.Abs(y-py)<hd+Radius;
        static bool Blocked(WorldMapDefinition m,float x,float y)=>m.Props.Any(p=>Hit(x,y,p.X,p.Y,p.HalfWidth,p.HalfDepth)) || m.Interactions.Any(p=>Hit(x,y,p.X,p.Y,p.HalfWidth,p.HalfDepth));
    }
}
