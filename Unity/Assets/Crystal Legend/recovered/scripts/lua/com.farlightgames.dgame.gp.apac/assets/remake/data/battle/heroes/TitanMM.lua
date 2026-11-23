module("ed.battlehero", package.seeall)
local ed = ed
TitanMM = {}
TitanMM.atk2_change_CD = 4
TitanMM.TitanMM_atk2_buff_bid = 1670
TitanMM.TitanMM_ult_buff_ID = 1669
TitanMM.TitanMM_ult_Uncontrollable = 1673
TitanMM.TitanMM_atk3_buff_ID = 1674
TitanMM.TitanMM_atk3_stun_buff_ID = 1675
TitanMM.TitanMM_cast_stable_ID = 1672
TitanMM.nil_bid = 1259

function TitanMM.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillenter = hero.skills.TitanMM_enter
  if skillenter then
    local dir = hero:getInitDir()
    hero:setPosition({
      400 - 280 * dir,
      0
    })
    local bid = 651
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero.enter_buff = hero:addBuff(binfo, hero)
  end
  hero.TitanMM_atk2_CdRemaining = TitanMM.atk2_change_CD
  hero.TitanMM_atk2_duration = false
  hero.TitanMM_atk2_preivous_target = nil
  hero.TitanMM_atk3_target = nil
  hero.TitanMM_ult_timer1 = 0
  hero.TitanMM_ult_timer2 = 0
  hero.TitanMM_enter_casted = false
end

function TitanMM.skillenter_start(basefunc, skill, target)
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
end

function TitanMM.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = -1
    end
  end
  caster.TitanMM_enter_casted = true
end

function TitanMM.skillatk2_canCast(skill)
  local info = skill.info
  local caster = skill.caster
  local skillult = caster.skills.TitanMM_ult
  local skillatk3 = caster.skills.TitanMM_atk3
  if skill.cd_remaining > 0 then
    return false, "enter stage cd"
  end
  if caster.buff_effects.stun then
    return false, "stun"
  end
  if caster.current_skill == skillult or caster.current_skill == skillatk3 then
    return false, "current skill"
  end
  if caster.buff_effects.silence or caster.buff_effects.doom then
    return false, "silence doom"
  end
  local num = 0
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.info["Unit Type"] == "Hero" and unit ~= caster and not unit.config.is_summoned and not unit.buff_effects.untargetable and not unit.buffManager.invisible and unit.position[1] > -100 and unit.position[1] < 900 then
      num = num + 1
    end
    if unit.info["Unit Type"] == "Hero" and unit ~= caster and unit.TitanMM_atk2_buff_on then
      return false
    end
  end
  if num < 1 then
    return false, "no one"
  end
  return true
end

