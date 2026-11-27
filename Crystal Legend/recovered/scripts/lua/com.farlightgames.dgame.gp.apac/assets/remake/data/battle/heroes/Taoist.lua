module("ed.battlehero", package.seeall)
local ed = ed
Taoist = {}
Taoist.barNameList = {
  "bar_Fury",
  "bar_shield",
  "bar_hp"
}
Taoist.sawake_aoe_range = 280

function Taoist.hero_onHitMiss(basefunc, hero, skill)
  basefunc(hero, skill)
  local skill4 = hero.passive_skill_list[1]
  hero:takeHeal(skill4["Script Arg2"])
  if hero.actor then
    local effect = "eff_impact_Taoist_atk4.cha"
    local effect_z = 1
    hero.actor:addEffect(effect, effect_z)
  end
  Taoist.chain_index = Taoist.chain_index + 1
end

function Taoist.skillult_canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function Taoist.skillult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local buffMiss = true
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 335 then
        local bid = 336
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, caster)
        local bid = 337
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, caster)
        buffMiss = false
        break
      end
    end
  end
  if buffMiss then
    skill:interrupt()
  end
  Taoist.chain_index = Taoist.chain_index + 1
end

function Taoist.skillult_interrupt(basefunc, skill)
  basefunc(skill)
  local target = skill.target
  if skill.target then
    for i, tbuff in pairs(target.buff_list) do
      if tbuff.info.ID == 335 then
        target:removeBuff(tbuff)
      end
    end
    for i, tbuff in pairs(target.buff_list) do
      if tbuff.info.ID == 336 then
        target:removeBuff(tbuff)
      end
    end
    for i, tbuff in pairs(target.buff_list) do
      if tbuff.info.ID == 337 then
        target:removeBuff(tbuff)
      end
    end
  end
end

function Taoist.ult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner and buff.owner.hp <= 1 then
    for i, tbuff in ipairs(buff.owner.buff_list) do
      if tbuff.info.ID == 335 then
        buff.owner:onDying()
        if buff.caster and buff.caster.current_skill then
          buff.caster.current_skill:interrupt()
        end
        break
      end
    end
    local skillatk2 = buff.caster.skills.Taoist_atk2
    if skillatk2 then
      skillatk2.cd_remaining = 0
    end
    local skillatk3 = buff.caster.skills.Taoist_atk3
    if skillatk3 then
      skillatk3.cd_remaining = 0
    end
  end
end

function Taoist.ult_buff_onRemoved(basefunc, buff)
  if buff.caster.current_skill and buff.caster.current_skill.info["Skill Name"] == "Taoist_ult" then
    buff.caster.current_skill:interrupt()
  end
  basefunc(buff)
end

function Taoist.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Taoist.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, Taoist.ult_buff_onRemoved)
  return buff
end

function Taoist.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local templocaltion = {
    location[1],
    0
  }
  Taoist.chain_index = Taoist.chain_index + 1
  basefunc(skill, templocaltion, source)
end

function Taoist.skillatk2_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  Taoist.chain_index = Taoist.chain_index + 1
  if target.config.is_summoned then
    local ratio = target.mp / 1000
    power = power * (2 + ratio)
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function Taoist.skillawake_canCastWithTarget(basefunc, skill, target)
  if Taoist.chain_index ~= 0 then
    return false
  else
    return basefunc(skill, target)
  end
end

