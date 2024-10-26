using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Archer_ArrowMoveState : EntityState
{
    private Archer_Arrow entity;

    public Archer_ArrowMoveState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, Archer_Arrow _entity) : base(_entityBase, _stateMachine, _animBoolName)
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
