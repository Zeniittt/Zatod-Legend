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
    public float skillUltimateStunDuration;
    public int damageSkilUltimate;

    [Header("Skill Second Informations")]
    [SerializeField] private Transform skillSecondRangeEffect;
    [SerializeField] private float radius;
    [SerializeField] private int damageSkillSecond;

    [Header("Skill Third Information")]
    [SerializeField] private int amountHeal;

    [Header("Skill Four Informations")]
    [SerializeField] private GameObject skillFourPrefab;
    [SerializeField] private Transform skillFourPosition;
    public int damageSkillFour;

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

    private Vector2 NearestEnemyPosition()
    {
        GameObject nearestEnemy = null;
        float shortestDistance = Mathf.Infinity;

        foreach (GameObject enemy in lineupDefense)
        {
            if(enemy != null)
            {
                float distance = Vector2.Distance(transform.position, enemy.transform.position);

                if(distance < shortestDistance)
                {
                    shortestDistance = distance;
                    nearestEnemy = enemy;
                }
            }
        }

        if(nearestEnemy != null)
            return nearestEnemy.transform.position;

        return Vector2.zero;
    }

    public void CastSkillUltimate()
    {
       Time.timeScale = 0;
       Vector2 targetPosition = NearestEnemyPosition();
       targetPosition.y -= .2f; // this line to adjust postion of Desert Dungeon

        GameObject newSkillUltimate = Instantiate(skillUltimatePrefab, targetPosition, Quaternion.identity, transform);
    }

    public void CastSkillSecond()
    {
        Collider2D[] colliders = Physics2D.OverlapCircleAll(skillSecondRangeEffect.position, radius, whatIsEnemy);

        foreach (var hit in colliders)
        {
            Enemy enemy = hit.GetComponent<Enemy>();

            if (enemy != null && !enemy.isDead)
            {
                EnemyStats target = hit.GetComponent<EnemyStats>();
                if(target != null)
                    stats.DoPhysicDamage(target, damageSkillSecond);

                if (!enemy.isDead)
                    enemy.canBeKnockback = true;
            }
        }
    }

    public void CastSkillThird()
    {
        foreach (GameObject ally in allies)
        {
            ally.GetComponent<CharacterFX>().CreateHealFX(ally.transform.position);
            ally.GetComponent<Character>().stats.IncreaseHealthBy(amountHeal);
            fx.CreatePopUpText(ally.transform.position, "+ " + amountHeal.ToString(), new Vector3(144, 255, 107));
        }
    }

    public void CastSkillFour()
    {
        GameObject newSkillFour = Instantiate(skillFourPrefab, skillFourPosition.position, Quaternion.identity, transform);

        newSkillFour.GetComponent<Leenald_GroundRaise_Controller>().SetupGroundRaise();
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
