module("ed.battlehero", package.seeall)
local ed = ed
GMBOSSTitanPA = {}
GMBOSSTitanPA.ult_invulnerableBuff = 1611
GMBOSSTitanPA.ult_uncontrollableBuff = 1612
GMBOSSTitanPA.GMBOSSTitanPA_HPratio = 1000000

function GMBOSSTitanPA.skillatk_INT_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skillatk2 = caster.skills.GMBOSSTitanPA_atk2
  local power2 = power
  if skillatk2 and caster.atk2_isFinish == true then
    local Ratio_num = skillatk2.info["Script Arg2"]
    local INT_Ratio = target.attribs.INT * Ratio_num
    if caster.GMBOSSTitanPA_hasArcana > 3 then
      INT_Ratio = INT_Ratio * 2
    end
    power2 = power2 + INT_Ratio
  end
  local dmg = target:takeDamage({
    amount = power2,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function GMBOSSTitanPA.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  if lost > GMBOSSTitanPA.GMBOSSTitanPA_HPratio then
    lost = GMBOSSTitanPA.GMBOSSTitanPA_HPratio
  end
  return lost
end

function GMBOSSTitanPA.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1610
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onDamaged = override(buff.onDamaged, GMBOSSTitanPA.atk2_MissbuffonDamaged)
  caster.atk2_isFinish = false
  buff.timer = 3
  caster.atk2_Missbuff = caster:addBuff(buff, caster)
end

function GMBOSSTitanPA.atk2_MissbuffonDamaged(basefunc, buff, damage, damage_type)
  local caster = buff.caster
  local info = buff.info
  local owner = buff.owner
  if damage and damage_type then
    if damage <= 0 then
      return 0
    else
      damage = 0
      return 0
    end
  end
  return basefunc(buff, damage, damage_type)
end

function GMBOSSTitanPA.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.GMBOSSTitanPA_atk2
  local target = skill.target
  local protal_pos
  local minX = ed.engine.stage_rect.minX + 50
  local maxX = ed.engine.stage_rect.maxX - 50
  if target then
    protal_pos = {
      target.position[1],
      target.position[2]
    }
  else
    local MaxINTUnit
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit and not unit.buff_effects.invisible and unit:isHero() then
        local unitInt = unit.attribs.INT
        local MaxINT = 0
        if unitInt > MaxINT then
          MaxINT = unitInt
          MaxINTUnit = unit
        end
      end
    end
    if MaxINTUnit then
      protal_pos = {
        MaxINTUnit.position[1],
        MaxINTUnit.position[2]
      }
    else
      protal_pos = {
        caster.position[1],
        caster.position[2]
      }
    end
  end
  if skill.attack_counter == 1 then
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, caster.position, {
          caster.direction * 1.1,
          1
        }, nil, 1)
      end
    end
    if minX <= protal_pos[1] and maxX >= protal_pos[1] then
      caster:setPosition({
        protal_pos[1] + caster.direction * 40,
        protal_pos[2]
      })
    elseif minX > protal_pos[1] or maxX < protal_pos[1] then
      caster:setPosition({
        protal_pos[1] - caster.direction * 40,
        protal_pos[2]
      })
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, caster.position, {
          caster.direction * 1.1,
          1
        }, nil, 1)
      end
    end
  end
end

function GMBOSSTitanPA.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local bid = 1613
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  local Buff_Time = skill.info["Script Arg3"]
  buff.update = override(buff.update, GMBOSSTitanPA.skillatk2_finishBuff_update)
  buff.onRemoved = override(buff.onRemoved, GMBOSSTitanPA.skillatk2_finishBuff_onRemoved)
  buff.timer = buff.timer + Buff_Time + (caster.GMBOSSTitanPA_hasArcana > 3 and 2 or 0)
  caster.atk2_buff = caster:addBuff(buff, caster)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1610 then
      tbuff.timer = -1
    end
  end
  if caster.GMBOSSTitanPA_hasArcana > 2 then
    local binfo_arcana = ed.lookupDataTable("Buff", nil, 1688)
    local buff_arcana = ed.BuffCreate(binfo_arcana, caster, caster)
    caster:addBuff(buff_arcana, caster)
  end
