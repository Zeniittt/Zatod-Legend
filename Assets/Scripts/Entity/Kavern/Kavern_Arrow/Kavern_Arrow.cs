using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting.Antlr3.Runtime.Misc;
using UnityEngine;

public class Kavern_Arrow : Entity
{
    public Kavern_ArrowIdleState idleState { get; private set; }


    [SerializeField] private string targetLayerName = "Enemy";
    public float speed;
    [SerializeField] private bool canMove;

    private CharacterStats myStats;
    public int direction;

    protected override void Awake()
    {
        base.Awake();

        idleState = new Kavern_ArrowIdleState(this, stateMachine, "Idle", this);
    }

    protected override void Start()
    {
        base.Start();

        FlipArrow();

        stateMachine.Initialize(idleState);
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
            canMove = false;
            myStats.DoPhysicDamage(collision.GetComponent<CharacterStats>(), myStats.physicDamage.GetValue());

            SelfDestroy();
        }
    }

    private void SelfDestroy()
    {
        Destroy(gameObject);
    }

    private void FlipArrow()
    {
        if (direction == -1)
            transform.Rotate(0, 0, 180);
    }

}
