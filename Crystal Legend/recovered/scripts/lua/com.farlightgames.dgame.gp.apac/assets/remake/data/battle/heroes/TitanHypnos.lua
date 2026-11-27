module("ed.battlehero", package.seeall)
local ed = ed
TitanHypnos = {}
TitanHypnos.TitanHypnos_fashionID = 101181

function TitanHypnos.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    basefunc(skill)
  elseif skill.attack_counter > 0 then
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanHypnos.hero_handleUnitDieEventToAll(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4414 and unit.camp ~= self.camp and unit.TitanHypnos_atk3_damage then
      tbuff.timer = -1
      local skillatk3s = self.skills.TitanHypnos_atk3s
      if skillatk3s and self.TitanHypnos_skillatk3s_can_cast then
        skillatk3s:takeEffectAt(unit.position)
        self.TitanHypnos_skillatk3s_can_cast = false
      end
    end
  end
  local skillatk3 = self.skills.TitanHypnos_atk3
  if skillatk3 and (skillatk3.casting or skillatk3.cd_remaining >= 8) and killer_unit == self and unit.camp ~= self.camp then
    local skillatk3s = self.skills.TitanHypnos_atk3s
    if skillatk3s and self.TitanHypnos_skillatk3s_can_cast then
      skillatk3s:takeEffectAt(unit.position)
      self.TitanHypnos_skillatk3s_can_cast = false
    end
  end
end

function TitanHypnos.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.TitanHypnos_atk3_damage = 0
  buff.onDamaged = override(buff.onDamaged, TitanHypnos.skillatk3_buff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, TitanHypnos.skillatk3_buffOnRemoved)
  return buff
end

function TitanHypnos.skillatk3_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local caster = buff.caster
  local TitanHypnos_atk3_ratio = caster.skills.TitanHypnos_atk3.info["Script Arg2"]
  if damage and 0 < damage and owner.TitanHypnos_atk3_damage then
    owner.TitanHypnos_atk3_damage = owner.TitanHypnos_atk3_damage + damage
  end
  if TitanHypnos_atk3_ratio <= owner.TitanHypnos_atk3_damage then
    buff.timer = -1
  end
  return damage
end

function TitanHypnos.skillatk3_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  owner.TitanHypnos_atk3_damage = 0
  basefunc(buff)
end

function TitanHypnos.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, TitanHypnos.TitanHypnos_atk3_projectile_hit)
  return projectile
end

function TitanHypnos.TitanHypnos_atk3_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target == skill.target then
    basefunc(projectile, target)
    projectile:terminate()
  else
    return nil
  end
end

function TitanHypnos.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  buff.onRemoved = override(buff.onRemoved, TitanHypnos.skillatk4_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, TitanHypnos.skillatk4_buff_onDamaged)
  return buff
end

function TitanHypnos.skillatk4_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local caster = buff.caster
  if damage and 0 < damage then
    owner:removeBuff(buff)
    if caster.TitanHypnos_hasArcana and caster.TitanHypnos_hasArcana > 3 then
      local bid = 4421
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, owner, caster)
      buff:setAttribute("AD", 0.3 * owner.attribs.AD)
      buff:setAttribute("AP", 0.3 * owner.attribs.AP)
      owner:addBuff(buff, caster)
    end
  end
  return damage
end

function TitanHypnos.skillatk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  if TitanHypnos.TitanHypnos_fashionID and TitanHypnos.TitanHypnos_fashionID == caster.fashion_id then
    owner:takeHeal(250, "mp", buff.caster)
  end
end

function TitanHypnos.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  caster.TitanHypnos_skillult_AGI = 0
  caster.TitanHypnos_skillult_INT = 0
  caster.TitanHypnos_skillult_STR = 0
  caster.TitanHypnos_skillult_AGI_count = 0
  caster.TitanHypnos_skillult_INT_count = 0
  caster.TitanHypnos_skillult_STR_count = 0
  local bid = 4409
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanHypnos.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 4409 then
      tbuff.timer = -1
    end
  end
end

function TitanHypnos.skillult_canCastWithTarget(basefunc, skill, target)
  return basefunc(skill, target)
end

