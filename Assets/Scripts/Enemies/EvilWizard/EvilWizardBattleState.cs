using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EvilWizardBattleState : EnemyState
{
    private EvilWizard enemy;

    public EvilWizardBattleState(Enemy _enemyBase, EnemyStateMachine _stateMachine, string _animBoolName, EvilWizard _enemy) : base(_enemyBase, _stateMachine, _animBoolName)
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
