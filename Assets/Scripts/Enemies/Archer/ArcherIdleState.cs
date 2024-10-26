using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArcherIdleState : EnemyState
{
    private Archer enemy;

    public ArcherIdleState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, Archer _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
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
                enemy.ArcherMovement();
            }
        }
    }
}