module("ed.battlehero", package.seeall)
local ed = ed
Puck = {}
Puck.ult_teambuff = 10007202
Puck.atk4inv = 10007205
Puck.atk2blink = 10007206
Puck.PuckorbOutTimes = 2
Puck.PuckorbOutShrink = 0.75
Puck.PuckorbOutDelay = 0.5
Puck.testPointInShape = ed.Skill.testPointInShape
Puck.fashion_id_1 = 721
Puck.fashion_id_2 = 722

function Puck.reset(basefunc, unit)
  basefunc(unit)
  if Puck.fashion_id_1 and Puck.fashion_id_1 == unit.fashion_id then
    unit:enterActionStageFromOneStage(7, 72)
  elseif Puck.fashion_id_2 and Puck.fashion_id_2 == unit.fashion_id then
    unit:enterActionStageFromOneStage(9, 72)
  else
    unit:enterActionStageFromOneStage(1, 72)
  end
  unit.atk4_timer = nil
  unit.havecastult = false
end

function Puck.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if ed.run_with_scene and not caster.havecastult then
    if not ed.IsMultiArena() and (not ed.engine.hero_background or ed.engine.hero_background[1] ~= "Roshan_hell") then
      ed.scene:onBackgroundHide(1)
    end
    local particle = CCParticleSystemQuad:create("UI/particle/nnn.plist")
    local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
    particle:setSourcePosition(ccp(-280, 300))
    particle:setPositionType(kCCPositionTypeFree)
    particle:setEmissionRate(8)
    particle:setPosition(ccp(ed.winSize[1] / 2, ed.winSize[2] / 2))
    ed.scene:addParticle(particle, 1)
    ListenTimer(Timer:Once(0.2), function()
      local particle = CCParticleSystemQuad:create("UI/particle/chixupiao.plist")
      local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
      particle:setSourcePosition(ccp(-300, 300))
      particle:setPositionType(kCCPositionTypeFree)
      particle:setEmissionRate(2)
      particle:setPosition(ccp(ed.winSize[1] / 2, ed.winSize[2] / 2))
      ed.scene:addParticle(particle, 1)
    end)
  end
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(15) and caster.camp == 1 then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(15)
    local bid = 64000015
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff.attack_timer = charmEffect.info["Script Arg" .. charmEffect.level]
    buff.update = override(buff.update, Puck.Charm15buff_update)
    caster:addBuff(buff, caster)
  end
end

function Puck.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if not caster.havecastult then
    if Puck.fashion_id_1 and Puck.fashion_id_1 == caster.fashion_id then
      caster:enterActionStageFromOneStage(8, 72)
    elseif Puck.fashion_id_2 and Puck.fashion_id_2 == caster.fashion_id then
      caster:enterActionStageFromOneStage(10, 72)
    else
      caster:enterActionStageFromOneStage(2, 72)
    end
    if ed.run_with_scene and not ed.IsMultiArena() and (not ed.engine.hero_background or ed.engine.hero_background[1] ~= "Roshan_hell") then
      if Puck.fashion_id_2 and Puck.fashion_id_2 == caster.fashion_id then
        if ed.scene.backgroundPath == "battle_bg/bbg_puck_dream2.jpg" then
          ed.scene:onBackgroundAppear(1, "battle_bg/bbg_puck_dream2.jpg")
        else
          ed.scene:onBackgroundAppear(1, "battle_bg/bbg_puck_dream2.jpg")
        end
      elseif ed.scene.backgroundPath == "battle_bg/bbg_puck_dream1.jpg" then
        ed.scene:onBackgroundAppear(1, "battle_bg/bbg_puck_dream1.jpg")
      else
        ed.scene:onBackgroundAppear(1, "battle_bg/bbg_puck_dream1.jpg")
      end
    end
  end
  caster.havecastult = true
  local bid = Puck.ult_teambuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local oringint = caster.attribs.INT
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit:isAlive() and not unit.config.is_summoned and not unit.buff_effects.invulnerable then
      local buff = ed.BuffCreate(binfo, unit, caster)
      buff:setAttribute("INT", skill.info["Script Arg2"] + skill.info["Script Arg4"] * oringint)
      buff:setAttribute("MCSD", skill.info["Script Arg3"])
      if Puck.fashion_id_1 and Puck.fashion_id_1 == caster.fashion_id then
        buff:setAttribute("Effect", "eff_buff_Puck_fashion_1_atk4_2.cha")
      end
      if Puck.fashion_id_2 and Puck.fashion_id_2 == caster.fashion_id then
        buff:setAttribute("Effect", "eff_buff_Puck_fashion_2_atk4_2.cha")
      end
      unit:addBuff(buff, caster)
    end
  end
end

