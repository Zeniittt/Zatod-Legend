module("ed.battlehero", package.seeall)
Oracle = {}
local ed = ed
local math = math
Oracle.nil_bid = 1282
Oracle.ult_counter_control_bid = 1283
Oracle.ult_mainbuff_bid = 1279
Oracle.ult_mainbuff_self_bid = 1280
Oracle.Oracle_atk3_durtime = 2
Oracle.Oracle_atk4_enemy_bid = 1277
Oracle.Oracle_atk4_friend_bid = 1276
Oracle.Orcale_atk4_enemy_ratio = 0.5
Oracle.Orcale_atk4_friend_ratio = 2
Oracle.Oracle_ult_CD = 0.5
Oracle.Oracle_atk2_infect_radius = 175
Oracle.Oracle_ult_dangerHP = 0.2
Oracle.Oracle_ult_self_mp = -50
Oracle.Oracle_ult_self_hpratio = -0.02
Oracle.dispelRange = 150
Oracle.ult_counter_number_bid = 1285

function Oracle.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Oracle_atk3_unit_list = {}
  hero.ori_camp = hero.camp
  hero.ori_foecamp = hero.foecamp
  hero.Oracle_atk4_pjcount = 0
  hero.Oracle_atk2list = {}
  hero.Oracle_ult_CD = Oracle.Oracle_ult_CD
  hero.Oracle_ult_temp_buff_list = {}
end

function Oracle.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  Oracle.removeUlt(hero)
end

function Oracle.dispelCheckLevel(skillLevel, targetLevel)
  if ed.rand() < 0.3 then
    return true
  end
  local dice = 20
  if skillLevel < 30 then
    skillLevel = 10 + skillLevel / 30 * 20
  end
  dice = dice * ed.rand()
  local pass = targetLevel <= skillLevel + dice
  return pass
end

