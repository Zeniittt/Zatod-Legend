using System;
using UnityEngine;
using Zatod.World;

namespace Zatod.Networking
{
    // Dedicated-server world geometry. No render assets or presentation components.
    public sealed class ZatodWorldMapRuntime : MonoBehaviour
    {
        [NonSerialized] public WorldMapDefinition Definition;
        public static GameObject Create(WorldCatalog catalog,Transform parent)
        {
            var world=new GameObject("ZatodServerWorld");world.transform.SetParent(parent,false);
            foreach(var map in catalog.Data.Maps)
            {
                var root=new GameObject("ZatodMap_"+map.Id,typeof(ZatodWorldMapRuntime));root.transform.SetParent(world.transform,false);
                root.transform.position=new Vector3(map.OriginX,map.OriginY,0);root.GetComponent<ZatodWorldMapRuntime>().Definition=map;
                var bounds=root.AddComponent<BoxCollider2D>();bounds.isTrigger=true;
                bounds.size=new Vector2(map.MaxX-map.MinX,map.MaxY-map.MinY);
                bounds.offset=new Vector2((map.MinX+map.MaxX)/2-map.OriginX,(map.MinY+map.MaxY)/2-map.OriginY);
                foreach(var p in map.Props)
                {
                    if(p.HalfWidth<=0 || p.HalfDepth<=0)continue;
                    var prop=new GameObject(p.Id,typeof(BoxCollider2D));prop.transform.SetParent(root.transform,false);prop.transform.position=new Vector3(p.X,p.Y,0);
                    prop.GetComponent<BoxCollider2D>().size=new Vector2(p.HalfWidth*2,p.HalfDepth*2);
                }
                foreach(var p in map.Interactions)
                {
                    var point=new GameObject(p.Id,typeof(CircleCollider2D));point.transform.SetParent(root.transform,false);point.transform.position=new Vector3(p.X,p.Y,0);
                    var trigger=point.GetComponent<CircleCollider2D>();trigger.radius=p.Radius;trigger.isTrigger=true;
                    if(p.HalfWidth>0 && p.HalfDepth>0)point.AddComponent<BoxCollider2D>().size=new Vector2(p.HalfWidth*2,p.HalfDepth*2);
                }
            }
            return world;
        }
    }
}
