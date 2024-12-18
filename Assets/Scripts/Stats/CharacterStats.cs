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

    public System.Action onHealthChanged;


    protected virtual void Start()
    {
        fx = GetComponent<CharacterFX>();

        currentHealth = health.GetValue();        
    }

    public virtual void DoPhysicDamage(CharacterStats _targetStats, int _damage)
    {
        fx.CreatePopUpText(_targetStats.transform.position, "- " + _damage.ToString(), new Vector3(255, 255, 255));
        
        _targetStats.TakePhysicDamage(_damage);
    }

    public virtual void DoMagicalDamage(CharacterStats _targetStats, int _damage)
    {
        fx.CreatePopUpText(_targetStats.transform.position, "- " + _damage.ToString(), new Vector3(243, 215, 0));
        
        _targetStats.TakeMagicalDamage(_damage);
    }

    public virtual void TakePhysicDamage(int _damage)
    {
        DecreaseHealthBy(_damage);

        if (currentHealth <= 0)
            Die();
    }

    public virtual void TakeMagicalDamage(int _damage)
    {
        DecreaseHealthBy(_damage);

        if (currentHealth <= 0)
            Die();
    }

    public void DecreaseHealthBy(int _damage)
    {
        currentHealth -= _damage;

        if (onHealthChanged != null)
            onHealthChanged();
    }

    public void IncreaseHealthBy(int _amount)
    {
        currentHealth += _amount;

        if (currentHealth > health.GetValue())
            currentHealth = health.GetValue();

        if (onHealthChanged != null)
            onHealthChanged();
    }



    public virtual void Die() { }
}