function Oracle.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.Oracle_ult_duration and hero.Oracle_ult_CD > 0 then
    hero.Oracle_ult_CD = hero.Oracle_ult_CD - dt
  end
  local caster = hero
  local skillult = hero.skills.Oracle_ult
  local skillatk2 = hero.skills.Oracle_atk2
  local skillatk2s = hero.skills.Oracle_atk2s
  local number = #hero.Oracle_atk2list
  if 0 < number and skillatk2 then
    for i = 1, number do
      if hero.Oracle_atk2list[i] and hero.Oracle_atk2list[i]:isAlive() then
        for k = i + 1, number do
          if hero.Oracle_atk2list[k] and hero.Oracle_atk2list[k]:isAlive() and hero.Oracle_atk2list[i].camp ~= hero.Oracle_atk2list[k].camp and ed.edpDistanceSQ(hero.Oracle_atk2list[i].position, hero.Oracle_atk2list[k].position) <= Oracle.Oracle_atk2_infect_radius * Oracle.Oracle_atk2_infect_radius then
            local unit1 = hero.Oracle_atk2list[i]
            local unit2 = hero.Oracle_atk2list[k]
            local mid_position = {
              (hero.Oracle_atk2list[i].position[1] + hero.Oracle_atk2list[k].position[1]) / 2,
              (hero.Oracle_atk2list[i].position[2] + hero.Oracle_atk2list[k].position[2]) / 2
            }
            skillatk2s:takeEffectAt(mid_position)
            for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
              if unit.buff_effects.untargetable then
              else
                local p2 = ed.edpSub(unit.position, hero.position)
                p2[1] = p2[1] * hero.direction
                if skillatk2.testPointInShape(p2, "circle", Oracle.dispelRange, Oracle.dispelRange) and Oracle.dispelCheckLevel(skillatk2.level, unit.level) then
                  local list = unit.buff_list
                  for i = 1, #list do
                    local unitBuff = list[i]
                    if unitBuff and (not unitBuff.caster or unitBuff.caster.camp ~= caster.camp) and unitBuff.info.Dispel then
                      unitBuff.timer = 0
                    end
                  end
                end
              end
            end
            if unit1.camp == hero.ori_camp then
              local healamount = caster.Oracle_atk2_bufffriend.timer * skillatk2.info["Script Arg3"]
              unit1:takeHeal(healamount, "hp", hero)
            else
              local healamount = caster.Oracle_atk2_buffenemy.timer * skillatk2.info["Script Arg2"]
              unit1:takeHeal(healamount, "hp", hero)
            end
            caster.Oracle_atk2_bufffriend.timer = 0
            if unit2.camp == hero.ori_camp then
              local healamount = caster.Oracle_atk2_bufffriend.timer * skillatk2.info["Script Arg3"]
              unit2:takeHeal(healamount, "hp", hero)
            else
              local healamount = caster.Oracle_atk2_buffenemy.timer * skillatk2.info["Script Arg2"]
              unit2:takeHeal(healamount, "hp", hero)
            end
            caster.Oracle_atk2_buffenemy.timer = 0
            hero.Oracle_atk2list = {}
            break
          end
        end
      end
    end
  end
  if (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and skillult and skillult:canTrigger() and hero.hp / hero.attribs.HP <= Oracle.Oracle_ult_dangerHP and skillult then
    skillult:trigger()
  end
end

function Oracle.removeUlt(hero)
  if hero.Orcale_ult_friend then
    for i, tbuff in ipairs(hero.Orcale_ult_friend.buff_list) do
      if tbuff.info.ID == Oracle.ult_counter_control_bid or tbuff.info.ID == Oracle.ult_counter_number_bid or tbuff.info.ID == 203 then
        tbuff.timer = 0
      end
    end
  end
  hero.Oracle_ult_duration = nil
  hero.Orcale_ult_friend = nil
  if hero.Oracle_ult_self_buff then
    hero.Oracle_ult_self_buff.timer = 0
    hero.Oracle_ult_self_buff = nil
  end
  if hero.Oracle_ult_friend_buff then
    hero.Oracle_ult_friend_buff.timer = 0
    hero.Oracle_ult_friend_buff = nil
  end
  if hero.Oracle_ult_friend_buff_undoom then
    hero.Oracle_ult_friend_buff_undoom.timer = 0
    hero.Oracle_ult_friend_buff_undoom = nil
  end
end

function Oracle.hero_canPanelTrigger(basefunc, hero)
  local skillult = hero.skills.Oracle_ult
  return hero.Oracle_ult_duration and hero.Oracle_ult_CD <= 0 and hero.current_skill ~= skillult
end

function Oracle.skillult_canTrigger(basefunc, skill)
  local caster = skill.caster
  return caster.Oracle_ult_duration and caster.Oracle_ult_CD <= 0
end

function Oracle.skillult_trigger(basefunc, skill)
  local caster = skill.caster
  Oracle.removeUlt(caster)
end

function Oracle.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if target == caster or caster.Oracle_ult_duration or caster.mp < 500 or caster.current_skill == caster.manual_skill then
    result = nil
  end
  if (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and caster.hp / caster.attribs.HP <= Oracle.Oracle_ult_dangerHP then
    result = nil
  end
  return result
end

function Oracle.skillult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
end

function Oracle.skillult_buff_friend_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  Oracle.removeUlt(caster)
end

function Oracle.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  Oracle.removeUlt(caster)
end

function Oracle.skillult_buff_self_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.mp <= 50 then
    Oracle.removeUlt(owner)
  end
end

function Oracle.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if target and target:isAlive() then
    caster.Oracle_ult_CD = Oracle.Oracle_ult_CD
    local bid = Oracle.ult_mainbuff_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff.update = override(buff.update, Oracle.skillult_buff_update)
    buff.onRemoved = override(buff.onRemoved, Oracle.skillult_buff_friend_onRemoved)
    local buffresult = target:addBuff(buff, caster)
    caster.Oracle_ult_friend_buff = buffresult
    if buffresult then
      local bid = 203
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster.Oracle_ult_friend_buff_undoom = target:addBuff(binfo, caster)
      local bid = Oracle.ult_mainbuff_self_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.update = override(buff.update, Oracle.skillult_buff_self_update)
      buff.onRemoved = override(buff.onRemoved, Oracle.skillult_buff_onRemoved)
      local HPR = Oracle.Oracle_ult_self_hpratio * caster.attribs.HP
      local MPR = Oracle.Oracle_ult_self_mp
      buff:setAttribute("HPR", HPR)
      buff:setAttribute("MPR", MPR)
      local buffresult = caster:addBuff(buff, caster)
      caster.Oracle_ult_self_buff = buffresult
      local list = target.buff_list
      for i = 1, #list do
        local unitBuff = list[i]
        if unitBuff and (not unitBuff.caster or unitBuff.caster.camp ~= caster.camp) and unitBuff.info.Dispel then
          unitBuff.timer = 0
        end
      end
      caster.Oracle_ult_duration = true
      caster.Orcale_ult_friend = target
    end
  end
end

function Oracle.skillult_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.config.is_summoned then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function Oracle.collectBuff(basefunc, self, config)
  if self.Oracle_ult_duration then
    local buff = config.buff
    local owner = buff.owner
    if buff.owner:isAlive() and not buff.Oracle_trigger and self.Orcale_ult_friend == owner and buff.caster and buff.caster.camp ~= owner.camp then
      if buff.owner.camp ~= buff.caster.camp and buff:isCrlEftConflictWithUncontrollable() then
        local bid = Oracle.nil_bid
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        config.buff = ed.BuffCreate(binfo, owner, buff.caster)
        config.buff.Oracle_trigger = true
        local bid = Oracle.ult_counter_control_bid
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, owner, self)
        local buffresult = owner:addBuff(buff, self)
      end
      local Numdebuff
      local Numbuff_list = {}
      if buff.info.ID ~= 494 and buff.info.ID ~= Oracle.nil_bid then
        local row = ed.getDataTable("Buff")[buff.info.ID]
        for k, _ in pairs(row) do
          if k == "STR" or "AGI" or "INT" or "HP" or "MP" or "AD" or "AP" or "ARM" or "MR" or "CRIT" or "MCRIT" or "HPS" or "MPS" or "DODG" or "ARMP" or "MRI" or "LFS" or "CDR" or "HEAL" or "HPR" or "MPR" or "HAST" or "MSPD" or "PIMU" or "MIMU" or "HIT" or "HealRatio" or "LFSRatio" or "TEN" or "POAD" or "POAP" or "POARM" or "POMR" or not "DotDRatio" then
          end
          local v = buff.info[k]
          if type(v) == "number" and v < 0 then
            Numdebuff = true
            break
          end
        end
        if Numdebuff then
          local bid = Oracle.nil_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          config.buff = ed.BuffCreate(binfo, owner, buff.caster)
          config.buff.Oracle_trigger = true
          local skillult = self.skills.Oracle_ult
          local bid2 = Oracle.ult_counter_number_bid
          local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
          local buff = ed.BuffCreate(binfo2, owner, self)
          buff:setAttribute("AD", skillult.info["Script Arg2"])
          buff:setAttribute("AP", skillult.info["Script Arg3"])
          local buffresult = owner:addBuff(buff, self)
        end
      end
    end
  end
end

function Oracle.skillatk2_chosetarget(skill, camp)
  local caster = skill.caster
  local max = -math.huge
  local chosen
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  local Ignore = skill:Ignore_Target_Type()
  local selector
  if camp == caster.ori_camp then
    selector = skill.target_selectors.maxagi
    for unit in ed.engine:foreachAliveUnit(camp) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif camp == caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    skill.target = chosen
    return chosen
  elseif camp == caster.ori_foecamp then
    selector = skill.target_selectors.maxint
    for unit in ed.engine:foreachAliveUnit(camp) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif camp == caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    skill.target = chosen
    return chosen
  end
end

function Oracle.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target_friend = Oracle.skillatk2_chosetarget(skill, caster.ori_camp)
  local target_enemy = Oracle.skillatk2_chosetarget(skill, caster.ori_foecamp)
  if target_friend then
    local buff1 = skill:createBuff(target_friend)
    local result1 = target_friend:addBuff(buff1, caster)
    if result1 then
      table.insert(caster.Oracle_atk2list, target_friend)
      caster.Oracle_atk2_bufffriend = buff1
    end
  end
  if target_enemy then
    local buff2 = skill:createBuff(target_enemy)
    local result2 = target_enemy:addBuff(buff2, caster)
    if result2 then
      table.insert(caster.Oracle_atk2list, target_enemy)
      caster.Oracle_atk2_buffenemy = buff2
    end
  end
  local info = skill.info
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
end

function Oracle.skillatk2_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
end

function Oracle.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.update = override(buff.update, Oracle.skillatk2_buff_update)
  if target.camp == caster.ori_camp then
    buff:setAttribute("HPR", skill.info["Script Arg3"])
  else
    buff:setAttribute("HPR", skill.info["Script Arg2"])
  end
  return buff
end

function Oracle.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if ed.run_with_scene then
    local effect_name = "eff_point_Oracle_atk3.cha"
    if not effect_name then
      return
    end
    local effect_z = 0
    caster.Oracel_atk3_effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
      caster.direction,
      1
    }, nil, effect_z)
  end
