module("ed.battlehero", package.seeall)
local ed = ed
TitanRG = {}
TitanRG.ults_deathBid = 4588

function TitanRG.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanRG_atk3
  if caster and skillatk3 and target then
    local mp_ratio = skillatk3.info["Script Arg3"] / 100
    local mp_lost = skillatk3.info["Script Arg2"]
    target:takeDamage(mp_lost, "Holy", "mp", caster, 1, 1, true)
    caster:takeHeal(mp_lost * mp_ratio, "mp", caster)
  end
end

function TitanRG.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local ratio = 1
  if caster and caster.TitanRG_hasArcana and caster.TitanRG_hasArcana >= 2 then
    ratio = math.min((1000 - target.mp) / 1000, 1) + 1
  end
  return power * ratio, i
end

function TitanRG.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanRG_atk3
  if caster and skillatk3 and target then
    local mp_ratio = skillatk3.info["Script Arg3"] / 100
    local mp_lost = skillatk3.info["Script Arg2"]
    target:takeDamage(mp_lost, "Holy", "mp", caster, 1, 1, true)
    caster:takeHeal(mp_lost * mp_ratio, "mp", caster)
  end
end

function TitanRG.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local skillatk3 = self.skills.TitanRG_atk3
  local source = source or struct_table.source
  local damage_type = damage_type or struct_table.damage_type
  if source and lost and 0 < lost and damage_type ~= "Holy" and skillatk3 and self.atk3_canStealMP then
    local mp_ratio = skillatk3.info["Script Arg3"] / 100
    local mp_lost = skillatk3.info["Script Arg2"]
    source:takeDamage(mp_lost, "Holy", "mp", self, 1, 1, true)
    self:takeHeal(mp_lost * mp_ratio, "mp", self)
    self.atk3_canStealMP = false
  end
  return lost, bc
end

function TitanRG.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanRG_atk4
  buff.onRemoved = override(buff.onRemoved, TitanRG.skillatk4buff_onRemoved)
  buff.onDamaged = override(buff.onDamaged, TitanRG.skillatk4buff_onDamaged)
  buff.update = override(buff.update, TitanRG.skillatk4buff_update)
  if caster and skillatk4 then
    caster.hasAtk4Buff = true
  end
  return buff
end

