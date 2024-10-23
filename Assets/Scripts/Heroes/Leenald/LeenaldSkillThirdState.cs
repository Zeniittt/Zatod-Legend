using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeenaldSkillThirdState : HeroState
{
    private Leenald hero;

    public LeenaldSkillThirdState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Leenald _hero) : base(_heroBase, _stateMachine, _animBoolName)
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

        if (triggerCalled)
        {
            hero.LeenaldMovement();
        }
    }
}