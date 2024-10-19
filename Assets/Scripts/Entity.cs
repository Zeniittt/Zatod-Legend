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

    [Header("Collision Information")]
    [SerializeField] protected LayerMask whatIsEnemy;
    [SerializeField] protected Transform detectEnemy;
    [SerializeField] protected float detectEnemyDistance = 2;
    public Transform attackRange;
    public float attackRangeRadius;

    public float moveSpeed;
    public bool isInitialTime;
    public float idleTimeInitial;
    public float idleTime;

    public int currentStateIndex = 0;


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
}
