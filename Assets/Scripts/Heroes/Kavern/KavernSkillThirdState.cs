using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KavernSkillThirdState : HeroState
{
    private Kavern hero;

    public KavernSkillThirdState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Kavern _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        hero.CastSkillThirdEnter();
    }

    public override void Exit()
    {
        base.Exit();

        hero.CastSkillThirdExit();
    }

    public override void Update()
    {
        base.Update();

        hero.SetZeroVelocity();

        if (triggerCalled)
        {
            hero.KavernMovement();
        }
    }
}
