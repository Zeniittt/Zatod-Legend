module("ed.battlehero", package.seeall)
local ed = ed
WorldTusk = {}
WorldTusk.velocity = 180
WorldTusk.base = ed.Entity
WorldTusk.enchbuff = 10038312
WorldTusk.ragelosthp = 35000
WorldTusk.rage2losthp = 15000
WorldTusk.stage2hp = 1750000
WorldTusk.stage2ragelosthp = 7500

function WorldTusk.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.WorldTusk_atk4
  if skillatk4 then
    hero.WorldTuskAtk4Time = 10
    hero.WorldTuskStayTime = 0
    hero.WorldTuskAtk4Crit = false
    hero.havedonecrit = false
  end
  hero.WorldTuskUltTarget = nil
  hero.WorldTuskUltMoving = nil
  hero.WorldTusk_firstin = true
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldTusk.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldTusk.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.05)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.05)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
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

function WorldTusk.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local skillatk2s = hero.skills.WorldTusk_atk2s
  if attack_counter == 3 then
    local target = skillatk2s:selectTarget(nil)
    if target then
      local projectile = skillatk2s:createProjectile()
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
  end
end

function WorldTusk.skillatk2s_createProjectile(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  local projectile = basefunc(skill, target)
  projectile.position = {
    caster.position[1] + caster.direction * 40,
    caster.position[2] - 10
  }
  projectile.height = 115
  if target then
    projectile:enableTrack(target)
  end
  ed.engine:addProjectile(projectile)
end

function WorldTusk.skillatk2and3_createProjectile(basefunc, skill)
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile:enableTrack(target)
  ed.engine:addProjectile(projectile)
end

function WorldTusk.skillatk4_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local hero = skill.caster
  if hero.WorldTuskAtk4Crit then
    skill.info["Do Crit"] = "YES"
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
    for i, buff in ipairs(hero.buff_list) do
      if buff.info.ID == 11001107 and buff.caster == hero then
        buff.timer = 0
      end
    end
    hero.havedonecrit = true
  else
    skill.info["Do Crit"] = nil
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg
end

function WorldTusk.hero_getRuntimeScale(basefunc, hero)
  return hero.direction, 1
end

function WorldTusk.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  hero.WorldTuskUltPos = {
    hero.position[1],
    hero.position[2]
  }
end

function WorldTusk.skillult_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local bid = 11001108
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
    basefunc(skill)
  end
end

function WorldTusk.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local hero = projectile.skill.caster
  local target = hero.WorldTuskUltTarget
  if not target or target and (target.buff_effects.untargetable or not target:isAlive()) then
    hero.WorldTuskUltTarget = projectile.skill:selectTarget(target)
    if not hero.WorldTuskUltTarget or hero.WorldTuskUltTarget and (hero.WorldTuskUltTarget.buff_effects.untargetable or not hero.WorldTuskUltTarget:isAlive()) then
      projectile:terminate()
    end
  end
  if hero.WorldTuskUltTarget then
    local targetpos = hero.WorldTuskUltTarget.position
    local targetxyV = ed.edpSub(targetpos, projectile.position)
    local targetzV = -projectile.height + 40
    local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
    local targetV = {
      targetxyV[1] * u,
      targetxyV[2] * u,
      targetzV * u
    }
    if not projectile.targetxyV then
      projectile.targetxyV = targetxyV
    elseif projectile.targetxyV then
      if projectile.targetxyV[1] * targetxyV[1] >= 0 then
        projectile.targetxyV = targetxyV
      elseif projectile.targetxyV[1] * targetxyV[1] < 0 then
        projectile.velocity[1] = projectile.velocity[1] / 10
        projectile.velocity[2] = projectile.velocity[2] / 10
        projectile.zSpeed = projectile.zSpeed / 10
        projectile.targetxyV = nil
      end
    end
    local v = 30
    projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
    projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
    projectile.zSpeed = projectile.zSpeed + targetV[3] * v
  end
end

function WorldTusk.projectile_hit(basefunc, projectile, target)
  local hero = projectile.skill.caster
  local skillults = hero.skills.WorldTusk_ults
  projectile.skill:takeEffectOn(target, projectile)
  projectile.affect_times[target] = (projectile.affect_times[target] or 0) + 1
  if target == hero.WorldTuskUltTarget then
    projectile.affect_times[target] = (projectile.affect_times[target] or 0) + 1
    projectile:terminate()
  else
    projectile.affect_times[target] = nil
  end
end

function WorldTusk.projectile_terminate(basefunc, projectile)
  local hero = projectile.skill.caster
  local blink_distance = 70
  local skillults = hero.skills.WorldTusk_ults
  basefunc(projectile)
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 11001108 and buff.caster == hero then
      buff.timer = 0
    end
  end
  local direction = 0 < projectile.position[1] - hero.position[1] and 1 or -1
  local position1 = projectile.position[1] - direction * blink_distance
  if 799 < position1 then
    position1 = 799 - blink_distance
  elseif position1 < 1 then
    position1 = 1 + blink_distance
  end
  hero.position = {
    position1,
    projectile.position[2]
  }
  local bid = 11001109
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
  hero:castSkill(skillults, nil)
end

function WorldTusk.skillult_createProjectile(basefunc, skill)
  local hero = skill.caster
  local target = skill.target
  hero.WorldTuskUltTarget = target
  local projectile = basefunc(skill, target)
  projectile.update = override(projectile.update, WorldTusk.projectile_update)
  projectile.hit = override(projectile.hit, WorldTusk.projectile_hit)
  projectile.terminate = override(projectile.terminate, WorldTusk.projectile_terminate)
  return projectile
end

function WorldTusk.skillults_selectTarget(basefunc, self, default)
  local hero = self.caster
  if hero.WorldTuskUltTarget and hero.WorldTuskUltTarget:isAlive() then
    local distance = math.abs(hero.position[1] - hero.WorldTuskUltTarget.position[1])
    if distance <= self.info["Max Range"] then
      self.target = hero.WorldTuskUltTarget
      return self.target
    end
  end
end

function WorldTusk.skillults_start(basefunc, skill, target)
  local hero = skill.caster
  hero.WorldTuskBeginPos = {
    hero.position[1],
    hero.position[2]
  }
  basefunc(skill, target)
end

function WorldTusk.skillults_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    hero.WorldTuskBeginPos = {
      hero.position[1],
      hero.position[2]
    }
    basefunc(skill)
  elseif attack_counter == 1 then
    attack_counter = attack_counter + 1
  else
    basefunc(skill)
  end
end

function WorldTusk.skillults_takeEffectOn(basefunc, skill, target, source)
  local hero = skill.caster
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  basefunc(skill, target, source)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(50, 0.1, 5)
  end
  skill.info = originfo
end

function WorldTusk.skillults_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  local skillult = hero.skills.WorldTusk_ult
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 11001109 and buff.caster == hero then
      buff.timer = 0
    end
  end
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    local bid = 11001111
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
  end
  hero.WorldTuskUltMoving = nil
  hero.walk_v = {0, 0}
  if hero.havedonecrit then
    hero.WorldTuskAtk4Crit = false
    hero.havedonecrit = false
  end
end

function WorldTusk.skillatk2s_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local hero = skill.caster
  if hero.havedonecrit then
    hero.WorldTuskAtk4Crit = false
    hero.havedonecrit = false
  end
end

function WorldTusk.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local hero = skill.caster
  if hero.havedonecrit then
    hero.WorldTuskAtk4Crit = false
    hero.havedonecrit = false
  end
end

function WorldTusk.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  if type(struct_table) == "table" then
    if struct_table.source and struct_table.source.info.Gender == T("\229\165\179") then
      self.Gender = T("\229\165\179")
      local bid = WorldTusk.enchbuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local caster = self
      local rand = ed.rand()
      if rand <= 0.25 then
        struct_table.source:addBuff(binfo, caster)
      end
    end
  elseif source and source.info.Gender == T("\229\165\179") then
    self.Gender = T("\229\165\179")
    local bid = WorldTusk.enchbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = self
    local rand = ed.rand()
    if rand <= 0.25 then
      source:addBuff(binfo, caster)
    end
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function WorldTusk.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  if self.Gender == T("\229\165\179") then
    damage = damage * 0.5
  end
  return basefunc(self, damage, immunity)
end

function WorldTusk.hero_update(basefunc, self, dt)
  local hero = self
  local skillatk4 = hero.skills.WorldTusk_atk4
  local skillults = hero.skills.WorldTusk_ults
  if skillatk4 and not hero.WorldTuskAtk4Crit then
    hero.WorldTuskStayTime = hero.WorldTuskStayTime + dt
    if hero.WorldTuskStayTime >= hero.WorldTuskAtk4Time then
      local bid = 11001107
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
        buff:setAttribute("ARMP", skillatk4.evo_rank3["Script Arg1"])
        buff:setAttribute("MRI", skillatk4.evo_rank3["Script Arg1"])
      end
      hero:addBuff(buff, hero)
      hero.WorldTuskAtk4Crit = true
      hero.WorldTuskStayTime = 0
    end
  end
  basefunc(self, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldTusk.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldTusk.ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldTusk.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldTusk.stage2ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldTusk.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldTusk.init_hero(hero)
  hero.reset = override(hero.reset, WorldTusk.hero_reset)
  hero.update = override(hero.update, WorldTusk.hero_update)
  if hero.name == "WorldTusk" then
    hero.getRuntimeScale = override(hero.getRuntimeScale, WorldTusk.hero_getRuntimeScale)
  end
  hero.takeDamage = override(hero.takeDamage, WorldTusk.hero_takeDamage)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldTusk.skill_getLostHPAfterImmunity)
  local skillult = hero.skills.WorldTusk_ult
  local skillults = hero.skills.WorldTusk_ults
  local skillatk2 = hero.skills.WorldTusk_atk2
  local skillatk2s = hero.skills.WorldTusk_atk2s
  local skillatk3 = hero.skills.WorldTusk_atk3
  local skillatk4 = hero.skills.WorldTusk_atk4
  if skillult and skillults then
    skillult.start = override(skillult.start, WorldTusk.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldTusk.skillult_onAttackFrame)
    skillult.createProjectile = override(skillult.createProjectile, WorldTusk.skillult_createProjectile)
    skillults.start = override(skillults.start, WorldTusk.skillults_start)
    skillults.selectTarget = override(skillults.selectTarget, WorldTusk.skillults_selectTarget)
    skillults.onAttackFrame = override(skillults.onAttackFrame, WorldTusk.skillults_onAttackFrame)
    skillults.takeEffectOn = override(skillults.takeEffectOn, WorldTusk.skillults_takeEffectOn)
    skillults.finish = override(skillults.finish, WorldTusk.skillults_finish)
  end
  if skillatk2 and skillatk2s then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldTusk.skillatk2_onAttackFrame)
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldTusk.skillatk2and3_createProjectile)
    skillatk2s.createProjectile = override(skillatk2s.createProjectile, WorldTusk.skillatk2s_createProjectile)
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, WorldTusk.skillatk2and3_createProjectile)
  end
  if skillatk4 and skillatk2 then
    skillatk2s.getDamage = override(skillatk2s.getDamage, WorldTusk.skillatk4_getDamage)
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, WorldTusk.skillatk2s_takeEffectOn)
  end
  if skillatk4 and skillults then
    skillults.getDamage = override(skillults.getDamage, WorldTusk.skillatk4_getDamage)
  end
  if skillatk4 and skillatk3 then
    skillatk3.getDamage = override(skillatk3.getDamage, WorldTusk.skillatk4_getDamage)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, WorldTusk.skillatk3_takeEffectAt)
  end
  return hero
end

return WorldTusk.init_hero
