using System;
using TMPro;
using UnityEngine;
using Zatod.Networking;
using static Zatod.Presentation.ZatodHeroUi;
using static Zatod.Presentation.ZatodInventoryView;
namespace Zatod.Presentation
{
    public sealed class ZatodLoginView:MonoBehaviour
    {
        public RectTransform Board;
        public TMP_InputField PlayerName;
        public TextMeshProUGUI Message;
        public UnityEngine.UI.Button ConnectButton;
        ZatodConnection client;
        public static ZatodLoginView Create(Transform parent,TMP_FontAsset font,ZatodConnection client)
        {
            var root=Box(parent,"ZatodLoginView");Stretch(root);var v=root.gameObject.AddComponent<ZatodLoginView>();v.client=client;
            var background=Pic(root,"Background","bg/herolist_bg",0,0,1600,900,true);Stretch(background.rectTransform);background.gameObject.AddComponent<ZatodFullScreenArt>();
            v.Board=Box(root,"LoginBoard",w:850,h:620);v.Board.anchorMin=v.Board.anchorMax=v.Board.pivot=new Vector2(.5f,.5f);
            Pic(v.Board,"Panel","common/com_new_2",0,0,850,620);
            var title=Label(v.Board,"Title","ZATOD LEGEND",font,55,55,740,75,46);title.fontStyle=FontStyles.Bold;
            Label(v.Board,"NameLabel","Your name",font,115,170,620,50,29);
            var field=Pic(v.Board,"NameField","package/bg_number",115,235,620,80,true);
            v.PlayerName=field.gameObject.AddComponent<TMP_InputField>();v.PlayerName.targetGraphic=field;
            var viewport=Box(field.transform,"Viewport");Stretch(viewport,15);viewport.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            var text=ZatodHeroUi.Text(viewport,"Text","",font,32);Stretch(text.rectTransform);text.alignment=TextAlignmentOptions.MidlineLeft;text.richText=false;text.color=new Color(.22f,.18f,.13f);text.outlineWidth=0;
            var hint=ZatodHeroUi.Text(viewport,"Placeholder","Enter your name",font,30);Stretch(hint.rectTransform);hint.color=new Color(.4f,.35f,.3f,.75f);hint.outlineWidth=0;
            v.PlayerName.textViewport=viewport;v.PlayerName.textComponent=text;v.PlayerName.placeholder=hint;v.PlayerName.characterLimit=24;v.PlayerName.lineType=TMP_InputField.LineType.SingleLine;v.PlayerName.text=client.SavedDisplayName;
            v.ConnectButton=NativeButton(v.Board,"Connect","Connect",font,235,355,380,85,()=>client.JoinLan(v.PlayerName.text));
            v.PlayerName.onSubmit.AddListener(_=>{if(v.ConnectButton.interactable)client.JoinLan(v.PlayerName.text);});
            v.Message=Label(v.Board,"Status","",font,65,475,720,95,24);v.Message.textWrappingMode=TextWrappingModes.Normal;
            return v;
        }
        public void Refresh()
        {
            ConnectButton.interactable=!client.LoginBusy&&!string.IsNullOrWhiteSpace(PlayerName.text);
            PlayerName.interactable=!client.LoginBusy;
            Message.text=client.Status=="Connect to a Zatod server."?"Enter a name to join the shared town.":client.Status.StartsWith("Disconnected.")?"Disconnected. Tap Connect to join again.":client.Status;
        }
        void Update()
        {
            var size=((RectTransform)transform).rect.size;Board.anchoredPosition=Vector2.zero;Board.localScale=Vector3.one*Mathf.Min(size.x/1050,size.y/760);Refresh();
        }
    }
}
