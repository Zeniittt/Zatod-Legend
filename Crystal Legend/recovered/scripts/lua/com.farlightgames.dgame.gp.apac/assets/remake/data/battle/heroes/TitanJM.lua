module("ed.battlehero", package.seeall)
local ed = ed
TitanJM = {}

function TitanJM.hero_reset(basefunc, hero)
  basefunc(hero)
  if hero.config.is_boss then
    local bid = 4695
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function TitanJM.ult_func_hideBuffEffect(unit)
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

function TitanJM.ult_func_resetBuffEffect(unit)
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

function TitanJM.shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanJM_shield = nil
end

function TitanJM.add_Shield(hero, shield_vaule)
  local max = 150000
  if not hero.TitanJM_shield then
    local bid = 4686
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local shield_buff = ed.BuffCreate(binfo, hero, hero)
    shield_buff.onRemoved = override(shield_buff.onRemoved, TitanJM.shield_onRemoved)
    shield_buff.shield = shield_vaule
    hero.TitanJM_shield = hero:addBuff(shield_buff, hero)
    if max < shield_buff.shield then
      shield_buff.shield = max
    end
  else
    local buff = hero.TitanJM_shield
    local shield = buff.shield
    buff.shield = shield + shield_vaule
    buff.timer = buff.info.Time
    if buff.shield <= 0 and hero.TitanJM_shield then
      hero:removeBuff(hero.TitanJM_shield)
    end
    if max < buff.shield then
      buff.shield = max
    end
  end
end

function TitanJM.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4689
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  TitanJM.ult_func_hideBuffEffect(caster)
  basefunc(skill, target)
end

function TitanJM.skillatk2_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4689 then
      tbuff.timer = -1
    end
  end
  TitanJM.ult_func_resetBuffEffect(caster)
  basefunc(skill, target)
end

function TitanJM.skillatk2_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local target = skill.target
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanJM_atk2
  local skillatk2s = caster.skills.TitanJM_atk2s
  local TitanJM_region
  if caster.name == "TitanJM" and skillatk2 and skillatk2s then
    skillatk2s.target = caster
    TitanJM_region = skillatk2s:createRegion()
    caster.TitanJM_region = TitanJM_region
    local position = {
      caster.position[1],
      caster.position[2]
    }
    TitanJM_region.position = position
    ed.engine:addRegion(TitanJM_region)
  end
  local heal = caster.attribs.HP * 0.1
  if target and caster and skillatk2 and 1 < caster.TitanJM_hasArcana then
    caster:takeHeal(50, "mp", caster)
    caster:takeHeal(heal, "hp", caster)
  end
end

function TitanJM.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4690
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanJM.skillatk4_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4690 then
      tbuff.timer = -1
    end
  end
  basefunc(skill, target)
end

function TitanJM.skillatk4_takeEffectOn(basefunc, skill, target)
  local target = skill.target
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanJM_atk4
  if target then
    local heal = caster.attribs.HEAL or 0
    local power, coefficient = skill:power(caster, target, "HP")
    local power = power * (1 + heal / 100)
    local atk4_ShieldValue = power * (math.max((target.attribs.HealRatio or 0) / 100, -1) + 1)
    local atk4_hp_gap = target.attribs.HP - target.hp
    if atk4_ShieldValue > atk4_hp_gap and target.camp == caster.camp and skillatk4 then
      local atk4_AddShield = atk4_ShieldValue - atk4_hp_gap
      TitanJM.add_Shield(target, atk4_AddShield)
    end
  end
  if skillatk4 and caster.TitanJM_hasArcana > 3 then
    local bid = 4685
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, target)
  end
  basefunc(skill, target)
end

function TitanJM.skillatk4_update(basefunc, self, dt)
  local caster = self.skill.caster
  self.jump_timer = self.jump_timer - dt
  if self.jump_timer <= 0 then
    if 0 < self.jumps_remaining then
      self.source = self.target
      self.target = self:findNextTaeget()
      local skill = self.skill
      skill.target = self.target
      if self.target and self.source then
        self:jump()
        return
      end
    end
    self:terminate()
  end
end

function TitanJM.skillatk4_chain_jump(basefunc, chain)
  local target = chain.target
  local caster = chain.skill.caster
  local source = chain.source
  local skillatk4 = caster.skills.TitanJM_atk4
  local atk4_ShieldValue = skillatk4.info["Script Arg2"]
  local atk4_hp_gap = target.attribs.HP - target.hp
  if source then
    for i, tbuff in ipairs(source.buff_list) do
      if tbuff.info.ID == 4691 then
        tbuff.timer = -1
      end
    end
  end
  if atk4_ShieldValue > atk4_hp_gap and target.camp == caster.camp and skillatk4 then
    local bid = 4691
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, target)
    local atk4_AddShield = atk4_ShieldValue - atk4_hp_gap
    TitanJM.add_Shield(target, atk4_AddShield)
  end
  if skillatk4 and caster.TitanJM_hasArcana > 3 then
    local bid = 4685
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, target)
  end
  basefunc(chain)
