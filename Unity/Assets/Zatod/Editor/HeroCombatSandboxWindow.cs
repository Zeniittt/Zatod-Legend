using System;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UIElements;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

namespace Zatod.Editor
{
    public sealed class HeroCombatSandboxWindow : EditorWindow
    {
        const string PendingKey = "Zatod.HeroCombatSandbox.Pending";
        const string StatusKey = "Zatod.HeroCombatSandbox.Status";
        [SerializeField] HeroSandboxSettings settings = new HeroSandboxSettings();
        HeroCatalog catalog;
        DropdownField heroField, rankField;
        VisualElement skillButtons;
        VisualElement monsterRows;
        DropdownField monsterToAdd;
        IntegerField monsterCount;
        Label status;
        static double deadline;

        [InitializeOnLoadMethod]
        static void Initialize()
        {
            EditorApplication.playModeStateChanged -= OnPlayModeChanged;
            EditorApplication.playModeStateChanged += OnPlayModeChanged;
            EditorApplication.delayCall += ResumePending;
        }
        static void ResumePending()
        {
            if (SessionState.GetString(PendingKey, "").Length > 0) Schedule();
        }
        static void OnPlayModeChanged(PlayModeStateChange state)
        {
            if (state == PlayModeStateChange.EnteredPlayMode) ResumePending();
            if (state == PlayModeStateChange.EnteredEditMode) SessionState.EraseString(PendingKey);
        }

        [MenuItem("Zatod/Heroes/Combat Sandbox")]
        public static void Open() { GetWindow<HeroCombatSandboxWindow>("Combat Sandbox"); }

