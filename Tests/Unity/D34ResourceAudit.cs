// Run in Unity Edit Mode after staging the Data and Resources to check.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;
using Zatod.World;

public static class D34ResourceAudit
{
    public static object Run(string report)
    {
        if (EditorApplication.isPlaying)
            throw new InvalidOperationException("Run the resource audit in Edit Mode.");
        var heroes = HeroDataJson.LoadBundledCatalog();
        var campaign = CampaignDataJson.LoadZatod(heroes);
        var world = WorldDataJson.Load(campaign);
        var audit = new Audit();

        foreach (var hero in heroes.Data.Heroes)
        {
            string portrait = "Portraits/" + hero.Id;
            audit.Asset<Sprite>("FormationPortrait", "Zatod/UI/Formation/" + portrait, hero.Id);
            if (ZatodBattleHudLayout.Portrait(hero.Id) == null)
                audit.Issue("CombatPortrait", portrait, hero.Id);
            var skills = hero.SkillSlots.Select(slot => slot.SkillId).ToArray();
            foreach (string id in skills)
                audit.Asset<Sprite>("SkillIcon", "Zatod/UI/Hero/Skills/Icons/" + id, hero.Id);
            audit.Actor(hero, skills, heroes);
        }
        foreach (var monster in heroes.Data.Monsters)
            audit.Actor(monster, monster.SkillIds, heroes);
        foreach (var item in heroes.Data.Items)
        {
            string icon = "Items/" + item.DefinitionId;
            try { _ = ZatodStageUi.Art(icon); }
            catch (InvalidOperationException) { audit.Issue("ItemIcon", icon, item.DefinitionId); }
        }

        foreach (var skill in heroes.Data.Skills.Where(skill => skill.Crystal != null))
        {
            var data = skill.Crystal;
            foreach(string resource in data.AdditionalEffectResources)audit.Effect(resource,skill.Id+"/NativeHook");
            if(data.NativeForm?.Enabled==true)audit.Effect(data.NativeForm.Resource+".cha",skill.Id+"/NativeForm");
            foreach(var form in data.Summon?.Forms??new System.Collections.Generic.List<ZatodBattleFormDefinition>())audit.Effect(form.Resource+".cha",skill.Id+"/SummonForm");
            audit.Effect(data.LaunchEffect, skill.Id + "/LaunchEffect");
            audit.Effect(data.PointEffect, skill.Id + "/PointEffect");
            audit.Effect(data.ImpactEffect, skill.Id + "/ImpactEffect");
            if (data.TrackType == "chain") audit.Effect(data.ChainEffect, skill.Id + "/ChainEffect");
            if (data.TrackType == "projectile") audit.Effect(data.ProjectileArt, skill.Id + "/ProjectileArt");
        }
        foreach (var buff in heroes.Data.Buffs)
            audit.Effect(buff.Effect, buff.Id);

