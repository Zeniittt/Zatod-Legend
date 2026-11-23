module("ed.battlehero", package.seeall)
local ed = ed
TitanGang = {}
TitanGang.invulnerableBuff = 4440
TitanGang.ult_AttribBuff = 4458
TitanGang.TitanGang_fashionID = 101241
TitanGang.TitanGang_fashionSTR = 4568
TitanGang.TitanGang_fashionINT = 4569
TitanGang.TitanGang_fashionAGI = 4570

function TitanGang.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit, dmg = basefunc(skill, target, source, shift)
  local skillatk2 = caster.skills.TitanGang_atk2
  local atk2_BuffTime = skillatk2.info["Script Arg3"]
  if isHit then
    local bid = 4462
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
    local con_temp = 0
    if caster.attribs.CON then
      con_temp = caster.attribs.CON
    end
    if buff then
      if target.attribs.TEN then
        buff.timer = (buff.timer + atk2_BuffTime) * (1 - (target.attribs.TEN - con_temp) / 100)
      else
        buff.timer = atk2_BuffTime + buff.timer
      end
    end
  end
  return isHit, dmg
end

function TitanGang.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk2 = caster.skills.TitanGang_atk2
  local DownRatio = skillatk2.info["Script Arg2"] * 0.01
  local Caster_AD = caster.attribs.AD
  local Caster_STR = caster.attribs.STR
  if skillatk2 and owner and caster then
    if owner.config.is_monster or owner.config.is_boss then
      local AD = owner.attribs.AD
      buff:setAttribute("AD", -math.min(AD * DownRatio, Caster_AD))
    else
      local STR = owner.attribs.STR
      buff:setAttribute("STR", -math.min(STR * DownRatio, Caster_STR))
    end
  end
  if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == caster.fashion_id then
    local bid1 = TitanGang.TitanGang_fashionSTR
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    local buff1_Ratio = 0.1
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.info.ID == 10126 or unit.info.ID == 10127 or unit.info.ID == 10129 or unit.info.ID == 10130 or unit.info.ID == 10132 or unit.info.ID == 10133 or unit.info.ID == 10137 or unit.info.ID == 10138 or unit.info.ID == 10140 or unit.info.ID == 10141 then
        buff1_Ratio = buff1_Ratio + 0.1
      end
    end
    buff1_Ratio = math.min(buff1_Ratio, 0.4)
    buff1:setAttribute("STR", Caster_STR * 0.2 * (1 + buff1_Ratio))
    caster:addBuff(buff1)
    buff1.CreatedByHunterHunter = true
    buff1.timer = buff.timer
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanGang.skillatk2_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local target = skill.target
  local caster = skill.caster
  if caster then
    local Target_position = {
      caster.position[1],
      caster.position[2]
    }
    local minX = ed.engine.stage_rect.minX + 50
    local maxX = ed.engine.stage_rect.maxX - 50
    if minX <= Target_position[1] and maxX >= Target_position[1] then
      caster:setPosition({
        Target_position[1] + caster.direction * 10,
        Target_position[2]
      })
    elseif minX > Target_position[1] or maxX < Target_position[1] then
      caster:setPosition({
        Target_position[1] - caster.direction * 10,
        Target_position[2]
      })
    end
  end
end

function TitanGang.skillatk2s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk2s = caster.skills.TitanGang_atk2s
  if caster and skillatk2s then
    local invbid = TitanGang.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 0.5
    caster.TitanGang_invbuff = caster:addBuff(buff1, caster)
  end
end

function TitanGang.skillatk2s_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk2s = caster.skills.TitanGang_atk2s
  if caster and skillatk2s then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanGang.invulnerableBuff then
        tbuff.timer = -1
      end
    end
    if target then
      target:hurt()
    end
  end
end

