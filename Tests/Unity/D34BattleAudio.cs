// Run in Play Mode in the isolated validation workspace using Unity Pipeline.
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TMPro;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

public static class D34BattleAudio
{
    public static async Task<object> Run(string report)
    {
        if (!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))
            throw new InvalidOperationException("Use the isolated validation Editor in Play Mode.");

        const string audio = "Zatod/Audio/battle_win";
        const string oldAudio = "Crystal/Audio/battle_win";
        int checks = 0;
        void Check(bool ok, string error)
        {
            checks++;
            if (!ok) throw new InvalidOperationException(error);
        }

        var catalog = HeroDataJson.LoadBundledCatalog();
        var campaign = CampaignDataJson.LoadZatod(catalog);
        var session = new ZatodPlayerSession(catalog, campaign, Guid.NewGuid().ToString("D"));
        var match = session.BeginCampaign("chapter_one_stage_1", null, 34, "audio-fixture");
        match.MusicResource = oldAudio;
        var simulation = new ZatodBattleSimulation(match);
        var frame = simulation.Frame();
        var unit = frame.Units.First(x => x.Team == 0);
        frame.Visuals.Add(new ZatodVisualState { Id = 3434, Resource = "eff_impact_burn", Kind = "impact" });
        var root = new GameObject("D34 audio fixture");
        var overlay = new GameObject("D34 result fixture", typeof(RectTransform), typeof(Canvas));
        float oldVolume = AudioListener.volume;
        bool oldPause = AudioListener.pause;
        try
        {
            AudioListener.volume = 0;
            AudioListener.pause = false;
            var stage = root.AddComponent<ZatodBattleStage>();
            void Draw(bool play, double interpolation = 0) => stage.Draw(frame, simulation, interpolation, 0, false, play, 4);
            Draw(false);
            var music = stage.GetComponents<AudioSource>().Single(source => source.loop);
            var effects = stage.GetComponents<AudioSource>().Single(source => !source.loop);
            var actor = stage.transform.Find("Hero_" + unit.EntityId);
            var animations = actor.GetComponent<ZatodBattleSprite>().Set;
            var attack = animations.Clips.First(clip => clip.State == "atk");
            string attackAction = attack.State;
            attack.AudioCues = new() { new HeroAudioCue { Resource = oldAudio, Time = .25f } };
            animations.Clips.First(clip => clip.State == "Idle").AudioCues.Clear();
            animations.Clips.First(clip => clip.State == "Death").AudioCues.Clear();
            var visual = stage.transform.Find("Effect_3434").GetComponent<ZatodBattleSprite>();
            visual.Set.Clips.First().AudioCues = new() { new HeroAudioCue { Resource = "Crystal/Audio/battle_loot", Time = .0625f } };
            Check(music.clip == Resources.Load<AudioClip>(audio) && music.clip != null && !music.isPlaying,
                "Paused load did not resolve the old music path correctly.");

            unit.Action = attackAction;
            unit.ActionElapsed = .25;
            frame.Visuals[0].Elapsed = .125;
            Draw(true);
            await Task.Delay(45);
            var voice = actor.GetComponent<AudioSource>();
            Check(music.isPlaying && voice != null && voice.isPlaying && effects.isPlaying,
                "The legacy resource paths did not play through the music, actor and effect sources.");
            Draw(false);
            await Task.Delay(45);
            Check(!music.isPlaying && !voice.isPlaying && !effects.isPlaying,
                $"Pausing playback left combat audio playing (music={music.isPlaying}, actor={voice.isPlaying}, effect={effects.isPlaying}).");
            Draw(true, .0625);
            await Task.Delay(45);
            Check(music.isPlaying && voice.isPlaying && effects.isPlaying,
                "Resuming playback did not resume the three audio sources.");
            unit.CastInterruptedTick = 3;
            unit.Action = "Idle";
            unit.ActionElapsed = 0;
            Draw(true);
            await Task.Delay(45);
            Check(!voice.isPlaying && effects.isPlaying && music.isPlaying,
                "Interrupting an actor did not cut only its own in-flight sound.");

            unit.Action = attackAction;
            unit.ActionElapsed = .25;
            Draw(true);
            await Task.Delay(45);
            Check(voice.isPlaying, "The next action could not play its cue.");
            unit.Hp = 0;
            unit.Action = "Death";
            unit.DeathWave = frame.Wave;
            animations.Clips.First(clip => clip.State == "Death").AudioCues.Add(new HeroAudioCue { Resource = audio, Time = .125f });
            Draw(true);
            await Task.Delay(45);
            Check(!voice.isPlaying && effects.isPlaying, "A dead actor kept playing an old cue.");
            frame.Visuals.Clear();
            frame.Wave++;
            unit.DeathElapsed = .25;
            Draw(true);
            await Task.Delay(45);
            Check(!effects.isPlaying && music.isPlaying, "Wave transition did not clear old effects while keeping the music.");
            Check(actor == null && voice == null, "A corpse from the previous wave remained able to play a late death cue.");

            stage.Clear();
            await Task.Delay(45);
            Check(!music.isPlaying && !effects.isPlaying && voice == null, "Clearing the battle left audio behind.");
            frame = simulation.Frame();
            unit = frame.Units.First(x => x.Team == 0);
            unit.Action = attackAction;
            unit.ActionElapsed = .25;
            Draw(false);
            var newActor = stage.transform.Cast<Transform>().Last(x => x.name == "Hero_" + unit.EntityId);
            attack = newActor.GetComponent<ZatodBattleSprite>().Set.Clips.First(clip => clip.State == unit.Action);
            attack.AudioCues = new() { new HeroAudioCue { Resource = audio, Time = .125f } };
            Draw(true);
            await Task.Delay(45);
            Check(newActor.GetComponent<AudioSource>() == null && music.isPlaying,
                "Resuming a scrubbed frame emitted a cue from before the seek point.");

            var view = ZatodBattleResultView.Create(overlay.transform, Resources.Load<TMP_FontAsset>("UI/FormationFont"));
            var replay = simulation.Replay();
            view.Open(replay, null, catalog, session.Account, null, false);
            Check(view.GetComponent<AudioSource>() == null, "Opening results at a paused seek played a victory sound.");
            view.Open(replay, null, catalog, session.Account, null);
            await Task.Delay(45);
            var result = view.GetComponent<AudioSource>();
            Check(result != null && result.isPlaying, "Live results did not play their victory cue.");
            view.Hide();
            await Task.Delay(45);
            Check(!result.isPlaying, "Leaving the results kept the victory cue alive.");
        }
        finally
        {
            AudioListener.volume = oldVolume;
            AudioListener.pause = oldPause;
            UnityEngine.Object.Destroy(root);
            UnityEngine.Object.Destroy(overlay);
        }
        var output = new { State = "PASS", Checks = checks, PlaybackSpeed = 4 };
        File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(output));
        return output;
    }
}
