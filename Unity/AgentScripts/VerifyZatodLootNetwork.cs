using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using Zatod.Networking;
using Zatod.Combat;
using Zatod.Heroes;
public static class VerifyZatodLootNetwork
{
    public static object Run()
    {
        if(!Application.isPlaying)throw new Exception("Enter Play Mode first.");
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(c.Connected)throw new Exception("Disconnect before isolated loot test.");
        string folder=Path.GetFullPath("../Artifacts/ZatodLootChecks/network");Directory.CreateDirectory(folder);
        string profile="loot-check-"+Guid.NewGuid().ToString("N");c.DevelopmentProfile=profile;c.Port=17995;c.GetComponent<Mirror.TelepathyTransport>().port=17995;
        int phase=0,checks=0,attempt=0,initialCount=0,expectedCount=0;string[] heroes=null,plan=null;ZatodReplay record=null;string[] guids=null;
        double start=EditorApplication.timeSinceStartup,at=start;bool finished=false;var flags=System.Reflection.BindingFlags.Instance|System.Reflection.BindingFlags.NonPublic;
        void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        void Next(int p){phase=p;at=EditorApplication.timeSinceStartup;}
        EditorApplication.CallbackFunction tick=null;
        void Finish(string error=null)
        {
            if(finished)return;finished=true;EditorApplication.update-=tick;c.Disconnect();PlayerPrefs.DeleteKey("ZatodPrototype.Account."+profile);PlayerPrefs.Save();
            File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{Result=error==null?"PASS":"FAIL",Error=error,Checks=checks,Attempts=attempt,ExpectedCount=expectedCount,Guids=guids,Phase=phase,Seconds=EditorApplication.timeSinceStartup-start},Newtonsoft.Json.Formatting.Indented));
        }
        tick=()=>
        {
            try
            {
                if(!Application.isPlaying || EditorApplication.timeSinceStartup-start>100)throw new Exception("Loot test timeout/interrupted phase="+phase+" "+c.Status);
                if(phase==0 && c.Snapshot!=null && c.Connected)
                {
                    Check(c.Snapshot.Account.Inventory.Count==0,"Isolated profile not empty");heroes=c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId).Take(5).ToArray();foreach(var id in heroes)c.DevLevel(id,40);Next(1);
                }
                if(phase==1 && c.Snapshot.Account.HeroDesk.All(h=>h.Level==40))
                {initialCount=c.Snapshot.Account.Inventory.Count;c.Campaign("chapter_one_stage_1",heroes);Next(2);}
                if(phase==2 && c.Battle!=null && !c.Battle.Finished)
                {
                    plan=c.PendingCampaignLoot.ToArray();expectedCount=plan.Length;Check(expectedCount>=0&&expectedCount<=5,"Invalid pending count");Check(c.Snapshot.Account.Inventory.Count==initialCount,"Loot granted at entry");
                    while(!c.Battle.Finished){foreach(var u in c.Battle.Frame().Units.Where(u=>u.Team==0&&u.Alive))c.Battle.RequestUltimate(u.EntityId);c.Battle.Step();}
                    record=c.Battle.Replay();Check(record.Winner==0,"Test team lost");c.SubmitCampaign();Next(3);
                }
                if(phase==3 && c.Snapshot.LastCampaignReward?.BattleId==record.Initial.BattleId)
                {
                    var receipt=c.Snapshot.LastCampaignReward;var added=c.Snapshot.Account.Inventory.Skip(initialCount).ToArray();
                    Check(added.Select(i=>i.ItemId).SequenceEqual(plan),"Network grant differs from pending plan");Check(added.Select(i=>i.Id).Distinct().Count()==expectedCount&&added.All(i=>Guid.TryParseExact(i.Id,"D",out _)),"Network item GUID invalid");
                    Check(receipt.Items.Select(i=>i.Id).SequenceEqual(added.Select(i=>i.Id)),"Reward receipt GUID differs from inventory");
                    string owned=Path.Combine(folder,"server","Owned",c.Snapshot.Account.CharacterId+".json");
                    var disk=HeroDataJson.ReadCharacter(File.ReadAllText(owned),HeroDataJson.LoadBundledCatalog());Check(disk.Inventory.Select(i=>i.Id).SequenceEqual(c.Snapshot.Account.Inventory.Select(i=>i.Id)),"Owned save missed awarded items");
                    attempt++;if(expectedCount==0&&attempt<16){Next(1);return;}Check(expectedCount>0,"No nonempty reward after 16 attempts");
                    guids=c.Snapshot.Account.Inventory.Select(i=>i.Id).ToArray();
                    typeof(ZatodConnection).GetField("submitted",flags).SetValue(c,false);c.SubmitCampaign();Next(4);
                }
                if(phase==4 && c.Status.Contains("No issued battle"))
                {
                    Check(c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(guids),"Duplicate network claim changed inventory");
                    c.Request(new ZatodRequest{Command="replay",A=record.Initial.BattleId});Next(5);
                }
                if(phase==5 && c.Status.StartsWith("Validated replay"))
                {
                    Check(c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(guids),"Watching replay granted items");
                    c.Disconnect();Next(6);
                }
                if(phase==6 && !c.Connected && EditorApplication.timeSinceStartup-at>.4){c.Connect();Next(7);}
                if(phase==7 && c.Connected && c.WorldSelf!=null && c.Status.StartsWith("Connected"))
                {Check(c.Snapshot.Account.Inventory.Select(i=>i.Id).SequenceEqual(guids),"Reconnect changed awarded GUIDs");Check(c.Snapshot.LastCampaignReward.BattleId==record.Initial.BattleId,"Reconnect lost settlement receipt");Finish();}
            }
            catch(Exception e){Finish(e.ToString());}
        };
        c.Connect();EditorApplication.update+=tick;return new{Armed=true,Port=17995,Output=folder};
    }
}