        public void CreateGUI()
        {
            minSize = new Vector2(400, 660);
            rootVisualElement.Clear();
            var style = AssetDatabase.LoadAssetAtPath<StyleSheet>("Assets/Zatod/Editor/HeroBalanceWindow.uss");
            if (style != null) rootVisualElement.styleSheets.Add(style);
            rootVisualElement.AddToClassList("hero-balance");
            var scroll = new ScrollView(); rootVisualElement.Add(scroll);
            scroll.Add(new Label("HERO / COMBAT SANDBOX") { name = "hero-title" });
            scroll.Add(new Label("One temporary Hero against your Monster team. Monsters move and attack in every test mode. Opens Play Mode in ArenaPrototype; no host, account write or archive commit.") { name = "sandbox-note" });
            scroll.Q<Label>("sandbox-note").AddToClassList("wrapped");
            scroll.Add(new Button(() => Execute(ReloadCatalog)) { text = "Reload saved config", name = "reload-catalog" });
            heroField = new DropdownField("Hero") { name = "sandbox-hero" };
            heroField.RegisterValueChangedCallback(evt => Execute(() =>
            {
                settings.HeroId = catalog.Data.Heroes.Single(h => HeroLabel(h) == evt.newValue).Id;
                settings.RankId = HeroCombatSandbox.Ranks(catalog, settings.HeroId).Last().Id;
                int range = catalog.Hero(settings.HeroId).BaseStats.FirstOrDefault(s => s.StatId == "attack_range")?.Value ?? 100;
                settings.TargetDistance = Math.Min(600, Math.Max(70, range / 2));
                int travel = catalog.Hero(settings.HeroId).SkillSlots.SelectMany(s => catalog.Skill(s.SkillId).CastSequences)
                    .SelectMany(s => s.Motion).Select(k => Math.Abs(k.Forward)).DefaultIfEmpty(0).Max();
                if (travel > 0) settings.TargetDistance = Math.Min(10000, Math.Max(settings.TargetDistance, travel + 600));
                rootVisualElement.Q<IntegerField>("sandbox-distance")?.SetValueWithoutNotify(settings.TargetDistance);
                RebuildRanks();
            })); scroll.Add(heroField);
            rankField = new DropdownField("Test rank") { name = "sandbox-rank" };
            rankField.RegisterValueChangedCallback(evt => Execute(() =>
            {
                settings.RankId = HeroCombatSandbox.Ranks(catalog, settings.HeroId).Single(r => RankLabel(r) == evt.newValue).Id;
                RebuildSkills();
            })); scroll.Add(rankField);
            Integer(scroll, "Starting HP (%)", "sandbox-hp", settings.HpPercent, v => settings.HpPercent = v);
            Integer(scroll, "Starting energy", "sandbox-energy", settings.StartingEnergy, v => settings.StartingEnergy = v);
            Integer(scroll, "Duration (seconds)", "sandbox-duration", settings.DurationSeconds, v => settings.DurationSeconds = v);
            Integer(scroll, "Single-skill casts (1–5)", "sandbox-casts", settings.SingleSkillCasts, v => settings.SingleSkillCasts = v);
            monsterRows=new VisualElement{name="sandbox-monsters"};scroll.Add(monsterRows);
            var addMonsterRow=new VisualElement();addMonsterRow.AddToClassList("toolbar");scroll.Add(addMonsterRow);
            monsterToAdd=new DropdownField("Monster to add"){name="sandbox-monster-choice"};addMonsterRow.Add(monsterToAdd);
            addMonsterRow.Add(new Button(()=>Execute(()=>
            {
                if(settings.MonsterIds.Count>=5)throw new InvalidOperationException("Monster team is full (5).");
                var definition=catalog.Data.Monsters.Single(m=>MonsterLabel(m)==monsterToAdd.value);
                settings.MonsterIds.Add(definition.Id);RebuildMonsters();
            })){text="Add Monster",name="sandbox-add-monster"});
            monsterCount=new IntegerField("Monster count (1–5)"){name="sandbox-target-count"};scroll.Add(monsterCount);
            monsterCount.RegisterValueChangedCallback(e=>Execute(()=>
            {
                if(e.newValue<1 || e.newValue>5)throw new ArgumentException("Choose 1–5 monsters.");
                if(catalog.Data.Monsters.Count==0)throw new InvalidOperationException("No Monster definitions loaded.");
                while(settings.MonsterIds.Count>e.newValue)settings.MonsterIds.RemoveAt(settings.MonsterIds.Count-1);
                while(settings.MonsterIds.Count<e.newValue)settings.MonsterIds.Add(settings.MonsterIds.LastOrDefault()??catalog.Data.Monsters[0].Id);
                RebuildMonsters();
            }));
            Integer(scroll, "Target distance", "sandbox-distance", settings.TargetDistance, v => settings.TargetDistance = v);
            Integer(scroll, "Target spacing", "sandbox-spacing", settings.TargetSpacing, v => settings.TargetSpacing = v);
            Integer(scroll, "Monster HP override (0 = config)", "sandbox-target-hp", settings.TargetHp, v => settings.TargetHp = v);
            Integer(scroll, "Random seed", "sandbox-seed", settings.Seed, v => settings.Seed = v);
            scroll.Add(new Button(() => Execute(() =>
            {
                settings.RankId = HeroCombatSandbox.Ranks(catalog, settings.HeroId).Last().Id;
                RebuildRanks(); RunTest(SandboxTestMode.Auto);
            })) { text = "TEST ALL SKILLS / highest rank", name = "sandbox-test-all" });
            scroll.Add(new Button(() => Execute(() => RunTest(SandboxTestMode.Auto)))
                { text = "Auto fight / selected rank", name = "sandbox-auto" });
            scroll.Add(new Button(() => Execute(() => RunTest(SandboxTestMode.BasicAttack)))
                { text = "Normal attack only", name = "sandbox-basic" });
            skillButtons = new VisualElement { name = "sandbox-skills" }; scroll.Add(skillButtons);
            var playback = new VisualElement(); playback.AddToClassList("toolbar"); scroll.Add(playback);
            playback.Add(new Button(() => Execute(() => Arena().TogglePlayback())) { text = "Pause / Play", name = "sandbox-play" });
            playback.Add(new Button(() => Execute(() => Step(-1))) { text = "-1 tick", name = "sandbox-step-back" });
            playback.Add(new Button(() => Execute(() => Step(1))) { text = "+1 tick", name = "sandbox-step-forward" });
            scroll.Add(new Label("Single-skill buttons start a fresh preview. Cast count defaults to 1; use 2 and a longer duration to compare opening/repeat sequences. Cooldowns and energy still apply. Use HP < 100% for healing. Pause, seek and speed controls are in Game view.") { name = "sandbox-help" });
            scroll.Q<Label>("sandbox-help").AddToClassList("wrapped");
            scroll.Add(new Label("Monsters use their own stats, chase into attack range and fight back even in single-skill tests. They can interrupt or defeat the Hero. Opponents are sorted front/middle/rear; repeated types are allowed."){name="sandbox-monster-help"});
            scroll.Q<Label>("sandbox-monster-help").AddToClassList("wrapped");
            status = new Label(SessionState.GetString(StatusKey, "Ready")) { name = "sandbox-status" };
            status.AddToClassList("wrapped"); scroll.Add(status);
            Execute(ReloadCatalog);
        }

