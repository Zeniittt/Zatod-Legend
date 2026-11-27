module("ed.battlehero", package.seeall)
local ed = ed
FieldNPC = {}
FieldNPC.name = "FieldNPC"
FieldNPC.test = false
FieldNPC.testStage = 90010
FieldNPC.testWave = 1
FieldNPC.testField = 22
FieldNPC.fieldBasicBuffId = 1071
FieldNPC.requireLuaSuffixList = {
  "chaosField",
  "extraKael",
  "fishman",
  "randomAerolite",
  "lovers",
  "loversPVE",
  "blackHole",
  "crazyUltimate2",
  "arenaTestUse",
  "godHand",
  "extraDuckboy",
  "ArcanaTrial",
  "NightmareGuild",
  "AngrySheep",
  "FancyAbyssbuff1",
  "FancyAbyssbuff2",
  "FancyAbyssbuff3",
  "FancyAbyssbuff3_2",
  "FancyAbyssbuff4",
  "FancyAbyssbuff6",
  "FancyAbyssbuff7",
  "FancyAbyssbuff9",
  "FancyAbyssbuff9_2",
  "FancyAbyssbuff10",
  "FancyAbyssbuff10_2",
  "FancyAbyssbuff11",
  "FancyAbyssbuff11_2",
  "FancyAbyssbuff12",
  "FancyAbyssbuff12_2",
  "FancyAbyssbuff13",
  "FancyAbyssbuff13_2",
  "FancyAbyssbuff14",
  "FancyAbyssbuff15",
  "PeakArena01",
  "PeakArena02",
  "PeakArena03",
  "PeakArena04",
  "PeakArena05",
  "PeakArena06",
  "FancyAbyssbuff16",
  "FancyAbyssbuff16_2",
  "GuildMountHPR",
  "GuildMountControl",
  "GuildMountControlCD",
  "FancyAbyssbuff17",
  "PeakArena07",
  "GuildMountAP",
  "FancyAbyssbuff17_2",
  "FancyAbyssbuff18",
  "FancyAbyssbuff19",
  "FancyAbyssbuff19_2",
  "PeakArena08",
  "FancyAbyssbuff20",
  "GuildMountShield",
  "GuildMountHoly",
  "GuildMountAtk",
  "PeakArena09",
  "FancyAbyssbuff21",
  "FancyAbyssbuff22",
  "FancyAbyssbuff22_2",
  "PeakArena10",
  "FancyAbyssbuff23",
  "PeakArena11",
  "FancyAbyssbuff24",
  "GuildMountFemale",
  "GuildMountFixReduce",
  "PeakArena12",
  "FancyAbyssbuff25",
  "FancyAbyssbuff26",
  "PeakArena13",
  "Dungeon2",
  "Dungeon5",
  "Dungeon6",
  "Dungeon8",
  "FancyAbyssbuff27",
  "GuildMountAPUlt",
  "GuildMountMultiUp",
  "GuildMountMultiUp2",
  "GuildMountSummon",
  "FancyAbyssbuff28",
  "extraSheep",
  "Dungeon9",
  "PeakArena14",
  "FancyAbyssbuff29",
  "FancyAbyssbuff30",
  "PeakArena15",
  "FancyAbyssbuff31",
  "GuildMountHeal",
  "GuildMountHast",
  "FancyAbyssbuff32",
  "PeakArena16",
  "PeakArena17",
  "FancyAbyssbuff33",
  "FancyAbyssbuff33_2"
}
FieldNPC.minX = ed.engine.stage_rect.minX
FieldNPC.minY = ed.engine.stage_rect.minY
FieldNPC.maxX = ed.engine.stage_rect.maxX
FieldNPC.maxY = ed.engine.stage_rect.maxY
FieldNPC.randomLightning_count = {
  [15] = 1,
  [30] = 3
}
FieldNPC.randomLightning_effect = "eff_point_Fur_ult.cha"
FieldNPC.buffDuration_debuff = 0.2
FieldNPC.buffDuration_buff = 3
FieldNPC.elementStorm_iceBuff = 1084
FieldNPC.elementStorm_fireBuff = 1085
FieldNPC.elementStorm_lightningBuff = 1086
FieldNPC.elementStorm_coef = 0
FieldNPC.speAttack_createCd = 0.25
FieldNPC.speAttack_duration = 7
FieldNPC.speAttack_mpDamage = 125
FieldNPC.mpTransformHp_healCoef = 0
FieldNPC.edgeKill_range = 125
FieldNPC.edgeKill_cd = 5
FieldNPC.edgeKill_rangeX = 1.55 * (FieldNPC.maxX - FieldNPC.minX - FieldNPC.edgeKill_range) / 2
FieldNPC.edgeKill_rangeY = 170
FieldNPC.edgeKill_collideDistanceX = 55
FieldNPC.edgeKill_collideDistanceY = 20
FieldNPC.edgeKill_pointEffect = "eff_tile_TS_atk2.cha"
FieldNPC.killBonus_effect = "eff_impact_KOTL_atk2.cha"
FieldNPC.solo1v1_effect = "eff_buff_VIS_awakeb.cha"
FieldNPC.solo1v1_spectatorBuff = 1092
FieldNPC.solo1v1_duelistBuff = 1093
FieldNPC.fireworks_lampEffectList = {
  R = "eff_point_Field_fireworks_redLamp.cha",
  G = "eff_point_Field_fireworks_greenLamp.cha",
  B = "eff_point_Field_fireworks_blueLamp.cha"
}
FieldNPC.fireworks_deltaPosition = {
  {58, 96},
  {115, 113},
  {177, 135}
}
FieldNPC.fireworks_buffId = 1103
FieldNPC.fireworks_iniEffect = "eff_point_Field_fireworks_iniLamps.cha"
FieldNPC.fireworks_pointEffect1 = "eff_point_Field_fireworks_fireworks.cha"
FieldNPC.fireworks_pointEffect2 = "eff_point_Field_fireworks_fireworks2.cha"
FieldNPC.fireworks_AP = 8
FieldNPC.fireworks_AD = 4
FieldNPC.fireworks_ARM = 2
FieldNPC.fireworks_MR = 1
FieldNPC.fireworks_scale = 0.85
FieldNPC.godHand_buffId = 1273
FieldNPC.godHand_summonId = 228
FieldNPC.PeriodR_buffID = 4190
FieldNPC.PeriodG_buffID = 4191
FieldNPC.PeriodB_buffID = 4192
FieldNPC.PeriodGold_buffID = 4193
FieldNPC.PeriodDarken_buffID = 4194
FieldNPC.PeriodBossR_buffID = 4195
FieldNPC.PeriodBossG_buffID = 4196
FieldNPC.PeriodBossB_buffID = 4197
FieldNPC.PeriodWeak_buffID = 4198
FieldNPC.PeriodInvis_buffID = 4199
FieldNPC.The5thBomb_buffID = 4221
FieldNPC.The5thBomb_red_buffID = 4222

function FieldNPC.getSkillList(ed, field)
  local stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  local waveId = ed.engine.wave_id or 1
  local battleCsvName = ed.engine:getBattleCsvName()
  local level = ed.getDataTable(battleCsvName)[stageId][waveId]
  if FieldNPC.test then
    level = ed.getDataTable(battleCsvName)[FieldNPC.testStage][FieldNPC.testWave]
  end
  local fieldId = level["Stage Skill ID"]
  if FieldNPC.test and FieldNPC.testField then
    fieldId = FieldNPC.testField
  elseif field.setSpecialStageSkillId then
    fieldId = field.setSpecialStageSkillId
  end
  local stageSkill = ed.getDataTable("StageSkill")[fieldId]
  local activeSkillIdList = {}
  local activeSkillNameList = {}
  for i = 1, 999 do
    if not stageSkill["Skill " .. i .. " ID"] or stageSkill["Skill " .. i .. " ID"] == 0 then
      break
    end
    local skillId = stageSkill["Skill " .. i .. " ID"]
    local iniCd = stageSkill["Skill " .. i .. " Start Time"]
    local skillName = ed.getDataTable("Skill")[skillId][0]["Skill Name"]
    table.insert(activeSkillIdList, skillId)
    table.insert(activeSkillNameList, skillName)
    if field.skills[skillId] then
      field.skills[skillId].cd_remaining = iniCd
    end
  end
  return activeSkillIdList, activeSkillNameList
end

function FieldNPC.checkSkill(field, suffix)
  if field.skills[FieldNPC.name .. "_" .. suffix] and field.skills[FieldNPC.name .. "_" .. suffix].is_update then
    return field.skills[FieldNPC.name .. "_" .. suffix]
  end
  return false
end

function FieldNPC.randomLightning_support_createLightning(times, skill)
  local t = 0
  for i = 1, times do
    local position = {
      (FieldNPC.minX + FieldNPC.maxX) / 2,
      0
    }
    local deltaX = (FieldNPC.maxX - FieldNPC.minX) * 0.4
    position[1] = position[1] + ed.rand() * 2 * deltaX - deltaX
    position[2] = position[2] + ed.rand() * 160 - 80
    skill:takeEffectAt(position)
    t = t + 1
  end
  local r = ed.rand()
  if r <= times - t then
    local position = {
      (FieldNPC.minX + FieldNPC.maxX) / 2,
      0
    }
    local deltaX = (FieldNPC.maxX - FieldNPC.minX) * 0.4
    position[1] = position[1] + ed.rand() * 2 * deltaX - deltaX
    position[2] = position[2] + ed.rand() * 160 - 80
    skill:takeEffectAt(position)
  end
end

function FieldNPC.randomLightning_0_field_update(field, dt, skill)
  if skill.cd_remaining <= 0 then
    field.field_randomLightning_time = field.field_randomLightning_time + dt
    FieldNPC.randomLightning_support_createLightning(0.5, skill)
    if skill.field_hasPlayTime then
      skill.field_hasPlayTime = skill.field_hasPlayTime + dt
      if skill.field_hasPlayTime >= 4.5 then
        skill.field_hasPlayTime = nil
      end
    end
    if ed.run_with_scene and not skill.field_hasPlayTime then
      local effect_name = FieldNPC.randomLightning_effect
      local origin = {400, -50}
      ed.scene:playEffectOnScene(effect_name, origin, nil, nil, 1)
      skill.field_hasPlayTime = 0
    end
  end
end

function FieldNPC.buffDuration_0_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local list = owner.buff_list
  local camp = owner.camp
  local buffCoef = 1 / FieldNPC.buffDuration_buff - 1 or 0
  local debuffCoef = 1 / FieldNPC.buffDuration_debuff - 1 or 0
  for i = 1, #list do
    local tbuff = list[i]
    if tbuff.info.Dispel == "YES" and tbuff.caster and tbuff ~= buff then
      if tbuff.caster.camp ~= camp then
        tbuff.timer = tbuff.timer - dt * debuffCoef
      elseif buff.caster.camp == camp then
        tbuff.timer = tbuff.timer - dt * buffCoef
      end
    end
  end
end

function FieldNPC.buffDuration_0_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, FieldNPC.buffDuration_0_buff_update)
  return buff
end

function FieldNPC.elementStorm_0_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local dmg = basefunc(buff, damage, damage_type, source, skill)
  local owner = buff.owner
  if skill then
    local skillTags = skill.info["Skill Tags"]
    local ice = 0
    local fire = 0
    local lightning = 0
    for _, tag in pairs(skillTags) do
      if tag == "ice" then
        ice = ice + 1
        local bid = FieldNPC.elementStorm_iceBuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = owner:addBuff(binfo, owner)
      elseif tag == "fire" then
        fire = fire + 1
        local bid = FieldNPC.elementStorm_fireBuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = owner:addBuff(binfo, owner)
      elseif tag == "lightning" then
        lightning = lightning + 1
        local bid = FieldNPC.elementStorm_lightningBuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = owner:addBuff(binfo, owner)
      end
    end
    dmg = dmg * (1 + FieldNPC.elementStorm_coef * (ice + fire + lightning))
  end
  return dmg
