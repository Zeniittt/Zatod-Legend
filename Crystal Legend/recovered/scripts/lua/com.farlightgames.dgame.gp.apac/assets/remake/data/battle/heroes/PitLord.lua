module("ed.battlehero", package.seeall)
local ed = ed
PitLord = {}
PitLord.ultBuffID = 514
PitLord.ultBuffID2 = 516
PitLord.ultBuffID22 = 517
PitLord.ultBuffID23 = 518
PitLord.ultTagBuffID = 515
PitLord.ultTagBuffID2 = 521

function PitLord.addUltBuff(hero, rank, caster)
  for i = 1, rank do
    local bid = PitLord.ultBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, caster)
    local hasBuff = false
    for i, tbuff in pairs(hero.buff_list) do
      if tbuff.info.ID == PitLord.ultBuffID2 then
        hero:removeBuff(tbuff)
        local bid2 = PitLord.ultBuffID22
        local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
        local buff2 = hero:addBuff(binfo2, caster)
        hasBuff = true
        break
      elseif tbuff.info.ID == PitLord.ultBuffID22 then
        hero:removeBuff(tbuff)
        local bid2 = PitLord.ultBuffID23
        local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
        local buff2 = hero:addBuff(binfo2, caster)
        hasBuff = true
        break
      elseif tbuff.info.ID == PitLord.ultBuffID23 then
        hasBuff = true
        break
      end
    end
    if not hasBuff then
      local bid2 = PitLord.ultBuffID2
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = hero:addBuff(binfo2, caster)
    end
  end
end

function PitLord.addUltBuffToAlliances(hero, killByHero)
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
        if tbuff.info.ID == PitLord.ultBuffID2 then
          PitLord.addUltBuff(alive_partner_list[ran], 1, hero)
        end
        if tbuff.info.ID == PitLord.ultBuffID22 then
          PitLord.addUltBuff(alive_partner_list[ran], 2, hero)
        end
        if tbuff.info.ID == PitLord.ultBuffID23 then
          PitLord.addUltBuff(alive_partner_list[ran], 3, hero)
        end
      end
    end
    if killByHero then
      PitLord.addUltBuff(alive_partner_list[ran], 3, hero)
    else
      PitLord.addUltBuff(alive_partner_list[ran], 1, hero)
    end
    local skillawake = hero.skills.PitLord_awake
    alive_partner_list[ran]:takeHeal(skillawake.info["Script Arg1"], "hp", hero)
    alive_partner_list[ran]:takeHeal(skillawake.info["Script Arg2"], "mp", hero)
  end
end

function PitLord.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    skill:selectTarget(skill.target)
    if skill.target then
      basefunc(skill)
      skill.enemyTarget = skill.target
      local bid = PitLord.ultTagBuffID2
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = skill.target:addBuff(binfo, skill.caster)
      local skillult2 = caster.skills.PitLord_ult2
      if skillult2 then
        skill.partnerTarget = skillult2:selectTarget(nil)
      end
      if skill.partnerTarget then
        skill.partnerTarget:addBuff(skill:createBuff(skill.partnerTarget))
        local bid = PitLord.ultTagBuffID2
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = skill.partnerTarget:addBuff(binfo, skill.caster)
      end
    else
      skill:finish()
    end
  elseif attack_counter == 1 then
    local targetAlive = true
    if skill.enemyTarget:isAlive() then
      local skillult3 = caster.skills.PitLord_ult3
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
      PitLord.addUltBuff(caster, 1, caster)
      caster.PitLord_notFirePartners = true
      if skill.partnerTarget then
        for i, tbuff in pairs(skill.partnerTarget.buff_list) do
          if tbuff.info.ID == PitLord.ultTagBuffID or tbuff.info.ID == PitLord.ultTagBuffID2 then
            tbuff.timer = 0
          end
        end
      end
    elseif skill.enemyTarget then
      for i, tbuff in pairs(skill.enemyTarget.buff_list) do
        if tbuff.info.ID == PitLord.ultTagBuffID or tbuff.info.ID == PitLord.ultTagBuffID2 then
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
      local skillult2 = caster.skills.PitLord_ult2
      if skillult2 then
        skillult2:takeEffectOn(skill.partnerTarget, caster)
        targetAlive = false
      end
    else
      targetAlive = false
    end
    if not targetAlive then
      if skill.partnerTarget ~= caster then
        PitLord.addUltBuff(caster, 2, caster)
      end
    elseif skill.partnerTarget then
      for i, tbuff in pairs(skill.partnerTarget.buff_list) do
        if tbuff.info.ID == PitLord.ultTagBuffID or tbuff.info.ID == PitLord.ultTagBuffID2 then
          tbuff.timer = 0
        end
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 4 then
    skill.attack_counter = skill.attack_counter + 1
  end
