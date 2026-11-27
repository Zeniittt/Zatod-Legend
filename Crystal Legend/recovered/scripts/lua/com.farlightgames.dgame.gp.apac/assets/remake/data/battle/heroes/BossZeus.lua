module("ed.battlehero", package.seeall)
local ed = ed
BossZeus = {}
BossZeus.name = "BossZeus"
BossZeus.debuffResistance = {
  0.5,
  0.3,
  0.25
}
BossZeus.lockHpSmall = "UI/alpha/1080P/hp_gray_small.png"
BossZeus.lockHpBig = "UI/alpha/1080P/hp_gray"
BossZeus.lockHpBuffId = 857
BossZeus.lockHpBuffLockPercent = 0.065
BossZeus.atk2_iniCoef = 0.11
BossZeus.atk2_extraCoef = 0.08
BossZeus.atk3_iniCoef = 2.5
BossZeus.atk4_iniCoef = 2.5
BossZeus.atk5_buffId = 214
BossZeus.atk5_dpsRatio = 1.15
BossZeus.atk7_coef1 = 0.1
BossZeus.atk6_buffId = 858
BossZeus.atk6_tileNum = 8
BossZeus.atk6_tileTime = 1.5
BossZeus.atk6_tileHalfTime = BossZeus.atk6_tileTime * 0.5
BossZeus.atk6_directionList = {
  {180, 0},
  {130, 35},
  {0, 50},
  {-130, 35},
  {-180, 0},
  {-130, -35},
  {0, -50},
  {130, -35}
}
BossZeus.enter_buffId = 884
BossZeus.enter_position = {650, 0}
BossZeus.maxHpCheck = 200000
BossZeus.jump_gap = 14400

function BossZeus.randomLightning(times, skill)
  local minX = ed.engine.stage_rect.minX
  local minY = ed.engine.stage_rect.minY
  local maxX = ed.engine.stage_rect.maxX
  local maxY = ed.engine.stage_rect.maxY
  local t = 0
  for i = 1, times do
    local position = {
      (minX + maxX) / 2,
      0
    }
    local deltaX = (maxX - minX) * 0.4
    position[1] = position[1] + ed.rand() * 2 * deltaX - deltaX
    position[2] = position[2] + ed.rand() * 160 - 80
    skill:takeEffectAt(position)
    t = t + 1
  end
  local r = ed.rand()
  if r <= times - t then
    local position = {
      (minX + maxX) / 2,
      0
    }
    local deltaX = (maxX - minX) * 0.4
    position[1] = position[1] + ed.rand() * 2 * deltaX - deltaX
    position[2] = position[2] + ed.rand() * 160 - 80
    skill:takeEffectAt(position)
  end
end

function BossZeus.enterBuff_update(basefunc, buff, dt)
  local owner = buff.owner
  if buff.timer <= 0 then
    owner.position[1] = BossZeus.enter_position[1]
    owner.position[2] = BossZeus.enter_position[2]
  end
  basefunc(buff, dt)
  buff.existTime = buff.existTime + dt
  local skillatk8 = owner.skills[BossZeus.name .. "_atk8"]
  if skillatk8 then
    if buff.existTime <= 0.5 then
      BossZeus.randomLightning(0.4, skillatk8)
    elseif 1 >= buff.existTime then
      BossZeus.randomLightning(0.65, skillatk8)
    elseif buff.existTime <= 1.5 then
      BossZeus.randomLightning(0.9, skillatk8)
    elseif buff.existTime <= 1.9 then
      BossZeus.randomLightning(1.2, skillatk8)
    elseif buff.existTime <= 2.3 then
      BossZeus.randomLightning(1.5, skillatk8)
    elseif buff.existTime <= 2.7 then
      BossZeus.randomLightning(1.8, skillatk8)
    elseif buff.existTime <= 3.2 then
      BossZeus.randomLightning(2.2, skillatk8)
    elseif buff.existTime <= 3.8 then
      BossZeus.randomLightning(2.7, skillatk8)
    elseif buff.existTime <= 999 then
      BossZeus.randomLightning(3.5, skillatk8)
    end
  end
  if buff.existTime >= 4 and not buff.BossZeus_alreadyPlayEffect then
    buff.timer = 0.5
    buff.BossZeus_alreadyPlayEffect = true
    if ed.run_with_scene then
      local effect_name = "eff_impact_FarSeer_ult"
      local effect = ed.scene:playEffectOnScene(effect_name, BossZeus.enter_position, {1, 1}, nil, 1)
    end
  end
