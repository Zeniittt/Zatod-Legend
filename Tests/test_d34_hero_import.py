"""Source-backed importer checks; outputs remain outside Unity and Owned."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('d34_import', ROOT / 'scripts/Import-ZatodD34Heroes.py')
importer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(importer)


class HeroImport(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix='zatod-d34-import-')
        cls.output = Path(cls.temp.name) / 'Data'
        cls.before = {p.relative_to(importer.DATA): p.read_bytes() for p in importer.DATA.rglob('*') if p.is_file()}
        cls.manifest = importer.build(importer.DATA.resolve(), cls.output)

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def test_active_data_untouched(self):
        self.assertEqual(self.before, {p.relative_to(importer.DATA): p.read_bytes() for p in importer.DATA.rglob('*') if p.is_file()})
        with self.assertRaises(ValueError):
            importer.build(importer.DATA.resolve(), importer.DATA.resolve())

    def test_retains_all_prior_rows_and_evolution(self):
        for name in ('Skills', 'Items', 'Buffs', 'Monsters', 'CraftRecipes'):
            before = importer.read(importer.DATA / (name + '.txt'))[name]
            after = importer.read(self.output / (name + '.txt'))[name]
            self.assertEqual(before, after[:len(before)], name)
        for old in importer.read(importer.DATA / 'Heroes.txt')['Heroes']:
            hero = next(h for h in importer.read(self.output / 'Heroes.txt')['Heroes'] if h['Id'] == old['Id'])
            for key, value in old.items():
                if key in ('Ranks', 'RankStats', 'SkillSlots'):
                    prefix = hero[key][:len(value)]
                    for left, right in zip(value, prefix):
                        expected = dict(left)
                        if key == 'Ranks' and left['Id'] == 'blue':
                            expected['NextRankId'] = 'blue_plus_1'
                        self.assertEqual(expected, right, (hero['Id'], key))
                else:
                    self.assertEqual(value, hero[key], (hero['Id'], key))

    def test_approved_roster_and_rank_paths(self):
        heroes = importer.read(self.output / 'Heroes.txt')['Heroes']
        self.assertEqual(40, len(heroes))
        self.assertEqual(set(importer.NEW_HEROES), {h['SourceUnitId'] for h in heroes if h['Id'] in self.manifest['AddedHeroes']})
        for hero in heroes:
            self.assertEqual(list(importer.RANKS), [r['Id'] for r in hero['Ranks']])
            self.assertEqual(['skill_1', 'skill_2', 'skill_3', 'skill_4'], [s['Id'] for s in hero['SkillSlots']])
            self.assertEqual(['skill_4'], hero['Ranks'][-1]['UnlockSkillSlotIds'])
            self.assertFalse(hero.get('AvailableInFreePvp', False))
        campaign = importer.read(self.output / 'Campaigns.txt')
        original = importer.read(importer.DATA / 'Campaigns.txt')
        campaign.pop('ConfigVersion'); original.pop('ConfigVersion')
        self.assertEqual(original, campaign)

    def test_draft_does_not_claim_native_parity(self):
        self.assertFalse(self.manifest['RuntimeActivationReady'])
        self.assertEqual(85, self.manifest['PendingNativeSkills'])
        self.assertEqual(255, self.manifest['PendingSourceEvolutions'])
        self.assertEqual(160, len(self.manifest['Coverage']))
        self.assertEqual(75, sum(c['RuntimeEvoImported'] for c in self.manifest['Coverage']))
        self.assertTrue(all(len(c['SourceEvolutions']) == 3 for c in self.manifest['Coverage']))

    def test_repeatable_without_artifacts_inputs(self):
        # Identical input to a fresh directory must produce identical bytes and aliases.
        other = Path(self.temp.name) / 'Second'
        manifest = importer.build(importer.DATA.resolve(), other)
        self.assertEqual(self.manifest, manifest)
        for path in self.output.rglob('*.txt'):
            self.assertEqual(path.read_bytes(), (other / path.relative_to(self.output)).read_bytes())
        with self.assertRaises(ValueError):
            importer.build(importer.DATA.resolve(), other)

    def test_native_assets_and_no_primary_attributes(self):
        for row in self.manifest['Assets'] + self.manifest['AudioAssets']:
            path = ROOT / row['Source']
            self.assertTrue(path.is_file(), str(path))
            self.assertEqual(row['Sha256'], importer.hashlib.sha256(path.read_bytes()).hexdigest())
        for item in importer.read(self.output / 'Items.txt')['Items']:
            self.assertNotIn('HeroStats', item)
            self.assertTrue(all(s['StatId'] not in ('str', 'agi', 'int', 'strength', 'agility', 'intelligence') for s in item['PreciseStats']))


if __name__ == '__main__':
    unittest.main()
