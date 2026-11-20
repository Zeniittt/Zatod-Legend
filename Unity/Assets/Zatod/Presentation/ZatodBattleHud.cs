using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
namespace Zatod.Presentation
{
    public sealed partial class ZatodPrototypeView
    {
        ZatodBattleHudLayout hud;
        readonly int[] cardEntities=new int[5];
        readonly Dictionary<int,TextMeshProUGUI> floatingText=new Dictionary<int,TextMeshProUGUI>();
        static Vector2 BattlePoint(double x,double y,double height)=>new Vector2(100+(float)x*1.75f,-520+(float)y*.875f+(float)height*1.75f);
        void ClearFloating()
        {
            foreach(var text in floatingText.Values)if(text!=null)Destroy(text.gameObject);
            floatingText.Clear();Array.Clear(cardEntities,0,cardEntities.Length);
        }
        void RefreshAuto()
        {
            hud.AutoText.text=connection.AutoUltimate?"AUTO ON":"AUTO OFF";
            hud.AutoImage.sprite=ZatodBattleHudLayout.Art(connection.AutoUltimate?"battle_auto_bg_1":"battle_auto_bg_2");
            hud.AutoText.color=connection.AutoUltimate?new Color(.65f,1,.25f):new Color(.9f,.88f,.75f);
        }
        void DrawHud(ZatodFrame frame,ZatodBattleSimulation simulation,double interpolation)
        {
            hud.Wave.text=frame.Wave+" / "+simulation.TotalWaves;
            hud.GoldValue.text=hud.ChestValue.text="0";
            hud.ReplayControls.gameObject.SetActive(replay!=null);
            hud.Auto.gameObject.SetActive(replay==null && simulation.Mode==ZatodMode.Campaign);
            hud.Auto.interactable=!frame.Finished;RefreshAuto();
            hud.ResultPanel.SetActive(frame.Finished);
            hud.Floating.gameObject.SetActive(!frame.Finished);
            bool validated=replay!=null || connection.LastReplay!=null && connection.LastReplay.Initial.BattleId==simulation.BattleId;
            hud.Continue.interactable=frame.Finished && validated;
            hud.WatchReplay.interactable=frame.Finished && validated && connection.LastReplay!=null;
            var party=frame.Units.Where(u=>replay==null && simulation.Mode==ZatodMode.RealtimePvp && connection.Team==1?u.EntityId>=100:u.EntityId<100).Take(5).ToArray();
            for(int index=0;index<5;index++)
            {
                var card=hud.Cards[index];bool exists=index<party.Length;card.Root.gameObject.SetActive(exists);if(!exists)continue;
                var unit=party[index];card.Root.anchoredPosition=new Vector2((740-party.Length*148)/2+index*148,0);
                string id=ZatodContentIds.Canonical(unit.DefinitionId);var definition=catalog.Data.Heroes.FirstOrDefault(h=>h.Id==id);
                card.Portrait.sprite=Resources.Load<Sprite>("Zatod/UI/Portraits/"+id);card.Portrait.color=unit.Alive?Color.white:new Color(.3f,.3f,.3f,.8f);
                card.Name.text=definition?.Name??unit.Name;
                var owned=connection.Snapshot?.Account.HeroDesk.FirstOrDefault(h=>h.HeroDefinitionId==id);
                int stars=Math.Clamp(owned?.Stars??1,1,5);card.Stars.gameObject.SetActive(false);for(int j=0;j<5;j++){card.StarIcons[j].gameObject.SetActive(j<stars);card.StarIcons[j].rectTransform.anchoredPosition=new Vector2((114-stars*18)/2+j*18,0);}
                var rankFrame=card.Root.GetComponent<UnityEngine.UI.Image>();rankFrame.color=owned?.RankId=="blue"?new Color(.4f,.7f,1):owned?.RankId=="green" || owned?.RankId=="green_plus_1"?new Color(.5f,1,.4f):Color.white;
                card.Health.fillAmount=(float)(unit.Hp/Math.Max(1,unit.MaxHp));card.Energy.fillAmount=(float)(unit.Energy/Math.Max(1,unit.MaxEnergy));
                bool ready=unit.Alive && unit.Energy>=unit.MaxEnergy;
                card.Ready.gameObject.SetActive(ready);card.Button.interactable=replay==null && !frame.Finished && ready && unit.Team==connection.Team;
                if(cardEntities[index]!=unit.EntityId)
                {
                    cardEntities[index]=unit.EntityId;int actorId=unit.EntityId;
                    card.Button.onClick.RemoveAllListeners();card.Button.onClick.AddListener(()=>{if(replay==null)connection.Ultimate(actorId);});
                }
            }
            var live=new HashSet<int>();
            foreach(var effect in frame.CombatEvents)
            {
                double age=(frame.Tick-effect.Tick)*ZatodBattleSimulation.StepSeconds+interpolation;if(age>1.25)continue;live.Add(effect.Id);
                if(!floatingText.TryGetValue(effect.Id,out var text))
                {
                    string value=(effect.Kind=="damage"?"-":"+")+Math.Ceiling(effect.Amount).ToString("0");
                    if(effect.Kind=="energy" || effect.Kind=="last_hit")value+=" ENERGY";
                    if(effect.Kind=="last_hit")value="LAST HIT!\n"+value;
                    text=Label(hud.Floating,value,0,0,220,60,effect.Kind=="energy"?19:effect.Critical?30:23);text.alignment=TextAlignmentOptions.Center;
                    text.name="Combat_"+effect.Kind+"_"+effect.Id;
                    floatingText.Add(effect.Id,text);
                }
                var point=BattlePoint(effect.X,effect.Y,effect.Height);text.rectTransform.anchoredPosition=point+new Vector2(-110+(effect.Id%3-1)*18,105+(float)age*60+(effect.Kind=="energy"?45:0));
                Color color=effect.Kind=="heal"?new Color(.4f,1,.25f):effect.Kind=="energy" || effect.Kind=="last_hit"?new Color(.2f,.8f,1):effect.DamageType=="AP"?new Color(.3f,.85f,1):new Color(1,.8f,.12f);
                color.a=1-(float)Math.Max(0,(age-.65)/.6);text.color=color;
            }
            foreach(int id in floatingText.Keys.Where(id=>!live.Contains(id)).ToArray()){Destroy(floatingText[id].gameObject);floatingText.Remove(id);}
        }
    }
}
