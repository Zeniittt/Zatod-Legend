using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class NagiyahIdleState : HeroState
{
    private Nagiyah hero;

    public NagiyahIdleState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Nagiyah _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        hero.CanCastSkillSecond();

        if (hero.isInitialTime)
        {
            stateTimer = hero.idleTimeInitial;
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
            if (hero.isInitialTime)
                stateMachine.ChangeState(hero.moveState);
            else
            {
                if (hero.CanAttack())
                    hero.NagiyahMovement();
                else if (hero.lineupDefense.Count > 0)
                {
                    hero.FlipDependOnTargetEnemy();
                    if (hero.currentStateIndex == -1) hero.currentStateIndex = 0;
                    stateMachine.ChangeState(hero.moveState);
                }
            }
        }
    }
}
