module("ed.battlehero", package.seeall)
local ed = ed
TitanTB = {}
TitanTB.ult_shield_buffid = 1528
TitanTB.ult_shield_ratio = 0.3
TitanTB.ult_Devil_buffid = 1529
TitanTB.ult2_Devil_buffid = 1530
TitanTB.ult2_Devil_fashion_buffid = 1680
TitanTB.Venus_atk_time = 6
TitanTB.TitanTB_atk3D_counttime = 6
TitanTB.TitanTB_atk4_self_bid = 1531
TitanTB.TitanTB_atk4_ADratio = 0.3
TitanTB.Titan_atk_ratio = 0.75
TitanTB.TitanTB_atk_mp = 25
TitanTB.TitanTB_ult_basicADratio = 0.0025
TitanTB.TitanTB_ult_basicMRratio = 0.002
TitanTB.TitanTB_ult_basicDODG = 0.5
TitanTB.TitanTB_ult2_basicCRIT = 2
TitanTB.TitanTB_ult2_basicHIT = 1
TitanTB.TitanTB_region_times = 4
TitanTB.Titan_atkD_countMax = 4
TitanTB.TitanTB_atk4_HPratio = 20000
TitanTB.TitanTB_atk4_mp_ratio = 10
TitanTB.TitanTB_atk2A_self_bid = 1536
TitanTB.Fashion_ID1 = 100771
TitanTB.Fashion_ID2 = 100772

function TitanTB.shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanTB_shield = nil
end

function TitanTB.add_Shield(hero, shield_vaule)
  if not hero.TitanTB_shield then
    local bid = TitanTB.ult_shield_buffid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local shield_buff = ed.BuffCreate(binfo, hero, hero)
    shield_buff.onRemoved = override(shield_buff.onRemoved, TitanTB.shield_onRemoved)
    shield_buff.shield = shield_vaule
    hero.TitanTB_shield = hero:addBuff(shield_buff, hero)
  else
    local buff = hero.TitanTB_shield
    local shield = buff.shield
    buff.shield = shield + shield_vaule
    buff.timer = buff.info.Time
    if buff.shield <= 0 and hero.TitanTB_shield then
      hero:removeBuff(hero.TitanTB_shield)
    end
  end
end

function TitanTB.DOP_in_battlefield(caster, radius, camp)
  local point_list = {}
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local x = 0
  local y = 0
  local distance = 0
  local mindistance = 999999999
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
  end
  if maxcount <= 0 then
    return {400, 0}
  end
end

function TitanTB.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.TitanTB_atk3D_region then
    hero.TitanTB_atk3D_region:terminate()
  end
end

function TitanTB.skillult_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  if self.caster.taunter and self.info["Target Type"] ~= "self" then
    if target then
      if target.camp ~= self:targetCamp() then
        self:selectTarget(target)
      else
      end
    else
      self:selectTarget(target)
    end
  else
    self:selectTarget(target)
  end
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  self:startPhase(1)
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  if caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 then
    caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  else
    caster:setMP(caster.mp - 100)
  end
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function TitanTB.skillult_devilbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  basefunc(buff)
  if caster.TitanTB_devilBuff then
    caster.TitanTB_devilBuff = nil
  end
end

function TitanTB.skillult_devilbuff2_onRemoved(basefunc, buff)
  local caster = buff.caster
  basefunc(buff)
  if caster.TitanTB_devilBuff2 then
    caster.TitanTB_devilBuff2 = nil
  end
end

function TitanTB.skillult_devilbuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  if hero.mp <= 25 then
    buff.timer = 0
  end
end

