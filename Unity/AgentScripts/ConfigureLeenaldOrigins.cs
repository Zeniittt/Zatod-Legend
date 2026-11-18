using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
using Zatod.Heroes;

public static class ConfigureLeenaldOrigins
{
    public static object Run()
    {
        if (EditorApplication.isPlaying) throw new InvalidOperationException("Stop Play Mode before updating origin config.");
        var source = HeroConfigFileStore.Read(); var catalog = HeroDataJson.ReadDocuments(source);
        var hero = catalog.Hero("leenald"); var skill = catalog.Skill("leenald_skill2");
        var feet = hero.SpawnPoints.SingleOrDefault(p => p.Id == "feet");
        if (feet == null) { feet = new HeroSpawnPointDefinition { Id = "feet" }; hero.SpawnPoints.Add(feet); }
        feet.Forward = feet.Height = 0;
        const string path = "Assets/Zatod/Resources/Heroes/Leenald/AnimationSet.txt";
        var manifest = JsonUtility.FromJson<HeroAnimationSetData>(File.ReadAllText(path));
        var clip = manifest.Clips.Single(c => c.State == "Skill2_Projectile");
        clip.UseProjectileOrigin = true;
        clip.ProjectileOriginPixelX = manifest.AnchorPixelX;
        clip.ProjectileOriginPixelY = manifest.AnchorPixelY;
        skill.ProjectileSpawnPointId = feet.Id;
        skill.ProjectileSpawnOffsetForward = skill.ProjectileSpawnOffsetHeight = 0;
        // The first visible ground eruption starts just beyond the planted foot in the source art.
        skill.ProjectileHitOffsetForward = Mathf.RoundToInt((clip.ContentBounds[0].X - clip.ProjectileOriginPixelX) * 100f / manifest.PixelsPerUnit);
        skill.ProjectileVisualScaleBasisPoints = 10000;
        if (!catalog.Data.ConfigVersion.EndsWith("-origins-1", StringComparison.Ordinal))
        {
            catalog.Data.ConfigVersion += "-origins-1";
            HeroConfigFileStore.Save(catalog.Data, source);
        }
        File.WriteAllText(path, JsonUtility.ToJson(manifest, true)); AssetDatabase.ImportAsset(path); AssetDatabase.SaveAssets();
        foreach (var window in Resources.FindObjectsOfTypeAll<HeroBalanceWindow>()) window.ReloadIfClean();
        return new { catalog.Data.ConfigVersion, skill.ProjectileSpawnPointId, skill.ProjectileHitOffsetForward,
            clip.ProjectileOriginPixelX, clip.ProjectileOriginPixelY, skill.ProjectileVisualScaleBasisPoints };
    }
}
