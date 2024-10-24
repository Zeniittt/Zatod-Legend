using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Leenald_DesertDungeon_Controller : MonoBehaviour
{
    Animator animator => GetComponent<Animator>();

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
            if (hit.GetComponent<Enemy>() != null)
            {
                hit.GetComponent<Enemy>().canBeStun = true;
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
