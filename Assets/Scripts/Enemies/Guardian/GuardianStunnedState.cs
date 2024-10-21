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

        if (enemy.canBeStun)
        {
            enemy.Stun();
        }
        else if (enemy.canBeKnockback)
        {
            enemy.CastKnockback();
            enemy.canBeKnockback = false;
        }
        else if(enemy.canBeKnockup)
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

        if (triggerCalled)
        {
            stateMachine.ChangeState(enemy.idleState); // tuy chon dung yen hay di chuyen ngay sau khi knockback
            //enemy.GuardianMovement();
        }
    }
}
