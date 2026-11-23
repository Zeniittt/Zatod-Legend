module("ed.battlehero", package.seeall)
local ed = ed
HeatBossKael = {}
HeatBossKael.HeatBossKaelSkillElement = {
  [38801] = {
    1,
    1,
    1
  },
  [38811] = {
    3,
    0,
    0
  },
  [38821] = {
    2,
    1,
    0
  },
  [38831] = {
    2,
    0,
    1
  },
  [38841] = {
    0,
    3,
    0
  },
  [38851] = {
    1,
    2,
    0
  },
  [38861] = {
    0,
    2,
    1
  },
  [38871] = {
    0,
    0,
    3
  },
  [38881] = {
    0,
    1,
    2
  },
  [38891] = {
    1,
    0,
    2
  }
}
ed.HeatBossKaelSkillElement = HeatBossKael.HeatBossKaelSkillElement
HeatBossKael.HeatBossKaelSkillShowEffect = {
  [38801] = "eff_buff_HeatBossKael_all.cha",
  [38811] = "eff_buff_HeatBossKael_ice3.cha",
  [38821] = "eff_buff_HeatBossKael_ice2fire.cha",
  [38831] = "eff_buff_HeatBossKael_ice2lightning.cha",
  [38841] = "eff_buff_HeatBossKael_fire3.cha",
  [38851] = "eff_buff_HeatBossKael_fire2ice.cha",
  [38861] = "eff_buff_HeatBossKael_fire2lightning.cha",
  [38871] = "eff_buff_HeatBossKael_lightning3.cha",
  [38881] = "eff_buff_HeatBossKael_lightning2fire.cha",
  [38891] = "eff_buff_HeatBossKael_lightning2ice.cha"
}
HeatBossKael.globalBallIdx = 0
HeatBossKael.epsilon = ed.epsilon
HeatBossKael.ballKeywords = {
  ice = 1,
  fire = 1,
  lightning = 1
}
HeatBossKael.ballName = {
  [1] = "ice",
  [2] = "fire",
  [3] = "lightning"
}
HeatBossKael.ballKeywords2 = {
  "ice",
  "fire",
  "lightning"
}
HeatBossKael.HeatBossKael_inawake_time = 15
HeatBossKael.HeatBossKael_shock_ice_rand = 0.4
HeatBossKael.HeatBossKael_frozen_ice_rand = 0.2
HeatBossKael.HeatBossKael_skyfire_powerup = 0.3
HeatBossKael.HeatBossKael_magnet_powerratio = 20
HeatBossKael.HeatBossKael_shock_APdown = -0.3
HeatBossKael.HeatBossKael_meteor_lightning = 0.75
HeatBossKael.HeatBossKael_swift_stun = 0.5
HeatBossKael.trigger_distance = 50

function HeatBossKael.selectPosition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable or unit.config.is_summoned then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      x = i
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 < maxcount then
    return x
  end
  if maxcount <= 0 then
    return false
  end
end

function HeatBossKael.deliverBall(kael, deliverer, t, lifetime, isManual, skill, fromLaunchPoint)
  HeatBossKael.globalBallIdx = HeatBossKael.globalBallIdx + 1
  local idx = HeatBossKael.globalBallIdx
  local dsIdx = isManual and ed.engine:getManualDeliveredEmptySlot(deliverer.position[1]) or ed.engine:getDeliveredEmptySlot(deliverer.position[1])
  local duration = lifetime or 6
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

function HeatBossKael.deliverRandBall(kael, deliverer, number, lifetime, isManual, skill, fromLaunchPoint)
  local number = number or 1
  for i = 1, number do
    local k = math.floor(ed.rand() * 3 + 1)
    HeatBossKael.deliverBall(kael, deliverer, HeatBossKael.ballName[k], lifetime, isManual, skill, fromLaunchPoint)
  end
end

function HeatBossKael.showBall(kael, deliverer, skill, eventIdx)
  if not kael:isAlive() then
    return
  end
  local t = "ice"
  if not t or not HeatBossKael.ballKeywords[t] then
    return
  end
  HeatBossKael.deliverBall(kael, deliverer, t)
end

