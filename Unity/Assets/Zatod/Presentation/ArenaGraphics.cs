using UnityEngine;

namespace Zatod.Presentation
{
    // Small code-native graphics keep the prototype independent of hero art/assets.
    [RequireComponent(typeof(CanvasRenderer))]
    public class ArenaGraphic : UnityEngine.UI.MaskableGraphic
    {
        public int shape; // 0 floor, 1 shield, 2 blades, 3 bow, 4 star, 5 cross, 6 back, 7 check
        protected override void OnPopulateMesh(UnityEngine.UI.VertexHelper vh)
        {
            vh.Clear();
            var r = rectTransform.rect;
            if (shape == 8)
            {
                Ellipse(vh, r.center, new Vector2(r.width*.5f,r.height*.5f), 3, color);
                Ellipse(vh, r.center, new Vector2(r.width*.43f,r.height*.43f), 1, color);
                return;
            }
            if (shape == 0)
            {
                Color grid = new Color(.25f, .43f, .53f, .11f);
                for (float x = r.xMin; x < r.xMax; x += 76) Line(vh, new Vector2(x, r.yMin), new Vector2(x, r.yMax), 1, grid);
                for (float y = r.yMin; y < r.yMax; y += 76) Line(vh, new Vector2(r.xMin, y), new Vector2(r.xMax, y), 1, grid);
                Ellipse(vh, r.center + new Vector2(0, -10), new Vector2(r.width * .44f, r.height * .32f), 2, new Color(.35f, .57f, .68f, .14f));
                Ellipse(vh, r.center + new Vector2(0, -10), new Vector2(r.width * .32f, r.height * .23f), 1, grid);
                Line(vh, r.center + new Vector2(0, -r.height * .32f), r.center + new Vector2(0, r.height * .32f), 1, grid);
                return;
            }
            Color c = color;
            float s = Mathf.Min(r.width, r.height) * .38f;
            Ellipse(vh, Vector2.zero, new Vector2(s * 1.2f, s * 1.2f), 2, new Color(c.r, c.g, c.b, .26f));
            if (shape == 1)
            {
                Polygon(vh, new[] { new Vector2(-s * .7f, s), new Vector2(s * .7f, s), new Vector2(s * .6f, -s * .3f), new Vector2(0, -s), new Vector2(-s * .6f, -s * .3f) }, c);
                Line(vh, new Vector2(0, s * .6f), new Vector2(0, -s * .5f), 3, new Color(.05f, .11f, .18f));
            }
            else if (shape == 2)
            {
                Line(vh, new Vector2(-s * .7f, -s * .7f), new Vector2(s * .7f, s * .7f), 7, c);
                Line(vh, new Vector2(-s * .7f, s * .7f), new Vector2(s * .7f, -s * .7f), 7, c);
            }
            else if (shape == 3)
            {
                Line(vh, new Vector2(-s * .5f, -s), new Vector2(s * .4f, 0), 5, c);
                Line(vh, new Vector2(s * .4f, 0), new Vector2(-s * .5f, s), 5, c);
                Line(vh, new Vector2(-s * .5f, -s), new Vector2(-s * .5f, s), 2, c);
                Line(vh, new Vector2(-s, 0), new Vector2(s, 0), 3, c);
            }
            else if (shape == 4)
            {
                Polygon(vh, new[] { new Vector2(0, s), new Vector2(s * .3f, s * .3f), new Vector2(s, 0), new Vector2(s * .3f, -s * .3f), new Vector2(0, -s), new Vector2(-s * .3f, -s * .3f), new Vector2(-s, 0), new Vector2(-s * .3f, s * .3f) }, c);
            }
            else if (shape == 6)
            {
                Line(vh, new Vector2(s * .8f, 0), new Vector2(-s * .8f, 0), s * .35f, c);
                Line(vh, new Vector2(-s * .8f, 0), new Vector2(0, s * .8f), s * .35f, c);
                Line(vh, new Vector2(-s * .8f, 0), new Vector2(0, -s * .8f), s * .35f, c);
            }
            else if (shape == 7)
            {
                Line(vh, new Vector2(-s * .8f, 0), new Vector2(-s * .2f, -s * .5f), s * .3f, c);
                Line(vh, new Vector2(-s * .2f, -s * .5f), new Vector2(s * .9f, s * .7f), s * .3f, c);
            }
            else
            {
                Line(vh, new Vector2(-s * .8f, 0), new Vector2(s * .8f, 0), s * .5f, c);
                Line(vh, new Vector2(0, -s * .8f), new Vector2(0, s * .8f), s * .5f, c);
            }
            for (int i = 0; i < vh.currentVertCount; i++)
            {
                UIVertex vertex = default;
                vh.PopulateUIVertex(ref vertex, i);
                vertex.position += (Vector3)r.center;
                vh.SetUIVertex(vertex, i);
            }
        }
        static void Polygon(UnityEngine.UI.VertexHelper vh, Vector2[] points, Color c)
        {
            int start = vh.currentVertCount;
            vh.AddVert(Vector2.zero, c, Vector2.zero);
            foreach (var point in points) vh.AddVert(point, c, Vector2.zero);
            for (int i = 0; i < points.Length; i++) vh.AddTriangle(start, start + 1 + i, start + 1 + (i + 1) % points.Length);
        }
        static void Ellipse(UnityEngine.UI.VertexHelper vh, Vector2 center, Vector2 radius, float width, Color c)
        {
            const int segments = 72;
            for (int i = 0; i < segments; i++)
            {
                float a = i * Mathf.PI * 2 / segments, b = (i + 1) * Mathf.PI * 2 / segments;
                Line(vh, center + new Vector2(Mathf.Cos(a) * radius.x, Mathf.Sin(a) * radius.y), center + new Vector2(Mathf.Cos(b) * radius.x, Mathf.Sin(b) * radius.y), width, c);
            }
        }
        static void Line(UnityEngine.UI.VertexHelper vh, Vector2 a, Vector2 b, float width, Color c)
        {
            Vector2 n = new Vector2(-(b - a).y, (b - a).x).normalized * width * .5f;
            int v = vh.currentVertCount;
            vh.AddVert(a - n, c, Vector2.zero); vh.AddVert(a + n, c, Vector2.zero);
            vh.AddVert(b + n, c, Vector2.zero); vh.AddVert(b - n, c, Vector2.zero);
            vh.AddTriangle(v, v + 1, v + 2); vh.AddTriangle(v, v + 2, v + 3);
        }
    }
}
