using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HuntressAttackState : EnemyState
{
    private Huntress enemy;
    public HuntressAttackState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, Huntress _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
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

        enemy.SetZeroVelocity();

        if (triggerCalled)
        {
            enemy.HuntressMovement();
        }
    }
}
