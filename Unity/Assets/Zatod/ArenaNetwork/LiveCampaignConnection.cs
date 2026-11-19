using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using Mirror;
using UnityEngine;
using Zatod.Combat;

namespace Zatod.Networking
{
    public sealed partial class ArenaConnection
    {
        sealed class LiveCampaign
        {
            public string Id;
            public NetworkConnectionToClient Connection;
            public BattleSimulation Simulation;
            public readonly HashSet<string> Requests=new HashSet<string>(StringComparer.Ordinal);
        }
        readonly Dictionary<int,LiveCampaign> liveCampaigns=new Dictionary<int,LiveCampaign>();
        public string LiveBattleId { get; private set; }
        public bool LiveBattleActive => LiveBattleId!=null;
        public event Action<BattleRecord> LiveFrameReceived;
        public event Action<BattleRecord> LiveBattleFinished;
        public event Action<UltimateResponse> UltimateResponded;

        public string RequestUltimate(int fighterId,string requestId=null)
        {
            if(!Connected || !LiveBattleActive)return null;
            string id=requestId??Guid.NewGuid().ToString("N");
            NetworkClient.Send(new UltimateRequest{battleId=LiveBattleId,requestId=id,fighterId=fighterId});return id;
        }

        void OnUltimateRequest(NetworkConnectionToClient conn,UltimateRequest request)
        {
            bool accepted=false;string reason="Lệnh Ultimate không hợp lệ.";
            if(liveCampaigns.TryGetValue(conn.connectionId,out var battle) && ReferenceEquals(battle.Connection,conn) && battle.Id==request.battleId)
            {
                if(Guid.TryParseExact(request.requestId,"N",out _) && battle.Requests.Count<256 && battle.Requests.Add(request.requestId))
                {
                    accepted=battle.Simulation.RequestUltimate(request.fighterId);
                    reason=accepted?"Ultimate đã được chọn.":"Chưa thể dùng Ultimate lúc này.";
                }
            }
            conn.Send(new UltimateResponse{requestId=request.requestId,fighterId=request.fighterId,accepted=accepted,reason=reason});
        }

        IEnumerator RunLiveCampaign(NetworkConnectionToClient conn,string id,CampaignBattleSetup setup)
        {
            uint seed;using(var rng=RandomNumberGenerator.Create()){var bytes=new byte[4];rng.GetBytes(bytes);seed=BitConverter.ToUInt32(bytes,0);}
            var simulation=new BattleSimulation(id,"campaign:"+setup.StageId,seed,setup.Fighters,setup.Loadouts,manualUltimateTeams:1);
            var record=simulation.CurrentRecord;record.campaignStageId=setup.StageId;record.campaignConfigVersion=setup.ConfigVersion;record.createdUtc=DateTime.UtcNow.ToString("O");
            liveCampaigns.Add(conn.connectionId,new LiveCampaign{Id=id,Connection=conn,Simulation=simulation});
            double next=Time.realtimeSinceStartupAsDouble;int sentTick=-2;bool failed=false;var cursor=new LiveBattleCursor();
            try
            {
                while(!simulation.Finished)
                {
                    if(Time.realtimeSinceStartupAsDouble<next){yield return null;continue;}
                    try
                    {
                        // Fixed 20 Hz authority. Presentation and client frame rate never step combat.
                        int catchup=0;
                        while(!simulation.Finished && Time.realtimeSinceStartupAsDouble>=next && catchup++<4)
                        {simulation.Step();next+=1d/BattleSimulation.TickRate;}
                        if(!simulation.Finished && simulation.CurrentTick-sentTick>=2 && StillConnected(conn))
                        {
                            SendReplay(conn,id,LiveBattleCodec.Encode(record,cursor),live:true);sentTick=simulation.CurrentTick;
                        }
                    }
                    catch(Exception e){Debug.LogException(e);if(StillConnected(conn))Fail(conn,e);failed=true;break;}
                    yield return null;
                }
                if(failed)yield break;
                try
                {
                    byte[] bytes=ReplayArchive.Encode(record);repository.Save(id,bytes);
                    campaignState.AcceptCommitted(record);
                    Debug.Log("[ArenaServer] COMMITTED live="+id+" winner="+record.winner+" ticks="+record.durationTicks+" bytes="+bytes.Length);
                    if(StillConnected(conn)){SendReplay(conn,id,bytes);SendCatalog(conn);}
                }
                catch(Exception e){Debug.LogException(e);if(StillConnected(conn))Fail(conn,e);}
            }
            finally{liveCampaigns.Remove(conn.connectionId);inFlight.Remove(id);}
        }
    }
}
