using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Archer : Enemy
{
    #region States

    public ArcherIdleState idleState { get; private set; }
    public ArcherMoveState moveState { get; private set; }
    public ArcherBattleState battleState { get; private set; }
    public ArcherAttackState attackState { get; private set; }
    public ArcherStunnedState stunnedState { get; private set; }
    public ArcherAfterStunnedState afterStunnedState { get; private set; }
    public ArcherDeadState deadState { get; private set; }

    #endregion

    [SerializeField] private GameObject arrowPrefab;

    protected override void Awake()
    {
        base.Awake();

        idleState = new ArcherIdleState(this, stateMachine, "Idle", this);
        moveState = new ArcherMoveState(this, stateMachine, "Move", this);
        battleState = new ArcherBattleState(this, stateMachine, "Idle", this);
        attackState = new ArcherAttackState(this, stateMachine, "Attack", this);
        stunnedState = new ArcherStunnedState(this, stateMachine, "Stunned", this);
        afterStunnedState = new ArcherAfterStunnedState(this, stateMachine, "AfterStunned", this);
        deadState = new ArcherDeadState(this, stateMachine, "Dead", this);
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
        };

        isInitialTime = true;
        stateMachine.Initialize(idleState);
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

    public void ArcherMovement()
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

    public void CreateArrow()
    {
        GameObject newArrow = Instantiate(arrowPrefab, attackRange.position, Quaternion.identity, transform);

        newArrow.GetComponent<Archer_Arrow>().SetupArrow(facingDirection, stats);
    }
}