function TitanGang.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk2s = caster.skills.TitanGang_atk2s
  local DownRatio = skillatk2s.info["Script Arg2"] * 0.01
  local Caster_AP = caster.attribs.AP
  local Caster_INT = caster.attribs.INT
  if skillatk2s and owner and caster then
    if owner.config.is_monster or owner.config.is_boss then
      local AP = owner.attribs.AP
      buff:setAttribute("AP", -math.min(AP * DownRatio, Caster_AP))
    else
      local INT = owner.attribs.INT
      buff:setAttribute("INT", -math.min(INT * DownRatio, Caster_INT))
    end
  end
  if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == caster.fashion_id then
    local bid1 = TitanGang.TitanGang_fashionINT
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    local buff1_Ratio = 0.1
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.info.ID == 10126 or unit.info.ID == 10127 or unit.info.ID == 10129 or unit.info.ID == 10130 or unit.info.ID == 10132 or unit.info.ID == 10133 or unit.info.ID == 10137 or unit.info.ID == 10138 or unit.info.ID == 10140 or unit.info.ID == 10141 then
        buff1_Ratio = buff1_Ratio + 0.1
      end
    end
    buff1_Ratio = math.min(buff1_Ratio, 0.4)
    buff1:setAttribute("INT", Caster_INT * 0.2 * (1 + buff1_Ratio))
    caster:addBuff(buff1)
    buff1.CreatedByHunterHunter = true
    buff1.timer = buff.timer
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanGang.skillatk2s_finish(basefunc, skill)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanGang.invulnerableBuff then
      tbuff.timer = -1
    end
  end
end

function TitanGang.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk3 = caster.skills.TitanGang_atk3
  local DownRatio = skillatk3.info["Script Arg2"] * 0.01
  local Caster_AP = caster.attribs.AP
  local Caster_AD = caster.attribs.AD
  local Caster_AGI = caster.attribs.AGI
  if skillatk3 and owner and caster then
    if owner.config.is_monster or owner.config.is_boss then
      local AD = owner.attribs.AD
      local AP = owner.attribs.AP
      buff:setAttribute("AP", -math.min(AP * DownRatio * 0.5, Caster_AP))
      buff:setAttribute("AD", -math.min(AD * DownRatio * 0.5, Caster_AD))
    else
      local AGI = owner.attribs.AGI
      buff:setAttribute("AGI", -math.min(AGI * DownRatio, Caster_AGI))
    end
    if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 4 then
      buff.timer = buff.timer + 4
    end
    if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == caster.fashion_id then
      local bid1 = TitanGang.TitanGang_fashionAGI
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = ed.BuffCreate(binfo1, caster, caster)
      local buff1_Ratio = 0.1
      for unit in ed.engine:foreachAliveUnit(caster.camp) do
        if unit.info.ID == 10126 or unit.info.ID == 10127 or unit.info.ID == 10129 or unit.info.ID == 10130 or unit.info.ID == 10132 or unit.info.ID == 10133 or unit.info.ID == 10137 or unit.info.ID == 10138 or unit.info.ID == 10140 or unit.info.ID == 10141 then
          buff1_Ratio = buff1_Ratio + 0.1
        end
      end
      buff1_Ratio = math.min(buff1_Ratio, 0.4)
      buff1:setAttribute("AGI", Caster_AGI * 0.2 * (1 + buff1_Ratio))
      caster:addBuff(buff1)
      buff1.CreatedByHunterHunter = true
      buff1.timer = buff.timer
    end
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanGang.skillatk3_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local target = skill.target
  local caster = skill.caster
  if target then
    local Target_position = {
      caster.position[1],
      caster.position[2]
    }
    local minX = ed.engine.stage_rect.minX + 50
    local maxX = ed.engine.stage_rect.maxX - 50
    if minX <= Target_position[1] and maxX >= Target_position[1] then
      caster:setPosition({
        Target_position[1] + caster.direction * 100,
        Target_position[2]
      })
    elseif minX > Target_position[1] or maxX < Target_position[1] then
      caster:setPosition({
        Target_position[1] - caster.direction * 100,
        Target_position[2]
      })
    end
  end
end

function TitanGang.skillatk3s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3s = caster.skills.TitanGang_atk3s
  if caster and skillatk3s then
    local invbid = TitanGang.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 1.5
    caster.TitanGang_invbuff = caster:addBuff(buff1, caster)
  end
end

function TitanGang.skillatk3s_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.TitanGang_atk3s
  if caster and skillatk3s then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanGang.invulnerableBuff then
        tbuff.timer = -1
      end
    end
  end
