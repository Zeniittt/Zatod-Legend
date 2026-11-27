module("ed.battlehero", package.seeall)
local ed = ed
CHEN = {}
CHEN.atk4_HPpercent = 25
CHEN.atk4_Unitpercent = 15
CHEN.atk4_Basepercent = 15
CHEN.atk4_radius = 150
CHEN.awake_buffID1 = 585
CHEN.awake_buffID2 = 586
CHEN.atk3s_monsterIDlist = {
  {
    101,
    100,
    2.5,
    1
  },
  {
    103,
    100,
    1.5,
    2
  },
  {
    107,
    100,
    2,
    1
  },
  {
    108,
    100,
    2.5,
    1
  },
  {
    109,
    100,
    1,
    1
  },
  {
    110,
    100,
    2.5,
    1
  },
  {
    113,
    100,
    1,
    1
  },
  {
    114,
    100,
    2,
    1
  },
  {
    115,
    100,
    1.5,
    1
  },
  {
    116,
    100,
    1,
    1
  },
  {
    117,
    100,
    1.5,
    1
  },
  {
    118,
    100,
    1.5,
    1
  },
  {
    119,
    100,
    1.5,
    1
  },
  {
    121,
    20,
    1,
    1
  },
  {
    122,
    100,
    1,
    1
  },
  {
    123,
    100,
    1.4,
    1
  },
  {
    124,
    100,
    1.4,
    1
  },
  {
    125,
    50,
    1,
    1
  },
  {
    126,
    20,
    1,
    1
  },
  {
    127,
    50,
    1,
    1
  },
  {
    131,
    100,
    1.5,
    1
  },
  {
    132,
    100,
    1,
    1
  },
  {
    133,
    100,
    1,
    1
  },
  {
    134,
    100,
    1.5,
    1
  }
}

function CHEN.choice_monsterID()
  local randNum = ed.rand() * CHEN.atk3s_monsterIDlist[#CHEN.atk3s_monsterIDlist][5]
  for i = 1, #CHEN.atk3s_monsterIDlist do
    if i == 1 and randNum < CHEN.atk3s_monsterIDlist[i][5] and CHEN.atk3s_monsterIDlist[i][1] then
      return CHEN.atk3s_monsterIDlist[i][1]
    end
    if 1 < i and randNum >= CHEN.atk3s_monsterIDlist[i - 1][5] and randNum < CHEN.atk3s_monsterIDlist[i][5] and CHEN.atk3s_monsterIDlist[i][1] then
      return CHEN.atk3s_monsterIDlist[i][1]
    end
  end
  return 101
end

function CHEN.hero_reset(basefunc, hero)
  hero.CHEN_haveunitlist = {}
  basefunc(hero)
  for i = 1, #CHEN.atk3s_monsterIDlist do
    if i == 1 then
      CHEN.atk3s_monsterIDlist[i][5] = CHEN.atk3s_monsterIDlist[i][2]
    else
      CHEN.atk3s_monsterIDlist[i][5] = CHEN.atk3s_monsterIDlist[i - 1][5] + CHEN.atk3s_monsterIDlist[i][2]
    end
  end
end

function CHEN.battleEnd_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  hero.config.is_monster = true
  hero.config.is_summoned = true
  hero.manually_casting = false
  if hero:isAlive() and ed.engine.beingEnd then
    if do_battle_log then
      btlog("%s died.", hero:display())
    end
    hero.state = ed.emUnitState_Dying
    if hero.manually_casting then
      hero.manually_casting = false
      ed.engine:unfreeze()
    end
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    hero.can_cast_manual = false
    hero.walk_v = {0, 0}
    hero.hp = 0
    hero.mp = 0
    if not hero.isDeathWithEffect then
      hero:setAction("Death", false, true)
    else
      hero.action_name = nil
      hero.action_loop = false
      hero.action_duration = 0
      hero.action_elapsed = 0
      local origin = {
        hero.position[1],
        hero.position[2]
      }
      if ed.run_with_scene then
        local effect_name = "eff_point_mirror_die.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, origin, {
            hero.direction * 0.85,
            0.85
          }, nil, 1)
        end
      end
    end
    ed.engine:onUnitDie(hero, nil)
    if hero.actor then
      hero.actor:onUnitDeath()
    end
  end
