module("ed.battlehero", package.seeall)
local ed = ed
Marine = {}
Marine.range_interval = 150
Marine.atk2_cost_hp = 20
Marine.atk2_bid = 91
Marine.uncontrol_bid = 1226
Marine.building_bid = 1227
Marine.atk_ratio = 0.05
Marine.atk3_ratio = 0.03
Marine.atk4_raito = 0.02
Marine.Ammo_AD = 1513
Marine.Ammo_AP = 1514
Marine.Heal_effect = 1515

function Marine.skill2_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = owner.skills.Marine_atk
  if skillatk then
    skillatk.info = skillatk.originfo
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    owner.attack_range = owner.attack_range + Marine.range_interval
  end
  owner.medBuff_Marine = nil
  local skillawake = owner.skills.Marine_awake
  local skillawakes = owner.skills.Marine_awakes
  if skillawake and owner.currentActionStage == 3 then
    owner.fever_exit_time = 0.25
  end
  return basefunc(buff)
end

function Marine.skillult_onPhaseFinished(basefunc, skill)
  basefunc(skill)
  local position = skill.caster.position
  position[1] = position[1] - 40
end

function Marine.skillult_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 140,
      ["Point Effect"] = false,
      ["Knock Back"] = 70,
      ["Knock Up"] = 0.2,
      ["Basic Num"] = 10,
      ["Plus Ratio"] = 0.3
    })
    basefunc(skill, location, source)
    skill.info = originfo
  elseif attack_counter == 2 then
    basefunc(skill, location, source)
  end
end

function Marine.skillult_takeEffectOn(basefunc, skill, target, source)
  if skill.attack_counter == 1 then
    local bid = 92
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  end
  basefunc(skill, target, source)
end

function Marine.skillatk2_createBuff(basefunc, skill, target)
  local hpcost = target.attribs.HP * skill.info["Cost HP"] * 0.01
  if not ed.engine.babelMode then
    target.takeDamage(target, hpcost, "Holy", "hp", skill.caster)
  elseif ed.engine.babelMode then
    local remainingHp = math.max(1, target.hp - hpcost)
    target:setHP(remainingHp)
    if target.actor then
      local str = "-" .. math.floor(hpcost + 0.5)
      if str ~= "-0" then
        local color
        if target.camp == ed.emCampPlayer then
          color = "red"
        else
          color = "orange"
        end
        if not target.notPopupBattleInfo then
          ed.PopupCreate(str, color, target.actor, false)
        end
      end
    end
  end
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk = caster.skills.Marine_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Max Range"] = skillatk.info["Max Range"] - Marine.range_interval,
      ["Gain MP"] = 30
    })
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = 0
    caster.attack_range = caster.attack_range - Marine.range_interval
  end
  caster.medBuff_Marine = true
  buff.onRemoved = override(buff.onRemoved, Marine.skill2_buffOnRemoved)
  return buff
end

function Marine.skillatk_start(basefunc, skill, target)
  local info = skill.info
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  if skill.caster.medBuff_Marine then
    skill:startPhase(2)
  else
    skill:startPhase(1)
  end
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if ed.run_with_scene then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
  local skillsawake = caster.skills.Marine_sawake
  if skillsawake and caster.name == "Marine" then
    if caster.Target_type == "AD" then
      local bid = Marine.Ammo_AD
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
    end
    if caster.Target_type == "AP" then
      local bid = Marine.Ammo_AP
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
    end
  end
end

function Marine.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Marine.skillatk_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillawake = caster.skills.Marine_awake
  if skillawake then
    local ratio = 0
    if caster.medBuff_Marine then
      ratio = Marine.atk3_ratio
    else
      ratio = Marine.atk_ratio
    end
    local extradamage = math.min(target.attribs.HP * ratio, skillawake.info["Script Arg1"])
    power = power + extradamage
  end
  return power * 0.8 ^ (skill.attack_counter - 1), i
end

function Marine.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local hpcost = caster.attribs.HP * skill.info["Cost HP"] * 0.01
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if hpcost > caster.hp then
    return false, "hp"
  end
  if caster.current_skill and caster.current_skill.info["Skill Name"] == "Marine_ult" then
    return false, "ult"
  end
  if caster.medBuff_Marine then
    return false, "medBuff"
  end
  local skillawake = caster.skills.Marine_awake
  if skillawake then
    if caster.fever_exit_time then
      return false, "exit mode"
    end
    if not skillawake:selectTarget(nil) then
      return false, "no target"
    end
  end
  return true
