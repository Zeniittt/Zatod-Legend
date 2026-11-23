module("ed.battlehero", package.seeall)
local ed = ed
WorldAV = {}
WorldAV.atk3buff = 10003604
WorldAV.ragelosthp = 35000
WorldAV.rage2losthp = 15000
WorldAV.stage2hp = 1750000
WorldAV.stage2ragelosthp = 7500

function WorldAV.skillult_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  basefunc(skill, target)
  local caster = skill.caster
  local position = {
    caster.position[1],
    caster.position[2]
  }
  if skill.target then
    position = {
      skill.target.position[1],
      skill.target.position[2]
    }
  end
  skill.caster.origin_WorldAV = {
    position[1],
    position[2]
  }
  skill:selectTarget(target)
  if ed.run_with_scene then
    local effect_name = "eff_launch_AV_ult.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, skill.caster.origin_WorldAV, nil, nil, -1)
  end
end

function WorldAV.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter and skill.attack_counter == 0 then
    local target = skill.target
    local enemyCount = 0
    local info = skill.info
    local direction = skill.caster.direction
    local location = skill.caster.position
    local origin = {
      location[1],
      location[2]
    }
    local shape = "circle"
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if skill.testPointInShape(p2, shape, arg1, arg2) then
        enemyCount = enemyCount + 1
      end
    end
    skill.enemyCount = enemyCount
    basefunc(skill)
  elseif skill.attack_counter and skill.attack_counter == 1 then
    local target = skill.target
    local enemyCount = 0
    local info = skill.info
    local direction = skill.caster.direction
    local location = skill.caster.position
    local origin = {
      location[1],
      location[2]
    }
    local shape = "circle"
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if skill.testPointInShape(p2, shape, arg1, arg2) then
        enemyCount = enemyCount + 1
      end
    end
    skill.enemyCount = enemyCount
    basefunc(skill)
  end
end

function WorldAV.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  return power * (1 + (skill.enemyCount - 1) * 0.2), coefficient
end

function WorldAV.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.height = 300
  projectile.position = skill.caster.origin_WorldAV
  return projectile
end

function WorldAV.skillult_willCast(basefunc, skill)
  local flag = true
  if skill.caster.skills.WorldAV_atk3 ~= nil and skill.caster.current_skill == skill.caster.skills.WorldAV_atk3 then
    flag = false
  end
  return basefunc(skill) and flag
end

function WorldAV.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local dis = caster.direction == 1 and ed.engine.stage_rect.maxX - caster.position[1] or caster.position[1]
  local t = 2.3
  local v = dis / t
  if skill.attack_counter and skill.attack_counter == 0 then
    caster.walk_v = {
      caster.direction * v,
      0
    }
    caster.WorldAVultposition = {
      caster.position[1],
      caster.position[2]
    }
    local bid = WorldAV.atk3buff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
    basefunc(skill)
  elseif skill.attack_counter and skill.attack_counter == 11 then
    caster.walk_v = {0, 0}
    caster.position = {
      caster.WorldAVultposition[1],
      caster.WorldAVultposition[2]
    }
  else
    basefunc(skill)
  end
end

function WorldAV.skillatk3_takeEffectOn(basefunc, self, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(self, target, source, shift)
  local caster = self.caster
  if isHit then
    local shiledbuff_list = {}
    local shileddmg = 0
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.shield and 0 <= tbuff.shield then
        shiledbuff_list[#shiledbuff_list + 1] = tbuff
        shileddmg = shileddmg + tbuff.shield
      end
    end
    for i = 1, #shiledbuff_list do
      target:removeBuff(shiledbuff_list[i])
    end
    target:takeDamage(shileddmg, "AD", "hp", caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function WorldAV.skillatk3_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 10036703
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function WorldAV.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10036703 then
      tbuff.timer = 0
    end
  end
end

function WorldAV.skillatk2_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  basefunc(skill, target)
end

function WorldAV.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 1200
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  local targetpos = target.position
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
  projectile.zSpeed = projectile.zSpeed + targetV[3] * v
  return projectile
end

function WorldAV.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldAV.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldAV.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldAV.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldAV.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldAV.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldAV.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldAV.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldAV.rage_buff_update(basefunc, buff, dt)
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

function WorldAV.skillatk_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  basefunc(skill, target)
end

function WorldAV.init_hero(hero)
  local skillult = hero.skills.WorldAV_ult
  local skillatk = hero.skills.WorldAV_atk
  local skillatk2 = hero.skills.WorldAV_atk2
  local skillatk3 = hero.skills.WorldAV_atk3
  local skillatk4 = hero.skills.WorldAV_atk4
  hero.update = override(hero.update, WorldAV.hero_update)
  hero.reset = override(hero.reset, WorldAV.hero_reset)
  if skillult then
    hero:preloadEffect("eff_launch_WorldAV_ult.cha")
    skillult.start = override(skillult.start, WorldAV.skillult_start)
    skillult.createProjectile = override(skillult.createProjectile, WorldAV.skillult_createProjectile)
    skillult.willCast = override(skillult.willCast, WorldAV.skillult_willCast)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldAV.skillult_onAttackFrame)
    skillult.power = override(skillult.power, WorldAV.skillult_power)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, WorldAV.skillatk_start)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, WorldAV.skillatk2_start)
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldAV.skillatk2_createProjectile)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, WorldAV.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, WorldAV.skillatk3_finish)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldAV.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldAV.skillatk3_takeEffectOn)
  end
  return hero
end

return WorldAV.init_hero
