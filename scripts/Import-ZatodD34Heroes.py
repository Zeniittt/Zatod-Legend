"""Build a repeatable D34 Hero draft from tracked Lua and the current Zatod catalog.

Never runs Lua, old importers, or reads Artifacts as input. Output is a complete Data
folder for --d34-content-preflight; runtime activation is a separate milestone.
Unported native hooks/Evo are explicitly listed, never guessed from Script Arg1.
"""
from pathlib import Path
import argparse
import ast
import copy
import hashlib
import json
import re
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
REF = ROOT / 'Unity/Assets/Crystal Legend'
DATA = ROOT / 'Tests/Fixtures/D34Baseline'
ART = REF / 'recovered/assets/install_time_pack/remake'
NEW_HEROES = (5, 11, 12, 13, 14, 15, 21, 23, 26, 31, 32, 33, 34, 35, 39)
# Normal form/dependent skills from encounter hooks. Slots 101+ also contain
# shard, fashion and warschool skills; never import them indiscriminately.
ENCOUNTER_DEPENDENCIES = {446,465,515,611,656,657,658,659,686,687,736,737,
    816,817,818,819,1116,1117,1146,1147,1148,1149,1226,1227,1228,12210,
    1286,1288,1289,12810,1437,1438,1439,14310,1496,1767,11105,11106,26604,26605}
RANKS = ('white', 'green', 'green_plus_1', 'blue', 'blue_plus_1', 'blue_plus_2', 'purple')
RANK_NAMES = ('Trắng', 'Xanh Lá', 'Xanh Lá+1', 'Xanh Dương', 'Xanh Dương+1', 'Xanh Dương+2', 'Tím')
sys.path.insert(0, str(REF / 'recovery_tools'))
from lua_data import read_table, named_row, Reader, BASE


def read(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))

def puppet_art(puppet):
    """Name a derived component variant without changing the recovered source."""
    resource=puppet['Resource'];pairs=list(puppet.get('Change Components',{}).values())
    if not pairs:return dict(Resource=resource)
    if len(pairs)%2:raise ValueError('Unpaired puppet component replacement: '+puppet['ID'])
    return dict(Resource=resource+'__'+Path(puppet['ID']).stem,SourceArtResource=resource,
        ComponentReplacements=[dict(From=pairs[i],To=pairs[i+1]) for i in range(0,len(pairs),2)])


def battle_forms(skills):
    for skill in skills:
        info=skill.get('Crystal') or {}
        if info.get('NativeForm'):yield info['NativeForm']
        yield from (info.get('Summon') or {}).get('Forms',[])


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(value, ensure_ascii=False, indent=2) + '\n'
    if not path.exists() or path.read_text(encoding='utf-8') != text:
        path.write_text(text, encoding='utf-8')


def slug(value):
    return re.sub('[^a-z0-9]+', '_', re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', value).lower()).strip('_')


class Source:
    def __init__(self):
        self.tables = {}
        # Reuse stat/formula definitions only, not the legacy importer's writes.
        scope = {}
        tree = ast.parse((ROOT / 'scripts/Import-CrystalConfig.py').read_text(encoding='utf-8-sig'))
        for node in tree.body:
            assignment = isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id in ('MAP', 'SOURCE_STATS', 'FIELDS') for t in node.targets)
            function = isinstance(node, ast.FunctionDef) and node.name in ('direct', 'plus')
            if assignment or function:
                exec(compile(ast.Module(body=[node], type_ignores=[]), '<audited-conversion>', 'exec'), scope)
        for key in scope['SOURCE_STATS']:
            scope['MAP'].setdefault(key, key.lower())
        self.direct, self.plus = scope['direct'], scope['plus']
        self.stat_map, self.source_stats, self.skill_fields = scope['MAP'], scope['SOURCE_STATS'], scope['FIELDS']
        text = (BASE / 'texttable/texttable.lua').read_text(encoding='utf-8-sig')
        text = re.sub(r'\[(=*)\[(.*?)\]\1\]', lambda m: json.dumps(m.group(2), ensure_ascii=False), text, flags=re.S)
        self.translations = Reader(text.replace('ed.textConfig =', 'return ', 1)).parse()

    def table(self, name):
        if name not in self.tables:
            self.tables[name] = read_table(name)
        return self.tables[name]

    def row(self, name, *keys):
        raw = self.table(name)[1]
        for key in keys:
            raw = raw[key]
        return named_row(self.table(name), raw)

    def english(self, key, fallback=''):
        return self.translations.get(key, {}).get('nil', {}).get('en') or fallback

    def phases(self, unit, skill):
        if skill['Skill Group ID']==26602:
            # Source-only placeholder: CD/Init CD 999, never invoked by the
            # normal hooks, and DruidBear has no atk2 action in CHA or duration.
            assert skill['CD']==skill['Init CD']==999 and list(skill['Action(s)'].values())==['atk2']
            return []
        resource = self.row('Puppet', unit['Puppet'])['Resource'] + '.cha'
        phases = []
        for action in (skill['Action(s)'] or {}).values():
            duration = self.row('AnimDuration', resource, action)['Duration']
            events = [named_row(self.table('AnimAtkFrame'), raw) for raw in self.table('AnimAtkFrame')[1].get(resource, {}).get(action, {}).values()]
            events.sort(key=lambda value: value['Time'])
            phases.append(dict(Action=action, Duration=duration, AttackTimes=[e['Time'] for e in events],
                               AttackOrigins=[dict(Time=e['Time'], X=e['X'], Y=e['Y']) for e in events]))
        return phases


