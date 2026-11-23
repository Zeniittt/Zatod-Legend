using System;
using System.Net;
using Mirror;
using Mirror.Discovery;
using UnityEngine;
namespace Zatod.Networking
{
    public struct ZatodDiscoveryRequest:NetworkMessage {public int Protocol;}
    public struct ZatodDiscoveryResponse:NetworkMessage {public int Protocol;public ushort Port;public string CatalogVersion;}
    public sealed class ZatodLanDiscovery:NetworkDiscoveryBase<ZatodDiscoveryRequest,ZatodDiscoveryResponse>
    {
        public const int ProtocolVersion=1;
        ZatodConnection owner;
        public override void Start(){} // Headless smoke clients must not advertise as servers.
        public void Initialize(ZatodConnection connection)
        {
            owner=connection;transport=connection.GetComponent<TelepathyTransport>();
            secretHandshake=0x5A41544F444C414EL;
            if(int.TryParse(ZatodConnection.Argument("--zatod-discovery-port","47777"),out var port)&&port>0&&port<=65535)serverBroadcastListenPort=port;
        }
        public void Advertise()
        {
            try{AdvertiseServer();}
            catch(Exception e){Debug.LogWarning("[ZatodLAN] Could not advertise server: "+e.Message);}
        }
        protected override ZatodDiscoveryRequest GetRequest()=>new ZatodDiscoveryRequest{Protocol=ProtocolVersion};
        protected override ZatodDiscoveryResponse ProcessRequest(ZatodDiscoveryRequest request,IPEndPoint endpoint)
            =>new ZatodDiscoveryResponse{Protocol=request.Protocol==ProtocolVersion&&NetworkServer.active?ProtocolVersion:0,Port=owner.Port,CatalogVersion=owner.CatalogVersion};
        protected override void ProcessResponse(ZatodDiscoveryResponse response,IPEndPoint endpoint)
        {
            if(response.Protocol!=ProtocolVersion||response.CatalogVersion!=owner.CatalogVersion)return;
            owner.AcceptLanServer(endpoint.Address.ToString(),response.Port);
        }
    }
}
