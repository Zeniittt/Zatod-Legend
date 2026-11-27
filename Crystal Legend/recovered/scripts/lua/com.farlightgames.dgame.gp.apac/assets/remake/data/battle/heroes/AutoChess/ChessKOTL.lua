module("ed.battlehero", package.seeall)
local ed = ed
ChessKOTL = {}

function ChessKOTL.canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function ChessKOTL.onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    skill.caster.manually_casting = false
    skill.caster.ultcharge_begin = 1
    skill.ultbegin = skill.current_phase_elapsed
    skill.attack_counter = 1
  elseif skill.attack_counter == 1 then
    skill.ultcharge = skill.current_phase_elapsed - skill.ultbegin
    local multi_ret = (skill.info["Script Arg2"] - skill.info["Basic Num"]) / skill.info["Basic Num"]
    skill.ultcharge = math.min(5, skill.ultcharge) / 5 * multi_ret
    basefunc(skill)
  end
end

function ChessKOTL.trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function ChessKOTL.interrupt(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end

function ChessKOTL.power(basefunc, skill, source, target, damage_type)
  return basefunc(skill, source, target, damage_type) * (1 + skill.ultcharge), 1
end

function ChessKOTL.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.ultcharge_begin and hero.ultcharge_begin <= 6 then
    hero.ultcharge_begin = hero.ultcharge_begin + dt
  elseif hero.ultcharge_begin and hero.ultcharge_begin > 6 then
    hero.ultcharge_begin = nil
    local skillult = hero.skills.KOTL_ult
    skillult:trigger()
  end
end

function ChessKOTL.init_hero(hero)
  local skillult = hero.skills.KOTL_ult
  local skillatk2 = hero.skills.KOTL_atk2
  hero.update = override(hero.update, ChessKOTL.hero_update)
  if skillult then
    skillult.info["No Speeder"] = true
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessKOTL.onAttackFrame)
    skillult.canTrigger = override(skillult.canTrigger, ChessKOTL.canTrigger)
    skillult.trigger = override(skillult.trigger, ChessKOTL.trigger)
    skillult.interrupt = override(skillult.interrupt, ChessKOTL.interrupt)
    skillult.power = override(skillult.power, ChessKOTL.power)
  end
  return hero
end

return ChessKOTL.init_hero
