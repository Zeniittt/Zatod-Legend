module("ed.battlehero", package.seeall)
local ed = ed
Paper = {}
Paper.Paper_atk4_buffID = 1392
Paper.PaperDoll_atk2_count = 2
Paper.Paper_LockHpMax_BuffID = 1393
Paper.lockHpSmall = "UI/alpha/1080P/hp_gray_small.png"
Paper.lockHpBig = "UI/alpha/1080P/hp_gray"
Paper.PaperDoll_untargetable_BuffID = 1396
Paper.Paper_atk3_HPR_buffID = 1397
Paper.Paper_atk3_HPR_ratio = 2.5
Paper.Paper_atk3_HAST_ratio = 2
Paper.Paper_atk4_HP_ratio = 0.2
Paper.Paper_atk4_maxtimes = 3
Paper.Paper_awake_buffID = 1394
Paper.PaperDoll_livetime = 12
Paper.Paper_ult_self_buffID = 1398
Paper.Paper_awake_AP_ratio = 0.15
Paper.Paper_awake_MCRIT_ratio = 0.3
Paper.Paper_awake_ARMP_ratio = 1.2

function Paper.hpLockPerform(unit)
  local actor = unit.actor
  local lockPercent
  if actor then
    local buff
    local level = 0
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == Paper.Paper_LockHpMax_BuffID then
        buff = tbuff
        break
      end
    end
    if buff then
      lockPercent = buff.Paper_lockHp_amount / unit.attribs.HP
    end
    if not buff and unit.Paper_hpLockBar then
      unit.Paper_hpLockBar:removeFromParentAndCleanup(true)
      unit.Paper_hpLockBar = false
    elseif buff and not unit.Paper_hpLockBar then
      local barHp = unit.actor.bar_hp
      if barHp then
        local backgroundSize = barHp.background:getTextureRect().size
        local midlayerSize = barHp.midlayer:getTextureRect().size
        local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
        local offsetY = backgroundSize.height / 2
        local newBar = ed.createSprite(Paper.lockHpSmall)
        barHp.background:addChild(newBar, 0)
        newBar:setAnchorPoint(ccp(1, 0.5))
        newBar:setPosition(ccp(offsetX, offsetY))
        newBar:setScaleX(lockPercent)
        unit.Paper_hpLockBar = newBar
      end
    elseif buff and unit.Paper_hpLockBar then
      unit.Paper_hpLockBar:setScaleX(lockPercent)
    end
  end
end

function Paper.lockHpBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local lockHp = buff.Paper_lockHp_amount
  if owner then
    local maxHp = owner.attribs.HP - lockHp
    if maxHp <= 0 then
      maxHp = 1
    end
    local currentHp = owner.hp
    if maxHp < currentHp then
      owner:setHP(maxHp)
    end
  end
  Paper.hpLockPerform(owner)
end

function Paper.lockHpBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local Paper_skillult = caster.skills.Paper_ult
  local Paper_skillatk2s = caster.skills.Paper_atk2s
  local maxdmg = buff.owner.hp - 1
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  if lastdamage < owner.hp then
    if buff.Paper_lockHp_amount then
      buff.Paper_lockHp_amount = buff.Paper_lockHp_amount + lastdamage
    else
      buff.Paper_lockHp_amount = lastdamage
    end
  end
  return damage
end

function Paper.lockHpBuff_upgrade(basefunc, buff, owner, caster, nextBuffInfo)
  local bufftime = buff.timer
  basefunc(buff, owner, caster, nextBuffInfo)
  buff.timer = bufftime
end

function Paper.addLockHpBuff(skill, target)
  local caster = skill.caster
  local bid = Paper.Paper_LockHpMax_BuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, target, caster)
  buff.update = override(buff.update, Paper.lockHpBuff_update)
  buff.onDamaged = override(buff.onDamaged, Paper.lockHpBuff_onDamaged)
  buff.upgrade = override(buff.upgrade, Paper.lockHpBuff_upgrade)
  buff.info["No Pass"] = true
  buff.Paper_lockHp_amount = 0
  local addbuff = target:addBuff(buff, caster)
  Paper.hpLockPerform(target)
end

