using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;
using Zatod.Combat;

namespace Zatod.Networking
{
    public static class ReplayArchive
    {
        public const int MaxCompressedBytes = 4 * 1024 * 1024;
        public const int MaxJsonBytes = 16 * 1024 * 1024;

        public static byte[] Encode(BattleRecord record)
        {
            byte[] json = Encoding.UTF8.GetBytes(JsonUtility.ToJson(record));
            if (json.Length > MaxJsonBytes) throw new InvalidDataException("Replay exceeds JSON limit.");
            using (var output = new MemoryStream())
            {
                using (var gzip = new GZipStream(output, System.IO.Compression.CompressionLevel.Optimal, true)) gzip.Write(json, 0, json.Length);
                byte[] bytes = output.ToArray();
                if (bytes.Length > MaxCompressedBytes) throw new InvalidDataException("Replay exceeds archive limit.");
                return bytes;
            }
        }

        public static BattleRecord Decode(byte[] bytes)
        {
            if (bytes == null || bytes.Length == 0 || bytes.Length > MaxCompressedBytes)
                throw new InvalidDataException("Invalid replay size.");
            using (var input = new MemoryStream(bytes))
            using (var gzip = new GZipStream(input, CompressionMode.Decompress))
            using (var output = new MemoryStream())
            {
                var buffer = new byte[8192];
                int count;
                while ((count = gzip.Read(buffer, 0, buffer.Length)) > 0)
                {
                    if (output.Length + count > MaxJsonBytes) throw new InvalidDataException("Replay decompression limit exceeded.");
                    output.Write(buffer, 0, count);
                }
                var record = JsonUtility.FromJson<BattleRecord>(Encoding.UTF8.GetString(output.ToArray()));
                Validate(record);
                return record;
            }
        }

        public static void Validate(BattleRecord r)
        {
            if (r == null || r.schemaVersion != BattleRecord.CurrentSchema)
                throw new InvalidDataException("Unsupported replay version.");
            if (!Guid.TryParseExact(r.battleId, "N", out _) || r.tickRate <= 0 || r.tickRate > 240 ||
                r.durationTicks <= 0 || r.durationTicks > 240 * 600 || r.winner < -1 || r.winner > 1 ||
                r.initial == null || r.initial.Count != 10 || r.events == null || r.events.Count == 0 || r.events.Count > 200000 ||
                r.snapshots == null || r.snapshots.Count == 0)
                throw new InvalidDataException("Invalid replay header.");
            var ids = new HashSet<int>();
            foreach (var f in r.initial)
                if (f == null || !ids.Add(f.id) || f.team < 0 || f.team > 1 || f.maxHp <= 0) throw new InvalidDataException("Invalid fighter.");
            int previousTick = 0;
            for (int i = 0; i < r.events.Count; i++)
            {
                var e = r.events[i];
                if (e == null || e.sequence != i || e.tick < previousTick || e.tick > r.durationTicks ||
                    (e.hasState && (e.state == null || !ids.Contains(e.state.id) || e.state.hp < 0 || e.state.hp > e.state.maxHp)))
                    throw new InvalidDataException("Invalid event ordering or state.");
                previousTick = e.tick;
            }
            int previousSnapshotTick = -1;
            foreach (var s in r.snapshots)
            {
                if (s == null || s.tick < previousSnapshotTick || s.tick > r.durationTicks || s.nextEventIndex < 0 ||
                    s.nextEventIndex > r.events.Count || s.fighters == null || s.fighters.Count != r.initial.Count)
                    throw new InvalidDataException("Invalid snapshot.");
                var snapshotIds = new HashSet<int>();
                foreach (var f in s.fighters)
                    if (f == null || !ids.Contains(f.id) || !snapshotIds.Add(f.id)) throw new InvalidDataException("Invalid snapshot fighters.");
                if (s.nextEventIndex > 0 && r.events[s.nextEventIndex - 1].tick > s.tick)
                    throw new InvalidDataException("Snapshot event offset is ahead of its clock.");
                if (s.nextEventIndex < r.events.Count && r.events[s.nextEventIndex].tick <= s.tick)
                    throw new InvalidDataException("Snapshot event offset is behind its clock.");
                previousSnapshotTick = s.tick;
            }
            if (r.snapshots[0].tick != 0 || r.snapshots[0].nextEventIndex != 0 ||
                r.events[r.events.Count - 1].kind != BattleEventKind.Finished)
                throw new InvalidDataException("Replay is incomplete.");
        }

        public static string Hash(byte[] bytes)
        {
            using (var sha = SHA256.Create()) return BitConverter.ToString(sha.ComputeHash(bytes)).Replace("-", "").ToLowerInvariant();
        }

        public static string CanonicalId(string id)
        {
            if (!Guid.TryParseExact(id, "N", out Guid parsed)) throw new ArgumentException("Invalid battle ID.");
            return parsed.ToString("N");
        }

        public static ReplaySummary Summary(BattleRecord r)
        {
            return new ReplaySummary { battleId = r.battleId, opponentId = r.opponentId, createdUtc = r.createdUtc, winner = r.winner, duration = r.DurationSeconds };
        }
    }

    public sealed class ReplayRepository
    {
        public string DirectoryPath { get; }
        public ReplayRepository(string path) { DirectoryPath = Path.GetFullPath(path); Directory.CreateDirectory(DirectoryPath); }
        string PathFor(string id) { return Path.Combine(DirectoryPath, ReplayArchive.CanonicalId(id) + ".arena.gz"); }
        public bool Contains(string id) { return File.Exists(PathFor(id)); }
        public byte[] Read(string id)
        {
            string path = PathFor(id);
            if (new FileInfo(path).Length > ReplayArchive.MaxCompressedBytes) throw new InvalidDataException("Replay file too large.");
            return File.ReadAllBytes(path);
        }
        public void Save(string id, byte[] bytes)
        {
            string path = PathFor(id);
            if (File.Exists(path)) throw new IOException("A committed replay is immutable.");
            string staging = path + ".tmp";
            try
            {
                using (var file = new FileStream(staging, FileMode.Create, FileAccess.Write, FileShare.None))
                { file.Write(bytes, 0, bytes.Length); file.Flush(true); }
                File.Move(staging, path);
            }
            finally { if (File.Exists(staging)) File.Delete(staging); }
        }
        public ReplaySummary[] Recent()
        {
            var result = new List<ReplaySummary>();
            foreach (var file in new DirectoryInfo(DirectoryPath).EnumerateFiles("*.arena.gz").OrderByDescending(f => f.LastWriteTimeUtc).Take(20))
            {
                try { result.Add(ReplayArchive.Summary(ReplayArchive.Decode(Read(file.Name.Substring(0, 32))))); }
                catch (Exception e) { Debug.LogWarning("[Arena] Skipping unreadable replay: " + e.Message); }
            }
            return result.ToArray();
        }
    }
}