end

function BossZeus.reset(basefunc, unit)
  basefunc(unit)
  unit.BossZeus_phase = 1
  unit.BossZeus_atk2Coef = BossZeus.atk2_iniCoef
  local skillatk8 = unit.skills[BossZeus.name .. "_atk8"]
  if skillatk8 then
    unit.position[1] = 1000
    local binfo = ed.lookupDataTable("Buff", nil, BossZeus.enter_buffId)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff.existTime = 0
    buff.update = override(buff.update, BossZeus.enterBuff_update)
    unit.BossZeus_enterBuff = unit:addBuff(buff, unit)
  end
end

function BossZeus.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local skillatk3 = unit.skills[BossZeus.name .. "_atk3"]
  local list = unit.buff_list
  local camp = unit.camp
  local resist = unit.BossZeus_phase and BossZeus.debuffResistance[unit.BossZeus_phase] or 0.75
  local coef = 1 / resist - 1 or 0
  for i = 1, #list do
    local buff = list[i]
    if buff.caster and buff.caster.camp ~= camp and buff.info.Dispel == "YES" then
      buff.timer = buff.timer - dt * coef
    end
  end
end

function BossZeus.hpLockPerform(unit)
  local actor = unit.actor
  if actor then
    local buff
    local level = 0
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == BossZeus.lockHpBuffId then
        buff = tbuff
        level = tbuff.rank
        break
      end
    end
    local lockPercent = level * BossZeus.lockHpBuffLockPercent
    if not buff and unit.BossZeus_hpLockBar then
      unit.BossZeus_hpLockBar:removeFromParentAndCleanup(true)
      unit.BossZeus_hpLockBar = false
    elseif buff and not unit.BossZeus_hpLockBar then
      local barHp = unit.actor.bar_hp
      if barHp then
        local backgroundSize = barHp.background:getTextureRect().size
        local midlayerSize = barHp.midlayer:getTextureRect().size
        local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
        local offsetY = backgroundSize.height / 2
        local newBar = ed.createSprite(BossZeus.lockHpSmall)
        barHp.background:addChild(newBar, 0)
        newBar:setAnchorPoint(ccp(1, 0.5))
        newBar:setPosition(ccp(offsetX, offsetY))
        newBar:setScaleX(lockPercent)
        unit.BossZeus_hpLockBar = newBar
      end
    elseif buff and unit.BossZeus_hpLockBar then
      unit.BossZeus_hpLockBar:setScaleX(lockPercent)
    end
  end
end

function BossZeus.lockHpBuff_update(basefunc, self, dt)
  basefunc(self, dt)
  local owner = self.owner
  local lockPercent = self.rank * BossZeus.lockHpBuffLockPercent
  if owner then
    local maxHp = owner.attribs.HP * (1 - lockPercent)
    local currentHp = owner.hp
    if maxHp < currentHp then
      owner:setHP(maxHp)
    end
  end
  BossZeus.hpLockPerform(owner)
end

function BossZeus.addLockHpBuff(skill, target, times)
  local caster = skill.caster
  for i = 1, times do
    local bid = BossZeus.lockHpBuffId
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff.update = override(buff.update, BossZeus.lockHpBuff_update)
    local addbuff = target:addBuff(buff, caster)
  end
  BossZeus.hpLockPerform(target)
end

function BossZeus.skillatk5_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = BossZeus.atk5_buffId
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.BossZeus_uncontrollableBuff = buff
  basefunc(skill, target)
end

function BossZeus.skillatk5_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, duration)
end

