module("ed.battlehero", package.seeall)
local ed = ed
WorldMars = {}
WorldMars.ragelosthp = 35000
WorldMars.rage2losthp = 15000
WorldMars.stage2hp = 1750000
WorldMars.stage2ragelosthp = 7500

function WorldMars.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldMars.skillatk_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  local ran = ed.rand()
  if ran < 0.5 then
    self:startPhase(1)
  else
    self:startPhase(2)
  end
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function WorldMars.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function WorldMars.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  local rageBuff_rank = hero.rageStack
  if damage_type == "AD" then
    local skillatk3 = hero.skills.WorldMars_atk3
    if skillatk3 and lost and 0 < lost and source and 0 > hero.direction * (hero.position[1] - source.position[1]) then
      local resist_value = skillatk3.info["Script Arg2"] / 100
      if rageBuff_rank then
        resist_value = resist_value + rageBuff_rank * 0.25 * 0.01
      end
      if ed.run_with_scene then
        local effect = "eff_impact_TitanMars_atk3.cha"
        local origin = hero.position
        ed.scene:playEffectOnScene(effect, origin, {
          hero.direction * -1,
          0.85
        }, nil, 0)
      end
      local parry = lost * resist_value
      lost = lost - parry
      hero:setMP(hero.mp + 30)
    end
  end
  return lost
end

function WorldMars.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldMars.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldMars.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.WorldMars_atk4
  local ad = skillatk4.info["Script Arg2"]
  local arm = skillatk4.info["Script Arg3"]
  local mr = skillatk4.info["Script Arg4"]
  local bid = 4353
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("AD", ad)
  buff:setAttribute("ARM", arm)
  buff:setAttribute("MR", mr)
  caster:addBuff(buff, caster)
  basefunc(skill)
  if ed.run_with_scene then
    local effect_name = "eff_impact_TitanMars_atk4.cha"
    local direction = caster:getInitDir()
    ed.scene:playEffectOnScene(effect_name, caster.position, {direction, 1}, nil, 0)
  end
end

function WorldMars.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  print("WorldMars_ultTraget_1 = " .. skill.target.name)
  projectile.update = override(projectile.update, WorldMars.projectile_update)
  projectile.hit = override(projectile.hit, WorldMars.projectile_hit)
  projectile.terminate = override(projectile.terminate, WorldMars.projectile_Terminate)
  return projectile
end

function WorldMars.skillult_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4357
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function WorldMars.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4357 then
      tbuff.timer = -1
    end
  end
end

function WorldMars.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if ed.run_with_scene and projectile.actor then
    projectile.actor.ownScaleX = 0.66
    projectile.actor.ownScaleY = 0.66
  end
  projectile.zSpeed = projectile.zSpeed - projectile.skill.info["Tile Gravity"] * dt
  local dv = 600 * dt
  local target = projectile.skill.target
  if not target then
    return
  end
  target = target.position
  local xySpeed = projectile.velocity
  local zSpeed = projectile.zSpeed
  local v = {
    xySpeed[1],
    xySpeed[2],
    zSpeed
  }
  local targetxyV = ed.edpSub(target, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  if zSpeed and dv < zSpeed then
    projectile.zSpeed = projectile.zSpeed - dv
    dv = 0
  elseif zSpeed and 0 < zSpeed then
    dv = dv - zSpeed
    projectile.zSpeed = 0
  end
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * dv * 8
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * dv * 8
  projectile.zSpeed = projectile.zSpeed + targetV[3] * dv * 8
end

function WorldMars.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  local skillults = caster.skills.WorldMars_ults
  local skillults_target
  local maxPriority = 999
  if target and target == skill.target then
    basefunc(projectile, target)
    caster.WorldMars_ult_target = target
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buff_effects.enchanted then
      elseif math.abs(target.position[1] - unit.position[1]) > 120 then
      elseif caster.direction * (unit.position[1] - target.position[1]) < 0 then
      elseif unit == target then
      elseif math.abs(target.position[2] - unit.position[2]) > 100 then
      else
        local priority = math.abs(target.position[1] - unit.position[1])
        if maxPriority > priority then
          maxPriority = priority
          skillults_target = unit
        end
      end
    end
  else
    target = skill.target
    basefunc(projectile, target)
    caster.WorldMars_ult_target = target
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buff_effects.enchanted then
      elseif math.abs(target.position[1] - unit.position[1]) > 120 then
      elseif caster.direction * (unit.position[1] - target.position[1]) < 0 then
      elseif unit == target then
      elseif math.abs(target.position[2] - unit.position[2]) > 100 then
      else
        local priority = math.abs(target.position[1] - unit.position[1])
        if maxPriority > priority then
          maxPriority = priority
          skillults_target = unit
        end
      end
    end
  end
  if skillults_target and skillults then
    skillults:takeEffectOn(skillults_target, caster)
  end
  if not projectile.terminated then
    projectile:terminate()
  end
end

function WorldMars.projectile_Terminate(basefunc, self)
  local caster = self.caster
  local skillults2 = caster.skills.WorldMars_ults2
  local WorldMars_region
  if caster.name == "WorldMars" and caster.WorldMars_ult_target then
    skillults2.target = caster.WorldMars_ult_target
    WorldMars_region = skillults2:createRegion()
    WorldMars_region.terminate = override(WorldMars_region.terminate, WorldMars.WorldMars_region_terminate)
    caster.WorldMars_region = WorldMars_region
    ed.engine:addRegion(WorldMars_region)
    caster.WorldMars_ult_target = nil
    if WorldMars_region.position and ed.run_with_scene then
      local effect_name = "eff_buff_TitanMars_ult.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, WorldMars_region.position, {
        caster.direction,
        1
      }, nil, 0)
      ed.scene:startCameraShakeAnimationY(5, 0.2, 5)
      caster.ult_region_effect = effect
    end
  end
  basefunc(self)
