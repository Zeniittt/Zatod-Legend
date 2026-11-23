module("ed.battlehero", package.seeall)
local ed = ed
Enigma = {}
Enigma.bh_absorb_r = 150
Enigma.bh_start_time = 2
Enigma.blackhole_time = 12
Enigma.knock_count = 0
Enigma.bh_terminate_r = 100
Enigma.blackhole_projectile_max = 4
Enigma.blackhole_projectile_ratio = 0.25
Enigma.ult_r = 30
Enigma.sps_max = 100
Enigma.san_min_distance = 100
Enigma.sps_min = 25
Enigma.san_max_distance = 600
Enigma.lockhp_bid = 4087
Enigma.lockHpSmall = "UI/alpha/1080P/hp_gray_small.png"

function Enigma.selectPosition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      x = i
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 < maxcount then
    return x
  end
  if maxcount <= 0 then
    return ed.engine.stage_rect.maxX / 2
  end
end

function Enigma.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.ult_region then
    hero.ult_region:terminate()
  end
  if hero.atk2_region then
    hero.atk2_region:terminate()
  end
  if hero.small_blackhole and hero.small_blackhole:isAlive() then
    hero.small_blackhole:die()
  end
end

function Enigma.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillenter = hero.skills.Enigma_enter
  if skillenter then
    local bid = 651
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
  end
end

function Enigma.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_name = "eff_point_Enigma_ult.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, -1)
    skill.ult_effect1 = effect
  end
end

function Enigma.skillult_finish(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene and skill.ult_effect1 then
    ed.scene:removeEffect(skill.ult_effect1, -1)
  end
end

function Enigma.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  local dir
  local originfo = skill.info
  if attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter == 1 then
    basefunc(skill)
    local region_position = {
      Enigma.selectPosition(skill, 150),
      0
    }
    caster.ult_region_position = region_position
    local skillults = caster.skills.Enigma_ults
    if skill.ult_region then
      skill.ult_region:terminate()
    end
    if skillults then
      skillults.target = caster
      local region = skillults:createRegion()
      region.position = region_position
      skill.ult_region = region
      caster.ult_region = region
      ed.engine:addRegion(region)
    end
    if ed.run_with_scene then
      if skill.ult_effect1 then
        ed.scene:removeEffect(skill.ult_effect1, -1)
      end
      local effect_name = "eff_point_Enigma_ult3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, -1)
      skill.ult_effect1 = effect
    end
  end
end

function Enigma.ultregion_update(basefunc, region, dt)
  basefunc(region, dt)
  if not region.effecton then
    if ed.run_with_scene then
      local effect_name = "eff_point_Enigma_ult2.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, region.position, {1, 1}, nil, -1)
      effect:setZOrder(9999)
      region.scene_effect = effect
    end
    region.effecton = true
  end
end

function Enigma.ultregion_terminate(basefunc, region)
  if ed.run_with_scene and region.scene_effect then
    ed.scene:removeEffect(region.scene_effect, -1)
  end
  basefunc(region)
end

function Enigma.skillults_createRegion(basefunc, skill)
  local ultregion = basefunc(skill)
  ultregion.update = override(ultregion.update, Enigma.ultregion_update)
  ultregion.terminate = override(ultregion.terminate, Enigma.ultregion_terminate)
  return ultregion
end

function Enigma.ultsbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.knock_count = buff.knock_count - 1
  local caster = buff.caster
  local owner = buff.owner
  local region_position = caster.ult_region_position
  local time = 0.05
  local distance = -2
  local distanceplus = 0
  local distance_last = -2
  local direction = {1, 0}
  local DistanceSQ = ed.edpDistanceSQ(owner.position, region_position)
  if buff.knock_count < 0 then
    if owner.position[1] == region_position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    elseif DistanceSQ < Enigma.ult_r * Enigma.ult_r then
      local directionold = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      direction[1] = -directionold[2]
      direction[2] = directionold[1]
      distance_last = distance + distanceplus
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = distance + distanceplus * (150 - math.sqrt(DistanceSQ)) / (150 - Enigma.ult_r)
    end
    owner:knockup(time, ed.edpMult(direction, distance_last), true)
    buff.knock_count = Enigma.knock_count
  end
end

function Enigma.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Enigma.ultsbuff_update)
  buff.knock_count = Enigma.knock_count
  return buff