function HeatBossKael.update(basefunc, kael, dt)
  kael.randomtime = kael.randomtime - dt
  kael.changetime = kael.changetime - dt
  kael.actskillcd = kael.actskillcd - dt
  kael.cantapcd = kael.cantapcd - dt
  if kael.changetimebuff == true then
    for i, tbuff in ipairs(kael.buff_list) do
      if tbuff.info.ID == 20050131 then
        kael.changetime = kael.changetime - 5
      end
      if tbuff.info.ID == 20050132 then
        kael.changetime = kael.changetime - 10
      end
      if tbuff.info.ID == 20050133 then
        kael.changetime = kael.changetime - 15
      end
      if tbuff.info.ID == 20050134 then
        kael.changetime = kael.changetime - 20
      end
      kael.changetimebuff = false
    end
  end
  if kael.cantapcd <= 0 then
    kael.cantap = true
  end
  if kael.randomtime <= 0 then
    kael.energy_ball_manager:consumeEnergyBall()
    for k, v in pairs(HeatBossKael.HeatBossKaelSkillElement) do
      local skill = kael.skills[k]
      skill.cd_remaining = 999
    end
    local skillatk = kael.skills.HeatBossKael_atk
    skillatk.cd_remaining = math.min(1.5, skillatk.cd_remaining)
    local randomresult = {
      0,
      0,
      0,
      0,
      0,
      0
    }
    kael.skillresult = {
      0,
      0,
      0
    }
    local list = {
      1,
      2,
      3,
      4,
      5,
      6
    }
    local newList = {}
    local value
    for i = 1, 3 do
      value = table.remove(list, math.floor(ed.rand() * #list + 1))
      table.insert(newList, value)
    end
    for i = 1, 6 do
      randomresult[i] = math.floor(ed.rand() * 3 + 1)
      if kael.cantap == true then
        HeatBossKael.deliverBall(kael, kael, HeatBossKael.ballName[randomresult[i]], 3, false, nil, true)
      end
    end
    for i = 1, #newList do
      local value = newList[i]
      if randomresult[value] == 1 then
        kael.skillresult[1] = kael.skillresult[1] + 1
        kael.icecount = kael.icecount + 1
      end
      if randomresult[value] == 2 then
        kael.skillresult[2] = kael.skillresult[2] + 1
        kael.firecount = kael.firecount + 1
      end
      if randomresult[value] == 3 then
        kael.skillresult[3] = kael.skillresult[3] + 1
        kael.lightningcount = kael.lightningcount + 1
      end
    end
    for k, v in pairs(HeatBossKael.HeatBossKaelSkillElement) do
      if v[1] == kael.skillresult[1] and v[2] == kael.skillresult[2] and v[3] == kael.skillresult[3] then
        kael.actskill = kael.skills[k]
        local showeffect = HeatBossKael.HeatBossKaelSkillShowEffect[k]
        local bid = 10038827
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, kael, kael)
        buff:setAttribute("Effect", showeffect)
        kael:addBuff(buff, kael)
        kael.actskill.cd_remaining = 3.5
        break
      end
    end
    kael.randomtime = 5
    kael.tapediceball = 0
    kael.tapedfireball = 0
    kael.tapedlightningball = 0
  end
  if kael.randomtime == 2 and kael.skillresult and kael.cantap == true then
    for i, v in ipairs(kael.energy_ball_manager.slots) do
      if kael.energy_ball_manager.slots[i].ballType == "ice" then
        kael.tapediceball = kael.tapediceball + 1
      end
      if kael.energy_ball_manager.slots[i].ballType == "fire" then
        kael.tapedfireball = kael.tapedfireball + 1
      end
      if kael.energy_ball_manager.slots[i].ballType == "lightning" then
        kael.tapedlightningball = kael.tapedlightningball + 1
      end
    end
    if kael.skillresult[1] == kael.tapediceball and kael.skillresult[2] == kael.tapedfireball and kael.skillresult[3] == kael.tapedlightningball then
      if 2 <= kael.tapediceball then
        local bid = 10038824
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, kael, kael)
        buff.onDamaged = override(buff.onDamaged, HeatBossKael.tapicebuff_onDamaged)
        kael:addBuff(buff, kael)
      elseif 2 <= kael.tapedfireball then
        local bid = 10038825
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, kael, kael)
        kael:addBuff(buff, kael)
      elseif 2 <= kael.tapedlightningball then
        kael:takeDamage(kael.attribs.HP * 0.1, "Holy", "hp", kael)
        if ed.run_with_scene then
          local effect_name = "eff_point_TitanLoong_atk2.cha"
          if effect_name then
            ed.scene:playEffectOnScene(effect_name, kael.position, nil, nil, 1)
          end
        end
      else
        local bid = 10038826
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, kael, kael)
        kael:addBuff(buff, kael)
        if ed.run_with_scene then
          local effect_name = "eff_impact_burst.cha"
          if effect_name then
            ed.scene:playEffectOnScene(effect_name, kael.position, nil, nil, 1)
          end
        end
        kael:hurt()
      end
      kael.icecount = kael.icecount - kael.tapediceball
      kael.firecount = kael.firecount - kael.tapedfireball
      kael.lightningcount = kael.lightningcount - kael.tapedlightningball
      kael.actskill.cd_remaining = 999
      kael.cantap = false
      kael.cantapcd = 15
    end
    kael.energy_ball_manager:consumeEnergyBall()
  end
  if kael.changetime <= 0 then
    local maxcount = math.max(kael.icecount, kael.firecount, kael.lightningcount)
    print(kael.icecount)
    print(kael.firecount)
    print(kael.lightningcount)
    if kael.icecount == maxcount then
      if kael.icecount == kael.firecount then
        if kael.icecount == kael.lightningcount then
          kael.awake_stage = math.floor(ed.rand() * 3 + 1)
        else
          kael.awake_stage = math.floor(ed.rand() * 2 + 1)
        end
      else
        kael.awake_stage = 1
      end
    elseif kael.firecount == maxcount then
      if kael.firecount == kael.lightningcount then
        kael.awake_stage = math.floor(ed.rand() * 2 + 2)
      else
        kael.awake_stage = 2
      end
    else
      kael.awake_stage = 3
    end
    local skillawake = kael.skills.HeatBossKael_awake
    kael:castSkill(skillawake, nil)
    kael.changetime = 9999
  end
  for k, v in pairs(kael.deliveredBalls) do
    v.duration = v.duration - dt
    if v.duration < HeatBossKael.epsilon and not v.startAutoGet then
      if ed.run_with_scene then
        ed.sceneui:removeBall(v.idx)
      end
      kael.deliveredBalls[v.idx] = nil
      ed.engine.usedDeliveredBallSlots[v.deliveredSlotIdx] = false
    end
    if (kael.aiMode or kael.auto_combat) and v.autoPick > HeatBossKael.epsilon then
      v.autoPick = v.autoPick - dt
    end
    if v.startAutoGet and v.autoGet > HeatBossKael.epsilon then
      v.autoGet = v.autoGet - dt
      if v.autoGet < HeatBossKael.epsilon then
        ed.engine.usedDeliveredBallSlots[v.deliveredSlotIdx] = false
        kael:addEnergyBall(v.idx, v.balltype, v.myslotidx)
      end
    end
  end
  kael.energy_ball_manager:update(dt)
  basefunc(kael, dt)
