using System;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Animation;
using Zatod.Presentation;

namespace Zatod.Editor
{
    public sealed class HeroAnimationPreviewWindow : EditorWindow
    {
        Label status;
        [MenuItem("Zatod/Heroes/Leenald Animation Preview")]
        public static void Open() { GetWindow<HeroAnimationPreviewWindow>("Leenald Animations"); }
        public void CreateGUI()
        {
            minSize = new Vector2(360, 480);
            var style = AssetDatabase.LoadAssetAtPath<StyleSheet>("Assets/Zatod/Editor/HeroBalanceWindow.uss");
            if (style != null) rootVisualElement.styleSheets.Add(style);
            rootVisualElement.AddToClassList("hero-balance");
            rootVisualElement.Add(new Label("LEENALD / ANIMATION PREVIEW") { name = "hero-title" });
            rootVisualElement.Add(new Label("Enter Play Mode, then open Leenald. These controls preview all clips regardless of rank; they do not resolve combat effects.") { name = "preview-note" });
            rootVisualElement.Q<Label>("preview-note").AddToClassList("wrapped");
            status = new Label("Ready"); rootVisualElement.Add(status);
            rootVisualElement.Add(new Button(() => Execute(() =>
            {
                if (!EditorApplication.isPlaying) throw new InvalidOperationException("Enter Play Mode first.");
                var roster = UnityEngine.Object.FindAnyObjectByType<HeroRosterView>();
                roster.Show(); roster.OpenDetail(roster.Character.HeroDesk.Single(h => h.HeroDefinitionId == "leenald").HeroInstanceId);
            })) { text = "Open Leenald detail", name = "open-leenald" });
            foreach (string state in new[] { "Idle", "Run", "Stun", "Death", "NormalAttack", "Ultimate", "Skill2", "Skill3", "Skill4" })
            {
                string selected = state;
                rootVisualElement.Add(new Button(() => Execute(() => Player().Play(selected))) { text = state, name = "play-" + state });
            }
            rootVisualElement.Add(new Button(() => Execute(() =>
            {
                var player = Player(); player.SetFacing(player.transform.localScale.x < 0);
            })) { text = "Flip facing", name = "flip-facing" });
        }
        static HeroAnimationPlayer Player()
        {
            var preview = UnityEngine.Object.FindAnyObjectByType<HeroModelPreview>();
            if (!EditorApplication.isPlaying || preview == null || preview.Player == null) throw new InvalidOperationException("Open Leenald's detail in Play Mode.");
            return preview.Player;
        }
        void Execute(Action action)
        {
            try { action(); status.text = "Preview updated"; }
            catch (Exception error) { status.text = error.Message; }
        }
    }
}
