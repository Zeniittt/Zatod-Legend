module("ed.battlehero", package.seeall)
local ed = ed
GMBOSSTitanTB = {}
GMBOSSTitanTB.ult_shield_buffid = 1528
GMBOSSTitanTB.ult_shield_ratio = 0.3
GMBOSSTitanTB.ult_Devil_buffid = 1710
GMBOSSTitanTB.ult2_Devil_buffid = 1530
GMBOSSTitanTB.ult2_Devil_fashion_buffid = 1680
GMBOSSTitanTB.Venus_atk_time = 6
GMBOSSTitanTB.GMBOSSTitanTB_atk3D_counttime = 6
GMBOSSTitanTB.GMBOSSTitanTB_atk4_self_bid = 1531
GMBOSSTitanTB.GMBOSSTitanTB_atk4_ADratio = 0.3
GMBOSSTitanTB.Titan_atk_ratio = 0.75
GMBOSSTitanTB.GMBOSSTitanTB_atk_mp = 25
GMBOSSTitanTB.GMBOSSTitanTB_ult_basicADratio = 0.0025
GMBOSSTitanTB.GMBOSSTitanTB_ult_basicMRratio = 0.002
GMBOSSTitanTB.GMBOSSTitanTB_ult_basicDODG = 0.5
GMBOSSTitanTB.GMBOSSTitanTB_ult2_basicCRIT = 2
GMBOSSTitanTB.GMBOSSTitanTB_ult2_basicHIT = 1
GMBOSSTitanTB.GMBOSSTitanTB_region_times = 4
GMBOSSTitanTB.Titan_atkD_countMax = 4
GMBOSSTitanTB.GMBOSSTitanTB_atk4_HPratio = 1000000
GMBOSSTitanTB.GMBOSSTitanTB_atk4_mp_ratio = 10
GMBOSSTitanTB.GMBOSSTitanTB_atk2A_self_bid = 1536
GMBOSSTitanTB.Fashion_ID1 = 100771
GMBOSSTitanTB.Fashion_ID2 = 100772

function GMBOSSTitanTB.shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.GMBOSSTitanTB_shield = nil
end

function GMBOSSTitanTB.add_Shield(hero, shield_vaule)
  if not hero.GMBOSSTitanTB_shield then
    local bid = GMBOSSTitanTB.ult_shield_buffid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local shield_buff = ed.BuffCreate(binfo, hero, hero)
    shield_buff.onRemoved = override(shield_buff.onRemoved, GMBOSSTitanTB.shield_onRemoved)
    shield_buff.shield = shield_vaule
    hero.GMBOSSTitanTB_shield = hero:addBuff(shield_buff, hero)
  else
    local buff = hero.GMBOSSTitanTB_shield
    local shield = buff.shield
    buff.shield = shield + shield_vaule
    buff.timer = buff.info.Time
    if buff.shield <= 0 and hero.GMBOSSTitanTB_shield then
      hero:removeBuff(hero.GMBOSSTitanTB_shield)
    end
  end
end

function GMBOSSTitanTB.DOP_in_battlefield(caster, radius, camp)
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

function GMBOSSTitanTB.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.GMBOSSTitanTB_atk3D_region then
    hero.GMBOSSTitanTB_atk3D_region:terminate()
  end
end

function GMBOSSTitanTB.skillult_start(basefunc, self, target)
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

function GMBOSSTitanTB.skillult_devilbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  basefunc(buff)
  if caster.GMBOSSTitanTB_devilBuff then
    caster.GMBOSSTitanTB_devilBuff = nil
  end
end

function GMBOSSTitanTB.skillult_devilbuff2_onRemoved(basefunc, buff)
  local caster = buff.caster
  basefunc(buff)
  if caster.GMBOSSTitanTB_devilBuff2 then
    caster.GMBOSSTitanTB_devilBuff2 = nil
  end
end

function GMBOSSTitanTB.skillult_devilbuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  if hero.mp <= 25 then
    buff.timer = 0
  end
end