end

function Enigma.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local skillatk2s = caster.skills.Enigma_atk2s
  if skillatk2s and location then
    skillatk2s.target = caster
    local region = skillatk2s:createRegion()
    region.position = location
    caster.atk2_region = region
    ed.engine:addRegion(region)
  end
end

function Enigma.atk2region_update(basefunc, region, dt)
  basefunc(region, dt)
  if not region.effecton then
    if ed.run_with_scene then
      local effect_name = "eff_point_Enigma_atk2.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, region.position, {1, 1}, nil, -1)
      region.scene_effect = effect
    end
    region.effecton = true
  end
end

function Enigma.atk2region_terminate(basefunc, region)
  if ed.run_with_scene and region.scene_effect then
    ed.scene:removeEffect(region.scene_effect, -1)
  end
  basefunc(region)
end

function Enigma.skillatk2s_createRegion(basefunc, skill)
  local atk2region = basefunc(skill)
  atk2region.update = override(atk2region.update, Enigma.atk2region_update)
  atk2region.terminate = override(atk2region.terminate, Enigma.atk2region_terminate)
  return atk2region
end

function Enigma.atk2sbuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local havebuff1131
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 1131 then
      havebuff1131 = true
      break
    end
  end
  if not havebuff1131 then
    buff.timer = 0
  end
end

function Enigma.atk2sbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local havebuff1135
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 1135 then
      havebuff1135 = true
      break
    end
  end
  if not havebuff1135 then
    for _, v in ipairs(owner.info["Hero Tags"]) do
      if v == "Fly" or v == "float" then
        local bid = 1135
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff2 = ed.BuffCreate(binfo, owner, caster)
        buff2.update = override(buff2.update, Enigma.atk2sbuff2_update)
        local buffresult = owner:addBuff(buff2, caster)
      end
    end
  end
end

function Enigma.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Enigma.atk2sbuff_update)
  return buff
end

function Enigma.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  if target.buff_effects.stable or target.config.is_boss then
    result = nil
  end
  return result
end

function Enigma.skillatk3_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local base_speed = caster.info["Walk Speed"]
  if caster.Enigmaatk3_v and base_speed >= caster.Enigmaatk3_v then
    base_speed = caster.Enigmaatk3_v
  end
  local direction = {
    caster.Enigmaatk3_distance[1],
    caster.Enigmaatk3_distance[2]
  }
  owner.fearVelocity = ed.edpMult(ed.edpNormalize(direction), base_speed * caster.walk_speed_multiplier)
  local skillatk3s = caster.skills.Enigma_atk3s
  if buff.timer == 0 then
    skillatk3s:takeEffectOn(owner)
  end
end

function Enigma.skillatk3_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
end

function Enigma.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Enigma.skillatk3_buffUpdate)
  local owner = buff.owner
  local caster = buff.caster
  local distanceSQ = ed.edpDistanceSQ(caster.position, owner.position)
  local distance = ed.edpSub(caster.position, owner.position)
  local time = buff.timer
  caster.Enigmaatk3_v = distanceSQ ^ 0.5 / time / 4
  caster.Enigmaatk3_distance = distance
  buff:setAttribute("fearrange", 999)
  return buff
end

function Enigma.blackhole_atk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local power2 = power * (1 + caster.projectile_count * Enigma.blackhole_projectile_ratio)
  return power2
end

