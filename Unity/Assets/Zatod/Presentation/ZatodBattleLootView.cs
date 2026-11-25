using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Zatod.Combat;

namespace Zatod.Presentation
{
    // Cosmetic projection of the server-issued plan and deterministic death records.
    public sealed class ZatodBattleLootView : MonoBehaviour
    {
        sealed class Chest {public Transform Root;public SpriteRenderer Shine,Halo;}
        readonly Dictionary<int,Chest> chests=new Dictionary<int,Chest>();
        ZatodBattleSimulation bound;List<ZatodLootDrop> plan=new List<ZatodLootDrop>();AudioSource audio;
        bool audioPaused;
        float finishedAt=-1;
        public int Collected {get;private set;}
        public int Planned=>plan.Count;
        public int VisibleChestCount=>chests.Count;
        public bool Complete=>Collected==plan.Count;
        public void Draw(ZatodBattleSimulation simulation,double interpolation,Camera camera,RectTransform marker,bool playAudio)
        {
            if(bound!=simulation){Clear();bound=simulation;plan=simulation.LootPlan();}
            if(audio==null){audio=gameObject.AddComponent<AudioSource>();audio.spatialBlend=0;audio.playOnAwake=false;}
            if(audioPaused==playAudio)
            {
                audioPaused=!playAudio;
                if(audioPaused)audio.Pause();else audio.UnPause();
            }
            double time=simulation.CurrentTick*ZatodBattleSimulation.StepSeconds+interpolation;
            if(simulation.Finished){if(finishedAt<0)finishedAt=Time.unscaledTime;time+=Time.unscaledTime-finishedAt;}
            var deaths=simulation.DeathRecords();var active=new HashSet<int>();int collected=0;
            foreach(var drop in plan)
            {
                var death=deaths.FirstOrDefault(d=>d.EntityId==drop.EntityId && d.Wave==drop.Wave);if(death==null)continue;
                double age=time-death.Tick*ZatodBattleSimulation.StepSeconds-drop.Index*.07;
                if(age<0)continue;
                const double fall=.6,hold=.65,fly=.55;double end=fall+hold+fly;
                if(age>=end){collected++;continue;}
                active.Add(drop.Index);
                if(!chests.TryGetValue(drop.Index,out var chest))
                {
                    var root=new GameObject("LootChest_"+drop.Index).transform;root.SetParent(transform,false);root.gameObject.layer=ZatodBattleStage.BattleLayer;
                    var image=Image(root,"Chest","common/chest1",31000);chest=new Chest{Root=root,Shine=Image(root,"Shine","common/shine",30998),Halo=Image(root,"Halo","common/chest_holo",30999)};
                    image.transform.localScale=Vector3.one*.9f;chest.Shine.color=new Color(1,1,1,.6f);chests.Add(drop.Index,chest);
                    if(playAudio && age<.2)Sound();
                }
                double t=Math.Min(age,fall),height=Math.Max(0,300*t-500*t*t);
                float spread=(drop.Index%5-2)*45;
                var position=ZatodBattleStage.Point(death.X+spread*t,death.Y-70*t,height+death.Height*Math.Max(0,1-t/fall));
                Vector3 viewport=camera.WorldToViewportPoint(position);viewport.x=Mathf.Clamp(viewport.x,.045f,.955f);viewport.y=Mathf.Clamp(viewport.y,.08f,.94f);position=camera.ViewportToWorldPoint(viewport);position.z=0;
                if(age>fall+hold)
                {
                    float f=(float)((age-fall-hold)/fly);var screen=RectTransformUtility.WorldToScreenPoint(null,marker.TransformPoint(marker.rect.center));
                    var target=camera.ScreenToWorldPoint(new Vector3(screen.x,screen.y,10));target.z=0;position=Vector3.Lerp(position,target,f*f);chest.Root.localScale=Vector3.one*Mathf.Lerp(1,.35f,f);
                }
                chest.Root.position=position;chest.Shine.transform.localRotation=Quaternion.Euler(0,0,(float)age*60);var color=chest.Halo.color;color.a=.45f+.3f*Mathf.Sin((float)age*Mathf.PI*2);chest.Halo.color=color;
            }
            if(collected>Collected && playAudio)Sound();Collected=collected;
            foreach(int id in chests.Keys.Where(k=>!active.Contains(k)).ToArray()){Destroy(chests[id].Root.gameObject);chests.Remove(id);}
        }
        SpriteRenderer Image(Transform parent,string name,string art,int order)
        {
            var go=new GameObject(name,typeof(SpriteRenderer));go.layer=ZatodBattleStage.BattleLayer;go.transform.SetParent(parent,false);var image=go.GetComponent<SpriteRenderer>();image.sprite=ZatodResultUi.Art(art);image.sortingOrder=order;image.sharedMaterial=Resources.Load<Material>("Zatod/World/ZatodWorldSprite");return image;
        }
        void Sound(){var clip=Resources.Load<AudioClip>("Zatod/Audio/battle_loot");if(clip!=null)audio.PlayOneShot(clip,.4f);}
        public void Clear()
        {
            foreach(var chest in chests.Values)if(chest.Root!=null)Destroy(chest.Root.gameObject);chests.Clear();bound=null;plan.Clear();finishedAt=-1;Collected=0;if(audio!=null)audio.Stop();audioPaused=false;
        }
    }
}