function Paper.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Paper_PaperDollList = {}
  hero.Paper_enter_time = 0
  hero.Paper_atk4_count = 1
  hero.skillsawake1_alreadyCreateRegion = false
  hero.skillsawake2_alreadyCreateRegion = false
end

function Paper.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.Paper_PaperDollList) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  if hero.skillsawake1_alreadyCreateRegion then
    hero.Paper_sawake1region:terminate()
  end
  if hero.skillsawake2_alreadyCreateRegion then
    hero.Paper_sawake2region:terminate()
  end
  basefunc(hero, killer)
end

function Paper.selectPosition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      x = i
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 < maxcount then
    return x
  end
  if maxcount <= 0 then
    return false
  end
end

function Paper.Paper_ult_clearCut(hero)
  if hero.Paper_ult_CutX then
    ed.engine:closeCut(hero.Paper_ult_CutX)
    if ed.run_with_scene and hero.Paper_ult_effectX then
      local z = -1
      ed.scene:removeEffect(hero.Paper_ult_effectX, z)
    end
  end
  if hero.Paper_ult_CutY then
    ed.engine:closeCut(hero.Paper_ult_CutY)
    if ed.run_with_scene and hero.Paper_ult_effectY then
      local z = -1
      ed.scene:removeEffect(hero.Paper_ult_effectY, z)
    end
  end
end

function Paper.skillult_buff_onRemoved(basefunc, buff)
  Paper.Paper_ult_clearCut(buff.owner)
  basefunc(buff)
end

function Paper.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  Paper.Paper_ult_clearCut(caster)
  local bid = Paper.Paper_ult_self_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onRemoved = override(buff.onRemoved, Paper.skillult_buff_onRemoved)
  caster:addBuff(buff, caster)
  local bid = 1399
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function Paper.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster.direction
  if attack_counter == 0 then
    caster.Paper_ult_CutX = ed.engine:cutScene(nil, 0, 35)
    if ed.run_with_scene then
      local effectx = "eff_point_Paper_ultx.cha"
      if ed.protoSuperAwake(caster.proto, 10059) then
        effectx = "eff_point_Paper_ultx_s2.cha"
      end
      local originx = {400, 0}
      caster.Paper_ult_effectX = ed.scene:playEffectOnScene(effectx, originx, {
        0.8 * dir,
        0.8
      }, nil, -1)
    end
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter == 1 then
    basefunc(skill)
  end
  if attack_counter == 2 then
    local cutx = Paper.selectPosition(skill, 175)
    cutx = cutx or 400
    caster.Paper_ult_CutY = ed.engine:cutScene(cutx, nil, 35)
    if ed.run_with_scene then
      local effecty = "eff_point_Paper_ulty.cha"
      if ed.protoSuperAwake(caster.proto, 10059) then
        effecty = "eff_point_Paper_ulty_s.cha"
      end
      local originy = {cutx, 0}
      caster.Paper_ult_effectY = ed.scene:playEffectOnScene(effecty, originy, {
        0.8 * dir,
        0.8
      }, nil, -1)
    end
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter == 3 then
    basefunc(skill)
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 1399 then
        tbuff.timer = 0
      end
    end
  end
end

function Paper.skillult_takeEffectOn(basefunc, self, target, source, shift)
  local caster = self.caster
  if caster ~= target then
    Paper.addLockHpBuff(self, target)
  end
  basefunc(self, target, source, shift)
end

function Paper.PaperDoll_atk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2s = caster.config.summoner.skills.Paper_atk2s
  skillatk2s:takeEffectAt(caster.position)
end

function Paper.PaperDoll_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local damage = basefunc(hero, damage, immunity, damage_type, source)
  if damage and 0 < damage then
    if hero.PaperDoll_getDamageCount then
      hero.PaperDoll_getDamageCount = hero.PaperDoll_getDamageCount + 1
    else
      hero.PaperDoll_getDamageCount = 1
    end
  end
  if hero.PaperDoll_getDamageCount and hero.PaperDoll_getDamageCount >= Paper.PaperDoll_atk2_count then
    local summoner = hero.config.summoner
    local skillatk2 = hero.skills.PaperDoll_atk2
    hero:castSkill(skillatk2, nil)
    hero.PaperDoll_getDamageCount = 0
  end
  return 1
