using System;
using System.Collections.Generic;

namespace Zatod.Heroes
{
    [Serializable]
    public sealed class MonsterDefinition
    {
        public string Id,Name,PortraitKey,BodyPrefabResource,AnimationSetResource,NormalAttackSkillId;
        public HeroPosition Position;
        public int ProjectileHurtboxHeight=100,DeathAnimationMilliseconds=1500;
        public List<StatValue> BaseStats=new List<StatValue>();
        public List<HeroSpawnPointDefinition> SpawnPoints=new List<HeroSpawnPointDefinition>();
        public List<string> SkillIds=new List<string>();
    }

    [Serializable]
    public sealed class MonsterBattleData : CombatantBattleData
    {
        public string MonsterInstanceId,MonsterDefinitionId;
    }
}