end

function PitLord.skillult2_selectTarget(basefunc, skill, default)
  local target = basefunc(skill, default)
  local caster = skill.caster
  if target == caster and #ed.engine.alive_units[caster.camp] == 1 then
    skill.target = nil
    return nil
  end
  return target
end

function PitLord.skillult_finish(basefunc, skill)
  basefunc(skill)
  skill.caster.PitLord_notFirePartners = nil
  if skill.partnerTarget then
    for i, tbuff in pairs(skill.partnerTarget.buff_list) do
      if tbuff.info.ID == PitLord.ultTagBuffID or tbuff.info.ID == PitLord.ultTagBuffID2 then
        tbuff.timer = 0
      end
    end
  end
  if skill.enemyTarget then
    for i, tbuff in pairs(skill.enemyTarget.buff_list) do
      if tbuff.info.ID == PitLord.ultTagBuffID or tbuff.info.ID == PitLord.ultTagBuffID2 then
        tbuff.timer = 0
      end
    end
  end
end

function PitLord.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg = basefunc(skill, target, source, shift)
  if dmg and 0 < dmg and target.actor then
    target.actor:addEffect("eff_impact_PitLord_ult_2", 1)
  end
  return ret, dmg
end

function PitLord.skillatk3_takeEffectAt(basefunc, skill, location, source)
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

function PitLord.hero_onDying(basefunc, hero, killer)
  if killer and killer == hero then
    hero.PitLord_killer = true
  end
  basefunc(hero, killer)
end

function PitLord.hero_update(basefunc, hero, dt)
  if hero.state == ed.emUnitState_Dying then
    if not hero.dyingTimer_PitLord then
      hero.dyingTimer_PitLord = 0.25
    end
    hero.dyingTimer_PitLord = hero.dyingTimer_PitLord - dt
    if hero.dyingTimer_PitLord <= 0 and not hero.CHEN_ult1time then
      hero.dyingTimer_PitLord = 99999
      if hero.PitLord_killer then
        PitLord.addUltBuffToAlliances(hero, true)
        hero.PitLord_killer = nil
      else
        PitLord.addUltBuffToAlliances(hero, false)
      end
    end
  else
    hero.dyingTimer_PitLord = nil
  end
  basefunc(hero, dt)
end

function PitLord.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.PitLord_notFirePartners = nil
  local skillult = hero.skills.PitLord_ult
  if skillult then
    skillult.partnerTarget = nil
    skillult.enemyTarget = nil
  end
end

function PitLord.init_hero(hero)
  local skillawake = hero.skills.PitLord_awake
  if skillawake then
    hero.onDying = override(hero.onDying, PitLord.hero_onDying)
    hero.update = override(hero.update, PitLord.hero_update)
  end
  hero.reset = override(hero.reset, PitLord.hero_reset)
  local skillult = hero.skills.PitLord_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, PitLord.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, PitLord.skillult_finish)
  end
  local skillult2 = hero.skills.PitLord_ult2
  if skillult2 then
    skillult2.selectTarget = override(skillult2.selectTarget, PitLord.skillult2_selectTarget)
  end
  local skillatk3 = hero.skills.PitLord_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, PitLord.skillatk3_takeEffectAt)
  end
  return hero
end

return PitLord.init_hero
