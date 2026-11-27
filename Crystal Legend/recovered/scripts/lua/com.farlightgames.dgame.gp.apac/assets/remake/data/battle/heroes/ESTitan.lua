module("ed.battlehero", package.seeall)
local ed = ed
ESTitan = {}

function ESTitan.skill_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local enemyCount = 0
  local skillatk4 = caster.skills.ESTitan_atk4
  local info = skillatk4.info
  local direction = skill.caster.direction
  local location = skill.caster.position
  local origin = {
    location[1],
    location[2]
  }
  local shape = "circle"
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(skillatk4:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, origin)
    p2[1] = p2[1] * direction
    if skillatk4.testPointInShape(p2, shape, arg1, arg2) then
      enemyCount = enemyCount + 1
      if ed.run_with_scene then
        local effect_name = "eff_point_ES_awake.cha"
        local effect_z = info["Point Zorder"] or 0
        ed.scene:playEffectOnScene(effect_name, unit.position, {direction, 1}, nil, effect_z)
      end
    end
  end
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
  skillatk4.enemyCount = enemyCount
  skillatk4:takeEffectAt(caster.position)
end

function ESTitan.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local enemyCount = 0
  local info = skill.info
  local direction = caster.direction
  local location = caster.position
  local origin = {
    location[1],
    location[2]
  }
  local shape = "circle"
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, origin)
    p2[1] = p2[1] * direction
    if skill.testPointInShape(p2, shape, arg1, arg2) then
      enemyCount = enemyCount + 1
      if ed.run_with_scene then
        local effect_name = "eff_point_ES_awake.cha"
        local effect_z = info["Point Zorder"] or 0
        ed.scene:playEffectOnScene(effect_name, unit.position, {direction, 1}, nil, effect_z)
      end
    end
  end
  caster.skillatk3_enemyCount = enemyCount
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
  local skillatk4 = caster.skills.ESTitan_atk4
  if skillatk4 then
    skillatk4.enemyCount = enemyCount
    skillatk4:takeEffectAt(caster.position)
  end
end

function ESTitan.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.skillatk3_enemyCount then
    buff.timer = math.min(buff.timer + caster.skillatk3_enemyCount * 0.5, 10)
  end
  return buff
end

function ESTitan.skillatk3_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4637
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  local DOPPosition = ESTitan.DOP_in_battlefield(caster, 160, caster.foecamp)
  if DOPPosition and ((caster.position[1] - DOPPosition[1]) ^ 2 + (caster.position[2] - DOPPosition[2]) ^ 2) ^ 0.5 > 80 then
    if ed.run_with_scene then
      local effect_name1 = "eff_impact_NW_ult2.cha"
      local origin = caster.position
      if effect_name1 then
        ed.scene:playEffectOnScene(effect_name1, origin, {
          caster.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
    caster:setPosition({
      DOPPosition[1],
      DOPPosition[2]
    })
  end
end

function ESTitan.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
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
    position = {400, 0}
    return position
  end
end

function ESTitan.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4637 then
      tbuff.timer = 0
    end
  end
end

function ESTitan.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local skillatk2s = caster.skills.ESTitan_atk2s
  if skillatk2s then
    caster:addBuff(skillatk2s:createBuff(caster), caster)
  end
end

function ESTitan.skillult_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  if hero.name == "ESTitan" then
    local distance = ((hero.position[1] - target.position[1]) ^ 2 + (hero.position[2] - target.position[2]) ^ 2) ^ 0.5
    local distance_halo = 180
    local ult_ratio = distance_halo / distance
    if 1 < ult_ratio then
      ult_ratio = 2
    else
      ult_ratio = 1
    end
    local power = power * ult_ratio
    local dmg = target:takeDamage({
      amount = power,
      damage_type = damage_type,
      field = field,
      source = source,
      crit_mod = crit_mod,
      skill = self
    })
    return dmg
  end
end

function ESTitan.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hero = skill.caster
  if hero.name == "ESTitan" then
    local distance = ((hero.position[1] - target.position[1]) ^ 2 + (hero.position[2] - target.position[2]) ^ 2) ^ 0.5
    local distance_halo = 180
    if distance <= distance_halo then
      buff.timer = buff.timer * 2
    end
    return buff
  end
end

function ESTitan.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  return power * skill.enemyCount, coefficient
end

function ESTitan.skillult_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function ESTitan.init_hero(hero)
  local skillatk4 = hero.skills.ESTitan_atk4
  if skillatk4 then
    local skillnames = {"_ult", "_atk2"}
    for i = 1, #skillnames do
      local skill = hero.skills["ESTitan" .. skillnames[i]]
      skill.onAttackFrame = override(skill.onAttackFrame, ESTitan.skill_onAttackFrame)
    end
    skillatk4.power = override(skillatk4.power, ESTitan.skillatk4_power)
  end
  local skillult = hero.skills.ESTitan_ult
  local skillatk2 = hero.skills.ESTitan_atk2
  local skillatk3 = hero.skills.ESTitan_atk3
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, ESTitan.skillatk2_takeEffectAt)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, ESTitan.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, ESTitan.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, ESTitan.skillatk3_createBuff)
    skillatk3.finish = override(skillatk3.finish, ESTitan.skillatk3_finish)
  end
  if skillult then
    skillult.start = override(skillult.start, ESTitan.skillult_start)
    skillult.createBuff = override(skillult.createBuff, ESTitan.skillult_createBuff)
    skillult.getDamage = override(skillult.getDamage, ESTitan.skillult_getDamage)
  end
  return hero
end

return ESTitan.init_hero
