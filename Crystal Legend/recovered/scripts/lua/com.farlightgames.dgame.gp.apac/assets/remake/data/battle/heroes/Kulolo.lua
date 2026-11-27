module("ed.battlehero", package.seeall)
local ed = ed
Kulolo = {}
Kulolo.STR_UP_Buff = 4560
Kulolo.INT_UP_Buff = 4561
Kulolo.AGI_UP_Buff = 4562
Kulolo.Kulolo_fishinvBuffID = 4563

function Kulolo.skillatk2_launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local caster = skill.caster
  local direction = caster.direction
  position[1] = caster.position[1] + 30 * direction
  return position, height
end

function Kulolo.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.target = skill.target
  local caster = skill.caster
  projectile.terminate = override(projectile.terminate, Kulolo.skillatk2_tile_Terminate)
  if caster.Kulolo_hasArcana and caster.Kulolo_hasArcana >= 3 then
    local projectile2 = ed.ProjectileCreate(skill)
    projectile2.position, projectile2.height = skill:launchPoint()
    local range_x = 75
    local range_y = 30
    local xs = 40
    local ys = 10
    local xxs = ed.rand() * 2 * range_x + xs - range_x
    local yys = ed.rand() * 2 * range_y + ys - range_y
    projectile2.position = {
      projectile2.position[1] + xxs * caster.direction,
      projectile2.position[2] + yys
    }
    projectile2.terminate = override(projectile2.terminate, Kulolo.skillatk2_tile_Terminate)
    projectile2.target = skill.target
    ed.engine:addProjectile(projectile2)
  end
  return projectile
end

function Kulolo.skillatk2_tile_Terminate(basefunc, self)
  basefunc(self)
  local hero = self.skill.caster
  local target = self.skill.target
  local skillatk2 = hero.skills.Kulolo_atk2
  if hero:isAlive() and skillatk2 and ed.run_with_scene then
    local effect_name = "eff_impact_TitanKulolo_fish_atk.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, {
      target.position[1] - target.direction * 35,
      target.position[2]
    }, {
      -target.direction,
      1
    }, nil, -1)
  end
end

