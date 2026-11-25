using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Zatod.Heroes
{
    public sealed class FreePvpRoster
    {
        public const int Level = 60;
        public const int Stars = 3;
        public const int SkillLevel = 60;
        public const string RankId = "purple";
        readonly HeroCatalog catalog;
        readonly HashSet<string> allowed;
        public IReadOnlyList<string> HeroIds { get; }
        public string CompatibilityKey { get; }

        internal FreePvpRoster(HeroCatalog catalog)
        {
            this.catalog = catalog;
            var ids = catalog.Data.Heroes.Where(hero => hero.AvailableInFreePvp).Select(hero => hero.Id).ToArray();
            allowed = new HashSet<string>(ids, StringComparer.Ordinal);
            HeroIds = Array.AsReadOnly(ids);
            foreach (string id in ids) CreatePreset(id);
            if (ids.Length > 0)
            {
                var input = new StringBuilder();
                Append(catalog.Data.ConfigVersion);
                foreach (string id in ids.OrderBy(id => id, StringComparer.Ordinal)) Append(id);
                using var hash = SHA256.Create();
                CompatibilityKey = Convert.ToBase64String(hash.ComputeHash(Encoding.UTF8.GetBytes(input.ToString())));

                void Append(string value) => input.Append(value.Length).Append(':').Append(value);
            }
        }

        public HeroData CreatePreset(string definitionId)
        {
            if (definitionId == null || !allowed.Contains(definitionId))
                throw new ArgumentException("Hero is outside the free PvP roster.");
            var definition = catalog.Hero(definitionId);
            var path = catalog.RankPath(definition, RankId);
            var hero = catalog.CreateHero(definitionId, definitionId);
            hero.RankId = RankId;
            hero.Level = Level;
            hero.Stars = Stars;
            foreach (var rank in path.Take(path.Count - 1))
            foreach (var slot in rank.EquipmentSlots)
            {
                var item = catalog.Item(slot.RequiredItemId);
                HeroCatalog.Require(item.LevelRequirement <= Level, "PvP preset equipment exceeds level 60: " + definitionId + " / " + item.DefinitionId);
                hero.AbsorbedItems.Add(new AbsorbedItemData
                {
                    RankId = rank.Id, SlotId = slot.Id, ItemId = item.DefinitionId, Quantity = 1
                });
            }
            var skills = HeroProgression.UnlockedSkills(hero, catalog);
            HeroCatalog.Require(skills.Count == 4, "Free PvP Hero needs four skills at Purple: " + definitionId);
            foreach (var progress in hero.Skills.Where(progress => skills.Any(slot => slot.Id == progress.SlotId)))
                progress.Level = SkillLevel;
            return hero;
        }

        public List<HeroData> Team(IEnumerable<string> selected)
        {
            var ids = selected?.Take(6).ToArray();
            if (ids == null || ids.Length < 1 || ids.Length > 5 || ids.Distinct(StringComparer.Ordinal).Count() != ids.Length)
                throw new ArgumentException("Choose 1–5 distinct Heroes from the free PvP roster.");
            return ids.Select(CreatePreset).ToList();
        }
    }
}
