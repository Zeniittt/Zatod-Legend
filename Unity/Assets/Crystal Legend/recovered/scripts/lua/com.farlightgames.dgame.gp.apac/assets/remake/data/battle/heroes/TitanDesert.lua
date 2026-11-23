module("ed.battlehero", package.seeall)
local ed = ed
TitanDesert = {}
TitanDesert.TitanDesert_fashionID = 101161
TitanDesert.ragelosthp = 35000
TitanDesert.rage2losthp = 15000
TitanDesert.stage2hp = 1750000
TitanDesert.stage2ragelosthp = 7500

function TitanDesert.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
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
  else
    return caster.position
  end
end

function TitanDesert.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2s = caster.skills.TitanDesert_atk2s
  local TitanDesert_atk2_position = TitanDesert.DOP_in_battlefield(caster, 175, caster.foecamp)
  caster.skillatk2_counter = skill.attack_counter
  if skill.attack_counter == 0 then
    if ed.run_with_scene and TitanDesert_atk2_position then
      local effect_name = "eff_point_TitanDesert_atk2.cha"
      if TitanDesert.TitanDesert_fashionID and TitanDesert.TitanDesert_fashionID == caster.fashion_id then
        effect_name = "eff_point_TitanDesert_skin_atk2.cha"
      end
      local origin = TitanDesert_atk2_position
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          caster.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
    basefunc(skill)
  elseif skill.attack_counter > 0 then
    if skillatk2s and caster:isAlive() then
      skillatk2s:takeEffectAt(TitanDesert_atk2_position, caster)
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanDesert.skillatk2s_takeEffectOn(basefunc, skill, target, source, shift)
  local hit, dmg, Crit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanDesert_atk3
  if caster and skillatk3 and hit and target and target:isAlive() then
    skillatk3:takeEffectOn(target, caster)
  end
  return hit, dmg, Crit
end

function TitanDesert.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  if TitanDesert.TitanDesert_fashionID and TitanDesert.TitanDesert_fashionID == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_TitanDesert_skin_atk3.cha")
  end
  buff.onRemoved = override(buff.onRemoved, TitanDesert.skillatk3_BuffonRemoved)
  return buff
end

function TitanDesert.skillatk3_BuffonRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  if not ed.engine.beingEnd then
    local skillatk3s = caster.skills.TitanDesert_atk3s
    if skillatk3s then
      skillatk3s:takeEffectAt(owner.position, caster)
    end
  end
end

function TitanDesert.skillatk4_selectTarget(basefunc, skill, default)
  local target_type = skill.info["Target Type"]
  local selector = skill:target_selector()
  local Ignore = skill:Ignore_Target_Type()
  local max = -math.huge
  local chosen
  local caster = skill.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
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
  return skill.target
end

function TitanDesert.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  caster.skillatk4_casting = true
  local bid = 11011606
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanDesert.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  skill.cd_remaining = skill.info.CD
end

function TitanDesert.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local bid = 11011607
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff1 = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff1, caster)
  local bid2 = 11011610
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = ed.BuffCreate(binfo2, caster, caster)
  caster:addBuff(buff2, caster)
  caster:setHpVisible(false)
  caster:setFuryVisible(false)
  basefunc(skill)
end

function TitanDesert.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  caster.skillatk4_self_buff = false
  caster.skillatk4_self_buff_reply = false
  buff.update = override(buff.update, TitanDesert.skillatk4_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, TitanDesert.skillatk4_buffOnRemoved)
  if TitanDesert.TitanDesert_fashionID and TitanDesert.TitanDesert_fashionID == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_TitanDesert_skin_atk4.cha")
  end
  return buff
end

function TitanDesert.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local hpr = -buff.info.HPR
  local mpr = -buff.info.MPR
  local bufftime = buff.timer
end

function TitanDesert.skillatk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if ed.run_with_scene and owner.position then
    local effect_name = "eff_point_TitanDesert_atk4.cha"
    if TitanDesert.TitanDesert_fashionID and TitanDesert.TitanDesert_fashionID == caster.fashion_id then
      effect_name = "eff_point_TitanDesert_skin_atk4.cha"
    end
    local origin = owner.position
    if effect_name then
      ed.scene:playEffectOnScene(effect_name, origin, {
        owner.direction * 1,
        1
      }, nil, 1)
    end
  end
  local skillatk4s = caster.skills.TitanDesert_atk4s
  if skillatk4s then
    caster.global_cd = 0
    skillatk4s.cd_remaining = 0
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 11011610 or tbuff.info.ID == 11011604 then
        tbuff.timer = -1
      end
    end
  else
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 11011606 or tbuff.info.ID == 11011604 or tbuff.info.ID == 11011607 or tbuff.info.ID == 11011610 then
        tbuff.timer = -1
      end
    end
    caster.skillatk4_casting = false
  end
end

function TitanDesert.skillatk4s_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11011607 then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function TitanDesert.skillatk4s_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 11011606 then
      tbuff.timer = -1
    end
  end
  skill.caster:setHpVisible(true)
  skill.caster:setFuryVisible(true)
  skill.caster.skillatk4_casting = false
end