function Taoist.skillawake_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local proto = {
    _tid = 258,
    _level = skill.level,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local Diagram = ed.UnitCreate(proto, caster.camp, config)
  local bid = 606
  local binfo606 = ed.lookupDataTable("Buff", nil, bid)
  local buff = Diagram:addBuff(binfo606, caster)
  Diagram.direction = caster.direction
  local location_diagram = {
    caster.position[1],
    caster.position[2]
  }
  Diagram.update = override(Diagram.update, Taoist.Diagram_update)
  local Diagram_atk = Diagram.skills.Diagram_atk
  Diagram_atk.onAttackFrame = override(Diagram_atk.onAttackFrame, Taoist.Diagram_atk_onAttackFrame)
  ed.engine:summonUnit(Diagram, location_diagram, caster, "Birth")
  Taoist.chain_index = Taoist.chain_index + 1
  local actor = caster.actor
  if actor then
    local addY = -15
    for _, barName in ipairs(Taoist.barNameList) do
      local bar = actor[barName]
      if bar then
        local posX, posY = bar.node:getPosition()
        bar.node:setPosition(posX, posY + addY)
      end
    end
  end
end

function Taoist.skillawake_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if not caster.Taoist_leadingTaoist then
    caster.Taoist_leadingTaoist = true
    local dir = caster:getInitDir()
    if caster.camp == 1 then
      caster:setPosition({
        ed.engine.stage_rect.maxX / 2 - dir * 210,
        caster.position[2]
      })
      caster.direction = dir
    else
      caster:setPosition({
        ed.engine.stage_rect.maxX / 2 - dir * 210,
        caster.position[2]
      })
      caster.direction = dir
    end
  end
end

function Taoist.Diagram_atk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if Taoist.chain_index == -1 or Taoist.chain_index == 0 then
    return
  else
    local hero = Taoist.globalcaster
    local skillatk2 = hero.skills.Taoist_atk2
    local skillatk3 = hero.skills.Taoist_atk3
    if skillatk2 then
      local skillatk2_originfo = skillatk2.info
      skillatk2.info = ed.wraptable(skillatk2_originfo, {
        ["Gain MP"] = 100 * (0.9 + Taoist.chain_index / 10),
        CD = 7 - (1.2 + Taoist.chain_index / 10)
      })
    end
    if skillatk3 then
      local skillatk3_originfo = skillatk3.info
      skillatk3.info = ed.wraptable(skillatk3_originfo, {
        ["Gain MP"] = 100 * (0.9 + Taoist.chain_index / 10),
        CD = 7 - (1.2 + Taoist.chain_index / 10)
      })
    end
    local skillatk = hero.skills.Taoist_atk
    if skillatk then
      local skillatk_originfo = skillatk.info
      skillatk.info = ed.wraptable(skillatk_originfo, {
        ["Gain MP"] = 100 * (0.9 + Taoist.chain_index / 10)
      })
      skillatk.info = skillatk_originfo
    end
  end
end

function Taoist.Diagram_update(basefunc, self, dt)
  basefunc(self, dt)
  for unit in ed.engine:foreachAliveUnit(self.camp) do
    if unit.name == "Taoist" then
      self.position = unit.position
    end
  end
  self.flying = true
  if not Taoist.globalcaster:isAlive() then
    Taoist.chain_index = 0
    self:die()
  end
  if Taoist.chain_index == -1 then
    self:die()
  end
  local foecamp_number = 0
  for unit in ed.engine:foreachAliveUnit(self.foecamp) do
    foecamp_number = foecamp_number + 1
  end
  if foecamp_number == 0 then
    self:setAction("Idle")
  end
end

function Taoist.update(basefunc, self, dt)
  basefunc(self, dt)
  local skilllevel = self.skills.Taoist_awake.level
  if Taoist.threshold_is_true == 0 then
    Taoist.threshold = 0.1 + (skilllevel - 60) / 100
    Taoist.threshold_is_true = 1
  end
  if Taoist.chain_index ~= 0 then
    Taoist.hp_dt[1] = Taoist.hp_dt[2]
    Taoist.hp_dt[2] = Taoist.hp_dt[3]
    Taoist.hp_dt[3] = Taoist.hp_dt[4]
    Taoist.hp_dt[4] = Taoist.hp_dt[5]
    Taoist.hp_dt[5] = Taoist.hp_dt[6]
    Taoist.hp_dt[6] = Taoist.hp_dt[7]
    Taoist.hp_dt[7] = Taoist.hp_dt[8]
    Taoist.hp_dt[8] = Taoist.hp_dt[9]
    Taoist.hp_dt[9] = Taoist.hp_dt[10]
    Taoist.hp_dt[10] = Taoist.hp_dt[11]
    Taoist.hp_dt[11] = Taoist.hp_dt[12]
    Taoist.hp_dt[12] = Taoist.hp_dt[13]
    Taoist.hp_dt[13] = Taoist.hp_dt[14]
    Taoist.hp_dt[14] = Taoist.hp_dt[15]
    Taoist.hp_dt[15] = Taoist.hp_dt[16]
    Taoist.hp_dt[16] = self.hp
  end
  if Taoist.hp_dt[16] ~= nil and Taoist.hp_dt[1] ~= nil and Taoist.hp_dt[16] - Taoist.hp_dt[1] < -1 * Taoist.HP * Taoist.threshold then
    Taoist.chain_index = -1
  end
  local skillsawake = self.skills.Taoist_sawake
  local skillsawakeb = self.skills.Taoist_sawakeb
  if skillsawake and ed.protoSuperAwake(self.proto, 82) and not Taoist.sawake_effect_play then
    Taoist.sawake_effect_play = true
    if ed.run_with_scene then
      local effect_name = "eff_point_Taoist_sawake.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, -1)
    end
  end
  if skillsawakeb and ed.protoSuperAwake(self.proto, 82) then
    for unit in ed.engine:foreachAliveUnit(-self.camp) do
      local tags = ed.getHeroTags(unit.proto)
      local dmgdistance = (unit.position[1] - 400) ^ 2 + (unit.position[2] - 0) ^ 2
      if dmgdistance < Taoist.sawake_aoe_range ^ 2 and not unit.Taoist_sawake_dmg then
        skillsawakeb:takeEffectOn(unit)
        unit.Taoist_sawake_dmg = true
        if ed.isElementInTable("Undead", tags) or ed.isElementInTable("demon", tags) or unit.config.is_summoned and not unit.Taoist_sawake_hit and 0 < Taoist.sawake_hit_times then
          local bid = 1635
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit, self)
          unit:addBuff(buff, unit)
          unit.Taoist_sawake_hit = true
          Taoist.sawake_hit_times = Taoist.sawake_hit_times - 1
          buff.update = override(buff.update, Taoist.sawake_Buff_update)
          buff.onDamaged = override(buff.onDamaged, Taoist.sawake_Buff_onDamaged)
        end
      end
    end
  end
