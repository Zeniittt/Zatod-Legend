using System;
using System.Collections.Generic;

namespace Zatod.Combat
{
    // Applies recorded outcomes. It intentionally has no dependency on BattleSimulation.
    public sealed class ReplayTimeline
    {
        readonly BattleRecord record;
        readonly Dictionary<int, FighterState> states = new Dictionary<int, FighterState>();
        int nextEvent;
        public int Tick { get; private set; }
        public IReadOnlyDictionary<int, FighterState> States { get { return states; } }
        public event Action<BattleEvent> EventApplied;

        public ReplayTimeline(BattleRecord record)
        {
            if (record == null || record.schemaVersion != BattleRecord.CurrentSchema)
                throw new ArgumentException("Unsupported replay schema.");
            this.record = record;
            Seek(0);
        }

        public void Seek(int targetTick)
        {
            targetTick = Math.Max(0, Math.Min(record.durationTicks, targetTick));
            BattleSnapshot selected = null;
            foreach (var snapshot in record.snapshots)
            {
                if (snapshot.tick > targetTick) break;
                selected = snapshot;
            }
            states.Clear();
            var source = selected == null ? record.initial : selected.fighters;
            foreach (var state in source) states.Add(state.id, state.Copy());
            nextEvent = selected == null ? 0 : selected.nextEventIndex;
            Tick = selected == null ? 0 : selected.tick;
            AdvanceTo(targetTick, false);
        }

        public void AdvanceTo(int targetTick, bool notify = true)
        {
            targetTick = Math.Max(0, Math.Min(record.durationTicks, targetTick));
            if (targetTick < Tick) { Seek(targetTick); return; }
            while (nextEvent < record.events.Count && record.events[nextEvent].tick <= targetTick)
            {
                var e = record.events[nextEvent++];
                if (e.hasState) states[e.state.id] = e.state.Copy();
                if (notify) EventApplied?.Invoke(e);
            }
            Tick = targetTick;
        }
    }
}
