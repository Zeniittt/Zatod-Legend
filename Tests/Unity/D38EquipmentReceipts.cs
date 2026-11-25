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
public static class D38EquipmentReceipts
{
    const BindingFlags Private=BindingFlags.Instance|BindingFlags.NonPublic;
    static object Call(object value,string name,params object[] args)=>value.GetType().GetMethod(name,Private).Invoke(value,args);
    static T Field<T>(object value,string name)=>(T)value.GetType().GetField(name,Private).GetValue(value);
    public static string Arm(string output)
    {
        if(!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/") || NetworkServer.active || NetworkClient.active)throw new InvalidOperationException("Use the disconnected isolated Editor");
        Directory.CreateDirectory(output);string report=Path.Combine(output,"equipment.json");File.WriteAllText(report,"{\"State\":\"RUNNING\"}");Run(output,report);return report;
    }
    static async void Run(string output,string report)
    {
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var view=c.GetComponent<ZatodPrototypeView>();var transport=c.GetComponent<TelepathyTransport>();var window=Field<ZatodEquipmentView>(view,"equipmentWindow");
        var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(catalog);var profile="d38-equipment-"+Guid.NewGuid().ToString("N");var account=Guid.NewGuid().ToString("D");var directory=Path.Combine(output,"Server");Directory.CreateDirectory(directory);
        string oldProfile=c.DevelopmentProfile;ushort oldPort=c.Port,oldTransport=transport.port;EditorApplication.CallbackFunction pump=null;int checks=0;string phase="startup";
        void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
        async Task Until(Func<bool> predicate,string why){double end=EditorApplication.timeSinceStartup+12;while(!predicate()){if(EditorApplication.timeSinceStartup>end)throw new TimeoutException(why+" / "+c.Status);await Task.Delay(30);}}
        try
        {
            Field<Dictionary<string,ZatodPlayerSession>>(c,"launches").Clear();Field<Dictionary<int,ZatodPlayerSession>>(c,"sessions").Clear();
            var previous=Field<GameObject>(c,"serverWorldRoot");if(previous!=null)UnityEngine.Object.Destroy(previous);
            c.DevelopmentProfile=profile;c.Port=transport.port=17939;PlayerPrefs.SetString("ZatodPrototype.Account."+profile,account);Call(c,"StartServer");typeof(ZatodConnection).GetField("archiveDirectory",Private).SetValue(c,directory);
            pump=()=>{if(NetworkServer.active){Call(c,"UpdateWorldServer");Call(c,"UpdateEconomyServer");}};EditorApplication.update+=pump;
            c.JoinLan("D38 equipment fixture","127.0.0.1");await Until(()=>c.Snapshot?.Account.CharacterId==account && c.WorldSelf!=null,"Fixture login");
            var session=Field<Dictionary<int,ZatodPlayerSession>>(c,"sessions").Values.Single();foreach(var member in session.Account.HeroDesk)member.Level=2;
            Call(c,"SendAccount",NetworkServer.connections[c.WorldSelf.ConnectionId],session,false);await Until(()=>c.Snapshot.Account.HeroDesk[1].Level==2,"Fixture hero level sync");var hero=session.Account.HeroDesk[1];var slot=HeroProgression.CurrentRank(hero,catalog).EquipmentSlots.First(s=>catalog.Item(s.RequiredItemId).LevelRequirement<=hero.Level);var other=session.Account.HeroDesk[2];var otherSlot=HeroProgression.CurrentRank(other,catalog).EquipmentSlots.First(s=>s.RequiredItemId==slot.RequiredItemId);
            c.AddItemByItemId(slot.RequiredItemId,2);await Until(()=>c.Snapshot.Account.Inventory.Count(i=>i.ItemId==slot.RequiredItemId)==2,"Fixture grant");
            phase="double click and late reply";
            window.Open(catalog,c.Snapshot.Account,c,campaign,hero.HeroInstanceId,slot.Id);window.ActionButton.onClick.Invoke();string op=c.PendingItemOperationId;window.ActionButton.onClick.Invoke();
            window.Hide();window.Open(catalog,c.Snapshot.Account,c,campaign,other.HeroInstanceId,otherSlot.Id);
            await Until(()=>c.Snapshot.Account.ItemOperations.Any(r=>r.OperationId==op),"Late Equip receipt");
            Check(window.gameObject.activeSelf,"Late reply cannot close another Hero's panel");var receipt=c.Snapshot.Account.ItemOperations.Single(r=>r.OperationId==op);
            Check(c.Snapshot.Account.HeroDesk.Single(h=>h.HeroInstanceId==hero.HeroInstanceId).EquippedItems.Single(i=>i.SlotId==slot.Id).Id==receipt.ItemInstanceId,"Receipt preserves item GUID");
            Check(c.Snapshot.Account.ItemOperations.Count(r=>r.Command=="equip")==1,"Double click commits once");
            long revision=c.Snapshot.Account.Revision;c.Request(new ZatodRequest{Command="equip",A=hero.HeroInstanceId,B=slot.Id,C=receipt.ItemInstanceId,OperationId=op});await Task.Delay(180);
            Check(c.Snapshot.Account.Revision==revision && c.Snapshot.Account.ItemOperations.Count(r=>r.OperationId==op)==1,"Repeated receipt is idempotent");Check(window.gameObject.activeSelf,"Duplicate receipt leaves new popup open");
            phase="stale GUID failure";
            var stale=c.Snapshot.Account.Inventory.Single(i=>i.ItemId==slot.RequiredItemId);var third=session.Account.HeroDesk[3];var thirdSlot=HeroProgression.CurrentRank(third,catalog).EquipmentSlots.First(s=>s.RequiredItemId==slot.RequiredItemId);
            session.EquipItem(third.HeroInstanceId,thirdSlot.Id,stale.Id,Guid.NewGuid().ToString("D"),()=>Call(c,"SaveOwned",session));
            long serverBefore=session.Account.Revision;window.ActionButton.onClick.Invoke();await Until(()=>c.Status.StartsWith("Error:") && !c.ItemOperationBusy,"Stale item rejection");Check(window.gameObject.activeSelf && session.Account.Revision==serverBefore,"Failure keeps panel and Owned unchanged");
            phase="persist rollback";
            c.AddItemByItemId(slot.RequiredItemId);await Until(()=>c.Snapshot.Account.Inventory.Any(i=>i.ItemId==slot.RequiredItemId),"Rollback fixture item");window.Open(catalog,c.Snapshot.Account,c,campaign,other.HeroInstanceId,otherSlot.Id);
            var inventory=session.Account.Inventory.Select(i=>i.Id).OrderBy(x=>x).ToArray();serverBefore=session.Account.Revision;
            string fail=Path.Combine(output,"PersistFail");Directory.CreateDirectory(fail);File.WriteAllText(Path.Combine(fail,"Owned"),"Intentional fixture persistence failure");typeof(ZatodConnection).GetField("archiveDirectory",Private).SetValue(c,fail);
            window.ActionButton.onClick.Invoke();await Until(()=>c.Status.StartsWith("Error:") && !c.ItemOperationBusy,"Persist failure reply");typeof(ZatodConnection).GetField("archiveDirectory",Private).SetValue(c,directory);
            Check(window.gameObject.activeSelf && session.Account.Revision==serverBefore && inventory.SequenceEqual(session.Account.Inventory.Select(i=>i.Id).OrderBy(x=>x)),"Persist failure rolls back GUID/revision");Check(!other.EquippedItems.Any(i=>i.SlotId==otherSlot.Id),"Persist failure rolls back slot");
            phase="disconnect and retry";
            window.ActionButton.onClick.Invoke();string reconnectOp=c.PendingItemOperationId;c.Disconnect();await Until(()=>!c.Connected,"Disconnect fixture");c.JoinLan("D38 equipment fixture","127.0.0.1");
            await Until(()=>c.Connected && c.Snapshot?.Account.ItemOperations.Any(r=>r.OperationId==reconnectOp)==true && !c.ItemOperationBusy,"Retry across reconnect");
            Check(c.Snapshot.Account.ItemOperations.Count(r=>r.OperationId==reconnectOp)==1,"Reconnect does not duplicate Equip");
            window.Open(catalog,c.Snapshot.Account,c,campaign,other.HeroInstanceId,otherSlot.Id);window.Refresh(c.Snapshot.Account);Check(window.gameObject.activeSelf,"Reopening equipped item remains explicit");window.Hide();
            window.OpenItem(catalog,c.Snapshot.Account,c,campaign,slot.RequiredItemId);window.Refresh(c.Snapshot.Account);Check(window.gameObject.activeSelf && window.RecipeVisible,"Craft/read-only flow stays open");window.Hide();
            File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="PASS",Checks=checks,DoubleClick=true,LateReply=true,DuplicateReceipt=true,StaleGuid=true,PersistRollback=true,Reconnect=true,ReadOnly=true},Newtonsoft.Json.Formatting.Indented));
        }
        catch(Exception e){File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Phase=phase,Checks=checks,Error=e.ToString()},Newtonsoft.Json.Formatting.Indented));}
        finally{typeof(ZatodConnection).GetField("archiveDirectory",Private).SetValue(c,directory);window.Hide();if(pump!=null)EditorApplication.update-=pump;c.Disconnect();if(NetworkServer.active)NetworkServer.Shutdown();c.DevelopmentProfile=oldProfile;c.Port=oldPort;transport.port=oldTransport;foreach(var part in new[]{"Account","Name","Server"})PlayerPrefs.DeleteKey("ZatodPrototype."+part+"."+profile);PlayerPrefs.Save();}
    }
}