function TitanHypnos.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanHypnos_ult
  local skillults = caster.skills.TitanHypnos_ults
  local atriblost_ratio = skillult.info["Script Arg2"]
  if skill.attack_counter == 0 then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if unit and unit:isAlive() and not unit.config.is_summoned and unit.info["Main Attrib"] and unit.info["Unit Type"] == "Hero" and not unit.config.is_boss then
        local bid = 4411
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, unit, caster)
        if unit.info["Main Attrib"] == "AGI" then
          buff:setAttribute("AGI", -math.min(atriblost_ratio * caster.attribs.INT, unit.attribs.AGI - 1))
          caster.TitanHypnos_skillult_AGI = caster.TitanHypnos_skillult_AGI + atriblost_ratio * caster.attribs.INT
        elseif unit.info["Main Attrib"] == "INT" then
          buff:setAttribute("INT", -math.min(atriblost_ratio * caster.attribs.INT, unit.attribs.INT - 1))
          caster.TitanHypnos_skillult_INT = caster.TitanHypnos_skillult_INT + atriblost_ratio * caster.attribs.INT
        elseif unit.info["Main Attrib"] == "STR" then
          buff:setAttribute("STR", -math.min(atriblost_ratio * caster.attribs.INT, unit.attribs.STR - 1))
          caster.TitanHypnos_skillult_STR = caster.TitanHypnos_skillult_STR + atriblost_ratio * caster.attribs.INT
        end
        unit:addBuff(buff, caster)
      end
    end
    basefunc(skill)
  elseif skill.attack_counter > 0 then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.info["Unit Type"] == "Hero" and unit:isAlive() and not unit.config.is_summoned then
        if unit.info["Main Attrib"] == "AGI" then
          caster.TitanHypnos_skillult_AGI_count = caster.TitanHypnos_skillult_AGI_count + 1
        elseif unit.info["Main Attrib"] == "INT" then
          caster.TitanHypnos_skillult_INT_count = caster.TitanHypnos_skillult_INT_count + 1
        elseif unit.info["Main Attrib"] == "STR" then
          caster.TitanHypnos_skillult_STR_count = caster.TitanHypnos_skillult_STR_count + 1
        end
      end
    end
    skillults:takeEffectAt(caster.position)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanHypnos.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.TitanHypnos_ult_timer = 0
  buff.onDamaged = override(buff.onDamaged, TitanHypnos.skillult_buff_onDamaged)
  buff.update = override(buff.update, TitanHypnos.skillult_buff_buffUpdate)
  return buff
end

function TitanHypnos.skillult_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local caster = buff.caster
  local TitanHypnos_ult_ratio = caster.skills.TitanHypnos_ult.info["Script Arg3"]
  if damage and 0 < damage and TitanHypnos_ult_ratio < buff.TitanHypnos_ult_timer then
    buff.timer = -1
  end
  return damage
end

function TitanHypnos.skillult_buff_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.TitanHypnos_ult_timer then
    buff.TitanHypnos_ult_timer = buff.TitanHypnos_ult_timer + dt
  end
end

function TitanHypnos.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info["Main Attrib"] == "AGI" and caster.TitanHypnos_skillult_AGI_count > 0 and 0 < caster.TitanHypnos_skillult_AGI then
    buff:setAttribute("AGI", caster.TitanHypnos_skillult_AGI / caster.TitanHypnos_skillult_AGI_count)
    buff.timer = 18
  elseif owner.info["Main Attrib"] == "INT" and 0 < caster.TitanHypnos_skillult_INT_count and 0 < caster.TitanHypnos_skillult_INT then
    buff:setAttribute("INT", caster.TitanHypnos_skillult_INT / caster.TitanHypnos_skillult_INT_count)
    buff.timer = 18
  elseif owner.info["Main Attrib"] == "STR" and 0 < caster.TitanHypnos_skillult_STR_count and 0 < caster.TitanHypnos_skillult_STR then
    buff:setAttribute("STR", caster.TitanHypnos_skillult_STR / caster.TitanHypnos_skillult_STR_count)
    buff.timer = 18
  else
    buff.timer = 0
  end
  return buff
end

function TitanHypnos.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk2 = hero.skills.TitanHypnos_atk2
  if skillatk2 and hero.TitanHypnos_hasArcana > 1 then
    local originfo = skillatk2.info
    skillatk2.info = ed.wraptable(originfo, {
      ["AOE Origin"] = "target",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 120
    })
  end
  local skillatk3 = hero.skills.TitanHypnos_atk3
  if skillatk3 and hero.TitanHypnos_hasArcana > 2 then
    local originfo = skillatk3.info
    skillatk3.info = ed.wraptable(originfo, {
      ["Target Type"] = "minhp"
    })
    hero.TitanHypnos_skillatk3s_can_cast = false
  end
  local skillatk4 = hero.skills.TitanHypnos_atk4s
  if skillatk4 then
    hero.TitanHypnos_atk4_will_cast = true
    hero.skillatk4_cd_timer = 9
  end
  if hero.TitanHypnos_atk4_region then
    hero.TitanHypnos_atk4_region:finish()
    hero.TitanHypnos_atk4_region = nil
  end
