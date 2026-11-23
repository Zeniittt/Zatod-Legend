module("ed.battlehero", package.seeall)
local ed = ed
Artemis = {}
Artemis.testPointInShape = ed.Skill.testPointInShape
Artemis.atk2changetimeInit = 10
Artemis.atk2changetimeCD = 25
Artemis.atk2Gdeviation = 100
Artemis.atk2arenaFtoG = 25
Artemis.atk2arenaGtoF = 35
Artemis.ultmoontime = 12
Artemis.atk2moontime = 9
Artemis.skillFashionId = 100261

function Artemis.moon_die(basefunc, hero, killer)
  if hero.moon_region then
    hero.moon_region:finish()
    if ed.run_with_scene and hero.moon_effect then
      local z = -1
      ed.scene:removeEffect(hero.moon_effect, z)
    end
  end
  if hero.moon_region2 then
    hero.moon_region2:finish()
  end
  basefunc(hero, killer)
end

function Artemis.moon_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.ultmoontime then
    hero.ultmoontime = hero.ultmoontime - dt
    if hero.ultmoontime <= 0 and hero:isAlive() then
      hero:die()
    end
  end
  if hero.atk2moontime then
    hero.atk2moontime = hero.atk2moontime - dt
    if 0 >= hero.atk2moontime and hero:isAlive() then
      hero:die()
    end
  end
end

function Artemis.selectPosition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 200, 600, 25 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = ed.edpDistanceSQ(unit.position, {i, 0})
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unitdistance <= r * r then
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
    return {x, 0}
  end
  if maxcount <= 0 then
    return false
  end
end