end

function HeatBossKael.tapicebuff_onDamaged(basefunc, buff, damage, damage_type)
  local damage = basefunc(buff, damage, damage_type)
  damage = damage and damage * 1.3
  return damage
end

function HeatBossKael:addEnergyBall(idx, balltype, myslotidx)
  if self.deliveredBalls[idx] then
    self.deliveredBalls[idx] = nil
    self.energy_ball_manager:addEnergyBall(balltype, myslotidx)
  end
end

function HeatBossKael:tapBall(ext)
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

function HeatBossKael.castSkill(basefunc, kael, skill, target)
  if kael.current_skill and not kael.current_skill.info.Manual and not kael.current_skill == kael.skills.HeatBossKael_awake then
    kael.current_skill:interrupt()
  end
  basefunc(kael, skill, target)
end

function HeatBossKael.autoTapBall(kael)
  if not kael.aiMode and not kael.auto_combat then
    return
  end
  for k, v in pairs(kael.deliveredBalls) do
    if v.autoPick < HeatBossKael.epsilon and not v.tapped then
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

function HeatBossKael.SpecialCheckEnableAi(kael)
  if kael.energy_ball_manager:isSlotsAvailable() and not ed.engine:arenaMode() then
    return true
  end
  return false
end

function HeatBossKael.reset(basefunc, kael)
  basefunc(kael)
  if kael.name == "HeatBossKael" then
    kael.deliveredBalls = {}
    kael.energy_ball_manager:clear()
  end
  HeatBossKael.globalBallIdx = 0
  kael.awake_stage = nil
  kael.atkcount = 0
  kael.randomtime = 3
  kael.icecount = 0
  kael.firecount = 0
  kael.lightningcount = 0
  kael.changetime = 40
  kael.changetimebuff = true
  kael.actskillcd = 999
  kael.cantap = true
  kael.cantapcd = 0
