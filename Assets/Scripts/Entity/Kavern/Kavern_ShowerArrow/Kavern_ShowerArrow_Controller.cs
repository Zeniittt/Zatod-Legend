using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_ShowerArrow_Controller : MonoBehaviour
{

    private CharacterStats myStats;
    private GameObject target;
    private float stunDuration;
    private int damageArrow;
    private int damageRoot;


    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void SetupShowerArrow(CharacterStats _myStats, GameObject _target, float _stunDuration,  int _damageArrow, int _damageRoot)
    {
        myStats = _myStats;
        target = _target;
        stunDuration = _stunDuration;
        damageArrow = _damageArrow;
        damageRoot = _damageRoot;
    }

    private void ArrowDoDamage()
    {
        myStats.DoPhysicDamage(target.GetComponent<CharacterStats>(), damageArrow);
    }

    private void RootDoDamage()
    {
        myStats.DoMagicalDamage(target.GetComponent<CharacterStats>(), damageRoot);

        Character enemy = target.GetComponent<Character>();

        if (!enemy.isDead)
        {
            enemy.stunDuration = stunDuration;
            enemy.canBeStun = true;
        }
    }

    private void SelfDestroy() => Destroy(gameObject);
}
