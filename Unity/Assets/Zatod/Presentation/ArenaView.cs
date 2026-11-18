using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem.UI;
using Zatod.Combat;
using Zatod.Networking;

namespace Zatod.Presentation
{
    public sealed class ArenaView : MonoBehaviour
    {
        public TMP_FontAsset Font;
        public float Playhead { get; private set; }
        public bool Playing { get; private set; }
        public float Speed { get; private set; } = 1;
        public ReplayTimeline Timeline { get; private set; }
        public BattleRecord Record { get; private set; }
        public bool SandboxMode { get; private set; }
        public bool Ready { get { return root != null; } }
        public Transform ViewRoot=>root;
        public void SetCampaignTitle(string title)
        {if(modeTitle!=null)modeTitle.text="CAMPAIGN";if(modeNote!=null)modeNote.text=title;}
        static readonly Color Background = Hex("0B111B"), Panel = Hex("111D2A"), Border = Hex("243647"), Muted = Hex("8C9DAE"), White = Hex("EDF2F6"), Gold = Hex("E7BB73"), Blue = Hex("66C8E8"), Red = Hex("EF8D83");
        ArenaConnection connection;
        RectTransform root, stage, actors, effects, history;
        TextMeshProUGUI status, clock, result, info, feed, pauseLabel, addressState, leftCount, rightCount;
        TextMeshProUGUI modeTitle, authorityLabel;
        TextMeshProUGUI modeNote;
        UnityEngine.UI.Button challenge, connect;
        TMP_InputField address;
        UnityEngine.UI.Slider progress;
        readonly List<string> logs = new List<string>();
        readonly Dictionary<int, FighterVisual> visuals = new Dictionary<int, FighterVisual>();
        readonly List<FloatingEffect> floaters = new List<FloatingEffect>();
        readonly List<FighterState> drawStates = new List<FighterState>();
        float cameraCenterX, pixelsPerUnit = .078f;
        float recordCameraCenterX, recordPixelsPerUnit;
        string opponent = "balanced";
        bool seeking;
        float previousRealtime;
        bool beginWhenConnected;
        public bool IsVisible { get { return root != null && root.gameObject.activeInHierarchy; } }

        sealed class FighterVisual
        {
            public RectTransform root, hp, energy;
            public CanvasGroup group;
            public TextMeshProUGUI value, action;
            public ArenaGraphic icon;
            public ReplaySprite sprite;
            public Vector2 iconOrigin;
            public float flashUntil;
        }
        sealed class FloatingEffect { public RectTransform rect; public CanvasGroup group; public Vector2 origin; public float born, lifetime; }
        readonly Dictionary<BattleProjectile, ReplaySprite> projectileVisuals = new Dictionary<BattleProjectile, ReplaySprite>();
        readonly Dictionary<BattleVisualEffect, ReplaySprite> skillVisuals = new Dictionary<BattleVisualEffect, ReplaySprite>();
        readonly Dictionary<BattleVisualEffect, ArenaGraphic> shockwaves = new Dictionary<BattleVisualEffect, ArenaGraphic>();

        void Start()
        {
            connection = GetComponent<ArenaConnection>();
            if (connection.IsServer || (Array.IndexOf(Environment.GetCommandLineArgs(), "--arena-smoke") >= 0 || Array.IndexOf(Environment.GetCommandLineArgs(), "--campaign-smoke") >= 0)) { enabled = false; return; }
            BuildInterface();
            connection.ReplayReceived += Load;
            connection.CatalogChanged += DrawHistory;
            connection.StatusChanged += UpdateConnection;
            PreviewTeams();
            UpdateConnection();
            previousRealtime = Time.realtimeSinceStartup;
            if (GetComponent<FormationView>() != null) SetVisible(false);
        }

        public void SetVisible(bool visible)
        {
            if (root != null) root.parent.gameObject.SetActive(visible);
            if (!visible) { Playing = false; beginWhenConnected = false; }
            previousRealtime = Time.realtimeSinceStartup;
        }

        public void OpenBattle()
        {
            SetSandboxMode(false);
            SetVisible(true);
            if (connection.Busy) return;
            if (connection.Connected) connection.Challenge(opponent);
            else { beginWhenConnected = true; connection.Connect(); }
        }

        void BuildInterface()
        {
            var canvasGo = new GameObject("ArenaCanvas", typeof(RectTransform), typeof(Canvas), typeof(UnityEngine.UI.CanvasScaler), typeof(UnityEngine.UI.GraphicRaycaster));
            canvasGo.GetComponent<Canvas>().renderMode = RenderMode.ScreenSpaceOverlay;
            var scaler = canvasGo.GetComponent<UnityEngine.UI.CanvasScaler>();
            scaler.uiScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1600, 900);
            scaler.screenMatchMode = UnityEngine.UI.CanvasScaler.ScreenMatchMode.Expand;
            var full = canvasGo.AddComponent<UnityEngine.UI.Image>(); full.color = Background; full.raycastTarget = false;
            root = Rect(canvasGo.transform, "Layout", 0, 0, 1600, 900);
            root.anchorMin = root.anchorMax = new Vector2(.5f, .5f); root.pivot = new Vector2(.5f, .5f); root.anchoredPosition = Vector2.zero;
            if (FindFirstObjectByType<EventSystem>() == null) new GameObject("EventSystem", typeof(EventSystem), typeof(InputSystemUIInputModule));

