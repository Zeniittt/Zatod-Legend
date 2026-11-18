using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    [Serializable]
    public sealed class HeroFormationData
    {
        public List<string> HeroInstanceIds = new List<string>();
    }

    public sealed class HeroFormation
    {
        public const int Capacity = 5;
        public CharacterData Character { get; private set; }
        public HeroCatalog Catalog { get; private set; }
        readonly Dictionary<string, HeroData> owned;

        public HeroFormation(CharacterData character, HeroCatalog catalog)
        {
            catalog.Bind(character);
            Character = character; Catalog = catalog;
            owned = character.HeroDesk.ToDictionary(h => h.HeroInstanceId, StringComparer.Ordinal);
            if (character.Formation == null) character.Formation = new HeroFormationData();
            var ids = character.Formation.HeroInstanceIds;
            HeroCatalog.Require(ids != null && ids.Count <= Capacity && ids.Distinct(StringComparer.Ordinal).Count() == ids.Count
                && ids.All(id => id != null && owned.ContainsKey(id)), "Invalid owned formation.");
            Sort();
        }

        public IReadOnlyList<HeroData> Selected { get { return Character.Formation.HeroInstanceIds.Select(id => owned[id]).ToList(); } }
        public bool CanBattle { get { return Character.Formation.HeroInstanceIds.Count > 0; } }
        public bool Contains(string id) { return Character.Formation.HeroInstanceIds.Contains(id); }

        public bool Toggle(string instanceId)
        {
            HeroCatalog.Require(instanceId != null && owned.ContainsKey(instanceId), "Cannot select a hero outside HeroDesk.");
            var ids = Character.Formation.HeroInstanceIds;
            if (ids.Remove(instanceId)) return true;
            if (ids.Count == Capacity) return false;
            ids.Add(instanceId); Sort(); return true;
        }

        public IEnumerable<HeroData> Filter(HeroPosition? position)
        {
            return Character.HeroDesk.Where(h => !position.HasValue || Catalog.Hero(h.HeroDefinitionId).Position == position.Value);
        }

        void Sort()
        {
            // Stable front-to-back placement; ties preserve the order of the owned roster.
            Character.Formation.HeroInstanceIds = Character.Formation.HeroInstanceIds
                .OrderBy(id => Catalog.Hero(owned[id].HeroDefinitionId).Position)
                .ThenBy(id => Character.HeroDesk.IndexOf(owned[id])).ToList();
        }
    }
}