function TitanTB.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    if caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 then
      caster.TitanTB_ultchange = true
      TitanTB.add_Shield(caster, caster.attribs.HP * TitanTB.ult_shield_ratio)
      local bid = TitanTB.ult_Devil_buffid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      local level = skill.level
      buff.onRemoved = override(buff.onRemoved, TitanTB.skillult_devilbuff_onRemoved)
      buff:setAttribute("AD", TitanTB.TitanTB_ult_basicADratio * level * caster.attribs.AD)
      buff:setAttribute("MR", TitanTB.TitanTB_ult_basicMRratio * level * caster.attribs.MR)
      if caster.stars >= 6 then
        buff:setAttribute("DODG", (TitanTB.TitanTB_ult_basicDODG - (10 - caster.stars) * 0.1) * level)
      else
        buff:setAttribute("DODG", TitanTB.TitanTB_ult_basicDODG * level * 0.1)
      end
      caster.TitanTB_devilBuff = buff
      caster:addBuff(buff, caster)
      caster:setPosition({
        caster.position[1] - 200 * caster:getInitDir(),
        caster.position[2]
      })
    elseif caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
      local bid = TitanTB.ult2_Devil_buffid
      if caster.currentActionStage == 4 or caster.currentActionStage == 6 then
        bid = TitanTB.ult2_Devil_fashion_buffid
      end
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      local level = skill.level
      buff.onRemoved = override(buff.onRemoved, TitanTB.skillult_devilbuff2_onRemoved)
      buff.update = override(buff.update, TitanTB.skillult_devilbuff2_update)
      if caster.stars >= 6 then
        buff:setAttribute("CRIT", (TitanTB.TitanTB_ult2_basicCRIT - (10 - caster.stars) * 0.3) * level)
      else
        buff:setAttribute("CRIT", TitanTB.TitanTB_ult2_basicCRIT * level * 0.1)
      end
      buff:setAttribute("HIT", TitanTB.TitanTB_ult2_basicHIT * level)
      caster.TitanTB_devilBuff2 = buff
      caster:addBuff(buff, caster)
    end
  end
end

function TitanTB.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.TitanTB_ultchange then
    if caster.currentActionStage == 1 then
      caster:enterActionStageFromOneStage(2, 10077)
    elseif caster.currentActionStage == 3 then
      caster:enterActionStageFromOneStage(4, 10077)
    elseif caster.currentActionStage == 5 then
      caster:enterActionStageFromOneStage(6, 10077)
    end
  end
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "TitanTB" then
      if caster.currentActionStage == 2 then
        panel:setPortrait("UI/DOTA-HERO/TitanTB2.png")
      elseif caster.currentActionStage == 4 then
        panel:setPortrait("UI/DOTA-HERO/TitanTB_fashion1_1.jpg")
      elseif caster.currentActionStage == 6 then
        panel:setPortrait("UI/DOTA-HERO/TitanTB_fashion2_1.jpg")
      end
    end
  end
  local skillatk3A = caster.skills.TitanTB_atk3A
  if not caster.Titan_atk3Abuff and skillatk3A and 3 < caster.TitanTB_hasArcana then
    skillatk3A:takeEffectOn(caster, caster)
  end
end

function TitanTB.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if result then
    if caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
      if caster.TitanTB_devilBuff2 or caster.current_skill == caster.manual_skill then
        return nil
      end
    elseif (caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5) and caster.current_skill == caster.manual_skill then
      return nil
    end
  end
  return result
end

function TitanTB.skillatkD_takeEffectOn(basefunc, skill, target, source, shift)
  local result, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result and target and target:isAlive() and caster.TitanTB_devilBuff2 then
    local shape = "circle"
    local arg1 = 125
    local arg2 = 0
    local list = {}
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit == caster then
      elseif unit == target then
      else
        local p2 = ed.edpSub(unit.position, target.position)
        p2[1] = p2[1] * caster.direction
        if skill.testPointInShape(p2, shape, arg1, arg2) then
          table.insert(list, unit)
        end
      end
    end
    if 0 < #list then
      for k, unit in ipairs(list) do
        unit:takeDamage(dmg * TitanTB.Titan_atk_ratio / caster.attribs.PDM, "Holy", "hp", caster, 1, 0)
      end
    end
    target:takeDamage(TitanTB.TitanTB_atk_mp, "Holy", "mp", caster, 1, 0)
    caster:takeHeal(TitanTB.TitanTB_atk_mp, "mp", caster)
  end
  if caster.TitanTB_atk3D_region then
    if not caster.TitanTB_atkD_count then
      caster.TitanTB_atkD_count = 1
    else
      caster.TitanTB_atkD_count = caster.TitanTB_atkD_count + 1
    end
    if caster.TitanTB_atkD_count >= TitanTB.Titan_atkD_countMax then
      caster.TitanTB_region_times = caster.TitanTB_region_times + 1
      caster.TitanTB_atkD_count = 0
    end
  end
