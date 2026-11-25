using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
public static class D38HitProbe
{
    public static async Task<object> Run(string report)
    {
        var template=UnityEngine.Object.FindAnyObjectByType<ZatodChapterSelectorView>(FindObjectsInactive.Include);
        var font=template.Notice.font;var view=ZatodChapterSelectorView.Create(template.transform.parent,font);var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(catalog);var account=campaign.CreateDemoCharacter(catalog);account.Level=80;
        var snapshot=new ZatodAccountSnapshot{Account=account,Cleared=campaign.Data.Chapters.SelectMany(ch=>ch.Stages).Select(s=>s.Id).ToList()};var rows=new List<object>();int failures=0,checkedButtons=0;
        try
        {
            view.Open(campaign,snapshot,campaign.Data.Chapters[0].Id,id=>{});Canvas.ForceUpdateCanvases();await Task.Delay(150);
            foreach(var button in view.ChapterButtons)
            {
                var rect=(RectTransform)button.transform;var point=RectTransformUtility.WorldToScreenPoint(null,rect.TransformPoint(rect.rect.center));
                if(point.x<0 || point.x>Screen.width || point.y<0 || point.y>Screen.height)continue;
                var eventData=new PointerEventData(EventSystem.current){position=point};var hits=new List<RaycastResult>();EventSystem.current.RaycastAll(eventData,hits);var first=hits.FirstOrDefault();var actual=first.gameObject?.GetComponentInParent<UnityEngine.UI.Button>();bool correct=actual==button;if(!correct)failures++;checkedButtons++;
                rows.Add(new{Expected=button.name,Actual=actual?.name,First=first.gameObject?.name,Hits=hits.Count,Correct=correct,X=point.x,Y=point.y});
            }
            var result=new{State=failures==0?"PASS":"FAIL",Checked=checkedButtons,Failures=failures,Rows=rows};File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        finally{view.Hide();UnityEngine.Object.Destroy(view.gameObject);}
    }
}
