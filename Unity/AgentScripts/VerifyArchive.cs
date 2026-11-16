using System;
using System.IO;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Networking;

public static class VerifyArchive
{
    public static object Run()
    {
        int checks = 0;
        Action<bool, string> check = (ok, reason) => { checks++; if (!ok) throw new Exception(reason); };
        string id = Guid.NewGuid().ToString("N");
        var record = new BattleSimulation(id, "balanced", 123, PrototypeTeams.Create("balanced")).RunToCompletion();
        record.createdUtc = DateTime.UtcNow.ToString("O");
        byte[] bytes = ReplayArchive.Encode(record);
        var loaded = ReplayArchive.Decode(bytes);
        check(JsonUtility.ToJson(record) == JsonUtility.ToJson(loaded), "Unity serialization changed record");
        var timeline = new ReplayTimeline(loaded);
        timeline.Seek(record.durationTicks);
        foreach (var f in record.snapshots[record.snapshots.Count - 1].fighters)
            check(JsonUtility.ToJson(f) == JsonUtility.ToJson(timeline.States[f.id]), "Serialized final state differs");
        string directory = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/ArchiveChecks", id));
        var repository = new ReplayRepository(directory);
        repository.Save(id, bytes);
        var reopened = new ReplayRepository(directory);
        check(ReplayArchive.Hash(bytes) == ReplayArchive.Hash(reopened.Read(id)), "Disk archive differs");
        check(reopened.Recent().Length == 1 && reopened.Recent()[0].battleId == id, "History did not survive reopening");
        bool rejected = false;
        try { repository.Save(id, bytes); } catch (IOException) { rejected = true; }
        check(rejected, "Committed replay overwritten");
        rejected = false;
        try { repository.Read("../../outside"); } catch (ArgumentException) { rejected = true; }
        check(rejected, "Path traversal accepted");
        rejected = false;
        try { ReplayArchive.Decode(new byte[] { 1, 2, 3, 4 }); } catch (Exception) { rejected = true; }
        check(rejected, "Corrupted gzip accepted");
        loaded.schemaVersion = 999;
        rejected = false;
        try { ReplayArchive.Decode(ReplayArchive.Encode(loaded)); } catch (InvalidDataException) { rejected = true; }
        check(rejected, "Unknown replay schema accepted");
        loaded.schemaVersion = 1;
        loaded.events[2].sequence = 999;
        rejected = false;
        try { ReplayArchive.Decode(ReplayArchive.Encode(loaded)); } catch (InvalidDataException) { rejected = true; }
        check(rejected, "Invalid event ordering accepted");
        loaded.events[2].sequence = 2;
        loaded.snapshots[1].nextEventIndex = 0;
        rejected = false;
        try { ReplayArchive.Decode(ReplayArchive.Encode(loaded)); } catch (InvalidDataException) { rejected = true; }
        check(rejected, "Invalid snapshot offset accepted");
        string oldDirectory = Path.GetFullPath(Path.Combine(Application.dataPath, "../../ServerData"));
        int legacyReplays = 0;
        if (Directory.Exists(oldDirectory))
        foreach (string file in Directory.GetFiles(oldDirectory, "*.arena.gz").OrderBy(p => p).Take(3))
        {
            var old = ReplayArchive.Decode(File.ReadAllBytes(file));
            if (old.rulesVersion != "combat-prototype-1") continue;
            var playback = new ReplayTimeline(old);
            playback.Seek(old.durationTicks);
            foreach (var f in old.snapshots[old.snapshots.Count - 1].fighters)
                check(JsonUtility.ToJson(f) == JsonUtility.ToJson(playback.States[f.id]), "Legacy replay changed after movement upgrade");
            legacyReplays++;
        }
        return new { passed = true, checks, legacyReplays, bytes = bytes.Length, events = record.events.Count, duration = record.DurationSeconds, file = directory };
    }
}
