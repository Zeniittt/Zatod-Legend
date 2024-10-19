using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeroStateMachine
{
    public HeroState currentState { get; private set; }

    public void Initialize(HeroState _startState)
    {
        currentState = _startState;
        currentState.Enter();
    }

    public void ChangeState(HeroState _newState)
    {
        currentState.Exit();
        currentState = _newState;
        currentState.Enter();
    }
}
