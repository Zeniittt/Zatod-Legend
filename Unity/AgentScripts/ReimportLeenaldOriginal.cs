using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;

public static class ReimportLeenaldOriginal
{
    const string Source = "C:/Users/tinnq/Downloads/monk_original_selected";
    const string Art = "Assets/Zatod/Art/Leenald";
    const string Root = "Assets/Zatod/Resources/Heroes/Leenald";
    const string Icon = "Assets/Zatod/Resources/HeroPortraits/leenald.png";
    static readonly Vector2 Anchor = new Vector2(144, 7);
    sealed class Frame
    {
        public string source, path;
        public GUID spriteId;
        public HeroFrameBounds content, crop;
    }
    public static object Run()
    {
        if (EditorApplication.isPlaying) throw new InvalidOperationException("Stop Play Mode before reimporting art.");
        var manifest = JsonUtility.FromJson<HeroAnimationSetData>(File.ReadAllText(Root + "/AnimationSet.txt"));
        if (manifest.HeroId != "leenald" || manifest.Clips.Count != 11) throw new InvalidDataException("Unexpected Leenald animation set.");
        var factories = new SpriteDataProviderFactories(); factories.Init();
        var all = new Dictionary<string, List<Frame>>();
        // Read all sources and check all importer capabilities before replacing any asset bytes.
        foreach (var clip in manifest.Clips)
        {
            var files = Directory.GetFiles(Path.Combine(Source, clip.SourceFolder), "*.png")
                .OrderBy(p => int.Parse(Regex.Match(Path.GetFileNameWithoutExtension(p), @"_(\d+)(?:_proj)?$").Groups[1].Value)).ToArray();
            if (!files.Select(Path.GetFileName).SequenceEqual(clip.SourceFrames)) throw new InvalidDataException("Frame mapping changed: " + clip.State);
            var frames = new List<Frame>();
            foreach (var file in files)
            {
                var path = Art + "/" + clip.SourceFolder + "/" + Path.GetFileName(file);
                var importer = AssetImporter.GetAtPath(path) as TextureImporter;
                if (importer == null) throw new InvalidDataException("Existing sprite importer missing: " + path);
                var provider = Provider(factories, importer);
                var previous = provider.GetSpriteRects();
                if (previous.Length != 1) throw new InvalidDataException("Expected one stable sprite ID: " + path);
                var content = Bounds(file);
                var minX = Math.Max(0, Math.Min(content.X, (int)Anchor.x) - 1);
                var minY = Math.Max(0, Math.Min(content.Y, (int)Anchor.y) - 1);
                var maxX = Math.Min(287, Math.Max(content.X + content.Width - 1, (int)Anchor.x) + 1);
                var maxY = Math.Min(127, Math.Max(content.Y + content.Height - 1, (int)Anchor.y) + 1);
                frames.Add(new Frame { source = file, path = path, spriteId = previous[0].spriteID, content = content,
                    crop = new HeroFrameBounds { X = minX, Y = minY, Width = maxX - minX + 1, Height = maxY - minY + 1, Empty = content.Empty } });
            }
            all.Add(clip.State, frames);
        }
        var iconBytes = File.ReadAllBytes(Icon); var iconMeta = File.ReadAllBytes(Icon + ".meta");
        string backup = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/LeenaldOriginalImport", DateTime.UtcNow.ToString("yyyyMMdd-HHmmss")));
        Directory.CreateDirectory(backup);
        File.WriteAllText(Path.Combine(backup, "AnimationSet-before.txt"), File.ReadAllText(Root + "/AnimationSet.txt"));
        manifest.CanvasWidth = 288; manifest.CanvasHeight = 128; manifest.AnchorPixelX = 144; manifest.AnchorPixelY = 7; manifest.PixelsPerUnit = 25;
        foreach (var entry in manifest.Clips)
        {
            var sprites = new List<Sprite>(); entry.Frames.Clear(); entry.ContentBounds.Clear();
            foreach (var frame in all[entry.State])
            {
                // Metadata is applied before SaveAndReimport, so an old 1152px crop is never imported against a 288px canvas.
                var importer = (TextureImporter)AssetImporter.GetAtPath(frame.path);
                var provider = Provider(factories, importer);
                File.Copy(frame.source, frame.path, true);
                importer.textureType = TextureImporterType.Sprite; importer.spriteImportMode = SpriteImportMode.Multiple;
                importer.spritePixelsPerUnit = 25; importer.filterMode = FilterMode.Point; importer.mipmapEnabled = false;
                importer.npotScale = TextureImporterNPOTScale.None; importer.textureCompression = TextureImporterCompression.Uncompressed;
                var textureSettings = new TextureImporterSettings(); importer.ReadTextureSettings(textureSettings);
                textureSettings.spriteMeshType = SpriteMeshType.FullRect; importer.SetTextureSettings(textureSettings);
                var crop = frame.crop;
                var rect = new SpriteRect { name = Path.GetFileNameWithoutExtension(frame.path), spriteID = frame.spriteId,
                    rect = new Rect(crop.X, crop.Y, crop.Width, crop.Height), alignment = SpriteAlignment.Custom,
                    pivot = new Vector2((Anchor.x - crop.X) / crop.Width, (Anchor.y - crop.Y) / crop.Height) };
                provider.SetSpriteRects(new[] { rect });
                provider.GetDataProvider<ISpriteNameFileIdDataProvider>().SetNameFileIdPairs(new[] { new SpriteNameFileIdPair(rect.name, rect.spriteID) });
                provider.Apply(); importer.SaveAndReimport();
                sprites.Add(AssetDatabase.LoadAllAssetsAtPath(frame.path).OfType<Sprite>().Single());
                entry.Frames.Add(crop); entry.ContentBounds.Add(frame.content);
            }
            var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(Root + "/Animations/" + entry.State + ".anim");
            if (clip == null) throw new InvalidDataException("Existing animation clip missing: " + entry.State);
            AnimationUtility.SetObjectReferenceCurve(clip, EditorCurveBinding.PPtrCurve("", typeof(SpriteRenderer), "m_Sprite"),
                sprites.Select((sprite, i) => new ObjectReferenceKeyframe { time = i / (float)entry.FramesPerSecond, value = sprite }).ToArray());
            EditorUtility.SetDirty(clip);
        }
        File.Copy(Path.Combine(Source, "projectile_bboxes.json"), Art + "/projectile_bboxes.json", true);
        File.Copy(Path.Combine(Source, "README.txt"), Art + "/SourceNotes.txt", true);
        File.WriteAllText(Root + "/AnimationSet.txt", JsonUtility.ToJson(manifest, true));
        AssetDatabase.ImportAsset(Root + "/AnimationSet.txt");
        AssetDatabase.ImportAsset(Art + "/projectile_bboxes.json"); AssetDatabase.ImportAsset(Art + "/SourceNotes.txt");
        LeenaldAtlasBuild.Ensure(); AssetDatabase.SaveAssets();
        if (!iconBytes.SequenceEqual(File.ReadAllBytes(Icon)) || !iconMeta.SequenceEqual(File.ReadAllBytes(Icon + ".meta")))
            throw new IOException("Icon unexpectedly changed.");
        return new { replacedFrames = all.Values.Sum(f => f.Count), clips = manifest.Clips.Count, ppu = manifest.PixelsPerUnit, iconPreserved = true, backup };
    }
    static ISpriteEditorDataProvider Provider(SpriteDataProviderFactories factories, TextureImporter importer)
    {
        var provider = factories.GetSpriteEditorDataProviderFromObject(importer);
        if (provider == null) throw new InvalidOperationException("Sprite Editor provider unavailable.");
        provider.InitSpriteEditorDataProvider();
        var capabilities = provider.GetDataProvider<ISpriteFrameEditCapability>();
        if (capabilities == null) throw new InvalidOperationException("Sprite edit capabilities unavailable.");
        foreach (var required in new[] { EEditCapability.EditSpriteRect, EEditCapability.EditPivot, EEditCapability.EditSpriteName, EEditCapability.CreateAndDeleteSprite })
            if (!capabilities.GetEditCapability().HasCapability(required)) throw new InvalidOperationException("Missing sprite edit capability: " + required);
        if (provider.GetDataProvider<ISpriteNameFileIdDataProvider>() == null) throw new InvalidOperationException("Stable sprite file IDs unavailable.");
        return provider;
    }
    static HeroFrameBounds Bounds(string path)
    {
        var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
        try
        {
            if (!texture.LoadImage(File.ReadAllBytes(path)) || texture.width != 288 || texture.height != 128) throw new InvalidDataException("Expected original 288x128 artwork: " + path);
            var pixels = texture.GetPixels32(); int minX = 288, minY = 128, maxX = -1, maxY = -1;
            for (int y = 0; y < 128; y++) for (int x = 0; x < 288; x++)
                if (pixels[y * 288 + x].a != 0) { minX = Math.Min(minX, x); minY = Math.Min(minY, y); maxX = Math.Max(maxX, x); maxY = Math.Max(maxY, y); }
            return maxX < 0 ? new HeroFrameBounds { X = 144, Y = 7, Width = 1, Height = 1, Empty = true } :
                new HeroFrameBounds { X = minX, Y = minY, Width = maxX - minX + 1, Height = maxY - minY + 1 };
        }
        finally { UnityEngine.Object.DestroyImmediate(texture); }
    }
}
