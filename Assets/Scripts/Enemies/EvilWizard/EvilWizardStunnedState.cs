using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EvilWizardStunnedState : EnemyState
{
    private EvilWizard enemy;

    public EvilWizardStunnedState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, EvilWizard _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
    {
        this.enemy = _enemy;
    }

    public override void Enter()
    {
        base.Enter();


        if (enemy.canBeStun)
        {
            enemy.fx.CastStunFX();
        }

        if (enemy.canBeKnockback)
        {
            enemy.CastKnockback();
            enemy.canBeKnockback = false;
        }

        if (enemy.canBeKnockup)
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
