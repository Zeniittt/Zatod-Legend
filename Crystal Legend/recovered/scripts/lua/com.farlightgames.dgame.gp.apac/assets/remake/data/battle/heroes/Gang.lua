module("ed.battlehero", package.seeall)
local ed = ed
Gang = {}
Gang.invulnerableBuff = 4440
Gang.ult_AttribBuff = 4458

function Gang.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit, dmg = basefunc(skill, target, source, shift)
  local skillatk2 = caster.skills.Gang_atk2
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

function Gang.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk2 = caster.skills.Gang_atk2
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
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function Gang.skillatk2_finish(basefunc, skill, reason)
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

function Gang.skillatk2s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk2s = caster.skills.Gang_atk2s
  if caster and skillatk2s then
    local invbid = Gang.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 0.5
    caster.Gang_invbuff = caster:addBuff(buff1, caster)
  end
end

function Gang.skillatk2s_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk2s = caster.skills.Gang_atk2s
  if caster and skillatk2s then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Gang.invulnerableBuff then
        tbuff.timer = -1
      end
    end
    if target then
      target:hurt()
    end
  end
end

function Gang.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk2s = caster.skills.Gang_atk2s
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
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function Gang.skillatk2s_finish(basefunc, skill)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Gang.invulnerableBuff then
      tbuff.timer = -1
    end
  end
end

function Gang.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk3 = caster.skills.Gang_atk3
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
  end
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function Gang.skillatk3_finish(basefunc, skill, reason)
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

function Gang.skillatk3s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3s = caster.skills.Gang_atk3s
  if caster and skillatk3s then
    local invbid = Gang.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 1.5
    caster.Gang_invbuff = caster:addBuff(buff1, caster)
  end
end

function Gang.skillatk3s_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.Gang_atk3s
  if caster and skillatk3s then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Gang.invulnerableBuff then
        tbuff.timer = -1
      end
    end
  end
end

function Gang.skillatk3s_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit, dmg = basefunc(skill, target, source, shift)
  local skillatk3 = caster.skills.Gang_atk3
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

function Gang.skillatk3s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk3s = caster.skills.Gang_atk3s
  local DownRatio = skillatk3s.info["Script Arg2"] * 0.01
  local Caster_AP = caster.attribs.AP
  local Caster_AD = caster.attribs.AD
  local Caster_INT = caster.attribs.INT
  if skillatk3s and owner and caster then
    if owner.config.is_monster or owner.config.is_boss then
      local AD = owner.attribs.AD
      local AP = owner.attribs.AP
      buff:setAttribute("AP", -math.min(AP * DownRatio * 0.5, Caster_AP))
      buff:setAttribute("AD", -math.min(AD * DownRatio * 0.5, Caster_AD))
    else
      local AGI = owner.attribs.AGI
      buff:setAttribute("AGI", -math.min(AGI * DownRatio, Caster_INT))
    end
  end
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function Gang.skillatk3s_finish(basefunc, skill)
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
    if tbuff.info.ID == Gang.invulnerableBuff then
      tbuff.timer = -1
    end
  end
end

function Gang.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.TitanIron_atk3_projectile = projectile
  projectile.height = 50
  projectile.hit = override(projectile.hit, Gang.skillatk4_projectile_hit)
  return projectile
end

function Gang.skillatk4_projectile_hit(basefunc, projectile, target)
  basefunc(projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target == skill.target then
    target:hurt()
    projectile:terminate()
  end
end

function Gang.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk4 = caster.skills.Gang_atk4
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
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function Gang.skillatk4s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4s = caster.skills.Gang_atk4s
  if caster and skillatk4s then
    local invbid = Gang.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 2.3
    caster.Gang_invbuff = caster:addBuff(buff1, caster)
  end
end

function Gang.skillatk4s_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4s = caster.skills.Gang_atk4s
  if caster and skillatk4s then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Gang.invulnerableBuff then
        tbuff.timer = -1
      end
    end
  end
end

function Gang.skillatk4s_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit, dmg = basefunc(skill, target, source, shift)
  local bid = 4463
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, caster)
  local con_temp = 0
  local skillatk4 = caster.skills.Gang_atk3
  local atk4_BuffTime = skillatk4.info["Script Arg3"]
  if buff then
    buff.timer = atk4_BuffTime + buff.timer
  end
  return isHit, dmg
end

