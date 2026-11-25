using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using TMPro;
using Zatod.Heroes;
namespace Zatod.Presentation
{
    public sealed partial class ZatodPrototypeView
    {
        ZatodLoginView loginView;
        ZatodFeatureView featureView;
        readonly List<string> freePvpSelection=new List<string>();
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
            var rosterIds=connection.Snapshot.FreePvpHeroIds;
            bool freePvp=mode=="pvp" && rosterIds?.Count>0;
            string blocked=freePvp?connection.FreePvpBlockReason:null;
            HeroData[] roster=null;
            if(freePvp)roster=blocked==null?rosterIds.Select(catalog.FreePvp.CreatePreset).ToArray():Array.Empty<HeroData>();
            var draft=freePvp?freePvpSelection:selected;
            if(blocked!=null)draft=new List<string>();
            formation.OpenTeam(mode,catalog,connection.Snapshot.Account,draft,()=>
            {
                if(connection.FindingPvp)connection.Cancel();
                Show("campaign");
            },team=>
            {
                if(mode=="arena")connection.Arena(team);else connection.FindPvp(team);
            },roster,blocked);
            RefreshWorldChrome();
        }
    }
}
