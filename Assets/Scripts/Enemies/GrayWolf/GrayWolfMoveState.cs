using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayWolfMoveState : EnemyState
{
    private GrayWolf enemy;

    public GrayWolfMoveState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, GrayWolf _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
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

        enemy.SetVelocity(enemy.moveSpeed * enemy.facingDirection, rb.velocity.y);

        if (enemy.CanAttack())
            stateMachine.ChangeState(enemy.battleState);
    }
}
