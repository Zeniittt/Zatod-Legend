module("ed.battlehero", package.seeall)
local ed = ed
BossMed = {}
BossMed.unitName = "BossMed"

function BossMed.reset(basefunc, hero)
  basefunc(hero)
  if not hero.has_resetted then
    hero.has_resetted = true
    local owner = hero
    local bid = 176
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    owner:addBuff(buff, owner)
  end
  hero.position = {
    400 - hero:getInitDir() * 700,
    0
  }
end

function BossMed.createProjectile(basefunc, skill)
  local counter = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if 5 <= counter then
      break
    end
    counter = counter + 1
    skill.target = unit
    local projectile = basefunc(skill, unit)
    projectile.dmgModifier = 1
    projectile:enableTrack(unit)
    ed.engine:addProjectile(projectile)
  end
end

function BossMed.power(basefunc, self, source, target, damage_type)
  return basefunc(self, source, target, damage_type) * source.dmgModifier, source.dmgModifier
end

function BossMed.skillatk3_takeEffectAt(basefunc, skill, location)
  local caster = skill.caster
  local bid = 34
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, location)
  caster:removeBuff(buff)
end

function BossMed.skillatk3_takeEffectOn(basefunc, skill, target, source)
  if target and target.config.is_summoned then
    return
  end
  basefunc(skill, target, source)
end

function BossMed.skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossMed.skill6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
end

function BossMed.skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2, 154)
  end
  local skill4 = caster.skills[BossMed.unitName .. "_atk4"]
  skill4.cd_remaining = 0
  local skill5 = caster.skills[BossMed.unitName .. "_atk5"]
  skill5.originfo = skill5.info
  skill5.info = ed.wraptable(skill5.originfo, {CD = 19})
  skill5.cd_remaining = 6
  local stone = skill5.info.buff_info
  skill5.info.origin_buff_info = stone
  skill5.info.buff_info = ed.wraptable(stone, {Time = 10})
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
end

function BossMed.skill5_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local list = caster.buff_list
  for _, buff in pairs(list) do
    if buff.info.Name == "BossMed_shield" then
      caster:removeBuff(buff)
      break
    end
  end
  local skill4 = caster.skills[BossMed.unitName .. "_atk4"]
  skill4.cd_remaining = 8
end

function BossMed.shield_onDamaged(basefunc, buff, damage)
  return damage * 0.3
end

function BossMed.skill4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, BossMed.shield_onDamaged)
  return buff
end

function BossMed.init_hero(hero)
  hero.reset = override(hero.reset, BossMed.reset)
  local skillatk2 = hero.skills[BossMed.unitName .. "_atk2"]
  local skillatk3 = hero.skills[BossMed.unitName .. "_atk3"]
  local skillatk4 = hero.skills[BossMed.unitName .. "_atk4"]
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, BossMed.createProjectile)
    skillatk2.power = override(skillatk2.power, BossMed.power)
  end
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, BossMed.skillatk3_takeEffectAt)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, BossMed.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, BossMed.skill4_createBuff)
  end
  local skill5 = hero.skills[BossMed.unitName .. "_atk5"]
  if skill5 then
    skill5.onAttackFrame = override(skill5.onAttackFrame, BossMed.skill5_onAttackFrame)
  end
  local skill6 = hero.skills[BossMed.unitName .. "_atk6"]
  if skill6 then
    skill6.start = override(skill6.start, BossMed.skill6_start)
    skill6.finish = override(skill6.finish, BossMed.skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, BossMed.skill6_onAttackFrame)
  end
  return hero
end

return BossMed.init_hero
