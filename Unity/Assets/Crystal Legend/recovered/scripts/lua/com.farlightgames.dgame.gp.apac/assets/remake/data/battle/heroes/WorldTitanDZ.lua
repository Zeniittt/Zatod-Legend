module("ed.battlehero", package.seeall)
local ed = ed
WorldTitanDZ = {}
WorldTitanDZ.ragelosthp = 600000
WorldTitanDZ.stage2hp = 30000000
WorldTitanDZ.rage2losthp = 200000
WorldTitanDZ.stage2ragelosthp = 400000

function WorldTitanDZ.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.WorldTitanDZ_atk4
  if skillatk4 then
    local bid = 4549
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
  end
  local bid2 = 4572
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = hero:addBuff(binfo2, hero)
  buff2.update = override(buff2.update, WorldTitanDZ.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldTitanDZ.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
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

function WorldTitanDZ.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldTitanDZ.stage2hp and hero.hp - lost <= WorldTitanDZ.stage2hp then
    return hero.hp - WorldTitanDZ.stage2hp
  else
    return lost
  end
end

function WorldTitanDZ.skillatk2_createProjectile(basefunc, skill)
  local count = 2
  local origtarget = skill.target
  local caster = skill.caster
  local skillatk2s = caster.skills.WorldTitanDZ_atk2s
  for i = 1, count do
    local projectile = basefunc(skill)
    local h = projectile.height
    local v = projectile.zSpeed
    local a = skill.info["Tile Gravity"]
    local A = 0.5 * a
    local B = v
    local C = h
    local delta = B ^ 2 - 4 * A * C
    local t = (-B - delta ^ 0.5) / (2 * A)
    if i == 1 then
      local target_position = {
        skill.target.position[1],
        skill.target.position[2]
      }
      local distance = ed.edpSub(target_position, caster.position)
      projectile.velocity = ed.edpMult(distance, 1 / t)
      ed.engine:addProjectile(projectile)
    elseif skillatk2s and i == 2 then
      skillatk2s:selectTarget()
      local projectile2 = skillatk2s:createProjectile()
      if skillatk2s.target and skillatk2s.target:isAlive() then
        projectile2:enableTrack(skillatk2s.target)
        ed.engine:addProjectile(projectile2)
      end
    end
  end
  return nil
end

function WorldTitanDZ.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local lost = buff.info.HPR - caster.attribs.AP * 0.08
  if caster.WorldTitanDZ_hasArcana and caster.WorldTitanDZ_hasArcana > 1 then
    lost = lost * 1.25
  end
  buff:setAttribute("HPR", lost)
  return buff
end

function WorldTitanDZ.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local heal = buff.info.HPR + caster.attribs.AP * 0.08
  if caster.WorldTitanDZ_hasArcana and caster.WorldTitanDZ_hasArcana > 1 then
    heal = heal * 1.25
  end
  buff:setAttribute("HPR", heal)
  return buff
end

function WorldTitanDZ.skillatk3_start(basefunc, skill, target)
  basefunc(skill)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  local hero = skill.caster
  local bid = 4537
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function WorldTitanDZ.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4537 then
      tbuff.timer = -1
    end
  end
end

function WorldTitanDZ.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.caster.WorldTitanDZ_atk3_target = skill.target
  projectile.hit = override(projectile.hit, WorldTitanDZ.projectile_hit)
  projectile.terminate = override(projectile.terminate, WorldTitanDZ.projectile_Terminate)
  projectile.update = override(projectile.update, WorldTitanDZ.skillatk3_projectile_update)
  return projectile
end

function WorldTitanDZ.skillatk3_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if projectile.height < 10 and not projectile.terminated then
    projectile:terminate()
  end
end

function WorldTitanDZ.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  basefunc(projectile, target)
  caster.WorldTitanDZ_atk3_target = target
  if not projectile.terminated then
    projectile:terminate()
  end
end

function WorldTitanDZ.projectile_Terminate(basefunc, self)
  local caster = self.caster
  local skillatk3s = caster.skills.WorldTitanDZ_atk3s
  local WorldTitanDZ_region
  if caster.name == "WorldTitanDZ" and caster.WorldTitanDZ_atk3_target then
    skillatk3s.target = caster.WorldTitanDZ_atk3_target
    WorldTitanDZ_region = skillatk3s:createRegion()
    caster.WorldTitanDZ_region = WorldTitanDZ_region
    local position = {
      self.position[1],
      self.position[2]
    }
    WorldTitanDZ_region.position = position
    ed.engine:addRegion(WorldTitanDZ_region)
    caster.WorldTitanDZ_atk3_target = nil
  end
  basefunc(self)
end

function WorldTitanDZ.skillatk3s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.WorldTitanDZ_hasArcana and caster.WorldTitanDZ_hasArcana > 2 and buff.owner then
    buff.owner.WorldTitanDZ_skillatk3_buff = true
    buff.onRemoved = override(buff.onRemoved, WorldTitanDZ.skillatk3_buffonRemoved)
  end
  buff:setAttribute("HPR", buff.info.HPR - caster.attribs.AP * 0.08)
  return buff
end

function WorldTitanDZ.skillatk3_buffonRemoved(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.WorldTitanDZ_skillatk3_buff = nil
  end
end

function WorldTitanDZ.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.WorldTitanDZ_atk4
  local skillatk4s = hero.skills.WorldTitanDZ_atk4s
  local skillatk3 = hero.skills.WorldTitanDZ_atk3
  local skillatk3s = hero.skills.WorldTitanDZ_atk3s
  if hero.WorldTitanDZ_skillatk4_timer then
    hero.WorldTitanDZ_skillatk4_timer = hero.WorldTitanDZ_skillatk4_timer + dt
  else
    hero.WorldTitanDZ_skillatk4_timer = 0
  end
  if hero.WorldTitanDZ_skillatk3_timer and hero.WorldTitanDZ_hasArcana and hero.WorldTitanDZ_hasArcana > 2 then
    hero.WorldTitanDZ_skillatk3_timer = hero.WorldTitanDZ_skillatk3_timer + dt
  else
    hero.WorldTitanDZ_skillatk3_timer = 0
  end
  if hero.WorldTitanDZ_skillatk4_timer and hero.WorldTitanDZ_skillatk4_timer >= 1.5 and skillatk4 and skillatk4s and not hero.config.is_summoned then
    skillatk4:takeEffectAt(hero.position)
    skillatk4s:takeEffectAt(hero.position)
    hero.WorldTitanDZ_skillatk4_timer = 0
  end
  if hero.WorldTitanDZ_skillatk3_timer and hero.WorldTitanDZ_skillatk3_timer >= 2 and skillatk3 and hero.WorldTitanDZ_hasArcana and hero.WorldTitanDZ_hasArcana > 2 then
    hero.WorldTitanDZ_skillatk3_timer = 0
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      if unit.WorldTitanDZ_skillatk3_buff and unit:isAlive() then
        unit:hurt()
      end
    end
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldTitanDZ.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldTitanDZ.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldTitanDZ.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldTitanDZ.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldTitanDZ.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldTitanDZ.skillult_start(basefunc, skill, target)
  basefunc(skill)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  local hero = skill.caster
  local bid = 4537
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function WorldTitanDZ.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4537 then
      tbuff.timer = -1
    end
  end
end

function WorldTitanDZ.skillult_createProjectile(basefunc, skill)
  local originInfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 1 or attack_counter == 3 then
    skill.info["Tile Art"] = "eff_tile_TitanDZ_ults.cha"
  else
    skill.info["Tile Art"] = "eff_tile_TitanDZ_ult.cha"
  end
  local projectile = basefunc(skill)
  if attack_counter == 1 or attack_counter == 3 then
    projectile.WorldTitanDZ_ult_tile = 1
  else
    projectile.WorldTitanDZ_ult_tile = 0
  end
  projectile.hit = override(projectile.hit, WorldTitanDZ.skillult_projectile_hit)
  projectile.collideCheck = override(projectile.collideCheck, WorldTitanDZ.skillult_projectile_collideCheck)
  skill.info = originInfo
  local dir = skill.caster:getInitDir()
  local caster = skill.caster
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target = skill:selectTarget()
  if target then
    local target_position = {
      skill.target.position[1] - 40 * caster:getInitDir(),
      skill.target.position[2]
    }
    local launchposition, h = skill:launchPoint()
    local distance = ed.edpSub(target_position, {
      launchposition[1],
      launchposition[2]
    })
    projectile.velocity = ed.edpMult(distance, 1 / t)
    projectile.can_be_influenced = false
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function WorldTitanDZ.skillult_projectile_collideCheck(basefunc, self, unit)
  local t = basefunc(self, unit)
  local u_pos = unit.position
  local t_pos = self.position
  if u_pos and t_pos then
    if (u_pos[1] - t_pos[1]) ^ 2 <= 2500 and (u_pos[2] - t_pos[2]) ^ 2 <= 2500 then
      t = 0.5
    else
      return false
    end
  else
    return false
  end
  return t
end

function WorldTitanDZ.skillult_projectile_hit(basefunc, projectile, target)
  if ed.run_with_scene and projectile.WorldTitanDZ_ult_tile == 1 then
    ed.scene:playEffectOnScene("eff_impact_TitanDZ_ults.cha", {
      projectile.position[1],
      projectile.position[2]
    }, {
      projectile.direction,
      1
    }, nil, 1)
  end
  if ed.run_with_scene and projectile.WorldTitanDZ_ult_tile == 0 then
    ed.scene:playEffectOnScene("eff_impact_TitanDZ_ult.cha", {
      projectile.position[1],
      projectile.position[2]
    }, {
      projectile.direction,
      1
    }, nil, 1)
  end
  projectile.skill:takeEffectAt(projectile.position)
  if not projectile.terminated then
    projectile:terminate()
  end
end

function WorldTitanDZ.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.WorldTitanDZ_ult
  local skillult_buff_id = 1
  local r = ed.rand()
  if 0.8 < r then
    skillult_buff_id = 4539
  elseif 0.6 < r then
    skillult_buff_id = 4540
  elseif 0.4 < r then
    skillult_buff_id = 4541
  elseif 0.2 < r then
    skillult_buff_id = 4542
  else
    skillult_buff_id = 4543
  end
  local bid = skillult_buff_id
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buffs = ed.BuffCreate(binfo, owner, caster or owner)
  buffs.timer = skillult.info["Script Arg2"]
  if bid == 4540 then
    buffs:setAttribute("fearrange", 5)
  end
  if bid == 4543 then
    buffs.onDamaged = override(buffs.onDamaged, WorldTitanDZ.skillatk3_buffsOnDamaged)
  end
  if caster.WorldTitanDZ_hasArcana and caster.WorldTitanDZ_hasArcana > 3 then
    buffs:setAttribute("MPR", -40)
  end
  owner:addBuff(buffs, caster or owner)
  return buff
end

function WorldTitanDZ.skillatk3_buffsOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  if damage and 0 < damage then
    buff.timer = -1
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

function WorldTitanDZ.skillatk2_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  power = power * 1.25
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function WorldTitanDZ.init_hero(hero)
  local skillult = hero.skills.WorldTitanDZ_ult
  local skillatk2 = hero.skills.WorldTitanDZ_atk2
  local skillatk2s = hero.skills.WorldTitanDZ_atk2s
  local skillatk3 = hero.skills.WorldTitanDZ_atk3
  local skillatk3s = hero.skills.WorldTitanDZ_atk3s
  local skillatk4 = hero.skills.WorldTitanDZ_atk4
  hero.WorldTitanDZ_hasArcana = 4
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, WorldTitanDZ.skillatk2_createBuff)
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldTitanDZ.skillatk2_createProjectile)
    if hero.WorldTitanDZ_hasArcana and hero.WorldTitanDZ_hasArcana > 1 then
      skillatk2.getDamage = override(skillatk2.getDamage, WorldTitanDZ.skillatk2_getDamage)
    end
  end
  if skillatk2s then
    skillatk2s.createBuff = override(skillatk2s.createBuff, WorldTitanDZ.skillatk2s_createBuff)
    if hero.WorldTitanDZ_hasArcana and hero.WorldTitanDZ_hasArcana > 1 then
      skillatk2s.getDamage = override(skillatk2s.getDamage, WorldTitanDZ.skillatk2_getDamage)
    end
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, WorldTitanDZ.skillatk3_start)
    skillatk3.createProjectile = override(skillatk3.createProjectile, WorldTitanDZ.skillatk3_createProjectile)
    skillatk3.finish = override(skillatk3.finish, WorldTitanDZ.skillatk3_finish)
  end
  if skillatk3s then
    skillatk3s.createBuff = override(skillatk3s.createBuff, WorldTitanDZ.skillatk3s_createBuff)
  end
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, WorldTitanDZ.skillult_createProjectile)
    skillult.createBuff = override(skillult.createBuff, WorldTitanDZ.skillult_createBuff)
    skillult.start = override(skillult.start, WorldTitanDZ.skillult_start)
    skillult.finish = override(skillult.finish, WorldTitanDZ.skillult_finish)
  end
  hero.update = override(hero.update, WorldTitanDZ.hero_update)
  hero.reset = override(hero.reset, WorldTitanDZ.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldTitanDZ.getLostHPAfterImmunity)
  return hero
end

return WorldTitanDZ.init_hero
