module("ed.battlehero", package.seeall)
local ed = ed
TitanSA = {}
TitanSA.ult_stealthBuff = 4578
TitanSA.ult_successBuff = 4579

function TitanSA.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local ratio = 1
  if caster and caster.TitanSA_hasArcana and caster.TitanSA_hasArcana >= 2 and target and caster.atk2_hitNum and caster.atk2_origposition then
    local list = skill:collectAoeTarget(caster.atk2_origposition, caster.direction)
    caster.atk2_hitNum = caster.atk2_hitNum + 1
    ratio = ratio + 0.1 * (#list - caster.atk2_hitNum)
  end
  return power * ratio, i
end

function TitanSA.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if attack_counter then
    if attack_counter == 0 then
      caster.atk2_origposition = caster.position
      skill:takeEffectAt(caster.position, caster)
      caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      caster.atk2_hitNum = 0
    end
  end
end

function TitanSA.skillatk2_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  caster:setPosition({
    caster.position[1] + caster.direction * 285,
    caster.position[2]
  })
end

function TitanSA.skillatk3_createbuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  if caster and owner then
    buff:setAttribute("fearrange", 5)
  end
  return buff
end

function TitanSA.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  caster.atk3_power = power
  return power
end

function TitanSA.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if attack_counter and caster.atk3_power then
    caster:takeHeal(caster.atk3_power * 0.5, "hp", caster)
  end
end

function TitanSA.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if target and caster and caster.TitanSA_hasArcana and caster.TitanSA_hasArcana >= 3 then
    target:takeDamage(target.mp * 0.1, "Holy", "mp", caster, 1, 1)
  end
end

function TitanSA.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local ratio = 1
  local skillatk4 = caster.skills.TitanSA_atk4
  local TitanSA_Ratio = skillatk4.info["Script Arg2"] / 100
  local target_hasHast = false
  if caster and target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.HAST > 0 or 0 < tbuff.info.MSPD then
        target_hasHast = true
      end
    end
    if target_hasHast then
      ratio = 1 + TitanSA_Ratio
    end
  end
  return power * ratio, i
end

function TitanSA.skillatk4_createbuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = caster.skills.TitanSA_atk4
  local TitanSA_Ratio = skillatk4.info["Script Arg2"] / 100
  local target_hasHast = false
  if caster and owner then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.HAST > 0 or 0 < tbuff.info.MSPD then
        target_hasHast = true
      end
    end
    if target_hasHast then
      buff.timer = buff.timer * (1 + TitanSA_Ratio)
    end
  end
  return buff
end

function TitanSA.skillatk234_getDamaged(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  if caster.TitanSA_canCrit then
    crit_mod = 999999
  else
    crit_mod = crit_mod or 1
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg
end

function TitanSA.ult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.ult_target = target
end

function TitanSA.ult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillult = caster.skills.TitanSA_ult
  local attack_counter = skill.attack_counter
  local StealthTime = skillult.info["Script Arg2"]
  if caster and skillult and attack_counter then
    if attack_counter == 0 then
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
      end
      skill.caster.manually_casting = false
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 and target then
      local binfo = ed.lookupDataTable("Buff", nil, TitanSA.ult_stealthBuff)
      local buff = ed.BuffCreate(binfo, caster, caster)
      local Stealthbuff = caster:addBuff(buff, caster)
      Stealthbuff.timer = Stealthbuff.timer + StealthTime
      Stealthbuff.onRemoved = override(Stealthbuff.onRemoved, TitanSA.Stealthbuff_onRemoved)
      caster:setPosition({
        target.position[1] + 15 * caster.direction,
        target.position[2]
      })
      caster.Stealthbuff = Stealthbuff
    end
    if 1 <= attack_counter and target then
      skillult:takeEffectOn(target)
      caster:setPosition({
        target.position[1] + 15 * caster.direction,
        target.position[2]
      })
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanSA.Stealthbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner.Stealthbuff then
    owner.Stealthbuff = nil
  end
end

function TitanSA.ult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if target and caster and caster.TitanSA_hasArcana and caster.TitanSA_hasArcana >= 4 then
    local binfo = ed.lookupDataTable("Buff", nil, 4581)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff.onRemoved = override(buff.onRemoved, TitanSA.ult_hit_buff_onRemoved)
    local ult_hit_buff = target:addBuff(buff, caster)
    target.has_TitanSA_ult = true
  end
  basefunc(skill, target, source, shift)
end

function TitanSA.ult_hit_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner then
    owner.has_TitanSA_ult = false
  end
end

function TitanSA.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillult = self.skills.TitanSA_ult
  if skillult then
    local canCrit_time = skillult.info["Script Arg3"]
    if not (killer_unit ~= self or unit.config.is_summoned) and self.current_skill == skillult or unit.has_TitanSA_ult then
      if self.Stealthbuff then
        local binfo = ed.lookupDataTable("Buff", nil, TitanSA.ult_successBuff)
        local buff = ed.BuffCreate(binfo, self, self)
        buff.onRemoved = override(buff.onRemoved, TitanSA.ult_successBuff_onRemoved)
        self.Stealthbuff.timer = self.Stealthbuff.timer + canCrit_time + 3
        buff.timer = self.Stealthbuff.timer + canCrit_time + 3
        unit.has_TitanSA_ult = false
        self:addBuff(buff, self)
        self.TitanSA_canCrit = true
      else
        local binfo = ed.lookupDataTable("Buff", nil, TitanSA.ult_successBuff)
        local buff = ed.BuffCreate(binfo, self, self)
        buff.onRemoved = override(buff.onRemoved, TitanSA.ult_successBuff_onRemoved)
        buff.timer = canCrit_time + 3
        unit.has_TitanSA_ult = false
        self:addBuff(buff, self)
        self.TitanSA_canCrit = true
      end
    end
  end
end

function TitanSA.ult_successBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  caster.TitanSA_canCrit = false
end

function TitanSA.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function TitanSA.hero_die(basefunc, hero)
  basefunc(hero)
  hero.TitanSA_canCrit = false
end

function TitanSA.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanSA_canCrit = false
  hero.atk2_hitNum = 0
end

function TitanSA.init_hero(hero)
  hero.reset = override(hero.reset, TitanSA.hero_reset)
  hero.update = override(hero.update, TitanSA.hero_update)
  hero.die = override(hero.die, TitanSA.hero_die)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, TitanSA.hero_handleUnitDieEvent)
  local skillatk2 = hero.skills.TitanSA_atk2
  local skillatk3 = hero.skills.TitanSA_atk3
  local skillatk4 = hero.skills.TitanSA_atk4
  local skillult = hero.skills.TitanSA_ult
  hero.TitanSA_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanSA.skillatk2_onAttackFrame)
    skillatk2.power = override(skillatk2.power, TitanSA.skillatk2_power)
    skillatk2.finish = override(skillatk2.finish, TitanSA.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanSA.skillatk3_onAttackFrame)
    skillatk3.power = override(skillatk3.power, TitanSA.skillatk3_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanSA.skillatk3_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanSA.skillatk3_createbuff)
  end
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, TitanSA.skillatk4_power)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanSA.skillatk4_createbuff)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanSA.ult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanSA.ult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanSA.ult_takeEffectOn)
  end
  local skillnames = {
    "_ult",
    "_atk2",
    "_atk3",
    "_atk4"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["TitanSA" .. skillnames[i]]
    if skill then
      skill.getDamage = override(skill.getDamage, TitanSA.skillatk234_getDamaged)
    end
  end
  return hero
end

return TitanSA.init_hero