end

function GMBOSSTitanPA.skillatk2_finishBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  caster.atk2_isFinish = true
end

function GMBOSSTitanPA.skillatk2_finishBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  caster.atk2_isFinish = false
end

function GMBOSSTitanPA.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.GMBOSSTitanPA_atk3
  local GMBOSSTitanPA_atk3_mp = skillatk3.info["Gain MP"]
  local attack_counter = skill.attack_counter
  if skill.attack_counter == 0 then
    caster:setMP(caster.mp + GMBOSSTitanPA_atk3_mp)
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanPA_atk3.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, caster.position, {
          0.8 * caster.direction,
          0.8
        }, nil, 1)
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter == 1 then
    skillatk3:takeEffectAt(caster.position, caster)
  end
end

function GMBOSSTitanPA.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.GMBOSSTitanPA_atk4
  local atk4_BuffTime = caster.attribs.AGI / 5000
  if skillatk4 and caster.name == "GMBOSSTitanPA" then
    local con_temp = 0
    if caster.attribs.CON then
      con_temp = caster.attribs.CON
    end
    if buff then
      if caster.attribs.TEN then
        buff.timer = buff.timer + atk4_BuffTime * (1 - (caster.attribs.TEN - con_temp) / 100)
      else
        buff.timer = atk4_BuffTime + buff.timer
      end
    end
  end
  return buff
end

function GMBOSSTitanPA.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local APdown = skill.info["Script Arg2"]
  local APdown_buffTime = skill.info["Script Arg3"]
  local APdown_Time = caster.attribs.AGI / 3000
  local minunit
  local mindis = 9999
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.buff_effects.invulnerable and not unit.config.is_summoned then
      local unitDistance = ed.edpDistanceSQ(unit.position, caster.position) ^ 0.5
      if mindis > unitDistance then
        mindis = unitDistance
        minunit = unit
      end
    end
  end
  if skill.attack_counter == 1 and minunit then
    local bid = 1614
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, minunit, caster)
    local GMBOSSTitanPA_APdown = caster.attribs.AD
    buff:setAttribute("AP", -GMBOSSTitanPA_APdown * APdown)
    buff.timer = buff.timer + APdown_Time + APdown_buffTime
    minunit:hurt()
    minunit:addBuff(buff, caster)
  end
end

function GMBOSSTitanPA.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    return {400, 0}
  end
end

function GMBOSSTitanPA.ult_func_hideBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
end

function GMBOSSTitanPA.ult_func_resetBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(true)
      end
    end
  end
end

function GMBOSSTitanPA.ult_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, GMBOSSTitanPA.ult_invulnerableBuff)
  local buff = caster:addBuff(binfo, caster)
  buff.timer = 1.25
  caster.GMBOSSTitanPA_invulnerableBuff = buff
  GMBOSSTitanPA.ult_func_hideBuffEffect(caster)
end

function GMBOSSTitanPA.ult_onPhaseFinished(basefunc, skill)
  local currentPhase = skill.current_phase_idx
  local caster = skill.caster
  local skillulta = caster.skills.GMBOSSTitanPA_ulta
  local target = skill.target
  if currentPhase == 1 then
    local PortalPosition = GMBOSSTitanPA.DOP_in_battlefield(caster, 80, caster.foecamp)
    if PortalPosition then
      caster.ultPosition = {
        PortalPosition[1],
        PortalPosition[2]
      }
      caster:setPosition({
        PortalPosition[1],
        PortalPosition[2]
      })
    end
    skill:startPhase(2)
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 1611 then
        tbuff.timer = -1
      end
    end
  elseif currentPhase == 2 then
    local binfo = ed.lookupDataTable("Buff", nil, GMBOSSTitanPA.ult_uncontrollableBuff)
    local buff = caster:addBuff(binfo, caster)
    buff.timer = 2
    caster.GMBOSSTitanPA_uncontrollableBuff = buff
    if skillulta then
      skillulta:takeEffectAt(caster.ultPosition, caster)
    end
    skill:startPhase(3)
  elseif currentPhase == 3 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 1612 then
        tbuff.timer = -1
      end
    end
    local binfo = ed.lookupDataTable("Buff", nil, GMBOSSTitanPA.ult_invulnerableBuff)
    local buff = caster:addBuff(binfo, caster)
    buff = 1.5
    caster.GMBOSSTitanPA_invulnerableBuff = buff
    skill:finish()
  end
