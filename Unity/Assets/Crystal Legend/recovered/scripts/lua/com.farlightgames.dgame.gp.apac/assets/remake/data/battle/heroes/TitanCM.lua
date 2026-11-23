module("ed.battlehero", package.seeall)
local ed = ed
TitanCM = {}
TitanCM.HealTick = 0.75
TitanCM.blackholeBuff = 1553
TitanCM.blackholeStealth = 1551
TitanCM.blackHoleDest = 50
TitanCM.blackHoleRange = 75
TitanCM.blackHoleOutTime = 5
TitanCM.blackHoleTick = 0
TitanCM.blackHoleCheck = 1
TitanCM.blackHoleStayTime = 5
TitanCM.blackHoleStayRange = 100
TitanCM.blackholeBackSpeedupTime = 5
TitanCM.blackholeBackTime = 8
TitanCM.blackhole_r = 30
TitanCM.skillFashionId = 100811

function TitanCM.skillatk2_CreateBuff(basefunc, self, target)
  local buff = basefunc(self, target)
  buff.update = override(buff.update, TitanCM.skillatk2_buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanCM.skillatk2_buff_onRemoved)
  return buff
end

function TitanCM.skillatk2_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  caster.heal_time = 0
end

function TitanCM.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanCM_atk2
  local skillatk2b = caster.skills.TitanCM_atk2b
  local fashionId = caster.fashion_id
  if skillatk2b then
    skillatk2b.HP_change = 0
    skillatk2b.Orgi_HP = target.attribs.HP
  end
  if skillatk2b.HP_change > 0 then
    skillatk2b.HP_change = skillatk2b.HP_change
  end
  basefunc(skill, target)
end

function TitanCM.skillatk2_buff_update(basefunc, self, dt)
  local buff = self
  local target = buff.owner
  local caster = buff.caster
  local skillatk2b = caster.skills.TitanCM_atk2b
  local skillatk4 = caster.skills.TitanCM_atk4
  caster.heal_time = caster.heal_time + dt
  if skillatk2b and target:isAlive() and caster.heal_time % TitanCM.HealTick == 0 then
    caster.atk2_target = target
    skillatk2b:takeEffectOn(target, caster)
  end
  basefunc(self, dt)
end

function TitanCM.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local fashionId = caster.fashion_id
  if power and fashionId and fashionId == TitanCM.skillFashionId then
    caster.fashion_healPower = power * 0.65
    if caster.fashion_healPower then
      caster:takeHeal(caster.fashion_healPower, "hp", caster)
    end
  end
  return power
end

function TitanCM.skillatk2b_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanCM_atk2
  local skillatk2b = caster.skills.TitanCM_atk2b
  local heal = caster.attribs.HEAL or 0
  local power, coefficient = skill:power(source, target, "Heal")
  local power = power * (1 + heal / 100)
  local amount = power * (math.max((target.attribs.HealRatio or 0) / 100, -1) + 1)
  local target = caster.atk2_target
  local havebuff = false
  local HPbuff
  for _, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 1547 then
      HPbuff = tbuff
      havebuff = true
    end
  end
  if target and target.hp + amount >= target.attribs.HP then
    local max = skillatk2.info["Script Arg2"] * caster.Skillatk2_HP
    local MaxHP_time = skillatk2.info["Script Arg4"]
    if havebuff then
      if skillatk2b.HP_change then
        skillatk2b.HP_change = skillatk2b.HP_change + amount
        if max < skillatk2b.HP_change then
          skillatk2b.HP_change = max
        end
        HPbuff:setAttribute("HP", skillatk2b.HP_change)
        HPbuff.timer = MaxHP_time
        target:rebuild()
      end
    else
      local bid = 1547
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local HPbuff = ed.BuffCreate(binfo, target, caster)
      HPbuff.onRemoved = override(HPbuff.onRemoved, TitanCM.atk2_HPbuff_onRemoved)
      if HPbuff then
        HPbuff.timer = MaxHP_time
        HPbuff:setAttribute("Time", MaxHP_time)
        if skillatk2b.HP_change then
          skillatk2b.HP_change = target.hp + amount - target.attribs.HP
          if max < skillatk2b.HP_change then
            skillatk2b.HP_change = max
          end
          HPbuff:setAttribute("HP", skillatk2b.HP_change)
          target:addBuff(HPbuff, caster)
          target:rebuild()
          target:setHP(target.hp + skillatk2b.HP_change)
        end
      end
    end
  end
  basefunc(skill, target)
