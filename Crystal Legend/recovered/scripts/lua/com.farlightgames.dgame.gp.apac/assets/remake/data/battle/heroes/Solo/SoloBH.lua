module("ed.battlehero", package.seeall)
local ed = ed
SoloBH = {}

function SoloBH.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local values = caster:getPowerTypeAttr("battle_gold")
  local UltRatio = caster.attribs.UltRatio or 0
  power = power + (values[1] or 0) * 0.4 * (1 + UltRatio * 0.01)
  return power, coeff
end

function SoloBH.skill_createProjectile(basefunc, skill)
  local caster = skill.caster
  local values = caster:getPowerTypeAttr("battle_gold")
  skill.soloScale = (1 + math.min((math.max(values[1] - 400, 0) / 100) ^ 0.4, 5)) * 0.3
  skill.soloRadius = skill.soloScale * 15
  local projectile = basefunc(skill)
  return projectile
end

function SoloBH.hero_true_init(hero)
  local skillult = hero.skills.BH_ult
  if skillult then
    skillult.power = override(skillult.power, SoloBH.skillult_power)
    skillult.createProjectile = override(skillult.createProjectile, SoloBH.skill_createProjectile)
  end
  return hero
end

function SoloBH.init_hero(hero)
  SoloBH.hero_true_init(hero)
  return hero
end

return SoloBH.init_hero
