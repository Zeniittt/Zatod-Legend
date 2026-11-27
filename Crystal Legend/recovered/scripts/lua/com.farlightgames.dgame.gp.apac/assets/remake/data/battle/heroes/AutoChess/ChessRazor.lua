module("ed.battlehero", package.seeall)
local ed = ed
ChessRazor = {}
ChessRazor.ChessNPC_ultbuffID = 6068

function ChessRazor.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local max_skill_dis = skill.info["Shape Arg1"]
  local min_power = skill.info["Basic Num"]
  local dis = math.min(max_skill_dis, math.abs(target.position[1] - caster.position[1]))
  power = math.max(min_power * 0.5, power * (dis / max_skill_dis))
  return power, coeff
end

function ChessRazor.init_hero(hero)
  local skillult = hero.skills.Razor_ult
  if skillult then
    skillult.power = override(skillult.power, ChessRazor.skillult_power)
  end
  return hero
end

return ChessRazor.init_hero
