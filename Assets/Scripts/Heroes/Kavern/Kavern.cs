using DG.Tweening;
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
    public KavernSkillSecondState skillSecondState { get; private set; }
    public KavernSkillThirdState skillThirdState { get; private set; }
    public KavernSkillFourState skillFourState { get; private set; }
    public KavernSkillUltimateState skillUltimateState { get; private set; }


    #endregion

    [SerializeField] private GameObject arrowPrefab;

    [Header("Skill Second Informations")]
    [SerializeField] private GameObject poisionArrowPrefab;
    [SerializeField] private int damageSkillSecond;
    public float poisionDuration;
    public int damageDPS;
    public float timeDoDamage;

    [Header("Skill Third Information")]
    [SerializeField] private GameObject diagonalArrowPrefab;
    public GameObject skillThirdTarget;
    [SerializeField] private float yPosition;
    [SerializeField] private int damageSkillThird;
    [SerializeField] private float jumpForce;
    [SerializeField] private float jumpDuration;

    [Header("Skill Four Informations")]
    [SerializeField] private GameObject showerArrowPrefab;
    public List<GameObject> skillFourTarget;
    public float skillFourStunDuration;
    public int damageArrow;
    public int damageRoot;

    [Header("Skill Ultimate Informations")]
    [SerializeField] private GameObject skillUltimatePrefab;
    [SerializeField] private Transform ultimateSkillPosition;
    public int damageSkilUltimate;

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
        skillSecondState = new KavernSkillSecondState(this, stateMachine, "SkillSecond", this);
        skillThirdState = new KavernSkillThirdState(this, stateMachine, "SkillThird", this);
        skillFourState = new KavernSkillFourState(this, stateMachine, "SkillFour", this);
        skillUltimateState = new KavernSkillUltimateState(this, stateMachine, "SkillUltimate", this);
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
            skillThirdState,
            idleState,
            attackState,
            idleState,
            skillFourState,
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

        Gizmos.color = Color.white;
        Gizmos.DrawWireSphere(ultimateSkillPosition.position, attackRangeRadius);
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
        GameObject newArrow = Instantiate(arrowPrefab, attackRange.position, Quaternion.identity);

        newArrow.GetComponent<Kavern_Arrow>().SetupArrow(facingDirection, stats);
    }

    #region Abilities

    public void CastSkillSecond()
    {
        GameObject newArrow = Instantiate(poisionArrowPrefab, attackRange.position, Quaternion.identity, transform);

        newArrow.GetComponent<Kavern_PoisionArrow>().SetupArrow(facingDirection, stats, this, damageSkillSecond);
    }

    public void CastSkillThirdEnter()
    {
        yPosition = transform.position.y;

        transform.DOMoveY(transform.position.y + jumpForce, jumpDuration)
            .SetEase(Ease.OutCubic);
    }

    public void CastSkillThirdExit()
    {
        transform.DOMoveY(yPosition, .1f)
            .SetEase(Ease.OutCubic);
    }

    public void CastSkillThird()
    {
        FindSkillThirdTarget();

        GameObject newArrow = Instantiate(diagonalArrowPrefab, attackRange.position, Quaternion.identity);

        newArrow.GetComponent<Kavern_DiagonalArrow>().SetupArrow(stats, this, damageSkillThird);

    }

    private void FindSkillThirdTarget()
    {
        skillThirdTarget = lineupDefense[0];
        int targetHealth = int.MaxValue;

        foreach(GameObject enemy in lineupDefense)
        {
            CharacterStats stat = enemy.GetComponent<CharacterStats>();
            if(stat.currentHealth < targetHealth)
            {
                targetHealth = stat.currentHealth;
                skillThirdTarget = enemy;
            }
        }
    }

    public void CastSkillFour()
    {
        FindSkillFourTarget();

        int count = 0;

        if (skillFourTarget.Count == 1) count = 1;
        else count = 2;

        for (int i = 0; i < count; i++)
        {
            GameObject newShowerArrow = Instantiate(showerArrowPrefab, skillFourTarget[i].transform.position, Quaternion.identity);
            newShowerArrow.GetComponent<Kavern_ShowerArrow_Controller>().SetupShowerArrow(stats, skillFourTarget[i], skillFourStunDuration, damageArrow, damageRoot);
        }

        skillFourTarget.Clear();
    }

    private void FindSkillFourTarget()
    {
        if (lineupDefense.Count == 1)
            skillFourTarget.Add(lineupDefense[0]);
        else
        {
            foreach (GameObject enemy in lineupDefense)
            {
                skillFourTarget.Add(enemy);
            }

            skillFourTarget = Shuffle(skillFourTarget);
        }
    }

    private List<GameObject> Shuffle(List<GameObject> list)
    {
        for (int i = list.Count - 1; i > 0; i--)
        {
            int j = Random.Range(0, i + 1);
            GameObject temp = list[i];
            list[i] = list[j];
            list[j] = temp;
        }

        return list;
    }

    public void CastSkillUltimate()
    {
        GameObject newSkillUltimate = Instantiate(skillUltimatePrefab, ultimateSkillPosition.transform.position, Quaternion.identity, transform);

        newSkillUltimate.GetComponent<Kavern_BeamExtension_Controller>().SetupBeamExtension(stats, lineupDefense, damageSkilUltimate);
    }

    #endregion
}
