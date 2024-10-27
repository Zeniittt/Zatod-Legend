using System.Collections;
using System.Collections.Generic;
using Unity.IO.LowLevel.Unsafe;
using UnityEngine;

public class EvilWizard_DarkEnergy : Entity
{
    #region

    public EvilWizard_DarkEnergyExplodeState explodeState { get; private set; }
    public EvilWizard_DarkEnergyMoveState moveState { get; private set; }

    #endregion

    [SerializeField] private string targetLayerName = "Hero";
    public float speed;

    private CharacterStats myStats;
    public int direction;

    protected override void Awake()
    {
        base.Awake();

        explodeState = new EvilWizard_DarkEnergyExplodeState(this, stateMachine, "Explode", this);
        moveState = new EvilWizard_DarkEnergyMoveState(this, stateMachine, "Move", this);
    }

    protected override void Start()
    {
        base.Start();

        FlipDarkEnergy();

        stateMachine.Initialize(moveState);
    }

    protected override void Update()
    {
        base.Update();
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer(targetLayerName))
        {
            stateMachine.ChangeState(explodeState);
            myStats.DoMagicalDamage(collision.GetComponent<CharacterStats>(), myStats.physicDamage.GetValue());

        }
    }

    public void SetupDarkEnergy(int _direction, CharacterStats _myStats)
    {
        direction = _direction;
        myStats = _myStats;
    }

    private void FlipDarkEnergy()
    {
        if (direction == -1)
            transform.Rotate(0, 0, 180);
    }

    public void SelfDestroy() => Destroy(gameObject, 1f);
}