            Label(root, "Z A T O D", 28, 20, 360, 42, 29, White, FontStyles.Bold);
            Label(root, "COMBAT PROTOTYPE  /  02", 30, 68, 470, 24, 13, Muted);
            var formationView = GetComponent<FormationView>();
            if (formationView != null) Button(root, "SQUAD", 760, 28, 180, 40, formationView.Show, Gold);
            modeTitle = Label(root, "OFFLINE ARENA", 1000, 28, 280, 30, 18, Gold, FontStyles.Bold);
            authorityLabel = Label(root, "SERVER-RECORDED BATTLE", 1000, 61, 360, 22, 12, Muted);
            Box(root, "HeaderRule", 28, 106, 1544, 1, Border);

            stage = Box(root, "BattleStage", 28, 128, 1140, 600, Panel);
            var floor = Rect(stage, "ArenaFloor", 0, 70, 1140, 475).gameObject.AddComponent<ArenaGraphic>(); floor.shape = 0; floor.raycastTarget = false;
            Label(stage, "YOUR SQUAD", 28, 22, 280, 28, 17, Blue, FontStyles.Bold);
            Label(stage, "DEFENSE SQUAD", 832, 22, 280, 28, 17, Red, FontStyles.Bold, TextAlignmentOptions.Right);
            clock = Label(stage, "00:00.00", 430, 20, 280, 36, 26, White, FontStyles.Bold, TextAlignmentOptions.Center);
            leftCount = Label(stage, "5  /  5", 28, 53, 200, 24, 12, Muted);
            rightCount = Label(stage, "5 / 5  |  AUTO SKILLS", 862, 53, 250, 24, 12, Muted, FontStyles.Normal, TextAlignmentOptions.Right);
            actors = Rect(stage, "Fighters", 0, 0, 1140, 600);
            effects = Rect(stage, "Effects", 0, 0, 1140, 600);
            actors.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            effects.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            result = Label(stage, "", 300, 200, 540, 110, 36, Gold, FontStyles.Bold, TextAlignmentOptions.Center);
            info = Label(stage, "Choose a defense squad, connect, then start a challenge.", 28, 554, 1084, 28, 14, Muted, FontStyles.Normal, TextAlignmentOptions.Center);

            var side = Box(root, "ArenaControls", 1192, 128, 380, 728, Panel);
            Label(side, "ARENA CONNECTION", 22, 20, 336, 24, 14, White, FontStyles.Bold);
            address = Input(side, "ServerAddress", 22, 56, 218, 40, "127.0.0.1");
            connect = Button(side, "Connect", 250, 56, 108, 40, () => { if (connection.Connected) connection.Disconnect(); else { connection.Address = address.text.Trim(); connection.Connect(); } }, Blue);
            addressState = Label(side, "Dedicated server / TCP 7777", 22, 104, 336, 24, 12, Muted);
            Box(side, "Rule", 22, 145, 336, 1, Border);
            Label(side, "CHOOSE DEFENSE", 22, 166, 336, 24, 13, Muted, FontStyles.Bold);
            Button(side, "Balanced", 22, 204, 106, 38, () => SelectOpponent("balanced"), Border);
            Button(side, "Fortress", 136, 204, 106, 38, () => SelectOpponent("fortress"), Border);
            Button(side, "Burst", 250, 204, 108, 38, () => SelectOpponent("burst"), Border);
            challenge = Button(side, "START CHALLENGE", 22, 260, 336, 48, () => connection.Challenge(opponent), Gold);
            modeNote = Label(side, "Auto ultimates. Result saved before playback.", 22, 316, 336, 34, 12, Muted);
            Box(side, "RuleHistory", 22, 362, 336, 1, Border);
            Label(side, "SERVER HISTORY", 22, 382, 228, 24, 13, White, FontStyles.Bold);
            Button(side, "Refresh", 270, 378, 88, 30, () => connection.RefreshCatalog(), Border);
            history = Rect(side, "History", 22, 420, 336, 130);
            Label(history, "No saved battles yet.", 0, 0, 336, 30, 13, Muted);
            Box(side, "RuleFeed", 22, 560, 336, 1, Border);
            Label(side, "BATTLE EVENTS", 22, 579, 336, 22, 13, White, FontStyles.Bold);
            feed = Label(side, "Recorded outcomes appear here.", 22, 613, 336, 98, 12, Muted);

            var footer = Box(root, "Playback", 28, 752, 1140, 104, Panel);
            pauseLabel = Button(footer, "PLAY", 20, 46, 90, 38, TogglePlayback, Gold).GetComponentInChildren<TextMeshProUGUI>();
            Button(footer, "Restart", 120, 46, 90, 38, () => Seek(0), Border);
            Button(footer, "-5s", 220, 46, 64, 38, () => Seek(Playhead - 5), Border);
            Button(footer, "+5s", 292, 46, 64, 38, () => Seek(Playhead + 5), Border);
            Button(footer, "0.5x", 698, 46, 70, 38, () => Speed = .5f, Border);
            Button(footer, "1x", 776, 46, 60, 38, () => Speed = 1, Border);
            Button(footer, "2x", 844, 46, 60, 38, () => Speed = 2, Border);
            Button(footer, "4x", 912, 46, 60, 38, () => Speed = 4, Border);
            Button(footer, "End", 996, 46, 122, 38, () => { if (Record != null) Seek(Record.DurationSeconds); }, Border);
            progress = Slider(footer, 20, 16, 1098, 16);
            progress.onValueChanged.AddListener(value => { if (!seeking && Record != null) Seek(value * Record.DurationSeconds); });
            status = Label(root, "", 30, 869, 1540, 24, 12, Muted);
        }

