using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy_AnimationTriggers : MonoBehaviour
{
    private Enemy enemy => GetComponentInParent<Enemy>();

    private void AnimationFinishTrigger()
    {
        enemy.AnimationFinishTrigger();
    }

    private void AttackTrigger()
    {
        Collider2D[] colliders = Physics2D.OverlapCircleAll(enemy.attackRange.position, enemy.attackRangeRadius);

        foreach (var hit in colliders)
        {
            Hero hero = hit.GetComponent<Hero>();

            if (hero != null && !hero.isDead)
            {
                HeroStats target = hit.GetComponent<HeroStats>();

                if (target != null)
                {
                    enemy.stats.DoPhysicDamage(target);
                    target.fx.CreateHitFX(target.transform);
                }

                break;
            }
        }
    }
}
