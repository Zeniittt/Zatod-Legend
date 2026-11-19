using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Animations;
using Zatod.Animation;

namespace Zatod.Presentation
{
    // Samples sprite keys against replay time. No Animator clock or animation event changes gameplay.
    public sealed class ReplaySprite : MonoBehaviour
    {
        public string CurrentState { get; private set; }
        public float SampleSeconds { get; private set; }
        public int PresentationHeight { get; private set; }
        UnityEngine.UI.Image image;
        GameObject sampler;
        SpriteRenderer rendererSource;
        PlayableGraph graph;
        AnimationPlayableOutput output;
        readonly Dictionary<string, AnimationClipPlayable> playables = new Dictionary<string, AnimationClipPlayable>();
        readonly Dictionary<string, AnimationClip> clips = new Dictionary<string, AnimationClip>();
        readonly Dictionary<string, HeroAnimationClipData> definitions = new Dictionary<string, HeroAnimationClipData>();

        public void Initialize(string setResource)
        {
            var asset = Resources.Load<TextAsset>(setResource);
            if (asset == null) return;
            var set = JsonUtility.FromJson<HeroAnimationSetData>(asset.text);
            foreach (var entry in set.Clips)
            {
                var clip = Resources.Load<AnimationClip>(entry.ClipResource);
                if (clip == null) continue;
                clips.Add(entry.State, clip); definitions.Add(entry.State, entry);
            }
            image = gameObject.AddComponent<UnityEngine.UI.Image>(); image.raycastTarget = false;
            sampler = new GameObject("ReplaySpriteSampler", typeof(SpriteRenderer), typeof(Animator));
            sampler.transform.SetParent(transform, false);
            rendererSource = sampler.GetComponent<SpriteRenderer>(); rendererSource.enabled = false;
            var animator = sampler.GetComponent<Animator>(); animator.cullingMode = AnimatorCullingMode.AlwaysAnimate;
            graph = PlayableGraph.Create("ReplaySprite"); graph.SetTimeUpdateMode(DirectorUpdateMode.Manual);
            output = AnimationPlayableOutput.Create(graph, "Sprite", animator);
            foreach (var entry in clips) playables.Add(entry.Key, AnimationClipPlayable.Create(graph, entry.Value));
            graph.Play();
        }

        public void Sample(string state, float seconds, bool facingRight, float scale, bool projectile = false, bool stabilizeRoot = false)
        {
            if (image == null || !clips.TryGetValue(state, out var clip)) return;
            var definition = definitions[state];
            float duration = definition.DurationSeconds;
            seconds = Mathf.Max(0, seconds);
            SampleSeconds = definition.Loop ? seconds % duration : Mathf.Min(seconds, Mathf.Max(0, duration - .0001f));
            CurrentState = state;
            PresentationHeight = definition.PresentationHeight;
            var playable = playables[state];
            // Native clips can mirror left-facing source art. Reset first so a previous clip's
            // flip does not leak into a clip with no flip curve.
            rendererSource.flipX = false;
            output.SetSourcePlayable(playable); playable.SetTime(SampleSeconds); graph.Evaluate(0);
            var sprite = rendererSource.sprite; image.sprite = sprite;
            if (sprite == null) { image.enabled = false; return; }
            image.enabled = true;
            var rect = (RectTransform)transform;
            // Respect source PPU: original-resolution art and enlarged art keep the same world size.
            rect.sizeDelta = sprite.rect.size * (100f / sprite.pixelsPerUnit) * scale;
            rect.pivot = new Vector2(sprite.pivot.x / sprite.rect.width, sprite.pivot.y / sprite.rect.height);
            if (stabilizeRoot && definition.StabilizeHorizontalAnchor && !projectile)
            {
                int frame = definition.FrameIndex(SampleSeconds);
                if (definition.ContentBounds != null && definition.ContentBounds.Count == definition.Frames.Count && frame < definition.ContentBounds.Count)
                {
                    var content = definition.ContentBounds[frame]; var crop = definition.Frames[frame];
                    // Remove baked horizontal actor travel from stationary attack poses.
                    // Server movement remains the only source of the actor's world displacement.
                    rect.pivot = new Vector2((content.X + content.Width * .5f - crop.X) / crop.Width, rect.pivot.y);
                }
            }
            if (projectile && !definition.PreserveSpritePivot)
            {
                int frame = definition.FrameIndex(SampleSeconds);
                if (definition.ContentBounds != null && definition.ContentBounds.Count == definition.Frames.Count && frame < definition.ContentBounds.Count)
                {
                    var content = definition.ContentBounds[frame]; var crop = definition.Frames[frame];
                    // Remove baked horizontal travel; the recorded path owns horizontal movement.
                    // Preserve authored vertical growth relative to the shared ground/foot pivot.
                    if (definition.UseProjectileOrigin)
                    {
                        // Keep the authored gap between the actor's foot and the effect's trailing edge.
                        // Normalize travel against the first frame, never against changing image centers.
                        float originX = definition.ProjectileOriginPixelX + content.X - definition.ContentBounds[0].X;
                        rect.pivot = new Vector2((originX - crop.X) / crop.Width, (definition.ProjectileOriginPixelY - crop.Y) / crop.Height);
                    }
                    else rect.pivot = new Vector2((content.X + content.Width * .5f - crop.X) / crop.Width, rect.pivot.y);
                }
                else rect.pivot = new Vector2(.5f, .5f);
            }
            rect.localScale = new Vector3(facingRight != rendererSource.flipX ? 1 : -1, 1, 1);
        }
        public float ClipDuration(string state) { return definitions.TryGetValue(state, out var definition) ? definition.DurationSeconds : 0; }
        public void StretchWidth(float width)
        {
            var rect = (RectTransform)transform;
            int reference = definitions[CurrentState].VisualReferenceWidthPixels;
            float fraction = reference > 0 && image.sprite != null ? image.sprite.rect.width / reference : 1;
            rect.sizeDelta = new Vector2(Mathf.Max(1,width * fraction),rect.sizeDelta.y);
        }
        void OnDestroy() { if (graph.IsValid()) graph.Destroy(); }
    }
}
