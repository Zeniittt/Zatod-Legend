using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;

namespace Zatod.Editor
{
    public enum SandboxTestMode { Auto, BasicAttack, SingleSkill }

    [Serializable]
    public sealed class HeroSandboxSettings
    {
        public string HeroId, RankId, SkillSlotId;
        public SandboxTestMode Mode;
        public int DurationSeconds = 15, HpPercent = 50, StartingEnergy = 100;
        public int TargetCount = 3, TargetDistance = 70, TargetSpacing = 220, TargetHp;
        public List<string> MonsterIds=new List<string>{"fighter_goblin","goblin_mage","skeleton_knight"};
        public int MonsterSetupVersion;
        public int Seed = 123;
        public int SingleSkillCasts = 1;
    }

    public sealed class SandboxBattleSetup
    {
        public List<FighterState> Fighters;
        public List<FighterLoadout> Loadouts;
        public string Title;
        public uint Seed;
        public int DurationTicks;
        public BattleRecord Run()
        {
            var record=new BattleSimulation(Guid.NewGuid().ToString("N"),Title,Seed,Fighters,Loadouts,DurationTicks).RunToCompletion();
            record.createdUtc=DateTime.UtcNow.ToString("O");return record;
        }
    }

    public static class HeroCombatSandbox
    {
        public static List<HeroRankDefinition> Ranks(HeroCatalog catalog, string heroId)
        {
            var definition = catalog.Hero(heroId);
            var result = new List<HeroRankDefinition>();
            string next = definition.StartingRankId;
            while (!string.IsNullOrEmpty(next))
            {
                var rank = definition.Ranks.Single(r => r.Id == next); result.Add(rank); next = rank.NextRankId;
            }
            return result;
        }

        public static HeroData TemporaryHero(HeroCatalog catalog, string heroId, string rankId)
        {
            var hero = catalog.CreateHero(heroId, "sandbox-" + heroId);
            var ranks = Ranks(catalog, heroId);
            if (!ranks.Any(r => r.Id == rankId)) throw new ArgumentException("Unknown test rank.");
            while (hero.RankId != rankId)
            {
                foreach (var slot in HeroProgression.CurrentRank(hero, catalog).EquipmentSlots)
                    HeroProgression.Equip(hero, catalog, slot.Id, slot.RequiredItemId);
                HeroProgression.Promote(hero, catalog);
            }
            return hero;
        }

        public static BattleRecord Build(HeroCatalog catalog, HeroSandboxSettings settings)
        {return Prepare(catalog,settings).Run();}

        public static SandboxBattleSetup Prepare(HeroCatalog catalog, HeroSandboxSettings settings)
        {
            if (settings.DurationSeconds < 1 || settings.DurationSeconds > 45 || settings.MonsterIds==null || settings.MonsterIds.Count < 1 || settings.MonsterIds.Count > 5 ||
                settings.TargetDistance < 0 || settings.TargetDistance > 10000 || settings.TargetSpacing < 0 || settings.TargetSpacing > 1000 ||
                settings.TargetHp < 0 || settings.TargetHp > 1000000 || settings.HpPercent < 1 || settings.HpPercent > 100 ||
                settings.StartingEnergy < 0 || settings.StartingEnergy > 100 || settings.SingleSkillCasts < 1 || settings.SingleSkillCasts > 5)
                throw new ArgumentException("Invalid sandbox settings. Duration 1–45s; 1–5 monsters; HP override 0–1000000; Hero HP 1–100%; energy 0–100.");
            var hero = TemporaryHero(catalog, settings.HeroId, settings.RankId);
            var definition = catalog.Hero(settings.HeroId);
            var data = HeroBattleFactory.Create(hero, catalog);
            string test = "Auto / all unlocked skills";
            if (settings.Mode == SandboxTestMode.BasicAttack)
            { data.Skills.Clear(); test = "Normal attack"; }
            else if (settings.Mode == SandboxTestMode.SingleSkill)
            {
                var selected = data.Skills.SingleOrDefault(s => s.SlotId == settings.SkillSlotId);
                if (selected == null) throw new ArgumentException("Skill is locked at the selected rank.");
                bool onDeath=selected.Definition.Kind==SkillKind.Passive && selected.Definition.Activation==SkillActivation.OnDeath;
                if (!onDeath && (selected.Definition.Kind != SkillKind.Active ||
                    (selected.Definition.Activation != SkillActivation.Automatic && selected.Definition.Activation != SkillActivation.UltimateIntent))
                    )
                    throw new ArgumentException("This skill needs a passive/event trigger, which the current combat core does not execute yet.");
                if (!onDeath && settings.StartingEnergy < selected.Definition.EnergyCost)
                    throw new ArgumentException("Skill needs " + selected.Definition.EnergyCost + " starting energy.");
                if (selected.Definition.Effects.Any(e => e.Kind == SkillEffectKind.StatBonus))
                    throw new ArgumentException("StatBonus effects are not implemented by the current combat core.");
                data.Skills = new List<BattleSkillData> { selected }; test = selected.Definition.Name;
            }
            var actor = ServerHeroTeams.CreateFighter(definition, data, 0, 0);
            actor.x = actor.y = 0;
            actor.hp = Math.Max(1, actor.maxHp * settings.HpPercent / 100);
            actor.energy = settings.StartingEnergy;
            data.CurrentHp = actor.hp; data.Energy = actor.energy;
            var initial = new List<FighterState> { actor };
            var loadouts = new List<FighterLoadout>
            {
                new FighterLoadout { fighterId = actor.id, hero = data,
                    disableBasicAttacks = settings.Mode == SandboxTestMode.SingleSkill,
                    skillCastLimit = settings.Mode == SandboxTestMode.SingleSkill ? settings.SingleSkillCasts : 0 }
            };
            var monsters=settings.MonsterIds.Select((id,index)=>new{id,index,definition=catalog.Monster(id)})
                .OrderBy(m=>m.definition.Position).ThenBy(m=>m.index).ToList();
            for (int i = 0; i < monsters.Count; i++)
            {
                var monster=monsters[i].definition;
                var battle=MonsterBattleFactory.Create(monster.Id,"sandbox-monster-"+i,catalog);
                if(settings.TargetHp>0){battle.CurrentHp=settings.TargetHp;battle.Stats.Single(s=>s.StatId=="health").Value=settings.TargetHp;}
                var fighter=MonsterBattleFactory.CreateFighter(monster,battle,1,i);
                fighter.x=settings.TargetDistance+i*settings.TargetSpacing;fighter.y=(i-(monsters.Count-1)/2)*300;
                fighter.formationSpacing=settings.TargetSpacing;
                initial.Add(fighter);loadouts.Add(new FighterLoadout{fighterId=fighter.id,kind=CombatantKind.Monster,monster=battle});
            }
            return new SandboxBattleSetup{Title=definition.Name+" / "+test,Seed=unchecked((uint)settings.Seed),Fighters=initial,Loadouts=loadouts,
                DurationTicks=settings.DurationSeconds*BattleSimulation.TickRate};
        }
    }
}