function Puck.skillult_finish(basefunc, skill, target)
  basefunc(skill, target)
end

function Puck.Charm15buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local charmEffect = ed.engine.rogueSkillMgr:getCharm(15)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + charmEffect.info["Script Arg" .. charmEffect.level]
    local skillatk = owner.skills.Puck_atk
    for unit in ed.engine:foreachAliveUnit(owner.foecamp) do
      if not unit.buff_effects.untargetable and not unit.buffManager.invisible then
        skillatk.target = unit
        local projectile = skillatk:createProjectile()
        projectile:enableTrack(unit)
        ed.engine:addProjectile(projectile)
      end
    end
  end
  buff.attack_timer = timer
end

function Puck.skillult_interrupt(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 0 and ed.run_with_scene and not ed.IsMultiArena() then
    ed.scene:onBackgroundAppear(1)
  end
end

function Puck.skillatk2a_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local info = skill.info
  local skillult = caster.skills.Puck_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    skill.skillultevodmg = power * skillult.evo_rank3["Script Arg1"] / 100
  end
  return power, coeff
end

function Puck.skillatk2a_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = Puck.atk2blink
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  owner.position2 = {
    owner.position[1],
    owner.position[2]
  }
end

function Puck.skillatk2a_onAttackFrame(basefunc, skill)
  skill.caster.isskillatk4 = false
  skill.attack_counter = skill.attack_counter + 1
  if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local DOPPosition = Puck.DOP_in_battlefield(caster, 200, caster.foecamp)
      caster:setPosition({
        DOPPosition[1],
        DOPPosition[2]
      })
    end
  else
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Puck.atk2blink then
        local buff = tbuff
        buff.timer = -1
      end
    end
    basefunc(skill)
  end
end

function Puck.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if (unit.buffManager.invisible or unit.buff_effects.untargetable or unit.buff_effects.invulnerable) and unit.camp ~= caster.camp then
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
    position = {400, 0}
    return position
  end
end

function Puck.skillatk2a_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local skillatk2b = caster.skills.Puck_atk2b
  if not caster.isskillatk4 then
    caster.isskillatk4 = false
    if skillatk2b then
      skillatk2b.cd_remaining = 0
    end
  end
end

function Puck.skillatk2a_takeEffectOn(basefunc, skill, target, source)
  local mppower = skill.info["Script Arg2"]
  local ret, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  local skillult = caster.skills.Puck_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 and ret then
    target:takeDamage(skill.skillultevodmg, "Holy", "hp", caster)
  end
  return ret, dmg
end

function Puck.skillatk2b_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = Puck.atk2blink
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
end

function Puck.skillatk2b_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      caster:setPosition({
        caster.position2[1],
        caster.position2[2]
      })
    end
  else
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Puck.atk2blink then
        local buff = tbuff
        buff.timer = -1
      end
    end
  end
end

function Puck.skillatk3a_createProjectile(basefunc, skill)
  local originOrb = basefunc(skill)
  originOrb.isOutOfStage = override(originOrb.isOutOfStage, Puck.originOrb_isOutOfStage)
  originOrb.update = override(originOrb.update, Puck.originOrb_update)
  originOrb.customScale = 1
  originOrb.damageReduce = 1
  originOrb.outTimes = 0
  return originOrb
end

function Puck.originOrb_isOutOfStage(basefunc, orb)
  local isOut = basefunc(orb)
  if isOut then
    orb.outTimes = orb.outTimes + 1
    if orb.outTimes >= Puck.PuckorbOutTimes then
      isOut = true
    else
      orb.originY = orb.position[2]
      orb.position[2] = 9999
      orb.isWait = true
      orb.waitTime = 0
      if orb.position[1] > ed.engine.stage_rect.maxX then
        orb.nextX = ed.engine.stage_rect.minX + 1
      end
      if orb.position[1] < ed.engine.stage_rect.minX then
        orb.nextX = ed.engine.stage_rect.maxX - 1
      end
      isOut = false
    end
  end
  return isOut
end

function Puck.originOrb_update(basefunc, orb, dt)
  if orb.birthtick == ed.engine.ticks then
    return
  end
  if orb.isWait then
    orb.waitTime = orb.waitTime + dt
    if orb.waitTime >= Puck.PuckorbOutDelay then
      orb.isWait = false
      if orb.nextX then
        orb.position[1] = orb.nextX
      end
      if orb.originY then
        orb.position[2] = orb.originY
      end
      orb.customScale = orb.customScale * Puck.PuckorbOutShrink
      if ed.run_with_scene and orb.actor then
        local node = orb.actor.node
        if node then
          CCNode.setScale(node, orb.customScale)
        end
      end
    end
    return
  end
  basefunc(orb, dt)
  if not orb.terminated and orb.outTimes >= Puck.PuckorbOutTimes - 1 then
    local isHit = orb:collideCheck(orb.caster)
    if isHit then
      orb:terminate()
      local skillatk3 = orb.caster.skills.Puck_atk3
      orb.caster:takeHeal(orb.caster.attribs.HP * skillatk3.evo_rank3["Script Arg1"] / 100, "hp", orb.caster)
      if ed.run_with_scene and orb.caster.actor then
        orb.caster.actor:addEffect("eff_impact_heal.cha", 0)
      end
    end
  end
end

function Puck.skillatk3a_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local info = skill.info
  local skillult = caster.skills.Puck_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    skill.skillultevodmg = power * skillult.evo_rank3["Script Arg1"] / 100
  end
  return power, coeff
end

function Puck.skillatk3a_takeEffectOn(basefunc, skill, target, source)
  local mppower = skill.info["Script Arg2"]
  local ret, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  local skillult = caster.skills.Puck_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 and ret then
    target:takeDamage(skill.skillultevodmg, "Holy", "hp", caster)
  end
  return ret, dmg
end

function Puck.hero_update(basefunc, self, dt)
  if self.atk4_timer == nil then
    self.atk4_timer = 0
  end
  self.atk4_timer = self.atk4_timer - dt
  basefunc(self, dt)
end

function Puck.getLostHPAfterImmunity(basefunc, self, damage, immunity)
  local skillatk4 = self.skills.Puck_atk4
  if skillatk4 then
    local uplimit = skillatk4.info["Script Arg2"]
    if self.atk4_timer <= 0 and uplimit then
      self.atk4_timer = skillatk4.info["Script Arg3"]
      if (self.currentActionStage == 1 or self.currentActionStage == 7 or self.currentActionStage == 9) and ed.run_with_scene then
        local effect_moon = "eff_point_Puck_atk4.cha"
        local casterorigin = self.position
        ed.scene:playEffectOnScene(effect_moon, casterorigin, nil, nil, 1)
      end
      if self.currentActionStage == 2 or self.currentActionStage == 8 or self.currentActionStage == 10 then
        if ed.run_with_scene then
          local effect_moon = "eff_point_Puck_atk4.cha"
          local casterorigin = self.position
          ed.scene:playEffectOnScene(effect_moon, casterorigin, nil, nil, 1)
        end
        local skillatk2a = self.skills.Puck_atk2a
        if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
          self.isskillatk4 = true
          skillatk2a:takeEffectAt(self.position, self)
        end
      end
      if skillatk4.evo_rank and 1 <= skillatk4.evo_rank then
        uplimit = uplimit + skillatk4.evo_rank1["Script Arg1"]
      end
      if skillatk4.evo_rank and 2 <= skillatk4.evo_rank then
        local bid = Puck.atk4inv
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = self:addBuff(binfo, self)
      end
      local mpheal = skillatk4.info["Script Arg4"]
      self:takeHeal(mpheal, "mp", self)
      if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(15) and self.camp == 1 then
        local charmEffect = ed.engine.rogueSkillMgr:getCharm(15)
        if charmEffect.level == 3 then
          self:takeHeal(self.attribs.HP * charmEffect.info["Script Arg4"] / 100, "hp", self)
        end
      end
      local dmg = damage - uplimit
      if dmg <= 0 then
        return 0
      else
        return dmg
      end
    end
  end
  return basefunc(self, damage, immunity)
end

function Puck.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, Puck.reset)
  if ed.run_with_scene and not ed.IsMultiArena() then
    ed.getSpriteFrame("UI/alpha/1080P/battle_bg/bbg_puck_dream1.jpg")
  end
  if Puck.fashion_id_2 and Puck.fashion_id_2 == hero.fashion_id and ed.run_with_scene and not ed.IsMultiArena() then
    ed.getSpriteFrame("UI/alpha/1080P/battle_bg/bbg_puck_dream2.jpg")
  end
  local skillult = hero.skills.Puck_ult
  local skillatk = hero.skills.Puck_atk
  local skillatk2 = hero.skills.Puck_atk2
  local skillatk3 = hero.skills.Puck_atk3
  local skillatk2a = hero.skills.Puck_atk2a
  local skillatk2b = hero.skills.Puck_atk2b
  local skillatk3a = hero.skills.Puck_atk3a
  local skillatk4 = hero.skills.Puck_atk4
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
    skillult.start = override(skillult.start, Puck.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Puck.skillult_onAttackFrame)
    skillult.interrupt = override(skillult.interrupt, Puck.skillult_interrupt)
    skillult.finish = override(skillult.finish, Puck.skillult_finish)
  end
  if skillatk then
    if Puck.fashion_id_1 and Puck.fashion_id_1 == hero.fashion_id then
      local originfo1 = skillatk.info
      skillatk.info = ed.wraptable(originfo1, {
        ["Tile Art"] = "eff_tile_Puck_fashion_1_atk.cha",
        ["Impact Effect"] = "eff_impact_Puck_fashion_1_atk.cha"
      })
    end
    if Puck.fashion_id_2 and Puck.fashion_id_2 == hero.fashion_id then
      local originfo1 = skillatk.info
      skillatk.info = ed.wraptable(originfo1, {
        ["Tile Art"] = "eff_tile_Puck_fashion_2_atk.cha",
        ["Impact Effect"] = "eff_impact_Puck_fashion_2_atk.cha"
      })
    end
  end
  if skillatk2a then
    if skillatk2 then
      if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
        skillatk2a.info = ed.wraptable(skillatk2a.info, {
          ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
        skillatk2a.info = ed.wraptable(skillatk2a.info, {
          ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
        skillatk2a.info = ed.wraptable(skillatk2a.info, {
          ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
        })
      end
      if Puck.fashion_id_1 and Puck.fashion_id_1 == hero.fashion_id then
        local originfo1 = skillatk2.info
        skillatk2.info = ed.wraptable(originfo1, {
          ["Point Effect"] = "eff_point_Puck_fashion_1_atk2_1.cha"
        })
      end
      if Puck.fashion_id_2 and Puck.fashion_id_2 == hero.fashion_id then
        local originfo1 = skillatk2.info
        skillatk2.info = ed.wraptable(originfo1, {
          ["Point Effect"] = "eff_point_Puck_fashion_2_atk2_1.cha"
        })
      end
    end
    skillatk2a.power = override(skillatk2a.power, Puck.skillatk2a_power)
    skillatk2a.start = override(skillatk2a.start, Puck.skillatk2a_start)
    skillatk2a.takeEffectAt = override(skillatk2a.takeEffectAt, Puck.skillatk2a_takeEffectAt)
    skillatk2a.takeEffectOn = override(skillatk2a.takeEffectOn, Puck.skillatk2a_takeEffectOn)
    skillatk2a.onAttackFrame = override(skillatk2a.onAttackFrame, Puck.skillatk2a_onAttackFrame)
    if Puck.fashion_id_1 and Puck.fashion_id_1 == hero.fashion_id then
      local originfo1 = skillatk2a.info
      skillatk2a.info = ed.wraptable(originfo1, {
        ["Point Effect"] = "eff_point_Puck_fashion_1_atk2_2.cha"
      })
    end
  end
  if skillatk2b then
    skillatk2b.start = override(skillatk2b.start, Puck.skillatk2b_start)
    skillatk2b.takeEffectAt = override(skillatk2b.takeEffectAt, Puck.skillatk2b_takeEffectAt)
  end
  if skillatk3a then
    if skillatk3 then
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        skillatk3a.info = ed.wraptable(skillatk3a.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        skillatk3a.info = ed.wraptable(skillatk3a.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        skillatk3a.createProjectile = override(skillatk3a.createProjectile, Puck.skillatk3a_createProjectile)
      end
      if Puck.fashion_id_1 and Puck.fashion_id_1 == hero.fashion_id then
        local originfo1 = skillatk3.info
        skillatk3.info = ed.wraptable(originfo1, {
          ["Tile Art"] = "eff_tile_Puck_fashion_1_atk3_1.cha"
        })
      end
      if Puck.fashion_id_2 and Puck.fashion_id_2 == hero.fashion_id then
        local originfo1 = skillatk3.info
        skillatk3.info = ed.wraptable(originfo1, {
          ["Tile Art"] = "eff_tile_Puck_fashion_2_atk3_1.cha"
        })
      end
    end
    skillatk3a.power = override(skillatk3a.power, Puck.skillatk3a_power)
    skillatk3a.takeEffectOn = override(skillatk3a.takeEffectOn, Puck.skillatk3a_takeEffectOn)
    if Puck.fashion_id_1 and Puck.fashion_id_1 == hero.fashion_id then
      local originfo1 = skillatk3a.info
      skillatk3a.info = ed.wraptable(originfo1, {
        ["Tile Art"] = "eff_tile_Puck_fashion_1_atk3_2.cha"
      })
    end
    if Puck.fashion_id_2 and Puck.fashion_id_2 == hero.fashion_id then
      local originfo1 = skillatk3a.info
      skillatk3a.info = ed.wraptable(originfo1, {
        ["Tile Art"] = "eff_tile_Puck_fashion_2_atk3_2.cha"
      })
    end
  end
  if skillatk4 then
    hero.update = override(hero.update, Puck.hero_update)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, Puck.getLostHPAfterImmunity)
  end
  return hero
end

return Puck.init_hero
