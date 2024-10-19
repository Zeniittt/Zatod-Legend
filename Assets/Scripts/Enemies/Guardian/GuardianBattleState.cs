using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardianBattleState : EnemyState
{
    private Guardian enemy;

    public GuardianBattleState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, Guardian _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
    {
        this.enemy = _enemy;
    }

    public override void Enter()
    {
        base.Enter();

        enemy.isInitialTime = false;
    }

    public override void Exit()
    {
        base.Exit();
    }

    public override void Update()
    {
        base.Update();

        stateMachine.ChangeState(enemy.enemyStates[enemy.currentStateIndex]);
    }
}
