module("ed.battlehero", package.seeall)
local ed = ed
TowerMor = {}
TowerMor.MixUP_summonpos = {
  {420, 0},
  {510, 5},
  {600, -5},
  {690, 8},
  {780, -8}
}
TowerMor.MixUP_buffID = 6070
TowerMor.slimSummon_buffID = 4230
TowerMor.MixUP_powerUP_buffID = 4226
TowerMor.invisTimer = 30
TowerMor.redSlim_buffID = 4227
TowerMor.greenSlim_buffID = 4228
TowerMor.ultinvis_buffID = 4229

function TowerMor.hero_update(basefunc, unit, dt)
  basefunc(unit, dt)
  unit.timeCount = unit.timeCount + dt
  local basic_frequency = 2
  if ed.engine.time_limit > 30 and ed.engine.time_limit <= 45 then
    basic_frequency = basic_frequency * 0.5
  elseif ed.engine.time_limit < TowerMor.invisTimer and not unit.ShowUP then
    unit.ShowUP = true
    basic_frequency = 9999
    local skillenter = unit.skills.TowerMor_enter
    unit.position[1] = 650
    for i, buff in ipairs(unit.buff_list) do
      if buff.info.ID == TowerMor.MixUP_buffID then
        print(buff.info.ID)
        unit:removeBuff(buff)
      end
    end
    local slim_counter = {
      0,
      0,
      0
    }
    local slim_sum = 0
    for sunit in ed.engine:foreachAliveUnit(unit.camp) do
      if sunit.info.ID == 273 then
        slim_sum = slim_sum + 1
        slim_counter[1] = slim_counter[1] + 1
        sunit:die(sunit)
      elseif sunit.info.ID == 274 then
        slim_sum = slim_sum + 1
        slim_counter[2] = slim_counter[2] + 1
        sunit:die(sunit)
      elseif sunit.info.ID == 275 then
        slim_sum = slim_sum + 1
        slim_counter[3] = slim_counter[3] + 1
        sunit:die(sunit)
      end
    end
    local binfo = ed.lookupDataTable("Buff", nil, TowerMor.MixUP_powerUP_buffID)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff:setAttribute("AD", slim_counter[1] * unit.attribs.AD * 0.05)
    buff:setAttribute("HP", unit.attribs.HP * unit.TowerMor_countingStars * 0.05 + slim_counter[2] * unit.attribs.HP * (0.05 + 0.002 * unit.TowerMor_countingStars))
    buff:setAttribute("ARM", slim_counter[3] * unit.attribs.ARM * 0.05)
    buff:setAttribute("MR", slim_counter[3] * unit.attribs.MR * 0.05)
    unit:addBuff(buff, unit)
    unit:takeHeal(unit.attribs.HP, "hp", unit)
    local ibinfo = ed.lookupDataTable("Buff", nil, TowerMor.ultinvis_buffID)
    unit:addBuff(ibinfo, unit)
    unit:castSkill(skillenter, unit)
  end
  if basic_frequency < unit.timeCount and ed.engine.time_limit >= TowerMor.invisTimer then
    unit.timeCount = 0
    local slimID = math.ceil(ed.rand() * 3) + 272
    local proto = {
      _tid = slimID,
      _level = unit.level or 1,
      _stars = unit.stars,
      _rank = unit.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = unit.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or unit.config.hp_mod,
      dps_mod = unit.config.dps_mod or 1
    }
    local slim = ed.UnitCreate(proto, unit.camp, config)
    slim.direction = unit.direction
    local basic_pos = TowerMor.MixUP_summonpos[math.ceil(ed.rand() * 5)]
    local slim_location = {
      basic_pos[1] + ed.rand() * 50 - 25,
      basic_pos[2] + ed.rand() * 20 - 10
    }
    if unit:isAlive() then
      if slimID == 273 then
        local binfo = ed.lookupDataTable("Buff", nil, TowerMor.redSlim_buffID)
        local bbuff = ed.BuffCreate(binfo, slim, slim)
        bbuff:setAttribute("HP", unit.TowerMor_countingStars * 0.04 * slim.attribs.HP)
        slim:addBuff(bbuff, slim)
        slim:setHP(slim.attribs.HP)
      elseif slimID == 274 then
        local binfo = ed.lookupDataTable("Buff", nil, TowerMor.greenSlim_buffID)
        local bbuff = ed.BuffCreate(binfo, slim, slim)
        bbuff:setAttribute("HP", unit.TowerMor_countingStars * 0.04 * slim.attribs.HP)
        slim:addBuff(bbuff, slim)
        slim:setHP(slim.attribs.HP)
      end
      ed.engine:summonUnit(slim, slim_location, unit, "Idle")
      local wbinfo = ed.lookupDataTable("Buff", nil, TowerMor.slimSummon_buffID)
      slim:addBuff(wbinfo, slim)
    end
  end
end

function TowerMor.hero_reset(basefunc, unit)
  basefunc(unit)
  for starunit in ed.engine:foreachAliveUnit(unit.foecamp) do
    unit.TowerMor_countingStars = unit.TowerMor_countingStars + starunit.stars
  end
  unit.TowerMor_countingStars = math.max(0, unit.TowerMor_countingStars - 35)
  for sunit in ed.engine:foreachAliveUnit(unit.camp) do
    if sunit.info.ID == 273 then
      local binfo = ed.lookupDataTable("Buff", nil, TowerMor.redSlim_buffID)
      local bbuff = ed.BuffCreate(binfo, sunit, sunit)
      bbuff:setAttribute("HP", unit.TowerMor_countingStars * 0.04 * sunit.attribs.HP)
      sunit:addBuff(bbuff, sunit)
      sunit:setHP(sunit.attribs.HP)
    elseif sunit.info.ID == 274 then
      local binfo = ed.lookupDataTable("Buff", nil, TowerMor.greenSlim_buffID)
      local bbuff = ed.BuffCreate(binfo, sunit, sunit)
      bbuff:setAttribute("HP", unit.TowerMor_countingStars * 0.04 * sunit.attribs.HP)
      sunit:addBuff(bbuff, sunit)
      sunit:setHP(sunit.attribs.HP)
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, TowerMor.MixUP_buffID)
  local buff = ed.BuffCreate(binfo, unit, unit)
  unit:addBuff(buff, unit)
end

function TowerMor.skillenter_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TowerMor.ultinvis_buffID then
      caster:removeBuff(buff)
    end
  end
end

function TowerMor.init_hero(hero)
  hero.TowerMor_countingStars = 0
  hero.timeCount = 0
  hero.TowerMor_slimCount = {
    0,
    0,
    0
  }
  hero.update = override(hero.update, TowerMor.hero_update)
  hero.reset = override(hero.reset, TowerMor.hero_reset)
  local skillenter = hero.skills.TowerMor_enter
  if skillenter then
    skillenter.onAttackFrame = override(skillenter.onAttackFrame, TowerMor.skillenter_onAttackFrame)
  end
  return hero
end

return TowerMor.init_hero
