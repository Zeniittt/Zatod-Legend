module("ed.battlehero", package.seeall)
local ed = ed
Tusk = {}
Tusk.velocity = 180
Tusk.base = ed.Entity

function Tusk.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.Tusk_atk4
  if skillatk4 then
    hero.TuskAtk4Time = skillatk4.info["Basic Num"]
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      hero.TuskAtk4Time = hero.TuskAtk4Time - skillatk4.evo_rank1["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      hero.TuskAtk4Time = hero.TuskAtk4Time - skillatk4.evo_rank2["Script Arg1"]
    end
    hero.TuskStayTime = 0
    hero.TuskAtk4Crit = false
    hero.havedonecrit = false
  end
  hero.TuskUltTarget = nil
  hero.TuskUltMoving = nil
  hero.Tusk_firstin = true
end

function Tusk.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local skillatk2s = hero.skills.Tusk_atk2s
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

function Tusk.skillatk2s_createProjectile(basefunc, skill)
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

function Tusk.skillatk2and3_createProjectile(basefunc, skill)
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile:enableTrack(target)
  ed.engine:addProjectile(projectile)
end

function Tusk.skillatk4_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local hero = skill.caster
  if hero.TuskAtk4Crit then
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

function Tusk.hero_getRuntimeScale(basefunc, hero)
  return hero.direction, 1
end

function Tusk.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  hero.TuskUltPos = {
    hero.position[1],
    hero.position[2]
  }
end

function Tusk.skillult_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local bid = 11001108
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
    basefunc(skill)
  end
end

function Tusk.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local hero = projectile.skill.caster
  local target = hero.TuskUltTarget
  if not target or target and (target.buff_effects.untargetable or not target:isAlive()) then
    hero.TuskUltTarget = projectile.skill:selectTarget(target)
    if not hero.TuskUltTarget or hero.TuskUltTarget and (hero.TuskUltTarget.buff_effects.untargetable or not hero.TuskUltTarget:isAlive()) then
      projectile:terminate()
    end
  end
  if hero.TuskUltTarget then
    local targetpos = hero.TuskUltTarget.position
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

function Tusk.projectile_hit(basefunc, projectile, target)
  local hero = projectile.skill.caster
  local skillults = hero.skills.Tusk_ults
  projectile.skill:takeEffectOn(target, projectile)
  projectile.affect_times[target] = (projectile.affect_times[target] or 0) + 1
  if target == hero.TuskUltTarget then
    projectile.affect_times[target] = (projectile.affect_times[target] or 0) + 1
    projectile:terminate()
  else
    projectile.affect_times[target] = nil
  end
end

function Tusk.projectile_terminate(basefunc, projectile)
  local hero = projectile.skill.caster
  local blink_distance = 70
  local skillults = hero.skills.Tusk_ults
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

function Tusk.skillult_createProjectile(basefunc, skill)
  local hero = skill.caster
  local target = skill.target
  hero.TuskUltTarget = target
  local projectile = basefunc(skill, target)
  projectile.update = override(projectile.update, Tusk.projectile_update)
  projectile.hit = override(projectile.hit, Tusk.projectile_hit)
  projectile.terminate = override(projectile.terminate, Tusk.projectile_terminate)
  return projectile
end

function Tusk.skillults_selectTarget(basefunc, self, default)
  local hero = self.caster
  if hero.TuskUltTarget and hero.TuskUltTarget:isAlive() then
    local distance = math.abs(hero.position[1] - hero.TuskUltTarget.position[1])
    if distance <= self.info["Max Range"] then
      self.target = hero.TuskUltTarget
      return self.target
    end
  end
end

function Tusk.skillults_start(basefunc, skill, target)
  local hero = skill.caster
  hero.TuskBeginPos = {
    hero.position[1],
    hero.position[2]
  }
  basefunc(skill, target)
end

function Tusk.skillults_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    hero.TuskBeginPos = {
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

function Tusk.skillults_takeEffectOn(basefunc, skill, target, source)
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

function Tusk.skillults_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  local skillult = hero.skills.Tusk_ult
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
  hero.TuskUltMoving = nil
  hero.walk_v = {0, 0}
  if hero.havedonecrit then
    hero.TuskAtk4Crit = false
    hero.havedonecrit = false
  end
end

function Tusk.skillatk2s_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local hero = skill.caster
  if hero.havedonecrit then
    hero.TuskAtk4Crit = false
    hero.havedonecrit = false
  end
end

function Tusk.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local hero = skill.caster
  if hero.havedonecrit then
    hero.TuskAtk4Crit = false
    hero.havedonecrit = false
  end
end

function Tusk.hero_update(basefunc, self, dt)
  local hero = self
  local skillatk4 = hero.skills.Tusk_atk4
  local skillults = hero.skills.Tusk_ults
  if skillatk4 and not hero.TuskAtk4Crit then
    hero.TuskStayTime = hero.TuskStayTime + dt
    if hero.TuskStayTime >= hero.TuskAtk4Time then
      local bid = 11001107
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
        buff:setAttribute("ARMP", skillatk4.evo_rank3["Script Arg1"])
      end
      hero:addBuff(buff, hero)
      hero.TuskAtk4Crit = true
      hero.TuskStayTime = 0
    end
  end
  basefunc(self, dt)
end

function Tusk.init_hero(hero)
  hero.reset = override(hero.reset, Tusk.hero_reset)
  hero.update = override(hero.update, Tusk.hero_update)
  if hero.name == "Tusk" then
    hero.getRuntimeScale = override(hero.getRuntimeScale, Tusk.hero_getRuntimeScale)
  end
  local skillult = hero.skills.Tusk_ult
  local skillults = hero.skills.Tusk_ults
  local skillatk = hero.skills.Tusk_atk
  local skillatk2 = hero.skills.Tusk_atk2
  local skillatk2s = hero.skills.Tusk_atk2s
  local skillatk3 = hero.skills.Tusk_atk3
  local skillatk4 = hero.skills.Tusk_atk4
  if skillult and skillults then
    skillult.start = override(skillult.start, Tusk.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Tusk.skillult_onAttackFrame)
    skillult.createProjectile = override(skillult.createProjectile, Tusk.skillult_createProjectile)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillults.info = ed.wraptable(skillults.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillults.info = ed.wraptable(skillults.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    skillults.start = override(skillults.start, Tusk.skillults_start)
    skillults.selectTarget = override(skillults.selectTarget, Tusk.skillults_selectTarget)
    skillults.onAttackFrame = override(skillults.onAttackFrame, Tusk.skillults_onAttackFrame)
    skillults.takeEffectOn = override(skillults.takeEffectOn, Tusk.skillults_takeEffectOn)
    skillults.finish = override(skillults.finish, Tusk.skillults_finish)
  end
  if skillatk2 and skillatk2s then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Tusk.skillatk2_onAttackFrame)
    skillatk2.createProjectile = override(skillatk2.createProjectile, Tusk.skillatk2and3_createProjectile)
    skillatk2s.createProjectile = override(skillatk2s.createProjectile, Tusk.skillatk2s_createProjectile)
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    skillatk3.createProjectile = override(skillatk3.createProjectile, Tusk.skillatk2and3_createProjectile)
  end
  if skillatk4 and skillatk2 then
    skillatk2s.getDamage = override(skillatk2s.getDamage, Tusk.skillatk4_getDamage)
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, Tusk.skillatk2s_takeEffectOn)
  end
  if skillatk4 and skillults then
    skillults.getDamage = override(skillults.getDamage, Tusk.skillatk4_getDamage)
  end
  if skillatk4 and skillatk3 then
    skillatk3.getDamage = override(skillatk3.getDamage, Tusk.skillatk4_getDamage)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, Tusk.skillatk3_takeEffectAt)
  end
  return hero
end

return Tusk.init_hero
