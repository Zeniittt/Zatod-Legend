using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Huntress_SpearIdleState : EntityState
{
    private Huntress_Spear entity;

    public Huntress_SpearIdleState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, Huntress_Spear _entity) : base(_entityBase, _stateMachine, _animBoolName)
    {
        this.entity = _entity;
    }

    public override void Enter()
    {
        base.Enter();

        entity.SelfDestroy();
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