function Gang.skillatk4s_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local skillatk4s = caster.skills.Gang_atk4s
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
  end
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 4 then
    buff.timer = buff.timer + 4
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function Gang.skillatk4s_finish(basefunc, skill)
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
    if tbuff.info.ID == Gang.invulnerableBuff then
      tbuff.timer = -1
    end
  end
end

function Gang.ult_func_hideBuffEffect(unit)
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

function Gang.ult_func_resetBuffEffect(unit)
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

function Gang.ult_func_NormalChangeToAngry(unit)
  if not (unit:isNormal() and unit:isAlive()) or unit.name ~= "Gang" then
    return
  end
  unit:enterActionStageFromOneStage(unit:getAngryPeriod(), 10124)
  Gang.isAngry = true
  local bid1 = Gang.ult_AttribBuff
  local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
  local buff1 = ed.BuffCreate(binfo1, unit, unit)
  local skillult = unit.skills.Gang_ult
  local AttribsUP = skillult.info["Script Arg2"] / 100
  if unit.name == "Gang" and not unit.config.is_summoned and not unit.config.is_boss and unit:isAlive() then
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
  if unit.name == "Gang" and not unit.config.is_summoned and not unit.config.is_boss and unit:isAlive() then
    buff2:setAttribute("MSPD", SpeedUP)
    buff2:setAttribute("HAST", SpeedUP)
    buff2.timer = SpeedUP_time
  end
  buff2.CreatedByHunterHunter = true
  unit:addBuff(buff2, unit)
  if not unit.config.is_summoned and not unit.config.is_boss then
    unit:takeHeal(unit.attribs.HP, "hp", unit)
  end
  unit.GangAngryBuff = buff1
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
end

function Gang.ult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if not caster:isNormal() then
    return false, "Already Angry"
  end
  if Gang.canCastUlt == false then
    return false, "Gang_Ult Casting"
  end
  return basefunc(skill, target)
end

function Gang.ult_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  caster.Gang_ultCasting = true
  local binfo = ed.lookupDataTable("Buff", nil, Gang.invulnerableBuff)
  local buff = caster:addBuff(binfo, caster)
  buff.timer = 5
  skill.Gang_invulnerableBuff = buff
  Gang.canCastUlt = false
  if caster:isNormal() then
    skill.changeMode = "NtoA"
  end
  Gang.ult_func_hideBuffEffect(caster)
end

function Gang.ult_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Gang.ult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 2 then
    local skillults = caster.skills.Gang_ults
    if skillults then
      skillults:takeEffectAt(caster.position)
    end
  end
end

function Gang.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function Gang.ult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.Gang_ultCasting = false
  if skill.Gang_invulnerableBuff then
    skill.Gang_invulnerableBuff.timer = -1
    skill.Gang_invulnerableBuff = nil
  end
  if skill.changeMode == "NtoA" and caster:isNormal() then
    Gang.ult_func_NormalChangeToAngry(caster)
  end
  skill.changeMode = nil
  Gang.canCastUlt = true
  Gang.ult_func_resetBuffEffect(caster)
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "Gang" and caster.currentActionStage == 2 then
      panel:setPortrait("UI/DOTA-HERO/TitanGang2.png")
    end
  end
end

function Gang.skills_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local Power_up = 0
  if caster.Gang_hasArcana and caster.Gang_hasArcana >= 3 then
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

function Gang.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.Gang_ult
  local skillatk2 = hero.skills.Gang_atk2
  local skillatk3 = hero.skills.Gang_atk3
  local skillatk4 = hero.skills.Gang_atk4
  if hero.currentActionStage == 1 and hero.Gang_hasArcana >= 2 and hero.Gang_ultCasting == false and hero.hp <= hero.attribs.HP * 0.15 then
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
  if hero.currentActionStage == 2 and Gang.isAngry == true then
    hero.mp = 0
  end
end

function Gang.hero_reset(basefunc, hero)
  basefunc(hero)
  Gang.isAngry = false
  hero.Gang_ultCasting = false
  Gang.canCastUlt = true
  if hero.currentActionStage == 2 then
    hero:enterActionStageFromOneStage(hero:getNormalPeriod(), 10124)
  end
  if ed.run_with_scene then
    local panel = hero.heroPanel
    if panel and hero.name == "Gang" then
      panel:setPortrait("UI/DOTA-HERO/TitanGang.png")
    end
  end
end

function Gang.collectMPchange(basefunc, self, config)
  local unit = self
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4458 then
      unit.mp = 0
    end
  end
end

