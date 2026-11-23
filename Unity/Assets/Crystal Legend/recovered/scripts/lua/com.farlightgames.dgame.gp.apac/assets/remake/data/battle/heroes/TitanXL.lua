module("ed.battlehero", package.seeall)
local ed = ed
TitanXL = {}

function TitanXL.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1612
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  if caster and not caster.config.is_summoned then
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster.TitanXL_atk2_buff = buff
    caster:addBuff(buff, caster)
  end
end

function TitanXL.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillatk2 = caster.skills.TitanXL_atk2
  local skillatk2a = caster.skills.TitanXL_atk2a
  local target = skill.target
  if target and target:isAlive() then
    target:hurt()
  end
  if skillatk2 and attack_counter == 1 then
    if ed.run_with_scene then
      local effect_name = "eff_buff_TitanXL_atk2_2.cha"
      local origin = caster.position
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          caster.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
    if skillatk2a then
      skillatk2a.target = caster
      local region = skillatk2a:createRegion()
      region.takeRegionEffectOn = override(region.takeRegionEffectOn, TitanXL.skillatk2a_takeRegionEffectOn)
      region.position = {
        caster.position[1],
        caster.position[2]
      }
      caster.TitanXL_atk2_region = region
      ed.engine:addRegion(region)
    end
  end
  if skillatk2 and attack_counter == 3 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 1612 and tbuff.caster == caster then
        caster:removeBuff(tbuff)
      end
    end
  end
end

function TitanXL.skillatk2a_takeRegionEffectOn(basefunc, self, unit)
  local hero = self.skill.caster
  local skillatk2a = self.skill
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  if skillatk2a and hero:isAlive() then
    buff:setAttribute("HIT", -hero.attribs.STR * 0.3)
    if hero.TitanXL_hasArcana >= 4 then
      buff:setAttribute("Control Effects", {"disarm"})
      buff:setAttribute("Effect", "eff_buff_Earth_atk2.cha")
    end
  end
  unit:addBuff(buff)
end