function GMBOSSTitanTB.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    if caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 then
      caster.GMBOSSTitanTB_ultchange = true
      GMBOSSTitanTB.add_Shield(caster, caster.attribs.HP * GMBOSSTitanTB.ult_shield_ratio)
      local bid = GMBOSSTitanTB.ult_Devil_buffid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      local level = skill.level
      buff.onRemoved = override(buff.onRemoved, GMBOSSTitanTB.skillult_devilbuff_onRemoved)
      buff:setAttribute("AD", GMBOSSTitanTB.GMBOSSTitanTB_ult_basicADratio * level * caster.attribs.AD)
      buff:setAttribute("MR", GMBOSSTitanTB.GMBOSSTitanTB_ult_basicMRratio * level * caster.attribs.MR)
      if caster.stars >= 6 then
        buff:setAttribute("DODG", (GMBOSSTitanTB.GMBOSSTitanTB_ult_basicDODG - (10 - caster.stars) * 0.1) * level)
      else
        buff:setAttribute("DODG", GMBOSSTitanTB.GMBOSSTitanTB_ult_basicDODG * level * 0.1)
      end
      caster.GMBOSSTitanTB_devilBuff = buff
      caster:addBuff(buff, caster)
      caster:setPosition({
        caster.position[1] - 200 * caster:getInitDir(),
        caster.position[2]
      })
    elseif caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
      local bid = GMBOSSTitanTB.ult2_Devil_buffid
      if caster.currentActionStage == 4 or caster.currentActionStage == 6 then
        bid = GMBOSSTitanTB.ult2_Devil_fashion_buffid
      end
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      local level = skill.level
      buff.onRemoved = override(buff.onRemoved, GMBOSSTitanTB.skillult_devilbuff2_onRemoved)
      buff.update = override(buff.update, GMBOSSTitanTB.skillult_devilbuff2_update)
      if caster.stars >= 6 then
        buff:setAttribute("CRIT", (GMBOSSTitanTB.GMBOSSTitanTB_ult2_basicCRIT - (10 - caster.stars) * 0.3) * level)
      else
        buff:setAttribute("CRIT", GMBOSSTitanTB.GMBOSSTitanTB_ult2_basicCRIT * level * 0.1)
      end
      buff:setAttribute("HIT", GMBOSSTitanTB.GMBOSSTitanTB_ult2_basicHIT * level)
      caster.GMBOSSTitanTB_devilBuff2 = buff
      caster:addBuff(buff, caster)
    end
  end
end

function GMBOSSTitanTB.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.GMBOSSTitanTB_ultchange then
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
    if panel and caster.name == "GMBOSSTitanTB" then
      if caster.currentActionStage == 2 then
        panel:setPortrait("UI/DOTA-HERO/GMBOSSTitanTB2.png")
      elseif caster.currentActionStage == 4 then
        panel:setPortrait("UI/DOTA-HERO/GMBOSSTitanTB_fashion1_1.jpg")
      elseif caster.currentActionStage == 6 then
        panel:setPortrait("UI/DOTA-HERO/GMBOSSTitanTB_fashion2_1.jpg")
      end
    end
  end
  local skillatk3A = caster.skills.GMBOSSTitanTB_atk3A
  if not caster.Titan_atk3Abuff and skillatk3A and 3 < caster.GMBOSSTitanTB_hasArcana then
    skillatk3A:takeEffectOn(caster, caster)
  end
end

function GMBOSSTitanTB.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if result then
    if caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
      if caster.GMBOSSTitanTB_devilBuff2 or caster.current_skill == caster.manual_skill then
        return nil
      end
    elseif (caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5) and caster.current_skill == caster.manual_skill then
      return nil
    end
  end
  return result
end

