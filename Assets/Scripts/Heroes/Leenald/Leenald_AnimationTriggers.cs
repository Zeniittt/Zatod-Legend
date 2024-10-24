using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Leenald_AnimationTriggers : Hero_AnimationTriggers
{
    private Leenald hero => GetComponentInParent<Leenald>();

    private void SkillUltimateTrigger()
    {
        hero.CastSkillUltimate();
    }

    private void SkillFourTrigger()
    {
        hero.CastSkillFour();
    }

    private void SkillThirdTrigger()
    {
        hero.CastSkillThird();
    }

    private void SkillSecondTrigger()
    {
        hero.CastSkillSecond();
    }
}
