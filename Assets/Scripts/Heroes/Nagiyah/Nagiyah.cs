using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Nagiyah : Hero
{

    #region States

    public NagiyahIdleState idleState { get; private set; }
    public NagiyahMoveState moveState { get; private set; }
    public NagiyahBattleState battleState { get; private set; }
    public NagiyahAttackState attackState { get; private set; }
    public NagiyahStunnedState stunnedState { get; private set; }
    public NagiyahAfterStunnedState afterStunnedState { get; private set; }
    public NagiyahDeadState deadState { get; private set; }

    #endregion

    [SerializeField] private GameObject knifePrefab;


    protected override void Awake()
    {
        base.Awake();

        idleState = new NagiyahIdleState(this, stateMachine, "Idle", this);
        moveState = new NagiyahMoveState(this, stateMachine, "Move", this);
        battleState = new NagiyahBattleState(this, stateMachine, "Idle", this);
        attackState = new NagiyahAttackState(this, stateMachine, "Attack", this);
        stunnedState = new NagiyahStunnedState(this, stateMachine, "Stunned", this);
        afterStunnedState = new NagiyahAfterStunnedState(this, stateMachine, "AfterStunned", this);
        deadState = new NagiyahDeadState(this, stateMachine, "Dead", this);
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

    public void NagiyahMovement()
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

    public void CreateKnife()
    {
        GameObject newKnife = Instantiate(knifePrefab, attackRange.position, Quaternion.identity);

        newKnife.GetComponent<Nagiyah_Knife>().SetupKnife(facingDirection, stats);
    }
}
