module("ed.battlehero", package.seeall)
local ed = ed
local math = ed.math
TitanCyborg = {}

function TitanCyborg.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk4arcana_ratio = 0
  hero.last_hp = hero.attribs.HP
end

function TitanCyborg.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.hp < hero.last_hp then
    hero.atk4arcana_ratio = hero.atk4arcana_ratio + (hero.last_hp - hero.hp)
    hero.last_hp = hero.hp
  end
  if hero.hp > hero.last_hp then
    hero.last_hp = hero.hp
  end
end

function TitanCyborg.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4801
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanCyborg.skillult_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4801 then
      tbuff.timer = -1
    end
  end
  if caster.TitanCyborg_hasArcana and caster.TitanCyborg_hasArcana > 1 then
    local bid = 4805
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  basefunc(skill, target)
end

function TitanCyborg.DOP_in_battlefield(caster, radius, camp)
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

function TitanCyborg.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.TitanCyborg_ult
  local target = skill.target
  local target_position = TitanCyborg.DOP_in_battlefield(caster, 350, caster.foecamp)
  if skillult then
    if attack_counter == 0 then
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      local target_position = TitanCyborg.DOP_in_battlefield(caster, 350, caster.foecamp)
      if target_position then
        caster:setPosition({
          target_position[1],
          target_position[2]
        })
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 2 then
      if target_position then
        skillult:takeEffectAt(target_position, caster)
        if ed.run_with_scene then
          ed.scene:startCameraShakeAnimationY(50, 0.1, 2)
        end
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanCyborg.skillatk_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local ratio = ed.rand()
  local new_rand = 0
  local skillatk3 = caster.skills.TitanCyborg_atk3
  if caster.TitanCyborg_hasArcana and caster.TitanCyborg_hasArcana > 3 then
    local hp_ratio = math.ceil(caster.hp / caster.attribs.HP * 10)
    local new_rand = 1 - hp_ratio / 10
  end
  local atk2_rand = new_rand + 0.4
  if 0.8 < atk2_rand then
    atk2_rand = 0.8
  end
  if ratio < atk2_rand and skillatk3 then
    if ratio < 0.33 * atk2_rand then
      local bid = 4797
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, caster)
    elseif ratio >= 0.33 * atk2_rand and ratio < 0.66 * atk2_rand then
      local bid = 4802
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, caster)
    elseif ratio >= 0.66 * atk2_rand then
      local bid = 4804
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, caster)
    end
    local atk3heal_ratio = skillatk3.info["Script Arg4"]
    TitanCyborg.add_Shield(caster, atk3heal_ratio)
  end
  basefunc(skill, target, source)
end

function TitanCyborg.shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanCyborg_shield = nil
end

function TitanCyborg.add_Shield(hero, shield_vaule)
  local max = 150000
  if not hero.TitanCyborg_shield then
    local bid = 4806
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local shield_buff = ed.BuffCreate(binfo, hero, hero)
    shield_buff.onRemoved = override(shield_buff.onRemoved, TitanCyborg.shield_onRemoved)
    shield_buff.shield = shield_vaule
    hero.TitanCyborg_shield = hero:addBuff(shield_buff, hero)
    if max < shield_buff.shield then
      shield_buff.shield = max
    end
  else
    local buff = hero.TitanCyborg_shield
    local shield = buff.shield
    buff.shield = shield + shield_vaule
    buff.timer = buff.info.Time
    if buff.shield <= 0 and hero.TitanCyborg_shield then
      hero:removeBuff(hero.TitanCyborg_shield)
    end
    if max < buff.shield then
      buff.shield = max
    end
  end
end

function TitanCyborg.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanCyborg_atk2
  local skillatk2s = caster.skills.TitanCyborg_atk2s
  local skillatk2s2 = caster.skills.TitanCyborg_atk2s2
  local target = skill.target
  if target then
    local target_position = target.position
    local atk2hp_ration = 0.1 * caster.hp
    if skillatk2 then
      if attack_counter == 0 then
        caster:takeDamage(atk2hp_ration, "Holy", "hp", caster)
        basefunc(skill)
      elseif attack_counter == 1 then
        if skillatk2s and target then
          skillatk2s:takeEffectOn(target, caster)
        end
        skill.attack_counter = skill.attack_counter + 1
      elseif attack_counter == 2 then
        if skillatk2s2 then
          skillatk2s2:takeEffectAt(target_position, caster)
        end
        skill.attack_counter = skill.attack_counter + 1
      end
    end
  end
end

function TitanCyborg.skillatk2_finish(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanCyborg_atk2
  local shield_value = skillatk2.info["Script Arg3"]
  TitanCyborg.add_Shield(caster, shield_value)
  basefunc(skill, target)
end

function TitanCyborg.hero_onDying(basefunc, hero, killer)
  local skillatk3 = hero.skills.TitanCyborg_atk3
  if skillatk3 then
    local attribs_ratio = skillatk3.info["Script Arg3"] / 100
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      local AttriBinfo = ed.lookupDataTable("Buff", nil, 4803)
      TitanCyborg.changeBuffInfo(AttriBinfo, attribs_ratio, unit, 1)
      local buff = unit:addBuff(AttriBinfo, hero)
    end
  end
  basefunc(hero, killer)
end

function TitanCyborg.changeBuffInfo(buffInfo, enhance, target, mode)
  local attrib_temp = {}
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
    end
  end
  if buffInfo.ID == 4803 then
    buffInfo.TEN = 10
  end
end

function TitanCyborg.skillatk4_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanCyborg_atk4
  if caster.atk4arcana_ratio and caster.atk4arcana_ratio > 360000 then
    caster.atk4arcana_ratio = 360000
  end
  if caster.TitanCyborg_hasArcana and caster.TitanCyborg_hasArcana > 2 then
    target:takeDamage(caster.atk4arcana_ratio * 0.5, "Holy", "hp", caster)
  end
  basefunc(skill, target, source)
end

function TitanCyborg.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4807
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanCyborg.skillatk4_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4807 then
      tbuff.timer = -1
    end
  end
  basefunc(skill, target)
end

function TitanCyborg.init_hero(hero)
  local skillult = hero.skills.TitanCyborg_ult
  local skillatk = hero.skills.TitanCyborg_atk
  local skillatk2 = hero.skills.TitanCyborg_atk2
  local skillatk3 = hero.skills.TitanCyborg_atk3
  local skillatk4 = hero.skills.TitanCyborg_atk4
  hero.TitanCyborg_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if hero.TitanCyborg_hasArcana and hero.TitanCyborg_hasArcana > 2 then
    hero.reset = override(hero.reset, TitanCyborg.hero_reset)
    hero.update = override(hero.update, TitanCyborg.hero_update)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanCyborg.skillatk_takeEffectOn)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanCyborg.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanCyborg.skillult_start)
    skillult.finish = override(skillult.finish, TitanCyborg.skillult_finish)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanCyborg.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, TitanCyborg.skillatk2_finish)
  end
  if skillatk3 then
    hero.onDying = override(hero.onDying, TitanCyborg.hero_onDying)
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanCyborg.skillatk4_takeEffectOn)
    if hero.TitanCyborg_hasArcana and hero.TitanCyborg_hasArcana > 2 then
      skillatk4.start = override(skillatk4.start, TitanCyborg.skillatk4_start)
      skillatk4.finish = override(skillatk4.finish, TitanCyborg.skillatk4_finish)
    end
  end
  return hero
end

return TitanCyborg.init_hero