end

function Oracle.skillatk3_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  if caster.Oracel_atk3_effect then
    local z = 0
    ed.scene:removeEffect(caster.Oracel_atk3_effect, z)
  end
  caster.Oracle_atk3_region = nil
end

function Oracle.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if caster.Oracle_atk3_region then
    result = nil
  end
  return result
end

function Oracle.skillatk3_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local finaldamage = damage
  local owner = buff.owner
  local caster = buff.caster
  local Oracle_atk3_ratio = caster.skills.Oracle_atk3.info["Script Arg2"] / 100
  if skill and skill.info["AOE Origin"] then
    finaldamage = damage * Oracle_atk3_ratio
  end
  return finaldamage
end

function Oracle.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.onDamaged = override(buff.onDamaged, Oracle.skillatk3_buff_onDamaged)
  caster.Oracle_atk3_skill_list = {}
  return buff
end

function Oracle.skillatk3_createRegion(basefunc, skill)
  local region = basefunc(skill)
  local caster = skill.caster
  caster.Oracle_atk3_region = region
  region.terminate = override(region.terminate, Oracle.skillatk3_region_terminate)
  return region
end

function Oracle.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local info = skill.info
  for i = 1, 2 do
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
end

function Oracle.skillatk4_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if projectile.projectile_time then
    projectile.projectile_time = projectile.projectile_time + dt
  else
    projectile.projectile_time = 0
  end
  projectile["No Gravity"] = true
  if projectile.height > 200 or projectile.Oracle_turn then
    local xy = ed.edpSub(projectile.Oracle_atk4_target.position, projectile.position)
    local z = 20 - projectile.height
    local l = (xy[1] * xy[1] + xy[2] * xy[2] + z * z) ^ 0.5
    local v = 100
    local u = 1 / l
    local targetV = {
      u * xy[1],
      u * xy[2],
      u * z
    }
    local bh_plus_v1 = targetV[1] * v
    local bh_plus_v2 = targetV[2] * v
    local bh_plus_zv = targetV[3] * v
    local oldvelocity = projectile.velocity
    local oldzSpeed = 0
    local newvelocity = {}
    local newzSpeed = 0
    newvelocity[1] = projectile.velocity[1] + bh_plus_v1
    newvelocity[2] = projectile.velocity[2] + bh_plus_v2
    if projectile.zSpeed then
      oldzSpeed = projectile.zSpeed
      newzSpeed = projectile.zSpeed + bh_plus_zv
    end
    local v_a = 0.3
    local k = ((oldvelocity[1] * oldvelocity[1] + oldvelocity[2] * oldvelocity[2] + oldzSpeed * oldzSpeed) / (newvelocity[1] * newvelocity[1] + newvelocity[2] * newvelocity[2] + newzSpeed * newzSpeed)) ^ 0.5 * (1 + v_a * (projectile.projectile_time > 1 and projectile.projectile_time or 0))
    projectile.velocity[1] = k * newvelocity[1]
    projectile.velocity[2] = k * newvelocity[2]
    if projectile.zSpeed then
      projectile.zSpeed = k * newzSpeed
    end
    projectile.Oracle_turn = true
  end
