using UnityEngine;

namespace Zatod.Presentation
{
    [DefaultExecutionOrder(-100)]
    public sealed class ZatodSafeAreaRoot : MonoBehaviour
    {
        public static Rect Normalized(Rect safe,int width,int height)
        {
            if(width<=0 || height<=0)return new Rect(0,0,1,1);
            float left=Mathf.Clamp01(safe.xMin/width),bottom=Mathf.Clamp01(safe.yMin/height);
            float right=Mathf.Clamp01(safe.xMax/width),top=Mathf.Clamp01(safe.yMax/height);
            return right>left && top>bottom?Rect.MinMaxRect(left,bottom,right,top):new Rect(0,0,1,1);
        }
        void OnEnable()=>Apply();
        void Update()=>Apply();
        public void Apply()
        {
            // Simulator can briefly retain the old device's pixel safe area after a
            // resolution/view switch. Never allow those anchors outside the Canvas.
            var area=Normalized(Screen.safeArea,Screen.width,Screen.height);var r=(RectTransform)transform;
            r.anchorMin=area.min;r.anchorMax=area.max;r.offsetMin=r.offsetMax=Vector2.zero;
        }
    }
}
