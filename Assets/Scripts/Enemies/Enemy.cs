using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : Character
{
    public EnemyStateMachine stateMachine { get; private set; }

    public List<EnemyState> enemyStates;

    private Lineup lineupAttackScript;
    public List<GameObject> lineupAttack;

    protected override void Awake()
    {
        base.Awake();

        stateMachine = new EnemyStateMachine();

        lineupAttackScript = GameObject.Find("LineupAttack").GetComponent<Lineup>();
    }

    protected override void Start()
    {
        base.Start();
    }

    protected override void Update()
    {
        base.Update();

        lineupAttack = lineupAttackScript.lineup;
        targetEnemy = FindTargetEnemy();

        stateMachine.currentState.Update();
    }

    public GameObject FindTargetEnemy()
    {
        GameObject nearestEnemy = null;
        float shortestDistance = Mathf.Infinity;

        foreach (GameObject enemy in lineupAttack)
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
}
