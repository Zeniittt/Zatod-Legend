using System;
using TMPro;
using UnityEngine;
using Zatod.Combat;

namespace Zatod.Presentation
{
    public sealed partial class ArenaView
    {
        BattleHeroHud heroHud;
        public int HeroHudCount=>heroHud?.Count??0;
        public bool LiveMode=>Record!=null && Record.battleInProgress;
        void BuildHeroHud()
        {
            var font=Resources.Load<TMP_FontAsset>("UI/FormationFont")??Font;
            info.font=font;modeNote.font=font;status.font=font;
            heroHud=new BattleHeroHud(font,stage,id=>connection.RequestUltimate(id));
        }
        void CreateProjectileVisual(BattleProjectile projectile)
        {
            var owner=Record.initial.Find(f=>f.id==projectile.actorId);
            if(owner==null || string.IsNullOrEmpty(owner.animationSetResource))return;
            var rect=Rect(effects,"Projectile_"+projectile.actorId,0,0,1,1);rect.anchorMin=rect.anchorMax=new Vector2(.5f,.5f);
            var visual=rect.gameObject.AddComponent<ReplaySprite>();visual.Initialize(owner.animationSetResource);projectileVisuals.Add(projectile,visual);
        }
        void CreateEffectVisual(BattleVisualEffect effect)
        {
            if(effect.shockwave)
            {
                var rect=Rect(effects,"BurstRing_"+effect.startTick,0,0,1,1);rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);
                var ring=rect.gameObject.AddComponent<ArenaGraphic>();ring.shape=8;ring.raycastTarget=false;shockwaves.Add(effect,ring);return;
            }
            var owner=Record.initial.Find(f=>f.id==effect.actorId);if(owner==null || string.IsNullOrEmpty(owner.animationSetResource))return;
            var fx=Rect(effects,"FX_"+effect.state+"_"+effect.targetId+"_"+skillVisuals.Count,0,0,1,1);fx.anchorMin=fx.anchorMax=new Vector2(.5f,.5f);
            var visual=fx.gameObject.AddComponent<ReplaySprite>();visual.Initialize(owner.animationSetResource);skillVisuals.Add(effect,visual);
        }
        void ApplyLiveFrame(BattleRecord frame)
        {
            if(Record==null || Record.battleId!=frame.battleId)return;
            // Preserve visual bindings by append-only record index, including completed effects.
            for(int i=0;i<frame.projectiles.Count;i++)
            {
                if(i<Record.projectiles.Count)
                {var old=Record.projectiles[i];if(!ReferenceEquals(frame.projectiles[i],old))JsonUtility.FromJsonOverwrite(JsonUtility.ToJson(frame.projectiles[i]),old);frame.projectiles[i]=old;}
                else CreateProjectileVisual(frame.projectiles[i]);
            }
            for(int i=0;i<frame.visualEffects.Count;i++)
            {
                if(i<Record.visualEffects.Count)
                {var old=Record.visualEffects[i];if(!ReferenceEquals(frame.visualEffects[i],old))JsonUtility.FromJsonOverwrite(JsonUtility.ToJson(frame.visualEffects[i]),old);frame.visualEffects[i]=old;}
                else CreateEffectVisual(frame.visualEffects[i]);
            }
            if(frame.battleInProgress && frame.DurationSeconds-Playhead>.5f)Playhead=Mathf.Max(0,frame.DurationSeconds-.1f);
            Record=frame;Timeline=new ReplayTimeline(frame);Timeline.Seek(Mathf.FloorToInt(Playhead*frame.tickRate));Timeline.EventApplied+=OnBattleEvent;
            if(!frame.battleInProgress){modeNote.text="Trận đã kết thúc. Có thể xem lại bản ghi.";authorityLabel.text="SERVER-RECORDED BATTLE";}
            Playing=true;Speed=1;
            RenderStates(Timeline.States.Values,Playhead*frame.tickRate,false);UpdatePlaybackLabels();
        }
        void UpdateLiveControls()
        {
            var footer=root.Find("Playback");
            if(footer!=null)foreach(var control in footer.GetComponentsInChildren<UnityEngine.UI.Selectable>())control.interactable=!LiveMode;
            bool canCommand=LiveMode && connection.Connected && connection.LiveBattleId==Record.battleId;
            if(Timeline!=null)heroHud?.Update(Timeline.States,Record,canCommand,Timeline.Tick);
        }
        void UltimateResponse(Zatod.Networking.UltimateResponse response)
        {heroHud?.Responded(response.fighterId,response.requestId,response.accepted);}
    }
}
