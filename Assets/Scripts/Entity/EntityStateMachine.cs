using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EntityStateMachine
{
    public EntityState currentState { get; private set; }

    public void Initialize(EntityState _startState)
    {
        currentState = _startState;
        currentState.Enter();
    }

    public void ChangeState(EntityState _newState)
    {
        currentState.Exit();
        currentState = _newState;
        currentState.Enter();
    }
}
