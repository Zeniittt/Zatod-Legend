module("ed.battlehero", package.seeall)
local ed = ed
TitanAxe = {}
TitanAxe.invulnerableBuff = 4440
TitanAxe.uncontrollableBuff = 4441
TitanAxe.atk4_arcanaBuff = 4442

function TitanAxe.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1610
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onDamaged = override(buff.onDamaged, TitanAxe.atk2_MissbuffonDamaged)
  caster.atk2_isFinish = false
  buff.timer = 1.2
  caster.atk2_Missbuff = caster:addBuff(buff, caster)
end

function TitanAxe.atk2_MissbuffonDamaged(basefunc, buff, damage, damage_type)
  local caster = buff.caster
  local info = buff.info
  local owner = buff.owner
  if damage and damage_type then
    if damage <= 0 then
      return 0
    else
      damage = 0
      return 0
    end
  end
  return basefunc(buff, damage, damage_type)
end

function TitanAxe.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanAxe_atk2
  local skillatk2s = caster.skills.TitanAxe_atk2s
  local GainMP = skillatk2.info["Gain MP"]
  local target = skill.target
  local protal_pos
  local minX = ed.engine.stage_rect.minX + 50
  local maxX = ed.engine.stage_rect.maxX - 50
  if target then
    protal_pos = {
      target.position[1],
      target.position[2]
    }
  else
    local MinHPUnit
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit and not unit.buff_effects.invisible and unit:isHero() then
        local unitHP = unit.hp
        local MinHP = 99999999
        if unitHP < MinHP then
          MinHP = unitHP
          MinHPUnit = unit
        end
      end
    end
    if MinHPUnit then
      protal_pos = {
        MinHPUnit.position[1],
        MinHPUnit.position[2]
      }
    else
      protal_pos = {
        caster.position[1],
        caster.position[2]
      }
    end
  end
  if skill.attack_counter == 0 then
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, caster.position, {
          caster.direction * 1.1,
          1
        }, nil, 1)
      end
    end
    if minX <= protal_pos[1] and maxX >= protal_pos[1] then
      caster:setPosition({
        protal_pos[1] + caster.direction * 40,
        protal_pos[2]
      })
    elseif minX > protal_pos[1] or maxX < protal_pos[1] then
      caster:setPosition({
        protal_pos[1] - caster.direction * 40,
        protal_pos[2]
      })
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, caster.position, {
          caster.direction * 1.1,
          1
        }, nil, 1)
      end
    end
    skillatk2:takeEffectOn(target)
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter == 1 then
    local initDir = caster.direction
    caster.direction = -initDir
    caster:setMP(caster.mp + GainMP)
    skillatk2:takeEffectOn(target)
    if skillatk2s and 2 <= caster.TitanAxe_hasArcana then
      skillatk2s:takeEffectAt(caster.position, caster)
    end
  end
end

function TitanAxe.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanAxe_atk3
  if caster and skillatk3 then
    local invbid = TitanAxe.invulnerableBuff
    local uncontrolbid = TitanAxe.uncontrollableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local binfo2 = ed.lookupDataTable("Buff", nil, uncontrolbid)
    caster.TitanAxe_invbuff = ed.BuffCreate(binfo1, caster, caster)
    caster.TitanAxe_uncontrolbuff = ed.BuffCreate(binfo2, caster, caster)
  end
end

