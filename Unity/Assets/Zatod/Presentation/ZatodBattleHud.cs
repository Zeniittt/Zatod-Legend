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
        readonly int[] heardReadyTicks={-1,-1,-1,-1,-1};
        AudioSource readySound;
        AudioClip readyClip;
        int hudSoundTick=-1;
        readonly Dictionary<int,TextMeshProUGUI> floatingText=new Dictionary<int,TextMeshProUGUI>();
        static Vector2 BattlePoint(double x,double y,double height)=>new Vector2(100+(float)x*1.75f,-520+(float)y*.875f+(float)height*1.75f);
        void ActivateUltimate(int actorId)
        {
            if(replay==null && connection.Ultimate(actorId))DrawBattle();
        }
        void ClearFloating()
        {
            foreach(var text in floatingText.Values)if(text!=null)Destroy(text.gameObject);
            floatingText.Clear();Array.Clear(cardEntities,0,cardEntities.Length);
            for(int i=0;i<heardReadyTicks.Length;i++)heardReadyTicks[i]=-1;
            hudSoundTick=-1;readySound?.Stop();
        }
        void RefreshAuto()
        {
            hud.AutoText.text=connection.AutoUltimate?"AUTO ON":"AUTO OFF";
            hud.AutoImage.sprite=ZatodBattleHudLayout.Art(connection.AutoUltimate?"battle_auto_bg_1":"battle_auto_bg_2");
            hud.AutoText.color=connection.AutoUltimate?new Color(.65f,1,.25f):new Color(.9f,.88f,.75f);
        }
        void DrawHud(ZatodFrame frame,ZatodBattleSimulation simulation,double interpolation)
        {
            if(readySound==null)
            {
                readySound=gameObject.AddComponent<AudioSource>();readySound.playOnAwake=false;readySound.spatialBlend=0;
                readyClip=Resources.Load<AudioClip>("Zatod/Audio/battle_fury_full");
            }
            bool advancing=(replay==null || playing) && frame.Tick>hudSoundTick;
            if(replay!=null && !playing)readySound.Pause();else readySound.UnPause();
            hud.Wave.text=frame.Wave+" / "+simulation.TotalWaves;
            hud.GoldValue.text=hud.ChestValue.text="0";
            hud.ReplayControls.gameObject.SetActive(replay!=null);
            hud.Auto.gameObject.SetActive(replay==null && simulation.Mode==ZatodMode.Campaign);
            hud.Auto.interactable=!frame.Finished;RefreshAuto();
            hud.ResultPanel.SetActive(frame.Finished && !(simulation.Mode==ZatodMode.Campaign && frame.Winner==0));
            hud.Floating.gameObject.SetActive(!frame.Finished);
            bool validated=replay!=null || connection.LastReplay!=null && connection.LastReplay.Initial.BattleId==simulation.BattleId;
            hud.Continue.interactable=frame.Finished && validated;
            hud.WatchReplay.interactable=frame.Finished && validated && connection.LastReplay!=null;
            int viewingTeam=replay==null?connection.Team:0;
            var party=frame.Units.Where(u=>u.Team==viewingTeam && u.SummonerId==0).Take(5).ToArray();
            for(int index=0;index<5;index++)
            {
                var card=hud.Cards[index];bool exists=index<party.Length;card.Root.gameObject.SetActive(exists);if(!exists)continue;
                var unit=party[index];card.Root.anchoredPosition=new Vector2((740-party.Length*148)/2+index*148,0);
                string id=ZatodContentIds.Canonical(unit.DefinitionId);var definition=catalog.Data.Heroes.FirstOrDefault(h=>h.Id==id);
                card.Portrait.sprite=ZatodBattleHudLayout.Portrait(id);card.Portrait.color=unit.Alive?Color.white:new Color(.3f,.3f,.3f,.8f);
                card.Name.text=definition?.Name??unit.Name;
                int stars=Math.Clamp(unit.Stars,0,5);card.Stars.gameObject.SetActive(false);for(int j=0;j<5;j++){card.StarIcons[j].gameObject.SetActive(j<stars);card.StarIcons[j].rectTransform.anchoredPosition=new Vector2((114-stars*18)/2+j*18,0);}
                var rankFrame=card.Root.GetComponent<UnityEngine.UI.Image>();
                rankFrame.color=ZatodHeroUi.RankColor(unit.RankId);
                card.Health.fillAmount=(float)(unit.Hp/Math.Max(1,unit.MaxHp));card.Energy.fillAmount=(float)(unit.Energy/Math.Max(1,unit.MaxEnergy));
                float castDuration=card.CastCue.Duration;
                float time=(float)(frame.Tick*ZatodBattleSimulation.StepSeconds+interpolation);
                float castAge=unit.UltimateCastTick<0?castDuration:(float)((frame.Tick-unit.UltimateCastTick)*ZatodBattleSimulation.StepSeconds+interpolation);
                bool pending=replay==null && unit.Alive && !frame.Finished && connection.UltimatePending(unit.EntityId);
                bool ready=unit.CanActivateUltimate && !pending;
                if(advancing && ready && unit.UltimateReadySinceTick>=0 && unit.UltimateReadySinceTick!=heardReadyTicks[index] && readyClip!=null)
                    readySound.PlayOneShot(readyClip,.7f);
                heardReadyTicks[index]=unit.UltimateReadySinceTick;
                bool casting=unit.Alive && !frame.Finished && castAge>=0 && castAge<castDuration;
                bool showSignal=ready || pending || casting;
                card.Ready.gameObject.SetActive(showSignal);
                card.UltimateSignal.alpha=pending && !casting ? .34f : 1;
                bool trigger=unit.SourceId==39 && unit.Action=="ult";
                double readyAge=(frame.Tick-Math.Max(0,unit.UltimateReadySinceTick))*ZatodBattleSimulation.StepSeconds+interpolation;
                card.ReadyCue.Draw(readyAge,ready && !trigger && !casting,true);
                card.TriggerCue.Draw(readyAge,ready && trigger && !casting,true);
                card.CastCue.Draw(castAge,casting,false);
                double fullAge=(frame.Tick-Math.Max(0,unit.FullEnergySinceTick))*ZatodBattleSimulation.StepSeconds+interpolation;
                card.FullEnergyCue.Draw(fullAge,unit.Alive && unit.Energy>=unit.MaxEnergy && !frame.Finished,true);
                double costAge=(frame.Tick-unit.EnergyCostSinceTick)*ZatodBattleSimulation.StepSeconds+interpolation;
                card.EnergyCostCue.Draw(costAge,unit.Alive && unit.EnergyCostSinceTick>=0 && !frame.Finished,true);
                ((RectTransform)card.EnergyCostCue.transform).anchoredPosition=new Vector2(114*(card.Energy.fillAmount-.5f),0);
                card.Portrait.rectTransform.localScale=Vector3.one;
                card.LowHealth.gameObject.SetActive(unit.Alive && unit.Hp/unit.MaxHp<.2 && !frame.Finished);
                float phase=Mathf.Repeat(time,1);
                card.LowHealth.color=new Color(1,1,1,phase<.8f?Mathf.Lerp(1,.25f,phase/.8f):Mathf.Lerp(.25f,1,(phase-.8f)/.2f));
                card.Button.interactable=replay==null && ready;
                if(cardEntities[index]!=unit.EntityId)
                {
                    cardEntities[index]=unit.EntityId;int actorId=unit.EntityId;
                    card.Button.onClick.RemoveAllListeners();card.Button.onClick.AddListener(()=>ActivateUltimate(actorId));
                }
            }
            hudSoundTick=frame.Tick;
            var live=new HashSet<int>();
            foreach(var effect in frame.CombatEvents)
            {
                if(effect.Kind=="death" || effect.Wave!=frame.Wave)continue;
                const float life=.85f;
                float age=(float)((frame.Tick-effect.Tick)*ZatodBattleSimulation.StepSeconds+interpolation);
                if(age>life)continue;
                live.Add(effect.Id);
                if(!floatingText.TryGetValue(effect.Id,out var text))
                {
                    string value=effect.Kind switch
                    {
                        "immune"=>"IMMUNE",
                        "dodge"=>"DODGE",
                        "miss"=>"MISS",
                        "resist"=>"RESIST",
                        _=>(effect.Kind=="damage"?"-":"+")+Math.Ceiling(effect.Amount).ToString("0")
                    };
                    if(effect.Kind=="energy" || effect.Kind=="last_hit")value+=" ENERGY";
                    if(effect.Kind=="last_hit")value="LAST HIT!\n"+value;
                    text=Label(hud.Floating,value,0,0,220,60,effect.Kind=="energy"?19:effect.Critical?30:23);text.alignment=TextAlignmentOptions.Center;
                    text.name="Combat_"+effect.Kind+"_"+effect.Id;
                    floatingText.Add(effect.Id,text);
                }
                float rise=1-Mathf.Pow(1-Mathf.Clamp01(age/life),2);
                float pop=1+Mathf.Sin(Mathf.PI*Mathf.Clamp01(age/.20f))*(effect.Critical ? .25f : .12f);
                double x=effect.X;
                if(frame.WaveEntryRemaining>0)
                {
                    var actor=frame.Units.FirstOrDefault(unit=>unit.EntityId==effect.EntityId && unit.Alive);
                    if(actor!=null)x+=ZatodBattleStage.WaveEntryOffset(actor.Team,frame.WaveEntryRemaining,interpolation);
                }
                var point=BattlePoint(x,effect.Y,effect.Height);
                text.rectTransform.anchoredPosition=point+new Vector2(-110+(effect.Id%3-1)*18,105+rise*62+(effect.Kind=="energy"?45:0));
                text.rectTransform.localScale=Vector3.one*pop;
                Color color=effect.Kind=="heal"?new Color(.4f,1,.25f):effect.Kind=="energy" || effect.Kind=="last_hit"?new Color(.2f,.8f,1):effect.DamageType=="AP"?new Color(.3f,.85f,1):new Color(1,.8f,.12f);
                if(effect.Kind=="immune" || effect.Kind=="dodge" || effect.Kind=="miss" || effect.Kind=="resist")color=new Color(.83f,.9f,1);
                color.a=1-Mathf.InverseLerp(.47f,life,age);text.color=color;
            }
            foreach(int id in floatingText.Keys.Where(id=>!live.Contains(id)).ToArray()){Destroy(floatingText[id].gameObject);floatingText.Remove(id);}
        }
    }
}
