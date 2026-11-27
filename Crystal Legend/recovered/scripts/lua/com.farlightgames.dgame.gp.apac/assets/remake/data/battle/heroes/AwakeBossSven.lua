module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossSven = {}
AwakeBossSven.assistTicks = 80
AwakeBossSven.ultbuffID = 12001102
AwakeBossSven.empty = 12001103

function AwakeBossSven.skillult_buffOnRemoved(basefunc, buff)
  buff.owner.emptybuff = nil
  local caster = buff.caster
  if caster.changePeriod_AwakeBossSven then
    if caster.current_skill then
      caster.current_skill:finish()
    end
    caster:enterActionStageFromOneStage(caster:getNormalPeriod(), 200011)
    if ed.run_with_scene then
      local effect_name = "eff_impact_Transform.cha"
      local origin = caster.position
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, origin, {
        caster.direction,
        1
      }, nil, effect_z)
    end
    caster.changePeriod_AwakeBossSven = nil
    caster.ultBuff_AwakeBossSven = false
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "AwakeBossSven" then
        panel:setPortrait(caster:getNormalPanelPic())
      end
    end
    local skillatk = caster.skills.AwakeBossSven_atk
    local skillatk3 = caster.skills.AwakeBossSven_atk3
    if skillatk then
      skillatk.cd_remaining = 1.5
      caster.basic_skill = skillatk
    end
    if skillatk3 then
      skillatk3.info = caster.atk3originfo
    end
  end
  local skillult = caster.skills.AwakeBossSven_ult
  if skillult then
    skillult.cd_remaining = 0
  end
  basefunc(buff)
end

function AwakeBossSven.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    caster.changePeriod_AwakeBossSven = true
  end
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, AwakeBossSven.skillult_buffOnRemoved)
  target.emptybuff = buff
  return buff
end

function AwakeBossSven.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.emptybuff then
    return false
  end
  return basefunc(skill, target)
end

function AwakeBossSven.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_AwakeBossSven then
    local bid = AwakeBossSven.ultbuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("AD", skill.info["Script Arg2"] + caster.attribs.AD * skill.info["Script Arg5"])
    buff:setAttribute("HAST", skill.info["Script Arg3"])
    buff:setAttribute("MSPD", skill.info["Script Arg4"])
    buff:setAttribute("HIT", 100)
    if skill.evo_rank and skill.evo_rank >= 1 then
      buff:setAttribute("AD", skill.info["Script Arg2"] + caster.attribs.AD * skill.evo_rank1["Script Arg1"])
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      buff:setAttribute("AD", skill.info["Script Arg2"] + caster.attribs.AD * skill.evo_rank2["Script Arg1"])
    end
    caster:addBuff(buff, caster)
    if buff then
      for i, tbuff in ipairs(buff.owner.buff_list) do
        if tbuff.info.ID == AwakeBossSven.empty then
          tbuff.timer = buff.timer
        end
      end
    end
    caster:enterActionStageFromOneStage(caster:getUltPeriod(), 200011)
    local atk3 = caster.skills.AwakeBossSven_atk3
    if atk3 then
      caster.basic_skill = atk3
      caster.atk3originfo = atk3.info
      atk3.info = ed.wraptable(caster.atk3originfo, {
        ["Plus Ratio"] = caster.atk3originfo["Plus Ratio"],
        CD = 1.5,
        ["Global CD"] = 1.5
      })
      if atk3.evo_rank and atk3.evo_rank >= 1 then
        atk3.info = ed.wraptable(caster.atk3originfo, {
          ["Plus Ratio"] = atk3.evo_rank1["Script Arg1"],
          CD = 1.5,
          ["Global CD"] = 1.5
        })
      end
      if atk3.evo_rank and atk3.evo_rank >= 3 then
        atk3.info = ed.wraptable(caster.atk3originfo, {
          ["Plus Ratio"] = atk3.evo_rank3["Script Arg1"],
          CD = 1.5,
          ["Global CD"] = 1.5
        })
      end
      caster.attack_range = atk3.info["Max Range"]
      local atk = caster.skills.AwakeBossSven_atk
      atk.cd_remaining = 9999
      atk:pause()
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "AwakeBossSven" then
        panel:setPortrait(caster:getUltPanelPic())
      end
    end
    local skillatk3 = caster.skills.AwakeBossSven_atk3
    local skillatk = caster.skills.AwakeBossSven_atk
    if skillatk3 and skillatk then
      skillatk.cd_remaining = 1
    end
  end
end

function AwakeBossSven.skillult_onAttackFrame(basefunc, self)
  local attack_counter = self.attack_counter
  if self.caster.manually_casting and self.attack_counter == 1 then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
    self.attack_counter = self.attack_counter + 1
  else
    if attack_counter == 0 and ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(3, 1.2, 10)
    end
    self.attack_counter = self.attack_counter + 1
    if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
      self:selectTarget(nil)
    end
    if not self.target then
      return
    end
    local info = self.info
    local caster = self.caster
    local ttype = info["Track Type"]
    if ttype == "projectile" then
      local projectile = self:createProjectile()
      ed.engine:addProjectile(projectile)
    elseif ttype == "chain" then
      local chain = self:createChain()
      ed.engine:addChain(chain)
    elseif ttype == nil then
      self:takeEffectAt(self.target.position)
    else
      EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
    end
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    if info["Move Forward"] ~= 0 then
      caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
    end
  end
end