end

function FieldNPC.elementStorm_0_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, FieldNPC.elementStorm_0_buff_onDamaged)
  return buff
end

function FieldNPC.speAttack_mirror_update(basefunc, unit, dt)
  unit.field_speMirrorDuration = unit.field_speMirrorDuration - dt
  local heroCount = 0
  for u in ed.engine:foreachAliveUnit(unit.camp) do
    if not u.config.is_summoned then
      heroCount = heroCount + 1
    end
  end
  if heroCount <= 0 or unit.field_speMirrorDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function FieldNPC.speAttack_mirror_atk_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg = basefunc(skill, target, source, shift)
  if ret then
    target:takeDamage(FieldNPC.speAttack_mpDamage, "Holy", "mp", skill.caster, 1, 1)
  end
  return ret, dmg
end

function FieldNPC.speAttack_mirror_ai_searchTarget(basefunc, ai)
  local owner = ai.owner
  local target = owner.field_speMirrorTarget
  if target and target:isAlive() and target ~= owner and not target.buff_effects.untargetable and not target.buffManager.invisible then
    local p0 = owner.position
    local p1 = target.position
    local x = p0[1] - p1[1]
    local y = p0[2] - p1[2]
    local distanceSQ = x * x + y * y
    return target, distanceSQ
  else
    owner.field_speMirrorTarget = nil
  end
  return basefunc(ai)
end

function FieldNPC.speAttack_support_summonSpe(field, skill, target)
  local proto = {
    _tid = 183,
    _level = 100,
    _stars = field.stars,
    _rank = field.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 2,
    dps_mod = field.config.dps_mod or 1
  }
  local targetPos = target.position
  local mirrorUnit = ed.UnitCreate(proto, -target.camp, config)
  mirrorUnit:setDeathWithEffectOrNot(true)
  mirrorUnit.direction = target.direction
  local deltaX = target.direction > 0 and -38 or 38
  local summonPos = {
    targetPos[1] + deltaX,
    targetPos[2]
  }
  mirrorUnit:pushPuppet("SPEMirror2.cha")
  mirrorUnit:reset()
  mirrorUnit.field_speMirrorTarget = target
  mirrorUnit.field_speMirrorDuration = FieldNPC.speAttack_duration
  ed.engine:summonUnit(mirrorUnit, summonPos, field)
  mirrorUnit.update = override(mirrorUnit.update, FieldNPC.speAttack_mirror_update)
  mirrorUnit.ai.searchTarget = override(mirrorUnit.ai.searchTarget, FieldNPC.speAttack_mirror_ai_searchTarget)
  local mirrorAtk = mirrorUnit.skills.SPEMirror_atk
  if mirrorAtk then
    mirrorAtk.takeEffectOn = override(mirrorAtk.takeEffectOn, FieldNPC.speAttack_mirror_atk_takeEffectOn)
  end
end

function FieldNPC.speAttack_0_start(basefunc, skill, target)
  basefunc(skill, target)
  local field = skill.caster
  field.field_speAttackList = {}
  field.field_speCreateCd = 0
end

function FieldNPC.speAttack_0_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local field = skill.caster
  table.insert(field.field_speAttackList, target)
end

function FieldNPC.speAttack_0_field_update(field, dt, skill)
  local targetList = field.field_speAttackList
  local target
  if targetList then
    target = targetList[#targetList]
  end
  if field.field_speCreateCd then
    field.field_speCreateCd = field.field_speCreateCd + dt
  end
  if target and field.field_speCreateCd >= FieldNPC.speAttack_createCd then
    field.field_speCreateCd = field.field_speCreateCd - FieldNPC.speAttack_createCd
    FieldNPC.speAttack_support_summonSpe(field, skill, target)
    targetList[#targetList] = nil
  end
end

function FieldNPC.mpTransformHp_0_buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local mp = owner.mp
  if owner.mp < owner.attribs.MP then
    owner:setMP(mp - 12)
  end
  basefunc(buff, dt)
end

function FieldNPC.mpTransformHp_0_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, FieldNPC.mpTransformHp_0_buff_update)
  return buff
end

function FieldNPC.attackStunHero_0_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local field = buff.caster
  local skill = field.skills[FieldNPC.name .. "_" .. "attackStunHero"]
  buff.field_attackStunCd = buff.field_attackStunCd and buff.field_attackStunCd - dt or 5
  if buff.field_attackStunCd <= 0 and owner.buff_effects.stun then
    FieldNPC.speAttack_support_summonSpe(field, skill, owner)
    buff.field_attackStunCd = 5
  end
end

function FieldNPC.attackStunHero_0_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, FieldNPC.attackStunHero_0_buff_update)
  return buff
end

function FieldNPC.crazyUltimate_0_buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local mp = owner.mp
  owner:setMP(mp + 8)
  basefunc(buff, dt)
end

function FieldNPC.crazyUltimate_0_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, FieldNPC.crazyUltimate_0_buff_update)
  return buff
end

function FieldNPC.crazyUltimate5_0_buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local mp = owner.mp
  owner:setMP(mp + 8)
  basefunc(buff, dt)
end

function FieldNPC.crazyUltimate5_0_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, FieldNPC.crazyUltimate5_0_buff_update)
  return buff
end

function FieldNPC.edgeKill_projectile_recalculateSpeed(tile)
  local currentRad = tile.field_edgeKillRad
  local currentPos = tile.position
  if currentRad and currentPos then
    local nextRad = currentRad + 2 * math.pi / (FieldNPC.edgeKill_cd / 0.125)
    local nextPosition = {
      FieldNPC.edgeKill_rangeX * math.cos(nextRad) + (FieldNPC.minX + FieldNPC.maxX) / 2,
      FieldNPC.edgeKill_rangeY * math.sin(nextRad)
    }
    tile.velocity = ed.edpSub(nextPosition, currentPos)
    tile.field_edgeKillRad = nextRad
  end
end

function FieldNPC.edgeKill_projectile_collideCheck(basefunc, self, unit)
  local t = basefunc(self, unit)
  local u_pos = unit.position
  local t_pos = self.position
  if (u_pos[1] - t_pos[1]) ^ 2 <= FieldNPC.edgeKill_collideDistanceX ^ 2 and (u_pos[2] - t_pos[2]) ^ 2 <= FieldNPC.edgeKill_collideDistanceY ^ 2 then
    return true
  else
    return false
  end
  return t
end

function FieldNPC.edgeKill_projectile_update(basefunc, tile, dt)
  tile.field_edgeKillExistTime = tile.field_edgeKillExistTime + dt
  local currentRad = tile.field_edgeKillRad
  FieldNPC.edgeKill_projectile_recalculateSpeed(tile)
  local nextRad = tile.field_edgeKillRad
  if tile.field_edgeKillExistTime >= FieldNPC.edgeKill_cd then
    tile.field_edgeKillExistTime = tile.field_edgeKillExistTime - FieldNPC.edgeKill_cd
    tile.affect_times = {}
  end
  basefunc(tile, dt)
end

function FieldNPC.edgeKill_projectile_terminate(basefunc, tile)
  if not tile:isOutOfStage() then
    local skill = tile.skill
    basefunc(tile)
    if skill.existProjectile then
      skill.existProjectile = nil
    end
  end
end

function FieldNPC.edgeKill_0_createProjectile(basefunc, skill)
  local field = skill.caster
  local projectile = basefunc(skill)
  projectile.field_edgeKillRad = 0
  projectile.field_edgeKillExistTime = 0
  projectile.height = 1
  projectile.position = {850, 90}
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(FieldNPC.edgeKill_pointEffect, projectile.position, nil, projectile.height, 1)
  end
  FieldNPC.edgeKill_projectile_recalculateSpeed(projectile)
  projectile.update = override(projectile.update, FieldNPC.edgeKill_projectile_update)
  projectile.collideCheck = override(projectile.collideCheck, FieldNPC.edgeKill_projectile_collideCheck)
  projectile.terminate = override(projectile.terminate, FieldNPC.edgeKill_projectile_terminate)
  ed.engine:addProjectile(projectile)
  skill.existProjectile = projectile
  return nil
end

function FieldNPC.edgeKill_0_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse and skill.existProjectile then
    return false, "already exist"
  end
  return canUse, reason
end

function FieldNPC.edgeKill_0_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local field = skill.caster
  if target:isAlive() and not target.buff_effects.invulnerable then
    target:onDying(field)
  end
end

function FieldNPC.killBonus_0_field_handleUnitDieEvent(field, unit, killer_unit, skill)
  if skill.cd_remaining <= 0 and not unit.config.is_summoned and killer_unit then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(FieldNPC.killBonus_effect, killer_unit.position, nil, killer_unit.height, 1)
    end
    killer_unit:takeHeal(233, "mp", field)
    killer_unit:takeHeal(2333, "hp", field)
  end
end

function FieldNPC.solo1v1_support_forceDie(unit, killer)
  if unit.actor and unit.actor.node then
    unit.actor.node:setVisible(false)
  end
  unit:die(killer)
  unit:setAction(nil)
  unit.hasCorpse = false
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(FieldNPC.solo1v1_effect, unit.position, {1, 1}, nil, 0)
  end
end

function FieldNPC.solo1v1_duelistBuff_onRemoved(basefunc, buff)
  local owner = buff.owner
  local field = buff.caster
  basefunc(buff)
  if not owner:isAlive() then
    for unit in ed.engine:foreachAliveUnit(owner.camp) do
      if unit == owner then
      elseif unit == field then
      else
        FieldNPC.solo1v1_support_forceDie(unit, field)
      end
    end
  end
end

function FieldNPC.solo1v1_support_iniCamp(field, skill, camp)
  local nearestRange = math.huge
  local nearestHero
  local spectatorList = {}
  for unit in ed.engine:foreachAliveUnit(camp) do
    if unit == field then
    elseif unit.config.is_summoned then
    elseif unit.attack_range and nearestRange > unit.attack_range then
      if nearestHero then
        table.insert(spectatorList, nearestHero)
      end
      nearestHero = unit
      nearestRange = unit.attack_range
    else
      table.insert(spectatorList, unit)
    end
  end
  local binfo_duelist = ed.lookupDataTable("Buff", nil, FieldNPC.solo1v1_duelistBuff)
  local buff_duelist = ed.BuffCreate(binfo_duelist, nearestHero, field)
  buff_duelist.onRemoved = override(buff_duelist.onRemoved, FieldNPC.solo1v1_duelistBuff_onRemoved)
  nearestHero:addBuff(buff_duelist, field)
  for i, unit in ipairs(spectatorList) do
    local binfo_spectator = ed.lookupDataTable("Buff", nil, FieldNPC.solo1v1_spectatorBuff)
    local buff_spectator = unit:addBuff(binfo_spectator, field)
    if ed.emCampPlayer == camp then
      unit.position = {
        FieldNPC.minX + i * 70,
        60 + i * 7
      }
    else
      unit.position = {
        FieldNPC.maxX - i * 70,
        60 + i * 7
      }
      unit.direction = -unit.direction
    end
    unit.can_cast_manual = false
    unit.walk_v = {0, 0}
    unit.state = ed.emUnitState_Dying
    ed.engine:onUnitDie(unit, field, false)
  end
end

function FieldNPC.solo1v1_0_field_update(field, dt, skill)
  if skill.cd_remaining <= 0 and not skill.field_iniSet then
    FieldNPC.solo1v1_support_iniCamp(field, skill, field.camp)
    FieldNPC.solo1v1_support_iniCamp(field, skill, -field.camp)
    skill.field_iniSet = true
  end
end

