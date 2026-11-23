module("ed.battlehero", package.seeall)
local ed = ed
Brahma = {}
Brahma.ult_bid = 1446
Brahma.atk2_stun_bid = 1447
Brahma.atk3_trigger_bid = 1449
Brahma.nil_bid = 1259
Brahma.atk4_shield_ratio = 0.2
Brahma.atk4_shield_bid = 1450
Brahma.uncontrol_bid = 1338
Brahma.awake_position_left = {200, 30}
Brahma.awake_position_right = {600, 30}
Brahma.awake_hpr_bid = 1451
Brahma.Brahma_fashion_ID = 100671

function Brahma.skillult_deal_damage(buff, target, buff_attribs)
  local damage_para = 0
  for name, value in pairs(buff_attribs) do
    if target.attribs[name] then
      local temp_para = 0
      if target.attribs[name] ~= 0 then
        temp_para = math.min(value / target.attribs[name], 2)
        if target.Brahama_ult_collect and target.attribs[name] - value ~= 0 then
          temp_para = math.min(value / (target.attribs[name] - value), 2)
        end
      else
        temp_para = math.min(value / 100, 2)
      end
      damage_para = damage_para + math.abs(temp_para)
    end
  end
  local addition_ratio = math.min(1 + damage_para, 10)
  local caster = buff.caster
  local skillultb = caster.skills.Brahma_ultb
  if skillultb and (0 < damage_para or not buff.Brahma_ult_first_damaged) then
    local originfo = skillultb.info
    skillultb.info = ed.wraptable(originfo, {
      ["Basic Num"] = originfo["Basic Num"] * addition_ratio,
      ["Plus Ratio"] = originfo["Plus Ratio"] * addition_ratio
    })
    skillultb:takeEffectOn(target)
    skillultb.info = originfo
  end
end

function Brahma.skillult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  if caster.attribute_ratio ~= 1 then
    caster.Brahma_temp_attribute_ratio = caster.attribute_ratio
    caster.attribute_ratio = 1
  end
  local buff_attribs = {}
  for i, tbuff in ipairs(owner.buff_list) do
    local attribs = owner.attribs
    local info = tbuff.info
    if tbuff.info.ID == Brahma.ult_bid then
    elseif tbuff.info.ID == 219 then
    elseif tbuff.info.ID == 4214 then
    elseif tbuff.CreatedByHunterHunter then
    elseif tbuff.caster and type(tbuff.caster.tid) == "number" and tbuff.caster.tid > 100000 then
    else
      for name, value in pairs(info) do
        if name == "HP" or name == "MP" or name == "HPR" then
          break
        end
        if attribs[name] then
          if not buff_attribs[name] then
            buff_attribs[name] = value
          else
            buff_attribs[name] = value + buff_attribs[name]
          end
        end
      end
    end
  end
  if buff_attribs.PIMU and buff_attribs.PIMU >= 100 then
    buff_attribs.PIMU = 0
  elseif buff_attribs.MIMU and 100 <= buff_attribs.MIMU then
    buff_attribs.MIMU = 0
  elseif buff_attribs.ALLIMU and 100 <= buff_attribs.ALLIMU then
    buff_attribs.ALLIMU = 0
  end
  if not owner.config.is_boss then
    for name, value in pairs(buff_attribs) do
      buff:setAttribute(name, -value)
    end
  end
  owner:rebuild()
  if not buff.Brahma_ult_first_damaged then
    if owner.info.ID ~= 272 then
      Brahma.skillult_deal_damage(buff, owner, buff_attribs)
    end
    owner.Brahma_ult_buff = buff
    buff.Brahma_ult_first_damaged = true
  end
  caster.attribute_ratio = caster.Brahma_temp_attribute_ratio
end

function Brahma.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.Brahma_ult_buff = nil
end

function Brahma.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Brahma.skillult_buff_update)
  buff.onRemoved = override(buff.onRemoved, Brahma.skillult_buff_onRemoved)
  return buff
end

