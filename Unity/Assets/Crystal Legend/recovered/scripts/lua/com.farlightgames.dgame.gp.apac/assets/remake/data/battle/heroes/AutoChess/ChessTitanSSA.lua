module("ed.battlehero", package.seeall)
local ed = ed
ChessTitanSSA = {}

function ChessTitanSSA.skillult_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local target = skill.target
  if not target then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if not target then
        target = unit
      elseif unit.attribs.ARM < target.attribs.ARM then
        target = unit
      end
    end
    skill.target = target
  end
  if idx == 2 then
    caster.TitanSSA_ult_oriposition = {}
    caster.TitanSSA_ult_oriposition[1] = caster.position[1]
    caster.TitanSSA_ult_oriposition[2] = caster.position[2]
    local dir = caster.direction
    if target then
      local dir = math.abs(caster.position[1] - target.position[1]) / (caster.position[1] - target.position[1])
    end
    if dir ~= 1 and dir ~= -1 and dir ~= 0 then
      dir = target.direction
    end
    if target and target:isAlive() then
      caster.position = {
        target.position[1] + dir,
        target.position[2] - 1
      }
    else
      skill:interrupt()
      skill.cd_remaining = skill.info.CD * 0.25
    end
  elseif idx == 3 then
    local maxarm = 0
    local targetunit
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if maxarm < unit.attribs.ARM then
        maxarm = unit.attribs.ARM
        targetunit = unit
      end
    end
    if targetunit and targetunit ~= caster then
      caster.position[1] = math.min(math.max(30, targetunit.position[1] - targetunit.direction * 180), 770)
      caster.direction = targetunit.direction
    else
      caster.position[1] = caster.TitanSSA_ult_oriposition[1]
      caster.position[2] = caster.TitanSSA_ult_oriposition[2]
    end
  end
  basefunc(skill, idx)
end

function ChessTitanSSA.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 3 then
    return false
  else
    return basefunc(skill, target, source, shift)
  end
end

function ChessTitanSSA.init_hero(hero)
  local skillult = hero.skills.TitanSSA_ult
  if skillult then
    skillult.startPhase = override(skillult.startPhase, ChessTitanSSA.skillult_startPhase)
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessTitanSSA.skillult_takeEffectOn)
  end
  return hero
end

return ChessTitanSSA.init_hero
