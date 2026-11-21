using UnityEngine;

namespace Zatod.Presentation
{
    public sealed class ZatodFullScreenArt : MonoBehaviour
    {
        void LateUpdate()=>Fit();
        public void Fit()
        {
            var rect=(RectTransform)transform;var canvas=GetComponentInParent<Canvas>();if(canvas==null || !(rect.parent is RectTransform parent))return;
            var canvasRect=(RectTransform)canvas.rootCanvas.transform;Vector2 dimensions=canvasRect.rect.size;
            var image=GetComponent<UnityEngine.UI.Image>();var raw=GetComponent<UnityEngine.UI.RawImage>();
            Vector2 native=image!=null && image.sprite!=null?image.sprite.rect.size:raw!=null && raw.texture!=null?new Vector2(raw.texture.width,raw.texture.height):dimensions;
            float cover=Mathf.Max(dimensions.x/native.x,dimensions.y/native.y);
            rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);rect.localScale=Vector3.one;
            rect.localPosition=parent.InverseTransformPoint(canvasRect.TransformPoint(canvasRect.rect.center));rect.sizeDelta=native*cover;
        }
    }
}