function Artemis.selectPositionUlt(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local target
  local distance = 0
  local mindistance = 99999999999999
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    for otherunit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = ed.edpDistanceSQ(unit.position, otherunit.position)
      if otherunit.buff_effects.untargetable then
      elseif otherunit.buffManager.invisible and otherunit.camp ~= caster.camp then
      elseif unitdistance <= r * r then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      target = unit
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      target = unit
    end
    count = 0
    distance = 0
  end
  if target and 0 < maxcount then
    return {
      target.position[1],
      target.position[2]
    }
  else
    return {400, 0}
  end
end

function Artemis.change_mark(hero, BuffIDold, BuffIDnew)
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == BuffIDold then
        local reamin_time = tbuff.timer
        tbuff.timer = 0
        local bid = BuffIDnew
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = unit:addBuff(binfo, hero)
      end
    end
  end
  local havemark, addmark
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == BuffIDold or tbuff.info.ID == BuffIDnew then
        havemark = true
      end
    end
    if not havemark and not addmark then
      local bid = BuffIDnew
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = unit:addBuff(binfo, hero)
      addmark = true
    end
  end
end

function Artemis.skillultF_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.origin_position = {
    caster.position[1],
    caster.position[2]
  }
  local bid = 614
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.Artemis_attack_position = Artemis.selectPositionUlt(skill, 200)
  if caster.Artemis_attack_position[1] >= caster.position[1] then
    caster.direction = 1
  else
    caster.direction = -1
  end
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    local mark
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 608 then
        mark = true
      end
    end
    if mark then
      local bid = 617
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      binfo.fearrange = 5
      if unit then
        local buff = unit:addBuff(binfo, caster)
      end
    end
  end
end

function Artemis.skillultF_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local attack_position = caster.Artemis_attack_position
  if caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
    if attack_counter == 0 then
      local distance = attack_position[1] - caster.origin_position[1]
      local skill_dir = distance / math.abs(distance)
      local hero_position = {
        attack_position[1],
        attack_position[2]
      }
      caster:setPosition({
        hero_position[1],
        hero_position[2]
      })
      skill.attack_counter = skill.attack_counter + 1
    end
    if 1 <= attack_counter and attack_counter <= 8 then
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
        skill.caster.manually_casting = false
      end
      skill:takeEffectAt(attack_position)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 9 then
      caster:setPosition({
        caster.origin_position[1],
        caster.origin_position[2]
      })
    end
  else
    local summonlocation = Artemis.selectPosition(skill, 300)
    local caster = skill.caster
    local skillultF = caster.skills.Artemis_ultF
    local dir = caster:getInitDir()
    local skillevel = {
      skillultF.level,
      skillultF.level,
      skillultF.level
    }
    local proto = {
      _tid = 223,
      _level = skillultF.level or 1,
      _skill_levels = skillevel,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_summoned = true,
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1
    }
    local ultmoon = ed.UnitCreate(proto, caster.camp, config)
    ultmoon.direction = caster.direction
    local moon_position = summonlocation and summonlocation or {400, 0}
    local bid = 606
    local binfo606 = ed.lookupDataTable("Buff", nil, bid)
    local buff = ultmoon:addBuff(binfo606, ultmoon)
    ultmoon.die = override(ultmoon.die, Artemis.moon_die)
    ultmoon.update = override(ultmoon.update, Artemis.moon_update)
    ultmoon.ultmoontime = Artemis.ultmoontime
    ed.engine:summonUnit(ultmoon, moon_position, caster)
    local moon_skillatk2 = ultmoon.skills.Artemismoon2_atk2
    moon_skillatk2.target = ultmoon
    local region = moon_skillatk2:createRegion()
    ultmoon.moon_region = region
    ed.engine:addRegion(region)
    if ed.run_with_scene then
      local effect_name = "eff_point_Artemis_ultF.cha"
      if not effect_name then
        return
      end
      ultmoon.moon_effect = ed.scene:playEffectOnScene(effect_name, moon_position, nil, nil, -1)
    end
    table.insert(caster.ultmoonlist, ultmoon)
  end
end

function Artemis.skillultF_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = power
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 608 then
      power2 = power2 * 1.3
      break
    end
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function Artemis.skillultF_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 614 then
      tbuff.timer = 0
    end
  end
end

function Artemis.skillatk2FG_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 619
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Artemis.skillatk2F_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2G = caster.skills.Artemis_atk2G
  local attack_counter = skill.attack_counter
  caster.changePeriod_Artemis = true
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "Artemis" then
      if caster.currentActionStage == 1 then
        panel:setPortrait("UI/DOTA-HERO/Artemis2.png")
      elseif caster.currentActionStage == 2 then
        panel:setPortrait("UI/DOTA-HERO/Artemis.png")
      elseif caster.currentActionStage == 3 then
        panel:setPortrait("UI/DOTA-HERO/SwitchArtemis2.png")
      elseif caster.currentActionStage == 4 then
        panel:setPortrait("UI/DOTA-HERO/SwitchArtemis.png")
      elseif caster.currentActionStage == 5 then
        panel:setPortrait("UI/DOTA-HERO/Artemis2_sunshangxiang.png")
      elseif caster.currentActionStage == 6 then
        panel:setPortrait("UI/DOTA-HERO/Artemis_sunshangxiang.png")
      end
    end
  end
  basefunc(skill)
end

function Artemis.skillatk2F_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local result = basefunc(skill, target, source)
  if result and target:isAlive() then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 607 then
        local bid = 618
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, caster)
      end
    end
  end
end

function Artemis.skillatk2F_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_Artemis then
    if caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 then
      local fashionId = caster.fashion_id
      if fashionId and fashionId == Artemis.skillFashionId then
        caster:enterActionStageFromOneStage(6, 10026)
      elseif ed.protoAwake(caster.proto, 10026) then
        caster:enterActionStageFromOneStage(4, 10026)
      else
        caster:enterActionStageFromOneStage(2, 10026)
      end
    else
      local fashionId = caster.fashion_id
      if fashionId and fashionId == Artemis.skillFashionId then
        caster:enterActionStageFromOneStage(5, 10026)
      elseif ed.protoAwake(caster.proto, 10026) then
        caster:enterActionStageFromOneStage(3, 10026)
      else
        caster:enterActionStageFromOneStage(1, 10026)
      end
      local caster = skill.caster
      local dir = caster:getInitDir()
      local positionX
      if caster.position[1] - Artemis.atk2Gdeviation * dir <= ed.engine.stage_rect.minX then
        positionX = ed.engine.stage_rect.minX + 20
      elseif caster.position[1] - Artemis.atk2Gdeviation * dir >= ed.engine.stage_rect.maxX then
        positionX = ed.engine.stage_rect.maxX - 20
      else
        positionX = caster.position[1] - Artemis.atk2Gdeviation * dir
      end
      caster:setPosition({
        positionX,
        caster.position[2]
      })
    end
    caster.changePeriod_Artemis = false
  end
  caster.atk2changetime = Artemis.atk2changetimeCD
  for i, skill in pairs(caster.skill_list) do
    if skill == caster.manual_skill then
      skill.cd_remaining = 0
    end
  end
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 619 then
      tbuff.timer = 0
    end
  end
  local fashionId = caster.fashion_id
  if fashionId and fashionId == Artemis.skillFashionId then
    Artemis.change_mark(caster, 607, 608)
  end
