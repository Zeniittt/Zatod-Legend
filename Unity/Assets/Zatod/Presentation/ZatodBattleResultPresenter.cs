using UnityEngine;
using Zatod.Combat;

namespace Zatod.Presentation
{
    public sealed partial class ZatodPrototypeView
    {
        ZatodBattleResultView battleResult;
        float battleFinishedAt=-1;
        ZatodBattleSimulation resultSimulation;
        void BuildBattleResultView()
        {
            var prefab=Resources.Load<GameObject>("Zatod/UI/BattleResult/ZatodBattleResultView");
            battleResult=prefab==null?ZatodBattleResultView.Create(root,Font):Instantiate(prefab,root,false).GetComponent<ZatodBattleResultView>();
            battleResult.gameObject.SetActive(false);
        }
        void ClearBattleResult()
        {battleResult?.Hide();resultSimulation=null;battleFinishedAt=-1;}
        void DrawBattleResult(ZatodFrame frame,ZatodBattleSimulation simulation,double interpolation)
        {
            var world=battleScene.Stage;var loot=world.GetComponent<ZatodBattleLootView>();if(loot==null)loot=world.gameObject.AddComponent<ZatodBattleLootView>();
            loot.Draw(simulation,interpolation,world.BattleCamera,hud.ChestValue.rectTransform,replay==null||playing);
            hud.ChestValue.text=loot.Collected.ToString();hud.GoldValue.text=(connection.Snapshot?.LastCampaignReward?.BattleId==simulation.BattleId?connection.Snapshot.LastCampaignReward.Economy?.Gold??0:0).ToString("N0");
            if(resultSimulation!=simulation){if(battleResult.BattleId!=simulation.BattleId)battleResult.Hide();resultSimulation=simulation;battleFinishedAt=-1;}
            bool campaignWin=simulation.Mode==ZatodMode.Campaign && frame.Finished && frame.Winner==0;
            if(!campaignWin)return;
            hud.ResultPanel.SetActive(false);
            if(battleFinishedAt<0)battleFinishedAt=Time.unscaledTime;
            if(battleResult.gameObject.activeSelf || Time.unscaledTime-battleFinishedAt<.8f || !loot.Complete)return;
            if(replay!=null)
            {battleResult.Open(simulation.Replay(),null,catalog,connection.Snapshot.Account,()=>Show("campaign"));return;}
            var receipt=connection.Snapshot?.LastCampaignReward;var record=connection.LastReplay;
            if(receipt?.BattleId==simulation.BattleId && record?.Initial.BattleId==simulation.BattleId)
                battleResult.Open(record,receipt,catalog,connection.Snapshot.Account,()=>Show("campaign"));
        }
    }
}
