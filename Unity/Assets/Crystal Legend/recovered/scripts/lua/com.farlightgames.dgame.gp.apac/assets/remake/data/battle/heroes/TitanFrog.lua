module("ed.battlehero", package.seeall)
local ed = ed
TitanFrog = {}

function TitanFrog.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.25
  return power
end

function TitanFrog.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanFrog_atk3
  local skillatk3s = caster.skills.TitanFrog_atk3s
  if skillatk3 and skillatk3s and buff and buff.owner and caster.TitanFrog_hasArcana > 1 and caster then
    if caster then
      skillatk3s:takeEffectAt(caster.position)
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanFrog_atk3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, caster.position, nil, nil, 1)
    end
  end
  buff.onRemoved = override(buff.onRemoved, TitanFrog.skillatk3_buffonRemoved)
  return buff
end

function TitanFrog.skillatk3_buffonRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk3 = caster.skills.TitanFrog_atk3
  local skillatk3s = caster.skills.TitanFrog_atk3s
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

function TitanFrog.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4672
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanFrog.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4672 then
      tbuff.timer = 0
    end
  end
end

function TitanFrog.setUnitHeight(unit, height)
  unit.height = height
  if unit.actor then
    unit.actor.height = height
  end
end

function TitanFrog.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target:isAlive() then
    target:hurt()
  end
end

function TitanFrog.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanFrog.skillatk4_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, TitanFrog.skillatk4_buffOnRemoved)
  return buff
end

function TitanFrog.skillatk4_buffUpdate(basefunc, buff, dt)
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
    TitanFrog.setUnitHeight(owner, owner.height + 5 + (1 + 2 * ed.rand()))
  else
    TitanFrog.setUnitHeight(owner, owner.height + 1 - 2 * ed.rand())
  end
end

function TitanFrog.skillatk4_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk4s = caster.skills.TitanFrog_atk4s
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
    if tbuff.info.ID == 4670 then
      tbuff.timer = 0
    end
  end
end

function TitanFrog.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  local bid = 4673
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function TitanFrog.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if caster then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 4673 then
        tbuff.timer = 0
      end
    end
  end
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 4671 then
        tbuff.timer = 0
      end
    end
  end
end

function TitanFrog.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.TitanFrog_ult
  local skillults = caster.skills.TitanFrog_ults
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
      if caster.TitanFrog_hasArcana > 3 and caster then
        local unit_num = 0
        for unit in ed.engine:foreachAliveUnit(caster.camp) do
          if unit.info["Unit Type"] == "Hero" then
            unit_num = unit_num + 1
          end
        end
        local mp_gain = mp_damage / unit_num
        for unit in ed.engine:foreachAliveUnit(caster.camp) do
          if unit.info["Unit Type"] == "Hero" then
            unit:takeHeal(mp_gain, "mp", caster)
          end
        end
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanFrog.init_hero(hero)
  local skillatk2 = hero.skills.TitanFrog_atk2
  local skillatk3 = hero.skills.TitanFrog_atk3
  local skillatk4 = hero.skills.TitanFrog_atk4
  local skillatk3s = hero.skills.TitanFrog_atk3s
  local skillatk4s = hero.skills.TitanFrog_atk4s
  local skillult = hero.skills.TitanFrog_ult
  local skillults = hero.skills.TitanFrog_ults
  hero.TitanFrog_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 and hero.TitanFrog_hasArcana and hero.TitanFrog_hasArcana > 2 then
    skillatk2.power = override(skillatk2.power, TitanFrog.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanFrog.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanFrog.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanFrog.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanFrog.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanFrog.skillatk4_takeEffectOn)
  end
  if skillult and skillults then
    skillult.start = override(skillult.start, TitanFrog.skillult_start)
    skillult.finish = override(skillult.finish, TitanFrog.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanFrog.skillult_onAttackFrame)
  end
  return hero
end

return TitanFrog.init_hero
