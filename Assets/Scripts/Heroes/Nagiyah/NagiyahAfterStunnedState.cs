using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NagiyahAfterStunnedState : HeroState
{
    private Nagiyah hero;

    public NagiyahAfterStunnedState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Nagiyah _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        if (hero.canBeStun)
        {
            stateTimer = hero.stunDuration;
        }
        else
        {
            stateTimer = 1;
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

        if (stateTimer < 0)
        {

            hero.canBeStun = false;

            if (hero.isInitialTime)
                stateMachine.ChangeState(hero.moveState);
            else
            {
                hero.NagiyahMovement();
            }
        }
    }
}
