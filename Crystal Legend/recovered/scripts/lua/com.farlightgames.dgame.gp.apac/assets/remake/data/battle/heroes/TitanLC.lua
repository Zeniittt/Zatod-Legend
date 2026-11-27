module("ed.battlehero", package.seeall)
local ed = ed
TitanLC = {}

function TitanLC.skillatk_power(basefunc, skill, source, target, damage_type)
  local origin_power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanLC_atk4
  local power_ratio = 1
  if skillatk4 then
    local atk4_Ratio = skillatk4.info["Script Arg2"] / 100 + 0.3
    if atk4_Ratio >= ed.rand() then
      local heal_ratio = 1
      if target and target.info.Union == "Dark" then
        heal_ratio = 1.2
      end
      if caster and caster.TitanLC_hasArcana and 1 < caster.TitanLC_hasArcana then
        heal_ratio = heal_ratio + 0.1 * caster.holy_count
      end
      caster:takeHeal(origin_power * heal_ratio, "hp", target)
      skillatk4:takeEffectOn(caster)
    end
  end
  if target.config.is_summoned or target.config.summoner or target.info.Union == "Dark" then
    if caster.TitanLC_hasArcana and caster.TitanLC_hasArcana > 2 then
      power_ratio = 1.5
    else
      power_ratio = 1
    end
  else
    power_ratio = 1
  end
  return origin_power * power_ratio, 1
end

function TitanLC.skillatk2_power(basefunc, skill, source, target, damage_type)
  local origin_power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanLC_atk4
  local power_ratio = 1
  if skillatk4 then
    local atk4_Ratio = skillatk4.info["Script Arg2"] / 100 + 0.3
    if atk4_Ratio >= ed.rand() then
      local heal_ratio = 1
      if target and target.info.Union == "Dark" then
        heal_ratio = 1.2
      end
      if caster and caster.TitanLC_hasArcana and 1 < caster.TitanLC_hasArcana then
        heal_ratio = heal_ratio + 0.1 * caster.holy_count
      end
      caster:takeHeal(origin_power * heal_ratio, "hp", target)
      skillatk4:takeEffectOn(caster)
    end
  end
  if target.config.is_summoned or target.config.summoner or target.info.Union == "Dark" then
    if caster.TitanLC_hasArcana and caster.TitanLC_hasArcana > 2 then
      power_ratio = 1.5
    else
      power_ratio = 1
    end
  else
    power_ratio = 1
  end
  return origin_power * power_ratio, 1
end

function TitanLC.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanLC_atk2
  if caster and skillatk2 then
    buff.update = override(buff.update, TitanLC.skillatk2_buffUpdate)
  end
  return buff
end

function TitanLC.skillatk2_buffUpdate(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2 = caster.skills.TitanLC_atk2
  local skillatk2s = caster.skills.TitanLC_atk2s
  if caster.atk2s_hurt_time and not buff.TitanLC_atk2sCast then
    caster.atk2s_hurt_time = caster.atk2s_hurt_time + dt
  end
  if skillatk2 and caster and owner then
    local atk2s_CD = 4.5 - skillatk2.info["Script Arg2"]
    if not buff.lastposition then
      buff.lastposition = {
        owner.position[1],
        owner.position[2]
      }
    end
    if atk2s_CD <= caster.atk2s_hurt_time and (buff.lastposition[1] ~= owner.position[1] or buff.lastposition[2] ~= owner.position[2]) then
      caster.atk2s_hurt_time = 0
      skillatk2s:takeEffectOn(owner)
      buff.lastposition = {
        owner.position[1],
        owner.position[2]
      }
    end
  end
  basefunc(buff, dt)
end

function TitanLC.DOP_in_battlefield(caster, radius, camp)
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

function TitanLC.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanLC_atk3
  local attack_counter = skill.attack_counter
  if caster and skillatk3 and attack_counter == 0 then
    local SkillPosition = TitanLC.DOP_in_battlefield(caster, 325, caster.foecamp)
    skillatk3:takeEffectAt(SkillPosition, caster)
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanLC_atk3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, SkillPosition, {
        caster.direction,
        1
      }, nil, -1)
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanLC.skillatk3_power(basefunc, skill, source, target, damage_type)
  local origin_power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanLC_atk4
  local power_ratio = 1
  if skillatk4 then
    local atk4_Ratio = skillatk4.info["Script Arg2"] / 100 + 0.3
    if atk4_Ratio >= ed.rand() then
      local heal_ratio = 1
      if target and target.info.Union == "Dark" then
        heal_ratio = 1.2
      end
      if caster and caster.TitanLC_hasArcana and 1 < caster.TitanLC_hasArcana then
        heal_ratio = heal_ratio + 0.1 * caster.holy_count
      end
      caster:takeHeal(origin_power * heal_ratio, "hp", target)
      skillatk4:takeEffectOn(caster)
    end
  end
  if target.config.is_summoned or target.config.summoner or target.info.Union == "Dark" then
    power_ratio = 1.5
  else
    power_ratio = 1
  end
  return origin_power * power_ratio, 1