function AwakeBossSven.sillatk2_createProjectile(basefunc, skill)
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile:enableTrack(target)
  ed.engine:addProjectile(projectile)
end

function AwakeBossSven.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = buff.timer + skill.evo_rank2["Script Arg1"]
  end
  return buff
end

function AwakeBossSven.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skill = caster.skills.AwakeBossSven_atk3
  local distanceSQ = (target.position[1] - caster.position[1]) ^ 2 + (target.position[2] - caster.position[2]) ^ 2
  if distanceSQ > skill.info["Max Range"] ^ 2 then
    power = skill.info["Script Arg2"] / 100 * power
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  if skill.evo_rank and 2 <= skill.evo_rank and target and target.hp < target.attribs.HP * skill.evo_rank2["Script Arg1"] / 100 then
    target:takeDamage(dmg * skill.evo_rank2["Script Arg2"] / 100, "Holy", "hp", caster)
  end
  return dmg
end

function AwakeBossSven.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster.assistTickTimer and type(caster.assistTickTimer) == "table" and target then
    caster.assistTickTimer[target] = ed.engine.ticks
  end
  return basefunc(skill, target, source, shift)
end

function AwakeBossSven.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster.assistTickTimer and type(caster.assistTickTimer) == "table" and target then
    caster.assistTickTimer[target] = ed.engine.ticks
  end
  return basefunc(skill, target, source, shift)
end

function AwakeBossSven.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local list = skill:collectAoeTarget(caster.position, caster.direction)
  for k, unit in ipairs(list) do
    local prob = ed.rand()
    print(prob)
    if prob < 0.3 then
      local bid = 12001106
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, unit, caster)
      unit:addBuff(buff, caster)
    end
  end
  basefunc(skill, location, source)
end

function AwakeBossSven.handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skill = self.skills.AwakeBossSven_ult
  if self:isAlive() and not unit.config.is_summoned and self.emptybuff then
    local currentTick = ed.engine.ticks
    local lastHitTick = self.assistTickTimer and self.assistTickTimer[unit]
    local assist = lastHitTick and currentTick - lastHitTick <= AwakeBossSven.assistTicks
    if assist and self.emptybuff and skill.evo_rank and skill.evo_rank >= 3 then
      self.emptybuff.timer = self.emptybuff.timer + skill.evo_rank3["Script Arg1"]
      for i, tbuff in ipairs(self.buff_list) do
        if tbuff.info.ID == AwakeBossSven.ultbuffID then
          tbuff.timer = self.emptybuff.timer
        end
      end
    end
  end
end

function AwakeBossSven.reset(basefunc, hero)
  basefunc(hero)
  local skillult = hero.skills.AwakeBossSven_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    hero:enterActionStageFromOneStage(hero:getNormalPeriod(), 200011)
    hero.assistTickTimer = {}
  end
  if skillult then
    local bid = 12001105
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function AwakeBossSven.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.AwakeBossSven_atk4
  local atk4originfo = buff.info
  if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
    buff:setAttribute("ARM", atk4originfo.ARM + skillatk4.evo_rank1["Script Arg1"])
  end
  if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
    buff:setAttribute("ARM", atk4originfo.ARM + skillatk4.evo_rank1["Script Arg1"] + skillatk4.evo_rank2["Script Arg1"])
  end
  if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
    buff:setAttribute("ARM", atk4originfo.ARM + skillatk4.evo_rank1["Script Arg1"] + skillatk4.evo_rank2["Script Arg1"] + caster.attribs.STR / skillatk4.evo_rank3["Script Arg1"])
  end
  return buff
end

function AwakeBossSven.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, AwakeBossSven.reset)
  local skillult = hero.skills.AwakeBossSven_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, AwakeBossSven.skillult_createBuff)
    skillult.finish = override(skillult.finish, AwakeBossSven.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, AwakeBossSven.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, AwakeBossSven.skillult_onAttackFrame)
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, AwakeBossSven.handleUnitDieEvent)
    end
  end
  local skillatk2 = hero.skills.AwakeBossSven_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossSven.skillatk2_createBuff)
    skillatk2.createProjectile = override(skillatk2.createProjectile, AwakeBossSven.sillatk2_createProjectile)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  local skillatk3 = hero.skills.AwakeBossSven_atk3
  if skillatk3 then
    skillatk3.getDamage = override(skillatk3.getDamage, AwakeBossSven.skillatk3_getDamage)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, AwakeBossSven.skillatk3_takeEffectOn)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, AwakeBossSven.skillatk3_takeEffectAt)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"],
        CD = 3,
        ["Global CD"] = 3
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"],
        CD = 3,
        ["Global CD"] = 3
      })
    end
  end
  local skillatk4 = hero.skills.AwakeBossSven_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, AwakeBossSven.skillatk4_createBuff)
  end
  local skillatk = hero.skills.AwakeBossSven_atk
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, AwakeBossSven.skillatk_takeEffectOn)
  end
  
  function hero.getNormalPeriod(unit)
    local period = 1
    return period
  end
  
  function hero.getUltPeriod(unit)
    local period = 2
    return period
  end
  
  function hero.getNormalPanelPic(unit)
    local pic = "UI/DOTA-HERO/AwakeBossSven.png"
    return pic
  end
  
  function hero.getUltPanelPic(unit)
    local pic = "UI/DOTA-HERO/AwakeBossSven_s.png"
    return pic
  end
  
  return hero
end

return AwakeBossSven.init_hero
