module("ed.battlehero", package.seeall)
local ed = ed
SA = {}
SA.ultinv = 11002301
SA.atk2 = 11002302
SA.atk4 = 11002303
SA.fashionID1 = 100231

function SA.skillult_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = SA.ultinv
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == SA.atk2 and tbuff.timer < 5.5 then
      tbuff.timer = 5.5
    end
  end
  basefunc(skill, target)
end

function SA.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == SA.ultinv then
      local buff = tbuff
      buff.timer = -1
    end
  end
end

function SA.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    local rightward = 0
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if not unit.config.is_summoned and unit:isAlive() then
        if unit.direction == 1 then
          rightward = rightward + 1
        elseif unit.direction == -1 then
          rightward = rightward - 1
        end
      end
    end
    if 0 <= rightward then
      caster.position = {
        ed.engine.stage_rect.minX + 30,
        0
      }
      caster.direction = 1
    else
      caster.position = {
        ed.engine.stage_rect.maxX - 30,
        0
      }
      caster.direction = -1
    end
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    local skillult2 = caster.skills.SA_ult2
    if skillult2 and skill.target then
      skillult2:takeEffectAt(skill.target.position)
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == SA.ultinv then
        local buff = tbuff
        buff.timer = -1
      end
    end
    basefunc(skill)
  end
end

function SA.skillult2_takeEffectOn(basefunc, skill, target, source)
  local hit, dmg, Crit, lfs_amount = basefunc(skill, target, source)
  local skillult = skill.caster.skills.SA_ult
  if hit then
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      if not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
        local binfo = ed.lookupDataTable("Buff", nil, 11002305)
        local buff = ed.BuffCreate(binfo, target, skill.caster)
        target:addBuff(buff, skill.caster)
      end
    elseif not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
      local binfo = ed.lookupDataTable("Buff", nil, 11002304)
      local buff = ed.BuffCreate(binfo, target, skill.caster)
      target:addBuff(buff, skill.caster)
    end
  end
  return hit, dmg, Crit, lfs_amount
end

function SA.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if ed.run_with_scene then
    local effect_night = "eff_point_SA_atk2.cha"
    if caster.fashion_id and caster.fashion_id == SA.fashionID1 then
      effect_night = "eff_point_SA_fashion_1_atk2.cha"
    end
    local origin = skill.caster.position
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
  end
end

function SA.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR.a", skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    local adratio = buff.info["AD.a"]
    buff:setAttribute("AD.a", adratio + skill.evo_rank3["Script Arg1"] / 100)
  end
  buff.onRemoved = override(buff.onRemoved, SA.skillatk2buff_onRemoved)
  return buff
end

function SA.skillatk2_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local hasbuff
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == SA.atk2 then
      hasbuff = true
    end
  end
  if not basefunc(skill, target) or hasbuff then
    return false
  end
  return true
end

function SA.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local hasbuff
  local caster = skill.caster
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == SA.atk2 then
      hasbuff = true
    end
  end
  if hasbuff then
    if caster.fashion_id and caster.fashion_id == SA.fashionID1 then
      caster:enterActionStageFromOneStage(8, 10023)
    else
      caster:enterActionStageFromOneStage(2, 10023)
    end
  end
  local skillult = caster.skills.SA_ult
  if skillult then
    skillult.cd_remaining = 0
  end
  local skillatk4 = caster.skills.SA_atk4
  if skillatk4 then
    skillatk4.cd_remaining = 0
  end
end

function SA.skillatk2buff_onRemoved(basefunc, buff)
  local caster = buff.owner
  if buff.timer <= 0 then
    if caster.fashion_id and caster.fashion_id == SA.fashionID1 then
      caster:enterActionStageFromOneStage(7, 10023)
    else
      caster:enterActionStageFromOneStage(1, 10023)
    end
    if ed.run_with_scene then
      local effect_night = "eff_point_SA_atk22.cha"
      if caster.fashion_id and caster.fashion_id == SA.fashionID1 then
        effect_night = "eff_point_SA_fashion_1_atk22.cha"
      end
      local origin = buff.owner.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
    end
    local skillatk2 = buff.owner.skills.SA_atk2
    if skillatk2 then
      local cd = 12
      if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
        cd = skillatk2.evo_rank1["Script Arg1"]
      end
      skillatk2.cd_remaining = cd
    end
    local skillult = buff.owner.skills.SA_ult
    if skillult then
      skillult.cd_remaining = 0
    end
    local skillatk = buff.owner.skills.SA_atk
    if skillatk then
      skillatk.cd_remaining = 0
    end
  elseif not ed.engine.beingEnd then
    buff.caster.delay_trigger = true
  else
    buff.caster.skillatk2_battleend = true
  end
  basefunc(buff)
