module("ed.battlehero", package.seeall)
local ed = ed
TitanSSA = {}
TitanSSA.TitanSSA_atk2_moving_timer = 4205
TitanSSA.TitanSSA_atk2_enemy_stun_buffID = 4206
TitanSSA.TitanSSA_atk2_self_DODG_buffID = 4207
TitanSSA.TitanSSA_move_stun_buffID = 4208
TitanSSA.TitanSSA_Sword_enemy_1_buffID = 4209
TitanSSA.TitanSSA_Sword_enemy_2_buffID = 4210
TitanSSA.TitanSSA_Sword_enemy_3_buffID = 4211
TitanSSA.TitanSSA_atk2_Dash_buffID = 4212
TitanSSA.TitanSSA_atk2_Dash_enemy_buffID = 4213
TitanSSA.TitanSSA_selfSword_buffID = 4214
TitanSSA.TitanSSA_enemySword_buffID = 4215
TitanSSA.TitanSSA_throw_counter_buffID = 4216
TitanSSA.TitanSSA_period = {
  "TitanSSA0.cha",
  "TitanSSA1.cha",
  "TitanSSA2.cha",
  "TitanSSA3.cha",
  "TitanSSA.cha"
}
TitanSSA.TitanSSA_Skin_period = {
  "TitanSSA_skin0.cha",
  "TitanSSA_skin1.cha",
  "TitanSSA_skin2.cha",
  "TitanSSA_skin3.cha",
  "TitanSSA_skin.cha"
}
TitanSSA.TitanSSA_arcana3_buff = 4642
TitanSSA.TitanSSA_atk3_knock_time = 0.75
TitanSSA.TitanSSA_fashion_id = 100881

function TitanSSA.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanSSA_self_swordCounter = 4
  local Pbinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_selfSword_buffID)
  local SwordBuff = ed.BuffCreate(Pbinfo, hero, hero)
  TitanSSA.ChangeSwordBuff(SwordBuff, hero, 0)
  hero:addBuff(SwordBuff, hero)
end

function TitanSSA.ChangeSwordBuff(buff, hero, counter)
  local skillatk4 = hero.skills.TitanSSA_atk4
  hero.TitanSSA_self_swordCounter = hero.TitanSSA_self_swordCounter + counter
  if #hero.puppet_stack >= 1 then
    if TitanSSA.TitanSSA_fashion_id and TitanSSA.TitanSSA_fashion_id == hero.fashion_id then
      hero:rewritePuppetStack(1, TitanSSA.TitanSSA_Skin_period[math.max(0, math.min(hero.TitanSSA_self_swordCounter + 1, 5))])
    else
      hero:rewritePuppetStack(1, TitanSSA.TitanSSA_period[math.max(0, math.min(hero.TitanSSA_self_swordCounter + 1, 5))])
    end
    if hero.actor then
      hero.actor:usePuppet()
    end
  end
  buff:setAttribute("AD", skillatk4.info["Script Arg2"] * (4 - hero.TitanSSA_self_swordCounter) * hero.attribs.AD)
  buff:setAttribute("HAST", (4 - hero.TitanSSA_self_swordCounter) * 30)
  if hero.TitanSSA_hasArcana and 1 < hero.TitanSSA_hasArcana then
    buff:setAttribute("ARM", 2.5 * skillatk4.info["Script Arg3"] * (4 - hero.TitanSSA_self_swordCounter) * hero.attribs.ARM)
    buff:setAttribute("MR", 2.5 * skillatk4.info["Script Arg3"] * (4 - hero.TitanSSA_self_swordCounter) * hero.attribs.MR)
  else
    buff:setAttribute("ARM", skillatk4.info["Script Arg3"] * (4 - hero.TitanSSA_self_swordCounter) * hero.attribs.ARM)
    buff:setAttribute("MR", skillatk4.info["Script Arg3"] * (4 - hero.TitanSSA_self_swordCounter) * hero.attribs.MR)
  end
  hero:rebuild()
end