function BossZeus.skillatk5_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * BossZeus.atk5_dpsRatio
  caster.BossZeus_atk2Coef = caster.BossZeus_atk2Coef and caster.BossZeus_atk2Coef + BossZeus.atk2_extraCoef or BossZeus.atk2_iniCoef
  if caster then
    local skillatk5 = caster.skills[BossZeus.name .. "_atk5"]
    local phase = caster.BossZeus_phase
    if phase and phase == 1 then
      caster:enterActionStageFromOneStage(2, 230)
      if skillatk5 then
        skillatk5.cd_remaining = 9999
      end
    elseif phase and phase == 2 then
      caster:enterActionStageFromOneStage(3, 230)
      if skillatk5 then
        skillatk5.cd_remaining = 9999
      end
    end
  end
  caster:endScalingAction()
  caster.BossZeus_phase = caster.BossZeus_phase + 1
  local buff = caster.BossZeus_uncontrollableBuff
  if buff then
    caster:removeBuff(buff)
    caster.BossZeus_uncontrollableBuff = nil
  end
end

function BossZeus.skillatk2chain_findNextTaeget(basefunc, self)
  local min = math.huge
  local ret
  local retList = {}
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
    else
      local times = self.affect_times[unit] or 0
      if min < times then
      else
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - BossZeus.jump_gap)
        if distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          if times == min then
            table.insert(retList, unit)
          elseif min > times then
            retList = {}
            table.insert(retList, unit)
            min = times
          end
        end
      end
    end
  end
  local n = #retList
  local rand_i = math.floor(ed.rand() * n) + 1
  ret = retList[rand_i] or ret
  return ret
end

function BossZeus.skillatk2_createChain(basefunc, skill)
  local chain = basefunc(skill)
  chain.findNextTaeget = override(chain.findNextTaeget, BossZeus.skillatk2chain_findNextTaeget)
  return chain
end

function BossZeus.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local coef = caster.BossZeus_atk2Coef or 0.1
  local dmg = target and target.hp * coef
  local targetMaxHp = target.attribs.HP or 1
  if 30000 <= dmg or targetMaxHp >= BossZeus.maxHpCheck then
    dmg = 30000
  end
  if target == caster then
    dmg = 0
  end
  local originInfo = skill.info
  skill.info = ed.wraptable(originInfo, {
    ["Damage Type"] = "Holy",
    ["Basic Num"] = dmg,
    ["Plus Ratio"] = 0
  })
  local isHit, trueDmg = basefunc(skill, target, source, shift)
  skill.info = originInfo
end

function BossZeus.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local target = skill.target
  if target and target.config.is_summoned then
    skill.cd_remaining = skill.cd_remaining / 2
  end
end

function BossZeus.skillatk3_takeEffectOn(basefunc, self, target, source, shift)
  basefunc(self, target, source, shift)
  local caster = self.caster
  local targetMaxHp = target.attribs.HP or 1
  if caster ~= target and targetMaxHp < BossZeus.maxHpCheck then
    BossZeus.addLockHpBuff(self, target, 1)
  end
end

function BossZeus.skillatk3_power(basefunc, self, source, target, damage_type)
  local power, c = basefunc(self, source, target, damage_type)
  if target and target:isAlive() and target.hp then
    local loseHpRatio = (target.attribs.HP - target.hp) / target.attribs.HP
    local extraRatio = loseHpRatio * BossZeus.atk3_iniCoef
    power = power * (1 + extraRatio)
  end
  return power, c
end

function BossZeus.skillatk4_power(basefunc, self, source, target, damage_type)
  local power, c = basefunc(self, source, target, damage_type)
  if target and target:isAlive() and target.hp then
    local loseHpRatio = (target.attribs.HP - target.hp) / target.attribs.HP
    local extraRatio = loseHpRatio * BossZeus.atk4_iniCoef
    power = power * (1 + extraRatio)
  end
  return power, c
end

function BossZeus.skillatk4_takeEffectOn(basefunc, self, target, source, shift)
  basefunc(self, target, source, shift)
  local caster = self.caster
  local targetMaxHp = target.attribs.HP or 1
  if caster ~= target and targetMaxHp < BossZeus.maxHpCheck then
    BossZeus.addLockHpBuff(self, target, 1)
  end
end