function Enigma.blackhole_update(basefunc, blackhole, dt)
  basefunc(blackhole, dt)
  local Enigmalocal = blackhole.config.summoner
  blackhole.blackhole_time = blackhole.blackhole_time - dt
  if blackhole:isAlive() and (blackhole.blackhole_time and blackhole.blackhole_time <= 0 or blackhole.projectile_count >= Enigma.blackhole_projectile_max) then
    local skillatk2 = blackhole.skills.EnigmaBH_atk2
    skillatk2:takeEffectAt(blackhole.position)
    blackhole:die()
  end
  if blackhole:isAlive() then
    local bh_position = blackhole.position
    local bh_h = blackhole.height
    for _, projectile in ipairs(ed.engine.projectile_list) do
      if projectile.camp == Enigmalocal.camp then
      elseif not projectile.can_be_influenced then
      elseif projectile.is_region or projectile.is_chain then
      else
        local xy = ed.edpSub(bh_position, projectile.position)
        local z = bh_h - projectile.height
        local l = (xy[1] * xy[1] + xy[2] * xy[2] + z * z) ^ 0.5
        if l <= Enigma.bh_absorb_r and l >= Enigma.bh_terminate_r then
          projectile["No Gravity"] = true
          local v = 1000
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
          local k = ((oldvelocity[1] * oldvelocity[1] + oldvelocity[2] * oldvelocity[2] + oldzSpeed * oldzSpeed) / (newvelocity[1] * newvelocity[1] + newvelocity[2] * newvelocity[2] + newzSpeed * newzSpeed)) ^ 0.5
          projectile.velocity[1] = k * newvelocity[1]
          projectile.velocity[2] = k * newvelocity[2]
          if projectile.zSpeed then
            projectile.zSpeed = k * newzSpeed
          end
        elseif l < Enigma.bh_terminate_r then
          projectile:terminate()
          blackhole.projectile_count = blackhole.projectile_count + 1
        end
      end
    end
  end
end

function Enigma.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir
  if attack_counter == 0 then
    basefunc(skill)
    local location = {}
    local x = Enigma.selectPosition(skill, 100)
    if x then
      location = {x, 0}
    else
      location = {400, 0}
    end
    if location[1] >= caster.position[1] then
      dir = 1
    else
      dir = -1
    end
    local skillatk4 = caster.skills.Enigma_atk4
    local skillevel = {
      skillatk4.level,
      skillatk4.level,
      skillatk4.level
    }
    local proto = {
      _tid = 246,
      _level = skillatk4.level or 1,
      _skill_levels = skillevel,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1
    }
    local blackhole = ed.UnitCreate(proto, caster.camp, config)
    blackhole.update = override(blackhole.update, Enigma.blackhole_update)
    blackhole.blackhole_time = Enigma.blackhole_time
    blackhole.direction = dir
    blackhole.height = 50
    blackhole.blackhole_start_time = Enigma.bh_start_time
    blackhole.projectile_count = 0
    local blackhole_position = location
    local bornaction = ed.protoAwake(caster.proto, 10042) and "Birth2" or "Birth"
    if ed.protoSuperAwake(caster.proto, 10042) then
      bornaction = "Birth3"
    end
    ed.engine:summonUnit(blackhole, blackhole_position, caster, bornaction)
    caster.small_blackhole = blackhole
    local bid = 1112
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = blackhole:addBuff(binfo, caster)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Enigma.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1112 then
      tbuff.timer = 0
    end
  end
end

function Enigma.san_run_with_scene(unit, dt)
  if unit.san_point < 1000 and unit.visible_count1 <= 1.5 then
    unit:setFuryVisible(true)
    unit.visible_count1 = unit.visible_count1 - dt
  end
  if unit.visible_count1 < 0 then
    unit:setFuryVisible(nil)
    unit.visible_count1 = 99999
  end
  if unit.san_point < 500 and 1.5 >= unit.visible_count2 then
    unit:setFuryVisible(true)
    unit.visible_count2 = unit.visible_count2 - dt
  end
  if 0 > unit.visible_count2 then
    unit:setFuryVisible(nil)
    unit.visible_count2 = 99999
  end
  if unit.san_point < 100 and 1.5 >= unit.visible_count3 then
    unit:setFuryVisible(true)
    unit.visible_count3 = unit.visible_count3 - dt
  end
  if 0 > unit.visible_count3 then
    unit:setFuryVisible(nil)
    unit.visible_count3 = 99999
  end
