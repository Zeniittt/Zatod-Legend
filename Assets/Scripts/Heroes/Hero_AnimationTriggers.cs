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
            if (hit.GetComponent<Enemy>() != null)
            {
                Debug.Log("Hero do damage");
            }
        }
    }

    private void SelfDestroy()
    {
        if (hero != null)
            Destroy(hero.gameObject);
    }
}
