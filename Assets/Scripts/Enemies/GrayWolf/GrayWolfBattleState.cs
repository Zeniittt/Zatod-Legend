using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayWolfBattleState : EnemyState
{
    private GrayWolf enemy;

    public GrayWolfBattleState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, GrayWolf _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
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