end

function TitanJM.skillatk4_chain_findNextTaeget(basefunc, self)
  local ret
  local min = -math.huge
  local Ignore = self.skill:Ignore_Target_Type()
  local skill = self.skill
  local caster = skill.caster
  local skillatk4_camp = caster.camp
  local selector = skill.target_selectors.weakest
  if self.source and skill then
    for unit in ed.engine:foreachAliveUnit(skillatk4_camp) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.camp ~= caster.camp then
      else
        local times = self.affect_times[unit] or 0
        if 0 < times then
        else
          local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - 6400)
          if distanceSQ > skill.min_range_sq and distanceSQ < skill.max_range_sq then
            local v = selector(unit)
            local shouldIgnore = Ignore(unit)
            if min < v and not shouldIgnore then
              min = v
              ret = unit
            end
          end
        end
      end
    end
  end
  return ret
end

function TitanJM.skillatk4_createChain(basefunc, skill)
  local caster = skill.caster
  local chain = basefunc(skill)
  chain.jump = override(chain.jump, TitanJM.skillatk4_chain_jump)
  chain.findNextTaeget = override(chain.findNextTaeget, TitanJM.skillatk4_chain_findNextTaeget)
  chain.update = override(chain.update, TitanJM.skillatk4_update)
  return chain
end

function TitanJM.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4692
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanJM.skillult_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4692 then
      tbuff.timer = -1
    end
  end
  basefunc(skill, target)
end

function TitanJM.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.TitanJM_ult
  local target = skill.target
  if skillult and target then
    if attack_counter == 0 then
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanJM_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      for unit in ed.engine:foreachAliveUnit(caster.camp) do
        local heal = caster.attribs.HEAL or 0
        local power, coefficient = skill:power(caster, unit, "HP")
        local power = power * (1 + heal / 100)
        local ult_ShieldValue = power * (math.max((unit.attribs.HealRatio or 0) / 100, -1) + 1)
        local ult_hp_gap = unit.attribs.HP - unit.hp
        if ult_ShieldValue > ult_hp_gap and unit.camp == unit.camp and skillult and unit and not unit.config.is_summoned then
          local ult_AddShield = ult_ShieldValue - ult_hp_gap
          TitanJM.add_Shield(unit, ult_AddShield)
        end
      end
      local bid = 4694
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      buff.update = override(buff.update, TitanJM.effect_update)
      basefunc(skill)
    end
  end
end

function TitanJM.effect_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if not TitanJM.effect_time then
    TitanJM.effect_time = 0
  else
    TitanJM.effect_time = TitanJM.effect_time + dt
  end
  if TitanJM.effect_time > 0.8 and owner then
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanJM_ult.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, nil, nil, 1)
    end
    TitanJM.effect_time = TitanJM.effect_time - 0.8
  end
end

function TitanJM.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.update = override(buff.update, TitanJM.skillultbuff_update)
  return buff
end

function TitanJM.skillultbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanJM_ult
  if caster.TitanJM_hasArcana > 2 and skillult and owner and caster and owner.mp > 800 and not owner.Arcana_takeHeal then
    owner.Arcana_takeHeal = true
    owner:takeHeal(200, "mp", owner)
    owner:removeBuff(buff)
  end
end

function TitanJM.init_hero(hero)
  local skillatk2 = hero.skills.TitanJM_atk2
  local skillatk4 = hero.skills.TitanJM_atk4
  local skillult = hero.skills.TitanJM_ult
  hero.TitanJM_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if hero.config.is_boss then
    hero.reset = override(hero.reset, TitanJM.hero_reset)
  end
  if skillatk4 and hero.TitanJM_hasArcana > 3 then
    skillatk4.info = ed.wraptable(skillatk4.info, {
      ["Chain Jumps"] = 4
    })
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanJM.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, TitanJM.skillatk2_finish)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanJM.skillatk2_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanJM.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanJM.skillatk4_finish)
    skillatk4.createChain = override(skillatk4.createChain, TitanJM.skillatk4_createChain)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanJM.skillatk4_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanJM.skillult_start)
    skillult.finish = override(skillult.finish, TitanJM.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanJM.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, TitanJM.skillult_createBuff)
  end
  return hero
end

return TitanJM.init_hero
