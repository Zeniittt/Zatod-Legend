module("ed.battlehero", package.seeall)
local ed = ed
TA = {}
TA.ultstartbuff = 10005104
TA.atk2buff = 10005101
TA.Fashion_ID_1 = 511

function TA.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.TA_ult_casting = true
  caster.origposition_TA = {
    caster.position[1],
    caster.position[2]
  }
  caster.origtarget_TA = target
  local bid = TA.ultstartbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  local buffs = {}
  local index = 0
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TA.atk2buff then
      index = index + 1
      buffs[index] = tbuff
    end
  end
  for i = 1, index do
    buffs[index + 1 - i]:removeEffectAndShader()
  end
end

function TA.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if skill.attack_counter == 1 then
    skill.origtarget = skill.target
    if target then
      caster:setPosition({
        target.position[1] + caster.direction * 120,
        target.position[2]
      })
      caster.direction = -caster.direction
    end
  elseif attack_counter == 2 then
    skill.target = skill.origtarget
    if skill.target then
      basefunc(skill, skill.target.position, source)
    end
  else
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["AOE Origin"] = "target",
      ["Point Effect"] = false
    })
    basefunc(skill, skill.target.position, source)
    skill.info = originfo
    caster.position = {
      caster.origposition_TA[1],
      caster.origposition_TA[2]
    }
  end
end

function TA.skillult_finish(basefunc, skill)
  local caster = skill.caster
  caster.TA_ult_casting = nil
  basefunc(skill)
  local buffs = {}
  local index = 0
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TA.atk2buff then
      index = index + 1
      buffs[index] = tbuff
    end
  end
  for i = 1, index do
    buffs[index + 1 - i]:onAddedClient()
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TA.ultstartbuff then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  skill.attack_counter = 0
end

function TA.skillult_selectTarget(basefunc, skill, default)
  local attack_counter = skill.attack_counter
  local target = basefunc(skill, default)
  if 1 < attack_counter then
    return target
  end
  local caster = skill.caster
  local damage = 2 * (skill.info["Basic Num"] + skill.info["Plus Ratio"] * caster.attribs[skill.info["Plus Attr"]])
  local caster = skill.caster
  local targethp = target and target.hp or 0
  local maxHPTarget = target
  local origindamage = damage
  if damage > targethp then
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      if unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit.config.is_summoned then
      else
        if unit.attribs.ALLIMU then
          damage = damage * (100 - unit.attribs.ALLIMU) / 100
        end
        if targethp < unit.hp and damage >= unit.hp then
          maxHPTarget = unit
          targethp = unit.hp
        end
        damage = origindamage
      end
    end
  end
  skill.target = maxHPTarget
  return maxHPTarget
end

function TA.skillatk4_takeEffectOn(basefunc, skill, target)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4s = caster.skills.TA_atk4s
  skillatk4s.target = skill.target
  skillatk4s.origdamage = dmg
  if ret and skillatk4s.origdamage then
    skillatk4s:takeEffectAt(skill.target.position)
  end
  return ret, dmg, Crit, lfs_amount
end

function TA.skillatk4s_takeEffectOn(basefunc, skill, target)
  if target ~= skill.target then
    basefunc(skill, target)
  else
    return
  end
end

function TA.skillatk4s_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TA_atk4
  local powerratio = skillatk4.info["Script Arg2"]
  if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
    powerratio = powerratio + skillatk4.evo_rank1["Script Arg1"]
  end
  if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
    powerratio = powerratio + skillatk4.evo_rank3["Script Arg1"]
  end
  if target ~= skill.target then
    return skill.origdamage * (powerratio / 100), 1
  else
    return 0, 1
  end
end

function TA.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.refraction = skill.info["Script Arg2"]
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.refraction = skill.evo_rank2["Script Arg1"]
  end
  buff:setAttribute("AD", skill.info["Script Arg4"] + skill.info["Script Arg5"] * caster.attribs.AD)
  buff.onRemoved = override(buff.onRemoved, TA.skillatk2_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, TA.skillatk2_buffOnDamaged)
  if TA.Fashion_ID_1 and TA.Fashion_ID_1 == caster.fashion_id then
    buff.impactEffect = "eff_buff_TA_fashion_1_atk2_impact.cha"
    buff:setAttribute("Effect", "eff_buff_TA_fashion_1_atk2.cha")
  end
  return buff
end

function TA.skillatk2_buffOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  local owner = buff.owner
  local skillatk2 = owner.skills.TA_atk2
  if damage <= 0 then
    if buff.refraction and 0 >= buff.refraction then
      owner:removeBuff(buff)
    end
    return 0
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
      local mppower = skillatk2.info["Script Arg3"]
      if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
        mppower = mppower + skillatk2.evo_rank1["Script Arg1"]
      end
      owner:takeHeal(mppower, "mp", owner)
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

function TA.skillatk2_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  buff.refraction = 0
  return basefunc(buff)
end

