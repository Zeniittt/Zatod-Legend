using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Nagiyah_AnimationTriggers : Hero_AnimationTriggers
{
    private Nagiyah hero => GetComponentInParent<Nagiyah>();


    private void NagiyahAttackTrigger()
    {
        hero.CreateKnife();
    }
}
