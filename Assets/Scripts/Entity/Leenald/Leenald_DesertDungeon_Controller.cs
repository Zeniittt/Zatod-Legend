using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Leenald_DesertDungeon_Controller : MonoBehaviour
{
    Animator animator => GetComponent<Animator>();
    private Leenald hero => GetComponentInParent<Leenald>();


    [SerializeField] private Transform rangeEffect;
    [SerializeField] private Vector2 boxSize;
    [SerializeField] private LayerMask whatIsEnemy;

    private void Start()
    {
        if(animator != null)
            animator.updateMode = AnimatorUpdateMode.UnscaledTime;
    }

    private void ExitFreezeTime() => Time.timeScale = 1;

    private void AnimationTrigger()
    {
        Collider2D[] colliders = Physics2D.OverlapBoxAll(rangeEffect.position, boxSize, whatIsEnemy);

        foreach (var hit in colliders)
        {
            Enemy enemy = hit.GetComponent<Enemy>();

            if (enemy != null)
            {
                EnemyStats target = hit.GetComponent<EnemyStats>();
                if (target != null)
                    hero.stats.DoMagicalDamage(target, hero.damageSkillFour);

                if(!enemy.isDead)
                {
                    enemy.stunDuration = hero.skillUltimateStunDuration;
                    enemy.canBeStun = true;
                }

                break;
            }
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawWireCube(rangeEffect.position, boxSize);
    }


    private void SelfDestroy()
    {
        Destroy(gameObject);
    }
}
