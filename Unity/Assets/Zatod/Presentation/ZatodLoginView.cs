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
        public TMP_InputField PlayerName,ServerIp;
        public TextMeshProUGUI Message;
        public UnityEngine.UI.Button ConnectButton;
        ZatodConnection client;
        bool lookupStarted,addressEdited;
        public static ZatodLoginView Create(Transform parent,TMP_FontAsset font,ZatodConnection client)
        {
            var root=Box(parent,"ZatodLoginView");Stretch(root);var v=root.gameObject.AddComponent<ZatodLoginView>();v.client=client;
            var background=Pic(root,"Background","bg/herolist_bg",0,0,1600,900,true);Stretch(background.rectTransform);background.gameObject.AddComponent<ZatodFullScreenArt>();
            v.Board=Box(root,"LoginBoard",w:850,h:740);v.Board.anchorMin=v.Board.anchorMax=v.Board.pivot=new Vector2(.5f,.5f);
            Pic(v.Board,"Panel","common/com_new_2",0,0,850,740);
            var title=Label(v.Board,"Title","ZATOD LEGEND",font,55,55,740,75,46);title.fontStyle=FontStyles.Bold;
            Label(v.Board,"NameLabel","Your name",font,115,155,620,45,29);
            v.PlayerName=Input(v.Board,"NameField","Enter your name",client.SavedDisplayName,font,115,205,620,24);
            Label(v.Board,"ServerLabel","Server IP",font,115,290,620,45,29);
            v.ServerIp=Input(v.Board,"ServerField",client.CanDiscoverLan?"Auto LAN / enter IPv4":"e.g. 192.168.1.23",client.SavedServerAddress,font,115,340,client.CanDiscoverLan?455:620,15);
            v.ServerIp.keyboardType=TouchScreenKeyboardType.NumbersAndPunctuation;
            v.ServerIp.onValueChanged.AddListener(_=>{v.addressEdited=true;client.StopAddressLookup();});
            if(client.CanDiscoverLan)NativeButton(v.Board,"FindLan","Find LAN",font,590,340,145,70,()=>{v.addressEdited=false;client.FindServerAddress();});
            v.ConnectButton=NativeButton(v.Board,"Connect","Connect",font,235,450,380,85,()=>client.JoinLan(v.PlayerName.text,v.ServerIp.text));
            v.PlayerName.onSubmit.AddListener(_=>{if(v.ConnectButton.interactable)client.JoinLan(v.PlayerName.text,v.ServerIp.text);});
            v.ServerIp.onSubmit.AddListener(_=>{if(v.ConnectButton.interactable)client.JoinLan(v.PlayerName.text,v.ServerIp.text);});
            v.Message=Label(v.Board,"Status","",font,65,570,720,110,24);v.Message.textWrappingMode=TextWrappingModes.Normal;
            return v;
        }
        static TMP_InputField Input(Transform parent,string name,string placeholder,string value,TMP_FontAsset font,float x,float y,float width,int limit)
        {
            var field=Pic(parent,name,"package/bg_number",x,y,width,70,true);
            var input=field.gameObject.AddComponent<TMP_InputField>();input.targetGraphic=field;
            var viewport=Box(field.transform,"Viewport");Stretch(viewport,15);viewport.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            var text=ZatodHeroUi.Text(viewport,"Text","",font,32);Stretch(text.rectTransform);text.alignment=TextAlignmentOptions.MidlineLeft;text.richText=false;text.color=new Color(.22f,.18f,.13f);text.outlineWidth=0;
            var hint=ZatodHeroUi.Text(viewport,"Placeholder",placeholder,font,26);Stretch(hint.rectTransform);hint.color=new Color(.4f,.35f,.3f,.75f);hint.outlineWidth=0;
            input.textViewport=viewport;input.textComponent=text;input.placeholder=hint;input.characterLimit=limit;input.lineType=TMP_InputField.LineType.SingleLine;input.text=value;return input;
        }
        public void Refresh()
        {
            ConnectButton.interactable=!client.LoginBusy&&!string.IsNullOrWhiteSpace(PlayerName.text)&&(client.CanDiscoverLan||!string.IsNullOrWhiteSpace(ServerIp.text));
            PlayerName.interactable=!client.LoginBusy;
            ServerIp.interactable=!client.LoginBusy;
            if(!addressEdited&&!string.IsNullOrEmpty(client.SuggestedServerAddress))ServerIp.SetTextWithoutNotify(client.SuggestedServerAddress);
            Message.text=client.Status=="Connect to a Zatod server."?(client.CanDiscoverLan?"Enter your name. Server IP is detected on this LAN; you can also enter it manually.":"Enter your name and the PC server IPv4. Allow Local Network access when asked."):client.Status.StartsWith("Disconnected.")?"Disconnected. Check Server IP, then tap Connect.":client.Status;
        }
        void Update()
        {
            if(!lookupStarted&&client.LanReady){lookupStarted=true;client.FindServerAddress();}
            var size=((RectTransform)transform).rect.size;Board.anchoredPosition=Vector2.zero;Board.localScale=Vector3.one*Mathf.Min(size.x/1050,size.y/850);Refresh();
        }
    }
}