end

function TitanTB.skillatk2A_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = TitanTB.TitanTB_atk2A_self_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  hero.TitanTB_atk2Aself_Buff = hero:addBuff(buff, hero)
end

function TitanTB.skillatk2A_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  if reason == "stun" then
    return true
  end
  return result, reason
end

function TitanTB.skillatk2A_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if target and target:isAlive() then
    for _, buff in ipairs(target.buff_list) do
      if buff.caster.camp ~= target.camp and buff.info.Dispel and buff:isCrlEftConflictWithUncontrollable() then
        buff.timer = 0
      end
    end
  end
end

function TitanTB.skillatk2A_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  if hero.TitanTB_atk2Aself_Buff then
    hero.TitanTB_atk2Aself_Buff.timer = 0
  end
end

function TitanTB.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  local skillatk4 = hero.skills.TitanTB_atk4
  local TitanTB_RemnantSkill2 = hero.skills.TitanTB_Remnant2
  local TitanTB_atk4_HPRatio = TitanTB.TitanTB_atk4_HPratio
  if hero and TitanTB_RemnantSkill2 then
    TitanTB_atk4_HPRatio = 15000
  end
  if skillatk4 and lost > TitanTB_atk4_HPRatio and skill and not skill.info["Ignore Shield"] then
    local overdamage = lost - TitanTB_atk4_HPRatio
    local max = skillatk4.info["Script Arg2"]
    if overdamage >= max then
      overdamage = max
    end
    lost = TitanTB_atk4_HPRatio
    TitanTB.add_Shield(hero, overdamage)
  end
  return lost
end

function TitanTB.skillatk2D_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function TitanTB.skillatk3A_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if caster.Titan_atk3Abuff and caster.Titan_atk3Abuff.timer > 0 then
    return nil
  end
  return result, reason
end

function TitanTB.skillatk3D_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if caster.TitanTB_atk3D_region then
    return nil
  end
  return result, reason
end

function TitanTB.skillatk3D_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function TitanTB.skillatk3D_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  caster.TitanTB_atk3D_region = nil
end

function TitanTB.skillatk3D_region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  for i, target in ipairs(caster.TitanTB_atk3_targetlist) do
    target[2] = target[2] - dt
  end
  if caster.TitanTB_region_times < 0 then
    region:terminate()
  end
end

function TitanTB.skillatk3D_region_takeRegionEffectOn(basefunc, region, unit)
  local caster = region.caster
  local skillatk3Ds = caster.skills.TitanTB_atk3Ds
  local targetinlist
  local TitanTB_atk3D_counttime = TitanTB.TitanTB_atk3D_counttime
  if caster.TitanTB_hasArcana > 1 and skillatk3Ds then
    TitanTB_atk3D_counttime = 2.5
  end
  local TitanTB_RemnantSkill1 = caster.skills.TitanTB_Remnant1
  if caster and TitanTB_RemnantSkill1 then
    TitanTB_atk3D_counttime = TitanTB_atk3D_counttime - 1
  end
  if #caster.TitanTB_atk3_targetlist > 0 then
    for i, target in ipairs(caster.TitanTB_atk3_targetlist) do
      if target[1] == unit then
        targetinlist = true
        if 0 >= target[2] then
          skillatk3Ds:takeEffectOn(unit, caster)
          target[2] = TitanTB_atk3D_counttime
          caster.TitanTB_region_times = caster.TitanTB_region_times - 1
        end
      end
    end
  end
  if not targetinlist then
    skillatk3Ds:takeEffectOn(unit, caster)
    table.insert(caster.TitanTB_atk3_targetlist, {unit, TitanTB_atk3D_counttime})
    caster.TitanTB_region_times = caster.TitanTB_region_times - 1
  end
