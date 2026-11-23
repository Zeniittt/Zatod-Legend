module("ed.battlehero", package.seeall)
local ed = ed
TitanOracle = {}

function TitanOracle.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanOracle.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanOracle_atk4
  if hero.TitanOracle_atk4_timer then
    hero.TitanOracle_atk4_timer = hero.TitanOracle_atk4_timer + dt
  else
    hero.TitanOracle_atk4_timer = 13
  end
  if (not (not (hero.TitanOracle_atk4_timer >= 17) or hero.config.is_boss) or hero.TitanOracle_atk4_timer >= 30) and not hero.config.is_summoned and hero.hp / hero.attribs.HP < 0.35 then
    hero.TitanOracle_atk4_timer = 0
    if skillatk4 then
      hero:addBuff(skillatk4:createBuff(hero))
    end
  end
  if hero.TitanOracle_skillatk4_buff and hero.buff_list then
    for _, tbuff in ipairs(hero.buff_list) do
      if 0 > tbuff.info.HPR then
        hero:removeBuff(tbuff)
      end
    end
  end
end

function TitanOracle.skillatk2_onAttackFrame(basufunc, skill)
  basufunc(skill)
  local caster = skill.caster
  local skillatk2s = caster.skills.TitanOracle_atk2s
  if skillatk2s then
    skillatk2s:takeEffectAt(caster.position, caster)
  end
end

function TitanOracle.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if buff.owner.TitanOracle_skillatk2_count and buff.owner.TitanOracle_skillatk2_count > 0 then
    buff.owner.TitanOracle_skillatk2_count = buff.owner.TitanOracle_skillatk2_count + 3
  else
    buff.owner.TitanOracle_skillatk2_count = 3
  end
  buff.update = override(buff.update, TitanOracle.skillatk2_buff_update)
  buff.onDamaged = override(buff.onDamaged, TitanOracle.skillatk2_buff_onDamaged)
  return buff
end

function TitanOracle.skillatk2_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.TitanOracle_skillatk2_count and owner.TitanOracle_skillatk2_count <= 0 then
    buff.timer = -1
  end
end

function TitanOracle.skillatk2_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if skill and 0 < damage and buff.owner.TitanOracle_skillatk2_count and 0 < buff.owner.TitanOracle_skillatk2_count then
    local caster = buff.caster
    local skillatk2 = caster.skills.TitanOracle_atk2
    local dmg_value = skillatk2.info["Script Arg3"]
    damage = damage + dmg_value + caster.attribs.STR * 0.8
    buff.owner.TitanOracle_skillatk2_count = buff.owner.TitanOracle_skillatk2_count - 1
  end
  return damage
end

function TitanOracle.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if buff.owner.TitanOracle_skillatk2s_count and buff.owner.TitanOracle_skillatk2s_count > 0 then
    buff.owner.TitanOracle_skillatk2s_count = buff.owner.TitanOracle_skillatk2s_count + 3
  else
    buff.owner.TitanOracle_skillatk2s_count = 3
  end
  buff.update = override(buff.update, TitanOracle.skillatk2s_buff_update)
  buff.onDamaged = override(buff.onDamaged, TitanOracle.skillatk2s_buff_onDamaged)
  return buff
end

function TitanOracle.skillatk2s_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.TitanOracle_skillatk2s_count and owner.TitanOracle_skillatk2s_count <= 0 then
    buff.timer = -1
  end
end

function TitanOracle.skillatk2s_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if skill and 0 < damage and buff.owner.TitanOracle_skillatk2s_count and 0 < buff.owner.TitanOracle_skillatk2s_count then
    local caster = buff.caster
    local skillatk2 = caster.skills.TitanOracle_atk2
    local dmg_value = skillatk2.info["Script Arg2"]
    damage = math.max(0, damage - dmg_value - caster.attribs.STR * 0.8)
    buff.owner.TitanOracle_skillatk2s_count = buff.owner.TitanOracle_skillatk2s_count - 1
    local effect_name = "eff_buff_TitanOracle_atk2.cha"
    local origin = buff.owner.position
    if ed.run_with_scene and effect_name then
      ed.scene:playEffectOnScene(effect_name, origin, {
        buff.owner.direction * 1,
        1
      }, nil, 1)
    end
  end
  return damage
end

