using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Archer_AnimationTriggers : Enemy_AnimationTriggers
{
    private Archer archer => GetComponentInParent<Archer>();

    private void AttackTrigger()
    {
        archer.CreateArrow();
    }
}