end

function TitanCM.atk2_HPbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk2b = caster.skills.TitanCM_atk2b
  skillatk2b.HP_change = 0
end

function TitanCM.isNearDest(posStart, posDest, range)
  local disX = posStart[1] - posDest[1]
  local disY = posStart[2] - posDest[2]
  if disX * disX + disY * disY <= range * range then
    return true
  else
    return false
  end
end

function TitanCM.BlackHole_collideCheck(basefunc, projectile, unit)
  local NearDest = TitanCM.isNearDest(projectile.position, unit.position, TitanCM.blackHoleRange)
  return NearDest
end

function TitanCM.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter then
    caster.atk3_counter = attack_counter
  end
  if attack_counter == 0 then
    local BlackHole = skill:createProjectile()
    ed.engine:addProjectile(BlackHole)
  end
  basefunc(skill)
end

function TitanCM.skillatk3_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local enemy_count = 0
  if caster:isAlive() then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit:isAlive() then
        enemy_count = enemy_count + 1
      end
    end
    if 1 < enemy_count then
      return basefunc(skill, target)
    else
      return false
    end
  end
end

function TitanCM.skillatk3_CreateProjectile(basefunc, skill)
  local blackhole = basefunc(skill)
  local caster = skill.caster
  local skillatk3b = caster.skills.TitanCM_atk3b
  caster.atk3_projectile = blackhole
  if skillatk3b then
    skillatk3b.target = blackhole
    local skillatk3b_DragRegion = skillatk3b:createRegion()
    skillatk3b_DragRegion.position = blackhole.position
    ed.engine:addRegion(skillatk3b_DragRegion)
  end
  blackhole.attackTime = 0
  blackhole.OrigV = blackhole.velocity
  caster.DragEnemy = false
  blackhole.collideCheck = override(blackhole.collideCheck, TitanCM.BlackHole_collideCheck)
  blackhole.update = override(blackhole.update, TitanCM.skillatk3_blackholeupdate)
  blackhole.isOut = true
  blackhole.isDrag = false
  blackhole.isBack = false
  blackhole.theDest = skill.target.position
  return blackhole
end

function TitanCM.skillatk3b_CreateRegion(basefunc, skill)
  local DragRegion = basefunc(skill)
  DragRegion.update = override(DragRegion.update, TitanCM.DragRegion_update)
  return DragRegion
end

function TitanCM.DragRegion_update(basefunc, region, dt)
  local caster = region.caster
  if caster.blackholePosition then
    region.position = caster.blackholePosition
  end
  caster.atk3_region_position = region.position
  if not caster:isAlive() or caster.blackhole_ismov == false then
    region:terminate()
  end
  basefunc(region, dt)
end

function TitanCM.skillatk3b_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanCM.skillatk3bBuff_update)
  buff.blackHoleTick = TitanCM.blackHoleTick
  return buff
end

function TitanCM.skillatk3bBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.blackHoleTick = buff.blackHoleTick - 1
  local caster = buff.caster
  local owner = buff.owner
  local region_position = caster.atk3_region_position
  local time = 0.035
  local distance = -2
  local distanceplus = 0
  local distance_last = -2
  local direction = {1, 0}
  local DistanceSQ = ed.edpDistanceSQ(owner.position, region_position)
  if caster.blackhole_ismov == true and buff.blackHoleTick < 0 then
    if owner.position[1] == region_position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    elseif DistanceSQ < TitanCM.blackhole_r * TitanCM.blackhole_r then
      local directionold = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      direction[1] = -directionold[2]
      direction[2] = directionold[1]
      distance_last = distance + distanceplus
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = distance + distanceplus * (75 - math.sqrt(DistanceSQ)) / (75 - TitanCM.blackhole_r)
    end
    owner:knockup(time, ed.edpMult(direction, distance_last), true)
    buff.blackHoleTick = TitanCM.blackHoleTick
  end
