using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum StatType
{
    health,
    physicDamage,
    magicDamage,
    armor,
    magicResistance,
}

public class CharacterStats : MonoBehaviour
{
    public CharacterFX fx;

    public Stat health;
    public Stat physicDamage;
    public Stat magicDamage;
    public Stat armor;
    public Stat magicResistance;

    public int currentHealth;


    protected virtual void Start()
    {
        fx = GetComponent<CharacterFX>();

        currentHealth = health.GetValue();        
    }

    public virtual void DoPhysicDamage(CharacterStats _targetStats)
    {
        int damage = physicDamage.GetValue();

        _targetStats.TakePhysicDamage(damage);
    }

    public virtual void TakePhysicDamage(int _damage)
    {
        DecreaseHealthBy(_damage);

        if (currentHealth <= 0)
            Die();
    }

    public virtual void DecreaseHealthBy(int _damage)
    {
        currentHealth -= _damage;
    }

    public virtual void Die() { }
}
