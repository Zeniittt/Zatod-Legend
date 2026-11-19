using System;
using System.Linq;
using System.IO;
using System.Collections.Generic;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.Editor;
using Zatod.Combat;
// DTO fields below are populated by System.Text.Json.
#pragma warning disable CS0649
static class Program
{
    static int checks;
    static void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
    static void Reject(Action action,string why){bool rejected=false;try{action();}catch(ArgumentException){rejected=true;}Check(rejected,why);}
    static void Main()
    {
        try { Inventory(); ImportedData(); CrystalBattles(); Sessions(); SourceCombatRules(); PresentationMotion(); Console.WriteLine("[CrystalChecks] PASS / "+checks+" assertions"); }
        catch(Exception error) { Console.Error.WriteLine(error.ToString());Environment.ExitCode=1; }
    }
    sealed class Oracle { public List<OracleRow> Rows; }
    sealed class OracleRow { public string HeroId,RankId; public int Stars,Level; public bool Equipped; public List<StatAmount> Expected; }
    static readonly JsonSerializerOptions Json = new JsonSerializerOptions { IncludeFields=true,IgnoreReadOnlyProperties=true };
    static T Read<T>(string path) => JsonSerializer.Deserialize<T>(File.ReadAllText(path),Json);
    static HeroCatalog ImportedCatalog()
    {
        const string root="Unity/Assets/Zatod/Resources/Data/";
        var data=new HeroCatalogData{ConfigVersion=Read<StatsConfigData>(root+"Stats.txt").ConfigVersion,
            Stats=Read<StatsConfigData>(root+"Stats.txt").Stats,Items=Read<ItemsConfigData>(root+"Items.txt").Items,
            Skills=Read<SkillsConfigData>(root+"Skills.txt").Skills,Heroes=Read<HeroesConfigData>(root+"Heroes.txt").Heroes,
            Monsters=Read<MonstersConfigData>(root+"Monsters.txt").Monsters,Buffs=Read<BuffsConfigData>(root+"Buffs.txt").Buffs};
        return new HeroCatalog(data);
    }
    static void ImportedData()
    {
        var catalog=ImportedCatalog();
        Check(catalog.Data.Heroes.Count(x=>x.SourceUnitId>0)==16,"Crystal Hero coverage");
        Check(catalog.Data.Monsters.Count(x=>x.SourceUnitId>0)==10,"Crystal Monster coverage");
        Check(catalog.Data.Items.Count(x=>x.DefinitionId.StartsWith("crystal_"))==67,"Crystal equipment coverage");
        var oracle=Read<Oracle>("Artifacts/CrystalPhaseChecks/stat-oracle.json");
        foreach(var expected in oracle.Rows)
        {
            var hero=catalog.CreateHero(expected.HeroId,"oracle");hero.Level=expected.Level;hero.Stars=expected.Stars;
            void Fill(){foreach(var slot in HeroProgression.CurrentRank(hero,catalog).EquipmentSlots)HeroProgression.Equip(hero,catalog,slot.Id,slot.RequiredItemId);}
            while(hero.RankId!=expected.RankId){Fill();HeroProgression.Promote(hero,catalog);}
            if(expected.Equipped)Fill();
            var actual=HeroStatCalculator.Calculate(hero,catalog);
            foreach(var stat in expected.Expected)
                Check(Math.Abs(actual.PreciseStats.Single(s=>s.StatId==stat.StatId).Value-stat.Value)<.000001,"Source stat mismatch: "+expected.HeroId+"/"+expected.RankId+"/"+stat.StatId);
            var battle=HeroBattleFactory.Create(hero,catalog);
            var original=catalog.Skill(catalog.Hero(hero.HeroDefinitionId).NormalAttackSkillId).Crystal;
            double time=original.Phases[0].AttackTimes[0];battle.NormalAttack.Crystal.Phases[0].AttackTimes[0]+=1;
            Check(original.Phases[0].AttackTimes[0]==time,"Crystal timing snapshot shares mutable config");
        }
        var campaign=new CampaignCatalog(Read<CampaignDefinition>("Unity/Assets/Zatod/Resources/Data/CrystalCampaigns.txt"),catalog);
        Check(campaign.Data.Chapters.Single().Stages.Count==18 && campaign.Data.Chapters.Single().Stages.Sum(x=>x.Waves.Count)==54,"Chapter wave coverage");
        var run=new CampaignRun(campaign);Check(run.IsUnlocked("crystal_stage_1")&&!run.IsUnlocked("crystal_stage_2"),"New run unlock state");
        run.AcceptValidated("crystal_stage_1",true,3);Check(run.IsUnlocked("crystal_stage_2"),"Validated clear did not unlock next stage");
        Check(!new CampaignRun(campaign).IsUnlocked("crystal_stage_2"),"New run restored old progress");
    }
    static void CrystalBattles()
    {
        var catalog=ImportedCatalog();var campaign=new CampaignCatalog(Read<CampaignDefinition>("Unity/Assets/Zatod/Resources/Data/CrystalCampaigns.txt"),catalog);
        var account=campaign.CreateDemoCharacter(catalog);foreach(var hero in account.HeroDesk)hero.Level=40;
        foreach(var stage in campaign.Data.Chapters[0].Stages)
        {
            var match=CrystalMatchFactory.Campaign(campaign,catalog,account,stage.Id,account.HeroDesk.Select(h=>h.HeroInstanceId),17,stage.Id);
            var battle=new CrystalBattleSimulation(match);
            int budget=3000;
            while(!battle.Finished && budget-->0)
            {
                foreach(var unit in battle.Frame().Units.Where(u=>u.Team==0 && u.Alive))battle.RequestUltimate(unit.EntityId);
                battle.Step();
            }
            Check(battle.Finished,"Crystal battle never terminated");
            var replay=battle.Replay();
            Check(replay.Winner==0 && battle.WaveIndex==3,"High-level test team did not clear all 3 waves: "+stage.Id);
            var repeated=CrystalBattleSimulation.Resimulate(replay);
            Check(repeated.Digest==replay.Digest && repeated.Winner==replay.Winner && repeated.EndTick==replay.EndTick,"Crystal replay diverged");
            Check(CrystalBattleSimulation.Validate(match,replay.Inputs,replay.EndTick,replay.Winner,replay.Stars,replay.Digest),"Legitimate battle rejected");
            Check(!CrystalBattleSimulation.Validate(match,replay.Inputs,replay.EndTick,1-replay.Winner,replay.Stars,replay.Digest),"Tampered result accepted");
        }
        foreach(var definition in catalog.Data.Heroes.Where(h=>h.SourceUnitId>0))
        {
            var hero=catalog.CreateHero(definition.Id,"all-blue-"+definition.Id);hero.Level=40;
            while(hero.RankId!="blue")
            {foreach(var slot in HeroProgression.CurrentRank(hero,catalog).EquipmentSlots)HeroProgression.Equip(hero,catalog,slot.Id,slot.RequiredItemId);HeroProgression.Promote(hero,catalog);}
            foreach(var slot in HeroProgression.CurrentRank(hero,catalog).EquipmentSlots)HeroProgression.Equip(hero,catalog,slot.Id,slot.RequiredItemId);
            var blueMatch=CrystalMatchFactory.Versus(catalog,new[]{hero},account.HeroDesk,87,"blue-"+definition.Id,false);
            var blue=new CrystalBattleSimulation(blueMatch).RunToCompletion();
            Check(blue.Completed,"Imported blue Hero battle did not terminate: "+definition.Id);
            Check(CrystalBattleSimulation.Resimulate(blue).Digest==blue.Digest,"Imported blue Hero replay diverged: "+definition.Id);
        }
        var match1=CrystalMatchFactory.Versus(catalog,account.HeroDesk,account.HeroDesk,42,"arena",false);
        var auto=new CrystalBattleSimulation(match1).RunToCompletion();
        Check(CrystalBattleSimulation.Resimulate(auto).Digest==auto.Digest,"Automatic Arena replay changed");
        var partial=new CrystalBattleSimulation(match1);partial.Step();var frame=partial.Frame();
        Check(!CrystalBattleSimulation.Validate(match1,Array.Empty<CrystalInput>(),1,frame.Winner,frame.Stars,frame.Digest),"Incomplete match accepted as finished");
    }
    static void Sessions()
    {
        var catalog=ImportedCatalog();var campaign=new CampaignCatalog(Read<CampaignDefinition>("Unity/Assets/Zatod/Resources/Data/CrystalCampaigns.txt"),catalog);
        var session=new CrystalPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"));
        Reject(()=>session.BeginCampaign("crystal_stage_2",null,3,"locked"),"Locked stage was issued");
        foreach(var hero in session.Account.HeroDesk)session.DevLevel(hero.HeroInstanceId,40);
        var match=session.BeginCampaign("crystal_stage_1",null,5,"issued");
        Reject(()=>session.DevItem("crystal_item_108",1),"Item changed during an issued battle");
        var battle=new CrystalBattleSimulation(match);
        while(!battle.Finished){foreach(var actor in battle.Frame().Units.Where(u=>u.Team==0 && u.Alive))battle.RequestUltimate(actor.EntityId);battle.Step();}
        var claim=battle.Replay();int stars=claim.Stars;claim.Stars=3-stars;
        Reject(()=>session.ValidateCampaign(claim),"Tampered claim was accepted");claim.Stars=stars;
        var accepted=session.ValidateCampaign(claim);
        Check(accepted.Digest==claim.Digest && session.Run.IsUnlocked("crystal_stage_2"),"Valid claim did not unlock next stage");
        Reject(()=>session.ValidateCampaign(claim),"Consumed battle was accepted a second time");
        var nextLaunch=new CrystalPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"));
        Check(!nextLaunch.Run.IsUnlocked("crystal_stage_2"),"A new launch retained campaign progress");
        session.DevItem("crystal_item_108",2);string retainedGuid=session.Account.Inventory[0].Id;
        var ownedAgain=new CrystalPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),session.Account);
        Check(ownedAgain.Account.Inventory.Any(x=>x.Id==retainedGuid) && ownedAgain.Account.HeroDesk.All(h=>h.Level==40),"New launch reset owned Hero/items");
        Check(!ownedAgain.Run.IsUnlocked("crystal_stage_2"),"Owned save restored campaign progress");

    }
    static CrystalMatchDefinition Fixture(string type="AD",double amount=100,double defense=0,double speed=0,double haste=0,int enemies=1)
    {
        CrystalUnitData Unit(int id,int team)
        {
            var info=new CrystalSkillDefinition{SourceId=id+10,ActiveType="active",TargetType="target",AffectedCamp=-1,TargetCamp=-1,DamageType=type,BasicAmount=amount,MaxRange=9999,Cooldown=1000,GlobalCooldown=1000,CritPercent=100,Phases=new List<CrystalActionPhase>{new CrystalActionPhase{Action="Attack",Duration=.5,AttackTimes=new List<double>{.25}}}};
            var data=new CrystalUnitData{EntityId=id,Team=team,Level=1,DefinitionId="fixture",Battle=new CombatantBattleData{HasNormalAttack=team==0,NormalAttack=team==0?new SkillDefinition{Id="fixture_skill",Crystal=info}:null,PreciseStats=new List<StatAmount>{new StatAmount{StatId="health",Value=10000},new StatAmount{StatId="defense",Value=defense},new StatAmount{StatId="magic_resistance",Value=defense},new StatAmount{StatId="action_speed",Value=speed},new StatAmount{StatId="haste",Value=haste}}}};
            return data;
        }
        return new CrystalMatchDefinition{BattleId="fixture",Mode=CrystalMode.Arena,Seed=7,Players=new List<CrystalUnitData>{Unit(1,0)},Waves=new List<CrystalWaveData>{new CrystalWaveData{Enemies=Enumerable.Range(101,enemies).Select(id=>Unit(id,1)).ToList()}}};
    }
    static void SourceCombatRules()
    {
        foreach(var pair in new[]{("AD",12.5,50d),("AP",25d,25d),("Holy",999d,100d)})
        {
            var battle=new CrystalBattleSimulation(Fixture(pair.Item1,100,pair.Item2));battle.Step();battle.Step();
            Check(battle.Frame().Units.Single(x=>x.Team==1).Hp==10000,"Damage happened before the .25s release marker");battle.Step();
            Check(Math.Abs(battle.Frame().Units.Single(x=>x.Team==1).Hp-(10000-pair.Item3))<1e-8,"Source damage formula changed: "+pair.Item1);
        }
        var energy=Fixture("Holy");energy.EnergyGainMultiplier=1.5;energy.Waves[0].Enemies[0].Battle.PreciseStats.Add(new StatAmount{StatId="damage_energy_rate",Value=1200});
        var charged=new CrystalBattleSimulation(energy);for(int i=0;i<3;i++)charged.Step();
        Check(Math.Abs(charged.Frame().Units.Single(u=>u.Team==1).Energy-18)<1e-8,"Per-unit damage energy rate/stage multiplier changed");
        foreach(int resistance in new[]{0,100})
        {
            var kill=Fixture("Holy",20000);kill.Players[0].Hero=true;kill.Waves[0].Enemies[0].Battle.PreciseStats.Add(new StatAmount{StatId="kill_energy",Value=resistance});
            var killer=new CrystalBattleSimulation(kill);for(int i=0;i<3;i++)killer.Step();
            Check(killer.Frame().Units.Single(u=>u.Team==0).Energy==(resistance==0?300:150),"Kill energy/KMPR rule changed");
        }
        var movement=Fixture();var mover=movement.Players[0].Copy();mover.EntityId=2;mover.Battle.HasNormalAttack=false;mover.Battle.NormalAttack=null;mover.Battle.PreciseStats.Add(new StatAmount{StatId="move_speed",Value=1000});movement.Players.Add(mover);
        var ground=new CrystalBattleSimulation(movement);ground.Step();
        Check(ground.Frame().Units.Single(u=>u.EntityId==2).Y> -40,"Ground movement ignored depth direction");
        var contact=Fixture("Holy",100,0,0,0,2);contact.Waves[0].Enemies[0].Battle.PreciseStats.Add(new StatAmount{StatId="attack_range",Value=10000});
        var bolt=contact.Players[0].Battle.NormalAttack.Crystal;bolt.TrackType="projectile";bolt.ProjectileSpeed=8000;bolt.AimTarget=true;
        var swept=new CrystalBattleSimulation(contact);for(int i=0;i<4;i++)swept.Step();
        Check(swept.Frame().Units.Single(u=>u.EntityId==102).Hp==9900 && swept.Frame().Units.Single(u=>u.EntityId==101).Hp==10000,"Projectile picked entity ID before first swept contact");
        var heal=Fixture("Heal");heal.Players[0].InitialHealth=5000;var healInfo=heal.Players[0].Battle.NormalAttack.Crystal;healInfo.TargetType="self";healInfo.TargetCamp=1;healInfo.AffectedCamp=1;
        heal.Players[0].Battle.PreciseStats.AddRange(new[]{new StatAmount{StatId="healing_bonus",Value=25},new StatAmount{StatId="heal_ratio",Value=20},new StatAmount{StatId="pdm",Value=1.2}});
        var healed=new CrystalBattleSimulation(heal);for(int i=0;i<3;i++)healed.Step();Check(Math.Abs(healed.Frame().Units.Single(u=>u.Team==0).Hp-5180)<1e-8,"Source caster HEAL/PDM and receiver HealRatio were not composed exactly once");
        var scaled=Fixture("Holy");scaled.Players[0].DamageMultiplier=1.5;var scaledBattle=new CrystalBattleSimulation(scaled);for(int i=0;i<3;i++)scaledBattle.Step();Check(scaledBattle.Frame().Units.Single(u=>u.Team==1).Hp==9850,"Encounter DPS multiplier did not include the flat skill amount");
        var quick=new CrystalBattleSimulation(Fixture("Holy",100,0,100));quick.Step();quick.Step();
        Check(quick.Frame().Units.Single(x=>x.Team==1).Hp==9900,"MSPD did not speed the release marker with animation");
        var haste=new CrystalBattleSimulation(Fixture("Holy",100,0,0,100));haste.Step();haste.Step();
        Check(haste.Frame().Units.Single(x=>x.Team==1).Hp==10000,"HAST incorrectly sped up the cast marker");
        var metadata=Fixture("Holy",100,0,0,0,3);metadata.Players[0].Battle.NormalAttack.Crystal.TrackType="chain";metadata.Players[0].Battle.NormalAttack.Crystal.ChainJumps=2;metadata.Players[0].Battle.NormalAttack.Crystal.ChainGap=.5;
        var chain=new CrystalBattleSimulation(metadata);for(int i=0;i<3;i++)chain.Step();
        Check(chain.Frame().Units.Count(x=>x.Team==1 && x.Hp<10000)==1,"Chain applied later jumps at release");
        for(int i=0;i<3;i++)chain.Step();Check(chain.Frame().Units.Count(x=>x.Team==1 && x.Hp<10000)==1,"Chain ignored its .5s gap");chain.Step();
        Check(chain.Frame().Units.Count(x=>x.Team==1 && x.Hp<10000)==2,"Chain did not jump after source gap");
        Check(ImportedCatalog().Data.Buffs.Where(b=>b.SourceId==10000101).Single().Control=="stun","Lua control list was serialized as a dictionary string");
        var slow=Fixture("Holy");slow.Buffs=ImportedCatalog().Data.Buffs;var slowInfo=slow.Players[0].Battle.NormalAttack.Crystal;slowInfo.SourceId=103;slowInfo.BuffId=10001002;
        slow.Players[0].Battle.PreciseStats.Add(new StatAmount{StatId="damage",Value=200});slow.Waves[0].Enemies[0].Battle.PreciseStats.Add(new StatAmount{StatId="damage",Value=100});
        var slowed=new CrystalBattleSimulation(slow);for(int i=0;i<3;i++)slowed.Step();double slowedSpeed=slowed.Frame().Units.Single(x=>x.Team==1).ActionSpeed;
        Check(Math.Abs(slowedSpeed-100d/276)<1e-8,"Agreed Sniper AD ratio coefficient was not applied");slowed.Step();
        Check(slowed.Frame().Units.Single(x=>x.Team==1).ActionSpeed>slowedSpeed,"Sniper slow did not decay over time");
        var barrage=Fixture();var arrows=barrage.Players[0].Battle.NormalAttack.Crystal;arrows.SourceId=20;arrows.TrackType="projectile";arrows.ProjectileSpeed=300;arrows.ProjectileZSpeed=600;arrows.Gravity=-1350;arrows.ScriptArgs=new List<double>{1,25};
        var rain=new CrystalBattleSimulation(barrage);for(int i=0;i<3;i++)rain.Step();Check(rain.Frame().Visuals.Count(x=>x.Kind=="projectile")==5,"DR source barrage did not emit its capped arrow count");
        var blink=Fixture("Holy");blink.Buffs=ImportedCatalog().Data.Buffs;var blinkInfo=blink.Players[0].Battle.NormalAttack.Crystal;blinkInfo.SourceId=73;blinkInfo.AoeOrigin="self";blinkInfo.AoeShape="circle";blinkInfo.ShapeArg1=130;blinkInfo.Phases[0].AttackTimes=new List<double>{.125,.25,.375};
        var queen=new CrystalBattleSimulation(blink);queen.Step();queen.Step();
        Check(queen.Frame().Units.Single(x=>x.Team==0).X>500 && queen.Frame().Units.Single(x=>x.Team==1).Hp==10000,"QOP first marker did not blink without damage");queen.Step();
        Check(queen.Frame().Units.Single(x=>x.Team==1).Hp==9900,"QOP middle marker did not deal its AoE");queen.Step();
        Check(queen.Frame().Units.Single(x=>x.Team==0).X==0,"QOP last marker did not return to original position");
        var pulse=Fixture("AP");var pulseInfo=pulse.Players[0].Battle.NormalAttack.Crystal;pulseInfo.SourceId=202;pulseInfo.TrackType="projectile";pulseInfo.AffectedCamp=0;pulseInfo.ProjectileSpeed=8000;pulseInfo.AimTarget=true;
        pulse.Players[0].InitialHealth=5000;var friend=pulse.Players[0].Copy();friend.EntityId=2;friend.Battle.HasNormalAttack=false;friend.Battle.NormalAttack=null;pulse.Players.Add(friend);
        pulse.Players[0].Battle.PreciseStats.Add(new StatAmount{StatId="healing_bonus",Value=25});
        var necro=new CrystalBattleSimulation(pulse);for(int i=0;i<3;i++)necro.Step();Check(necro.Frame().Units.Single(x=>x.EntityId==1).Hp==5125,"NEC pulse did not heal its caster immediately");necro.Step();
        Check(necro.Frame().Units.Single(x=>x.EntityId==2).Hp==5125,"NEC pulse did not heal a nearby ally through its own projectile");

    }
    static void PresentationMotion()
    {
        var definition=Fixture();var mover=definition.Players[0];mover.Battle.HasNormalAttack=false;mover.Battle.NormalAttack=null;
        mover.Battle.PreciseStats.Add(new StatAmount{StatId="move_speed",Value=1000});
        var walked=new CrystalBattleSimulation(definition);var untouched=new CrystalBattleSimulation(definition);
        walked.Step();untouched.Step();var frame=walked.Frame();var actor=frame.Units.Single(u=>u.Team==0);
        actor.Motion.Project(actor.X,actor.Y,actor.Height,.02,out double x1,out _,out _);
        actor.Motion.Project(actor.X,actor.Y,actor.Height,.08,out double x2,out _,out _);
        Check(x2>x1 && Math.Abs((x2-x1)-6)<1e-8,"Walking presentation did not advance at source speed between ticks");
        actor.Motion.Project(actor.X,actor.Y,actor.Height,1,out double capped,out _,out _);
        Check(Math.Abs(capped-(actor.X+12.5))<1e-8,"Presentation extrapolated beyond one uncommitted tick");
        actor.Motion.Project(actor.X,actor.Y,actor.Height,0,out double paused,out _,out _);
        Check(paused==actor.X,"Paused/seek presentation drifted");
        actor.X=-9000;actor.Motion.VX=-10000;
        Check(walked.Frame().Digest==untouched.Frame().Digest,"Presentation snapshot mutated the combat model");
        for(int tick=0;tick<20;tick++)
        {
            for(int sample=0;sample<12;sample++)walked.Frame();
            walked.Step();untouched.Step();
            Check(walked.Frame().Digest==untouched.Frame().Digest,"Render sample frequency changed simulation/digest");
        }
        var projectile=Fixture();var info=projectile.Players[0].Battle.NormalAttack.Crystal;
        info.TrackType="projectile";info.ProjectileSpeed=300;info.ProjectileZSpeed=200;info.Gravity=-100;
        var flying=new CrystalBattleSimulation(projectile);for(int i=0;i<3;i++)flying.Step();
        var shot=flying.Frame().Visuals.Single(v=>v.Kind=="projectile");
        shot.Motion.Project(shot.X,shot.Y,shot.Height,.02,out x1,out _,out double h1);
        shot.Motion.Project(shot.X,shot.Y,shot.Height,.08,out x2,out _,out double h2);
        Check(Math.Abs(x2-x1-18)<1e-8 && h2>h1,"Projectile position/height did not advance between ticks");
        ulong digest=flying.Frame().Digest;shot.X=-999;shot.Motion.VX=0;
        Check(flying.Frame().Digest==digest,"Projectile presentation mutated combat");
        var frozen=Fixture();var basic=frozen.Players[0].Battle.NormalAttack;frozen.Players[0].Hero=true;frozen.Mode=CrystalMode.Campaign;
        frozen.Players[0].Battle.Skills.Add(new BattleSkillData{SlotId="ultimate",IsUltimate=true,Level=1,Definition=basic.Copy()});
        frozen.Players[0].InitialEnergy=1000;frozen.Players[0].Battle.Skills[0].Definition.Crystal.CostEnergy=1000;
        var freezing=new CrystalBattleSimulation(frozen);Check(freezing.RequestUltimate(1),"Freeze motion fixture could not request ultimate");freezing.Step();
        Check(freezing.Frame().Units.Single(u=>u.Team==1).Motion.VX==0 && freezing.Frame().Units.Single(u=>u.Team==1).ActionSpeed==0,"Manual ultimate freeze did not stop enemy presentation");
        // Fixed pre-change recordings verify that added render metadata does not change combat.
        const string archiveRoot="Artifacts/CrystalPhaseChecks/network-20261119-185731/Server";
        foreach(string path in Directory.GetFiles(archiveRoot,"*.crystal.gz"))
        {
            using var input=File.OpenRead(path);using var gzip=new System.IO.Compression.GZipStream(input,System.IO.Compression.CompressionMode.Decompress);
            var old=JsonSerializer.Deserialize<CrystalReplay>(gzip,Json);var repeated=CrystalBattleSimulation.Resimulate(old);
            Check(old.Digest==repeated.Digest && old.Winner==repeated.Winner && old.EndTick==repeated.EndTick,"Presentation change altered a pre-change archive: "+Path.GetFileName(path));
        }
    }
    static void Inventory()
    {
        var data=HeroCatalogSample.Create();
        var catalog=new HeroCatalog(data);
        var account=new CharacterData{CharacterId="test"};
        var hero=catalog.CreateHero("training_warrior","hero");account.HeroDesk.Add(hero);
        var inventory=new ItemInventory(account,catalog);
        var added=inventory.AddItemByItemId("axe_basic",2);
        Check(added.Count==2 && account.Inventory.Count==2,"Grant did not create two instances");
        Check(added[0].Id!=added[1].Id && added.All(x=>Guid.TryParseExact(x.Id,"D",out _)),"Nonunique/non-GUID item identity");
        string firstId=added[0].Id,secondId=added[1].Id;
        Reject(()=>inventory.AddItemByItemId("missing"),"Unknown item was granted");
        Reject(()=>inventory.AddItemByItemId("axe_basic",0),"Zero amount was granted");
        Check(account.Inventory.Count==2,"Rejected grant mutated inventory");
        Reject(()=>inventory.Equip("not-owned","gear_1",firstId),"Foreign hero equipped");
        Reject(()=>inventory.Equip(hero.HeroInstanceId,"invalid",firstId),"Unknown slot equipped");
        Check(account.Inventory.Count==2 && hero.EquippedItems.Count==0,"Rejected equip mutated account");
        inventory.Equip(hero.HeroInstanceId,"gear_1",firstId);
        Check(account.Inventory.Single().Id==secondId && hero.EquippedItems.Single().Id==firstId,"Equip changed identity/lost another instance");
        Reject(()=>inventory.Equip(hero.HeroInstanceId,"gear_2",firstId),"An equipped instance was duplicated");
        account.Inventory.Add(new ItemData{Id=firstId,ItemId="axe_basic"});
        Reject(()=>inventory.Validate(),"Inventory/equipment GUID collision accepted");account.Inventory.RemoveAt(account.Inventory.Count-1);
        Reject(()=>inventory.Promote(hero.HeroInstanceId),"Incomplete rank promoted");
        inventory.Equip(hero.HeroInstanceId,"gear_2",secondId);
        var others=inventory.AddItemByItemId("axe_basic",4).ToList();
        for(int i=0;i<4;i++)inventory.Equip(hero.HeroInstanceId,"gear_"+(i+3),others[i].Id);
        int damage=HeroStatCalculator.Calculate(hero,catalog).Get("damage");
        inventory.Promote(hero.HeroInstanceId);inventory.Validate();
        Check(hero.RankId=="green" && hero.AbsorbedItems.Count==6 && hero.EquippedItems.Count==0 && account.Inventory.Count==0,"Promotion transfer incorrect");
        Check(hero.AbsorbedItems.Any(x=>x.Id==firstId) && hero.AbsorbedItems.Select(x=>x.Id).Distinct().Count()==6,"Absorption lost GUID provenance");
        Check(HeroStatCalculator.Calculate(hero,catalog).Get("damage")==damage,"Promotion lost/double-counted stats");
        account.Inventory.Add(new ItemData{Id=firstId,ItemId="axe_basic"});
        Reject(()=>inventory.Validate(),"Absorbed item resurrected into inventory");account.Inventory.Clear();
        data.Items.Single(i=>i.Id=="axe_basic").Stats[0].Value=10;
        Check(HeroStatCalculator.Calculate(hero,new HeroCatalog(data)).Get("damage")==65,"Absorbed IDs did not use current balance config");
        data.Items.Single(i=>i.Id=="axe_basic").LevelRequirement=10;
        inventory.AddItemByItemId("axe_basic");
        Reject(()=>inventory.Equip(hero.HeroInstanceId,"gear_1",account.Inventory[0].Id),"Level gate bypassed");
        Check(account.Inventory.Count==1 && hero.EquippedItems.Count==0,"Level rejection mutated inventory");
        var modern=new ItemDefinition{ItemId="modern",Name="modern"};data.Items.Add(modern);
        Check(new HeroCatalog(data).Item("modern")==modern,"Modern definition ItemId was not indexed");
    }
}
