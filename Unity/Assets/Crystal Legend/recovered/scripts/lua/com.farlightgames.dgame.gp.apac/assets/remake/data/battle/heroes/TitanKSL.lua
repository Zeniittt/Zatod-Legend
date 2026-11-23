module("ed.battlehero", package.seeall)
local ed = ed
TitanKSL = {}

function TitanKSL.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillenter = hero.skills.TitanKSL_enter
  if hero.config.is_boss then
    local bid = 4695
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
  if skillenter then
    local bid = 4758
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero.enter_buff = hero:addBuff(binfo, hero)
    local bid1 = 4760
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    hero.building_buff = hero:addBuff(binfo1, hero)
    local dir = hero:getInitDir()
    hero:setPosition({
      400 - 260 * dir,
      0
    })
  end
  hero.TitanKSL_enter_casted = false
  hero.walk_v = {0, 0}
  hero.zSpeed = 0
  hero.height = 0
  hero.knockup_time = -1
  hero.knockup_v = {0, 0}
  hero.info["Walk Speed"] = 60
end

function TitanKSL.skillenter_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4758 then
      tbuff.timer = -1
    end
  end
  local bid = 4757
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanKSL.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4757 then
      tbuff.timer = -1
    end
  end
  caster.TitanKSL_enter_casted = true
end

function TitanKSL.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4759
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  skill.info["Ignore Shield"] = true
  local target_position = TitanKSL.DOP_in_battlefield(caster, 300, caster.foecamp)
  local dir = caster:getInitDir()
  if (caster.position[1] - target_position[1]) * dir < 0 then
    caster.direction = dir
  end
  basefunc(skill, target)
end

function TitanKSL.skillult_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4759 then
      tbuff.timer = -1
    end
  end
  basefunc(skill, target)
end

function TitanKSL.DOP_in_battlefield(caster, radius, camp)
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
    return caster.position
  end
end

function TitanKSL.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanKSL_atk2
  local MPR_ratio = skillatk2.info["Script Arg3"]
  for j, bbuff in ipairs(target.buff_list) do
    if bbuff.info.ID ~= 4754 and skillatk2 then
      local bid = 4754
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("MPR", MPR_ratio)
      target:addBuff(buff, caster)
      target.buff_distance = math.abs(caster.position[1] - target.position[1])
      buff.update = override(buff.update, TitanKSL.skillatk2buff_update)
    end
  end
  basefunc(skill, target, source)
end

function TitanKSL.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.TitanKSL_ult
  local target = skill.target
  local target_position = TitanKSL.DOP_in_battlefield(caster, 300, caster.foecamp)
  if skillult then
    if attack_counter == 0 then
      target_position = TitanKSL.DOP_in_battlefield(caster, 300, caster.foecamp)
      skill.attack_counter = skill.attack_counter + 1
      skillult:takeEffectAt(target_position, caster)
    elseif attack_counter == 1 and target_position then
      skillult:takeEffectAt(target_position, caster)
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 2 and target_position then
      skillult:takeEffectAt(target_position, caster)
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 3 and target_position then
      skillult:takeEffectAt(target_position, caster)
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanKSL.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
end

function TitanKSL.skillatk2_createBuff(basefunc, skill, target)
  local target = skill.target
  local caster = skill.caster
  target.buff_distance = math.abs(caster.position[1] - target.position[1])
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanKSL.skillatk2buff_update)
  return buff
end

function TitanKSL.skillatk2buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local dir = caster:getInitDir()
  local owner = buff.owner
  local skillatk2 = caster.skills.TitanKSL_atk2
  local Holy_dmg = skillatk2.info["Script Arg2"]
  local new_distance = math.abs(caster.position[1] - owner.position[1])
  local check_distance = math.abs(new_distance - owner.buff_distance)
  if 80 < check_distance then
    if check_distance > owner.buff_distance then
      if caster.TitanKSL_hasArcana and 1 < caster.TitanKSL_hasArcana then
        owner:takeDamage(Holy_dmg, "Holy", "hp", owner)
        owner.buff_distance = new_distance
      end
    elseif check_distance < owner.buff_distance and caster.TitanKSL_hasArcana and 1 < caster.TitanKSL_hasArcana then
      local bid = 4761
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      owner:addBuff(binfo, owner)
      owner.buff_distance = new_distance
    end
  end
