using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hero : Character
{
    public HeroStateMachine stateMachine { get; private set; }

    public List<HeroState> heroStates;

    protected override void Awake()
    {
        base.Awake();

        stateMachine = new HeroStateMachine();
    }

    protected override void Start()
    {
        base.Start();
    }

    protected override void Update()
    {
        base.Update();

        FindAllEnemiesInArea(transform.position);
        DetectAndIgnoreAlly();

        stateMachine.currentState.Update();

    }

    public override void FindAllEnemiesInArea(Vector2 _position)
    {
        base.FindAllEnemiesInArea(_position);

        Collider2D[] hitColliders = Physics2D.OverlapBoxAll(_position, observeRangeSize, 0f, whatIsEnemy);

        foreach (Collider2D collider in hitColliders)
        {
            Enemy enemy = collider.GetComponent<Enemy>();
            if (enemy != null)
            {
                enemies.Add(enemy);
            }
        }
    }

    public bool ExistEnemyInObserve()
    {
        if (enemies.Count > 0)
            return true;

        return false;
    }

    public virtual void AnimationFinishTrigger() => stateMachine.currentState.AnimationFinishTrigger();


    private void DetectAndIgnoreAlly()
    {
        Collider2D[] colliders = Physics2D.OverlapBoxAll(ignoreAlly.position, ignoreBoxSize, whatIsAlly);

        foreach (var collider in colliders)
        {
            GameObject character = collider.gameObject;

            if (character != null && IsAlly(character))
            {
                Physics2D.IgnoreCollision(cd, collider);
            }
        }

    }

    public  bool IsAlly(GameObject _detectedCharacter)
    {

        Hero thisCharacter = GetComponent<Hero>();
        Hero detectedCharacter = _detectedCharacter.GetComponent<Hero>();

        if (thisCharacter != null && detectedCharacter != null)
            return true;

        return false;
    }

    public virtual void UseUltimateSkill() { }
}