function TitanMM.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk2 = hero.skills.TitanMM_atk2
  if skillatk2 and hero.TitanMM_atk2_duration then
    hero.TitanMM_atk2_CdRemaining = hero.TitanMM_atk2_CdRemaining - dt
    hero.can_cast_manual = hero.can_cast_manual or hero.mp < 1000 and TitanMM.skillatk2_canchange(skillatk2)
    if (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and hero.mp < 1000 and TitanMM.skillatk2_canchange(skillatk2) then
      if hero.current_skill then
        hero.current_skill:interrupt()
      end
      TitanMM.atk2_change(hero)
    end
  end
end

function TitanMM.hero_castManualSkill(basefunc, hero)
  local skillatk2 = hero.skills.TitanMM_atk2
  if TitanMM.skillatk2_canchange(skillatk2) then
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    TitanMM.atk2_change(hero)
  else
    basefunc(hero)
  end
end

function TitanMM.hero_canPanelTrigger(basefunc, hero)
  local skillult = hero.skills.TitanMM_ult
  local skillatk3 = hero.skills.TitanMM_atk3
  local skillatk3b = hero.skills.TitanMM_atk3b
  local friend_hero_num = 0
  local atk2_buff_on = false
  for unit in ed.engine:foreachAliveUnit(hero.camp) do
    if unit.info["Unit Type"] == "Hero" and unit ~= hero and not unit.config.is_summoned and not unit.buff_effects.untargetable and unit.position[1] > -100 and unit.position[1] < 900 then
      friend_hero_num = friend_hero_num + 1
    end
    if unit.info["Unit Type"] == "Hero" and unit ~= caster and unit.TitanMM_atk2_buff_on then
      atk2_buff_on = true
    end
  end
  return hero.TitanMM_atk2_duration and 0 >= hero.TitanMM_atk2_CdRemaining and hero.current_skill ~= skillult and hero.current_skill ~= skillatk3 and hero.current_skill ~= skillatk3b and 1 < friend_hero_num and atk2_buff_on and hero.mp < 1000
end

function TitanMM.skillatk2_canchange(skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanMM_ult
  local skillatk3 = caster.skills.TitanMM_atk3
  local skillatk3b = caster.skills.TitanMM_atk3b
  local friend_hero_num = 0
  local atk2_buff_on = false
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.info["Unit Type"] == "Hero" and unit ~= caster and not unit.config.is_summoned and not unit.buff_effects.untargetable and unit.position[1] > -100 and unit.position[1] < 900 then
      friend_hero_num = friend_hero_num + 1
    end
    if unit.info["Unit Type"] == "Hero" and unit ~= caster and unit.TitanMM_atk2_buff_on then
      atk2_buff_on = true
    end
  end
  return caster.TitanMM_atk2_duration and caster.current_skill ~= skillult and caster.current_skill ~= skillatk3 and caster.current_skill ~= skillatk3b and 0 >= caster.TitanMM_atk2_CdRemaining and 1 < friend_hero_num and atk2_buff_on and caster.mp < 1000
end

function TitanMM.skillatk2_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if target ~= caster and TitanMM.skillatk2_canCast(skill) then
    result = true
  else
    result = nil
  end
  return result
end

function TitanMM.atk2_change(hero)
  local skillatk2 = hero.skills.TitanMM_atk2
  local skillatk4 = hero.skills.TitanMM_atk4
  if skillatk2 and hero.TitanMM_atk2_preivous_target then
    local target = hero.TitanMM_atk2_preivous_target
    for _, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == TitanMM.TitanMM_atk2_buff_bid then
        tbuff.timer = -1
        tbuff:onRemoved()
      end
    end
    hero:castSkill(skillatk2, nil)
    hero.TitanMM_atk2_CdRemaining = TitanMM.atk2_change_CD
    if skillatk4 then
      skillatk4:takeEffectOn(hero)
    end
  end
end

function TitanMM.skillatk2_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    local maxDamage = 0
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.buff_effects.untargetable then
      elseif unit.config.is_summoned then
      elseif unit.buff_effects.invulnerable then
      elseif unit.TitanMM_atk2_buff_on then
      elseif not unit:isAlive() then
      elseif unit == caster.TitanMM_atk2_preivous_target then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq and maxDamage <= unit.battledata.damage then
          maxDamage = unit.battledata.damage
          chosen = unit
        end
      end
    end
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function TitanMM.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk2 = caster.skills.TitanMM_atk2
  local skillatk4 = caster.skills.TitanMM_atk4
  if target and target:isAlive() then
    caster.TitanMM_atk2_duration = true
    for _, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == TitanMM.TitanMM_ult_buff_ID then
        tbuff.timer = -1
        tbuff:onRemoved()
      end
    end
    if skillatk4 and caster.TitanMM_atk2_preivous_target then
      skillatk4:takeEffectOn(target, caster)
    end
    caster.TitanMM_atk2_preivous_target = target
  end
end

function TitanMM.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local skillatk2 = skill.caster.skills.TitanMM_atk2
  local caster = skill.caster
  buff:setAttribute("AD", skillatk2.info["Script Arg2"] * caster.attribs.AP)
  buff:setAttribute("AP", skillatk2.info["Script Arg3"] * caster.attribs.AP)
  buff:setAttribute("MPGainRatio", skillatk2.info["Script Arg4"])
  buff.onRemoved = override(buff.onRemoved, TitanMM.skillatk2_buff_onRemoved)
  target.TitanMM_atk2_buff_on = true
  target.TitanMM_atk2_buff_count = 1
  return buff
end

function TitanMM.skillatk2_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2 = caster.skills.TitanMM_atk2
  local skillatk4 = caster.skills.TitanMM_atk4
  owner.TitanMM_atk2_buff_on = false
  if ed.run_with_scene then
    local effect_name = "eff_buff_TitanMM_atk2a.cha"
    local effect_z = 1
    local effect_position = {
      owner.position[1],
      owner.position[2]
    }
    ed.scene:playEffectOnScene(effect_name, effect_position, {
      owner.direction,
      1
    }, nil, effect_z)
  end
end

function TitanMM.collectBuff(basefunc, self, config)
  if self.TitanMM_atk2_duration then
    local buff = config.buff
    local owner = buff.owner
    local caster = buff.caster
    if owner and caster and owner.TitanMM_atk2_buff_on and owner.TitanMM_atk2_buff_count > 0 then
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
        polymorph = true,
        slow = true,
        icefrozen = true
      }
      for i, effect in ipairs(buff.info["Control Effects"]) do
        if negative_effects[effect] then
          local bid = TitanMM.nil_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          config.buff = ed.BuffCreate(binfo, owner, buff.caster)
          owner.TitanMM_atk2_buff_count = owner.TitanMM_atk2_buff_count - 1
          break
        end
      end
    end
  end
end

function TitanMM.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanMM_ult
  if caster.current_skill == skillult then
    result = false
  end
  return result
end

function TitanMM.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.config.is_summoned then
    elseif unit.TitanMM_atk2_buff_on then
      target = unit
    end
  end
  if target then
    caster:setPosition({
      target.position[1],
      target.position[2] - 35
    })
    caster.TitanMM_atk3_target = target
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      local binfo = ed.lookupDataTable("Buff", nil, TitanMM.TitanMM_atk3_buff_ID)
      local buff = ed.BuffCreate(binfo, unit, caster)
      buff.onDamaged = override(buff.onDamaged, TitanMM.skillatk3_buffonDamaged)
      unit:addBuff(buff, caster)
    end
  else
    local Enemy_position = TitanMM.DOP_in_battlefield(caster, 245, caster.foecamp)
    if Enemy_position then
      caster:setPosition({
        Enemy_position[1],
        Enemy_position[2]
      })
    else
      caster:setPosition({400, 0})
    end
  end
end

function TitanMM.skillatk3_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local owner = buff.owner
  local ran = ed.rand()
  if owner and owner:isAlive() and source and source.name == caster.TitanMM_atk3_target.name and ran < 0.5 then
    local binfo = ed.lookupDataTable("Buff", nil, TitanMM.TitanMM_atk3_stun_buff_ID)
    local buff = ed.BuffCreate(binfo, owner, caster)
    owner:addBuff(binfo, caster)
  end
  return damage
end

function TitanMM.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local skillatk3b = skill.caster.skills.TitanMM_atk3b
  if skillatk3b then
    skill.caster.global_cd = 0
    skillatk3b.cd_remaining = 0
  end
end

function TitanMM.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local light_num = 3
  local caster = skill.caster
  local skillult = caster.skills.TitanMM_ult
  if caster.TitanMM_atk2_duration then
    light_num = 2
  end
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit and unit ~= caster and not unit.config.is_summoned and not unit.buff_effects.untargetable and not unit.TitanMM_atk2_buff_on and 1 <= light_num then
      local binfo = ed.lookupDataTable("Buff", nil, TitanMM.TitanMM_ult_buff_ID)
      local buff = ed.BuffCreate(binfo, unit, caster)
      buff:setAttribute("AD", skillult.info["Script Arg2"] * caster.attribs.AP)
      buff:setAttribute("AP", skillult.info["Script Arg3"] * caster.attribs.AP)
      buff:setAttribute("MPGainRatio", skillult.info["Script Arg4"])
      unit.TitanMM_atk2_buff_count = 1
      buff.onRemoved = override(buff.onRemoved, TitanMM.skillatk2_buff_onRemoved)
      unit:addBuff(buff, caster)
      light_num = light_num - 1
    end
  end
end

function TitanMM.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local unit = skill.caster
  unit.TitanMM_ult_timer1 = unit.TitanMM_ult_timer1 + dt_action
  unit.TitanMM_ult_timer2 = unit.TitanMM_ult_timer2 + dt_action
  local skillultb = unit.skills.TitanMM_ultb
  if unit.TitanMM_ult_timer1 >= 0.75 and skillultb and skill == skill.caster.current_skill and unit.TitanMM_ult_timer2 >= 1.25 then
    skillultb:takeEffectAt(unit.position, skill.caster)
    unit.TitanMM_ult_timer1 = 0
  end
end

function TitanMM.skillult_start(basefunc, skill, target)
  basefunc(skill)
  local hero = skill.caster
  local bid = TitanMM.TitanMM_ult_Uncontrollable
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanMM.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == TitanMM.TitanMM_ult_Uncontrollable then
      tbuff.timer = -1
    end
  end
end

function TitanMM.skillult_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if result and (not caster.TitanMM_enter_casted or skill.casting) then
    return false
  end
  return result
end

function TitanMM.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, -25 do
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
  end
  if maxcount <= 0 then
    return false
  end
end

function TitanMM.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local star = skill.caster.stars
  buff:setAttribute("PIMU", 50 - 7 * (10 - star))
  buff:setAttribute("MIMU", 50 - 7 * (10 - star))
  return buff
end

function TitanMM.skillatk3b_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local target = skill.target
  local mppower = 80
  if target and target:isAlive() then
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
  end
end

function TitanMM.skillultb_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local mppower = 120
  if target and target:isAlive() then
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
  end
end

function TitanMM.skillatk2_start(basefunc, skill, target)
  basefunc(skill)
  local hero = skill.caster
  local bid = TitanMM.TitanMM_cast_stable_ID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanMM.skillatk3_start(basefunc, skill, target)
  basefunc(skill)
  local hero = skill.caster
  local bid = TitanMM.TitanMM_cast_stable_ID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanMM.init_hero(hero)
  local skillult = hero.skills.TitanMM_ult
  local skillultb = hero.skills.TitanMM_ultb
  local skillatk2 = hero.skills.TitanMM_atk2
  local skillatk3 = hero.skills.TitanMM_atk3
  local skillatk3b = hero.skills.TitanMM_atk3b
  local skillatk4 = hero.skills.TitanMM_atk4
  local skillenter = hero.skills.TitanMM_enter
  hero.TitanMM_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.reset = override(hero.reset, TitanMM.hero_reset)
  hero.update = override(hero.update, TitanMM.hero_update)
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanMM.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, TitanMM.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanMM.skillult_takeEffectOn)
    skillult.update = override(skillult.update, TitanMM.skillult_update)
    skillult.finish = override(skillult.finish, TitanMM.skillult_finish)
  end
  if skillatk2 then
    skillatk2.selectTarget = override(skillatk2.selectTarget, TitanMM.skillatk2_selectTarget)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, TitanMM.skillatk2_canCastWithTarget)
    hero.canPanelTrigger = override(hero.canPanelTrigger, TitanMM.hero_canPanelTrigger)
    hero.castManualSkill = override(hero.castManualSkill, TitanMM.hero_castManualSkill)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanMM.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanMM.skillatk2_createBuff)
    hero.collectBuff = override(hero.collectBuff, TitanMM.collectBuff)
  end
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, TitanMM.skillatk3_canCastWithTarget)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanMM.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, TitanMM.skillatk3_finish)
  end
  if skillenter then
    skillenter.start = override(skillenter.start, TitanMM.skillenter_start)
    skillenter.finish = override(skillenter.finish, TitanMM.skillenter_finish)
  end
  if skillatk4 and hero.TitanMM_hasArcana > 1 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanMM.skillatk4_createBuff)
  end
  if skillatk3b and hero.TitanMM_hasArcana > 2 then
    skillatk3b.onAttackFrame = override(skillatk3b.onAttackFrame, TitanMM.skillatk3b_onAttackFrame)
  end
  if skillultb and hero.TitanMM_hasArcana > 2 then
    skillultb.takeEffectOn = override(skillultb.takeEffectOn, TitanMM.skillultb_takeEffectOn)
  end
  if skillatk2 and hero.TitanMM_hasArcana > 3 then
    skillatk2.start = override(skillatk2.start, TitanMM.skillatk2_start)
  end
  if skillatk3 and hero.TitanMM_hasArcana > 3 then
    skillatk3.start = override(skillatk3.start, TitanMM.skillatk3_start)
  end
  return hero
end

return TitanMM.init_hero