end

function TitanCM.skillatk3_blackholeupdate(basefunc, projectile, dt)
  local caster = projectile.caster
  local skill = projectile.skill
  local OrigV = projectile.OrigV
  projectile.attackTime = projectile.attackTime + dt
  if projectile.attackTime <= 1 then
    projectile.velocity = {0.01, 0}
  else
    projectile.velocity = OrigV
  end
  caster.blackholePosition = projectile.position
  if ed.run_with_scene and projectile.actor then
    projectile.actor.ownRotation = 0
    projectile.actor.ownScaleX = 1 * caster.direction
    projectile.actor.ownScaleY = 1
  end
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  if projectile.isOut then
    caster.blackhole_ismov = true
    TitanCM.blackhole_update_isOut(basefunc, projectile, dt)
  end
  if projectile.isDrag then
    caster.blackhole_ismov = false
    TitanCM.blackhole_update_isDrag(basefunc, projectile, dt)
  end
  if projectile.isBack then
    caster.blackhole_ismov = false
    TitanCM.blackhole_update_isBack(basefunc, projectile, dt)
  end
  if not projectile.skill.caster:isAlive() and not projectile.terminated then
    projectile:terminate()
  end
end

function TitanCM.BlackholeProjectile_back(projectile)
  projectile.isOut = false
  projectile.isDrag = false
  projectile.isBack = true
  projectile.affect_times = {}
end

function TitanCM.blackhole_update_isOut(basefunc, projectile, dt)
  local skill = projectile.skill
  local caster = skill.caster
  local target = skill.target
  if not projectile.outTime then
    projectile.outTime = 0
  end
  projectile.outTime = projectile.outTime + dt
  if projectile.outTime > TitanCM.blackHoleStayTime and not projectile.terminated then
    TitanCM.BlackholeProjectile_back(projectile)
    return
  end
  local pos = projectile.position
  local v = projectile.velocity
  local x = pos[1] + v[1] * 0.125
  local y = pos[2] + v[2] * 0.125
  local rect = ed.engine.stage_rect
  if x < rect.minX or x > rect.maxX or y < rect.minY or y > rect.maxY then
    TitanCM.BlackholeProjectile_back(projectile)
    return
  end
  local nowPosition = projectile.position
  local destPosition = projectile.theDest
  local havePeople = false
  if TitanCM.isNearDest(nowPosition, destPosition, TitanCM.blackHoleDest) then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
      else
        if TitanCM.isNearDest(nowPosition, unit.position, TitanCM.blackHoleRange) then
          havePeople = true
        else
        end
      end
      if havePeople then
        break
      end
    end
    if havePeople then
      projectile.isOut = false
      projectile.isDrag = true
      projectile.isBack = false
      return
    else
      TitanCM.BlackholeProjectile_back(projectile)
      return
    end
  end
  basefunc(projectile, dt)
end