function Brahma.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    if ed.run_with_scene then
      if Brahma.Brahma_fashion_ID and Brahma.Brahma_fashion_ID == caster.fashion_id then
        ed.scene:playEffectOnScene("eff_point_Brahma_ult_elite.cha", {400, -50}, {
          caster.direction,
          1
        }, nil, -1)
      else
        ed.scene:playEffectOnScene("eff_point_Brahma_ult.cha", {400, -50}, {
          caster.direction,
          1
        }, nil, -1)
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
  end
end

function Brahma.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  caster.Brahma_left = 0
  caster.Brahma_right = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.position[1] > caster.position[1] and unit.position[1] - caster.position[1] < 340 and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
      caster.Brahma_right = caster.Brahma_right + 1
    elseif unit.position[1] < caster.position[1] and caster.position[1] - unit.position[1] < 340 and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
      caster.Brahma_left = caster.Brahma_left + 1
    end
  end
  if not basefunc(skill, target) or caster.Brahma_left == 0 and caster.Brahma_right == 0 then
    return false
  end
  return true
end

function Brahma.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.Brahma_left > caster.Brahma_right then
    caster.direction = -1
  elseif caster.Brahma_left < caster.Brahma_right then
    caster.direction = 1
  else
    caster.direction = -caster:getInitDir()
  end
  caster.startdirection = caster.direction
  basefunc(skill, target)
end

function Brahma.skillatk2_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    local caster = skill.caster
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if unit.config.is_summoned then
        break
      end
      if unit.buff_effects.invulnerable then
        break
      end
      if unit.buff_effects.uncontrollable then
        break
      end
      local bid = Brahma.atk2_stun_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      unit:addBuff(binfo, caster)
      if unit.position[1] > caster.position[1] then
        unit.direction = -1
      else
        unit.direction = 1
      end
      caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * 0.5)
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
  end
end

function Brahma.skillatk3_selectTarget(basefunc, self, default)
  local target = basefunc(self, default)
  local distance = 9999
  local new_target = self.caster
  for unit in ed.engine:foreachAliveUnit(self.caster.camp) do
    if unit.config.is_summoned then
    else
      local basic_skill = unit.basic_skill
      if basic_skill and distance > basic_skill.info["Max Range"] then
        distance = basic_skill.info["Max Range"]
        new_target = unit
      end
    end
  end
  self.target = new_target
  return self.target
end

function Brahma.skillatk3_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local move_trigger
  if buff.previous_position and buff.previous_height then
    local shift = ed.edpDistanceSQ(owner.position, buff.previous_position)
    local z_shift = math.abs(caster.height - buff.previous_height)
    if 8 < shift or 1 < z_shift then
      move_trigger = true
    end
  end
  buff.previous_position = {
    owner.position[1],
    owner.position[2]
  }
  buff.previous_height = owner.height
  if move_trigger and (not owner.Brahma_atk3_uncontrollable or owner.Brahma_atk3_uncontrollable.timer <= 0) then
    local bid = Brahma.atk3_trigger_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, caster)
    owner.Brahma_atk3_uncontrollable = buff
    local skillatk3 = caster.skills.Brahma_atk3
    owner:takeHeal(skillatk3.info["Script Arg2"], "mp", caster)
  end
end

function Brahma.skillatk3_createBuff(basefunc, buff, skill)
  local buff = basefunc(buff, skill)
  buff.update = override(buff.update, Brahma.skillatk3_buff_update)
  return buff
end

function Brahma.collectHPchange(basefunc, self, config)
  local unit = config.unit
  if unit.camp ~= self.camp then
    return
  elseif config.hp_change > 0 then
    local skillatk4 = self.skills.Brahma_atk4
    if not self.Brahma_atk4_shield then
      local bid = Brahma.atk4_shield_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local sheild_buff = ed.BuffCreate(binfo, self, self)
      sheild_buff.onRemoved = override(sheild_buff.onRemoved, Brahma.skillatk4_shield_onRemoved)
      sheild_buff.shield = math.min(config.hp_change * Brahma.atk4_shield_ratio, skillatk4.info["Script Arg2"])
      self:addBuff(sheild_buff, self)
      self.Brahma_atk4_shield = sheild_buff
    else
      local buff = self.Brahma_atk4_shield
      local shield = buff.shield
      buff.shield = math.min(shield + config.hp_change * Brahma.atk4_shield_ratio, skillatk4.info["Script Arg2"])
      buff.timer = buff.info.Time
    end
  end
