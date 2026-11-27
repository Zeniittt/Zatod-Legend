module("ed.battlehero", package.seeall)
local ed = ed
ChessTK = {}
ChessTK.TKAwakeMPCost = 90
ChessTK.TKAwakeBuffBID = 477
ChessTK.TKPasvRefreshRate = 0.5

function ChessTK.skillult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  if skill.info["Target Type"] == "random" then
    skill:selectTarget(skill.target)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  skill.attack_counter = skill.attack_counter + 1
  local ttype = info["Track Type"]
  local MPGR = caster.attribs.MPGainRatio or 0
  skill:createTrackType(ttype)
  if MPGR then
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  end
  if 0 < info["Move Forward"] then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function ChessTK.projectile_update(basefunc, projectile, dt)
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

function ChessTK.skill_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, ChessTK.projectile_update)
  return projectile
end

function ChessTK.init_hero(hero)
  local skillult = hero.skills.TK_ult
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, ChessTK.skill_createProjectile)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessTK.skillult_onAttackFrame)
  else
  end
  return hero
end

return ChessTK.init_hero