end

function Paper.PaperDoll_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.PaperDoll_livetime then
    hero.PaperDoll_livetime = hero.PaperDoll_livetime - dt
  else
    hero.PaperDoll_livetime = Paper.PaperDoll_livetime
  end
  if hero.PaperDoll_livetime <= 0 then
    hero:die()
  end
end

function Paper.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  return buff
end

function Paper.skillatk2s_takeEffectOn(basefunc, self, target, source, shift)
  basefunc(self, target, source, shift)
  local caster = self.caster
  local targetMaxHp = target.attribs.HP or 1
  if caster ~= target then
    Paper.addLockHpBuff(self, target)
  end
end

function Paper.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    local x = Paper.selectPosition(skill, 150)
    x = x or 400
    local newlocation = {
      x,
      -15 + ed.rand() * 30
    }
    skill.Paper_atk2_newlocation = newlocation
    if ed.run_with_scene then
      local effect = "eff_point_Paper_atk2.cha"
      local origin = newlocation
      ed.scene:playEffectOnScene(effect, origin, nil, nil, -1)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
  end
end

function Paper.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, skill.Paper_atk2_newlocation, source)
  local caster = skill.caster
  local skillatk2 = caster.skills.Paper_atk2
  local dir = caster:getInitDir()
  local skillevel = {
    skillatk2.level,
    skillatk2.level,
    skillatk2.level
  }
  local proto = {
    _tid = 262,
    _level = skillatk2.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local PaperDoll = ed.UnitCreate(proto, caster.camp, config)
  PaperDoll.getLostHPAfterImmunity = override(PaperDoll.getLostHPAfterImmunity, Paper.PaperDoll_getLostHPAfterImmunity)
  PaperDoll.update = override(PaperDoll.update, Paper.PaperDoll_update)
  local PaperDoll_atk2 = PaperDoll.skills.PaperDoll_atk2
  PaperDoll_atk2.onAttackFrame = override(PaperDoll_atk2.onAttackFrame, Paper.PaperDoll_atk2_onAttackFrame)
  PaperDoll.direction = caster.direction
  local PaperDoll_position = {
    skill.Paper_atk2_newlocation[1],
    skill.Paper_atk2_newlocation[2]
  }
  ed.engine:summonUnit(PaperDoll, PaperDoll_position, caster)
  table.insert(caster.Paper_PaperDollList, PaperDoll)
  local bid = Paper.PaperDoll_untargetable_BuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = PaperDoll:addBuff(binfo, PaperDoll)
end

function Paper.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result and target and target:isAlive() then
    local mpdamage = skill.info["Script Arg2"]
    target:takeDamage(mpdamage / caster.attribs.PDM, "Holy", "mp", caster, 1, 0)
  end
end

function Paper.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local bid = Paper.Paper_atk3_HPR_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, target, caster)
  if not target.buff_effects.stun then
    buff:setAttribute("HPR", buff.info.HPR * Paper.Paper_atk3_HPR_ratio)
    buff:setAttribute("HAST", buff.info.HAST * Paper.Paper_atk3_HAST_ratio)
    buff:setAttribute("MSPD", buff.info.MSPD * Paper.Paper_atk3_HAST_ratio)
  end
  target:addBuff(buff, caster)
end

