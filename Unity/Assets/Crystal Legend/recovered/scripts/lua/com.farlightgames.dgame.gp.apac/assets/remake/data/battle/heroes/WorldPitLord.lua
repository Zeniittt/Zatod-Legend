module("ed.battlehero", package.seeall)
local ed = ed
WorldPitLord = {}
WorldPitLord.ultBuffID = 1050
WorldPitLord.ultBuffID2 = 516
WorldPitLord.ultBuffID22 = 517
WorldPitLord.ultBuffID23 = 518
WorldPitLord.ultTagBuffID = 515
WorldPitLord.ultTagBuffID2 = 521
WorldPitLord.ragelosthp = 600000
WorldPitLord.rage2losthp = 200000
WorldPitLord.stage2hp = 30000000
WorldPitLord.stage2ragelosthp = 400000

function WorldPitLord.addUltBuff(hero, rank, caster)
  for i = 1, rank do
    local bid = WorldPitLord.ultBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, caster)
    local hasBuff = false
    for i, tbuff in pairs(hero.buff_list) do
      if tbuff.info.ID == WorldPitLord.ultBuffID2 then
        hero:removeBuff(tbuff)
        local bid2 = WorldPitLord.ultBuffID22
        local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
        local buff2 = hero:addBuff(binfo2, caster)
        hasBuff = true
        break
      elseif tbuff.info.ID == WorldPitLord.ultBuffID22 then
        hero:removeBuff(tbuff)
        local bid2 = WorldPitLord.ultBuffID23
        local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
        local buff2 = hero:addBuff(binfo2, caster)
        hasBuff = true
        break
      elseif tbuff.info.ID == WorldPitLord.ultBuffID23 then
        hasBuff = true
        break
      end
    end
    if not hasBuff then
      local bid2 = WorldPitLord.ultBuffID2
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = hero:addBuff(binfo2, caster)
    end
  end
end