function TitanSSA.addEnemySwordBuff(caster, unit)
  local sword_rank = 0
  local skillatk3 = caster.skills.TitanSSA_atk3
  for i, bbuff in ipairs(unit.buff_list) do
    if bbuff.info.ID == TitanSSA.TitanSSA_Sword_enemy_1_buffID and sword_rank == 0 then
      sword_rank = 1
    end
    if bbuff.info.ID == TitanSSA.TitanSSA_Sword_enemy_2_buffID and sword_rank < 2 then
      sword_rank = 2
    end
    if bbuff.info.ID == TitanSSA.TitanSSA_Sword_enemy_3_buffID and sword_rank < 3 then
      sword_rank = 3
    end
  end
  if sword_rank < 3 then
    local binfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_Sword_enemy_1_buffID + sword_rank)
    local SwordBuff = ed.BuffCreate(binfo, unit, unit)
    if skillatk3 then
      SwordBuff:setAttribute("DODG", skillatk3.info["Script Arg3"] * -1)
    end
    local enemypos = math.abs(unit.position[1] - caster.position[1]) / (unit.position[1] - caster.position[1])
    local buffresult = unit:addBuff(SwordBuff, unit)
    if ed.run_with_scene and enemypos ~= unit.direction then
      local effect = unit.actor:getEffectById(buffresult.effect_id)
      local scaleX = effect:getScaleX()
      effect:setScaleX(-scaleX)
    end
  end
  return sword_rank + 1
end

function TitanSSA.EnemySwordBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local damageAfter = owner.battledata:getDamage()
  local caster = buff.caster
  local skillatk3s = caster.skills.TitanSSA_atk3s
  local skillatk3 = caster.skills.TitanSSA_atk3
  local damageGap = damageAfter - buff.TitanSSA_enemyDamage_before
  if owner.attribs.ARM > 0 then
    if 10000 < damageGap then
      local temp, b = math.modf(damageGap / 10000)
      local sword_rank = 0
      if owner.TitanSSA_enemy_sword_rank then
        sword_rank = owner.TitanSSA_enemy_sword_rank
      end
      if TitanSSA.TitanSSA_fashion_id and TitanSSA.TitanSSA_fashion_id == caster.fashion_id then
        buff:setAttribute("ARM", buff.info.ARM + temp * -1 * skillatk3.info["Script Arg2"] * caster.attribs.AD * sword_rank * 2)
        buff:setAttribute("MR", buff.info.MR + temp * -1 * skillatk3.info["Script Arg2"] * caster.attribs.AD * sword_rank * 2)
        buff.TitanSSA_enemyDamage_before = buff.TitanSSA_enemyDamage_before + 10000 * temp
      else
        buff:setAttribute("ARM", buff.info.ARM + temp * -1 * skillatk3.info["Script Arg2"] * caster.attribs.AD * sword_rank)
        buff:setAttribute("MR", buff.info.MR + temp * -1 * skillatk3.info["Script Arg2"] * caster.attribs.AD * sword_rank)
        buff.TitanSSA_enemyDamage_before = buff.TitanSSA_enemyDamage_before + 10000 * temp
      end
      owner:rebuild()
    end
  elseif owner.TitanSSA_enemy_sword_rank and 0 < owner.TitanSSA_enemy_sword_rank and not caster.TitanSSA_throwing then
    caster.TitanSSA_throwing = true
    if caster.current_skill and caster.current_skill ~= caster.manual_skill then
      caster.current_skill:interrupt()
      caster:castSkill(skillatk3s, owner)
    elseif caster.current_skill and caster.current_skill == caster.manual_skill then
    else
      caster:castSkill(skillatk3s, owner)
    end
  end
end

function TitanSSA.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanSSA.TitanSSA_selfSword_buffID then
      TitanSSA.ChangeSwordBuff(buff, caster, -1)
    end
  end
  basefunc(skill, target)
end

