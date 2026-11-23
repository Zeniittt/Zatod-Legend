module("ed.battlehero", package.seeall)
local ed = ed
TitanDZ = {}

function TitanDZ.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.TitanDZ_atk4
  if skillatk4 then
    local bid = 4549
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
  end
end

function TitanDZ.skillatk2_createProjectile(basefunc, skill)
  local count = 2
  local origtarget = skill.target
  local caster = skill.caster
  local skillatk2s = caster.skills.TitanDZ_atk2s
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

function TitanDZ.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local lost = buff.info.HPR - caster.attribs.AP * 0.08
  if caster.TitanDZ_hasArcana and caster.TitanDZ_hasArcana > 1 then
    lost = lost * 1.25
  end
  buff:setAttribute("HPR", lost)
  return buff
end

function TitanDZ.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local heal = buff.info.HPR + caster.attribs.AP * 0.08
  if caster.TitanDZ_hasArcana and caster.TitanDZ_hasArcana > 1 then
    heal = heal * 1.25
  end
  buff:setAttribute("HPR", heal)
  return buff
end

function TitanDZ.skillatk3_start(basefunc, skill, target)
  basefunc(skill)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  local hero = skill.caster
  local bid = 4537
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanDZ.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4537 then
      tbuff.timer = -1
    end
  end
end

function TitanDZ.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.caster.TitanDZ_atk3_target = skill.target
  projectile.hit = override(projectile.hit, TitanDZ.projectile_hit)
  projectile.terminate = override(projectile.terminate, TitanDZ.projectile_Terminate)
  projectile.update = override(projectile.update, TitanDZ.skillatk3_projectile_update)
  return projectile
end

function TitanDZ.skillatk3_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if projectile.height < 10 and not projectile.terminated then
    projectile:terminate()
  end
end

function TitanDZ.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  basefunc(projectile, target)
  caster.TitanDZ_atk3_target = target
  if not projectile.terminated then
    projectile:terminate()
  end
end

function TitanDZ.projectile_Terminate(basefunc, self)
  local caster = self.caster
  local skillatk3s = caster.skills.TitanDZ_atk3s
  local TitanDZ_region
  if caster.name == "TitanDZ" and caster.TitanDZ_atk3_target then
    skillatk3s.target = caster.TitanDZ_atk3_target
    TitanDZ_region = skillatk3s:createRegion()
    caster.TitanDZ_region = TitanDZ_region
    local position = {
      self.position[1],
      self.position[2]
    }
    TitanDZ_region.position = position
    ed.engine:addRegion(TitanDZ_region)
    caster.TitanDZ_atk3_target = nil
  end
  basefunc(self)
end

function TitanDZ.skillatk3s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.TitanDZ_hasArcana and caster.TitanDZ_hasArcana > 2 and buff.owner then
    buff.owner.TitanDZ_skillatk3_buff = true
    buff.onRemoved = override(buff.onRemoved, TitanDZ.skillatk3_buffonRemoved)
  end
  buff:setAttribute("HPR", buff.info.HPR - caster.attribs.AP * 0.08)
  return buff
end