        audit.Background("battle_bg/bbg_arena.jpg", "Arena and realtime PvP");
        foreach (var chapter in campaign.Data.Chapters)
        {
            audit.Asset<AudioClip>("ChapterMusic", ZatodPath(chapter.BattleMusicResource), chapter.Id);
            foreach (var stage in chapter.Stages)
            {
                foreach (var wave in stage.Waves ?? new List<WaveDefinition>())
                    audit.Background(wave.BackgroundResource, stage.Id + "/" + wave.Id);
                foreach (bool unlocked in new[] { true, false })
                {
                    string icon = ZatodStageVisuals.IconPath + "stage_" + stage.SourceStageId + (unlocked ? "" : "_locked");
                    if (ZatodStageVisuals.Icon(stage, unlocked) == null)
                        audit.Issue("MissingStageIcon", icon, stage.Id);
                    else if (Resources.Load<Sprite>(icon) == null)
                        audit.Issue("UsesStageIconFallback", icon, stage.Id);
                }
            }
        }
        foreach (var map in world.Data.Maps)
        {
            audit.WorldVisual(map.VisualResource, map.Id);
            foreach (var prop in map.Props) audit.WorldVisual(prop.VisualResource, map.Id + "/" + prop.Id);
            foreach (var point in map.Interactions) audit.WorldVisual(point.VisualResource, map.Id + "/" + point.Id);
        }
        var result = audit.Report();
        var summary = new
        {
            BundledHeroes = heroes.Data.Heroes.Count, BundledItems = heroes.Data.Items.Count,
            Chapters = campaign.Data.Chapters.Count, result.AssetChecks, result.AnimationSets, result.Findings
        };
        File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(summary, Newtonsoft.Json.Formatting.Indented));
        return new { Report = report, result.AssetChecks, result.AnimationSets, Issues = result.Findings.Count };
    }

    public static async Task<object> VerifyPortraitReplays()
    {
        if (!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))
            throw new InvalidOperationException("Use the isolated validation Editor in Play Mode.");

        var heroes = HeroDataJson.LoadBundledCatalog();
        var definitions = heroes.Data.Heroes.Where(hero =>
            ZatodBattleHudLayout.Art("Portraits/" + hero.Id) == null).ToArray();
        if (definitions.Length == 0)
            throw new InvalidOperationException("No Hero exercises the combat portrait fallback.");

        var view = UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
        var scenes = view.GetComponent<ZatodBattleSceneController>();
        const BindingFlags flags = BindingFlags.Instance | BindingFlags.NonPublic;
        var hud = (ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud", flags).GetValue(view);
        void Apply(string method, params object[] args)
            => typeof(ZatodPrototypeView).GetMethod(method, flags).Invoke(view, args);

        try
        {
            for (int i = 0; i < definitions.Length; i += 5)
            {
                var batch = definitions.Skip(i).Take(5).ToArray();
                var party = batch.Select(hero => heroes.CreateHero(hero.Id, hero.Id)).ToArray();
                var match = ZatodMatchFactory.Versus(heroes, party, new[] { heroes.CreateHero("lina", "opponent") },
                    34, "d34-portrait-fixture", false);
                match.Waves[0].TimeLimitSeconds = 2;
                var record = new ZatodBattleSimulation(match).RunToCompletion();
                Apply("LoadReplay", record);
                Apply("SetReplayPlaying", false);
                double limit = EditorApplication.timeSinceStartup + 8;
                while (scenes.Phase != ZatodScenePhase.InBattle && EditorApplication.timeSinceStartup < limit)
                    await Task.Delay(30);
                if (scenes.Phase != ZatodScenePhase.InBattle)
                    throw new InvalidOperationException("The replay view could not open.");

                for (int card = 0; card < batch.Length; card++)
                {
                    var image = hud.Cards[card].Portrait;
                    var expected = ZatodFormationView.Art("Portraits/" + batch[card].Id);
                    if (!image.gameObject.activeInHierarchy || image.sprite != expected)
                        throw new InvalidOperationException("Replay HUD did not show the portrait of " + batch[card].Id);
                }
            }
        }
        finally { Apply("Show", "campaign"); }
        return new { State = "PASS", Portraits = definitions.Select(hero => hero.Id).ToArray() };
    }

    static string ZatodPath(string path)
        => path?.StartsWith("Crystal/", StringComparison.Ordinal) == true ? "Zatod/" + path.Substring("Crystal/".Length) : path;

    sealed class Finding
    {
        public string Kind, Resource;
        public SortedSet<string> ReferencedBy = new SortedSet<string>(StringComparer.Ordinal);
    }

    sealed class Audit
    {
        readonly Dictionary<(Type, string), UnityEngine.Object> assets = new();
        readonly Dictionary<string, HeroAnimationSetData> sets = new(StringComparer.Ordinal);
        readonly Dictionary<(string Kind, string Resource), Finding> missing = new();

        public void Issue(string kind, string path, string origin)
        {
            path = string.IsNullOrWhiteSpace(path) ? "(unconfigured)" : path;
            var key = (kind, path);
            if (!missing.TryGetValue(key, out var finding))
            {
                finding = new Finding { Kind = kind, Resource = path };
                missing.Add(key, finding);
            }
            finding.ReferencedBy.Add(origin);
        }

        public T Asset<T>(string kind, string path, string origin) where T : UnityEngine.Object
        {
            if (string.IsNullOrWhiteSpace(path))
            {
                Issue(kind, path, origin);
                return null;
            }
            var key = (typeof(T), path);
            if (!assets.TryGetValue(key, out var asset))
            {
                asset = Resources.Load<T>(path);
                assets.Add(key, asset);
            }
            if (asset == null) Issue(kind, path, origin);
            return (T)asset;
        }

        public void Actor(CombatantDefinition actor, IEnumerable<string> skillIds, HeroCatalog heroes)
        {
            string path = ZatodPath(actor.AnimationSetResource);
            var set = Animation(path, actor.Id);
            if (set == null) return;
            var actions = skillIds.Append(actor.NormalAttackSkillId).Where(id => !string.IsNullOrEmpty(id))
                .Select(id => heroes.Skill(id).Crystal).Where(skill => skill?.ActiveType == "active")
                .SelectMany(skill => skill.Phases).Select(phase => phase.Action)
                .Concat(new[] { "Idle", "Death" }).Distinct(StringComparer.Ordinal);
            foreach (string action in actions.Where(action => !set.Clips.Any(clip => clip.State == action)))
                Issue("ActorAction", path + "#" + action, actor.Id);
        }

        public void Effect(string path, string origin)
        {
            if (!string.IsNullOrWhiteSpace(path))
                Animation("Zatod/" + Path.GetFileNameWithoutExtension(path) + "/AnimationSet", origin);
        }

        public void Background(string path, string origin)
        {
            string resource = string.IsNullOrWhiteSpace(path) ? null : "Zatod/Backgrounds/" + Path.GetFileNameWithoutExtension(path);
            Asset<Texture2D>("BattleBackground", resource, origin);
        }

        public void WorldVisual(string path, string origin)
        {
            string resource = string.IsNullOrWhiteSpace(path) ? null : "Zatod/World/Visuals/" + path;
            Asset<GameObject>("WorldPrefab", resource, origin);
        }

        HeroAnimationSetData Animation(string path, string origin)
        {
            var json = Asset<TextAsset>("AnimationSet", path, origin);
            if (json == null) return null;
            if (!sets.TryGetValue(path, out var set))
            {
                try { set = JsonUtility.FromJson<HeroAnimationSetData>(json.text); }
                catch (ArgumentException) { set = null; }
                sets.Add(path, set);
            }
            if (set?.Clips == null || set.Clips.Count == 0 ||
                set.Clips.Any(clip => clip == null || string.IsNullOrWhiteSpace(clip.State)) ||
                set.Clips.Select(clip => clip.State).Distinct(StringComparer.Ordinal).Count() != set.Clips.Count)
            {
                Issue("InvalidAnimationSet", path, origin);
                return null;
            }
            foreach (var clip in set.Clips)
            {
                string context = path + "#" + clip.State;
                Asset<AnimationClip>("AnimationClip", clip.ClipResource, context);
                if (clip.AudioCues == null)
                {
                    Issue("InvalidAnimationCues", context, origin);
                    continue;
                }
                foreach (var cue in clip.AudioCues.Where(cue => cue != null && !string.IsNullOrWhiteSpace(cue.Resource)))
                    Asset<AudioClip>("CombatAudio", ZatodPath(cue.Resource), context);
            }
            return set;
        }

        public (int AssetChecks, int AnimationSets, List<Finding> Findings) Report()
            => (assets.Count, sets.Count, missing.Values.OrderBy(finding => finding.Kind, StringComparer.Ordinal)
                .ThenBy(finding => finding.Resource, StringComparer.Ordinal).ToList());
    }
}
