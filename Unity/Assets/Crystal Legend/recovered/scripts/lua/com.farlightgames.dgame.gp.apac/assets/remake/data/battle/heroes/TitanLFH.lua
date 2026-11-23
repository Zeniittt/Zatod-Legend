module("ed.battlehero", package.seeall)
local ed = ed
TitanLFH = {}

function TitanLFH.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanLFH_atk2
  local aim_position
  local attack_counter = skill.attack_counter
  if skillatk2 and attack_counter <= 1 then
    if caster.TitanLFH_hasArcana and caster.TitanLFH_hasArcana >= 2 then
      aim_position = TitanLFH.DOP_in_battlefield(caster, 1000, caster.camp)
      local atk2_originfo = skill.info
      skill.info = ed.wraptable(atk2_originfo, {
        ["Shape Arg1"] = 1000
      })
      skillatk2:takeEffectAt(aim_position)
      skill.info = atk2_originfo
      local effect_name = "eff_buff_TitanLFH_atk2.cha"
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(effect_name, {
          aim_position[1],
          aim_position[2]
        }, {
          caster.direction * 1,
          1
        }, nil, 1)
      end
      for unit in ed.engine:foreachAliveUnit(caster.camp) do
        if unit.buff_effects.untargetable then
          break
        end
        if unit.config.is_summoned then
          break
        end
        local bid = 4369
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local TitanLFH_HealRatioBuff = ed.BuffCreate(binfo, unit, caster)
        unit:takeHeal(10000, "hp", caster)
        unit:addBuff(TitanLFH_HealRatioBuff, caster)
      end
    else
      aim_position = TitanLFH.DOP_in_battlefield(caster, 120, caster.camp)
      skillatk2:takeEffectAt(aim_position)
      local effect_name = "eff_buff_TitanLFH_atk2.cha"
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(effect_name, {
          aim_position[1],
          aim_position[2]
        }, {
          caster.direction * 1,
          1
        }, nil, 1)
      end
    end
  end
end

function TitanLFH.DOP_in_battlefield(caster, radius, camp)
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
    return caster.position
  end
end

function TitanLFH.need_interrupt(skill)
  local current_phase_idx = skill and skill.current_phase_idx
  local max_phase_idx = skill and #skill.phase_list
  local max_event_idx = current_phase_idx and skill.current_phase and type(skill.current_phase.event_list) == "table" and #skill.current_phase.event_list
  local next_event_idx = current_phase_idx and skill.next_event_idx
  local need
  if skill and current_phase_idx and max_phase_idx and max_event_idx and next_event_idx then
    if current_phase_idx < max_phase_idx then
      need = true
    elseif current_phase_idx == max_phase_idx and max_event_idx >= next_event_idx then
      need = true
    end
  end
  return need
end

function TitanLFH.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanLFH_atk3
  local skillatk3a = caster.skills.TitanLFH_atk3a
  local aim_position = caster.position
  local attack_counter = skill.attack_counter
  aim_position = TitanLFH.DOP_in_battlefield(caster, 120, caster.camp)
  if skillatk3 and attack_counter < 3 then
    basefunc(skill)
  elseif skillatk3a then
    local maxMP_target = skillatk3a:selectTarget()
    if caster.TitanLFH_hasArcana and 3 <= caster.TitanLFH_hasArcana then
      for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
        if unit.buff_effects.untargetable then
          break
        end
        if unit.buffManager.invisible then
          break
        end
        local effect_name = "eff_buff_TitanLFH_atk3.cha"
        if ed.run_with_scene then
          ed.scene:playEffectOnScene(effect_name, {
            unit.position[1],
            unit.position[2]
          }, {
            unit.direction * 1,
            1
          }, nil, 1)
        end
        skillatk3a:takeEffectOn(unit, caster)
      end
    else
      if not maxMP_target then
        local maxUnit
        local maxmp = 0
        for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
          if not unit.buff_effects.untargetable and maxmp <= unit.mp then
            maxUnit = unit
            maxmp = unit.mp
          end
        end
        if maxUnit then
          maxMP_target = maxUnit
        end
      end
      if maxMP_target then
        local effect_name = "eff_buff_TitanLFH_atk3.cha"
        if ed.run_with_scene then
          ed.scene:playEffectOnScene(effect_name, {
            maxMP_target.position[1],
            maxMP_target.position[2]
          }, {
            maxMP_target.direction * 1,
            1
          }, nil, 1)
        end
        skillatk3a:takeEffectOn(maxMP_target, caster)
      end
    end
  end
end

function TitanLFH.skillatk3a_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk3a = caster.skills.TitanLFH_atk3a
  if caster:isAlive() and skillatk3a then
    buff.update = override(buff.update, TitanLFH.skillatk3aBuff_update)
    buff.onRemoved = override(buff.onRemoved, TitanLFH.skillatk3aBuff_onRemoved)
  end
  buff.paralyzeTime = 0
  return buff
end

