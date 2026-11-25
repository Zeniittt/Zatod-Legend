using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEngine;
using Zatod.Heroes;
using Zatod.Combat;
using Zatod.Networking;

public static class D34ContentSchema
{
    public static object Run(string report)
    {
        if(!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new InvalidOperationException("Use the isolated validation workspace.");
        int checks=0;void Check(bool value,string why){checks++;if(!value)throw new InvalidDataException(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();
        Check(catalog.Data.Heroes.Count==66 && catalog.FreePvp.HeroIds.Count==40,"Unexpected D34 roster");
        Check(catalog.Data.Skills.Where(s=>s.Crystal.NativeForm?.Enabled==true).Select(s=>s.Crystal.SourceId).OrderBy(x=>x).SequenceEqual(new[]{470,610,810,1220}),"Only the four reviewed native Hero forms should be enabled");
        var copy=HeroDataJson.ReadDocuments(HeroDataJson.WriteDocuments(catalog.Data));
        var nativeDigests=new System.Collections.Generic.Dictionary<string,string>();
        Check(catalog.Data.UseExpandedCombatRules && copy.Data.UseExpandedCombatRules,"JsonUtility lost the explicit V7 catalog flag");
        var starter=ZatodMatchFactory.Versus(copy,new[]{copy.CreateHero("coco","starter-left")},new[]{copy.CreateHero("dr","starter-right")},117,"schema-starter",false);
        Check(starter.RulesVersion==ZatodMatchDefinition.ExpandedRulesV7,"Fresh starter matches must also select V7");
        Check(copy.Data.Skills.Count(s=>s.Crystal.NativeForm?.Enabled==true)==4,"JsonUtility lost or invented an enabled form");
        foreach(string id in copy.FreePvp.HeroIds)
        {
            var hero=copy.FreePvp.CreatePreset(id);
            Check(hero.Level==60 && hero.Stars==3 && hero.RankId=="purple" && hero.EquippedItems.Count==0,"Incorrect free PvP preset: "+id);
            Check(hero.Skills.Count==4 && hero.Skills.All(s=>s.Level==60),"Incorrect free PvP skill levels: "+id);
            var match=ZatodMatchFactory.Versus(copy,new[]{hero},new[]{copy.FreePvp.CreatePreset("coco")},117,"schema-"+id,true);
            var restored=JsonUtility.FromJson<ZatodMatchDefinition>(JsonUtility.ToJson(match));
            var a=new ZatodBattleSimulation(match);var b=new ZatodBattleSimulation(restored);
            for(int i=0;i<96;i++){a.Step();b.Step();}
            Check(a.Replay().Digest==b.Replay().Digest,"Unity snapshot drift: "+id);
            nativeDigests.Add(id,a.Replay().Digest.ToString(System.Globalization.CultureInfo.InvariantCulture));
        }
        var sample=ZatodMatchFactory.Versus(copy,copy.FreePvp.Team(new[]{"kotl","luna","od","cm","sil"}),copy.FreePvp.Team(new[]{"lich","vs","pom","huskar","naga"}),27,"schema-archive",false);
        var sim=new ZatodBattleSimulation(sample);for(int i=0;i<240;i++)sim.Step();
        var record=sim.Replay();var flags=BindingFlags.Static|BindingFlags.NonPublic;
        var encoded=(byte[])typeof(ReplayArchive).GetMethod("EncodePayload",flags).Invoke(null,new object[]{record});
        var decoded=(ZatodReplay)typeof(ReplayArchive).GetMethod("DecodePayload",flags).MakeGenericMethod(typeof(ZatodReplay)).Invoke(null,new object[]{encoded});
        Check(ZatodBattleSimulation.Resimulate(decoded).Digest==record.Digest,"Actual gzip/JsonUtility replay archive drift");
        var result=new{State="PASS",Checks=checks,Heroes=copy.Data.Heroes.Count,FreePvp=copy.FreePvp.HeroIds.Count,ArchiveBytes=encoded.Length,NativeDigests=nativeDigests};
        File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
}
