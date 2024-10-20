using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : Entity
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

        stateMachine.currentState.Update();

    }

    public virtual void AnimationFinishTrigger() => stateMachine.currentState.AnimationFinishTrigger();

    public virtual void CanBeKnockback() {  }

    public virtual void CallCanBeKnockback()
    {
        if (this.GetType() != typeof(Enemy))
        {
            this.CanBeKnockback(); // G?i ph??ng th?c l?p con
        }
        else
        {
            Debug.Log("Cha rong");
        }
    }

    public virtual void CastKnockback()
    {
        rb.velocity = new Vector2(knockbackDirection.x * -facingDirection, knockbackDirection.y);
    }
}