end

function Enigma.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillawake = hero.skills.Enigma_awake
  if skillawake and hero:isAlive() then
    local san_down_limit = 5
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      if unit.config.is_summoned or unit.name == "Enigma" then
      elseif san_down_limit < 0 then
      elseif unit.isDandan_Phoenix then
      elseif unit.buff_effects.fury then
      elseif unit.config.is_boss then
      elseif unit.san_point and unit.san_point <= 1000 and 0 > (unit.position[1] - hero.position[1]) * unit.direction then
        san_down_limit = san_down_limit - 1
        if unit.san_point == 1000 then
          unit.visible_count1 = 1.5
          unit.visible_count2 = 1.5
          unit.visible_count3 = 1.5
        end
        if 0 < unit.san_point then
          local distance = ed.edpDistanceSQ(unit.position, hero.position) ^ 0.5
          local san_down
          if distance < Enigma.san_min_distance then
            san_down = Enigma.sps_max
          elseif distance > Enigma.san_max_distance then
            san_down = Enigma.sps_min
          else
            san_down = math.pow(Enigma.san_max_distance - Enigma.san_min_distance - (distance - Enigma.san_min_distance), 2) / math.pow(Enigma.san_max_distance - Enigma.san_min_distance, 2) * (Enigma.sps_max - Enigma.sps_min) + Enigma.sps_min
          end
          unit.san_point = unit.san_point - san_down / 8
        else
          local bid = 1136
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit, hero)
          buff.onRemoved = override(buff.onRemoved, Enigma.sanbuff_onRemoved)
          buff.info["friend discount"] = skillawake.info["Script Arg2"] / 100 * hero.stars * 0.2
          local buffresult = unit:addBuff(buff, hero)
          if ed.protoSuperAwake(hero.proto, 10042) then
            local skillsawake = hero.skills.Enigma_sawake
            if skillsawake then
              local bid = 4084
              local binfo = ed.lookupDataTable("Buff", nil, bid)
              local buff = ed.BuffCreate(binfo, hero, hero)
              hero:addBuff(buff, hero)
              local hp_amount = skillsawake.info["Script Arg2"]
              local mp_amount = skillsawake.info["Script Arg3"]
              if hp_amount < unit.hp then
                unit:takeDamage(hp_amount, "Holy", "hp", hero)
                unit:takeDamage(mp_amount, "Holy", "mp", hero)
                hero:takeHeal(hp_amount, "hp", hero)
                hero:takeHeal(mp_amount, "mp", hero)
                Enigma.addLockHpBuff(hero, unit)
              else
                hero:takeHeal(hp_amount, "hp", hero)
                hero:takeHeal(mp_amount, "mp", hero)
                unit:takeDamage(unit.hp, "Holy", "hp", hero)
              end
            end
          end
        end
        if ed.run_with_scene then
          Enigma.san_run_with_scene(unit, dt)
        end
      end
    end
  end
end

function Enigma.sanbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.san_point = 1000
end

function Enigma.addLockHpBuff(caster, target)
  local bid = Enigma.lockhp_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, target, caster)
  buff.update = override(buff.update, Enigma.lockHpBuff_update)
  buff.onDamaged = override(buff.onDamaged, Enigma.lockHpBuff_onDamaged)
  buff.upgrade = override(buff.upgrade, Enigma.lockHpBuff_upgrade)
  buff.info["No Pass"] = true
  buff.Paper_lockHp_amount = 0
  local addbuff = target:addBuff(buff, caster)
  Enigma.hpLockPerform(caster, target)
end

