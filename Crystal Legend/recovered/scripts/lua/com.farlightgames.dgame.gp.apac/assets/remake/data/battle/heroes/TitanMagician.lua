module("ed.battlehero", package.seeall)
local ed = ed
TitanMagician = {}

function TitanMagician.arcana_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.25
  return power
end

function TitanMagician.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4731
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanMagician.skillult_finish(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanMagician_atk4
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4731 then
      tbuff.timer = -1
    end
  end
  basefunc(skill, target)
end

function TitanMagician.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.TitanMagician_ult
  local target = skill.target
  if skillult and target then
    if attack_counter == 0 then
      if ed.run_with_scene and skillult then
        caster.effect1 = ed.scene:playEffectOnScene("eff_point_TitanMagician_ult.cha", {
          target.position[1],
          target.position[2]
        }, {1, 1}, nil, -1)
        caster.effect2 = ed.scene:playEffectOnScene("eff_point_TitanMagician_ultb.cha", {
          target.position[1],
          target.position[2]
        }, {1, 1}, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      basefunc(skill)
    end
  end
end

function TitanMagician.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4733
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanMagician.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanMagician_atk2
  local HASTratio = -skillatk2.info["Script Arg2"]
  local MPratio = skillatk2.info["Script Arg3"]
  basefunc(skill, target, source)
  caster.atk2_win = false
  local enemy_int = 0
  local friend_int = 0
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    friend_int = friend_int + unit.attribs.INT
  end
  for hero in ed.engine:foreachAliveUnit(-caster.camp) do
    enemy_int = enemy_int + hero.attribs.INT
  end
  if friend_int > enemy_int then
    caster.atk2_win = true
  end
  if skillatk2 then
    if caster.atk2_win then
      for unit in ed.engine:foreachAliveUnit(-caster.camp) do
        local bid = 4734
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local bbuff = ed.BuffCreate(binfo, unit, caster)
        bbuff:setAttribute("HAST", HASTratio)
        bbuff:setAttribute("MSPD", HASTratio)
        unit:addBuff(bbuff, unit)
      end
      for hero in ed.engine:foreachAliveUnit(caster.camp) do
        hero:takeHeal(MPratio / 2, "mp", hero)
      end
    else
      for unit in ed.engine:foreachAliveUnit(caster.camp) do
        unit:takeHeal(MPratio, "mp", unit)
      end
    end
  end
  if caster.TitanMagician_hasArcana and 2 < caster.TitanMagician_hasArcana then
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      for i, tbuff in ipairs(unit.buff_list) do
        if 0 < tbuff.info.HAST or 0 < tbuff.info.MSPD then
          local bid = 4735
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local bbuff = ed.BuffCreate(binfo, unit, caster)
          unit:addBuff(bbuff, unit)
        end
      end
    end
  end
end

function TitanMagician.skillatk2_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4733 then
      tbuff.timer = -1
    end
  end
  basefunc(skill, target)
end

function TitanMagician.skillakt3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, TitanMagician.skillatk3_buffonRemoved)
  return buff
end

function TitanMagician.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanMagician_atk3
  skillatk3.info["Ignore Shield"] = true
  basefunc(skill, target)
end

function TitanMagician.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanMagician_atk3
  local target = skill.target
  if skillatk3 and target then
    if attack_counter == 0 then
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      basefunc(skill)
      local buff = skill:createBuff(target)
      buff.onRemoved = override(buff.onRemoved, TitanMagician.skillatk3_buffonRemoved)
    end
  end
end

function TitanMagician.skillatk3_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = caster.skills.TitanMagician_atk3
  local Holy_dmg = skillatk3.info["Script Arg2"]
  if owner and skillatk3 and caster then
    owner:takeDamage(Holy_dmg, "Holy", "hp", owner)
  end
end

function TitanMagician.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanMagician.skillatk4buff_update)
  return buff
end

function TitanMagician.skillatk4_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanMagician_atk4
  local MPRratio = skillatk4.info["Script Arg2"]
  caster.HEALratio = skillatk4.info["Script Arg3"]
  local bid = 4728
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local tbuff = ed.BuffCreate(binfo, caster, caster)
  caster.atk4buff = true
  tbuff:setAttribute("MPR", MPRratio)
  caster:addBuff(tbuff, caster)
end

function TitanMagician.skillatk4buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if not caster.atk4buff then
    buff.timer = -1
  end
  if owner and owner.camp == caster.camp and owner.hp / owner.attribs.HP < 0.3 and owner:isAlive() and caster.atk4buff then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 4728 then
        tbuff.timer = -1
        caster.atk4buff = false
      end
    end
    local bid = 4737
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    owner:addBuff(binfo, owner)
    owner:takeHeal(caster.HEALratio, "hp", owner)
    if caster.TitanMagician_hasArcana and caster.TitanMagician_hasArcana > 3 then
      local bid = 4738
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      owner:addBuff(binfo, owner)
    end
  end
end

function TitanMagician.init_hero(hero)
  local skillatk = hero.skills.TitanMagician_atk
  local skillult = hero.skills.TitanMagician_ult
  local skillatk2 = hero.skills.TitanMagician_atk2
  local skillatk3 = hero.skills.TitanMagician_atk3
  local skillatk4 = hero.skills.TitanMagician_atk4
  hero.TitanMagician_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanMagician.skillatk2_takeEffectOn)
    skillatk2.finish = override(skillult.finish, TitanMagician.skillatk2_finish)
    skillatk2.start = override(skillatk2.start, TitanMagician.skillatk2_start)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanMagician.skillatk3_start)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanMagician.skillakt3_createBuff)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanMagician.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanMagician.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanMagician.skillatk4_takeEffectOn)
  end
  if skillult then
    if hero.TitanMagician_hasArcana and hero.TitanMagician_hasArcana > 1 then
      skillult.power = override(skillult.power, TitanMagician.arcana_power)
    end
    skillult.start = override(skillult.start, TitanMagician.skillult_start)
    skillult.finish = override(skillult.finish, TitanMagician.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanMagician.skillult_onAttackFrame)
  end
  return hero
end

return TitanMagician.init_hero