end

function TitanGang.skillatk3s_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit, dmg = basefunc(skill, target, source, shift)
  local skillatk3 = caster.skills.TitanGang_atk3
  local atk3_BuffTime = skillatk3.info["Script Arg3"]
  local bid = 4462
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, caster)
  local con_temp = 0
  if caster.attribs.CON then
    con_temp = caster.attribs.CON
  end
  if buff then
    if target.attribs.TEN then
      buff.timer = (buff.timer + atk3_BuffTime) * (1 - (target.attribs.TEN - con_temp) / 100)
    else
      buff.timer = atk3_BuffTime + buff.timer
    end
  end
  return isHit, dmg
end

function TitanGang.skillatk3s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk3s = caster.skills.TitanGang_atk3s
  local DownRatio = skillatk3s.info["Script Arg2"] * 0.01
  local Caster_AP = caster.attribs.AP
  local Caster_AD = caster.attribs.AD
  local Caster_AGI = caster.attribs.AGI
  if skillatk3s and owner and caster then
    if owner.config.is_monster or owner.config.is_boss then
      local AD = owner.attribs.AD
      local AP = owner.attribs.AP
      buff:setAttribute("AP", -math.min(AP * DownRatio * 0.5, Caster_AP))
      buff:setAttribute("AD", -math.min(AD * DownRatio * 0.5, Caster_AD))
    else
      local AGI = owner.attribs.AGI
      buff:setAttribute("AGI", -math.min(AGI * DownRatio, Caster_AGI))
    end
  end
  if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == caster.fashion_id then
    local bid1 = TitanGang.TitanGang_fashionAGI
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    local buff1_Ratio = 0.1
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.info.ID == 10126 or unit.info.ID == 10127 or unit.info.ID == 10129 or unit.info.ID == 10130 or unit.info.ID == 10132 or unit.info.ID == 10133 or unit.info.ID == 10137 or unit.info.ID == 10138 or unit.info.ID == 10140 or unit.info.ID == 10141 then
        buff1_Ratio = buff1_Ratio + 0.1
      end
    end
    buff1_Ratio = math.min(buff1_Ratio, 0.4)
    buff1:setAttribute("AGI", Caster_AGI * 0.2 * (1 + buff1_Ratio))
    caster:addBuff(buff1)
    buff1.CreatedByHunterHunter = true
    buff1.timer = buff.timer
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanGang.skillatk3s_finish(basefunc, skill)
  basefunc(skill)
  local target = skill.target
  local caster = skill.caster
  if target then
    local Target_position = {
      caster.position[1],
      caster.position[2]
    }
    local minX = ed.engine.stage_rect.minX + 50
    local maxX = ed.engine.stage_rect.maxX - 50
    if minX <= Target_position[1] and maxX >= Target_position[1] then
      caster:setPosition({
        Target_position[1] + caster.direction * 50,
        Target_position[2]
      })
    elseif minX > Target_position[1] or maxX < Target_position[1] then
      caster:setPosition({
        Target_position[1] - caster.direction * 50,
        Target_position[2]
      })
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanGang.invulnerableBuff then
      tbuff.timer = -1
    end
  end
end

function TitanGang.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.TitanIron_atk3_projectile = projectile
  projectile.height = 50
  projectile.hit = override(projectile.hit, TitanGang.skillatk4_projectile_hit)
  return projectile
end

