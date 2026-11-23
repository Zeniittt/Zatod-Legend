module("ed.battlehero", package.seeall)
local ed = ed
ChessPA = {}
ChessPA.chess_crit_mod = {
  3,
  4.5,
  6
}

function ChessPA.skillatk_start(basefunc, skill, target)
  local info = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  if skill.caster.taunter and skill.info["Target Type"] ~= "skill" then
    if target then
      if target.camp ~= skill:targetCamp() then
        skill:selectTarget(target)
      else
      end
    else
      skill:selectTarget(target)
    end
  else
    skill:selectTarget(target)
  end
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local t = ed.rand() < 0.5
  if t then
    skill:startPhase(1)
  else
    skill:startPhase(2)
  end
  skill.is_update = true
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  local CDR = math.min(caster.attribs.CDR, 50)
  caster:setMP(caster.mp - info["Cost MP"] * (1 - CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function ChessPA.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function ChessPA.hero_castSkill(basefunc, hero, skill, target)
  if not hero:isAlive() then
    return
  end
  if hero.SD_ultStackBuff and hero.SD_ultStackBuff.timer > 0 and skill.info.Manual then
    hero.readyToUlt = true
    return
  end
  hero.state = ed.emUnitState_Attack
  hero.walk_v = {0, 0}
  local skillatkc = hero.skills.PA_atkc
  if skill == hero.basic_skill and ed.rand() < skill.info["Script Arg2"] then
    skill = skillatkc
  end
  hero.current_skill = skill
  skill:start(target)
  if skill.info["Stolen Tag"] == 2 and not skill.info.Manual and hero.info["Fit For Rubick"] then
    hero.last_stolen_skill = skill
    hero.last_stolen_skill_puppet = hero.puppet_stack[#hero.puppet_stack]
  end
  if skill.info.Manual and ed.engine:isTowerWarsMode() and hero.firstManualCast and hero.camp == ed.emCampPlayer then
    hero.manually_casting = true
    ed.engine:freeze(hero.camp)
    hero:unfreeze()
    hero.firstManualCast = false
  end
end

function ChessPA.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillatk = hero.skills.PA_atk
  local skillult = hero.skills.PA_ult
  local skillatkc = hero.skills.PA_atkc
  if skillult then
    skillatk.start = override(skillatk.start, ChessPA.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, ChessPA.skillatk_onPhaseFinished)
    hero.castSkill = override(hero.castSkill, ChessPA.hero_castSkill)
  end
  return hero
end

return ChessPA.init_hero
