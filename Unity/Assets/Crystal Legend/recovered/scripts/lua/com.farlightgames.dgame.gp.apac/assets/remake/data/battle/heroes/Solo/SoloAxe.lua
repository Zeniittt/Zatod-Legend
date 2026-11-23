module("ed.battlehero", package.seeall)
local ed = ed
SoloAxe = {}

function SoloAxe.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillpasv = hero.skills.Axe_pasv
  if skillpasv and not hero.pasv_addShield then
    hero.pasv_addShield = true
    hero:addShield(hero.level * 100, {
      type = 2,
      id = skillpasv.info.Slot
    })
  end
end

function SoloAxe.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local ult_powerPlus = math.max(caster.shieldValue, 0)
  local UltRatio = caster.attribs.UltRatio or 0
  power = power + ult_powerPlus * (1 + UltRatio * 0.01)
  return power, coeff
end

function SoloAxe.hero_true_init(hero)
  local skillult = hero.skills.Axe_ult
  if skillult then
    skillult.power = override(skillult.power, SoloAxe.skillult_power)
  end
  hero.update = override(hero.update, SoloAxe.hero_update)
  return hero
end

function SoloAxe.init_hero(hero)
  SoloAxe.hero_true_init(hero)
  return hero
end

return SoloAxe.init_hero
