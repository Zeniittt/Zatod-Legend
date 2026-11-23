module("ed.battlehero", package.seeall)
local ed = ed
TitanHS = {}
TitanHS.atk2_CD = 7
TitanHS.atk2_auto_CD = 8
TitanHS.atk3_movetime = 0.6
TitanHS.buff_TitanHS_atk4_rage1_ID = 4179
TitanHS.buff_TitanHS_ult_bleed_ID = 4187
TitanHS.buff_TitanHS_atk2_block_ID = 4183
TitanHS.buff_TitanHS_ult_stun_ID = 4184
TitanHS.buff_TitanHS_ult_ate_ID = 4185
TitanHS.buff_TitanHS_atk4_rage_ID = 4186
TitanHS.buff_TitanHS_atk2_count_ID = 4188

function TitanHS.add_rage_buff(target)
  local binfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_atk4_rage_ID)
  local buff = target:addBuff(binfo, target)
end

function TitanHS.removeRageBuff(target, rank1, rank2)
  local skillatk4 = target.skills.TitanHS_atk4
  if skillatk4 then
    for i, rbuff in ipairs(target.buff_list) do
      if rbuff.info.ID == TitanHS.buff_TitanHS_atk4_rage1_ID - 1 + rank1 then
        rbuff.timer = 0
      end
    end
    local binfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_atk4_rage1_ID - 1 + rank2)
    local abuff = ed.BuffCreate(binfo, target, target)
    abuff:setAttribute("AD", skillatk4.info["Script Arg3"] * (rank2 - 1))
    abuff:setAttribute("HAST", 50 * (rank2 - 1))
    target:addBuff(abuff, target)
  end
end

function TitanHS.hero_reset(basefunc, hero)
  basefunc(hero)
  if ed.run_with_scene then
    hero.TitanHS_combat_status = ed.scene.auto_combat
  end
  local binfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_atk4_rage_ID)
  local bbuff = ed.BuffCreate(binfo, hero, hero)
  local skillatk2 = hero.skills.TitanHS_atk2
  bbuff.upgrade = override(bbuff.upgrade, TitanHS.hero_bbuff_upgrade)
  hero:addBuff(bbuff, hero)
  local skillenter = hero.skills.TitanHS_enter
  if skillenter then
    local bid = 651
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
  end
  local atk2binfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_atk2_count_ID)
  local atk2buff = ed.BuffCreate(atk2binfo, hero, hero)
  atk2buff.timer = 2.5
  atk2buff.onRemoved = override(atk2buff.onRemoved, TitanHS.atk2buff_onRemoved)
  hero:addBuff(atk2buff, hero)
end

function TitanHS.atk2buff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.owner.TitanHS_canCastATK2 = true
end

function TitanHS.hero_bbuff_upgrade(basefunc, buff, owner, caster, nextBuffInfo)
  local buff = basefunc(buff, owner, caster, nextBuffInfo)
  TitanHS.removeRageBuff(owner, buff.rank - 1, buff.rank)
  return buff
end

function TitanHS.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = 400 - 300 * caster.direction
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = 0
    end
  end
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanHS.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = 0
    end
  end
end

function TitanHS.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local target = skill.target
  local dir = (target.position[1] - caster.position[1]) / math.abs(target.position[1] - caster.position[1])
  if target.position[1] - caster.position[1] == 0 then
    dir = caster:getInitDir()
  end
  skill.TitanHS_atk3_target_position1 = target.position[1]
  caster.direction = dir
  basefunc(skill, target)
end

function TitanHS.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if skill.attack_counter < 2 then
    return false, dmg, Crit, lfs_amount
  else
    local binfo = ed.lookupDataTable("Buff", nil, 6)
    if target then
      target:addBuff(binfo, skill.caster)
    end
    return out, dmg, Crit, lfs_amount
  end
end

