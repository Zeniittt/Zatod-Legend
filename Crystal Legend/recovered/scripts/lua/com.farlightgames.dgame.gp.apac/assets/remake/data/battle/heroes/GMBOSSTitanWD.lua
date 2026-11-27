module("ed.battlehero", package.seeall)
local ed = ed
GMBOSSTitanWD = {}
GMBOSSTitanWD.GMBOSSTitanWD_HPratio = 1000000

function GMBOSSTitanWD.hero_reset(basefunc, hero)
  basefunc(hero)
end

function GMBOSSTitanWD.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.2
  return power
end

function GMBOSSTitanWD.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if result and (caster.current_skill == caster.skills.GMBOSSTitanWD_atk3 or caster.current_skill == caster.skills.GMBOSSTitanWD_atk4) then
    result = false
  end
  return result, reason
end

function GMBOSSTitanWD.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4467
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    unit.GMBOSSTitanWD_ult_hit = 0
  end
end

function GMBOSSTitanWD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4467 then
      tbuff.timer = 0
    end
  end
end

function GMBOSSTitanWD.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(6)
  if skill.caster.GMBOSSTitanWD_hasArcana and skill.caster.GMBOSSTitanWD_hasArcana > 3 then
    projectile.hit = override(projectile.hit, GMBOSSTitanWD.projectile_hit)
    projectile.terminate = override(projectile.terminate, GMBOSSTitanWD.projectile_terminate)
  end
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
      else
        local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
    return ret
  end
  
  return projectile
end

function GMBOSSTitanWD.projectile_hit(basefunc, projectile, target)
  basefunc(projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target.GMBOSSTitanWD_ult_hit then
    target.GMBOSSTitanWD_ult_hit = target.GMBOSSTitanWD_ult_hit + 1
    if target.GMBOSSTitanWD_ult_hit == 2 then
      local bid = 4468
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("fearrange", 5)
      target:addBuff(buff, caster)
    end
  end
end

function GMBOSSTitanWD.projectile_terminate(basefunc, projectile)
  basefunc(projectile)
end

function GMBOSSTitanWD.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    return {400, 0}
  end
end

function GMBOSSTitanWD.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target.config.is_boss then
    buff.timer = buff.timer * 0.5
  end
  local caster = skill.caster
  local bid = 4469
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff_s = target:addBuff(binfo, caster)
  buff_s.timer = buff.timer
  return buff
end

function GMBOSSTitanWD.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  if lost > GMBOSSTitanWD.GMBOSSTitanWD_HPratio then
    lost = GMBOSSTitanWD.GMBOSSTitanWD_HPratio
  end
  return lost
end

function GMBOSSTitanWD.init_hero(hero)
  local skillult = hero.skills.GMBOSSTitanWD_ult
  local skillatk2 = hero.skills.GMBOSSTitanWD_atk2
  local skillatk3 = hero.skills.GMBOSSTitanWD_atk3
  local skillatk4 = hero.skills.GMBOSSTitanWD_atk4
  hero.GMBOSSTitanWD_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 and hero.GMBOSSTitanWD_hasArcana > 1 then
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["Chain Jumps"] = 4
    })
    skillatk2.power = override(skillatk2.power, GMBOSSTitanWD.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GMBOSSTitanWD.skillatk3_createBuff)
  end
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, GMBOSSTitanWD.skillult_canCastWithTarget)
    skillult.createProjectile = override(skillult.createProjectile, GMBOSSTitanWD.skillult_createProjectile)
    skillult.start = override(skillult.start, GMBOSSTitanWD.skillult_start)
    skillult.finish = override(skillult.finish, GMBOSSTitanWD.skillult_finish)
  end
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, GMBOSSTitanWD.hero_getLostHPAfterImmunity)
  hero.reset = override(hero.reset, GMBOSSTitanWD.hero_reset)
  return hero
end

return GMBOSSTitanWD.init_hero
