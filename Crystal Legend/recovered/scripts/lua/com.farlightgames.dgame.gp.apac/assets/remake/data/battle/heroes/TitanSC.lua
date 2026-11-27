module("ed.battlehero", package.seeall)
local ed = ed
TitanSC = {}
TitanSC.atk3max_position = 480
TitanSC.TitanSC_atk2_BuffID = 4274
TitanSC.TitanSC_atk3_BuffID = 4275
TitanSC.TitanSC_fashion_id = 101011
TitanSC.fashion_bid = 4677

function TitanSC.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster and caster:isAlive() and caster.TitanSC_hasArcana > 3 then
    buff:setAttribute("MPGainRatio", -100)
    buff:setAttribute("MPRatio", -100)
    buff:setAttribute("MIMU", -50)
    buff.timer = buff.timer + 3
  end
  if TitanSC.TitanSC_fashion_id and TitanSC.TitanSC_fashion_id == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_TitanSC_skin_atk2.cha")
  end
  if target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, 4277)
    local bbuff = ed.BuffCreate(binfo, target, caster)
    if TitanSC.TitanSC_fashion_id and TitanSC.TitanSC_fashion_id == caster.fashion_id then
      bbuff:setAttribute("Effect", "eff_buff_TitanSC_skin_atk2a.cha")
    end
    target:addBuff(bbuff, caster)
  end
  buff.onRemoved = override(buff.onRemoved, TitanSC.skillatk2_buff_onRemoved)
  return buff
end

function TitanSC.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  skill.info["No Dodge"] = true
  return ret, dmg, Crit, lfs_amount
end

function TitanSC.skillatk2_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  for i, bbuff in ipairs(buff.owner.buff_list) do
    if bbuff.info.ID == 4277 then
      bbuff.timer = 0
    end
  end
end

function TitanSC.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local outpos = TitanSC.findEffectPos(skill)
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

function TitanSC.skillatk3_createTrackType(basefunc, skill, ttype)
  if ttype and (ttype ~= "projectile" or ttype ~= "chain" or ttype ~= "region") then
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
end

function TitanSC.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local direction = skill.caster.direction
  skill.TitanSC_atk3origin = {
    location[1] + skill.info["X Shift"] * direction,
    location[2]
  }
end

function TitanSC.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
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