function TitanHS.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if skill.attack_counter == 0 then
    local dir = (skill.TitanHS_atk3_target_position1 - caster.position[1]) / math.abs(skill.TitanHS_atk3_target_position1 - caster.position[1])
    if skill.TitanHS_atk3_target_position1 - caster.position[1] == 0 then
      dir = caster:getInitDir()
    end
    local move_velocity = math.abs(skill.TitanHS_atk3_target_position1 - caster.position[1] - 160 * dir) / TitanHS.atk3_movetime
    caster.manual_moving = true
    caster.walk_v = {
      move_velocity * dir,
      0
    }
  elseif skill.attack_counter == 1 then
    caster.walk_v = {0, 0}
    caster.manual_moving = false
  end
  basefunc(skill)
end

function TitanHS.skillatk3_finish(basefunc, skill, reason)
  skill.caster.position[1] = skill.caster.position[1] + 92 * skill.caster.direction
  basefunc(skill, reason)
end

function TitanHS.skillatk3_canCastWithTarget(basefunc, skill, target)
  local out, reason = basefunc(skill, target)
  local unithp = 0
  local checktarget
  for unit in ed.engine:foreachAliveUnit(skill.caster.foecamp) do
    if unithp <= 0 then
      unithp = unit.hp
      checktarget = unit
    elseif unithp > unit.hp then
      unithp = unit.hp
      checktarget = unit
    end
  end
  if not checktarget then
    return false
  end
  if (target and 0 > target.position[1] or target.position[1] > 800) and (skill.caster.position[1] < 160 or skill.caster.position[1] > 640) then
    return false
  end
  if 160 > math.abs(checktarget.position[1] - skill.caster.position[1]) then
    return false
  end
  return out, reason
end

function TitanHS.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.TitanHS_skillatk2_pressed = false
  caster.TitanHS_atk2CD = TitanHS.atk2_CD
  caster.TitanHS_skillatk2_autotimer = TitanHS.atk2_auto_CD
  local binfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_atk2_block_ID)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.TitanHS_takeDamage = 0
  buff.onDamaged = override(buff.onDamaged, TitanHS.skillatk2_blockbuff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, TitanHS.skillatk2_blockbuff_onRemoved)
  caster:addBuff(buff, caster)
end

function TitanHS.skillatk2_blockbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local caster = buff.owner
  local skillatk2 = caster.skills.TitanHS_atk2
  local skillatk2s = caster.skills.TitanHS_atk2s
  buff.TitanHS_takeDamage = buff.TitanHS_takeDamage + damage
  local track = false
  if math.abs(source.position[1] - caster.position[1]) <= 230 and buff.TitanHS_takeDamage > 3500 then
    skillatk2s.TitanHS_skillatk2s_blocked = true
    buff.TitanHS_block_source = source
    damage = 0
    buff.timer = 0
  end
  return damage
end

function TitanHS.skillatk2_blockbuff_onRemoved(basefunc, buff)
  local caster = buff.owner
  local skillatk2 = caster.skills.TitanHS_atk2
  local skillatk2s = caster.skills.TitanHS_atk2s
  if buff.TitanHS_block_source and skillatk2s.TitanHS_skillatk2s_blocked == true then
    buff.TitanHS_block_source:takeDamage(math.min(buff.TitanHS_takeDamage * skillatk2.info["Script Arg2"], caster.attribs.HP), "Holy", "hp", caster, 1, 1)
  end
  buff.TitanHS_takeDamage = 0
  if caster.current_skill and caster.current_skill ~= caster.manual_skill then
    caster.current_skill:interrupt()
  end
  caster:castSkill(skillatk2s, source)
  basefunc(buff)
end

function TitanHS.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.attack_counter == 1 then
    return false
  end
  return basefunc(skill, target, source, shift)
end

