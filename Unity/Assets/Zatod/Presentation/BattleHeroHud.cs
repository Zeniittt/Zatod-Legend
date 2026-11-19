using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using Zatod.Combat;

namespace Zatod.Presentation
{
    public sealed class BattleHeroHud
    {
        sealed class Card
        {
            public int Id,EnergyCost;
            public bool HasUltimate;
            public FormationFrame Frame;
            public UnityEngine.UI.Button Button;
            public UnityEngine.UI.Image Portrait;
            public RectTransform Hp,Energy;
            public TextMeshProUGUI Caption;
        }
        readonly HeroUi ui;
        readonly RectTransform root;
        readonly Func<int,string> cast;
        readonly List<Card> cards=new List<Card>();
        readonly Dictionary<int,string> pending=new Dictionary<int,string>();
        public int Count=>cards.Count;

        public BattleHeroHud(TMP_FontAsset font,Transform parent,Func<int,string> cast)
        {
            ui=new HeroUi(font);this.cast=cast;
            root=HeroUi.Rect(parent,"BattleHeroHud",0,432,1140,116);
        }

        public void Bind(BattleRecord record)
        {
            HeroUi.Clear(root);cards.Clear();pending.Clear();
            var squad=record.initial.Where(f=>f.team==0).OrderBy(f=>f.slot).ToArray();
            float left=(1140-squad.Length*106+10)*.5f;
            for(int i=0;i<squad.Length;i++)
            {
                var fighter=squad[i];int id=fighter.id;
                var button=ui.Button(root,"HeroUltimate-"+id,left+i*106,0,96,114,()=>Click(id));
                var portrait=HeroUi.Rect(button.transform,"Portrait",7,5,82,72).gameObject.AddComponent<UnityEngine.UI.Image>();
                portrait.sprite=Resources.Load<Sprite>("HeroPortraits/"+fighter.heroDefinitionId);portrait.preserveAspect=true;portrait.raycastTarget=false;
                if(portrait.sprite==null){portrait.enabled=false;ui.Glyph(button.transform,"Role",22,12,52,54,(int)fighter.role+1,HeroUi.Gold);}
                ui.Frame(button.transform,"HpTrack",7,79,82,6,HeroUi.Deep,HeroUi.Deep);
                var hp=HeroUi.Rect(button.transform,"Hp",7,79,82,6);var hpImage=hp.gameObject.AddComponent<UnityEngine.UI.Image>();hpImage.color=HeroUi.Hex("78C899");hpImage.raycastTarget=false;
                ui.Frame(button.transform,"EnergyTrack",7,88,82,8,HeroUi.Deep,HeroUi.Deep);
                var energy=HeroUi.Rect(button.transform,"Energy",7,88,82,8);var energyImage=energy.gameObject.AddComponent<UnityEngine.UI.Image>();energyImage.color=HeroUi.Gold;energyImage.raycastTarget=false;
                var ultimate=record.loadouts?.FirstOrDefault(l=>l.fighterId==id)?.hero?.Skills.FirstOrDefault(s=>s.IsUltimate);
                cards.Add(new Card{Id=id,HasUltimate=ultimate!=null,EnergyCost=ultimate?.Definition.EnergyCost??100,Button=button,Frame=button.GetComponent<FormationFrame>(),
                    Portrait=portrait,Hp=hp,Energy=energy,Caption=ui.Label(button.transform,"UltimateState","",3,98,90,14,10,HeroUi.Text,TextAlignmentOptions.Center,true)});
            }
        }

        public void Update(IReadOnlyDictionary<int,FighterState> states,BattleRecord record,bool canCommand,int tick)
        {
            foreach(var card in cards)
            {
                if(!states.TryGetValue(card.Id,out var state))continue;
                card.Hp.localScale=new Vector3(Mathf.Clamp01((float)state.hp/state.maxHp),1,1);
                card.Energy.localScale=new Vector3(Mathf.Clamp01((float)state.energy/Math.Max(1,card.EnergyCost)),1,1);
                if(!state.Alive || state.energy<card.EnergyCost)pending.Remove(card.Id);
                bool queued=state.ultimateQueued || pending.ContainsKey(card.Id);
                bool controlled=state.stunUntil>tick,ready=state.Alive && card.HasUltimate && state.energy>=card.EnergyCost && !controlled && !queued;
                card.Button.interactable=canCommand && ready;
                card.Portrait.color=state.Alive?Color.white:new Color(.28f,.28f,.28f,1);
                card.Frame.Edge=canCommand && ready?HeroUi.Gold:HeroUi.Edge;
                card.Frame.Fill=canCommand && ready?HeroUi.Hex("746032"):HeroUi.Panel;card.Frame.SetVerticesDirty();
                card.Caption.text=!state.Alive?"ĐÃ GỤC":!record.battleInProgress?(record.manualUltimateTeams==0?"AUTO":"REPLAY"):
                    controlled?"CHOÁNG":queued?"ĐÃ CHỌN":ready?"ULTI":state.energy+"/"+card.EnergyCost;
            }
        }
        void Click(int id)
        {
            var card=cards.Find(c=>c.Id==id);if(card==null || pending.ContainsKey(id))return;
            string request=cast(id);if(request==null)return;
            pending[id]=request;card.Button.interactable=false;card.Caption.text="ĐÃ CHỌN";
        }
        public void Responded(int id,string requestId,bool accepted)
        {if(!accepted && pending.TryGetValue(id,out string request) && request==requestId)pending.Remove(id);}
    }
}
