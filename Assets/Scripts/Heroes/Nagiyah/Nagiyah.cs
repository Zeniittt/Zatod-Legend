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
    public NagiyahSkillSecondState skillSecondState { get; private set; }

    #endregion

    [SerializeField] private GameObject knifePrefab;

    [Header("Skill Second Informations")]
    public bool isUnblockSkillSecond;
    private string knifeClone = "Nagiyah_Knife_Controller(Clone)";
    [SerializeField] private int damageKnifeInRend;
    [SerializeField] private Dictionary<GameObject, int> enemiesHasKnife;




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
        skillSecondState = new NagiyahSkillSecondState(this, stateMachine, "SkillSecond", this);
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
        float yOffset = Random.Range(-.5f, .5f);
        Vector3 offset = new Vector3(0, yOffset, 0);

        GameObject newKnife = Instantiate(knifePrefab, attackRange.position + offset, Quaternion.identity);
        newKnife.GetComponent<Nagiyah_Knife>().SetupKnife(this, facingDirection);
    }

    #region Skill Second

    public void CanCastSkillSecond()
    {
        enemiesHasKnife = CheckEnemyHasKnife();

        if (CanDeadByRend())
        {
            stateMachine.ChangeState(skillSecondState);

            foreach (KeyValuePair<GameObject, int> enemy in enemiesHasKnife)
            {
                stats.DoPhysicDamage(enemy.Key.GetComponent<CharacterStats>(), enemy.Value * 5);
            }

            DeleteAllKnife(knifeClone);
        }
    }

    void DeleteAllKnife(string name)
    {
        GameObject[] allKnife = GameObject.FindObjectsOfType<GameObject>();

        foreach (GameObject knife in allKnife)
        {
            if (knife.name == name)
            {
                Destroy(knife);
            }
        }
    }

    private bool CanDeadByRend()
    {
        foreach (KeyValuePair<GameObject, int> enemy in enemiesHasKnife)
        {
            CharacterStats targetStats = enemy.Key.GetComponent<CharacterStats>();
            int totalDamage = damageKnifeInRend * enemy.Value;

            if (targetStats.currentHealth - totalDamage <= 0)
                return true;
        }

        return false;
    }

    private Dictionary<GameObject, int> CheckEnemyHasKnife()
    {
        Dictionary<GameObject, int> result = new Dictionary<GameObject, int>();

        foreach (GameObject enemy in lineupDefense)
        {
            int amountKnife = 0;

            foreach (Transform child in enemy.transform)
            {
                if (child.name == knifeClone)
                    amountKnife++;
            }

            if (amountKnife > 0)
                result.Add(enemy, amountKnife);
        }

        return result;
    }

    #endregion
}