function TitanLFH.skillatk3aBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3a = caster.skills.TitanLFH_atk3a
  local paralyizeRatio = (skillatk3a.info["Script Arg2"] + caster.attribs.INT * 5.0E-4) / 100
  local target_need_interrupt = TitanLFH.need_interrupt(owner.current_skill)
  if caster:isAlive() then
    buff.paralyzeTime = buff.paralyzeTime and buff.paralyzeTime + dt or dt
    local target_casting1 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
    if owner and owner:isAlive() and target_casting1 ~= nil and target_casting1 ~= owner.info["Basic Skill"] then
      local interruptRand = ed.rand()
      if paralyizeRatio > interruptRand and owner.TitanLFH_interrupt ~= true then
        owner:hurt()
        local target_casting2 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
        local interrupt = false
        if target_casting2 == nil and target_need_interrupt == true then
          interrupt = true
        end
        if interrupt == true and owner:isAlive() and not owner.buff_effects.invulnerable then
          local amount = 0
          if owner.config.is_boss then
            amount = caster.hp * 0.1
          else
            amount = owner.hp * 0.1
          end
          amount = math.min(amount, caster.attribs.HP * 0.1)
          owner:takeDamage(amount, "Holy", "hp", caster, 1, 1)
          owner.TitanLFH_interrupt = true
        end
      end
    end
  else
    buff.timer = -1
  end
end

function TitanLFH.skillatk3aBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.paralyzeTime = 0
end

function TitanLFH.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanLFH_atk4
  local CON_plus = skillatk4.info["Script Arg3"]
  owner.TitanLFH_atk4_Buff = true
  buff.onRemoved = override(buff.onRemoved, TitanLFH.skillatk4_buffonRemoved)
  if owner.name == "TitanLFH" or owner.name == "LFH" or owner.name == "TitanXL" or owner.name == "XL" or owner.name == "TitanLE" or owner.name == "LE" or owner.name == "TitanLMX" or owner.name == "LMX" or owner.name == "TitanXE" or owner.name == "XE" then
    buff.info.Effect = "eff_buff_TitanLFH_atk42.cha"
  end
  return buff
end

function TitanLFH.skillatk4_buffonRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.TitanLFH_atk4_Buff = false
  basefunc(buff)
end

function TitanLFH.hero_collectBuff(basefunc, self, config)
  if config then
    local buff = config.buff
    local owner = buff.owner
    local caster = buff.caster
    local hero = self
    local skillatk4 = hero.skills.TitanLFH_atk4
    local TitanLFH_atk4Ratio = skillatk4.info["Script Arg2"] / 100
    if caster and caster.TitanLFH_atk4_Buff and (not caster or type(caster.tid) ~= "number" or not (caster.tid > 100000)) and hero:isAlive() and not buff.TitanLFH_trigger then
      if buff:isCrlEftConflictWithUncontrollable() and caster.camp == hero.camp and caster.camp ~= owner.camp then
        local TitanLFH_atk4_TimeRatio = skillatk4.info["Script Arg3"] / 100
        buff.timer = buff.timer * (1 + TitanLFH_atk4_TimeRatio)
      end
      if (caster.name == "TitanLFH" or caster.name == "LFH" or caster.name == "TitanXL" or caster.name == "XL" or caster.name == "TitanLE" or caster.name == "LE" or caster.name == "TitanLMX" or caster.name == "LMX" or caster.name == "TitanXE" or caster.name == "XE") and caster.camp == hero.camp and caster.camp == owner.camp then
        local info = buff.info
        local attribs = owner.attribs
        local buff_attribs = {}
        for name, value in pairs(info) do
          if name == "HP" or name == "MP" or name == "HPR" or name == "MPR" or name == "PIMU" or name == "MIMU" or name == "ALLMIMU" or name == "HAST" or name == "MSPD" or name == "CDR" or name == "Time" then
          elseif not value or value and type(value) == "number" and value <= 0 then
          elseif attribs[name] then
            if not buff_attribs[name] then
              buff_attribs[name] = value
            else
              buff_attribs[name] = value + buff_attribs[name]
            end
          end
        end
        if not owner.config.is_boss then
          for name, value in pairs(buff_attribs) do
            buff:setAttribute(name, value * (1 + TitanLFH_atk4Ratio))
          end
        end
      end
      buff.TitanLFH_trigger = true
    end
  end
end

function TitanLFH.isCrlEftConflictWithUncontrollableSP(buff)
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

