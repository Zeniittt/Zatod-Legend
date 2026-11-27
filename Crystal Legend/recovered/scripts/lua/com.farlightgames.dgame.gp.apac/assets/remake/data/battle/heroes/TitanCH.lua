module("ed.battlehero", package.seeall)
local ed = ed
TitanCH = {}
TitanCH.TitanCH_arcana3Bid = 4725
TitanCH.TitanCH_arcana4Bid = 4726

function TitanCH.need_interrupt(skill)
  local current_phase_idx = skill and skill.current_phase_idx
  local max_phase_idx = skill and #skill.phase_list
  local max_event_idx = current_phase_idx and skill.current_phase and type(skill.current_phase.event_list) == "table" and #skill.current_phase.event_list
  local next_event_idx = current_phase_idx and skill.next_event_idx
  local need
  if skill and current_phase_idx and max_phase_idx and max_event_idx and next_event_idx then
    if current_phase_idx < max_phase_idx then
      need = true
    elseif current_phase_idx == max_phase_idx and max_event_idx >= next_event_idx then
      need = true
    end
  end
  return need
end

function TitanCH.arcana4Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local target_need_interrupt = TitanCH.need_interrupt(owner.current_skill)
  if caster:isAlive() then
    local target_casting1 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
    if owner and owner:isAlive() and target_casting1 ~= nil and target_casting1 ~= owner.info["Basic Skill"] then
      owner:hurt()
      local target_casting2 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
      local interrupt = false
      if target_casting2 == nil and target_need_interrupt == true then
        interrupt = true
      end
      if interrupt == true and owner:isAlive() and not owner.buff_effects.invulnerable then
        owner:takeDamage(math.min(owner.attribs.HP * 0.05, caster.attribs.HP * 0.1), "AP", "hp", caster)
        buff.timer = -1
      end
    end
  else
    buff.timer = -1
  end
end

function TitanCH.skillatk2_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  local d = {0, 0}
  projectile.hit = override(projectile.hit, TitanCH.atk2_projectile_hit)
  return projectile
end

function TitanCH.atk2_projectile_hit(basefunc, projectile, target)
  local caster = projectile.caster
  if target and target == projectile.skill.target then
    basefunc(projectile, target)
    if caster.TitanCH_hasArcana and caster.TitanCH_hasArcana >= 4 then
      local bid = TitanCH.TitanCH_arcana4Bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      local ratio = 0.3
      buff.update = override(buff.update, TitanCH.arcana4Buff_update)
      if ratio > ed.rand() then
        target:addBuff(buff, caster)
      end
    end
    if not projectile.terminated then
      projectile:terminate()
    end
  end
end

function TitanCH.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  buff.onRemoved = override(buff.onRemoved, TitanCH.skillatk2_buffonRemoved)
  local bid2 = 4727
  local binfo2 = ed.lookupDataTable("Buff", nil, 4727)
  local buff2 = ed.BuffCreate(binfo2, owner, caster)
  owner:addBuff(buff2, caster)
  return buff
end

function TitanCH.skillatk2_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if owner then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 4727 then
        tbuff.timer = -1
      end
    end
  end
end

function TitanCH.skillatk3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  local d = {0, 0}
  projectile.hit = override(projectile.hit, TitanCH.atk3_projectile_hit)
  return projectile
end

function TitanCH.atk3_projectile_hit(basefunc, projectile, target)
  local caster = projectile.caster
  if target ~= projectile.skill.target then
    local skillatk3 = caster.skills.TitanCH_atk3
    if skillatk3 and caster then
      local damage = skillatk3.info["Script Arg2"]
      target:takeDamage(damage, "AD", "hp", caster, 1, 1)
    end
    return
  else
    basefunc(projectile, target)
    if caster.TitanCH_hasArcana and caster.TitanCH_hasArcana >= 4 then
      local bid = TitanCH.TitanCH_arcana4Bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      local ratio = 0.3
      buff.update = override(buff.update, TitanCH.arcana4Buff_update)
      if ratio > ed.rand() then
        target:addBuff(buff, caster)
      end
    end
    if not projectile.terminated then
      projectile:terminate()
    end
  end
end

function TitanCH.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
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
    return position
  end
end