function TitanHS.skillatk2s_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if skill.TitanHS_skillatk2s_blocked == false then
    power = power * 0.5
    for i, bbuff in ipairs(caster.buff_list) do
      if bbuff.info.ID == TitanHS.buff_TitanHS_atk4_rage_ID and bbuff.rank > 1 then
        bbuff.rank = bbuff.rank - 1
        TitanHS.removeRageBuff(caster, bbuff.rank + 1, bbuff.rank)
      end
    end
  else
    TitanHS.add_rage_buff(caster)
  end
  skill.TitanHS_skillatk2s_blocked = false
  return power, coeff
end

function TitanHS.skillatk2s_finish(basefunc, skill, reason)
  local hero = skill.caster
  local skillatk2 = hero.skills.TitanHS_atk2
  hero.TitanHS_canCastATK2 = false
  local atk2binfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_atk2_count_ID)
  local atk2buff = ed.BuffCreate(atk2binfo, hero, hero)
  atk2buff.onRemoved = override(atk2buff.onRemoved, TitanHS.atk2buff_onRemoved)
  hero:addBuff(atk2buff, hero)
  basefunc(skill, reason)
end

function TitanHS.closeskills_takeEffectOn(basefunc, skill, target, source, shift)
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  caster.TitanHS_attack_counter = caster.TitanHS_attack_counter + 1
  if caster.TitanHS_attack_counter == 3 then
    caster.TitanHS_attack_counter = 0
    TitanHS.add_rage_buff(caster)
  end
  return out, dmg, Crit, lfs_amount
end

function TitanHS.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.attack_counter == 1 then
    return false
  elseif skill.attack_counter == 3 then
    local caster = skill.caster
    local skillatk4 = caster.skills.TitanHS_atk4
    local rage_lv = 0
    if skillatk4 then
      for i, rbuff in ipairs(caster.buff_list) do
        if rbuff.info.ID == TitanHS.buff_TitanHS_atk4_rage_ID then
          rage_lv = rbuff.rank - 1
        elseif rbuff.info.ID >= TitanHS.buff_TitanHS_atk4_rage1_ID and rbuff.info.ID <= TitanHS.buff_TitanHS_atk4_rage1_ID + 3 then
          rbuff.timer = 0
        end
      end
      if 0 < rage_lv then
        local bldinfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_ult_bleed_ID)
        local bldbuff = ed.BuffCreate(bldinfo, target, caster)
        bldbuff:setAttribute("HPR", skillatk4.info["Script Arg2"] * -1)
        target:addBuff(bldbuff, caster)
      end
      if 1 < rage_lv then
        local stuninfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_ult_stun_ID)
        local stunbuff = ed.BuffCreate(stuninfo, target, caster)
        stunbuff:setAttribute("ARM", caster.attribs.AD * 0.03 * -1)
        target:addBuff(stunbuff, caster)
      end
      if 2 < rage_lv then
        local ateinfo = ed.lookupDataTable("Buff", nil, TitanHS.buff_TitanHS_ult_ate_ID)
        local atebuff = ed.BuffCreate(ateinfo, target, caster)
        target:addBuff(atebuff, caster)
      end
    end
  end
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  return out, dmg, Crit, lfs_amount
end

function TitanHS.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 and ed.run_with_scene then
    local effectx = "eff_point_TitanHS_ult.cha"
    local effect = ed.scene:playEffectOnScene(effectx, caster.position, {
      caster.direction,
      1
    }, nil, -1)
  end
  basefunc(skill)
  if skill.attack_counter == 3 then
    for i, rbuff in ipairs(caster.buff_list) do
      if rbuff.info.ID == TitanHS.buff_TitanHS_atk4_rage_ID then
        rbuff.rank = 1
      end
    end
  end
end