function Kulolo.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2 = caster.skills.Kulolo_atk2
  if caster and target and skillatk2 then
    local Attribs_Down = skillatk2.info["Script Arg2"] / 100
    local HP_Down = skillatk2.info["Script Arg4"] / 100
    if target.config.is_boss or owner.get_Kulolo_ultBuff then
    else
      local HP_DownMax = math.min(HP_Down * target.attribs.HP, caster.attribs.HP * 0.2)
      buff:setAttribute("HP", 0)
      buff.Kulolo_lockHp_amount = HP_DownMax
      buff.update = override(buff.update, Kulolo.lockHpBuff_update)
      buff.onRemoved = override(buff.onRemoved, Kulolo.lockHpBuff_onRemoved)
      buff.onDamaged = override(buff.onDamaged, Kulolo.lockHpBuff_onDamaged)
      Kulolo.hpLockPerform(owner)
      if not owner.get_Kulolo_ultBuff then
        owner.get_Kulolo_ultBuff = true
      end
    end
    buff.info.Time = skillatk2.info["Script Arg3"] + 3
    local mainAtt = target.info["Main Attrib"]
    if mainAtt and mainAtt == "STR" then
      local bid = 4557
      local binfo2 = ed.lookupDataTable("Buff", nil, bid)
      local buff2 = ed.BuffCreate(binfo2, target, caster)
      buff2:setAttribute(mainAtt, -math.min(Attribs_Down * target.attribs[mainAtt], target.attribs[mainAtt] - 1))
      buff2.timer = skillatk2.info["Script Arg3"]
      buff2.CreatedByHunterHunter = true
      target:addBuff(buff2, caster)
    elseif mainAtt and mainAtt == "INT" then
      local bid = 4558
      local binfo2 = ed.lookupDataTable("Buff", nil, bid)
      local buff2 = ed.BuffCreate(binfo2, target, caster)
      buff2:setAttribute(mainAtt, -math.min(Attribs_Down * target.attribs[mainAtt], target.attribs[mainAtt] - 1))
      buff2.timer = skillatk2.info["Script Arg3"]
      buff2.CreatedByHunterHunter = true
      target:addBuff(buff2, caster)
    elseif mainAtt and mainAtt == "AGI" then
      local bid = 4559
      local binfo2 = ed.lookupDataTable("Buff", nil, bid)
      local buff2 = ed.BuffCreate(binfo2, target, caster)
      buff2:setAttribute(mainAtt, -math.min(Attribs_Down * target.attribs[mainAtt], target.attribs[mainAtt] - 1))
      buff2.timer = skillatk2.info["Script Arg3"]
      buff2.CreatedByHunterHunter = true
      target:addBuff(buff2, caster)
    end
    if caster.Kulolo_hasArcana and caster.Kulolo_hasArcana >= 2 then
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp then
          if tbuff.info.STR and 0 >= tbuff.info.STR then
            local bid = 4560
            local binfo2 = ed.lookupDataTable("Buff", nil, bid)
            local buff2 = ed.BuffCreate(binfo2, caster, caster)
            buff2:setAttribute("STR", math.min(tbuff.info.STR, caster.attribs.STR * 0.5))
            buff2.timer = skillatk2.info["Script Arg3"]
            buff2.CreatedByHunterHunter = true
            if not caster.config.is_boss then
              caster:addBuff(buff2, caster)
            end
          elseif tbuff.info.INT and 0 >= tbuff.info.INT then
            local bid = 4561
            local binfo2 = ed.lookupDataTable("Buff", nil, bid)
            local buff2 = ed.BuffCreate(binfo2, caster, caster)
            buff2:setAttribute("INT", math.min(tbuff.info.INT, caster.attribs.INT * 0.5))
            buff2.timer = skillatk2.info["Script Arg3"]
            buff2.CreatedByHunterHunter = true
            if not caster.config.is_boss then
              caster:addBuff(buff2, caster)
            end
          elseif tbuff.info.AGI and 0 >= tbuff.info.AGI then
            local bid = 4562
            local binfo2 = ed.lookupDataTable("Buff", nil, bid)
            local buff2 = ed.BuffCreate(binfo2, caster, caster)
            buff2:setAttribute("AGI", math.min(tbuff.info.AGI, caster.attribs.AGI * 0.5))
            buff2.timer = skillatk2.info["Script Arg3"]
            if not caster.config.is_boss then
              caster:addBuff(buff2, caster)
            end
          end
        end
      end
    end
  end
  return buff
end

function Kulolo.hpLockPerform(unit)
  local actor = unit.actor
  local lockPercent
  if actor then
    local buff
    local level = 0
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 4554 then
        buff = tbuff
        break
      end
    end
    if buff then
      lockPercent = buff.Kulolo_lockHp_amount / unit.attribs.HP
    end
    if not buff and unit.Kulolo_hpLockBar then
      unit.Kulolo_hpLockBar:removeFromParentAndCleanup(true)
      unit.Kulolo_hpLockBar = false
    elseif buff and not unit.Kulolo_hpLockBar then
      local barHp = unit.actor.bar_hp
      if barHp then
        local backgroundSize = barHp.background:getTextureRect().size
        local midlayerSize = barHp.midlayer:getTextureRect().size
        local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
        local offsetY = backgroundSize.height / 2
        local newBar = ed.createSprite("UI/alpha/1080P/hp_gray_small.png")
        barHp.background:addChild(newBar, 0)
        newBar:setAnchorPoint(ccp(1, 0.5))
        newBar:setPosition(ccp(offsetX, offsetY))
        newBar:setScaleX(lockPercent)
        unit.Kulolo_hpLockBar = newBar
      end
    elseif buff and unit.Kulolo_hpLockBar then
      unit.Kulolo_hpLockBar:setScaleX(lockPercent)
    end
  end
end

function Kulolo.lockHpBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local lockHp = buff.Kulolo_lockHp_amount
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
  Kulolo.hpLockPerform(owner)
end

function Kulolo.lockHpBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
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
    if buff.Kulolo_lockHp_amount then
      buff.Kulolo_lockHp_amount = buff.Kulolo_lockHp_amount + lastdamage
    else
      buff.Kulolo_lockHp_amount = lastdamage
    end
  end
  return damage
end

function Kulolo.lockHpBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.get_Kulolo_ultBuff = false
end

function Kulolo.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  local caster = skill.caster
  caster.skillatk3_target = target
  target.hasKulolo_atk3Buff = false
  target.hasKulolo_atk3Buff2 = false
