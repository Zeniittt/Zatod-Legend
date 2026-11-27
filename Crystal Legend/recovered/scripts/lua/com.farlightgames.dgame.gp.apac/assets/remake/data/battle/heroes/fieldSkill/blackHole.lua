module("ed.battlehero", package.seeall)
local ed = ed
blackHole = {}
blackHole.minX = ed.engine.stage_rect.minX
blackHole.maxX = ed.engine.stage_rect.maxX
blackHole.blackHoleStartTime = 0
blackHole.blackHoleStartTime2 = 2
blackHole.holePositionDeltaX = 175
blackHole.knock_count = 0
blackHole.ult_r = 30
blackHole.ult_maxR = 200

function blackHole.region_update(basefunc, region, dt)
  basefunc(region, dt)
  if not region.effecton then
    if ed.run_with_scene then
      local effect_name = "eff_point_field_blackHole.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, region.position, {1, 1}, nil, -1)
      effect:setZOrder(9999)
      region.scene_effect = effect
    end
    region.effecton = true
  end
end

function blackHole.region_terminate(basefunc, region)
  if ed.run_with_scene and region.scene_effect then
    ed.scene:removeEffect(region.scene_effect, -1)
  end
  basefunc(region)
end

function blackHole.skill_createRegion(basefunc, skill)
  local region = basefunc(skill)
  region.update = override(region.update, blackHole.region_update)
  region.terminate = override(region.terminate, blackHole.region_terminate)
  return region
end

function blackHole.buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.knock_count = buff.knock_count - 1
  local caster = buff.caster
  local owner = buff.owner
  local region_position = caster.blackHole_leftPos
  if owner.position[1] >= (blackHole.minX + blackHole.maxX) / 2 then
    region_position = caster.blackHole_rightPos
  end
  local time = 0.05
  local distance = -2
  local distanceplus = 0
  local distance_last = -2
  local direction = {1, 0}
  local DistanceSQ = ed.edpDistanceSQ(owner.position, region_position)
  if buff.knock_count < 0 and DistanceSQ < blackHole.ult_maxR * blackHole.ult_maxR then
    if owner.position[1] == region_position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    elseif DistanceSQ < blackHole.ult_r * blackHole.ult_r then
      local directionold = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      direction[1] = -directionold[2]
      direction[2] = directionold[1]
      distance_last = distance + distanceplus
    elseif DistanceSQ < 3600 then
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = 2.3 * (distance + distanceplus * (blackHole.ult_maxR - math.sqrt(DistanceSQ)) / (blackHole.ult_maxR - blackHole.ult_r))
    elseif DistanceSQ < 8100 then
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = 2.3 * (distance + distanceplus * (blackHole.ult_maxR - math.sqrt(DistanceSQ)) / (blackHole.ult_maxR - blackHole.ult_r))
    elseif DistanceSQ < 14400 then
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = 2.8 * (distance + distanceplus * (blackHole.ult_maxR - math.sqrt(DistanceSQ)) / (blackHole.ult_maxR - blackHole.ult_r))
    elseif DistanceSQ < 22500 then
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = 3.8 * (distance + distanceplus * (blackHole.ult_maxR - math.sqrt(DistanceSQ)) / (blackHole.ult_maxR - blackHole.ult_r))
    elseif DistanceSQ then
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = 1 * (distance + distanceplus * (blackHole.ult_maxR - math.sqrt(DistanceSQ)) / (blackHole.ult_maxR - blackHole.ult_r))
    end
    owner:knockup(time, ed.edpMult(direction, distance_last), true)
    buff.knock_count = blackHole.knock_count
  end
end

function blackHole.skill_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, blackHole.buff_update)
  buff.knock_count = blackHole.knock_count
  return buff
end

function blackHole.createBlackHole(skill, position, LorR)
  local tPosition = {}
  tPosition[1] = position[1]
  tPosition[2] = position[2]
  local caster = skill.caster
  skill.target = caster
  if LorR == "L" then
    caster.blackHole_leftPos = tPosition
  elseif LorR == "R" then
    caster.blackHole_rightPos = tPosition
  end
  local region = skill:createRegion()
  region.position = tPosition
  ed.engine:addRegion(region)
  return region
end

function blackHole.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if not skill.initialAlready then
    skill.initialAlready = true
    skill.battleStartTime = 0
  end
  if skill.initialAlready then
    skill.battleStartTime = skill.battleStartTime and skill.battleStartTime + dt_cd
    if skill.battleStartTime and not skill.blackHoleStartEffect and skill.battleStartTime >= blackHole.blackHoleStartTime and ed.run_with_scene then
      local effect_name = "eff_point_Enigma_ult.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, -1)
      skill.blackHoleStartEffect = effect
    end
    if skill.battleStartTime and skill.battleStartTime >= blackHole.blackHoleStartTime2 then
      skill.battleStartTime = nil
      local position = {
        blackHole.minX + blackHole.holePositionDeltaX,
        0
      }
      local hole = blackHole.createBlackHole(skill, position, "L")
      local position = {
        blackHole.maxX - blackHole.holePositionDeltaX,
        0
      }
      local hole = blackHole.createBlackHole(skill, position, "R")
      if ed.run_with_scene then
        if skill.blackHoleStartEffect then
          ed.scene:removeEffect(skill.blackHoleStartEffect, -1)
        end
        local effect_name = "eff_point_Enigma_ult3.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, -1)
        skill.blackHoleStartEffect = effect
      end
    end
  end
end

function blackHole.init_fieldSkill(skill)
  skill.update = override(skill.update, blackHole.skill_update)
  skill.createBuff = override(skill.createBuff, blackHole.skill_createBuff)
  skill.createRegion = override(skill.createRegion, blackHole.skill_createRegion)
  return skill
end

return blackHole.init_fieldSkill