function GMBOSSTitanTB.skillatkD_takeEffectOn(basefunc, skill, target, source, shift)
  local result, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result and target and target:isAlive() and caster.GMBOSSTitanTB_devilBuff2 then
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
        unit:takeDamage(dmg * GMBOSSTitanTB.Titan_atk_ratio / caster.attribs.PDM, "Holy", "hp", caster, 1, 0)
      end
    end
    target:takeDamage(GMBOSSTitanTB.GMBOSSTitanTB_atk_mp, "Holy", "mp", caster, 1, 0)
    caster:takeHeal(GMBOSSTitanTB.GMBOSSTitanTB_atk_mp, "mp", caster)
  end
  if caster.GMBOSSTitanTB_atk3D_region then
    if not caster.GMBOSSTitanTB_atkD_count then
      caster.GMBOSSTitanTB_atkD_count = 1
    else
      caster.GMBOSSTitanTB_atkD_count = caster.GMBOSSTitanTB_atkD_count + 1
    end
    if caster.GMBOSSTitanTB_atkD_count >= GMBOSSTitanTB.Titan_atkD_countMax then
      caster.GMBOSSTitanTB_region_times = caster.GMBOSSTitanTB_region_times + 1
      caster.GMBOSSTitanTB_atkD_count = 0
    end
  end
end

function GMBOSSTitanTB.skillatk2A_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = GMBOSSTitanTB.GMBOSSTitanTB_atk2A_self_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  hero.GMBOSSTitanTB_atk2Aself_Buff = hero:addBuff(buff, hero)
end

function GMBOSSTitanTB.skillatk2A_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  if reason == "stun" then
    return true
  end
  return result, reason
end

function GMBOSSTitanTB.skillatk2A_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if target and target:isAlive() then
    for _, buff in ipairs(target.buff_list) do
      if buff.caster.camp ~= target.camp and buff.info.Dispel and buff:isCrlEftConflictWithUncontrollable() then
        buff.timer = 0
      end
    end
  end
end

function GMBOSSTitanTB.skillatk2A_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  if hero.GMBOSSTitanTB_atk2Aself_Buff then
    hero.GMBOSSTitanTB_atk2Aself_Buff.timer = 0
  end
end

function GMBOSSTitanTB.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  local skillatk4 = hero.skills.GMBOSSTitanTB_atk4
  if skillatk4 and lost > GMBOSSTitanTB.GMBOSSTitanTB_atk4_HPratio and skill and not skill.info["Ignore Shield"] then
    local overdamage = lost - GMBOSSTitanTB.GMBOSSTitanTB_atk4_HPratio
    local max = skillatk4.info["Script Arg2"]
    if overdamage >= max then
      overdamage = max
    end
    lost = GMBOSSTitanTB.GMBOSSTitanTB_atk4_HPratio
    GMBOSSTitanTB.add_Shield(hero, overdamage)
  end
  return lost
end

function GMBOSSTitanTB.skillatk2D_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function GMBOSSTitanTB.skillatk3A_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if caster.Titan_atk3Abuff and caster.Titan_atk3Abuff.timer > 0 then
    return nil
  end
  return result, reason
end

function GMBOSSTitanTB.skillatk3D_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if caster.GMBOSSTitanTB_atk3D_region then
    return nil
  end
  return result, reason
end

function GMBOSSTitanTB.skillatk3D_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function GMBOSSTitanTB.skillatk3D_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  caster.GMBOSSTitanTB_atk3D_region = nil
end

function GMBOSSTitanTB.skillatk3D_region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  for i, target in ipairs(caster.GMBOSSTitanTB_atk3_targetlist) do
    target[2] = target[2] - dt
  end
  if caster.GMBOSSTitanTB_region_times < 0 then
    region:terminate()
  end
end

function GMBOSSTitanTB.skillatk3D_region_takeRegionEffectOn(basefunc, region, unit)
  local caster = region.caster
  local skillatk3Ds = caster.skills.GMBOSSTitanTB_atk3Ds
  local targetinlist
  if #caster.GMBOSSTitanTB_atk3_targetlist > 0 then
    for i, target in ipairs(caster.GMBOSSTitanTB_atk3_targetlist) do
      if target[1] == unit then
        targetinlist = true
        if 0 >= target[2] then
          skillatk3Ds:takeEffectOn(unit, caster)
          target[2] = 1 < caster.GMBOSSTitanTB_hasArcana and 2.5 or GMBOSSTitanTB.GMBOSSTitanTB_atk3D_counttime
          caster.GMBOSSTitanTB_region_times = caster.GMBOSSTitanTB_region_times - 1
        end
      end
    end
  end
  if not targetinlist then
    skillatk3Ds:takeEffectOn(unit, caster)
    table.insert(caster.GMBOSSTitanTB_atk3_targetlist, {
      unit,
      1 < caster.GMBOSSTitanTB_hasArcana and 2.5 or GMBOSSTitanTB.GMBOSSTitanTB_atk3D_counttime
    })
    caster.GMBOSSTitanTB_region_times = caster.GMBOSSTitanTB_region_times - 1
  end