end

function TitanHypnos.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, TitanHypnos.skillatk4s_buff_onDamaged)
  return buff
end

function TitanHypnos.skillatk4s_createRegion(basefunc, skill)
  local region = basefunc(skill)
  return region
end

function TitanHypnos.skillatk4s_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanHypnos_atk4
  if damage and owner and owner:isAlive() then
    local hp_ratio = owner.hp / owner.attribs.HP
    local control_ratio = 1
    if owner.buff_effects.stun or owner.buff_effects.silence or owner.buff_effects.doom or owner.buff_effects.enchanted or owner.buff_effects.fear then
      control_ratio = 0.75
    end
    owner.TitanHypnos_atk4_ratio = hp_ratio * control_ratio
    if owner.TitanHypnos_atk4_ratio <= 0.475 then
      owner.TitanHypnos_atk4_can_cast = true
    else
      owner.TitanHypnos_atk4_can_cast = false
    end
  end
  if damage and source.camp ~= owner.camp and skillatk4 and caster.TitanHypnos_atk4_will_cast and owner.TitanHypnos_atk4_can_cast and owner:isAlive() and caster:isAlive() and not owner.manually_casting and not owner.config.is_summoned then
    skillatk4:takeEffectOn(owner)
    caster.TitanHypnos_atk4_will_cast = false
    local bid = 4416
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, caster)
  end
  return damage
end

function TitanHypnos.skillatk3_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  skill.caster.TitanHypnos_skillatk3s_can_cast = true
  basefunc(skill, target)
end

function TitanHypnos.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanHypnos_atk4
  if skillatk4 and not hero.TitanHypnos_atk4_will_cast and hero.skillatk4_cd_timer then
    hero.skillatk4_cd_timer = hero.skillatk4_cd_timer - dt
  end
  if hero.skillatk4_cd_timer and hero.skillatk4_cd_timer <= 0 then
    hero.TitanHypnos_atk4_will_cast = true
    hero.skillatk4_cd_timer = 9
  end
  local atk4s = hero.skills.TitanHypnos_atk4s
  if atk4s and not hero.TitanHypnos_atk4_region then
    atk4s.target = hero
    local atk4s_region = atk4s:createRegion()
    atk4s_region.position = {400, 0}
    hero.TitanHypnos_atk4_region = atk4s_region
    ed.engine:addRegion(atk4s_region)
  end
end

function TitanHypnos.die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.TitanHypnos_atk4_region then
    hero.TitanHypnos_atk4_region:finish()
    hero.TitanHypnos_atk4_region = nil
  end
end

function TitanHypnos.init_hero(hero)
  local skillult = hero.skills.TitanHypnos_ult
  local skillults = hero.skills.TitanHypnos_ults
  local skillatk2 = hero.skills.TitanHypnos_atk2
  local skillatk3 = hero.skills.TitanHypnos_atk3
  local skillatk3s = hero.skills.TitanHypnos_atk3s
  local skillatk4 = hero.skills.TitanHypnos_atk4
  local skillatk4s = hero.skills.TitanHypnos_atk4s
  hero.reset = override(hero.reset, TitanHypnos.hero_reset)
  hero.update = override(hero.update, TitanHypnos.hero_update)
  hero.die = override(hero.die, TitanHypnos.die)
  hero.TitanHypnos_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanHypnos.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanHypnos.skillatk3_start)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanHypnos.skillatk3_createBuff)
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanHypnos.skillatk3_createProjectile)
    if hero.TitanHypnos_hasArcana > 2 then
      hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, TitanHypnos.hero_handleUnitDieEventToAll)
    end
  end
  if skillatk3s then
    skillatk3s.createBuff = override(skillatk3s.createBuff, TitanHypnos.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanHypnos.skillatk4_createBuff)
  end
  if skillatk4s then
    skillatk4s.createRegion = override(skillatk4s.createRegion, TitanHypnos.skillatk4s_createRegion)
    skillatk4s.createBuff = override(skillatk4s.createBuff, TitanHypnos.skillatk4s_createBuff)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanHypnos.skillult_start)
    skillult.finish = override(skillult.finish, TitanHypnos.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanHypnos.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanHypnos.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, TitanHypnos.skillult_createBuff)
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, TitanHypnos.skillults_createBuff)
  end
  return hero
end

return TitanHypnos.init_hero