end

function HeatBossKael.die(basefunc, kael, killer)
  basefunc(kael, killer)
  if kael.oldfireman_HeatBossKael then
    kael.oldfireman_HeatBossKael:die()
  end
end

function HeatBossKael.skillawake_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.changePeriod_HeatBossKael = true
end

function HeatBossKael.skillawake_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 10038821
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
end

function HeatBossKael.skillawake_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.HeatBossKael_inawake_time = 9999999999
  if caster.changePeriod_HeatBossKael then
    caster:enterActionStageFromOneStage(caster.awake_stage + 2, 388)
    local awakeheal = caster.attribs.HP * 0.2
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 20050141 then
        awakeheal = caster.attribs.HP * 0.24
      end
      if tbuff.info.ID == 20050142 then
        awakeheal = caster.attribs.HP * 0.28
      end
      if tbuff.info.ID == 20050143 then
        awakeheal = caster.attribs.HP * 0.32
      end
      if tbuff.info.ID == 20050144 then
        awakeheal = caster.attribs.HP * 0.36
      end
    end
    caster:takeHeal(awakeheal, "hp", caster)
    local bid = 10038817 + caster.awake_stage
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    local AP = skill.info["Script Arg2"]
    local ARM = skill.info["Script Arg1"]
    local DODG = skill.info["Script Arg3"]
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 20050161 then
        AP = AP * 1.25
        ARM = ARM * 1.25
        DODG = DODG * 1.25
      end
      if tbuff.info.ID == 20050162 then
        AP = AP * 1.5
        ARM = ARM * 1.5
        DODG = DODG * 1.5
      end
      if tbuff.info.ID == 20050163 then
        AP = AP * 1.75
        ARM = ARM * 1.75
        DODG = DODG * 1.75
      end
      if tbuff.info.ID == 20050164 then
        AP = AP * 2
        ARM = ARM * 2
        DODG = DODG * 2
      end
    end
    if bid == 10038818 then
      buff:setAttribute("AP", AP)
    elseif bid == 10038819 then
      buff:setAttribute("ARM", ARM)
    elseif bid == 10038820 then
      buff:setAttribute("DODG", DODG)
    end
    caster:addBuff(buff, caster)
    if caster.awake_stage == 1 then
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 10038802 then
          tbuff:setAttribute("MIMU", 80)
        end
      end
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and buff.owner.name == "HeatBossKael" and ed.protoAwake(caster.proto, 388) then
        if caster.awake_stage == 1 then
          panel:setPortrait("UI/DOTA-HERO/SwitchHeatBossKael_ice.png")
        elseif caster.awake_stage == 2 then
          panel:setPortrait("UI/DOTA-HERO/SwitchHeatBossKael_fire.png")
        else
          panel:setPortrait("UI/DOTA-HERO/SwitchHeatBossKael_lightning.png")
        end
      end
    end
  end
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 10038821 then
      tbuff.timer = 0
    end
  end
end

function HeatBossKael.skillshock_createBuff(basefunc, skill, target)
  local bid = 10038808
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  target:addBuff(binfo, skill.caster)
  local buff = basefunc(skill, target)
  buff:setAttribute("AD", -0.2 * target.attribs.AD)
  return buff
end

function HeatBossKael.skillshock_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  if target:isAlive() and caster.awake_stage == 1 and ed.rand() < HeatBossKael.HeatBossKael_shock_ice_rand then
    local bid = 10038809
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
  if target:isAlive() and caster.awake_stage == 2 then
    local bid = 10038810
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local HPR = skill.info["Script Arg2"]
    local MPR = skill.info["Script Arg3"]
    buff:setAttribute("HPR", HPR)
    buff:setAttribute("MPR", MPR)
    target:addBuff(buff, caster)
  end
  if target:isAlive() and caster.awake_stage == 3 then
    local bid = 10038811
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local APdown = HeatBossKael.HeatBossKael_shock_APdown * target.attribs.AP
    buff:setAttribute("AP", APdown)
    target:addBuff(buff, caster)
  end