end

function Artemis.skillatk2G_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  caster.changePeriod_Artemis = true
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "Artemis" then
      if caster.currentActionStage == 1 then
        panel:setPortrait("UI/DOTA-HERO/Artemis2.png")
      elseif caster.currentActionStage == 2 then
        panel:setPortrait("UI/DOTA-HERO/Artemis.png")
      elseif caster.currentActionStage == 3 then
        panel:setPortrait("UI/DOTA-HERO/SwitchArtemis2.png")
      elseif caster.currentActionStage == 4 then
        panel:setPortrait("UI/DOTA-HERO/SwitchArtemis.png")
      elseif caster.currentActionStage == 5 then
        panel:setPortrait("UI/DOTA-HERO/Artemis2_sunshangxiang.png")
      elseif caster.currentActionStage == 6 then
        panel:setPortrait("UI/DOTA-HERO/Artemis_sunshangxiang.png")
      end
    end
  end
  if attack_counter == 0 then
    basefunc(skill)
    local caster = skill.caster
    local dir = caster:getInitDir()
    local positionX
    if caster.position[1] - Artemis.atk2Gdeviation * dir <= ed.engine.stage_rect.minX then
      positionX = ed.engine.stage_rect.minX + 20
    elseif caster.position[1] - Artemis.atk2Gdeviation * dir >= ed.engine.stage_rect.maxX then
      positionX = ed.engine.stage_rect.maxX - 20
    else
      positionX = caster.position[1] - Artemis.atk2Gdeviation * dir
    end
    caster:setPosition({
      positionX,
      caster.position[2]
    })
  end
end

function Artemis.skillatk2G_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local result = basefunc(skill, target, source)
  if result and target:isAlive() then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 608 then
        local bid = 618
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, caster)
      end
    end
  end
end

function Artemis.skillatk2G_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_Artemis then
    local fashionId = caster.fashion_id
    if fashionId and fashionId == Artemis.skillFashionId then
      caster:enterActionStageFromOneStage(5, 10026)
    elseif ed.protoAwake(caster.proto, 10026) then
      caster:enterActionStageFromOneStage(3, 10026)
    else
      caster:enterActionStageFromOneStage(1, 10026)
    end
    caster.changePeriod_Artemis = false
  end
  caster.atk2changetime = Artemis.atk2changetimeCD
  for i, skill in pairs(caster.skill_list) do
    if skill == caster.manual_skill then
      skill.cd_remaining = 0
    end
  end
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 619 then
      tbuff.timer = 0
    end
  end
  local fashionId = caster.fashion_id
  if fashionId and fashionId == Artemis.skillFashionId then
    Artemis.change_mark(caster, 608, 607)
  end
end

function Artemis.atk2_summonlocation(hero, skill)
  local dir = hero:getInitDir()
  local target
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    if not unit.config.is_summoned and unit.position[1] > 200 - 200 * dir and unit.position[1] < 600 - 200 * dir then
      target = unit
    end
  end
  if target then
    return target.position
  elseif skill.target then
    return skill.target.position
  else
    return {
      400 - 200 * dir,
      0
    }
  end
end