function TitanSC.skillatk4b_takeEffectOn(basefunc, skill, target, source, shift)
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
    buff.onRemoved = override(buff.onRemoved, TitanSC.skillatk2_buff_onRemoved)
    target:addBuff(buff, caster)
    local bbinfo = ed.lookupDataTable("Buff", nil, 4277)
    local bbuff = ed.BuffCreate(bbinfo, target, caster)
    if TitanSC.TitanSC_fashion_id and TitanSC.TitanSC_fashion_id == caster.fashion_id then
      bbuff:setAttribute("Effect", "eff_buff_TitanSC_skin_atk2a.cha")
    end
    target:addBuff(bbuff, caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function TitanSC.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  caster.atk3_HPR = buff.info.HPR
  if caster and caster:isAlive() and caster.TitanSC_hasArcana > 1 then
    buff:setAttribute("PIMU", -100)
  end
  return buff
end

function TitanSC.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local outpos = TitanSC.findEffectPos(skill)
  if skill.attack_counter == 1 and ed.run_with_scene then
    if TitanSC.TitanSC_fashion_id and TitanSC.TitanSC_fashion_id == caster.fashion_id then
      ed.scene:playEffectOnScene("eff_point_TitanSC_skin_atk4.cha", {
        outpos,
        caster.position[2] - 30
      }, {
        caster.direction,
        1
      }, nil, 1)
    else
      ed.scene:playEffectOnScene("eff_point_TitanSC_atk4.cha", {
        outpos,
        caster.position[2] - 30
      }, {
        caster.direction,
        1
      }, nil, 1)
    end
  end
  skill:takeEffectAt({
    outpos,
    caster.position[2]
  }, caster)
end

function TitanSC.findEffectPos(skill)
  local caster = skill.caster
  local max_count = -1
  local outpos = 400
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if not unit.config.is_summoned then
      local posA = unit.position[1]
      if outpos == 400 then
        outpos = posA
      end
      local count = 0
      local max_pos = unit.position[1]
      for unit2 in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
        if not unit2.config.is_summoned and unit2 ~= unit and posA < unit2.position[1] and unit2.position[1] - posA < TitanSC.atk3max_position then
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

function TitanSC.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4b = caster.skills.TitanSC_atk4b
  local has_buff = false
  if target and target:isAlive() then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == TitanSC.TitanSC_atk2_BuffID then
        has_buff = true
      end
    end
  end
  if skillatk4b and has_buff and skill.attack_counter == 4 then
    skillatk4b:takeEffectAt(target.position, caster)
  end
  if TitanSC.TitanSC_fashion_id and TitanSC.TitanSC_fashion_id == caster.fashion_id and target then
    local skillatk3 = caster.skills.TitanSC_atk3
    local buff = skillatk3:createBuff(target)
    target:addBuff(buff, caster)
    if not caster.fashion_atk3Buff_count then
      caster.fashion_atk3Buff_count = 0
    end
    caster.fashion_atk3Buff_count = caster.fashion_atk3Buff_count + 1
  end
  return ret, dmg, Crit, lfs_amount
end

function TitanSC.skillult_takeEffectAt(basefunc, skill, location, source)
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

function TitanSC.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if target and target:isAlive() and caster.TitanSC_hasArcana > 2 then
    power = power * (target.TitanSC_powerR or 1)
    target.TitanSC_powerR = nil
  end
  return power, coeff
end

function TitanSC.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4276
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.timer = 3
  caster:addBuff(buff, caster)
end

function TitanSC.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == 4276 then
      buff.timer = 0
    end
  end
  if TitanSC.TitanSC_fashion_id and TitanSC.TitanSC_fashion_id == caster.fashion_id and caster.atk3_HPR and caster.fashion_atk3Buff_count and caster.fashion_atk3Buff_count >= 1 then
    local skillatk3 = caster.skills.TitanSC_atk3
    local HPR = caster.atk3_HPR * -1
    if HPR then
      local bid = TitanSC.fashion_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff:setAttribute("HPR", HPR * caster.fashion_atk3Buff_count)
      caster:addBuff(buff, caster)
      caster.fashion_atk3Buff_count = 0
    end
  end
end

function TitanSC.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 1 and ed.run_with_scene then
    if TitanSC.TitanSC_fashion_id and TitanSC.TitanSC_fashion_id == caster.fashion_id then
      ed.scene:playEffectOnScene("eff_point_TitanSC_skin_ult.cha", {400, 0}, {
        caster.direction,
        1
      }, nil, 1)
    else
      ed.scene:playEffectOnScene("eff_point_TitanSC_ult.cha", {400, 0}, {
        caster.direction,
        1
      }, nil, 1)
    end
  end
end

function TitanSC.init_hero(hero)
  local skillatk2 = hero.skills.TitanSC_atk2
  local skillatk3 = hero.skills.TitanSC_atk3
  local skillatk4 = hero.skills.TitanSC_atk4
  local skillatk4b = hero.skills.TitanSC_atk4b
  local skillult = hero.skills.TitanSC_ult
  hero.TitanSC_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanSC.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanSC.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.TitanSC_atk3affected = {}
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanSC.skillatk3_onAttackFrame)
    skillatk3.createTrackType = override(skillatk3.createTrackType, TitanSC.skillatk3_createTrackType)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, TitanSC.skillatk3_takeEffectAt)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanSC.skillatk3_createBuff)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanSC.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanSC.skillatk4_onAttackFrame)
    skillatk4.createTrackType = override(skillatk4.createTrackType, TitanSC.skillatk3_createTrackType)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanSC.skillatk4_takeEffectOn)
    skillatk4.start = override(skillatk4.start, TitanSC.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanSC.skillatk4_finish)
    skillatk4b.takeEffectOn = override(skillatk4b.takeEffectOn, TitanSC.skillatk4b_takeEffectOn)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanSC.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, TitanSC.skillult_takeEffectAt)
    skillult.power = override(skillult.power, TitanSC.skillult_power)
  end
  return hero
end

return TitanSC.init_hero
