using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;
using Zatod.Networking;

namespace Zatod.Presentation
{
    // Native Crystal layers in their authored coordinate system (2x source pixels).
    public sealed class ZatodChapterSelectorView:MonoBehaviour
    {
        public ScrollRect Scroll{get;private set;}
        public TextMeshProUGUI Notice{get;private set;}
        public string FocusedChapter{get;private set;}
        public readonly List<UnityEngine.UI.Button> ChapterButtons=new List<UnityEngine.UI.Button>();
        readonly List<UnityEngine.UI.Image> islands=new List<UnityEngine.UI.Image>(),outlines=new List<UnityEngine.UI.Image>(),locks=new List<UnityEngine.UI.Image>();
        readonly List<TextMeshProUGUI> progress=new List<TextMeshProUGUI>();
        readonly List<TextMeshProUGUI> labels=new List<TextMeshProUGUI>();
        static readonly Vector2[] Positions={new Vector2(63,200.3f),new Vector2(196.19f,351.13f),new Vector2(331,221.57f),new Vector2(444.52f,375.98f),new Vector2(538.59f,185.18f),new Vector2(723.24f,335.17f),new Vector2(849.23f,205.62f),new Vector2(1005.45f,381.3f)};
        CampaignCatalog catalog;ZatodAccountSnapshot snapshot;Action<string> choose;TMP_FontAsset font;Vector2 lastSize;bool recenter;
        const string Art="Zatod/UI/ChapterSelector/";
        static UnityEngine.UI.Image Picture(Transform parent,string name,string resource,Vector2 center,Vector2? size=null,bool hit=false)
        {
            var rect=new GameObject(name,typeof(RectTransform)).GetComponent<RectTransform>();rect.SetParent(parent,false);rect.anchorMin=rect.anchorMax=Vector2.zero;rect.pivot=new Vector2(.5f,.5f);rect.anchoredPosition=center;
            var im=rect.gameObject.AddComponent<UnityEngine.UI.Image>();im.sprite=Resources.Load<Sprite>(Art+resource);im.raycastTarget=hit;
            if(im.sprite==null)throw new System.IO.FileNotFoundException(Art+resource);
            rect.sizeDelta=size??im.sprite.rect.size;return im;
        }
        public void Open(CampaignCatalog data,ZatodAccountSnapshot account,string current,Action<string> onChoose)
        {
            ClearSelection();catalog=data;snapshot=account;choose=onChoose;
            foreach(Transform child in Scroll.content)Destroy(child.gameObject);
            ChapterButtons.Clear();islands.Clear();outlines.Clear();locks.Clear();labels.Clear();progress.Clear();
            Picture(Scroll.content,"Ocean","worldmap_normal",new Vector2(1999,720),new Vector2(3998,1440),true);
            Picture(Scroll.content,"OceanRight","worldmap_normal_1",new Vector2(4466,720),new Vector2(936,1440),true);
            var overlay=new GameObject("ChapterLabels",typeof(RectTransform)).GetComponent<RectTransform>();overlay.SetParent(Scroll.content,false);overlay.anchorMin=overlay.anchorMax=overlay.pivot=Vector2.zero;overlay.anchoredPosition=Vector2.zero;
            var available=data.Data.Chapters.Take(Positions.Length).ToArray();
            FocusedChapter=available.Any(c=>c.Id==current)?current:available.LastOrDefault(c=>data.ChapterLockReason(c.Id,account.Account.Level,account.Cleared)==null)?.Id??available[0].Id;
            for(int n=0;n<available.Length;n++)
            {
                int index=n;var chapter=available[n];var position=(Positions[n]+new Vector2(80,85))*2;
                var island=Picture(Scroll.content,"Chapter_"+chapter.Id,"worldmap_map_norlmal_"+(n+1),position,hit:true);islands.Add(island);
                island.gameObject.AddComponent<ZatodSpriteHitArea>();
                var button=island.gameObject.AddComponent<UnityEngine.UI.Button>();button.targetGraphic=island;button.transition=Selectable.Transition.None;ChapterButtons.Add(button);
                button.onClick.AddListener(()=>{string reason=catalog.ChapterLockReason(chapter.Id,snapshot.Account.Level,snapshot.Cleared);if(reason!=null)Notice.text=reason;else choose?.Invoke(chapter.Id);});
                outlines.Add(Picture(Scroll.content,"Outline_"+chapter.Id,"worldmap_map_norlmal_choose_"+(n+1),position));
                var titlePos=(Positions[n]+new Vector2(80,-10))*2;
                var title=Picture(overlay,"Name_"+chapter.Id,"worldmap_chapter_normal_bg",titlePos,new Vector2(450,76));
                var label=ZatodStageUi.Text(title.transform,"Name",(n+1)+". "+chapter.Name,10,8,430,60,35,font);label.alignment=TextAlignmentOptions.Center;label.enableAutoSizing=true;label.fontSizeMin=25;label.fontSizeMax=35;labels.Add(label);
                var detail=ZatodStageUi.Text(overlay,"Progress_"+chapter.Id,"",0,0,430,52,30,font);detail.rectTransform.anchorMin=detail.rectTransform.anchorMax=Vector2.zero;detail.rectTransform.pivot=new Vector2(.5f,.5f);detail.rectTransform.anchoredPosition=titlePos+new Vector2(0,-72);detail.alignment=TextAlignmentOptions.Center;progress.Add(detail);
                locks.Add(Picture(overlay,"Lock_"+chapter.Id,"worldmap_chapter_lock",titlePos+new Vector2(0,-70),new Vector2(44,50)));
            }
            overlay.SetAsLastSibling();gameObject.SetActive(true);transform.SetAsLastSibling();Notice.text="Select an unlocked chapter";lastSize=Vector2.zero;recenter=true;Refresh(account);Fit();
        }
        public void Refresh(ZatodAccountSnapshot account)
        {
            snapshot=account;if(catalog==null)return;
            for(int i=0;i<islands.Count;i++)
            {
                var chapter=catalog.Data.Chapters[i];bool open=catalog.ChapterLockReason(chapter.Id,account.Account.Level,account.Cleared)==null;
                islands[i].color=open?Color.white:new Color(.30f,.30f,.34f,1);outlines[i].gameObject.SetActive(open && chapter.Id==FocusedChapter);locks[i].gameObject.SetActive(!open);
                var keys=chapter.Stages.Where(stage=>stage.KeyStage).ToArray();int stars=keys.Sum(stage=>account.StarsFor(stage.Id));progress[i].text=open?"Normal  ★  "+(keys.Length>0?Mathf.FloorToInt(stars*100f/(keys.Length*3)):0)+"%":"";progress[i].color=new Color(.62f,1,.43f);
                labels[i].color=open?new Color(1,.94f,.71f):new Color(.72f,.72f,.72f);
            }
        }
        public void Hide(){ClearSelection();Scroll.StopMovement();gameObject.SetActive(false);choose=null;}
        void ClearSelection()
        {
            var events=UnityEngine.EventSystems.EventSystem.current;var selected=events!=null?events.currentSelectedGameObject:null;
            if(selected!=null && selected.transform.IsChildOf(transform))events.SetSelectedGameObject(null);
        }
        void LateUpdate()=>Fit();
        void Fit()
        {
            var size=((RectTransform)transform).rect.size;if(size==lastSize)return;lastSize=size;
            float scale=size.y/1440f;float width=catalog==null?4934:Mathf.Min(4934,(Positions[islands.Count-1].x+80)*2+islands.Last().sprite.rect.width/2+80);Scroll.content.sizeDelta=new Vector2(width,1440);Scroll.content.localScale=Vector3.one*scale;
            if(recenter && catalog!=null)
            {
                Canvas.ForceUpdateCanvases();int index=Math.Max(0,catalog.Data.Chapters.FindIndex(c=>c.Id==FocusedChapter));
                float center=(Positions[index].x+80)*2*scale;float max=Mathf.Max(0,width*scale-size.x);
                Scroll.horizontalNormalizedPosition=max>0?Mathf.Clamp01((center-size.x/2)/max):0;recenter=false;
            }
        }
        public static ZatodChapterSelectorView Create(Transform parent,TMP_FontAsset font)
        {
            var root=ZatodStageUi.Box(parent,"ZatodChapterSelector",0,0,1600,900);root.anchorMin=Vector2.zero;root.anchorMax=Vector2.one;root.offsetMin=root.offsetMax=Vector2.zero;
            var view=root.gameObject.AddComponent<ZatodChapterSelectorView>();view.font=font;
            var block=root.gameObject.AddComponent<UnityEngine.UI.Image>();block.color=Color.black;block.raycastTarget=true;
            var viewport=ZatodStageUi.Box(root,"Viewport",0,0,1600,900);viewport.anchorMin=Vector2.zero;viewport.anchorMax=Vector2.one;viewport.offsetMin=viewport.offsetMax=Vector2.zero;viewport.gameObject.AddComponent<RectMask2D>();
            var content=new GameObject("Map",typeof(RectTransform)).GetComponent<RectTransform>();content.SetParent(viewport,false);content.anchorMin=content.anchorMax=content.pivot=new Vector2(0,.5f);
            view.Scroll=viewport.gameObject.AddComponent<ScrollRect>();view.Scroll.viewport=viewport;view.Scroll.content=content;view.Scroll.horizontal=true;view.Scroll.vertical=false;view.Scroll.movementType=ScrollRect.MovementType.Clamped;
            var close=ZatodStageUi.Button(root,"Close","break_butt_bj",24,20,65,65);ZatodStageUi.Image(ZatodStageUi.Box(close.transform,"Arrow",10,10,45,45),"break_butt");close.onClick.AddListener(view.Hide);
            var title=ZatodStageUi.Text(root,"Title","Legend World  ·  Normal",110,24,590,56,32,font);title.fontStyle=FontStyles.Bold;title.color=new Color(1,.84f,.38f);
            view.Notice=ZatodStageUi.Text(root,"LockReason","Select an unlocked chapter",100,0,1400,70,26,font);view.Notice.rectTransform.anchorMin=new Vector2(0,0);view.Notice.rectTransform.anchorMax=new Vector2(1,0);view.Notice.rectTransform.pivot=new Vector2(.5f,0);view.Notice.rectTransform.anchoredPosition=new Vector2(0,14);view.Notice.rectTransform.sizeDelta=new Vector2(-180,70);view.Notice.alignment=TextAlignmentOptions.Center;view.Notice.enableAutoSizing=true;view.Notice.fontSizeMin=18;view.Notice.fontSizeMax=26;
            root.gameObject.SetActive(false);return view;
        }
    }
}
