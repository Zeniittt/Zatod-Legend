using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Heroes;
using Zatod.Presentation;
using Zatod.Networking;
var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var host=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
var field=BindingFlags.Instance|BindingFlags.NonPublic;var view=(ZatodFormationView)host.GetType().GetField("formation",field).GetValue(host);
var catalog=HeroDataJson.LoadBundledCatalog();var campaigns=CampaignDataJson.LoadZatod(catalog);
var selected=(List<string>)host.GetType().GetField("selected",field).GetValue(host);
string folder=Path.GetFullPath("../Artifacts/ZatodFormationChecks");Directory.CreateDirectory(folder);
c.DevelopmentProfile="formation-final-"+Guid.NewGuid().ToString("N");c.Connect();
int phase=0,checks=0,waves=0;double started=EditorApplication.timeSinceStartup,phaseStart=started;string[] initial=null;bool drag=false;
UnityEditor.EditorApplication.CallbackFunction callback=null;
void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
void OpenFromMap(){UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name.StartsWith("Ải 1") && b.interactable).onClick.Invoke();}
void Finish(string error=null)
{
    EditorApplication.update-=callback;
    var result=new{Result=error==null?"PASS":"FAIL",Error=error,Checks=checks,Waves=waves,ScrollDrag=drag,AutoInputs=c.LastReplay?.Inputs.Count,ServerValidated=c.LastReplay?.Completed,OriginalOwnedHeroes=c.Snapshot?.Account.HeroDesk.Count,Seconds=EditorApplication.timeSinceStartup-started};
    File.WriteAllText(Path.Combine(folder,"view-live.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
}
callback=()=>
{
    try
    {
        if(!Application.isPlaying || EditorApplication.timeSinceStartup-started>140)throw new Exception("Formation test timeout/interrupted: "+phase+" "+c.Status);
        if(phase==0 && c.Snapshot!=null)
        {
            initial=c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray();OpenFromMap();
            Check(view.gameObject.activeSelf && c.Battle==null,"Stage click skipped formation");Check(view.Power.text=="?" && view.Cost.text=="" && view.Rewards.text=="","Placeholder data incorrect");
            Check(view.Description.text==campaigns.Stage(view.StageId).Description,"Chinese description not retained");
            foreach(var stage in campaigns.Data.Chapters[0].Stages)
            {
                view.Open(stage,catalog,c.Snapshot.Account,selected,()=>{},(_,__)=>{});
                for(int wi=0;wi<stage.Waves.Count;wi++)
                {
                    var wave=stage.Waves[wi];Check(view.WaveIndex==wi,"Wave order");Check(view.EnemyCards.Count(card=>card.Root.gameObject.activeSelf)==wave.Enemies.Count,"Enemy count");
                    for(int i=0;i<wave.Enemies.Count;i++){var spawn=wave.Enemies[i];var card=view.EnemyCards[i];Check(card.Portrait.sprite.name==spawn.DefinitionId && card.Level.text==spawn.Level.ToString() && card.Stars.Count(s=>s.gameObject.activeSelf)==spawn.Stars,"Enemy card data");}
                    Check(view.PreviousWave.interactable==(wi>0) && view.NextWave.interactable==(wi+1<stage.Waves.Count),"Wave arrow boundary");view.NextWave.onClick.Invoke();waves++;
                }
            }
            host.GetType().GetMethod("OpenFormation",field).Invoke(host,new object[]{"chapter_one_stage_1"});
            for(int i=0;i<4;i++)
            {
                view.Filters[i].onClick.Invoke();int expected=c.Snapshot.Account.HeroDesk.Count(h=>i==0 || (int)catalog.Hero(h.HeroDefinitionId).Position==i-1);
                Check(view.RosterCards.Count==expected && selected.Count==5,"Filter changed selection or roster incorrect");
            }
            view.Filters[0].onClick.Invoke();view.RosterCards[0].Button.onClick.Invoke();
            Check(!view.TeamCards[0].Root.gameObject.activeSelf && view.TeamCards.Skip(1).All(card=>card.Root.gameObject.activeSelf),"Four Heroes not right aligned");
            string[] draft=selected.ToArray();int preview=view.WaveIndex;view.Tutorial.onClick.Invoke();Check(selected.SequenceEqual(draft) && view.WaveIndex==preview,"Tutorial changed data");
            view.Back.onClick.Invoke();Check(!view.gameObject.activeSelf && c.Battle==null,"Back started battle");OpenFromMap();Check(selected.SequenceEqual(draft),"Back discarded session draft");
            ScreenCapture.CaptureScreenshot(Path.Combine(folder,"formation-four.png"));phase=1;phaseStart=EditorApplication.timeSinceStartup;return;
        }
        if(phase==1 && EditorApplication.timeSinceStartup-phaseStart>.3)
        {
            var copy=HeroDataJson.ReadCharacter(HeroDataJson.WriteCharacter(c.Snapshot.Account,catalog),catalog);
            for(int n=0;n<2;n++)foreach(var definition in catalog.Data.Heroes){var hero=catalog.CreateHero(definition.Id,Guid.NewGuid().ToString("D"));hero.Level=37;hero.Stars=3;hero.RankId="blue";copy.HeroDesk.Add(hero);}
            view.RefreshAccount(copy,true,"");Check(view.RosterCards.Count==37,"Isolated scroll roster missing");
            Check(view.Content.rect.height>view.RosterScroll.viewport.rect.height,"Grid not scrollable");
            var data=new PointerEventData(EventSystem.current){button=PointerEventData.InputButton.Left,position=RectTransformUtility.WorldToScreenPoint(null,view.RosterScroll.viewport.position)+new Vector2(100,-100)};
            view.RosterScroll.OnInitializePotentialDrag(data);view.RosterScroll.OnBeginDrag(data);float y=view.Content.anchoredPosition.y;data.position+=Vector2.up*160;view.RosterScroll.OnDrag(data);view.RosterScroll.OnEndDrag(data);drag=view.Content.anchoredPosition.y>y+10;Check(drag,"Scroll drag did not move content");
            int count=selected.Count;foreach(var card in view.RosterCards.Take(12).ToArray())if(!selected.Contains(card.InstanceId))card.Button.onClick.Invoke();Check(selected.Count==5,"Team exceeded capacity");
            foreach(string id in selected.ToArray())view.Toggle(id);Check(selected.Count==0 && !view.Battle.interactable,"Empty team can battle");
            foreach(string id in initial.Take(4))view.Toggle(id);view.RosterScroll.verticalNormalizedPosition=1;
            ScreenCapture.CaptureScreenshot(Path.Combine(folder,"formation-scroll-test-roster.png"));phase=2;phaseStart=EditorApplication.timeSinceStartup;return;
        }
        if(phase==2 && EditorApplication.timeSinceStartup-phaseStart>.3)
        {
            view.RefreshAccount(c.Snapshot.Account,true,"");foreach(string id in initial)if(!selected.Contains(id))view.Toggle(id);
            Check(view.RosterCards.Count==5 && c.Snapshot.Account.HeroDesk.Count==5,"Test roster persisted into real ownership");
            var eventData=new PointerEventData(EventSystem.current){position=RectTransformUtility.WorldToScreenPoint(null,view.Battle.image.rectTransform.TransformPoint(view.Battle.image.rectTransform.rect.center))};
            var hits=new List<RaycastResult>();EventSystem.current.RaycastAll(eventData,hits);Check(hits.Count>0 && hits[0].gameObject==view.Battle.gameObject,"Battle hit blocked");
            ScreenCapture.CaptureScreenshot(Path.Combine(folder,"formation-final.png"));phase=3;phaseStart=EditorApplication.timeSinceStartup;return;
        }
        if(phase==3 && EditorApplication.timeSinceStartup-phaseStart>.3)
        {c.AutoUltimate=true;view.Battle.onClick.Invoke();Check(view.Pending && !view.Battle.interactable,"Battle double-click not gated");phase=4;return;}
        if(phase==4 && c.Battle!=null)
        {
            Check(!view.gameObject.activeSelf,"Formation remained over battle");Check(c.Battle.Frame().Units.Where(u=>u.EntityId<100).Count()==5,"Wrong submitted team");phase=5;return;
        }
        if(phase==5 && c.Battle.Finished && c.LastReplay!=null)
        {
            Check(c.LastReplay.Completed && c.LastReplay.Digest==c.Battle.Replay().Digest,"Campaign checker rejected battle");
            Check(c.Snapshot.Account.HeroDesk.Select(h=>h.HeroInstanceId).SequenceEqual(initial),"Owned roster identity changed");Finish();
        }
    }
    catch(Exception error){Finish(error.ToString());}
};
EditorApplication.update+=callback;return new{Started=true};