function TitanGang.skillatk4_projectile_hit(basefunc, projectile, target)
  basefunc(projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target == skill.target then
    target:hurt()
    projectile:terminate()
  end
end

function TitanGang.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk4 = caster.skills.TitanGang_atk4
  local DownRatio = skillatk4.info["Script Arg2"] * 0.01
  local Caster_AP = caster.attribs.AP
  local Caster_INT = caster.attribs.INT
  if skillatk4 and owner and caster then
    if owner.config.is_monster or owner.config.is_boss then
      local AD = owner.attribs.AP
      buff:setAttribute("AP", -math.min(AD * DownRatio, Caster_AP))
    else
      local INT = owner.attribs.INT
      buff:setAttribute("INT", -math.min(INT * DownRatio, Caster_INT))
    end
  end
  if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == caster.fashion_id then
    local bid1 = TitanGang.TitanGang_fashionINT
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    local buff1_Ratio = 0.1
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.info.ID == 10126 or unit.info.ID == 10127 or unit.info.ID == 10129 or unit.info.ID == 10130 or unit.info.ID == 10132 or unit.info.ID == 10133 or unit.info.ID == 10137 or unit.info.ID == 10138 or unit.info.ID == 10140 or unit.info.ID == 10141 then
        buff1_Ratio = buff1_Ratio + 0.1
      end
    end
    buff1_Ratio = math.min(buff1_Ratio, 0.4)
    buff1:setAttribute("INT", Caster_INT * 0.2 * (1 + buff1_Ratio))
    caster:addBuff(buff1)
    buff1.CreatedByHunterHunter = true
    buff1.timer = buff.timer
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanGang.skillatk4s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4s = caster.skills.TitanGang_atk4s
  if caster and skillatk4s then
    local invbid = TitanGang.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 2.3
    caster.TitanGang_invbuff = caster:addBuff(buff1, caster)
  end
end

function TitanGang.skillatk4s_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4s = caster.skills.TitanGang_atk4s
  if caster and skillatk4s then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanGang.invulnerableBuff then
        tbuff.timer = -1
      end
    end
  end
end

function TitanGang.skillatk4s_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit, dmg = basefunc(skill, target, source, shift)
  local bid = 4463
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, caster)
  local con_temp = 0
  local skillatk4 = caster.skills.TitanGang_atk3
  local atk4_BuffTime = skillatk4.info["Script Arg3"]
  if buff then
    buff.timer = atk4_BuffTime + buff.timer
  end
  return isHit, dmg
end

function TitanGang.skillatk4s_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk4s = caster.skills.TitanGang_atk4s
  local DownRatio = skillatk4s.info["Script Arg2"] * 0.01
  local Caster_AD = caster.attribs.AD
  local Caster_STR = caster.attribs.STR
  if skillatk4s and owner and caster then
    if owner.config.is_monster or owner.config.is_boss then
      local AD = owner.attribs.AD
      buff:setAttribute("AD", -math.min(AD * DownRatio, Caster_AD))
    else
      local STR = owner.attribs.STR
      buff:setAttribute("STR", -math.min(STR * DownRatio, Caster_STR))
    end
    if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 4 then
      buff.timer = buff.timer + 4
    end
    if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == caster.fashion_id then
      local bid1 = TitanGang.TitanGang_fashionSTR
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = ed.BuffCreate(binfo1, caster, caster)
      local buff1_Ratio = 0.1
      for unit in ed.engine:foreachAliveUnit(caster.camp) do
        if unit.info.ID == 10126 or unit.info.ID == 10127 or unit.info.ID == 10129 or unit.info.ID == 10130 or unit.info.ID == 10132 or unit.info.ID == 10133 or unit.info.ID == 10137 or unit.info.ID == 10138 or unit.info.ID == 10140 or unit.info.ID == 10141 then
          buff1_Ratio = buff1_Ratio + 0.1
        end
      end
      buff1_Ratio = math.min(buff1_Ratio, 0.5)
      buff1:setAttribute("STR", Caster_STR * 0.2 * (1 + buff1_Ratio))
      caster:addBuff(buff1)
      buff1.CreatedByHunterHunter = true
      buff1.timer = buff.timer
    end
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanGang.skillatk4s_finish(basefunc, skill)
  basefunc(skill)
  local target = skill.target
  local caster = skill.caster
  if target then
    local Target_position = {
      caster.position[1],
      caster.position[2]
    }
    local minX = ed.engine.stage_rect.minX + 50
    local maxX = ed.engine.stage_rect.maxX - 50
    if minX <= Target_position[1] and maxX >= Target_position[1] then
      caster:setPosition({
        Target_position[1] + caster.direction * 50,
        Target_position[2]
      })
    elseif minX > Target_position[1] or maxX < Target_position[1] then
      caster:setPosition({
        Target_position[1] - caster.direction * 50,
        Target_position[2]
      })
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanGang.invulnerableBuff then
      tbuff.timer = -1
    end
  end
end

