using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KavernBattleState : HeroState
{
    private Kavern hero;

    public KavernBattleState(Hero _heroBase, HeroStateMachine _stateMachine, string _animBoolName, Kavern _hero) : base(_heroBase, _stateMachine, _animBoolName)
    {
        this.hero = _hero;
    }

    public override void Enter()
    {
        base.Enter();

        hero.isInitialTime = false;
    }

    public override void Exit()
    {
        base.Exit();
    }

    public override void Update()
    {
        base.Update();

        stateMachine.ChangeState(hero.heroStates[hero.currentStateIndex]);
    }
}
