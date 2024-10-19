using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeroState
{
    protected HeroStateMachine stateMachine;
    protected Hero heroBase;
    protected Rigidbody2D rigidbody;

    private string animBoolName;

    protected float stateTimer;
    protected bool triggerCalled;


    public HeroState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName)
    {
        this.heroBase = _heroBase;
        this.stateMachine = _stateMachine;
        this.animBoolName = _animBoolName;
    }

    public virtual void Enter()
    {
        triggerCalled = false;
        rigidbody = heroBase.rb;
        heroBase.animator.SetBool(animBoolName, true);
    }

    public virtual void Update()
    {
        stateTimer -= Time.deltaTime;

    }

    public virtual void Exit()
    {
        heroBase.animator.SetBool(animBoolName, false);
        /*        enemyBase.AssignLastAnimName(animBoolName);*/
    }

    public virtual void AnimationFinishTrigger()
    {
        triggerCalled = true;
    }
}