        void PreviewTeams()
        {
            foreach (var state in PrototypeTeams.Create(opponent))
                if (!visuals.ContainsKey(state.id)) visuals.Add(state.id, MakeFighter(state));
            RenderStates(PrototypeTeams.Create(opponent), 0, true);
        }

        void SelectOpponent(string id)
        {
            opponent = id;
            if (Record == null) PreviewTeams();
            info.text = "Selected defense: " + opponent.ToUpperInvariant() + ". Server owns all squad stats.";
        }

        public void Load(BattleRecord record)
        {
            SetSandboxMode(false);
            Record = record;
            Timeline = new ReplayTimeline(record);
            Timeline.EventApplied += OnBattleEvent;
            Playhead = 0; Playing = true;
            logs.Clear(); ClearEffects();
            // A new match can contain different heroes and fewer than five allies.
            foreach (var visual in visuals.Values) Destroy(visual.root.gameObject);
            visuals.Clear();
            foreach (var visual in projectileVisuals.Values) Destroy(visual.gameObject);
            projectileVisuals.Clear();
            foreach (var visual in skillVisuals.Values) Destroy(visual.gameObject);
            skillVisuals.Clear();
            foreach (var visual in shockwaves.Values) Destroy(visual.gameObject);
            shockwaves.Clear();
            result.text = "";
            info.text = "REPLAY  " + record.battleId.Substring(0, 8).ToUpperInvariant() + "   /   " + record.opponentId.ToUpperInvariant() + "   /   RESULT COMMITTED";
            foreach (var f in record.initial) if (!visuals.ContainsKey(f.id)) visuals.Add(f.id, MakeFighter(f));
            if (record.projectiles != null) foreach (var projectile in record.projectiles)
            {
                var owner = record.initial.Find(f => f.id == projectile.actorId);
                if (owner == null || string.IsNullOrEmpty(owner.animationSetResource)) continue;
                var rect = Rect(effects, "Projectile_" + projectile.actorId, 0, 0, 1, 1);
                rect.anchorMin = rect.anchorMax = new Vector2(.5f, .5f);
                var visual = rect.gameObject.AddComponent<ReplaySprite>(); visual.Initialize(owner.animationSetResource);
                projectileVisuals.Add(projectile, visual);
            }
            if (record.visualEffects != null) foreach (var effect in record.visualEffects)
            {
                if (effect.shockwave)
                {
                    var ringRect = Rect(effects,"BurstRing_"+effect.startTick,0,0,1,1);
                    ringRect.anchorMin = ringRect.anchorMax = ringRect.pivot = new Vector2(.5f,.5f);
                    var ring = ringRect.gameObject.AddComponent<ArenaGraphic>(); ring.shape=8;ring.raycastTarget=false;
                    shockwaves.Add(effect,ring);continue;
                }
                var owner = record.initial.Find(f => f.id == effect.actorId);
                if (owner == null || string.IsNullOrEmpty(owner.animationSetResource)) continue;
                var rect = Rect(effects, "FX_" + effect.state + "_" + effect.targetId + "_" + skillVisuals.Count, 0, 0, 1, 1);
                rect.anchorMin = rect.anchorMax = new Vector2(.5f,.5f);
                var visual = rect.gameObject.AddComponent<ReplaySprite>(); visual.Initialize(owner.animationSetResource);
                skillVisuals.Add(effect,visual);
            }
            FitRecordCamera();
            RenderStates(Timeline.States.Values, 0, true);
            UpdatePlaybackLabels();
        }

#if UNITY_EDITOR
        public void LoadSandbox(BattleRecord record)
        {
            if (connection.Busy) throw new InvalidOperationException("Wait for the pending Arena request before opening a sandbox preview.");
            GetComponent<CampaignView>()?.Hide();
            GetComponent<HeroRosterView>()?.Hide();
            GetComponent<FormationView>()?.Hide();
            Load(record); SetSandboxMode(true); FitRecordCamera(); SetVisible(true); Speed = 1; Seek(0);
        }
#endif
        void SetSandboxMode(bool enabled)
        {
            SandboxMode = enabled;
            if (modeTitle != null) modeTitle.text = enabled ? "COMBAT SANDBOX" : "OFFLINE ARENA";
            if (authorityLabel != null) authorityLabel.text = enabled ? "EDITOR / LOCAL COMBAT CORE" : "SERVER-RECORDED BATTLE";
            if (modeNote != null) modeNote.text = enabled ? "Temporary preview. No server archive is written." : "Auto ultimates. Result saved before playback.";
            UpdateConnection();
        }

        public void TogglePlayback()
        {
            if (Record == null) return;
            if (Playhead >= Record.DurationSeconds) Seek(0);
            Playing = !Playing;
            UpdatePlaybackLabels();
        }