end

function HeatBossKael.frozenbuff_onDamaged(basefunc, buff, damage, damage_type)
  local damage = basefunc(buff, damage, damage_type)
  if not buff.owner.config.is_boss and buff.owner.state ~= ed.emUnitState_Hurt then
    buff.owner:hurt()
  end
  local owner = buff.owner
  local caster = buff.caster
  if caster.awake_stage ~= 1 or ed.rand() < HeatBossKael.HeatBossKael_frozen_ice_rand then
  end
  return damage
end

function HeatBossKael.skillfrozen_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.onDamaged = override(buff.onDamaged, HeatBossKael.frozenbuff_onDamaged)
  if caster.awake_stage == 1 then
    local MPRatioDown = skill.info["Script Arg2"]
    local bid = 10038822
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, target, caster)
    buff2:setAttribute("MPRatio", MPRatioDown)
    target:addBuff(buff2, caster)
  end
  return buff
end

function HeatBossKael.fireman_die(basefunc, fireman, killer)
  basefunc(fireman, killer)
  if fireman.region then
    fireman.region:terminate()
  end
end

function HeatBossKael.skillfireman_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local proto = {
    _tid = 389,
    _level = skill.level
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    estimate_skill = true,
    hp_mod = caster.awake_stage == 2 and 3 or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local oldfireman_HeatBossKael = caster.oldfireman_HeatBossKael
  if oldfireman_HeatBossKael and oldfireman_HeatBossKael:isAlive() then
    oldfireman_HeatBossKael:die()
  end
  local fireman = ed.UnitCreate(proto, caster.camp, config)
  local location = {
    caster.position[1] + 50 * caster.direction,
    caster.position[2]
  }
  local fireman_skillatk2 = fireman.skills.HeatFireElement_ice
  local fireman_skillatk3 = fireman.skills.HeatFireElement_fire
  if caster.awake_stage == 2 then
    local x = HeatBossKael.selectPosition(fireman_skillatk3, 70)
    if x then
      location = {
        x,
        caster.position[2]
      }
    end
  end
  fireman.die = override(fireman.die, HeatBossKael.fireman_die)
  fireman.direction = caster.direction
  ed.engine:summonUnit(fireman, location, caster)
  if caster.awake_stage == 1 then
    local bid = 10038812
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    fireman:addBuff(binfo, caster)
    fireman_skillatk2.target = fireman
    local region = fireman_skillatk2:createRegion()
    ed.engine:addRegion(region)
    fireman.region = region
  elseif caster.awake_stage == 2 then
    fireman_skillatk3.target = fireman
    local region = fireman_skillatk3:createRegion()
    ed.engine:addRegion(region)
    fireman.region = region
  end
  caster.oldfireman_HeatBossKael = fireman
end

function HeatBossKael.skillmagnet_takeEffectOn(basefunc, skill, target, source)
  local succ = basefunc(skill, target)
  if succ then
    local power = skill.info["Script Arg1"]
    local targetMP = target.mp
    local d = power - targetMP
    target:takeDamage(power, "Holy", "mp", skill.caster)
    if skill.caster.awake_stage == 3 and 0 < d then
      target:takeDamage(d * HeatBossKael.HeatBossKael_magnet_powerratio, "Holy", "hp", skill.caster)
    end
  end
  return succ
end

function HeatBossKael.skillmagnet_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if skill.target then
      skill.magnetorigin = {
        skill.target.position[1],
        -30
      }
    else
      skill.magnetorigin = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_Kael_atk8.cha"
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

function HeatBossKael.skillmeteor_createProjectile(basefunc, skill)
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

function HeatBossKael.projectile2_update(basefunc, projectile2, dt)
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
    distance = distance + HeatBossKael.trigger_distance * (caster.awake_stage == 3 and HeatBossKael.HeatBossKael_meteor_lightning or 1)
  end
  projectile2.tile_distance = distance
  basefunc(projectile2, dt)
  local long_max = 260
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

function HeatBossKael.projectile2_terminate(basefunc, projectile)
  basefunc(projectile)
  local caster = projectile.caster
  if caster.awake_stage == 2 then
    local skillboom = caster.skills.HeatBossKael_meteor_boom
    skillboom:takeEffectAt(projectile.position)
  end
end

function HeatBossKael.skillmeteor_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  local caster = skill.caster
  if source and source.tile2 then
    basefunc(skill, location, source)
  else
    skill.info = ed.wraptable(originfo, {
      ["Point Effect"] = "eff_point_Kael_atk2_2.cha",
      ["Point Zorder"] = 1,
      ["Tile OTT Height"] = 50,
      ["Tile Art"] = caster.awake_stage == 2 and "eff_tile_Kael_awake_meteor.cha" or "eff_tile_Kael_atk2.cha"
    })
    basefunc(skill, location, source)
    skill:selectTarget()
    local projectile2 = ed.ProjectileCreate(skill)
    projectile2.tile2 = true
    projectile2.update = override(projectile2.update, HeatBossKael.projectile2_update)
    projectile2.terminate = override(projectile2.terminate, HeatBossKael.projectile2_terminate)
    projectile2.height = 35
    projectile2.velocity = {
      160 * skill.meteorDirection,
      0
    }
    projectile2.tile_distance = HeatBossKael.trigger_distance * (caster.awake_stage == 3 and HeatBossKael.HeatBossKael_meteor_lightning or 1)
    projectile2.position = {
      location[1],
      location[2]
    }
    ed.engine:addProjectile(projectile2)
    skill.info = originfo
  end
end

function HeatBossKael.swiftbuff_onRemoved(basefunc, buff)
  if buff.originfo then
    buff.owner.basic_skill.info = buff.originfo
  end
  basefunc(buff)
end

function HeatBossKael.skillswift_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local targetBasicSkill = buff.owner.basic_skill
  local originfo = targetBasicSkill.info
  buff.originfo = originfo
  targetBasicSkill.cd_remaining = 0
  targetBasicSkill.info = ed.wraptable(originfo, {
    CD = 0,
    ["Global CD"] = 1
  })
  buff.onRemoved = override(buff.onRemoved, HeatBossKael.swiftbuff_onRemoved)
  return buff
end

function HeatBossKael.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  local ultheal = caster.attribs.HP * 0.15
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050151 then
      ultheal = caster.attribs.HP * 0.17
    end
    if tbuff.info.ID == 20050152 then
      ultheal = caster.attribs.HP * 0.19
    end
    if tbuff.info.ID == 20050153 then
      ultheal = caster.attribs.HP * 0.21
    end
    if tbuff.info.ID == 20050154 then
      ultheal = caster.attribs.HP * 0.23
    end
  end
  caster:takeHeal(ultheal / 7, "hp", caster)
end

function HeatBossKael.skillicewall_takeEffectAt(basefunc, skill, location)
  local caster = skill.caster
  local origin = {
    location[1],
    0
  }
  skill.HeatBossKael_icewall_origin = origin
  basefunc(skill, origin)
end

function HeatBossKael.icewall_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.position[1] <= buff.HeatBossKael_icewall_origin[1] + 50 and owner.position[1] >= buff.HeatBossKael_icewall_origin[1] - 50 then
    buff.HeatBossKael_icewall_awakecount = buff.HeatBossKael_icewall_awakecount - dt
  end
  if buff.HeatBossKael_icewall_awakecount <= 0 and caster.awake_stage == 1 then
    local bid = 10038823
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, owner, caster)
    local result = owner:addBuff(buff2, caster)
    buff.HeatBossKael_icewall_awakecount = 999999
  end
  if buff.HeatBossKael_icewall_awakecount <= 0 and caster.awake_stage == 2 then
    local skilliceflower = caster.skills.HeatBossKael_icewall_flower
    skilliceflower:takeEffectAt(owner.position)
    buff.HeatBossKael_icewall_awakecount = 999999
  end