end

function TitanLC.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanLC_atk4
  local AD_up = skill.info.AD
  local HIT_up = skill.info.HIT
  if AD_up and HIT_up then
    if target and target.info.Union == "Dark" then
      AD_up = AD_up * 1.2
      HIT_up = HIT_up * 1.2
    end
    if caster and caster.TitanLC_hasArcana and caster.TitanLC_hasArcana > 1 then
      AD_up = AD_up * (1 + 0.1 * caster.holy_count)
      HIT_up = HIT_up * (1 + 0.1 * caster.holy_count)
    end
    buff:setAttribute("AD", AD_up)
    buff:setAttribute("HIT", HIT_up)
  end
  return buff
end

function TitanLC.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillult = caster.skills.TitanLC_ult
  local skillults = caster.skills.TitanLC_ults
  local attack_counter = skill.attack_counter
  if caster and skillult then
    if attack_counter == 0 then
      local SkillPosition = target.position
      caster:setPosition(SkillPosition)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      basefunc(skill)
      for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
        if unit ~= target then
          skillults:takeEffectOn(unit)
        end
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanLC.skillult_power(basefunc, skill, source, target, damage_type)
  local origin_power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanLC_atk4
  caster.ult_target = target
  local power_ratio = 1
  if skillatk4 then
    local atk4_Ratio = skillatk4.info["Script Arg2"] / 100 + 0.3
    if atk4_Ratio >= ed.rand() then
      local heal_ratio = 1
      if target and target.info.Union == "Dark" then
        heal_ratio = 1.2
      end
      caster:takeHeal(origin_power * heal_ratio, "hp", target)
      skillatk4:takeEffectOn(caster)
    end
  end
  if target.config.is_summoned or target.config.summoner then
    if caster.TitanLC_hasArcana and caster.TitanLC_hasArcana > 2 then
      power_ratio = 1.5
    else
      power_ratio = 1
    end
  else
    power_ratio = 1
  end
  return origin_power * power_ratio, 1
end

function TitanLC.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanLC_ult
  if caster and caster.TitanLC_hasArcana and caster.TitanLC_hasArcana > 3 and caster and skillult then
    buff.update = override(buff.update, TitanLC.skillatk2_buffUpdate)
  end
  return buff
end

function TitanLC.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.TitanLC_hasArcana and hero.TitanLC_hasArcana > 1 and hero.holy_count <= 0 then
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if unit.info.Union == "Holy" then
        hero.holy_count = hero.holy_count + 1
      end
    end
  end
end

function TitanLC.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.holy_count = 0
  hero.atk2s_hurt_time = 0
end

function TitanLC.init_hero(hero)
  hero.reset = override(hero.reset, TitanLC.hero_reset)
  hero.update = override(hero.update, TitanLC.hero_update)
  local skillatk = hero.skills.TitanLC_atk
  local skillatk2 = hero.skills.TitanLC_atk2
  local skillatk2s = hero.skills.TitanLC_atk2s
  local skillatk3 = hero.skills.TitanLC_atk3
  local skillatk4 = hero.skills.TitanLC_atk4
  local skillult = hero.skills.TitanLC_ult
  local skillults = hero.skills.TitanLC_ults
  hero.TitanLC_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.power = override(skillatk.power, TitanLC.skillatk_power)
  end
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, TitanLC.skillatk2_power)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanLC.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.power = override(skillatk3.power, TitanLC.skillatk3_power)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanLC.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanLC.skillatk4_createBuff)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanLC.skillult_onAttackFrame)
    skillult.power = override(skillult.power, TitanLC.skillult_power)
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, TitanLC.skillults_createBuff)
  end
  return hero
end

return TitanLC.init_hero