end

function Oracle.skillatk4_projectile_hit(basefunc, projectile, target)
  if target == projectile.Oracle_atk4_target then
    basefunc(projectile, target)
  else
    return
  end
end

function Oracle.skillatk4_chosetarget(skill, camp)
  local caster = skill.caster
  local max = -math.huge
  local chosen
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  local Ignore = skill:Ignore_Target_Type()
  local selector
  if camp == caster.ori_camp then
    selector = skill.target_selectors.maxmp
    for unit in ed.engine:foreachAliveUnit(camp) do
      if unit.buff_effects.untargetable then
      elseif unit.config.is_summoned then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      else
        local power = skill:power(caster, unit, "Holy")
        if power >= unit.hp then
        elseif camp == caster.camp and unit.controlledTarget then
        else
          local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
          if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
            local v = selector(unit)
            local shouldIgnore = Ignore(unit)
            if max < v and not shouldIgnore then
              max = v
              chosen = unit
            end
          end
        end
      end
    end
    skill.target = chosen
    return chosen
  elseif camp == caster.ori_foecamp then
    selector = skill.target_selectors.minhp
    for unit in ed.engine:foreachAliveUnit(camp) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif camp == caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    skill.target = chosen
    return chosen
  end
end

function Oracle.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  if caster.Oracle_atk4_pjcount % 2 == 1 then
    projectile.Oracle_atk4_target = Oracle.skillatk4_chosetarget(skill, skill.caster.ori_camp)
  else
    projectile.Oracle_atk4_target = Oracle.skillatk4_chosetarget(skill, skill.caster.ori_foecamp)
  end
  caster.Oracle_atk4_pjcount = caster.Oracle_atk4_pjcount + 1
  if projectile.Oracle_atk4_target then
    projectile.update = override(projectile.update, Oracle.skillatk4_projectile_update)
    projectile.hit = override(projectile.hit, Oracle.skillatk4_projectile_hit)
    return projectile
  else
    return nil
  end
