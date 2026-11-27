module("ed.battlehero", package.seeall)
local ed = ed
TitanSNK = {}

function TitanSNK.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanSNK_atk3_dmg = true
  hero.TitanSNK_atk3_timer = 0
  hero.TitanSNK_atk4_count = 1
  for unit in ed.engine:foreachAliveUnit(hero.camp) do
    if unit.info["Unit Type"] == "Hero" and unit.info.Name == "TitanKOTL" and unit.TitanKOTL_hasArcana and unit.TitanKOTL_hasArcana > 3 then
      hero.TitanSNK_atk4_count = 2
    end
  end
end

function TitanSNK.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.TitanSNK_atk3_dmg then
    hero.TitanSNK_atk3_timer = hero.TitanSNK_atk3_timer + dt
    if hero.TitanSNK_atk3_timer >= 0.25 then
      hero.TitanSNK_atk3_dmg = true
      hero.TitanSNK_atk3_timer = 0
    end
  end
end

function TitanSNK.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4478
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanSNK.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4478 then
      tbuff.timer = 0
    end
  end
end

function TitanSNK.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.TitanSNK_ult
  local skillults = caster.skills.TitanSNK_ults
  if attack_counter == 0 then
    caster.TitanSNK_oriPosition = {
      caster.position[1],
      caster.position[2]
    }
    local Enemy_position = TitanSNK.DOP_in_battlefield(caster, 100, caster.foecamp)
    if Enemy_position then
      caster:setPosition({
        Enemy_position[1],
        Enemy_position[2]
      })
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
    local skillRemnant = caster.skills.TitanSNK_Remnant1
    if skillRemnant then
      skillRemnant:takeEffectAt(caster.position, caster)
    end
    if skillults then
      caster:addBuff(skillults:createBuff(caster))
    end
  end
end

function TitanSNK.DOP_in_battlefield(caster, radius, camp)
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
    return {400, 0}
  end
end

function TitanSNK.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
end

function TitanSNK.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter < 3 then
    basefunc(skill)
  else
    local originfo = skill.info
    local plusratio = skill.info["Plus Ratio"] * 1.4
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 225,
      ["Plus Ratio"] = plusratio
    })
    basefunc(skill)
    skill.info = originfo
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if caster.direction == 1 and (unit.position[1] > caster.position[1] + caster.direction * 225 or unit.position[1] < caster.position[1]) then
      elseif caster.direction == -1 and (unit.position[1] < caster.position[1] + caster.direction * 225 or unit.position[1] > caster.position[1]) then
      elseif unit:isAlive() then
        local buffID = 4480
        local binfo = ed.lookupDataTable("Buff", nil, buffID)
        local buff = ed.BuffCreate(binfo, unit, caster)
        unit:addBuff(buff, unit)
        unit:hurt()
      end
    end
  end
end

function TitanSNK.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  if lost and hero.TitanSNK_atk3_dmg and (not source or source.name ~= "TitanSNK" or damage_type ~= "Holy") and (not skill or skill.info["Skill Name"] ~= "TitanPiggy_atk4s") then
    local target_damage = 0
    target_damage = math.min(lost, 285691)
    for unit in ed.engine:foreachAliveUnit(-hero.camp) do
      if unit.TitanSNK_atk3_Target and unit:isAlive() then
        hero.TitanSNK_atk3_dmg = false
        local target = unit
        target:takeDamage(target_damage, "Holy", "hp", hero)
      end
    end
  end
  return lost
end

function TitanSNK.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skill = caster.skills.TitanSNK_atk3
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  if dmg <= 0 then
    target:addBuff(skill:createBuff(target))
  end
  return dmg
end

function TitanSNK.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  target.TitanSNK_atk3_Target = true
  buff.onRemoved = override(buff.onRemoved, TitanSNK.skillatk3_buffonRemoved)
  target:hurt()
  local bid = 4479
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff_s = caster:addBuff(binfo, caster)
  if buff_s and buff then
    buff_s.timer = buff.timer
  end
  return buff
end

function TitanSNK.skillatk3_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanSNK_atk3_Target = false
end

function TitanSNK.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  local caster = skill.caster
  local bid = 4478
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanSNK.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4478 then
      tbuff.timer = 0
    end
  end
end