function TitanHS.hero_castManualSkill(basefunc, unit)
  local skillatk2 = unit.skills.TitanHS_atk2
  local skillult = unit.skills.TitanHS_ult
  if unit.current_skill and unit.current_skill ~= unit.manual_skill then
    unit.current_skill:interrupt()
  end
  if skillult and skillult:canCastWithTarget(unit.ai.target) then
    if skillatk2 then
      if unit.TitanHS_skillatk2_autotimer then
        unit.TitanHS_skillatk2_autotimer = unit.TitanHS_skillatk2_autotimer + 0.25
      end
      skillatk2.cd_remaining = 0.25
    end
    basefunc(unit)
  elseif skillatk2 and skillatk2.cd_remaining <= 0 then
    unit:castSkill(skillatk2, unit)
  end
end

function TitanHS.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.TitanHS_skillatk2_autotimer = hero.TitanHS_skillatk2_autotimer - dt
  local skillatk2 = hero.skills.TitanHS_atk2
  local skillult = hero.skills.TitanHS_ult
  if skillatk2 and skillatk2.cd_remaining <= 0 then
    hero.can_cast_manual = hero.can_cast_manual or skillatk2 and hero.mp < 1000 and hero:isAlive() and hero.current_skill ~= skillult
  end
end

function TitanHS.skillatk2_willCast(basefunc, skill)
  local caster = skill.caster
  local foecounter = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if math.abs(unit.position[1] - caster.position[1]) < 200 then
      foecounter = foecounter + 1
    end
  end
  if foecounter < 1 then
    return false
  end
  if 0 < caster.TitanHS_skillatk2_autotimer then
    return false
  end
  if ed.run_with_scene and caster.name == "TitanHS" and caster.TitanHS_combat_status ~= ed.scene.auto_combat and ed.scene.auto_combat then
    return true
  end
  if ed.run_with_scene and caster.name == "TitanHS" and ed.scene.auto_combat and caster.current_skill then
    return false
  end
  return basefunc(skill)
end

function TitanHS.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.caster.can_cast_manual = false
end

function TitanHS.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  skill.caster.can_cast_manual = trueduide
end

function TitanHS.init_hero(hero)
  hero.TitanHS_attack_counter = 0
  hero.TitanHS_canCastATK2 = false
  hero.TitanHS_atk2CD = TitanHS.atk2_CD
  hero.TitanHS_skillatk2_pressed = false
  hero.TitanHS_skillatk2_autotimer = TitanHS.atk2_auto_CD
  local skillult = hero.skills.TitanHS_ult
  local skillults = hero.skills.TitanHS_ults
  local skillatk = hero.skills.TitanHS_atk
  local skillatk2 = hero.skills.TitanHS_atk2
  local skillatk3 = hero.skills.TitanHS_atk3
  local skillenter = hero.skills.TitanHS_enter
  local skillatk2s = hero.skills.TitanHS_atk2s
  hero.castManualSkill = override(hero.castManualSkill, TitanHS.hero_castManualSkill)
  hero.reset = override(hero.reset, TitanHS.hero_reset)
  hero.update = override(hero.update, TitanHS.hero_update)
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanHS.closeskills_takeEffectOn)
  end
  if skillenter then
    skillenter.start = override(skillenter.start, TitanHS.skillenter_start)
    skillenter.finish = override(skillenter.finish, TitanHS.skillenter_finish)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanHS.skillatk3_start)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanHS.skillatk3_takeEffectOn)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanHS.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, TitanHS.skillatk3_finish)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, TitanHS.skillatk3_canCastWithTarget)
  end
  if skillatk2 then
    skillatk2.willCast = override(skillatk2.willCast, TitanHS.skillatk2_willCast)
    skillatk2s.TitanHS_skillatk2s_blocked = false
    skillatk2s.power = override(skillatk2s.power, TitanHS.skillatk2s_power)
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, TitanHS.closeskills_takeEffectOn)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanHS.skillatk2_takeEffectOn)
    skillatk2.start = override(skillatk2.start, TitanHS.skillatk2_start)
  end
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanHS.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanHS.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanHS.skillult_start)
    skillult.finish = override(skillult.finish, TitanHS.skillult_finish)
  end
  return hero
end

return TitanHS.init_hero