function TitanGang.ult_func_hideBuffEffect(unit)
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

function TitanGang.ult_func_resetBuffEffect(unit)
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

function TitanGang.ult_func_NormalChangeToAngry(unit)
  if not (unit:isNormal() and unit:isAlive()) or unit.name ~= "TitanGang" then
    return
  end
  unit:enterActionStageFromOneStage(unit:getAngryPeriod(), 10124)
  unit.isAngry = true
  local bid1 = TitanGang.ult_AttribBuff
  local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
  local buff1 = ed.BuffCreate(binfo1, unit, unit)
  local skillult = unit.skills.TitanGang_ult
  local AttribsUP = skillult.info["Script Arg2"] / 100
  if unit.name == "TitanGang" and not unit.config.is_summoned and not unit.config.is_boss and unit:isAlive() then
    buff1:setAttribute("HP", unit.attribs.HP * AttribsUP)
    buff1:setAttribute("STR", unit.attribs.STR * AttribsUP)
    buff1:setAttribute("AGI", unit.attribs.AGI * AttribsUP)
    buff1:setAttribute("INT", unit.attribs.INT * AttribsUP)
    buff1:setAttribute("AD", unit.attribs.AD * AttribsUP)
    buff1:setAttribute("ARM", unit.attribs.ARM * AttribsUP)
    buff1:setAttribute("MR", unit.attribs.MR * AttribsUP)
    buff1:setAttribute("HIT", unit.attribs.HIT * AttribsUP)
    buff1:setAttribute("DODG", unit.attribs.DODG * AttribsUP)
    buff1:setAttribute("ARMP", unit.attribs.ARMP * AttribsUP)
  end
  buff1.CreatedByHunterHunter = true
  unit:addBuff(buff1, unit)
  local bid2 = 4461
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = ed.BuffCreate(binfo2, unit, unit)
  local SpeedUP = skillult.info["Script Arg3"] + 20
  local SpeedUP_time = skillult.info["Script Arg4"] + 5
  if unit.name == "TitanGang" and not unit.config.is_summoned and not unit.config.is_boss and unit:isAlive() then
    buff2:setAttribute("MSPD", SpeedUP)
    buff2:setAttribute("HAST", SpeedUP)
    buff2.timer = SpeedUP_time
  end
  buff2.CreatedByHunterHunter = true
  unit:addBuff(buff2, unit)
  if not unit.config.is_summoned and not unit.config.is_boss then
    unit:takeHeal(unit.attribs.HP, "hp", unit)
  end
  unit.TitanGangAngryBuff = buff1
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
end

function TitanGang.ult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if not caster:isNormal() then
    return false, "Already Angry"
  end
  if caster.canCastUlt == false then
    return false, "TitanGang_Ult Casting"
  end
  return basefunc(skill, target)
end

function TitanGang.ult_start(basefunc, skill, default)
  local caster = skill.caster
  caster.TitanGang_ultCasting = true
  local binfo = ed.lookupDataTable("Buff", nil, TitanGang.invulnerableBuff)
  local buff = caster:addBuff(binfo, caster)
  buff.timer = 5
  skill.TitanGang_invulnerableBuff = buff
  caster.canCastUlt = false
  if caster:isNormal() then
    skill.changeMode = "NtoA"
  end
  TitanGang.ult_func_hideBuffEffect(caster)
  basefunc(skill, default)
end

function TitanGang.ult_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function TitanGang.ult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 2 then
    local skillults = caster.skills.TitanGang_ults
    if skillults then
      skillults:takeEffectAt(caster.position)
    end
  end
  basefunc(skill)
end

function TitanGang.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function TitanGang.ult_finish(basefunc, skill, reaseon)
  basefunc(skill, reaseon)
  local caster = skill.caster
  caster.TitanGang_ultCasting = false
  if skill.TitanGang_invulnerableBuff then
    skill.TitanGang_invulnerableBuff.timer = -1
    skill.TitanGang_invulnerableBuff = nil
  end
  if skill.changeMode == "NtoA" and caster:isNormal() then
    TitanGang.ult_func_NormalChangeToAngry(caster)
  end
  skill.changeMode = nil
  caster.canCastUlt = true
  TitanGang.ult_func_resetBuffEffect(caster)
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "TitanGang" and caster.currentActionStage == 2 then
      panel:setPortrait("UI/DOTA-HERO/TitanGang2.png")
    end
  end
