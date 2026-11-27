module("ed.battlehero", package.seeall)
local ed = ed
local math = ed.math
Cyborg = {}
Cyborg.Cyborg_atk3_friend_radius = 150
Cyborg.Cyborg_awakeBuffID = 1469
Cyborg.Cyborg_awakeBuff_ratio = 0.5
Cyborg.Cyborg_atk3_range = 150
Cyborg.Cyborg_atk3_highHP = 0.8
Cyborg.Cyborg_atk3_lowHP = 0.2

function Cyborg.DOP_in_battlefield(caster, radius, camp)
  local point_list = {}
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local x = 0
  local y = 0
  local distance = 0
  local mindistance = 999999999
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
  end
  if maxcount <= 0 then
    return false
  end
end

function Cyborg.cheer(basefunc, actor)
  local puppet = actor.puppet
  local cheerActionName = actor.model.direction == 1 and "Cheer" or "Cheer_r"
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  actor.velocity = {0, 0}
  actor.node:setScaleX(actor.model.direction)
  actor.node:setScaleY(1)
  actor.offline = true
end

function Cyborg.getFixDir(basefunc, unit)
  return unit.Cyborg_fixdir and unit.Cyborg_fixdir or unit.direction
end

function Cyborg.setAction(basefunc, hero, action_name, loop, interrupt)
  local movable = not hero.buff_effects.immoblilize
  local pos = hero.position
  local v1 = movable and hero.walk_v or ed.edpZero
  if hero.buff_effects.fix then
    hero.direction = hero:getFixDir()
  else
    local direction = 0
    if movable and v1[1] ~= 0 then
      direction = v1[1]
    elseif hero.current_skill and hero.current_skill.target and not hero.current_skill.casterDirectionLocked then
      direction = hero.current_skill.target.position[1] - pos[1]
    end
    if direction * hero.direction < 0 then
      hero.direction = hero.direction * -1
    end
  end
  if action_name then
    local puppetName = hero.puppet_stack[#hero.puppet_stack]
    puppetName = ed.lookupDataTable("Puppet", "Resource", puppetName) .. ".cha"
    if hero.direction == -1 or hero:getInitDir() == -1 and action_name == "Move2" then
      local action_r = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name .. "_r")
      if action_r then
        action_name = action_name .. "_r"
      end
    end
    hero.action_loop = loop or false
    if loop and action_name == hero.action_name then
      return
    end
    hero.action_name = action_name
    hero.action_elapsed = interrupt and 0 or math.max(0, hero.action_elapsed - hero.action_duration)
    if not loop and action_name ~= nil then
      hero.action_duration = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name)
      if not hero.action_duration then
        print("nil action duration in table AnimDuration puppetName -> " .. puppetName)
        print("nil action duration in table AnimDuration action_name -> " .. action_name)
        hero.action_name = "Idle"
        hero.action_duration = 1.375
      end
    else
      hero.action_duration = 0
    end
    if hero.actor then
      hero.actor:onStartNewAction()
    end
  end
end

function Cyborg.DeafBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local caster = buff.caster
  if source and not transferred and caster.name == "Cyborg" and owner.current_skill ~= owner.manual_skill then
    local have_awakeBuff
    if owner and owner.buff_list and #owner.buff_list > 0 then
      for i, tbuff in ipairs(owner.buff_list) do
        if tbuff.info.ID == Cyborg.Cyborg_awakeBuffID then
          have_awakeBuff = true
        end
      end
    end
    if source and source.position and 0 > (source.position[1] - owner.position[1]) * owner.direction or source and source.camp and source.camp ~= owner.camp and have_awakeBuff then
      local holydamage = caster.skills.Cyborg_ult.info["Script Arg2"]
      owner:takeDamage(holydamage / source.attribs.PDM, "Holy", "hp", source, 1, 0, true)
      if ed.rand() < Cyborg.Cyborg_awakeBuff_ratio then
        local bid = 7
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = owner:addBuff(binfo, caster)
      end
    end
  end
  return damage
end

