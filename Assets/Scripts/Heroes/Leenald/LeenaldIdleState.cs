using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeenaldIdleState : HeroState
{
    private Leenald hero;

    public LeenaldIdleState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Leenald _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        if (hero.isInitialTime)
        {
            stateTimer = hero.idleTimeInitial;
        }
        else if (hero.canBeStun)
        {
            stateTimer = hero.stunDuration;
        }
        else
        {
            stateTimer = hero.idleTime;
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
                if (hero.IsEnemyDetected())
                    hero.LeenaldMovement();
                else if (hero.ExistEnemyInObserve())
                {
                    stateMachine.ChangeState(hero.moveState);
                }
            }
        }
    }
}
