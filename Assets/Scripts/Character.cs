using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class Character : MonoBehaviour
{
    #region

    public CapsuleCollider2D cd { get; private set; }
    public Rigidbody2D rb { get; private set; }
    public Animator animator { get; private set; }
    public SpriteRenderer sr { get; private set; }
    public CharacterStats stats { get; private set; }
    public CharacterFX fx { get; private set; }
    public Lineup myLineup { get; private set; }

    #endregion

    public int facingDirection { get; protected set; } = 1;

    [Space]
    [Header("Basic Informations")]
    public float moveSpeed;
    public bool isDead;
    public int currentStateIndex = 0;
    public float yPositionDefault;
    [SerializeField] protected GameObject targetEnemy;

    [Space]
    [Space]
    [Header("Collision Information")]
    [SerializeField] protected LayerMask whatIsEnemy;
    [SerializeField] protected Transform detectEnemy;
    [SerializeField] protected float detectEnemyDistance = 2;
    public Transform attackRange;
    public float attackRangeRadius;
    [SerializeField] protected Transform ignoreAlly;
    [SerializeField] protected Vector2 ignoreBoxSize;
    [SerializeField] protected List<GameObject> allies;

    [Space]
    [Space]
    [Header("Idle State Informations")]
    public bool isInitialTime;
    public float idleTimeInitial;
    public float idleTime;

    [Space]
    [Space]
    [Header("Crowd Control Informations")]
    public bool canBeStun;
    public float stunDuration;
    public bool canBeKnockback;
    [SerializeField] private float knockbackForce;
    [SerializeField] private float knockbackDuration;
    public bool canBeKnockup;
    [SerializeField] private float knockupForce;
    [SerializeField] private float knockupDuration;
    [SerializeField] private float fallDuration;

    public System.Action onFlipped;


    protected virtual void Awake()
    {

    }

    protected virtual void Start()
    {
        cd = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        animator = GetComponentInChildren<Animator>();
        sr = GetComponentInChildren<SpriteRenderer>();
        stats = GetComponent<CharacterStats>();
        fx = GetComponent<CharacterFX>();
        myLineup = GetComponentInParent<Lineup>();

        targetEnemy = null;
    }

    protected virtual void Update()
    {
        allies = myLineup.lineup;

        IgnoreAlly();
    }

    public void FlipDependOnTargetEnemy()
    {
        if (transform.position.x > targetEnemy.transform.position.x && facingDirection == 1)
            Flip();
        else if (transform.position.x < targetEnemy.transform.position.x && facingDirection == -1)
            Flip();
    }

    public bool CanAttack()
    {
        if (Vector2.Distance(transform.position, targetEnemy.transform.position) <= detectEnemyDistance)
            return true;

        return false;
    }

    public void IgnoreAlly()
    {
        foreach (GameObject ally in allies)
        {
            if(ally != null)
                Physics2D.IgnoreCollision(cd, ally.GetComponent<CapsuleCollider2D>());
        }
    }

    #region Velocity

    public void SetVelocity(float _xVelocity, float _yVelocity)
    {
        rb.velocity = new Vector2(_xVelocity, _yVelocity);
    }

    public void SetZeroVelocity()
    {
        rb.velocity = Vector2.zero;
    }

    #endregion

    #region Flip

    public virtual void Flip()
    {
        facingDirection = facingDirection * -1;
        transform.Rotate(0, 180, 0);

        if (onFlipped != null)
            onFlipped();
    }

    #endregion

    #region Stun State

    public virtual void Knockback() { }

    public void CastKnockback()
    {
        transform.DOMoveX(transform.position.x + (knockbackForce * -facingDirection), knockbackDuration)
            .SetEase(Ease.InCubic);

        Invoke("CallCreateDust", .5f);
    }

    public virtual void Knockup() { }

    public void CastKnockup()
    {
        Sequence sequence = DOTween.Sequence();

        sequence.Append(transform.DOMoveY(transform.position.y + knockupForce, knockupDuration)
            .SetEase(Ease.OutCubic));

        sequence.Append(transform.DOMoveY(transform.position.y, fallDuration)
            .SetEase(Ease.InCubic));

        Invoke("CallCreateDust", .8f);
    }

    private void CallCreateDust()
    {
        fx.CreateDustFX();
    }

    #endregion

    public virtual void Die()
    {
        isDead = true;
    }

    protected virtual void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(detectEnemy.position, new Vector3(detectEnemy.position.x + detectEnemyDistance * facingDirection, detectEnemy.position.y));

        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(attackRange.position, attackRangeRadius);

        Gizmos.color = Color.black;
        Gizmos.DrawWireCube(ignoreAlly.position, ignoreBoxSize);
    }

    public void SelfDestroy()
    {
        Destroy(gameObject, .6f);
    }
}
