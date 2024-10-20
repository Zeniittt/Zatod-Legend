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
            if (hit.GetComponent<Hero>() != null)
            {
                //Debug.Log("Enemy do damage");
            }
        }
    }

    private void KnockbackTrigger()
    {
        enemy.CastKnockback();
        //enemy.rb.velocity = new Vector2(enemy.knockbackDirection.x * -enemy.facingDirection, enemy.knockbackDirection.y);
    }

    private void SelfDestroy()
    {
        if (enemy != null)
            Destroy(enemy.gameObject);
    }
}
