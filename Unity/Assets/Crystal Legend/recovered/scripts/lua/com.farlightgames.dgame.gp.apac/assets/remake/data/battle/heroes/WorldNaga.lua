module("ed.battlehero", package.seeall)
local ed = ed
WorldNaga = {}
WorldNaga.ragelosthp = 35000
WorldNaga.rage2losthp = 15000
WorldNaga.ultdevetion = 50
WorldNaga.ultfault = 25
WorldNaga.atk3doge = 0.2
WorldNaga.WorldNaga_atk3mir = 10
WorldNaga.WorldNaga_ultmir = 15
WorldNaga.stage2hp = 1750000
WorldNaga.stage2ragelosthp = 7500

function WorldNaga.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldNaga.rage_buff_update)
  hero.lastrageStack = 0
  hero.BossNaga_ultMirrorlist = {}
  hero.BossNaga_ultHerolist = {}
  hero.BossNaga_atk3Mirrorlist = {}
  hero.inUlt = false
end

function WorldNaga.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldNaga.ultmirror_update(basefunc, hero, dt)
  hero.WorldNaga_ultmir = hero.WorldNaga_ultmir - dt
  if hero.WorldNaga_ultmir <= 0 and hero:isAlive() then
    hero:die()
    local BossNaga = hero.config.summoner
    local MirNaga = hero
    local skillults = BossNaga.skills.WorldNaga_ults
    if skillults then
      skillults:takeEffectAt(MirNaga.position)
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_AV_ult.cha"
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, MirNaga.position, {
        MirNaga.direction,
        1
      }, nil, effect_z)
    end
  else
    basefunc(hero, dt)
  end
end

function WorldNaga.atk3mirror_update(basefunc, hero, dt)
  hero.WorldNaga_atk3mir = hero.WorldNaga_atk3mir - dt
  if hero.WorldNaga_atk3mir <= 0 and hero:isAlive() then
    hero:die()
  else
    basefunc(hero, dt)
  end
end

function WorldNaga.ult_scuessed(BossNaga)
  for i, unit in ipairs(BossNaga.BossNaga_ultMirrorlist) do
    if unit:isAlive() then
      unit:die()
    end
  end
  BossNaga.inUlt = false
end

function WorldNaga.ult_failure(BossNaga, MirNaga)
  if MirNaga:isAlive() then
    MirNaga:die()
    local skillults = BossNaga.skills.WorldNaga_ults
    if skillults then
      skillults:takeEffectAt(MirNaga.position)
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_AV_ult.cha"
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, MirNaga.position, {
        MirNaga.direction,
        1
      }, nil, effect_z)
    end
  end
end

function WorldNaga.skillatk2_onAttackFrame(basefunc, skill)
  skill.info["No Dodge"] = true
  basefunc(skill)
end

function WorldNaga.skillults3_buffUpdate(basefunc, buff, dt)
  local hero = buff.BossNaga
  if hero:isAlive() and hero.inUlt then
    for i, unit in ipairs(hero.BossNaga_ultHerolist) do
      if unit[1]:isAlive() and unit[1].current_skill and unit[1].manually_casting and unit[3] then
        if unit[3] == hero or ed.edpDistanceSQ(unit[1].position, hero.BossNaga_ultHerolist[1][1].position) <= WorldNaga.ultfault * WorldNaga.ultfault then
          WorldNaga.ult_scuessed(hero)
        else
          WorldNaga.ult_failure(hero, unit[3])
        end
      end
    end
  end
  basefunc(buff, dt)
end

function WorldNaga.skillults3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.BossNaga = skill.caster
  buff.update = override(buff.update, WorldNaga.skillults3_buffUpdate)
  return buff
end