function FieldNPC.DragonKnight_0_field_update(field, dt, skill)
  local dragonTeam = {
    37,
    38,
    92,
    10027,
    10030
  }
  local num_index = math.ceil(ed.rand() * 100) % 5 + 1
  local proto = {
    _tid = dragonTeam[num_index],
    _level = 100,
    _stars = 5,
    _rank = 15
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 5,
    dps_mod = 5,
    summoner = field
  }
  local dragon = ed.UnitCreate(proto, field.camp, config)
  dragon.direction = -1
  local location = {
    500 + (ed.rand() - 0.5) * 300,
    (ed.rand() - 0.5) * 40
  }
  ed.engine:summonUnit(dragon, location, field)
  if ed.run_with_scene then
    local teleportEffect = "eff_buff_TK_awake.cha"
    ed.scene:playEffectOnScene(teleportEffect, {
      dragon.position[1],
      dragon.position[2]
    }, {1, 1}, nil, 1)
  end
end

function FieldNPC.Overyear_summon(field, id)
  local skillevel = {
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100
  }
  local proto = {
    _tid = id,
    _level = 100,
    _stars = 5,
    _rank = 16,
    _skill_levels = skillevel,
    _arousal = {
      _status = 1,
      _str = 100,
      _int = 100,
      _agi = 100
    },
    _hero_rune = {
      _status = 1,
      _sun = 0,
      _moon = 0,
      _star = 0
    },
    _pet = {
      _type_id = 100016,
      _heart = 5,
      _skill_levels = {100, 100}
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    size_mod = 0.95,
    summoner = field
  }
  local location = {0, 0}
  if id == 10046 then
    location = {
      600,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 3
    config.dps_mod = 1.5
  elseif id == 10048 then
    location = {
      400,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 4
    config.dps_mod = 1.5
  elseif id == 10049 then
    location = {
      750,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 6
    config.dps_mod = 1.5
  elseif id == 27 then
    location = {
      420,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 4
    config.dps_mod = 1.7
  elseif id == 61 then
    location = {
      570,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 4
    config.dps_mod = 2.2
  elseif id == 92 then
    location = {
      750,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 3.5
    config.dps_mod = 1
  elseif id == 73 then
    location = {
      450,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 3
    config.dps_mod = 1
  elseif id == 10054 then
    location = {
      600,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 5
    config.dps_mod = 2
  elseif id == 10056 then
    location = {
      720,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 5.5
    config.dps_mod = 2.2
  elseif id == 10059 then
    location = {
      650,
      (ed.rand() - 0.5) * 40
    }
    config.hp_mod = 5.5
    config.dps_mod = 2.7
  end
  local hero = ed.UnitCreate(proto, field.camp, config)
  hero.direction = -1
  ed.engine:summonUnit(hero, location, field, "Idle")
  hero:reset()
end

function FieldNPC.fireworks_support_lampEffect(field, unit, idx, color)
  if ed.run_with_scene then
    local effect_name = FieldNPC.fireworks_lampEffectList[color]
    local pos = FieldNPC.fireworks_deltaPosition[idx]
    local newpos = {}
    newpos[1] = unit.camp == field.camp and FieldNPC.maxX - pos[1] or pos[1]
    newpos[2] = pos[2]
    local node = ed.scene:playEffectOnScene(effect_name, newpos, {
      FieldNPC.fireworks_scale,
      FieldNPC.fireworks_scale
    }, nil, 0)
    if unit.camp == ed.emCampPlayer then
      table.insert(field.field_fireworks_playerLampsEffect, node)
    else
      table.insert(field.field_fireworks_enemyLampsEffect, node)
    end
  end
end

function FieldNPC.fireworks_0_field_collectSkill(field, unit, skill, idx)
  if idx == 1 and skill == unit.manual_skill and skill.info["Cost MP"] >= 1000 and not unit.config.is_summoned then
    local lampList = field.camp ~= unit.camp and field.field_fireworks_playerLamps or field.field_fireworks_enemyLamps
    if field.camp ~= unit.camp and #lampList < 3 then
      local main = unit.info["Main Attrib"]
      local color = "R"
      if main then
        color = main == "INT" and "B" or main == "AGI" and "G" or main == "STR" and "R" or "R"
      end
      table.insert(lampList, color)
      FieldNPC.fireworks_support_lampEffect(field, unit, #lampList, color)
    elseif field.camp == unit.camp and #lampList < 3 then
      local main = unit.info["Main Attrib"]
      local color = "R"
      if main then
        color = main == "INT" and "B" or main == "AGI" and "G" or main == "STR" and "R" or "R"
      end
      table.insert(lampList, color)
      FieldNPC.fireworks_support_lampEffect(field, unit, #lampList, color)
    end
  end
end

function FieldNPC.fireworks_support_checkCampLamps(field, camp, dt)
  local lampList = camp == ed.emCampPlayer and field.field_fireworks_playerLamps or field.field_fireworks_enemyLamps
  local extraSkill = camp == ed.emCampPlayer and field.skills.FieldNPC_fireworksP or field.skills.FieldNPC_fireworksE
  local effectList = camp == ed.emCampPlayer and field.field_fireworks_playerLampsEffect or field.field_fireworks_enemyLampsEffect
  local campIdx = camp == ed.emCampPlayer and 1 or -1
  if 3 <= #lampList then
    field.field_fireworks_fireworksTime[campIdx] = field.field_fireworks_fireworksTime[campIdx] + dt
    if field.field_fireworks_fireworksTime[campIdx] >= 0 and not field.fireworks_nightEffect and ed.run_with_scene then
      local effect_night = "eff_point_Luna_night.cha"
      local origin = {
        ed.engine.stage_rect.maxX / 2,
        0
      }
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
      field.fireworks_nightEffect = true
    end
    if field.field_fireworks_fireworksTime[campIdx] >= 1.5 then
      local oinfo = extraSkill.info
      if lampList[1] == lampList[2] and lampList[1] == lampList[3] then
        extraSkill.field_fireworks_powerUp = true
      end
      if ed.run_with_scene then
        local effect = extraSkill.field_fireworks_powerUp and FieldNPC.fireworks_pointEffect2 or FieldNPC.fireworks_pointEffect1
        local dx = 200
        local y = 80
        local pos = camp == ed.emCampPlayer and {dx, y} or {
          FieldNPC.maxX - dx,
          y
        }
        local scale = camp == ed.emCampPlayer and {1, 1} or {-1, 1}
        ed.scene:playEffectOnScene(effect, pos, scale, nil, 1)
      end
      extraSkill:takeEffectAt(field.position)
      extraSkill.info = oinfo
      extraSkill.field_fireworks_powerUp = false
      field.field_fireworks_fireworksTime[campIdx] = 0
      field.fireworks_nightEffect = false
      if camp ~= field.camp then
        field.field_fireworks_playerLamps = {}
      else
        field.field_fireworks_enemyLamps = {}
      end
      if ed.run_with_scene then
        for _, effect in ipairs(effectList) do
          ed.scene:removeEffect(effect, 0)
        end
      end
    end
  end
end

function FieldNPC.fireworks_0_field_update(field, dt, skill)
  FieldNPC.fireworks_support_checkCampLamps(field, field.camp, dt)
  FieldNPC.fireworks_support_checkCampLamps(field, -field.camp, dt)
  if not field.fireworks_ini and ed.run_with_scene then
    local effect_night = FieldNPC.fireworks_iniEffect
    local deltaX = 128
    local deltaY = 135
    local origin1 = {deltaX, deltaY}
    local _ = ed.scene:playEffectOnScene(effect_night, origin1, {
      FieldNPC.fireworks_scale,
      FieldNPC.fireworks_scale
    }, nil, 0)
    local origin2 = {
      ed.engine.stage_rect.maxX - deltaX,
      deltaY
    }
    local __ = ed.scene:playEffectOnScene(effect_night, origin2, {
      -FieldNPC.fireworks_scale,
      FieldNPC.fireworks_scale
    }, nil, 0)
    field.fireworks_ini = true
  end
end

function FieldNPC.fireworks_pe_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local level = target.level or 1
  buff:setAttribute("AP", level * FieldNPC.fireworks_AP)
  buff:setAttribute("AD", level * FieldNPC.fireworks_AD)
  buff:setAttribute("ARM", level * FieldNPC.fireworks_ARM)
  buff:setAttribute("MR", level * FieldNPC.fireworks_MR)
  return buff
end

function FieldNPC.fireworks_pe_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if skill.field_fireworks_powerUp then
    target:addBuff(skill:createBuff(target))
  end
end

function FieldNPC.Giantism_0_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk1 = caster.skills.FieldNPC_Giantism1
  local skillatk2 = caster.skills.FieldNPC_Giantism2
  if skillatk1 then
    local newTarget = skillatk2:selectTarget(nil)
    if newTarget then
      newTarget:addBuff(skillatk2:createBuff(newTarget), master)
    end
  end
end

function FieldNPC.breakfast_0_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk1 = caster.skills.FieldNPC_breakfast1
  local skillatk2 = caster.skills.FieldNPC_breakfast2
  if skillatk1 then
    local newTarget = skillatk2:selectTarget(nil)
    if newTarget then
      newTarget:addBuff(skillatk2:createBuff(newTarget), master)
    end
  end
end

function FieldNPC.exchange_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk1 = caster.skills.FieldNPC_RandomExchange1
  local skillatk2 = caster.skills.FieldNPC_RandomExchange2
  if skillatk1 then
    local newTarget = skillatk2:selectTarget(nil)
    if newTarget then
      newTarget:addBuff(skillatk2:createBuff(newTarget), master)
    end
  end
end

function FieldNPC.maleLostHp_buff_update(basefunc, self, dt)
  basefunc(self, dt)
  local owner = self.owner
  if owner.hp < 10 then
    owner.die(owner)
  end
end

function FieldNPC.maleLostHp_createBuff(basefunc, skill, target)
  local maleLostHp_buff = basefunc(skill, target)
  if target.info.Gender == "\231\148\183" then
    local buffHPR = -target.attribs.HP / 5
    maleLostHp_buff:setAttribute("HPR", buffHPR)
    maleLostHp_buff.update = override(maleLostHp_buff.update, FieldNPC.maleLostHp_buff_update)
  end
  return maleLostHp_buff
end

function FieldNPC.LostHp_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  buff.counter = buff.counter + 1
  local t = ed.engine.ticks
  if buff.counter >= 0 and not owner.volcanno then
    if ed.run_with_scene then
      local effect_electric = "eff_point_Stargate_electric.cha"
      local origin = {400, 0}
      ed.scene:playEffectOnScene(effect_electric, origin, nil, nil, -1)
    end
    owner.volcanno = true
  end
end

function FieldNPC.LostHp_createBuff(basefunc, skill, target)
  local cataBuff = basefunc(skill, target)
  cataBuff.update = override(cataBuff.update, FieldNPC.LostHp_buff_update)
  cataBuff.counter = 0
  return cataBuff
end

function FieldNPC.godHand_summonUnit_canTouchRespond(basefunc, summonUnit)
  if not ed.engine.beingEnd then
    return 99999
  end
  return basefunc(summonUnit)
end

function FieldNPC.godHand_summonUnit_touchPositionHandler(basefunc, summonUnit, pos)
  basefunc(summonUnit, pos)
  local field = summonUnit.fieldNPC
  local godHand = FieldNPC.checkSkill(field, "godHand")
  if godHand and godHand.remainUseLimit and godHand.remainUseLimit > 0 then
    godHand:takeEffectAt(pos)
  end
end

function FieldNPC.godHand_0_field_reset(field, skill)
  local proto = {
    _tid = FieldNPC.godHand_summonId,
    _level = 100,
    _skill_levels = {
      [1] = 100
    },
    _stars = field.stars,
    _rank = field.rank,
    _fashion = {
      _current_fashion = field.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = field.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or field.config.hp_mod,
    dps_mod = field.config.dps_mod or 1
  }
  local summonUnit = ed.UnitCreate(proto, field.camp, config)
  summonUnit.canTouchRespond = override(summonUnit.canTouchRespond, FieldNPC.godHand_summonUnit_canTouchRespond)
  summonUnit.touchPositionHandler = override(summonUnit.touchPositionHandler, FieldNPC.godHand_summonUnit_touchPositionHandler)
  local binfo = ed.lookupDataTable("Buff", nil, FieldNPC.godHand_buffId)
  local buff = summonUnit:addBuff(binfo, summonUnit)
  local location = {400, 0}
  ed.engine:summonUnit(summonUnit, location, field)
  summonUnit.fieldNPC = field
  field.godHandSummonUnit = summonUnit
end

function FieldNPC.godHand_0_field_handleUnitDieEvent(field, unit, killer_unit, skill)
  if field.godHandSummonUnit and field.godHandSummonUnit:isAlive() then
    local remainEnemy = false
    for u in ed.engine:foreachAliveUnit(field.camp) do
      if u ~= field.godHandSummonUnit and not u.config.is_summoned then
        remainEnemy = true
        break
      end
    end
    if not remainEnemy then
      field.godHandSummonUnit:die()
    end
  end
end

function FieldNPC.setStageSkillId(field, stageSkillId)
  field.setSpecialStageSkillId = stageSkillId
end

function FieldNPC.reset(basefunc, field)
  basefunc(field)
  local activeSkillIdList, activeSkillNameList = FieldNPC.getSkillList(ed, field)
  for _, skill in ipairs(field.skill_list) do
    skill:pause()
  end
  if activeSkillNameList then
    for _, skillName in ipairs(activeSkillNameList) do
      local skill = field.skills[skillName]
      if skill then
        skill:resume()
      end
    end
  end
  field.position = {
    (FieldNPC.minX + FieldNPC.maxX) / 2,
    0
  }
  local randomLightning = FieldNPC.checkSkill(field, "randomLightning")
  if randomLightning then
    field.field_randomLightning_time = 0
  end
  local fancy8_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  local FancyAbyssbuff8 = FieldNPC.checkSkill(field, "FancyAbyssbuff8")
  if FancyAbyssbuff8 and 12109000 < fancy8_stageId and fancy8_stageId < 12110000 then
    field.fancyabyssbuff8currentcount = 0
    field.fancyabyssbuff8count = 0
  end
  local speAttack = FieldNPC.checkSkill(field, "speAttack")
  if speAttack then
    field.field_speAttackList = {}
    field.field_speCreateCd = 0
  end
  local crazyUltimate = FieldNPC.checkSkill(field, "crazyUltimate")
  if crazyUltimate then
    ed.engine.time_limit = ed.engine.time_limit + 30
  end
  local crazyUltimate = FieldNPC.checkSkill(field, "crazyUltimate2")
  if crazyUltimate then
    ed.engine.time_limit = ed.engine.time_limit + 30
  end
  local fireworks = FieldNPC.checkSkill(field, "fireworks")
  if fireworks then
    field.field_fireworks_playerLamps = {}
    field.field_fireworks_enemyLamps = {}
    field.field_fireworks_playerLampsEffect = {}
    field.field_fireworks_enemyLampsEffect = {}
    field.field_fireworks_fireworksTime = {
      [1] = 0,
      [-1] = 0
    }
  end
  local godHand = FieldNPC.checkSkill(field, "godHand")
  if godHand then
    FieldNPC.godHand_0_field_reset(field, godHand)
  end
  for _, suffix in ipairs(FieldNPC.requireLuaSuffixList) do
    local iniSkill = FieldNPC.checkSkill(field, suffix)
    if iniSkill then
      local init_func = require("battle/heroes/fieldSkill/" .. suffix)
      iniSkill = init_func(iniSkill)
      if overwrite_fieldNPC_script and overwrite_fieldNPC_script[suffix] then
        local func = overwrite_fieldNPC_script[suffix]
        func()
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, FieldNPC.fieldBasicBuffId)
  local buff = field:addBuff(binfo, field)
  field.United_enemy_num = 0
  field.United_enemy_num_record = 0
  field.overyear_total_num = 0
  field.Overyear_actor_index = 1
  local The5thBomb = FieldNPC.checkSkill(field, "5thBomb")
  if The5thBomb then
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      unit.castSkill = override(unit.castSkill, FieldNPC.The5th_castSkill)
    end
    local unit = FieldNPC.The5thBomb_chooseRandomUnit()
    local binfo = ed.lookupDataTable("Buff", nil, FieldNPC.The5thBomb_buffID)
    local buff = ed.BuffCreate(binfo, unit, field)
    unit.The5th_hasBomb = true
    buff.onRemoved = override(buff.onRemoved, FieldNPC.The5thBomb_onRemoved)
    buff.timer = buff.timer * (0.75 + 0.25 * ed.rand())
    unit:addBuff(buff, unit)
  end
  field.healamount = 0
  field.GuildMountHealTime = 0
  field.GuildMountHealAmount = 0
  field.healamount29 = 0
end

function FieldNPC.The5th_castSkill(basefunc, unit, skill, target)
  basefunc(unit, skill, target)
  local caster = skill.caster
  if skill == caster.manual_skill and unit.The5th_hasBomb then
    local next_unit = FieldNPC.The5thBomb_chooseRandomUnit(unit)
    if not next_unit then
      return
    end
    local binfo = {}
    local buff = {}
    unit.The5th_hasBomb = nil
    for i, ubuff in ipairs(caster.buff_list) do
      if ubuff.info.ID == FieldNPC.The5thBomb_buffID then
        binfo = ed.lookupDataTable("Buff", nil, FieldNPC.The5thBomb_buffID)
        buff = ed.BuffCreate(binfo, next_unit, unit)
        buff.timer = ubuff.timer
        ubuff.The5th_buff_isMoved = true
        ubuff.timer = 0
        buff.onRemoved = override(buff.onRemoved, FieldNPC.The5thBomb_onRemoved)
      elseif ubuff.info.ID == FieldNPC.The5thBomb_red_buffID and ubuff.timer > 1 then
        binfo = ed.lookupDataTable("Buff", nil, FieldNPC.The5thBomb_red_buffID)
        buff = ed.BuffCreate(binfo, next_unit, unit)
        buff.timer = ubuff.timer
        ubuff.The5th_buff_isMoved = true
        ubuff.timer = 0
        ubuff.The5thBomb_explode = nil
        buff.The5thBomb_explode = true
        buff.update = override(buff.update, FieldNPC.The5thBomb_red_update)
      end
    end
    if buff.timer and buff.timer > 0 then
      next_unit:addBuff(buff, unit)
    end
    next_unit.The5th_hasBomb = true
  end
end

function FieldNPC.The5thBomb_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  if owner.state == ed.emUnitState_Dying then
    local cunit = FieldNPC.The5thBomb_chooseRandomUnit()
    if cunit then
      local binfo = ed.lookupDataTable("Buff", nil, FieldNPC.The5thBomb_buffID)
      local buff = ed.BuffCreate(binfo, cunit, caster)
      cunit.The5th_hasBomb = true
      buff.onRemoved = override(buff.onRemoved, FieldNPC.The5thBomb_onRemoved)
      buff.timer = buff.timer * (0.5 + 0.5 * ed.rand())
      cunit:addBuff(buff, caster)
      return
    end
  end
  if not buff.The5th_buff_isMoved then
    binfo = ed.lookupDataTable("Buff", nil, FieldNPC.The5thBomb_red_buffID)
    local bbuff = ed.BuffCreate(binfo, owner, caster)
    bbuff.The5thBomb_explode = true
    bbuff.update = override(bbuff.update, FieldNPC.The5thBomb_red_update)
    owner:addBuff(bbuff, caster)
  else
    buff.The5th_buff_isMoved = nil
  end
end

function FieldNPC.The5thBomb_red_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local unit = buff.owner
  local caster = buff.caster
  if unit.state == ed.emUnitState_Dying then
    local cunit = FieldNPC.The5thBomb_chooseRandomUnit()
    if cunit then
      local binfo = ed.lookupDataTable("Buff", nil, FieldNPC.The5thBomb_buffID)
      local buff = ed.BuffCreate(binfo, cunit, caster)
      cunit.The5th_hasBomb = true
      buff.onRemoved = override(buff.onRemoved, FieldNPC.The5thBomb_onRemoved)
      buff.timer = buff.timer * (0.5 + 0.5 * ed.rand())
      cunit:addBuff(buff, caster)
      return
    end
  end
  if buff.timer <= 1 and buff.The5thBomb_explode then
    buff.The5thBomb_explode = nil
    if unit.camp ~= ed.emCampPlayer then
      unit:takeDamage(500000, "Holy", "hp", caster)
    else
      unit:takeDamage(unit.hp * 0.95, "Holy", "hp", caster)
    end
    local cunit = FieldNPC.The5thBomb_chooseRandomUnit()
    if cunit then
      local binfo = ed.lookupDataTable("Buff", nil, FieldNPC.The5thBomb_buffID)
      local buff = ed.BuffCreate(binfo, cunit, caster)
      cunit.The5th_hasBomb = true
      buff.onRemoved = override(buff.onRemoved, FieldNPC.The5thBomb_onRemoved)
      buff.timer = buff.timer * (0.5 + 0.5 * ed.rand())
      cunit:addBuff(buff, caster)
    end
  end
end

function FieldNPC.The5thBomb_chooseRandomUnit(owner)
  local ally_buff_temp = {}
  local enemy_buff_temp = {}
  local i = 0
  local j = 0
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit ~= owner and not unit.config.is_summoned and unit.camp == ed.emCampPlayer then
      i = i + 1
      table.insert(ally_buff_temp, unit)
    elseif unit ~= owner and not unit.config.is_summoned and unit.camp == ed.emCampEnemy then
      j = j + 1
      table.insert(enemy_buff_temp, unit)
    end
  end
  local enemy_prob = 0
  if not ally_buff_temp[1] then
    enemy_prob = 1
  elseif not enemy_buff_temp[1] then
    enemy_prob = 0
  elseif owner and owner.camp == ed.emCampPlayer then
    enemy_prob = 0.8
  elseif owner and owner.camp == ed.emCampEnemy then
    enemy_prob = 0.2
  end
  if enemy_prob >= ed.rand() then
    return enemy_buff_temp[math.ceil(ed.rand() / (1 / j))]
  else
    return ally_buff_temp[math.ceil(ed.rand() / (1 / i))]
  end
end

function FieldNPC.update(basefunc, field, dt)
  basefunc(field, dt)
  field.timeCount = field.timeCount + dt
  local randomLightning = FieldNPC.checkSkill(field, "randomLightning")
  if randomLightning then
    FieldNPC.randomLightning_0_field_update(field, dt, randomLightning)
  end
  local speAttack = FieldNPC.checkSkill(field, "speAttack")
  if speAttack then
    FieldNPC.speAttack_0_field_update(field, dt, speAttack)
  end
  local solo1v1 = FieldNPC.checkSkill(field, "solo1v1")
  if solo1v1 then
    FieldNPC.solo1v1_0_field_update(field, dt, solo1v1)
  end
  local fireworks = FieldNPC.checkSkill(field, "fireworks")
  if fireworks then
    FieldNPC.fireworks_0_field_update(field, dt, fireworks)
  end
  local DragonKnight = FieldNPC.checkSkill(field, "DragonKnight")
  if DragonKnight and field.DKAlive and field.dragonSummonNum < 4 and field.timeCount % 1 == 0 then
    FieldNPC.DragonKnight_0_field_update(field, dt, DragonKnight)
    field.dragonSummonNum = field.dragonSummonNum + 1
  end
  if DragonKnight and field.DKAlive and field.dragonSummonNum >= 4 and field.timeCount % 10 == 0 then
    FieldNPC.DragonKnight_0_field_update(field, dt, DragonKnight)
    field.dragonSummonNum = field.dragonSummonNum + 1
  end
  local Overyear = FieldNPC.checkSkill(field, "Overyear")
  if Overyear then
    local Overyear_Boss = ed.engine:findBoss()
    local Overyear_actor_list = {
      10046,
      10048,
      10056,
      10049,
      27,
      92,
      61,
      73,
      10054,
      10059
    }
    if field.timeCount % 7 == 0 then
      for unit in ed.engine:foreachAliveUnit(-1) do
        if unit.info["Unit Type"] == "Hero" then
          field.overyear_total_num = field.overyear_total_num + 1
        end
      end
      if field.overyear_total_num < 5 then
        local summon_id = Overyear_actor_list[field.Overyear_actor_index]
        FieldNPC.Overyear_summon(field, summon_id)
        field.Overyear_actor_index = field.Overyear_actor_index + 1
        if 10 < field.Overyear_actor_index then
          field.Overyear_actor_index = 1
        end
      end
      field.overyear_total_num = 0
    end
    if field.timeCount % 9 == 0 then
      local hp_least_Unit, mp_least_Unit
      local least_hp = 9999999
      local least_mp = 1000
      for unit in ed.engine:foreachAliveUnit(1) do
        if unit.info["Unit Type"] == "Hero" then
          local hp = unit.hp
          local mp = unit.mp
          if least_hp > hp then
            hp_least_Unit = unit
            least_hp = hp
          end
          if least_mp > mp then
            mp_least_Unit = unit
            least_mp = mp
          end
        end
      end
      if hp_least_Unit then
        hp_least_Unit:takeHeal(9999999, "hp", hp_least_Unit)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_CHEN_atk3.cha", {
            hp_least_Unit.position[1],
            hp_least_Unit.position[2]
          }, {1, 1}, nil, 0)
        end
      end
      if mp_least_Unit then
        mp_least_Unit:takeHeal(1000, "mp", mp_least_Unit)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_CHEN_atk3.cha", {
            mp_least_Unit.position[1],
            mp_least_Unit.position[2]
          }, {1, 1}, nil, 0)
        end
      end
    end
    if Overyear_Boss and not Overyear_Boss:isAlive() then
      for unit in ed.engine:foreachAliveUnit(-1) do
        if unit.info["Unit Type"] == "Hero" and not unit.config.is_boss then
          unit:die()
          if ed.run_with_scene then
            ed.scene:playEffectOnScene("eff_point_GT_bless.cha", {
              unit.position[1],
              unit.position[2]
            }, {1, 1}, nil, 0)
          end
        end
      end
    end
  end
  local DeathCall = FieldNPC.checkSkill(field, "DeathCall")
  if DeathCall and field.timeCount % 12 == 0 then
    local unit_number_one = 0
    local one_list = {}
    for unit in ed.engine:foreachAliveUnit(1) do
      if unit.info["Unit Type"] == "Hero" then
        unit_number_one = unit_number_one + 1
        table.insert(one_list, unit)
      end
    end
    local unit_number_minus_one = 0
    local minus_one_list = {}
    for unit in ed.engine:foreachAliveUnit(-1) do
      if unit.info["Unit Type"] == "Hero" then
        unit_number_minus_one = unit_number_minus_one + 1
        table.insert(minus_one_list, unit)
      end
    end
    if 1 < unit_number_one and 1 < unit_number_minus_one then
      local one_rand = math.ceil(ed.rand() * 100) % #one_list
      local one_dead_unit = one_list[one_rand + 1]
      if one_dead_unit:isAlive() and not one_dead_unit.config.is_summoned then
        one_dead_unit:die()
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_GT_bless.cha", {
            one_dead_unit.position[1],
            one_dead_unit.position[2]
          }, {1, 1}, nil, 0)
        end
      end
      local minus_one_rand = math.ceil(ed.rand() * 100) % #minus_one_list
      local minus_one_dead_unit = minus_one_list[minus_one_rand + 1]
      if minus_one_dead_unit:isAlive() and not minus_one_dead_unit.config.is_summoned then
        minus_one_dead_unit:die()
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_GT_bless.cha", {
            minus_one_dead_unit.position[1],
            minus_one_dead_unit.position[2]
          }, {1, 1}, nil, 0)
        end
      end
    end
  end
  local SinglePoint = FieldNPC.checkSkill(field, "SinglePoint")
  if SinglePoint then
    local SinglePoint_Boss = ed.engine:findBoss()
    if SinglePoint_Boss and not SinglePoint_Boss:isAlive() then
      for unit in ed.engine:foreachAliveUnit(-1) do
        if unit.info["Unit Type"] == "Hero" and not unit.config.is_boss then
          unit:die()
          if ed.run_with_scene then
            ed.scene:playEffectOnScene("eff_point_GT_bless.cha", {
              unit.position[1],
              unit.position[2]
            }, {1, 1}, nil, 0)
          end
        end
      end
    end
  end
  local United = FieldNPC.checkSkill(field, "United")
  if United then
    if field.timeCount == 0.125 then
      local bid = 4047
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      for unit in ed.engine:foreachAliveUnit(1) do
        if unit.info["Unit Type"] == "Hero" then
          field.United_buff = unit:addBuff(binfo, field)
        end
      end
    end
    field.United_enemy_num = 0
    for unit in ed.engine:foreachAliveUnit(-1) do
      if unit.info["Unit Type"] == "Hero" then
        field.United_enemy_num = field.United_enemy_num + 1
      end
    end
    if field.timeCount > 0.125 and field.United_enemy_num ~= field.United_enemy_num_record then
      local bid = 4047
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      for unit in ed.engine:foreachAliveUnit(1) do
        if unit.info["Unit Type"] == "Hero" then
          unit:addBuff(binfo, field)
        end
      end
    end
    field.United_enemy_num_record = field.United_enemy_num
  end
  local Newyear = FieldNPC.checkSkill(field, "Newyear")
  local Newyear2019 = FieldNPC.checkSkill(field, "Newyear2019")
  if Newyear or Newyear2019 then
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      if unit.Newyear_speed_status ~= 1 and unit.Newyear_speed_status ~= 2 then
        unit.Newyear_speed_status = 0
      end
      if unit.info["Unit Type"] == "Hero" then
        if unit.position[1] >= 250 and unit.position[1] <= 450 and unit.Newyear_speed_status ~= 1 then
          for i, buff in ipairs(unit.buff_list) do
            if buff.info.ID == 4086 then
              buff.timer = 0
            end
          end
          local bid = 4085
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit, field)
          unit:addBuff(buff, field)
          unit.Newyear_speed_status = 1
        end
        if (0 <= unit.position[1] and unit.position[1] < 250 or unit.position[1] > 450 and unit.position[1] <= 800) and unit.Newyear_speed_status ~= 2 then
          for i, buff in ipairs(unit.buff_list) do
            if buff.info.ID == 4085 then
              buff.timer = 0
            end
          end
          local bid = 4086
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit, field)
          unit:addBuff(buff, field)
          unit.Newyear_speed_status = 2
        end
      end
    end
  end
  local fancy8_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  local FancyAbyssbuff8 = FieldNPC.checkSkill(field, "FancyAbyssbuff8")
  if FancyAbyssbuff8 and 12109000 < fancy8_stageId and fancy8_stageId < 12110000 then
    FieldNPC.FancyAbyssbuff8_hero_update(basefunc, field, dt)
  end
end

function FieldNPC.collectSkill(basefunc, field, unit, skill, idx)
  basefunc(field, unit, skill, idx)
  local fireworks = FieldNPC.checkSkill(field, "fireworks")
  if fireworks then
    FieldNPC.fireworks_0_field_collectSkill(field, unit, skill, idx)
  end
end

function FieldNPC.handleUnitDieEvent(basefunc, field, unit, killer_unit)
  basefunc(field, unit, killer_unit)
  local killBonus = FieldNPC.checkSkill(field, "killBonus")
  if killBonus then
    FieldNPC.killBonus_0_field_handleUnitDieEvent(field, unit, killer_unit, killBonus)
  end
  local godHand = FieldNPC.checkSkill(field, "godHand")
  if godHand then
    FieldNPC.godHand_0_field_handleUnitDieEvent(field, unit, killer_unit, godHand)
  end
  local DeathBoom = FieldNPC.checkSkill(field, "DeathBoom")
  if DeathBoom and unit:isHero() and not unit.config.is_summoned then
    DeathBoom.takeEffectAt(DeathBoom, unit.position, field)
  end
  local DragonKnight = FieldNPC.checkSkill(field, "DragonKnight")
  if DragonKnight then
    print("die")
  end
  if DragonKnight and (unit.tid == 67 or unit.tid == "DK") and unit.camp == field.camp then
    field.DKAlive = false
    print("DKdie")
    for u in ed.engine:foreachAliveUnit(field.camp) do
      u:die()
    end
  end
  local TreasureDie = FieldNPC.checkSkill(field, "TreasureDie")
  if TreasureDie and (unit.tid == 10057 or unit.tid == "Treasure" and unit.camp == field.camp) then
    field.TreasuerAlive = false
    for Treasurecamp in ed.engine:foreachAliveUnit(field.camp) do
      Treasurecamp:die()
    end
  end
  local fancy8_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  local FancyAbyssbuff8 = FieldNPC.checkSkill(field, "FancyAbyssbuff8")
  if FancyAbyssbuff8 and 12109000 < fancy8_stageId and fancy8_stageId < 12110000 then
    FieldNPC.FancyAbyssbuff8_handledieevent(field, unit, killer_unit, FancyAbyssbuff8)
  end
end

function FieldNPC.HPRatioLow_0_buff_update(basefunc, buff, dt)
  local owner = buff.owner
  if owner.info["Interrupt HP Ratio"] >= 0 then
    owner.info["Interrupt HP Ratio"] = 1.0E-4
  end
  if 0 <= owner.attribs.INTR then
    owner.attribs.INTR = 1.0E-4
  end
  basefunc(buff, dt)
end

function FieldNPC.HPRatioLow_0_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, FieldNPC.HPRatioLow_0_buff_update)
  return buff
end

function FieldNPC.chicken_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target and target:isAlive() then
    target.notPopupBattleInfo = true
    local binfo = ed.lookupDataTable("Buff", nil, 296)
    target:addBuff(binfo, skill.caster)
  end
  buff.info["No Pass"] = true
  buff.update = override(buff.update, FieldNPC.chicken_buff_update)
  buff.onDamaged = override(buff.onDamaged, FieldNPC.chicken_buff_onDamaged)
  target.chicken_trig = true
  target.chicken_damage_timer = 0
  target.chicken_heal_timer = 0
  target.chicken_hp_counter = 5
  return buff
end

function FieldNPC.chicken_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.owner.chicken_damage_timer = buff.owner.chicken_damage_timer + 1
  buff.owner.chicken_heal_timer = buff.owner.chicken_heal_timer + 1
end

function FieldNPC.chicken_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source.config.is_summoned == true then
    owner.chicken_summon = true
  end
  if owner.chicken_hp_counter == 1 then
    source.chicken_hp_counter = source.chicken_hp_div
    source.hp = source.attribs.HP
  end
  return damage
end

function FieldNPC.chicken_collectHPchange(basefunc, npc, config)
  basefunc(npc, config)
  local hp_change = config.hp_change
  local hp = config.hp
  local unit = config.unit
  if unit.config.is_summoned and hp_change ~= 0 then
    hp_change = hp - hp_change
    hp = 0
    config.hp = hp - hp_change
    config.hp_change = 0
    return
  end
  if unit.chicken_summon == true then
    unit.chicken_summon = false
    config.hp = hp - hp_change
    config.hp_change = 0
    return
  end
  if not unit.chicken_hp_div then
    unit.chicken_hp_div = 5
  end
  if not unit.chicken_hp_counter then
    unit.chicken_hp_counter = unit.chicken_hp_div
  end
  if not unit.chicken_damage_timer then
    unit.chicken_damage_timer = 0
  end
  if not unit.chicken_heal_timer then
    unit.chicken_heal_timer = 0
  end
  local bloodball = math.floor(unit.attribs.HP / unit.chicken_hp_div) + 1
  if unit.chicken_damage_timer >= 16 and hp_change < 0 then
    unit.chicken_hp_counter = math.max(0, unit.chicken_hp_counter - 1)
    hp = bloodball * unit.chicken_hp_counter
    if unit.chicken_hp_counter == 0 then
      hp_change = 0
    else
      hp_change = -bloodball
    end
    unit.chicken_damage_timer = 0
    if unit.actor then
      unit.notPopupBattleInfo = false
      ed.PopupCreate("-1", "red", unit.actor, nil, "damage")
      unit.notPopupBattleInfo = true
    end
  end
  if unit.chicken_heal_timer >= 16 and 0 < hp_change then
    unit.chicken_hp_counter = math.min(unit.chicken_hp_div, unit.chicken_hp_counter + 1)
    hp = math.min(unit.attribs.HP, bloodball * unit.chicken_hp_counter)
    if unit.chicken_hp_counter == unit.chicken_hp_div then
      hp_change = 0
    else
      hp_change = bloodball
    end
    unit.chicken_heal_timer = 0
    if unit.actor then
      unit.notPopupBattleInfo = false
      ed.PopupCreate("+1", "green", unit.actor, nil, "damage")
      unit.notPopupBattleInfo = true
    end
  end
  if unit.chicken_heal_timer < 16 and unit.chicken_damage_timer < 16 or math.abs(hp_change) ~= math.abs(bloodball) then
    hp = hp - hp_change
    hp_change = 0
  end
  config.hp = hp
  config.hp_change = hp_change
  local alive_counter = 0
  local unit_last
  if hp <= 0 and not unit.config.is_summoned then
    for unitC in ed.engine:foreachAliveUnit(unit.camp) do
      if unitC:isAlive() and not unitC.config.is_summoned and unitC ~= unit then
        alive_counter = alive_counter + 1
        unit_last = unitC
      end
    end
  end
  if alive_counter == 1 then
    unit_last.hp = unit_last.attribs.HP
    unit_last.chicken_hp_div = math.max(unit_last.chicken_hp_counter * 2, 5)
    unit_last.chicken_hp_counter = unit_last.chicken_hp_div
  end
end

function FieldNPC.fancy13_stuneffect(buff)
  local negative_effects = {stun = true, stunbyself = true}
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

function FieldNPC.fancy13_feareffect(buff)
  local negative_effects = {fear = true}
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

function FieldNPC.halloween1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hero = skill.caster
  buff:setAttribute("fearrange", 5)
  local halloween2 = hero.skills[FieldNPC.name .. "_" .. "halloween2"]
  if halloween2 then
    local minINT = math.huge
    local minINT_Unit = target
    for unit in ed.engine:foreachAliveUnit(-target.camp) do
      if unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible then
      elseif unit.attribs.INT and minINT > unit.attribs.INT then
        minINT_Unit = unit
        minINT = unit.attribs.INT
      end
    end
    if minINT_Unit then
      halloween2:takeEffectOn(minINT_Unit, hero)
    end
  end
  return buff
end

function FieldNPC.halloween2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function FieldNPC.fancybuff13_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local caster = buff.caster
  local owner = buff.owner
  if FieldNPC.fancy13_stuneffect(buff) and caster:isAlive() and owner.camp == unit.camp and caster.f13stuncount then
    caster.f13stuncount = caster.f13stuncount + 1
  end
  if FieldNPC.fancy13_feareffect(buff) and caster:isAlive() and owner.camp == unit.camp and caster.f13stuncount then
    caster.f13stuncount = caster.f13stuncount + 1
  end
end

function FieldNPC.fancybuff17_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local caster = buff.caster
  local owner = buff.owner
  if buff.info.HPR < 0 and caster:isAlive() and owner.camp == unit.camp and caster.fancybuff17 == true then
    buff:setAttribute("HPR", buff.info.HPR * 2.5)
    buff.timer = buff.timer * 2.5
  end
end

function FieldNPC.Fancy20_feareffect(buff)
  local negative_effects = {fear = true}
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

function FieldNPC.fancybuff20_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local caster = buff.caster
  local owner = buff.owner
  if FieldNPC.Fancy20_feareffect(buff) and caster:isAlive() and caster.fancy20 == true then
    local bid1 = 6217
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.unremoveable = true
    caster:addBuff(buff1, caster)
  end
end

function FieldNPC.GuildMount_controleffect(buff)
  local negative_effects = {
    stun = true,
    frozen = true,
    icefrozen = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    doom = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    polymorph = true
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

function FieldNPC.GuildMountControl_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local caster = buff.caster
  local owner = buff.owner
  if FieldNPC.GuildMount_controleffect(buff) and caster and caster:isAlive() and owner.camp == unit.camp and caster.GuildMountControlcd and caster.GuildMountControlcd < 0 then
    buff.timer = buff.timer * 1.5
    owner:takeDamage(math.max(caster.attribs.AD, caster.attribs.AP) * (0.8 + unit.GMCdifficult / 28), "Holy", "hp", caster)
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanLoong_atk2.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
      end
    end
    caster.GuildMountControlcd = 0.5
  end
end

function FieldNPC.GuildMountShield_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local owner = buff.owner
  if buff.shield and buff.shield > 0 and owner.GMShield and owner.GMShield <= 40000 then
    owner.GMShield = owner.GMShield + buff.shield
    owner.GMShield = math.min(owner.GMShield, 40000)
  end
end

function FieldNPC.GuildMountHast_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local owner = buff.owner
  if (buff.info.HAST > 0 or 0 < buff.info.MSPD) and owner.GMHast == true and not buff.GMextra and owner.GuildMountHastinitad and owner.GuildMountHastinitap then
    local bid = 50020017
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff1 = ed.BuffCreate(binfo, owner, owner)
    buff1:setAttribute("HAST", buff.info.HAST * 0.2)
    buff1:setAttribute("MSPD", buff.info.MSPD * 0.2)
    buff1:setAttribute("AD", owner.GuildMountHastinitad * 0.125)
    buff1:setAttribute("AP", owner.GuildMountHastinitap * 0.125)
    buff1.GMextra = true
    owner:addBuff(buff1, owner)
    buff1.timer = math.min(buff.timer, 8)
  end
end

function FieldNPC.peakarena01_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  local buff = config.buff
  local caster = buff.caster
  if buff.shield and caster:isAlive() and caster.peakarena01 == true then
    buff.timer = buff.timer * 2
    buff.shield = buff.shield * 2
  end
end

function FieldNPC.chicken_collectBuff(basefunc, unit, config)
  basefunc(unit, config)
  if config.buff.shield then
    config.buff.shield = 0
  end
end

function FieldNPC.periodBoss_start(basefunc, skill, target)
  basefunc(skill, target)
  local field = skill.caster
  local BossMonk, RMonk, GMonk, BMonk
  local unit_counter = 1
  BossMonk = ed.engine:findBoss()
  BossMonk.onDying = override(BossMonk.onDying, FieldNPC.BossMonk_onDying)
  BossMonk.PeriodB_childcounter = 0
  BossMonk.PeriodB_childInvis_counter = 1
  local BossBinfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodGold_buffID)
  local BossBKBBuff = ed.BuffCreate(BossBinfo, BossMonk, field)
  BossMonk:addBuff(BossBKBBuff, field)
  for unitP in ed.engine:foreachAliveUnit(-1) do
    if unitP == BossMonk then
    elseif unit_counter == 1 then
      RMonk = unitP
      RMonk.onDying = override(RMonk.onDying, FieldNPC.Monks_onDying)
      local RMonkBinfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodR_buffID)
      RMonk:addBuff(RMonkBinfo, field)
      local InvisBuffInfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodInvis_buffID)
      local InvisBuff = ed.BuffCreate(InvisBuffInfo, RMonk, field)
      InvisBuff.onRemoved = override(InvisBuff.onRemoved, FieldNPC.InvisBuff_onRemoved)
      RMonk:addBuff(InvisBuff, field)
      unit_counter = unit_counter + 1
    elseif unit_counter == 2 then
      GMonk = unitP
      GMonk.onDying = override(GMonk.onDying, FieldNPC.Monks_onDying)
      local GMonkBinfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodG_buffID)
      GMonk:addBuff(GMonkBinfo, field)
      unit_counter = unit_counter + 1
    elseif unit_counter == 3 then
      BMonk = unitP
      BMonk.onDying = override(BMonk.onDying, FieldNPC.Monks_onDying)
      local BMonkBinfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodB_buffID)
      BMonk:addBuff(BMonkBinfo, field)
      unit_counter = nil
    end
  end
  if RMonk then
    BossMonk.periodBoss_RMonk = RMonk
    local RMonk2BossInfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodBossR_buffID)
    local RMonkBuff = ed.BuffCreate(RMonk2BossInfo, BossMonk, field)
    RMonkBuff:setAttribute("AD", 1000)
    local RMonkBuff = BossMonk:addBuff(RMonkBuff, field)
    RMonk.period_buff = RMonkBuff
    RMonk.period_fatherBoss = BossMonk
    RMonk.period_fatherBoss.PeriodB_childcounter = RMonk.period_fatherBoss.PeriodB_childcounter + 1
  end
  if GMonk then
    BossMonk.periodBoss_GMonk = GMonk
    local GMonk2BossInfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodBossG_buffID)
    local GMonkBuff = ed.BuffCreate(GMonk2BossInfo, BossMonk, field)
    GMonkBuff:setAttribute("HP", 1000000)
    local GMonkBuff = BossMonk:addBuff(GMonkBuff, field)
    BossMonk:setHP(BossMonk.attribs.HP)
    GMonk.period_buff = GMonkBuff
    GMonk.period_fatherBoss = BossMonk
    GMonk.period_fatherBoss.PeriodB_childcounter = GMonk.period_fatherBoss.PeriodB_childcounter + 1
  end
  if BMonk then
    BossMonk.periodBoss_BMonk = BMonk
    local BMonk2BossInfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodBossB_buffID)
    local BMonkBuff = ed.BuffCreate(BMonk2BossInfo, BossMonk, field)
    local BMonkBuff = BossMonk:addBuff(BMonkBuff, field)
    BMonk.period_fatherBoss = BossMonk
    BMonk.period_fatherBoss.PeriodB_childcounter = BMonk.period_fatherBoss.PeriodB_childcounter + 1
  end
