module("ed.battlehero", package.seeall)
local ed = ed
SoloKOTL = {}

function SoloKOTL.canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function SoloKOTL.onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    skill.caster.ultcharge_begin = 1
    skill.attack_counter = 1
  elseif skill.attack_counter == 1 then
    basefunc(skill)
  end
end

function SoloKOTL.trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function SoloKOTL.interrupt(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end

function SoloKOTL.power(basefunc, skill, source, target, damage_type)
  return 300 * (0.5 + 0.5 * math.min(5, skill.ultTimes)) * (1 + skill.caster.attribs.UltRatio / 100), 1
end

function SoloKOTL.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.ultcharge_begin and hero.ultcharge_begin <= 0.2 then
    hero.ultcharge_begin = hero.ultcharge_begin + dt
  elseif hero.ultcharge_begin and hero.ultcharge_begin > 0.2 then
    hero.ultcharge_begin = nil
    local skillult = hero.skills.KOTL_ult
    skillult.ultTimes = skillult.ultTimes + 1
    skillult:trigger()
  end
end

function SoloKOTL.hero_true_init(hero)
  local skillult = hero.skills.KOTL_ult
  hero.update = override(hero.update, SoloKOTL.hero_update)
  if skillult then
    skillult.info["No Speeder"] = true
    skillult.ultTimes = 0
    skillult.onAttackFrame = override(skillult.onAttackFrame, SoloKOTL.onAttackFrame)
    skillult.canTrigger = override(skillult.canTrigger, SoloKOTL.canTrigger)
    skillult.trigger = override(skillult.trigger, SoloKOTL.trigger)
    skillult.interrupt = override(skillult.interrupt, SoloKOTL.interrupt)
    skillult.power = override(skillult.power, SoloKOTL.power)
  end
  return hero
end

function SoloKOTL.init_hero(hero)
  SoloKOTL.hero_true_init(hero)
  return hero
end

return SoloKOTL.init_hero
