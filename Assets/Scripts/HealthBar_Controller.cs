using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthBar_Controller : MonoBehaviour
{
    private Character character => GetComponentInParent<Character>();
    private CharacterStats myStats => GetComponentInParent<CharacterStats>();
    private RectTransform myTransform;
    private Slider slider;

    private CanvasGroup canvasGroup;

    [SerializeField] private float hideDelay;
    private Coroutine hideCoroutine;

    private void Start()
    {
        myTransform = GetComponent<RectTransform>();
        slider = GetComponentInChildren<Slider>();
        canvasGroup = GetComponent<CanvasGroup>();

        UpdateHealthUI();
        HideHealthBar();
    }

    private void UpdateHealthUI()
    {
        slider.maxValue = myStats.health.GetValue();
        slider.value = myStats.currentHealth;

        if (canvasGroup.alpha == 0 && myStats.currentHealth < myStats.health.GetValue())
        {
            ShowHealthBar();
        }

        if (hideCoroutine != null)
        {
            StopCoroutine(hideCoroutine);
        }
        hideCoroutine = StartCoroutine(HideHealthBarAfterDelay());
    }

    private void OnEnable()
    {
        character.onFlipped += FlipUI;
        myStats.onHealthChanged += UpdateHealthUI;
    }


    private void OnDisable()
    {
        if (character != null)
            character.onFlipped -= FlipUI;

        if (myStats != null)
            myStats.onHealthChanged -= UpdateHealthUI;

        if (hideCoroutine != null)
        {
            StopCoroutine(hideCoroutine);
        }

    }
    private void FlipUI() => myTransform.Rotate(0, 180, 0);

    private void ShowHealthBar()
    {
        canvasGroup.alpha = 1;
        canvasGroup.interactable = true;
        canvasGroup.blocksRaycasts = true;
    }

    private void HideHealthBar()
    {
        canvasGroup.alpha = 0;
        canvasGroup.interactable = false;
        canvasGroup.blocksRaycasts = false;
    }

    private IEnumerator HideHealthBarAfterDelay()
    {
        yield return new WaitForSeconds(hideDelay);
        HideHealthBar();
    }
}
