using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodPlayerSession
    {
        public ItemOperationReceipt UpgradeSkill(string heroId, string slotId, int expectedLevel, int count,
            long expectedRevision, string operationId, Action persist = null)
            => HeroOperation("skill_up", heroId, slotId, expectedLevel, count, expectedRevision, operationId, persist);

        public ItemOperationReceipt QuickEquip(string heroId, long expectedRevision, string operationId, Action persist = null)
            => HeroOperation("quick_equip", heroId, null, 0, 0, expectedRevision, operationId, persist);

        public ItemOperationReceipt PromoteHero(string heroId, long expectedRevision, string operationId, Action persist = null)
            => HeroOperation("promote", heroId, null, 0, 0, expectedRevision, operationId, persist);

        ItemOperationReceipt HeroOperation(string command, string heroId, string slotId, int expectedLevel, int count,
            long expectedRevision, string operationId, Action persist)
        {
            if (!Guid.TryParseExact(operationId, "D", out var parsed) || parsed == Guid.Empty)
                throw new ArgumentException("Hero operation requires a GUID.");
            operationId = parsed.ToString("D");
            string Part(string value) => (value?.Length ?? -1).ToString(CultureInfo.InvariantCulture) + ":" + value;
            string key = Part(command) + Part(heroId) + Part(slotId) + Part(expectedLevel.ToString(CultureInfo.InvariantCulture))
                + Part(count.ToString(CultureInfo.InvariantCulture)) + Part(expectedRevision.ToString(CultureInfo.InvariantCulture));
            Account.ItemOperations = Account.ItemOperations ?? new List<ItemOperationReceipt>();
            var previous = Account.ItemOperations.SingleOrDefault(o => o.OperationId == operationId);
            if (previous != null)
            {
                if (previous.Command != command || previous.RequestKey != key)
                    throw new ArgumentException("Operation ID reused with a different request.");
                return previous;
            }
            if (issued.Count > 0) throw new ArgumentException("Finish or cancel the battle before changing a Hero.");
            if (expectedRevision != Account.Revision) throw new ArgumentException("Account changed. Review the updated Hero.");
            var inventory = new ItemInventory(Account, catalog);
            var hero = Account.HeroDesk.SingleOrDefault(h => h.HeroInstanceId == heroId)
                ?? throw new ArgumentException("Hero is not owned by this character.");
            var economyBefore = new EconomyCheckpoint(Account);
            var itemsBefore = Account.Inventory.ToList();
            var equipmentBefore = hero.EquippedItems.ToList();
            var absorbedBefore = hero.AbsorbedItems.ToList();
            var skillsBefore = hero.Skills.Select(s => new HeroSkillData { SlotId = s.SlotId, Level = s.Level }).ToList();
            string rankBefore = hero.RankId;
            long revisionBefore = Account.Revision;
            var receipt = new ItemOperationReceipt { OperationId = operationId, Command = command, RequestKey = key,
                HeroId = heroId, SlotId = slotId, PreviousRankId = rankBefore };
            try
            {
                if (command == "skill_up")
                {
                    var plan = SkillProgression.Plan(hero, catalog, slotId, expectedLevel, count);
                    if (CurrencyBalance.GetGold(Account) < plan.Gold) throw new ArgumentException("Not enough gold.");
                    CurrencyBalance.AddGold(Account, -plan.Gold);
                    hero.Skills.Single(s => s.SlotId == slotId).Level = plan.ToLevel;
                    receipt.GoldCharged = plan.Gold;
                    receipt.PreviousSkillLevel = plan.FromLevel;
                    receipt.SkillLevel = plan.ToLevel;
                }
                else if (command == "quick_equip")
                {
                    var plan = SkillProgression.QuickEquipPlan(Account, hero, catalog);
                    if (plan.Count == 0) throw new ArgumentException("No owned equipment can fill this Hero's empty slots.");
                    foreach (var item in plan) inventory.Equip(heroId, item.SlotId, item.Id);
                    receipt.Equipped = plan;
                }
                else if (command == "promote") inventory.Promote(heroId);
                else throw new ArgumentException("Unknown Hero operation.");
                receipt.RankId = hero.RankId;
                receipt.Revision = ++Account.Revision;
                Account.ItemOperations.Add(receipt);
                inventory.Validate();
                persist?.Invoke();
                return receipt;
            }
            catch
            {
                economyBefore.Restore();
                Account.Inventory = itemsBefore;
                hero.EquippedItems = equipmentBefore;
                hero.AbsorbedItems = absorbedBefore;
                hero.Skills = skillsBefore;
                hero.RankId = rankBefore;
                Account.Revision = revisionBefore;
                Account.ItemOperations.Remove(receipt);
                throw;
            }
        }
    }
}
