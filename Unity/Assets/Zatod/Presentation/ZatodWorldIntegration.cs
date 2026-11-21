using System.Linq;
using UnityEngine;
using TMPro;
using UnityEngine.EventSystems;
using Zatod.World;
namespace Zatod.Presentation
{
    public sealed partial class ZatodPrototypeView
    {
        ZatodWorldView world;Transform legacyHeader;
        void BuildWorld()
        {
            // Keep the existing connection/debug controls available before login and in feature menus.
            legacyHeader=new GameObject("ConnectionAndFeatureControls",typeof(RectTransform)).transform;legacyHeader.SetParent(root,false);
            var header=(RectTransform)legacyHeader;header.anchorMin=Vector2.zero;header.anchorMax=Vector2.one;header.offsetMin=header.offsetMax=Vector2.zero;
            foreach(Transform child in root.Cast<Transform>().ToArray())if(child!=legacyHeader && child!=menu && child!=stage && child!=formation.transform && child!=stagePreview.transform && child!=status.transform)child.SetParent(header,false);
            var legacy=new GameObject("DevelopmentLayout",typeof(RectTransform),typeof(ZatodResponsiveLayout)).GetComponent<RectTransform>();legacy.SetParent(root,false);
            header.SetParent(legacy,false);menu.SetParent(legacy,false);status.transform.SetParent(legacy,false);legacy.GetComponent<ZatodResponsiveLayout>().Fit();
            world=gameObject.AddComponent<ZatodWorldView>();world.Initialize(connection,WorldDataJson.Load(campaign),root,Resources.Load<TMP_FontAsset>("Zatod/UI/Formation/ZatodFormationLatin"));
            world.InputLocked=()=>screen!="campaign" || connection.Snapshot==null || stagePreview.gameObject.activeSelf || formation.gameObject.activeSelf || (battleScene?.OccupiesClient??false) || stage.gameObject.activeSelf || (EventSystem.current?.currentSelectedGameObject?.GetComponent<TMP_InputField>()?.isFocused??false);
            world.Interact=point=>
            {
                if(point.Kind==WorldInteractionKind.Portal)connection.WorldTravel(point.Id);
                else if(point.Kind==WorldInteractionKind.Stage)OpenStagePreview(point.TargetId);
                else if(point.TargetId=="clan" || point.TargetId=="tower")world.Hint.text=point.Label+" - Coming soon";
                else if(point.TargetId=="heroes")OpenHeroRoster();else Show(point.TargetId);
            };
            var returnButton=ZatodStageUi.Button(world.Hud,"Features","buttion_big",1370,20,205,58);var rr=(RectTransform)returnButton.transform;rr.anchorMin=rr.anchorMax=rr.pivot=Vector2.one;rr.anchoredPosition=new Vector2(-24,-20);ZatodStageUi.Text(returnButton.transform,"Caption","Menu",10,3,185,48,23,world.MapLabel.font).alignment=TextAlignmentOptions.Center;returnButton.onClick.AddListener(()=>Show("heroes"));
        }
        void RefreshWorldChrome()
        {
            if(world==null)return;bool battling=battleScene?.OccupiesClient??false;bool worldScreen=screen=="campaign" && connection.Snapshot!=null && connection.Connected;
            bool heroes=heroRoster!=null && heroRoster.gameObject.activeSelf || heroDetail!=null && heroDetail.gameObject.activeSelf;
            root.GetComponent<UnityEngine.UI.Image>().color=worldScreen || heroes || battling?Color.clear:Ink;
            root.parent.Find("Backdrop").GetComponent<UnityEngine.UI.Image>().color=worldScreen || heroes || battling?Color.clear:Ink;
            legacyHeader.gameObject.SetActive(!worldScreen && !heroes && !battling);status.gameObject.SetActive(!worldScreen && !heroes && !battling);
            menu.gameObject.SetActive(!worldScreen && !heroes && !battling && !stage.gameObject.activeSelf && !formation.gameObject.activeSelf);
        }
    }
}
