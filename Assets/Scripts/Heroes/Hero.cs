using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hero : Character
{
    public HeroStateMachine stateMachine { get; private set; }

    public List<HeroState> heroStates;

    private Lineup lineupDefenseScript;
    public List<GameObject> lineupDefense;

    protected override void Awake()
    {
        base.Awake();

        stateMachine = new HeroStateMachine();

        lineupDefenseScript = GameObject.Find("LineupDefense").GetComponent<Lineup>();

    }

    protected override void Start()
    {
        base.Start();
    }

    protected override void Update()
    {
        base.Update();

        lineupDefense = lineupDefenseScript.lineup;
        targetEnemy = FindTargetEnemy();

        stateMachine.currentState.Update();

    }

    public GameObject FindTargetEnemy()
    {
        GameObject nearestEnemy = null;
        float shortestDistance = Mathf.Infinity;

        foreach (GameObject enemy in lineupDefense)
        {
            if (enemy != null)
            {
                float distance = Vector2.Distance(transform.position, enemy.transform.position);

                if (distance < shortestDistance)
                {
                    shortestDistance = distance;
                    nearestEnemy = enemy;
                }
            }
        }

        return nearestEnemy;
    }

    public virtual void AnimationFinishTrigger() => stateMachine.currentState.AnimationFinishTrigger();


    public virtual void UseUltimateSkill() { }
}
