using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_AnimationTriggers : Hero_AnimationTriggers
{
    private Kavern kavern => GetComponentInParent<Kavern>();

    private void KavernAttackTrigger()
    {
        kavern.CreateArrow();
    }
}
