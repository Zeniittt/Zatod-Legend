module("ed.battlehero", package.seeall)
local ed = ed
WorldRoshan = {}
WorldRoshan.targetpos = 0
WorldRoshan.dmg = 30000
WorldRoshan.ragelosthp = 600000
WorldRoshan.rage2losthp = 200000
WorldRoshan.stage2hp = 30000000
WorldRoshan.stage2ragelosthp = 400000

function WorldRoshan.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldRoshan.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldRoshan.rage_buff_update(basefunc, buff, dt)
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

function WorldRoshan.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 900
  local caster = skill.caster
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  projectile.height = 300
  projectile.position = {
    caster.position[1],
    caster.position[2]
  }
  WorldRoshan.targetpos = {
    target.position[1] - 60 * caster.direction,
    target.position[2]
  }
  local targetxyV = ed.edpSub(WorldRoshan.targetpos, projectile.position)
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
  print("ult")
  return projectile
end

function WorldRoshan.atk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
  end
end

function WorldRoshan.atk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
  end
end

function WorldRoshan.atk2_willCast(basefunc, skill)
  local num = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    local tmp = (unit.position[1] - caster.position[1]) ^ 2 + (unit.position[2] - caster.position[2]) ^ 2
    if (unit.position[1] - caster.position[1]) ^ 2 + (unit.position[2] - caster.position[2]) ^ 2 < 40000 then
      num = num + 1
    end
  end
  if 2 <= num then
    return true
  else
    return false
  end
end

function WorldRoshan.cataBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  buff.counter = buff.counter + 1
  local t = ed.engine.ticks
  if buff.counter % 16 == 0 then
    owner:setMP(owner.mp - 20)
  end
end

function WorldRoshan.atk5_createBuff(basefunc, skill, target)
  local cataBuff = basefunc(skill, target)
  cataBuff.update = override(cataBuff.update, WorldRoshan.cataBuff_update)
  cataBuff.counter = 0
  return cataBuff
end

function WorldRoshan.hero_update(basefunc, self, dt)
  basefunc(self, dt)
  if self.current_skill and self.current_skill.info["Skill Name"] == "WorldRoshan_atk4" then
    if not self.bdmg then
      self.bdmg = self.battledata.beardmg
    end
    if self.battledata.beardmg - self.bdmg > WorldRoshan.dmg then
      ed.engine:addEnergy(1)
      self.bdmg = self.bdmg + WorldRoshan.dmg
      if ed.run_with_scene then
        local p = ed.toViewPosition(self.position, 0)
        ed.sceneui:addBeanMarker(p)
      end
    end
  end
  if not self.lastRageHp then
    self.lastRageHp = self.hp
    self.rageStack = 0
  end
  if self.attribs.HP - self.hp < WorldRoshan.stage2hp then
    while self.lastRageHp - self.hp >= WorldRoshan.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, self, self)
      self:addBuff(buff, self)
      self.lastRageHp = self.lastRageHp - WorldRoshan.ragelosthp
      self.rageStack = self.rageStack + 1
    end
  else
    if not self.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      self.stage2ragebuff = self:addBuff(binfo, self)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      self:addBuff(binfo2, self)
    end
    while self.lastRageHp - self.hp >= WorldRoshan.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, self, self)
      self:addBuff(buff, self)
      self.lastRageHp = self.lastRageHp - WorldRoshan.rage2losthp
      self.rageStack = self.rageStack + 1
    end
  end
  local list = self.buff_list
  local debuff_list = {}
  local my_camp = self.camp
  for i = 1, #list do
    local buff = list[i]
    if not (not buff or buff.caster) or buff.caster.camp ~= my_camp then
      debuff_list[#debuff_list + 1] = buff
    end
  end
  for i = 1, #debuff_list do
    self:removeBuff(debuff_list[i])
  end
  local t = ed.engine.ticks
  if 240 <= t and not self.volcanno then
    if ed.engine.hero_background and ed.engine.hero_background[3] ~= true then
      ed.engine.hero_background = ed.engine.genHeroBackground("WorldRoshan", 9999, true)
    end
    if ed.run_with_scene and not ed.IsMultiArena() then
      ed.scene:onBackgroundAppear(1, "battle_bg/bbg_volcano2_worldroshan.jpg")
      local effect_smoke = "eff_point_WorldRoshan_smoke.cha"
      local origin = {
        ed.engine.stage_rect.maxX / 2,
        0
      }
      self.atk5_somkeeffect = ed.scene:playEffectOnScene(effect_smoke, origin, {5, 5}, nil, -1)
    end
    local p = {400, 0}
    local atk5 = self.skills.WorldRoshan_atk5
    atk5:takeEffectAt(p)
    self.volcanno = true
  end
end

function WorldRoshan.atk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.bdmg = nil
end

function WorldRoshan.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldRoshan.stage2hp and hero.hp - lost <= WorldRoshan.stage2hp then
    return hero.hp - WorldRoshan.stage2hp
  else
    return lost
  end
end

function WorldRoshan.init_hero(hero)
  hero.update = override(hero.update, WorldRoshan.hero_update)
  hero.reset = override(hero.reset, WorldRoshan.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldRoshan.getLostHPAfterImmunity)
  local skillatk2 = hero.skills.WorldRoshan_atk2
  local skillatk3 = hero.skills.WorldRoshan_atk3
  local skillult = hero.skills.WorldRoshan_ult
  local skillatk4 = hero.skills.WorldRoshan_atk4
  local skillatk5 = hero.skills.WorldRoshan_atk5
  if skillatk2 then
    skillatk2.willCast = override(skillatk2.willCast, WorldRoshan.atk2_willCast)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldRoshan.atk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldRoshan.atk3_onAttackFrame)
  end
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, WorldRoshan.skillult_createProjectile)
  end
  if skillatk4 then
    skillatk4.finish = override(skillatk4.finish, WorldRoshan.atk4_finish)
  end
  if skillatk5 then
    skillatk5.createBuff = override(skillatk5.createBuff, WorldRoshan.atk5_createBuff)
  end
  return hero
end

return WorldRoshan.init_hero