function TitanSSA.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local sword_rank = 0
  if target and target:isAlive() then
    sword_rank = TitanSSA.addEnemySwordBuff(caster, target)
  end
  target.TitanSSA_enemy_sword_rank = sword_rank
  target.TitanSSA_sword_caster = skill.caster
  target.onDying = override(target.onDying, TitanSSA.swordTarget_onDying)
  local EnemySwordParaBuff
  local hasBuff = false
  for i, bbuff in ipairs(target.buff_list) do
    if bbuff.info.ID == TitanSSA.TitanSSA_enemySword_buffID then
      EnemySwordParaBuff = bbuff
      hasBuff = true
    end
  end
  if hasBuff == false then
    local ebinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_enemySword_buffID)
    local ESwordBuff = ed.BuffCreate(ebinfo, target, skill.caster)
    ESwordBuff.TitanSSA_enemyDamage_before = target.battledata:getDamage()
    ESwordBuff.update = override(ESwordBuff.update, TitanSSA.EnemySwordBuff_update)
    local buffresult = target:addBuff(ESwordBuff, caster)
    EnemySwordParaBuff = buffresult
  end
  if TitanSSA.TitanSSA_fashion_id and TitanSSA.TitanSSA_fashion_id == caster.fashion_id then
    local targetunit
    local maxarm = 0
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if maxarm < unit.attribs.ARM and not unit.config.is_summoned and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
        maxarm = unit.attribs.ARM
        targetunit = unit
      end
    end
    if targetunit then
      local bid = 4652
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, targetunit, caster)
      local skinshieldbuff = targetunit:addBuff(buff, caster)
    end
  end
  return out, dmg, Crit, lfs_amount
end

function TitanSSA.skillatk3_selectTarget(basefunc, skill, default)
  local target = basefunc(skill, default)
  local maxad = 0
  local outtarget
  local choose = true
  if target and target:isAlive() then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == TitanSSA.TitanSSA_throw_counter_buffID then
        choose = false
      end
    end
  end
  if target and target.TitanSSA_enemy_sword_rank and target.TitanSSA_enemy_sword_rank >= 3 or choose == false then
    for unit in ed.engine:foreachAliveUnit(target.camp) do
      local choose = true
      if unit and unit:isAlive() then
        for i, buff in ipairs(unit.buff_list) do
          if buff.info.ID == TitanSSA.TitanSSA_throw_counter_buffID then
            choose = false
          end
        end
      end
      if unit ~= target and maxad < unit.attribs.AD or choose == false then
        outtarget = unit
        maxad = unit.attribs.AD
      end
    end
  end
  if outtarget then
    target = outtarget
    skill.target = target
  end
  return target
end

function TitanSSA.skillatk3_canCastWithTarget(basefunc, skill, target)
  local out = basefunc(skill, target)
  local caster = skill.caster
  if caster.TitanSSA_self_swordCounter <= 0 then
    out = false
  end
  local enemycounter = 0
  local outunit
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    outunit = unit
    enemycounter = enemycounter + 1
  end
  if not outunit or outunit.TitanSSA_enemy_sword_rank then
  end
  if enemycounter < 2 and outunit and outunit.TitanSSA_enemy_sword_rank and outunit.TitanSSA_enemy_sword_rank >= 3 then
    out = false
  end
  return out
end