end

function SA.skillatk2_interrupt(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 0 then
    skill.cd_remaining = 5
  end
end

function SA.skillatk3getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  local skillatk3 = skill.caster.skills.SA_atk3
  local hasatk4Buff = false
  if skillatk3 and target then
    for i, tbuff in pairs(target.buff_list) do
      if tbuff.info.ID == SA.atk4 and tbuff.caster == caster then
        local buff = tbuff
        buff.timer = -1
        hasatk4Buff = true
        break
      end
    end
    local ifbackstab = false
    if target.direction == skill.caster.direction then
      if target.name == "BB" then
        if target.ultBuff_BB then
        else
          ifbackstab = true
        end
      else
        ifbackstab = true
      end
    elseif target.name == "BB" and target.ultBuff_BB then
      ifbackstab = true
    end
    if hasatk4Buff or ifbackstab then
      local backstab = skillatk3.info["Script Arg2"] / 100
      local agidamage = 0
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        backstab = backstab + skillatk3.evo_rank1["Script Arg1"] / 100
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        backstab = backstab + skillatk3.evo_rank2["Script Arg1"] / 100
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        agidamage = skillatk3.evo_rank3["Script Arg1"] * caster.attribs.AGI
      end
      power = power * (1 + backstab) + agidamage
    end
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = skill
  })
  return dmg
end

function SA.skillatk_start(basefunc, skill, target)
  local info = skill.info
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local caster = skill.caster
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == SA.atk2 and tbuff.timer < 1 then
      tbuff.timer = 1.5
    end
  end
  local skillatk3 = skill.caster.skills.SA_atk3
  if skillatk3 then
    local hasatk4Buff = false
    for i, tbuff in pairs(target.buff_list) do
      if tbuff.info.ID == SA.atk4 and tbuff.caster == caster then
        local buff = tbuff
        hasatk4Buff = true
        break
      end
    end
    if hasatk4Buff then
      skill:startPhase(3)
    elseif target.direction == skill.caster.direction then
      skill:startPhase(2)
    else
      skill:startPhase(1)
    end
  else
    skill:startPhase(1)
  end
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if ed.run_with_scene then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function SA.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function SA.skillatk4_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = SA.ultinv
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == SA.atk2 and tbuff.timer < 2 then
      tbuff.timer = 2
    end
  end
  basefunc(skill, target)
end

function SA.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == SA.ultinv then
      local buff = tbuff
      buff.timer = -1
    end
  end
end

function SA.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    local target = skill.target
    target = target or skill:selectTarget(nil)
    local caster = skill.caster
    if target then
      local position1 = target.position[1] - target.direction * 70
      if target.buff_effects.stable then
        position1 = position1 + target.direction * 70
      end
      if position1 < 30 then
        position1 = 30
      elseif 770 < position1 then
        position1 = 770
      end
      caster.position = {
        position1,
        target.position[2]
      }
    else
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == SA.ultinv then
        local buff = tbuff
        buff.timer = -1
      end
    end
  end
end

function SA.skillatk4_canCastWithTarget(basefunc, skill, target)
  local position1 = target.position[1]
  if not basefunc(skill, target) or 730 < position1 or position1 < 70 then
    return false
  end
  return true
end

function SA.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  if caster.fashion_id and caster.fashion_id == SA.fashionID1 then
    buff:setAttribute("Effect", "eff_buff_SA_fashion_1_atk31.cha")
  end
  return buff
end