end

function TitanGang.skills_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local Power_up = 0
  if caster.TitanGang_hasArcana and caster.TitanGang_hasArcana >= 3 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter then
        local STR_down = tbuff.info.STR
        local AGI_down = tbuff.info.AGI
        local INT_down = tbuff.info.INT
        local AD_down = tbuff.info.AD
        local AP_down = tbuff.info.AP
        if STR_down and STR_down < 0 then
          Power_up = Power_up + 0.1
        end
        if AGI_down and AGI_down < 0 then
          Power_up = Power_up + 0.1
        end
        if INT_down and INT_down < 0 then
          Power_up = Power_up + 0.1
        end
        if AD_down and AD_down < 0 then
          Power_up = Power_up + 0.1
        end
        if AP_down and AP_down < 0 then
          Power_up = Power_up + 0.1
        end
      end
    end
    power = power * (1 + Power_up)
  end
  return power, coeff
end

function TitanGang.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.TitanGang_ult
  local skillatk2 = hero.skills.TitanGang_atk2
  local skillatk3 = hero.skills.TitanGang_atk3
  local skillatk4 = hero.skills.TitanGang_atk4
  if (hero.currentActionStage == 1 or hero.currentActionStage == 3) and hero.TitanGang_hasArcana >= 2 and hero.TitanGang_ultCasting == false and hero.hp <= hero.attribs.HP * 0.15 then
    for _, buff in ipairs(hero.buff_list) do
      local willBeRemove = buff:isCrlEftConflictWithUncontrollable() or ed.isElementInTable("derangedOwner", buff.info["Control Effects"]) or ed.isElementInTable("enchantedbyself", buff.info["Control Effects"]) or ed.isElementInTable("stunbyself", buff.info["Control Effects"])
      if willBeRemove then
        buff.timer = -1
        if buff.owner then
          buff.owner:hurt()
        end
      end
    end
    hero:castSkill(skillult, hero)
  end
  if hero.currentActionStage == 2 and hero.isAngry == true then
    hero.mp = 0
  end
  if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == hero.fashion_id and not hero.has_SkinHastBuff then
    local bid = 4571
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
    hero.has_SkinHastBuff = true
    buff.CreatedByHunterHunter = true
  end
end

function TitanGang.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.isAngry = false
  hero.TitanGang_ultCasting = false
  hero.canCastUlt = true
  hero:enterActionStageFromOneStage(hero:getNormalPeriod(), 10124)
  if ed.run_with_scene then
    local panel = hero.heroPanel
    if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == hero.fashion_id then
      if panel and hero.name == "TitanGang" then
        panel:setPortrait("UI/DOTA-HERO/TitanGang_skin.png")
      end
    elseif panel and hero.name == "TitanGang" then
      panel:setPortrait("UI/DOTA-HERO/TitanGang.png")
    end
  end
end

function TitanGang.collectMPchange(basefunc, self, config)
  local unit = self
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4458 then
      unit.mp = 0
    end
  end
end