function Artemis.skillatk3F_onAttackFrame(basefunc, skill)
  local info = skill.info
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local summonlocation = Artemis.atk2_summonlocation(caster, skill)
  if ed.run_with_scene then
    local effect_name = "eff_point_Artemis_atk3F2.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, summonlocation, nil, nil, -1)
  end
  local caster = skill.caster
  local skillatk3 = caster.skills.Artemis_atk3F
  local dir = caster:getInitDir()
  local skillevel = {
    skillatk3.level,
    skillatk3.level,
    skillatk3.level
  }
  local proto = {
    _tid = 222,
    _level = skillatk3.level or 1,
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
  local atk2moon = ed.UnitCreate(proto, caster.camp, config)
  atk2moon.direction = caster.direction
  local moon_position = summonlocation
  local bid = 606
  local binfo606 = ed.lookupDataTable("Buff", nil, bid)
  local buff = atk2moon:addBuff(binfo606, atk2moon)
  atk2moon.die = override(atk2moon.die, Artemis.moon_die)
  atk2moon.update = override(atk2moon.update, Artemis.moon_update)
  atk2moon.ultmoontime = Artemis.atk2moontime
  ed.engine:summonUnit(atk2moon, moon_position, caster)
  local moon_skillatk2 = atk2moon.skills.Artemismoon1_atk2
  moon_skillatk2.target = atk2moon
  local region1 = moon_skillatk2:createRegion()
  atk2moon.moon_region = region1
  ed.engine:addRegion(region1)
  local moon_skillatk3 = atk2moon.skills.Artemismoon1_atk3
  moon_skillatk3.target = atk2moon
  local region2 = moon_skillatk3:createRegion()
  atk2moon.moon_region2 = region2
  ed.engine:addRegion(region2)
  if ed.run_with_scene then
    local effect_name = "eff_point_Artemis_atk3F.cha"
    if not effect_name then
      return
    end
    atk2moon.moon_effect = ed.scene:playEffectOnScene(effect_name, summonlocation, nil, nil, -1)
    region1.moon_effect = atk2moon.moon_effect
  end
  table.insert(caster.atk2moonlist, atk2moon)
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
end

function Artemis.atk3_target(hero)
  local max = 0
  local target
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    if unit.buff_effects.untargetable then
    elseif unit.position[1] > ed.engine.stage_rect.maxX or unit.position[1] < ed.engine.stage_rect.minX then
    else
      local count = 0
      for otherunit in ed.engine:foreachAliveUnit(hero.foecamp) do
        local p1 = ed.edpSub(unit.position, otherunit.position)
        if otherunit ~= unit and Artemis.testPointInShape(p1, "circle", 200, 0) then
          count = count + 1
        end
      end
      if max <= count then
        target = unit
      end
    end
  end
  return target
end

function Artemis.atk3G_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if not projectile.mark and projectile.height <= 250 then
    if ed.run_with_scene then
      local effect_name = "eff_tile_Artemis_atk3G.cha"
      if not effect_name then
        return
      end
      local effect = ed.scene:playEffectOnScene(effect_name, {
        projectile.position[1],
        -25
      }, nil, nil, 1)
    end
    projectile.mark = true
  end
end

function Artemis.skillatk3G_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.originfo = projectile.skill.info
  projectile.update = override(projectile.update, Artemis.atk3G_projectile_update)
  local positionXY = Artemis.selectPosition(skill, 200) or {400, 0}
  projectile.height = 550
  projectile.position = positionXY
  return projectile
end

function Artemis.skillatk4FG_buffUpdate(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4F = caster.skills.Artemis_atk4F
  local skillatk4F2 = caster.skills.Artemis_atk4F2
  local skillatk4F3 = caster.skills.Artemis_atk4F3
  local skillatk4G = caster.skills.Artemis_atk4G
  local skillatk4G2 = caster.skills.Artemis_atk4G2
  skillatk4G.info["No Dodge"] = true
  local isF = buff.info.ID == 609
  if owner.current_skill == nil then
    buff.skill_mark = nil
  end
  if isF then
    if buff.skill_mark == nil and owner.current_skill then
      if owner.current_skill ~= owner.manual_skill then
        skillatk4F2:takeEffectOn(owner, caster)
        buff.Fcount = buff.Fcount + 1
      else
        skillatk4F3.manual_mark = true
        skillatk4F3:takeEffectAt(owner.position)
        buff.Fcount = 0
        owner:removeBuff(buff)
      end
      buff.skill_mark = owner.current_skill
    end
  elseif buff.skill_mark == nil and owner.current_skill then
    skillatk4G2:takeEffectOn(owner, caster)
    buff.skill_mark = owner.current_skill
    buff.Gcount = buff.Gcount + 1
  end
  if buff.Fcount >= 2 then
    skillatk4F3:takeEffectAt(owner.position)
    buff.Fcount = 0
    owner:removeBuff(buff)
  end
  if buff.Gcount >= 2 then
    buff.Gcount = 0
    owner:removeBuff(buff)
  end
  basefunc(buff, dt)
end

function Artemis.skillatk4FG_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.Fcount = 0
  buff.Gcount = 0
  buff.skill_mark = true
  buff.update = override(buff.update, Artemis.skillatk4FG_buffUpdate)
  return buff
end

function Artemis.skillatk4F2_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local damage_up1 = skill.info["Script Arg2"]
  local power2 = power
  if target.current_skill == target.basic_skill then
  elseif target.current_skill == target.manual_skill then
    power2 = 0
  else
    power2 = power2 * 1.5
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function Artemis.skillatk4G2_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = power
  if target.current_skill == target.basic_skill then
  elseif target.current_skill == target.manual_skill then
    power2 = power2 * 1.2
  else
    power2 = power2 * 1.1
  end
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 608 then
      power2 = power2 * 1.2
      break
    end
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function Artemis.skillatk4F3_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = power
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 607 then
      power2 = power2 * 1.2
      break
    end
  end
  if skill.manual_mark then
    power2 = power2 * 1.3
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function Artemis.skillatk4G2_takeEffectOn(basefunc, self, target, source, shift)
  local caster = self.caster
  source = source or caster
  if not target:isAlive() or target.buff_effects.invulnerable then
    return false
  end
  local info = self.info
  local damage_type = info["Damage Type"]
  local affect_field = info["Affect MP"] and "mp" or "hp"
  local dmg = 0
  if damage_type then
    local power, coefficient = self:power(source, target, damage_type)
    if damage_type == "Heal" then
      local heal = affect_field == "hp" and caster.attribs.HEAL or 0
      local power = power * (1 + heal / 100)
      if do_battle_log then
        btlog("%s: %s ++> %s (+%d)", self:display(), caster:display(), target:display(), power)
      end
      target:takeHeal(power, affect_field, caster)
    else
      if damage_type == "AD" and not info["No Dodge"] then
        local dodg = math.max(0, target.attribs.DODG - caster.attribs.HIT)
        local prob = dodg / (100 + dodg)
        local dice = ed.rand()
        local hit = prob <= dice
        if not hit then
          target:onHitMiss(self)
          if do_battle_log then
            btlog("%s: %s --> %s (Miss!)", self:display(), caster:display(), target:display())
          end
          local color = target.camp == ed.emCampEnemy and "red" or "blue"
          if target.actor then
            ed.PopupCreate("dodge", color, target.actor, nil, "text")
          end
          return false
        end
      end
      if do_battle_log then
        btlog("%s: %s --> %s (-%d)", self:display(), caster:display(), target:display(), power)
      end
      dmg = self:getDamage(target, power, damage_type, affect_field, caster, info["CRIT%"] / 100)
      if target.buffImpactEffect and target.actor then
        local name = target.buffImpactEffect.value.ImpactEffect
        local effect_z = target.buffImpactEffect.value.ImpactEffectZorder
        if self.isEffectAt then
          self.curSkillCount = self.curSkillCount + 1
          if self.curSkillCount <= class.maxShowSkillCount then
            target.actor:addEffect(name, effect_z)
          end
        else
          target.actor:addEffect(name, effect_z)
        end
      end
      if dmg == 0 then
        return false
      end
      if 0 < info["LFS%"] then
        local LFSRatio = caster.attribs.LFSRatio
        local lfs = caster.attribs.LFS
        local heal = dmg * lfs / (100 + lfs + target.level) * info["LFS%"] * 0.01
        local heal = heal * (1 + LFSRatio * 0.01)
        if 1 < heal or heal < 0 then
          if do_battle_log then
            btlog("  %s leeches %d %s form %s", caster:display(), heal, affect_field, target:display())
          end
          caster:takeHeal(heal, affect_field)
        end
      end
    end
  end
  local buff_miss = false
  if target:isAlive() and 0 < info["Buff ID"] then
    local bSucess, reason = ed.Buff.checkAddBuff(info.buff_info, self.level, target, caster)
    if bSucess then
      target:addBuff(self:createBuff(target))
    else
      local color = target.camp == ed.emCampEnemy and "red" or "blue"
      local text = reason == "resist" and "resist" or "miss"
      if target.actor then
        ed.PopupCreate(text, color, target.actor, nil, "text")
      end
      buff_miss = true
    end
  end
  if not buff_miss and (0 < info["Knock Up"] or 0 < info["Knock Back"]) then
    local time = info["Knock Up"]
    local distance = info["Knock Back"]
    local direction = {1, 0}
    if target.position[1] == caster.position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(target.position, caster.position)))
    end
    target:knockup(time, ed.edpMult(direction, distance), shift)
  end
  local name = info["Impact Effect"]
  if name and target.actor then
    local effect_z = info["Impact Zorder"]
    if self.isEffectAt then
      self.curSkillCount = self.curSkillCount + 1
      if self.curSkillCount <= 6 then
        target.actor:addEffect(name, effect_z)
      end
    else
      target.actor:addEffect(name, effect_z)
    end
  end
  return true, dmg