def amounts(values):
    return [dict(StatId=k, Value=round(v, 9)) for k, v in sorted(values.items()) if abs(v) > 1e-9]

def complete_stats(docs):
    used=set()
    def walk(value):
        if isinstance(value,dict):
            if value.get('StatId'):used.add(value['StatId'])
            for child in value.values():walk(child)
        elif isinstance(value,list):
            for child in value:walk(child)
    walk(docs)
    existing={s['Id'] for s in docs['Stats']['Stats']}
    for ident in sorted(used-existing):
        if ident in ('str','agi','int'):raise ValueError('Primary attributes remain outside runtime.')
        docs['Stats']['Stats'].append(dict(Id=ident,Name=ident.replace('_',' ').title(),Minimum=0))

def direct_passive_descriptions(docs):
    names={s['Id']:s['Name'] for s in docs['Stats']['Stats']}
    for skill in docs['Skills']['Skills']:
        ratios=skill.get('Crystal',{}).get('PassiveStatRatios',[])
        if not ratios:continue
        for evo in skill.get('Evolutions',[]):
            changes=[p for p in evo['ParameterChanges'] if p['Field']=='BasicAmount']
            if not changes:continue
            amount=sum(p['Value'] for p in changes)
            evo['Description']='Increases '+', '.join(f"{names.get(r['StatId'],r['StatId'].replace('_',' '))} by {amount*r['Value']:g}" for r in ratios)+'.'

def buff_presentation(docs,source):
    shaders={None:0,'FrozenShader':1,'PoisonShader':2,'BanishShader':3,'StoneShader':4,'IceShader':5,'BKBShader':6,'InvisibleShader':7,'FireShader':8,'NanaShader':9,'MirrorShader':10}
    for buff in docs['Buffs']['Buffs']:
        row=source.row('Buff',buff['SourceId'])
        if row.get('Shader') not in shaders:raise ValueError('Unmapped native shader: '+str(row.get('Shader')))
        buff['Shader']=shaders[row.get('Shader')]
        buff['LevelCheckDice']=row['Level Check Dice'];buff['ResistAttribute']=source.stat_map.get(row['Resist Attribute'],row['Resist Attribute'])
        # These are attachments to the actor, not BattleScene.addEffect z layers.
        buff['EffectLayer']=1 if row.get('Effect Zorder',0)<0 else 2
        scale=list((row.get('Actor Scale') or {}).values())
        if scale and len(scale)!=2:raise ValueError('Unsupported actor scale: '+str(buff['SourceId']))
        buff['ActorScaleX'],buff['ActorScaleY']=scale if scale else (1,1)