end

function FieldNPC.InvisBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local bossMonk = ed.engine:findBoss()
  local owner = buff.owner
  local buffMonk
  if bossMonk.PeriodB_childcounter == 3 then
    if owner == bossMonk.periodBoss_RMonk then
      buffMonk = bossMonk.periodBoss_GMonk
    elseif owner == bossMonk.periodBoss_GMonk then
      buffMonk = bossMonk.periodBoss_BMonk
    elseif owner == bossMonk.periodBoss_BMonk then
      buffMonk = bossMonk.periodBoss_RMonk
    end
  elseif bossMonk.PeriodB_childcounter == 2 then
    if bossMonk.periodBoss_RMonk and not bossMonk.periodBoss_RMonk:isAlive() then
      if buff.owner == bossMonk.periodBoss_GMonk then
        buffMonk = bossMonk.periodBoss_BMonk
      else
        buffMonk = bossMonk.periodBoss_GMonk
      end
    elseif bossMonk.periodBoss_GMonk and not bossMonk.periodBoss_GMonk:isAlive() then
      if buff.owner == bossMonk.periodBoss_BMonk then
        buffMonk = bossMonk.periodBoss_RMonk
      else
        buffMonk = bossMonk.periodBoss_BMonk
      end
    elseif bossMonk.periodBoss_BMonk and not bossMonk.periodBoss_BMonk:isAlive() then
      if buff.owner == bossMonk.periodBoss_RMonk then
        buffMonk = bossMonk.periodBoss_GMonk
      else
        buffMonk = bossMonk.periodBoss_RMonk
      end
    end
  end
  owner.position[1] = 750
  if buffMonk then
    local InvisBuffInfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodInvis_buffID)
    local InvisBuff = ed.BuffCreate(InvisBuffInfo, buffMonk, buffMonk)
    buffMonk:addBuff(InvisBuff, buffMonk)
  end
