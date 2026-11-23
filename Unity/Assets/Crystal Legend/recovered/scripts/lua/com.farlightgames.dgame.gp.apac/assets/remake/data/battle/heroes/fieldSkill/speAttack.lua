module("ed.battlehero", package.seeall)
local ed = ed
speAttack = {}
speAttack.speAttack_createCd = 0.25
speAttack.speAttack_duration = 7
speAttack.speAttack_mpDamage = 125

function speAttack.speAttack_mirror_update(basefunc, unit, dt)
  unit.field_speMirrorDuration = unit.field_speMirrorDuration - dt
  local heroCount = 0
  for u in ed.engine:foreachAliveUnit(unit.camp) do
    if not u.config.is_summoned then
      heroCount = heroCount + 1
    end
  end
  if heroCount <= 0 or unit.field_speMirrorDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function speAttack.speAttack_mirror_atk_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg = basefunc(skill, target, source, shift)
  if ret then
    target:takeDamage(speAttack.speAttack_mpDamage, "Holy", "mp", skill.caster, 1, 1)
  end
  return ret, dmg
end

function speAttack.speAttack_mirror_ai_searchTarget(basefunc, ai)
  local owner = ai.owner
  local target = owner.field_speMirrorTarget
  if target and target:isAlive() and target ~= owner and not target.buff_effects.untargetable and not target.buffManager.invisible then
    local p0 = owner.position
    local p1 = target.position
    local x = p0[1] - p1[1]
    local y = p0[2] - p1[2]
    local distanceSQ = x * x + y * y
    return target, distanceSQ
  else
    owner.field_speMirrorTarget = nil
  end
  return basefunc(ai)
end

function speAttack.speAttack_support_summonSpe(field, skill, target)
  local proto = {
    _tid = 183,
    _level = 100,
    _stars = field.stars,
    _rank = field.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 2,
    dps_mod = field.config.dps_mod or 1
  }
  local targetPos = target.position
  local mirrorUnit = ed.UnitCreate(proto, -target.camp, config)
  mirrorUnit:setDeathWithEffectOrNot(true)
  mirrorUnit.direction = target.direction
  local deltaX = target.direction > 0 and -38 or 38
  local summonPos = {
    targetPos[1] + deltaX,
    targetPos[2]
  }
  mirrorUnit:pushPuppet("SPEMirror2.cha")
  mirrorUnit:reset()
  mirrorUnit.field_speMirrorTarget = target
  mirrorUnit.field_speMirrorDuration = speAttack.speAttack_duration
  ed.engine:summonUnit(mirrorUnit, summonPos, field)
  mirrorUnit.update = override(mirrorUnit.update, speAttack.speAttack_mirror_update)
  mirrorUnit.ai.searchTarget = override(mirrorUnit.ai.searchTarget, speAttack.speAttack_mirror_ai_searchTarget)
  local mirrorAtk = mirrorUnit.skills.SPEMirror_atk
  if mirrorAtk then
    mirrorAtk.takeEffectOn = override(mirrorAtk.takeEffectOn, speAttack.speAttack_mirror_atk_takeEffectOn)
  end
end

function speAttack.speAttack_0_start(basefunc, skill, target)
  basefunc(skill, target)
  local field = skill.caster
  field.field_speAttackList = {}
  field.field_speCreateCd = 0
end

function speAttack.speAttack_0_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local field = skill.caster
  table.insert(field.field_speAttackList, target)
end

function speAttack.speAttack_0_field_update(basefunc, field, dt, skill)
  basefunc(field, dt, skill)
  local targetList = field.field_speAttackList
  local target
  if targetList then
    target = targetList[#targetList]
  end
  if field.field_speCreateCd then
    field.field_speCreateCd = field.field_speCreateCd + dt
  end
  if target and field.field_speCreateCd >= speAttack.speAttack_createCd then
    field.field_speCreateCd = field.field_speCreateCd - speAttack.speAttack_createCd
    speAttack.speAttack_support_summonSpe(field, skill, target)
    targetList[#targetList] = nil
  end
end

function speAttack.init_fieldSkill(skill, caster)
  skill.start = override(skill.start, speAttack.speAttack_0_start)
  skill.takeEffectOn = override(skill.takeEffectOn, speAttack.speAttack_0_takeEffectOn)
  if caster then
    caster.update = override(caster.update, speAttack.speAttack_0_field_update)
  end
  return skill, caster
end

return speAttack.init_fieldSkill
