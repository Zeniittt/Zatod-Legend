using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Huntress_SpearMoveState : EntityState
{
    private Huntress_Spear entity;

    public Huntress_SpearMoveState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, Huntress_Spear _entity) : base(_entityBase, _stateMachine, _animBoolName)
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

        entity.SetVelocity(entity.speed * entity.direction, entity.rb.velocity.y);
    }
}