function TitanSSA.skillatk3_createProjectile(basefunc, skill, target)
  local projectile = basefunc(skill, target)
  if skill.target then
    target = skill.target
    projectile.position, projectile.height = skill:launchPoint()
    local d = {
      target.position[1] - projectile.position[1],
      target.position[2] - projectile.position[2]
    }
    projectile.zSpeed = (target.position[2] - projectile.height + 50) / math.abs((target.position[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
    projectile.max_distance = math.abs(projectile.position[1] - target.position[1])
    projectile.hit = override(projectile.hit, TitanSSA.skillatk3_tilehit)
    ed.engine:addProjectile(projectile)
    return nil
  end
  projectile.hit = override(projectile.hit, TitanSSA.skillatk3_tilehit)
  return projectile
end

function TitanSSA.skillatk3_tilehit(basefunc, tile, target)
  local skill = tile.skill
  if target ~= skill.target then
    return
  else
    if tile.actor and tile.actor.node then
      tile.actor.node:setVisible(false)
    end
    basefunc(tile, target)
    tile:terminate()
  end
end

function TitanSSA.swordTarget_onDying(basefunc, unit, skiller)
  local caster = unit.TitanSSA_sword_caster
  if unit.TitanSSA_enemy_sword_rank and unit.TitanSSA_enemy_sword_rank > 0 then
    for i, ubuff in ipairs(unit.buff_list) do
      if ubuff.info.ID >= TitanSSA.TitanSSA_Sword_enemy_1_buffID and ubuff.info.ID < TitanSSA.TitanSSA_Sword_enemy_1_buffID + 3 or ubuff.info.ID == TitanSSA.TitanSSA_enemySword_buffID then
        ubuff.timer = 0
      end
    end
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == TitanSSA.TitanSSA_selfSword_buffID then
        TitanSSA.ChangeSwordBuff(buff, caster, unit.TitanSSA_enemy_sword_rank)
      end
    end
    unit.TitanSSA_enemy_sword_rank = nil
  end
  basefunc(unit, skiller)
end

function TitanSSA.skillatk3s_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local target = skill.target
  if target and target:isAlive() then
    if idx == 1 then
      caster.TitanSSA_atk3s_oriposition = {}
      caster.TitanSSA_atk3s_oriposition[1] = caster.position[1]
      caster.TitanSSA_atk3s_oriposition[2] = caster.position[2]
    elseif idx == 2 and target and target:isAlive() then
      local dir = math.abs(caster.position[1] - target.position[1]) / (caster.position[1] - target.position[1])
      if dir ~= 1 and dir ~= -1 and dir ~= 0 then
        dir = target.direction
      end
      caster.position[1] = target.position[1] + dir * 80 * -1
    elseif idx == 3 then
      caster.position[1] = caster.TitanSSA_atk3s_oriposition[1]
      caster.position[2] = caster.TitanSSA_atk3s_oriposition[2]
    end
  end
  basefunc(skill, idx)
end

function TitanSSA.skillatk3s_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 3 then
    return false
  else
    local out, dmg, crit, lfs_amount = basefunc(skill, target, source, shift)
    local caster = skill.caster
    TitanSSA.throwEnemy(caster, target)
    local binfo = ed.lookupDataTable("Buff", nil, 6)
    target:addBuff(binfo, caster)
    local cbinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_throw_counter_buffID)
    local cbuff = ed.BuffCreate(cbinfo, target, caster)
    cbuff.onRemoved = override(cbuff.onRemoved, TitanSSA.skillatk3s_swordRemoveBuff_onRemoved)
    target:addBuff(cbuff, caster)
    return out, dmg, crit, lfs_amount
  end
end

function TitanSSA.skillatk3s_swordRemoveBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if owner.TitanSSA_enemy_sword_rank then
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == TitanSSA.TitanSSA_selfSword_buffID then
        TitanSSA.ChangeSwordBuff(buff, caster, owner.TitanSSA_enemy_sword_rank)
      end
    end
    owner.TitanSSA_enemy_sword_rank = nil
  end
  for i, bbuff in ipairs(owner.buff_list) do
    if bbuff.info.ID == TitanSSA.TitanSSA_Sword_enemy_1_buffID or bbuff.info.ID == TitanSSA.TitanSSA_Sword_enemy_2_buffID or bbuff.info.ID == TitanSSA.TitanSSA_Sword_enemy_3_buffID then
      bbuff.timer = 0
    end
    if bbuff.info.ID == TitanSSA.TitanSSA_enemySword_buffID then
      bbuff:setAttribute("ARM", 0)
      bbuff:setAttribute("MR", 0)
    end
  end
  if caster.TitanSSA_throwing == true then
    caster.TitanSSA_throwing = nil
  end
end

function TitanSSA.throwEnemy(caster, target)
  local maxarm = 0
  local targetunit
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if maxarm < unit.attribs.ARM and not unit.config.is_summoned and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
      maxarm = unit.attribs.ARM
      targetunit = unit
    end
  end
  local time = TitanSSA.TitanSSA_atk3_knock_time
  local distance = 100
  local direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(caster.position, target.position)))
  if targetunit then
    if targetunit.position[1] - target.position[1] == 0 then
      direction = {
        -caster.direction,
        0
      }
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(targetunit.position, target.position)))
    end
    distance = math.min(math.abs(target.position[1] - 400 - direction[1] * 400) - 50, math.max(100, math.abs(targetunit.position[1] - target.position[1])))
  end
  local mbinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_move_stun_buffID)
  target:addBuff(mbinfo, caster)
  target:knockup(time, ed.edpMult(direction, distance))
