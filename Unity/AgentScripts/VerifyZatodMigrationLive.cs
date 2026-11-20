using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Newtonsoft.Json.Linq;
using Zatod.Networking;
using Zatod.Heroes;
var path=Directory.GetFiles("../Artifacts/CrystalServer/Owned","*.json").OrderBy(x=>x).First();
var before=JObject.Parse(File.ReadAllText(path));
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();
string profile="migration-verification-"+Guid.NewGuid().ToString("N"),key="ZatodPrototype.Account."+profile;
PlayerPrefs.SetString(key,(string)before["CharacterId"]);c.DevelopmentProfile=profile;c.Connect();
double start=EditorApplication.timeSinceStartup;
EditorApplication.CallbackFunction callback=null;
callback=()=>
{
    if(c.Snapshot==null && EditorApplication.timeSinceStartup-start<30)return;
    EditorApplication.update-=callback;
    string error=null;
    try
    {
        if(c.Snapshot==null)throw new Exception(c.Status);
        foreach(var hero in (JArray)before["HeroDesk"])
        {
            var current=c.Snapshot.Account.HeroDesk.Single(h=>h.HeroInstanceId==(string)hero["HeroInstanceId"]);
            if(current.HeroDefinitionId!=ZatodContentIds.Canonical((string)hero["HeroDefinitionId"]) || current.Level!=(int)hero["Level"] || current.RankId!=(string)hero["RankId"])throw new Exception("Ownership identity/progression changed");
        }
        if(!File.Exists("../Artifacts/ZatodServer/Owned/"+Path.GetFileName(path)+".before-zatod-ids"))throw new Exception("Missing migration backup");
    }
    catch(Exception e){error=e.ToString();}
    var result=new{Result=error==null?"PASS":"FAIL",Error=error,ServerPort=7788,Account=c.Snapshot?.Account.CharacterId,Heroes=c.Snapshot?.Account.HeroDesk.Count,HeroIdentitiesAndProgressionRetained=error==null,MigrationBackupPresent=error==null};
    File.WriteAllText("../Artifacts/ZatodPhaseChecks/owned-migration-live.json",Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
    c.Disconnect();PlayerPrefs.DeleteKey(key);PlayerPrefs.Save();
};
EditorApplication.update+=callback;return new{Started=true,Source=Path.GetFileName(path)};
