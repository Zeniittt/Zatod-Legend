using System.Collections.Generic;
using Zatod.Heroes;

namespace Zatod.Editor
{
    public static class HeroCatalogSample
    {
        // Creates only an initial test document; never runs automatically over an existing config.
        public static HeroCatalogData Create()
        {
            var data = new HeroCatalogData();
            data.Stats.AddRange(new[]
            {
                new StatDefinition { Id = "health", Name = "Health", Minimum = 1 },
                new StatDefinition { Id = "attack", Name = "Attack" },
                new StatDefinition { Id = "armor", Name = "Armor" },
                new StatDefinition { Id = "attack_range", Name = "Attack range (center units)" },
                new StatDefinition { Id = "move_speed", Name = "Move speed (units/second)" },
                new StatDefinition { Id = "attack_interval", Name = "Attack interval (20 Hz ticks)", Minimum = 1 }
            });
            data.Items.Add(new ItemDefinition { Id = "axe_basic", Name = "Training axe", Stats = new List<StatValue> { new StatValue("attack", 5) } });
            data.Items.Add(new ItemDefinition { Id = "sword_basic", Name = "Training sword", Stats = new List<StatValue> { new StatValue("attack", 7) } });
            data.Skills.Add(new SkillDefinition
            {
                Id = "warrior_ultimate", Name = "Heavy strike", Kind = SkillKind.Active,
                Activation = SkillActivation.UltimateIntent, Target = SkillTarget.FrontEnemy,
                EnergyCost = 100, CastRange = 1100, WindupMilliseconds = 600, RecoveryMilliseconds = 300,
                Effects = new List<SkillEffectDefinition>
                {
                    new SkillEffectDefinition { Kind = SkillEffectKind.Damage, AttackScaleBasisPoints = 12000 },
                    new SkillEffectDefinition { Kind = SkillEffectKind.Stun, DurationMilliseconds = 1000 }
                }
            });
            data.Skills.Add(new SkillDefinition
            {
                Id = "warrior_strike", Name = "Auto strike", Kind = SkillKind.Active,
                Activation = SkillActivation.Automatic, Target = SkillTarget.FrontEnemy,
                CooldownMilliseconds = 5000, CastRange = 1100, WindupMilliseconds = 300,
                Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Damage, AttackScaleBasisPoints = 15000 } }
            });
            data.Skills.Add(new SkillDefinition
            {
                Id = "warrior_guard", Name = "Guard (passive)", Kind = SkillKind.Passive,
                Activation = SkillActivation.BattleStart, Target = SkillTarget.Self,
                Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.StatBonus, StatId = "armor", Amount = 5 } }
            });
            data.Skills.Add(new SkillDefinition
            {
                Id = "warrior_heal", Name = "Recovery", Kind = SkillKind.Active,
                Activation = SkillActivation.Automatic, Target = SkillTarget.LowestHealthAlly,
                CooldownMilliseconds = 8000, CastRange = 4800,
                Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Heal, Amount = 50 } }
            });
            var hero = new HeroDefinition
            {
                Id = "training_warrior", Name = "Training Warrior", StartingRankId = "white",
                BaseStats = new List<StatValue>
                {
                    new StatValue("health", 600), new StatValue("attack", 5), new StatValue("armor", 10),
                    new StatValue("attack_range", 1100), new StatValue("move_speed", 1600), new StatValue("attack_interval", 27)
                }
            };
            string[] ranks = { "white", "green", "blue", "purple" };
            string[] names = { "Trắng", "Xanh Lá", "Xanh Dương", "Tím" };
            string[] slotIds = { "ultimate", "skill_2", "skill_3", "skill_4" };
            for (int i = 0; i < ranks.Length; i++)
            {
                var rank = new HeroRankDefinition { Id = ranks[i], Name = names[i], NextRankId = i < 3 ? ranks[i + 1] : "" };
                rank.UnlockSkillSlotIds.Add(slotIds[i]);
                // Purple is the terminal rank in this sample; no further recipe yet.
                if (i < 3) for (int j = 0; j < 6; j++)
                    rank.EquipmentSlots.Add(new EquipmentSlotDefinition { Id = "gear_" + (j + 1), RequiredItemId = "axe_basic" });
                hero.Ranks.Add(rank);
                hero.SkillSlots.Add(new HeroSkillSlotDefinition { Id = slotIds[i], SkillId = data.Skills[i].Id, IsUltimate = i == 0 });
            }
            data.Heroes.Add(hero);
            return data;
        }
    }
}
