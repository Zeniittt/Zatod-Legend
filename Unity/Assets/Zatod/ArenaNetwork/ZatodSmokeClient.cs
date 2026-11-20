using System;
using System.IO;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
namespace Zatod.Networking
{
    public sealed class ZatodSmokeClient : MonoBehaviour
    {
        ZatodConnection connection;HeroCatalog catalog;string role;string[] heroes;
        int phase;float started;int campaignReplays,arenaReplays;bool queued,grantVerified,grantSent;long pendingRevision;string grantType;
        void Start()
        {
            connection=GetComponent<ZatodConnection>();catalog=HeroDataJson.LoadBundledCatalog();
            role=ZatodConnection.Argument("--zatod-smoke","left");
            started=Time.realtimeSinceStartup;connection.ReplayReceived+=OnReplay;
        }
        void Update()
        {
            try
            {
                if(Time.realtimeSinceStartup-started>240)throw new Exception("Smoke timeout phase="+phase+" status="+connection.Status);
                var snapshot=connection.Snapshot;if(snapshot==null)return;
                if(phase==0)
                {
                    if(snapshot.Cleared.Count!=0)throw new Exception("New application launch restored campaign progress.");
                    if(role=="reset")
                    {
                        var retained=snapshot.Account.HeroDesk.Single(h=>h.HeroDefinitionId=="lina");
                        if(retained.Level!=40 || retained.RankId!="blue" || retained.EquippedItems.Count!=6 || retained.AbsorbedItems.Count!=18)throw new Exception("New launch reset owned Hero/item progress.");
                        new ItemInventory(snapshot.Account,catalog).Validate();Done("fresh-launch-reset owned-hero-and-guids-retained");return;
                    }
                    heroes=snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId).Take(5).ToArray();
                    foreach(string id in heroes)connection.DevLevel(id,40);phase=1;
                }
                if(phase==1 && snapshot.Account.HeroDesk.All(h=>h.Level==40))
                {
                    if(role=="right"){connection.FindPvp(heroes);phase=5;queued=true;}
                    else{phase=10;}
                }
                if(phase==10)
                {
                    if(snapshot.Account.Revision<pendingRevision)return;
                    var hero=snapshot.Account.HeroDesk.Single(h=>h.HeroDefinitionId=="lina");
                    var inventory=new ItemInventory(snapshot.Account,catalog);inventory.Validate();
                    if(!grantSent)
                    {
                        grantType=HeroProgression.CurrentRank(hero,catalog).EquipmentSlots[0].RequiredItemId;grantSent=true;
                        pendingRevision=snapshot.Account.Revision+1;connection.AddItemByItemId(grantType,2);return;
                    }
                    if(!grantVerified)
                    {
                        var instances=snapshot.Account.Inventory.Where(i=>i.ItemId==grantType).ToArray();
                        if(instances.Length!=2 || instances[0].Id==instances[1].Id)throw new Exception("Network dev grant did not create distinct GUID instances.");grantVerified=true;
                    }
                    var rank=HeroProgression.CurrentRank(hero,catalog);var empty=rank.EquipmentSlots.FirstOrDefault(slot=>!hero.EquippedItems.Any(i=>i.SlotId==slot.Id));
                    if(empty!=null)
                    {
                        var owned=snapshot.Account.Inventory.FirstOrDefault(i=>i.ItemId==empty.RequiredItemId);pendingRevision=snapshot.Account.Revision+1;
                        if(owned==null)connection.AddItemByItemId(empty.RequiredItemId);else connection.Equip(hero.HeroInstanceId,empty.Id,owned.Id);return;
                    }
                    if(hero.RankId!="blue"){pendingRevision=snapshot.Account.Revision+1;connection.Promote(hero.HeroInstanceId);return;}
                    connection.Campaign("chapter_one_stage_1",heroes);phase=2;
                }
                if(phase==3 && snapshot.Cleared.Contains("chapter_one_stage_1")){connection.Arena(heroes);phase=4;}
                if(phase==6 && !queued){connection.FindPvp(heroes);queued=true;phase=5;}
                var battle=connection.Battle;
                if(battle!=null && !battle.Finished)
                    foreach(var actor in battle.Frame().Units.Where(u=>u.Team==connection.Team && u.Alive && u.Energy>=u.MaxEnergy))connection.Ultimate(actor.EntityId);
            }
            catch(Exception error){Fail(error);}
        }
        void OnReplay()
        {
            try
            {
                var replay=connection.LastReplay;var repeat=ZatodBattleSimulation.Resimulate(replay);
                if(!replay.Completed || repeat.Digest!=replay.Digest || repeat.Winner!=replay.Winner)throw new Exception("Received replay does not resimulate.");
                if(replay.Initial.Mode==ZatodMode.Campaign)
                {if(replay.Winner!=0 || replay.Stars<1)throw new Exception("Campaign smoke did not win.");campaignReplays++;phase=3;}
                else if(replay.Initial.Mode==ZatodMode.Arena){arenaReplays++;phase=6;}
                else
                {
                    if(replay.Inputs.Count==0)throw new Exception("PvP smoke did not exercise manual inputs.");
                    Done("pvp digest="+replay.Digest+" inputs="+replay.Inputs.Count+" campaign="+campaignReplays+" arena="+arenaReplays);
                }
            }
            catch(Exception error){Fail(error);}
        }
        void Done(string details)
        {
            enabled=false;string line="[ZatodSmoke] PASS role="+role+" "+details;Debug.Log(line);
            var args=Environment.GetCommandLineArgs();int i=Array.IndexOf(args,"--smoke-output");
            if(i>=0 && i+1<args.Length){string path=Path.GetFullPath(args[i+1]);Directory.CreateDirectory(Path.GetDirectoryName(path));File.WriteAllText(path,line);}
            Application.Quit(0);
        }
        void Fail(Exception error){enabled=false;Debug.LogError("[ZatodSmoke] FAIL role="+role+" "+error);Application.Quit(1);}
        void OnDestroy(){if(connection!=null)connection.ReplayReceived-=OnReplay;}
    }
}