function TitanDesert.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  caster.skillatk4_casting = true
  local bid = 11011605
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanDesert.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 11011605 then
      tbuff.timer = -1
    end
  end
end

function TitanDesert.skillult_canCastWithTarget(basefunc, skill, target)
  if skill.caster.skillatk4_casting then
    return false, "skillatk4_casting"
  end
  return basefunc(skill, target)
end

function TitanDesert.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  local skillults = caster.skills.TitanDesert_ults
  if skillults then
    if caster.TitanDesert_skillult_region then
      caster.skillult_region_lv = caster.skillult_region_lv + 1
    else
      skillults.target = caster
      local TitanDesert_region = skillults:createRegion()
      TitanDesert_region.position = caster.position
      ed.engine:addRegion(TitanDesert_region)
    end
  end
end

function TitanDesert.skillults_createRegion(basefunc, skill)
  local region = basefunc(skill)
  local caster = skill.caster
  caster.TitanDesert_skillult_region = region
  caster.skillult_region_lv = 1
  return region
end

function TitanDesert.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local skillult = caster.skills.TitanDesert_ult
  local HPR_Count = -skillult.info["Script Arg2"]
  local HAST_Lost = -skillult.info["Script Arg3"]
  buff:setAttribute("HAST", HAST_Lost)
  buff:setAttribute("MSPD", HAST_Lost)
  if caster.skillult_region_lv then
    buff:setAttribute("HPR", HPR_Count * caster.skillult_region_lv)
  end
  buff.update = override(buff.update, TitanDesert.skillults_buff_update)
  return buff
end

function TitanDesert.skillults_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanDesert_ult
  local HPR_Count = -skillult.info["Script Arg2"]
  if caster.skillult_region_lv and caster.skillult_region_lv ~= owner.TitanDesert_skillult_region_lastlv then
    buff:setAttribute("HPR", HPR_Count * caster.skillult_region_lv)
  end
  owner.TitanDesert_skillult_region_lastlv = caster.skillult_region_lv
end

function TitanDesert.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.skillatk4_casting = false
  hero.skillatk4_self_buff = false
  hero.skillatk4_self_buff_reply = false
  hero.skillatk3_first_cast = true
  hero.dying_skillatk4_AlreadyUse = false
  hero.TitanDesert_skillult_region = nil
  hero.skillult_region_lv = 0
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, TitanDesert.rage_buff_update)
  hero.lastrageStack = 0
end

function TitanDesert.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanDesert.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanDesert.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanDesert.ragelosthp
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
    while hero.lastRageHp - hero.hp >= TitanDesert.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanDesert.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanDesert.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
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

function TitanDesert.init_hero(hero)
  local skillult = hero.skills.TitanDesert_ult
  local skillults = hero.skills.TitanDesert_ults
  local skillatk = hero.skills.TitanDesert_atk
  local skillatk2 = hero.skills.TitanDesert_atk2
  local skillatk2s = hero.skills.TitanDesert_atk2s
  local skillatk3 = hero.skills.TitanDesert_atk3
  local skillatk3s = hero.skills.TitanDesert_atk3s
  local skillatk4 = hero.skills.TitanDesert_atk4
  local skillatk4s = hero.skills.TitanDesert_atk4s
  hero.reset = override(hero.reset, TitanDesert.hero_reset)
  hero.update = override(hero.update, TitanDesert.hero_update)
  hero.TitanDesert_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if TitanDesert.TitanDesert_fashionID and TitanDesert.TitanDesert_fashionID == hero.fashion_id then
    if skillatk then
      local originfo = skillatk.info
      skillatk.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_TitanDesert_skin_atk.cha",
        ["Impact Effect"] = "eff_impact_TitanDesert_skin_atk.cha"
      })
    end
    if skillults then
      local originfo = skillults.info
      skillults.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_TitanDesert_skin_ult.cha"
      })
    end
    if skillatk3s then
      local originfo = skillatk3s.info
      skillatk3s.info = ed.wraptable(originfo, {
        ["Point Effect"] = "eff_point_TitanDesert_skin_atk3.cha"
      })
    end
  end
  if skillatk2 and skillatk2s then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanDesert.skillatk2_onAttackFrame)
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, TitanDesert.skillatk2s_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanDesert.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.selectTarget = override(skillatk4.selectTarget, TitanDesert.skillatk4_selectTarget)
    skillatk4.start = override(skillatk4.start, TitanDesert.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanDesert.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanDesert.skillatk4_onAttackFrame)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanDesert.skillatk4_createBuff)
  end
  if skillatk4s then
    skillatk4s.onAttackFrame = override(skillatk4s.onAttackFrame, TitanDesert.skillatk4s_onAttackFrame)
    skillatk4s.finish = override(skillatk4s.finish, TitanDesert.skillatk4s_finish)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanDesert.skillult_start)
    skillult.finish = override(skillult.finish, TitanDesert.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanDesert.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanDesert.skillult_canCastWithTarget)
  end
  if skillults then
    skillults.createRegion = override(skillults.createRegion, TitanDesert.skillults_createRegion)
    skillults.createBuff = override(skillults.createBuff, TitanDesert.skillults_createBuff)
  end
  return hero
end

return TitanDesert.init_hero