function Paper.selectPositionSelf(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  local dir = caster:getInitDir()
  for i = 400 - dir * 300, 400 + dir * 300, 50 do
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit == caster then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      x = i
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 < maxcount then
    return x
  end
  if maxcount <= 0 then
    return false
  end
end

function Paper.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Paper.Paper_atk4_buffID then
      tbuff.timer = 0
    end
  end
end

function Paper.skillatk4_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    caster:setPosition({
      caster.Paper_atk4_position[1],
      caster.Paper_atk4_position[2]
    })
    basefunc(skill)
  end
end

function Paper.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local x = Paper.selectPositionSelf(skill, 50)
  x = x or 100 + ed.rand() * 600
  caster.Paper_atk4_position = {x, 0}
end

function Paper.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  local skillatk4 = hero.skills.Paper_atk4
  if skillatk4 and hero.Paper_atk4_count <= Paper.Paper_atk4_maxtimes and lost >= hero.attribs.HP * Paper.Paper_atk4_HP_ratio then
    local lost2 = hero.attribs.HP * Paper.Paper_atk4_HP_ratio
    hero.Paper_atk4_count = hero.Paper_atk4_count + 1
    local bid = Paper.Paper_atk4_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
    local min_overdamage = skillatk4.info["Script Arg2"]
    local max_overdamage = skillatk4.info["Script Arg3"]
    local overdamage = lost - lost2
    if min_overdamage > overdamage then
      overdamage = min_overdamage
    elseif max_overdamage < overdamage then
      overdamage = max_overdamage
    end
    if source then
      source:takeDamage(overdamage / hero.attribs.PDM, "Holy", "hp", hero, 1, 0)
    end
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    hero:castSkill(skillatk4, nil)
    if ed.run_with_scene then
      local effect_name = "eff_point_Ony_awake.cha"
      if not effect_name then
        return
      end
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, hero.position, {
        hero.direction,
        1
      }, nil, effect_z)
    end
    return lost2
  end
  return lost
end

function Paper.skillawake_buff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local skillawake = caster.skills.Paper_awake
  buff.time_count = buff.time_count + dt
  if buff.time_count >= 1.5 then
    skillawake:takeEffectOn(owner, caster)
    buff.time_count = 0
    buff.timer = 0
  end
end

function Paper.skillawake_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local skillawake = caster.skills.Paper_awake
  if buff.Paper_awake_ownermp > owner.mp then
    buff.Paper_awake_mpcount = buff.Paper_awake_mpcount + buff.Paper_awake_ownermp - owner.mp
  end
  if buff.Paper_awake_mpcount >= 1000 and buff.timer > 0 then
    buff.time_count = buff.time_count + dt
    if buff.time_count >= 2 then
      local bid = 1400
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buffnew = ed.BuffCreate(binfo, owner, caster)
      buffnew.update = override(buffnew.update, Paper.skillawake_buff2_update)
      buffnew.time_count = 0
      local addbuff = owner:addBuff(buffnew, caster)
      buff.timer = 0
      buff.time_count = 0
    end
  end
  buff.Paper_awake_ownermp = owner.mp
end

function Paper.skillawake_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
end

function Paper.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillawake = hero.skills.Paper_awake
  if skillawake and hero.Paper_enter_time then
    if hero.Paper_enter_time >= 8 then
      local skillawake = hero.skills.Paper_awake
      local target = skillawake:selectTarget()
      if target then
        local bid = Paper.Paper_awake_buffID
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, target, hero)
        buff.update = override(buff.update, Paper.skillawake_buff_update)
        buff.Paper_awake_ownermp = target.mp
        buff.Paper_awake_mpcount = 0
        buff.time_count = 0
        local addbuff = target:addBuff(buff, hero)
        hero.Paper_enter_time = nil
      end
      local bid2 = 1402
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, hero, hero)
      buff2:setAttribute("AD", hero.attribs.AP * Paper.Paper_awake_AP_ratio)
      buff2:setAttribute("MCRIT", hero.attribs.CRIT * Paper.Paper_awake_MCRIT_ratio)
      buff2:setAttribute("MRI", hero.attribs.ARMP * Paper.Paper_awake_ARMP_ratio)
      hero:addBuff(buff2, hero)
    else
      hero.Paper_enter_time = hero.Paper_enter_time + 1
    end
  end
  local skillsawake1 = hero.skills.Paper_sawake1
  local skillsawake2 = hero.skills.Paper_sawake2
  local hero_HPratio = hero.hp / hero.attribs.HP
  if skillsawake1 and hero.name == "Paper" and not hero.config.is_summoned and not hero.skillsawake1_alreadyCreateRegion and 0.5 <= hero_HPratio then
    hero.skillsawake1_alreadyCreateRegion = true
    if hero.skillsawake2_alreadyCreateRegion then
      hero.Paper_sawake2region:terminate()
      hero.skillsawake2_alreadyCreateRegion = false
      if hero.skillsawake2_buff and 0 < hero.skillsawake2_buff.timer then
        hero.skillsawake2_buff.timer = -1
      end
    end
    skillsawake1.target = hero
    hero.Paper_sawake1region = skillsawake1:createRegion()
    ed.engine:addRegion(hero.Paper_sawake1region)
    local bid = 1702
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero.skillsawake1_buff = hero:addBuff(binfo, hero)
  end
  if skillsawake2 and hero.name == "Paper" and not hero.config.is_summoned and not hero.skillsawake2_alreadyCreateRegion and hero_HPratio < 0.5 then
    hero.skillsawake2_alreadyCreateRegion = true
    if hero.skillsawake1_alreadyCreateRegion then
      hero.Paper_sawake1region:terminate()
      hero.skillsawake1_alreadyCreateRegion = false
      if hero.skillsawake1_buff and 0 < hero.skillsawake1_buff.timer then
        hero.skillsawake1_buff.timer = -1
      end
    end
    skillsawake2.target = hero
    hero.Paper_sawake2region = skillsawake2:createRegion()
    ed.engine:addRegion(hero.Paper_sawake2region)
    local bid = 1703
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero.skillsawake2_buff = hero:addBuff(binfo, hero)
  end
