module("ed.battlehero", package.seeall)
local ed = ed
Sven = {}
Sven.assistTicks = 80
Sven.ultbuffID = 10006602
Sven.empty = 10006603

function Sven.skillult_buffOnRemoved(basefunc, buff)
  buff.owner.emptybuff = nil
  local caster = buff.caster
  if caster.changePeriod_Sven then
    if caster.current_skill then
      caster.current_skill:finish()
    end
    caster:enterActionStageFromOneStage(caster:getNormalPeriod(), 66)
    if ed.run_with_scene then
      local effect_name = "eff_impact_Transform.cha"
      local origin = caster.position
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, origin, {
        caster.direction,
        1
      }, nil, effect_z)
    end
    caster.changePeriod_Sven = nil
    caster.ultBuff_Sven = false
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "Sven" then
        panel:setPortrait(caster:getNormalPanelPic())
      end
    end
    local skillatk = caster.skills.Sven_atk
    local skillatk3 = caster.skills.Sven_atk3
    if skillatk then
      skillatk.cd_remaining = 1.5
      caster.basic_skill = skillatk
    end
    if skillatk3 then
      skillatk3.info = caster.atk3originfo
    end
  end
  local skillult = caster.skills.Sven_ult
  if skillult then
    skillult.cd_remaining = 0
  end
  basefunc(buff)
end

function Sven.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    caster.changePeriod_Sven = true
  end
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Sven.skillult_buffOnRemoved)
  target.emptybuff = buff
  return buff
end

function Sven.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.emptybuff then
    return false
  end
  return basefunc(skill, target)
end

function Sven.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_Sven then
    local bid = Sven.ultbuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("AD", skill.info["Script Arg2"] + caster.attribs.AD * skill.info["Script Arg5"])
    buff:setAttribute("HAST", skill.info["Script Arg3"])
    buff:setAttribute("MSPD", skill.info["Script Arg4"])
    buff:setAttribute("HIT", 50)
    buff:setAttribute("DOTRES", 30)
    if skill.evo_rank and skill.evo_rank >= 1 then
      buff:setAttribute("AD", skill.info["Script Arg2"] + caster.attribs.AD * skill.evo_rank1["Script Arg1"])
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      buff:setAttribute("AD", skill.info["Script Arg2"] + caster.attribs.AD * skill.evo_rank2["Script Arg1"])
    end
    caster:addBuff(buff, caster)
    if buff then
      for i, tbuff in ipairs(buff.owner.buff_list) do
        if tbuff.info.ID == Sven.empty then
          tbuff.timer = buff.timer
        end
      end
    end
    caster:enterActionStageFromOneStage(caster:getUltPeriod(), 66)
    local atk3 = caster.skills.Sven_atk3
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
      local atk = caster.skills.Sven_atk
      atk.cd_remaining = 9999
      atk:pause()
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "Sven" then
        panel:setPortrait(caster:getUltPanelPic())
      end
    end
    local skillatk3 = caster.skills.Sven_atk3
    local skillatk = caster.skills.Sven_atk
    if skillatk3 and skillatk then
      skillatk.cd_remaining = 1
    end
  end
end

function Sven.skillult_onAttackFrame(basefunc, self)
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

function Sven.sillatk2_createProjectile(basefunc, skill)
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile:enableTrack(target)
  ed.engine:addProjectile(projectile)
end

function Sven.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local timer = buff.timer
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = timer + skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Sven.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skill = caster.skills.Sven_atk3
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

function Sven.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster.assistTickTimer and type(caster.assistTickTimer) == "table" and target then
    caster.assistTickTimer[target] = ed.engine.ticks
  end
  return basefunc(skill, target, source, shift)
end

function Sven.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster.assistTickTimer and type(caster.assistTickTimer) == "table" and target then
    caster.assistTickTimer[target] = ed.engine.ticks
  end
  return basefunc(skill, target, source, shift)
end

function Sven.handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skill = self.skills.Sven_ult
  if self:isAlive() and not unit.config.is_summoned and self.emptybuff then
    local currentTick = ed.engine.ticks
    local lastHitTick = self.assistTickTimer and self.assistTickTimer[unit]
    local assist = lastHitTick and currentTick - lastHitTick <= Sven.assistTicks
    if assist and self.emptybuff and skill.evo_rank and skill.evo_rank >= 3 then
      self.emptybuff.timer = self.emptybuff.timer + skill.evo_rank3["Script Arg1"]
      for i, tbuff in ipairs(self.buff_list) do
        if tbuff.info.ID == Sven.ultbuffID then
          tbuff.timer = self.emptybuff.timer
        end
      end
    end
  end
end

function Sven.reset(basefunc, hero)
  basefunc(hero)
  local skillult = hero.skills.Sven_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    hero:enterActionStageFromOneStage(hero:getNormalPeriod(), 66)
    hero.assistTickTimer = {}
  end
  if skillult then
    local bid = 10006605
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function Sven.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.Sven_atk4
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

function Sven.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, Sven.reset)
  local skillult = hero.skills.Sven_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, Sven.skillult_createBuff)
    skillult.finish = override(skillult.finish, Sven.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Sven.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Sven.skillult_onAttackFrame)
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Sven.handleUnitDieEvent)
    end
  end
  local skillatk2 = hero.skills.Sven_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, Sven.skillatk2_createBuff)
    skillatk2.createProjectile = override(skillatk2.createProjectile, Sven.sillatk2_createProjectile)
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
  local skillatk3 = hero.skills.Sven_atk3
  if skillatk3 then
    skillatk3.getDamage = override(skillatk3.getDamage, Sven.skillatk3_getDamage)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Sven.skillatk3_takeEffectOn)
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
  local skillatk4 = hero.skills.Sven_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Sven.skillatk4_createBuff)
  end
  local skillatk = hero.skills.Sven_atk
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Sven.skillatk_takeEffectOn)
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
    local pic = "UI/DOTA-HERO/Sven.png"
    return pic
  end
  
  function hero.getUltPanelPic(unit)
    local pic = "UI/DOTA-HERO/Sven_s.png"
    return pic
  end
  
  return hero
end

return Sven.init_hero
