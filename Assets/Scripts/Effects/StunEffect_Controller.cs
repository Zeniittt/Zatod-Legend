using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StunEffect_Controller : MonoBehaviour
{
    Entity entity=> GetComponentInParent<Entity>();


    private void Update()
    {
        if(entity != null)
        {
            if (entity.canBeStun == false)
                gameObject.SetActive(false);
        }
    }
}
