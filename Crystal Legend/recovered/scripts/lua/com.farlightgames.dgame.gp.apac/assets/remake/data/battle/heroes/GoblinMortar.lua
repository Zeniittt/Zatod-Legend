module("ed.battlehero", package.seeall)
local ed = ed
GoblinMortar = {}

function GoblinMortar.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local distance = ed.edpSub(target_position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function GoblinMortar.init_hero(hero)
  local skillatk = hero.skills.GoblinMortar_atk
  local skillatk2 = hero.skills.GoblinMortar_atk2
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, GoblinMortar.skillatk_createProjectile)
  end
  return hero
end

return GoblinMortar.init_hero