end

function FieldNPC.weakBuff_onRemoved(basefunc, buff)
  local BossMonk = buff.owner
  if BossMonk.PeriodB_childcounter > 0 then
    local BossBinfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodGold_buffID)
    local BossBKBBuff = ed.BuffCreate(BossBinfo, BossMonk, BossMonk)
    BossMonk:addBuff(BossBKBBuff, BossMonk)
  else
    local BossDinfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodDarken_buffID)
    local BossDBuff = ed.BuffCreate(BossDinfo, BossMonk, BossMonk)
    BossMonk:addBuff(BossDBuff, BossMonk)
  end
  basefunc(buff)
end

function FieldNPC.Monks_onDying(basefunc, unit, skiller)
  local BossMonk = unit.period_fatherBoss
  if BossMonk and BossMonk:isAlive() then
    BossMonk.PeriodB_childcounter = BossMonk.PeriodB_childcounter - 1
    if BossMonk.PeriodB_childcounter == 1 then
      local invisMonk
      if BossMonk.periodBoss_RMonk and BossMonk.periodBoss_RMonk:isAlive() then
        invisMonk = BossMonk.periodBoss_RMonk
      elseif BossMonk.periodBoss_GMonk and BossMonk.periodBoss_GMonk:isAlive() then
        invisMonk = BossMonk.periodBoss_GMonk
      elseif BossMonk.periodBoss_BMonk and BossMonk.periodBoss_BMonk:isAlive() then
        invisMonk = BossMonk.periodBoss_BMonk
      end
      for i, invisBbuff in ipairs(invisMonk.buff_list) do
        if invisBbuff.info.ID == FieldNPC.PeriodInvis_buffID then
          invisBbuff.timer = 0
        end
      end
    end
  end
  for i, BKBbuff in ipairs(BossMonk.buff_list) do
    if BKBbuff.info.ID == FieldNPC.PeriodGold_buffID then
      BKBbuff.timer = 0
    end
    if unit == BossMonk.periodBoss_RMonk then
      if BKBbuff.info.ID == FieldNPC.PeriodBossR_buffID then
        BKBbuff.timer = 0
      end
    elseif unit == BossMonk.periodBoss_GMonk then
      if BKBbuff.info.ID == FieldNPC.PeriodBossG_buffID then
        BKBbuff.timer = 0
      end
    elseif unit == BossMonk.periodBoss_BMonk and BKBbuff.info.ID == FieldNPC.PeriodBossB_buffID then
      BKBbuff.timer = 0
    end
  end
  local buffWeakInfo = ed.lookupDataTable("Buff", nil, FieldNPC.PeriodWeak_buffID)
  local weakBuff = ed.BuffCreate(buffWeakInfo, BossMonk, BossMonk)
  weakBuff:setAttribute("ARM", BossMonk.attribs.ARM * -1)
  weakBuff:setAttribute("MR", BossMonk.attribs.MR * -1)
  weakBuff.onRemoved = override(weakBuff.onRemoved, FieldNPC.weakBuff_onRemoved)
  BossMonk:addBuff(weakBuff, BossMonk)
  basefunc(unit, skiller)