end

function Kulolo.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = caster.skillatk3_target
  local attack_counter = skill.attack_counter
  if caster and target then
    local skillatk3 = caster.skills.Kulolo_atk3
    local buff_DaGuoBu_time = skillatk3.info["Script Arg2"]
    local MPR_down = -skillatk3.info["Script Arg3"]
    if attack_counter == 0 and buff_DaGuoBu_time then
      local bid = 4555
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp then
          if tbuff.info.STR and 0 >= tbuff.info.STR then
            buff_DaGuoBu_time = buff_DaGuoBu_time + math.abs(tbuff.info.STR * 5.0E-4)
          end
          if tbuff.info.AGI and 0 >= tbuff.info.AGI then
            buff_DaGuoBu_time = buff_DaGuoBu_time + math.abs(tbuff.info.AGI * 5.0E-4)
          end
          if tbuff.info.INT and 0 >= tbuff.info.INT then
            buff_DaGuoBu_time = buff_DaGuoBu_time + math.abs(tbuff.info.INT * 5.0E-4)
          end
        end
      end
      buff.timer = buff_DaGuoBu_time + 1.2
      caster.skillatk3_buff1_Time = buff_DaGuoBu_time
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.info.ID == 4555 then
          target.hasKulolo_atk3Buff = true
        end
      end
      if not target.config.is_boss and not target.hasKulolo_atk3Buff then
        target:addBuff(buff, caster)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      basefunc(skill)
    end
    if attack_counter == 2 and MPR_down then
      local bid = 4556
      local binfo2 = ed.lookupDataTable("Buff", nil, bid)
      local buff2 = ed.BuffCreate(binfo2, target, caster)
      local buff_DaGuoBu_time = caster.skillatk3_buff1_Time
      buff2.onRemoved = override(buff2.onRemoved, Kulolo.skillatk3_DaGuoBu_buffonRemoved)
      buff2.timer = buff_DaGuoBu_time
      buff2:setAttribute("MPR", MPR_down)
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.info.ID == 4556 then
          target.hasKulolo_atk3Buff2 = true
        end
      end
      if not target.config.is_boss and not target.hasKulolo_atk3Buff2 then
        target:addBuff(buff2, caster)
      end
      skill:finish()
    end
  end
end

function Kulolo.skillatk3_DaGuoBu_buffonRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  if caster and owner then
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanKulolo_atk3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 1)
    end
    owner.hasKulolo_atk3Buff = false
    owner.hasKulolo_atk3Buff2 = false
  end
  basefunc(buff)
end

function Kulolo.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.Kulolo_atk4
  local BuffTime = skillatk4.info["Script Arg3"]
  if caster and skillatk4 then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if not unit.config.is_summoned then
        local bid = Kulolo.STR_UP_Buff
        local binfo1 = ed.lookupDataTable("Buff", nil, bid)
        local buff1 = ed.BuffCreate(binfo1, unit, caster)
        buff1:setAttribute("STR", caster.attribs.STR * skillatk4.info["Script Arg2"] / 100)
        buff1.timer = BuffTime
        buff1.CreatedByHunterHunter = true
        if not unit.config.is_boss then
          unit:addBuff(buff1, caster)
        end
        local bid = Kulolo.AGI_UP_Buff
        local binfo2 = ed.lookupDataTable("Buff", nil, bid)
        local buff2 = ed.BuffCreate(binfo2, unit, caster)
        buff2:setAttribute("AGI", caster.attribs.AGI * skillatk4.info["Script Arg2"] / 100)
        buff2.timer = BuffTime
        buff2.CreatedByHunterHunter = true
        if not unit.config.is_boss then
          unit:addBuff(buff2, caster)
        end
        local bid = Kulolo.INT_UP_Buff
        local binfo3 = ed.lookupDataTable("Buff", nil, bid)
        local buff3 = ed.BuffCreate(binfo3, unit, caster)
        buff3:setAttribute("INT", caster.attribs.INT * skillatk4.info["Script Arg2"] / 100)
        buff3.timer = BuffTime
        buff3.CreatedByHunterHunter = true
        if not unit.config.is_boss then
          unit:addBuff(buff3, caster)
        end
      end
    end
  end
end

