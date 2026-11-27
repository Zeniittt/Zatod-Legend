module("ed.battlehero", package.seeall)
local ed = ed
TitanKirua = {}
TitanKirua.invulnerableBuff = 4501
TitanKirua.uncontrollableBuff = 4502
TitanKirua.fashion_Bid = 4515
TitanKirua.TitanKirua_fashionID = 101331

function TitanKirua.need_interrupt(skill)
  local current_phase_idx = skill and skill.current_phase_idx
  local max_phase_idx = skill and #skill.phase_list
  local max_event_idx = current_phase_idx and skill.current_phase and type(skill.current_phase.event_list) == "table" and #skill.current_phase.event_list
  local next_event_idx = current_phase_idx and skill.next_event_idx
  local need
  if skill and current_phase_idx and max_phase_idx and max_event_idx and next_event_idx then
    if current_phase_idx < max_phase_idx then
      need = true
    elseif current_phase_idx == max_phase_idx and max_event_idx >= next_event_idx then
      need = true
    end
  end
  return need
end

function TitanKirua.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanKirua_atk2
  if caster and skillatk2 then
    local invbid = TitanKirua.uncontrollableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    caster.TitanLeorio_invbuff = caster:addBuff(buff1, caster)
  end
end

function TitanKirua.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local target = skill.target
  local skillatk2 = caster.skills.TitanKirua_atk2
  if attack_counter and target and target:isAlive() then
    if target and attack_counter == 0 then
      local effect_name = "eff_impact_TitanKirua_atk2.cha"
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(effect_name, {
          target.position[1],
          target.position[2]
        }, {
          target.direction,
          1
        }, nil, 1)
      end
      if caster and skillatk2 then
        for i, tbuff in ipairs(caster.buff_list) do
          if tbuff.info.ID == TitanKirua.uncontrollableBuff then
            tbuff.timer = -1
          end
        end
      end
      local mp = caster.mp
      caster:setMP(mp + 150)
    end
    if target and 1 <= attack_counter then
      local target_need_interrupt = TitanKirua.need_interrupt(target.current_skill)
      local target_casting1 = target.current_skill and target.current_skill.info["Skill Group ID"]
      skillatk2:takeEffectOn(target, caster)
      if not target.buff_effects.invulnerableBuff then
        target:hurt()
      end
      if target and target:isAlive() and target_casting1 ~= nil and target_casting1 ~= target.info["Basic Skill"] then
        local interrupt = false
        local target_casting2 = target.current_skill and target.current_skill.info["Skill Group ID"]
        if target_casting2 == nil and target_need_interrupt == true then
          interrupt = true
        end
        if interrupt == true and target:isAlive() and not target.buff_effects.invulnerable then
          local amount = 0
          if target.config.is_boss then
            amount = caster.hp * 0.1
          else
            amount = target.hp * 0.1
          end
          amount = math.min(amount, caster.attribs.HP * 0.1)
          target:takeDamage(amount, "Holy", "hp", caster, 1, 1)
          target.TitanKirua_interrupt = true
        end
      end
    end
    if attack_counter == 8 then
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanKirua.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.CreatedByHunterHunter = true
  local caster = buff.caster
  local skillatk2 = caster.skills.TitanKirua_atk2
  if caster and skillatk2 then
    local AGI_down = (100 - skillatk2.info["Script Arg2"]) / 100
    buff:setAttribute("AGI", -target.attribs.STR * AGI_down)
  end
  return buff
end

function TitanKirua.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanKirua_atk3
  if caster and skillatk3 then
    local invbid = TitanKirua.uncontrollableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    caster.TitanLeorio_invbuff = caster:addBuff(buff1, caster)
  end
end

function TitanKirua.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local buff_SilenceTime = 0
  local skillatk3 = caster.skills.TitanKiura_atk3
  buff.CreatedByHunterHunter = true
  if caster and owner then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and 0 >= tbuff.info.AGI then
        buff_SilenceTime = math.abs(tbuff.info.AGI * 0.015)
      end
    end
    local skillatk2 = caster.skills.TitanKirua_atk2
    if skillatk2 then
      owner:addBuff(skillatk2:createBuff(owner))
    end
  end
  buff.timer = buff.timer + buff_SilenceTime
  if caster:isAlive() and skillatk3 then
    buff.update = override(buff.update, TitanKirua.skillatk3Buff_update)
    buff.onRemoved = override(buff.onRemoved, TitanKirua.skillatk3Buff_onRemoved)
  end
  buff.CreatedByHunterHunter = true
  owner.TitanKirua_atk3_interrupt = true
  return buff
