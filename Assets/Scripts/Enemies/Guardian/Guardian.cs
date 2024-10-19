using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Guardian : Enemy
{
    #region

    public GuardianIdleState idleState { get; private set; }
    public GuardianMoveState moveState { get; private set; }
    public GuardianBattleState battleState { get; private set; }
    public GuardianAttackState attackState { get; private set; }

    #endregion

    protected override void Awake()
    {
        base.Awake();

        idleState = new GuardianIdleState(this, stateMachine, "Idle", this);
        moveState = new GuardianMoveState(this, stateMachine, "Move", this);
        battleState = new GuardianBattleState(this, stateMachine, "Idle", this);
        attackState = new GuardianAttackState(this, stateMachine, "Attack", this);
    }

    protected override void Start()
    {
        base.Start();

        Flip();

        enemyStates = new List<EnemyState>
        {
            idleState,
            attackState,
            idleState,
            attackState
        };

        isInitialTime = true;
        stateMachine.Initialize(idleState);
    }

    protected override void Update()
    {
        base.Update();

        if (currentStateIndex == enemyStates.Count - 1)
            currentStateIndex = 0;
    }

    public void GuardianMovement()
    {
        if (IsEnemyDetected())
        {
            currentStateIndex++;
            stateMachine.ChangeState(enemyStates[currentStateIndex]);
        }
        else
        {
            stateMachine.ChangeState(moveState);
        }
    }
}