function Gang.init_hero(hero)
  hero.Gang_ultCasting = false
  Gang.isAngry = false
  hero.reset = override(hero.reset, Gang.hero_reset)
  hero.update = override(hero.update, Gang.hero_update)
  hero.Gang_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.Gang_ult
  local skillults = hero.skills.Gang_ults
  local skillatk = hero.skills.Gang_atk
  local skillatks = hero.skills.Gang_atks
  local skillatk2 = hero.skills.Gang_atk2
  local skillatk2s = hero.skills.Gang_atk2s
  local skillatk3 = hero.skills.Gang_atk3
  local skillatk3s = hero.skills.Gang_atk3s
  local skillatk4 = hero.skills.Gang_atk4
  local skillatk4s = hero.skills.Gang_atk4s
  if hero.name == "Gang" then
    hero:setActionStageChangeByManual(true)
  end
  if skillult and not hero.config.is_summoned and hero.name == "Gang" then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Gang.ult_canCastWithTarget)
    skillult.start = override(skillult.start, Gang.ult_start)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, Gang.ult_onPhaseFinished)
    skillult.finish = override(skillult.finish, Gang.ult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Gang.ult_onAttackFrame)
  end
  if skillults and hero.name == "Gang" then
    skillults.createBuff = override(skillults.createBuff, Gang.skillults_createBuff)
  end
  if skillatk2 and hero.name == "Gang" then
    skillatk2.createBuff = override(skillatk2.createBuff, Gang.skillatk2_createBuff)
    skillatk2.finish = override(skillatk2.finish, Gang.skillatk2_finish)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Gang.skillatk2_takeEffectOn)
  end
  if skillatk2s and hero.name == "Gang" then
    skillatk2s.start = override(skillatk2s.start, Gang.skillatk2s_start)
    skillatk2s.onAttackFrame = override(skillatk2s.onAttackFrame, Gang.skillatk2s_onAttackFrame)
    skillatk2s.createBuff = override(skillatk2s.createBuff, Gang.skillatk2s_createBuff)
    skillatk2s.finish = override(skillatk2s.finish, Gang.skillatk2s_finish)
  end
  if skillatk3 and hero.name == "Gang" then
    skillatk3.createBuff = override(skillatk3.createBuff, Gang.skillatk3_createBuff)
    skillatk3.finish = override(skillatk3.finish, Gang.skillatk3_finish)
  end
  if skillatk3s and hero.name == "Gang" then
    skillatk3s.start = override(skillatk3s.start, Gang.skillatk3s_start)
    skillatk3s.onAttackFrame = override(skillatk3s.onAttackFrame, Gang.skillatk3s_onAttackFrame)
    skillatk3s.takeEffectOn = override(skillatk3s.takeEffectOn, Gang.skillatk3s_takeEffectOn)
    skillatk3s.createBuff = override(skillatk3s.createBuff, Gang.skillatk3s_createBuff)
    skillatk3s.finish = override(skillatk3s.finish, Gang.skillatk3s_finish)
  end
  if skillatk4 and hero.name == "Gang" then
    skillatk4.createBuff = override(skillatk4.createBuff, Gang.skillatk4_CreateBuff)
    skillatk4.createProjectile = override(skillatk4.createProjectile, Gang.skillatk4_createProjectile)
  end
  if skillatk4s and hero.name == "Gang" then
    skillatk4s.start = override(skillatk4s.start, Gang.skillatk4s_start)
    skillatk4s.onAttackFrame = override(skillatk4s.onAttackFrame, Gang.skillatk4s_onAttackFrame)
    skillatk4s.takeEffectOn = override(skillatk4s.takeEffectOn, Gang.skillatk4s_takeEffectOn)
    skillatk4s.createBuff = override(skillatk4s.createBuff, Gang.skillatk4s_CreateBuff)
    skillatk4s.finish = override(skillatk4s.finish, Gang.skillatk4s_finish)
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
    local skill = hero.skills["Gang" .. skillnames[i]]
    if skill then
      skill.power = override(skill.power, Gang.skills_power)
    end
  end
  
  function hero.getNormalPeriod(unit)
    local period = 1
    return period
  end
  
  function hero.getAngryPeriod(unit)
    local period = 2
    return period
  end
  
  function hero.isNormal(unit)
    local current = unit.currentActionStage or 1
    if current == 2 then
      return false
    end
    return true
  end
  
  function hero.isAngry(unit)
    local current = unit.currentActionStage or 2
    if current == 1 then
      return false
    end
    return true
  end
  
  ed.PreloadPuppetRcs("TitanGang")
  return hero
end

return Gang.init_hero
