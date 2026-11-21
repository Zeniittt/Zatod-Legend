using UnityEngine;

namespace Zatod.Presentation
{
    // Keeps the development screens readable without letting their fixed authoring
    // coordinates spill outside the shared safe area. New screens use fluid anchors.
    public sealed class ZatodResponsiveLayout : MonoBehaviour
    {
        public Vector2 DesignSize=new Vector2(1600,900);
        void LateUpdate()=>Fit();
        public void Fit()
        {
            var rect=(RectTransform)transform;if(!(rect.parent is RectTransform parent))return;
            rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);rect.sizeDelta=DesignSize;rect.anchoredPosition=Vector2.zero;
            rect.localScale=Vector3.one*Mathf.Min(parent.rect.width/DesignSize.x,parent.rect.height/DesignSize.y);
        }
    }
}