end

function TitanSSA.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local mbinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_atk2_self_DODG_buffID)
  local mbuff = ed.BuffCreate(mbinfo, caster, caster)
  caster:addBuff(mbuff, caster)
end

function TitanSSA.skillatk2_finish(basefunc, skill, reason)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanSSA.TitanSSA_atk2_self_DODG_buffID then
      buff.timer = 3
    end
  end
  basefunc(skill, reason)
end

function TitanSSA.skillatk2_canCastWithTarget(basefunc, skill, target)
  local out = basefunc(skill, target)
  local enemycounter = 0
  for unit in ed.engine:foreachAliveUnit(target.camp) do
    if unit and unit:isAlive() then
      enemycounter = enemycounter + 1
    end
  end
  if 1 < enemycounter and 0 > skill.cd_remaining then
    out = true
  end
  return out
end

function TitanSSA.skillatk2_selectTarget(basefunc, skill, default)
  local target = basefunc(skill, default)
  local caster = skill.caster
  local maxpos = 0
  local maxunit
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    local pos = math.abs(unit.position[1] - caster.position[1])
    if not unit.config.is_summoned and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX and maxpos < pos then
      maxpos = pos
      maxunit = unit
    end
  end
  target = maxunit
  skill.target = target
  return target
end

function TitanSSA.skillatk2_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local target = skill.target
  if not target then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if not target then
        target = unit
      elseif unit.attribs.ARM < target.attribs.ARM then
        target = unit
      end
    end
    skill.target = target
  end
  if not target then
    skill:interrupt()
    skill.cd_remaining = skill.info.CD * 0.25
    return
  end
  if idx == 2 then
    local dir = math.abs(caster.position[1] - target.position[1]) / (caster.position[1] - target.position[1])
    if dir ~= 1 and dir ~= -1 and dir ~= 0 then
      dir = target.direction
    end
    caster.position[1] = target.position[1] - dir * 80
    caster.position[2] = target.position[2] - 1
  elseif idx == 3 then
    basefunc(skill, idx)
    local mindis = 800
    local targetALLYunit
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if mindis > unit.basic_skill.info["Max Range"] and not unit.config.is_summoned and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
        mindis = unit.basic_skill.info["Max Range"]
        targetALLYunit = unit
      end
    end
    local dirCT = 0
    local dirAT = 0
    local knockDistance = 0
    dirCT = math.abs(caster.position[1] - target.position[1]) / (caster.position[1] - target.position[1])
    if targetALLYunit then
      dirAT = math.abs(targetALLYunit.position[1] - target.position[1]) / (targetALLYunit.position[1] - target.position[1])
      knockDistance = math.max(0, math.abs(targetALLYunit.position[1] - target.position[1]) - 10)
    end
    if knockDistance < 50 or dirCT == dirAT then
      local phase = skill.phase_list[idx]
      skill.current_phase_idx = idx
      skill.current_phase = phase
      skill.current_phase_elapsed = 0
      skill.next_event_idx = 1
      skill.next_event = phase.event_list[1]
      skill:onPhaseFinished()
      return
    end
    local direction = {
      caster.direction,
      0
    }
    if targetALLYunit.position[1] - target.position[1] ~= 0 then
      direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(targetALLYunit.position, target.position)))
    end
    local ebinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_atk2_enemy_stun_buffID)
    local ebuff = ed.BuffCreate(ebinfo, target, caster)
    target:addBuff(ebuff, caster)
    target:knockup(0.5, ed.edpMult(direction, knockDistance), true)
    caster.manual_moving = true
    local mbinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_atk2_moving_timer)
    local mbuff = ed.BuffCreate(mbinfo, caster, caster)
    mbuff.onRemoved = override(mbuff.onRemoved, TitanSSA.skillatk2_movingBuff_onRemoved)
    caster:addBuff(mbuff, caster)
    caster.walk_v = {
      knockDistance / 0.5 * direction[1],
      0
    }
    return
  end
  basefunc(skill, idx)
