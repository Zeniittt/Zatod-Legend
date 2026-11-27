module("ed.battlehero", package.seeall)
local ed = ed
IO = {}

function IO.skillult_createBuff(basefunc, skill, target)
  local owner = skill.caster
  local skillatk2 = owner.skills.IO_atk2
  local ulttarget = owner.IO_atk2_target
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  local hast = buff.info.HAST
  local mspd = buff.info.MSPD
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + owner.attribs.HEAL / 100))
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + owner.attribs.HEAL / 100) + skill.evo_rank2["Script Arg1"] * (1 + owner.attribs.HEAL / 100))
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HAST", hast + skill.evo_rank3["Script Arg1"])
    buff:setAttribute("MSPD", mspd + skill.evo_rank3["Script Arg1"])
  end
  if ulttarget then
    local binfo1 = skill.info.buff_info
    local buff1 = ed.BuffCreate(binfo1, ulttarget, owner)
    if skill.evo_rank and skill.evo_rank >= 1 then
      buff1:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + owner.attribs.HEAL / 100))
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      buff1:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + owner.attribs.HEAL / 100) + skill.evo_rank2["Script Arg1"] * (1 + owner.attribs.HEAL / 100))
    end
    if skill.evo_rank and skill.evo_rank >= 3 then
      buff1:setAttribute("HAST", hast + skill.evo_rank3["Script Arg1"])
      buff1:setAttribute("MSPD", mspd + skill.evo_rank3["Script Arg1"])
    end
    ulttarget:addBuff(buff1, owner)
  end
  return buff
end

function IO.skillatk2_selectTarget(basefunc, self, default)
  local max = -math.huge
  local selector = self:target_selector()
  local chosen
  local caster = self.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.config.is_summoned then
    elseif unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
    elseif not unit:isAlive() then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit == caster then
    elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
        local v = selector(unit)
        if not unit.config.is_summoned and chosen and chosen.config.is_summoned then
          max = v
          chosen = unit
        elseif v > max then
          max = v
          chosen = unit
        end
      end
    end
  end
  self.target = chosen
  return self.target
end

function IO.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.target then
    skill.caster.IO_atk2_target = skill.target
  end
  local skillatk2_1 = skill.caster.skills.IO_atk2_1
  if skillatk2_1 then
    skillatk2_1:takeEffectOn(skill.caster, skill.caster)
  end
  skill.cd_remaining = 999
end

