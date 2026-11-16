using System;
using System.Collections.Generic;

namespace Zatod.Heroes
{
    [Serializable]
    public sealed class HeroData
    {
        public string HeroInstanceId, HeroDefinitionId, RankId;
        // Reserved progress fields; this phase implements rank progression only.
        public int Level = 1, Stars = 1;
        public long Exp;
        public bool Awakened;
        public List<EquippedItemData> EquippedItems = new List<EquippedItemData>();
        public List<AbsorbedItemData> AbsorbedItems = new List<AbsorbedItemData>();
        public List<HeroSkillData> Skills = new List<HeroSkillData>();
        // Resolved after loading; shared config never belongs in the player save.
        [NonSerialized] public HeroDefinition Definition;
    }

    [Serializable] public sealed class EquippedItemData { public string SlotId, ItemId; }

    [Serializable]
    public sealed class AbsorbedItemData
    {
        public string RankId, SlotId, ItemId;
        public int Quantity = 1;
    }

    [Serializable] public sealed class HeroSkillData { public string SlotId; public int Level = 1; }

    // Declarations only: no inventory, economy, quest or account-level logic yet.
    [Serializable]
    public sealed class CharacterData
    {
        public int SchemaVersion = 1;
        public string CharacterId, Name;
        public long Revision, Exp;
        public int Level = 1;
        public List<HeroData> HeroDesk = new List<HeroData>();
        public List<Currency> Currencies = new List<Currency>();
        public List<ItemStackData> Inventory = new List<ItemStackData>();
        public CampaignProgressData MainCampaignProgress = new CampaignProgressData();
        public List<QuestProgressData> Quests = new List<QuestProgressData>();
    }

    [Serializable] public sealed class Currency { public string Id; public long Amount; }
    [Serializable] public sealed class ItemStackData { public string ItemId; public long Quantity; }
    [Serializable] public sealed class CampaignProgressData { public List<string> ClearedStageIds = new List<string>(); }
    [Serializable] public sealed class QuestProgressData { public string Id, PeriodId; public long Progress; public bool Claimed; }

    [Serializable]
    public sealed class HeroBattleData
    {
        public string ConfigVersion, HeroInstanceId, HeroDefinitionId;
        public List<StatValue> Stats = new List<StatValue>();
        public List<HeroBattleSkillData> Skills = new List<HeroBattleSkillData>();
        public int CurrentHp, Energy;
    }

    [Serializable]
    public sealed class HeroBattleSkillData
    {
        public string SlotId;
        public int Level, CooldownRemainingMilliseconds;
        public bool IsUltimate;
        public SkillDefinition Definition;
    }
}
