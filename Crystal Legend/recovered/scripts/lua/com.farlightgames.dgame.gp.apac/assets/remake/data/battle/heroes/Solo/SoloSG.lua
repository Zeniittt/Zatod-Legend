module("ed.battlehero", package.seeall)
local ed = ed
SoloSG = {}

function SoloSG.skillatk_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if target and isHit then
    target:addWeak(15 + caster.level, {type = 2, id = 1}, caster)
  end
  return isHit, dmg
end

function SoloSG.skillult_launchPoint(basefunc, skill)
  local caster = skill.caster
  local dir = caster.direction
  return {
    caster.position[1] + dir * 55,
    caster.position[2]
  }, 50
end

function SoloSG.hero_true_init(hero)
  local skillatk = hero.skills.SG_atk
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SoloSG.skillatk_takeEffectOn)
  end
  local skillult = hero.skills.SG_ult
  if skillult then
    skillult.launchPoint = override(skillult.launchPoint, SoloSG.skillult_launchPoint)
  end
  return hero
end

function SoloSG.init_hero(hero)
  SoloSG.hero_true_init(hero)
  return hero
end

return SoloSG.init_hero
