module("ed.battlehero", package.seeall)
local ed = ed
WorldLvBu = {}
WorldLvBu.ragelosthp = 35000
WorldLvBu.rage2losthp = 15000
WorldLvBu.stage2hp = 1750000
WorldLvBu.stage2ragelosthp = 7500

function WorldLvBu.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local enhance_value = 1
  if owner.WorldLvBu_buff1 then
    local n = 0
    for unit in ed.engine:foreachAliveUnit(-owner.camp) do
      if unit.info.Gender == T("\229\165\179") and unit.info["Unit Type"] == "Hero" and not unit.config.is_summoned then
        n = n + 1
      end
    end
    enhance_value = 0.82 ^ math.min(n, 5)
  end
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1 * enhance_value)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1 * enhance_value)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1 * enhance_value)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1 * enhance_value)
    buff:setAttribute("CRIT", 50 * owner.rageStack * enhance_value)
    buff:setAttribute("MCRIT", 10 * owner.rageStack * enhance_value)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50) * enhance_value)
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50) * enhance_value)
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2 * enhance_value)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2 * enhance_value)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2 * enhance_value)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2 * enhance_value)
      buff:setAttribute("CRIT", 50 * owner.rageStack * enhance_value)
      buff:setAttribute("MCRIT", 10 * owner.rageStack * enhance_value)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldLvBu.skillatk_start(basefunc, self, target)
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

function WorldLvBu.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function WorldLvBu.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.WorldLvBu_buff2 then
    if 0 < lost and damage_type == "AP" then
      lost = lost * 2.28
    end
    if 0 < lost and damage_type == "AD" then
      lost = lost * 0.12
    end
  end
  if hero.WorldLvBu_buff3 and 0 < lost and source and source.info["Position Type"] == T("\229\144\142\230\142\146") then
    lost = lost * 2.28
  end
  if hero.WorldLvBu_buff4 and 0 < lost and source and source.fashion_id and (source.fashion_id == 531 or source.fashion_id == 722 or source.fashion_id == 101101 or source.fashion_id == 101102) then
    lost = lost * 3.88
  end
  if hero.WorldLvBu_buff5 then
    local fashion_add
    for unit in ed.engine:foreachAliveUnit(-hero.camp) do
      if unit.fashion_id and not unit.config.is_summoned and unit.fashion_id == 101101 then
        fashion_add = true
      end
    end
    if 0 < lost and fashion_add then
      lost = lost * 2.88
    end
  end
  return lost
end

function WorldLvBu.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldLvBu.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldLvBu.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  if ed.run_with_scene then
    local effect_name = "eff_impact_TitanMars_atk4_fashion_2.cha"
    local direction = caster:getInitDir()
    ed.scene:playEffectOnScene(effect_name, caster.position, {direction, 1}, nil, 0)
  end
end

function WorldLvBu.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, WorldLvBu.projectile_update)
  projectile.hit = override(projectile.hit, WorldLvBu.projectile_hit)
  projectile.terminate = override(projectile.terminate, WorldLvBu.projectile_Terminate)
  return projectile
end

function WorldLvBu.skillult_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4357
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function WorldLvBu.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4357 then
      tbuff.timer = -1
    end
  end
end

function WorldLvBu.projectile_update(basefunc, projectile, dt)
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

function WorldLvBu.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target and target == skill.target then
    basefunc(projectile, target)
    caster.WorldLvBu_ult_target = target
  else
    target = skill.target
    basefunc(projectile, target)
    caster.WorldLvBu_ult_target = target
  end
  if not projectile.terminated then
    projectile:terminate()
  end
end

function WorldLvBu.projectile_Terminate(basefunc, self)
  local caster = self.caster
  local skillults2 = caster.skills.WorldLvBu_ults2
  local WorldLvBu_region
  if caster.name == "WorldLvBu" and caster.WorldLvBu_ult_target then
    skillults2.target = caster.WorldLvBu_ult_target
    WorldLvBu_region = skillults2:createRegion()
    WorldLvBu_region.terminate = override(WorldLvBu_region.terminate, WorldLvBu.WorldLvBu_region_terminate)
    caster.WorldLvBu_region = WorldLvBu_region
    ed.engine:addRegion(WorldLvBu_region)
    caster.WorldLvBu_ult_target = nil
    if WorldLvBu_region.position and ed.run_with_scene then
      local effect_name = "eff_buff_TitanMars_ult_fashion_1.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, WorldLvBu_region.position, {
        caster.direction,
        1
      }, nil, 0)
      ed.scene:startCameraShakeAnimationY(5, 0.2, 5)
      caster.ult_region_effect = effect
    end
  end
  basefunc(self)
end

function WorldLvBu.WorldLvBu_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  if caster.WorldLvBu_region then
    caster.WorldLvBu_region = nil
  end
  if caster.ult_region_effect then
    local z = 0
    ed.scene:removeEffect(caster.ult_region_effect, z)
  end
end

function WorldLvBu.getRuntimeScale(basefunc, self)
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

function WorldLvBu.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local caster = skill.caster
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local ret, dmg = basefunc(skill, target, source)
  return ret, dmg
end

function WorldLvBu.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4357
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function WorldLvBu.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4357 then
      tbuff.timer = -1
    end
  end
end

function WorldLvBu.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldLvBu.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldLvBu.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLvBu.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldLvBu.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLvBu.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldLvBu.init_hero(hero)
  local skillult = hero.skills.WorldLvBu_ult
  local skillatk = hero.skills.WorldLvBu_atk
  local skillatk2 = hero.skills.WorldLvBu_atk2
  local skillatk3 = hero.skills.WorldLvBu_atk3
  hero.reset = override(hero.reset, WorldLvBu.hero_reset)
  hero.update = override(hero.update, WorldLvBu.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldLvBu.getLostHPAfterImmunity)
  if skillatk then
    skillatk.start = override(skillatk.start, WorldLvBu.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, WorldLvBu.skillatk_onPhaseFinished)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldLvBu.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldLvBu.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, WorldLvBu.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, WorldLvBu.skillatk3_finish)
  end
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, WorldLvBu.skillult_createProjectile)
    hero.getRuntimeScale = override(hero.getRuntimeScale, WorldLvBu.getRuntimeScale)
    skillult.start = override(skillult.start, WorldLvBu.skillult_start)
    skillult.finish = override(skillult.finish, WorldLvBu.skillult_finish)
  end
  return hero
end

return WorldLvBu.init_hero
