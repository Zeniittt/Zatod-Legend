using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Huntress : Enemy
{
    #region States

    public HuntressIdleState idleState { get; private set; }
    public HuntressMoveState moveState { get; private set; }
    public HuntressBattleState battleState { get; private set; }
    public HuntressAttackState attackState { get; private set; }
    public HuntressStunnedState stunnedState { get; private set; }
    public HuntressAfterStunnedState afterStunnedState { get; private set; }
    public HuntressDeadState deadState { get; private set; }

    #endregion

    [SerializeField] private GameObject spearPrefab;


    protected override void Awake()
    {
        base.Awake();

        idleState = new HuntressIdleState(this, stateMachine, "Idle", this);
        moveState = new HuntressMoveState(this, stateMachine, "Move", this);
        battleState = new HuntressBattleState(this, stateMachine, "Idle", this);
        attackState = new HuntressAttackState(this, stateMachine, "Attack", this);
        stunnedState = new HuntressStunnedState(this, stateMachine, "Stunned", this);
        afterStunnedState = new HuntressAfterStunnedState(this, stateMachine, "AfterStunned", this);
        deadState = new HuntressDeadState(this, stateMachine, "Dead", this);
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

    public void HuntressMovement()
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

    public void CreateSpear()
    {
        GameObject newArrow = Instantiate(spearPrefab, attackRange.position, Quaternion.identity, transform);

        newArrow.GetComponent<Huntress_Spear>().SetupSpear(facingDirection, stats);
    }
}