end

function TitanSSA.skillatk2_movingBuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk2 = caster.skills.TitanSSA_atk2
  caster.walk_v = {0, 0}
  caster.manual_moving = false
  basefunc(buff)
  if skillatk2 and skillatk2.casting and skillatk2.current_phase_idx == 3 then
    skillatk2:onPhaseFinished()
  end
end

function TitanSSA.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 3 then
    return false
  elseif skill.current_phase_idx == 4 then
    if target then
      local direction = {
        skill.caster.direction,
        0
      }
      if skill.caster.position[1] - target.position[1] ~= 0 then
        direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(skill.caster.position, target.position)))
      end
      target:knockup(0.125, ed.edpMult(direction, 20))
      if caster.TitanSSA_hasArcana and caster.TitanSSA_hasArcana > 2 then
        local tbinfo = ed.lookupDataTable("Buff", nil, TitanSSA.TitanSSA_arcana3_buff)
        local tbuff = ed.BuffCreate(tbinfo, target, caster)
        target:addBuff(tbuff, caster)
      end
    end
    return basefunc(skill, target, source, shift)
  else
    return basefunc(skill, target, source, shift)
  end
end

function TitanSSA.skillult_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local target = skill.target
  if not target then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if not target then
        target = unit
      elseif unit.attribs.ARM < target.attribs.ARM then
        target = unit
      end
    end
    skill.target = target
  end
  if idx == 2 then
    caster.TitanSSA_ult_oriposition = {}
    caster.TitanSSA_ult_oriposition[1] = caster.position[1]
    caster.TitanSSA_ult_oriposition[2] = caster.position[2]
    local dir = caster.direction
    if target then
      local dir = math.abs(caster.position[1] - target.position[1]) / (caster.position[1] - target.position[1])
    end
    if dir ~= 1 and dir ~= -1 and dir ~= 0 then
      dir = target.direction
    end
    if target and target:isAlive() then
      caster.position = {
        target.position[1] + dir,
        target.position[2] - 1
      }
    else
      skill:interrupt()
      skill.cd_remaining = skill.info.CD * 0.25
    end
  elseif idx == 3 then
    local maxarm = 0
    local targetunit
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if maxarm < unit.attribs.ARM then
        maxarm = unit.attribs.ARM
        targetunit = unit
      end
    end
    if targetunit and targetunit ~= caster then
      caster.position[1] = math.min(math.max(30, targetunit.position[1] - targetunit.direction * 180), 770)
      caster.direction = targetunit.direction
    else
      caster.position[1] = caster.TitanSSA_ult_oriposition[1]
      caster.position[2] = caster.TitanSSA_ult_oriposition[2]
    end
  end
  basefunc(skill, idx)
end