end

function Marine.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skill2 = hero.skills.Marine_atk2
  local skillult = hero.skills.Marine_ult
  local skillsawake = hero.skills.Marine_sawake
  hero.can_cast_manual = hero.can_cast_manual or skill2 and skill2:canCastWithTarget(hero.ai.target)
  local skillawake = hero.skills.Marine_awake
  if skillawake then
    if hero.current_skill == skillult and not hero.ult_casting and hero.currentActionStage == 3 then
      hero.ult_casting = true
    end
    if hero.fever_exit_time then
      hero.fever_exit_time = hero.fever_exit_time - dt
      if hero.fever_exit_time <= 0 and hero.currentActionStage == 3 and not hero.ult_casting then
        if skillsawake then
          hero:enterActionStageFromOneStage(4, 50)
        else
          hero:enterActionStageFromOneStage(2, 50)
        end
        skillult.cd_remaining = 0.25
        for _, buff in ipairs(hero.buff_list) do
          if buff.info.ID == Marine.building_bid then
            buff.timer = 0
          end
        end
        hero.fever_exit_time = nil
      end
    end
    if hero.currentActionStage == 3 and not skillawake:selectTarget(nil) and not hero.fever_exit_time then
      hero.fever_exit_time = 0.25
    end
  end
  local skillsawake = hero.skills.Marine_sawake
  if skillsawake and hero.name == "Marine" then
    local heal_effect = "eff_impact_heal.cha"
    local Marine_emergency = skillsawake.info["Script Arg2"]
    local bid = Marine.Heal_effect
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    if hero.hp <= hero.attribs.HP * 0.75 and hero.hero_takeHeal1 == 0 then
      local Heal_hp = hero:takeHeal(Marine_emergency, "hp")
      hero:addBuff(binfo, hero)
      hero.hero_takeHeal1 = hero.hero_takeHeal1 + 1
    end
    if hero.hp <= hero.attribs.HP * 0.5 and hero.hero_takeHeal2 == 0 then
      local Heal_hp = hero:takeHeal(Marine_emergency, "hp")
      hero:addBuff(binfo, hero)
      hero.hero_takeHeal2 = hero.hero_takeHeal2 + 1
    end
    if hero.hp <= hero.attribs.HP * 0.25 and hero.hero_takeHeal3 == 0 then
      local Heal_HP = hero:takeHeal(Marine_emergency, "hp")
      hero:addBuff(binfo, hero)
      hero.hero_takeHeal3 = hero.hero_takeHeal3 + 1
    end
  end
end

function Marine.Skill_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local skillsawake = hero.skills.Marine_sawake
  local Damage_Ratio = skillsawake.info["Script Arg3"] * 0.01
  if skillsawake and hero.name == "Marine" then
    local Ammo_power = power
    local Ammo_crit = crit_mod
    if hero.Target_type == "AD" then
    end
    if hero.Target_type == "AP" then
      Ammo_power = Ammo_power * (1 + Damage_Ratio)
      Ammo_crit = Ammo_crit * (1 + Damage_Ratio * 2.5)
    end
    local dmg = target:takeDamage({
      amount = Ammo_power,
      damage_type = hero.Target_type,
      field = field,
      source = source,
      crit_mod = Ammo_crit,
      skill = self
    })
    if dmg == nil then
      dmg = 0
    end
    return dmg
  end
end

