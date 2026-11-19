using System;
namespace Zatod.Editor
{
    [Serializable] public sealed class CrystalBakeManifest { public string UnitId, Resource; public CrystalBakeSheet[] Sheets; public CrystalBakeAction[] Actions; }
    [Serializable] public sealed class CrystalBakeSheet { public string Path; public CrystalBakeFrame[] Frames; }
    [Serializable] public sealed class CrystalBakeFrame { public string Name; public int X,Y,Width,Height; public float PivotX,PivotY; }
    [Serializable] public sealed class CrystalBakeFrameRef { public string Sheet,Name; }
    [Serializable] public sealed class CrystalBakeAction { public string Name; public Zatod.Animation.HeroAudioCue[] AudioCues; public float Fps,Duration; public CrystalBakeFrameRef[] Frames; public bool Loop; public int Width,Height; }
}
