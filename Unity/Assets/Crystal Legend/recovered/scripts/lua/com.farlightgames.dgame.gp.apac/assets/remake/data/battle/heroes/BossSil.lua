module("ed.battlehero", package.seeall)
local ed = ed
BossSil = {}

function BossSil.takeEffectOn(basefunc, skill, target)
  local succ = basefunc(skill, target)
  if succ then
    local power = skill.info["Script Arg1"]
    target:takeDamage(power, "Holy", "mp", skill.caster)
  end
  return succ
end

function BossSil.skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossSil.skill6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
end

function BossSil.skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2, 137)
  end
  local skill2 = caster.skills.BossSil_atk4
  skill2.originfo = skill2.info
  skill2.info = ed.wraptable(skill2.originfo, {CD = 2})
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
end

local function hero_update(basefunc, hero, dt)
  if not hero.babel_configbuff then
    local bid = 1264
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local BossSil_babel_configbuff = ed.BuffCreate(binfo, hero, hero)
    local addHp = 2500000 - hero.attribs.HP
    local addARM = 1000
    local addMR = 1000
    BossSil_babel_configbuff:setAttribute("HP", addHp)
    BossSil_babel_configbuff:setAttribute("ARM", addARM)
    BossSil_babel_configbuff:setAttribute("MR", addMR)
    hero:addBuff(BossSil_babel_configbuff, hero)
    hero.hp = hero.attribs.HP
    hero.babel_configbuff = true
  end
  basefunc(hero, dt)
end

function BossSil.init_hero(hero)
  if ed.engine.babelMode and hero.name ~= "Rubick" then
    hero.update = override(hero.update, hero_update)
  end
  local skill = hero.skills.BossSil_atk3
  if skill then
    skill.takeEffectOn = override(skill.takeEffectOn, BossSil.takeEffectOn)
  end
  local skill6 = hero.skills.BossSil_atk6
  if skill6 then
    skill6.start = override(skill6.start, BossSil.skill6_start)
    skill6.finish = override(skill6.finish, BossSil.skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, BossSil.skill6_onAttackFrame)
  end
  return hero
end

return BossSil.init_hero