function SA.update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit.delay_trigger and not unit.current_skill then
    if unit.fashion_id and unit.fashion_id == SA.fashionID1 then
      unit:enterActionStageFromOneStage(7, 10023)
    else
      unit:enterActionStageFromOneStage(1, 10023)
    end
    if ed.run_with_scene then
      local effect_night = "eff_point_SA_atk22.cha"
      if unit.fashion_id and unit.fashion_id == SA.fashionID1 then
        effect_night = "eff_point_SA_fashion_1_atk22.cha"
      end
      local origin = unit.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
    end
    local skillatk2 = unit.skills.SA_atk2
    if skillatk2 then
      local cd = 12
      if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
        cd = skillatk2.evo_rank1["Script Arg1"]
      end
      skillatk2.cd_remaining = cd
    end
    local skillult = unit.skills.SA_ult
    if skillult then
      skillult.cd_remaining = 0
    end
    local skillatk = unit.skills.SA_atk
    if skillatk then
      skillatk.cd_remaining = 0
    end
    unit.delay_trigger = nil
  elseif unit.skillatk2_battleend and not unit.current_skill then
    if unit.fashion_id and SA.fashionID1 == unit.fashion_id then
      unit:enterActionStageFromOneStage(7, 10023)
    else
      unit:enterActionStageFromOneStage(1, 10023)
    end
    unit.skillatk2_battleend = nil
  end
end

function SA.reset(basefunc, hero)
  basefunc(hero)
  if hero.fashion_id and SA.fashionID1 == hero.fashion_id then
    hero:enterActionStageFromOneStage(7, 10023)
  else
    hero:enterActionStageFromOneStage(1, 10023)
  end
end

function SA.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, SA.reset)
  hero.update = override(hero.update, SA.update)
  local skillult = hero.skills.SA_ult
  local skillult2 = hero.skills.SA_ult2
  local skillatk = hero.skills.SA_atk
  local skillatk2 = hero.skills.SA_atk2
  local skillatk3 = hero.skills.SA_atk3
  local skillatk4 = hero.skills.SA_atk4
  if skillult then
    skillult.start = override(skillult.start, SA.skillult_start)
    skillult.finish = override(skillult.finish, SA.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, SA.skillult_onAttackFrame)
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
  end
  if skillult2 then
    skillult2.takeEffectOn = override(skillult2.takeEffectOn, SA.skillult2_takeEffectOn)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, SA.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, SA.skillatk_onPhaseFinished)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, SA.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, SA.skillatk2_createBuff)
    skillatk2.finish = override(skillatk2.finish, SA.skillatk2_finish)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, SA.skillatk2_canCastWithTarget)
    skillatk2.interrupt = override(skillatk2.interrupt, SA.skillatk2_interrupt)
  end
  if skillatk3 then
    local skillnames = {
      "_ult",
      "_ult2",
      "_atk3",
      "_atk4",
      "_atk"
    }
    for i = 1, #skillnames do
      local skill = hero.skills["SA" .. skillnames[i]]
      if skill then
        skill.getDamage = override(skill.getDamage, SA.skillatk3getDamage)
      end
    end
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, SA.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, SA.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, SA.skillatk4_onAttackFrame)
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, SA.skillatk4_canCastWithTarget)
    skillatk4.createBuff = override(skillatk4.createBuff, SA.skillatk4_createBuff)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank3["Script Arg1"]
      })
    end
  end
  if hero.fashion_id == SA.fashionID1 then
    ed.PreloadPuppetRcs("SA_fashion_1")
    ed.PreloadPuppetRcs("SA_fashion_1_Invisibility")
    if skillult then
      hero.skills.SA_ult.info["Impact Effect"] = "eff_impact_SA_fashion_1_ult.cha"
    end
    if skillult2 then
      hero.skills.SA_ult2.info["Point Effect"] = "eff_point_SA_fashion_1_ult2.cha"
    end
    if skillatk then
      hero.skills.SA_atk.info["Impact Effect"] = "eff_impact_SA_fashion_1_atk.cha"
    end
    if skillatk4 then
      hero.skills.SA_atk4.info["Impact Effect"] = "eff_impact_SA_fashion_1_atk4.cha"
    end
  end
  return hero
end

return SA.init_hero