end

function Brahma.skillatk4_shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.Brahma_atk4_shield = nil
end

function Brahma.skillawake_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    local caster = skill.caster
    if ed.run_with_scene then
      local direction = caster:getInitDir()
      if direction == 1 then
        ed.scene:playEffectOnScene("eff_point_Brahma_awake.cha", Brahma.awake_position_left, {1, 1}, nil, 0)
      else
        ed.scene:playEffectOnScene("eff_point_Brahma_awake.cha", Brahma.awake_position_right, {-1, 1}, nil, 0)
      end
    end
  end
  basefunc(skill)
end

function Brahma.skillawake_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillawake = caster.skills.Brahma_awake
  local skillawakeb = caster.skills.Brahma_awakeb
  local target = skillawakeb:selectTarget(nil)
  if target then
    local bid = Brahma.awake_hpr_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local hpr_buff = ed.BuffCreate(binfo, target, caster)
    if caster.Brahma_awake_count then
      hpr_buff:setAttribute("HPR", caster.Brahma_awake_count * skillawake.info["Script Arg2"] / 5)
      target:addBuff(hpr_buff, caster)
    end
  end
  caster.Brahma_awake_count = nil
end

function Brahma.skillawake_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if not buff.Brahma_first_remove then
    for unit in ed.engine:foreachAliveUnit(owner.camp) do
      local is_buffremoved
      for i, tbuff in ipairs(unit.buff_list) do
        if not caster.Brahma_awake_count then
          break
        end
        if (not tbuff.caster or tbuff.caster.camp ~= owner.camp) and tbuff.info.Dispel == "YES" and caster.Brahma_awake_count < 15 then
          tbuff.timer = 0
          is_buffremoved = true
          caster.Brahma_awake_count = caster.Brahma_awake_count + 1
        end
        if ed.run_with_scene and is_buffremoved then
          ed.scene:playEffectOnScene("eff_impact_Brahma_awake.cha", unit.position, {
            owner.direction,
            1
          }, nil, 0)
        end
      end
    end
    buff.Brahma_first_remove = true
  end
end

function Brahma.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  caster.Brahma_awake_count = 0
  buff.update = override(buff.update, Brahma.skillawake_buff_update)
  buff.onRemoved = override(buff.onRemoved, Brahma.skillawake_buff_onRemoved)
  return buff
end

function Brahma.skillawake_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = Brahma.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function Brahma.skillawake_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Brahma.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Brahma.Brahma_update(basefunc, self, dt)
  local skill_fashionRegion = self.skills.Brahma_fashionRegion
  self.Brahma_StartTime = self.Brahma_StartTime and self.Brahma_StartTime + dt or dt
  if self.Brahma_StartTime >= 0.5 then
    local HealRatio_bid = 1533
    local HealRatio_binfo = ed.lookupDataTable("Buff", nil, HealRatio_bid)
    if Brahma.Brahma_fashion_ID and Brahma.Brahma_fashion_ID == self.fashion_id and skill_fashionRegion then
      skill_fashionRegion.target = self
      self.Brahma_fashionRegion = skill_fashionRegion:createRegion()
      ed.engine:addRegion(self.Brahma_fashionRegion)
      for unit in ed.engine:foreachAliveUnit(self.camp) do
        unit:addBuff(HealRatio_binfo, self)
      end
      self.Brahma_StartTime = -999
    end
  end
  basefunc(self, dt)
end

