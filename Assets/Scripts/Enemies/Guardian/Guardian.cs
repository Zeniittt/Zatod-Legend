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
    public GuardianStunnedState stunnedState { get; private set; }
    public GuardianAfterStunnedState afterStunnedState { get; private set; }
    public GuardianDeadState deadState { get; private set; }

    #endregion

    protected override void Awake()
    {
        base.Awake();

        idleState = new GuardianIdleState(this, stateMachine, "Idle", this);
        moveState = new GuardianMoveState(this, stateMachine, "Move", this);
        battleState = new GuardianBattleState(this, stateMachine, "Idle", this);
        attackState = new GuardianAttackState(this, stateMachine, "Attack", this);
        stunnedState = new GuardianStunnedState(this, stateMachine, "Stunned", this);
        afterStunnedState = new GuardianAfterStunnedState(this, stateMachine, "AfterStunned", this);
        deadState = new GuardianDeadState(this, stateMachine, "Dead", this);
    }

    protected override void Start()
    {
        base.Start();

        SetupGuardian();
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

    private void SetupGuardian()
    {
        if (yPositionDefault == -1.95f)
            transform.position = new Vector3(transform.position.x, yPositionDefault, 1);
        else if(yPositionDefault == -2.45f)
            transform.position = new Vector3(transform.position.x, yPositionDefault, 0);
    }

    protected override void Update()
    {
        base.Update();

        if (currentStateIndex == enemyStates.Count - 1)
            currentStateIndex = 0;

        if (canBeStun && !fx.stunObject.gameObject.activeSelf)
        {
            stateMachine.ChangeState(stunnedState);
        }

        if (canBeKnockback)
            Knockback();

        if (canBeKnockup)
            Knockup();
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

    public override void Knockback()
    {
        base.Knockback();

        stateMachine.ChangeState(stunnedState);
    }

    public override void Knockup()
    {
        base.Knockup();

        stateMachine.ChangeState(stunnedState);
    }

    public override void Die()
    {
        base.Die();

        stateMachine.ChangeState(deadState);
    }
}
