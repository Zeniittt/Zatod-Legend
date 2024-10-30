using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoisionEffect : MonoBehaviour
{
    private CharacterStats stats;

    private float duration;
    private int damagePerSecond;

    private float timer = 0;
    private float timeDoDamage;

    private void Start()
    {
        stats = GetComponentInParent<CharacterStats>();
    }

    void Update()
    {
        duration -= Time.deltaTime;
        timer += Time.deltaTime;

        if(timer >= timeDoDamage)
        {
            DoDamagePoision();

            timer = 0;
        }

        if(duration < 0)
            Destroy(gameObject);

    }

    public void SetupPoision(float _duration, int _damagePerSecond, float _timeDoDamage)
    {
        duration = _duration;
        damagePerSecond = _damagePerSecond;
        timeDoDamage = _timeDoDamage;
    }

    private void DoDamagePoision()
    {
        stats.DoMagicalDamage(stats, damagePerSecond);
    }
}