end

function GMBOSSTitanPA.ult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local currentPhase = skill.current_phase_idx
  local caster = skill.caster
  local skillulta = caster.skills.GMBOSSTitanPA_ulta
  local skillultb = caster.skills.GMBOSSTitanPA_ultb
  local skillultc = caster.skills.GMBOSSTitanPA_ultc
  if currentPhase == 1 then
    if skill.attack_counter == 1 and skillulta then
      skillulta:takeEffectAt(caster.ultPosition, caster)
    end
  elseif currentPhase == 2 then
    if skill.attack_counter == 2 then
      if skillultb then
        local target = skillultb:selectTarget()
        if target then
          skillultb:takeEffectOn(target, caster)
        end
      end
    elseif skill.attack_counter == 3 then
      if skillultb then
        local target = skillultb:selectTarget()
        if target then
          skillultb:takeEffectOn(target, caster)
        end
      end
    elseif skill.attack_counter == 4 then
      if skillultb then
        local target = skillultb:selectTarget()
        if target then
          skillultb:takeEffectOn(target, caster)
        end
      end
    elseif skill.attack_counter == 5 then
      if skillultb then
        local target = skillultb:selectTarget()
        if target then
          skillultb:takeEffectOn(target, caster)
        end
      end
    elseif skill.attack_counter == 6 then
      if skillultb then
        local target = skillultb:selectTarget()
        if target then
          skillultb:takeEffectOn(target, caster)
        end
      end
    elseif skill.attack_counter == 7 and skillultb then
      local targetb = skillultb:selectTarget()
      if targetb then
        skillultb:takeEffectOn(targetb, caster)
      end
      local targetc = skillultc:selectTarget()
      if targetc then
        local ult_back_position = {
          targetc.position[1],
          targetc.position[2]
        }
        caster:setPosition({
          ult_back_position[1] - 100 * caster.direction,
          ult_back_position[2]
        })
      end
    end
  elseif currentPhase == 3 then
    if skill.attack_counter == 8 then
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanPA_ult.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, caster.ultPosition, {
            0.8 * caster.direction,
            0.8
          }, nil, 1)
        end
      end
    elseif skill.attack_counter == 9 and skillultc then
      local target = skillultc:selectTarget()
      if target then
        skillultc:takeEffectOn(target, caster)
      end
      caster.GMBOSSTitanPA_ultcTarget = target
      for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
        if unit and not unit.buff_effects.invisible and unit:isAlive() then
          local bid = 1615
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit, caster)
          local Buff_Time = skillultc.info["Script Arg2"]
          local con_temp = 0
          local silbuff = unit:addBuff(buff, caster)
          if caster.attribs.CON then
            con_temp = caster.attribs.CON
          end
          if silbuff then
            if unit.attribs.TEN then
              silbuff.timer = silbuff.timer + Buff_Time * (1 - (unit.attribs.TEN - con_temp) / 100)
            else
              silbuff.timer = silbuff.timer + Buff_Time
            end
          end
        end
      end
    end
  end
end

function GMBOSSTitanPA.ult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  GMBOSSTitanPA.ult_func_resetBuffEffect(caster)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1611 then
      tbuff.timer = -1
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1612 then
      tbuff.timer = -1
    end
  end