function TitanSSA.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 3 then
    return false
  else
    if caster.TitanSSA_hasArcana and 3 < caster.TitanSSA_hasArcana and target and not target.TitanSSA_arcana4Buff then
      local bid1 = 4643
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = ed.BuffCreate(binfo1, target, caster)
      local arcana4_ARM = math.min(caster.attribs.ARM, math.abs(0.3 * target.attribs.ARM))
      local arcana4_MR = math.min(caster.attribs.MR, math.abs(0.3 * target.attribs.MR))
      buff1:setAttribute("ARM", -arcana4_ARM)
      buff1:setAttribute("MR", -arcana4_MR)
      target.TitanSSA_arcana4Buff = target:addBuff(buff1, caster)
      caster.arcana4_ARM = caster.arcana4_ARM + arcana4_ARM
      caster.arcana4_MR = caster.arcana4_MR + arcana4_MR
      local bid2 = 4644
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, caster, caster)
      buff2:setAttribute("ARM", math.abs(caster.arcana4_ARM))
      buff2:setAttribute("MR", math.abs(caster.arcana4_MR))
      caster:addBuff(buff2, caster)
    end
    return basefunc(skill, target, source, shift)
  end
end

function TitanSSA.skills_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  power = power * 1
  return power, coeff
end

function TitanSSA.hero_onDying(basefunc, unit, skiller)
  for unit in ed.engine:foreachAliveUnit(unit.foecamp) do
    for i, buff in ipairs(unit.buff_list) do
      if buff.info.ID >= TitanSSA.TitanSSA_Sword_enemy_1_buffID and buff.info.ID < TitanSSA.TitanSSA_Sword_enemy_1_buffID + 3 or buff.info.ID == TitanSSA.TitanSSA_enemySword_buffID then
        buff.timer = 0
      end
    end
    if unit.TitanSSA_enemy_sword_rank then
      unit.TitanSSA_enemy_sword_rank = nil
    end
  end
  basefunc(unit, skiller)
end

function TitanSSA.init_hero(hero)
  local skillult = hero.skills.TitanSSA_ult
  local skillatk = hero.skills.TitanSSA_atk
  local skillatk2 = hero.skills.TitanSSA_atk2
  local skillatk3 = hero.skills.TitanSSA_atk3
  local skillatk4 = hero.skills.TitanSSA_atk4
  local skillatk3s = hero.skills.TitanSSA_atk3s
  hero.onDying = override(hero.onDying, TitanSSA.hero_onDying)
  hero.TitanSSA_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.arcana4_ARM = 0
  hero.arcana4_MR = 0
  if skillatk4 then
    hero.reset = override(hero.reset, TitanSSA.hero_reset)
  end
  if skillatk then
    skillatk.power = override(skillatk.power, TitanSSA.skills_power)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanSSA.skillatk3_start)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanSSA.skillatk3_takeEffectOn)
    skillatk3.selectTarget = override(skillatk3.selectTarget, TitanSSA.skillatk3_selectTarget)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, TitanSSA.skillatk3_canCastWithTarget)
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanSSA.skillatk3_createProjectile)
    skillatk3s.startPhase = override(skillatk3s.startPhase, TitanSSA.skillatk3s_startPhase)
    skillatk3s.takeEffectOn = override(skillatk3s.takeEffectOn, TitanSSA.skillatk3s_takeEffectOn)
    skillatk3.power = override(skillatk3.power, TitanSSA.skills_power)
    skillatk3s.power = override(skillatk3s.power, TitanSSA.skills_power)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanSSA.skillatk2_start)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, TitanSSA.skillatk2_canCastWithTarget)
    skillatk2.selectTarget = override(skillatk2.selectTarget, TitanSSA.skillatk2_selectTarget)
    skillatk2.startPhase = override(skillatk2.startPhase, TitanSSA.skillatk2_startPhase)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanSSA.skillatk2_takeEffectOn)
    skillatk2.power = override(skillatk2.power, TitanSSA.skills_power)
    skillatk2.finish = override(skillatk2.finish, TitanSSA.skillatk2_finish)
  end
  if skillult then
    skillult.startPhase = override(skillult.startPhase, TitanSSA.skillult_startPhase)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanSSA.skillult_takeEffectOn)
    skillult.power = override(skillult.power, TitanSSA.skills_power)
  end
  return hero
end

return TitanSSA.init_hero
