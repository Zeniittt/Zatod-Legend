module("ed.battlehero", package.seeall)
local ed = ed
Kael = {}
Kael.KaelSkillElement = {
  [535] = {
    1,
    1,
    1
  },
  [536] = {
    3,
    0,
    0
  },
  [537] = {
    2,
    1,
    0
  },
  [538] = {
    2,
    0,
    1
  },
  [539] = {
    0,
    3,
    0
  },
  [5310] = {
    1,
    2,
    0
  },
  [5311] = {
    0,
    2,
    1
  },
  [5312] = {
    0,
    0,
    3
  },
  [5313] = {
    0,
    1,
    2
  },
  [5314] = {
    1,
    0,
    2
  }
}
ed.KaelSkillElement = Kael.KaelSkillElement
Kael.globalBallIdx = 0
Kael.epsilon = ed.epsilon
Kael.ballKeywords = {
  ice = 1,
  fire = 1,
  lightning = 1
}
Kael.ballName = {
  [1] = "ice",
  [2] = "fire",
  [3] = "lightning"
}
Kael.ballKeywords2 = {
  "ice",
  "fire",
  "lightning"
}
Kael.fashion_id_1 = 531
Kael.trigger_distance = 70
Kael.trigger_distance_evo = 50

function Kael.deliverBall(kael, deliverer, t, lifetime, isManual, skill, fromLaunchPoint)
  Kael.globalBallIdx = Kael.globalBallIdx + 1
  local idx = Kael.globalBallIdx
  local dsIdx = isManual and ed.engine:getManualDeliveredEmptySlot(deliverer.position[1]) or ed.engine:getDeliveredEmptySlot(deliverer.position[1])
  local duration = lifetime or 7
  kael.deliveredBalls[idx] = {
    balltype = t,
    duration = duration,
    idx = idx,
    deliveredSlotIdx = dsIdx,
    deliverer = kael,
    autoPick = 0.6,
    autoGet = 0.25,
    startAutoGet = false,
    tapped = false,
    myslotidx = 0
  }
  ed.engine.usedDeliveredBallSlots[dsIdx] = true
  if ed.run_with_scene and kael.displayBall then
    local b = ed.BallCreate(deliverer, t, idx, dsIdx, duration, skill, fromLaunchPoint)
    b.deliverer = kael
    table.insert(ed.sceneui.ui_list, b)
    ed.sceneui.ui_layer:addChild(b.node, 100)
  end
end

function Kael.deliverRandBall(kael, deliverer, number, lifetime, isManual, skill, fromLaunchPoint)
  local number = number or 1
  for i = 1, number do
    local k = math.floor(ed.rand() * 3 + 1)
    Kael.deliverBall(kael, deliverer, Kael.ballName[k], lifetime, isManual, skill, fromLaunchPoint)
  end
end

function Kael.showBall(kael, deliverer, skill, eventIdx)
  if not kael:isAlive() or deliverer == kael then
    return
  end
  if skill == deliverer.basic_skill then
    return
  end
  local skillult = kael.skills.Kael_ult
  local p = skillult.info["Script Arg3"] / 100
  local balltime = skillult.info["Script Arg2"]
  local t = deliverer.info.Element
  if not t or not Kael.ballKeywords[t] then
    return
  end
  if p > ed.rand() then
    Kael.deliverBall(kael, deliverer, t, balltime)
  end
end

function Kael.setHP(basefunc, unit, hp, reason)
  local kael = unit
  local hpchange = basefunc(unit, hp, reason)
  local count = 1
  for i, skillinfo in ipairs(kael.passive_skill_list) do
    if skillinfo["Skill Name"] == "Kael_ice" then
      count = i
    end
  end
  local skillice = kael.passive_skill_list[count]
  if hpchange < 0 and 0 < unit.hp and skillice.evo_rank and skillice.evo_rank >= 3 then
    local skillice2lightning = kael.skills.Kael_ice2lightning
    local hpp = skillice.evo_rank3["Script Arg1"] / 100
    local hpnow = kael.hp / kael.attribs.HP
    if hpp >= hpnow and kael.skilliceEvo3Count == 0 then
      kael.skilliceEvo3Count = 1
      skillice2lightning:takeEffectOn(kael, kael)
    end
  end