end

function CHEN.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local result
  for i, unit in ipairs(ed.engine.unit_list) do
    if (unit.info.ID < 101 or unit.info.ID > 10000) and unit.camp == caster.camp and not unit:isAlive() and not unit.config.is_summoned and unit.info["Unit Type"] == "Hero" and not unit.CHEN_ult1time then
      result = basefunc(skill, target)
    end
  end
  return result
end

function CHEN.skillult_onAttackFrame(basefunc, skill)
  local newHero1 = skill.caster.CHEN_ultHero1
  local caster = skill.caster
  local templist = {}
  if newHero1 and newHero1:isAlive() then
    newHero1:die()
  end
  for i, unit in ipairs(ed.engine.unit_list) do
    if (unit.info.ID < 101 or unit.info.ID > 10000) and unit.camp == caster.camp and not unit:isAlive() and unit.info["Unit Type"] == "Hero" and not unit.CHEN_ult1time and not unit.config.is_summoned then
      table.insert(templist, {
        unit,
        ed.rand()
      })
    end
  end
  table.sort(templist, function(a, b)
    return a[2] > b[2]
  end)
  local summonlocation
  if templist[1] then
    local target = templist[1][1]
    if target then
      local caster = skill.caster
      local tid = target.info.ID
      local level = target.level
      local stars = target.stars
      local skillevel = {
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level,
        target.level
      }
      local rank = target.rank
      local arousal = target.proto._arousal
      local _rune_info = target._hero_rune
      local proto = {
        _tid = tid,
        _level = level,
        _stars = stars,
        _skill_levels = skillevel,
        _arousal = arousal,
        _rank = rank
      }
      local config = {
        is_monster = false,
        is_summoned = false,
        hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
        dps_mod = caster.config.dps_mod,
        size_mod = target.config.size_mod
      }
      local newHero = ed.UnitCreate(proto, caster.camp, config)
      newHero:setDeathWithEffectOrNot(false)
      if target.position[1] <= ed.engine.stage_rect.minX then
        target.position[1] = ed.engine.stage_rect.minX + 50
      elseif target.position[1] >= ed.engine.stage_rect.maxX then
        target.position[1] = ed.engine.stage_rect.maxX - 50
      end
      summonlocation = {
        target.position[1],
        target.position[2]
      }
      newHero.direction = target.direction
      if ed.run_with_scene then
        local effect_name = "eff_point_CHEN_ult.cha"
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, summonlocation, nil, nil, -1)
      end
      ed.engine:summonUnit(newHero, summonlocation, caster, "Idle")
      newHero:reset()
      if newHero.name == "Mor" then
        newHero.orginHP = newHero.attribs.HP / target.config.hp_mod * newHero.config.hp_mod
      else
        newHero.orginHP = target.attribs.HP / target.config.hp_mod * newHero.config.hp_mod
      end
      for i, attrib in pairs(target.attribs) do
        newHero.attribs[i] = attrib
      end
      newHero.attribs.HP = newHero.orginHP
      newHero.hp = newHero.attribs.HP
      for i, skill in pairs(newHero.skill_list) do
        if skill.info["Init CD"] <= 60 then
          skill.cd_remaining = 0
        end
      end
      local skillults = caster.skills.CHEN_ults
      newHero:addBuff(skillults:createBuff(newHero), caster)
      local bid601 = 601
      local binfo601 = ed.lookupDataTable("Buff", nil, bid601)
      local buff601 = newHero:addBuff(binfo601, caster)
      buff601.onRemoved = override(buff601.onRemoved, CHEN.battleEnd_onRemoved)
      local bid2 = 351
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      newHero:addBuff(binfo2, caster)
      if newHero.name == "NA" or newHero.name == "POM" or newHero.name == "Flood" or newHero.name == "CW" then
        local bid3 = 492
        local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
        newHero:addBuff(binfo3, caster)
      end
      caster.CHEN_ultHero1 = newHero
      newHero.CHEN_ult1time = true
      target.CHEN_ult1time = true
      local skillawake = caster.skills.CHEN_awake
      local skillawakes = caster.skills.CHEN_awakes
      if skillawake then
        caster:addBuff(skillawake:createBuff(caster), caster)
        newHero:addBuff(skillawakes:createBuff(newHero), caster)
      end
      newHero.NotStolenByRubick = true
      newHero.config.is_summoned = false
    end
  end
  basefunc(skill)
