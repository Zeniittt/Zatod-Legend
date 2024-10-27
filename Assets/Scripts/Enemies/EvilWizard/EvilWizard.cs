using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EvilWizard : Enemy
{
    #region States

    public EvilWizardIdleState idleState { get; private set; }
    public EvilWizardMoveState moveState { get; private set; }
    public EvilWizardBattleState battleState { get; private set; }
    public EvilWizardAttackState attackState { get; private set; }
    public EvilWizardStunnedState stunnedState { get; private set; }
    public EvilWizardAfterStunnedState afterStunnedState { get; private set; }
    public EvilWizardDeadState deadState { get; private set; }

    #endregion

    [SerializeField] private GameObject darkEnergyPrefab;

    protected override void Awake()
    {
        base.Awake();

        idleState = new EvilWizardIdleState(this, stateMachine, "Idle", this);
        moveState = new EvilWizardMoveState(this, stateMachine, "Move", this);
        battleState = new EvilWizardBattleState(this, stateMachine, "Idle", this);
        attackState = new EvilWizardAttackState(this, stateMachine, "Attack", this);
        stunnedState = new EvilWizardStunnedState(this, stateMachine, "Stunned", this);
        afterStunnedState = new EvilWizardAfterStunnedState(this, stateMachine, "AfterStunned", this);
        deadState = new EvilWizardDeadState(this, stateMachine, "Dead", this);
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

    public void EvilWizardMovement()
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

    public void CreateDarkEnergy()
    {
        GameObject newArrow = Instantiate(darkEnergyPrefab, attackRange.position, Quaternion.identity, transform);

        newArrow.GetComponent<EvilWizard_DarkEnergy>().SetupDarkEnergy(facingDirection, stats);
    }
}