function TitanCM.blackhole_update_isDrag(basefunc, projectile, dt)
  projectile.velocity = {0.1, 0}
  local skill = projectile.skill
  local caster = projectile.caster
  local withinRange = false
  local skillatk3 = caster.skills.TitanCM_atk3
  local atk3_HPR = -skillatk3.info["Script Arg2"]
  local atk3_MPR = -skillatk3.info["Script Arg3"]
  local skillatk3c = caster.skills.TitanCM_atk3c
  if not projectile.DragTime then
    projectile.DragTime = 0
    projectile.lastDragTime = 0
  end
  projectile.DragTime = projectile.DragTime + dt
  projectile.lastDragTime = projectile.lastDragTime + dt
  if projectile.DragTime > TitanCM.blackHoleStayTime and not projectile.terminated then
    TitanCM.BlackholeProjectile_back(projectile)
    return
  end
  if projectile.lastDragTime >= TitanCM.blackHoleCheck then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if not unit.config.is_summoned and not unit.buffManager.invisible and TitanCM.isNearDest(unit.position, projectile.position, TitanCM.blackHoleRange) then
        withinRange = true
        break
      end
    end
    if withinRange then
      local nearest_Unit
      local min_dis = TitanCM.blackHoleRange
      for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
        if not unit.config.is_summoned or unit.config.is_summoned and unit.config.summoner and unit.attribs.HP >= unit.config.summoner.attribs.HP * 0.5 and not unit.buffManager.invisible then
          local unit_dis = math.abs(math.sqrt((unit.position[1] - projectile.position[1]) ^ 2 + (unit.position[2] - projectile.position[2]) ^ 2))
          if min_dis > unit_dis then
            nearest_Unit = unit
            min_dis = unit_dis
          end
        end
      end
      if projectile.DragTime == 2 and nearest_Unit and nearest_Unit:isAlive() and not nearest_Unit.config.is_boss and not nearest_Unit.buffManager.invisible and caster.DragEnemy == false then
        caster.atk3_nearest_Unit = nearest_Unit
        skillatk3c:takeEffectOn(nearest_Unit, caster)
        caster.DragEnemy = true
      end
      if caster.DragEnemy == true then
        projectile:terminate()
        if ed.run_with_scene then
          local effect_name = "eff_impact_TitanCM_atk3_2.cha"
          local effect = ed.scene:playEffectOnScene(effect_name, projectile.position, {
            caster.direction * 1,
            1
          }, nil, -1)
        end
      end
    else
      TitanCM.BlackholeProjectile_back(projectile)
      return
    end
    projectile.lastDragTime = 0
  end
end

function TitanCM.blackhole_update_isBack(basefunc, projectile, dt)
  local caster = projectile.caster
  if not projectile:terminate() then
    projectile:terminate()
    if ed.run_with_scene then
      local effect_name = "eff_impact_TitanCM_atk3_2.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, projectile.position, {
        caster.direction * 1,
        1
      }, nil, -1)
    end
  end
end

