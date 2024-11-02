using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Nagiyah_KnifeLandState : EntityState
{
    private Nagiyah_Knife entity;

    public Nagiyah_KnifeLandState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, Nagiyah_Knife _entity) : base(_entityBase, _stateMachine, _animBoolName)
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

        entity.SetZeroVelocity();
    }
}
