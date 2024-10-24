using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterFX : MonoBehaviour
{
    private SpriteRenderer sr;

    [Header("Stun FX")]
    public Transform stunObject;

    [Header("Dust FX")]
    [SerializeField] private GameObject dustEffectPrefab;

    [Header("FadeOut FX")]
    public float fadeDuration = 1.0f;

    [Header("Hit FX")]
    [SerializeField] private GameObject hitPrefab;
    [SerializeField] private Vector3 offset;


    private void Start()
    {
        sr = GetComponentInChildren<SpriteRenderer>();
    }

    public void CastStunFX()
    {
        stunObject.gameObject.SetActive(true);
    }

    public void CreateDustFX()
    {
        GameObject newDust = Instantiate(dustEffectPrefab, transform.position, Quaternion.identity);
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

    public void CreateHitFX(Transform _target)
    {
        float zRotation = Random.Range(-90, 90);


        Vector3 hitFXRotation = new Vector3(0, 0, zRotation);

        GameObject newHit = Instantiate(hitPrefab, _target.position + offset, Quaternion.identity);
        newHit.transform.Rotate(hitFXRotation);

        Destroy(newHit, .5f);
    }
}
