using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern : Hero
{

    #region States

    public KavernIdleState idleState { get; private set; }
    public KavernMoveState moveState { get; private set; }
    public KavernBattleState battleState { get; private set; }
    public KavernAttackState attackState { get; private set; }
    public KavernStunnedState stunnedState { get; private set; }
    public KavernAfterStunnedState afterStunnedState { get; private set; }
    public KavernDeadState deadState { get; private set; }

    #endregion

    [SerializeField] private GameObject arrowPrefab;

    protected override void Awake()
    {
        base.Awake();

        idleState = new KavernIdleState(this, stateMachine, "Idle", this);
        moveState = new KavernMoveState(this, stateMachine, "Move", this);
        battleState = new KavernBattleState(this, stateMachine, "Idle", this);
        attackState = new KavernAttackState(this, stateMachine, "Attack", this);
        stunnedState = new KavernStunnedState(this, stateMachine, "Stunned", this);
        afterStunnedState = new KavernAfterStunnedState(this, stateMachine, "AfterStunned", this);
        deadState = new KavernDeadState(this, stateMachine, "Dead", this);
    }

    protected override void Start()
    {
        base.Start();

        heroStates = new List<HeroState>
        {
            idleState,
            attackState,
            idleState,
            attackState,
        };

        isInitialTime = true;
        stateMachine.Initialize(idleState);
    }

    protected override void Update()
    {
        base.Update();

        if (currentStateIndex == heroStates.Count - 1)
            currentStateIndex = -1;

        if (Input.GetKeyDown(KeyCode.D))
            stateMachine.ChangeState(deadState);

        if (Input.GetKeyDown(KeyCode.S))
        {
            canBeStun = true;
            stateMachine.ChangeState(stunnedState);
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

    public void KavernMovement()
    {
        if (CanAttack())
        {
            currentStateIndex++;
            stateMachine.ChangeState(heroStates[currentStateIndex]);
        }
        else
        {
            stateMachine.ChangeState(idleState);
        }
    }

    public void CreateArrow()
    {
        GameObject newArrow = Instantiate(arrowPrefab, attackRange.position, Quaternion.identity, transform);

        newArrow.GetComponent<Kavern_Arrow>().SetupArrow(facingDirection, stats);
    }
}
