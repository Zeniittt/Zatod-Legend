using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KavernMoveState : HeroState
{
    private Kavern hero;

    public KavernMoveState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Kavern _hero) : base(_heroBase, _stateMachine, _animBoolName)
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

        hero.SetVelocity(hero.moveSpeed * hero.facingDirection, rigidbody.velocity.y);

        if (hero.CanAttack())
            stateMachine.ChangeState(hero.battleState);
    }
}