function TitanCM.DragTargetSamll_update(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local actor = owner.actor
  local prison_id = 1554
  local prison_info = ed.lookupDataTable("Buff", nil, prison_id)
  local prison_buff = ed.BuffCreate(prison_info, owner, caster)
  buff.SmallTime = buff.SmallTime + dt
  if buff.SmallTime == 0.25 then
    owner:addBuff(prison_buff, caster)
  end
  if buff.SmallTime == 1 then
    local skillatk3 = caster.skills.TitanCM_atk3
    local atk3_HPR = -skillatk3.info["Script Arg2"]
    local atk3_MPR = -skillatk3.info["Script Arg3"]
    if owner and caster:isAlive() then
      local BHprison_id = 1553
      local BHprison_info = ed.lookupDataTable("Buff", nil, BHprison_id)
      local BHprison_buff = ed.BuffCreate(BHprison_info, owner, caster)
      caster.prison_flag = false
      BHprison_buff.update = override(BHprison_buff.update, TitanCM.BHprison_update)
      BHprison_buff.onRemoved = override(BHprison_buff.onRemoved, TitanCM.BHprison_onRemoved)
      BHprison_buff:setAttribute("HPR", atk3_HPR)
      BHprison_buff:setAttribute("MPR", atk3_MPR)
      owner:addBuff(BHprison_buff, caster)
    end
  end
  if actor then
    if buff.targetsmall[1] > 0.1 then
      buff.scale_id = actor:useScale(buff.targetsmall)
      buff.targetsmall[1] = buff.targetsmall[1] - dt
      buff.targetsmall[2] = buff.targetsmall[2] - dt
    else
      buff.scale_id = actor:useScale({1, 1})
    end
  end
  basefunc(buff, dt)
end

function TitanCM.BHprison_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner and caster then
    owner:setPosition({
      caster.targetOrigPosition[1],
      caster.targetOrigPosition[2]
    })
  end
end

function TitanCM.BHprison_onRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  if owner and caster then
    owner:setPosition({
      caster.targetOrigPosition[1],
      caster.targetOrigPosition[2]
    })
  end
  basefunc(buff)
end

function TitanCM.DragTargetSamll_onRemoved(basefunc, buff)
  buff.SmallTime = 0
  local owner = buff.owner
  local caster = buff.caster
  if owner and caster then
    owner:setPosition({
      caster.targetOrigPosition[1],
      caster.targetOrigPosition[2]
    })
  end
  basefunc(buff)
end

function TitanCM.skillatk3c_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local BlackHole = caster.atk3_projectile
  local dir
  local direction = {0, 1}
  local distance = 4
  local time = 0.007
  caster.targetOrigPosition = {
    target.position[1],
    target.position[2]
  }
  local dir = caster:getInitDir()
  target:knockup(time, ed.edpMult(direction, distance), false)
  local TargetSmall_id = 1550
  local TargetSmall_info = ed.lookupDataTable("Buff", nil, TargetSmall_id)
  local TargetSmall_buff = ed.BuffCreate(TargetSmall_info, target, caster)
  TargetSmall_buff.blackHoleTick = TitanCM.blackHoleTick
  TargetSmall_buff.targetsmall = {1, 1}
  TargetSmall_buff.SmallTime = 0
  TargetSmall_buff.update = override(TargetSmall_buff.update, TitanCM.DragTargetSamll_update)
  TargetSmall_buff.onRemoved = override(TargetSmall_buff.onRemoved, TitanCM.DragTargetSamll_onRemoved)
  target:addBuff(TargetSmall_buff, caster)
  basefunc(skill, target, source)
end

function TitanCM.hero_update(basefunc, self, dt)
  local skillatk = self.skills.TitanCM_atk
  local skillatk2 = self.skills.TitanCM_atk2
  local skillatk3 = self.skills.TitanCM_atk3
  local skillatk4 = self.skills.TitanCM_atk4
  local TitanCM_region
  if self.Start_time then
    self.Start_time = self.Start_time + dt
  end
  skillatk4.target = self
  if self:isAlive() then
    if skillatk4 and not self.TitanCM_region and not self.config.is_summoned and self.Start_time >= 1 then
      TitanCM_region = skillatk4:createRegion()
      self.TitanCM_region = TitanCM_region
      ed.engine:addRegion(TitanCM_region)
    end
    if self.TitanCM_region then
      self.TitanCM_region.position = self.position
    end
  end
  basefunc(self, dt)
end

function TitanCM.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local Stars = caster.stars
  local MPR = skill.info["Script Arg2"] * skill.level + caster.attribs.INT / 1000
  MPR = math.ceil(MPR + caster.stars)
  buff:setAttribute("MPR", MPR)
  return buff
end

function TitanCM.selectPosition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable then
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
    return ed.engine.stage_rect.maxX / 2
  end
end

function TitanCM.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanCM_ult
  local skillultb = caster.skills.TitanCM_ultb
  local skillPosition = TitanCM.selectPosition(skill, 600)
  local location = {}
  if skillPosition then
    location = {skillPosition, 0}
  else
    location = {
      400 * caster.direction,
      0
    }
  end
  if location[1] >= caster.position[1] then
    caster.direction = 1
  else
    caster.direction = -1
  end
  caster.ult_counter = 0
  basefunc(skill, target)
end

function TitanCM.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanCM_ult
  local skillultb = caster.skills.TitanCM_ultb
  local attack_counter = skill.attack_counter
  if caster:isAlive() and attack_counter == 0 and ed.run_with_scene then
    local effect_name = "eff_point_TitanCM_ult.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
      caster.direction * 1,
      1
    }, nil, -1)
  end
  if caster:isAlive() and attack_counter == 1 and ed.run_with_scene then
    local effect_name = "eff_point_TitanCM_ult2.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
      caster.direction * 1,
      1
    }, nil, 1)
  end
  if caster:isAlive() and 0 < attack_counter and attack_counter < 4 and caster.ult_counter then
    caster.ult_counter = attack_counter
    skillultb:takeEffectAt(caster.position, caster)
    caster.FinishUlt = false
  end
  if caster:isAlive() and attack_counter == 4 and caster.ult_counter then
    caster.ult_counter = attack_counter
    skillultb:takeEffectAt(caster.position, caster)
    caster.FinishUlt = true
  end
  basefunc(skill)
