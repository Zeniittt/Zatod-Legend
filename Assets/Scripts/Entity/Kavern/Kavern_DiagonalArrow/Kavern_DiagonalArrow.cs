using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.IO.LowLevel.Unsafe;
using Unity.VisualScripting;
using UnityEditorInternal;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class Kavern_DiagonalArrow : MonoBehaviour
{
    [SerializeField] private string targetLayerName = "Enemy";
    public float speed;
    private int damage;
    private CharacterStats myStats;
    private Kavern kavern;

    private void Update()
    {
        ArrowMove();
    }

    public void SetupArrow(CharacterStats _myStats, Kavern _kavern, int _damage)
    {
        myStats = _myStats;
        kavern = _kavern;
        damage = _damage;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer(targetLayerName))
        {
            myStats.DoPhysicDamage(collision.GetComponent<CharacterStats>(), damage);

            SelfDestroy(collision);
        }
    }

    private void ArrowMove()
    {
        Vector3 targetPosition = new Vector3(kavern.skillThirdTarget.transform.position.x, kavern.skillThirdTarget.transform.position.y + 1, 0);

        Vector3 direction = (targetPosition - transform.position).normalized;

        float angle = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;

        transform.rotation = Quaternion.Euler(0, 0, angle);

        transform.position = Vector3.MoveTowards(transform.position, targetPosition, speed);
    }

    private void SelfDestroy(Collider2D collision)
    {
        Destroy(gameObject);
    }
}
