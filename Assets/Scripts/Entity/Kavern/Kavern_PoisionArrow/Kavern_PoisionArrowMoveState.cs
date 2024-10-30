using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_PoisionArrowMoveState : EntityState
{
    private Kavern_PoisionArrow entity;

    public Kavern_PoisionArrowMoveState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, Kavern_PoisionArrow _entity) : base(_entityBase, _stateMachine, _animBoolName)
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
