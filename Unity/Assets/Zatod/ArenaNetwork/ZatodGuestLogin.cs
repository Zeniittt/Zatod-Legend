using System;
using UnityEngine;
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
        public bool LoginBusy{get;private set;}
        public string CatalogVersion=>catalog?.Data.ConfigVersion??(lanCatalogVersion??=HeroDataJson.LoadBundledCatalog().Data.ConfigVersion);
        string NamePreference=>"ZatodPrototype.Name."+Argument("--zatod-profile",Argument("--zatod-smoke",DevelopmentProfile));
        public string SavedDisplayName=>PlayerPrefs.GetString(NamePreference,"");
        void InitializeLan()
        {
            lanDiscovery=gameObject.AddComponent<ZatodLanDiscovery>();lanDiscovery.Initialize(this);
            if(IsServer)lanDiscovery.Advertise();
        }
        public void JoinLan(string name)
        {
            if(LoginBusy||NetworkClient.active||IsServer)return;
            try
            {
                requestedName=GuestIdentity.Name(name);LoginBusy=true;loginDeadline=Time.realtimeSinceStartupAsDouble+15;
                if(HasArgument("--server")){Connect();return;}
                lookingForServer=true;SetStatus("Looking for the Zatod server on this LAN...");lanDiscovery.StartDiscovery();
            }
            catch(Exception e){StopLogin();SetStatus(e.Message);}
        }
        public void AcceptLanServer(string host,ushort port)
        {
            if(!lookingForServer||!LoginBusy||NetworkClient.active||port==0)return;
            lookingForServer=false;lanDiscovery.StopDiscovery();Address=host;Port=port;GetComponent<TelepathyTransport>().port=port;Connect();
        }
        void StopLogin(){lookingForServer=false;LoginBusy=false;lanDiscovery?.StopDiscovery();}
        void FinishLogin()
        {
            if(!string.IsNullOrEmpty(requestedName)){PlayerPrefs.SetString(NamePreference,Snapshot.Account.Name);PlayerPrefs.Save();}
            StopLogin();
        }
        void UpdateGuestLogin()
        {
            if(!LoginBusy||Time.realtimeSinceStartupAsDouble<loginDeadline)return;
            bool missing=lookingForServer;StopLogin();if(NetworkClient.active)NetworkClient.Disconnect();
            SetStatus(missing?"No Zatod server found. Check that the PC server is running and devices share a LAN.":"The server did not respond. Check your connection and try again.");
        }
    }
}
