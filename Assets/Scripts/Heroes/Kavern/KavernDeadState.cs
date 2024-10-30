using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KavernDeadState : HeroState
{
    private Kavern hero;

    public KavernDeadState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Kavern _hero) : base(_heroBase, _stateMachine, _animBoolName)
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

        hero.SetZeroVelocity();

        if (triggerCalled)
        {
            hero.animator.enabled = false;
            hero.StartCoroutine(hero.fx.FadeOut());

            hero.SelfDestroy();
        }
    }
}