        public void Seek(float seconds)
        {
            if (Record == null) return;
            Playhead = Mathf.Clamp(seconds, 0, Record.DurationSeconds);
            Timeline.Seek(Mathf.FloorToInt(Playhead * Record.tickRate + .001f));
            ClearEffects(); logs.Clear();
            // Rebuild the small feed from the destination, without replaying transient VFX/audio.
            for (int i = Record.events.Count - 1; i >= 0 && logs.Count < 4; i--)
            {
                var e = Record.events[i];
                if (e.tick <= Timeline.Tick && Interesting(e)) logs.Insert(0, Describe(e));
            }
            feed.text = string.Join("\n", logs);
            RenderStates(Timeline.States.Values, Playhead * Record.tickRate, true);
            UpdatePlaybackLabels();
        }

        void Update()
        {
            float now = Time.realtimeSinceStartup;
            float delta = Mathf.Min(now - previousRealtime, .25f);
            previousRealtime = now;
            if (Record != null)
            {
                if (Playing)
                {
                    Playhead = Mathf.Min(Record.DurationSeconds, Playhead + delta * Speed);
                    Timeline.AdvanceTo(Mathf.FloorToInt(Playhead * Record.tickRate + .001f));
                    if (Playhead >= Record.DurationSeconds) Playing = false;
                }
                RenderStates(Timeline.States.Values, Playhead * Record.tickRate, false);
                UpdatePlaybackLabels();
            }
            for (int i = floaters.Count - 1; i >= 0; i--)
            {
                var f = floaters[i];
                float age = (now - f.born) / f.lifetime;
                if (age >= 1) { Destroy(f.rect.gameObject); floaters.RemoveAt(i); continue; }
                f.rect.anchoredPosition = f.origin + Vector2.up * age * 55;
                f.group.alpha = 1 - age * age;
            }
            challenge.interactable = !SandboxMode && connection.Connected && !connection.Busy;
            connect.interactable = !SandboxMode;
            address.interactable = !SandboxMode && !connection.Connected && !connection.Busy;
        }

        void UpdateConnection()
        {
            if (status == null) return;
            status.text = SandboxMode ? "Editor sandbox: temporary Hero, same combat core. No server request, account write or archive commit." : connection.Status;
            connect.GetComponentInChildren<TextMeshProUGUI>().text = connection.Connected ? "Disconnect" : "Connect";
            addressState.text = SandboxMode ? "SANDBOX / no network required" : connection.Connected ? "CONNECTED  /  dedicated server :" + connection.Port : "Dedicated server / TCP " + connection.Port;
            addressState.color = connection.Connected ? Blue : Muted;
            if (beginWhenConnected && connection.Connected && !connection.Busy)
            {
                beginWhenConnected = false;
                connection.Challenge(opponent);
            }
        }

        void UpdatePlaybackLabels()
        {
            if (Record == null) return;
            clock.text = TimeText(Playhead);
            pauseLabel.text = Playing ? "PAUSE" : "PLAY";
            seeking = true; progress.SetValueWithoutNotify(Playhead / Record.DurationSeconds); seeking = false;
            bool ended = Playhead >= Record.DurationSeconds;
            result.text = ended ? SandboxMode ? "SANDBOX COMPLETE" : Record.winner == 0 ? "VICTORY" : Record.winner == 1 ? "DEFEAT" : "DRAW" : "";
            if (SandboxMode) info.text = "SANDBOX  /  " + Record.opponentId + "  /  " + Speed.ToString("0.#") + "x  /  temporary data, no Arena result";
            else if (ended) info.text = (Record.timedOut ? "TIME LIMIT  /  " : "BATTLE COMPLETE  /  ") + "Replay saved on server. Restart or select it from history.";
            else info.text = (LegacyLayout ? "LEGACY REPLAY  " : "REPLAY  ") + Record.battleId.Substring(0, 8).ToUpperInvariant() + "   /   " + Record.opponentId.ToUpperInvariant() + "   /   " + Speed.ToString("0.#") + "x   /   " + TimeText(Record.DurationSeconds);
        }

        void DrawHistory()
        {
            for (int i = history.childCount - 1; i >= 0; i--) Destroy(history.GetChild(i).gameObject);
            int count = Mathf.Min(3, connection.Catalog.Length);
            for (int i = 0; i < count; i++)
            {
                var entry = connection.Catalog[i];
                string text = entry.battleId.Substring(0, 8) + "  /  " + entry.opponentId + "  /  " + (entry.winner == 0 ? "WIN" : entry.winner == 1 ? "LOSS" : "DRAW");
                Button(history, text, 0, i * 43, 336, 36, () => connection.LoadReplay(entry.battleId), Border);
            }
            if (count == 0) Label(history, "No saved battles yet.", 0, 0, 336, 30, 13, Muted);
        }

