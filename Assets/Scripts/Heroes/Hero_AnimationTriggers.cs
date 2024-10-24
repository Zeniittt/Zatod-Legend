using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hero_AnimationTriggers : MonoBehaviour
{
    private Hero hero => GetComponentInParent<Hero>();

    private void AnimationFinishTrigger()
    {
        hero.AnimationFinishTrigger();
    }

    private void AttackTrigger()
    {
        Collider2D[] colliders = Physics2D.OverlapCircleAll(hero.attackRange.position, hero.attackRangeRadius);

        foreach (var hit in colliders)
        {
            Enemy enemy = hit.GetComponent<Enemy>();

            if (enemy != null && !enemy.isDead)
            {
                EnemyStats target = hit.GetComponent<EnemyStats>();

                if (target != null)
                {
                    hero.stats.DoPhysicDamage(target);
                    target.fx.CreateHitFX(target.transform);
                }    

                break;
            }
        }
    }

    private void SelfDestroy()
    {
        if (hero != null)
            Destroy(hero.gameObject);
    }
}