function BossZeus.skillatk7_power(basefunc, self, source, target, damage_type)
  local power, c = basefunc(self, source, target, damage_type)
  local targetMaxHp = target.attribs.HP or 1
  if target and target:isAlive() and target.hp and target ~= self.caster and targetMaxHp < BossZeus.maxHpCheck then
    power = target.hp * BossZeus.atk7_coef1
  end
  return power, c
end

function BossZeus.skillatk7_createBuff(basefunc, self, target)
  local buff = basefunc(self, target)
  return buff
end

function BossZeus.skillatk7_takeEffectOn(basefunc, self, target, source, shift)
  basefunc(self, target, source, shift)
  local caster = self.caster
  local targetMaxHp = target.attribs.HP or 1
  if caster ~= target and targetMaxHp < BossZeus.maxHpCheck then
    BossZeus.addLockHpBuff(self, target, 3)
  end
end

function BossZeus.skillatk6_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local currentPos = caster.position
  local dxList = {}
  local minNearEnemy
  for dx = -600, 600, 50 do
    if math.abs(dx) <= 200 then
    else
      local x2 = currentPos[1] + dx
      if x2 > ed.engine.stage_rect.maxX - 50 or x2 < ed.engine.stage_rect.minX + 50 then
      else
        local near_enemy = 0
        local e_camp = -caster.camp
        for e_unit in ed.engine:foreachAliveUnit(e_camp) do
          local e_x = e_unit.position[1]
          local e_attackRange = e_unit.attack_range and e_unit.attack_range + 100 or 200
          if not e_unit.config.is_summoned and e_attackRange >= math.abs(e_x - x2) then
            near_enemy = near_enemy + 1
          end
        end
        if not minNearEnemy or near_enemy == minNearEnemy then
          minNearEnemy = near_enemy
          table.insert(dxList, dx)
        elseif near_enemy < minNearEnemy then
          dxList = {}
          table.insert(dxList, dx)
          minNearEnemy = near_enemy
        end
      end
    end
  end
  local n = #dxList
  local rand_i = math.floor(ed.rand() * n) + 1
  skill.BossZeus_dx = dxList[rand_i] or 0
end

function BossZeus.skillatk6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local bid = BossZeus.atk6_buffId
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.BossZeus_invisibleBuff = buff
  caster.BossZeus_alreadyMove = nil
end

function BossZeus.skillatk6projectile_update(basefunc, self, dt)
  if self.BossZeus_phase == "out" then
    if self.BossZeus_targetPos then
      local time = self.existTime or 0
      local time_remaining = BossZeus.atk6_tileHalfTime - time
      local speedCoef = (2 * BossZeus.atk6_tileHalfTime - time) / BossZeus.atk6_tileHalfTime
      if self.BossZeus_targetPos then
        local targetPosVector = ed.edpSub(self.BossZeus_targetPos, self.position)
        self.velocity = ed.edpMult(targetPosVector, speedCoef / time_remaining)
      end
    end
  elseif self.BossZeus_phase == "in" then
    local caster = self.caster
    local targetPos = caster.position
    if targetPos then
      local time = self.existTime - BossZeus.atk6_tileHalfTime or 0
      local time_remaining = BossZeus.atk6_tileHalfTime - time
      local speedCoef = (BossZeus.atk6_tileHalfTime + time) / (2 * BossZeus.atk6_tileHalfTime)
      if self.BossZeus_targetPos then
        local targetPosVector = ed.edpSub(targetPos, self.position)
        self.velocity = ed.edpMult(targetPosVector, speedCoef / time_remaining)
      end
    else
      self:terminate()
    end
  end
  basefunc(self, dt)
  local caster = self.caster
  self.existTime = self.existTime and self.existTime + dt or dt
  if self.existTime >= BossZeus.atk6_tileHalfTime and self.BossZeus_phase == "out" then
    if not caster.BossZeus_alreadyMove and self.skill and self.skill.BossZeus_dx then
      caster.BossZeus_alreadyMove = true
      caster.position = ed.edpAdd(caster.position, {
        self.skill.BossZeus_dx,
        0
      })
    end
    self.affect_times = {}
    self.BossZeus_phase = "in"
  end
  if self.existTime >= BossZeus.atk6_tileTime and self.BossZeus_phase == "in" then
    self:terminate()
    if caster.BossZeus_invisibleBuff then
      caster:removeBuff(caster.BossZeus_invisibleBuff)
      caster.BossZeus_invisibleBuff = nil
    end
  end
