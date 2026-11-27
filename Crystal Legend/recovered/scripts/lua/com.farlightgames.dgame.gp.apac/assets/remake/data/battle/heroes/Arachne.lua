module("ed.battlehero", package.seeall)
local ed = ed
Arachne = {}
Arachne.sawake_bid = 4069
Arachne.sawake_bid_target = 4070

function Arachne.reset(basefunc, self)
  basefunc(self)
  self.index = 0
end

function Arachne.update(basefunc, self, dt)
  basefunc(self, dt)
  self.index = self.index + dt
  if self.index == 1 then
    local skillsawake = self.skills.Arachne_sawake
    for unit in ed.engine:foreachAliveUnit(self.camp) do
      if unit ~= self then
        skillsawake:takeEffectOn(unit)
      end
    end
  end
end

function Arachne.skillsawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Arachne.skillsawake_buffonDamaged)
  return buff
end

function Arachne.skillsawake_buffonDamaged(basefunc, buff, damage, damage_type, source)
  local dmg = basefunc(buff, damage, damage_type, source)
  local owner = buff.owner
  local poison_caster = owner
  local binfo = ed.lookupDataTable("Buff", nil, Arachne.sawake_bid_target)
  if source and source:isAlive() then
    local poison_target_buff = ed.BuffCreate(binfo, source, poison_caster)
    for unit in ed.engine:foreachAliveUnit(owner.camp) do
      if unit.name == "Arachne" then
        local skillsawake = unit.skills.Arachne_sawake
        if skillsawake then
          poison_caster = unit
          poison_target_buff = ed.BuffCreate(binfo, source, poison_caster)
          poison_target_buff:setAttribute("HPR", -skillsawake.info["Script Arg2"])
        end
      end
    end
    if damage_type == "AD" and math.abs(source.position[1] - owner.position[1]) < 150 then
      source:addBuff(poison_target_buff, poison_caster)
    end
  end
  return dmg
end

function Arachne.power(basefunc, skill, source, target, damage_type)
  local ret, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillsawake = caster.skills.Arachne_sawake
  for _, buff in ipairs(target.buff_list) do
    if buff.info.ID == 4070 then
      ret = ret + skillsawake.info["Script Arg3"]
    end
  end
  return ret, i
end

function Arachne.hero_markornot(hero, target)
  for i, awakeusedhero in ipairs(hero.awakeused_list) do
    if awakeusedhero == target then
      return false
    end
  end
  return true
end

function Arachne.skillawake_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillawake = caster.skills.Arachne_awake
  local owner = buff.owner
  local ratio = skillawake.info["Script Arg1"] / 100
  if Arachne.hero_markornot(caster, owner) and owner.hp < owner.attribs.HP * 0.35 then
    local bid = 493
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo.fearrange = 5
    local buff493 = owner:addBuff(binfo, caster)
    buff:setAttribute("HPR", buff.info.HPR * (1 + ratio))
    local list = caster.awakeused_list
    list[#list + 1] = owner
  end
end

function Arachne.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local skillawake = skill.caster.skills.Arachne_awake
  buff.update = override(buff.update, Arachne.skillawake_buffUpdate)
  return buff
end

function Arachne.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 500
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
    targetxyV[1] * u,
    targetxyV[2] * u,
    targetzV * u
  }
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
  projectile.zSpeed = projectile.zSpeed + targetV[3] * v
  return projectile
end

function Arachne.skillult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  if not target:isAlive() then
    local caster = skill.caster
    local skillult = caster.skills.Arachne_ult
    local nearestUnit
    local nearestDistance = math.huge
    for unit in ed.engine:foreachAliveUnit(skillult:affectedCamp()) do
      if not unit.buff_effects.untargetable then
        local d = ed.edpDistanceSQ(unit.position, caster.position)
        if nearestDistance > d then
          nearestUnit = unit
          nearestDistance = d
        end
      end
    end
    if nearestUnit then
      nearestUnit:addBuff(skillult:createBuff(nearestUnit))
    end
  end
end

function Arachne.hero_takeDamage(basefunc, hero, amount, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(hero, amount, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type and damage_type or amount.damage_type
  local s = source and source or amount.source
  if lost and dt == "AD" and 0 < lost and s and s:isAlive() then
    local skillatk4 = hero.skills.Arachne_pasv
    if skillatk4 then
      s:addBuff(skillatk4:createBuff(s))
    end
  end
  return lost
end

function Arachne.hero_handleUnitDieEventToAll(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 304 then
      local caster = tbuff.caster
      if caster == self then
        local skillult = caster.skills.Arachne_ult
        local nearestUnit
        local nearestDistance = math.huge
        for unit in ed.engine:foreachAliveUnit(skillult:affectedCamp()) do
          if not unit.buff_effects.untargetable then
            local d = ed.edpDistanceSQ(unit.position, caster.position)
            if nearestDistance > d then
              nearestUnit = unit
              nearestDistance = d
            end
          end
        end
        if nearestUnit then
          nearestUnit:addBuff(skillult:createBuff(nearestUnit))
        end
        unit:removeBuff(tbuff)
      end
    end
  end
end

function Arachne.createProjectile(basefunc, skill)
  local origTarget = skill.target
  local counter = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if 5 <= counter then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    else
      counter = counter + 1
      skill.target = unit
      local projectile = basefunc(skill, unit)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function Arachne.init_hero(hero)
  if ed.protoSuperAwake(hero.proto, 78) then
    hero.reset = override(hero.reset, Arachne.reset)
    hero.update = override(hero.update, Arachne.update)
    local skillsawake = hero.skills.Arachne_sawake
    skillsawake.createBuff = override(skillsawake.createBuff, Arachne.skillsawake_createBuff)
  end
  local skillawake = hero.skills.Arachne_awake
  local skillatk2 = hero.skills.Arachne_atk2
  if skillatk2 and skillawake then
    skillatk2.createBuff = override(skillatk2.createBuff, Arachne.skillawake_createBuff)
    local skillsawake = hero.skills.Arachne_sawake
    if skillsawake then
      skillatk2.power = override(skillatk2.power, Arachne.power)
    end
  end
  local skillatk = hero.skills.Arachne_atk
  if skillatk then
    local skillsawake = hero.skills.Arachne_sawake
    if skillsawake then
      skillatk.power = override(skillatk.power, Arachne.power)
    end
  end
  local skillatk3 = hero.skills.Arachne_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, Arachne.createProjectile)
    local skillsawake = hero.skills.Arachne_sawake
    if skillsawake then
      skillatk3.power = override(skillatk3.power, Arachne.power)
    end
  end
  local skillult = hero.skills.Arachne_ult
  if skillult then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Arachne.hero_handleUnitDieEventToAll)
    skillult.createProjectile = override(skillult.createProjectile, Arachne.skillult_createProjectile)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Arachne.skillult_takeEffectOn)
    local skillsawake = hero.skills.Arachne_sawake
    if skillsawake then
      skillult.power = override(skillult.power, Arachne.power)
    end
    if skillawake then
      hero.awakeused_list = {}
      skillult.createBuff = override(skillult.createBuff, Arachne.skillawake_createBuff)
    end
  end
  local skillatk4 = hero.skills.Arachne_pasv
  if skillatk4 then
    hero.takeDamage = override(hero.takeDamage, Arachne.hero_takeDamage)
    if skillawake then
      skillatk2.createBuff = override(skillatk4.createBuff, Arachne.skillawake_createBuff)
    end
  end
  return hero
end

return Arachne.init_hero