end

function Taoist.sawake_Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillsawake = caster.skills.Taoist_sawake
  local maxdmg = skillsawake.info["Script Arg2"]
  if owner.totaldmg and maxdmg < owner.totaldmg then
    buff.timer = -1
  end
end

function Taoist.sawake_Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local damage = basefunc(buff, damage, damage_type, source, skill)
  local owner = buff.owner
  if owner.totaldmg == nil then
    owner.totaldmg = 0
  end
  if 0 < damage then
    owner.totaldmg = owner.totaldmg + damage
  end
  return damage
end

function Taoist.reset(basefunc, hero)
  basefunc(hero)
  Taoist.chain_index = 0
  Taoist_leadingTaoist = 0
  Taoist.hp_dt = {
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -2,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1
  }
  Taoist.globalcaster = hero
  Taoist.HP = hero.hp
  Taoist.threshold_is_true = 0
  Taoist.Diagram_bufflevel = 0
  if ed.protoSuperAwake(hero.proto, 82) then
    Taoist.sawake_effect_play = false
    Taoist.sawake_hit_times = 5
  end
end

function Taoist.init_hero(hero)
  hero.reset = override(hero.reset, Taoist.reset)
  local skill4 = hero.passive_skill_list[1]
  if skill4 then
    hero.onHitMiss = override(hero.onHitMiss, Taoist.hero_onHitMiss)
  end
  local skillult = hero.skills.Taoist_ult
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, Taoist.skillult_takeEffectOn)
    skillult.interrupt = override(skillult.interrupt, Taoist.skillult_interrupt)
    skillult.createBuff = override(skillult.createBuff, Taoist.skillult_createBuff)
  end
  local skillatk3 = hero.skills.Taoist_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, Taoist.skillatk3_takeEffectAt)
  end
  local skillatk2 = hero.skills.Taoist_atk2
  if skillatk2 then
    skillatk2.getDamage = override(skillatk2.getDamage, Taoist.skillatk2_getDamage)
  end
  local skillawake = hero.skills.Taoist_awake
  if skillawake then
    skillawake.canCastWithTarget = override(skillawake.canCastWithTarget, Taoist.skillawake_canCastWithTarget)
    skillawake.takeEffectAt = override(skillawake.takeEffectAt, Taoist.skillawake_takeEffectAt)
    skillawake.update = override(skillawake.update, Taoist.skillawake_update)
    hero.update = override(hero.update, Taoist.update)
  end
  return hero
end

return Taoist.init_hero
