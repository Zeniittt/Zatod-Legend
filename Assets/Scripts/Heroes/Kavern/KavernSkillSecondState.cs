using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KavernSkillSecondState : HeroState
{
    private Kavern hero;

    public KavernSkillSecondState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Kavern _hero) : base(_heroBase, _stateMachine, _animBoolName)
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
            hero.currentStateIndex++;
            stateMachine.ChangeState(hero.heroStates[hero.currentStateIndex]);
        }
    }
}
