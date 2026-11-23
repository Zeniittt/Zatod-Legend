module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossAM = {}
AwakeBossAM.skillminSQ = 14400
AwakeBossAM.Evobuff = 10037701
AwakeBossAM.atk2 = 10037702
AwakeBossAM.atk3 = 10037703

function AwakeBossAM.skillatk2_start(basefunc, skill, target)
  local info = skill.info
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local caster = skill.caster
  local distanceSQ
  if skill.target then
    distanceSQ = (skill.target.position[1] - caster.position[1]) ^ 2 + (skill.target.position[2] - skill.target.position[2]) ^ 2
  end
  if distanceSQ and distanceSQ > AwakeBossAM.skillminSQ then
    skill:startPhase(1)
    local bid = AwakeBossAM.atk2
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = skill.caster
    caster:addBuff(binfo, caster)
  else
    skill:startPhase(2)
  end
  caster.global_cd = info["Global CD"]
  if ed.run_with_scene then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function AwakeBossAM.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    skill.caster.position = {
      skill.target.position[1] - skill.caster.direction * 70,
      skill.target.position[2]
    }
  else
    local skillevo = caster.skills.AwakeBossAM_evo
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == AwakeBossAM.Evobuff then
        buff.timer = 0
      end
    end
    skillevo:takeEffectOn(caster, caster)
    basefunc(skill, location, source)
  end
end

function AwakeBossAM.skillatk2_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 1 then
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == AwakeBossAM.atk2 then
        local buff = tbuff
        buff.timer = -1
      end
    end
  end
  basefunc(skill)
end

function AwakeBossAM.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local mppower = 100
  local ret, dmg = basefunc(skill, target, source)
  if ret then
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
  end
  return ret, dmg
end

function AwakeBossAM.skillevo_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.shield = buff.shield + caster.attribs.AD
  return buff
end

function AwakeBossAM.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local position1 = skill.target.position[1] + caster.direction * 70
      if skill.target.buff_effects.stable or 799 < position1 or position1 < 1 then
        position1 = position1 - caster.direction * 140
      end
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
    end
  else
    local skillevo = caster.skills.AwakeBossAM_evo
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == AwakeBossAM.Evobuff then
        buff.timer = 0
      end
    end
    skillevo:takeEffectOn(caster, caster)
    basefunc(skill, location, source)
  end
end

function AwakeBossAM.skillult_takeEffectOn(basefunc, skill, target, source)
  local mppower = target.mp / 2
  local ret, dmg = basefunc(skill, target, source)
  if ret then
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
  end
  return ret, dmg
end

function AwakeBossAM.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = AwakeBossAM.atk3
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function AwakeBossAM.init_hero(hero)
  local skillult = hero.skills.AwakeBossAM_ult
  local skillatk = hero.skills.AwakeBossAM_atk
  local skillatk2 = hero.skills.AwakeBossAM_atk2
  local skillevo = hero.skills.AwakeBossAM_evo
  hero.reset = override(hero.reset, AwakeBossAM.hero_reset)
  local count1, count2
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "AwakeBossAM_pasv" then
      count1 = i
    end
  end
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "AwakeBossAM_pasv2" then
      count2 = i
    end
  end
  local skillpasv = hero.passive_skill_list[count1]
  local skillpasv2 = hero.passive_skill_list[count2]
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, AwakeBossAM.skillult_takeEffectAt)
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossAM.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, AwakeBossAM.skillatk2_start)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, AwakeBossAM.skillatk2_takeEffectAt)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, AwakeBossAM.skillatk2_takeEffectOn)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, AwakeBossAM.skillatk2_onPhaseFinished)
  end
  if skillevo then
    skillevo.createBuff = override(skillevo.createBuff, AwakeBossAM.skillevo_createBuff)
  end
  if skillpasv then
    local anAwakeBossAMe = skillpasv["Passive Attr"]
    hero:rebuild()
  end
  if skillpasv2 then
    local anAwakeBossAMe = skillpasv2["Passive Attr"]
    hero:rebuild()
  end
  return hero
end

return AwakeBossAM.init_hero
