using System;
namespace Zatod.Editor
{
    [Serializable] public sealed class ZatodBakeManifest { public string UnitId, Resource; public float PixelsPerUnit; public ZatodBakeSheet[] Sheets; public ZatodBakeAction[] Actions; }
    [Serializable] public sealed class ZatodBakeSheet { public string Path; public ZatodBakeFrame[] Frames; }
    [Serializable] public sealed class ZatodBakeFrame { public string Name; public int X,Y,Width,Height; public float PivotX,PivotY; }
    [Serializable] public sealed class ZatodBakeFrameRef { public string Sheet,Name; }
    [Serializable] public sealed class ZatodBakeAction { public string Name; public Zatod.Animation.HeroAudioCue[] AudioCues; public float Fps,Duration; public ZatodBakeFrameRef[] Frames; public bool Loop; public int Width,Height; }
}