end

function Oracle.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local result, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result and target:isAlive() then
    if target.camp == caster.ori_camp then
      local bid = Oracle.Oracle_atk4_friend_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      local healHP = dmg * Oracle.Orcale_atk4_friend_ratio
      buff:setAttribute("HPR", healHP / buff.timer)
      local buffresult = target:addBuff(buff, caster)
    else
      local bid = Oracle.Oracle_atk4_enemy_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      local healHP = dmg * Oracle.Orcale_atk4_enemy_ratio
      buff:setAttribute("HPR", healHP / buff.timer)
      local buffresult = target:addBuff(buff, caster)
    end
  end
end

function Oracle.listerRemoveBuff(basefunc, self, config)
  local skillawake = self.skills.Oracle_awake
  if skillawake and not ed.engine.beingEnd then
    local buff = config.buff
    local owner = buff.owner
    local heal_hp_amount = skillawake.info["Script Arg2"]
    local heal_mp_amount = skillawake.info["Script Arg3"]
    if buff.timer <= 0 and buff:isCrlEftConflictWithUncontrollable() and buff.info.ID ~= 593 then
      self:takeHeal(heal_hp_amount, "hp", self)
    end
    local Numdebuff
    local Numbuff_list = {}
    if buff.info.ID ~= 494 and buff.info.ID ~= Oracle.nil_bid and buff.info.ID ~= 593 then
      for k, attribs in pairs(buff.info) do
        if type(attribs) == "number" then
          Numdebuff = true
          break
        end
      end
      if Numdebuff then
        self:takeHeal(heal_mp_amount, "mp", self)
      end
    end
  end
end

