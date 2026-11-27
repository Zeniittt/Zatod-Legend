module("ed.battlehero", package.seeall)
local ed = ed
MeatWagon = {}

function MeatWagon.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local caster = skill.caster
  local max = -math.huge
  local farthest_target = skill.target
  local caster_position = caster.position
  
  local function selector(unit)
    return ed.edpDistanceSQ(unit.position, skill.caster.position)
  end
  
  local Ignore = skill:Ignore_Target_Type()
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif skill:targetCamp() == caster.camp and unit.controlledTarget then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= skill.min_range_sq and distanceSQ <= 640000 then
        local v = selector(unit)
        local shouldIgnore = Ignore(unit)
        if max < v and not shouldIgnore then
          max = v
          farthest_target = unit
        end
      end
    end
  end
  local skilltarget = farthest_target
  local dir = caster.direction
  local targetpositionx = skilltarget.position[1]
  local targetpositiony = skilltarget.position[2]
  local xdistance = math.abs(targetpositionx - caster.position[1])
  if xdistance <= 300 then
    targetpositionx = caster.position[1] + dir * 300
  end
  local targetposition = {targetpositionx, targetpositiony}
  local distance = ed.edpSub(targetposition, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  ed.engine:addProjectile(projectile)
end

function MeatWagon.init_hero(hero)
  local skillatk = hero.skills.MeatWagon_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, MeatWagon.skillatk_createProjectile)
  end
  return hero
end

return MeatWagon.init_hero
