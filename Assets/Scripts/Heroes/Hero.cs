using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hero : Character
{
    public HeroStateMachine stateMachine { get; private set; }

    public List<HeroState> heroStates;

    protected override void Awake()
    {
        base.Awake();

        stateMachine = new HeroStateMachine();
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

    public virtual void UseUltimateSkill() { }
}