end

function FieldNPC.BossMonk_onDying(basefunc, unit, skiller)
  if unit.periodBoss_RMonk then
    unit.periodBoss_RMonk:die(unit)
  end
  if unit.periodBoss_GMonk then
    unit.periodBoss_GMonk:die(unit)
  end
  if unit.periodBoss_BMonk then
    unit.periodBoss_BMonk:die(unit)
  end
  basefunc(unit, skiller)
end

function FieldNPC.Broil_buff_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target then
    target.attribs.AD = buff.owner_origAD
    target.attribs.AP = buff.owner_origAP
  end
  buff.update = override(buff.update, FieldNPC.Broil_buff_update)
  buff.onRemoved = override(buff.onRemoved, FieldNPC.Broil_buff_onRemoved)
  buff.attack_timeTick = 0
  return buff
end

function FieldNPC.Broil_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local owner_origAD = buff.owner_origAD
  local owner_origAP = buff.owner_origAP
  if not buff.attack_timeTick then
    buff.attack_timeTick = 0
  end
  if not buff.attackUp_count then
    buff.attackUp_count = 0
  end
  buff.attack_timeTick = buff.attack_timeTick and buff.attack_timeTick + dt or dt
  if buff.attack_timeTick == 3 then
    buff.attack_timeTick = 0
    buff.attackUp_count = buff.attackUp_count + 1
    buff:setAttribute("AD", 300 * buff.attackUp_count)
    buff:setAttribute("AP", 300 * buff.attackUp_count)
  end