end

function Kael.update(basefunc, kael, dt)
  for k, v in pairs(kael.deliveredBalls) do
    v.duration = v.duration - dt
    if v.duration < Kael.epsilon and not v.startAutoGet then
      if ed.run_with_scene then
        ed.sceneui:removeBall(v.idx)
      end
      kael.deliveredBalls[v.idx] = nil
      ed.engine.usedDeliveredBallSlots[v.deliveredSlotIdx] = false
    end
    if (kael.aiMode or kael.auto_combat) and v.autoPick > Kael.epsilon then
      v.autoPick = v.autoPick - dt
    end
    if v.startAutoGet and v.autoGet > Kael.epsilon then
      v.autoGet = v.autoGet - dt
      if v.autoGet < Kael.epsilon then
        ed.engine.usedDeliveredBallSlots[v.deliveredSlotIdx] = false
        kael:addEnergyBall(v.idx, v.balltype, v.myslotidx)
      end
    end
  end
  kael.energy_ball_manager:update(dt)
  basefunc(kael, dt)
end

function Kael:addEnergyBall(idx, balltype, myslotidx)
  if self.deliveredBalls[idx] then
    self.deliveredBalls[idx] = nil
    self.energy_ball_manager:addEnergyBall(balltype, myslotidx)
    local skillult = self.skills.Kael_ult
    if skillult.evo_rank and skillult.evo_rank >= 1 and balltype == "ice" then
      self:takeHeal(skillult.evo_rank1["Script Arg1"] / 100 * self.attribs.HP, "hp", self)
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 and balltype == "lightning" then
      self:takeHeal(skillult.evo_rank2["Script Arg1"], "mp", self)
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 and balltype == "fire" then
      local bid = 10005311
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, self, self)
      self:addBuff(buff, self)
    end
  end
end

function Kael:tapBall(ext)
  local idx = ext[1]
  local myslotidx = ext[2]
  if not self.deliveredBalls[idx] then
    self.energy_ball_manager.slots[myslotidx].occupied = false
    return
  end
  self.deliveredBalls[idx].startAutoGet = true
  self.deliveredBalls[idx].myslotidx = myslotidx
  if ed.run_with_scene and self.displayBall and ed.sceneui.ballSlots[idx] then
    ed.sceneui.ballSlots[idx]:onTapped2(myslotidx)
  end
end

function Kael.castSkill(basefunc, kael, skill, target)
  if kael.current_skill and not kael.current_skill.info.Manual then
    kael.current_skill:interrupt()
  end
  basefunc(kael, skill, target)
  local sid = skill.info["Skill Group ID"]
  if Kael.KaelSkillElement[sid] then
    kael.energy_ball_manager:consumeEnergyBall()
  end
end

function Kael.autoTapBall(kael)
  if not kael.aiMode and not kael.auto_combat then
    return
  end
  for k, v in pairs(kael.deliveredBalls) do
    if v.autoPick < Kael.epsilon and not v.tapped then
      local s, myslotidx = kael.energy_ball_manager:getEmptySlot(true)
      if s then
        s.occupied = true
        v.tapped = true
        if kael.aiMode then
          kael:tapBall({
            v.idx,
            myslotidx
          })
        elseif kael.auto_combat then
          ed.engine:manualTapBall(v.deliverer, v.idx, myslotidx, true)
        end
      end
    end
  end
end

function Kael.SpecialCheckEnableAi(kael)
  if kael.energy_ball_manager:isSlotsAvailable() and not ed.engine:arenaMode() then
    return true
  end
  return false
end

function Kael.reset(basefunc, kael)
  basefunc(kael)
  if kael.name == "Kael" then
    kael.deliveredBalls = {}
    kael.energy_ball_manager:clear()
    kael.skilliceEvo3Count = 0
    kael.oldfireman_Kael = {}
  end
  Kael.globalBallIdx = 0
end

function Kael.die(basefunc, kael, killer)
  basefunc(kael, killer)
  for _, fireman in pairs(kael.oldfireman_Kael) do
    if fireman and fireman:isAlive() then
      fireman:die()
    end
  end
  if ed.run_with_scene and kael.name == "Kael" then
    for k, v in pairs(kael.deliveredBalls) do
      ed.sceneui:removeBall(v.idx)
    end
    if kael.displayBall then
      ed.sceneui:removeBallBar()
    end
  end
