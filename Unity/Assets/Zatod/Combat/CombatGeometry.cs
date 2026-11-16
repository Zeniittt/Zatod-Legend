using System;

namespace Zatod.Combat
{
    public static class CombatGeometry
    {
        // One horizontal combat axis. y is shallow display depth, never a lane or a hitbox radius.
        // All attack distances are measured from the unit centers. Kept here for future replacement.
        public static long CenterDistance(FighterState a, FighterState b) { return Math.Abs((long)a.x - b.x); }
        public static bool InAttackRange(FighterState a, FighterState b) { return CenterDistance(a, b) <= a.range; }
        public static int ArrivalDistance(FighterState actor) { return actor.range - Math.Min(40, Math.Max(0, actor.range / 10)); }

        public static int ApproachAttackRange(FighterState actor, FighterState target, int tickRate)
        {
            int direction = target.x >= actor.x ? 1 : -1;
            int destination = target.x - direction * ArrivalDistance(actor);
            int step = Math.Max(1, (actor.moveSpeed > 0 ? actor.moveSpeed : 1600) / tickRate);
            return actor.x < destination ? Math.Min(destination, actor.x + step) : Math.Max(destination, actor.x - step);
        }
    }
}