function Oracle.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillsawake = self.skills.Oracle_sawake
  local count = 0
  for hero in ed.engine:foreachAliveUnit(self.camp) do
    if hero:isAlive() and not hero.config.is_summoned and not hero.config.is_monster then
      count = count + 1
    end
  end
  if skillsawake and unit.info["Unit Type"] == "Hero" and self:isAlive() and 1 <= count and not self.Oracle_skillsawake_cast then
    self.Oracle_sawake_buff_HP = unit.attribs.HP * skillsawake.info["Script Arg1"] / count
    self.Oracle_sawake_buff_AD = unit.attribs.AD * skillsawake.info["Script Arg2"] / count
    self.Oracle_sawake_buff_AP = unit.attribs.AP * skillsawake.info["Script Arg3"] / count
    self.Oracle_sawake_buff_ARM = unit.attribs.ARM * skillsawake.info["Script Arg4"] / count
    self.Oracle_sawake_buff_MR = unit.attribs.MR * skillsawake.info["Script Arg5"] / count
    skillsawake:takeEffectAt(self.position)
    self.Oracle_skillsawake_cast = true
    if ed.run_with_scene then
      local effect = "eff_point_Oracle_atk4.cha"
      local origin = unit.position
      ed.scene:playEffectOnScene(effect, origin, nil, nil, 1)
    end
  end
end

function Oracle.skillsawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local hp_add = math.floor(caster.Oracle_sawake_buff_HP)
  local ad_add = math.floor(caster.Oracle_sawake_buff_AD)
  local ap_add = math.floor(caster.Oracle_sawake_buff_AP)
  local arm_add = math.floor(caster.Oracle_sawake_buff_ARM)
  local mr_add = math.floor(caster.Oracle_sawake_buff_MR)
  if target and target:isAlive() then
    target:takeHeal(hp_add, "HP", caster)
  end
  buff:setAttribute("AD", ad_add)
  buff:setAttribute("AP", ap_add)
  buff:setAttribute("ARM", arm_add)
  buff:setAttribute("MR", mr_add)
  return buff
end

function Oracle.skillsawake_takeEffectOn(basefunc, skill, target, source, shift)
  if target.config.is_summoned or target.config.is_monster then
    return false
  else
    basefunc(skill, target, source, shift)
  end
end

function Oracle.init_hero(hero)
  local skillult = hero.skills.Oracle_ult
  local skillatk2 = hero.skills.Oracle_atk2
  local skillatk3 = hero.skills.Oracle_atk3
  local skillatk4 = hero.skills.Oracle_atk4
  local skillawake = hero.skills.Oracle_awake
  local skillsawake = hero.skills.Oracle_sawake
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Oracle.skillult_onAttackFrame)
    skillult.selectTarget = override(skillult.selectTarget, Oracle.skillult_selectTarget)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Oracle.skillult_canCastWithTarget)
    skillult.canTrigger = override(skillult.canTrigger, Oracle.skillult_canTrigger)
    skillult.trigger = override(skillult.trigger, Oracle.skillult_trigger)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Oracle.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, Oracle.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Oracle.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, Oracle.skillatk3_createBuff)
    skillatk3.createRegion = override(skillatk3.createRegion, Oracle.skillatk3_createRegion)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Oracle.skillatk3_canCastWithTarget)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Oracle.skillatk4_onAttackFrame)
    skillatk4.createProjectile = override(skillatk4.createProjectile, Oracle.skillatk4_createProjectile)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Oracle.skillatk4_takeEffectOn)
  end
  hero.reset = override(hero.reset, Oracle.hero_reset)
  hero.die = override(hero.die, Oracle.hero_die)
  if hero.name == "Oracle" then
    hero.update = override(hero.update, Oracle.hero_update)
    hero.canPanelTrigger = override(hero.canPanelTrigger, Oracle.hero_canPanelTrigger)
    hero.collectBuff = override(hero.collectBuff, Oracle.collectBuff)
  end
  if skillawake then
    hero.listerRemoveBuff = override(hero.listerRemoveBuff, Oracle.listerRemoveBuff)
  end
  if skillsawake then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Oracle.hero_handleUnitDieEvent)
    skillsawake.createBuff = override(skillsawake.createBuff, Oracle.skillsawake_createBuff)
    skillsawake.takeEffectOn = override(skillsawake.takeEffectOn, Oracle.skillsawake_takeEffectOn)
  end
  return hero
end

return Oracle.init_hero
