using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HuntressDeadState : EnemyState
{
    private Huntress enemy;

    public HuntressDeadState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, Huntress _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
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

        if (triggerCalled)
        {
            enemy.animator.enabled = false;
            enemy.StartCoroutine(enemy.fx.FadeOut());

            enemy.SelfDestroy();
        }
    }
}