end

function TitanKirua.skillatk3Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = caster.skills.TitanKiura_atk3
  local paralyizeRatio = (skillatk3.info["Script Arg2"] + caster.attribs.AGI * 5.0E-4) / 100
  local target_need_interrupt = TitanKirua.need_interrupt(owner.current_skill)
  if caster:isAlive() and owner then
    buff.paralyzeTime = buff.paralyzeTime and buff.paralyzeTime + dt or dt
    if buff.paralyzeTime == 2 and owner.TitanKirua_ult_interrupt == true then
      owner.TitanKirua_ult_interrupt = false
      buff.paralyzeTime = 0
    end
    local target_casting1 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
    if owner and owner:isAlive() and target_casting1 ~= nil and target_casting1 ~= owner.info["Basic Skill"] then
      local interruptRand = ed.rand()
      if paralyizeRatio > interruptRand and owner.TitanKirua_ult_interrupt ~= true then
        owner:hurt()
        local target_casting2 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
        local interrupt = false
        if target_casting2 == nil and target_need_interrupt == true then
          interrupt = true
        end
        if interrupt == true and owner:isAlive() and not owner.buff_effects.invulnerable then
          local amount = 0
          local paralyzeHurtRatio = skillatk3.info["Script Arg3"] / 100
          if owner.config.is_boss then
            amount = caster.hp * paralyzeHurtRatio
          else
            amount = owner.hp * paralyzeHurtRatio
          end
          amount = math.min(amount, caster.attribs.HP * 0.15)
          owner:takeDamage(amount, "Holy", "hp", caster, 1, 1)
          owner.TitanKirua_ult_interrupt = true
        end
      end
    end
  else
    buff.timer = -1
  end
end

function TitanKirua.skillatk3Buff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.paralyzeTime = 0
end

function TitanKirua.skillatk3_onAttackFrame(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillatk3 = caster.skills.TitanKirua_atk3
  if attack_counter and attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter and attack_counter == 1 and target then
    local target_position = target.position
    if target_position then
      caster:setPosition({
        target_position[1] - target.direction * 80,
        target_position[2]
      })
    end
    if caster and skillatk3 then
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == TitanKirua.uncontrollableBuff then
          tbuff.timer = -1
        end
      end
    end
    skill.attack_counter = skill.attack_counter + 1
    local mp = caster.mp
    caster:setMP(mp + 150)
  end
  if attack_counter and 1 < attack_counter and attack_counter < 8 and target then
    skillatk3:takeEffectOn(target)
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter and attack_counter == 8 and target then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.1,
      ["Knock Back"] = 35
    })
    skillatk3:takeEffectOn(target, caster)
    skill.info = originfo
    skill:finish()
  end
end

function TitanKirua.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanKirua_atk3
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster and skillatk3 and caster.TitanKirua_hasArcana and caster.TitanKirua_hasArcana >= 3 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and tbuff.info.AGI <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.AGI) + caster.attribs.AGI)
      end
    end
  end
  return power, coeff
end

function TitanKirua.hero_collectMPchange(basefunc, self, config)
  local unit = config.unit
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4499 and config.mp_change > 0 then
      config.mp = unit.mp
    end
  end
end

function TitanKirua.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanKirua_atk4
  if caster and skillatk4 then
    local invbid = TitanKirua.uncontrollableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    caster.TitanLeorio_invbuff = caster:addBuff(buff1, caster)
  end
end

function TitanKirua.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local buff_MPRTime = 0
  buff.CreatedByHunterHunter = true
  if caster and owner then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and 0 >= tbuff.info.AGI then
        buff_MPRTime = math.abs(tbuff.info.AGI * 0.015)
      end
    end
    local skillatk2 = caster.skills.TitanKirua_atk2
    if skillatk2 then
      owner:addBuff(skillatk2:createBuff(owner))
    end
  end
  buff.timer = buff.timer + buff_MPRTime
  return buff
end

