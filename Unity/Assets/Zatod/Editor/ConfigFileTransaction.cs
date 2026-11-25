using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using Zatod.Heroes;

namespace Zatod.Editor
{
    internal sealed class ConfigFileTransaction
    {
        sealed class Change
        {
            public string Path, ExpectedText, NewText;
            public byte[] OriginalBytes, NewBytes;
        }

        readonly List<Change> changes = new List<Change>();

        public void Add(string path, string expectedText, string newText)
        {
            if (expectedText != newText)
                changes.Add(new Change { Path = path, ExpectedText = expectedText, NewText = newText });
        }

        public string SavedText(string path, string previousText)
            => changes.FirstOrDefault(change => change.Path == path)?.NewText ?? previousText;

        public void Commit(string backupLabel)
        {
            if (changes.Count == 0) return;

            foreach (var change in changes)
            {
                change.OriginalBytes = ReadBytes(change.Path);
                if (ReadText(change.OriginalBytes) != change.ExpectedText)
                    throw Changed(change.Path);
                change.NewBytes = Encoding.UTF8.GetBytes(change.NewText);
            }

            string backup = Path.GetFullPath("../Artifacts/ZatodConfigBefore/" + backupLabel + "-" +
                DateTime.UtcNow.ToString("yyyyMMdd-HHmmss-fff") + "-" + Guid.NewGuid().ToString("N"));
            foreach (var change in changes.Where(change => change.OriginalBytes != null))
            {
                string path = Path.Combine(backup, change.Path.Substring(HeroDataJson.ConfigAssetDirectory.Length + 1));
                Directory.CreateDirectory(Path.GetDirectoryName(path));
                File.WriteAllBytes(path, change.OriginalBytes);
            }

            var written = new List<Change>();
            AssetDatabase.StartAssetEditing();
            try
            {
                foreach (var change in changes)
                {
                    if (!Matches(change.Path, change.OriginalBytes)) throw Changed(change.Path);
                    HeroDataJson.WriteBytesAtomically(change.Path, change.NewBytes);
                    written.Add(change);
                }
            }
            catch (Exception error)
            {
                var errors = new List<Exception> { error };
                for (int i = written.Count - 1; i >= 0; i--)
                {
                    var change = written[i];
                    try
                    {
                        if (!Matches(change.Path, change.NewBytes)) throw Changed(change.Path);
                        if (change.OriginalBytes == null) File.Delete(change.Path);
                        else HeroDataJson.WriteBytesAtomically(change.Path, change.OriginalBytes);
                    }
                    catch (Exception rollbackError) { errors.Add(rollbackError); }
                }
                if (errors.Count > 1)
                    throw new AggregateException("Config rollback was incomplete. Restore from " + backup, errors);
                throw;
            }
            finally { AssetDatabase.StopAssetEditing(); }
        }

        public void ImportAssets()
        {
            foreach (var change in changes)
                AssetDatabase.ImportAsset(change.Path, ImportAssetOptions.ForceUpdate);
        }

        static IOException Changed(string path)
            => new IOException(path + " changed on disk. Draft preserved; reload before saving.");

        static byte[] ReadBytes(string path) => File.Exists(path) ? File.ReadAllBytes(path) : null;

        static string ReadText(byte[] bytes)
        {
            if (bytes == null) return null;
            using var reader = new StreamReader(new MemoryStream(bytes), Encoding.UTF8, detectEncodingFromByteOrderMarks: true);
            return reader.ReadToEnd();
        }

        static bool Matches(string path, byte[] expected)
        {
            var bytes = ReadBytes(path);
            return expected == null ? bytes == null : bytes != null && bytes.SequenceEqual(expected);
        }
    }
}
