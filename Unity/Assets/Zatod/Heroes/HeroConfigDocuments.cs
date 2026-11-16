using System;
using System.Collections.Generic;

namespace Zatod.Heroes
{
    public enum HeroConfigSection { Stats, Items, Skills, Heroes }

    [Serializable]
    public abstract class HeroConfigTable
    {
        public int SchemaVersion;
        public string ConfigVersion;
    }

    [Serializable] public sealed class StatsConfigData : HeroConfigTable { public List<StatDefinition> Stats; }
    [Serializable] public sealed class ItemsConfigData : HeroConfigTable { public List<ItemDefinition> Items; }
    [Serializable] public sealed class SkillsConfigData : HeroConfigTable { public List<SkillDefinition> Skills; }
    [Serializable] public sealed class HeroesConfigData : HeroConfigTable { public List<HeroDefinition> Heroes; }

    [Serializable]
    public sealed class HeroConfigDocuments
    {
        public string Stats, Items, Skills, Heroes;

        public string Get(HeroConfigSection section)
        {
            switch (section)
            {
                case HeroConfigSection.Stats: return Stats;
                case HeroConfigSection.Items: return Items;
                case HeroConfigSection.Skills: return Skills;
                case HeroConfigSection.Heroes: return Heroes;
                default: throw new ArgumentOutOfRangeException(nameof(section));
            }
        }

        public void Set(HeroConfigSection section, string json)
        {
            switch (section)
            {
                case HeroConfigSection.Stats: Stats = json; break;
                case HeroConfigSection.Items: Items = json; break;
                case HeroConfigSection.Skills: Skills = json; break;
                case HeroConfigSection.Heroes: Heroes = json; break;
                default: throw new ArgumentOutOfRangeException(nameof(section));
            }
        }
    }
}