function TitanGang.init_hero(hero)
  hero.TitanGang_ultCasting = false
  hero.isAngry = false
  hero.reset = override(hero.reset, TitanGang.hero_reset)
  hero.update = override(hero.update, TitanGang.hero_update)
  hero.TitanGang_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.TitanGang_ult
  local skillults = hero.skills.TitanGang_ults
  local skillatk = hero.skills.TitanGang_atk
  local skillatks = hero.skills.TitanGang_atks
  local skillatk2 = hero.skills.TitanGang_atk2
  local skillatk2s = hero.skills.TitanGang_atk2s
  local skillatk3 = hero.skills.TitanGang_atk3
  local skillatk3s = hero.skills.TitanGang_atk3s
  local skillatk4 = hero.skills.TitanGang_atk4
  local skillatk4s = hero.skills.TitanGang_atk4s
  if hero.name == "TitanGang" then
    hero:setActionStageChangeByManual(true)
  end
  if skillult and not hero.config.is_summoned and hero.name == "TitanGang" then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanGang.ult_canCastWithTarget)
    skillult.start = override(skillult.start, TitanGang.ult_start)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, TitanGang.ult_onPhaseFinished)
    skillult.finish = override(skillult.finish, TitanGang.ult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanGang.ult_onAttackFrame)
  end
  if skillults and hero.name == "TitanGang" then
    skillults.createBuff = override(skillults.createBuff, TitanGang.skillults_createBuff)
  end
  if skillatk2 and hero.name == "TitanGang" then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanGang.skillatk2_createBuff)
    skillatk2.finish = override(skillatk2.finish, TitanGang.skillatk2_finish)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanGang.skillatk2_takeEffectOn)
  end
  if skillatk2s and hero.name == "TitanGang" then
    skillatk2s.start = override(skillatk2s.start, TitanGang.skillatk2s_start)
    skillatk2s.onAttackFrame = override(skillatk2s.onAttackFrame, TitanGang.skillatk2s_onAttackFrame)
    skillatk2s.createBuff = override(skillatk2s.createBuff, TitanGang.skillatk2s_createBuff)
    skillatk2s.finish = override(skillatk2s.finish, TitanGang.skillatk2s_finish)
  end
  if skillatk3 and hero.name == "TitanGang" then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanGang.skillatk3_createBuff)
    skillatk3.finish = override(skillatk3.finish, TitanGang.skillatk3_finish)
  end
  if skillatk3s and hero.name == "TitanGang" then
    skillatk3s.start = override(skillatk3s.start, TitanGang.skillatk3s_start)
    skillatk3s.onAttackFrame = override(skillatk3s.onAttackFrame, TitanGang.skillatk3s_onAttackFrame)
    skillatk3s.takeEffectOn = override(skillatk3s.takeEffectOn, TitanGang.skillatk3s_takeEffectOn)
    skillatk3s.createBuff = override(skillatk3s.createBuff, TitanGang.skillatk3s_createBuff)
    skillatk3s.finish = override(skillatk3s.finish, TitanGang.skillatk3s_finish)
  end
  if skillatk4 and hero.name == "TitanGang" then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanGang.skillatk4_CreateBuff)
    skillatk4.createProjectile = override(skillatk4.createProjectile, TitanGang.skillatk4_createProjectile)
  end
  if skillatk4s and hero.name == "TitanGang" then
    skillatk4s.start = override(skillatk4s.start, TitanGang.skillatk4s_start)
    skillatk4s.onAttackFrame = override(skillatk4s.onAttackFrame, TitanGang.skillatk4s_onAttackFrame)
    skillatk4s.takeEffectOn = override(skillatk4s.takeEffectOn, TitanGang.skillatk4s_takeEffectOn)
    skillatk4s.createBuff = override(skillatk4s.createBuff, TitanGang.skillatk4s_CreateBuff)
    skillatk4s.finish = override(skillatk4s.finish, TitanGang.skillatk4s_finish)
  end
  local skillnames = {
    "_atk2",
    "_atk3",
    "_atk4",
    "_atk2s",
    "_atk3s",
    "_atk4s"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["TitanGang" .. skillnames[i]]
    if skill then
      skill.power = override(skill.power, TitanGang.skills_power)
    end
  end
  
  function hero.getNormalPeriod(unit)
    local period = 1
    if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == hero.fashion_id then
      period = 3
    else
      period = 1
    end
    return period
  end
  
  function hero.getAngryPeriod(unit)
    local period = 2
    return period
  end
  
  function hero.isNormal(unit)
    if TitanGang.TitanGang_fashionID and TitanGang.TitanGang_fashionID == hero.fashion_id then
      local current = unit.currentActionStage or 3
      if current == 2 then
        return false
      end
      return true
    else
      local current = unit.currentActionStage or 1
      if current == 2 then
        return false
      end
      return true
    end
  end
  
  function hero.isAngry(unit)
    local current = unit.currentActionStage or 2
    if current == 1 or current == 3 then
      return false
    end
    return true
  end
  
  ed.PreloadPuppetRcs("TitanGang")
  ed.PreloadPuppetRcs("TitanGang_skin")
  return hero
end

return TitanGang.init_hero