function TitanOracle.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4582
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function TitanOracle.skillatk2_finish(basefunc, skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4582 then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function TitanOracle.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local ratio = 1
  if target and target:isAlive() and target.hp / target.attribs.HP < 0.67 then
    ratio = (2 - target.hp / target.attribs.HP) / 1.1
  end
  return power * ratio, i
end

function TitanOracle.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  if lost and hero.TitanOracle_skillatk4_buff and hero.TitanOracle_skillatk4_dmg then
    hero.TitanOracle_skillatk4_dmg = hero.TitanOracle_skillatk4_dmg + damage
    lost = 0
  end
  if hero.TitanOracle_hasArcana and hero.TitanOracle_hasArcana > 1 and lost and lost > 0.0375 * hero.attribs.HP and source and source:isAlive() then
    if source.TitanOracle_skillatk2_count and 0 < source.TitanOracle_skillatk2_count then
      source.TitanOracle_skillatk2_count = source.TitanOracle_skillatk2_count + 1
    else
      local bid = 4584
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = source:addBuff(binfo, hero)
      source.TitanOracle_skillatk2_count = 1
      buff.update = override(buff.update, TitanOracle.skillatk2_buff_update)
      buff.onDamaged = override(buff.onDamaged, TitanOracle.skillatk2_buff_onDamaged)
    end
  end
  return lost
end

function TitanOracle.skillatk4s_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  if target and target:isAlive() and skill.caster.TitanOracle_skillatk4_dmg then
    power = math.min(power + skill.caster.TitanOracle_skillatk4_dmg, 1500000 * (1.25 - ed.rand() * 0.5))
  end
  return power, i
end

function TitanOracle.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.owner.TitanOracle_skillatk4_buff = true
  buff.owner.TitanOracle_skillatk4s_cancast = true
  buff.owner.TitanOracle_skillatk4_dmg = 0
  buff.update = override(buff.update, TitanOracle.atk4_buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanOracle.atk4_buff_onRemoved)
  local caster = buff.caster
  if caster.TitanOracle_hasArcana and caster.TitanOracle_hasArcana > 2 then
    buff.timer = buff.timer + 2
  end
  return buff
end

function TitanOracle.atk4_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk4s = caster.skills.TitanOracle_atk4s
  local skillult = caster.skills.TitanOracle_ult
  if skillatk4s and buff.timer < 0.42 and caster.TitanOracle_skillatk4s_cancast then
    caster.TitanOracle_skillatk4s_cancast = false
    if caster.current_skill and caster.current_skill ~= caster.manual_skill then
      caster.current_skill:interrupt()
      caster:castSkill(skillatk4s, skillatk4s.target)
    else
      skillatk4s.cd_remaining = 0
      caster.global_cd = 0
    end
  end
end

function TitanOracle.atk4_buff_onRemoved(basefunc, buff)
  buff.owner.TitanOracle_skillatk4_buff = false
  basefunc(buff)
end

function TitanOracle.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4582
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanOracle.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4582 then
      tbuff.timer = 0
    end
  end
end

function TitanOracle.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanOracle_ult
  local skillult_stuntime = skillult.info["Script Arg2"]
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanOracle_ult.cha", {
      caster.position[1],
      caster.position[2]
    }, {1, 1}, nil, 0)
  end
  if skillult and caster and caster:isAlive() then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.config.is_summoned then
      else
        local list = unit.buff_list
        local debuff_list = {}
        local my_camp = caster.camp
        for i = 1, #list do
          local buff = list[i]
          local info = buff.info
          if buff and (not buff.caster or buff.caster.camp ~= my_camp) and (TitanOracle.isCrlEftConflictWithUncontrollableSP(buff) or buff.info.Dispel == "YES") then
            debuff_list[#debuff_list + 1] = buff
          end
        end
        for i = 1, #debuff_list do
          unit:removeBuff(debuff_list[i])
        end
      end
    end
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      local bid = 4586
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, unit, caster)
      buff.timer = skillult_stuntime + math.min(unit.TitanOracle_skillatk2_count and unit.TitanOracle_skillatk2_count * 1 or 0, 10)
      unit.TitanOracle_skillatk2_count = 0
      unit:addBuff(buff, caster)
    end
  end
end

function TitanOracle.isCrlEftConflictWithUncontrollableSP(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function TitanOracle.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local bid = 4529
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  owner:addBuff(binfo, caster)
  buff.onDamaged = override(buff.onDamaged, TitanOracle.skillults_buff_onDamaged)
  return buff
end

function TitanOracle.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if target and target:isAlive() then
    if target.TitanOracle_skillatk2s_count and target.TitanOracle_skillatk2s_count > 0 then
      target.TitanOracle_skillatk2s_count = target.TitanOracle_skillatk2s_count + 3
    else
      local bid = 4583
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, skill.caster)
      target.TitanOracle_skillatk2s_count = 3
      if buff then
        buff.update = override(buff.update, TitanOracle.skillatk2s_buff_update)
        buff.onDamaged = override(buff.onDamaged, TitanOracle.skillatk2s_buff_onDamaged)
      end
    end
  end
end

function TitanOracle.init_hero(hero)
  local skillult = hero.skills.TitanOracle_ult
  local skillatk2 = hero.skills.TitanOracle_atk2
  local skillatk2s = hero.skills.TitanOracle_atk2s
  local skillatk3 = hero.skills.TitanOracle_atk3
  local skillatk4 = hero.skills.TitanOracle_atk4
  local skillatk4s = hero.skills.TitanOracle_atk4s
  hero.TitanOracle_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanOracle.skillatk2_start)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanOracle.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanOracle.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, TitanOracle.skillatk2_finish)
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["No Dodge"] = true,
      ["Ignore Shield"] = true
    })
  end
  if skillatk2s then
    skillatk2s.createBuff = override(skillatk2s.createBuff, TitanOracle.skillatk2s_createBuff)
  end
  if skillatk3 then
    skillatk3.power = override(skillatk3.power, TitanOracle.skillatk3_power)
    if hero.TitanOracle_hasArcana and hero.TitanOracle_hasArcana > 3 then
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanOracle.skillatk3_takeEffectOn)
    end
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanOracle.skillatk4_createBuff)
  end
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanOracle.hero_getLostHPAfterImmunity)
  if skillatk4s then
    skillatk4s.info = ed.wraptable(skillatk4s.info, {
      ["No Dodge"] = true
    })
    skillatk4s.power = override(skillatk4s.power, TitanOracle.skillatk4s_power)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanOracle.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanOracle.skillult_start)
    skillult.finish = override(skillult.finish, TitanOracle.skillult_finish)
  end
  hero.update = override(hero.update, TitanOracle.hero_update)
  hero.reset = override(hero.reset, TitanOracle.hero_reset)
  return hero
end

return TitanOracle.init_hero
