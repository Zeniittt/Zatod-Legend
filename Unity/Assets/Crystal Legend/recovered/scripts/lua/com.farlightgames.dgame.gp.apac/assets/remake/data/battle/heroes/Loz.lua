module("ed.battlehero", package.seeall)
local ed = ed
Loz = {}
Loz.atk2chainEffectzOrder = 0

function Loz.skillult_projectile_collideCheck(basefunc, self, unit)
  if self.lastHitTarget and unit == self.lastHitTarget then
    return false
  end
  if self.track_target and unit ~= self.track_target then
    return false
  end
  if not self.skill.info["Tile Piercing"] then
    if unit.buff_effects.untargetable then
      return false
    end
    if unit.buffManager.invisible and unit.camp ~= self.camp then
      return false
    end
  end
  local radius = unit.info["Collide Radius"]
  local ux = unit.position[1]
  local ux0 = unit.previous_position[1]
  local d = self.position[1] - ux
  local d0 = self.previous_position[1] - ux0
  local vx = self.position[1] - self.previous_position[1]
  if radius > d0 then
    if 0 < vx then
      return (ux0 - radius) / 99999
    else
      return 1 - (ux0 + radius) / 99999
    end
  end
  if 0 < d and 0 < d0 then
    d = d - radius
    d0 = d0 - radius
  elseif d < 0 and d0 < 0 then
    d = d + radius
    d0 = d0 + radius
  end
  local t = -d0 / (d - d0)
  if t < 0 or 1 < t then
    return false
  end
  return t
end

function Loz.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local projectile2 = basefunc(skill)
  projectile.collideCheck = override(projectile.collideCheck, Loz.skillult_projectile_collideCheck)
  projectile2.collideCheck = override(projectile2.collideCheck, Loz.skillult_projectile_collideCheck)
  local attack_counter = skill.attack_counter
  local position = skill.caster.position
  local direction = skill.caster.direction
  projectile2.position[1] = position[1] + 93.2715 * direction
  projectile2.height = 52.6295
  ed.engine:addProjectile(projectile2)
  if attack_counter == 1 or attack_counter == 4 or attack_counter == 8 then
    local skill4 = skill.caster.skills.Loz_atk4
    if skill4 then
      skill4:selectTarget(nil)
      local projectile3 = skill4:createProjectile()
      if skill4.target and skill4.target:isAlive() then
        projectile3:enableTrack(skill4.target)
        projectile3.mytarget = skill4.target
      end
      projectile3.position[1] = position[1] + -2.9767500000000098 * direction
      projectile3.height = 86.9535
      ed.engine:addProjectile(projectile3)
      skill4:selectTarget(nil)
      local projectile4 = skill.caster.skills.Loz_atk4:createProjectile()
      if skill4.target and skill4.target:isAlive() then
        projectile4:enableTrack(skill4.target)
        projectile4.mytarget = skill4.target
      end
      projectile4.position[1] = position[1] + 21.870000000000005 * direction
      projectile4.height = 85.27275
      ed.engine:addProjectile(projectile4)
    end
  end
  return projectile
end