function TitanAxe.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanAxe_atk3
  local TitanAxe_atk3_mp = skillatk3.info["Gain MP"]
  local attack_counter = skill.attack_counter
  local target = skillatk3:selectTarget()
  if skillatk3 and caster:isAlive() and target then
    if skill.attack_counter == 0 then
      caster:setMP(caster.mp + TitanAxe_atk3_mp * ed.engine.mp_bonus)
    end
    if skill.attack_counter < 6 then
      skillatk3:takeEffectOn(target)
      if ed.run_with_scene and attack_counter % 2 == 0 then
        local effect_name = "eff_impact_TitanAxe_atk3.cha"
        ed.scene:playEffectOnScene(effect_name, target.position, {1, 1}, nil, 1)
      elseif ed.run_with_scene and attack_counter % 2 ~= 0 then
        local effect_name = "eff_impact_TitanAxe_atk3.cha"
        ed.scene:playEffectOnScene(effect_name, target.position, {-1, 1}, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif skill.attack_counter == 6 then
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == TitanAxe.invulnerableBuff then
          tbuff.timer = -1
        end
        if tbuff.info.ID == TitanAxe.uncontrollableBuff then
          tbuff.timer = -1
        end
        skill:finish()
      end
    end
  end
end

function TitanAxe.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skillatk3 = caster.skills.TitanAxe_atk3
  if target.config.is_boss or target.config.is_monster then
    power = power + skillatk3.info["Script Arg2"] * caster.attribs.HP / 100
  else
    power = power + skillatk3.info["Script Arg2"] * math.min(target.attribs.HP - target.hp, caster.attribs.HP) / 100
  end
  local skillRemnant1 = caster.skills.TitanAxe_Remnant1
  if skillRemnant1 then
    caster:takeHeal(power * 0.5, "hp", caster)
  end
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

function TitanAxe.skillatk3_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanAxe.invulnerableBuff then
      tbuff.timer = -1
    end
    if tbuff.info.ID == TitanAxe.uncontrollableBuff then
      tbuff.timer = -1
    end
  end
end

function TitanAxe.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanAxe_atk4
  if skillatk4 and caster.name == "TitanAxe" then
    buff.update = override(buff.update, TitanAxe.skillatk4_Buffupdate)
    buff.onDamaged = override(buff.onDamaged, TitanAxe.skillatk4_onDamaged)
  end
  return buff
end

function TitanAxe.skillatk4_Buffupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanAxe_atk4
  local TitanAxe_atk4_CD = 14 - skillatk4.info["Script Arg2"]
  if not caster:isAlive() and skillatk4 then
    buff.timer = -1
  end
  if caster.atk4_trigger then
    caster.atk4_triggerTime = caster.atk4_triggerTime and caster.atk4_triggerTime + dt or dt
    if TitanAxe_atk4_CD <= caster.atk4_triggerTime then
      caster.atk4_trigger = false
      caster.atk4_triggerTime = 0
    end
  end
end

function TitanAxe.skillatk4_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = owner.skills.TitanAxe_atk4
  local MaxHP = skillatk4.info["Script Arg3"]
  local maxdmg = math.min(owner.hp * 0.3, MaxHP)
  local flagdmg = math.max(caster.hp * 0.1, 20000)
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  if not caster:isAlive() or owner.atk4_trigger == true or flagdmg > lastdamage then
    damage = lastdamage
    return damage
  elseif flagdmg <= lastdamage and owner.atk4_trigger == false then
    local tempDamage = lastdamage - maxdmg
    local mpDef_ratio = tempDamage / caster.attribs.HP
    local skillRemnant2 = caster.skills.TitanAxe_Remnant2
    if skillRemnant2 then
      mpDef_ratio = mpDef_ratio * 0.5
    end
    if tempDamage < 0 then
      tempDamage = lastdamage
      mpDef_ratio = tempDamage / caster.attribs.HP
      if skillRemnant2 then
        mpDef_ratio = mpDef_ratio * 0.5
      end
      caster:setMP(caster.mp - mpDef_ratio * caster.mp)
      damage = 0
    else
      tempDamage = maxdmg
      mpDef_ratio = tempDamage / caster.attribs.HP
      if skillRemnant2 then
        mpDef_ratio = mpDef_ratio * 0.5
      end
      caster:setMP(caster.mp - mpDef_ratio * caster.mp)
      damage = lastdamage - maxdmg
    end
    owner.atk4_trigger = true
    if ed.run_with_scene then
      local effect_front = "eff_buff_TitanAxe_atk4.cha"
      local origin = buff.owner.position
      ed.scene:playEffectOnScene(effect_front, origin, {
        caster.direction,
        1
      }, nil, 1)
      local effect_back = "eff_buff_TitanAxe_atk4b.cha"
      local origin = buff.owner.position
      ed.scene:playEffectOnScene(effect_back, origin, {
        caster.direction,
        1
      }, nil, -1)
    end
    if caster and caster.TitanAxe_hasArcana >= 3 then
      local bid = TitanAxe.atk4_arcanaBuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.timer = 5
      buff:setAttribute("MPR", mpDef_ratio * caster.mp / 5)
      caster:addBuff(buff)
    end
    return damage
  end
end

function TitanAxe.ult_func_hideBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
end

function TitanAxe.ult_func_resetBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(true)
      end
    end
  end
end

function TitanAxe.ult_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local target = skill.target
  caster.TitanAxe_targetAlive = false
  target.TitanAxe_ultAlive = false
  local binfo = ed.lookupDataTable("Buff", nil, TitanAxe.ult_invulnerableBuff)
  local buff = caster:addBuff(binfo, caster)
  caster.TitanAxe_invulnerableBuff = buff
  TitanAxe.ult_func_hideBuffEffect(caster)
end

function TitanAxe.ult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillult = caster.skills.TitanAxe_ult
  local attack_counter = skill.attack_counter
  local dir = 1
  if target and caster.position[1] > target.position[1] then
    dir = -1
  end
  if attack_counter == 0 then
    if target then
      caster:setPosition({
        target.position[1] - dir * 50,
        target.position[2]
      })
      skill.attack_counter = skill.attack_counter + 1
    else
      skill:finish()
    end
    if caster.manually_casting then
      ed.engine:unfreeze()
      caster.manually_casting = false
    end
  elseif attack_counter == 1 then
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
      end
      local bid1 = 4439
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = ed.BuffCreate(binfo1, target, caster)
      buff1.timer = 2.4
      caster.ultfrozenbuff = target:addBuff(buff1, caster)
      local bid2 = 233
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, target, caster)
      buff2.timer = 2.4
      caster.emptynbuff = target:addBuff(buff2, caster)
      buff2.onRemoved = override(buff2.onRemoved, TitanAxe.emptynbuff_onRemoved)
      local t = 0.25
      local dir = caster:getInitDir()
      if caster.position[1] - target.position[1] ~= 0 then
        dir = (caster.position[1] - target.position[1]) / math.abs(caster.position[1] - target.position[1])
      end
      local distance = {
        caster.position[1] - target.position[1] - 75 * dir,
        caster.position[2] - target.position[2]
      }
      skillult:takeEffectOn(target)
      target:knockup(t, distance, true)
      target.height = 80
      if target.actor then
        target.actor.height = 80
      end
      skill.attack_counter = skill.attack_counter + 1
    else
      skill:finish()
    end
  elseif 2 <= attack_counter and attack_counter < 7 then
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
        local t = 0.1
        local dir = caster:getInitDir()
        if attack_counter % 2 ~= 0 then
          dir = 1
        else
          dir = -1
        end
        local distance = {
          target.position[1] - target.position[1] - 5 * dir,
          target.position[2] - target.position[2]
        }
        target:knockup(t, distance, true)
      end
      skillult:takeEffectOn(target)
      skill.attack_counter = skill.attack_counter + 1
    else
      skill:finish()
    end
  elseif attack_counter == 7 then
    if target then
      if caster.ultfrozenbuff then
        caster.ultfrozenbuff.timer = 0
      end
      if target.actor then
        target.actor:launch(0)
      end
      skillult:takeEffectOn(target)
      local LfsTime = skillult.info["Script Arg2"]
      if target:isAlive() then
        local bid = 4444
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, target, caster)
        buff.timer = LfsTime
        buff.onRemoved = override(buff.onRemoved, TitanAxe.ultLfsbuff_onRemoved)
        target:addBuff(buff)
        target.TitanAxe_ultAlive = true
      end
      if caster.TitanAxe_hasArcana >= 4 then
        caster:takeHeal(math.min(target.attribs.HP * 0.2, caster.attribs.HP), "hp", caster)
      end
      skill.attack_counter = skill.attack_counter + 1
    else
      skill:finish()
    end
  end
