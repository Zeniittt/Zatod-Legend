using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Leenald : Hero
{
    #region

    public LeenaldIdleState idleState { get; private set; }
    public LeenaldMoveState moveState { get; private set; }
    public LeenaldBattleState battleState { get; private set; }
    public LeenaldAttackState attackState { get; private set; }
    public LeenaldStunnedState stunnedState { get; private set; }
    public LeenaldDeadState deadState { get; private set; }
    public LeenalSkillSecondState skillSecondState { get; private set; }
    public LeenaldSkillThirdState skillThirdState { get; private set; }
    public LeenaldSkillFourState skillFourState { get; private set; }
    public LeenaldSkillUltimateState skillUltimateState { get; private set; }

    #endregion

    [Header("Skill Ultimate Informations")]
    [SerializeField] private GameObject skillUltimatePrefab;

    [Header("Skill Second Informations")]
    [SerializeField] private Transform skillSecondRangeEffect;
    [SerializeField]private float radius;

    [Header("Skill Four Informations")]
    [SerializeField] private GameObject skillFourPrefab;

    protected override void Awake()
    {
        base.Awake();

        idleState = new LeenaldIdleState(this, stateMachine, "Idle", this);
        moveState = new LeenaldMoveState(this, stateMachine, "Move", this);
        battleState = new LeenaldBattleState(this, stateMachine, "Idle", this);
        attackState = new LeenaldAttackState(this, stateMachine, "Attack", this);
        stunnedState = new LeenaldStunnedState(this, stateMachine, "Stunned", this);
        deadState = new LeenaldDeadState(this, stateMachine, "Dead", this);
        skillSecondState = new LeenalSkillSecondState(this, stateMachine, "SkillSecond", this);
        skillThirdState = new LeenaldSkillThirdState(this, stateMachine, "SkillThird", this);
        skillFourState = new LeenaldSkillFourState(this, stateMachine, "SkillFour", this);
        skillUltimateState = new LeenaldSkillUltimateState(this, stateMachine, "SkillUltimate", this);
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
            idleState,
            skillSecondState,
            idleState,
            attackState,
            idleState,
            skillFourState,
            idleState,
            attackState,
            idleState,
            skillThirdState,
        };

        isInitialTime = true;
        stateMachine.Initialize(idleState);
    }

    protected override void Update()
    {
        base.Update();

        if (currentStateIndex == heroStates.Count - 1)
            currentStateIndex = -1;

        if (Input.GetKeyDown(KeyCode.R))
            stateMachine.ChangeState(skillUltimateState);

        if (Input.GetKeyDown(KeyCode.D))
            stateMachine.ChangeState(deadState);

        if (Input.GetKeyDown(KeyCode.S))
            stateMachine.ChangeState(stunnedState);
    }

    public void CastSkillUltimate()
    {
        GameObject newSkillUltimate = Instantiate(skillUltimatePrefab, transform.position, Quaternion.identity);
    }

    public void CastSkillFour()
    {
        GameObject newSkillFour = Instantiate(skillFourPrefab, transform.position, Quaternion.identity);
    }

    public void CastSkillSecond()
    {
        Collider2D[] colliders = Physics2D.OverlapCircleAll(skillSecondRangeEffect.position, radius, whatIsEnemy);

        foreach (var hit in colliders)
        {
            if (hit.GetComponent<Enemy>() != null)
            {
                Debug.Log("Second skill damage");
            }
        }
    }

    public void LeenaldMovement()
    {
        if (IsEnemyDetected())
        {
            currentStateIndex++;
            stateMachine.ChangeState(heroStates[currentStateIndex]);
        }
        else
        {
            stateMachine.ChangeState(moveState);
        }
    }

    protected override void OnDrawGizmos()
    {
        base.OnDrawGizmos();

        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(skillSecondRangeEffect.position, radius);
    }


}