end

function BossZeus.skillatk6_createProjectile(basefunc, skill)
  for code = 1, BossZeus.atk6_tileNum do
    local projectile = basefunc(skill)
    local caster = skill.caster
    local casterPos = caster and caster.position
    if casterPos then
      projectile.BossZeus_code = code
      local direction = BossZeus.atk6_directionList[code] or {0, 0}
      local x_coefLeft = math.min(200, casterPos[1] - ed.engine.stage_rect.minX) / 200
      local x_coefRight = math.min(200, ed.engine.stage_rect.maxX - casterPos[1]) / 200
      local x_coef = math.min(x_coefLeft, x_coefRight)
      local temp = direction[1]
      if direction[1] > 0 and x_coefLeft >= x_coefRight then
        direction[1] = x_coef * direction[1]
      elseif direction[1] < 0 and x_coefLeft < x_coefRight then
        direction[1] = x_coef * direction[1]
      end
      projectile.BossZeus_targetPos = ed.edpAdd(casterPos, direction)
      direction[1] = temp
    end
    projectile.BossZeus_phase = "out"
    local time = projectile.existTime or 0
    local time_remaining = BossZeus.atk6_tileHalfTime - time
    local speedCoef = (2 * BossZeus.atk6_tileHalfTime - time) / BossZeus.atk6_tileHalfTime
    if projectile.BossZeus_targetPos then
      local targetPosVector = ed.edpSub(projectile.BossZeus_targetPos, casterPos)
      projectile.velocity = ed.edpMult(targetPosVector, speedCoef / time_remaining)
    end
    projectile.update = override(projectile.update, BossZeus.skillatk6projectile_update)
    projectile.height = 1
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function BossZeus.init_hero(hero)
  hero.reset = override(hero.reset, BossZeus.reset)
  hero.update = override(hero.update, BossZeus.update)
  local skillatk2 = hero.skills[BossZeus.name .. "_atk2"]
  local skillatk3 = hero.skills[BossZeus.name .. "_atk3"]
  local skillatk4 = hero.skills[BossZeus.name .. "_atk4"]
  local skillatk5 = hero.skills[BossZeus.name .. "_atk5"]
  local skillatk6 = hero.skills[BossZeus.name .. "_atk6"]
  local skillatk7 = hero.skills[BossZeus.name .. "_atk7"]
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, BossZeus.skillatk2_takeEffectOn)
    skillatk2.createChain = override(skillatk2.createChain, BossZeus.skillatk2_createChain)
  end
  if skillatk3 then
    skillatk3.power = override(skillatk3.power, BossZeus.skillatk3_power)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, BossZeus.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, BossZeus.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, BossZeus.skillatk4_power)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, BossZeus.skillatk4_takeEffectOn)
  end
  if skillatk5 then
    skillatk5.start = override(skillatk5.start, BossZeus.skillatk5_start)
    skillatk5.onAttackFrame = override(skillatk5.onAttackFrame, BossZeus.skillatk5_onAttackFrame)
    skillatk5.finish = override(skillatk5.finish, BossZeus.skillatk5_finish)
  end
  if skillatk7 then
    skillatk7.power = override(skillatk7.power, BossZeus.skillatk7_power)
    skillatk7.createBuff = override(skillatk7.createBuff, BossZeus.skillatk7_createBuff)
    skillatk7.takeEffectOn = override(skillatk7.takeEffectOn, BossZeus.skillatk7_takeEffectOn)
  end
  if skillatk6 then
    skillatk6.start = override(skillatk6.start, BossZeus.skillatk6_start)
    skillatk6.onAttackFrame = override(skillatk6.onAttackFrame, BossZeus.skillatk6_onAttackFrame)
    skillatk6.createProjectile = override(skillatk6.createProjectile, BossZeus.skillatk6_createProjectile)
  end
  return hero
end

return BossZeus.init_hero
