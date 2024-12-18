using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HuntressIdleState : EnemyState
{
    private Huntress enemy;

    public HuntressIdleState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, Huntress _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
    {
        this.enemy = _enemy;
    }

    public override void Enter()
    {
        base.Enter();

        if (enemy.isInitialTime)
        {
            stateTimer = enemy.idleTimeInitial;
        }
        else
        {
            stateTimer = enemy.idleTime;
        }
    }

    public override void Exit()
    {
        base.Exit();
    }

    public override void Update()
    {
        base.Update();

        enemy.SetZeroVelocity();

        if (stateTimer < 0)
        {
            if (enemy.isInitialTime)
                stateMachine.ChangeState(enemy.moveState);
            else
            {
                enemy.HuntressMovement();
            }
        }
    }
}
