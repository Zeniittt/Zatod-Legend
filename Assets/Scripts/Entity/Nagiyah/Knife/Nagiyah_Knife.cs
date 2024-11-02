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
    private Nagiyah nagiyah;
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

    public void SetupKnife(Nagiyah _nagiyah, int _direction)
    {
        nagiyah = _nagiyah;
        direction = _direction;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer(targetLayerName))
        {
            nagiyah.stats.DoPhysicDamage(collision.GetComponent<CharacterStats>(), nagiyah.stats.physicDamage.GetValue());
            
            if(!nagiyah.isUnblockSkillSecond)
            {
                SelfDestroy();
            } else
            {
                stateMachine.ChangeState(landState);
                transform.SetParent(collision.transform);
            }

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
