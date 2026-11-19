using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyCampaignSkills
{
    public static object Run()
    {
        int checks=0; void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(catalog);
        string config=JsonUtility.ToJson(catalog.Data);
        var starter=campaign.CreateDemoCharacter(catalog);string owned=JsonUtility.ToJson(starter);
        Check(starter.HeroDesk.All(h=>h.RankId=="purple" && HeroBattleFactory.Create(h,catalog).Skills.Count==4),"Campaign demo does not own full kits");
        Check(starter.HeroDesk.All(h=>h.AbsorbedItems.Count==catalog.RankPath(catalog.Hero(h.HeroDefinitionId),"purple").Take(3).Sum(r=>r.EquipmentSlots.Count)),"Demo promotion lost absorbed equipment");
        Check(campaign.Data.StarterHeroIds.All(id=>catalog.CreateHero(id,"new-"+id).RankId=="white"),"New Hero starting rank changed outside Campaign");
        var rows=new List<object>();
        foreach(string id in campaign.Data.StarterHeroIds)
        {
            foreach(var rank in new[]{("white",1),("green",2),("blue",3),("purple",4)})
            {
                var hero=HeroCombatSandbox.TemporaryHero(catalog,id,rank.Item1);
                Check(HeroBattleFactory.Create(hero,catalog).Skills.Count==rank.Item2,"Rank unlock: "+id+" / "+rank.Item1);
            }
            var data=HeroBattleFactory.Create(HeroCombatSandbox.TemporaryHero(catalog,id,"purple"),catalog);
            int range=data.Stats.Single(s=>s.StatId=="attack_range").Value;
            foreach(var skill in data.Skills)
            {
                if(skill.Definition.Kind==SkillKind.Active && skill.Definition.Target!=SkillTarget.Self)
                    Check(skill.Definition.CastRange>=range,"Skill cannot reach from normal attack position: "+id+" / "+skill.SlotId);
                var settings=new HeroSandboxSettings{HeroId=id,RankId="purple",Mode=SandboxTestMode.SingleSkill,
                    SkillSlotId=skill.SlotId,DurationSeconds=35,StartingEnergy=100,HpPercent=50,
                    TargetDistance=Math.Max(0,Math.Min(range,skill.Definition.CastRange)-300),TargetSpacing=100,TargetHp=500000,
                    MonsterIds=Enumerable.Repeat("fighter_goblin",3).ToList()};
                var setup=HeroCombatSandbox.Prepare(catalog,settings);
                foreach(var f in setup.Fighters.Where(f=>f.team==1)){f.range=0;f.moveSpeed=1;f.attack=1;}
                foreach(var loadout in setup.Loadouts.Where(l=>l.kind==CombatantKind.Monster))
                {loadout.disableBasicAttacks=true;loadout.Data.Skills.Clear();}
                if(skill.Definition.Activation==SkillActivation.OnDeath)
                {
                    // A death-triggered passive is not an automatic active cast.
                    setup.Fighters[0].hp=1;
                    var enemy=setup.Fighters.First(f=>f.team==1);enemy.x=setup.Fighters[0].x+100;enemy.range=10000;
                    enemy.attack=10000;enemy.attackInterval=20;
                    var loadout=setup.Loadouts.First(l=>l.fighterId==enemy.id);loadout.disableBasicAttacks=false;
                    loadout.Data.HasNormalAttack=false;
                }
                var record=setup.Run();
                if(skill.Definition.Activation==SkillActivation.OnDeath)
                    Check(record.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Revive),"Passive did not revive: "+id);
                else
                {
                    Check(record.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.ability.StartsWith(skill.Definition.Name)),"No skill cast: "+id+" / "+skill.SlotId);
                    Check(record.events.Any(e=>e.actorId==1 && (e.kind==BattleEventKind.Damage || e.kind==BattleEventKind.Heal || e.kind==BattleEventKind.Buff || e.kind==BattleEventKind.Stun) && e.ability.StartsWith(skill.Definition.Name)),"No skill effect: "+id+" / "+skill.SlotId);
                }
                var restored=ReplayArchive.Decode(ReplayArchive.Encode(record));
                Check(restored.events.Count==record.events.Count,"Skill replay changed: "+id+" / "+skill.SlotId);
                rows.Add(new{hero=id,slot=skill.SlotId,range=skill.Definition.CastRange,normalRange=range,cast=true});
            }
        }
        // Preserve the exact Campaign formation while unlocking skills on detached test Heroes.
        var purple=campaign.CreateDemoCharacter(catalog);
        purple.HeroDesk=campaign.Data.StarterHeroIds.Take(5).Select(id=>HeroCombatSandbox.TemporaryHero(catalog,id,"purple")).ToList();
        var team=CampaignBattleFactory.Prepare(campaign,catalog,purple,"chapter_1_stage_1",purple.HeroDesk.Select(h=>h.HeroInstanceId));
        foreach(var f in team.Fighters)
        {
            f.maxHp=500000;f.hp=f.team==0?250000:500000;f.energy=100;
            if(f.team==1)f.attack=1;
        }
        var sim=new BattleSimulation(Guid.NewGuid().ToString("N"),"Campaign full kit audit",123,team.Fighters,team.Loadouts,900,manualUltimateTeams:1);
        foreach(var f in team.Fighters.Where(f=>f.team==0))Check(sim.RequestUltimate(f.id),"Manual ultimate refused: "+f.name);
        var full=sim.RunToCompletion();
        Directory.CreateDirectory("../Artifacts/CampaignSkillAudit");
        File.WriteAllBytes("../Artifacts/CampaignSkillAudit/purple-five.arena.gz",ReplayArchive.Encode(full));
        File.WriteAllText("../Artifacts/CampaignSkillAudit/full-team.json",Newtonsoft.Json.JsonConvert.SerializeObject(full.loadouts.Where(l=>l.kind==CombatantKind.Hero).Select(l=>new{hero=l.hero.HeroDefinitionId,cast=full.events.Where(e=>e.actorId==l.fighterId && e.kind==BattleEventKind.Action).Select(e=>e.ability).Distinct().ToArray()}),Newtonsoft.Json.Formatting.Indented));
        foreach(var loadout in full.loadouts.Where(l=>l.kind==CombatantKind.Hero))
            foreach(var skill in loadout.hero.Skills.Where(s=>s.Definition.Kind==SkillKind.Active))
                Check(full.events.Any(e=>e.actorId==loadout.fighterId && e.kind==BattleEventKind.Action && e.ability.StartsWith(skill.Definition.Name)),"Five-Hero formation did not cast: "+loadout.hero.HeroDefinitionId+" / "+skill.SlotId);
        Check(full.events.First(e=>e.actorId==4 && e.kind==BattleEventKind.Action).state.animationState=="Skill3","Enchantx opening did not use Skill3");
        Check(full.events.Any(e=>e.actorId==5 && e.kind==BattleEventKind.Damage && e.ability==catalog.Skill("lilina_skill2").Name),"Lilina bolt did not reach full-team rear targets");
        Check(JsonUtility.ToJson(catalog.Data)==config && JsonUtility.ToJson(starter)==owned,"Audit changed config or owned data");
        Directory.CreateDirectory("../Artifacts/CampaignSkillAudit");
        File.WriteAllBytes("../Artifacts/CampaignSkillAudit/purple-five.arena.gz",ReplayArchive.Encode(full));
        File.WriteAllText("../Artifacts/CampaignSkillAudit/skills.json",Newtonsoft.Json.JsonConvert.SerializeObject(rows,Newtonsoft.Json.Formatting.Indented));
        return new{passed=true,checks,heroes=campaign.Data.StarterHeroIds.Count,skills=rows.Count,rankUnlocks=true,fullTeamActiveSkills=true};
    }
}
