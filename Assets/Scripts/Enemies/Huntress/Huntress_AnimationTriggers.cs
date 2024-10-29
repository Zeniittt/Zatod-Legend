using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Huntress_AnimationTriggers : Enemy_AnimationTriggers
{
    private Huntress huntress => GetComponentInParent<Huntress>();

    private void AttackTrigger()
    {
        huntress.CreateSpear();
    }
}