function Cyborg.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Cyborg_firstin = true
  hero.cheer_action_reset = nil
  local skillenter = hero.skills.Cyborg_enter
  if skillenter then
    local dir = hero:getInitDir()
    hero:setPosition({
      400 - 300 * dir,
      0
    })
    local bid = 1456
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
  end
end

function Cyborg.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.Cyborg_firstin then
    local skillatk4 = hero.skills.Cyborg_atk4
    if skillatk4 then
      hero:addBuff(skillatk4:createBuff(hero))
    end
    hero.Cyborg_firstin = nil
  end
  if ed.run_with_scene and not hero.cheer_action_reset and hero.actor then
    hero.cheer_action_reset = true
    hero.actor.cheer = override(hero.actor.cheer, Cyborg.cheer)
  end
end

function Cyborg.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.Cyborg_fixdir = caster.direction
  local bid = 1454
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.Cyborg_ult_ori_position = {
    caster.position[1],
    caster.position[2]
  }
end

function Cyborg.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1454 then
      caster:removeBuff(tbuff)
    end
  end
end

function Cyborg.skillults2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Cyborg.DeafBuff_onDamaged)
  return buff
end

function Cyborg.ultbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner.actor then
    owner.actor:launch(0)
  end
end

function Cyborg.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  local dir = 1
  if target and caster.position[1] > target.position[1] then
    dir = -1
  end
  local skillults = caster.skills.Cyborg_ults
  local skillults2 = caster.skills.Cyborg_ults2
  local skillults3 = caster.skills.Cyborg_ults3
  if attack_counter == 0 then
    if target then
      caster:setPosition({
        target.position[1] + dir * 75,
        target.position[2]
      })
      skill.attack_counter = skill.attack_counter + 1
    else
      skill:finish()
    end
  elseif attack_counter == 1 then
    basefunc(skill)
    if target and not target:isHasUncontrolBufEffect() then
      target:hurt()
    end
  elseif attack_counter == 2 then
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
      end
      local bid = 1455
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.onRemoved = override(buff.onRemoved, Cyborg.ultbuff_onRemoved)
      caster.ultfrozenbuff = target:addBuff(buff, caster)
      local t = 0.25
      local dir = caster:getInitDir()
      if caster.position[1] - target.position[1] ~= 0 then
        dir = (caster.position[1] - target.position[1]) / math.abs(caster.position[1] - target.position[1])
      end
      local distance = {
        caster.position[1] - target.position[1] - 75 * dir,
        caster.position[2] - target.position[2]
      }
      target:knockup(t, distance, true)
      target.height = 50
      if target.actor then
        target.actor.height = 50
      end
      skillults:takeEffectOn(target, caster, true)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    if target then
      if caster.ultfrozenbuff then
        caster.ultfrozenbuff.timer = 0
      end
      skillults:takeEffectOn(target, caster, true)
      skill.attack_counter = skill.attack_counter + 1
    else
      skill:finish()
    end
  elseif attack_counter == 4 then
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
      end
      local bid = 1455
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.onRemoved = override(buff.onRemoved, Cyborg.ultbuff_onRemoved)
      caster.ultfrozenbuff = target:addBuff(buff, caster)
      local t = 0.05
      local dir = caster:getInitDir()
      if caster.position[1] - target.position[1] ~= 0 then
        dir = (caster.position[1] - target.position[1]) / math.abs(caster.position[1] - target.position[1])
      end
      local distance = {
        caster.position[1] - target.position[1] - 75 * dir,
        caster.position[2] - target.position[2]
      }
      target:knockup(t, distance, true)
      target.height = 50
      if target.actor then
        target.actor.height = 50
      end
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 5 then
    if caster.ultfrozenbuff then
      caster.ultfrozenbuff.timer = 0
    end
    if target then
      skillults2:takeEffectOn(target, caster, true)
      skillults3:takeEffectAt(caster.position, caster)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 6 then
    caster:setPosition({
      caster.Cyborg_ult_ori_position[1],
      caster.Cyborg_ult_ori_position[2]
    })
  end
end