function Brahma.collectBuff(basefunc, self, config)
  if config then
    local buff = config.buff
    local owner = buff.owner
    if owner.Brahma_ult_buff and not owner.Brahama_ult_done and buff.info.ID ~= 219 and (not buff.caster or type(buff.caster.tid) ~= "number" or not (buff.caster.tid > 100000)) and buff.CreatedByHunterHunter ~= true then
      if self.Brahma_engine_ticks and self.Brahma_engine_ticks == ed.engine.ticks then
        for _, id in ipairs(self.Brahama_sametick_bufflist) do
          if id == buff.info.ID then
            return
          end
        end
        table.insert(self.Brahama_sametick_bufflist, buff.info.ID)
      else
        self.Brahma_engine_ticks = ed.engine.ticks
        self.Brahama_sametick_bufflist = {}
        table.insert(self.Brahama_sametick_bufflist, buff.info.ID)
      end
      local info = buff.info
      local attribs = owner.attribs
      local buff_attribs = {}
      for name, value in pairs(info) do
        if name == "HP" or name == "MP" or name == "HPR" or name == "MPR" then
        elseif value == 0 then
        elseif attribs[name] then
          buff_attribs[name] = value
        end
      end
      owner.Brahama_ult_collect = true
      Brahma.skillult_deal_damage(owner.Brahma_ult_buff, owner, buff_attribs)
      owner.Brahama_ult_collect = nil
    end
    if self.Brahma_awake_count and self.Brahma_awake_count < 15 and owner.camp == self.camp and (not buff.caster or buff.caster.camp ~= owner.camp) and buff.info.Dispel == "YES" and not buff.Brahma_trigger then
      local bid = Brahma.nil_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      config.buff = ed.BuffCreate(binfo, buff.owner, buff.caster)
      config.buff.Brahma_trigger = true
      self.Brahma_awake_count = self.Brahma_awake_count + 1
      if ed.run_with_scene and buff.owner then
        ed.scene:playEffectOnScene("eff_impact_Brahma_awake.cha", buff.owner.position, {
          owner.direction,
          1
        }, nil, 0)
      end
    end
  end
end

function Brahma.reset(basefunc, hero)
  basefunc(hero)
  hero.Brahma_atk4_shield = nil
  hero.Brahma_ult_buff = nil
  hero.Brahma_StartTime = 0
end

function Brahma.hero_die(basefunc, hero, killer)
  if hero.Brahma_fashionRegion then
    hero.Brahma_fashionRegion:terminate()
  end
  basefunc(hero, killer)
end

function Brahma.init_hero(hero)
  local skillult = hero.skills.Brahma_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, Brahma.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Brahma.skillult_onAttackFrame)
  end
  local skillatk2 = hero.skills.Brahma_atk2
  if skillatk2 then
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, Brahma.skillatk2_canCastWithTarget)
    skillatk2.start = override(skillatk2.start, Brahma.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Brahma.skillatk2_onAttackFrame)
  end
  local skillatk3 = hero.skills.Brahma_atk3
  if skillatk3 then
    skillatk3.selectTarget = override(skillatk3.selectTarget, Brahma.skillatk3_selectTarget)
    skillatk3.createBuff = override(skillatk3.createBuff, Brahma.skillatk3_createBuff)
  end
  local skillatk4 = hero.skills.Brahma_atk4
  if skillatk4 then
    hero.collectHPchange = override(hero.collectHPchange, Brahma.collectHPchange)
  end
  local skillawake = hero.skills.Brahma_awake
  if skillawake then
    skillawake.start = override(skillawake.start, Brahma.skillawake_start)
    skillawake.finish = override(skillawake.finish, Brahma.skillawake_finish)
    skillawake.onAttackFrame = override(skillawake.onAttackFrame, Brahma.skillawake_onAttackFrame)
    skillawake.createBuff = override(skillawake.createBuff, Brahma.skillawake_createBuff)
  end
  local Brahma_fashionID = Brahma.Brahma_fashion_ID
  if Brahma_fashionID then
    hero.update = override(hero.update, Brahma.Brahma_update)
  end
  hero.die = override(hero.die, Brahma.hero_die)
  hero.reset = override(hero.reset, Brahma.reset)
  hero.collectBuff = override(hero.collectBuff, Brahma.collectBuff)
  return hero
end

return Brahma.init_hero