function TitanKirua.skillatk4_onAttackFrame(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillatk4 = caster.skills.TitanKirua_atk4
  if attack_counter and attack_counter == 0 and target then
    if caster then
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == TitanKirua.uncontrollableBuff then
          tbuff.timer = -1
        end
      end
    end
    local target_position = target.position
    if target_position then
      caster:setPosition({
        target_position[1],
        target_position[2]
      })
    end
    skill.attack_counter = skill.attack_counter + 1
    local mp = caster.mp
    caster:setMP(mp + 150)
  end
  if attack_counter and 1 <= attack_counter and target then
    skillatk4:takeEffectOn(target, caster)
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter and attack_counter == 10 and target then
    local stunbid = 4463
    local binfo = ed.lookupDataTable("Buff", nil, stunbid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(binfo, caster)
    skill:finish()
  end
end

function TitanKirua.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanKirua_atk4
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster and skillatk4 and caster.TitanKirua_hasArcana and caster.TitanKirua_hasArcana >= 3 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and tbuff.info.AGI <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.AGI) + caster.attribs.AGI)
      end
    end
  end
  return power, coeff
end

function TitanKirua.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanKirua_ult
  if caster and skillult then
    local invbid = TitanKirua.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    caster.TitanLeorio_invbuff = caster:addBuff(buff1, caster)
  end
  if caster and caster.TitanKirua_hasArcana and caster.TitanKirua_hasArcana >= 2 then
    local AGIbid = 4503
    local binfo1 = ed.lookupDataTable("Buff", nil, AGIbid)
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      local buff1 = ed.BuffCreate(binfo1, unit, caster)
      unit:addBuff(buff1, caster)
    end
  end
end

function TitanKirua.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanKirua_ult
  if caster:isAlive() and skillult then
    buff.update = override(buff.update, TitanKirua.skillultBuff_update)
    buff.onRemoved = override(buff.onRemoved, TitanKirua.skillultBuff_onRemoved)
  end
  buff.CreatedByHunterHunter = true
  owner.TitanKirua_ult_interrupt = true
  return buff
end

function TitanKirua.skillult_onAttackFrame(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.TitanKirua_ult
  if attack_counter and attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter and attack_counter == 1 and target then
    local target_position = target.position
    if target_position then
      caster:setPosition({
        target_position[1] - target.direction * 50,
        target_position[2]
      })
    end
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter and 1 < attack_counter and attack_counter < 12 and target then
    skillult:takeEffectOn(target, caster)
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter == 12 and target then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 1,
      ["Knock Back"] = 20
    })
    skillult:takeEffectOn(target, caster)
    skill.info = originfo
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanKirua.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillult = caster.skills.TitanKirua_ult
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster:isAlive() and skillult then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and tbuff.info.AGI <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.AGI) + caster.attribs.AGI)
      end
    end
  end
  return power, coeff
end

function TitanKirua.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanKirua.invulnerableBuff then
        tbuff.timer = -1
      end
    end
  end
end

function TitanKirua.skillultBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanKirua_ult
  local paralyizeRatio = (skillult.info["Script Arg2"] + caster.attribs.AGI * 5.0E-4) / 100
  local target_need_interrupt = TitanKirua.need_interrupt(owner.current_skill)
  if caster:isAlive() and owner then
    buff.paralyzeTime = buff.paralyzeTime and buff.paralyzeTime + dt or dt
    if buff.paralyzeTime == 2 and owner.TitanKirua_ult_interrupt == true then
      owner.TitanKirua_ult_interrupt = false
      buff.paralyzeTime = 0
    end
    local target_casting1 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
    if owner and owner:isAlive() and target_casting1 ~= nil and target_casting1 ~= owner.info["Basic Skill"] then
      local interruptRand = ed.rand()
      if paralyizeRatio > interruptRand and owner.TitanKirua_ult_interrupt ~= true then
        owner:hurt()
        local target_casting2 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
        local interrupt = false
        if target_casting2 == nil and target_need_interrupt == true then
          interrupt = true
        end
        if interrupt == true and owner:isAlive() and not owner.buff_effects.invulnerable then
          local amount = 0
          local paralyzeHurtRatio = skillult.info["Script Arg3"] / 100
          if owner.config.is_boss then
            amount = caster.hp * paralyzeHurtRatio
          else
            amount = owner.hp * paralyzeHurtRatio
          end
          amount = math.min(amount, caster.attribs.HP * 0.15)
          owner:takeDamage(amount, "Holy", "hp", caster, 1, 1)
          owner.TitanKirua_ult_interrupt = true
        end
      end
    end
  else
    buff.timer = -1
  end
