using System;
using System.Linq;
using System.Collections.Generic;
using Zatod.Heroes;
using Zatod.Combat;
static partial class Program
{
    static void D38PolicyChecks()
    {
        var heroes=ImportedCatalog(RuntimeData);var campaign=new CampaignCatalog(Read<CampaignDefinition>(System.IO.Path.Combine(RuntimeData,"Campaigns.txt")),heroes);
        int[] gates={1,5,8,16,26,36,46,56};
        Check(campaign.Data.Chapters.Count==8,"D38 requires the active eight chapters");
        var stages=campaign.Data.Chapters.SelectMany(c=>c.Stages).ToArray();
        Check(stages.Count(s=>s.KeyStage)==55 && stages.Count(s=>!s.KeyStage)==99,"Source Key Stage classification");
        for(int n=0;n<8;n++)
        {
            var chapter=campaign.Data.Chapters[n];Check(chapter.RequiredAccountLevel==gates[n],"Account gate "+n);
            if(n==0){Check(campaign.ChapterLockReason(chapter.Id,1,Array.Empty<string>())==null,"Chapter one opens by default");continue;}
            var clear=new[]{campaign.Data.Chapters[n-1].Stages.Last().Id};
            string both=campaign.ChapterLockReason(chapter.Id,gates[n]-1,Array.Empty<string>());
            Check(both.Contains("Account Lv") && both.Contains("Complete"),"Both gate reasons");
            Check(campaign.ChapterLockReason(chapter.Id,gates[n],Array.Empty<string>()).Contains("Complete"),"Need previous chapter");
            Check(campaign.ChapterLockReason(chapter.Id,gates[n]-1,clear).Contains("Account Lv"),"Need account level");
            Check(campaign.ChapterLockReason(chapter.Id,gates[n],clear)==null,"Boundary opens chapter");
        }
        int lootCalls=0,persists=0;
        var session=new ZatodPlayerSession(heroes,campaign,Guid.NewGuid().ToString("D"),rollLoot:s=>{lootCalls++;return new List<string>();});
        var minor=campaign.Data.Chapters[0].Stages.First(s=>!s.KeyStage);var required=campaign.Prerequisite(minor.Id);
        if(required!=null)session.Run.AcceptValidated(required,true,3);
        Check(campaign.StageLockReason(minor.Id,session.Account.Level,session.Run.Stars.Keys)==null,"Minor initially open");
        session.Run.AcceptValidated(minor.Id,true,2);
        Check(campaign.StageLockReason(minor.Id,session.Account.Level,session.Run.Stars.Keys).Contains("Passed"),"Minor Passed reason");
        var before=System.Text.Json.JsonSerializer.Serialize(session.Account,new System.Text.Json.JsonSerializerOptions{IncludeFields=true});
        try{session.BeginCampaign(minor.Id,null,1,Guid.NewGuid().ToString("N"),()=>persists++);throw new Exception("Passed minor accepted");}catch(ArgumentException){}
        Check(lootCalls==0 && persists==0 && !session.CampaignInProgress,"Rejected minor allocates no battle or loot");
        Check(before==System.Text.Json.JsonSerializer.Serialize(session.Account,new System.Text.Json.JsonSerializerOptions{IncludeFields=true}),"Rejected minor preserves Owned");
        var key=campaign.Data.Chapters[0].Stages.First(s=>s.KeyStage);session.Run.AcceptValidated(key.Id,true,3);
        Check(campaign.StageLockReason(key.Id,1,session.Run.Stars.Keys)==null,"Key remains farmable");
        session.BeginCampaign(key.Id,null,1,Guid.NewGuid().ToString("N"));Check(lootCalls==1 && session.CampaignInProgress,"Replaying a key issues one battle");session.CancelCampaign();
        var fresh=new ZatodPlayerSession(heroes,campaign,Guid.NewGuid().ToString("D"),owned:session.Account);
        Check(fresh.Run.Stars.Count==0 && !fresh.CampaignInProgress,"Launch reset does not recover clears from Owned");
        Console.WriteLine("[D38Policy] PASS / "+checks+" assertions");
    }
}