function TitanCH.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4As = caster.skills.TitanCH__atk4As
  local TitanCH_atk4region
  local position = TitanCH.DOP_in_battlefield(caster, 150, caster.foecamp)
  caster.skillatk4AsPosition = position
  if caster:isAlive() and position then
    skill:takeEffectAt(position, caster)
    skillatk4As.target = caster
    TitanCH_atk4region = skillatk4As:createRegion()
    caster.TitanCH_atk4region = TitanCH_atk4region
    ed.engine:addRegion(TitanCH_atk4region)
    if caster.TitanCH_hasArcana and caster.TitanCH_hasArcana >= 2 then
      local skillatk4_arcana2 = caster.skills.TitanCH_atk4_b
      skillatk4_arcana2.target = caster
      local TitanCH_region2 = skillatk4_arcana2:createRegion()
      caster.TitanCH_region2 = TitanCH_region2
      ed.engine:addRegion(TitanCH_region2)
    end
  end
  skill.attack_counter = skill.attack_counter + 1
end

function TitanCH.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, Dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster.TitanCH_hasArcana and caster.TitanCH_hasArcana >= 4 then
    local bid = TitanCH.TitanCH_arcana4Bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local ratio = 0.3
    buff.update = override(buff.update, TitanCH.arcana4Buff_update)
    if ratio > ed.rand() then
      target:addBuff(buff, caster)
    end
  end
  return isHit, Dmg
end

function TitanCH.skillatk4As_createRegion(basefunc, self)
  local region = basefunc(self)
  local caster = self.caster
  local position = caster.skillatk4AsPosition
  if position then
    region.position = position
    region.takeRegionEffectOn = override(region.takeRegionEffectOn, TitanCH.skillatk4As_takeRegionEffectOn)
    return region
  end
  return region
end

function TitanCH.skillatk4As_takeRegionEffectOn(basefunc, self, unit)
  local caster = self.caster
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  unit:addBuff(buff)
end

function TitanCH.skillatk4_arcana2_createRegion(basefunc, self)
  local region = basefunc(self)
  local caster = self.caster
  local position = caster.skillatk4AsPosition
  if position then
    region.position = position
    region.takeRegionEffectOn = override(region.takeRegionEffectOn, TitanCH.skillatk4_arcana2_takeRegionEffectOn)
    return region
  end
  return region
end

function TitanCH.skillatk4_arcana2_takeRegionEffectOn(basefunc, self, unit)
  local caster = self.caster
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  unit:addBuff(buff)
end

function TitanCH.locate_wall_position(caster, radius, camp)
  local position = {400, -50}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
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
    local direction = caster.direction
    local positionX = 400
    local caster_position1 = caster.position[1]
    if caster_position1 <= position[1] then
      positionX = caster_position1 + (position[1] - caster_position1) / 2
    elseif position[1] < caster.position[1] then
      positionX = caster_position1 - (caster_position1 - position[1]) / 2
    else
      positionX = 400
    end
    local positionY = -50
    position = {positionX, positionY}
    return position
  end
  if maxcount <= 0 then
    return position
  end
end

function TitanCH.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.TitanSniper_ultEffect = false
  local caster = skill.caster
  local bid = 4680
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  buff.timer = 2
end

function TitanCH.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanCH_ult
  local skillults = caster.skills.TitanCH_ults
  local TitanCH_ultregion
  local position = TitanCH.locate_wall_position(caster, 150, caster.foecamp)
  caster.ultRegion_position = position
  if caster:isAlive() and position then
    skillult:takeEffectAt(position, caster)
    skillults.target = caster
    TitanCH_ultregion = skillults:createRegion()
    caster.TitanCH_ultregion = TitanCH_ultregion
    ed.engine:addRegion(TitanCH_ultregion)
  end
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
end

function TitanCH.skillults_createRegion(basefunc, self)
  local caster = self.caster
  local region = basefunc(self)
  local position = caster.ultRegion_position
  if position then
    region.position = position
  end
  region.takeRegionEffectOn = override(region.takeRegionEffectOn, TitanCH.skillults_takeRegionEffectOn)
  region.update = override(region.update, TitanCH.TitanCH_ultregion_update)
  region.terminate = override(region.terminate, TitanCH.TitanCH_ultregion_terminate)
  if caster.TitanCH_hasArcana and caster.TitanCH_hasArcana >= 3 then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      local bid = TitanCH.TitanCH_arcana3Bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, unit, caster)
      buff.timer = region.timer
      unit:addBuff(buff, caster)
    end
  end
  return region
