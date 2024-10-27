using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EvilWizard_AnimationTriggers : Enemy_AnimationTriggers
{
    private EvilWizard evilWizard => GetComponentInParent<EvilWizard>();

    private void AttackTrigger()
    {
        evilWizard.CreateDarkEnergy();
    }
}