function Cyborg.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.Cyborg_fixdir = caster.direction
  local bid = 1468
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Cyborg.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Cyborg.DeafBuff_onDamaged)
  return buff
end

function Cyborg.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local distanceX = 25
  local distanceY = 10
  local caster = skill.caster
  local knockY
  if target and target:isAlive() and target.position[2] < caster.position[2] then
    distanceY = -10
  end
  local knock_ratio = math.abs(skill:launchPoint()[1], target.position[1]) / 150
  if result and target and target:isAlive() then
    if target.position[2] >= 50 or target.position[2] <= -50 then
      knockY = 0
    else
      knockY = distanceY * knock_ratio
    end
    local diff = target.position[1] - caster.position[1] == 0 and 1 or target.position[1] - caster.position[1]
    target:knockup(0.1, {
      distanceX * knock_ratio * math.abs(diff) / diff,
      knockY
    }, shift)
  end
end

function Cyborg.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1468 then
      tbuff.timer = 0
    end
  end
end

function Cyborg.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1465
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Cyborg.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  if result then
    local caster = skill.caster
    local temp_heroes_highHP = {}
    local temp_heroes_lowHP = {}
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      local unitdistance = ed.edpDistanceSQ(caster.position, unit.position)
      local unit_HPratio = unit.hp / unit.attribs.HP
      if unit ~= caster and unitdistance <= Cyborg.Cyborg_atk3_range * Cyborg.Cyborg_atk3_range then
        if unit_HPratio > Cyborg.Cyborg_atk3_highHP then
          table.insert(temp_heroes_highHP, {unit, unit_HPratio})
        elseif unit_HPratio < Cyborg.Cyborg_atk3_lowHP then
          table.insert(temp_heroes_lowHP, {unit, unit_HPratio})
        end
      end
    end
    table.sort(temp_heroes_highHP, function(a, b)
      return a[2] > b[2]
    end)
    table.sort(temp_heroes_lowHP, function(a, b)
      return a[2] < b[2]
    end)
    if 0 < #temp_heroes_highHP and temp_heroes_highHP[1][1] then
      skill.Cyborg_atk3_friend1 = temp_heroes_highHP[1][1]
      skill.Cyborg_atk3_camp = caster.foecamp
      if 1 < #temp_heroes_highHP then
        skill.Cyborg_atk3_friend2 = temp_heroes_highHP[2][1]
      end
    elseif 0 < #temp_heroes_lowHP and temp_heroes_lowHP[1][1] then
      skill.Cyborg_atk3_friend1 = temp_heroes_lowHP[1][1]
      skill.Cyborg_atk3_camp = caster.camp
      if 1 < #temp_heroes_lowHP then
        skill.Cyborg_atk3_friend2 = temp_heroes_lowHP[2][1]
      end
    else
      return nil
    end
  end
  return result
end