end

function Kael.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local balltime = skill.info["Script Arg2"]
  if skill.attack_counter <= 6 then
    skill.attack_counter = skill.attack_counter + 1
    Kael.deliverRandBall(caster, caster, 1, balltime, true, skill, true)
  else
    Kael.deliverRandBall(caster, caster, 1, balltime, true, skill, true)
    basefunc(skill)
  end
end

function Kael.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local ret, reason = basefunc(skill, target)
  if not ret and reason == "untargetable" then
    local Kael_ice2lightning = false
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 10005305 then
        Kael_ice2lightning = true
        break
      end
    end
    if Kael_ice2lightning then
      ret = true
    end
  end
  return ret, reason
end

function Kael.skillult_finish(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(14) and hero.camp == 1 then
    local bid = 64000014
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.attack_timer = 0
    buff.CharmLevel = 1
    buff.update = override(buff.update, Kael.Charm14buff_update)
    hero:addBuff(buff, hero)
  end
end

function Kael.Charm14buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  local charmEffect = ed.engine.rogueSkillMgr:getCharm(14)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + buff.CharmLevel
    local skillall = hero.skills.Kael_all
    local skillfire2lightning = hero.skills.Kael_fire2lightning
    local skilllightning2ice = hero.skills.Kael_lightning2ice
    if buff.CharmLevel == 1 then
      local target = skilllightning2ice:selectTarget()
      if target and target.camp ~= hero.camp then
        skilllightning2ice.target = target
        local projectile = skilllightning2ice:createProjectile()
        ed.engine:addProjectile(projectile)
      end
    end
    if buff.CharmLevel == 2 then
      local target = skillfire2lightning:selectTarget()
      if target and target.camp ~= hero.camp then
        skillfire2lightning.target = target
        local projectile = skillfire2lightning:createProjectile()
        ed.engine:addProjectile(projectile)
      end
    end
    if buff.CharmLevel == 3 then
      local target = skillall:selectTarget()
      if target and target.camp ~= hero.camp then
        skillall.target = target
        local projectile = skillall:createProjectile()
        ed.engine:addProjectile(projectile)
      end
    end
    buff.CharmLevel = buff.CharmLevel + 1
  end
  if buff.CharmLevel > charmEffect.level then
    buff.timer = -1
  end
  buff.attack_timer = timer
end

function Kael.skillall_createBuff(basefunc, skill, target)
  return basefunc(skill, target)
end

function Kael.skillall_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
end

function Kael.skillice3buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local damage = basefunc(buff, damage, damage_type)
  local target = buff.owner
  local caster = buff.caster
  if not buff.owner.config.is_boss and 0 < damage and not target.buff_effects.invulnerable and not target.buff_effects.uncontrollable and not transferred and buff.ice3cd then
    buff.ice3cd = false
    local bid = 10005303
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
    local skillice3 = caster.skills.Kael_ice3
    local ice3dmg = skillice3.info["Script Arg2"]
    local count = 1
    for i, skillinfo in ipairs(caster.passive_skill_list) do
      if skillinfo["Skill Name"] == "Kael_ice" then
        count = i
      end
    end
    local skillice = caster.passive_skill_list[count]
    if skillice.evo_rank and 1 <= skillice.evo_rank then
      ice3dmg = ice3dmg + skillice.evo_rank1["Script Arg1"] * caster.attribs.AP
    end
    target:takeDamage(ice3dmg, "AP", "hp", caster, 1, 1, true)
  end
  return damage
end

function Kael.skillice3buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local timer = buff.attack_timer
  if not buff.ice3cd then
    timer = timer - dt
  end
  while timer <= 0 do
    timer = timer + 0.5
    buff.ice3cd = true
  end
  buff.attack_timer = timer
end

function Kael.skillice3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  return projectile
end

function Kael.skillice3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = 0
  buff.ice3cd = true
  buff.onDamaged = override(buff.onDamaged, Kael.skillice3buff_onDamaged)
  buff.update = override(buff.update, Kael.skillice3buff_update)
  if Kael.fashion_id_1 and Kael.fashion_id_1 == buff.caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_Kael_fashion_1_atk6.cha")
  end
  return buff
end

function Kael.skillice2fire_takeEffectAt(basefunc, skill, location)
  local caster = skill.caster
  local origin = {
    location[1],
    0
  }
  skill.Kael_icewall_origin = origin
  basefunc(skill, origin)
end

function Kael.skillice2fire_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  return buff
end

function Kael.skillice2lightning_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if Kael.fashion_id_1 and Kael.fashion_id_1 == buff.caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_Kael_fashion_1_atk9_1.cha")
    local bid2 = 10005313
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, caster, caster)
    caster:addBuff(buff2, caster)
  end
  return buff