        static void Integer(VisualElement parent, string label, string name, int value, Action<int> changed)
        {
            var field = new IntegerField(label) { name = name, value = value };
            field.RegisterValueChangedCallback(evt => changed(evt.newValue)); parent.Add(field);
        }
        static string HeroLabel(HeroDefinition hero) { return hero.Name + " (" + hero.Id + ")"; }
        static string RankLabel(HeroRankDefinition rank) { return rank.Name + " (" + rank.Id + ")"; }
        static string MonsterLabel(MonsterDefinition monster){return monster.Name+" / "+monster.Position+" ("+monster.Id+")";}
        void ReloadCatalog()
        {
            catalog = HeroDataJson.ReadDocuments(HeroConfigFileStore.Read());
            if (!catalog.Data.Heroes.Any(h => h.Id == settings.HeroId))
            {
                settings.HeroId = (catalog.Data.Heroes.FirstOrDefault(h => !string.IsNullOrEmpty(h.AnimationSetResource)) ?? catalog.Data.Heroes.First()).Id;
                settings.RankId = null;
            }
            heroField.choices = catalog.Data.Heroes.Select(HeroLabel).ToList();
            heroField.SetValueWithoutNotify(HeroLabel(catalog.Hero(settings.HeroId))); RebuildRanks();
            if(settings.MonsterSetupVersion==0 && catalog.Data.Monsters.Count>0)
            {
                settings.MonsterIds=catalog.Data.Monsters.Take(3).Select(m=>m.Id).ToList();
                settings.TargetHp=0;settings.MonsterSetupVersion=1;
                settings.TargetSpacing=220;rootVisualElement.Q<IntegerField>("sandbox-spacing")?.SetValueWithoutNotify(220);
                rootVisualElement.Q<IntegerField>("sandbox-target-hp")?.SetValueWithoutNotify(0);
            }
            RebuildMonsters();
            SetStatus("Loaded " + catalog.Data.ConfigVersion + ". Save edits in Hero Balance before reloading here.");
        }
        void RebuildMonsters()
        {
            monsterRows.Clear();settings.MonsterIds=settings.MonsterIds??new System.Collections.Generic.List<string>();
            string previousChoice=monsterToAdd.value;
            monsterToAdd.choices=catalog.Data.Monsters.Select(MonsterLabel).ToList();
            monsterToAdd.SetValueWithoutNotify(monsterToAdd.choices.Contains(previousChoice)?previousChoice:monsterToAdd.choices.FirstOrDefault()??"");
            rootVisualElement.Q<Button>("sandbox-add-monster").SetEnabled(catalog.Data.Monsters.Count>0 && settings.MonsterIds.Count<5);
            monsterRows.Add(new Label("MONSTER TEAM / "+settings.MonsterIds.Count+" / 5"));
            for(int i=0;i<settings.MonsterIds.Count;i++)
            {
                int index=i;var row=new VisualElement();row.AddToClassList("toolbar");monsterRows.Add(row);
                var definition=catalog.Data.Monsters.FirstOrDefault(m=>m.Id==settings.MonsterIds[index]);
                var choice=new DropdownField("Slot "+(index+1)){name="sandbox-monster-"+index,choices=monsterToAdd.choices};
                choice.SetValueWithoutNotify(definition==null?"Missing: "+settings.MonsterIds[index]:MonsterLabel(definition));
                choice.RegisterValueChangedCallback(e=>Execute(()=>settings.MonsterIds[index]=catalog.Data.Monsters.Single(m=>MonsterLabel(m)==e.newValue).Id));
                choice.style.flexGrow=1;row.Add(choice);
                row.Add(new Button(()=>Execute(()=>{settings.MonsterIds.RemoveAt(index);RebuildMonsters();})){text="Remove",name="sandbox-remove-monster-"+index});
            }
            settings.TargetCount=settings.MonsterIds.Count;monsterCount.SetValueWithoutNotify(settings.TargetCount);
        }
        void RebuildRanks()
        {
            var ranks = HeroCombatSandbox.Ranks(catalog, settings.HeroId);
            if (!ranks.Any(r => r.Id == settings.RankId)) settings.RankId = ranks.Last().Id;
            rankField.choices = ranks.Select(RankLabel).ToList();
            rankField.SetValueWithoutNotify(RankLabel(ranks.Single(r => r.Id == settings.RankId))); RebuildSkills();
        }
        void RebuildSkills()
        {
            skillButtons.Clear();
            var hero = HeroCombatSandbox.TemporaryHero(catalog, settings.HeroId, settings.RankId);
            var unlocked = HeroProgression.UnlockedSkills(hero, catalog).Select(s => s.Id).ToHashSet();
            foreach (var slot in catalog.Hero(settings.HeroId).SkillSlots)
            {
                var skill = catalog.Skill(slot.SkillId); string slotId = slot.Id;
                bool locked = !unlocked.Contains(slot.Id), passive = skill.Kind == SkillKind.Passive;
                bool onDeath=passive && skill.Activation==SkillActivation.OnDeath;
                var button = new Button(() => Execute(() => RunTest(SandboxTestMode.SingleSkill, slotId)))
                { name = "sandbox-cast-" + slot.Id, text = slot.Id + " / " + skill.Name + (locked ? " [locked]" : onDeath ? " [on death; use low Hero HP]" : passive ? " [passive trigger pending]" : "") };
                button.SetEnabled(!locked && (!passive || onDeath)); skillButtons.Add(button);
            }
        }