function Enigma.lockHpBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local lockHp = buff.Paper_lockHp_amount
  if owner then
    local maxHp = owner.attribs.HP - lockHp
    if maxHp <= 0 then
      maxHp = 1
    end
    local currentHp = owner.hp
    if maxHp < currentHp then
      owner:setHP(maxHp)
    end
  end
  Enigma.hpLockPerform(caster, owner)
end

function Enigma.lockHpBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  if lastdamage < owner.hp then
    if buff.Paper_lockHp_amount then
      buff.Paper_lockHp_amount = buff.Paper_lockHp_amount + lastdamage
    else
      buff.Paper_lockHp_amount = lastdamage
    end
  end
  return damage
end

function Enigma.lockHpBuff_upgrade(basefunc, buff, owner, caster, nextBuffInfo)
  local bufftime = buff.timer
  basefunc(buff, owner, caster, nextBuffInfo)
  buff.timer = bufftime
end

function Enigma.hpLockPerform(caster, unit)
  local actor = unit.actor
  local lockPercent
  if actor then
    local buff
    local level = 0
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == Enigma.lockhp_bid then
        buff = tbuff
        break
      end
    end
    if buff then
      local skillsawake = caster.skills.Enigma_sawake
      local hp_amount = skillsawake.info["Script Arg2"]
      lockPercent = hp_amount / unit.attribs.HP
    end
    if not buff and unit.Paper_hpLockBar then
      unit.Paper_hpLockBar:removeFromParentAndCleanup(true)
      unit.Paper_hpLockBar = false
    elseif buff and not unit.Paper_hpLockBar then
      local barHp = unit.actor.bar_hp
      if barHp then
        local backgroundSize = barHp.background:getTextureRect().size
        local midlayerSize = barHp.midlayer:getTextureRect().size
        local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
        local offsetY = backgroundSize.height / 2
        local newBar = ed.createSprite(Enigma.lockHpSmall)
        barHp.background:addChild(newBar, 0)
        newBar:setAnchorPoint(ccp(1, 0.5))
        newBar:setPosition(ccp(offsetX, offsetY))
        newBar:setScaleX(lockPercent)
        unit.Paper_hpLockBar = newBar
      end
    elseif buff and unit.Paper_hpLockBar then
      unit.Paper_hpLockBar:setScaleX(lockPercent)
    end
  end
end

function Enigma.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = 0
    end
  end
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Enigma.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = 0
    end
  end
end

function Enigma.init_hero(hero)
  local skillult = hero.skills.Enigma_ult
  local skillults = hero.skills.Enigma_ults
  local skillatk2 = hero.skills.Enigma_atk2
  local skillatk2s = hero.skills.Enigma_atk2s
  local skillatk3 = hero.skills.Enigma_atk3
  local skillatk4 = hero.skills.Enigma_atk4
  local skillenter = hero.skills.Enigma_enter
  hero.reset = override(hero.reset, Enigma.hero_reset)
  hero.update = override(hero.update, Enigma.hero_update)
  hero.die = override(hero.die, Enigma.hero_die)
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Enigma.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Enigma.skillult_start)
    skillult.finish = override(skillult.finish, Enigma.skillult_finish)
  end
  if skillults then
    skillults.createRegion = override(skillults.createRegion, Enigma.skillults_createRegion)
    skillults.createBuff = override(skillults.createBuff, Enigma.skillults_createBuff)
  end
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, Enigma.skillatk2_takeEffectAt)
  end
  if skillatk2s then
    skillatk2s.createRegion = override(skillatk2s.createRegion, Enigma.skillatk2s_createRegion)
    skillatk2s.createBuff = override(skillatk2s.createBuff, Enigma.skillatk2s_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, Enigma.skillatk3_createBuff)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Enigma.skillatk3_canCastWithTarget)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Enigma.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, Enigma.skillatk4_finish)
  end
  if skillenter then
    skillenter.start = override(skillenter.start, Enigma.skillenter_start)
    skillenter.finish = override(skillenter.finish, Enigma.skillenter_finish)
  end
  return hero
end

return Enigma.init_hero
