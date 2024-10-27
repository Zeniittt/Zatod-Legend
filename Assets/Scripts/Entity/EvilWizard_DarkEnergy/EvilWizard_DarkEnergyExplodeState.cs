using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EvilWizard_DarkEnergyExplodeState : EntityState
{
    private EvilWizard_DarkEnergy entity;

    public EvilWizard_DarkEnergyExplodeState(Entity _entityBase, EntityStateMachine _stateMachine, string _animBoolName, EvilWizard_DarkEnergy _entity) : base(_entityBase, _stateMachine, _animBoolName)
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
