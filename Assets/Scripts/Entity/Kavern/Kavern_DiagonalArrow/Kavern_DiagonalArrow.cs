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
        // T�nh to�n vector h??ng t? m?i t�n t?i target hi?n t?i
        Vector3 direction = (targetPosition - transform.position).normalized;

        // T�nh g�c xoay d?a tr�n h??ng (tr?c y v� tr?c x)
        float angle = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;

        // Xoay m?i t�n ?? h??ng v? target
        transform.rotation = Quaternion.Euler(0, 0, angle);

        // Di chuy?n m?i t�n v? ph�a target v?i t?c ?? c? ??nh
        transform.position = Vector3.MoveTowards(transform.position, targetPosition, speed);
    }

    private void SelfDestroy(Collider2D collision)
    {
        Destroy(gameObject);
    }
}