function TitanXL.skillatk3_onAttackFrame(basufunc, skill)
  basufunc(skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillatk3 = caster.skills.TitanXL_atk3
  local target = skill.target
  if target and target:isAlive() then
    target:hurt()
  end
end

function TitanXL.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local HPR_Time = buff.timer
  local HPR_Count = 15000 / HPR_Time
  if caster.TitanXL_hasArcana >= 3 then
    buff:setAttribute("HPR", -HPR_Count)
  end
  if target then
    local bid = 4344
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("Time", HPR_Time)
    target:addBuff(buff, caster)
  end
  return buff
end

function TitanXL.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1610
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  if caster and not caster.config.is_summoned then
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster.TitanXL_atk4_buff = buff
    caster:addBuff(buff, caster)
  end
end

function TitanXL.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  basefunc(skill)
  if attack_counter == 1 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 1610 and tbuff.caster == caster then
        caster:removeBuff(tbuff)
      end
    end
  end
end

function TitanXL.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  if owner then
    owner.TitanXL_ad_count = 0
    owner.TitanXL_ap_count = 0
  end
  buff.onRemoved = override(buff.onRemoved, TitanXL.skillatk4_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, TitanXL.skillatk4_buffonDamaged)
  return buff
end

function TitanXL.skillatk4_buffonDamaged(basefunc, buff, damage, damage_type, source)
  local dmg, coe = basefunc(buff, damage, damage_type, source)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = caster.skills.TitanXL_atk4
  local dmg_downMAX = 1 - skillatk4.info["Script Arg2"] * 0.01
  if skillatk4 and caster:isAlive() then
    if damage and damage_type == "AD" then
      local dmg_ori = dmg
      owner.TitanXL_ad_count = owner.TitanXL_ad_count + 1
      dmg = dmg * math.max(1 - 0.15 * owner.TitanXL_ad_count, dmg_downMAX)
      local TitanXL_owner_lost = dmg_ori - dmg
      local mp_gain = TitanXL_owner_lost * owner.info["MP Gain Rate"] / owner.attribs.HP * (owner.attribs.MPRatio * 0.01 + 1)
      owner:setMP(owner.mp + mp_gain * ed.engine.mp_bonus)
    elseif damage and damage_type == "AP" then
      local dmg_ori = dmg
      owner.TitanXL_ap_count = owner.TitanXL_ap_count + 1
      dmg = dmg * math.max(1 - 0.15 * owner.TitanXL_ap_count, dmg_downMAX)
      local TitanXL_owner_lost = dmg_ori - dmg
      local mp_gain = TitanXL_owner_lost * owner.info["MP Gain Rate"] / owner.attribs.HP * (owner.attribs.MPRatio * 0.01 + 1)
      owner:setMP(owner.mp + mp_gain * ed.engine.mp_bonus)
    end
  end
  return dmg, coe
end

function TitanXL.skillatk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner then
    owner.TitanXL_ad_count = 0
    owner.TitanXL_ap_count = 0
  end
end

function TitanXL.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function TitanXL.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
  elseif attack_counter == 1 then
    local bid = 4343
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if not unit.config.is_boss and not unit.config.is_summoned then
        if caster.TitanXL_hasArcana >= 2 then
          unit:takeHeal(100, "mp", caster)
        end
        local buff = ed.BuffCreate(binfo, unit, caster)
        buff.update = override(buff.update, TitanXL.skillultb_Buff_update)
        buff.onRemoved = override(buff.onRemoved, TitanXL.skillultb_Buff_onRemoved)
        unit:addBuff(buff, caster)
        unit.ult_origMP = unit.mp
        unit.TitanXL_ultBuff_Time = 0
      end
    end
  end
end

function TitanXL.skillultb_Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanXL_ult
  local MPR_time = buff.info.Time
  local mp_persec = skillult.info["Script Arg2"] / MPR_time
  local owner_origMP = owner.ult_origMP
  if not owner.TitanXL_ultBuff_Time then
    owner.TitanXL_ultBuff_Time = 0
  end
  if owner.TitanXL_ultBuff_Time < 0 or MPR_time <= owner.TitanXL_ultBuff_Time then
    return
  end
  owner.TitanXL_ultBuff_Time = owner.TitanXL_ultBuff_Time + dt
  if skillult and owner:isAlive() and caster:isAlive() then
    owner:setMP(owner.mp + mp_persec * dt)
  end
  if owner.mp < owner_origMP + mp_persec * owner.TitanXL_ultBuff_Time then
    local MP_restTime = MPR_time - owner.TitanXL_ultBuff_Time
    owner:setMP(owner.mp + mp_persec * MP_restTime)
    buff.timer = -1
    owner.TitanXL_ultBuff_Time = -999
  end
  if MPR_time <= owner.TitanXL_ultBuff_Time then
    buff.timer = -1
    owner.TitanXL_ultBuff_Time = -999
  end
end

function TitanXL.skillultb_Buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local effect_name = "eff_buff_TitanXL_ult2.cha"
  local origin = owner.position
  if ed.run_with_scene and effect_name then
    ed.scene:playEffectOnScene(effect_name, origin, {
      owner.direction * 1,
      1
    }, nil, 1)
  end
  owner.TitanXL_ultBuff_Time = 0
end

function TitanXL.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanXL.hero_update(basefunc, self, dt)
  basefunc(self, dt)
  local skillatk2 = self.skills.TitanXL_atk2
  local skillatk4 = self.skills.TitanXL_atk4
  if self.actor and self.direction ~= self.lastDirection then
    if self.direction == -1 then
      if self.info.Name == "TitanXL" then
        self.actor.puppet:setComponent("tou_01", "tou_01_s")
        self.actor.puppet:setComponent("tou_02", "tou_02_s")
        self.actor.puppet:setComponent("tou_03", "tou_03_s")
      end
    elseif self.info.Name == "TitanXL" then
      self.actor.puppet:setComponent("tou_01", "tou_01")
      self.actor.puppet:setComponent("tou_02", "tou_02")
      self.actor.puppet:setComponent("tou_03", "tou_03")
    end
    local actionName = self.actor:getActionName(self.action_name)
    self.actor.puppet:setAction(actionName)
    self.actor.puppet:setLoop(self.action_loop)
    self.actor.puppet:setActionElapsed(self.action_elapsed)
  end
  self.lastDirection = self.direction
  if ed.run_with_scene and self.actor then
    self.actor.cheer = override(self.actor.cheer, TitanXL.actor_cheer)
  end
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID ~= 1610 or tbuff.caster == self then
    end
  end
  if skillatk2 and self:isAlive() and self.TitanXL_atk2_buff and self.current_skill ~= skillatk2 then
    self.TitanXL_atk2_buff.timer = -1
  end
  if skillatk4 and self:isAlive() and self.TitanXL_atk4_buff and self.current_skill ~= skillatk4 then
    self.TitanXL_atk4_buff.timer = -1
  end
end

function TitanXL.actor_cheer(basefunc, actor)
  local caster = actor.model
  if caster.direction == -1 then
    if caster.info.Name == "TitanXL" then
      caster.actor.puppet:setComponent("tou_01", "tou_01_s")
      caster.actor.puppet:setComponent("tou_02", "tou_02_s")
      caster.actor.puppet:setComponent("tou_03", "tou_03_s")
    end
  elseif caster.info.Name == "TitanXL" then
    caster.actor.puppet:setComponent("tou_01", "tou_01")
    caster.actor.puppet:setComponent("tou_02", "tou_02")
    caster.actor.puppet:setComponent("tou_03", "tou_03")
  end
  basefunc(actor)
end

function TitanXL.hero_onDying(basefunc, self, killer)
  basefunc(self, killer)
  if self.actor then
    if self.direction == -1 then
      if self.info.Name == "TitanXL" then
        self.actor.puppet:setComponent("tou_01", "tou_01_s")
        self.actor.puppet:setComponent("tou_02", "tou_02_s")
        self.actor.puppet:setComponent("tou_03", "tou_03_s")
      end
    elseif self.info.Name == "TitanXL" then
      self.actor.puppet:setComponent("tou_01", "tou_01")
      self.actor.puppet:setComponent("tou_02", "tou_02")
      self.actor.puppet:setComponent("tou_03", "tou_03")
    end
  end
end

function TitanXL.init_hero(hero)
  local skillatk = hero.skills.TitanXL_atk
  local skillatk2 = hero.skills.TitanXL_atk2
  local skillatk3 = hero.skills.TitanXL_atk3
  local skillatk4 = hero.skills.TitanXL_atk4
  local skillult = hero.skills.TitanXL_ult
  hero.TitanXL_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.update = override(hero.update, TitanXL.hero_update)
  hero.onDying = override(hero.onDying, TitanXL.hero_onDying)
  if skillatk then
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanXL.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanXL.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanXL.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanXL.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanXL.skillatk4_start)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanXL.skillatk4_createBuff)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanXL.skillatk4_onAttackFrame)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanXL.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanXL.skillult_onAttackFrame)
  end
  return hero
end

return TitanXL.init_hero
