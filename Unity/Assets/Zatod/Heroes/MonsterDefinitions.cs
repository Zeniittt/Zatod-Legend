using System;
using System.Collections.Generic;

namespace Zatod.Heroes
{
    [Serializable]
    public sealed class MonsterDefinition : CombatantDefinition
    {
        public List<string> SkillIds = new List<string>();
    }

    [Serializable]
    public sealed class MonsterBattleData : CombatantBattleData
    {
        public string MonsterInstanceId,MonsterDefinitionId;
    }
}