end

function TitanAxe.emptynbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner.actor then
    owner.actor:launch(0)
  end
end

function TitanAxe.ultLfsbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanAxe_ultAlive = false
end

function TitanAxe.ult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  TitanAxe.ult_func_resetBuffEffect(caster)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1611 then
      tbuff.timer = -1
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1612 then
      tbuff.timer = -1
    end
  end
end

function TitanAxe.hero_collectHPchange(basefunc, self, config)
  local unit = config.unit
  local hero = self
  local skillult = hero.skills.TitanAxe_ult
  if unit.camp == hero.foecamp and unit:isHero() and unit.TitanAxe_ultAlive == true and hero:isAlive() and config.hp_change > 0 then
    if unit.name ~= "TitanAxe" then
      local HP_change = config.hp_change
      hero:setHP(hero.hp + HP_change)
      config.hp = unit.hp
    elseif unit.name == "TitanAxe" and not hero.unit_is_TitanAxe then
      local HP_change = config.hp_change
      hero.unit_is_TitanAxe = true
      hero:setHP(hero.hp + HP_change)
      config.hp = unit.hp
    end
    hero.unit_is_TitanAxe = false
  end
end

function TitanAxe.hero_handleUnitDieEvent(basefunc, hero, unit, killer_unit)
  basefunc(hero, unit, killer_unit)
  local skillatk2 = hero.skills.TitanAxe_atk2
  local skillult = hero.skills.TitanAxe_ult
  local LfsTime = skillult.info["Script Arg2"]
  local LfsRatio = skillult.info["Script Arg3"] / 100
  if hero.current_skill and skillult and hero.current_skill == skillult and hero == killer_unit then
    local bid = 4443
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.timer = LfsTime
    buff:setAttribute("LFSRatio", hero.attribs.LFS * LfsRatio)
    hero:addBuff(buff)
  end
