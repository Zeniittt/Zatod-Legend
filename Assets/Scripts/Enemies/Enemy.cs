using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : Character
{
    public EnemyStateMachine stateMachine { get; private set; }

    public List<EnemyState> enemyStates;

    protected override void Awake()
    {
        base.Awake();

        stateMachine = new EnemyStateMachine();

    }

    protected override void Start()
    {
        base.Start();
    }

    protected override void Update()
    {
        base.Update();

        DetectAndIgnoreAlly();

        stateMachine.currentState.Update();

    }

    private void DetectAndIgnoreAlly()
    {
        Collider2D[] colliders = Physics2D.OverlapBoxAll(ignoreAlly.position, ignoreBoxSize, whatIsAlly);

        foreach (var collider in colliders)
        {
            GameObject character = collider.gameObject;

            if (character != null && IsAlly(character))
            {
                Physics2D.IgnoreCollision(cd, collider);
            }
        }

    }

    public bool IsAlly(GameObject _detectedCharacter)
    {

        Enemy thisCharacter = GetComponent<Enemy>();
        Enemy detectedCharacter = _detectedCharacter.GetComponent<Enemy>();

        if (thisCharacter != null && detectedCharacter != null)
            return true;

        return false;
    }

    public virtual void AnimationFinishTrigger() => stateMachine.currentState.AnimationFinishTrigger();
}
