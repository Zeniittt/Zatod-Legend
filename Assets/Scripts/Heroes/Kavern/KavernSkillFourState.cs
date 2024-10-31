using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KavernSkillFourState : HeroState
{
    private Kavern hero;

    public KavernSkillFourState(Hero _enemyBase, HeroStateMachine _stateMachine, string _animBoolName, Kavern _hero) : base(_enemyBase, _stateMachine, _animBoolName)
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
            hero.KavernMovement();
    }
}