        public void RunTest(SandboxTestMode mode, string slotId = null)
        {
            if(settings.MonsterIds==null || settings.MonsterIds.Count<1 || settings.MonsterIds.Count>5)
                throw new ArgumentException("Choose 1–5 Monsters before starting a test.");
            if (SceneManager.GetActiveScene().path != "Assets/Zatod/Scenes/ArenaPrototype.unity")
                throw new InvalidOperationException("Open ArenaPrototype.unity before testing.");
            if (EditorApplication.isCompiling) throw new InvalidOperationException("Wait for compilation to finish.");
            settings.Mode = mode; settings.SkillSlotId = slotId;
            SessionState.SetString(PendingKey, JsonUtility.ToJson(settings));
            SetStatus("Preparing preview...");
            if (EditorApplication.isPlaying) Schedule();
            else EditorApplication.EnterPlaymode();
        }
        static ArenaView Arena()
        {
            var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
            if (arena == null || !arena.SandboxMode || arena.Record == null) throw new InvalidOperationException("Run a sandbox test first.");
            return arena;
        }
        static void Step(int direction)
        {
            var arena = Arena(); if (arena.Playing) arena.TogglePlayback();
            arena.Seek((arena.Timeline.Tick + direction) / (float)arena.Record.tickRate);
        }
        static void Schedule()
        {
            deadline = EditorApplication.timeSinceStartup + 20;
            EditorApplication.update -= Poll; EditorApplication.update += Poll;
        }
        static void Poll()
        {
            if (EditorApplication.timeSinceStartup > deadline)
            { FinishPending("Sandbox timed out waiting for Play Mode. Open ArenaPrototype and try again."); return; }
            if (!EditorApplication.isPlaying) return;
            var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
            if (arena == null || !arena.Ready) return;
            try
            {
                var request = JsonUtility.FromJson<HeroSandboxSettings>(SessionState.GetString(PendingKey, ""));
                if (request == null) { FinishPending("No pending preview."); return; }
                var currentCatalog = HeroDataJson.ReadDocuments(HeroConfigFileStore.Read());
                BattleRecord record = HeroCombatSandbox.Build(currentCatalog, request);
                arena.LoadSandbox(record);
                int casts = record.events.Count(e => e.actorId == 1 && e.kind == BattleEventKind.Action && e.ability != "Recover" && e.ability != "In position");
                FinishPending(record.opponentId + ": " + casts + " action(s), " + record.projectiles.Count + " projectile(s). Preview playing in Game view.");
            }
            catch (Exception error) { FinishPending(error.Message); }
        }
        static void FinishPending(string message)
        {
            EditorApplication.update -= Poll; SessionState.EraseString(PendingKey); SetStatus(message);
        }
        static void SetStatus(string message)
        {
            SessionState.SetString(StatusKey, message);
            foreach (var window in Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>())
                if (window.status != null) window.status.text = message;
        }
        void Execute(Action action)
        {
            try { action(); }
            catch (Exception error) { SetStatus(error.Message); }
        }
    }
}
