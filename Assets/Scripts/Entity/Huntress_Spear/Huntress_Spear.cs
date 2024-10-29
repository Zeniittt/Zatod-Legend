using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Huntress_Spear : Entity
{
    #region States

    public Huntress_SpearIdleState idleState { get; private set; }
    public Huntress_SpearMoveState moveState { get; private set; }

    #endregion


    [SerializeField] private string targetLayerName = "Hero";
    public float speed;

    private CharacterStats myStats;
    public int direction;

    protected override void Awake()
    {
        base.Awake();

        idleState = new Huntress_SpearIdleState(this, stateMachine, "Idle", this);
        moveState = new Huntress_SpearMoveState(this, stateMachine, "Move", this);
    }

    protected override void Start()
    {
        base.Start();

        FlipSpear();

        stateMachine.Initialize(moveState);
    }

    protected override void Update()
    {
        base.Update();
    }

    public void SetupSpear(int _direction, CharacterStats _myStats)
    {
        direction = _direction;
        myStats = _myStats;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer(targetLayerName))
        {
            myStats.DoPhysicDamage(collision.GetComponent<CharacterStats>(), myStats.physicDamage.GetValue());

            stateMachine.ChangeState(idleState);
        }
    }

    private void FlipSpear()
    {
        if (direction == -1)
            transform.Rotate(0, 0, 180);
    }

    public void SelfDestroy() => Destroy(gameObject);

}