function WorldNaga.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
  end
  if attack_counter == 1 then
    local BossNaga = skill.caster
    local heroes_templist = {}
    for unit in ed.engine:foreachAliveUnit(BossNaga.foecamp) do
      if unit.config.is_summoned then
      elseif BossNaga.buff_effects.enchanted and unit == BossNaga then
      elseif 0 > unit.position[1] or unit.position[1] > 800 then
      else
        table.insert(heroes_templist, {
          unit,
          ed.rand()
        })
        local skillults3 = skill.caster.skills.WorldNaga_ults3
        if skillults3 then
          unit:addBuff(skillults3:createBuff(unit), unit)
        end
      end
    end
    table.sort(heroes_templist, function(a, b)
      return a[2] > b[2]
    end)
    local heroes_num = #heroes_templist
    for i = 1, heroes_num do
      if i == 1 then
        local unit = heroes_templist[i][1]
        local dir = unit.direction
        BossNaga.position = {
          unit.position[1] + dir * WorldNaga.ultdevetion,
          unit.position[2]
        }
        BossNaga.ulttarget = heroes_templist[i][1]
        table.insert(heroes_templist[i], BossNaga)
        local skillults2 = BossNaga.skills.WorldNaga_ults2
        if skillults2 then
          BossNaga.ulttarget:addBuff(skillults2:createBuff(BossNaga.ulttarget), BossNaga)
        end
      else
        local unit = heroes_templist[i][1]
        local dir = unit.direction
        local MirrorNaga_position = {
          unit.position[1] - dir * WorldNaga.ultdevetion,
          unit.position[2]
        }
        local skillevel = {
          skill.level,
          skill.level,
          skill.level,
          skill.level,
          skill.level,
          skill.level,
          skill.level
        }
        local proto = {
          _tid = 217,
          _level = skill.level or 1,
          _skill_levels = skillevel,
          _stars = BossNaga.stars,
          _rank = BossNaga.rank
        }
        local config = {
          is_monster = true,
          estimate_rank = true,
          hp_mod = BossNaga.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or BossNaga.config.hp_mod,
          dps_mod = BossNaga.config.dps_mod or 1
        }
        local ultMirrorNaga = ed.UnitCreate(proto, BossNaga.camp, config)
        ed.engine:summonUnit(ultMirrorNaga, MirrorNaga_position, BossNaga)
        ultMirrorNaga:setDeathWithEffectOrNot(true)
        table.insert(BossNaga.BossNaga_ultMirrorlist, ultMirrorNaga)
        table.insert(heroes_templist[i], ultMirrorNaga)
        ultMirrorNaga.ulttarget = heroes_templist[i][1]
        ultMirrorNaga.update = override(ultMirrorNaga.update, WorldNaga.ultmirror_update)
        ultMirrorNaga.WorldNaga_ultmir = WorldNaga.WorldNaga_ultmir
        local bid = 582
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ultMirrorNaga:addBuff(binfo, ultMirrorNaga)
        local skillults2 = ultMirrorNaga.skills.WorldNagaMir_ults2
        if skillults2 then
          ultMirrorNaga.ulttarget:addBuff(skillults2:createBuff(ultMirrorNaga.ulttarget), ultMirrorNaga)
        end
      end
    end
    BossNaga.BossNaga_ultHerolist = heroes_templist
    BossNaga.inUlt = true
  end
end

function WorldNaga.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldNaga.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldNaga.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldNaga.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldNaga.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldNaga.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldNaga.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldNaga.stage2hp and hero.hp - lost <= WorldNaga.stage2hp then
    return hero.hp - WorldNaga.stage2hp
  else
    return lost
  end
end

function WorldNaga.takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
  end
  local self = unit
  if not self:isAlive() then
    return
  end
  if (damage_type == "AD" or damage_type == "AP") and ed.rand() <= WorldNaga.atk3doge then
    local summonAD = true
    if damage_type == "AP" then
      summonAD = false
    end
    if do_battle_log then
      btlog("%s: %s --> %s (Miss! by WorldNagaatk3)", self:display(), source:display(), self:display())
    end
    local color = unit.camp == ed.emCampEnemy and "red" or "blue"
    if unit.actor then
      ed.PopupCreate("dodge", color, unit.actor, nil, "text")
    end
    local dir = unit.direction
    local MirrorNaga_position = {
      unit.position[1] + (ed.rand() * 2 - 1) * 100,
      unit.position[2] - 50
    }
    local skillevel = {
      unit.level
    }
    local proto = {
      _tid = summonAD and 218 or 219,
      _level = unit.level or 1,
      _skill_levels = skillevel,
      _stars = unit.stars,
      _rank = unit.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = unit.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or unit.config.hp_mod,
      dps_mod = unit.config.dps_mod or 1
    }
    local atk3MirrorNaga = ed.UnitCreate(proto, unit.camp, config)
    ed.engine:summonUnit(atk3MirrorNaga, MirrorNaga_position, unit)
    atk3MirrorNaga:setDeathWithEffectOrNot(true)
    local bid = summonAD and 577 or 579
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = atk3MirrorNaga:addBuff(binfo, atk3MirrorNaga)
    atk3MirrorNaga.WorldNaga_atk3mir = WorldNaga.WorldNaga_atk3mir
    atk3MirrorNaga.update = override(atk3MirrorNaga.update, WorldNaga.atk3mirror_update)
    table.insert(unit.BossNaga_atk3Mirrorlist, atk3MirrorNaga)
    return 0
  else
    return basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  end
end

function WorldNaga.init_hero(hero)
  local skillult = hero.skills.WorldNaga_ult
  local skillults3 = hero.skills.WorldNaga_ults3
  local skillatk2 = hero.skills.WorldNaga_atk2
  local skillatk3 = hero.skills.WorldNaga_atk3
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldNaga.skillult_onAttackFrame)
  end
  if skillults3 then
    skillults3.createBuff = override(skillults3.createBuff, WorldNaga.skillults3_createBuff)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldNaga.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    hero.takeDamage = override(hero.takeDamage, WorldNaga.takeDamage)
  end
  hero.reset = override(hero.reset, WorldNaga.hero_reset)
  hero.update = override(hero.update, WorldNaga.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldNaga.getLostHPAfterImmunity)
  return hero
end

return WorldNaga.init_hero