end

function Kael.skillfire3_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  if not skill.affectnum then
    skill.affectnum = 1
  end
  local caster = skill.caster
  return power / skill.affectnum, coefficient
end

function Kael.skillfire3_takeEffectAt(basefunc, skill, location, source)
  local info = skill.info
  local direction = skill.caster.direction
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  local affectlist = {}
  local shape = info["AOE Shape"]
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.buff_effects.invulnerable then
    else
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if skill.testPointInShape(p2, shape, arg1, arg2) then
        table.insert(affectlist, unit)
      end
    end
  end
  skill.affectnum = #affectlist or 1
  basefunc(skill, location, source)
end

function Kael.skillfire2ice_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local proto = {
    _tid = 146,
    _level = skill.level,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    estimate_skill = true,
    hp_mod = caster.config.hp_mod and caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  for _, fireman in pairs(caster.oldfireman_Kael) do
    if fireman and fireman:isAlive() then
      fireman:die()
    end
  end
  local count = 3
  for i, skillinfo in ipairs(caster.passive_skill_list) do
    if skillinfo["Skill Name"] == "Kael_fire" then
      count = i
    end
  end
  local skillfire = caster.passive_skill_list[count]
  local fireman = ed.UnitCreate(proto, caster.camp, config)
  local location = {
    caster.position[1] + 50 * caster.direction,
    caster.position[2]
  }
  if skillfire.evo_rank and 2 <= skillfire.evo_rank then
    location = {
      caster.position[1] + 50 * caster.direction,
      caster.position[2] - 30
    }
  end
  local skillatk = fireman.skills.FireElement_atk
  if skillfire.evo_rank and 1 <= skillfire.evo_rank then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Kael.firemanskillatk_takeEffectOn)
  end
  fireman.mDuration_fireman = 15
  fireman.update = override(fireman.update, Kael.fireman_update)
  fireman.direction = caster.direction
  ed.engine:summonUnit(fireman, location, caster)
  table.insert(caster.oldfireman_Kael, fireman)
  if Kael.fashion_id_1 and Kael.fashion_id_1 == caster.fashion_id then
    fireman:pushPuppet("FireElement_Kael_fashion_1.cha")
  end
  local firemanattribs = skill.info["Script Arg2"] / 100
  local AttriBinfo = ed.lookupDataTable("Buff", nil, 10005306)
  Kael.changeBuffInfo(AttriBinfo, firemanattribs, fireman)
  local buff = fireman:addBuff(AttriBinfo, caster)
  fireman:takeHeal(fireman.attribs.HP, "hp")
  if skillfire.evo_rank and 2 <= skillfire.evo_rank then
    local fireman2 = ed.UnitCreate(proto, caster.camp, config)
    local location = {
      caster.position[1] + 50 * caster.direction,
      caster.position[2] + 30
    }
    local skillatk = fireman2.skills.FireElement_atk
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Kael.firemanskillatk_takeEffectOn)
    fireman2.mDuration_fireman = 15
    fireman2.update = override(fireman2.update, Kael.fireman_update)
    fireman2.direction = caster.direction
    ed.engine:summonUnit(fireman2, location, caster)
    table.insert(caster.oldfireman_Kael, fireman2)
    if Kael.fashion_id_1 and Kael.fashion_id_1 == caster.fashion_id then
      fireman2:pushPuppet("FireElement_Kael_fashion_1.cha")
    end
    local firemanattribs = skill.info["Script Arg2"] / 100
    local AttriBinfo = ed.lookupDataTable("Buff", nil, 10005306)
    Kael.changeBuffInfo(AttriBinfo, firemanattribs, fireman2)
    local buff = fireman2:addBuff(AttriBinfo, caster)
    fireman2:takeHeal(fireman2.attribs.HP, "hp")
  end
