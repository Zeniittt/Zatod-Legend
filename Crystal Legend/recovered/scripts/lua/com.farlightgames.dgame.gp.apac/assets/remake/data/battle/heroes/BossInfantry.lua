module("ed.battlehero", package.seeall)
local ed = ed
BossInfantry = {}
BossInfantry.range_interval = 150
BossInfantry.atk2_cost_hp = 20
BossInfantry.name = "BossInfantry"

function BossInfantry.skill2_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = owner.skills[BossInfantry.name .. "_atk"]
  skillatk.info = skillatk.originfo
  skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  owner.attack_range = owner.attack_range + BossInfantry.range_interval
  owner.medBuff = nil
  return basefunc(buff)
end

function BossInfantry.skillult_onPhaseFinished(basefunc, skill)
  basefunc(skill)
  local position = skill.caster.position
  position[1] = position[1] - 40
end

function BossInfantry.skillult_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 140,
      ["Point Effect"] = false,
      ["Knock Back"] = 70,
      ["Knock Up"] = 0.2,
      ["Basic Num"] = 10,
      ["Plus Ratio"] = 0.3
    })
    basefunc(skill, location, source)
    skill.info = originfo
  elseif attack_counter == 2 then
    basefunc(skill, location, source)
  end
end

function BossInfantry.skillult_takeEffectOn(basefunc, skill, target, source)
  if skill.attack_counter == 1 then
    local bid = 92
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  end
  basefunc(skill, target, source)
end

function BossInfantry.skillatk2_createBuff(basefunc, skill, target)
  local hpcost = skill.caster.attribs.HP * 0.2
  skill.caster:takeDamage(hpcost, "Holy", "hp", skill.caster)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk = caster.skills[BossInfantry.name .. "_atk"]
  skillatk.originfo = skillatk.info
  skillatk.info = ed.wraptable(skillatk.originfo, {
    ["Max Range"] = skillatk.info["Max Range"] - BossInfantry.range_interval,
    ["Gain MP"] = 30
  })
  skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  skillatk.cd_remaining = 0
  caster.attack_range = caster.attack_range - BossInfantry.range_interval
  caster.medBuff = true
  buff.onRemoved = override(buff.onRemoved, BossInfantry.skill2_buffOnRemoved)
  return buff
end

function BossInfantry.skillatk_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  if skill.caster.medBuff then
    skill:startPhase(2)
  else
    skill:startPhase(1)
  end
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if ed.run_with_scene then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function BossInfantry.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function BossInfantry.skillatk_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power, i = basefunc(skill, source, target, damage_type)
  return power * 0.8 ^ (skill.attack_counter - 1), i
end

function BossInfantry.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local hpcost = caster.attribs.HP * skill.info["Cost HP"] * 0.01
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if hpcost > caster.hp then
    return false, "hp"
  end
  if caster.current_skill and caster.current_skill.info["Skill Name"] == BossInfantry.name .. "_ult" then
    return false, "ult"
  end
  if caster.medBuff then
    return false, "medBuff"
  end
  return true
end

function BossInfantry.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skill2 = hero.skills[BossInfantry.name .. "_atk2"]
  hero.can_cast_manual = hero.can_cast_manual or skill2 and skill2:canCastWithTarget(hero.ai.target)
end

function BossInfantry.hero_castManualSkill(basefunc, hero)
  local skill2 = hero.skills[BossInfantry.name .. "_atk2"]
  if skill2 and hero.mp < 1000 and skill2:canCastWithTarget(hero.ai.target) then
    hero:castSkill(hero.skills[BossInfantry.name .. "_atk2"], hero)
  else
    basefunc(hero)
  end
end

function BossInfantry.hero_ai_findSkillToCast(basefunc, ai)
  local skill = basefunc(ai)
  if skill and skill.info["Skill Name"] == BossInfantry.name .. "_atk2" then
    local caster = skill.caster
    if ed.engine:arenaMode() or not battle_tick.getRealTimePvp() and caster.camp == ed.emCampEnemy then
      return skill
    end
    return caster.skills[BossInfantry.name .. "_atk"]
  end
  return skill
end

function BossInfantry.init_hero(hero)
  local skillult = hero.skills[BossInfantry.name .. "_ult"]
  if skillult then
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, BossInfantry.skillult_onPhaseFinished)
    skillult.takeEffectAt = override(skillult.takeEffectAt, BossInfantry.skillult_takeEffectAt)
    skillult.takeEffectOn = override(skillult.takeEffectOn, BossInfantry.skillult_takeEffectOn)
  end
  local skillatk2 = hero.skills[BossInfantry.name .. "_atk2"]
  if skillatk2 then
    skillatk2.info["Cost HP"] = BossInfantry.atk2_cost_hp
    skillatk2.createBuff = override(skillatk2.createBuff, BossInfantry.skillatk2_createBuff)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, BossInfantry.skillatk2_canCastWithTarget)
  end
  local skillatk = hero.skills[BossInfantry.name .. "_atk"]
  if skillatk then
    skillatk.start = override(skillatk.start, BossInfantry.skillatk_start)
    skillatk.power = override(skillatk.power, BossInfantry.skillatk_power)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, BossInfantry.skillatk_onPhaseFinished)
  end
  hero.update = override(hero.update, BossInfantry.hero_update)
  hero.castManualSkill = override(hero.castManualSkill, BossInfantry.hero_castManualSkill)
  hero.ai.findSkillToCast = override(hero.ai.findSkillToCast, BossInfantry.hero_ai_findSkillToCast)
  return hero
end

return BossInfantry.init_hero