end

function FieldNPC.Broil_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.attack_timeTick = 0
  buff.attackUp_cont = 0
end

function FieldNPC.UnionHalf_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, FieldNPC.UnionHalf_onDamaged)
  return buff
end

function FieldNPC.UnionHalf_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  local selfUnion = owner:getUnitUnion()
  local sourceUnion = source:getUnitUnion()
  return damage * 0.5
end

function FieldNPC.UnionBookdmg_Dark_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, FieldNPC.UnionBookdmg_Dark_onDamaged)
  return buff
end

function FieldNPC.UnionBookdmg_Dark_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  local sourceUnion = source:getUnitUnion()
  if sourceUnion == "Dark" then
    return damage * 1.2
  else
    return damage
  end
end

function FieldNPC.FancyAbyssbuff5_collectHPchange(basefunc, field, config)
  if config.hp_change > 0 and config.unit.camp == -field.camp and config.unit:isHero() then
    field.healamount = field.healamount + config.hp_change
  end
end

function FieldNPC.FancyAbyssbuff5_hero_update(basefunc, field, dt)
  basefunc(field, dt)
  if field.healamount >= 60000 then
    field.healamount = field.healamount - 60000
    for unit in ed.engine:foreachAliveUnit(field.camp) do
      unit:takeDamage(unit.attribs.HP * 0.25, "Holy", "hp", field)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanLoong_atk2.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, unit.position, nil, nil, 1)
        end
      end
    end
  end
end

function FieldNPC.FancyAbyssbuff29_hero_update(basefunc, field, dt)
  basefunc(field, dt)
  if field.healamount29 >= 30000 then
    field.healamount29 = field.healamount29 - 30000
    local apsum = 0
    for unit in ed.engine:foreachAliveUnit(-field.camp) do
      if not unit.config.is_summoned then
        apsum = apsum + unit.attribs.AP
      end
    end
    for unit in ed.engine:foreachAliveUnit(field.camp) do
      unit:takeDamage(apsum * 0.5, "Holy", "hp", field)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanLoong_atk2.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, unit.position, nil, nil, 1)
        end
      end
    end
  end
end

function FieldNPC.FancyAbyssbuff29_collectHPchange(basefunc, field, config)
  if config.hp_change > 0 and config.unit.camp == -field.camp and not config.unit.config.is_summoned and config.reason ~= "LFS" then
    field.healamount29 = field.healamount29 + config.hp_change
  end
end

function FieldNPC.GuildMountHPR_collectHPchange(basefunc, field, config)
  if config.hp_change > 0 and config.unit.camp == -field.camp and config.unit:isHero() and config.unit.GuildMountHPR == true and config.reason == "heal" then
    for unit in ed.engine:foreachAliveUnit(field.camp) do
      unit:takeDamage(0.75 * config.hp_change, "Holy", "hp", config.unit)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanLoong_atk2.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, unit.position, nil, nil, 1)
        end
      end
    end
  end
end

function FieldNPC.GuildMountHeal_collectHPchange(basefunc, field, config)
  if config.hp_change > 0 and config.unit.camp == -field.camp and not config.unit.config.is_summoned and (config.unit.GuildMountHeal == true or config.unit.config.summoner and config.unit.config.summoner.GuildMountHeal == true) and config.reason == "heal" then
    for unit in ed.engine:foreachAliveUnit(field.camp) do
      unit:takeDamage(2 * config.hp_change, "Holy", "hp", config.unit)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanLoong_atk2.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, unit.position, nil, nil, 1)
        end
      end
    end
  end
end

function FieldNPC.FancyAbyssbuff8_hero_update(basefunc, field, dt)
  basefunc(field, dt)
  field.dt = field.dt and field.dt + dt or dt
  if field.dt == dt then
    for unit in ed.engine:foreachAliveUnit(field.foecamp) do
      unit.summoncurrentcount = 0
      unit.summonlastcount = 0
      unit.summoncountdif = 0
    end
  end
  for unit in ed.engine:foreachAliveUnit(field.foecamp) do
    if unit.config.is_summoned then
      field.fancyabyssbuff8currentcount = field.fancyabyssbuff8currentcount and field.fancyabyssbuff8currentcount + 1 or 1
      unit.config.summoner.summoncurrentcount = unit.config.summoner.summoncurrentcount and unit.config.summoner.summoncurrentcount + 1 or 1
    end
  end
  if field.fancyabyssbuff8count < field.fancyabyssbuff8currentcount or field.WLcount == 1 then
    for unit in ed.engine:foreachAliveUnit(field.foecamp) do
      if unit.config.is_summoned and unit.config.summoner and unit.config.summoner:isAlive() and unit.config.summoner.summoncurrentcount and unit.config.summoner.summonlastcount then
        unit.config.summoner.summoncountdif = unit.config.summoner.summoncurrentcount - unit.config.summoner.summonlastcount
        if unit.config.summoner.summoncountdif ~= 0 then
          local bid = 6168
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit.config.summoner, field)
          buff.unremoveable = true
          unit.config.summoner:addBuff(buff, field)
          unit.config.summoner:takeHeal(200, "mp", field)
          unit.config.summoner.summonlastcount = unit.config.summoner.summonlastcount + 1
        end
      end
    end
  end
  field.fancyabyssbuff8count = field.fancyabyssbuff8currentcount
  field.fancyabyssbuff8currentcount = 0
  for unit in ed.engine:foreachAliveUnit(field.foecamp) do
    if unit.config.is_summoned then
      unit.config.summoner.summoncurrentcount = 0
    end
  end
  field.WLcount = 0
end

function FieldNPC.FancyAbyssbuff8_handledieevent(field, unit, killer_unit, skill)
  if unit.camp == field.foecamp and unit.config.is_summoned and unit.config.summoner and unit.config.summoner:isAlive() then
    unit.config.summoner.summonlastcount = unit.config.summoner.summonlastcount - 1
    if unit.config.summoner.name == "WL" and not killer_unit then
      field.WLcount = 1
    end
  end
end

function FieldNPC.WorldLvBu_buff1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.WorldLvBu_buff1 = true
  return buff
end

function FieldNPC.WorldLvBu_buff2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.WorldLvBu_buff2 = true
  return buff
end

function FieldNPC.WorldLvBu_buff3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.WorldLvBu_buff3 = true
  return buff
end

function FieldNPC.WorldLvBu_buff4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.WorldLvBu_buff4 = true
  return buff
end

function FieldNPC.WorldLvBu_buff5_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.WorldLvBu_buff5 = true
  return buff
end

