using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Leenald_GroundRaise_Controller : MonoBehaviour
{

    [SerializeField] private Transform rangeEffect;
    [SerializeField] private Vector2 boxSize;
    [SerializeField] private LayerMask whatIsEnemy;

    private void AnimationTrigger()
    {
        Collider2D[] colliders = Physics2D.OverlapBoxAll(rangeEffect.position, boxSize, whatIsEnemy);

        foreach (var hit in colliders)
        {
            if (hit.GetComponentInParent<Enemy>() != null)
            {
                hit.GetComponent<Enemy>().canBeKnockup = true;
            }
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.magenta;
        Gizmos.DrawWireCube(rangeEffect.position, boxSize);
    } 


    private void SelfDestroy() => Destroy(gameObject);
}
