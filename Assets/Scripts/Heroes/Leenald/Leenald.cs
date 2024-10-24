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

    [Header("Skill Third Information")]
    [SerializeField] protected List<Character> allies;
    [SerializeField] private int amountHeal;

    [Header("Skill Four Informations")]
    [SerializeField] private GameObject skillFourPrefab;
    [SerializeField] private Transform skillFourPosition;

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
        {
            animator.updateMode = AnimatorUpdateMode.UnscaledTime;
            stateMachine.ChangeState(skillUltimateState);
        }    

        if (Input.GetKeyDown(KeyCode.D))
            stateMachine.ChangeState(deadState);

        if (Input.GetKeyDown(KeyCode.S))
        {
            canBeStun = true;
            stateMachine.ChangeState(stunnedState);
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
            stateMachine.ChangeState(idleState);
        }
    }

    private Vector2 ClosestEnemy()
    {
        Vector2 closestEnemyPosition = enemies[0].gameObject.transform.position;

        foreach (Enemy enemy in enemies)
        {
            if (enemy.transform.position.x < closestEnemyPosition.x)
                closestEnemyPosition = enemy.transform.position;
        }

        return closestEnemyPosition;
    }

    public void CastSkillUltimate()
    {
       Time.timeScale = 0;
       Vector2 targetPosition = ClosestEnemy();
       targetPosition.y -= .2f; // this line to adjust postion of Desert Dungeon

        GameObject newSkillUltimate = Instantiate(skillUltimatePrefab, targetPosition, Quaternion.identity);
    }

    public void CastSkillSecond()
    {
        Collider2D[] colliders = Physics2D.OverlapCircleAll(skillSecondRangeEffect.position, radius, whatIsEnemy);

        foreach (var hit in colliders)
        {
            if (hit.GetComponent<Enemy>() != null)
            {
                hit.GetComponent<Enemy>().canBeKnockback = true;
            }
        }
    }

    public void CastSkillThird()
    {
        FindAllAllyInArea(transform.position);

        foreach (Hero ally in allies)
        {
            fx.CreateHealFX(ally.transform.position);
            ally.stats.IncreaseHealthBy(amountHeal);
        }

        allies.Clear();
    }


    private void FindAllAllyInArea(Vector2 _position)
    {
        Collider2D[] hitColliders = Physics2D.OverlapBoxAll(_position, observeRangeSize, 0f, whatIsAlly);

        foreach (Collider2D collider in hitColliders)
        {
            Hero ally = collider.GetComponent<Hero>();
            if (ally != null)
            {
                allies.Add(ally);
            }
        }
    }

    public void CastSkillFour()
    {
        GameObject newSkillFour = Instantiate(skillFourPrefab, skillFourPosition.position, Quaternion.identity);
    }

    protected override void OnDrawGizmos()
    {
        base.OnDrawGizmos();

        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(skillSecondRangeEffect.position, radius);
    }

    public override void Die()
    {
        base.Die();

        stateMachine.ChangeState(deadState);
    }
}
