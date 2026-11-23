module("ed.battlehero", package.seeall)
local ed = ed
ChessTusk = {}
ChessTusk.velocity = 180
ChessTusk.base = ed.Entity
ChessTusk.sawake_bid = 1435
ChessTusk.sawake_addhpratio = 0.8

function ChessTusk.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TuskUltTarget = nil
  hero.TuskUltMoving = nil
  hero.Tusk_firstin = true
end

function ChessTusk.hero_getRuntimeScale(basefunc, hero)
  return hero.direction, 1
end

function ChessTusk.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  hero.TuskUltPos = {
    hero.position[1],
    hero.position[2]
  }
end

function ChessTusk.skillult_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    if skill.target then
      local bid = 461
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero:addBuff(binfo, hero)
    end
    basefunc(skill)
  end
end

function ChessTusk.projectile_update(basefunc, projectile, dt)
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

function ChessTusk.projectile_hit(basefunc, projectile, target)
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

function ChessTusk.projectile_terminate(basefunc, projectile)
  local hero = projectile.skill.caster
  local blink_distance = 70
  local skillults = hero.skills.Tusk_ults
  basefunc(projectile)
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 461 and buff.caster == hero then
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
  local bid = 462
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
  hero:castSkill(skillults, nil)
end

function ChessTusk.skillult_createProjectile(basefunc, skill)
  local hero = skill.caster
  local target = skill.target
  hero.TuskUltTarget = target
  local projectile = basefunc(skill, target)
  projectile.update = override(projectile.update, ChessTusk.projectile_update)
  projectile.hit = override(projectile.hit, ChessTusk.projectile_hit)
  projectile.terminate = override(projectile.terminate, ChessTusk.projectile_terminate)
  return projectile
end

function ChessTusk.skillults_selectTarget(basefunc, self, default)
  local hero = self.caster
  if hero.TuskUltTarget and hero.TuskUltTarget:isAlive() then
    local distance = math.abs(hero.position[1] - hero.TuskUltTarget.position[1])
    if distance <= self.info["Max Range"] then
      self.target = hero.TuskUltTarget
      return self.target
    end
  end
end

function ChessTusk.skillults_start(basefunc, skill, target)
  local hero = skill.caster
  hero.TuskBeginPos = {
    hero.position[1],
    hero.position[2]
  }
  basefunc(skill, target)
end

function ChessTusk.skillults_onAttackFrame(basefunc, skill)
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

function ChessTusk.skillults_takeEffectOn(basefunc, skill, target, source)
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

function ChessTusk.skillults_onPhaseFinished(basefunc, skill)
  local hero = skill.caster
  if skill.current_phase_idx == 1 then
    if hero.TuskUltPos[1] - hero.position[1] >= 0 then
      hero.direction = 1
    else
      hero.direction = -1
    end
    hero.walk_v = {
      hero.direction * ChessTusk.velocity,
      0
    }
    hero.TuskUltMoving = true
    skill:startPhase(2)
  elseif skill.current_phase_idx == 2 then
    hero.TuskUltMoving = nil
    hero.walk_v = {0, 0}
    basefunc(skill)
  end
end

function ChessTusk.skillults_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 462 and buff.caster == hero then
      buff.timer = 0
    end
  end
  hero.TuskUltMoving = nil
  hero.walk_v = {0, 0}
end

function ChessTusk.hero_update(basefunc, self, dt)
  local hero = self
  local skillults = hero.skills.Tusk_ults
  if hero.TuskUltMoving == true then
    if hero.TuskBeginPos[1] > hero.TuskUltPos[1] then
      if hero.position[1] < hero.TuskUltPos[1] or hero.position[1] < 50 then
        skillults:finish()
      end
    elseif (hero.TuskBeginPos[1] < hero.TuskUltPos[1] or hero.TuskBeginPos[1] > 750) and hero.position[1] > hero.TuskUltPos[1] then
      skillults:finish()
    end
  end
  basefunc(self, dt)
end

function ChessTusk.init_hero(hero)
  hero.reset = override(hero.reset, ChessTusk.hero_reset)
  hero.update = override(hero.update, ChessTusk.hero_update)
  if hero.name == "Tusk" then
    hero.getRuntimeScale = override(hero.getRuntimeScale, ChessTusk.hero_getRuntimeScale)
  end
  local skillult = hero.skills.Tusk_ult
  local skillults = hero.skills.Tusk_ults
  if skillult and skillults then
    skillult.start = override(skillult.start, ChessTusk.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessTusk.skillult_onAttackFrame)
    skillult.createProjectile = override(skillult.createProjectile, ChessTusk.skillult_createProjectile)
    skillults.start = override(skillults.start, ChessTusk.skillults_start)
    skillults.selectTarget = override(skillults.selectTarget, ChessTusk.skillults_selectTarget)
    skillults.onAttackFrame = override(skillults.onAttackFrame, ChessTusk.skillults_onAttackFrame)
    skillults.takeEffectOn = override(skillults.takeEffectOn, ChessTusk.skillults_takeEffectOn)
    skillults.onPhaseFinished = override(skillults.onPhaseFinished, ChessTusk.skillults_onPhaseFinished)
    skillults.finish = override(skillults.finish, ChessTusk.skillults_finish)
  end
  return hero
end

return ChessTusk.init_hero
