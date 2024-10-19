using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeenaldSkillUltimateState : HeroState
{
    private Leenald hero;

    public LeenaldSkillUltimateState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Leenald _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        hero.SetZeroVelocity();
    }

    public override void Exit()
    {
        base.Exit();
    }

    public override void Update()
    {
        base.Update();

        if (triggerCalled)
        {
            hero.LeenaldMovement();
        }

    }
}
