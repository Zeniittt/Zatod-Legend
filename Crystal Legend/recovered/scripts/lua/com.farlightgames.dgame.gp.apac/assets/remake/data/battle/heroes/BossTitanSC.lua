module("ed.battlehero", package.seeall)
local ed = ed
BossTitanSC = {}
BossTitanSC.atk3max_position = 480
BossTitanSC.TitanSC_atk2_BuffID = 4274
BossTitanSC.TitanSC_atk3_BuffID = 4275
BossTitanSC.bossID = 1

function BossTitanSC.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster and caster:isAlive() and caster.TitanSC_hasArcana > 3 then
    buff:setAttribute("MPGainRatio", -100)
    buff:setAttribute("MPRatio", -100)
    buff:setAttribute("MIMU", -50)
    buff.timer = buff.timer + 3
  end
  if target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, 4277)
    local bbuff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(bbuff, caster)
  end
  buff.onRemoved = override(buff.onRemoved, BossTitanSC.skillatk2_buff_onRemoved)
  return buff
end

function BossTitanSC.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  skill.info["No Dodge"] = true
  return ret, dmg, Crit, lfs_amount
end

function BossTitanSC.skillatk2_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  for i, bbuff in ipairs(buff.owner.buff_list) do
    if bbuff.info.ID == 4277 then
      bbuff.timer = 0
    end
  end
end

function BossTitanSC.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local outpos = BossTitanSC.findEffectPos(skill)
  if skill.attack_counter == 1 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_TitanSC_atk3.cha", {
        outpos,
        caster.position[2]
      }, {
        caster.direction,
        1
      }, nil, 1)
    end
  elseif skill.attack_counter == 2 then
    skill:takeEffectAt({
      outpos,
      caster.position[2]
    }, caster)
  elseif skill.attack_counter == 3 then
    skill:takeEffectAt({
      outpos,
      caster.position[2]
    }, caster)
  end
end

function BossTitanSC.skillatk3_createTrackType(basefunc, skill, ttype)
  if ttype and (ttype ~= "projectile" or ttype ~= "chain" or ttype ~= "region") then
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
end

function BossTitanSC.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local direction = skill.caster.direction
  skill.TitanSC_atk3origin = {
    location[1] + skill.info["X Shift"] * direction,
    location[2]
  }
end

function BossTitanSC.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if skill.attack_counter == 3 and target and target:isAlive() then
    local info = skill.info
    local aoe = info["AOE Origin"]
    local origin = skill.TitanSC_atk3origin
    local KRES = target.attribs.KnockRES
    local time = 0.5
    local distance = (origin[1] - target.position[1]) * 0.75
    if KRES < 1 and 0 <= KRES then
      time = time * math.sqrt(KRES)
      distance = distance * KRES
    end
    if 0 < time or 0 < distance then
      local direction = {1, 0}
      target:knockup(time, ed.edpMult(direction, distance), shift)
    end
  end
  return ret, dmg, Crit, lfs_amount
end

function BossTitanSC.skillatk4b_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, 4274)
    local buff = ed.BuffCreate(binfo, target, caster)
    if caster and caster:isAlive() and caster.TitanSC_hasArcana > 3 then
      buff:setAttribute("MPGainRatio", -100)
      buff:setAttribute("MPRatio", -100)
      buff.timer = buff.timer + 3
    end
    buff.onRemoved = override(buff.onRemoved, BossTitanSC.skillatk2_buff_onRemoved)
    target:addBuff(buff, caster)
    local bbinfo = ed.lookupDataTable("Buff", nil, 4277)
    local bbuff = ed.BuffCreate(bbinfo, target, caster)
    target:addBuff(bbuff, caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function BossTitanSC.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster and caster:isAlive() and caster.TitanSC_hasArcana > 1 then
    buff:setAttribute("PIMU", -100)
  end
  return buff
end

function BossTitanSC.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local outpos = BossTitanSC.findEffectPos(skill)
  if skill.attack_counter == 1 and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanSC_atk4.cha", {
      outpos,
      caster.position[2] - 30
    }, {
      caster.direction,
      1
    }, nil, 1)
  end
  skill:takeEffectAt({
    outpos,
    caster.position[2]
  }, caster)
end

function BossTitanSC.findEffectPos(skill)
  local caster = skill.caster
  local max_count = -1
  local outpos = -1024
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if not unit.config.is_summoned then
      local posA = unit.position[1]
      if outpos == -1024 then
        outpos = posA
      end
      local count = 0
      local max_pos = unit.position[1]
      for unit2 in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
        if not unit2.config.is_summoned and unit2 ~= unit and posA < unit2.position[1] and unit2.position[1] - posA < BossTitanSC.atk3max_position then
          count = count + 1
          if max_pos < unit2.position[1] then
            max_pos = unit2.position[1]
          end
        end
      end
      unit.TitanSC_atk3count = count
      unit.TitanSC_atk3mpos = max_pos
      if max_count < count then
        max_count = count
        outpos = 0.5 * (max_pos + posA)
      end
    end
  end
  return outpos
