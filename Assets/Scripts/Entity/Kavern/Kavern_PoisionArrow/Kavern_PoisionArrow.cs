using System.Collections;
using System.Collections.Generic;
using Unity.IO.LowLevel.Unsafe;
using UnityEngine;

public class Kavern_PoisionArrow : Entity
{
    #region States

    public Kavern_PoisionArrowMoveState moveState { get; private set; }
    public Kavern_PoisionArrowExplodeState explodeState { get; private set; }

    #endregion

    private Kavern kavern;

    [SerializeField] private string targetLayerName = "Enemy";
    public float speed;
    private int damage;
    public int direction;
    private CharacterStats myStats;


    protected override void Awake()
    {
        base.Awake();

        moveState = new Kavern_PoisionArrowMoveState(this, stateMachine, "Move", this);
        explodeState = new Kavern_PoisionArrowExplodeState(this, stateMachine, "Explode", this);
    }

    protected override void Start()
    {
        base.Start();
        FlipArrow();

        stateMachine.Initialize(moveState);
    }

    protected override void Update()
    {
        base.Update();
    }

    public void SetupArrow(int _direction, CharacterStats _myStats, Kavern _kavern, int _damage)
    {
        direction = _direction;
        myStats = _myStats;
        kavern = _kavern;
        damage = _damage;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer(targetLayerName))
        {
            myStats.DoMagicalDamage(collision.GetComponent<CharacterStats>(), damage);

            stateMachine.ChangeState(explodeState);
            collision.GetComponent<CharacterFX>().CreatePoision(collision.transform, 
                kavern.poisionDuration, kavern.damageDPS, kavern.timeDoDamage);
        }
    }

    public void SelfDestroy()
    {
        Destroy(gameObject, 1f);
    }

    private void FlipArrow()
    {
        if (direction == -1)
            transform.Rotate(0, 0, 180);
    }
}
