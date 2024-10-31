using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_BeamExtension_Controller : MonoBehaviour
{
    Animator animator => GetComponent<Animator>();


    private CharacterStats myStats;
    private List<GameObject> targets;
    private int damage;

    private void Start()
    {
        if (animator != null)
            animator.updateMode = AnimatorUpdateMode.UnscaledTime;
    }

    public void SetupBeamExtension(CharacterStats _myStats, List<GameObject> _targets, int _damage)
    {
        myStats = _myStats;
        targets = _targets;
        damage = _damage;
    }

    private void BeamExtensionDoDamage()
    {
        foreach (GameObject target in targets)
        {
            myStats.DoMagicalDamage(target.GetComponent<CharacterStats>(), damage);
        }
    }

    private void ExitFreezeTime() => Time.timeScale = 1;

    private void SelfDestroy() => Destroy(gameObject);
}
