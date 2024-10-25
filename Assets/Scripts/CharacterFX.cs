using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class CharacterFX : MonoBehaviour
{
    private SpriteRenderer sr;

    [Header("PopUpText FX")]
    [SerializeField] private GameObject popUpTextPrefab;

    [Header("Stun FX")]
    public Transform stunObject;

    [Header("Dust FX")]
    [SerializeField] private GameObject dustEffectPrefab;

    [Header("FadeOut FX")]
    public float fadeDuration = 1.0f;

    [Header("Hit FX")]
    [SerializeField] private GameObject hitPrefab;
    [SerializeField] private Vector3 hitOffset;

    [Header("Heal Effect")]
    [SerializeField] private GameObject healPrefab;
    [SerializeField] private Vector2 healOffset;


    private void Start()
    {
        sr = GetComponentInChildren<SpriteRenderer>();
    }

    public void CreatePopUpText(Vector2 _position, string _text, Vector3 _color)
    {
        float randomX = Random.Range(-.5f, .5f);
        float randomY = Random.Range(2.5f, 3.2f);

        Vector2 positionOffset = new Vector2(randomX, randomY);

        GameObject newText = Instantiate(popUpTextPrefab, _position + positionOffset, Quaternion.identity);

        TextMeshPro textComponent = newText.GetComponent<TextMeshPro>();

        textComponent.text = _text;
        textComponent.color = new Color(_color.x / 255f, _color.y / 255f , _color.z / 255f);
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

        GameObject newHit = Instantiate(hitPrefab, _target.position + hitOffset, Quaternion.identity);
        newHit.transform.Rotate(hitFXRotation);

        Destroy(newHit, .5f);
    }

    public void CreateHealFX(Vector2 _position)
    {
        GameObject newHeal = Instantiate(healPrefab, _position + healOffset, Quaternion.identity);

        Destroy(newHeal, .5f);
    }
}