end

function BossTitanSC.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4b = caster.skills.TitanSC_atk4b
  local has_buff = false
  if target and target:isAlive() then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == BossTitanSC.TitanSC_atk2_BuffID then
        has_buff = true
      end
    end
  end
  if skillatk4b and has_buff and skill.attack_counter == 4 then
    skillatk4b:takeEffectAt(target.position, caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function BossTitanSC.skillult_takeEffectAt(basefunc, skill, location, source)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local ratio_temp = 1
    for unitb in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if unitb ~= unit then
        local distance = math.abs(unitb.position[1] - unit.position[1])
        if distance < 400 and 240 < distance then
          ratio_temp = ratio_temp + 0.5 + 0.5 * (distance - 240) / 160
        end
        if distance <= 240 then
          ratio_temp = ratio_temp + 2 - (distance / 240) ^ 2
        end
      end
    end
    unit.TitanSC_powerR = math.min(ratio_temp, 5)
  end
  basefunc(skill, location, source)
end

function BossTitanSC.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if target and target:isAlive() and caster.TitanSC_hasArcana > 2 then
    power = power * (target.TitanSC_powerR or 1)
    target.TitanSC_powerR = nil
  end
  return power, coeff
end

function BossTitanSC.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4276
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function BossTitanSC.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == 4276 then
      buff.timer = 0
    end
  end
end

function BossTitanSC.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 1 and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanSC_ult.cha", {400, 0}, {
      caster.direction,
      1
    }, nil, 1)
  end
end

function BossTitanSC.hero_reset(basefunc, hero)
  basefunc(hero)
  local info = ed.getDataTable("MythBossReward")
  hero.BossStageList = {}
  hero.BossTotalHp = hero.attribs.HP
  hero.Boss_nstage = 0
  hero.Boss_stageBuff = nil
  for _, group in ipairs(info) do
    repeat
      if not group[1] then
      else
        if group[1]["Boss RewardLine ID"] == BossTitanSC.bossID then
          table.insert(hero.BossStageList, group)
        else
        end
        break -- pseudo-goto
      end
    until true
  end
  hero:setPosition({600, 0})
  hero.direction = -1
end

function BossTitanSC.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local lostHp = hero.BossTotalHp - hero.hp
  local stagechange
  for i, Hpstage in ipairs(hero.BossStageList) do
    if lostHp >= Hpstage[1]["Damage Value"] and i > hero.Boss_nstage then
      hero.Boss_nstage = i
      stagechange = true
    end
  end
  if stagechange then
    if hero.Boss_stageBuff then
      hero.Boss_stageBuff.timer = -1
    end
    local binfo = ed.lookupDataTable("Buff", nil, hero.BossStageList[hero.Boss_nstage][1]["Buff ID"])
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero.Boss_stageBuff = hero:addBuff(buff, hero)
  end
end

function BossTitanSC.init_hero(hero)
  local skillatk2 = hero.skills.BossTitanSC_atk2
  local skillatk3 = hero.skills.BossTitanSC_atk3
  local skillatk4 = hero.skills.BossTitanSC_atk4
  local skillatk4b = hero.skills.BossTitanSC_atk4b
  local skillult = hero.skills.BossTitanSC_ult
  hero.TitanSC_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, BossTitanSC.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, BossTitanSC.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.TitanSC_atk3affected = {}
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, BossTitanSC.skillatk3_onAttackFrame)
    skillatk3.createTrackType = override(skillatk3.createTrackType, BossTitanSC.skillatk3_createTrackType)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, BossTitanSC.skillatk3_takeEffectAt)
    skillatk3.createBuff = override(skillatk3.createBuff, BossTitanSC.skillatk3_createBuff)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, BossTitanSC.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, BossTitanSC.skillatk4_onAttackFrame)
    skillatk4.createTrackType = override(skillatk4.createTrackType, BossTitanSC.skillatk3_createTrackType)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, BossTitanSC.skillatk4_takeEffectOn)
    skillatk4.start = override(skillatk4.start, BossTitanSC.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, BossTitanSC.skillatk4_finish)
    skillatk4b.takeEffectOn = override(skillatk4b.takeEffectOn, BossTitanSC.skillatk4b_takeEffectOn)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossTitanSC.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, BossTitanSC.skillult_takeEffectAt)
    skillult.power = override(skillult.power, BossTitanSC.skillult_power)
  end
  hero.reset = override(hero.reset, BossTitanSC.hero_reset)
  hero.update = override(hero.update, BossTitanSC.hero_update)
  return hero
end

return BossTitanSC.init_hero
