using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NagiyahAttackState : HeroState
{
    private Nagiyah hero;

    public NagiyahAttackState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Nagiyah _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();
    }

    public override void Exit()
    {
        base.Exit();
    }

    public override void Update()
    {
        base.Update();

        hero.SetZeroVelocity();

        if (triggerCalled)
        {
            hero.NagiyahMovement();
        }
    }
}
