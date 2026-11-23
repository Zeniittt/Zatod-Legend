using System;
using UnityEngine;
using System.Net;
using System.Net.Sockets;
using Mirror;
using Zatod.Heroes;
namespace Zatod.Networking
{
    public sealed partial class ZatodConnection
    {
        ZatodLanDiscovery lanDiscovery;
        string requestedName,lanCatalogVersion;
        public bool FindingPvp{get;private set;}
        double loginDeadline;
        bool lookingForServer;
        bool lookingForAddress;
        double addressLookupDeadline;
        public bool LoginBusy{get;private set;}
        public bool LanReady=>lanDiscovery!=null;
        public bool CanDiscoverLan
        {
            get
            {
#if UNITY_IOS && !UNITY_EDITOR
                return false;
#else
                return true;
#endif
            }
        }
        string ServerPreference=>"ZatodPrototype.Server."+Argument("--zatod-profile",Argument("--zatod-smoke",DevelopmentProfile));
        public string SavedServerAddress=>HasArgument("--server")?Address:PlayerPrefs.GetString(ServerPreference,"");
        public string SuggestedServerAddress{get;private set;}="";
        public string CatalogVersion=>catalog?.Data.ConfigVersion??(lanCatalogVersion??=HeroDataJson.LoadBundledCatalog().Data.ConfigVersion);
        string NamePreference=>"ZatodPrototype.Name."+Argument("--zatod-profile",Argument("--zatod-smoke",DevelopmentProfile));
        public string SavedDisplayName=>PlayerPrefs.GetString(NamePreference,"");
        void InitializeLan()
        {
            lanDiscovery=gameObject.AddComponent<ZatodLanDiscovery>();lanDiscovery.Initialize(this);
            if(IsServer)lanDiscovery.Advertise();
        }
        public void FindServerAddress()
        {
            if(!LanReady||!CanDiscoverLan||IsServer||LoginBusy||NetworkClient.active||lookingForAddress)return;
            try{SuggestedServerAddress="";lookingForAddress=true;addressLookupDeadline=Time.realtimeSinceStartupAsDouble+5;lanDiscovery.StartDiscovery();}
            catch(Exception e){StopAddressLookup();SetStatus("LAN search unavailable. Enter the PC server IP. "+e.Message);}
        }
        public void StopAddressLookup(){lookingForAddress=false;if(!lookingForServer)lanDiscovery?.StopDiscovery();}
        public static bool TryServerAddress(string value,out string address)
        {
            address="";
            if(!IPAddress.TryParse((value??"").Trim(),out var parsed)||parsed.AddressFamily!=AddressFamily.InterNetwork)return false;
            byte first=parsed.GetAddressBytes()[0];
            if(first==0||first>=224)return false;
            address=parsed.ToString();return true;
        }
        public void JoinLan(string name)=>JoinLan(name,"");
        public void JoinLan(string name,string serverIp)
        {
            if(LoginBusy||NetworkClient.active||IsServer)return;
            try
            {
                requestedName=GuestIdentity.Name(name);
                string entered=(serverIp??"").Trim();
                if(entered.Length>0)
                {
                    if(!TryServerAddress(entered,out var host))throw new ArgumentException("Enter a valid server IPv4 address, for example 192.168.1.23.");
                    Address=host;
                }
                else if(!CanDiscoverLan&&!HasArgument("--server"))throw new ArgumentException("Enter the PC server IP. iOS connects directly without LAN discovery.");
                StopAddressLookup();LoginBusy=true;loginDeadline=Time.realtimeSinceStartupAsDouble+15;
                if(entered.Length>0){Connect();return;}
                if(HasArgument("--server")){Connect();return;}
                lookingForServer=true;SetStatus("Looking for the Zatod server on this LAN...");lanDiscovery.StartDiscovery();
            }
            catch(Exception e){StopLogin();SetStatus(e.Message);}
        }
        public void AcceptLanServer(string host,ushort port)
        {
            if(port==0||NetworkClient.active||!CanDiscoverLan)return;
            if(lookingForAddress&&!LoginBusy)
            {
                SuggestedServerAddress=host;Port=port;GetComponent<TelepathyTransport>().port=port;StopAddressLookup();Changed?.Invoke();return;
            }
            if(!lookingForServer||!LoginBusy)return;
            lookingForServer=false;lanDiscovery.StopDiscovery();Address=host;Port=port;GetComponent<TelepathyTransport>().port=port;Connect();
        }
        void StopLogin(){lookingForServer=false;lookingForAddress=false;LoginBusy=false;lanDiscovery?.StopDiscovery();}
        void FinishLogin()
        {
            if(!string.IsNullOrEmpty(requestedName)){PlayerPrefs.SetString(NamePreference,Snapshot.Account.Name);PlayerPrefs.Save();}
            if(TryServerAddress(Address,out var host)){PlayerPrefs.SetString(ServerPreference,host);PlayerPrefs.Save();}
            StopLogin();
        }
        void UpdateGuestLogin()
        {
            if(lookingForAddress&&Time.realtimeSinceStartupAsDouble>=addressLookupDeadline)StopAddressLookup();
            if(!LoginBusy||Time.realtimeSinceStartupAsDouble<loginDeadline)return;
            bool missing=lookingForServer;StopLogin();if(NetworkClient.active)NetworkClient.Disconnect();
            SetStatus(missing?"No Zatod server found. Check that the PC server is running and devices share a LAN.":"The server did not respond. Check your connection and try again.");
        }
    }
}