function Marine.skill156_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillsawake = caster.skills.Marine_sawake
  local skill_name = skill.info["Skill Name"]
  local skill156 = caster.skills[skill_name]
  local originfo_156 = skill156.info
  local multiplier_156 = originfo_156["Plus Ratio"]
  local base_attrib_156 = originfo_156["Plus Attr"] and caster.attribs[originfo_156["Plus Attr"]] or 0
  local power_156 = multiplier_156 * base_attrib_156 + originfo_156["Basic Num"]
  if skillsawake and caster.name == "Marine" then
    caster.skill156_power = power_156
    if caster.Target_type == "AD" then
      skill156.info = ed.wraptable(originfo_156, {
        ["Impact Effect"] = "eff_impact_slash.cha"
      })
    end
    if caster.Target_type == "AP" then
      skill156.info = ed.wraptable(originfo_156, {
        ["Impact Effect"] = "eff_impact_pierce.cha"
      })
    end
  end
  local defence, dd, dc, immunity, amount, crit
  if target and caster.name == "Marine" then
    defence = math.max(0, target.attribs.ARM - caster.attribs.ARMP)
    crit = caster.attribs.CRIT
    immunity = target.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
    immunity = immunity + target.attribs.ALLIMU
    amount = math.max(0, caster.skill156_power)
    local damage_AD = amount * amount / (amount + dd)
    damage_AD = damage_AD * caster.attribs.PDM
    damage_AD = damage_AD * (100 - immunity) / 100
    if 100 <= immunity then
      damage_AD = 0
    end
    defence = math.max(0, target.attribs.MR - caster.attribs.MRI)
    crit = caster.attribs.MCRIT
    immunity = target.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
    immunity = immunity + target.attribs.ALLIMU
    amount = math.max(0, caster.skill156_power)
    local damage_AP = amount * amount / (amount + dd)
    damage_AP = damage_AP * caster.attribs.PDM
    damage_AP = damage_AP * (100 - immunity) / 100
    if 100 <= immunity then
      damage_AP = 0
    end
    if damage_AD < damage_AP then
      caster.Target_type = "AP"
    else
      caster.Target_type = "AD"
    end
  end
  basefunc(skill)
  skill156.info = originfo_156
end

function Marine.skill_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillsawake = caster.skills.Marine_sawake
  if skillsawake and caster.name == "Marine" then
    if caster.Target_type == "AD" then
      local bid = Marine.Ammo_AD
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
    end
    if caster.Target_type == "AP" then
      local bid = Marine.Ammo_AP
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
    end
  end
end

function Marine.hero_castManualSkill(basefunc, hero)
  local skill2 = hero.skills.Marine_atk2
  if skill2 and hero.mp < 1000 and skill2:canCastWithTarget(hero.ai.target) then
    hero:castSkill(hero.skills.Marine_atk2, hero)
  else
    basefunc(hero)
  end
end

function Marine.hero_ai_findSkillToCast(basefunc, ai)
  local skill = basefunc(ai)
  if skill and skill.info["Skill Name"] == "Marine_atk2" then
    local caster = skill.caster
    if ed.engine:arenaMode() or ed.engine:isTowerWarsMode() or ed.IsMultiArena() or not battle_tick.getRealTimePvp() and caster.camp == ed.emCampEnemy then
      return skill
    end
    return caster.skills.Marine_atk
  end
  return skill
end

function Marine.awake_selectTarget(basefunc, skill, default)
  local max = -math.huge
  local chosen
  local caster = skill.caster
  local caster_position = caster.position
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit.config.is_summoned then
    elseif caster.currentActionStage == 3 and (unit.position[1] - caster.position[1]) * caster.direction < 0 then
    elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
        local v = unit.attribs.HP
        if max < v then
          max = v
          chosen = unit
        end
      end
    end
  end
  skill.target = chosen
  return skill.target
end

function Marine.skillawake_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillawake = caster.skills.Marine_awake
  local ratio = Marine.atk4_raito
  local extradamage = math.min(target.attribs.HP * ratio, skillawake.info["Script Arg1"])
  power = power + extradamage
  return power, i
end

function Marine.skillult_willCast(basefunc, skill)
  local caster = skill.caster
  for _, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Marine.atk2_bid and tbuff.timer > 3 then
      return false
    end
  end
  return true
end

function Marine.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.currentActionStage == 2 then
    local bid1 = Marine.uncontrol_bid
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    skill.caster:addBuff(binfo1, skill.caster)
    local bid2 = Marine.building_bid
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    skill.caster:addBuff(binfo2, skill.caster)
  end
end

function Marine.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillsawake = caster.skills.Marine_sawake
  if caster.currentActionStage == 2 or caster.currentActionStage == 4 then
    caster:enterActionStageFromOneStage(3, 50)
  end
  for _, buff in ipairs(caster.buff_list) do
    if buff.info.ID == Marine.uncontrol_bid then
      caster:removeBuff(buff)
    end
  end
  local skillawake = caster.skills.Marine_awake
  local skillult = caster.skills.Marine_ult
  skillawake.cd_remaining = 0.125
  skillult.cd_remaining = 0.125
  caster.global_cd = 0.5
end

