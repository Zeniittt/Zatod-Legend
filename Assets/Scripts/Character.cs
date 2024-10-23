using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Character : MonoBehaviour
{
    #region

    public CapsuleCollider2D cd { get; private set; }
    public Rigidbody2D rb { get; private set; }
    public Animator animator { get; private set; }
    public SpriteRenderer sr { get; private set; }
    public CharacterStats stats { get; private set; }

    #endregion

    public int facingDirection { get; protected set; } = 1;

    public float moveSpeed;
    public int currentStateIndex = 0;
    public bool isDead;

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
    [SerializeField] public Transform stunObject;
    public bool canBeStun;
    public float stunDuration;
    public bool canBeKnockback;
    public Vector2 knockbackForce;
    public bool canBeKnockup;
    public float knockupForce;

    [SerializeField] private GameObject dustEffectPrefab;
    [SerializeField] private Transform dustEffectPosition;

    public float fadeDuration = 1.0f;


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

    //public virtual bool IsEnemyDetected() => Physics2D.Raycast(detectEnemy.position, Vector2.right * facingDirection, detectEnemyDistance, whatIsEnemy);

    public virtual bool IsEnemyDetected()
    {
        RaycastHit2D hit = Physics2D.Raycast(detectEnemy.position, Vector2.right * facingDirection, detectEnemyDistance, whatIsEnemy);
        
        if(hit.collider != null)
        {
            Character enemy = hit.collider.GetComponent<Character>();

            if (enemy != null && !enemy.isDead)
            {
                return true;
            }
        }

        return false;
    }

    public virtual void CastStun()
    {
        stunObject.gameObject.SetActive(true);
    }

    public virtual void Knockback() { }

    public void CastKnockback()
    {
        rb.velocity = Vector2.zero;
        rb.velocity = new Vector2(knockbackForce.x * -facingDirection, knockbackForce.y);
    }

    public virtual void Knockup() { }

    public void CastKnockup()
    {
        rb.velocity = Vector2.zero;
        rb.AddForce(Vector2.up * knockupForce, ForceMode2D.Impulse);
    }

    public void CreateDust()
    {
        GameObject newDust = Instantiate(dustEffectPrefab, dustEffectPosition.transform.position, Quaternion.identity);
    }

    public IEnumerator FadeOut()
    {
        float startAlpha = sr.color.a;
        float elapsedTime = 0f;

        while (elapsedTime < fadeDuration)
        {
            elapsedTime += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, 0f, elapsedTime / fadeDuration);
            sr.color = new Color(sr.color.r, sr.color.g, sr.color.b, alpha);
            yield return null;
        }

    }

    public virtual void Die()
    {
        isDead = true;
    }

    public void SelfDestroy()
    {
        Destroy(gameObject, 1f);
    }
}
