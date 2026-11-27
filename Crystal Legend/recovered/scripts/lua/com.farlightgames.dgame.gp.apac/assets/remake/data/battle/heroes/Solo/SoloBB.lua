module("ed.battlehero", package.seeall)
local ed = ed
SoloBB = {}

function SoloBB.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillpasv = caster.skills.BB_pasv
  if caster and skillpasv then
    caster.ult_powerRatio = caster.ult_powerRatio + 0.5
    caster.ult_powerRatio = math.min(caster.ult_powerRatio, 2)
  end
end

function SoloBB.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local info = skill.info
  local ultpowerratio = caster.ult_powerRatio
  power = power * (1 + ultpowerratio)
  return power, coeff
end

function SoloBB.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.ult_powerRatio = 0
end

function SoloBB.hero_true_init(hero)
  local skillult = hero.skills.BB_ult
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, SoloBB.skillult_takeEffectOn)
    skillult.power = override(skillult.power, SoloBB.skillult_power)
  end
  hero.reset = override(hero.reset, SoloBB.hero_reset)
  return hero
end

function SoloBB.init_hero(hero)
  SoloBB.hero_true_init(hero)
  return hero
end

return SoloBB.init_hero