end

function TitanCH.skillults_takeRegionEffectOn(basefunc, self, unit)
  local caster = self.skill.caster
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  unit:addBuff(buff)
end

function TitanCH.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if buff then
    buff.update = override(buff.update, TitanCH.skillults_Buffupdate)
  end
  return buff
end

function TitanCH.skillults_Buffupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanCH_ult
  local region_position = caster.TitanCH_ultregion.position
  if not owner.ults_cd then
    owner.ults_cd = 0
  end
  if owner and owner.ults_cd < 0.5 then
    owner.ults_cd = owner.ults_cd + dt
  end
  if skillult and caster and owner and owner.ults_cd >= 0.5 then
    owner.ults_cd = 0
    skillult:takeEffectOn(owner)
    local time = 0.2
    local distance = 75
    local direction = {1, 0}
    if region_position[1] >= caster.position[1] then
      direction = ed.edpNormalize({1, 0})
    else
      direction = ed.edpNormalize({-1, 0})
    end
    owner:knockup(time, ed.edpMult(direction, distance))
  end
end

function TitanCH.TitanCH_ultregion_update(basefunc, region, dt)
  basefunc(region, dt)
  if not region.effecton then
    if ed.run_with_scene then
      local effect_name1 = "eff_point_TitanCH_ultb.cha"
      local effect1 = ed.scene:playEffectOnScene(effect_name1, region.position, {1, 1}, nil, 1)
      region.scene_effect1 = effect1
    end
    region.effecton = true
  end
end

function TitanCH.TitanCH_ultregion_terminate(basefunc, region)
  if ed.run_with_scene and region.scene_effect1 then
    ed.scene:removeEffect(region.scene_effect1, 1)
  end
  basefunc(region)
end

function TitanCH.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, Dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster.TitanCH_hasArcana and caster.TitanCH_hasArcana >= 4 then
    local bid = TitanCH.TitanCH_arcana4Bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local ratio = 0.3
    buff.update = override(buff.update, TitanCH.arcana4Buff_update)
    if ratio > ed.rand() then
      target:addBuff(buff, caster)
    end
  end
  return isHit, Dmg
end

function TitanCH.hero_die(basefunc, hero)
  basefunc(hero)
  if hero.TitanCH_ultregion then
    hero.TitanCH_ultregion:terminate()
  end
  if hero.TitanCH_region2 then
    hero.TitanCH_region2:terminate()
  end
end

function TitanCH.init_hero(hero)
  hero.die = override(hero.die, TitanCH.hero_die)
  local skillult = hero.skills.TitanCH_ult
  local skillults = hero.skills.TitanCH_ults
  local skillatk = hero.skills.TitanCH_atk
  local skillatk2 = hero.skills.TitanCH_atk2
  local skillatk3 = hero.skills.TitanCH_atk3
  local skillatk4 = hero.skills.TitanCH_atk4
  local skillatk4As = hero.skills.TitanCH__atk4As
  local skillatk4_arcana2 = hero.skills.TitanCH_atk4_b
  hero.TitanCH_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanCH.skillatk2_createProjectile)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanCH.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanCH.skillatk3_createProjectile)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanCH.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanCH.skillatk4_takeEffectOn)
  end
  if skillatk4As then
    skillatk4As.createRegion = override(skillatk4As.createRegion, TitanCH.skillatk4As_createRegion)
  end
  if skillatk4_arcana2 then
    skillatk4_arcana2.createRegion = override(skillatk4_arcana2.createRegion, TitanCH.skillatk4_arcana2_createRegion)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanCH.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanCH.skillult_takeEffectOn)
  end
  if skillults then
    skillults.createRegion = override(skillults.createRegion, TitanCH.skillults_createRegion)
    skillults.createBuff = override(skillults.createBuff, TitanCH.skillults_createBuff)
  end
  return hero
end

return TitanCH.init_hero