function FieldNPC.do_init_hero(hero)
  hero.setStageSkillId = FieldNPC.setStageSkillId
  hero.reset = override(hero.reset, FieldNPC.reset)
  hero.update = override(hero.update, FieldNPC.update)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, FieldNPC.handleUnitDieEvent)
  hero.collectSkill = override(hero.collectSkill, FieldNPC.collectSkill)
  hero.dragonSummonNum = 0
  hero.timeCount = 0
  hero.DKAlive = true
  hero.TreasuerAlive = true
  local halloween1 = hero.skills[FieldNPC.name .. "_" .. "halloween1"]
  if halloween1 then
    halloween1.createBuff = override(halloween1.createBuff, FieldNPC.halloween1_createBuff)
  end
  local halloween2 = hero.skills[FieldNPC.name .. "_" .. "halloween2"]
  if halloween2 then
    halloween2.createBuff = override(halloween2.createBuff, FieldNPC.halloween2_createBuff)
  end
  local PeakArena01 = hero.skills[FieldNPC.name .. "_" .. "PeakArena01"]
  if PeakArena01 then
    hero.collectBuff = override(hero.collectBuff, FieldNPC.peakarena01_collectBuff)
  end
  local HPRatioLow = hero.skills[FieldNPC.name .. "_" .. "HPRatioLow"]
  if HPRatioLow then
    HPRatioLow.createBuff = override(HPRatioLow.createBuff, FieldNPC.HPRatioLow_0_createBuff)
  end
  local buffDuration = hero.skills[FieldNPC.name .. "_" .. "buffDuration"]
  if buffDuration then
    buffDuration.createBuff = override(buffDuration.createBuff, FieldNPC.buffDuration_0_createBuff)
  end
  local elementStorm = hero.skills[FieldNPC.name .. "_" .. "elementStorm"]
  if elementStorm then
    elementStorm.createBuff = override(elementStorm.createBuff, FieldNPC.elementStorm_0_createBuff)
  end
  local Giantism = hero.skills[FieldNPC.name .. "_" .. "Giantism1"]
  if Giantism then
    Giantism.start = override(Giantism.start, FieldNPC.Giantism_0_start)
  end
  local breakfast = hero.skills[FieldNPC.name .. "_" .. "breakfast1"]
  if breakfast then
    breakfast.start = override(breakfast.start, FieldNPC.breakfast_0_start)
  end
  local RandomExchange = hero.skills[FieldNPC.name .. "_" .. "RandomExchange1"]
  if RandomExchange then
    RandomExchange.start = override(RandomExchange.start, FieldNPC.exchange_start)
  end
  local speAttack = hero.skills[FieldNPC.name .. "_" .. "speAttack"]
  if speAttack then
    speAttack.start = override(speAttack.start, FieldNPC.speAttack_0_start)
    speAttack.takeEffectOn = override(speAttack.takeEffectOn, FieldNPC.speAttack_0_takeEffectOn)
  end
  local mpTransformHp = hero.skills[FieldNPC.name .. "_" .. "mpTransformHp"]
  if mpTransformHp then
    mpTransformHp.createBuff = override(mpTransformHp.createBuff, FieldNPC.mpTransformHp_0_createBuff)
  end
  local attackStunHero = hero.skills[FieldNPC.name .. "_" .. "attackStunHero"]
  if attackStunHero then
    attackStunHero.createBuff = override(attackStunHero.createBuff, FieldNPC.attackStunHero_0_createBuff)
  end
  local crazyUltimate = hero.skills[FieldNPC.name .. "_" .. "crazyUltimate"]
  if crazyUltimate then
    crazyUltimate.createBuff = override(crazyUltimate.createBuff, FieldNPC.crazyUltimate_0_createBuff)
  end
  local crazyUltimate5 = hero.skills[FieldNPC.name .. "_" .. "crazyUltimate5"]
  if crazyUltimate5 then
    crazyUltimate5.createBuff = override(crazyUltimate5.createBuff, FieldNPC.crazyUltimate5_0_createBuff)
  end
  local edgeKill = hero.skills[FieldNPC.name .. "_" .. "edgeKill"]
  if edgeKill then
    edgeKill.canCastWithTarget = override(edgeKill.canCastWithTarget, FieldNPC.edgeKill_0_canCastWithTarget)
    edgeKill.takeEffectOn = override(edgeKill.takeEffectOn, FieldNPC.edgeKill_0_takeEffectOn)
    edgeKill.createProjectile = override(edgeKill.createProjectile, FieldNPC.edgeKill_0_createProjectile)
  end
  local fireworks = hero.skills[FieldNPC.name .. "_" .. "fireworks"]
  local fireworksP = hero.skills[FieldNPC.name .. "_" .. "fireworksP"]
  local fireworksE = hero.skills[FieldNPC.name .. "_" .. "fireworksE"]
  if fireworks and fireworksP and fireworksE then
    fireworksP.takeEffectOn = override(fireworksP.takeEffectOn, FieldNPC.fireworks_pe_takeEffectOn)
    fireworksP.createBuff = override(fireworksP.createBuff, FieldNPC.fireworks_pe_createBuff)
    fireworksE.takeEffectOn = override(fireworksE.takeEffectOn, FieldNPC.fireworks_pe_takeEffectOn)
    fireworksE.createBuff = override(fireworksE.createBuff, FieldNPC.fireworks_pe_createBuff)
  end
  local maleLostHp = hero.skills[FieldNPC.name .. "_" .. "maleLostHp"]
  if maleLostHp then
    maleLostHp.createBuff = override(maleLostHp.createBuff, FieldNPC.maleLostHp_createBuff)
  end
  local LostHp = hero.skills[FieldNPC.name .. "_" .. "LostHp"]
  if LostHp then
    LostHp.createBuff = override(LostHp.createBuff, FieldNPC.LostHp_createBuff)
  end
  local chicken = hero.skills[FieldNPC.name .. "_" .. "chicken"]
  local chicken_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if chicken and (chicken_stageId == 90440 or chicken_stageId == 90441 or chicken_stageId == 90442) then
    chicken.createBuff = override(chicken.createBuff, FieldNPC.chicken_createBuff)
    hero.collectHPchange = override(hero.collectHPchange, FieldNPC.chicken_collectHPchange)
    hero.collectBuff = override(hero.collectBuff, FieldNPC.chicken_collectBuff)
  end
  local FancyAbyssbuff5 = hero.skills[FieldNPC.name .. "_" .. "FancyAbyssbuff5"]
  local fancy5_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if FancyAbyssbuff5 and 12106000 < fancy5_stageId and fancy5_stageId < 12107000 then
    hero.update = override(hero.update, FieldNPC.FancyAbyssbuff5_hero_update)
    hero.collectHPchange = override(hero.collectHPchange, FieldNPC.FancyAbyssbuff5_collectHPchange)
  end
  local FancyAbyssbuff29 = hero.skills[FieldNPC.name .. "_" .. "FancyAbyssbuff29"]
  local fancy29_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if FancyAbyssbuff29 and 12130000 < fancy29_stageId and fancy29_stageId < 12131000 then
    hero.update = override(hero.update, FieldNPC.FancyAbyssbuff29_hero_update)
    hero.collectHPchange = override(hero.collectHPchange, FieldNPC.FancyAbyssbuff29_collectHPchange)
  end
  local GuildMountHPR = hero.skills[FieldNPC.name .. "_" .. "GuildMountHPR"]
  local GuildMountHPR_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if GuildMountHPR and 50100 < GuildMountHPR_stageId and GuildMountHPR_stageId < 60000 then
    hero.collectHPchange = override(hero.collectHPchange, FieldNPC.GuildMountHPR_collectHPchange)
  end
  local GuildMountShield = hero.skills[FieldNPC.name .. "_" .. "GuildMountShield"]
  local GuildMountShield_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if GuildMountShield and 50100 < GuildMountShield_stageId and GuildMountShield_stageId < 60000 then
    hero.collectBuff = override(hero.collectBuff, FieldNPC.GuildMountShield_collectBuff)
  end
  local GuildMountHast = hero.skills[FieldNPC.name .. "_" .. "GuildMountHast"]
  local GuildMountHast_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if GuildMountHast and 50100 < GuildMountHast_stageId and GuildMountHast_stageId < 60000 then
    hero.collectBuff = override(hero.collectBuff, FieldNPC.GuildMountHast_collectBuff)
  end
  local GuildMountHeal = hero.skills[FieldNPC.name .. "_" .. "GuildMountHeal"]
  local GuildMountHeal_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if GuildMountHeal and 50100 < GuildMountHeal_stageId and GuildMountHeal_stageId < 60000 then
    hero.collectHPchange = override(hero.collectHPchange, FieldNPC.GuildMountHeal_collectHPchange)
  end
  local FancyAbyssbuff13 = hero.skills[FieldNPC.name .. "_" .. "FancyAbyssbuff13"]
  local fancy5_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if FancyAbyssbuff5 and 12114000 < fancy5_stageId and fancy5_stageId < 12115000 then
    hero.collectBuff = override(hero.collectBuff, FieldNPC.fancybuff13_collectBuff)
  end
  local FancyAbyssbuff17 = hero.skills[FieldNPC.name .. "_" .. "FancyAbyssbuff17"]
  local fancy17_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if FancyAbyssbuff17 and 12118000 < fancy17_stageId and fancy17_stageId < 12119000 then
    hero.collectBuff = override(hero.collectBuff, FieldNPC.fancybuff17_collectBuff)
  end
  local FancyAbyssbuff20 = hero.skills[FieldNPC.name .. "_" .. "FancyAbyssbuff20"]
  local fancy20_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if FancyAbyssbuff20 and 12121000 < fancy20_stageId and fancy20_stageId < 12122000 then
    hero.collectBuff = override(hero.collectBuff, FieldNPC.fancybuff20_collectBuff)
  end
  local GuildMountControl = hero.skills[FieldNPC.name .. "_" .. "GuildMountControl"]
  local GuildMountControl_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if GuildMountControl and 50100 < GuildMountControl_stageId and GuildMountControl_stageId < 60000 then
    hero.collectBuff = override(hero.collectBuff, FieldNPC.GuildMountControl_collectBuff)
  end
  local periodBoss = hero.skills[FieldNPC.name .. "_PeriodBoss"]
  local periodBoss_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if periodBoss and periodBoss_stageId == 90480 then
    periodBoss.start = override(periodBoss.start, FieldNPC.periodBoss_start)
  end
  local Broil_buff = hero.skills[FieldNPC.name .. "_" .. "Broil"]
  if Broil_buff then
    Broil_buff.createBuff = override(Broil_buff.createBuff, FieldNPC.Broil_buff_createBuff)
  end
  local UnionHalf = hero.skills[FieldNPC.name .. "_" .. "UnionHalf"]
  if UnionHalf then
    UnionHalf.createBuff = override(UnionHalf.createBuff, FieldNPC.UnionHalf_createBuff)
  end
  local UnionBookdmg_Dark = hero.skills[FieldNPC.name .. "_" .. "UnionBookdmg_Dark"]
  if UnionBookdmg_Dark then
    UnionBookdmg_Dark.createBuff = override(UnionBookdmg_Dark.createBuff, FieldNPC.UnionBookdmg_Dark_createBuff)
  end
  local WorldLvBu_buff1 = hero.skills.FieldNPC_WorldLvBu_buff1
  if WorldLvBu_buff1 then
    WorldLvBu_buff1.createBuff = override(WorldLvBu_buff1.createBuff, FieldNPC.WorldLvBu_buff1_createBuff)
  end
  local WorldLvBu_buff2 = hero.skills.FieldNPC_WorldLvBu_buff2
  if WorldLvBu_buff2 then
    WorldLvBu_buff2.createBuff = override(WorldLvBu_buff2.createBuff, FieldNPC.WorldLvBu_buff2_createBuff)
  end
  local WorldLvBu_buff3 = hero.skills.FieldNPC_WorldLvBu_buff3
  if WorldLvBu_buff3 then
    WorldLvBu_buff3.createBuff = override(WorldLvBu_buff3.createBuff, FieldNPC.WorldLvBu_buff3_createBuff)
  end
  local WorldLvBu_buff4 = hero.skills.FieldNPC_WorldLvBu_buff4
  if WorldLvBu_buff4 then
    WorldLvBu_buff4.createBuff = override(WorldLvBu_buff4.createBuff, FieldNPC.WorldLvBu_buff4_createBuff)
  end
  local WorldLvBu_buff5 = hero.skills.FieldNPC_WorldLvBu_buff5
  if WorldLvBu_buff5 then
    WorldLvBu_buff5.createBuff = override(WorldLvBu_buff5.createBuff, FieldNPC.WorldLvBu_buff5_createBuff)
  end
  return hero
end

function FieldNPC.init_hero(hero)
  return FieldNPC.do_init_hero(hero)
end

return FieldNPC.init_hero