end

function TitanCM.skillultb_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillultb = caster.skills.TitanCM_ultb
  buff.update = override(buff.update, TitanCM.skillultb_buffUpdate)
  return buff
end

function TitanCM.skillultb_buffUpdate(basefunc, self, dt)
  local buff = self
  local caster = self.caster
  local skillultb = caster.skills.TitanCM_ultb
  local ultb_mpRatio = math.max(skillultb.info["Script Arg2"] * skillultb.level, -50)
  local ultb_mpgRatio = math.max(skillultb.info["Script Arg3"] * skillultb.level, -50)
  if caster.FinishUlt == true then
    buff:setAttribute("MPRatio", ultb_mpRatio * 2)
    buff:setAttribute("MPGRatio", ultb_mpgRatio * 2)
    buff.timer = 3
    caster.FinishUlt = false
  end
  basefunc(self, dt)
end

function TitanCM.TitanCM_skillallPower(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local power_Ratio = 0.01
  local power = power * power_Ratio
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function TitanCM.hero_die(basefunc, self, killer)
  if self.TitanCM_region then
    self.TitanCM_region:finish()
  end
  basefunc(self, killer)
end

function TitanCM.reset(basefunc, hero)
  basefunc(hero)
  hero.TitanCM_region = nil
  hero.heal_time = 0
  hero.Start_time = 0
  hero.Skillatk2_HP = hero.attribs.HP
  hero.ult_counter = 0
end

function TitanCM.init_hero(hero)
  local skillatk = hero.skills.TitanCM_atk
  local skillatk2 = hero.skills.TitanCM_atk2
  local skillatk3 = hero.skills.TitanCM_atk3
  local skillatk4 = hero.skills.TitanCM_atk4
  local skillatk2b = hero.skills.TitanCM_atk2b
  local skillatk3b = hero.skills.TitanCM_atk3b
  local skillatk3c = hero.skills.TitanCM_atk3c
  local skillult = hero.skills.TitanCM_ult
  local skillultb = hero.skills.TitanCM_ultb
  local fashionId = hero.fashion_id
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanCM.skillatk2_CreateBuff)
    skillatk2.start = override(skillatk2.start, TitanCM.skillatk2_start)
    if fashionId and fashionId == TitanCM.skillFashionId then
      skillatk2.power = override(skillatk2.power, TitanCM.skillatk2_power)
    end
  end
  if skillatk2b then
    skillatk2b.takeEffectOn = override(skillatk2b.takeEffectOn, TitanCM.skillatk2b_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanCM.skillatk3_CreateProjectile)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanCM.skillatk3_onAttackFrame)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, TitanCM.skillatk3_canCastWithTarget)
  end
  if skillatk3b then
    skillatk3b.createRegion = override(skillatk3b.createRegion, TitanCM.skillatk3b_CreateRegion)
    skillatk3b.createBuff = override(skillatk3b.createBuff, TitanCM.skillatk3b_createBuff)
  end
  if skillatk3c then
    skillatk3c.takeEffectOn = override(skillatk3c.takeEffectOn, TitanCM.skillatk3c_takeEffectOn)
  end
  if skillatk4 then
    hero.update = override(hero.update, TitanCM.hero_update)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanCM.skillatk4_CreateBuff)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanCM.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanCM.skillult_onAttackFrame)
  end
  if skillultb then
    skillultb.createBuff = override(skillultb.createBuff, TitanCM.skillultb_CreateBuff)
  end
  hero.die = override(hero.die, TitanCM.hero_die)
  hero.reset = override(hero.reset, TitanCM.reset)
  return hero
end

return TitanCM.init_hero