        FighterVisual MakeFighter(FighterState state)
        {
            var rect = Rect(actors, "Fighter_" + state.id, 0, 0, 88, 112);
            rect.anchorMin = rect.anchorMax = new Vector2(.5f, .5f); rect.pivot = new Vector2(.5f, .5f);
            var group = rect.gameObject.AddComponent<CanvasGroup>();
            Box(rect, "Shadow", 20, 76, 48, 5, new Color(0, 0, 0, .3f));
            var iconRect = Rect(rect, "RoleIcon", 18, 20, 52, 52);
            var icon = iconRect.gameObject.AddComponent<ArenaGraphic>(); icon.shape = (int)state.role + 1; icon.color = state.team == 0 ? Blue : Red; icon.raycastTarget = false;
            ReplaySprite sprite = null;
            if (!string.IsNullOrEmpty(state.animationSetResource))
            {
                var spriteRect = Rect(rect, "HeroSprite", 44, 76, 1, 1);
                sprite = spriteRect.gameObject.AddComponent<ReplaySprite>(); sprite.Initialize(state.animationSetResource);
                icon.gameObject.SetActive(false);
            }
            Label(rect, (state.name ?? state.role.ToString()).ToUpperInvariant(), -16, sprite == null ? 0 : -58, 120, 18, 10, Muted, FontStyles.Bold, TextAlignmentOptions.Center);
            float barOffset = sprite == null ? 0 : 36;
            Box(rect, "HpTrack", 6, 84 + barOffset, 76, 5, Background);
            var hp = Box(rect, "Hp", 6, 84 + barOffset, 76, 5, state.team == 0 ? Blue : Red); hp.pivot = new Vector2(0, 1);
            Box(rect, "EnergyTrack", 6, 93 + barOffset, 76, 3, Background);
            var energy = Box(rect, "Energy", 6, 93 + barOffset, 76, 3, Gold); energy.pivot = new Vector2(0, 1);
            var value = Label(rect, "", 0, 99 + barOffset, 88, 16, 9, Muted, FontStyles.Normal, TextAlignmentOptions.Center);
            var action = Label(rect, "", -4, 64, 96, 18, 9, Gold, FontStyles.Bold, TextAlignmentOptions.Center);
            return new FighterVisual { root = rect, hp = hp, energy = energy, group = group, icon = icon, sprite = sprite, iconOrigin = iconRect.anchoredPosition, value = value, action = action };
        }

