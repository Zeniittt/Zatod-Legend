using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StunEffect_Controller : MonoBehaviour
{
    Character entity=> GetComponentInParent<Character>();


    private void Update()
    {
        if(entity != null)
        {
            if (entity.canBeStun == false)
                gameObject.SetActive(false);
        }
    }
}
