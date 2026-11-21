"""Import stage drop preview metadata for the existing Zatod item catalog.

Imported selection chances total 100 percent per stage (D26), not recovered Crystal rates.
Explicit re-import resets the imported drop lists/rates; GameEditor edits persist otherwise.
Does not run Lua or change ownership, battle logic, or reward delivery.
"""
from pathlib import Path
import json
import sys

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / 'Unity/Assets/Zatod/Resources/Data'
sys.path.insert(0, str(ROOT / 'Crystal Legend/recovery_tools'))
from lua_data import read_table, named_row


def read(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def main():
    campaign_path = DATA / 'Campaigns.txt'
    campaign = read(campaign_path)
    aliases = read(ROOT / 'Artifacts/CrystalPhaseChecks/zatod-id-mapping.json')['Aliases']
    item_ids = {item['ItemId'] for item in read(DATA / 'Items.txt')['Items']}
    source = read_table('Stage')
    columns = sorted((key for key in source[2] if key.startswith('UI reward')),
                     key=lambda key: int(key.removeprefix('UI reward')))
    imported, skipped = [], []
    changed = False
    for chapter in campaign['Chapters']:
        for stage in chapter['Stages']:
            source_id = stage.get('SourceStageId', 0)
            if not source_id:
                continue
            row = named_row(source, source[1][source_id])
            drops, seen = [], set()
            for column in columns:
                source_item = row.get(column, 0)
                if not source_item:
                    continue
                item_id = aliases.get('crystal_item_' + str(source_item))
                if item_id not in item_ids:
                    skipped.append({'StageId': stage['Id'], 'SourceItemId': source_item,
                                    'Reason': 'Outside the imported Zatod item catalog'})
                    continue
                if item_id in seen:
                    continue
                seen.add(item_id)
                drops.append({'ItemId': item_id, 'DropChancePercent': 0})
            if drops:
                share = 10000 // len(drops)
                for i, drop in enumerate(drops):
                    drop['DropChancePercent'] = (share if i < len(drops)-1 else 10000-share*(len(drops)-1)) / 100
            if 'MaxDropAmount' not in stage:
                stage['MaxDropAmount'] = 5
                changed = True
            if stage.get('DropItems') != drops:
                stage['DropItems'] = drops
                changed = True
            imported.append({'StageId': stage['Id'], 'SourceStageId': source_id, 'DropItems': drops})
    if changed:
        campaign['ConfigVersion'] = 'zatod-campaign-loot-1'
        campaign_path.write_text(json.dumps(campaign, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    report = {'Date': '2026-11-21', 'ConfigOnly': True, 'ChanceUnit': 'percent-per-draw',
              'TotalChancePercent': 100, 'StageCount': len(imported),
              'DropEntryCount': sum(len(stage['DropItems']) for stage in imported),
              'UniqueItemCount': len({item['ItemId'] for stage in imported for item in stage['DropItems']}),
              'Stages': imported, 'Skipped': skipped}
    report_path = ROOT / 'Artifacts/CrystalPhaseChecks/zatod-stage-drops-import.json'
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({key: report[key] for key in ['StageCount', 'DropEntryCount', 'UniqueItemCount']}))


if __name__ == '__main__':
    main()