end

function TitanAxe.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanAxe_atk4
  if hero:isAlive() and hero.notAtk4 and skillatk4 then
    skillatk4:takeEffectOn(hero)
    hero.notAtk4 = false
  end
end

function TitanAxe.hero_die(basefunc, hero)
  basefunc(hero)
end

function TitanAxe.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk4_trigger = false
  hero.notAtk4 = true
end

function TitanAxe.init_hero(hero)
  hero.reset = override(hero.reset, TitanAxe.hero_reset)
  hero.update = override(hero.update, TitanAxe.hero_update)
  hero.die = override(hero.die, TitanAxe.hero_die)
  hero.collectHPchange = override(hero.collectHPchange, TitanAxe.hero_collectHPchange)
  local skillatk2 = hero.skills.TitanAxe_atk2
  local skillatk3 = hero.skills.TitanAxe_atk3
  local skillatk4 = hero.skills.TitanAxe_atk4
  local skillult = hero.skills.TitanAxe_ult
  hero.TitanAxe_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanAxe.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanAxe.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanAxe.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanAxe.skillatk3_onAttackFrame)
    skillatk3.getDamage = override(skillatk3.getDamage, TitanAxe.skillatk3_getDamage)
    skillatk3.finish = override(skillatk2.finish, TitanAxe.skillatk3_finish)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanAxe.skillatk4_createBuff)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanAxe.ult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanAxe.ult_onAttackFrame)
    skillult.finish = override(skillult.finish, TitanAxe.ult_finish)
  end
  return hero
end

return TitanAxe.init_hero