end

function CHEN.hero_die(basefunc, hero, killer)
  if hero.CHEN_ultHero1 and hero.CHEN_ultHero1:isAlive() then
    hero.CHEN_ultHero1:die()
  end
  for i, unit in ipairs(hero.CHEN_haveunitlist) do
    if unit and unit:isAlive() and unit.config.summoner == hero then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function CHEN.skillatk2_buffOnRemoved(basefunc, buff)
  local skillatk2s = buff.caster.skills.CHEN_atk2s
  local owner = buff.owner
  if owner:isAlive() and buff.timer <= 0.1 and owner.hp / owner.attribs.HP <= 0.5 then
    skillatk2s:takeEffectOn(buff.owner, buff.caster)
  end
  basefunc(buff)
end

function CHEN.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, CHEN.skillatk2_buffOnRemoved)
  return buff
end

function CHEN.check_unit_issummoned(skill)
  local result = false
  local monster
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.config.is_summoned and unit.info["Influenced By CHEN"] then
      result = true
      monster = unit
      break
    end
  end
  return result, monster
end

function CHEN.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local count = 0
  for i, unit in ipairs(skill.caster.CHEN_haveunitlist) do
    if unit and unit:isAlive() then
      count = count + 1
    end
    if 2 <= count then
      result = false
      break
    end
  end
  return result
end

function CHEN.skillatk3_start(basefunc, skill)
  basefunc(skill)
  skill.caster.atk3_count = 0
end

function CHEN.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local Buffresult = false
  local caster = skill.caster
  if caster.atk3_count <= 3 then
    if target.config.is_summoned and target.info["Influenced By CHEN"] then
      basefunc(skill, target, source)
    else
      local originfo = skill.info
      skill.info = ed.wraptable(originfo, {
        ["Buff ID"] = 0
      })
      basefunc(skill, target, source)
      skill.info = originfo
    end
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 588 then
        Buffresult = true
      end
    end
    if Buffresult then
      table.insert(caster.CHEN_haveunitlist, target)
      local skillawake = caster.skills.CHEN_awake
      local skillawakes = caster.skills.CHEN_awakes
      caster.atk3_count = caster.atk3_count + 1
      if skillawake then
        caster:addBuff(skillawake:createBuff(caster), caster)
        target:addBuff(skillawakes:createBuff(target), caster)
      end
    end
  end
end

function CHEN.skillatk3s_takeEffectAt(basefunc, skill, position)
  basefunc(skill, position)
  if ed.run_with_scene then
    local pos = {0, -50}
    local maxX = ed.engine.stage_rect.maxX
    pos[1] = skill.caster.camp ~= ed.emCampPlayer and maxX or pos[1]
    local effect_name = "eff_point_CHEN_atk3s.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, pos, nil, nil, -1)
  end
  for i = 1, 2 do
    local ID = CHEN.choice_monsterID()
    local caster = skill.caster
    local monster_id = ID
    local dir = caster:getInitDir()
    local monster_position = {
      ed.engine.stage_rect.minX - 100,
      0
    }
    if dir == -1 then
      monster_position = {
        ed.engine.stage_rect.maxX + 100,
        0
      }
    end
    local skillevel = {
      skill.level,
      skill.level,
      skill.level
    }
    local proto = {
      _tid = monster_id,
      _level = skill.level or 1,
      _skill_levels = skillevel,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = (caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod) * 0.5,
      dps_mod = caster.config.dps_mod or 1,
      size_mod = 0.8
    }
    local monster = ed.UnitCreate(proto, caster.camp, config)
    monster.direction = caster.direction
    ed.engine:summonUnit(monster, monster_position, caster, "Idle")
    table.insert(caster.CHEN_haveunitlist, monster)
    local skillawake = caster.skills.CHEN_awake
    local skillawakes = caster.skills.CHEN_awakes
    if skillawake then
      caster:addBuff(skillawake:createBuff(caster), caster)
      monster:addBuff(skillawakes:createBuff(monster), caster)
    end
  end