function Loz.skill4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local timer = buff.timer
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = timer + skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Loz.skill4_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  projectile.zSpeed = projectile.zSpeed - projectile.skill.info["Tile Gravity"] * dt
  local dv = 600 * dt
  local target = projectile.mytarget
  if not target then
    return
  end
  target = target.position
  local xySpeed = projectile.velocity
  local zSpeed = projectile.zSpeed
  local v = {
    xySpeed[1],
    xySpeed[2],
    zSpeed
  }
  local targetxyV = ed.edpSub(target, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  if zSpeed and dv < zSpeed then
    projectile.zSpeed = projectile.zSpeed - dv
    dv = 0
  elseif zSpeed and 0 < zSpeed then
    dv = dv - zSpeed
    projectile.zSpeed = 0
  end
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * dv * 8
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * dv * 8
  projectile.zSpeed = projectile.zSpeed + targetV[3] * dv * 8
end

function Loz.skill4_createProjectile(basefunc, skill)
  local caster = skill.caster
  local originfo = skill.info
  local projectile = basefunc(skill)
  if skill.target and skill.target:isAlive() then
    projectile:enableTrack(skill.target)
    projectile.mytarget = skill.target
  end
  projectile.update = override(projectile.update, Loz.skill4_projectile_update)
  local position = skill.caster.position
  local direction = skill.caster.direction
  skill:selectTarget(nil)
  local projectile2 = basefunc(skill)
  projectile2.position[1] = position[1] + 13.283999999999992 * direction
  projectile2.height = 71.28
  if skill.target and skill.target:isAlive() then
    projectile2:enableTrack(skill.target)
    projectile2.mytarget = skill.target
  end
  ed.engine:addProjectile(projectile2)
  projectile2.update = override(projectile2.update, Loz.skill4_projectile_update)
  skill.info = originfo
  return projectile
end

function Loz.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  caster.skill2target_Loz = target
  caster.skill2buff_Loz = buff
  return buff
end

function Loz.chain_jump(basefunc, self)
  self.jumps_remaining = self.jumps_remaining - 1
  self.jump_timer = self.jump_timer + self.skill.info["Chain Gap"]
  self.affect_times[self.target] = (self.affect_times[self.target] or 0) + 1
  self.skill:takeEffectOn(self.target)
  if ed.run_with_scene and self.skill.attack_counter == 1 and self.skill.info["Chain Effect"] then
    local effect = ed.ChainEffectCreate(self)
    local effectid = ed.scene:addEffect(effect, Loz.atk2chainEffectzOrder)
    effect.node:setScale(1)
    self.skill.caster.atk2chainEffect_Loz = effect
  end
end

function Loz.skill2_createChain(basefunc, skill)
  local info = skill.info
  local self = ed.Entity.create()
  local class = {
    mt = {}
  }
  self.skill = skill
  self.source = skill.caster
  self.target = skill.target
  self.jumps_remaining = info["Chain Jumps"]
  self.jump_timer = 0
  self.affect_times = {}
  setmetatable(self, ed.Chain.mt)
  self.jump = override(self.jump, Loz.chain_jump)
  self:jump()
  return self
end

function Loz.skillatk2_onAttackFrame(basefunc, self)
  local attack_counter = self.attack_counter
  local caster = self.caster
  if attack_counter == 0 then
    caster:setMP(caster.mp + 90 * ed.engine.mp_bonus * (1 + (caster.attribs.MPGainRatio or 0) / 100))
  end
  basefunc(self)
end

function Loz.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.atk2chainEffect_Loz and ed.run_with_scene then
    ed.scene:removeEffect(caster.atk2chainEffect_Loz, Loz.atk2chainEffectzOrder)
  end
  caster.skill2target_Loz = nil
  caster.skill2buff_Loz = nil
  caster.atk2chainEffect_Loz = nil
  for i, ttbuff in ipairs(caster.buff_list) do
    if ttbuff.info.ID == 10006403 then
      ttbuff.timer = -1
    end
  end
end

function Loz.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk2 = self.skills.Loz_atk2
  if self.current_skill and skillatk2 and self.skill2target_Loz and self.current_skill == skillatk2 and self.skill2target_Loz == unit and ed.run_with_scene and self.atk2chainEffect_Loz then
    ed.scene:removeEffect(self.atk2chainEffect_Loz, Loz.atk2chainEffectzOrder)
    self.atk2chainEffect_Loz = nil
  end
end

function Loz.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 10006403
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function Loz.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  if ishit then
    local caster = skill.caster
    local bid = 10006404
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
  if not target:isHasUncontrolBufEffect() and ishit then
    target:hurt()
  end
  return ishit, damage
end

function Loz.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  if ishit then
    target:takeDamage(100, "Holy", "mp", skill.caster)
  end
  return ishit, damage
end

function Loz.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 10006403
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("PIMU", skill.evo_rank3["Script Arg1"])
  buff:setAttribute("MIMU", skill.evo_rank3["Script Arg1"])
  caster:addBuff(buff, caster)
end

function Loz.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, ttbuff in ipairs(caster.buff_list) do
    if ttbuff.info.ID == 10006403 then
      ttbuff.timer = -1
    end
  end
end

function Loz.init_hero(hero)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Loz.hero_handleUnitDieEvent)
  local skillult = hero.skills.Loz_ult
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, Loz.skillult_createProjectile)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.start = override(skillult.start, Loz.skillult_start)
      skillult.finish = override(skillult.finish, Loz.skillult_finish)
    end
  end
  local skillatk2 = hero.skills.Loz_atk2
  if skillatk2 then
    skillatk2.finish = override(skillatk2.finish, Loz.skillatk2_finish)
    skillatk2.createBuff = override(skillatk2.createBuff, Loz.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Loz.skillatk2_onAttackFrame)
    skillatk2.createChain = override(skillatk2.createChain, Loz.skill2_createChain)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Loz.skillatk2_takeEffectOn)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.start = override(skillatk2.start, Loz.skillatk2_start)
    end
  end
  local skillatk3 = hero.skills.Loz_atk3
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Loz.skillatk3_takeEffectOn)
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
  end
  local skillatk4 = hero.skills.Loz_atk4
  if skillatk4 then
    skillatk4.createProjectile = override(skillatk4.createProjectile, Loz.skill4_createProjectile)
    skillatk4.createBuff = override(skillatk4.createBuff, Loz.skill4_createBuff)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
  end
  return hero
end

return Loz.init_hero