end

function GMBOSSTitanTB.skillatk3D_createRegion(basefunc, skill)
  local region = basefunc(skill)
  local caster = skill.caster
  region.update = override(region.update, GMBOSSTitanTB.skillatk3D_region_update)
  region.takeRegionEffectOn = override(region.takeRegionEffectOn, GMBOSSTitanTB.skillatk3D_region_takeRegionEffectOn)
  region.terminate = override(region.terminate, GMBOSSTitanTB.skillatk3D_region_terminate)
  caster.GMBOSSTitanTB_region_times = GMBOSSTitanTB.GMBOSSTitanTB_region_times
  if caster.GMBOSSTitanTB_hasArcana > 1 then
    caster.GMBOSSTitanTB_region_times = 6
  end
  caster.GMBOSSTitanTB_atk3D_region = region
  return region
end

function GMBOSSTitanTB.skillatk3A_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function GMBOSSTitanTB.skillatk3A_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  if not buff.Venus_time then
    buff.Venus_time = GMBOSSTitanTB.Venus_atk_time
  else
    buff.Venus_time = buff.Venus_time + dt
  end
  if buff.Venus_time >= GMBOSSTitanTB.Venus_atk_time then
    local skillatk3As = hero.skills.GMBOSSTitanTB_atk3As
    if skillatk3As then
      skillatk3As:takeEffectAt(GMBOSSTitanTB.DOP_in_battlefield(hero, 150, hero.foecamp))
      buff.Venus_time = 0
    end
  end
  if (hero.currentActionStage == 2 or hero.currentActionStage == 4 or hero.currentActionStage == 6) and (4 > hero.GMBOSSTitanTB_hasArcana or not hero.GMBOSSTitanTB_hasArcana) then
    hero.Titan_atk3Abuff = nil
    buff.timer = 0
  end
end

function GMBOSSTitanTB.skillatk3A_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  skill.caster.Titan_atk3Abuff = buff
  buff.update = override(buff.update, GMBOSSTitanTB.skillatk3A_buff_update)
  return buff
end

function GMBOSSTitanTB.skillatk4_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local hp = caster.hp
  if hp ~= buff.GMBOSSTitanTB_previousHP then
    buff:setAttribute("AD", caster.attribs.AD * GMBOSSTitanTB.GMBOSSTitanTB_atk4_ADratio * hp / caster.attribs.HP)
    caster:rebuild()
  end
  buff.GMBOSSTitanTB_previousHP = hp
end

function GMBOSSTitanTB.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.GMBOSSTitanTB_atk3_targetlist = {}
  if GMBOSSTitanTB.Fashion_ID1 and GMBOSSTitanTB.Fashion_ID1 == hero.fashion_id then
    hero:enterActionStageFromOneStage(3, 10077)
  elseif GMBOSSTitanTB.Fashion_ID2 and GMBOSSTitanTB.Fashion_ID2 == hero.fashion_id then
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
  local skillatk2D = hero.skills.GMBOSSTitanTB_atk2D
  if skillatk2D and not hero.config.is_summoned and 2 < hero.GMBOSSTitanTB_hasArcana then
    local originfo = skillatk2D.info
    skillatk2D.info = ed.wraptable(originfo, {CD = 7.5})
  end
end