end

function Artemis.skillatk4G_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 1500
  local caster = skill.caster
  local target = projectile.skill.target
  if not target then
    return
  end
  local deviationX = ed.rand() * 10 - 20
  local deviationY = ed.rand() * 10 - 20
  projectile:enableTrack(target)
  projectile.position = {
    caster.position[1],
    caster.position[2]
  }
  local targetpos = {
    target.position[1],
    target.position[2]
  }
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end

function Artemis.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk2changetime = Artemis.atk2changetimeInit
  hero.atk2arenaFtoG = Artemis.atk2arenaFtoG
  hero.atk2arenaGtoF = Artemis.atk2arenaGtoF
  hero.atk2moonlist = {}
  hero.ultmoonlist = {}
  local fashionId = hero.fashion_id
  if fashionId and fashionId == Artemis.skillFashionId then
    hero:enterActionStageFromOneStage(5, 10026)
  elseif ed.protoAwake(hero.proto, 10026) then
    hero:enterActionStageFromOneStage(3, 10026)
  else
    hero:enterActionStageFromOneStage(1, 10026)
  end
end

function Artemis.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.atk2changetime = hero.atk2changetime - dt
  if hero.currentActionStage == 1 or hero.currentActionStage == 3 or hero.currentActionStage == 5 then
    hero.atk2arenaFtoG = hero.atk2arenaFtoG - dt
  else
    hero.atk2arenaGtoF = hero.atk2arenaGtoF - dt
  end
  local skillatk2F = hero.skills.Artemis_atk2F
  local skillatk2G = hero.skills.Artemis_atk2G
  local skillult = hero.skills.Artemis_ultF
  local BeControlled = false
  if hero.buff_effects.stun or hero.buff_effects.silence or hero.buff_effects.doom or hero.buff_effects.enchanted then
    BeControlled = true
  end
  if skillatk2F then
    hero.can_cast_manual = hero.can_cast_manual or hero.atk2changetime <= 0 and skillatk2F and hero:isAlive() and hero.current_skill ~= skillult and hero.current_skill ~= skillatk2F and hero.current_skill ~= skillatk2G and not BeControlled
  end
  if skillatk2F and hero.ai.will_cast_manual_skill then
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      if unit.config.is_summoned then
        break
      end
      local unitdistance = ed.edpDistanceSQ(unit.position, hero.position)
      if unitdistance <= 30625 then
        hero.AIatk2 = true
      end
    end
  end
  if (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and (hero.AIatk2 or hero.atk2arenaFtoG <= 0) and hero.current_skill ~= skillatk2F and hero.current_skill ~= skillatk2G and hero.current_skill ~= skillult and (hero.currentActionStage == 1 or hero.currentActionStage == 3 or hero.currentActionStage == 5) and hero.atk2changetime <= 0 and not hero.buff_effects.stun then
    if skillatk2F then
      hero:castSkill(skillatk2F, nil)
      hero.atk2arenaFtoG = Artemis.atk2arenaFtoG
    end
  elseif (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and (hero.AIatk2 or hero.atk2arenaGtoF <= 0) and hero.current_skill ~= skillatk2F and hero.current_skill ~= skillatk2G and hero.current_skill ~= skillult and (hero.currentActionStage == 2 or hero.currentActionStage == 4 or hero.currentActionStage == 6) and hero.atk2changetime <= 0 and not hero.buff_effects.stun and skillatk2G then
    hero:castSkill(skillatk2G, nil)
    hero.atk2arenaGtoF = Artemis.atk2arenaGtoF
  end
end

function Artemis.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.atk2moonlist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  for i, unit in ipairs(hero.ultmoonlist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Artemis.hero_castManualSkill(basefunc, hero)
  local skillatk2F = hero.skills.Artemis_atk2F
  local skillultF = hero.skills.Artemis_ultF
  local skillatk2G = hero.skills.Artemis_atk2G
  if skillatk2F then
    if hero.mp < 1000 and (hero.currentActionStage == 1 or hero.currentActionStage == 3 or hero.currentActionStage == 5) and hero.current_skill ~= skillatk2F and hero.current_skill ~= skillultF and hero.current_skill ~= skillatk2G then
      if hero.current_skill then
        hero.current_skill:interrupt()
      end
      hero:castSkill(skillatk2F, nil)
      if hero.atk2changetime <= 0 then
        hero.atk2changetime = Artemis.atk2changetimeCD
      end
    elseif hero.mp < 1000 and (hero.currentActionStage == 2 or hero.currentActionStage == 4 or hero.currentActionStage == 6) and hero.current_skill ~= skillatk2F and hero.current_skill ~= skillultF and hero.current_skill ~= skillatk2G then
      if hero.current_skill then
        hero.current_skill:interrupt()
      end
      hero:castSkill(skillatk2G, nil)
      if hero.atk2changetime <= 0 then
        hero.atk2changetime = Artemis.atk2changetimeCD
      end
    else
      basefunc(hero)
    end
  else
    basefunc(hero)
  end
end

function Artemis.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Artemis.skillatk_finish(basefunc, skill)
  basefunc(skill)
  skill.info = skill.originfo
end

function Artemis.skillatk_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local skillawake = caster.skills.Artemis_awake
  if not skillawake then
    skill:startPhase(1)
  elseif caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
    skill.info = ed.wraptable(skill.originfo, {
      ["Tile Piercing"] = "YES",
      ["Tile XY Speed"] = 1500,
      ["Tile Art"] = "eff_tile_Artemis_atkG2.cha"
    })
    skill.updamageG = skillawake.info["Script Arg2"] / 100 * caster.attribs.AP
    skill:startPhase(2)
  elseif caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 then
    skill.info = ed.wraptable(skill.originfo, {
      ["AOE Origin"] = "target",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 150,
      ["Damage Type"] = "AP",
      ["Plus Attr"] = "AP",
      ["Plus Ratio"] = 0.6,
      ["Point Effect"] = "eff_point_Artemis_atkF.cha"
    })
    skill.updamageF = skillawake.info["Script Arg3"] / 100 * caster.attribs.AD
    skill:startPhase(2)
  end
  skill.is_update = true
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function Artemis.skillatkF_power(basefunc, skill, source, target, damage_type)
  local dmg = basefunc(skill, source, target, damage_type)
  if skill.updamageF then
    dmg = dmg + skill.updamageF
  end
  return dmg
end

function Artemis.skillatkG_power(basefunc, skill, source, target, damage_type)
  local dmg = basefunc(skill, source, target, damage_type)
  if skill.updamageG then
    dmg = dmg + skill.updamageG
  end
  return dmg
end

function Artemis.init_hero(hero)
  local skillultF = hero.skills.Artemis_ultF
  local skillatk2F = hero.skills.Artemis_atk2F
  local skillatk3F = hero.skills.Artemis_atk3F
  local skillatk4F = hero.skills.Artemis_atk4F
  local skillatk4F2 = hero.skills.Artemis_atk4F2
  local skillatk4F3 = hero.skills.Artemis_atk4F3
  local skillultG = hero.skills.Artemis_ultF
  local skillatk2G = hero.skills.Artemis_atk2G
  local skillatk3G = hero.skills.Artemis_atk3G
  local skillatk4G = hero.skills.Artemis_atk4G
  local skillatk4G2 = hero.skills.Artemis_atk4G2
  local skillatkF = hero.skills.Artemis_atkF
  local skillatkG = hero.skills.Artemis_atkG
  local skillawake = hero.skills.Artemis_awake
  if skillultF then
    skillultF.onAttackFrame = override(skillultF.onAttackFrame, Artemis.skillultF_onAttackFrame)
    skillultF.getDamage = override(skillultF.getDamage, Artemis.skillultF_getDamage)
    skillultF.start = override(skillultF.start, Artemis.skillultF_start)
    skillultF.finish = override(skillultF.finish, Artemis.skillultF_finish)
  end
  if skillatk2F then
    skillatk2F.start = override(skillatk2F.start, Artemis.skillatk2FG_start)
    skillatk2F.onAttackFrame = override(skillatk2F.onAttackFrame, Artemis.skillatk2F_onAttackFrame)
    skillatk2F.finish = override(skillatk2F.finish, Artemis.skillatk2F_finish)
    skillatk2F.takeEffectOn = override(skillatk2F.takeEffectOn, Artemis.skillatk2F_takeEffectOn)
  end
  if skillatk2G then
    skillatk2G.start = override(skillatk2G.start, Artemis.skillatk2FG_start)
    skillatk2G.takeEffectOn = override(skillatk2G.takeEffectOn, Artemis.skillatk2G_takeEffectOn)
    skillatk2G.onAttackFrame = override(skillatk2G.onAttackFrame, Artemis.skillatk2G_onAttackFrame)
    skillatk2G.finish = override(skillatk2G.finish, Artemis.skillatk2G_finish)
  end
  if skillatk3F then
    skillatk3F.onAttackFrame = override(skillatk3F.onAttackFrame, Artemis.skillatk3F_onAttackFrame)
  end
  if skillatk3G then
    skillatk3G.createProjectile = override(skillatk3G.createProjectile, Artemis.skillatk3G_createProjectile)
  end
  if skillatk4F then
    skillatk4F.createBuff = override(skillatk4F.createBuff, Artemis.skillatk4FG_createBuff)
    skillatk4F2.getDamage = override(skillatk4F2.getDamage, Artemis.skillatk4F2_getDamage)
  end
  if skillatk4G then
    skillatk4G.createBuff = override(skillatk4G.createBuff, Artemis.skillatk4FG_createBuff)
    skillatk4G2.getDamage = override(skillatk4G2.getDamage, Artemis.skillatk4G2_getDamage)
    skillatk4G2.takeEffectOn = override(skillatk4G2.takeEffectOn, Artemis.skillatk4G2_takeEffectOn)
    skillatk4G.createProjectile = override(skillatk4G.createProjectile, Artemis.skillatk4G_createProjectile)
  end
  if skillatk4F then
    skillatk4F3.getDamage = override(skillatk4F2.getDamage, Artemis.skillatk4F3_getDamage)
  end
  if skillatkF then
    skillatkF.start = override(skillatkF.start, Artemis.skillatk_start)
    skillatkF.onPhaseFinished = override(skillatkF.onPhaseFinished, Artemis.skillatk_onPhaseFinished)
    skillatkF.finish = override(skillatkF.finish, Artemis.skillatk_finish)
    skillatkF.power = override(skillatkF.power, Artemis.skillatkF_power)
  end
  if skillatkG then
    skillatkG.start = override(skillatkG.start, Artemis.skillatk_start)
    skillatkG.onPhaseFinished = override(skillatkG.onPhaseFinished, Artemis.skillatk_onPhaseFinished)
    skillatkG.finish = override(skillatkG.finish, Artemis.skillatk_finish)
    skillatkG.power = override(skillatkG.power, Artemis.skillatkG_power)
  end
  hero.reset = override(hero.reset, Artemis.hero_reset)
  hero.die = override(hero.die, Artemis.hero_die)
  hero:setActionStageChangeByManual(true)
  if hero.name == "Artemis" then
    hero.update = override(hero.update, Artemis.hero_update)
    hero.castManualSkill = override(hero.castManualSkill, Artemis.hero_castManualSkill)
  end
  return hero
end

return Artemis.init_hero
