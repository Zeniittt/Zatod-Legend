using System;
using TMPro;
using UnityEngine;
using Zatod.Networking;
using static Zatod.Presentation.ZatodHeroUi;
using static Zatod.Presentation.ZatodInventoryView;
namespace Zatod.Presentation
{
    // Replay NPC archive. Arena/PvP share ZatodFormationView with Campaign.
    public sealed class ZatodFeatureView:MonoBehaviour
    {
        public RectTransform Board,Content;
        public TextMeshProUGUI Heading,Status,Selection;
        public UnityEngine.UI.Button Back;
        public UnityEngine.UI.ScrollRect Scroll;
        string signature;
        Action close;
        public static ZatodFeatureView Create(Transform parent,TMP_FontAsset font)
        {
            var root=Box(parent,"ZatodFeatureView");Stretch(root);var v=root.gameObject.AddComponent<ZatodFeatureView>();
            var bg=Pic(root,"Background","bg/herolist_bg",0,0,1600,900,true);Stretch(bg.rectTransform);bg.gameObject.AddComponent<ZatodFullScreenArt>();
            v.Board=Box(root,"FeatureBoard",w:1600,h:900);v.Board.anchorMin=v.Board.anchorMax=v.Board.pivot=new Vector2(.5f,.5f);
            Pic(v.Board,"Panel","common/com_new_2",65,105,1470,745);
            v.Back=NativeButton(v.Board,"Back","",font,50,20,70,70,()=>v.close?.Invoke(),"common/break_butt_bj");Picture(v.Back.transform,"Arrow","break_butt",14,14,42,42,aspect:true);
            v.Heading=Label(v.Board,"Title","Replays",font,150,20,1250,70,38);
            v.Selection=Label(v.Board,"Selection","Battle replays",font,160,120,1280,46,25);
            v.Scroll=ZatodHeroUi.Scroll(v.Board,"ContentScroll",out v.Content);Place((RectTransform)v.Scroll.transform,130,185,1340,540);
            v.Status=Label(v.Board,"Status","Select a battle to watch its replay.",font,125,752,1350,65,23);v.Status.textWrappingMode=TextWrappingModes.Normal;
            root.gameObject.SetActive(false);return v;
        }
        public void OpenReplays(ZatodConnection connection,Action onBack)
        {
            close=onBack;gameObject.SetActive(true);transform.SetAsLastSibling();
            string next=string.Join(",",connection.Snapshot.Replays);if(signature==next)return;signature=next;
            ZatodInventoryView.Clear(Content);int n=0;
            foreach(string replayId in connection.Snapshot.Replays)
            {
                string id=replayId;NativeButton(Content,"Replay_"+id,id,Heading.font,15,n++*88,1300,75,()=>connection.Request(new ZatodRequest{Command="replay",A=id}));
            }
            if(n==0)Label(Content,"Empty","No replays yet.",Heading.font,0,70,1320,80,29);
            Content.sizeDelta=new Vector2(0,Mathf.Max(540,n*88));
        }
        void Update()
        {
            var size=((RectTransform)transform).rect.size;Board.anchoredPosition=Vector2.zero;Board.localScale=Vector3.one*Mathf.Min(size.x/1600,size.y/900);
        }
    }
}