function TA.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  if killer_unit == self and not unit.config.is_summoned then
    local skillatk2 = self.skills.TA_atk2
    if skillatk2 then
      local hero = self
      local hasbuff
      local buffnumber = 2
      local maxbuffnumber = 6
      if skillatk2.evo_rank and 2 <= skillatk2.evo_rank then
        maxbuffnumber = skillatk2.evo_rank2["Script Arg2"]
      end
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == TA.atk2buff then
          hasbuff = true
          tbuff.refraction = math.min(tbuff.refraction + buffnumber, maxbuffnumber)
          tbuff.timer = 15
          break
        end
      end
      if not hasbuff then
        local bid = TA.atk2buff
        local binfo = ed.copyTable(ed.lookupDataTable("Buff", nil, bid))
        binfo["Shield Value"] = 2100 + (skillatk2.level - 1) * 100
        local buff = ed.BuffCreate(binfo, hero, hero)
        buff.refraction = 2
        buff.timer = 15
        buff:setAttribute("AD", skillatk2.info["Script Arg4"] + skillatk2.info["Script Arg5"] * hero.attribs.AD)
        if TA.Fashion_ID_1 and TA.Fashion_ID_1 == self.fashion_id then
          buff.impactEffect = "eff_buff_TA_fashion_1_atk2_impact.cha"
          buff:setAttribute("Effect", "eff_buff_TA_fashion_1_atk2.cha")
        end
        hero:addBuff(buff, hero)
        buff.onRemoved = override(buff.onRemoved, TA.skillatk2_buffOnRemoved)
        buff.onDamaged = override(buff.onDamaged, TA.skillatk2_buffOnDamaged)
      end
    end
  end
end

function TA.skillatk2_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    local hero = skill.caster
    local skillatk2 = hero.skills.TA_atk2
    local hasbuff
    local buffnumber = skillatk2.info["Script Arg2"]
    local maxbuffnumber = 6
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      buffnumber = skillatk2.evo_rank2["Script Arg1"]
      maxbuffnumber = skillatk2.evo_rank2["Script Arg2"]
    end
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == TA.atk2buff then
        hasbuff = true
        tbuff.refraction = math.min(tbuff.refraction + buffnumber, maxbuffnumber)
        tbuff.timer = 15
        break
      end
    end
    if not hasbuff then
      skillatk2:takeEffectOn(hero)
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TA.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if TA.Fashion_ID_1 and TA.Fashion_ID_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_TA_fashion_1_atk3.cha")
  end
  return buff
end

function TA.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.dt = nil
  if hero.skills.TA_ult then
    hero.skills.TA_ult.attack_counter = 0
  end
end

function TA.update(basefunc, self, dt)
  local skillatk2 = self.skills.TA_atk2
  if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    self.dt = self.dt and self.dt + dt or dt
    if self.dt == 1 then
      skillatk2.cd_remaining = 0
    end
  end
  basefunc(self, dt)
end

function TA.init_hero(hero)
  hero.reset = override(hero.reset, TA.hero_reset)
  local skillult = hero.skills.TA_ult
  local skillatk = hero.skills.TA_atk
  local skillatk2 = hero.skills.TA_atk2
  local skillatk3 = hero.skills.TA_atk3
  local skillatk4 = hero.skills.TA_atk4
  local skillatk4s = hero.skills.TA_atk4s
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    if TA.Fashion_ID_1 and TA.Fashion_ID_1 == hero.fashion_id then
      skillult.info = ed.wraptable(skillult.info, {
        ["Point Effect"] = "eff_point_TA_fashion_1_ult.cha"
      })
    end
    skillult.takeEffectAt = override(skillult.takeEffectAt, TA.skillult_takeEffectAt)
    skillult.start = override(skillult.start, TA.skillult_start)
    skillult.selectTarget = override(skillult.selectTarget, TA.skillult_selectTarget)
    skillult.finish = override(skillult.finish, TA.skillult_finish)
  end
  if skillatk and TA.Fashion_ID_1 and TA.Fashion_ID_1 == hero.fashion_id then
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Tile Art"] = "eff_tile_TA_fashion_1_atk.cha"
    })
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      hero.update = override(hero.update, TA.update)
      if hero.name == "TA" then
        hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, TA.hero_handleUnitDieEvent)
      end
    end
    skillatk2.createBuff = override(skillatk2.createBuff, TA.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TA.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TA.skillatk3_createBuff)
    if TA.Fashion_ID_1 and TA.Fashion_ID_1 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_TA_fashion_1_atk3.cha"
      })
    end
  end
  if skillatk4 then
    hero.basic_skill = skillatk4
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TA.skillatk4_takeEffectOn)
    if skillatk4s then
      skillatk4s.takeEffectOn = override(skillatk4s.takeEffectOn, TA.skillatk4s_takeEffectOn)
      skillatk4s.power = override(skillatk4s.power, TA.skillatk4s_power)
      if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
        skillatk4s.info = ed.wraptable(skillatk4s.info, {
          ["Damage Type"] = "Holy"
        })
      end
    end
  end
  return hero
end

return TA.init_hero