end

function Kael.fireman_update(basefunc, unit, dt)
  unit.mDuration_fireman = unit.mDuration_fireman - dt
  if unit.mDuration_fireman <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function Kael.firemanskillatk_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local summoner = skill.caster.config.summoner
  local caster = skill.caster
  if isHit and not target.buff_effects.invulnerable and not target.buff_effects.uncontrollable then
    local bid = 10005307
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function Kael.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function Kael.skillfire2lightning_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local tileVx = 400
  local tileVz = -600
  local projectilex = caster.position[1]
  local distance = caster.position[1] - skill.target.position[1]
  if distance < 0 then
    distance = -distance
  end
  if 200 < distance then
    projectilex = skill.target.position[1] - caster.direction * 200
    tileVx = 200
  else
    tileVx = distance
  end
  projectile.height = 500
  projectile.velocity = {
    tileVx * caster.direction,
    0
  }
  skill.meteorDirection = caster.direction
  projectile.zSpeed = tileVz
  projectile.position = {
    projectilex,
    caster.position[2]
  }
  return projectile
end

function Kael.projectile2_update(basefunc, projectile2, dt)
  local skill = projectile2.skill
  local caster = skill.caster
  local info = projectile2.skill.info
  local distance = projectile2.tile_distance - 160 * dt
  local caster = skill.caster
  while distance <= 0 do
    local location = {
      projectile2.position[1] - distance,
      projectile2.position[2]
    }
    skill:takeEffectAt(location, projectile2)
    local count = 3
    for i, skillinfo in ipairs(caster.passive_skill_list) do
      if skillinfo["Skill Name"] == "Kael_fire" then
        count = i
      end
    end
    local skillfire = caster.passive_skill_list[count]
    if skillfire.evo_rank and 3 <= skillfire.evo_rank then
      distance = distance + Kael.trigger_distance_evo
    else
      distance = distance + Kael.trigger_distance
    end
  end
  projectile2.tile_distance = distance
  basefunc(projectile2, dt)
  local long_max = 310
  if long_max <= projectile2.distance then
    if not projectile2.fadeout_timer then
      projectile2.velocity = {0, 0}
      projectile2.fadeout_timer = 0.5
    else
      projectile2.fadeout_timer = projectile2.fadeout_timer - dt
    end
    if 0 > projectile2.fadeout_timer then
      projectile2:terminate()
    end
  end
  return
end

function Kael.projectile2_terminate(basefunc, projectile)
  basefunc(projectile)
  local caster = projectile.caster
end

function Kael.skillfire2lightning_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  local caster = skill.caster
  if source and source.tile2 then
    basefunc(skill, location, source)
  else
    local pointEffect = "eff_point_Kael_atk2_2.cha"
    local tileArt = "eff_tile_Kael_atk2.cha"
    if Kael.fashion_id_1 and Kael.fashion_id_1 == caster.fashion_id then
      pointEffect = "eff_point_Kael_fashion_1_atk2_2.cha"
      tileArt = "eff_tile_Kael_fashion_1_atk2.cha"
    end
    skill.info = ed.wraptable(originfo, {
      ["Point Effect"] = pointEffect,
      ["Point Zorder"] = 1,
      ["Tile OTT Height"] = 50,
      ["Tile Art"] = tileArt
    })
    basefunc(skill, location, source)
    skill:selectTarget()
    local projectile2 = ed.ProjectileCreate(skill)
    projectile2.tile2 = true
    projectile2.update = override(projectile2.update, Kael.projectile2_update)
    projectile2.terminate = override(projectile2.terminate, Kael.projectile2_terminate)
    projectile2.height = 35
    projectile2.velocity = {
      160 * skill.meteorDirection,
      0
    }
    local count = 3
    for i, skillinfo in ipairs(caster.passive_skill_list) do
      if skillinfo["Skill Name"] == "Kael_fire" then
        count = i
      end
    end
    local skillfire = caster.passive_skill_list[count]
    if skillfire.evo_rank and 3 <= skillfire.evo_rank then
      projectile2.tile_distance = Kael.trigger_distance_evo
    else
      projectile2.tile_distance = Kael.trigger_distance
    end
    projectile2.position = {
      location[1],
      location[2]
    }
    ed.engine:addProjectile(projectile2)
    skill.info = originfo
  end
