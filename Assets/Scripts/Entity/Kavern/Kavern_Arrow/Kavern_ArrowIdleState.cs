using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_ArrowIdleState : EntityState
{
    private Kavern_Arrow entity;

    public Kavern_ArrowIdleState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, Kavern_Arrow _entity) : base(_entityBase, _stateMachine, _animBoolName)
    {
        this.entity = _entity;
    }

    public override void Enter()
    {
        base.Enter();
    }

    public override void Exit()
    {
        base.Exit();
    }

    public override void Update()
    {
        base.Update();
    }
}
