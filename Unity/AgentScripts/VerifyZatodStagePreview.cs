using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Heroes;
using Zatod.Presentation;
using Zatod.Networking;
var host=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();var c=host.GetComponent<ZatodConnection>();
var flags=BindingFlags.Instance|BindingFlags.NonPublic;
var preview=(ZatodStagePreviewView)host.GetType().GetField("stagePreview",flags).GetValue(host);
var formation=(ZatodFormationView)host.GetType().GetField("formation",flags).GetValue(host);
var selected=(List<string>)host.GetType().GetField("selected",flags).GetValue(host);
var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);
var snapshot=new ZatodAccountSnapshot{Account=campaign.CreateDemoCharacter(catalog)};
c.GetType().GetProperty("Snapshot").SetValue(c,snapshot);host.GetType().GetMethod("OnChanged",flags).Invoke(host,null);
int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
void Click(UnityEngine.UI.Button b){Check(b.interactable,"Disabled control "+b.name);ExecuteEvents.Execute(b.gameObject,new PointerEventData(EventSystem.current){button=PointerEventData.InputButton.Left},ExecuteEvents.pointerClickHandler);}
foreach(var stage in campaign.Data.Chapters.SelectMany(ch=>ch.Stages))
{
    preview.Open(stage,catalog,0,true,()=>{},()=>{});
    var enemies=stage.Waves.Last().Enemies.OrderBy(e=>e.Boss).ToArray();
    Check(preview.Enemies.Count(e=>e.Root.gameObject.activeSelf)==enemies.Length,"Wrong final-wave enemy count");
    for(int i=0;i<enemies.Length;i++)
    {
        Check(preview.Enemies[i].InstanceId==enemies[i].Id,"Enemy spawn identity changed");
        Check(preview.BossBadges[i].activeSelf==enemies[i].Boss,"Boss flag incorrect");
        Check(preview.Enemies[i].Portrait.sprite.name==enemies[i].DefinitionId,"Wrong enemy portrait");
    }
    Check(preview.Cost.text==stage.VitalityCost.ToString(),"Wrong cost");
    Check(preview.DropRow.Cast<Transform>().Count(t=>t.gameObject.activeSelf)==stage.DropItems.Count,"Wrong drops");
    foreach(var drop in stage.DropItems)Check(preview.DropRow.Find("Item_"+drop.ItemId+"/Mask/Icon").GetComponent<UnityEngine.UI.Image>().sprite.name==drop.ItemId,"Wrong item icon");
    for(int stars=0;stars<=3;stars++)
    {
        preview.Refresh(stars,true);
        for(int i=0;i<3;i++)Check(preview.Stars[i].sprite.name=="campaign_stage_star_"+(i<stars?1:stars==0?2:3),"Wrong stage star variant");
        Check(preview.Raid.image.sprite.name==(stars==3?"button_com_big":"button_grey"),"Wrong raid visual state");
        Check(preview.Raid.interactable==(stars==3) && preview.RaidMany.interactable==(stars==3),"Raid unlock state incorrect");
        int listeners=preview.Raid.onClick.GetPersistentEventCount()+preview.RaidMany.onClick.GetPersistentEventCount();Check(listeners==0,"Raid wired unexpectedly");
    }
}
preview.gameObject.SetActive(false);host.GetType().GetMethod("Show",flags).Invoke(host,new object[]{"campaign"});
await UnityEngine.Awaitable.NextFrameAsync();
var map=UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b=>b.name.StartsWith("Ải 1\n") && b.interactable);
Click(map);Check(preview.gameObject.activeSelf && !formation.gameObject.activeSelf && c.Battle==null,"Map bypassed preview");
preview.Refresh(0,true);Canvas.ForceUpdateCanvases();await UnityEngine.Awaitable.NextFrameAsync();
var pointer=new PointerEventData(EventSystem.current){position=RectTransformUtility.WorldToScreenPoint(null,map.transform.TransformPoint(((RectTransform)map.transform).rect.center))};var hits=new List<RaycastResult>();EventSystem.current.RaycastAll(pointer,hits);
Check(hits.Count>0 && hits[0].gameObject.GetComponentInParent<ZatodStagePreviewView>()==preview,"Modal click-through");
Click(preview.Tutorial);preview.Refresh(3,true);Click(preview.Raid);Click(preview.RaidMany);preview.Refresh(0,true);Check(c.Battle==null && preview.gameObject.activeSelf,"Placeholder started gameplay");
Click(preview.Challenge);Check(formation.gameObject.activeSelf && !preview.gameObject.activeSelf && c.Battle==null,"Challenge started battle/bypassed formation");
Check(formation.Rewards.text=="Reward" && formation.Cost.text=="Cost: 6","Formation labels incorrect");
Check(formation.DropRow.Cast<Transform>().Count(t=>t.gameObject.activeSelf)==campaign.Stage("chapter_one_stage_1").DropItems.Count,"Formation drop count incorrect");
Check(formation.DropRow.GetComponentsInChildren<TMPro.TextMeshProUGUI>().Length==0,"Drop rates/labels should not display");
formation.Toggle(selected[0]);var draft=selected.ToArray();Click(formation.Back);
Check(preview.gameObject.activeSelf && !formation.gameObject.activeSelf && selected.SequenceEqual(draft),"Back lost preview/draft");
Click(preview.Close);Check(!preview.gameObject.activeSelf && !formation.gameObject.activeSelf,"X did not close to map");
snapshot.StageStars.Add(new ZatodStageStars{StageId="chapter_one_stage_1",Stars=2});
var roundtrip=JsonUtility.FromJson<ZatodAccountSnapshot>(JsonUtility.ToJson(snapshot));Check(roundtrip.StarsFor("chapter_one_stage_1")==2 && roundtrip.StarsFor("chapter_one_stage_2")==0,"Snapshot star count roundtrip");
Check(UnityEngine.Object.FindObjectsByType<EventSystem>().Length==1,"Wrong EventSystem count");
host.GetType().GetMethod("OpenStagePreview",flags).Invoke(host,new object[]{"chapter_one_stage_1"});preview.Refresh(0,true);
Canvas.ForceUpdateCanvases();Check(preview.Layout.rect.width>0 && preview.DropRow.rect.height>0,"Empty UI geometry");
string folder=Path.GetFullPath("../Artifacts/ZatodStagePreviewChecks");Directory.CreateDirectory(folder);File.WriteAllText(Path.Combine(folder,"view-checks.json"),JsonUtility.ToJson(new Result{Checks=checks,Stages=18,Passed=true,IsolatedAccount=true},true));
return new{Passed=true,Checks=checks,Stages=18,Frame=Time.frameCount};
[Serializable] public class Result {public int Checks,Stages;public bool Passed,IsolatedAccount;}
