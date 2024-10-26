using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Archer_Arrow : Entity
{
    #region

    public Archer_ArrowIdleState idleState { get; private set; }
    public Archer_ArrowMoveState moveState { get; private set; }

    #endregion

    [SerializeField] private string targetLayerName = "Hero";
    public float speed;
    [SerializeField] private bool canMove;

    private CharacterStats myStats;
    public int direction;

    protected override void Awake()
    {
        base.Awake();

        idleState = new Archer_ArrowIdleState(this, stateMachine, "Idle", this);
        moveState = new Archer_ArrowMoveState(this, stateMachine, "Move", this);
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

        if (canMove)
            SetVelocity(speed * direction, rb.velocity.y);
    }

    public void SetupArrow(int _direction, CharacterStats _myStats)
    {
        direction = _direction;
        myStats = _myStats;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer(targetLayerName))
        {
            myStats.DoPhysicDamage(collision.GetComponent<CharacterStats>(), myStats.physicDamage.GetValue());

            StuckInto(collision);
        }
    }

    private void StuckInto(Collider2D collision)
    {
        Destroy(gameObject);
    }

    private void FlipArrow()
    {
        if (direction == -1)
            transform.Rotate(0, 0, 180);
    }
}