function IO.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.buffremoved = false
  buff.buffupdatdremove = false
  local mimu = buff.info.MIMU
  local pimu = buff.info.PIMU
  if skill.evo_rank and skill.evo_rank >= 1 then
    mimu = mimu + skill.evo_rank1["Script Arg1"]
    pimu = pimu + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    mimu = mimu + skill.evo_rank2["Script Arg1"]
    pimu = pimu + skill.evo_rank2["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    mimu = mimu + skill.evo_rank3["Script Arg1"]
    pimu = pimu + skill.evo_rank3["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("MIMU", mimu)
    buff:setAttribute("PIMU", pimu)
  end
  buff.update = override(buff.update, IO.skillatk2_buff_update)
  buff.onRemoved = override(buff.onRemoved, IO.skillatk2_buff_onRemoved)
  return buff
end

function IO.skillatk2_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2 = caster.skills.IO_atk2
  if buff.atk2dt then
    buff.atk2dt = buff.atk2dt + dt
  else
    buff.atk2dt = dt
  end
  if not buff.caster:isAlive() then
    buff.timer = -1
  end
  if buff.atk2dt >= skillatk2.info["Script Arg2"] and not buff.buffremoved then
    local newtarget = skillatk2:selectTarget()
    if newtarget then
      buff.buffremoved = true
      buff.buffupdatdremove = true
      buff.atk2dt = nil
      buff.timer = -1
      caster.IO_atk2_target = newtarget
      skillatk2:takeEffectOn(caster.IO_atk2_target, caster)
    end
  elseif caster.foecamp == owner.camp and not buff.buffremoved then
    local newtarget = skillatk2:selectTarget()
    if newtarget then
      buff.buffremoved = true
      buff.buffupdatdremove = true
      buff.atk2dt = nil
      buff.timer = -1
      caster.IO_atk2_target = newtarget
      skillatk2:takeEffectOn(caster.IO_atk2_target, caster)
    else
      buff.buffremoved = true
      buff.buffupdatdremove = true
      buff.atk2dt = nil
      buff.timer = -1
      caster.IO_atk2_target = nil
    end
  end
end

function IO.skillatk2_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk2 = caster.skills.IO_atk2
  if buff.caster and buff.caster:isAlive() and not buff.buffupdatdremove and not ed.engine.beingEnd then
    local newtarget = skillatk2:selectTarget()
    if newtarget then
      caster.IO_atk2_target = newtarget
      skillatk2:takeEffectOn(caster.IO_atk2_target, caster)
    end
  end
  basefunc(buff)
end

function IO.skillatk2_1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local mimu = buff.info.MIMU
  local pimu = buff.info.PIMU
  local skillatk2 = buff.caster.skills.IO_atk2
  if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
    mimu = mimu + skillatk2.evo_rank1["Script Arg1"]
    pimu = pimu + skillatk2.evo_rank1["Script Arg1"]
  end
  if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
    mimu = mimu + skillatk2.evo_rank2["Script Arg1"]
    pimu = pimu + skillatk2.evo_rank2["Script Arg1"]
  end
  if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    mimu = mimu + skillatk2.evo_rank3["Script Arg1"]
    pimu = pimu + skillatk2.evo_rank3["Script Arg1"]
  end
  if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
    buff:setAttribute("MIMU", mimu)
    buff:setAttribute("PIMU", pimu)
  end
  buff.update = override(buff.update, IO.skillatk2_1_buff_update)
  buff.onRemoved = override(buff.onRemoved, IO.skillatk2_1_buff_onRemoved)
  return buff
end

function IO.skillatk2_1_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2 = caster.skills.IO_atk2
  local haveskillatk2buff = false
  for unit in ed.engine:foreachAliveUnit(0) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 11000902 and tbuff.caster == buff.caster then
        haveskillatk2buff = true
        break
      end
    end
  end
  if not haveskillatk2buff then
    local newtarget = skillatk2:selectTarget()
    if newtarget then
      caster.IO_atk2_target = newtarget
      skillatk2:takeEffectOn(caster.IO_atk2_target, caster)
    end
  end
end

function IO.skillatk2_1_buff_onRemoved(basefunc, buff)
  if buff.caster.IO_atk2_target and buff.caster.IO_atk2_target:isAlive() then
    for i, tbuff in ipairs(buff.caster.IO_atk2_target.buff_list) do
      if tbuff.info.ID == 11000902 and tbuff.caster == buff.caster then
        local buff = tbuff
        buff.timer = -1
        break
      end
    end
  end
  basefunc(buff)
end

function IO.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, IO.atk3_buffUpdate)
  return buff
end

function IO.atk3_buffUpdate(basefunc, buff, dt)
  local dir = buff.owner:getInitDir()
  if dir ~= buff.owner.direction and not buff.owner.buff_effects.uncontrollable and not buff.owner.buff_effects.invulnerable then
    buff.timer = -1
    local skillatk3_1 = buff.caster.skills.IO_atk3_1
    if skillatk3_1 then
      skillatk3_1:takeEffectOn(buff.owner)
    end
  end
  basefunc(buff, dt)
end

function IO.skillatk4_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = 11000907
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function IO.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 11000907 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function IO.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.refraction = 1
  if skill.evo_rank and skill.evo_rank >= 3 and target == caster.IO_atk2_target then
    buff.refraction = skill.evo_rank3["Script Arg1"]
  end
  buff.onRemoved = override(buff.onRemoved, IO.skillatk4_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, IO.skillatk4_buffOnDamaged)
  return buff
end

function IO.skillatk4_takeEffectOn(basefunc, skill, target)
  if target ~= skill.caster and not target.config.is_summoned then
    basefunc(skill, target)
  end
end

function IO.skillatk4_buffOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  local owner = buff.owner
  local caster = buff.caster
  if damage <= 0 then
    if buff.refraction and 0 >= buff.refraction then
      owner:removeBuff(buff)
    end
    return 0
  end
  if source == owner then
    return damage
  end
  if not buff.shield then
    return damage
  elseif not buff.info["No Pass"] == true and (skill and skill.info["Ignore Shield"] == true or damageinfo and damageinfo["Ignore Shield"]) then
    return damage
  else
    local block = false
    local stype = buff.info["Shield Type"]
    if stype == damage_type or stype == "all" then
      buff.shield = buff.shield - damage
      local temp = buff.shield
      buff.refraction = buff.refraction - 1
      local ShieldIncrease = 0
      local ShieldWeak = 0
      if owner.attribs.ShieldIncrease then
        ShieldIncrease = owner.attribs.ShieldIncrease
      end
      if owner.attribs.ShieldWeak then
        ShieldWeak = owner.attribs.ShieldWeak
      end
      local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
      buff.shield = buff.info["Shield Value"] * (owner.config.hp_mod or 1) * shieldratio
      if buff.refraction and 0 >= buff.refraction then
        owner:removeBuff(buff)
      end
      local skillatk4 = caster.skills.IO_atk4
      local mppower = skillatk4.info["Script Arg2"]
      local mpattack = skillatk4.info["Script Arg3"]
      local apattack = skillatk4.info["Script Arg4"] + skillatk4.info["Script Arg5"] * caster.attribs.AP
      if skillatk4.evo_rank and 1 <= skillatk4.evo_rank then
        mppower = mppower + skillatk4.evo_rank1["Script Arg1"]
      end
      if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
        mpattack = mpattack + skillatk4.evo_rank2["Script Arg1"]
      end
      buff.caster:takeHeal(mppower, "mp", owner)
      source:takeDamage(mpattack, "Holy", "mp", buff.caster)
      source:takeDamage(apattack, "AP", "hp", buff.caster)
      if temp < 0 then
        return -temp
      end
      if owner.actor then
        local color = owner.camp == ed.emCampPlayer and "blue" or "red"
        local str = {
          AD = "physical_immune",
          AP = "magic_immune",
          all = "immune"
        }
        ed.PopupCreate(str[stype] or "immune", color, owner.actor, nil, "text")
      end
      return 0
    end
  end
  return damage
end

function IO.skillatk4_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  buff.refraction = 0
  return basefunc(buff)
end

function IO.reset(basefunc, hero)
  basefunc(hero)
  hero.IO_atk2_target = nil
end

function IO.createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableTrack(skill.target)
  return projectile
end

function IO.init_hero(hero)
  hero.reset = override(hero.reset, IO.reset)
  local skillult = hero.skills.IO_ult
  local skillatk2 = hero.skills.IO_atk2
  local skillatk2_1 = hero.skills.IO_atk2_1
  local skillatk3 = hero.skills.IO_atk3
  local skillatk4 = hero.skills.IO_atk4
  if skillult then
    skillult.createBuff = override(skillult.createBuff, IO.skillult_createBuff)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, IO.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, IO.skillatk2_createBuff)
    skillatk2.selectTarget = override(skillatk2.selectTarget, IO.skillatk2_selectTarget)
  end
  if skillatk2_1 then
    skillatk2_1.createBuff = override(skillatk2_1.createBuff, IO.skillatk2_1_createBuff)
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, IO.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, IO.skillatk4_takeEffectOn)
    skillatk4.start = override(skillatk4.start, IO.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, IO.skillatk4_finish)
  end
  local skillatk = hero.skills.IO_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, IO.createProjectile)
  end
  return hero
end

return IO.init_hero
