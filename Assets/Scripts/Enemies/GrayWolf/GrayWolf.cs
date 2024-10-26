using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayWolf : Enemy
{
    #region States

    public GrayWolfIdleState idleState { get; private set; }
    public GrayWolfMoveState moveState { get; private set; }
    public GrayWolfRunState runState { get; private set; }
    public GrayWolfBattleState battleState { get; private set; }
    public GrayWolfInitialAttack initialAttackState { get; private set; }
    public GrayWolfAttackState attackState { get; private set; }
    public GrayWolfStunnedState stunnedState { get; private set; }
    public GrayWolfAfterStunnedState afterStunnedState { get; private set; }
    public GrayWolfDeadState deadState { get; private set; }

    #endregion


    [Space]
    [Space]
    [Header("GrayWolf Basic Informations")]
    public float runSpeed;
    public Transform initialAttackDetect;
    public float initialAttackDistance;
    public Transform initialAttackRange;
    public float initialAttackRangeRadius;
    public int initialDamage;

    protected override void Awake()
    {
        base.Awake();

        idleState = new GrayWolfIdleState(this, stateMachine, "Idle", this);
        moveState = new GrayWolfMoveState(this, stateMachine, "Move", this);
        runState = new GrayWolfRunState(this, stateMachine, "Run", this);
        battleState = new GrayWolfBattleState(this, stateMachine, "Idle", this);
        initialAttackState = new GrayWolfInitialAttack(this, stateMachine, "InitialAttack", this);
        attackState = new GrayWolfAttackState(this, stateMachine, "Attack", this);
        stunnedState = new GrayWolfStunnedState(this, stateMachine, "Stunned", this);
        afterStunnedState = new GrayWolfAfterStunnedState(this, stateMachine, "AfterStunned", this);
        deadState = new GrayWolfDeadState(this, stateMachine, "Dead", this);
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

    protected override void OnDrawGizmos()
    {
        base.OnDrawGizmos();

        Gizmos.color = Color.red;
        Gizmos.DrawLine(initialAttackDetect.position, new Vector3(initialAttackDetect.position.x + initialAttackDistance * facingDirection, initialAttackDetect.position.y));

        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(initialAttackRange.position, initialAttackRangeRadius);
    }

    public void GrayWolfMovement()
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

    public virtual bool InitialAttackDetected()
    {
        RaycastHit2D hit = Physics2D.Raycast(initialAttackDetect.position, Vector2.right * facingDirection, initialAttackDistance, whatIsEnemy);

        if (hit.collider != null)
        {
            Character enemy = hit.collider.GetComponent<Character>();

            if (enemy != null && !enemy.isDead)
            {
                return true;
            }
        }

        return false;
    }
}