end

function WorldMars.WorldMars_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  if caster.WorldMars_region then
    caster.WorldMars_region = nil
  end
  if caster.ult_region_effect then
    local z = 0
    ed.scene:removeEffect(caster.ult_region_effect, z)
  end
end

function WorldMars.getRuntimeScale(basefunc, self)
  if self.isScaleActionRunning then
    local dt = self.dt_action
    self.scaleActionRunningTime = self.scaleActionRunningTime + dt
    if self.scaleActionRunningTime > self.scaleActionDuration then
      local scale = self.scaleActionScaleValue
      return self.direction * scale, scale
    else
      local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
      return self.direction * scale, scale
    end
  end
  if not self.isScaleActionRunning then
    local m = self.manually_casting
    return self.direction * (m and 1.05 or 1), m and 1.05 or 1
  end
end

function WorldMars.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local caster = skill.caster
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local ret, dmg = basefunc(skill, target, source)
  return ret, dmg
end

function WorldMars.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  return buff
end

function WorldMars.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4357
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function WorldMars.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4357 then
      tbuff.timer = -1
    end
  end
end

function WorldMars.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldMars.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldMars.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldMars.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldMars.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldMars.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldMars.init_hero(hero)
  local skillult = hero.skills.WorldMars_ult
  local skillatk = hero.skills.WorldMars_atk
  local skillatk2 = hero.skills.WorldMars_atk2
  local skillatk3 = hero.skills.WorldMars_atk3
  local skillatk4 = hero.skills.WorldMars_atk4
  local skillatk5 = hero.skills.WorldMars_atk5
  hero.WorldMars_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.reset = override(hero.reset, WorldMars.hero_reset)
  hero.update = override(hero.update, WorldMars.hero_update)
  if skillatk then
    skillatk.start = override(skillatk.start, WorldMars.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, WorldMars.skillatk_onPhaseFinished)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldMars.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldMars.getLostHPAfterImmunity)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, WorldMars.skillatk4_onAttackFrame)
    skillatk4.createBuff = override(skillatk4.createBuff, WorldMars.skillatk4_createBuff)
    skillatk4.start = override(skillult.start, WorldMars.skillatk4_start)
    skillatk4.finish = override(skillult.finish, WorldMars.skillatk4_finish)
  end
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, WorldMars.skillult_createProjectile)
    hero.getRuntimeScale = override(hero.getRuntimeScale, WorldMars.getRuntimeScale)
    skillult.start = override(skillult.start, WorldMars.skillult_start)
    skillult.finish = override(skillult.finish, WorldMars.skillult_finish)
  end
  return hero
end

return WorldMars.init_hero