end

function TitanKirua.skillultBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.paralyzeTime = 0
end

function TitanKirua.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk2 = hero.skills.TitanKirua_atk2
  local skillatk3 = hero.skills.TitanKirua_atk3
  local skillatk4 = hero.skills.TitanKirua_atk4
  if hero.change_cd_index then
    hero.change_cd_index = hero.change_cd_index + dt
    if hero.change_cd_index == dt then
      if hero and hero.TitanKirua_hasArcana and hero.TitanKirua_hasArcana >= 4 then
        local originfo2 = skillatk2.info
        skillatk2.info = ed.wraptable(originfo2, {
          ["Init CD"] = 3,
          CD = 4
        })
        local originfo3 = skillatk3.info
        skillatk3.info = ed.wraptable(originfo3, {
          ["Init CD"] = 5,
          CD = 6
        })
        local originfo4 = skillatk4.info
        skillatk4.info = ed.wraptable(originfo4, {
          ["Init CD"] = 7,
          CD = 8
        })
      end
      if TitanKirua.TitanKirua_fashionID and TitanKirua.TitanKirua_fashionID == hero.fashion_id then
        local fashion2_id = 4524
        local binfo = ed.lookupDataTable("Buff", nil, fashion2_id)
        local buff = ed.BuffCreate(binfo, hero, hero)
        buff:setAttribute("CSDR", 100)
        buff:setAttribute("MCSDR", 100)
        hero:addBuff(buff, hero)
      end
    end
  end
end

function TitanKirua.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.change_cd_index = 0
end

function TitanKirua.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost, bCrit = basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if TitanKirua.TitanKirua_fashionID and TitanKirua.TitanKirua_fashionID == hero.fashion_id and lost and bCrit then
    hero.TitanKirua_bCrit = true
    local fashion_Bid = TitanKirua.fashion_Bid
    local fashion_Binfo = ed.lookupDataTable("Buff", nil, fashion_Bid)
    hero.fashion_buff = hero:addBuff(fashion_Binfo, hero)
  end
  return lost, bCrit
end

function TitanKirua.init_hero(hero)
  hero.reset = override(hero.reset, TitanKirua.hero_reset)
  hero.update = override(hero.update, TitanKirua.hero_update)
  hero.collectMPchange = override(hero.collectMPchange, TitanKirua.hero_collectMPchange)
  hero.TitanKirua_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.TitanKirua_ult
  local skillatk = hero.skills.TitanKirua_atk
  local skillatk2 = hero.skills.TitanKirua_atk2
  local skillatk3 = hero.skills.TitanKirua_atk3
  local skillatk4 = hero.skills.TitanKirua_atk4
  if TitanKirua.TitanKirua_fashionID and TitanKirua.TitanKirua_fashionID == hero.fashion_id then
    hero.takeDamage = override(hero.takeDamage, TitanKirua.hero_takeDamage)
  end
  if skillult and not hero.config.is_summoned and hero.name == "TitanKirua" then
    skillult.start = override(skillult.start, TitanKirua.skillult_start)
    skillult.createBuff = override(skillult.createBuff, TitanKirua.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanKirua.skillult_onAttackFrame)
    skillult.power = override(skillult.power, TitanKirua.skillult_power)
    skillult.finish = override(skillult.finish, TitanKirua.skillult_finish)
  end
  if skillatk2 and hero.name == "TitanKirua" then
    skillatk2.start = override(skillatk2.start, TitanKirua.skillatk2_start)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanKirua.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanKirua.skillatk2_onAttackFrame)
  end
  if skillatk3 and hero.name == "TitanKirua" then
    skillatk3.start = override(skillatk3.start, TitanKirua.skillatk3_start)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanKirua.skillatk3_createBuff)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanKirua.skillatk3_onAttackFrame)
    skillatk3.power = override(skillatk3.power, TitanKirua.skillatk3_power)
  end
  if skillatk4 and hero.name == "TitanKirua" then
    skillatk4.start = override(skillatk4.start, TitanKirua.skillatk4_start)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanKirua.skillatk4_createBuff)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanKirua.skillatk4_onAttackFrame)
    skillatk4.power = override(skillatk4.power, TitanKirua.skillatk4_power)
  end
  return hero
end

return TitanKirua.init_hero
