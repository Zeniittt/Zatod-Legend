using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_PoisionArrowExplodeState : EntityState
{
    private Kavern_PoisionArrow entity;

    public Kavern_PoisionArrowExplodeState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, Kavern_PoisionArrow _entity) : base(_entityBase, _stateMachine, _animBoolName)
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

        entity.SetZeroVelocity();
    }
}