end

function HeatBossKael.skillicewall_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.awake_stage == 1 or caster.awake_stage == 2 then
    buff.HeatBossKael_icewall_origin = {
      skill.HeatBossKael_icewall_origin[1],
      skill.HeatBossKael_icewall_origin[2]
    }
    buff.update = override(buff.update, HeatBossKael.icewall_buff_update)
    buff.HeatBossKael_icewall_awakecount = 2
  end
  return buff
end

function HeatBossKael.skillatk_startPhase(basefunc, skill, idx)
  local id = math.floor(ed.rand() * 2 + 1)
  basefunc(skill, id)
end

function HeatBossKael.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function HeatBossKael.skillatk_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local HeatBossKael_inswift
  if caster.awake_stage == 3 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 10038803 then
        HeatBossKael_inswift = true
      end
    end
  end
  caster.atkcount = caster.atkcount + 1
  basefunc(skill)
end

function HeatBossKael.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local HeatBossKael_inswift
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10038803 then
      HeatBossKael_inswift = true
    end
  end
  if result and HeatBossKael_inswift and caster.awake_stage == 2 then
    local caster = skill.caster
    local bid = 10038815
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local skillswift = caster.skills.HeatBossKael_lightning2fire
    local HPR = skillswift.info["Script Arg2"]
    buff:setAttribute("HPR", HPR)
    target:addBuff(buff, caster)
  end
  if result and HeatBossKael_inswift and caster.awake_stage == 3 and ed.rand() < HeatBossKael.HeatBossKael_swift_stun then
    local bid = 10038816
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(binfo, caster)
  end
