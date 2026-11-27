module("ed.battlehero", package.seeall)
local ed = ed
NC = {}

function NC.atk2_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  if not caster.buff_effects.doom then
    local list = caster.buff_list
    local debuff_list = {}
    local my_camp = caster.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      caster:removeBuff(debuff_list[i])
    end
    caster:skillatk2_waterEffect()
    local skillatk2_2 = caster.skills.NC_atk2_2
    skillatk2_2:takeEffectAt(caster.position)
  end
  basefunc(buff)
end

function NC:skillatk2_waterEffect()
  if ed.run_with_scene then
    local effect_night = "eff_point_NC_atk2.cha"
    local origin = self.position
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end

function NC.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local originfo = buff.info
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("ARM", originfo.ARM + skill.evo_rank3["Script Arg1"])
  end
  buff.onRemoved = override(buff.onRemoved, NC.atk2_buff_onRemoved)
  return buff
end

function NC.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("HAST", -skill.info["Script Arg2"])
  buff:setAttribute("MSPD", -skill.info["Script Arg2"])
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HAST", -skill.info["Script Arg2"] - skill.evo_rank2["Script Arg1"])
    buff:setAttribute("MSPD", -skill.info["Script Arg2"] - skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function NC.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  local caster = skill.caster
  if skill.attack_counter == 3 then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.3,
      ["Knock Back"] = 45
    })
    basefunc(skill, location, source)
    skill.info = originfo
  else
    basefunc(skill, location, source)
  end
end

function NC.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  if ret then
    local caster = skill.caster
    if skill.evo_rank and skill.evo_rank >= 3 and caster.stealnum < 30 and not target.config.is_summoned then
      local bid = 11001204
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
      caster.stealnum = caster.stealnum + 1
    end
  end
  return ret, dmg
end

function NC.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  if ret then
    local caster = skill.caster
    local skillatk3 = caster.skills.NC_atk3
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 and caster.stealnum < 30 and not target.config.is_summoned then
      local bid = 11001204
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
      caster.stealnum = caster.stealnum + 1
    end
  end
  return ret, dmg
end

function NC.update(basefunc, self, dt)
  basefunc(self, dt)
  local skillatk3 = self.skills.NC_atk3
  local stealnum_change = self.stealnum - self.stealnum_last
  if skillatk3.evo_rank and skillatk3.evo_rank >= 3 and 0 < stealnum_change then
    local bid = 11001205
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, self, self)
    buff:setAttribute("AD", skillatk3.evo_rank3["Script Arg1"] * stealnum_change)
    self:addBuff(buff, self)
    self.stealnum_last = self.stealnum
  end
end

function NC.skillult_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  skill:lockCasterDirection(false)
  if skill.current_phase_idx == 1 then
    local position1 = caster.position[1] + 150 * caster.ultdirection
    caster:setPosition({
      position1,
      caster.position[2]
    })
    skill:startPhase(2)
  elseif skill.current_phase_idx == 2 then
    local position1 = caster.position[1] + 150 * caster.ultdirection
    caster:setPosition({
      position1,
      caster.position[2]
    })
    skill:startPhase(3)
  else
    basefunc(skill)
  end
end

function NC.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillult2 = caster.skills.NC_ult2
  if skillult2 and caster.NC_jump < 7 then
    skillult2.cd_remaining = 0
  end
  local skillult = caster.skills.NC_ult
  local bid = 11001207
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("DODG", skillult.info["Script Arg4"])
  buff:setAttribute("ARM", skillult.info["Script Arg5"])
  caster:addBuff(buff, caster)
end

function NC.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if skill.attack_counter ~= 3 then
    caster.NC_jump = caster.NC_jump + 1
  end
  if target then
    caster.ultdirection = target.position[1] - caster.position[1] > 0 and 1 or -1
  end
  skill:lockCasterDirection(true)
  basefunc(skill)
end

function NC.skillult_interrupt(basefunc, skill)
  local caster = skill.caster
  caster.interrupt = true
  basefunc(skill)
  local skillult2 = caster.skills.NC_ult2
  if skillult2 then
    skillult2.cd_remaining = 999
  end
  local skillult3 = caster.skills.NC_ult3
  if skillult3 then
    skillult3.cd_remaining = 0
  end
  if ed.run_with_scene then
    local num = caster.NC_jump
    if 1 <= num then
      local effect_night = "eff_point_NC_ult3_" .. num .. ".cha"
      local origin = caster.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
      local effect_night2 = "eff_point_NC_ult3.cha"
      ed.scene:playEffectOnScene(effect_night2, origin, nil, nil, 0)
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11001207 then
      tbuff.timer = -1
    end
  end
  caster.NC_jump = 0
end

