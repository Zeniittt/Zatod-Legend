using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeenaldStunnedState : HeroState
{
    private Leenald hero;

    public LeenaldStunnedState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Leenald _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        if (hero.canBeKnockback)
        {
            hero.CastKnockback();
            hero.canBeKnockback = false;
        } else if(hero.canBeStun)
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

        if(triggerCalled)
        {
            //hero.LeenaldMovement();
            stateMachine.ChangeState(hero.idleState);
        }
    }
}
