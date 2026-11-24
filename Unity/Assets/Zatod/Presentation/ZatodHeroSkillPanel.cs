using System;
using System.Linq;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Zatod.Heroes;
using Zatod.Networking;
using static Zatod.Presentation.ZatodHeroUi;

namespace Zatod.Presentation
{
    public sealed class ZatodHeroSkillPanel:MonoBehaviour
    {
        public string SelectedSlotId{get;private set;}
        public UnityEngine.UI.Button UpgradeButton;
        public ScrollRect DetailsScroll;
        HeroCatalog catalog;CharacterData account;HeroData hero;ZatodConnection connection;TMP_FontAsset font;
        RectTransform cards,details,content,footer,portraitRoot,namePlate,descriptionFrame,descriptionArrow;
        ReplaySprite portrait;Vector2 portraitSize=new Vector2(250,300);float opened;
        TextMeshProUGUI heroName;UnityEngine.UI.Button introTab,detailsTab;bool showDetails;
        [Serializable] public class PresentationEntry { public string HeroId,Intro,Name;public int Slot; }
        [Serializable] public class PresentationData { public List<PresentationEntry> Entries; }
        PresentationData presentation;
        readonly List<RectTransform> evoRows=new List<RectTransform>();
        TextMeshProUGUI heading,description,cost,status;
        readonly List<UnityEngine.UI.Button> choices=new List<UnityEngine.UI.Button>();
        readonly List<TextMeshProUGUI> milestones=new List<TextMeshProUGUI>();
        ZatodRepeatButton repeat;Vector2 size;string heroId;bool wasBusy;
        public static ZatodHeroSkillPanel Create(Transform parent,TMP_FontAsset font)
        {
            var root=Box(parent,"HeroSkills");var view=root.gameObject.AddComponent<ZatodHeroSkillPanel>();view.font=font;
            view.presentation=JsonUtility.FromJson<PresentationData>(Resources.Load<TextAsset>(Path+"Skills/Presentation").text);
            view.cards=Picture(root,"SkillSlots","hero_info_bg_0").rectTransform;
            view.cards.GetComponent<UnityEngine.UI.Image>().color=new Color(.60f,.59f,.66f);
            Stretch(Picture(view.cards,"Floor","hero_bg_tattoos_2",aspect:true).rectTransform,40);
            Stretch(Picture(view.cards,"Circle","hero_star_bg_0",aspect:true).rectTransform,30);
            view.namePlate=Picture(view.cards,"HeroRank","hero_rank_1").rectTransform;
            view.heroName=Text(view.namePlate,"HeroName","",font,27);Stretch(view.heroName.rectTransform,6);view.heroName.alignment=TextAlignmentOptions.Center;
            view.details=Picture(root,"SkillDetails","hero_info_bg_0").rectTransform;
            var namebg=Picture(view.details,"NameBackground","Skills/skill_name_bg");Fill(namebg.rectTransform,Vector2.up,Vector2.one,new Vector2(12,-67),new Vector2(-12,-5));
            view.heading=Text(view.details,"SkillName","",font,28);Fill(view.heading.rectTransform,Vector2.up,Vector2.one,new Vector2(32,-60),new Vector2(-30,-10));view.heading.alignment=TextAlignmentOptions.Center;
            view.introTab=Button(view.details,"Intro","Skills/skill_detail_button_1",()=>view.SetDescription(false));Caption(view.introTab,"Intro",font,22);
            view.detailsTab=Button(view.details,"Details","Skills/skill_detail_button_2",()=>view.SetDescription(true));Caption(view.detailsTab,"Details",font,22);
            view.DetailsScroll=Scroll(view.details,"DescriptionScroll",out view.content);
            view.descriptionFrame=Picture(view.content,"IntroFrame","Skills/skill_expound_bg").rectTransform;
            view.descriptionArrow=Picture(view.content,"IntroArrow","Skills/skill_expound_arrow",aspect:true).rectTransform;
            view.description=Text(view.content,"Description","",font,23);view.description.enableAutoSizing=false;view.description.textWrappingMode=TextWrappingModes.Normal;view.description.overflowMode=TextOverflowModes.Overflow;
            view.footer=Box(view.details,"UpgradeFooter");
            var line=Picture(view.footer,"Divider","Skills/skill_line");Fill(line.rectTransform,Vector2.up,Vector2.one,new Vector2(0,-8),Vector2.zero);
            view.cost=Text(view.footer,"GoldCost","",font,24);
            Picture(view.footer,"Gold","goldicon",aspect:true);
            view.status=Text(view.footer,"Status","",font,19);view.status.alignment=TextAlignmentOptions.Center;
            view.UpgradeButton=Button(view.footer,"Upgrade","buttion_big");Caption(view.UpgradeButton,"Lvl Up",font,30);
            view.repeat=view.UpgradeButton.gameObject.AddComponent<ZatodRepeatButton>();view.repeat.CanPress=()=>view.CanUpgrade(out _,out _);view.repeat.Press=()=>view.connection.UpgradeSkill(view.hero.HeroInstanceId,view.SelectedSlotId);
            return view;
        }
        public void Bind(HeroCatalog definitions,CharacterData owned,string id,ZatodConnection client)
        {
            catalog=definitions;account=owned;connection=client;hero=owned.HeroDesk.Single(h=>h.HeroInstanceId==id);
            if(heroId!=id){heroId=id;SelectedSlotId=catalog.Hero(hero.HeroDefinitionId).SkillSlots.First().Id;BuildCards();DetailsScroll.verticalNormalizedPosition=1;}
            Refresh();
        }
        void BuildCards()
        {
            repeat.Cancel();foreach(var choice in choices){choice.gameObject.SetActive(false);Destroy(choice.gameObject);}choices.Clear();
            foreach(var slot in catalog.Hero(hero.HeroDefinitionId).SkillSlots)
            {
                string slotId=slot.Id;var skill=catalog.Skill(slot.SkillId);
                var choice=Button(cards,"Slot_"+slot.Id,"Skills/skill_icon_bg_1",()=>Select(slotId));
                Picture(choice.transform,"Icon","Skills/Icons/"+skill.Id,aspect:true);
                Picture(choice.transform,"Quality","equip_frame_white",aspect:true);
                Picture(choice.transform,"Lock","Skills/skill_lock",aspect:true);
                Picture(choice.transform,"Selection","Skills/skill_icon_bg_2").transform.SetAsFirstSibling();
                var badge=Picture(choice.transform,"EvoCount","Skills/skill_rank_1");var count=Text(badge.transform,"Count","0",font,22);Stretch(count.rectTransform);count.alignment=TextAlignmentOptions.Center;
                Text(choice.transform,"Name",skill.Name,font,24).alignment=TextAlignmentOptions.Center;
                Text(choice.transform,"Level","",font,22).alignment=TextAlignmentOptions.Center;
                choices.Add(choice);
            }
            // Purple remains a presentation-only locked slot until D34 opens that content.
            if(choices.Count==3)
            {
                var locked=Button(cards,"PurpleSlot","Skills/skill_icon_bg_1");locked.interactable=false;
                Picture(locked.transform,"Icon","Skills/Icons/locked_"+hero.HeroDefinitionId,aspect:true).color=new Color(.4f,.4f,.4f);
                Picture(locked.transform,"Quality","equip_frame_white",aspect:true);
                Picture(locked.transform,"Lock","Skills/skill_lock",aspect:true);
                Text(locked.transform,"Name","",font,20);
                var label=Text(locked.transform,"Level","Purple",font,22);label.color=new Color(1,.3f,.3f);label.alignment=TextAlignmentOptions.Center;
                choices.Add(locked);
            }
            if(portraitRoot!=null){portraitRoot.gameObject.SetActive(false);Destroy(portraitRoot.gameObject);}
            portraitRoot=Box(cards,"HeroIdle");portraitRoot.SetSiblingIndex(2);portrait=portraitRoot.gameObject.AddComponent<ReplaySprite>();
            string resource=catalog.Hero(hero.HeroDefinitionId).AnimationSetResource;portrait.Initialize(resource);opened=Time.unscaledTime;
            var set=JsonUtility.FromJson<Zatod.Animation.HeroAnimationSetData>(Resources.Load<TextAsset>(resource).text);
            var clip=set.Clips.First(c=>c.State=="Idle");if(clip.ContentBounds!=null && clip.ContentBounds.Count>0)portraitSize=new Vector2(clip.ContentBounds.Max(b=>b.Width),clip.ContentBounds.Max(b=>b.Height))*(100f/set.PixelsPerUnit);
            size=Vector2.zero;
        }
        void SetDescription(bool detailed){showDetails=detailed;Refresh();DetailsScroll.verticalNormalizedPosition=1;}
        public void Select(string slotId)
        {
            if(!catalog.Hero(hero.HeroDefinitionId).SkillSlots.Any(s=>s.Id==slotId))return;
            repeat.Cancel();SelectedSlotId=slotId;Refresh();DetailsScroll.verticalNormalizedPosition=1;
        }
        void Refresh()
        {
            if(hero==null)return;
            var definition=catalog.Hero(hero.HeroDefinitionId);var unlocked=HeroProgression.UnlockedSkills(hero,catalog).Select(x=>x.Id).ToHashSet();
            for(int n=0;n<definition.SkillSlots.Count;n++)
            {
                var slot=definition.SkillSlots[n];var choice=choices[n];bool open=unlocked.Contains(slot.Id);
                choice.transform.Find("Lock").gameObject.SetActive(!open);choice.transform.Find("Selection").gameObject.SetActive(slot.Id==SelectedSlotId);
                choice.transform.Find("Icon").GetComponent<UnityEngine.UI.Image>().color=open?Color.white:new Color(.48f,.48f,.48f);
                choice.transform.Find("Level").GetComponent<TextMeshProUGUI>().text=open?"Lvl "+hero.Skills.Single(x=>x.SlotId==slot.Id).Level:UnlockName(slot.Id);
                choice.transform.Find("Name").GetComponent<TextMeshProUGUI>().text=slot.IsUltimate?"Ultimate":"";
                choice.transform.Find("EvoCount/Count").GetComponent<TextMeshProUGUI>().text=(open?catalog.Skill(slot.SkillId).Evolutions.Count(e=>hero.Skills.Single(x=>x.SlotId==slot.Id).Level>=e.RequiredSkillLevel):0).ToString();
            }
            var selected=definition.SkillSlots.Single(x=>x.Id==SelectedSlotId);var skill=catalog.Skill(selected.SkillId);int level=hero.Skills.Single(x=>x.SlotId==SelectedSlotId).Level;
            heroName.text=definition.Name+" · "+HeroProgression.CurrentRank(hero,catalog).Name;namePlate.GetComponent<UnityEngine.UI.Image>().sprite=Art("hero_rank_"+Rank(hero,catalog));
            heading.text="<color=#FFD46E>"+skill.Name+"</color>  Lvl "+level;
            var intro=presentation.Entries.FirstOrDefault(x=>x.HeroId==definition.Id && x.Slot==definition.SkillSlots.IndexOf(selected)+1)?.Intro;
            // Resolve the same source placeholders as Details; the intro never invents combat numbers.
            var summary=skill.Copy();if(!string.IsNullOrWhiteSpace(intro))summary.Description=intro;
            description.text=SkillDescription.Describe(showDetails?skill:summary,level,catalog);
            introTab.image.sprite=Art("Skills/skill_detail_button_"+(showDetails?2:1));detailsTab.image.sprite=Art("Skills/skill_detail_button_"+(showDetails?1:2));
            while(milestones.Count<skill.Evolutions.Count)
            {
                var row=Picture(content,"EvolutionRow_"+milestones.Count,"Skills/skill_info_bg1").rectTransform;evoRows.Add(row);
                var badge=Picture(row,"Badge","Skills/skill_rank_1");var number=Text(badge.transform,"Number",(milestones.Count+1).ToString(),font,24);Stretch(number.rectTransform);number.alignment=TextAlignmentOptions.Center;
                var t=Text(row,"Evolution_"+milestones.Count,"",font,22);t.enableAutoSizing=false;t.textWrappingMode=TextWrappingModes.Normal;t.overflowMode=TextOverflowModes.Overflow;milestones.Add(t);
            }
            var ordered=skill.Evolutions.OrderBy(x=>x.RequiredSkillLevel).ThenBy(x=>x.Id,StringComparer.Ordinal).ToArray();
            for(int i=0;i<milestones.Count;i++)
            {
                evoRows[i].gameObject.SetActive(i<ordered.Length);if(i>=ordered.Length)continue;
                var evo=ordered[i];bool enabled=unlocked.Contains(SelectedSlotId)&&level>=evo.RequiredSkillLevel;
                milestones[i].text=evo.Description+(enabled?"":" <color=#FF6666>(Unlocks at Skill Lvl "+evo.RequiredSkillLevel+")</color>");
                milestones[i].color=enabled?new Color(.86f,1,.65f):new Color(.79f,.77f,.71f);
            }
            RefreshUpgrade();size=Vector2.zero;Fit();
        }
        string UnlockName(string slotId)=>catalog.Hero(hero.HeroDefinitionId).Ranks.FirstOrDefault(r=>r.UnlockSkillSlotIds.Contains(slotId))?.Name??"Locked";
        bool CanUpgrade(out long gold,out string reason)
        {
            gold=0;reason="";if(hero==null)return false;
            if(!HeroProgression.UnlockedSkills(hero,catalog).Any(x=>x.Id==SelectedSlotId)){reason="Unlock at "+UnlockName(SelectedSlotId);return false;}
            int level=hero.Skills.Single(x=>x.SlotId==SelectedSlotId).Level;
            if(level>=SkillProgression.Cap(hero,catalog)){reason=level>=catalog.Data.SkillProgression.SkillLevelCap?"Max skill level":"Raise Hero level to continue";return false;}
            try{gold=SkillProgression.Plan(hero,catalog,SelectedSlotId,level,1).Gold;}catch(ArgumentException){reason="Upgrade unavailable";return false;}
            if(CurrencyBalance.GetGold(account)<gold){reason="Not enough Gold";return false;}
            if(connection==null || !connection.Connected){reason="Connect to upgrade";return false;}
            if(connection.FindingPvp || connection.Battle!=null && !connection.Battle.Finished){reason="Finish the battle or leave the queue";return false;}
            if(connection.ItemOperationBusy){reason="Updating…";return false;}
            reason="Hold to upgrade one level at a time";return true;
        }
        void RefreshUpgrade()
        {
            UpgradeButton.interactable=CanUpgrade(out long gold,out string reason);cost.text=gold>0?"Cost:    "+gold.ToString("N0"):"";status.text=reason;
            wasBusy=connection!=null&&connection.ItemOperationBusy;
        }
        void LateUpdate()
        {
            Fit();if(wasBusy!=(connection!=null&&connection.ItemOperationBusy))RefreshUpgrade();
            if(portrait!=null)portrait.Sample("Idle",Time.unscaledTime-opened,true,Mathf.Min(cards.rect.width*.43f/Mathf.Max(1,portraitSize.x),cards.rect.height*.39f/Mathf.Max(1,portraitSize.y)));
        }
        void OnDisable()=>repeat?.Cancel();
        void Fit()
        {
            Vector2 now=((RectTransform)transform).rect.size;if(now==size || choices.Count==0)return;size=now;
            float left=size.x*.405f,right=size.x-left;
            Place(cards,0,0,left,size.y);Place(details,left,0,right,size.y);
            Place(namePlate,left*.16f,12,left*.68f,58);
            float diameter=Mathf.Min(left*.29f,size.y*.27f),icon=diameter*.60f;
            for(int n=0;n<choices.Count;n++)
            {
                var t=choices[n].transform;int row=n/2;float x=n%2==0?left*.035f:left-diameter-left*.035f;
                float y=row==0?size.y*.145f:size.y-diameter-24-(row-1)*(diameter+12);
                Place((RectTransform)t,x,y,diameter,diameter);
                Place((RectTransform)t.Find("Icon"),(diameter-icon)/2+7,diameter*.18f+7,icon-14,icon-14);Place((RectTransform)t.Find("Quality"),(diameter-icon)/2,diameter*.18f,icon,icon);
                Place((RectTransform)t.Find("Lock"),(diameter-icon*.55f)/2,diameter*.3f,icon*.55f,icon*.55f);
                Place((RectTransform)t.Find("Level"),0,diameter*.78f,diameter,30);
                Place((RectTransform)t.Find("Name"),0,diameter-2,diameter,27);
                var badge=t.Find("EvoCount");if(badge!=null)Place((RectTransform)badge,diameter*.34f,4,diameter*.32f,30);
                var selection=t.Find("Selection");if(selection!=null)Stretch((RectTransform)selection,-8);
            }
            portraitRoot.anchorMin=portraitRoot.anchorMax=new Vector2(.5f,.34f);portraitRoot.anchoredPosition=Vector2.zero;
            Place((RectTransform)introTab.transform,right/2-132,66,126,36);Place((RectTransform)detailsTab.transform,right/2+6,66,126,36);
            float footerHeight=Mathf.Min(180,size.y*.27f);
            Place(footer,0,size.y-footerHeight,right,footerHeight);
            Place(cost.rectTransform,right/2-115,20,230,36);cost.alignment=TextAlignmentOptions.Center;
            Place((RectTransform)footer.Find("Gold"),right/2+108,20,35,35);
            Place((RectTransform)UpgradeButton.transform,right/2-120,65,240,65);
            Place(status.rectTransform,12,footerHeight-32,right-24,28);
            Fill((RectTransform)DetailsScroll.transform,Vector2.zero,Vector2.one,new Vector2(12,footerHeight+8),new Vector2(-12,-112));
            float textWidth=Mathf.Max(100,right-48);
            float height=description.GetPreferredValues(description.text,textWidth,0).y+24;
            float introHeight=Mathf.Max(120,height);
            Place(descriptionFrame,0,0,right-24,introHeight+12);Place(descriptionArrow,(right-24)/2-18,introHeight-8,36,26);
            Place(description.rectTransform,12,8,textWidth,height);float offset=introHeight+26;
            for(int i=0;i<milestones.Count;i++)
            {
                if(!evoRows[i].gameObject.activeSelf)continue;
                var t=milestones[i];float w=textWidth-84,h=Mathf.Max(64,t.GetPreferredValues(t.text,w,0).y+24);
                Place(evoRows[i],0,offset,right-24,h);Place((RectTransform)evoRows[i].Find("Badge"),20,(h-34)/2,54,34);Place(t.rectTransform,86,12,w,h-24);offset+=h+4;
            }
            content.sizeDelta=new Vector2(0,offset);
        }
    }
}
