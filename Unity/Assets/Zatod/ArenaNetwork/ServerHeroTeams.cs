using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

namespace Zatod.Networking
{
    public static class ServerHeroTeams
    {
        // One trusted development account shared with the roster preview until account loading exists.
        // The request contains owned instance IDs only; clients never send stats, skills, or ranks.
        public static List<FighterState> Create(string opponent, string[] selected, HeroCatalog catalog, out List<FighterLoadout> loadouts)
        {
            loadouts = new List<FighterLoadout>();
            if (selected == null || selected.Length == 0) return PrototypeTeams.Create(opponent);
            if (selected.Length > HeroFormation.Capacity || selected.Distinct(StringComparer.Ordinal).Count() != selected.Length)
                throw new ArgumentException("Invalid squad selection.");
            var account = FormationView.CreateDemoCharacter(catalog);
            account.Formation.HeroInstanceIds = selected.ToList();
            var formation = new HeroFormation(account, catalog); // Validates ownership and sorts front to rear.
            var fighters = PrototypeTeams.Create(opponent).Where(f => f.team == 1).ToList();
            int slot = 0;
            foreach (var hero in formation.Selected)
            {
                var data = HeroBattleFactory.Create(hero, catalog);
                var definition = catalog.Hero(hero.HeroDefinitionId);
                var fighter = CreateFighter(definition, data, 0, slot);
                fighters.Add(fighter); loadouts.Add(new FighterLoadout { fighterId = fighter.id, hero = data }); slot++;
            }
            return fighters;
        }

        public static FighterState CreateFighter(HeroDefinition definition, HeroBattleData data, int team, int slot)
        {
            return HeroCombatantFactory.Create(definition, data, team, slot);
        }
    }
}