        void RenderStates(IEnumerable<FighterState> states, float tick, bool snap)
        {
            drawStates.Clear();
            foreach (var state in states) drawStates.Add(state);
            UpdateBattleCamera(snap);
            // Shallow depth determines draw order, not attack distance or navigation lanes.
            drawStates.Sort((a, b) => a.y == b.y ? a.id.CompareTo(b.id) : b.y.CompareTo(a.y));
            int leftAlive = 0, rightAlive = 0;
            foreach (var s in drawStates)
            {
                if (s.Alive) { if (s.team == 0) leftAlive++; else rightAlive++; }
                var v = visuals[s.id];
                v.root.SetAsLastSibling();
                Vector2 point = Position(s);
                point.y += s.presentationHeight * .9f;
                if (s.knockUpUntil > tick)
                    point.y += Mathf.Sin(Mathf.PI * (tick - s.controlStartTick) / Mathf.Max(1, s.knockUpUntil - s.controlStartTick)) * s.knockUpHeight * pixelsPerUnit;
                float phase = Mathf.Clamp01((tick - s.actionStartTick) / Mathf.Max(1, s.actionEndTick - s.actionStartTick));
                bool stunned = s.stunUntil > tick && s.Alive;
                Vector2 iconOffset = Vector2.zero;
                float iconScale = 1;
                if (s.Alive && (s.action == BattleAction.Attack || s.action == BattleAction.Ultimate) && tick <= s.actionEndTick)
                {
                    float pulse = Mathf.Sin(phase * Mathf.PI);
                    iconOffset = new Vector2((s.team == 0 ? 1 : -1) * pulse * 6, pulse * 3);
                    iconScale += pulse * (s.action == BattleAction.Ultimate ? .12f : .04f);
                }
                else if (s.Alive && !stunned && s.action == BattleAction.Moving)
                    iconOffset.y = Mathf.Sin((tick - s.actionStartTick) * .8f) * 2;
                // Attack poses affect only the symbol. The unit root/health bars follow recorded centers.
                v.root.localScale = Vector3.one;
                v.icon.rectTransform.anchoredPosition = v.iconOrigin + iconOffset;
                v.icon.rectTransform.localScale = Vector3.one * iconScale;
                v.root.anchoredPosition = snap ? point : Vector2.Lerp(v.root.anchoredPosition, point, 1 - Mathf.Exp(-24 * Time.unscaledDeltaTime));
                v.hp.localScale = new Vector3((float)s.hp / s.maxHp, 1, 1);
                v.energy.localScale = new Vector3(s.energy / 100f, 1, 1);
                bool resurrecting=s.reviveAtTick>tick;
                v.group.alpha = s.Alive || resurrecting || (v.sprite != null && tick - s.actionStartTick < (s.deathVisualTicks > 0 ? s.deathVisualTicks : 30)) ? 1 : LegacyLayout ? .18f : 0;
                if (v.sprite != null)
                {
                    string state = resurrecting ? s.animationState : !s.Alive ? "Death" : stunned ? "Stun" : tick < s.animationEndTick ? s.animationState : s.action == BattleAction.Moving ? "Run" : "Idle";
                    int start = resurrecting ? s.animationStartTick : !s.Alive ? s.actionStartTick : stunned ? s.controlStartTick : tick < s.animationEndTick ? s.animationStartTick : s.actionStartTick;
                    v.sprite.Sample(state, (tick - start) / (Record == null ? 20 : Record.tickRate), s.facingDirection==0?s.team==0:s.facingDirection>0, .9f);
                    v.sprite.GetComponent<RectTransform>().anchoredPosition = new Vector2(44,-76+v.sprite.PresentationHeight*.9f);
                }
                v.value.text = s.Alive ? s.hp + " / " + s.maxHp : "";
                v.action.text = resurrecting ? "RESURRECTING" : !s.Alive ? "DEFEATED" : stunned ? ControlText(s.controlKind).ToUpperInvariant() : s.burnUntil > tick ? "BURNING" : s.poisonUntil > tick ? "POISONED" : s.lifestealBasisPoints>0 ? "+ LIFESTEAL" : s.damageBonusBasisPoints > 0 ? "+ DAMAGE" : s.action == BattleAction.Ultimate ? "ULTIMATE" : s.action == BattleAction.Moving ? "MOVING" : "";
                v.icon.color = Time.realtimeSinceStartup < v.flashUntil ? White : stunned ? Gold : s.team == 0 ? Blue : Red;
            }
            int leftTotal = 0, rightTotal = 0;
            foreach (var s in drawStates) { if (s.team == 0) leftTotal++; else rightTotal++; }
            leftCount.text = leftAlive + "  /  " + leftTotal;
            bool monsterTeam=Record!=null && Record.initial.Exists(f=>f.team==1 && !string.IsNullOrEmpty(f.monsterDefinitionId));
            rightCount.text = rightAlive + " / " + rightTotal + (monsterTeam?"  |  MONSTERS":"  |  AUTO SKILLS");
            foreach (var entry in projectileVisuals)
            {
                var p = entry.Key; var visual = entry.Value;
                string state = !string.IsNullOrEmpty(p.flightState) ? p.flightState : p.resource.Substring(p.resource.LastIndexOf('/') + 1);
                // A close hit can resolve in one server tick. Finish the effect animation at the
                // recorded contact point without changing its hit time, damage or crowd control.
                float visualEnd = p.hasFlightPath ? p.endTick : p.hit ? Mathf.Max(p.endTick, p.startTick + visual.ClipDuration(state) * Record.tickRate) : p.endTick;
                bool visible = tick >= p.startTick && tick < visualEnd;
                visual.gameObject.SetActive(visible);
                if (!visible) continue;
                float x = Mathf.Lerp(p.startX, p.endX, (tick - p.startTick) / Mathf.Max(1, p.endTick - p.startTick));
                float height = p.hasFlightPath ? Mathf.Lerp(p.spawnHeight,p.endHeight,(tick-p.startTick)/Mathf.Max(1,p.endTick-p.startTick)) : p.spawnHeight;
                float depth = p.hasFlightPath ? Mathf.Lerp(p.y,p.endY,(tick-p.startTick)/Mathf.Max(1,p.endTick-p.startTick)) : p.y;
                int direction=p.direction;
                if(p.path!=null && p.path.Count>1)
                {
                    var a=p.path[0];var b=p.path[p.path.Count-1];
                    for(int i=1;i<p.path.Count;i++)if(tick<=p.path[i].tick){a=p.path[i-1];b=p.path[i];break;}
                    float progress=Mathf.Clamp01((tick-a.tick)/Mathf.Max(1,b.tick-a.tick));
                    x=Mathf.Lerp(a.x,b.x,progress);height=Mathf.Lerp(a.height,b.height,progress);depth=Mathf.Lerp(a.y,b.y,progress);
                    if(b.x!=a.x)direction=b.x>a.x?1:-1;
                }
                ((RectTransform)visual.transform).anchoredPosition = new Vector2((x - cameraCenterX) * pixelsPerUnit, depth * .2f - 45 + height * .9f);
                float scale = p.visualScaleBasisPoints > 0 ? .9f * p.visualScaleBasisPoints / 10000f : .65f;
                visual.Sample(state, (tick - p.startTick) / Record.tickRate, direction > 0, scale, true);
            }
            foreach (var entry in skillVisuals)
            {
                var effect = entry.Key; var visual = entry.Value;
                bool visible = tick >= effect.startTick && tick < effect.endTick;
                visual.gameObject.SetActive(visible); if (!visible) continue;
                float x = effect.x, y = effect.y;
                if (effect.followId != 0 && Timeline.States.TryGetValue(effect.followId,out var owner)) { x=owner.x; y=owner.y; }
                x += effect.direction * effect.forward;
                float travel = Mathf.Clamp01((tick-effect.startTick)/Mathf.Max(1,effect.endTick-effect.startTick));
                x += effect.direction * effect.moveForward * travel;
                var rect = (RectTransform)visual.transform;
                rect.anchoredPosition = new Vector2((x-cameraCenterX)*pixelsPerUnit,y*.2f-45+(effect.height+effect.moveHeight*travel)*.9f);
                visual.Sample(effect.state,(tick-effect.startTick)/Record.tickRate,effect.direction>=0,.9f);
                if (effect.stretchToRange)
                {
                    float grow = effect.growTicks > 0 ? Mathf.Clamp01((tick-effect.startTick)/effect.growTicks) : 1;
                    visual.StretchWidth(Mathf.Abs(effect.endX-x)*pixelsPerUnit*grow);
                }
            }
            foreach (var entry in shockwaves)
            {
                var effect=entry.Key;var ring=entry.Value;
                bool visible=tick>=effect.startTick && tick<effect.endTick;
                ring.gameObject.SetActive(visible);if(!visible)continue;
                float age=Mathf.Clamp01((tick-effect.startTick)/Mathf.Max(1,effect.endTick-effect.startTick));
                ring.rectTransform.anchoredPosition=new Vector2((effect.x+effect.direction*effect.forward-cameraCenterX)*pixelsPerUnit,
                    effect.y*.2f-45+effect.height*.9f);
                ring.rectTransform.sizeDelta=new Vector2(35+465*age,15+185*age);
                ring.color=new Color(1,.6f,.22f,1-age);
            }
        }