end

function HeatBossKael.skillskyfire_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  if not skill.affectnum then
    skill.affectnum = 1
  end
  local caster = skill.caster
  local awake_powerup = 0
  if caster.awake_stage == 2 then
    skill.affectnum = skill.affectnum <= 2 and skill.affectnum or 2
    awake_powerup = HeatBossKael.HeatBossKael_skyfire_powerup
  end
  return power * (1 + awake_powerup) / skill.affectnum, coefficient
end

function HeatBossKael.skillskyfire_takeEffectAt(basefunc, skill, location, source)
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
    if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == skill.caster then
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

function HeatBossKael.skillshadowwalk_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.awake_stage == 1 then
    buff:setAttribute("MIMU", 80)
  end
  return buff
end

function HeatBossKael.onHitMiss(basefunc, hero, skill)
  basefunc(hero, skill)
  if hero.awake_stage == 3 then
    local HeatBossKael_inshadow
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 10038802 then
        HeatBossKael_inshadow = true
        break
      end
    end
    local target = skill.caster
    if HeatBossKael_inshadow and target then
      local skillshadowwalk_lighting = hero.skills.HeatBossKael_skillshadowwalk_lighting
      skillshadowwalk_lighting.target = target
      local chain = skillshadowwalk_lighting:createChain()
      ed.engine:addChain(chain)
    end
  end
end

function HeatBossKael.skilltornado_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local result
  if caster.awake_stage == 3 then
    local originfo = skill.info
    local direction = ed.rand() < 0.5 and 1 or -1
    skill.info = ed.wraptable(originfo, {
      ["Knock Back"] = 50 * direction
    })
    result = basefunc(skill, target, source, shift)
    skill.info = originfo
  elseif caster.awake_stage == 1 then
    result = basefunc(skill, target, source, shift)
    if target:isAlive() and result then
      local caster = skill.caster
      local bid = 10038817
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(binfo, caster)
    end
  else
    basefunc(skill, target, source, shift)
  end
  return result
end

function HeatBossKael.silenceeffect(buff)
  local negative_effects = {silence = true}
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function HeatBossKael.collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local caster = buff.caster
  local owner = buff.owner
  if HeatBossKael.silenceeffect(buff) and owner.name == "HeatBossKael" and caster:isAlive() and buff.info.ID ~= 30010017 and buff.info.ID ~= 10038826 then
    buff.timer = buff.timer * 0.01
  end
end

