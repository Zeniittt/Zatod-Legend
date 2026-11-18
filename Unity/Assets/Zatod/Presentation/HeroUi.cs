using System;
using TMPro;
using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Presentation
{
    // Shared presentation helpers for the roster and detail panels; never modifies Hero progress.
    public sealed class HeroUi
    {
        readonly TMP_FontAsset font;
        public static readonly Color Gold = Hex("E6C780"), Text = Hex("F0EADB"), Muted = Hex("A3AD9D");
        public static readonly Color Panel = Hex("242C28"), Deep = Hex("141E1C"), Edge = Hex("8F9480");
        public HeroUi(TMP_FontAsset font) { this.font = font; }

        public static RectTransform Rect(Transform parent, string name, float x, float y, float width, float height)
        {
            var rect = new GameObject(name, typeof(RectTransform)).GetComponent<RectTransform>(); rect.SetParent(parent, false);
            rect.anchorMin = rect.anchorMax = rect.pivot = new Vector2(0, 1);
            rect.anchoredPosition = new Vector2(x, -y); rect.sizeDelta = new Vector2(width, height); return rect;
        }

        public GameObject Canvas(string name, int order, out RectTransform layout)
        {
            var go = new GameObject(name, typeof(RectTransform), typeof(UnityEngine.Canvas), typeof(UnityEngine.UI.CanvasScaler), typeof(UnityEngine.UI.GraphicRaycaster));
            var canvas = go.GetComponent<UnityEngine.Canvas>(); canvas.renderMode = RenderMode.ScreenSpaceOverlay; canvas.sortingOrder = order;
            var scaler = go.GetComponent<UnityEngine.UI.CanvasScaler>(); scaler.uiScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1600, 900); scaler.screenMatchMode = UnityEngine.UI.CanvasScaler.ScreenMatchMode.Expand;
            go.AddComponent<FormationBackdrop>().raycastTarget = false;
            layout = Rect(go.transform, name + "Layout", 0, 0, 1600, 900);
            layout.anchorMin = layout.anchorMax = layout.pivot = new Vector2(.5f, .5f); layout.anchoredPosition = Vector2.zero;
            return go;
        }

        public FormationFrame Frame(Transform parent, string name, float x, float y, float width, float height, Color fill, Color edge)
        {
            var frame = Rect(parent, name, x, y, width, height).gameObject.AddComponent<FormationFrame>();
            frame.Fill = fill; frame.Edge = edge; frame.Bevel = 9; frame.raycastTarget = false; return frame;
        }

        public UnityEngine.UI.Button Button(Transform parent, string name, float x, float y, float width, float height, Action clicked, Color? fill = null)
        {
            var frame = Frame(parent, name, x, y, width, height, fill ?? Panel, Edge); frame.raycastTarget = true;
            var button = frame.gameObject.AddComponent<UnityEngine.UI.Button>(); button.targetGraphic = frame;
            var colors = button.colors; colors.highlightedColor = new Color(1.15f, 1.12f, 1.05f); colors.pressedColor = new Color(.7f, .7f, .7f); colors.disabledColor = new Color(.5f, .5f, .5f); button.colors = colors;
            button.onClick.AddListener(() => clicked()); return button;
        }

        public TextMeshProUGUI Label(Transform parent, string name, string text, float x, float y, float width, float height, float size, Color? color = null, TextAlignmentOptions align = TextAlignmentOptions.Left, bool bold = false)
        {
            var label = Rect(parent, name, x, y, width, height).gameObject.AddComponent<TextMeshProUGUI>();
            label.font = font; label.text = text; label.fontSize = size; label.color = color ?? Text; label.alignment = align;
            label.fontStyle = bold ? FontStyles.Bold : FontStyles.Normal; label.raycastTarget = false;
            label.textWrappingMode = TextWrappingModes.NoWrap; label.overflowMode = TextOverflowModes.Truncate; return label;
        }

        public void Glyph(Transform parent, string name, float x, float y, float width, float height, int shape, Color color)
        {
            var glyph = Rect(parent, name, x, y, width, height).gameObject.AddComponent<ArenaGraphic>(); glyph.shape = shape; glyph.color = color; glyph.raycastTarget = false;
        }

        public void Portrait(Transform parent, HeroData hero, HeroDefinition definition, string name, float x, float y, float width, float height)
        {
            var frame = Frame(parent, name, x, y, width, height, Deep, RankColor(hero)); frame.Thickness = 3;
            // An illustration can be added later without changing data/stat calculations.
            var illustration = Resources.Load<Sprite>("HeroPortraits/" + definition.Id);
            if (illustration != null)
            {
                var image = Rect(frame.transform, "Illustration", 6, 6, width - 12, height - 12).gameObject.AddComponent<UnityEngine.UI.Image>();
                image.sprite = illustration; image.preserveAspect = true; image.raycastTarget = false;
            }
            else
            {
                float side = Mathf.Min(width - 20, height - 36);
                Glyph(frame.transform, "PortraitGlyph", (width - side) / 2, (height - side) / 2 - 4, side, side, PortraitShape(definition), RankColor(hero));
            }
        }

        public void Stars(Transform parent, string name, int stars, float x, float y, float size)
        {
            var group = Rect(parent, name, x, y, size * 5 + 4 * 5, size);
            for (int i = 0; i < 5; i++)
            {
                var graphic = Rect(group, "Star-" + i, i * (size + 5), 0, size, size).gameObject.AddComponent<HeroHudGlyph>();
                graphic.Shape = HeroHudGlyph.Kind.Star; graphic.color = i < stars ? Gold : Hex("566055"); graphic.raycastTarget = false;
            }
        }

        public UnityEngine.UI.ScrollRect Scroll(Transform parent, string name, float x, float y, float width, float height, out RectTransform content)
        {
            var root = Rect(parent, name, x, y, width, height);
            var scroll = root.gameObject.AddComponent<UnityEngine.UI.ScrollRect>(); scroll.horizontal = false; scroll.vertical = true;
            scroll.movementType = UnityEngine.UI.ScrollRect.MovementType.Clamped; scroll.scrollSensitivity = 38;
            var viewport = Rect(root, "Viewport", 0, 0, width, height); viewport.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            var hit = viewport.gameObject.AddComponent<UnityEngine.UI.Image>(); hit.color = new Color(1, 1, 1, .001f); hit.raycastTarget = true;
            content = Rect(viewport, "Content", 0, 0, width, 0); content.anchorMin = new Vector2(0, 1); content.anchorMax = Vector2.one;
            content.pivot = new Vector2(.5f, 1); content.offsetMin = content.offsetMax = Vector2.zero;
            scroll.viewport = viewport; scroll.content = content; return scroll;
        }

        public static void Clear(Transform parent)
        {
            foreach (Transform child in parent) { child.gameObject.SetActive(false); UnityEngine.Object.Destroy(child.gameObject); }
        }
        public static Color RankColor(HeroData hero)
        {
            return Hex(hero.RankId == "green" ? "82BC83" : hero.RankId == "blue" ? "75B4E6" : hero.RankId == "purple" ? "C698DF" : "C9C4AB");
        }
        public static int PortraitShape(HeroDefinition definition)
        {
            switch (definition.PortraitKey) { case "blades": return 2; case "bow": return 3; case "star": return 4; case "cross": return 5; default: return definition.Position == HeroPosition.Rear ? 4 : definition.Position == HeroPosition.Middle ? 3 : 1; }
        }
        public static Color Hex(string value) { ColorUtility.TryParseHtmlString("#" + value, out var color); return color; }
    }

    [RequireComponent(typeof(CanvasRenderer))]
    public sealed class HeroHudGlyph : UnityEngine.UI.MaskableGraphic
    {
        public enum Kind { Gold, Diamond, Stamina, Soul, Star }
        public Kind Shape;
        protected override void OnPopulateMesh(UnityEngine.UI.VertexHelper vh)
        {
            vh.Clear(); var r = rectTransform.rect; float size = Mathf.Min(r.width, r.height) * .43f;
            int count = Shape == Kind.Star ? 10 : Shape == Kind.Gold ? 32 : Shape == Kind.Soul ? 6 : 4;
            vh.AddVert(r.center, color, Vector2.zero);
            for (int i = 0; i < count; i++)
            {
                float angle = Mathf.PI / 2 + i * Mathf.PI * 2 / count;
                float radius = Shape == Kind.Star && i % 2 == 1 ? size * .45f : size;
                var point = r.center + new Vector2(Mathf.Cos(angle) * radius * (Shape == Kind.Stamina ? .65f : 1), Mathf.Sin(angle) * radius);
                vh.AddVert(point, color, Vector2.zero);
            }
            for (int i = 0; i < count; i++) vh.AddTriangle(0, i + 1, (i + 1) % count + 1);
        }
    }
}
