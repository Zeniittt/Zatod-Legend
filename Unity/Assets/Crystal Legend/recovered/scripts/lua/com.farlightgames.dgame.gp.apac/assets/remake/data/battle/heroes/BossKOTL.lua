module("ed.battlehero", package.seeall)
local ed = ed
BossKOTL = {}

function BossKOTL.skill6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, duration)
end

function BossKOTL.skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossKOTL.skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 1.8
  if caster then
    caster:enterActionStageFromOneStage(2, 140)
  end
  caster:endScalingAction()
end

function BossKOTL.canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function BossKOTL.onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
    end
    skill.caster.manually_casting = false
    skill.ultbegin = skill.current_phase_elapsed
    skill.attack_counter = 1
  elseif skill.attack_counter == 1 then
    skill.ultcharge = skill.current_phase_elapsed - skill.ultbegin
    skill.ultcharge = math.min(5, skill.ultcharge) / 5
    basefunc(skill)
  end
end

function BossKOTL.trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function BossKOTL.interrupt(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end

function BossKOTL.power(basefunc, skill, source, target, damage_type)
  local muti = 1
  if 1 <= skill.ultcharge then
    muti = 1.5
  end
  return basefunc(skill, source, target, damage_type) * (0.3 + skill.ultcharge * muti), 1
end

function BossKOTL.skill2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if target:isAlive() then
    target:takeDamage((target.hp - 2) / caster.attribs.PDM, "Holy", "hp", caster)
  end
  local name = skill.info["Impact Effect"]
  if name and target.actor then
    local effect_z = skill.info["Impact Zorder"]
    target.actor:addEffect(name, effect_z)
  end
end

function BossKOTL.init_hero(hero)
  local skillult = hero.skills.BossKOTL_atk4
  if skillult then
    skillult.info["No Speeder"] = true
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossKOTL.onAttackFrame)
    skillult.canTrigger = override(skillult.canTrigger, BossKOTL.canTrigger)
    skillult.trigger = override(skillult.trigger, BossKOTL.trigger)
    skillult.interrupt = override(skillult.interrupt, BossKOTL.interrupt)
    skillult.power = override(skillult.power, BossKOTL.power)
  end
  local skill2 = hero.skills.BossKOTL_atk2
  if skill2 then
    skill2.takeEffectOn = override(skill2.takeEffectOn, BossKOTL.skill2_takeEffectOn)
  end
  local skill6 = hero.skills.BossKOTL_atk6
  if skill6 then
    skill6.start = override(skill6.start, BossKOTL.skill6_start)
    skill6.finish = override(skill6.finish, BossKOTL.skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, BossKOTL.skill6_onAttackFrame)
  end
  return hero
end

return BossKOTL.init_hero