end

function GMBOSSTitanPA.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function GMBOSSTitanPA.hero_die(basefunc, hero)
  basefunc(hero)
end

function GMBOSSTitanPA.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk2_isFinish = false
  local skillenter = hero.skills.GMBOSSTitanPA_enter
  if skillenter then
    local dir = hero:getInitDir()
    hero:setPosition({
      400 - 165.5 * dir,
      0
    })
    local bid = 651
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero.enter_buff = hero:addBuff(binfo, hero)
  end
  local skillatk2 = hero.skills.GMBOSSTitanPA_atk2
  local skillatk3 = hero.skills.GMBOSSTitanPA_atk3
  local skillatk4 = hero.skills.GMBOSSTitanPA_atk4
  if hero.GMBOSSTitanPA_hasArcana > 1 and skillatk3 and skillatk4 then
    local skillatk3_originfo = skillatk3.info
    local skillatk4_originfo = skillatk4.info
    skillatk3.info = ed.wraptable(skillatk3_originfo, {
      ["Max Range"] = 135,
      ["Shape Arg1"] = 140
    })
    skillatk4.info = ed.wraptable(skillatk4_originfo, {
      ["Max Range"] = 155,
      ["Shape Arg1"] = 160
    })
  end
  if hero.GMBOSSTitanPA_hasArcana > 2 and skillatk2 then
    skillatk2.cd_remaining = 1.5
  end
end

function GMBOSSTitanPA.skillenter_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if caster.hasEnter == true then
    return false, "GMBOSSTitanPA_Enter already played"
  end
  return result
end

function GMBOSSTitanPA.skillenter_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = -1
    end
  end
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.hasEnter = true
end

function GMBOSSTitanPA.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = -1
    end
  end
end

function GMBOSSTitanPA.init_hero(hero)
  hero.hasEnter = false
  hero.reset = override(hero.reset, GMBOSSTitanPA.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, GMBOSSTitanPA.hero_getLostHPAfterImmunity)
  local skillenter = hero.skills.GMBOSSTitanPA_enter
  local skillatk = hero.skills.GMBOSSTitanPA_atk
  local skillatk2 = hero.skills.GMBOSSTitanPA_atk2
  local skillatk3 = hero.skills.GMBOSSTitanPA_atk3
  local skillatk4 = hero.skills.GMBOSSTitanPA_atk4
  local skillult = hero.skills.GMBOSSTitanPA_ult
  local skillulta = hero.skills.GMBOSSTitanPA_ulta
  local skillultb = hero.skills.GMBOSSTitanPA_ultb
  local skillultc = hero.skills.GMBOSSTitanPA_ultc
  hero.GMBOSSTitanPA_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillenter then
    skillenter.start = override(skillenter.start, GMBOSSTitanPA.skillenter_start)
    skillenter.finish = override(skillenter.finish, GMBOSSTitanPA.skillenter_finish)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, GMBOSSTitanPA.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, GMBOSSTitanPA.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, GMBOSSTitanPA.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, GMBOSSTitanPA.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, GMBOSSTitanPA.skillatk4_createBuff)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, GMBOSSTitanPA.skillatk4_onAttackFrame)
  end
  if skillult then
    skillult.start = override(skillult.start, GMBOSSTitanPA.ult_start)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, GMBOSSTitanPA.ult_onPhaseFinished)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GMBOSSTitanPA.ult_onAttackFrame)
    skillult.finish = override(skillult.finish, GMBOSSTitanPA.ult_finish)
  end
  local skillnames = {
    "_atk",
    "_atk3",
    "_atk4",
    "_ulta",
    "_ultb",
    "_ultc"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["GMBOSSTitanPA" .. skillnames[i]]
    if skill then
      skill.getDamage = override(skill.getDamage, GMBOSSTitanPA.skillatk_INT_getDamage)
    end
  end
  return hero
end

return GMBOSSTitanPA.init_hero