end

function TitanTB.skillatk3D_createRegion(basefunc, skill)
  local region = basefunc(skill)
  local caster = skill.caster
  region.update = override(region.update, TitanTB.skillatk3D_region_update)
  region.takeRegionEffectOn = override(region.takeRegionEffectOn, TitanTB.skillatk3D_region_takeRegionEffectOn)
  region.terminate = override(region.terminate, TitanTB.skillatk3D_region_terminate)
  caster.TitanTB_region_times = TitanTB.TitanTB_region_times
  local TitanTB_RemnantSkill1 = caster.skills.TitanTB_Remnant1
  if caster and TitanTB_RemnantSkill1 then
    caster.TitanTB_region_times = caster.TitanTB_region_times + 4
  end
  if caster.TitanTB_hasArcana > 1 then
    caster.TitanTB_region_times = caster.TitanTB_region_times + 2
  end
  caster.TitanTB_atk3D_region = region
  return region
end

function TitanTB.skillatk3A_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function TitanTB.skillatk3A_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  if not buff.Venus_time then
    buff.Venus_time = TitanTB.Venus_atk_time
  else
    buff.Venus_time = buff.Venus_time + dt
  end
  if buff.Venus_time >= TitanTB.Venus_atk_time then
    local skillatk3As = hero.skills.TitanTB_atk3As
    if skillatk3As then
      skillatk3As:takeEffectAt(TitanTB.DOP_in_battlefield(hero, 150, hero.foecamp))
      buff.Venus_time = 0
    end
  end
  if (hero.currentActionStage == 2 or hero.currentActionStage == 4 or hero.currentActionStage == 6) and (4 > hero.TitanTB_hasArcana or not hero.TitanTB_hasArcana) then
    hero.Titan_atk3Abuff = nil
    buff.timer = 0
  end
end

function TitanTB.skillatk3A_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  skill.caster.Titan_atk3Abuff = buff
  buff.update = override(buff.update, TitanTB.skillatk3A_buff_update)
  return buff
end

function TitanTB.skillatk4_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local hp = caster.hp
  if hp ~= buff.TitanTB_previousHP then
    buff:setAttribute("AD", caster.attribs.AD * TitanTB.TitanTB_atk4_ADratio * hp / caster.attribs.HP)
    caster:rebuild()
  end
  buff.TitanTB_previousHP = hp
end

function TitanTB.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanTB_atk3_targetlist = {}
  if TitanTB.Fashion_ID1 and TitanTB.Fashion_ID1 == hero.fashion_id then
    hero:enterActionStageFromOneStage(3, 10077)
  elseif TitanTB.Fashion_ID2 and TitanTB.Fashion_ID2 == hero.fashion_id then
    hero:enterActionStageFromOneStage(5, 10077)
  end
  if hero.currentActionStage == 2 then
    hero:enterActionStageFromOneStage(1, 10077)
  elseif hero.currentActionStage == 4 then
    hero:enterActionStageFromOneStage(3, 10077)
  elseif hero.currentActionStage == 6 then
    hero:enterActionStageFromOneStage(5, 10077)
  end
  hero.Titan_atk3Abuff = nil
  local skillatk2D = hero.skills.TitanTB_atk2D
  if skillatk2D and not hero.config.is_summoned and 2 < hero.TitanTB_hasArcana then
    local originfo = skillatk2D.info
    skillatk2D.info = ed.wraptable(originfo, {CD = 7.5})
  end
end

