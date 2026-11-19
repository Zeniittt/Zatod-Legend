using System;

namespace Zatod.Combat
{
    public static class BattleFormationLayout
    {
        public const int Version = 3;
        public const int Spacing = 1400;
        public static void Place(FighterState fighter)
        {
            fighter.x = (fighter.team == 0 ? -1 : 1) * (2300 + fighter.slot * Spacing);
            // Original shallow alternating depth; front-to-back order stays on X.
            int depth = fighter.slot % 2 == 0 ? 120 : -140;
            fighter.y = depth;
            fighter.formationSpacing = fighter.team == 0 ? 850 : 650;
            fighter.flexibleFormationSpacing = false;
        }

        public static int WalkingGap(FighterState actor, FighterState ally)
        {
            return Math.Max(actor.formationSpacing, ally.formationSpacing);
        }
    }
}