function Marine.skillatk2_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Marine.skillult_finish(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillsawake = caster.skills.Marine_sawake
  if caster.currentActionStage == 3 then
    if skillsawake then
      caster:enterActionStageFromOneStage(4, 50)
    else
      caster:enterActionStageFromOneStage(2, 50)
    end
    for _, buff in ipairs(caster.buff_list) do
      if buff.info.ID == Marine.building_bid then
        buff.timer = 0
      end
    end
    caster.fever_exit_time = nil
    caster.ult_casting = nil
  end
end

function Marine.reset(basefunc, hero)
  basefunc(hero)
  local skillsawake = hero.skills.Marine_sawake
  if hero.currentActionStage == 3 then
    if skillsawake then
      hero:enterActionStageFromOneStage(4, 50)
    else
      hero:enterActionStageFromOneStage(2, 50)
    end
  end
  hero.fever_exit_time = nil
  if skillsawake then
    hero.Target_type = "AD"
    hero.hero_takeHeal1 = 0
    hero.hero_takeHeal2 = 0
    hero.hero_takeHeal3 = 0
    if hero.hero_takeHeal1 >= 1 then
      hero.hero_takeHeal1 = hero.hero_takeHeal1
    end
    if hero.hero_takeHeal2 >= 1 then
      hero.hero_takeHeal2 = hero.hero_takeHeal2
    end
    if hero.hero_takeHeal3 >= 1 then
      hero.hero_takeHeal3 = hero.hero_takeHeal3
    end
    hero.skillult_power = 0
    hero.skillatk_power = 0
    hero.skill156_power = 0
  end
end

function Marine.init_hero(hero)
  local skillult = hero.skills.Marine_ult
  if skillult then
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, Marine.skillult_onPhaseFinished)
    skillult.takeEffectAt = override(skillult.takeEffectAt, Marine.skillult_takeEffectAt)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Marine.skillult_takeEffectOn)
  end
  local skillatk2 = hero.skills.Marine_atk2
  if skillatk2 then
    skillatk2.info["Cost HP"] = Marine.atk2_cost_hp
    skillatk2.createBuff = override(skillatk2.createBuff, Marine.skillatk2_createBuff)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, Marine.skillatk2_canCastWithTarget)
  end
  local skillatk = hero.skills.Marine_atk
  if skillatk then
    skillatk.start = override(skillatk.start, Marine.skillatk_start)
    skillatk.power = override(skillatk.power, Marine.skillatk_power)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Marine.skillatk_onPhaseFinished)
  end
  local skillawake = hero.skills.Marine_awake
  local skillawakes = hero.skills.Marine_awakes
  if skillawake then
    skillatk.selectTarget = override(skillatk.selectTarget, Marine.awake_selectTarget)
    skillult.willCast = override(skillult.willCast, Marine.skillult_willCast)
    skillult.finish = override(skillult.finish, Marine.skillult_finish)
    skillatk2.start = override(skillatk2.start, Marine.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, Marine.skillatk2_finish)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, Marine.skillatk2_onPhaseFinished)
    skillawake.power = override(skillawake.power, Marine.skillawake_power)
    skillawake.selectTarget = override(skillatk.selectTarget, Marine.awake_selectTarget)
    hero:enterActionStageFromOneStage(2, 50)
    hero:setActionStageChangeByManual(true)
    hero.reset = override(hero.reset, Marine.reset)
  end
  local skillsawake = hero.skills.Marine_sawake
  if skillsawake and hero.name == "Marine" then
    hero:preloadEffect("eff_buff_Marine_AD.cha")
    hero:preloadEffect("eff_buff_Marine_AP.cha")
    hero:enterActionStageFromOneStage(4, 50)
    local skillnames = {
      "_ult",
      "_atk",
      "_awake"
    }
    for i = 1, #skillnames do
      local skill = hero.skills["Marine" .. skillnames[i]]
      skill.getDamage = override(skill.getDamage, Marine.Skill_getDamage)
      skill.onAttackFrame = override(skill.onAttackFrame, Marine.skill156_onAttackFrame)
    end
    skillawake.start = override(skillawake.start, Marine.skill_start)
    skillult.start = override(skillult.start, Marine.skill_start)
  end
  hero.update = override(hero.update, Marine.hero_update)
  hero.castManualSkill = override(hero.castManualSkill, Marine.hero_castManualSkill)
  hero.ai.findSkillToCast = override(hero.ai.findSkillToCast, Marine.hero_ai_findSkillToCast)
  return hero
end

return Marine.init_hero
