module("ed.battlehero", package.seeall)
local ed = ed
WorldTitanFrog = {}
WorldTitanFrog.ragelosthp = 35000
WorldTitanFrog.rage2losthp = 15000
WorldTitanFrog.stage2hp = 1750000
WorldTitanFrog.stage2ragelosthp = 7500

function WorldTitanFrog.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if caster and caster:isAlive() and target and target:isAlive() then
    local TargetHAST = 0
    local TargetMSPD = 0
    for i, tbuff in ipairs(target.buff_list) do
      if 0 < tbuff.info.HAST then
        TargetHAST = TargetHAST + tbuff.info.HAST
      end
      if 0 < tbuff.info.MSPD then
        TargetMSPD = TargetMSPD + tbuff.info.MSPD
      end
    end
    local ADDPower = (TargetHAST + TargetMSPD) / 2
    power = power + power * ADDPower / 200
  end
  return power
end

function WorldTitanFrog.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.WorldTitanFrog_atk3
  local skillatk3s = caster.skills.WorldTitanFrog_atk3s
  buff.onRemoved = override(buff.onRemoved, WorldTitanFrog.skillatk3_buffonRemoved)
  return buff
end

function WorldTitanFrog.skillatk3_buffonRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk3 = caster.skills.WorldTitanFrog_atk3
  local skillatk3s = caster.skills.WorldTitanFrog_atk3s
  if buff.owner and skillatk3s and skillatk3 and caster then
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanFrog_atk3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, caster.position, nil, nil, 1)
    end
    if caster then
      skillatk3s:takeEffectAt(caster.position)
    end
  end
  basefunc(buff)
end

function WorldTitanFrog.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1036405
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function WorldTitanFrog.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1036405 then
      tbuff.timer = 0
    end
  end
end

function WorldTitanFrog.setUnitHeight(unit, height)
  unit.height = height
  if unit.actor then
    unit.actor.height = height
  end
end

function WorldTitanFrog.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target:isAlive() then
    target:hurt()
  end
end

function WorldTitanFrog.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, WorldTitanFrog.skillatk4_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, WorldTitanFrog.skillatk4_buffOnRemoved)
  return buff
end

function WorldTitanFrog.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.exsit_time then
    buff.exsit_time = 0
  else
    buff.exsit_time = buff.exsit_time + dt
  end
  if buff.exsit_time >= 14 then
    buff.timer = 0
  end
  if not buff.time_index then
    buff.time_index = 0
  else
    buff.time_index = buff.time_index + 1
  end
  local owner = buff.owner
  if buff.time_index <= 16 then
    WorldTitanFrog.setUnitHeight(owner, owner.height + 5 + (1 + 2 * ed.rand()))
  else
    WorldTitanFrog.setUnitHeight(owner, owner.height + 1 - 2 * ed.rand())
  end
end

function WorldTitanFrog.skillatk4_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk4s = caster.skills.WorldTitanFrog_atk4s
  local owner = buff.owner
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanFrog_atk3.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
  end
  owner.height = 0
  if owner.actor then
    owner.actor.height = 0
  end
  if skillatk4s and owner and owner:isAlive() and not owner.name == "Phoenix" then
    skillatk4s:takeEffectAt(owner.position)
  end
  basefunc(buff)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1036402 then
      tbuff.timer = 0
    end
  end
end

function WorldTitanFrog.skillatk4s_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if caster and caster:isAlive() and target and target:isAlive() then
    local TargetHAST = 0
    local TargetMSPD = 0
    for i, tbuff in ipairs(target.buff_list) do
      if 0 < tbuff.info.HAST then
        TargetHAST = TargetHAST + tbuff.info.HAST
      end
      if 0 < tbuff.info.MSPD then
        TargetMSPD = TargetMSPD + tbuff.info.MSPD
      end
    end
    local ADDPower = (TargetHAST + TargetMSPD) / 2
    power = power + power * ADDPower / 200
  end
  return power
end

function WorldTitanFrog.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  local bid = 1036406
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function WorldTitanFrog.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if caster then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 1036406 then
        tbuff.timer = 0
      end
    end
  end
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 1036403 then
        tbuff.timer = 0
      end
    end
  end
end

function WorldTitanFrog.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.WorldTitanFrog_ult
  local skillults = caster.skills.WorldTitanFrog_ults
  local target = skill.target
  if skillult and target then
    if attack_counter == 0 then
      basefunc(skill)
      if ed.run_with_scene then
        local effect_name = "eff_buff_TitanFrog_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, {
          target.position[1],
          target.position[2] - 1
        }, nil, nil, 1)
      end
    elseif attack_counter == 1 then
      local mp_damage = target.mp
      skillults:takeEffectAt(target.position)
      target:takeDamage(mp_damage, "Holy", "mp", caster, 1, 1, true)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanFrog_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, target.position, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function WorldTitanFrog.skillults_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if caster and caster:isAlive() and target and target:isAlive() then
    local TargetHAST = 0
    local TargetMSPD = 0
    for i, tbuff in ipairs(target.buff_list) do
      if 0 < tbuff.info.HAST then
        TargetHAST = TargetHAST + tbuff.info.HAST
      end
      if 0 < tbuff.info.MSPD then
        TargetMSPD = TargetMSPD + tbuff.info.MSPD
      end
    end
    local ADDPower = (TargetHAST + TargetMSPD) / 2
    power = power + power * ADDPower / 200
    local bid = 1036407
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local slow_buff = ed.BuffCreate(binfo, target, caster)
    slow_buff:setAttribute("HAST", -TargetHAST * 2)
    slow_buff:setAttribute("MSPD", -TargetMSPD * 2)
    target:addBuff(slow_buff, caster)
  end
  return power
end

function WorldTitanFrog.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldTitanFrog.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldTitanFrog.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldTitanFrog.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldTitanFrog.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldTitanFrog.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldTitanFrog.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldTitanFrog.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldTitanFrog.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldTitanFrog.init_hero(hero)
  local skillatk2 = hero.skills.WorldTitanFrog_atk2
  local skillatk3 = hero.skills.WorldTitanFrog_atk3
  local skillatk4 = hero.skills.WorldTitanFrog_atk4
  local skillatk3s = hero.skills.WorldTitanFrog_atk3s
  local skillatk4s = hero.skills.WorldTitanFrog_atk4s
  local skillult = hero.skills.WorldTitanFrog_ult
  local skillults = hero.skills.WorldTitanFrog_ults
  hero.update = override(hero.update, WorldTitanFrog.hero_update)
  hero.reset = override(hero.reset, WorldTitanFrog.hero_reset)
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, WorldTitanFrog.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, WorldTitanFrog.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, WorldTitanFrog.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, WorldTitanFrog.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, WorldTitanFrog.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WorldTitanFrog.skillatk4_takeEffectOn)
  end
  if skillatk4s then
    skillatk4s.power = override(skillatk4s.power, WorldTitanFrog.skillatk4s_power)
  end
  if skillult and skillults then
    skillult.start = override(skillult.start, WorldTitanFrog.skillult_start)
    skillult.finish = override(skillult.finish, WorldTitanFrog.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldTitanFrog.skillult_onAttackFrame)
    skillults.power = override(skillults.power, WorldTitanFrog.skillults_power)
  end
  return hero
end

return WorldTitanFrog.init_hero