function TitanLFH.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanLFH_ult
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      local list = unit.buff_list
      local debuff_list = {}
      local my_camp = caster.camp
      for i = 1, #list do
        local buff = list[i]
        local info = buff.info
        if buff and (not buff.caster or buff.caster.camp ~= my_camp) and (TitanLFH.isCrlEftConflictWithUncontrollableSP(buff) or buff.info.Dispel == "YES") then
          debuff_list[#debuff_list + 1] = buff
        end
      end
      for i = 1, #debuff_list do
        unit:removeBuff(debuff_list[i])
      end
      if caster.TitanLFH_hasArcana and caster.TitanLFH_hasArcana >= 4 and #debuff_list then
        unit:takeHeal(#debuff_list * 3000, "hp", caster)
      end
    end
  else
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      local bid = 4372
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local TitanLFH_ultaBuff = ed.BuffCreate(binfo, unit, caster)
      local HAST = skillult.info["Script Arg3"]
      local MSPD = skillult.info["Script Arg3"]
      local TitanLFH_ultaBuffTimer = skillult.info["Script Arg2"]
      TitanLFH_ultaBuff:setAttribute("HAST", HAST)
      TitanLFH_ultaBuff:setAttribute("MSPD", HAST)
      TitanLFH_ultaBuff.info.Time = 3 + TitanLFH_ultaBuffTimer
      unit:addBuff(TitanLFH_ultaBuff, caster)
    end
  end
end

function TitanLFH.hero_update(basefunc, self, dt)
  basefunc(self, dt)
  if self.actor and self.direction ~= self.lastDirection then
    if self.direction == -1 then
      if self.info.Name == "TitanLFH" then
        self.actor.puppet:setComponent("beimian_huidai2", "beimian_huidai2_s")
        self.actor.puppet:setComponent("beimian_zuoshangbi", "beimian_zuoshangbi_s")
        self.actor.puppet:setComponent("zuoshangbi", "zuoshangbi_s")
        self.actor.puppet:setComponent("youshangbi", "youshangbi_s")
      end
    elseif self.info.Name == "TitanLFH" then
      self.actor.puppet:setComponent("beimian_huidai2", "beimian_huidai2")
      self.actor.puppet:setComponent("beimian_zuoshangbi", "beimian_zuoshangbi")
      self.actor.puppet:setComponent("zuoshangbi", "zuoshangbi")
      self.actor.puppet:setComponent("youshangbi", "youshangbi")
    end
    local actionName = self.actor:getActionName(self.action_name)
    self.actor.puppet:setAction(actionName)
    self.actor.puppet:setLoop(self.action_loop)
    self.actor.puppet:setActionElapsed(self.action_elapsed)
  end
  self.lastDirection = self.direction
  if ed.run_with_scene and not self.cheer_action_reset and self.actor then
    self.cheer_action_reset = true
    self.actor.cheer = override(self.actor.cheer, TitanLFH.cheer)
  end
end

function TitanLFH.cheer(basefunc, actor)
  local puppet = actor.puppet
  local cheerActionName = actor.model.direction == 1 and "Cheer" or "Cheer_s"
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  actor.velocity = {0, 0}
  actor.node:setScaleX(actor.model.direction)
  actor.node:setScaleY(1)
  actor.offline = true
end

function TitanLFH.hero_onDying(basefunc, self, killer)
  basefunc(self, killer)
  if self.actor then
    if self.direction == -1 then
      if self.info.Name == "TitanLFH" then
        self.actor.puppet:setComponent("beimian_huidai2", "beimian_huidai2_s")
        self.actor.puppet:setComponent("beimian_zuoshangbi", "beimian_zuoshangbi_s")
        self.actor.puppet:setComponent("zuoshangbi", "zuoshangbi_s")
        self.actor.puppet:setComponent("youshangbi", "youshangbi_s")
      end
    elseif self.info.Name == "TitanLFH" then
      self.actor.puppet:setComponent("beimian_huidai2", "beimian_huidai2")
      self.actor.puppet:setComponent("beimian_zuoshangbi", "beimian_zuoshangbi")
      self.actor.puppet:setComponent("zuoshangbi", "zuoshangbi")
      self.actor.puppet:setComponent("youshangbi", "youshangbi")
    end
  end
end

function TitanLFH.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.cheer_action_reset = nil
end

function TitanLFH.init_hero(hero)
  local skillatk = hero.skills.TitanLFH_atk
  local skillatk2 = hero.skills.TitanLFH_atk2
  local skillatk3 = hero.skills.TitanLFH_atk3
  local skillatk3a = hero.skills.TitanLFH_atk3a
  local skillatk4 = hero.skills.TitanLFH_atk4
  local skillult = hero.skills.TitanLFH_ult
  hero.TitanLFH_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.update = override(hero.update, TitanLFH.hero_update)
  hero.onDying = override(hero.onDying, TitanLFH.hero_onDying)
  hero.reset = override(hero.reset, TitanLFH.hero_reset)
  if skillatk then
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanLFH.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanLFH.skillatk3_onAttackFrame)
  end
  if skillatk3a then
    skillatk3a.createBuff = override(skillatk3a.createBuff, TitanLFH.skillatk3a_createBuff)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanLFH.skillatk4_createBuff)
    hero.collectBuff = override(hero.collectBuff, TitanLFH.hero_collectBuff)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanLFH.skillult_onAttackFrame)
  end
  return hero
end

return TitanLFH.init_hero
