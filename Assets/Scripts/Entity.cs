using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Entity : MonoBehaviour
{
    #region

    public CapsuleCollider2D cd { get; private set; }
    public Rigidbody2D rb { get; private set; }
    public Animator animator { get; private set; }
    public SpriteRenderer sr { get; private set; }

    #endregion

    public int facingDirection { get; protected set; } = 1;

    public float moveSpeed;
    public int currentStateIndex = 0;

    [Header("Collision Information")]
    [SerializeField] protected LayerMask whatIsEnemy;
    [SerializeField] protected Transform detectEnemy;
    [SerializeField] protected float detectEnemyDistance = 2;
    public Transform attackRange;
    public float attackRangeRadius;

    [Header("Idle State Informations")]
    public bool isInitialTime;
    public float idleTimeInitial;
    public float idleTime;

    [Space]
    [Space]
    [Header("Crowd Control Informations")]
    [SerializeField] private GameObject stunPrefab;
    public bool canBeStun;
    [SerializeField] private float yOffset;
    public float stunDuration;
    public bool canBeKnockback;
    public Vector2 knockbackForce;



    protected virtual void Awake()
    {

    }

    protected virtual void Start()
    {
        cd = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        animator = GetComponentInChildren<Animator>();
        sr = GetComponentInChildren<SpriteRenderer>();
    }

    protected virtual void Update()
    {

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
    }

    #endregion

    protected virtual void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(detectEnemy.position, new Vector3(detectEnemy.position.x + detectEnemyDistance * facingDirection, detectEnemy.position.y));

        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(attackRange.position, attackRangeRadius);
    }

    public virtual bool IsEnemyDetected() => Physics2D.Raycast(detectEnemy.position, Vector2.right * facingDirection, detectEnemyDistance, whatIsEnemy);

    public virtual void Knockback() { }

    public void CastKnockback()
    {
        rb.velocity = new Vector2(knockbackForce.x * -facingDirection, knockbackForce.y);
    }

    public virtual void Stun()
    {
        Vector2 stunPosition = new Vector2(transform.position.x, transform.position.y + yOffset);

        GameObject newStun = Instantiate(stunPrefab, stunPosition, Quaternion.identity);

        newStun.transform.SetParent(transform);
    }
}
