module("ed.battlehero", package.seeall)
local ed = ed
TitanWD = {}

function TitanWD.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanWD.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.2
  return power
end

function TitanWD.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if result and (caster.current_skill == caster.skills.TitanWD_atk3 or caster.current_skill == caster.skills.TitanWD_atk4) then
    result = false
  end
  return result, reason
end

function TitanWD.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4467
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    unit.TitanWD_ult_hit = 0
  end
end

function TitanWD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4467 then
      tbuff.timer = 0
    end
  end
end

function TitanWD.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(6)
  if skill.caster.TitanWD_hasArcana and skill.caster.TitanWD_hasArcana > 3 then
    projectile.hit = override(projectile.hit, TitanWD.projectile_hit)
    projectile.terminate = override(projectile.terminate, TitanWD.projectile_terminate)
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

function TitanWD.projectile_hit(basefunc, projectile, target)
  basefunc(projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target.TitanWD_ult_hit then
    target.TitanWD_ult_hit = target.TitanWD_ult_hit + 1
    if target.TitanWD_ult_hit == 2 then
      local bid = 4468
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("fearrange", 5)
      target:addBuff(buff, caster)
    end
  end
end

function TitanWD.projectile_terminate(basefunc, projectile)
  basefunc(projectile)
end

function TitanWD.skillatk4_selectTarget(basefunc, skill, default)
  local target_type = skill.info["Target Type"]
  local Ignore = skill:Ignore_Target_Type()
  local caster = skill.caster
  local EnemiesPosition = TitanWD.DOP_in_battlefield(caster, 80, caster.foecamp)
  local min = math.huge
  local chosen
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.buff_effects.untargetable then
    elseif enchanted and unit == caster then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq and EnemiesPosition then
        local EnemiesdistanceSQ = ed.edpDistanceSQ(unit.position, EnemiesPosition)
        local shouldIgnore = Ignore(unit)
        if min > EnemiesdistanceSQ and not shouldIgnore then
          min = EnemiesdistanceSQ
          chosen = unit
        end
      end
    end
  end
  skill.target = chosen
  return skill.target
end

function TitanWD.DOP_in_battlefield(caster, radius, camp)
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

function TitanWD.skillatk3_createBuff(basefunc, skill, target)
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

function TitanWD.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target.info.Union and target.info.Union == "Dark" then
    local PIMU = buff.info.PIMU
    local MIMU = buff.info.MIMU
    buff.timer = buff.timer * 2
    buff:setAttribute("PIMU", PIMU + 20)
    buff:setAttribute("MIMU", MIMU + 20)
  end
  return buff
end

function TitanWD.init_hero(hero)
  local skillult = hero.skills.TitanWD_ult
  local skillatk2 = hero.skills.TitanWD_atk2
  local skillatk3 = hero.skills.TitanWD_atk3
  local skillatk4 = hero.skills.TitanWD_atk4
  hero.TitanWD_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 and hero.TitanWD_hasArcana > 1 then
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["Chain Jumps"] = 4
    })
    skillatk2.power = override(skillatk2.power, TitanWD.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanWD.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.selectTarget = override(skillatk4.selectTarget, TitanWD.skillatk4_selectTarget)
    if hero.TitanWD_hasArcana > 2 then
      skillatk4.createBuff = override(skillatk4.createBuff, TitanWD.skillatk4_createBuff)
    end
  end
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanWD.skillult_canCastWithTarget)
    skillult.createProjectile = override(skillult.createProjectile, TitanWD.skillult_createProjectile)
    skillult.start = override(skillult.start, TitanWD.skillult_start)
    skillult.finish = override(skillult.finish, TitanWD.skillult_finish)
  end
  hero.reset = override(hero.reset, TitanWD.hero_reset)
  return hero
end

return TitanWD.init_hero