function WorldPitLord.addUltBuffToAlliances(hero, killByHero)
  local alive_partner_list2 = ed.engine.alive_units[hero.camp]
  local alive_partner_list = {}
  local ran = 0
  for i = 1, #alive_partner_list2 do
    if alive_partner_list2[i] ~= hero and not alive_partner_list2[i].config.is_summoned then
      table.insert(alive_partner_list, alive_partner_list2[i])
    end
  end
  if 0 < #alive_partner_list then
    ran = math.floor(ed.rand() * #alive_partner_list) + 1
    for i, tbuff in ipairs(hero.buff_list) do
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == WorldPitLord.ultBuffID2 then
          addUltBuff(alive_partner_list[ran], 1, hero)
        end
        if tbuff.info.ID == WorldPitLord.ultBuffID22 then
          addUltBuff(alive_partner_list[ran], 2, hero)
        end
        if tbuff.info.ID == WorldPitLord.ultBuffID23 then
          addUltBuff(alive_partner_list[ran], 3, hero)
        end
      end
    end
    if killByHero then
      WorldPitLord.addUltBuff(alive_partner_list[ran], 3, hero)
    else
      WorldPitLord.addUltBuff(alive_partner_list[ran], 1, hero)
    end
    local skillawake = hero.skills.WorldPitLord_awake
    alive_partner_list[ran]:takeHeal(skillawake.info["Script Arg1"], "hp", hero)
    alive_partner_list[ran]:takeHeal(skillawake.info["Script Arg2"], "mp", hero)
  end
end

function WorldPitLord.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    skill:selectTarget(skill.target)
    if skill.target then
      basefunc(skill)
      skill.enemyTarget = skill.target
      local bid = WorldPitLord.ultTagBuffID2
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = skill.target:addBuff(binfo, skill.caster)
      local skillult2 = caster.skills.WorldPitLord_ult2
      if skillult2 then
        skill.partnerTarget = skillult2:selectTarget(nil)
      end
      if skill.partnerTarget then
        skill.partnerTarget:addBuff(skill:createBuff(skill.partnerTarget))
        local bid = WorldPitLord.ultTagBuffID2
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = skill.partnerTarget:addBuff(binfo, skill.caster)
      end
    else
      skill:finish()
    end
  elseif attack_counter == 1 then
    local targetAlive = true
    if skill.enemyTarget:isAlive() then
      local skillult3 = caster.skills.WorldPitLord_ult3
      if skillult3 then
        skillult3:takeEffectOn(skill.enemyTarget, caster)
        if not skill.enemyTarget:isAlive() then
          targetAlive = false
        end
      end
    else
      targetAlive = false
    end
    if not targetAlive then
      WorldPitLord.addUltBuff(caster, 1, caster)
      caster.PitLord_notFirePartners = true
      if skill.partnerTarget then
        for i, tbuff in pairs(skill.partnerTarget.buff_list) do
          if tbuff.info.ID == WorldPitLord.ultTagBuffID or tbuff.info.ID == WorldPitLord.ultTagBuffID2 then
            tbuff.timer = 0
          end
        end
      end
    elseif skill.enemyTarget then
      for i, tbuff in pairs(skill.enemyTarget.buff_list) do
        if tbuff.info.ID == WorldPitLord.ultTagBuffID or tbuff.info.ID == WorldPitLord.ultTagBuffID2 then
          tbuff.timer = 0
        end
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    if caster.PitLord_notFirePartners or not skill.partnerTarget then
      local actor = skill.caster.actor
      skill.current_phase_elapsed = 3.791667
      skill.caster.action_elapsed = 3.791667
      if actor then
        actor.puppet:setActionElapsed(skill.caster.action_elapsed)
      end
      skill.attack_counter = skill.attack_counter + 2
    else
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif attack_counter == 3 then
    local targetAlive = true
    if skill.partnerTarget:isAlive() then
      local skillult2 = caster.skills.WorldPitLord_ult2
      if skillult2 then
        skillult2:takeEffectOn(skill.partnerTarget, caster)
        if not skill.partnerTarget:isAlive() then
          targetAlive = false
        end
      end
    else
      targetAlive = false
    end
    if not targetAlive then
      if skill.partnerTarget ~= caster then
        WorldPitLord.addUltBuff(caster, 2, caster)
      end
    elseif skill.partnerTarget then
      for i, tbuff in pairs(skill.partnerTarget.buff_list) do
        if tbuff.info.ID == WorldPitLord.ultTagBuffID or tbuff.info.ID == WorldPitLord.ultTagBuffID2 then
          tbuff.timer = 0
        end
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 4 then
    skill.attack_counter = skill.attack_counter + 1
  end
end

function WorldPitLord.skillult2_selectTarget(basefunc, skill, default)
  local target = basefunc(skill, default)
  local caster = skill.caster
  if target == caster and #ed.engine.alive_units[caster.camp] == 1 then
    skill.target = nil
    return nil
  end
  return target
end

function WorldPitLord.skillult_finish(basefunc, skill)
  basefunc(skill)
  skill.caster.PitLord_notFirePartners = nil
  if skill.partnerTarget then
    for i, tbuff in pairs(skill.partnerTarget.buff_list) do
      if tbuff.info.ID == WorldPitLord.ultTagBuffID or tbuff.info.ID == WorldPitLord.ultTagBuffID2 then
        tbuff.timer = 0
      end
    end
  end
  if skill.enemyTarget then
    for i, tbuff in pairs(skill.enemyTarget.buff_list) do
      if tbuff.info.ID == WorldPitLord.ultTagBuffID or tbuff.info.ID == WorldPitLord.ultTagBuffID2 then
        tbuff.timer = 0
      end
    end
  end
end

function WorldPitLord.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg = basefunc(skill, target, source, shift)
  if dmg and 0 < dmg and target.actor then
    target.actor:addEffect("eff_impact_PitLord_ult_2", 1)
  end
  return ret, dmg
end

function WorldPitLord.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, {
    location[1],
    0
  }, source)
  if ed.run_with_scene then
    local effect_name = "eff_point_PitLord_atk3.cha"
    ed.scene:playEffectOnScene(effect_name, {
      location[1],
      0
    }, {
      skill.caster.direction,
      1
    }, nil, -1)
  end
end

function WorldPitLord.hero_onDying(basefunc, hero, killer)
  if killer and killer == hero then
    hero.PitLord_killer = true
  end
  basefunc(hero, killer)
end

function WorldPitLord.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldPitLord.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldPitLord.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldPitLord.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldPitLord.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldPitLord.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldPitLord.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldPitLord.stage2hp and hero.hp - lost <= WorldPitLord.stage2hp then
    return hero.hp - WorldPitLord.stage2hp
  else
    return lost
  end
end

function WorldPitLord.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldPitLord.rage_buff_update)
  hero.lastrageStack = 0
  hero.PitLord_notFirePartners = nil
  local skillult = hero.skills.WorldPitLord_ult
  if skillult then
    skillult.partnerTarget = nil
    skillult.enemyTarget = nil
  end
end

function WorldPitLord.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
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

function WorldPitLord.init_hero(hero)
  local skillawake = hero.skills.WorldPitLord_awake
  if skillawake then
    hero.onDying = override(hero.onDying, WorldPitLord.hero_onDying)
  end
  hero.update = override(hero.update, WorldPitLord.hero_update)
  hero.reset = override(hero.reset, WorldPitLord.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldPitLord.getLostHPAfterImmunity)
  local skillult = hero.skills.WorldPitLord_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldPitLord.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, WorldPitLord.skillult_finish)
  end
  local skillult2 = hero.skills.WorldPitLord_ult2
  if skillult2 then
    skillult2.selectTarget = override(skillult2.selectTarget, WorldPitLord.skillult2_selectTarget)
  end
  local skillatk3 = hero.skills.WorldPitLord_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, WorldPitLord.skillatk3_takeEffectAt)
  end
  return hero
end

return WorldPitLord.init_hero