function HeatBossKael.init_hero(hero)
  local skillshock = hero.skills.HeatBossKael_all
  local skillfrozen = hero.skills.HeatBossKael_ice3
  local skillfireman = hero.skills.HeatBossKael_fire2ice
  local skillmagnet = hero.skills.HeatBossKael_lightning3
  local skillmeteor = hero.skills.HeatBossKael_fire2lightning
  local skillswift = hero.skills.HeatBossKael_lightning2fire
  local skillult = hero.skills.HeatBossKael_book
  local skillatk = hero.skills.HeatBossKael_atk
  local skillicewall = hero.skills.HeatBossKael_ice2fire
  local skillskyfire = hero.skills.HeatBossKael_fire3
  local skillshadowwalk = hero.skills.HeatBossKael_ice2lightning
  local skilltornado = hero.skills.HeatBossKael_lightning2ice
  local skillawake = hero.skills.HeatBossKael_awake
  hero:preloadEffect("eff_point_Kael_atk8.cha")
  hero:preloadEffect("eff_point_Kael_atk2_2.cha")
  hero:preloadEffect("eff_tile_Kael_atk2.cha")
  if skillshock then
    skillshock.createBuff = override(skillshock.createBuff, HeatBossKael.skillshock_createBuff)
    skillshock.takeEffectOn = override(skillshock.takeEffectOn, HeatBossKael.skillshock_takeEffectOn)
  end
  if skillfrozen then
    skillfrozen.createBuff = override(skillfrozen.createBuff, HeatBossKael.skillfrozen_createBuff)
  end
  if skillfireman then
    skillfireman.takeEffectOn = override(skillfireman.takeEffectOn, HeatBossKael.skillfireman_takeEffectOn)
  end
  if skillmagnet then
    skillmagnet.takeEffectAt = override(skillmagnet.takeEffectAt, HeatBossKael.skillmagnet_takeEffectAt)
    skillmagnet.takeEffectOn = override(skillmagnet.takeEffectOn, HeatBossKael.skillmagnet_takeEffectOn)
  end
  if skillmeteor then
    skillmeteor.createProjectile = override(skillmeteor.createProjectile, HeatBossKael.skillmeteor_createProjectile)
    skillmeteor.takeEffectAt = override(skillmeteor.takeEffectAt, HeatBossKael.skillmeteor_takeEffectAt)
  end
  if skillswift then
    skillswift.createBuff = override(skillswift.createBuff, HeatBossKael.skillswift_createBuff)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, HeatBossKael.skillult_onAttackFrame)
  end
  if skillicewall then
    skillicewall.takeEffectAt = override(skillicewall.takeEffectAt, HeatBossKael.skillicewall_takeEffectAt)
    skillicewall.createBuff = override(skillicewall.createBuff, HeatBossKael.skillicewall_createBuff)
  end
  if skillatk then
    skillatk.startPhase = override(skillatk.startPhase, HeatBossKael.skillatk_startPhase)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, HeatBossKael.skillatk_onPhaseFinished)
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, HeatBossKael.skillatk_onAttackFrame)
  end
  if skillskyfire then
    skillskyfire.takeEffectAt = override(skillskyfire.takeEffectAt, HeatBossKael.skillskyfire_takeEffectAt)
    skillskyfire.power = override(skillskyfire.power, HeatBossKael.skillskyfire_power)
  end
  if skillshadowwalk then
    skillshadowwalk.createBuff = override(skillshadowwalk.createBuff, HeatBossKael.skillshadowwalk_createBuff)
  end
  if skilltornado then
    skilltornado.takeEffectOn = override(skilltornado.takeEffectOn, HeatBossKael.skilltornado_takeEffectOn)
  end
  if skillawake then
    skillawake.onAttackFrame = override(skillawake.onAttackFrame, HeatBossKael.skillawake_onAttackFrame)
    skillawake.start = override(skillawake.start, HeatBossKael.skillawake_start)
    skillawake.finish = override(skillawake.finish, HeatBossKael.skillawake_finish)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, HeatBossKael.skillatk_takeEffectOn)
  end
  hero.die = override(hero.die, HeatBossKael.die)
  if hero.name == "HeatBossKael" then
    hero.update = override(hero.update, HeatBossKael.update)
    hero.castSkill = override(hero.castSkill, HeatBossKael.castSkill)
    hero.reset = override(hero.reset, HeatBossKael.reset)
    hero.onHitMiss = override(hero.onHitMiss, HeatBossKael.onHitMiss)
    hero.showBall = HeatBossKael.showBall
    hero.skillConditon = HeatBossKael.HeatBossKaelSkillElement
    hero.addEnergyBall = HeatBossKael.addEnergyBall
    hero.autoTapBall = HeatBossKael.autoTapBall
    hero.tapBall = HeatBossKael.tapBall
    hero.SpecialCheckEnableAi = HeatBossKael.SpecialCheckEnableAi
    hero.energy_ball_manager = ed.EnergyBallManagerCreate(hero)
    hero.deliveredBalls = {}
    hero.collectBuff = override(hero.collectBuff, HeatBossKael.collectBuff)
    hero.displayBall = true
    ed.engine.enemyKaelHero = hero
  end
  hero:setActionStageChangeByManual(true)
  return hero
end

return HeatBossKael.init_hero