function Cyborg.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local target1 = skill.Cyborg_atk3_friend1
  local target2 = skill.Cyborg_atk3_friend2
  if attack_counter == 0 then
    caster.Cyborg_ori_position = {
      caster.position[1],
      caster.position[2]
    }
    if target1 and target1:isAlive() then
      local bid = 1464
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster.Cyborg_atk3_target1buff = target1:addBuff(binfo, caster)
      if ed.run_with_scene then
        local effect_name = "eff_point_Cyborg_atk3.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, target1.position, {1, 1}, nil, 1, nil, nil, nil)
      end
    end
    if target2 and target2:isAlive() then
      local bid = 1464
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster.Cyborg_atk3_target2buff = target2:addBuff(binfo, caster)
      if ed.run_with_scene then
        local effect_name = "eff_point_Cyborg_atk3.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, target2.position, {1, 1}, nil, 1, nil, nil, nil)
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    if target1 and target1:isAlive() then
      local bid = 1464
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster.Cyborg_atk3_target1buff = target1:addBuff(binfo, caster)
    end
    if target2 and target2:isAlive() then
      local bid = 1464
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster.Cyborg_atk3_target2buff = target2:addBuff(binfo, caster)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    basefunc(skill)
    local position = Cyborg.DOP_in_battlefield(caster, 150, skill.Cyborg_atk3_camp)
    if position then
      caster:setPosition({
        position[1],
        position[2]
      })
      if target1 and target1:isAlive() then
        if caster.Cyborg_atk3_target1buff then
          caster.Cyborg_atk3_target1buff.timer = 0
        end
        target1:setPosition({
          target1.position[1] + (position[1] - caster.Cyborg_ori_position[1]),
          target1.position[2] + (position[2] - caster.Cyborg_ori_position[2])
        })
      end
      if target2 and target2:isAlive() then
        if caster.Cyborg_atk3_target2buff then
          caster.Cyborg_atk3_target2buff.timer = 0
        end
        target2:setPosition({
          target2.position[1] + (position[1] - caster.Cyborg_ori_position[1]),
          target2.position[2] + (position[2] - caster.Cyborg_ori_position[1])
        })
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    if target1 and target1:isAlive() and caster.Cyborg_atk3_target1buff then
      caster.Cyborg_atk3_target1buff.timer = 0
    end
    if target2 and target2:isAlive() and caster.Cyborg_atk3_target2buff then
      caster.Cyborg_atk3_target2buff.timer = 0
    end
  end
end

function Cyborg.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1465 then
      tbuff.timer = 0
    end
  end
  local bid = 1466
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("PIMU", skill.info["Script Arg2"])
  buff:setAttribute("MIMU", skill.info["Script Arg3"])
  caster:addBuff(buff, caster)
  local target1 = skill.Cyborg_atk3_friend1
  local target2 = skill.Cyborg_atk3_friend2
  if target1 then
    target1:addBuff(buff, caster)
  end
  if target2 then
    target2:addBuff(buff, caster)
  end
end

function Cyborg.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.Cyborg_fixdir = caster.direction
  local bid = 1471
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Cyborg.skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1471 then
      tbuff.timer = 0
    end
  end
end

function Cyborg.skillawake_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if ed.run_with_scene then
    local effect_name = "eff_point_Cyborg_atk4.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, 1, nil, nil, nil)
  end
end

function Cyborg.init_hero(hero)
  local skillult = hero.skills.Cyborg_ult
  local skillults2 = hero.skills.Cyborg_ults2
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Cyborg.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Cyborg.skillult_start)
    skillult.finish = override(skillult.finish, Cyborg.skillult_finish)
    skillults2.finish = override(skillult.finish, Cyborg.skillult_finish)
    skillults2.createBuff = override(skillults2.createBuff, Cyborg.skillults2_createBuff)
  end
  local skillatk2 = hero.skills.Cyborg_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Cyborg.skillatk2_takeEffectOn)
    skillatk2.start = override(skillatk2.start, Cyborg.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, Cyborg.skillatk2_finish)
    skillatk2.createBuff = override(skillatk2.createBuff, Cyborg.skillatk2_createBuff)
  end
  local skillatk3 = hero.skills.Cyborg_atk3
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Cyborg.skillatk3_onAttackFrame)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Cyborg.skillatk3_canCastWithTarget)
    skillatk3.start = override(skillatk3.start, Cyborg.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, Cyborg.skillatk3_finish)
  end
  local skillawake = hero.skills.Cyborg_awake
  if skillawake then
    skillawake.onAttackFrame = override(skillawake.onAttackFrame, Cyborg.skillawake_onAttackFrame)
  end
  local skillatk = hero.skills.Cyborg_atk
  if skillatk then
    skillatk.start = override(skillatk.start, Cyborg.skillatk_start)
    skillatk.finish = override(skillatk.finish, Cyborg.skillatk_finish)
  end
  hero.reset = override(hero.reset, Cyborg.hero_reset)
  hero.getFixDir = override(hero.getFixDir, Cyborg.getFixDir)
  hero.update = override(hero.update, Cyborg.hero_update)
  hero.setAction = override(hero.setAction, Cyborg.setAction)
  return hero
end

return Cyborg.init_hero
