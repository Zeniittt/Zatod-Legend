using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardianDeadState : EnemyState
{
    private Guardian enemy;

    public GuardianDeadState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, Guardian _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
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

        if(triggerCalled)
        {
            enemy.animator.enabled = false;
            enemy.StartCoroutine(enemy.FadeOut());

            enemy.SelfDestroy();
        }
    }
}
