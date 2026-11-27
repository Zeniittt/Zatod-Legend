module("ed.battlehero", package.seeall)
local ed = ed
Gorilla = {}

function Gorilla.skill_createProjectile(basefunc, skill)
  local origtarget = skill.target
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = {
    skill.target.position[1] - 60 * skill.caster.direction,
    skill.target.position[2]
  }
  local distance = ed.edpSub(target_position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  ed.engine:addProjectile(projectile)
  return nil
end

function Gorilla.init_hero(hero)
  local skill = hero.skills.Gorilla_atk2
  if skill then
    skill.createProjectile = override(skill.createProjectile, Gorilla.skill_createProjectile)
  end
  return hero
end

return Gorilla.init_hero
