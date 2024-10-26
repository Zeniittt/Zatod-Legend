using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayWolfRunState : EnemyState
{
    private GrayWolf enemy;

    public GrayWolfRunState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, GrayWolf _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
    {
        this.enemy = _enemy;
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

        enemy.SetVelocity(enemy.runSpeed * enemy.facingDirection, rb.velocity.y);

        if (enemy.InitialAttackDetected())
            stateMachine.ChangeState(enemy.initialAttackState);
    }
}