function TitanRG.skillatk4buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local tempdamage, bc = basefunc(buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local skillatk3 = caster.skills.TitanRG_atk3
  if source and damage and 0 < damage and damage_type ~= "Holy" and skillatk3 and caster.atk3_canStealMP then
    local mp_ratio = skillatk3.info["Script Arg3"] / 100
    local mp_lost = skillatk3.info["Script Arg2"]
    source:takeDamage(mp_lost, "Holy", "mp", caster, 1, 1, true)
    caster:takeHeal(mp_lost * mp_ratio, "mp", caster)
    caster.atk3_canStealMP = false
  end
  return tempdamage, bc
end

function TitanRG.skillatk4buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanRG_atk4
  if skillatk4 and caster then
    caster.hasAtk4Buff = false
  end
end

function TitanRG.skillatk4buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.caster
  local skillatk4 = hero.skills.TitanRG_atk4
  local skillatk4s = hero.skills.TitanRG_atk4s
  local skillult = hero.skills.TitanRG_ult
  if not hero.manually_casting then
    hero.atk4buff_triggerTime = hero.atk4buff_triggerTime and hero.atk4buff_triggerTime + dt or dt
  end
  if hero.atk4buff_triggerTime == 3 then
    hero.atk4buff_triggerTime = 0
    hero.atk4_canKonckback = true
  end
  if skillatk4 and hero.hasAtk4Buff and hero.atk4_canKonckback then
    local radius = 135
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      local unitdistance = ed.edpDistanceSQ(hero.position, unit.position)
      if unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp == hero.camp then
      elseif unitdistance <= radius * radius then
        skillatk4s:takeEffectAt(hero.position, hero)
      end
    end
    hero.atk4_canKonckback = false
  end
end

function TitanRG.skillatk4s_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local skillatk4s = caster.skills.TitanRG_atk4s
  local skillatk3 = caster.skills.TitanRG_atk3
  if caster and skillatk4s and target and skillatk3 then
    local mp_ratio = skillatk3.info["Script Arg3"] / 100
    local mp_lost = skillatk3.info["Script Arg2"]
    if not target.buff_effects.invulnerable then
      target:hurt()
      target:takeDamage(mp_lost, "Holy", "mp", caster, 1, 1, true)
      caster:takeHeal(mp_lost * mp_ratio, "mp", caster)
    end
    if ed.run_with_scene then
      local effect_name = "eff_buff_TitanOracle_atk2.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {1, 1}, nil, -1)
    end
    if caster.TitanRG_hasArcana and caster.TitanRG_hasArcana >= 3 then
      local bid = 4589
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      if (not (target.info.ID == 10033 and target.buff_effects.uncontrollable) or not target.buff_effects.untargetable) and not target.buff_effects.invulnerable then
        target:addBuff(binfo, caster)
      end
    end
  end
end

function TitanRG.DOP_in_battlefield(caster, radius, camp)
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

function TitanRG.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
end

function TitanRG.ult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanRG_ult
  local attack_counter = skill.attack_counter
  if caster and skillult then
    if attack_counter == 0 then
      local PortalPosition = TitanRG.DOP_in_battlefield(caster, 200, caster.foecamp)
      if PortalPosition then
        caster:setPosition({
          PortalPosition[1],
          PortalPosition[2]
        })
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      basefunc(skill)
    end
  end
end

function TitanRG.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.TitanRG_hasArcana and hero.TitanRG_hasArcana >= 3 then
    local skillatk4 = hero.skills.TitanRG_atk4
    if not hero.TitanRG_enterShield then
      skillatk4:takeEffectOn(hero)
      hero.TitanRG_enterShield = true
    end
  end
  if not hero.atk3_canStealMP and not hero.manually_casting then
    hero.atk3_triggerTime = hero.atk3_triggerTime and hero.atk3_triggerTime + dt or dt
  end
  if hero.atk3_triggerTime == 7 then
    hero.atk3_canStealMP = true
    hero.atk3_triggerTime = 0
  end
end

function TitanRG.hero_setAction(basefunc, hero, action_name, loop, interrupt)
  local new_action_name = action_name
  if new_action_name == "Death" and hero and hero.TitanRG_hasArcana and hero.TitanRG_hasArcana >= 4 and hero.name == "TitanRG" then
    new_action_name = "Death2"
  end
  basefunc(hero, new_action_name, loop, interrupt)
end

function TitanRG.hero_onDying(basefunc, self, killer)
  local skillult = self.skills.TitanRG_ult
  if skillult and self and self.TitanRG_hasArcana and self.TitanRG_hasArcana >= 4 and not self.ults_already_cast then
    self.ults_already_cast = true
    local bid = TitanRG.ults_deathBid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = self:addBuff(binfo, self)
    skillult:takeEffectAt(self.position, self)
  end
  basefunc(self, killer)
end

function TitanRG.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hasAtk4Buff = false
  hero.ults_already_cast = false
  hero.TitanRG_enterShield = false
  hero.atk3_triggerTime = 0
  hero.atk3_canStealMP = true
end

function TitanRG.init_hero(hero)
  hero.reset = override(hero.reset, TitanRG.hero_reset)
  hero.update = override(hero.update, TitanRG.hero_update)
  hero.onDying = override(hero.onDying, TitanRG.hero_onDying)
  hero.takeDamage = override(hero.takeDamage, TitanRG.hero_takeDamage)
  hero.setAction = override(hero.setAction, TitanRG.hero_setAction)
  local skillatk = hero.skills.TitanRG_atk
  local skillatk2 = hero.skills.TitanRG_atk2
  local skillatk3 = hero.skills.TitanRG_atk3
  local skillatk4 = hero.skills.TitanRG_atk4
  local skillatk4s = hero.skills.TitanRG_atk4s
  local skillult = hero.skills.TitanRG_ult
  hero.TitanRG_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanRG.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, TitanRG.skillatk2_power)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanRG.skillatk2_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanRG.skillatk4_createBuff)
  end
  if skillatk4s then
    skillatk4s.takeEffectOn = override(skillatk4s.takeEffectOn, TitanRG.skillatk4s_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanRG.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanRG.ult_onAttackFrame)
  end
  return hero
end

return TitanRG.init_hero