function TitanDZ.skillatk3_buffonRemoved(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.TitanDZ_skillatk3_buff = nil
  end
end

function TitanDZ.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanDZ_atk4
  local skillatk4s = hero.skills.TitanDZ_atk4s
  local skillatk3 = hero.skills.TitanDZ_atk3
  local skillatk3s = hero.skills.TitanDZ_atk3s
  if hero.TitanDZ_skillatk4_timer then
    hero.TitanDZ_skillatk4_timer = hero.TitanDZ_skillatk4_timer + dt
  else
    hero.TitanDZ_skillatk4_timer = 0
  end
  if hero.TitanDZ_skillatk3_timer and hero.TitanDZ_hasArcana and hero.TitanDZ_hasArcana > 2 then
    hero.TitanDZ_skillatk3_timer = hero.TitanDZ_skillatk3_timer + dt
  else
    hero.TitanDZ_skillatk3_timer = 0
  end
  if hero.TitanDZ_skillatk4_timer and hero.TitanDZ_skillatk4_timer >= 1.5 and skillatk4 and skillatk4s and not hero.config.is_summoned then
    skillatk4:takeEffectAt(hero.position)
    skillatk4s:takeEffectAt(hero.position)
    hero.TitanDZ_skillatk4_timer = 0
  end
  if hero.TitanDZ_skillatk3_timer and hero.TitanDZ_skillatk3_timer >= 2 and skillatk3 and hero.TitanDZ_hasArcana and hero.TitanDZ_hasArcana > 2 then
    hero.TitanDZ_skillatk3_timer = 0
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      if unit.TitanDZ_skillatk3_buff and unit:isAlive() then
        unit:hurt()
      end
    end
  end
end

function TitanDZ.skillult_start(basefunc, skill, target)
  basefunc(skill)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  local hero = skill.caster
  local bid = 4537
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanDZ.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4537 then
      tbuff.timer = -1
    end
  end
end

function TitanDZ.skillult_createProjectile(basefunc, skill)
  local originInfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 1 or attack_counter == 3 then
    skill.info["Tile Art"] = "eff_tile_TitanDZ_ults.cha"
  else
    skill.info["Tile Art"] = "eff_tile_TitanDZ_ult.cha"
  end
  local projectile = basefunc(skill)
  if attack_counter == 1 or attack_counter == 3 then
    projectile.TitanDZ_ult_tile = 1
  else
    projectile.TitanDZ_ult_tile = 0
  end
  projectile.hit = override(projectile.hit, TitanDZ.skillult_projectile_hit)
  projectile.collideCheck = override(projectile.collideCheck, TitanDZ.skillult_projectile_collideCheck)
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

function TitanDZ.skillult_projectile_collideCheck(basefunc, self, unit)
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

function TitanDZ.skillult_projectile_hit(basefunc, projectile, target)
  if ed.run_with_scene and projectile.TitanDZ_ult_tile == 1 then
    ed.scene:playEffectOnScene("eff_impact_TitanDZ_ults.cha", {
      projectile.position[1],
      projectile.position[2]
    }, {
      projectile.direction,
      1
    }, nil, 1)
  end
  if ed.run_with_scene and projectile.TitanDZ_ult_tile == 0 then
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

function TitanDZ.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanDZ_ult
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
    buffs.onDamaged = override(buffs.onDamaged, TitanDZ.skillatk3_buffsOnDamaged)
  end
  if caster.TitanDZ_hasArcana and caster.TitanDZ_hasArcana > 3 then
    buffs:setAttribute("MPR", -40)
  end
  owner:addBuff(buffs, caster or owner)
  return buff
end

function TitanDZ.skillatk3_buffsOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  if damage and 0 < damage then
    buff.timer = -1
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

function TitanDZ.skillatk2_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
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

function TitanDZ.init_hero(hero)
  local skillult = hero.skills.TitanDZ_ult
  local skillatk2 = hero.skills.TitanDZ_atk2
  local skillatk2s = hero.skills.TitanDZ_atk2s
  local skillatk3 = hero.skills.TitanDZ_atk3
  local skillatk3s = hero.skills.TitanDZ_atk3s
  local skillatk4 = hero.skills.TitanDZ_atk4
  hero.TitanDZ_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanDZ.skillatk2_createBuff)
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanDZ.skillatk2_createProjectile)
    if hero.TitanDZ_hasArcana and hero.TitanDZ_hasArcana > 1 then
      skillatk2.getDamage = override(skillatk2.getDamage, TitanDZ.skillatk2_getDamage)
    end
  end
  if skillatk2s then
    skillatk2s.createBuff = override(skillatk2s.createBuff, TitanDZ.skillatk2s_createBuff)
    if hero.TitanDZ_hasArcana and hero.TitanDZ_hasArcana > 1 then
      skillatk2s.getDamage = override(skillatk2s.getDamage, TitanDZ.skillatk2_getDamage)
    end
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanDZ.skillatk3_start)
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanDZ.skillatk3_createProjectile)
    skillatk3.finish = override(skillatk3.finish, TitanDZ.skillatk3_finish)
  end
  if skillatk3s then
    skillatk3s.createBuff = override(skillatk3s.createBuff, TitanDZ.skillatk3s_createBuff)
  end
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, TitanDZ.skillult_createProjectile)
    skillult.createBuff = override(skillult.createBuff, TitanDZ.skillult_createBuff)
    skillult.start = override(skillult.start, TitanDZ.skillult_start)
    skillult.finish = override(skillult.finish, TitanDZ.skillult_finish)
  end
  hero.update = override(hero.update, TitanDZ.hero_update)
  hero.reset = override(hero.reset, TitanDZ.hero_reset)
  return hero
end

return TitanDZ.init_hero