def build(baseline, output, include_encounters=False, source=None):
    if baseline == output or output.is_relative_to(ROOT / 'Unity'):
        raise ValueError('Use a separate draft folder outside Unity; activation requires native-hook verification.')
    if (output.parent / (output.name + '-manifest.json')).exists():
        raise ValueError('Draft manifest already exists; choose a fresh output name.')
    if output.exists() and any(output.iterdir()):
        raise ValueError('Output must be new or empty; never overwrite an earlier draft.')
    source = source or Source()
    names = ('Heroes', 'Monsters', 'Items', 'Skills', 'Buffs', 'Stats', 'CraftRecipes')
    docs = {name: read(baseline / (name + '.txt')) for name in names}
    aliases = dict(re.findall(r'\{"([^"\n]+)","([^"\n]+)"\}', (ROOT / 'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs').read_text()))
    original_aliases = dict(aliases)
    units = {h['SourceUnitId']: h for h in docs['Heroes']['Heroes']}
    # Older aliases predate inventory tabs. Reuse the persistent item IDs rather
    # than creating a second soulstone/EXP definition for a source reward.
    for hid, hero in units.items():
        aliases['crystal_item_' + str(source.row('fragment', hid)['Fragment ID'])] = hero['SoulstoneItemId']
    for number, ident in ((169,'exp_potion'),(218,'exp_salve'),(290,'exp_cheese'),(440,'exp_burger'),(1609,'exp_pizza')):
        aliases['crystal_item_' + str(number)] = ident
    skills = {s['Crystal']['SourceId']: s for s in docs['Skills']['Skills'] if s.get('Crystal')}
    items = {i['ItemId']: i for i in docs['Items']['Items']}
    buffs = {b['SourceId']: b for b in docs['Buffs']['Buffs']}
    assets, audio_assets, missing_audio, coverage, needed_items, needed_buffs = {}, {}, set(), [], set(), set()
    encounter_ids=set()
    if include_encounters:
        needed_buffs.update({10004602,10004303,10004305,10004307,10004308,10004406,10005104,10005503,10005505,10009501,10009503,10009504,10006103,10006104})
        needed_buffs.update({10005202,10005203,10005205,10005206,10005207,10005208,10005209,10006509})
        needed_buffs.update({10006504,10006508})
        needed_buffs.update({10008101,10008102,10008108})
        needed_buffs.update({10004702,10004703,10004704,10004705,10004706,10004707,10004708})
        needed_buffs.add(10007307)
        needed_buffs.update({10006801,10006809})
        needed_buffs.update({11001107,11001108,11001109,11001111})
        needed_buffs.update({11001405,11001409,11001410})
        needed_buffs.update({11002202,11002203,11002204,11002205})
        needed_buffs.update({11011005,11011009})
        needed_buffs.update({11002801,11002802,11002803,11002804,11002805,11002811,11002812,11002813,11002815})
        needed_buffs.update({11004301,11004305,11004309,11004310})
        needed_buffs.update({11007601,11007603,11007608,11007610,11007613,11007615,11007616,11007617})
        needed_buffs.update({11004901,11004904,11004906,11004907,11004908})
        encounter_ids.update((128,129,130,214,215,249,250,266)) # Normal summon dependencies, never shard-only NagaMirror.
        for raw in source.table('Stage')[1].values():
            stage=named_row(source.table('Stage'),raw)
            if stage['Difficulty']==1 and 1<=stage['Chapter ID']<=8:
                for raw in source.table('Battle')[1][stage['Stage ID']].values():
                    wave=named_row(source.table('Battle'),raw)
                    encounter_ids.update(wave['Monster '+str(n)+' ID'] for n in range(1,6) if wave['Monster '+str(n)+' ID'])
    expected_heroes = set(units) | set(NEW_HEROES) | {i for i in encounter_ids if source.row('Unit',i)['Unit Type']=='Hero'}
    added_hero_ids=sorted(expected_heroes-set(units))
    added_monster_ids=sorted(encounter_ids-expected_heroes-{m['SourceUnitId'] for m in docs['Monsters']['Monsters']})
    if not include_encounters and len(expected_heroes) != 40:
        raise ValueError(f'Expected the approved 25+15 roster, found {len(expected_heroes)} source IDs.')

    def alias(key, preferred, used):
        if key in aliases:
            return aliases[key]
        if not preferred or preferred in used:
            raise ValueError(f'Ambiguous new ID {key}: {preferred}')
        aliases[key] = preferred
        return preferred

    def item_id(number):
        key = 'crystal_item_' + str(number)
        row = source.row('equip', number)
        english = source.english(row['Name'])
        if not english:
            raise ValueError(f'Missing official English item name: {number}')
        return alias(key, slug(english), set(items) | set(aliases.values()))

    def add_asset(relative, target):
        path = ART / relative
        if not path.is_file():
            path = path.with_suffix('.jpg')
        if not path.is_file():
            raise FileNotFoundError(path)
        target = target + path.suffix
        value = dict(Source=path.relative_to(ROOT).as_posix(), Target=target,
                     Sha256=hashlib.sha256(path.read_bytes()).hexdigest())
        if target in assets and assets[target] != value:
            raise ValueError('Conflicting asset target: ' + target)
        assets[target] = value
        return path.relative_to(ART).as_posix()

    def add_skill(unit, group):
        number = group['Skill Group ID']
        if number in skills:
            return skills[number]
        info = source.row('Skill', number, 0)
        name = source.english(group['Display Name']) or source.english(info['Skill Name'])
        if not name:
            name = info['Skill Name'].replace('_', ' ').lstrip('&')
        owner = aliases['crystal_' + str(unit['ID'])]
        preferred = owner + '_' + slug(name)
        if preferred in {s['Id'] for s in skills.values()}:
            preferred += '_' + str(number)
        ident = alias('crystal_skill_' + str(number), preferred, {s['Id'] for s in skills.values()})
        meta = {out: info[src] for out, src in source.skill_fields.items() if info.get(src) is not None}
        meta.update(SourceId=number, Slot=group['Slot'], UnlockRank=group['Unlock'], Priority=group['Priority'],
                    Interruptable=group['Interruptable'], Growth=[dict(Field=group[f'Growth {n} Field'], Amount=group[f'Growth {n} Value']) for n in range(1, 6) if group[f'Growth {n} Field']],
                    ScriptArgs=[info[f'Script Arg{n}'] for n in range(1, 7)], Phases=source.phases(unit, info))
        if meta.get('BuffId'):
            needed_buffs.add(meta['BuffId'])
        active = info['Active Type'] == 'active'
        skill = dict(Id=ident, Name=name, Kind=0 if active else 1, Activation=1 if info['Manual'] else (0 if active else 2), Target=1,
                     EnergyCost=int(info['Cost MP']), CooldownMilliseconds=round(info['CD'] * 1000), CastRange=round(info['Max Range'] * 10),
                     AnimationState=meta['Phases'][0]['Action'] if meta['Phases'] else 'Idle', Effects=[], Crystal=meta,
                     Description=source.english(info.get('Full Description')) or source.english(info.get('Description')) or name,
                     Evolutions=[])
        if group.get('Icon') and group['Slot'] in (1,2,3,4):
            skill['IconResource'] = add_asset(group['Icon'], 'Zatod/UI/Hero/Skills/Icons/' + ident)
        skills[number] = skill
        docs['Skills']['Skills'].append(skill)
        return skill

    for hid in sorted(expected_heroes):
        raw = source.row('Unit', hid)
        puppet = source.row('Puppet', raw['Puppet'])
        ident = alias('crystal_' + str(hid), slug(raw['Name']), {u['Id'] for u in units.values()})
        groups = [named_row(source.table('SkillGroup'), r) for r in source.table('SkillGroup')[1][hid].values()]
        allowed = [g for g in groups if g['Slot'] in (1, 2, 3, 4, 5) and g['Unlock'] <= 7 and not g['Awake'] and not g['Super Awake']]
        main = sorted([g for g in allowed if g['Slot'] in (1, 2, 3, 4)], key=lambda g: g['Slot'])
        if len(main) != 4 or [g['Slot'] for g in main] != [1, 2, 3, 4]:
            raise ValueError('Ambiguous four-skill roster: ' + ident)
        if not (REF / 'recovered/heroes' / puppet['Resource'] / 'animation.json').is_file():
            raise FileNotFoundError('Missing recovered animation: ' + puppet['Resource'])
        for group in allowed:
            add_skill(raw, group)
        if include_encounters:
            for group in groups:
                if group['Skill Group ID'] in ENCOUNTER_DEPENDENCIES:add_skill(raw,group)
        basic = skills[raw['Basic Skill']]
        if hid not in units:
            precise = source.direct(raw, raw['Main Attrib'])
            core = dict(health=max(1, round(precise.get('health', 1))), damage=max(1, round(precise.get('damage', 1))),
                        defense=max(0, round(precise.get('defense', 0))), attack_range=max(1, round(basic['Crystal']['MaxRange'] * 10)),
                        move_speed=round(raw['Walk Speed'] * 10), attack_interval=max(1, round(basic['Crystal']['Cooldown'] * 20)),
                        damage_energy_rate=raw['MP Gain Rate'], interrupt_health_ratio=raw['Interrupt HP Ratio'] or 8)
            movement = {k: v for k, v in core.items() if k not in ('health', 'damage', 'defense')}
            hero = dict(Id=ident, Name=raw['Name'], SourceUnitId=hid, Position={'前排': 0, '中排': 1, '后排': 2}[raw['Position Type']],
                        PortraitKey=ident, BodyPrefabResource='Zatod/' + puppet['Resource'] + '/' + puppet['Resource'],
                        AnimationSetResource='Zatod/' + puppet['Resource'] + '/AnimationSet', SourcePuppet=raw['Puppet'], SourceResource=puppet['Resource'],
                        ArtScale=puppet['Scale'], CollideRadius=raw['Collide Radius'], ProjectileHurtboxHeight=100, DeathAnimationMilliseconds=1500,
                        NormalAttackSkillId=basic['Id'], BaseStats=[dict(StatId=k, Value=v) for k, v in core.items()],
                        PreciseBaseStats=amounts(source.plus(precise, movement)), Growth=[], RankStats=[], StartingRankId='white', Ranks=[], SkillSlots=[],
                        InitialStars=raw['Initial Stars'], SoulstoneItemId='soulstone_' + ident)
            for star in range(1, 6):
                hero['Growth'].append(dict(Stars=star, PerLevel=amounts(source.direct({a: raw.get('+' + a + str(star), 0) for a in ('STR', 'AGI', 'INT')}, raw['Main Attrib']))))
            units[hid] = hero
            docs['Heroes']['Heroes'].append(hero)
        hero = units[hid]
        slots = {s['Id']: s for s in hero['SkillSlots']}
        for g in main:
            slot = 'skill_' + str(g['Slot'])
            if slot not in slots:
                hero['SkillSlots'].append(dict(Id=slot, SkillId=skills[g['Skill Group ID']]['Id'], IsUltimate=g['Slot'] == 1, InitialLevel=g['Init Level']))
            elif slots[slot]['SkillId'] != skills[g['Skill Group ID']]['Id']:
                raise ValueError('Refusing to replace persisted slot: ' + ident + '/' + slot)
            skill = skills[g['Skill Group ID']]
            evos = [named_row(source.table('SkillEvo'), r) for r in source.table('SkillEvo')[1].get(g['Skill Group ID'], {}).values()]
            coverage.append(dict(HeroId=ident, SourceUnitId=hid, SkillId=skill['Id'], SourceSkillId=g['Skill Group ID'], Slot=slot,
                                 NativeHook='data/battle/heroes/' + g['Caster Name'] + '.lua',
                                 RuntimeEvoImported=bool(skill.get('Evolutions')), SourceEvolutions=evos,
                                 Status='Existing D35 mapping; preserve' if skill.get('Evolutions') else 'Native hook and Evo port pending'))
        # Derive only newly appended ranks. Prior rows, slot IDs and bonuses stay byte-for-byte values.
        prior, absorbed = {}, {}
        for rank, rank_id in enumerate(RANKS, 1):
            stats = source.row('UnitRank', hid, rank)
            gear = source.row('hero_equip', hid, rank)
            residual = source.plus(source.direct(stats, raw['Main Attrib']), absorbed, -1)
            increment = source.plus(residual, prior, -1)
            prior = residual
            if not any(r['Id'] == rank_id for r in hero['Ranks']):
                hero['Ranks'].append(dict(Id=rank_id, Name=RANK_NAMES[rank - 1], NextRankId=RANKS[rank] if rank < 7 else '', BonusStats=[],
                                         PreciseBonusStats=amounts(increment), EquipmentSlots=[dict(Id='gear_' + str(n), RequiredItemId=item_id(gear[f'Equip{n} ID'])) for n in range(1, 7)],
                                         UnlockSkillSlotIds=['skill_' + str(g['Slot']) for g in main if g['Unlock'] == rank]))
            if rank < 7:
                next(r for r in hero['Ranks'] if r['Id'] == rank_id)['NextRankId'] = RANKS[rank]
            if not any(r['Rank'] == rank for r in hero['RankStats']):
                estimate = {k: stats.get('E.' + k, stats.get(k, 0)) for k in ['STR', 'AGI', 'INT'] + source.source_stats}
                hero['RankStats'].append(dict(Rank=rank, Stats=amounts(source.direct(stats, raw['Main Attrib'])), EstimatedStats=amounts(source.direct(estimate, raw['Main Attrib']))))
            for n in range(1, 7):
                number = gear[f'Equip{n} ID']
                needed_items.add(number)
                absorbed = source.plus(absorbed, source.direct(source.row('equip', number), raw['Main Attrib']))
        if hid in added_hero_ids:
            add_asset('UI/DOTA-HERO/' + raw['Portrait'][1:], 'Zatod/UI/Formation/Portraits/' + ident)
            illustration = raw['Art'].removeprefix('c')
            add_asset('UI/art/' + illustration, 'Zatod/UI/Hero/Illustrations/' + ident)
            animation = read(REF / 'recovered/heroes' / puppet['Resource'] / 'animation.json')
            for action in animation['actions']:
                for frame in action['frames']:
                    for event in frame['events']:
                        name = event.get('argument', '')
                        if event['type'] != 1 or not name:
                            continue
                        path = ART / 'sound' / name
                        if not path.is_file():
                            missing_audio.add(name)
                            continue
                        target = 'Zatod/Audio/' + Path(name).name
                        asset = dict(Source=path.relative_to(ROOT).as_posix(), Target=target, Sha256=hashlib.sha256(path.read_bytes()).hexdigest())
                        if target in audio_assets and audio_assets[target] != asset:
                            raise ValueError('Conflicting audio basename: ' + name)
                        audio_assets[target] = asset
            stone = source.row('fragment', hid)['Fragment ID']
            aliases['crystal_item_' + str(stone)] = hero['SoulstoneItemId']
            needed_items.add(stone)

    imported_monsters=[]
    for mid in added_monster_ids:
        raw=source.row('Unit',mid);puppet=source.row('Puppet',raw['Puppet'])
        ident=alias('crystal_'+str(mid),slug(raw['Name']),{u['Id'] for u in units.values()}|{u['Id'] for u in docs['Monsters']['Monsters']})
        groups=[named_row(source.table('SkillGroup'),g) for g in source.table('SkillGroup')[1][mid].values()]
        allowed=[g for g in groups if (g['Slot'] in (1,2,3,4,5) or g['Skill Group ID'] in ENCOUNTER_DEPENDENCIES) and g['Unlock']<=7 and not g['Awake'] and not g['Super Awake']]
        for group in allowed:add_skill(raw,group)
        basic=skills[raw['Basic Skill']];precise=source.direct(raw,raw['Main Attrib'])
        movement=dict(attack_range=max(1,round(basic['Crystal']['MaxRange']*10)),move_speed=round(raw['Walk Speed']*10),attack_interval=max(1,round(basic['Crystal']['Cooldown']*20)),damage_energy_rate=raw['MP Gain Rate'],interrupt_health_ratio=raw['Interrupt HP Ratio'] or 8)
        monster=dict(Id=ident,Name=raw['Name'],SourceUnitId=mid,SourceGender=raw['Gender'],SourcePuppet=raw['Puppet'],SourceResource=puppet['Resource'],ArtScale=puppet['Scale'],CollideRadius=raw['Collide Radius'],ProjectileHurtboxHeight=100,DeathAnimationMilliseconds=1500,Position={'前排':0,'中排':1,'后排':2}.get(raw['Position Type'],0),PortraitKey=ident,BodyPrefabResource='Zatod/'+puppet['Resource']+'/'+puppet['Resource'],AnimationSetResource='Zatod/'+puppet['Resource']+'/AnimationSet',NormalAttackSkillId=basic['Id'],BaseStats=[dict(StatId=k,Value=round(v)) for k,v in dict(health=max(1,round(precise.get('health',1))),damage=max(0,round(precise.get('damage',0))),defense=max(0,round(precise.get('defense',0))),**movement).items()],PreciseBaseStats=amounts(source.plus(precise,movement)),Growth=[],RankStats=[],SkillIds=[skills[g['Skill Group ID']]['Id'] for g in allowed if g['Skill Group ID']!=raw['Basic Skill']])
        for star in range(1,6):monster['Growth'].append(dict(Stars=star,PerLevel=amounts(source.direct({a:raw.get('+'+a+str(star),0) for a in ('STR','AGI','INT')},raw['Main Attrib']))))
        for rank in range(1,9):
            if rank not in source.table('UnitRank')[1].get(mid,{}):continue
            stats=source.row('UnitRank',mid,rank);estimate={k:stats.get('E.'+k,stats.get(k,0)) for k in ['STR','AGI','INT']+source.source_stats}
            monster['RankStats'].append(dict(Rank=rank,Stats=amounts(source.direct(stats,raw['Main Attrib'])),EstimatedStats=amounts(source.direct(estimate,raw['Main Attrib']))))
        docs['Monsters']['Monsters'].append(monster);imported_monsters.append(monster)
        if mid in (214,215,249,250,266):
            # These source-only summons use the absent Pler placeholder and have
            # no formation/HUD card. Do not invent an unrelated Hero portrait.
            monster['PortraitKey']=''
        else:add_asset('UI/DOTA-HERO/'+raw['Portrait'][1:],'Zatod/UI/Formation/Portraits/'+ident)
        animation=read(REF/'recovered/heroes'/puppet['Resource']/'animation.json')
        for action in animation['actions']:
            for frame in action['frames']:
                for event in frame['events']:
                    name=event.get('argument','')
                    if event['type']!=1 or not name:continue
                    path=ART/'sound'/name
                    if not path.is_file():missing_audio.add(name);continue
                    target='Zatod/Audio/'+Path(name).name
                    asset=dict(Source=path.relative_to(ROOT).as_posix(),Target=target,Sha256=hashlib.sha256(path.read_bytes()).hexdigest())
                    if target in audio_assets and audio_assets[target]!=asset:raise ValueError('Conflicting audio basename: '+name)
                    audio_assets[target]=asset
    if include_encounters:
        ready_sound=ART/'sound_menu/battle_fury_full.mp3'
        if not ready_sound.is_file():raise FileNotFoundError(ready_sound)
        audio_assets['Zatod/Audio/battle_fury_full.mp3']=dict(Source=ready_sound.relative_to(ROOT).as_posix(),Target='Zatod/Audio/battle_fury_full.mp3',Sha256=hashlib.sha256(ready_sound.read_bytes()).hexdigest())
        groups={}
        for rows in source.table('SkillGroup')[1].values():
            for row in rows.values():
                group=named_row(source.table('SkillGroup'),row);groups[group['Skill Group ID']]=group
        for skill in skills.values():
            skill['Crystal']['EnemyUnlockRank']=groups[skill['Crystal']['SourceId']]['Unlock For Monster']
            skill['Crystal']['LevelSourceId']=groups[skill['Crystal']['SourceId']]['Subordinate To']
            skill['Crystal']['IgnoreTargetType']=source.row('Skill',skill['Crystal']['SourceId'],0)['Ignore Target Type']
        for unit in docs['Heroes']['Heroes']+docs['Monsters']['Monsters']:
            unit['SourceGender']=source.row('Unit',unit['SourceUnitId'])['Gender']
            unit['DamageStatisticsRatio']=source.row('Unit',unit['SourceUnitId'])['DPS Statistics Ratio']
            unit['IsTitan']=bool(source.row('Unit',unit['SourceUnitId'])['IsTitan'])
            puppet=source.row('Puppet',unit['SourcePuppet'])
            unit['ActionRemaps']=[dict(Action=k[7:],Target=v) for k,v in puppet.items() if k.startswith('Action ') and v]
            duration=source.table('AnimDuration')[1].get(unit['SourceResource']+'.cha',{}).get(puppet.get('Action Birth') or 'Birth')
            unit['BirthSeconds']=named_row(source.table('AnimDuration'),duration)['Duration'] if duration else 0
            death=source.table('AnimDuration')[1].get(unit['SourceResource']+'.cha',{}).get(puppet.get('Action Death') or 'Death')
            if death:unit['DeathAnimationMilliseconds']=round(named_row(source.table('AnimDuration'),death)['Duration']*1000)
            hurt=source.table('AnimDuration')[1].get(unit['SourceResource']+'.cha',{}).get(puppet.get('Action Damaged') or 'Damaged')
            unit['HurtSeconds']=named_row(source.table('AnimDuration'),hurt)['Duration'] if hurt else 0
            alternate=source.table('AnimDuration')[1].get(unit['SourceResource']+'.cha',{}).get('Death2')
            unit['AlternateDeathSeconds']=named_row(source.table('AnimDuration'),alternate)['Duration'] if alternate else 0
            art=puppet_art(puppet)
            if art['Resource']!=unit['SourceResource']:
                unit.update({k:v for k,v in art.items() if k!='Resource'});unit['SourceResource']=art['Resource']
                unit['AnimationSetResource']='Zatod/'+art['Resource']+'/AnimationSet';unit['BodyPrefabResource']='Zatod/'+art['Resource']+'/'+art['Resource']
        for hero in docs['Heroes']['Heroes']:
            raw=source.row('Unit',hero['SourceUnitId']);hero['SourceGender']=raw['Gender']
            # Estimated level-65 encounters interpolate rank 7 and 8; owned ranks remain capped at Purple.
            if 8 in source.table('UnitRank')[1].get(hero['SourceUnitId'],{}) and not any(r['Rank']==8 for r in hero['RankStats']):
                stats=source.row('UnitRank',hero['SourceUnitId'],8);estimate={k:stats.get('E.'+k,stats.get(k,0)) for k in ['STR','AGI','INT']+source.source_stats}
                hero['RankStats'].append(dict(Rank=8,Stats=amounts(source.direct(stats,raw['Main Attrib'])),EstimatedStats=amounts(source.direct(estimate,raw['Main Attrib']))))
        for raw in source.table('Stage')[1].values():
            stage=named_row(source.table('Stage'),raw)
            if stage['Difficulty']==1 and 3<=stage['Chapter ID']<=8:
                needed_items.update(stage['UI reward'+str(n)] for n in range(1,11) if stage.get('UI reward'+str(n)) and stage['UI reward'+str(n)]!=20555)
    # All recipe leaves are explicit; no new Campaign drops or sources are invented.
    recipe_table = source.table('equipcraft')
    seen = set()
    def visit(number):
        if number in seen:
            return
        seen.add(number)
        if number in recipe_table[1]:
            recipe = source.row('equipcraft', number)
            for n in range(1, 5):
                if recipe.get('Component' + str(n)):
                    visit(recipe['Component' + str(n)])
    for number in sorted(needed_items):
        visit(number)
    inventory_groups = {'消耗品': (0, 5), '碎片': (1, 0), '合成品': (2, 6), '零件': (2, 7), '卷轴': (2, 8), '灵魂石': (3, 0)}
    for number in sorted(seen):
        raw = source.row('equip', number)
        ident = item_id(number)
        if ident not in items:
            tab, group = inventory_groups[raw['Category']]
            item = dict(ItemId=ident, Name=source.english(raw['Name']), IconResource=raw['Icon'], LevelRequirement=raw['Level Requirement'], Quality=raw['Quality'],
                        ItemKind=4 if tab == 3 else 1 if tab == 1 else 2 if group == 8 else 0, HeroExpValue=0, Stats=[],
                        PreciseStats=amounts(source.direct(raw)) if tab != 3 else [], InventoryTab=tab, InventoryFilter=group,
                        Description=source.english(raw.get('Description')), Comment=source.english(raw.get('Comment')), SellPrice=int(raw.get('Sell Price') or 0))
            items[ident] = item
            docs['Items']['Items'].append(item)
            add_asset(raw['Icon'], 'Zatod/UI/StagePreview/Items/' + ident)
        if number in recipe_table[1]:
            raw_recipe = source.row('equipcraft', number)
            if not any(r['OutputItemId'] == ident for r in docs['CraftRecipes']['CraftRecipes']):
                ingredients = {}
                for n in range(1, 5):
                    child = raw_recipe.get('Component' + str(n))
                    if child:
                        key = item_id(child)
                        ingredients[key] = ingredients.get(key, 0) + max(raw_recipe.get(f'Component{n} Count') or 1, 1)
                if ingredients:
                    docs['CraftRecipes']['CraftRecipes'].append(dict(Id=ident + '_recipe', SourceItemId=number, OutputItemId=ident, OutputAmount=1,
                        Ingredients=[dict(ItemId=k, Amount=v) for k, v in ingredients.items()], GoldCost=raw_recipe['Expense']))
    for bid in sorted(needed_buffs - buffs.keys()):
        raw = source.row('Buff', bid)
        stats = source.direct(raw)
        docs['Buffs']['Buffs'].append(dict(Id='d34_buff_' + str(bid), SourceId=bid, Name=source.english(raw['Name'], slug(raw['Name']).replace('_', ' ').title()),
            Control=','.join(str(v) for v in (raw['Control Effects'] or {}).values()), StackRule=str(raw['Stack and Refresh'] or ''), Dispel=raw['Dispel'] or '',
            Tenacity=raw['Tenacity'], Effect=raw['Effect'], ImpactEffect=raw['Impact Effect'], Mod=raw['MOD'], Duration=raw['Time'], ShieldValue=raw['Shield Value'],
            ShieldType=raw['Shield Type'], ClearOnDeath=bool(raw['Clear On Death ']), MaximumStacks=raw['Max Stack Times'], Stats=amounts(stats),
            Scaling=[dict(StatId=source.stat_map[k], Attribute=source.stat_map.get(raw[k + '.x'], ''), Ratio=raw[k + '.a']) for k in source.source_stats if raw.get(k + '.x') in source.stat_map]))
    # Existing PvP availability is never enabled just because definitions now exist.
    for h in docs['Heroes']['Heroes']:
        if h['SourceUnitId'] in added_hero_ids:

            h['AvailableInFreePvp'] = False
    # Copy world/progression tables as inputs, without touching saves or the active Data.
    complete_stats(docs)
    if include_encounters:buff_presentation(docs,source)
    output.mkdir(parents=True, exist_ok=True)
    for path in baseline.rglob('*.txt'):
        target = output / path.relative_to(baseline)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
    version = 'zatod-d34-heroes-draft-1'
    for name, doc in docs.items():
        doc['ConfigVersion'] = version
        write(output / (name + '.txt'), doc)
    for path in output.rglob('*.txt'):
        doc = read(path)
        if 'ConfigVersion' in doc:
            doc['ConfigVersion'] = version
            write(path, doc)
    inputs = [ROOT / 'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs', BASE / 'texttable/texttable.lua']
    inputs += [BASE / (name + '.lua') for name in sorted(source.tables)]
    inputs += [BASE / c['NativeHook'].removeprefix('data/') for c in coverage]
    inputs += [REF / 'recovered/heroes' / units[i]['SourceResource'] / 'animation.json' for i in added_hero_ids]
    input_hashes = {path.relative_to(ROOT).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest() for path in sorted(set(inputs))}
    pending = [c for c in coverage if not c['RuntimeEvoImported']]
    manifest = dict(SchemaVersion=1, Draft=True, RuntimeActivationReady=False,
        SourceRoot='Unity/Assets/Crystal Legend', InputPolicy='Tracked Lua + baseline Data + ZatodContentIds.cs; no Artifacts inputs',
        BaselineFiles={path.relative_to(baseline).as_posix():hashlib.sha256(path.read_bytes()).hexdigest() for path in sorted(baseline.rglob('*.txt'))},
        Counts={name: len(doc[name]) for name, doc in docs.items()}, AddedHeroes=[units[i]['Id'] for i in added_hero_ids],
        NewAliases={k: v for k, v in aliases.items() if k not in original_aliases},
        InputHashes=input_hashes, PreservedAliases=len(original_aliases), Assets=sorted(assets.values(), key=lambda a: a['Target']),
        Monsters=[dict(Id=m['Id'],SourceUnitId=m['SourceUnitId'],SourceResource=m['SourceResource'],AnimationSetResource=m['AnimationSetResource']) for m in imported_monsters],
        AudioAssets=sorted(audio_assets.values(), key=lambda a: a['Target']), MissingNativeAudio=sorted(missing_audio),
        Heroes=[dict(Id=units[i]['Id'], SourceUnitId=i, SourceResource=units[i]['SourceResource'], AnimationSetResource=units[i]['AnimationSetResource']) for i in added_hero_ids],
        Coverage=coverage, PendingNativeSkills=len(pending), PendingSourceEvolutions=sum(len(c['SourceEvolutions']) for c in pending),
        DeferredAttributeMechanics=['OD INT transfer and MainAttrib condition', 'Sil INT transfer'],
        Remaining=['Review/port native hooks and Evo for all added main skills', 'Summon dependencies required by unlocked source skills; shard remains excluded',
                   'Combat parity and Unity/PvP verification before activation', 'Chapters 3–8, farm acceptance and device checks remain in D34'])
    write(output.parent / (output.name + '-manifest.json'), manifest)
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--baseline', type=Path, default=DATA)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--include-encounters',action='store_true',help='Include source units and rewards from Normal chapters 1–8')
    args = parser.parse_args()
    result = build(args.baseline.resolve(), args.output.resolve(),args.include_encounters)
    print(json.dumps({k: result[k] for k in ('Draft', 'RuntimeActivationReady', 'Counts', 'AddedHeroes', 'PendingNativeSkills', 'PendingSourceEvolutions')}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
