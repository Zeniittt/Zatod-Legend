module("ed.battlehero", package.seeall)
local ed = ed
ExBossHuskar = {}
ExBossHuskar.timegap = 0.25
ExBossHuskar.collidedis = 30

function ExBossHuskar.reset(basefunc, hero)
  basefunc(hero)
  if not hero.has_resetted then
    hero.has_resetted = true
    local owner = hero
    local bid = 152
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    owner:addBuff(buff, owner)
  end
end

function ExBossHuskar.skill_atk2_createProjectile(basefunc, skill)
  local skill5 = skill.caster.skills.ExBossHuskar_atk5
  if skill.target and skill.target.config and skill.target.config.is_summoned then
    local shortCD = 5.5
    skill5.cd_remaining = skill5.cd_remaining / skill5.info.CD * shortCD
    skill5.info = ed.wraptable(skill5.originfo, {CD = shortCD})
  else
    local longCD = 10
    skill5.cd_remaining = skill5.cd_remaining / skill5.info.CD * longCD
    skill5.info = ed.wraptable(skill5.originfo, {CD = longCD})
  end
  local projectile = basefunc(skill)
  projectile:enableTrack(skill.target)
  return projectile
end

function ExBossHuskar.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local d = ed.edpSub(skill.target.position, caster.position)
    if d[1] == 0 and d[2] == 0 then
      caster.walk_v = {0, 0}
    else
      local d2 = ed.edpSub(d, ed.edpMult(ed.edpNormalize(d), ExBossHuskar.collidedis))
      caster.walk_v = {
        d2[1] / ExBossHuskar.timegap,
        d2[2] / ExBossHuskar.timegap
      }
    end
  else
    local bid = 98
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    local perc = 24.3
    if caster.level <= 25 then
      perc = 30
    elseif caster.level <= 36 then
      perc = 28
    elseif caster.level <= 47 then
      perc = 26
    elseif caster.level <= 55 then
      perc = 24.8
    elseif caster.level <= 60 then
      perc = 24.7
    elseif caster.level <= 70 then
      perc = 24.6
    elseif caster.level <= 75 then
      perc = 24.5
    elseif caster.level <= 80 then
      perc = 24.45
    elseif caster.level <= 85 then
      perc = 24.4
    elseif caster.level <= 90 then
      perc = 24.35
    elseif caster.level > 90 then
      perc = 24.3
    end
    local leftHp = math.max(caster.attribs.HP * 0.003, caster.hp - caster.attribs.HP * perc / 100)
    local damage = caster.hp - leftHp
    caster:setHP(leftHp)
    if ed.run_with_scene then
      local floor = math.floor
      local str = "-" .. floor(damage + 0.5)
      if str ~= "-0" then
        local color = "orange"
        ed.PopupCreate(str, color, caster.actor, false)
      end
    end
    caster.walk_v = {0, 0}
    basefunc(skill, target, source)
  end
end

function ExBossHuskar.skillatk2_power(basefunc, skill, source, target, damage_type)
  local ratio = 0.08
  local hero = skill.caster
  if hero.level <= 25 then
    ratio = 0.01
  elseif hero.level <= 36 then
    ratio = 0.015
  elseif hero.level <= 47 then
    ratio = 0.02
  elseif hero.level <= 55 then
    ratio = 0.025
  elseif hero.level <= 60 then
    ratio = 0.03
  elseif hero.level <= 70 then
    ratio = 0.35
  elseif hero.level <= 75 then
    ratio = 0.04
  elseif hero.level <= 80 then
    ratio = 0.05
  elseif hero.level <= 85 then
    ratio = 0.06
  elseif hero.level <= 90 then
    ratio = 0.07
  elseif hero.level > 90 then
    ratio = 0.08
  end
  local power = target.attribs.HP * ratio
  return power, 1
end

function ExBossHuskar.init_hero(hero)
  hero.reset = override(hero.reset, ExBossHuskar.reset)
  local skill2 = hero.skills.ExBossHuskar_atk2
  if skill2 then
    skill2.createProjectile = override(skill2.createProjectile, ExBossHuskar.skill_atk2_createProjectile)
  end
  local skillult = hero.skills.ExBossHuskar_atk3
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, ExBossHuskar.skillult_takeEffectOn)
  end
  local skill5 = hero.skills.ExBossHuskar_atk5
  if skill5 then
    skill5.originfo = skill5.info
  end
  return hero
end

return ExBossHuskar.init_hero
