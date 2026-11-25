using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;
public static class D38AssetsAudit
{
    public static object Run(string output)
    {
        if(!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new InvalidOperationException("Use the isolated validation workspace");
        var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(catalog);var rows=new List<object>();var failures=new List<string>();
        foreach(var heroId in catalog.Data.Heroes.Select(h=>h.Id))
        {
            try
            {
                var member=catalog.CreateHero(heroId,"d38-preload-"+heroId);member.Level=60;member.Stars=3;
                while(member.RankId!="purple")
                {
                    foreach(var slot in HeroProgression.CurrentRank(member,catalog).EquipmentSlots)HeroProgression.Equip(member,catalog,slot.Id,slot.RequiredItemId);
                    HeroProgression.Promote(member,catalog);
                }
                foreach(var slot in member.Skills)slot.Level=60;
                var hero=new[]{member};
                var match=ZatodMatchFactory.Versus(catalog,hero,hero,117,"d38-preload-"+heroId,true);
                using(var assets=ZatodBattleAssets.Prepare(match))rows.Add(new{Hero=heroId,assets.Count,Effects=assets.Effects.Count,MissingAudio=assets.MissingAudio.ToArray()});
            }
            catch(Exception e){failures.Add(heroId+": "+e.Message);}
        }
        foreach(var chapter in campaign.Data.Chapters)
        {
            try
            {
                var account=campaign.CreateDemoCharacter(catalog);var match=ZatodMatchFactory.Campaign(campaign,catalog,account,chapter.Stages.Last().Id,account.HeroDesk.Select(h=>h.HeroInstanceId),117,"d38-chapter-"+chapter.Id);
                using(var assets=ZatodBattleAssets.Prepare(match))rows.Add(new{Chapter=chapter.Id,assets.Count,Effects=assets.Effects.Count});
            }
            catch(Exception e){failures.Add(chapter.Id+": "+e.Message);}
        }
        var report=new{State=failures.Count==0?"PASS":"FAIL",Rows=rows,Failures=failures};File.WriteAllText(output,Newtonsoft.Json.JsonConvert.SerializeObject(report,Newtonsoft.Json.Formatting.Indented));return report;
    }
}
