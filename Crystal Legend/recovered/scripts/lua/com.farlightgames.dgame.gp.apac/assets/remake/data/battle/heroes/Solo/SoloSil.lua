module("ed.battlehero", package.seeall)
local ed = ed
SoloSil = {}

function SoloSil.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local values = caster:getPowerTypeAttr("battle_ult_extra_power")
  local UltRatio = caster.attribs.UltRatio or 0
  power = power + (values[1] or 0) * (1 + UltRatio * 0.01)
  return power, coeff
end

function SoloSil.hero_true_init(hero)
  local skillult = hero.skills.Sil_ult
  if skillult then
    skillult.power = override(skillult.power, SoloSil.skillult_power)
  end
  return hero
end

function SoloSil.init_hero(hero)
  SoloSil.hero_true_init(hero)
  return hero
end

return SoloSil.init_hero
