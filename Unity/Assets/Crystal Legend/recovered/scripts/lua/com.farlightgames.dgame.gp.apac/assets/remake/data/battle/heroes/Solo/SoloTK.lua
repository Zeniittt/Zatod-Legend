module("ed.battlehero", package.seeall)
local ed = ed
SoloTK = {}

function SoloTK.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local UltRatio = caster.attribs.UltRatio or 0
  power = power + (caster.level * 1 + caster.cardTypeCount * 2) * (1 + UltRatio * 0.01)
  return power, coeff
end

function SoloTK.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
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

function SoloTK.skill_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, SoloTK.projectile_update)
  return projectile
end

function SoloTK.hero_true_init(hero)
  local skillult = hero.skills.TK_ult
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, SoloTK.skill_createProjectile)
    skillult.power = override(skillult.power, SoloTK.skillult_power)
  end
  return hero
end

function SoloTK.init_hero(hero)
  SoloTK.hero_true_init(hero)
  return hero
end

return SoloTK.init_hero
