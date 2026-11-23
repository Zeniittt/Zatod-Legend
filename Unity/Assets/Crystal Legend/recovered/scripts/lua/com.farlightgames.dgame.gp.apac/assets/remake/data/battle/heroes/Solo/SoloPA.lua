module("ed.battlehero", package.seeall)
local ed = ed
SoloPA = {}

function SoloPA.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local caster_crit = caster.attribs.CRIT
  local caster_ad = caster.attribs.AD
  power = caster_ad * caster_crit * 0.04
  return power, coeff
end

function SoloPA.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 100000002
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  buff:setAttribute("CSD", 20)
  buff:setAttribute("MCSD", 20)
  hero:addBuff(buff, hero)
end

function SoloPA.hero_true_init(hero)
  local skillult = hero.skills.PA_ult
  hero.reset = override(hero.reset, SoloPA.hero_reset)
  if skillult then
    skillult.power = override(skillult.power, SoloPA.skillult_power)
  end
  return hero
end

function SoloPA.init_hero(hero)
  SoloPA.hero_true_init(hero)
  return hero
end

return SoloPA.init_hero
