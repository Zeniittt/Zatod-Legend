using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StunEffect_Controller : MonoBehaviour
{
    private float duration;

    public void SetupStun(float _duration)
    {
        duration = _duration;
    }

    private void Update()
    {
        duration -= Time.deltaTime;

        if(duration <= 0.5f)
            Destroy(gameObject);
    }
}