function Kulolo.isCrlEftConflictWithUncontrollableSP(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function Kulolo.skillult_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local skillult = caster.skills.Kulolo_ult
  buff.onDamaged = override(buff.onDamaged, Kulolo.skillult_buffonDamaged)
  if caster and owner then
    if caster.Kulolo_hasArcana and caster.Kulolo_hasArcana >= 4 then
      buff.timer = buff.timer + 5
    end
    if owner.config.is_summoned or owner.config.summoner or owner.config.is_boss then
      buff.timer = -1
    end
    if owner and owner.attribs.TEN then
      local Ten_Ratio = math.min(skillult.info["Script Arg2"], 30)
      buff:setAttribute("TEN", math.min(owner.attribs.TEN * Ten_Ratio, 85 - owner.attribs.TEN))
    end
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function Kulolo.skillult_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.Kulolo_ult
  if caster and owner and skillult and source and (damage_type == "AD" or damage_type == "AP") and skill then
    local DODG_Ratio = (skillult.info["Script Arg2"] + 30) / 100
    local Dodg_rand = ed.rand()
    local No_Dodg = skill.info["No Dodge"]
    if DODG_Ratio >= Dodg_rand and not No_Dodg then
      dmg = 0
      owner:onHitMiss(owner)
      if do_battle_log then
        btlog("%s: %s --> %s (Miss!)", skill:display(), source:display(), owner:display())
      end
      local color = owner.camp == ed.emCampPlayer and "blue" or "red"
      if owner.actor then
        ed.PopupCreate("dodge", color, owner.actor, nil, "text")
      end
    end
  end
  return dmg
end

function Kulolo.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.Kulolo_ult
  if skillult and caster and caster:isAlive() then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.config.is_summoned then
      else
        local list = unit.buff_list
        local debuff_list = {}
        local my_camp = caster.camp
        for i = 1, #list do
          local buff = list[i]
          if buff and (not buff.caster or buff.caster.camp ~= my_camp) and (Kulolo.isCrlEftConflictWithUncontrollableSP(buff) or buff.info.Dispel == "YES") then
            debuff_list[#debuff_list + 1] = buff
          end
        end
        for i = 1, #debuff_list do
          unit:removeBuff(debuff_list[i])
        end
      end
    end
  end
end

function Kulolo.hero_die(basefunc, hero, killer)
  for _, unit in ipairs(hero.Kulolo_fishList) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Kulolo.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Kulolo_fishList = {}
  hero.bgg_changed = false
end

function Kulolo.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if ed.engine.hero_background and ed.engine.hero_background[3] ~= true and not hero.bgg_changed then
    if ed.engine.hero_background and ed.engine.hero_background[1] == "Kulolo_SecretRoom" then
      ed.engine.hero_background = ed.engine.genHeroBackground("Kulolo_SecretRoom", 999, nil)
      hero.bgg_changed = true
    else
      ed.engine.hero_background = ed.engine.genHeroBackground("Kulolo_SecretRoom", 999, nil)
      if ed.run_with_scene and not ed.IsMultiArena() then
        ed.scene:onBackgroundAppear(1, "battle_bg/bgg_Kulolo_SecretRoom.jpg")
      end
      hero.bgg_changed = true
    end
  end
end

function Kulolo.init_hero(hero)
  hero.reset = override(hero.reset, Kulolo.hero_reset)
  hero.update = override(hero.update, Kulolo.hero_update)
  hero.die = override(hero.die, Kulolo.hero_die)
  hero.Kulolo_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.Kulolo_ult
  local skillatk = hero.skills.Kulolo_atk
  local skillatk2 = hero.skills.Kulolo_atk2
  local skillatk3 = hero.skills.Kulolo_atk3
  local skillatk4 = hero.skills.Kulolo_atk4
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Kulolo.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, Kulolo.skillult_CreateBuff)
  end
  if skillatk2 then
    skillatk2.launchPoint = override(skillatk2.launchPoint, Kulolo.skillatk2_launchPoint)
    skillatk2.createBuff = override(skillatk2.createBuff, Kulolo.skillatk2_createBuff)
    skillatk2.createProjectile = override(skillatk2.createProjectile, Kulolo.skillatk2_createProjectile)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Kulolo.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Kulolo.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Kulolo.skillatk4_onAttackFrame)
  end
  return hero
end

return Kulolo.init_hero
