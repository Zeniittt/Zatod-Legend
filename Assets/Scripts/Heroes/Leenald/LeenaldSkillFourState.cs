using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeenaldSkillFourState : HeroState
{
    private Leenald hero;

    public LeenaldSkillFourState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Leenald _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        //hero.CastSkillFour();
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
