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
        public TMP_InputField PlayerName,ServerIp,Password,ConfirmPassword;
        public TextMeshProUGUI Message;
        public UnityEngine.UI.Button ConnectButton,LoginTab,RegisterTab,ShowPassword;
        public bool RegisterMode {get;private set;}
        ZatodConnection client;
        RectTransform serverLabel,confirmLabel;
        UnityEngine.UI.Button findLan;
        bool lookupStarted,addressEdited,passwordVisible;
        string localError;
        public static ZatodLoginView Create(Transform parent,TMP_FontAsset font,ZatodConnection client)
        {
            var root=Box(parent,"ZatodLoginView");Stretch(root);var v=root.gameObject.AddComponent<ZatodLoginView>();v.client=client;
            var background=Pic(root,"Background","bg/herolist_bg",0,0,1600,900,true);Stretch(background.rectTransform);background.gameObject.AddComponent<ZatodFullScreenArt>();
            v.Board=Box(root,"LoginBoard",w:850,h:850);v.Board.anchorMin=v.Board.anchorMax=v.Board.pivot=new Vector2(.5f,.5f);
            Stretch(Pic(v.Board,"Panel","common/com_new_2",0,0,850,850).rectTransform);
            Label(v.Board,"Title","ZATOD LEGEND",font,55,24,740,65,43).fontStyle=FontStyles.Bold;
            v.LoginTab=NativeButton(v.Board,"LoginTab","Login",font,125,104,280,62,()=>v.SelectTab(false));
            v.RegisterTab=NativeButton(v.Board,"RegisterTab","Register",font,445,104,280,62,()=>v.SelectTab(true));
            Label(v.Board,"UsernameLabel","Username (case-sensitive)",font,115,185,620,34,25).alignment=TextAlignmentOptions.MidlineLeft;
            v.PlayerName=Input(v.Board,"UsernameField","Letters, numbers, _ or -",client.SavedDisplayName,font,115,224,620,24);
            Label(v.Board,"PasswordLabel","Password",font,115,301,620,34,25).alignment=TextAlignmentOptions.MidlineLeft;
            v.Password=Input(v.Board,"PasswordField","Enter password","",font,115,340,480,128);
            v.ShowPassword=NativeButton(v.Board,"ShowPassword","Show",font,605,340,130,64,v.TogglePassword);
            v.confirmLabel=Label(v.Board,"ConfirmPasswordLabel","Confirm password",font,115,415,620,34,25).rectTransform;
            v.confirmLabel.GetComponent<TextMeshProUGUI>().alignment=TextAlignmentOptions.MidlineLeft;
            v.ConfirmPassword=Input(v.Board,"ConfirmPasswordField","Enter password again","",font,115,454,620,128);
            v.serverLabel=Label(v.Board,"ServerLabel","Server IP",font,115,532,620,34,25).rectTransform;
            v.serverLabel.GetComponent<TextMeshProUGUI>().alignment=TextAlignmentOptions.MidlineLeft;
            v.ServerIp=Input(v.Board,"ServerField",client.CanDiscoverLan?"Auto LAN / enter IPv4":"e.g. 192.168.1.23",client.SavedServerAddress,font,115,568,client.CanDiscoverLan?455:620,15);
            v.ServerIp.keyboardType=TouchScreenKeyboardType.NumbersAndPunctuation;
            v.ServerIp.onValueChanged.AddListener(_=>{v.addressEdited=true;client.StopAddressLookup();v.localError=null;});
            if(client.CanDiscoverLan)v.findLan=NativeButton(v.Board,"FindLan","Find LAN",font,590,568,145,64,()=>{v.addressEdited=false;client.FindServerAddress();});
            v.ConnectButton=NativeButton(v.Board,"Submit","Login",font,235,666,380,72,v.Submit);
            v.Message=Label(v.Board,"Status","",font,65,751,720,82,23);v.Message.textWrappingMode=TextWrappingModes.Normal;
            foreach(var field in new[]{v.PlayerName,v.Password,v.ConfirmPassword,v.ServerIp})
            {field.onSubmit.AddListener(_=>v.Submit());field.onValueChanged.AddListener(_=>v.localError=null);}
            v.SetPasswordVisibility(false);v.SelectTab(false);return v;
        }
        static TMP_InputField Input(Transform parent,string name,string placeholder,string value,TMP_FontAsset font,float x,float y,float width,int limit)
        {
            var field=Pic(parent,name,"package/bg_number",x,y,width,64,true);
            var input=field.gameObject.AddComponent<TMP_InputField>();input.targetGraphic=field;
            var viewport=Box(field.transform,"Viewport");Stretch(viewport,12);viewport.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            var text=ZatodHeroUi.Text(viewport,"Text","",font,30);Stretch(text.rectTransform);text.alignment=TextAlignmentOptions.MidlineLeft;text.richText=false;text.color=new Color(.22f,.18f,.13f);text.outlineWidth=0;
            var hint=ZatodHeroUi.Text(viewport,"Placeholder",placeholder,font,25);Stretch(hint.rectTransform);hint.color=new Color(.4f,.35f,.3f,.75f);hint.outlineWidth=0;
            input.textViewport=viewport;input.textComponent=text;input.placeholder=hint;input.characterLimit=limit;input.lineType=TMP_InputField.LineType.SingleLine;input.text=value;return input;
        }
        public void SelectTab(bool register)
        {
            if(client.LoginBusy)return;
            RegisterMode=register;localError=null;ConfirmPassword.text="";
            confirmLabel.gameObject.SetActive(register);ConfirmPassword.gameObject.SetActive(register);
            Board.sizeDelta=new Vector2(850,register?850:735);
            Place(serverLabel,115,register?532:415,620,34);
            Place((RectTransform)ServerIp.transform,115,register?568:454,client.CanDiscoverLan?455:620,64);
            if(findLan!=null)Place((RectTransform)findLan.transform,590,register?568:454,145,64);
            Place((RectTransform)ConnectButton.transform,235,register?666:551,380,72);
            ConnectButton.GetComponentInChildren<TextMeshProUGUI>().text=register?"Register":"Login";
            Place(Message.rectTransform,65,register?751:636,720,82);
            LoginTab.image.sprite=ZatodFormationView.Art(register?"battle_prepare_lift_but_1":"battle_prepare_lift_but_2");
            RegisterTab.image.sprite=ZatodFormationView.Art(register?"battle_prepare_lift_but_2":"battle_prepare_lift_but_1");
        }
        public void TogglePassword()=>SetPasswordVisibility(!passwordVisible);
        void SetPasswordVisibility(bool visible)
        {
            passwordVisible=visible;
            foreach(var field in new[]{Password,ConfirmPassword})
            {field.contentType=visible?TMP_InputField.ContentType.Standard:TMP_InputField.ContentType.Password;field.asteriskChar='*';field.ForceLabelUpdate();}
            ShowPassword.GetComponentInChildren<TextMeshProUGUI>().text=visible?"Hide":"Show";
        }
        public void Submit()
        {
            if(client.LoginBusy)return;
            if(RegisterMode && Password.text!=ConfirmPassword.text){localError="Passwords do not match.";Refresh();return;}
            localError=null;
            if(RegisterMode)client.Register(PlayerName.text,Password.text,ServerIp.text);
            else client.Login(PlayerName.text,Password.text,ServerIp.text);
        }
        public void Refresh()
        {
            ConnectButton.interactable=!client.LoginBusy&&!string.IsNullOrEmpty(PlayerName.text)&&!string.IsNullOrEmpty(Password.text)
                &&(!RegisterMode||!string.IsNullOrEmpty(ConfirmPassword.text))&&(client.CanDiscoverLan||!string.IsNullOrWhiteSpace(ServerIp.text));
            foreach(var field in new[]{PlayerName,Password,ConfirmPassword,ServerIp})field.interactable=!client.LoginBusy;
            LoginTab.interactable=RegisterTab.interactable=ShowPassword.interactable=!client.LoginBusy;
            if(findLan!=null)findLan.interactable=!client.LoginBusy;
            if(!addressEdited&&!string.IsNullOrEmpty(client.SuggestedServerAddress))ServerIp.SetTextWithoutNotify(client.SuggestedServerAddress);
            Message.text=localError??(client.Status=="Connect to a Zatod server."?"Login to load your progress, or Register a new account.":client.Status);
        }
        void OnEnable(){if(client!=null && Password!=null){Password.text="";ConfirmPassword.text="";SetPasswordVisibility(false);localError=null;}}
        void OnDisable(){if(Password!=null){Password.text="";ConfirmPassword.text="";}}
        void Update()
        {
            if(!lookupStarted&&client.LanReady){lookupStarted=true;client.FindServerAddress();}
            var size=((RectTransform)transform).rect.size;Board.anchoredPosition=Vector2.zero;Board.localScale=Vector3.one*Mathf.Min(size.x/1020,size.y/(RegisterMode?890:775));Refresh();
        }
    }
}