        bool LegacyLayout { get { return Record != null && Record.rulesVersion == "combat-prototype-1"; } }
        void FitRecordCamera()
        {
            if (Record == null || actors == null) return;
            float min = float.MaxValue, max = float.MinValue;
            void Include(int x) { min = Mathf.Min(min, x); max = Mathf.Max(max, x); }
            foreach (var fighter in Record.initial) Include(fighter.x);
            foreach (var e in Record.events) if (e.hasState) Include(e.state.x);
            if (Record.projectiles != null) foreach (var p in Record.projectiles)
            { Include(p.startX); Include(p.endX); }
            recordCameraCenterX = (min + max) * .5f;
            recordPixelsPerUnit = Mathf.Min(SandboxMode ? .9f : .09f, (actors.rect.width - 160) / Mathf.Max(1, max - min));
        }
        void UpdateBattleCamera(bool snap)
        {
            if (LegacyLayout) return;
            // Offline Arena is a complete recorded fight: one fixed frame avoids apparent self-knockback
            // and gives the same camera at a tick whether played forward or reached by seeking.
            if (Record != null)
            { cameraCenterX = recordCameraCenterX; pixelsPerUnit = recordPixelsPerUnit; return; }
            float min = float.MaxValue, max = float.MinValue;
            foreach (var s in drawStates) if (s.Alive) { min = Mathf.Min(min, s.x); max = Mathf.Max(max, s.x); }
            if (min == float.MaxValue) return;
            float center = (min + max) * .5f;
            float scale = Mathf.Min(SandboxMode ? .9f : .09f, (actors.rect.width - 160) / Mathf.Max(1, max - min));
            float blend = snap ? 1 : 1 - Mathf.Exp(-6 * Time.unscaledDeltaTime);
            cameraCenterX = Mathf.Lerp(cameraCenterX, center, blend);
            pixelsPerUnit = Mathf.Lerp(pixelsPerUnit, scale, blend);
        }
        Vector2 Position(FighterState s)
        {
            if (LegacyLayout)
            {
                float[] oldDepth = { 0, 10, 45, 65, 65 }, oldLane = { 0, -160, 145, -145, 10 };
                float x = s.x * .103f + (s.team == 0 ? -1 : 1) * oldDepth[s.slot];
                return new Vector2(s.team == 0 ? Mathf.Min(-90, x) : Mathf.Max(90, x), oldLane[s.slot] + s.y * .02f - 20);
            }
            // One camera transform for the entire battlefield; no per-unit side/center clamping.
            return new Vector2((s.x - cameraCenterX) * pixelsPerUnit, s.y * .2f - 25);
        }
        void OnBattleEvent(BattleEvent e)
        {
            if (Interesting(e))
            {
                logs.Add(Describe(e)); if (logs.Count > 4) logs.RemoveAt(0);
                feed.text = string.Join("\n", logs);
            }
            if (e.kind == BattleEventKind.Damage || e.kind == BattleEventKind.Heal || e.kind == BattleEventKind.Death)
            {
                if (!visuals.TryGetValue(e.targetId, out var target)) return;
                target.flashUntil = Time.realtimeSinceStartup + .13f;
                bool death = e.kind == BattleEventKind.Death;
                string text = death ? "DEFEATED" : (e.kind == BattleEventKind.Heal ? "+" : "-") + e.amount + (e.critical ? "!" : "");
                var floating = Label(effects, text, 0, 0, 180, 45, death ? 16 : e.critical ? 28 : 23,
                    death ? Gold : e.kind == BattleEventKind.Heal ? Hex("8FE4B4") : e.critical ? Gold : White, FontStyles.Bold, TextAlignmentOptions.Center);
                var rect = floating.rectTransform;
                rect.anchorMin = rect.anchorMax = new Vector2(.5f, .5f); rect.pivot = new Vector2(.5f, .5f);
                rect.anchoredPosition = target.root.anchoredPosition + Vector2.up * 50;
                var group = floating.gameObject.AddComponent<CanvasGroup>();
                floaters.Add(new FloatingEffect { rect = rect, group = group, origin = rect.anchoredPosition, born = Time.realtimeSinceStartup, lifetime = .85f });
            }
        }
        static string ControlText(ControlKind kind) { return kind == ControlKind.KnockUp ? "airborne" : kind == ControlKind.Knockback ? "knockback" : "stunned"; }
        static bool Interesting(BattleEvent e) { return e.kind == BattleEventKind.ResurrectionPending || e.kind == BattleEventKind.Revive || e.kind == BattleEventKind.Buff || e.kind == BattleEventKind.Heal || e.kind == BattleEventKind.Death || e.kind == BattleEventKind.Stun || e.kind == BattleEventKind.Cancel || e.kind == BattleEventKind.Target || e.kind == BattleEventKind.Miss || (e.kind == BattleEventKind.Action && e.state.action == BattleAction.Ultimate); }
        string Describe(BattleEvent e)
        {
            int id = e.kind == BattleEventKind.Action || e.kind == BattleEventKind.Target || e.kind == BattleEventKind.Miss ? e.actorId : e.targetId;
            string who = (id < 100 ? "A" : "B") + ((id - 1) % 100 + 1);
            string action = e.kind == BattleEventKind.Revive ? "revived +"+e.amount+" HP" : e.kind == BattleEventKind.ResurrectionPending ? "resurrection pending" : e.kind == BattleEventKind.Death ? "defeated" : e.kind == BattleEventKind.Stun ? ControlText(e.controlKind) : e.kind == BattleEventKind.Heal ? "heal +" + e.amount : e.ability;
            if (e.kind == BattleEventKind.Target) action = "targets " + (e.state.targetId < 100 ? "A" : "B") + ((e.state.targetId - 1) % 100 + 1);
            return (e.tick / (float)(Record == null ? 20 : Record.tickRate)).ToString("00.0") + "  " + who + "  " + action;
        }
        void ClearEffects() { foreach (var f in floaters) Destroy(f.rect.gameObject); floaters.Clear(); foreach (var v in visuals.Values) v.flashUntil = 0; }
        static string TimeText(float seconds) { return ((int)seconds / 60).ToString("00") + ":" + (seconds % 60).ToString("00.00", System.Globalization.CultureInfo.InvariantCulture); }