end

function TitanKSL.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
end

function TitanKSL.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanKSL_atk3
  local skillatk3s = caster.skills.TitanKSL_atk3s
  local target = skill.target
  local TitanKSL_atk3region
  if skillatk3 then
    if attack_counter == 0 then
      local bid = 4763
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, caster)
      if ed.run_with_scene then
        local effect_name = "eff_impact_TitanKSL_atk3.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, target.position, {
          caster.direction * 1,
          1
        }, nil, 1)
      end
      if caster.name == "TitanKSL" and skillatk3 and skillatk3s and caster.TitanKSL_hasArcana and caster.TitanKSL_hasArcana > 3 then
        skillatk3s.target = target
        TitanKSL_atk3region = skillatk3s:createRegion()
        target.TitanKSL_atk3region = TitanKSL_atk3region
        local position = {
          target.position[1] + 15 * caster.direction,
          target.position[2]
        }
        TitanKSL_atk3region.position = position
        ed.engine:addRegion(TitanKSL_atk3region)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      basefunc(skill)
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanKSL.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4765
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanKSL.skillatk4_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4765 then
      tbuff.timer = -1
    end
  end
  basefunc(skill, target)
end

function TitanKSL.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanKSL_atk4
  local skillatk4s = caster.skills.TitanKSL_atk4s
  local target = skill.target
  local TitanKSL_atk4region
  if skillatk4 then
    if attack_counter ~= 2 then
      basefunc(skill)
    elseif attack_counter == 2 then
      basefunc(skill)
      for unit in ed.engine:foreachAliveUnit(-caster.camp) do
        local atk4_distance = math.abs(caster.position[1] - unit.position[1])
        if atk4_distance < 100 then
          caster:takeHeal(50, "mp", caster)
        end
      end
      if caster.name == "TitanKSL" and skillatk4 and skillatk4s then
        skillatk4s.target = caster
        TitanKSL_atk4region = skillatk4s:createRegion()
        target.TitanKSL_atk3region = TitanKSL_atk4region
        local position = {
          caster.position[1],
          caster.position[2]
        }
        TitanKSL_atk4region.position = position
        TitanKSL_atk4region.affect_camp = -caster.camp
        ed.engine:addRegion(TitanKSL_atk4region)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanKSL.init_hero(hero)
  local skillult = hero.skills.TitanKSL_ult
  local skillatk2 = hero.skills.TitanKSL_atk2
  local skillatk3 = hero.skills.TitanKSL_atk3
  local skillatk4 = hero.skills.TitanKSL_atk4
  local skillenter = hero.skills.TitanKSL_enter
  hero.TitanKSL_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanKSL.skillatk2_createBuff)
    skillatk2.start = override(skillatk2.start, TitanKSL.skillatk2_start)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanKSL.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, TitanKSL.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanKSL.skillatk4_onAttackFrame)
    skillatk4.start = override(skillatk4.start, TitanKSL.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanKSL.skillatk4_finish)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanKSL.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanKSL.skillult_start)
    skillult.finish = override(skillult.finish, TitanKSL.skillult_finish)
    if hero.TitanKSL_hasArcana and hero.TitanKSL_hasArcana > 2 then
      skillult.takeEffectOn = override(skillult.takeEffectOn, TitanKSL.skillult_takeEffectOn)
    end
  end
  if skillenter then
    skillenter.start = override(skillenter.start, TitanKSL.skillenter_start)
    skillenter.finish = override(skillenter.finish, TitanKSL.skillenter_finish)
  end
  hero.reset = override(hero.reset, TitanKSL.hero_reset)
  return hero
end

return TitanKSL.init_hero
