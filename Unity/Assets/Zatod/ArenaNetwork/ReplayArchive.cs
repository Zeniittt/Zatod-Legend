using System;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;

namespace Zatod.Networking
{
    // Bounded payload transport shared by the current Zatod client and server.
    // The pre-Crystal outcome replay format and repository were retired in D33.
    public static class ReplayArchive
    {
        public const int MaxCompressedBytes = 4 * 1024 * 1024;
        public const int MaxJsonBytes = 16 * 1024 * 1024;

        internal static byte[] EncodePayload(object payload)
        {
            byte[] json = Encoding.UTF8.GetBytes(JsonUtility.ToJson(payload));
            if (json.Length > MaxJsonBytes) throw new InvalidDataException("Replay exceeds JSON limit.");
            using (var output = new MemoryStream())
            {
                using (var gzip = new GZipStream(output, System.IO.Compression.CompressionLevel.Optimal, true)) gzip.Write(json, 0, json.Length);
                byte[] bytes = output.ToArray();
                if (bytes.Length > MaxCompressedBytes) throw new InvalidDataException("Replay exceeds archive limit.");
                return bytes;
            }
        }

        internal static T DecodePayload<T>(byte[] bytes)
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
                return JsonUtility.FromJson<T>(Encoding.UTF8.GetString(output.ToArray()));
            }
        }

        public static string Hash(byte[] bytes)
        {
            using (var sha = SHA256.Create()) return BitConverter.ToString(sha.ComputeHash(bytes)).Replace("-", "").ToLowerInvariant();
        }
    }
}
