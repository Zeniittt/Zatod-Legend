using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_AnimationTriggers : Hero_AnimationTriggers
{
    private Kavern hero => GetComponentInParent<Kavern>();

    private void KavernAttackTrigger()
    {
        hero.CreateArrow();
    }

    private void SkillUltimateTrigger()
    {
        hero.CastSkillUltimate();
    }

    private void SkillSecondTrigger()
    {
        hero.CastSkillSecond();
    }

    private void SkillThirdTrigger()
    {
        hero.CastSkillThird();
    }

    private void SkillFourTrigger()
    {
        hero.CastSkillFour();
    }

    private void EnterFreezeTime() => Time.timeScale = 0;


}
