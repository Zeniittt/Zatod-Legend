using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayWolf_AnimationTriggers : Enemy_AnimationTriggers
{
    GrayWolf grayWolf => GetComponentInParent<GrayWolf>();

    private void InitialAttackTrigger()
    {
        Collider2D[] colliders = Physics2D.OverlapCircleAll(grayWolf.initialAttackRange.position, grayWolf.initialAttackRangeRadius);

        foreach (var hit in colliders)
        {
            Hero hero = hit.GetComponent<Hero>();

            if (hero != null && !hero.isDead)
            {
                HeroStats target = hit.GetComponent<HeroStats>();

                if (target != null)
                {
                    grayWolf.stats.DoPhysicDamage(target, grayWolf.initialDamage);
                    target.fx.CreateHitFX(target.transform);
                    target.fx.CreateHemorrhage(hero.transform.position);
                }

                break;
            }
        }
    }
}
