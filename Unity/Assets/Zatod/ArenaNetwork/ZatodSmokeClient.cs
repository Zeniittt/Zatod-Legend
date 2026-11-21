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
        float worldPhaseAt;bool sawWorldPeer,sawWorldMovement,sawWorldIsolation,sawChapterOnePeer;
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
                if(role.StartsWith("interest_",StringComparison.Ordinal)){CheckInterest();return;}
                if(role.StartsWith("world_",StringComparison.Ordinal)){CheckWorld();return;}
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
                if(role.StartsWith("interest_",StringComparison.Ordinal)){CheckInterest();return;}
                if(role.StartsWith("world_",StringComparison.Ordinal))
                {
                    if(replay.Winner!=0 || connection.WorldSelf?.MapId!="chapter_two")throw new Exception("World/private battle return failed.");
                    Done("world peers movement isolation portals chapter1 chapter2 private-battle digest="+replay.Digest);return;
                }
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
        bool interestHidden;uint beforeTravelRevision;
        void CheckInterest()
        {
            var self=connection.WorldSelf;if(self==null)return;bool left=role=="interest_left";float now=Time.realtimeSinceStartup;
            if(phase==0){connection.WorldTravel("campaign");phase=1;worldPhaseAt=now;return;}
            if(phase==1 && self.MapId=="chapter_one")
            {
                if(now-worldPhaseAt<5)
                {
                    connection.SendWorldPose(left?111:171,20,1,false);
                    if(now-worldPhaseAt>2 && connection.WorldPlayers.Length==1)interestHidden=true;
                }
                else
                {
                    connection.SendWorldPose(left?116:118,5,1,false);
                    var other=connection.WorldPlayers.FirstOrDefault(p=>p.ConnectionId!=self.ConnectionId);
                    if(now-worldPhaseAt>7 && other!=null)
                    {
                        if(!interestHidden)throw new Exception("Far player was not excluded by interest management.");
                        if(!left){connection.SendWorldPose(119,5,1,false);phase=3;}
                        else if(Math.Abs(other.X-119)<.01)
                        {beforeTravelRevision=self.MapRevision;connection.WorldTravel("next");connection.SendWorldPose(116,5,1,true);phase=2;}
                    }
                }
            }
            if(phase==3 && connection.WorldPlayers.Length==1)
            {beforeTravelRevision=self.MapRevision;connection.WorldTravel("next");connection.SendWorldPose(119,5,1,true);phase=2;}
            if(phase==2 && self.MapId=="chapter_two")
            {
                if(self.MapRevision!=beforeTravelRevision+1 || Math.Abs(self.X-226)>.01 || Math.Abs(self.Y-5)>.01)
                    throw new Exception("Teleport/stale pose did not preserve new island spawn.");
                Done("interest far-hidden near-restored world-offset stale-pose-rejected");
            }
        }
        void CheckWorld()
        {
            var self=connection.WorldSelf;if(self==null)return;bool left=role=="world_left";float now=Time.realtimeSinceStartup;
            void Next(int value){phase=value;worldPhaseAt=now;}
            if(phase==0)
            {
                if(self.MapId!="town" || connection.Snapshot.Cleared.Count!=0)throw new Exception("New world connection did not start town with personal zero progress.");
                heroes=connection.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId).Take(5).ToArray();foreach(string id in heroes)connection.DevLevel(id,40);Next(1);
            }
            if(phase==1)
            {
                connection.SendWorldPose(left?-2:2,-4+(now-worldPhaseAt)*.5f,1,true);
                var other=connection.WorldPlayers.FirstOrDefault(p=>p.ConnectionId!=self.ConnectionId);
                if(other!=null){sawWorldPeer=true;if(other.Y> -3.7f && Math.Abs(other.X-(left?2:-2))<.1f)sawWorldMovement=true;}
                if(sawWorldPeer && sawWorldMovement && now-worldPhaseAt>3){if(left){connection.WorldTravel("campaign");Next(2);}else if(connection.WorldPlayers.Length==1){sawWorldIsolation=true;connection.WorldTravel("campaign");Next(2);}}
            }
            if(phase==2 && self.MapId=="chapter_one")
            {
                if(connection.WorldPlayers.Length==2){sawChapterOnePeer=true;if(left && now-worldPhaseAt>3){connection.WorldTravel("next");Next(3);}}
                if(!left && sawChapterOnePeer && connection.WorldPlayers.Length==1){sawWorldIsolation=true;connection.WorldTravel("next");Next(3);}
            }
            if(phase==3 && self.MapId=="chapter_two" && connection.WorldPlayers.Length==2)
            {
                if(!left){if(!sawWorldIsolation || !sawChapterOnePeer || connection.Snapshot.Cleared.Count!=0)throw new Exception("Personal progress/map isolation failed.");Done("world peers movement isolation chapter1 chapter2 personal-progress-zero");return;}
                connection.Campaign("chapter_one_stage_1",heroes);Next(4);
            }
            if(phase==4 && connection.Battle!=null && !connection.Battle.Finished)
                foreach(var actor in connection.Battle.Frame().Units.Where(u=>u.Team==connection.Team && u.Alive && u.Energy>=u.MaxEnergy))connection.Ultimate(actor.EntityId);
            if(phase>1 && (!sawWorldPeer || !sawWorldMovement))throw new Exception("World movement was not exercised.");
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
