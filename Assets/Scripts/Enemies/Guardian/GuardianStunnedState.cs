using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardianStunnedState : EnemyState
{
    private Guardian enemy;

    public GuardianStunnedState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, Guardian _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
    {
        this.enemy = _enemy;
    }

    public override void Enter()
    {
        base.Enter();

        if(enemy.canBeStun)
        {
            enemy.CastStun();
        }

        if (enemy.canBeKnockback)
        {
            enemy.CastKnockback();
            enemy.canBeKnockback = false;
        }
        
        if(enemy.canBeKnockup)
        {
            enemy.CastKnockup();
            enemy.canBeKnockup = false;
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

        if (triggerCalled)
        {
            stateMachine.ChangeState(enemy.afterStunnedState);
        }
    }
}
