using UnityEngine;

namespace Zatod.Presentation
{
    [RequireComponent(typeof(CanvasRenderer))]
    public sealed class FormationFrame : UnityEngine.UI.MaskableGraphic
    {
        public Color Fill = new Color(.14f, .16f, .14f), Edge = new Color(.58f, .55f, .43f);
        public float Bevel = 10, Thickness = 2;
        protected override void OnPopulateMesh(UnityEngine.UI.VertexHelper vh)
        {
            vh.Clear(); var r = rectTransform.rect;
            Polygon(vh, r, Bevel, Edge * color);
            var inner = new Rect(r.x + Thickness, r.y + Thickness, Mathf.Max(0, r.width - 2 * Thickness), Mathf.Max(0, r.height - 2 * Thickness));
            Polygon(vh, inner, Mathf.Max(0, Bevel - Thickness), Fill * color);
            if (r.width > 24 && r.height > 8)
                Quad(vh, new Rect(r.x + Bevel, r.yMax - Thickness, r.width - Bevel * 2, 1), new Color(.88f, .82f, .64f, .55f) * color);
        }
        static void Polygon(UnityEngine.UI.VertexHelper vh, Rect r, float b, Color c)
        {
            b = Mathf.Min(b, Mathf.Min(r.width, r.height) * .3f);
            Vector2[] p = { new Vector2(r.xMin + b, r.yMin), new Vector2(r.xMax - b, r.yMin), new Vector2(r.xMax, r.yMin + b), new Vector2(r.xMax, r.yMax - b), new Vector2(r.xMax - b, r.yMax), new Vector2(r.xMin + b, r.yMax), new Vector2(r.xMin, r.yMax - b), new Vector2(r.xMin, r.yMin + b) };
            int start = vh.currentVertCount; vh.AddVert(r.center, c, Vector2.zero);
            foreach (var point in p) vh.AddVert(point, c, Vector2.zero);
            for (int i = 0; i < p.Length; i++) vh.AddTriangle(start, start + i + 1, start + (i + 1) % p.Length + 1);
        }
        internal static void Quad(UnityEngine.UI.VertexHelper vh, Rect r, Color c)
        {
            int n = vh.currentVertCount;
            vh.AddVert(new Vector2(r.xMin, r.yMin), c, Vector2.zero); vh.AddVert(new Vector2(r.xMin, r.yMax), c, Vector2.zero);
            vh.AddVert(new Vector2(r.xMax, r.yMax), c, Vector2.zero); vh.AddVert(new Vector2(r.xMax, r.yMin), c, Vector2.zero);
            vh.AddTriangle(n, n + 1, n + 2); vh.AddTriangle(n, n + 2, n + 3);
        }
    }

    [RequireComponent(typeof(CanvasRenderer))]
    public sealed class FormationBackdrop : UnityEngine.UI.MaskableGraphic
    {
        protected override void OnPopulateMesh(UnityEngine.UI.VertexHelper vh)
        {
            vh.Clear(); var r = rectTransform.rect;
            vh.AddVert(new Vector2(r.xMin, r.yMin), new Color(.035f, .075f, .065f), Vector2.zero);
            vh.AddVert(new Vector2(r.xMin, r.yMax), new Color(.08f, .19f, .16f), Vector2.zero);
            vh.AddVert(new Vector2(r.xMax, r.yMax), new Color(.12f, .20f, .16f), Vector2.zero);
            vh.AddVert(new Vector2(r.xMax, r.yMin), new Color(.035f, .075f, .065f), Vector2.zero);
            vh.AddTriangle(0, 1, 2); vh.AddTriangle(0, 2, 3);
            for (int i = 0; i < 13; i++)
            {
                float x = r.xMin + r.width * i / 12;
                FormationFrame.Quad(vh, new Rect(x, r.yMin, 16 + i % 3 * 12, r.height), new Color(.02f, .045f, .035f, .28f));
            }
        }
    }
}
