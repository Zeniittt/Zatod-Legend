using System;
using System.Collections.Generic;

namespace Zatod.Animation
{
    [Serializable]
    public sealed class HeroAnimationSetData
    {
        public string HeroId;
        public int CanvasWidth = 1152, CanvasHeight = 512, PixelsPerUnit = 100;
        public float AnchorPixelX = 576, AnchorPixelY = 28;
        public List<HeroAnimationClipData> Clips = new List<HeroAnimationClipData>();
    }

    [Serializable]
    public sealed class HeroAnimationClipData
    {
        public string State, SourceFolder, ClipResource;
        public int FramesPerSecond = 12;
        public bool Loop, Projectile;
        public List<string> SourceFrames = new List<string>();
        public List<HeroFrameBounds> Frames = new List<HeroFrameBounds>();
        // Actual opaque bounds, separate from the padded crop that retains the shared foot pivot.
        public List<HeroFrameBounds> ContentBounds = new List<HeroFrameBounds>();
        public bool UseProjectileOrigin;
        public bool PreserveSpritePivot;
        public float ProjectileOriginPixelX, ProjectileOriginPixelY;
        public int PresentationHeight;
        public float SourceDurationSeconds;
        public int VisualReferenceWidthPixels;
        public List<float> FrameTimes = new List<float>();
        public float DurationSeconds { get { return SourceDurationSeconds > 0 ? SourceDurationSeconds : (float)SourceFrames.Count / FramesPerSecond; } }
        public int FrameIndex(float seconds)
        {
            if (FrameTimes != null && FrameTimes.Count == SourceFrames.Count)
            {
                for (int i = FrameTimes.Count - 1; i >= 0; i--) if (seconds + .000001f >= FrameTimes[i]) return i;
                return 0;
            }
            return Math.Min(SourceFrames.Count - 1, Math.Max(0,(int)(seconds * FramesPerSecond + .0001f)));
        }
    }

    [Serializable]
    public sealed class HeroFrameBounds
    {
        public int X, Y, Width, Height;
        public bool Empty;
    }
}