function TitanTB.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanTB_atk4
  if not hero.first_in and skillatk4 then
    local bid = TitanTB.TitanTB_atk4_self_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.TitanTB_previousHP = 0
    buff.update = override(buff.update, TitanTB.skillatk4_buff_update)
    local buffresult = hero:addBuff(buff, hero)
    hero.first_in = true
  end
end

function TitanTB.hero_setMP(basefunc, self, mp)
  local config = {
    unit = self,
    mp = mp,
    mp_change = mp - self.mp
  }
  ed.engine:collectMPchange(config)
  local mp = config.mp
  local mp_change = config.mp_change
  local extra = mp - self.mp
  local IsMultiArena = ed.IsMultiArena()
  if 0 < extra and IsMultiArena then
    mp = self.mp + extra / 2
  end
  if mp > self.attribs.MP then
    local skillatk4 = self.skills.TitanTB_atk4
    if skillatk4 and (self.currentActionStage == 2 or self.currentActionStage == 4 or self.currentActionStage == 6) then
      TitanTB.add_Shield(self, (mp - self.attribs.MP) * TitanTB.TitanTB_atk4_mp_ratio)
      mp = self.attribs.MP
    else
      mp = self.attribs.MP
    end
  end
  if mp < 0 then
    mp = 0
  end
  self.mp = mp
  return mp_change
end

function TitanTB.init_hero(hero)
  local skillult = hero.skills.TitanTB_ult
  local skillatkD = hero.skills.TitanTB_atkD
  local skillatk2A = hero.skills.TitanTB_atk2A
  local skillatk2As = hero.skills.TitanTB_atk2As
  local skillatk2D = hero.skills.TitanTB_atk2D
  local skillatk3A = hero.skills.TitanTB_atk3A
  local skillatk3D = hero.skills.TitanTB_atk3D
  hero.TitanTB_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.start = override(skillult.start, TitanTB.skillult_start)
    skillult.finish = override(skillult.finish, TitanTB.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanTB.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanTB.skillult_canCastWithTarget)
  end
  if skillatkD then
    skillatkD.takeEffectOn = override(skillatkD.takeEffectOn, TitanTB.skillatkD_takeEffectOn)
  end
  if skillatk2D then
    skillatk2D.createBuff = override(skillatk2D.createBuff, TitanTB.skillatk2D_createBuff)
  end
  if skillatk2A then
    skillatk2A.start = override(skillatk2A.start, TitanTB.skillatk2A_start)
    skillatk2A.finish = override(skillatk2A.finish, TitanTB.skillatk2A_finish)
    skillatk2A.canCastWithTarget = override(skillatk2A.canCastWithTarget, TitanTB.skillatk2A_canCastWithTarget)
    skillatk2A.takeEffectOn = override(skillatk2A.takeEffectOn, TitanTB.skillatk2A_takeEffectOn)
  end
  if skillatk3A then
    skillatk3A.onAttackFrame = override(skillatk3A.onAttackFrame, TitanTB.skillatk3A_onAttackFrame)
    skillatk3A.createBuff = override(skillatk3A.createBuff, TitanTB.skillatk3A_createBuff)
    skillatk3A.canCastWithTarget = override(skillatk3A.canCastWithTarget, TitanTB.skillatk3A_canCastWithTarget)
  end
  if skillatk3D then
    skillatk3D.onAttackFrame = override(skillatk3D.onAttackFrame, TitanTB.skillatk3D_onAttackFrame)
    skillatk3D.createRegion = override(skillatk3D.createRegion, TitanTB.skillatk3D_createRegion)
    skillatk3D.canCastWithTarget = override(skillatk3D.canCastWithTarget, TitanTB.skillatk3D_canCastWithTarget)
  end
  hero.die = override(hero.die, TitanTB.hero_die)
  hero.reset = override(hero.reset, TitanTB.hero_reset)
  hero.update = override(hero.update, TitanTB.hero_update)
  hero.setMP = override(hero.setMP, TitanTB.hero_setMP)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanTB.hero_getLostHPAfterImmunity)
  hero:setActionStageChangeByManual(true)
  return hero
end

return TitanTB.init_hero
