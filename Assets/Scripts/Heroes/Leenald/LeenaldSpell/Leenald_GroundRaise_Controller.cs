using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Leenald_GroundRaise_Controller : MonoBehaviour
{
    private Leenald hero => GetComponentInParent<Leenald>(); 


    [SerializeField] private Transform rangeEffect;
    [SerializeField] private Vector2 boxSize;
    [SerializeField] private LayerMask whatIsEnemy;

    private void AnimationTrigger()
    {

        Collider2D[] colliders = Physics2D.OverlapBoxAll(rangeEffect.position, boxSize, whatIsEnemy);

        foreach (var hit in colliders)
        {
            Enemy enemy = hit.GetComponent<Enemy>();

            if (enemy != null && !enemy.isDead)
            {
                EnemyStats target = hit.GetComponent<EnemyStats>();
                if (target != null)
                    hero.stats.DoMagicalDamage(target, hero.damageSkillFour);

                if(!enemy.isDead)
                    enemy.canBeKnockup = true;
            }
        }
    }

    public void SetupGroundRaise()
    {
        if (hero.facingDirection == -1)
            transform.Rotate(0, 180, 0);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.magenta;
        Gizmos.DrawWireCube(rangeEffect.position, boxSize);
    } 


    private void SelfDestroy() => Destroy(gameObject);
}
