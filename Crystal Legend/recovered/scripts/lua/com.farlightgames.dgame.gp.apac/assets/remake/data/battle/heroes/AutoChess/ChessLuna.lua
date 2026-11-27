module("ed.battlehero", package.seeall)
local ed = ed
ChessLuna = {}

function ChessLuna.skill_atk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local time = skill.info["Script Arg2"]
  projectile:enableJump(time)
  projectile:enableTrack(skill.target)
  return projectile
end

function ChessLuna.skill_atk_power(basefunc, skill, source, target, damage_type)
  local ret, coeff = basefunc(skill, source, target, damage_type)
  if source.jumps and source.jumps >= 1 and source.jumps <= skill.info["Script Arg2"] then
    ret = ret * math.pow(0.8, skill.info["Script Arg2"] - source.jumps)
  end
  return ret, coeff
end

function ChessLuna.init_hero(hero)
  local skill_atk = hero.skills.Luna_atk
  if skill_atk then
    skill_atk.createProjectile = override(skill_atk.createProjectile, ChessLuna.skill_atk_createProjectile)
    skill_atk.power = override(skill_atk.power, ChessLuna.skill_atk_power)
  end
  return hero
end

return ChessLuna.init_hero
