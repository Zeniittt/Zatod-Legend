using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEngine;
using Zatod.Networking;
using Zatod.Combat;
public static class VerifyZatodStatisticsArchives
{
    public static object Run()
    {
        var decode=typeof(ReplayArchive).GetMethod("DecodePayload",BindingFlags.Static|BindingFlags.NonPublic).MakeGenericMethod(typeof(ZatodReplay));int checkedCount=0,skipped=0;
        foreach(string path in Directory.GetFiles(Path.GetFullPath("../Artifacts/ZatodServer"),"*.gz").Where(p=>p.EndsWith(".zatod.gz")||p.EndsWith(".crystal.gz")))
        {
            var saved=(ZatodReplay)decode.Invoke(null,new object[]{File.ReadAllBytes(path)});if(!ZatodMatchDefinition.SupportedRules(saved.Initial.RulesVersion)){skipped++;continue;}
            var replay=ZatodBattleSimulation.Resimulate(saved);
            if(replay.Digest!=saved.Digest || replay.Winner!=saved.Winner || replay.Stars!=saved.Stars || replay.EndTick!=saved.EndTick)throw new Exception("Historical replay changed: "+Path.GetFileName(path));
            if(replay.Statistics.Count<saved.Initial.Players.Count || replay.Statistics.Any(s=>double.IsNaN(s.DamageDealt)||double.IsInfinity(s.DamageDealt)))throw new Exception("Historical statistics invalid: "+Path.GetFileName(path));checkedCount++;
        }
        var result=new{Result="PASS",ArchivesChecked=checkedCount,UnsupportedLegacySkipped=skipped};
        File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodBattleResultChecks/archive-regression.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
}
