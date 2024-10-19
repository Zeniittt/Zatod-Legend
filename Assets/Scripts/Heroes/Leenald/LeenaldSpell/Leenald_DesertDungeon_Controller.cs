using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Leenald_DesertDungeon_Controller : MonoBehaviour
{
    [SerializeField] private Transform rangeEffect;
    [SerializeField] private Vector2 boxSize;
    [SerializeField] private LayerMask whatIsEnemy;

    private void AnimationTrigger()
    {
        Collider2D[] colliders = Physics2D.OverlapBoxAll(rangeEffect.position, boxSize, whatIsEnemy);

        foreach (var hit in colliders)
        {
            if (hit.GetComponent<Enemy>() != null)
            {
                Debug.Log("...!!!");
            }
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawWireCube(rangeEffect.position, boxSize);
    }


    private void SelfDestroy() => Destroy(gameObject);
}
