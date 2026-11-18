using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    public readonly struct HeroProjectileOrigin
    {
        public const int CombatUnitsPerWorldUnit = 100;
        public readonly int Forward, Height;
        public HeroProjectileOrigin(int forward, int height) { Forward = forward; Height = height; }

        // Shared by the server and native animation preview. No Unity Transform or sprite bounds.
        public static HeroProjectileOrigin Resolve(IEnumerable<HeroSpawnPointDefinition> points, SkillDefinition skill)
        {
            HeroSpawnPointDefinition point = null;
            if (!string.IsNullOrEmpty(skill.ProjectileSpawnPointId))
            {
                point = points.SingleOrDefault(p => p.Id == skill.ProjectileSpawnPointId);
                if (point == null) throw new ArgumentException("Unknown projectile spawn point: " + skill.ProjectileSpawnPointId);
            }
            int forward = checked((point == null ? 0 : point.Forward) + skill.ProjectileSpawnOffsetForward);
            int height = checked((point == null ? 0 : point.Height) + skill.ProjectileSpawnOffsetHeight);
            if (height < 0) throw new ArgumentException("Projectile spawn point is below ground.");
            return new HeroProjectileOrigin(forward, height);
        }
    }
}
