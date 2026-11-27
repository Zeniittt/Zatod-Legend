module("ed.battlehero", package.seeall)
local ed = ed
ChessFarSeer = {}
ChessFarSeer.FarSeer_ballzspeed = 0
ChessFarSeer.chess_MaxDamage = {
  1000,
  1500,
  2000
}
ChessFarSeer.chess_damageTime = {
  8,
  12,
  16
}
ChessFarSeer.chess_stayTime = {
  3,
  3,
  4
}
ChessFarSeer.chess_onceAttack = {
  0.375,
  0.25,
  0.25
}

function ChessFarSeer.pasvbregion_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  local skillultc = caster.skills.FarSeer_ultc
  local damage_counter = ChessFarSeer.chess_damageTime[caster.chess_stars] - region.FarSeer_leftCounter
  local damage_once = ChessFarSeer.chess_onceAttack[caster.chess_stars]
  region.damage_time = region.damage_time + dt
  if region.damage_time > damage_once * damage_counter and region.FarSeer_leftCounter >= 0 then
    region.FarSeer_leftCounter = region.FarSeer_leftCounter - 1
    skillultc.FarSeer_damage_perc = damage_counter / ChessFarSeer.chess_damageTime[caster.chess_stars]
    local list = skillultc:collectAoeTarget(region.position, caster.direction)
    if list then
      skillultc:takeEffectAt(region.position, caster)
    end
  end
  if not region.effecton then
    if ed.run_with_scene then
      local effect_name1 = "eff_point_FarSeer_pasv_front"
      local effect1 = ed.scene:playEffectOnScene(effect_name1, region.position, {1, 1}, nil, 1)
      local effect_name2 = "eff_point_FarSeer_pasv_back"
      local effect2 = ed.scene:playEffectOnScene(effect_name2, region.position, {1, 1}, nil, -1)
      region.scene_effect1 = effect1
      region.scene_effect2 = effect2
    end
    region.effecton = true
  end
end

function ChessFarSeer.pasvbregion_terminate(basefunc, region)
  if ed.run_with_scene then
    if region.scene_effect1 then
      ed.scene:removeEffect(region.scene_effect1, 1)
    end
    if region.scene_effect2 then
      ed.scene:removeEffect(region.scene_effect2, -1)
    end
  end
  basefunc(region)
end

function ChessFarSeer.skillpasvb_createRegion(basefunc, skill)
  local pasvbregion = basefunc(skill)
  local caster = skill.caster
  pasvbregion.timer = ChessFarSeer.chess_stayTime[caster.chess_stars]
  pasvbregion.FarSeer_leftCounter = ChessFarSeer.chess_damageTime[caster.chess_stars]
  pasvbregion.FarSeer_damageTime = 0
  pasvbregion.damage_time = 0
  pasvbregion.update = override(pasvbregion.update, ChessFarSeer.pasvbregion_update)
  pasvbregion.terminate = override(pasvbregion.terminate, ChessFarSeer.pasvbregion_terminate)
  return pasvbregion
end

function ChessFarSeer.pasvProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  projectile.previous_position = {
    projectile.position[1],
    projectile.position[2]
  }
  ed.Entity.update(projectile, dt)
  local info = projectile.skill.info
  projectile.sumtime = projectile.sumtime + dt
  projectile.height = projectile.height + ChessFarSeer.FarSeer_ballzspeed * projectile.sumtime + 0.5 * projectile.gravity * projectile.sumtime ^ 2
  projectile.zSpeed = projectile.zSpeed + projectile.gravity * dt
  local h = projectile.height
  if not projectile.terminated and (h <= 0 or projectile:isOutOfStage()) then
    projectile:terminate()
  end
end

function ChessFarSeer.pasvProjectile_terminate(basefunc, projectile)
  local caster = projectile.caster
  local skillpasvb = caster.skills.FarSeer_ultb
  if skillpasvb then
    skillpasvb.target = caster
    local region = skillpasvb:createRegion()
    region.position = projectile.dest
    ed.engine:addRegion(region)
  end
  basefunc(projectile)
end

function ChessFarSeer.skillpasv_createProjectile(basefunc, skill)
  local pasvProjectile = basefunc(skill)
  pasvProjectile.update = override(pasvProjectile.update, ChessFarSeer.pasvProjectile_update)
  pasvProjectile.terminate = override(pasvProjectile.terminate, ChessFarSeer.pasvProjectile_terminate)
  local dir = skill.caster:getInitDir()
  local max_distance = ed.engine.stage_rect.maxX / 2 * (1 - dir)
  local far_unit
  local target = skill.target
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
      break
    end
    if unit.config.is_summoned then
      break
    end
    if unit.position[1] * dir > max_distance * dir then
      max_distance = unit.position[1]
      far_unit = unit
    end
  end
  if far_unit then
    if far_unit.position[1] > ed.engine.stage_rect.maxX / 2 then
      pasvProjectile.dest = {
        far_unit.position[1] - 75,
        0
      }
    else
      pasvProjectile.dest = {
        far_unit.position[1] + 75,
        0
      }
    end
  else
    pasvProjectile.dest = {
      target.position[1],
      0
    }
  end
  pasvProjectile.zSpeed = ChessFarSeer.FarSeer_ballzspeed
  local t = 0.465
  local h = pasvProjectile.height
  pasvProjectile.gravity = 2 * (-h - ChessFarSeer.FarSeer_ballzspeed * t) / t ^ 2
  pasvProjectile.sumtime = 0
  local distance = ed.edpSub(pasvProjectile.dest, pasvProjectile.position)
  pasvProjectile.velocity = ed.edpMult(distance, 1 / t)
  return pasvProjectile
end

function ChessFarSeer.skillultc_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  if skill.FarSeer_damage_perc then
    power = power * skill.FarSeer_damage_perc
  end
  return power, coeff
end

function ChessFarSeer.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillpasv = hero.skills.FarSeer_ult
  local skillpasvb = hero.skills.FarSeer_ultb
  local skillultc = hero.skills.FarSeer_ultc
  if skillpasv and skillpasvb and skillultc then
    skillpasv.createProjectile = override(skillpasv.createProjectile, ChessFarSeer.skillpasv_createProjectile)
    skillpasvb.createRegion = override(skillpasvb.createRegion, ChessFarSeer.skillpasvb_createRegion)
    skillultc.power = override(skillultc.power, ChessFarSeer.skillultc_power)
  end
  return hero
end

return ChessFarSeer.init_hero
