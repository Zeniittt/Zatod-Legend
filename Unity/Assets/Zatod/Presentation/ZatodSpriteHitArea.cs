using UnityEngine;
using UnityEngine.UI;
namespace Zatod.Presentation
{
    // Uses the imported Tight mesh, so transparent corners cannot select another island.
    [RequireComponent(typeof(UnityEngine.UI.Image))]
    public sealed class ZatodSpriteHitArea:MonoBehaviour,ICanvasRaycastFilter
    {
        UnityEngine.UI.Image image;Sprite cached;Vector2[] vertices;ushort[] triangles;
        public bool IsRaycastLocationValid(Vector2 screenPoint,Camera eventCamera)
        {
            if(image==null)image=GetComponent<UnityEngine.UI.Image>();var sprite=image.sprite;if(sprite==null)return false;
            if(cached!=sprite){cached=sprite;vertices=sprite.vertices;triangles=sprite.triangles;}
            if(!RectTransformUtility.ScreenPointToLocalPointInRectangle(image.rectTransform,screenPoint,eventCamera,out var local))return false;
            var rect=image.GetPixelAdjustedRect();if(rect.width<=0 || rect.height<=0)return false;
            var point=new Vector2(((local.x-rect.xMin)/rect.width*sprite.rect.width-sprite.pivot.x)/sprite.pixelsPerUnit,((local.y-rect.yMin)/rect.height*sprite.rect.height-sprite.pivot.y)/sprite.pixelsPerUnit);
            for(int i=0;i<triangles.Length;i+=3)
            {
                var a=vertices[triangles[i]];var b=vertices[triangles[i+1]];var c=vertices[triangles[i+2]];
                if(Mathf.Abs(Cross(b-a,c-a))<.00000001f)continue;
                float ab=Cross(b-a,point-a),bc=Cross(c-b,point-b),ca=Cross(a-c,point-c);
                if(ab>=-.00001f && bc>=-.00001f && ca>=-.00001f || ab<=.00001f && bc<=.00001f && ca<=.00001f)return true;
            }
            return false;
        }
        static float Cross(Vector2 a,Vector2 b)=>a.x*b.y-a.y*b.x;
    }
}