function NC.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.NC_ult
  if caster.interrupt == true or caster.NC_jump >= 9 then
    if ed.run_with_scene then
      local num = caster.NC_jump
      if 1 <= num then
        local effect_night = "eff_point_NC_ult3_" .. num .. ".cha"
        local origin = caster.position
        ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
        local effect_night2 = "eff_point_NC_ult3.cha"
        ed.scene:playEffectOnScene(effect_night2, origin, nil, nil, 0)
      end
    end
    local skillult2 = caster.skills.NC_ult2
    if skillult2 then
      skillult2.cd_remaining = 999
    end
    local skillult3 = caster.skills.NC_ult3
    if skillult3 then
      local originfo = skillult3.info
      if skillult.evo_rank and skillult.evo_rank >= 2 then
        local heal = caster.NC_jump * skillult.evo_rank2["Script Arg1"] * caster.attribs.HP
        skillult3.info = ed.wraptable(originfo, {
          ["Basic Num"] = heal,
          ["Impact Effect"] = "eff_impact_heal.cha"
        })
      end
      skillult3:takeEffectOn(caster)
      skillult3.info = originfo
    end
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 11001207 then
        tbuff.timer = -1
      end
    end
    caster.NC_jump = 0
    caster.interrupt = false
  end
end

function NC.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local skillult1 = caster.skills.NC_ult
  local skillult2 = caster.skills.NC_ult2
  if skillult1.casting or skillult2.casting then
    return false
  end
  return basefunc(skill, target)
end

function NC.skillult3_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local skillult = caster.skills.NC_ult
  local HAST = caster.NC_jump * buff.info.HAST
  local MSPD = caster.NC_jump * buff.info.MSPD
  buff:setAttribute("HAST", HAST)
  buff:setAttribute("MSPD", MSPD)
  return buff
end

function NC.skillult_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  local caster = skill.caster
  if skill.attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["X Shift"] = 150,
      ["Plus Ratio"] = 0.7
    })
    basefunc(skill, location, source)
    skill.info = originfo
  elseif skill.attack_counter == 2 then
    skill.info = ed.wraptable(originfo, {
      ["X Shift"] = 150,
      ["Plus Ratio"] = 0.7,
      ["Point Effect"] = "eff_point_NC_ult2.cha"
    })
    basefunc(skill, location, source)
    skill.info = originfo
  elseif skill.attack_counter == 3 then
    local target = skill.target
    target = target or skill:selectTarget(nil)
    target = skill:selectTarget(nil)
    local caster = skill.caster
    if target then
      local direction = target.position[1] - caster.position[1] > 0 and 1 or -1
      local position1 = target.position[1] - direction * 70
      if 799 < position1 then
        position1 = position1 - 140
      elseif position1 < 1 then
        position1 = position1 + 140
      end
      caster:setPosition({
        position1,
        target.position[2]
      })
    end
  else
    basefunc(skill, location, source)
  end
end

function NC.reset(basefunc, hero)
  basefunc(hero)
  hero.NC_jump = 0
  hero.interrupt = false
  hero.stealnum = 0
  hero.stealnum_last = 0
  hero.ultdirection = 0
end

function NC.init_hero(hero)
  hero.NC_jump = 0
  hero.interrupt = false
  hero.reset = override(hero.reset, NC.reset)
  hero.skillatk2_waterEffect = NC.skillatk2_waterEffect
  local skillatk = hero.skills.NC_atk
  local skillatk2 = hero.skills.NC_atk2
  local skillatk3 = hero.skills.NC_atk3
  local skillatk4 = hero.skills.NC_atk4
  local skillult = hero.skills.NC_ult
  local skillult2 = hero.skills.NC_ult2
  local skillult3 = hero.skills.NC_ult3
  local skillatk22 = hero.skills.NC_atk2_2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, NC.skillatk2_createBuff)
  end
  if skillatk2 and skillatk22 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk22.info = ed.wraptable(skillatk22.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk22.info = ed.wraptable(skillatk22.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, NC.skillatk4_createBuff)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, NC.skillatk3_takeEffectAt)
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
      hero.update = override(hero.update, NC.update)
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, NC.skillatk3_takeEffectOn)
      if skillatk then
        skillatk.takeEffectOn = override(skillatk.takeEffectOn, NC.skillatk_takeEffectOn)
      end
    end
  end
  if skillult then
    skillult.start = override(skillult.start, NC.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, NC.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, NC.skillult_takeEffectAt)
    skillult.interrupt = override(skillult.interrupt, NC.skillult_interrupt)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, NC.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, NC.skillult_finish)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, NC.skillult_onPhaseFinished)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillult2 then
    skillult2.start = override(skillult2.start, NC.skillult_start)
    skillult2.onAttackFrame = override(skillult2.onAttackFrame, NC.skillult_onAttackFrame)
    skillult2.takeEffectAt = override(skillult2.takeEffectAt, NC.skillult_takeEffectAt)
    skillult2.interrupt = override(skillult2.interrupt, NC.skillult_interrupt)
    skillult2.finish = override(skillult2.finish, NC.skillult_finish)
    skillult2.onPhaseFinished = override(skillult2.onPhaseFinished, NC.skillult_onPhaseFinished)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult2.info = ed.wraptable(skillult2.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult2.info = ed.wraptable(skillult2.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillult3 then
    skillult3.createBuff = override(skillult3.createBuff, NC.skillult3_createBuff)
  end
  return hero
end

return NC.init_hero
