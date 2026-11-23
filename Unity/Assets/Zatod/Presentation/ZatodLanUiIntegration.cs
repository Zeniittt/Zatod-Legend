using UnityEngine;
using TMPro;
namespace Zatod.Presentation
{
    public sealed partial class ZatodPrototypeView
    {
        ZatodLoginView loginView;
        ZatodFeatureView featureView;
        void BuildLanViews()
        {
            var font=Resources.Load<TMP_FontAsset>("Zatod/UI/Inventory/Fonts/InventoryRegular")??Font;
            loginView=ZatodLoginView.Create(root,font,connection);
            featureView=ZatodFeatureView.Create(root,font);
        }
        void OpenNpcFeature()
        {
            if(featureView==null||connection.Snapshot==null||!connection.Connected)return;
            if(screen=="history")
            {featureView.OpenReplays(connection,()=>Show("campaign"));return;}
            if(formation.gameObject.activeSelf&&formation.SelectionMode==screen){formation.RefreshAccount(connection.Snapshot.Account,connection.Connected,connection.Status,connection.FindingPvp);return;}
            string mode=screen;
            formation.OpenTeam(mode,catalog,connection.Snapshot.Account,selected,()=>
            {
                if(connection.FindingPvp)connection.Cancel();
                Show("campaign");
            },team=>
            {
                if(mode=="arena")connection.Arena(team);else connection.FindPvp(team);
            });
            RefreshWorldChrome();
        }
    }
}
