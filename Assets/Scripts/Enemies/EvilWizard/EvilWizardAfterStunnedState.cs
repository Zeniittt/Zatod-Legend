using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EvilWizardAfterStunnedState : EnemyState
{
    private EvilWizard enemy;

    public EvilWizardAfterStunnedState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, EvilWizard _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
    {
        this.enemy = _enemy;
    }

    public override void Enter()
    {
        base.Enter();

        if (enemy.canBeStun)
        {
            stateTimer = enemy.stunDuration;
        }
        else
        {
            stateTimer = 1;
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

            enemy.canBeStun = false;

            if (enemy.isInitialTime)
                stateMachine.ChangeState(enemy.moveState);
            else
            {
                enemy.EvilWizardMovement();
            }
        }
    }
}