function TitanSNK.onDying(basefunc, self, killer)
  local skill = self.skills.TitanSNK_atk4
  local unrebirth = ed.engine.guildInstance_mode and self.camp == ed.emCampEnemy
  if skill and self.TitanSNK_atk4_count > 0 and not unrebirth and not self.config.is_summoned and (not self.config.is_boss or ed.engine.babelMode) then
    self.rebirth_timer_TitanSNK = 2
    self.TitanSNK_atk4_count = self.TitanSNK_atk4_count - 1
    self.state = ed.emUnitState_Birth
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 1
    self.mp = 0
    local buff = skill.info.buff_info
    self:addBuff(buff, self)
    self:setAction("Death", false, true)
  else
    basefunc(self, killer)
  end
end

function TitanSNK.onActionFinished(basefunc, self)
  if not self.rebirth_timer_TitanSNK then
    basefunc(self)
  end
end

function TitanSNK.update(basefunc, self, dt)
  basefunc(self, dt)
  if not self:isAlive() then
    return
  end
  if self.rebirth_timer_TitanSNK then
    self.rebirth_timer_TitanSNK = self.rebirth_timer_TitanSNK - dt
    if self.rebirth_timer_TitanSNK <= 0 then
      self.rebirth_timer_TitanSNK = nil
      local skill = self.skills.TitanSNK_atk4
      self:setHP(math.min(skill.info["Basic Num"] * (self.config.hp_mod or 1) + self.attribs.STR * 7.5, 800000))
      if self.TitanSNK_hasArcana and 1 < self.TitanSNK_hasArcana and self.mp < 600 then
        self:setMP(600)
      end
      self:summon()
    end
  end
end

function TitanSNK.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = buff.timer + 5
  return buff
end

function TitanSNK.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  if self:isAlive() and owner == self and owner.name == "TitanSNK" and caster.name ~= "TitanSNK" and caster.name ~= "TitanPiggy" and buff:isCrlEftConflictWithUncontrollable() and buff.info.ID ~= 4248 and buff.info.ID ~= 4263 and buff.info.ID ~= 4381 then
    for unit in ed.engine:foreachAliveUnit(-self.camp) do
      if unit.TitanSNK_atk3_Target and unit:isAlive() and owner.camp ~= unit.camp then
        local flip_bid = buff.info.ID
        local flip_binfo = ed.lookupDataTable("Buff", nil, flip_bid)
        local flip_buff = ed.BuffCreate(flip_binfo, unit, unit)
        flip_buff.timer = math.min(buff.timer, 8)
        for j, effect in ipairs(flip_buff.info["Control Effects"]) do
          if string.find(effect, "fear") then
            flip_buff:setAttribute("fearrange", 5)
          end
        end
        unit:addBuff(flip_buff, unit)
      end
    end
  end
end

function TitanSNK.init_hero(hero)
  local skillult = hero.skills.TitanSNK_ult
  local skillatk2 = hero.skills.TitanSNK_atk2
  local skillatk3 = hero.skills.TitanSNK_atk3
  local skillatk4 = hero.skills.TitanSNK_atk4
  local skillults = hero.skills.TitanSNK_ults
  hero.TitanSNK_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanSNK.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanSNK.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanSNK.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, TitanSNK.skillatk3_finish)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanSNK.skillatk3_createBuff)
    skillatk3.getDamage = override(skillatk3.getDamage, TitanSNK.skillatk3_getDamage)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanSNK.hero_getLostHPAfterImmunity)
    if hero.TitanSNK_hasArcana and hero.TitanSNK_hasArcana > 3 then
      hero.collectBuff = override(hero.collectBuff, TitanSNK.collectBuff)
    end
  end
  if skillatk4 then
    hero.onDying = override(hero.onDying, TitanSNK.onDying)
    hero.onActionFinished = override(hero.onActionFinished, TitanSNK.onActionFinished)
    hero.update = override(hero.update, TitanSNK.update)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanSNK.skillult_start)
    skillult.finish = override(skillult.finish, TitanSNK.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanSNK.skillult_onAttackFrame)
    if skillults and hero.TitanSNK_hasArcana and hero.TitanSNK_hasArcana > 2 then
      skillults.createBuff = override(skillults.createBuff, TitanSNK.skillults_createBuff)
    end
  end
  hero.reset = override(hero.reset, TitanSNK.hero_reset)
  hero.update = override(hero.update, TitanSNK.hero_update)
  return hero
end

return TitanSNK.init_hero
