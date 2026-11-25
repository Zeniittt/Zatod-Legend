using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace Zatod.Heroes
{
    // Server-only document. Credentials never belong to CharacterData or an account snapshot.
    [Serializable] public sealed class PlayerDatabase
    {
        public int SchemaVersion;
        public long Revision;
        public List<PlayerRecord> Players;
    }
    [Serializable] public sealed class PlayerRecord
    {
        public string Username, Password;
        public CharacterData Player;
    }
    public static class PlayerIdentity
    {
        public static string Username(string value)
        {
            if (string.IsNullOrEmpty(value) || value.Length > 24 || value.Any(c =>
                !(c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z' || c >= '0' && c <= '9' || c == '_' || c == '-')))
                throw new ArgumentException("Username must be 1-24 letters, numbers, _ or -. Uppercase and lowercase are different.");
            return value;
        }
        public static string Password(string value)
        {
            if (string.IsNullOrEmpty(value) || value.Length > 128 || value.Any(char.IsControl))
                throw new ArgumentException("Enter a password of 1-128 characters without line breaks.");
            return value; // Prototype contract: preserve case and spaces exactly.
        }
    }
    // A single committed document owns every Player. Loaded accounts are detached working copies,
    // so another player's commit cannot accidentally include an uncommitted mutation.
    public sealed class PlayerDatabaseStore
    {
        public string FilePath { get; }
        public string BackupPath => FilePath + ".bak";
        public bool RecoveredBackup { get; private set; }
        public int Count => committed.Players.Count;
        readonly Func<PlayerDatabase,string> encode;
        readonly Func<string,PlayerDatabase> decode;
        readonly Action<CharacterData> validatePlayer;
        PlayerDatabase committed;

        public PlayerDatabaseStore(string path, Func<PlayerDatabase,string> encode,
            Func<string,PlayerDatabase> decode, Action<CharacterData> validatePlayer)
        {
            FilePath = Path.GetFullPath(path);
            this.encode = encode ?? throw new ArgumentNullException(nameof(encode));
            this.decode = decode ?? throw new ArgumentNullException(nameof(decode));
            this.validatePlayer = validatePlayer ?? throw new ArgumentNullException(nameof(validatePlayer));
            if (!File.Exists(FilePath) && !File.Exists(BackupPath))
            {
                committed = new PlayerDatabase { SchemaVersion = 1, Players = new List<PlayerRecord>() };
                return;
            }
            try { committed = Read(File.ReadAllText(FilePath)); }
            catch (NotSupportedException) { throw; }
            catch
            {
                try { committed = Read(File.ReadAllText(BackupPath)); }
                catch { throw new InvalidDataException("Player data could not be loaded. Keep datas.json and its backup for recovery."); }
                // Retain the corrupt file and the known-good backup; never replace the backup with corruption.
                if (File.Exists(FilePath)) File.Copy(FilePath, FilePath + ".corrupt-" + Guid.NewGuid().ToString("N"));
                WriteAtomic(FilePath, encode(committed), null);
                RecoveredBackup = true;
            }
        }
        PlayerDatabase Read(string json)
        {
            var data = decode(json);
            if (data != null && data.SchemaVersion > 1)
                throw new NotSupportedException("Player data belongs to a newer server version. Use a matching build.");
            if (data == null || data.SchemaVersion != 1 || data.Revision < 0 || data.Players == null)
                throw new InvalidDataException("Unsupported or incomplete player data.");
            var usernames = new HashSet<string>(StringComparer.Ordinal);
            var ids = new HashSet<string>(StringComparer.Ordinal);
            foreach (var row in data.Players)
            {
                if (row == null || row.Player == null || !usernames.Add(PlayerIdentity.Username(row.Username)) ||
                    !ids.Add(row.Player.CharacterId ?? "") || !Guid.TryParseExact(row.Player.CharacterId, "D", out _))
                    throw new InvalidDataException("Invalid or duplicate player identity.");
                PlayerIdentity.Password(row.Password);
                validatePlayer(row.Player);
            }
            return data;
        }
        PlayerDatabase Copy() => Read(encode(committed));
        public string UsernameFor(string accountId) => committed.Players.Single(p => p.Player.CharacterId == accountId).Username;
        public CharacterData Login(string username, string password)
        {
            PlayerIdentity.Username(username); PlayerIdentity.Password(password);
            var row = Copy().Players.SingleOrDefault(p => string.Equals(p.Username, username, StringComparison.Ordinal));
            if (row == null || !string.Equals(row.Password, password, StringComparison.Ordinal))
                throw new ArgumentException("Incorrect username or password.");
            return row.Player;
        }
        public CharacterData Register(string username, string password, Func<CharacterData> create)
        {
            PlayerIdentity.Username(username); PlayerIdentity.Password(password);
            if (committed.Players.Any(p => string.Equals(p.Username, username, StringComparison.Ordinal)))
                throw new ArgumentException("This username is already registered.");
            var player = create();
            player.CharacterId = Guid.NewGuid().ToString("D");
            player.Name = username;
            var next = Copy();
            next.Players.Add(new PlayerRecord { Username = username, Password = password, Player = player });
            Commit(next);
            return Login(username, password);
        }
        public void Save(CharacterData player)
        {
            var next = Copy();
            var row = next.Players.SingleOrDefault(p => p.Player.CharacterId == player.CharacterId)
                ?? throw new ArgumentException("Player is not registered.");
            if (player.Revision < row.Player.Revision) throw new ArgumentException("Player data is out of date.");
            row.Player = player;
            Commit(next);
        }
        void Commit(PlayerDatabase next)
        {
            next.Revision = checked(committed.Revision + 1);
            string json = encode(next);
            var frozen = Read(json);
            WriteAtomic(FilePath, json, BackupPath);
            committed = frozen; // Publish only after the disk replacement succeeds.
        }
        static void WriteAtomic(string path, string json, string backup)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            string temporary = path + "." + Guid.NewGuid().ToString("N") + ".tmp";
            try
            {
                var bytes = new UTF8Encoding(false).GetBytes(json);
                using (var stream = new FileStream(temporary, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                { stream.Write(bytes, 0, bytes.Length); stream.Flush(true); }
                if (File.Exists(path)) File.Replace(temporary, path, backup);
                else File.Move(temporary, path);
            }
            finally { if (File.Exists(temporary)) File.Delete(temporary); }
        }
    }
}
