module("ed.battlehero", package.seeall)
local ed = ed
PA = {}
PA.blink_distance = 70
PA.critPercent = 0.25
PA.bigType = "big"
PA.greenType = "green"
PA.goldType = "gold"
PA.BKB_Time = 4
PA.BKBhp_coef = 0.4
PA.skillFashionId = 611
PA.fashion_distanceCoef = 150
PA.fashion_dodgLimit = 100

function PA.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if caster.ultBuff_PA then
    return false, "ultIng"
  end
  return true
end

function PA.skillult_start(basefunc, skill, target)
  local bid = 10006103
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function PA.skillult_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  if caster.changePeriod_PA and not ed.engine.beingEnd then
    if caster.current_skill then
      caster.current_skill:finish()
    end
    if PA.skillFashionId and PA.skillFashionId == caster.fashion_id then
      if caster.currentActionStage ~= 7 then
        caster:enterActionStageFromOneStage(7, 61)
      end
    elseif caster.currentActionStage ~= 1 then
      caster:enterActionStageFromOneStage(1, 61)
    end
    caster.changePeriod_PA = nil
    caster.ultBuff_PA = nil
    caster.skills.PA_ult.cd_remaining = 0
    local skillatk = caster.skills.PA_atk
    if skillatk then
      skillatk.info = skillatk.originfo
    end
    caster.sureCrit_PA = nil
  end
  basefunc(buff)
end