function GMBOSSTitanTB.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.GMBOSSTitanTB_atk4
  if not hero.first_in and skillatk4 then
    local bid = GMBOSSTitanTB.GMBOSSTitanTB_atk4_self_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.GMBOSSTitanTB_previousHP = 0
    buff.update = override(buff.update, GMBOSSTitanTB.skillatk4_buff_update)
    local buffresult = hero:addBuff(buff, hero)
    hero.first_in = true
  end
end

function GMBOSSTitanTB.hero_setMP(basefunc, self, mp)
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
    local skillatk4 = self.skills.GMBOSSTitanTB_atk4
    if skillatk4 and (self.currentActionStage == 2 or self.currentActionStage == 4 or self.currentActionStage == 6) then
      GMBOSSTitanTB.add_Shield(self, (mp - self.attribs.MP) * GMBOSSTitanTB.GMBOSSTitanTB_atk4_mp_ratio)
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

function GMBOSSTitanTB.init_hero(hero)
  local skillult = hero.skills.GMBOSSTitanTB_ult
  local skillatkD = hero.skills.GMBOSSTitanTB_atkD
  local skillatk2A = hero.skills.GMBOSSTitanTB_atk2A
  local skillatk2As = hero.skills.GMBOSSTitanTB_atk2As
  local skillatk2D = hero.skills.GMBOSSTitanTB_atk2D
  local skillatk3A = hero.skills.GMBOSSTitanTB_atk3A
  local skillatk3D = hero.skills.GMBOSSTitanTB_atk3D
  hero.GMBOSSTitanTB_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.start = override(skillult.start, GMBOSSTitanTB.skillult_start)
    skillult.finish = override(skillult.finish, GMBOSSTitanTB.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GMBOSSTitanTB.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, GMBOSSTitanTB.skillult_canCastWithTarget)
  end
  if skillatkD then
    skillatkD.takeEffectOn = override(skillatkD.takeEffectOn, GMBOSSTitanTB.skillatkD_takeEffectOn)
  end
  if skillatk2D then
    skillatk2D.createBuff = override(skillatk2D.createBuff, GMBOSSTitanTB.skillatk2D_createBuff)
  end
  if skillatk2A then
    skillatk2A.start = override(skillatk2A.start, GMBOSSTitanTB.skillatk2A_start)
    skillatk2A.finish = override(skillatk2A.finish, GMBOSSTitanTB.skillatk2A_finish)
    skillatk2A.canCastWithTarget = override(skillatk2A.canCastWithTarget, GMBOSSTitanTB.skillatk2A_canCastWithTarget)
    skillatk2A.takeEffectOn = override(skillatk2A.takeEffectOn, GMBOSSTitanTB.skillatk2A_takeEffectOn)
  end
  if skillatk3A then
    skillatk3A.onAttackFrame = override(skillatk3A.onAttackFrame, GMBOSSTitanTB.skillatk3A_onAttackFrame)
    skillatk3A.createBuff = override(skillatk3A.createBuff, GMBOSSTitanTB.skillatk3A_createBuff)
    skillatk3A.canCastWithTarget = override(skillatk3A.canCastWithTarget, GMBOSSTitanTB.skillatk3A_canCastWithTarget)
  end
  if skillatk3D then
    skillatk3D.onAttackFrame = override(skillatk3D.onAttackFrame, GMBOSSTitanTB.skillatk3D_onAttackFrame)
    skillatk3D.createRegion = override(skillatk3D.createRegion, GMBOSSTitanTB.skillatk3D_createRegion)
    skillatk3D.canCastWithTarget = override(skillatk3D.canCastWithTarget, GMBOSSTitanTB.skillatk3D_canCastWithTarget)
  end
  hero.die = override(hero.die, GMBOSSTitanTB.hero_die)
  hero.reset = override(hero.reset, GMBOSSTitanTB.hero_reset)
  hero.update = override(hero.update, GMBOSSTitanTB.hero_update)
  hero.setMP = override(hero.setMP, GMBOSSTitanTB.hero_setMP)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, GMBOSSTitanTB.hero_getLostHPAfterImmunity)
  hero:setActionStageChangeByManual(true)
  return hero
end

return GMBOSSTitanTB.init_hero
