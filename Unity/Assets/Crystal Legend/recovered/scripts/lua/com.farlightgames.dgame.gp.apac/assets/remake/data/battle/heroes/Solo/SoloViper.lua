module("ed.battlehero", package.seeall)
local ed = ed
SoloViper = {}

function SoloViper.skillult_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if target then
    target:addDrug(skill.info["Basic Num"] + caster.level * 2, {type = 2, id = 1}, caster)
  end
  return isHit, dmg
end

function SoloViper.getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type, source)
  local lostHP = basefunc(unit, damage, immunity, damage_type, source)
  if 0 < lostHP and source then
    source:addDrug(10 + unit.level * 1, {type = 2, id = 2}, unit)
  end
  return lostHP
end

function SoloViper.hero_true_init(hero)
  local skillult = hero.skills.Viper_ult
  skillult.takeEffectOn = override(skillult.takeEffectOn, SoloViper.skillult_takeEffectOn)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, SoloViper.getLostHPAfterImmunity)
  return hero
end

function SoloViper.init_hero(hero)
  SoloViper.hero_true_init(hero)
  return hero
end

return SoloViper.init_hero
