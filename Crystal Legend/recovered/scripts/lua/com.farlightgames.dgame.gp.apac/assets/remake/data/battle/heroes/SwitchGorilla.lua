module("ed.battlehero", package.seeall)
local ed = ed
SwitchGorilla = {}

function SwitchGorilla.skill_createProjectile(basefunc, skill)
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

function SwitchGorilla.skill3_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 4246
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, owner)
  owner:addBuff(buff, owner)
end

function SwitchGorilla.init_hero(hero)
  local skill = hero.skills.SwitchGorilla_atk2
  local skill3 = hero.skills.SwitchGorilla_atk3
  if skill then
    skill.createProjectile = override(skill.createProjectile, SwitchGorilla.skill_createProjectile)
  end
  if skill3 then
    skill3.start = override(skill3.start, SwitchGorilla.skill3_start)
  end
  return hero
end

return SwitchGorilla.init_hero