        RectTransform Rect(Transform parent, string name, float x, float y, float w, float h)
        {
            var r = new GameObject(name, typeof(RectTransform)).GetComponent<RectTransform>();
            r.SetParent(parent, false); r.anchorMin = r.anchorMax = new Vector2(0, 1); r.pivot = new Vector2(0, 1);
            r.anchoredPosition = new Vector2(x, -y); r.sizeDelta = new Vector2(w, h); return r;
        }
        RectTransform Box(Transform parent, string name, float x, float y, float w, float h, Color color)
        {
            var r = Rect(parent, name, x, y, w, h); var image = r.gameObject.AddComponent<UnityEngine.UI.Image>(); image.color = color; image.raycastTarget = false; return r;
        }
        TextMeshProUGUI Label(Transform parent, string text, float x, float y, float w, float h, float size, Color color, FontStyles style = FontStyles.Normal, TextAlignmentOptions align = TextAlignmentOptions.Left)
        {
            var r = Rect(parent, "Text", x, y, w, h); var label = r.gameObject.AddComponent<TextMeshProUGUI>();
            label.font = Font; label.text = text; label.fontSize = size; label.color = color; label.fontStyle = style;
            label.alignment = align; label.raycastTarget = false; label.textWrappingMode = TextWrappingModes.Normal; label.overflowMode = TextOverflowModes.Truncate; return label;
        }
        UnityEngine.UI.Button Button(Transform parent, string title, float x, float y, float w, float h, Action action, Color color)
        {
            var r = Box(parent, title, x, y, w, h, color); r.GetComponent<UnityEngine.UI.Image>().raycastTarget = true;
            var button = r.gameObject.AddComponent<UnityEngine.UI.Button>(); button.targetGraphic = r.GetComponent<UnityEngine.UI.Image>();
            var colors = button.colors; colors.highlightedColor = new Color(1.15f, 1.15f, 1.15f); colors.pressedColor = new Color(.75f, .75f, .75f); colors.disabledColor = new Color(.4f, .4f, .4f); button.colors = colors;
            button.onClick.AddListener(() => action());
            Label(r, title, 5, (h - 22) / 2, w - 10, 22, title.Length > 22 ? 11 : 13, color == Gold || color == Blue ? Background : White, FontStyles.Bold, TextAlignmentOptions.Center);
            return button;
        }
        TMP_InputField Input(Transform parent, string name, float x, float y, float w, float h, string value)
        {
            var r = Box(parent, name, x, y, w, h, Background); r.GetComponent<UnityEngine.UI.Image>().raycastTarget = true;
            var input = r.gameObject.AddComponent<TMP_InputField>(); input.targetGraphic = r.GetComponent<UnityEngine.UI.Image>();
            var viewport = Rect(r, "Viewport", 10, 4, w - 20, h - 8); viewport.gameObject.AddComponent<UnityEngine.UI.RectMask2D>();
            var text = Label(viewport, value, 0, 0, w - 20, h - 8, 15, White);
            input.textViewport = viewport; input.textComponent = text; input.text = value; input.characterLimit = 128; return input;
        }
        UnityEngine.UI.Slider Slider(Transform parent, float x, float y, float w, float h)
        {
            var r = Box(parent, "Timeline", x, y, w, h, Background); r.GetComponent<UnityEngine.UI.Image>().raycastTarget = true;
            var slider = r.gameObject.AddComponent<UnityEngine.UI.Slider>();
            var fill = Box(r, "Fill", 0, 0, w, h, Gold);
            fill.anchorMin = Vector2.zero; fill.anchorMax = Vector2.one;
            fill.offsetMin = fill.offsetMax = Vector2.zero; slider.fillRect = fill;
            var handle = Box(r, "Handle", 0, 0, 8, 6, White); handle.GetComponent<UnityEngine.UI.Image>().raycastTarget = true;
            slider.handleRect = handle; slider.targetGraphic = handle.GetComponent<UnityEngine.UI.Image>(); slider.minValue = 0; slider.maxValue = 1; return slider;
        }
        static Color Hex(string value) { ColorUtility.TryParseHtmlString("#" + value, out Color c); return c; }
        void OnDestroy()
        {
            if (connection != null) { connection.ReplayReceived -= Load; connection.CatalogChanged -= DrawHistory; connection.StatusChanged -= UpdateConnection; }
        }
    }
}
