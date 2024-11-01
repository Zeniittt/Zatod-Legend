using System.Collections;
using System.Collections.Generic;
using Unity.IO.LowLevel.Unsafe;
using Unity.VisualScripting;
using UnityEngine;

public class Nagiyah_Knife : Entity
{
    #region States

    public Nagiyah_KnifeMoveState moveState { get; private set; }
    public Nagiyah_KnifeLandState landState { get; private set; }

    #endregion

    [SerializeField] private string targetLayerName = "Enemy";
    private CharacterStats myStats;
    public int speed;
    public int direction;


    protected override void Awake()
    {
        base.Awake();

        moveState = new Nagiyah_KnifeMoveState(this, stateMachine, "Move", this);
        landState = new Nagiyah_KnifeLandState(this, stateMachine, "Land", this);

    }

    protected override void Start()
    {
        base.Start();

        FlipKnife();

        stateMachine.Initialize(moveState);
    }

    public void SetupKnife(int _direction, CharacterStats _myStats)
    {
        direction = _direction;
        myStats = _myStats;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer(targetLayerName))
        {
            myStats.DoPhysicDamage(collision.GetComponent<CharacterStats>(), myStats.physicDamage.GetValue());

            SelfDestroy();
        }
    }

    private void SelfDestroy()
    {
        Destroy(gameObject);
    }

    private void FlipKnife()
    {
        if (direction == -1)
            transform.Rotate(0, 0, 180);
    }
}