function PA.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local AD = buff.info.AD
  buff.onRemoved = override(buff.onRemoved, PA.skillult_buffOnRemoved)
  caster.ultBuff_PA = true
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("AD", AD + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("AD", AD + skill.evo_rank1["Script Arg1"] + skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function PA.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
  elseif attack_counter == 2 then
  end
end

function PA.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_PA then
    if PA.skillFashionId and PA.skillFashionId == caster.fashion_id then
      caster:enterActionStageFromOneStage(8, 61)
    else
      caster:enterActionStageFromOneStage(2, 61)
    end
    local skillatk = caster.skills.PA_atk
    if skillatk then
      skillatk.originfo = skillatk.info
      skillatk.info = ed.wraptable(skillatk.originfo, {
        CD = 0,
        ["Global CD"] = 0
      })
      skillatk.cd_remaining = 0
    end
    caster.global_cd = 0
    caster.sureCrit_PA = 3
    if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(27) then
      local charmEffect = ed.engine.rogueSkillMgr:getCharm(27)
      caster.sureCrit_PA = 999
    end
    if caster.atk4buff_PA and skill.caster.name == "PA" then
      caster:setIdleAction("Idle3")
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10006103 then
      caster:removeBuff(tbuff)
    end
  end
end

function PA.BKBBuff_update(basefunc, self, dt)
  local caster = self.caster
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
  basefunc(self, dt)
end

function PA.BKBBuff_upgrade(basefunc, self, owner, caster, nextBuffInfo)
  if self.timer > PA.BKB_Time then
    return self
  else
    return basefunc(self, owner, caster, nextBuffInfo)
  end
end

function PA.skillult_onPhaseFinished(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 1 then
    local target = skill.target
    target = target or skill:selectTarget(nil)
    local caster = skill.caster
    if target then
      local direction = target.position[1] - caster.position[1] > 0 and 1 or -1
      local position1 = target.position[1] + direction * PA.blink_distance
      if target.buff_effects.stable or 799 < position1 or position1 < 1 then
        position1 = position1 - 2 * direction * PA.blink_distance
        if 799 < position1 then
          position1 = 799
        elseif position1 < 1 then
          position1 = 1
        end
      end
      caster.position = {
        position1,
        target.position[2]
      }
      caster.changePeriod_PA = true
      caster:addBuff(skill:createBuff(caster))
      if skill.evo_rank and 2 <= skill.evo_rank then
        local bid = 10006104
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local BKBBuff = ed.BuffCreate(binfo, caster, caster)
        BKBBuff.update = override(BKBBuff.update, PA.BKBBuff_update)
        caster:addBuff(BKBBuff, caster)
      end
    end
  end
end

function PA.skillatk_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  if caster.atkcrit_PA then
    skill.info["Do Crit"] = "YES"
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  else
    skill.info["Do Crit"] = "NO"
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  caster.atkcrit_PA = nil
  return dmg
end

function PA.skillatk_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local originfo = skill.info
  if not caster.atkcrit_PA then
    skill.info = ed.wraptable(originfo, {
      ["Impact Effect"] = "eff_impact_slash.cha",
      ["Impact Zorder"] = 0
    })
    basefunc(skill, location, source)
    skill.info = originfo
  else
    basefunc(skill, location, source)
  end
end

function PA.skillatk_start(basefunc, skill, target)
  local info = skill.info
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local caster = skill.caster
  local bCrit = true
  if caster.sureCrit_PA >= 1 then
    caster.sureCrit_PA = caster.sureCrit_PA - 1
  else
    local defence = math.max(0, target.attribs.ARM - caster.attribs.ARMP)
    local crit_resist = target.attribs.CRITRES
    local totalBuffCrit = 0
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.CRIT ~= 0 then
        totalBuffCrit = totalBuffCrit + tbuff.info.CRIT
      end
    end
    local myCrit = caster.attribs.CRIT
    local crit_prob = (myCrit + totalBuffCrit - crit_resist) / (100 + defence * 8)
    bCrit = crit_prob > ed.rand()
  end
  if bCrit then
    skill:startPhase(3)
    caster.atkcrit_PA = true
  else
    local t = ed.rand() < 0.5
    if t then
      skill:startPhase(1)
    else
      skill:startPhase(2)
    end
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

function PA.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function PA.skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.atkcrit_PA = nil
end

function PA.skillatk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.owner
  if caster.name == "PA" then
    if caster.ultBuff_PA then
      caster:setIdleAction("Idle2")
    else
      caster:setIdleAction("Idle")
    end
  end
  caster.atk4buff_PA = nil
  caster.current_opacity = nil
  caster.opacityTag = nil
end

function PA.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local dodg = buff.info.DODG
  buff.onRemoved = override(buff.onRemoved, PA.skillatk4_buffOnRemoved)
  caster.atk4buff_PA = true
  caster.current_opacity = 245
  caster.opacityTag = 1
  if skill.evo_rank and 1 <= skill.evo_rank then
    buff:setAttribute("DODG", dodg + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("DODG", dodg + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  if skill.caster.name == "PA" then
    if caster.ultBuff_PA then
      caster:setIdleAction("Idle3")
    else
      caster:setIdleAction("Idle4")
    end
  end
  return buff
end

function PA.hero_onHitMiss(basefunc, hero, skill)
  basefunc(hero, skill)
  local skillatk4 = hero.skills.PA_atk4
  if skillatk4 then
    local mp = skillatk4.info["Script Arg2"]
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      mp = mp + skillatk4.evo_rank3["Script Arg1"]
    end
    if hero.atk4buff_PA then
      hero:takeHeal(mp, "mp")
    end
  end
end

function PA.skillatk4_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if caster.atk4buff_PA then
    return false, "dodgbuff"
  end
  return true
end

function PA.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.sureCrit_PA = nil
  hero.atkcrit_PA = nil
  hero.atk2crit_PA = nil
  hero.atk3crit_PA = nil
  hero.atk4buff_PA = nil
  hero.ultBuff_PA = nil
  hero.fashion_dodgBuff = false
  hero.fashion_buffTimeCount = 0
  if hero.currentActionStage ~= 1 or hero.currentActionStage ~= 3 or hero.currentActionStage ~= 5 or hero.currentActionStage ~= 7 then
    if PA.skillFashionId and PA.skillFashionId == hero.fashion_id then
      hero:enterActionStageFromOneStage(7, 61)
    else
      hero:enterActionStageFromOneStage(1, 61)
    end
  end
end

function PA.skillatk_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if not caster.ultBuff_PA then
    return false, "not ultIng"
  end
  return true
end

function PA.fashion_dodgBuffUpdate(basefunc, buff, dt)
  local owner = buff.owner
  local PA_fashion_DODG = 0
  owner.fashion_buffTimeCount = owner.fashion_buffTimeCount + dt
  if owner.fashion_buffTimeCount % 1 == 0 then
    for unit in ed.engine:foreachAliveUnit(owner.foecamp) do
      local XdistanceSQ = (unit.position[1] - owner.position[1]) ^ 2
      if XdistanceSQ < PA.fashion_distanceCoef ^ 2 and not unit.config.is_summoned then
        PA_fashion_DODG = PA_fashion_DODG + 15
      end
    end
    PA_fashion_DODG = math.min(PA_fashion_DODG, PA.fashion_dodgLimit)
    buff:setAttribute("DODG", PA_fashion_DODG)
    owner:rebuild()
  end
  basefunc(buff, dt)
end

function PA.hero_update(basefunc, hero, dt)
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(27) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(27)
    hero.dt = hero.dt and hero.dt + dt or dt
    if hero.dt == 1 then
      local bid = 64000027
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      buff:setAttribute("CSD", charmEffect.info["Script Arg" .. charmEffect.level])
      hero:addBuff(buff, hero)
    end
  end
  basefunc(hero, dt)
end

function PA.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, PA.hero_reset)
  hero.onHitMiss = override(hero.onHitMiss, PA.hero_onHitMiss)
  hero.update = override(hero.update, PA.hero_update)
  hero.fashion_dodgBuff = false
  hero.fashion_buffTimeCount = 0
  local skillult = hero.skills.PA_ult
  local skillatk = hero.skills.PA_atk
  local skillatk3 = hero.skills.PA_atk3
  local skillatk4 = hero.skills.PA_atk4
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.start = override(skillult.start, PA.skillult_start)
    skillult.createBuff = override(skillult.createBuff, PA.skillult_createBuff)
    skillult.takeEffectAt = override(skillult.takeEffectAt, PA.skillult_takeEffectAt)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, PA.skillult_onPhaseFinished)
    skillult.finish = override(skillult.finish, PA.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, PA.skillult_canCastWithTarget)
  end
  if skillatk then
    skillatk.canCastWithTarget = override(skillatk.canCastWithTarget, PA.skillatk_canCastWithTarget)
    skillatk.getDamage = override(skillatk.getDamage, PA.skillatk_getDamage)
    skillatk.start = override(skillatk.start, PA.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, PA.skillatk_onPhaseFinished)
    skillatk.takeEffectAt = override(skillatk.takeEffectAt, PA.skillatk_takeEffectAt)
    skillatk.finish = override(skillatk.finish, PA.skillatk_finish)
  end
  if skillatk3 then
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
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
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, PA.skillatk_onPhaseFinished)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, PA.skillatk4_createBuff)
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, PA.skillatk4_canCastWithTarget)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return PA.init_hero