end

function CHEN.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.CHEN_atk3s
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local Tr, monster = CHEN.check_unit_issummoned(skill)
  if Tr then
    skill:takeEffectAt(monster.position)
  else
    skillatk3s:takeEffectAt(skill.target.position)
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function CHEN.check_aroundUnitNumber(skill, unit)
  local count = 0
  for hero in ed.engine:foreachAliveUnit(-skill:targetCamp()) do
    local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, hero.position))
    if distanceSQ <= CHEN.atk4_radius * CHEN.atk4_radius then
      count = count + 1
    end
  end
  return count
end

function CHEN.check_atk4MaxUnit(skill)
  local percent
  local maxPercent = 0
  local maxUnit
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if not unit.config.is_summoned then
      percent = CHEN.atk4_Basepercent + CHEN.check_aroundUnitNumber(skill, unit) * CHEN.atk4_Unitpercent + (1 - unit.hp / unit.attribs.HP) * CHEN.atk4_HPpercent
      if maxPercent < percent then
        maxPercent = percent
        maxUnit = unit
      end
    end
  end
  return maxUnit, maxPercent
end

function CHEN.skillatk4_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk4s = caster.skills.CHEN_atk4s
  local unit, percent = CHEN.check_atk4MaxUnit(skill)
  if not unit then
    unit = target
    percent = CHEN.atk4_Basepercent
  end
  if ed.rand() <= percent / 100 then
    basefunc(skill, unit, source)
  else
    skillatk4s:takeEffectOn(unit, source)
  end
end

function CHEN.skillawakes_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local hero = owner.config.summoner
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 586 then
      tbuff.timer = 0
      break
    end
  end
  basefunc(buff)
end

function CHEN.skillawakes_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, CHEN.skillawakes_buffOnRemoved)
  return buff
end

function CHEN.init_hero(hero)
  local skillult = hero.skills.CHEN_ult
  local skillatk2 = hero.skills.CHEN_atk2
  local skillatk2s = hero.skills.CHEN_atk2s
  local skillatk3 = hero.skills.CHEN_atk3
  local skillatk3s = hero.skills.CHEN_atk3s
  local skillatk4 = hero.skills.CHEN_atk4
  local skillatk4s = hero.skills.CHEN_atk4s
  local skillawake = hero.skills.CHEN_awake
  local skillawakes = hero.skills.CHEN_awakes
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, CHEN.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, CHEN.skillult_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, CHEN.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, CHEN.skillatk3_canCastWithTarget)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, CHEN.skillatk3_takeEffectOn)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, CHEN.skillatk3_onAttackFrame)
    skillatk3s.takeEffectAt = override(skillatk3s.takeEffectAt, CHEN.skillatk3s_takeEffectAt)
    skillatk3.start = override(skillatk3.start, CHEN.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, CHEN.skillatk4_takeEffectOn)
  end
  if skillawake then
    skillawakes.createBuff = override(skillawakes.createBuff, CHEN.skillawakes_createBuff)
  end
  hero.reset = override(hero.reset, CHEN.hero_reset)
  hero.die = override(hero.die, CHEN.hero_die)
  return hero
end

return CHEN.init_hero