end

function Paper.skillsawake1_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local skillsawake1 = caster.skills.Paper_sawake1
  local AD = skillsawake1.info["Script Arg3"]
  local MIMU = skillsawake1.info["Script Arg2"]
  local caster_HPratio = caster.hp / caster.attribs.HP
  if 0.5 <= caster_HPratio then
    buff:setAttribute("AD", 0)
    buff:setAttribute("MIMU", MIMU)
  else
    buff:setAttribute("AD", AD)
    buff:setAttribute("MIMU", 0)
  end
  return buff
end

function Paper.skillsawake2_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local skillsawake2 = caster.skills.Paper_sawake2
  local AD = skillsawake2.info["Script Arg3"]
  local MIMU = skillsawake2.info["Script Arg2"]
  local caster_HPratio = caster.hp / caster.attribs.HP
  if 0.5 <= caster_HPratio then
    buff:setAttribute("AD", 0)
    buff:setAttribute("MIMU", MIMU)
  else
    buff:setAttribute("AD", AD)
    buff:setAttribute("MIMU", 0)
  end
  return buff
end

function Paper.init_hero(hero)
  local skillult = hero.skills.Paper_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Paper.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Paper.skillult_takeEffectOn)
    skillult.start = override(skillult.start, Paper.skillult_start)
  end
  local skillatk2 = hero.skills.Paper_atk2
  local skillatk2s = hero.skills.Paper_atk2s
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Paper.skillatk2_onAttackFrame)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, Paper.skillatk2_takeEffectAt)
    skillatk2s.createBuff = override(skillatk2s.createBuff, Paper.skillatk2s_createBuff)
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, Paper.skillatk2s_takeEffectOn)
  end
  local skillatk3 = hero.skills.Paper_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Paper.skillatk3_takeEffectOn)
  end
  local skillatk4 = hero.skills.Paper_atk4
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Paper.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, Paper.skillatk4_finish)
    skillatk4.start = override(skillatk4.start, Paper.skillatk4_start)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, Paper.hero_getLostHPAfterImmunity)
  end
  local skillawake = hero.skills.Paper_awake
  if skillawake then
    skillawake.takeEffectOn = override(skillawake.takeEffectOn, Paper.skillawake_takeEffectOn)
  end
  hero.update = override(hero.update, Paper.hero_update)
  hero.reset = override(hero.reset, Paper.hero_reset)
  hero.die = override(hero.die, Paper.hero_die)
  local skillsawake1 = hero.skills.Paper_sawake1
  local skillsawake2 = hero.skills.Paper_sawake2
  if skillsawake1 then
    skillsawake1.createBuff = override(skillsawake1.createBuff, Paper.skillsawake1_createBuff)
  end
  if skillsawake2 then
    skillsawake2.createBuff = override(skillsawake2.createBuff, Paper.skillsawake2_createBuff)
  end
  return hero
end

return Paper.init_hero
