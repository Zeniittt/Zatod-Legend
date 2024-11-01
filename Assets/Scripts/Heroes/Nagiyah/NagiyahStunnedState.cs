using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NagiyahStunnedState : HeroState
{
    private Nagiyah hero;

    public NagiyahStunnedState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Nagiyah _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        if (hero.canBeStun)
        {
            hero.fx.CastStunFX();
        }
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
            stateMachine.ChangeState(hero.afterStunnedState);
        }
    }
}