end

function Kael.skilllightning3_takeEffectOn(basefunc, skill, target, source)
  local succ = basefunc(skill, target)
  if succ then
    local power = skill.info["Script Arg2"]
    local targetMP = target.mp
    local d = power - targetMP
    local caster = skill.caster
    local count = 2
    for i, skillinfo in ipairs(caster.passive_skill_list) do
      if skillinfo["Skill Name"] == "Kael_lightning" then
        count = i
      end
    end
    local skilllightning = caster.passive_skill_list[count]
    if skilllightning.evo_rank and skilllightning.evo_rank >= 1 then
      power = power + skilllightning.evo_rank1["Script Arg1"]
    end
    target:takeDamage(power, "Holy", "mp", skill.caster)
  end
  return succ
end

function Kael.skilllightning3_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if skill.target then
      skill.magnetorigin = {
        skill.target.position[1],
        skill.target.position[2]
      }
    else
      skill.magnetorigin = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        skill.caster.position[2]
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_Kael_atk8.cha"
      if Kael.fashion_id_1 and Kael.fashion_id_1 == skill.caster.fashion_id then
        effect_name = "eff_point_Kael_fashion_1_atk8.cha"
      end
      ed.scene:playEffectOnScene(effect_name, skill.magnetorigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  else
    if skill.magnetorigin == nil then
      return
    end
    basefunc(skill, skill.magnetorigin, source)
  end
end

function Kael.swiftbuff_onRemoved(basefunc, buff)
  if buff.originfo then
    buff.owner.basic_skill.info = buff.originfo
  end
  basefunc(buff)
end

function Kael.skilllightning2fire_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner == caster then
    local targetBasicSkill = owner.basic_skill
    local originfo = targetBasicSkill.info
    buff.originfo = originfo
    targetBasicSkill.cd_remaining = 0
    targetBasicSkill.info = ed.wraptable(originfo, {CD = 1})
    buff.onRemoved = override(buff.onRemoved, Kael.swiftbuff_onRemoved)
  end
  if Kael.fashion_id_1 and Kael.fashion_id_1 == buff.caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_Kael_fashion_1_atk11.cha")
  end
  return buff
end

function Kael.skilllightning2fire_selectTarget(basefunc, skill, default)
  local max = -math.huge
  local caster = skill.caster
  local chosen = caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  local enchantedbyself = caster.buff_effects.enchantedbyself
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    elseif enchantedbyself and unit == caster then
    elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.building then
    else
      local havebuff = false
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == 10005309 then
          havebuff = true
          break
        end
      end
      if havebuff then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = unit.attribs.AD
          if max < v then
            max = v
            chosen = unit
          end
        end
      end
    end
  end
  skill.target = chosen
  return chosen
end

function Kael.skilllightning2ice_takeEffectOn(basefunc, skill, target, source)
  local succ, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  local count = 2
  for i, skillinfo in ipairs(caster.passive_skill_list) do
    if skillinfo["Skill Name"] == "Kael_lightning" then
      count = i
    end
  end
  local skilllightning = caster.passive_skill_list[count]
  if skilllightning.evo_rank and skilllightning.evo_rank >= 3 then
    local list = target.buff_list
    local buff_list = {}
    local myenemycamp = caster.foecamp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp == myenemycamp) and buff.info.Dispel == "YES" then
        buff_list[#buff_list + 1] = buff
      end
    end
    for i = 1, #buff_list do
      target:removeBuff(buff_list[i])
    end
  end
  return succ, dmg, Crit, lfs_amount
end

function Kael.skillatk_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local skillult = caster.skills.Kael_ult
  local p = skillult.info["Script Arg3"] / 100
  local id = 1
  if p > ed.rand() then
    id = 2
  end
  basefunc(skill, id)
end

function Kael.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Kael.skillatk_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.Kael_ult
  local balltime = skillult.info["Script Arg2"]
  if skill.current_phase_idx == 2 then
    Kael.deliverRandBall(caster, caster, 1, balltime, false, skill, true)
  end
  basefunc(skill)
end

function Kael.hero_true_init(hero)
  local skillult = hero.skills.Kael_ult
  local count1 = 1
  local count2 = 2
  local count3 = 3
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "Kael_ice" then
      count1 = i
    end
  end
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "Kael_lightning" then
      count2 = i
    end
  end
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "Kael_fire" then
      count3 = i
    end
  end
  local skillice = hero.passive_skill_list[count1]
  local skilllightning = hero.passive_skill_list[count2]
  local skillfire = hero.passive_skill_list[count3]
  if skillice then
    local aname = skillice["Passive Attr"]
    local num = skillice["Script Arg1"]
    local oriattribs = hero.attribs[aname]
    skillice["Basic Num"] = num / 100 * oriattribs
    hero:rebuild()
  end
  if skilllightning then
    local aname = skilllightning["Passive Attr"]
    local num = skilllightning["Script Arg1"]
    local oriattribs = hero.attribs[aname]
    skilllightning["Basic Num"] = num / 100 * oriattribs
    hero:rebuild()
  end
  if skillfire then
    local aname = skillfire["Passive Attr"]
    local num = skillfire["Script Arg1"]
    local oriattribs = hero.attribs[aname]
    skillfire["Basic Num"] = num / 100 * oriattribs
    hero:rebuild()
  end
  local skillall = hero.skills.Kael_all
  local skillice3 = hero.skills.Kael_ice3
  local skillice2fire = hero.skills.Kael_ice2fire
  local skillice2lightning = hero.skills.Kael_ice2lightning
  local skillfire3 = hero.skills.Kael_fire3
  local skillfire2ice = hero.skills.Kael_fire2ice
  local skillfire2lightning = hero.skills.Kael_fire2lightning
  local skilllightning3 = hero.skills.Kael_lightning3
  local skilllightning2ice = hero.skills.Kael_lightning2ice
  local skilllightning2fire = hero.skills.Kael_lightning2fire
  local skillatk = hero.skills.Kael_atk
  hero:preloadEffect("eff_point_Kael_atk8.cha")
  hero:preloadEffect("eff_point_Kael_atk2_2.cha")
  hero:preloadEffect("eff_tile_Kael_atk2.cha")
  hero:preloadEffect("eff_point_Kael_fashion_1_atk8.cha")
  hero:preloadEffect("eff_point_Kael_fashion_1_atk2_2.cha")
  hero:preloadEffect("eff_tile_Kael_fashion_1_atk2.cha")
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Kael.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Kael.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, Kael.skillult_finish)
  end
  if skillatk then
    skillatk.startPhase = override(skillatk.startPhase, Kael.skillatk_startPhase)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Kael.skillatk_onPhaseFinished)
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Kael.skillatk_onAttackFrame)
    if Kael.fashion_id_1 and Kael.fashion_id_1 == hero.fashion_id then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Tile Art"] = "eff_tile_Kael_fashion_1_atk.cha"
      })
    end
  end
  if skillall then
    skillall.createBuff = override(skillall.createBuff, Kael.skillall_createBuff)
    skillall.takeEffectOn = override(skillall.takeEffectOn, Kael.skillall_takeEffectOn)
    if Kael.fashion_id_1 and Kael.fashion_id_1 == hero.fashion_id then
      skillall.info = ed.wraptable(skillall.info, {
        ["Tile Art"] = "eff_tile_Kael_fashion_1_atk4.cha"
      })
    end
  end
  if skillice3 then
    if skillice.evo_rank and 1 <= skillice.evo_rank then
      skillice3.info = ed.wraptable(skillice3.info, {
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 100
      })
    end
    skillice3.createBuff = override(skillice3.createBuff, Kael.skillice3_createBuff)
    skillice3.createProjectile = override(skillice3.createProjectile, Kael.skillice3_createProjectile)
  end
  if skillice2fire then
    skillice2fire.takeEffectAt = override(skillice2fire.takeEffectAt, Kael.skillice2fire_takeEffectAt)
    skillice2fire.createBuff = override(skillice2fire.createBuff, Kael.skillice2fire_createBuff)
    if skillice and skillice.evo_rank and 2 <= skillice.evo_rank then
      skillice2fire.info = ed.wraptable(skillice2fire.info, {
        ["Plus Ratio"] = skillice.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillice2lightning then
    skillice2lightning.createBuff = override(skillice2lightning.createBuff, Kael.skillice2lightning_createBuff)
  end
  if skillfire3 then
    skillfire3.takeEffectAt = override(skillfire3.takeEffectAt, Kael.skillfire3_takeEffectAt)
    skillfire3.power = override(skillfire3.power, Kael.skillfire3_power)
  end
  if skillfire2ice then
    skillfire2ice.takeEffectOn = override(skillfire2ice.takeEffectOn, Kael.skillfire2ice_takeEffectOn)
  end
  if skillfire2lightning then
    skillfire2lightning.createProjectile = override(skillfire2lightning.createProjectile, Kael.skillfire2lightning_createProjectile)
    skillfire2lightning.takeEffectAt = override(skillfire2lightning.takeEffectAt, Kael.skillfire2lightning_takeEffectAt)
    if Kael.fashion_id_1 and Kael.fashion_id_1 == hero.fashion_id then
      skillfire2lightning.info = ed.wraptable(skillfire2lightning.info, {
        ["Tile Art"] = "eff_tile_Kael_fashion_1_atk2_2.cha"
      })
    end
  end
  if skilllightning3 then
    skilllightning3.takeEffectAt = override(skilllightning3.takeEffectAt, Kael.skilllightning3_takeEffectAt)
    skilllightning3.takeEffectOn = override(skilllightning3.takeEffectOn, Kael.skilllightning3_takeEffectOn)
  end
  if skilllightning2fire then
    skilllightning2fire.createBuff = override(skilllightning2fire.createBuff, Kael.skilllightning2fire_createBuff)
    skilllightning2fire.selectTarget = override(skilllightning2fire.selectTarget, Kael.skilllightning2fire_selectTarget)
  end
  if skilllightning2ice then
    skilllightning2ice.takeEffectOn = override(skilllightning2ice.takeEffectOn, Kael.skilllightning2ice_takeEffectOn)
    if skilllightning and skilllightning.evo_rank and 2 <= skilllightning.evo_rank then
      skilllightning2ice.info = ed.wraptable(skilllightning2ice.info, {
        ["Plus Ratio"] = skilllightning.evo_rank2["Script Arg1"]
      })
    end
    if Kael.fashion_id_1 and Kael.fashion_id_1 == hero.fashion_id then
      skilllightning2ice.info = ed.wraptable(skilllightning2ice.info, {
        ["Tile Art"] = "eff_tile_Kael_fashion_1_atk3.cha"
      })
    end
  end
  if hero.name == "Kael" then
    hero.die = override(hero.die, Kael.die)
    hero.update = override(hero.update, Kael.update)
    hero.setHP = override(hero.setHP, Kael.setHP)
    hero.castSkill = override(hero.castSkill, Kael.castSkill)
    hero.reset = override(hero.reset, Kael.reset)
    hero.showBall = Kael.showBall
    hero.skillConditon = Kael.KaelSkillElement
    hero.addEnergyBall = Kael.addEnergyBall
    hero.autoTapBall = Kael.autoTapBall
    hero.tapBall = Kael.tapBall
    hero.SpecialCheckEnableAi = Kael.SpecialCheckEnableAi
    hero.energy_ball_manager = ed.EnergyBallManagerCreate(hero)
    hero.deliveredBalls = {}
    hero.orderedIdx_Kael = {}
    hero.isKael = true
    hero.displayBall = false
    hero.aiMode = false
    hero.skilliceEvo3Count = 0
    hero.oldfireman_Kael = {}
    if ed.engine:arenaMode() then
      hero.aiMode = true
    end
    if hero.camp == ed.emCampEnemy and not battle_tick.getRealTimePvp() then
      hero.aiMode = true
    end
    if ed.engine.crevicedefend_mode then
      hero.aiMode = true
    end
    hero.auto_combat = false
    if hero.camp == ed.emCampPlayer then
      ed.engine.playerKaelHero = hero
    else
      ed.engine.enemyKaelHero = hero
    end
  end
  return hero
end

function Kael.init_hero(hero)
  Kael.hero_true_init(hero)
  return hero
end

return Kael.init_hero
