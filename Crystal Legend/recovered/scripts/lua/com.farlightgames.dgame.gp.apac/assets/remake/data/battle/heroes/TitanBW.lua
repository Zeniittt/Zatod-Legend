module("ed.battlehero", package.seeall)
local ed = ed
TitanBW = {}
TitanBW.multicast_table = {
  TitanBW_ult = {
    42,
    38,
    20
  },
  TitanBW_atk2 = {
    45,
    40,
    15
  },
  TitanBW_atk2s = {
    45,
    40,
    15
  },
  TitanBW_atk3 = {
    48,
    35,
    17
  }
}
TitanBW.Arcana2_multicast_table = {
  TitanBW_ult = {
    0,
    32,
    38,
    30
  },
  TitanBW_atk2 = {
    0,
    35,
    40,
    25
  },
  TitanBW_atk2s = {
    0,
    35,
    40,
    25
  },
  TitanBW_atk3 = {
    0,
    38,
    35,
    27
  }
}
TitanBW.Arcana4_multicast_table = {
  TitanBW_ult = {
    0,
    26,
    28,
    30,
    16
  },
  TitanBW_atk2 = {
    0,
    25,
    27,
    30,
    18
  },
  TitanBW_atk2s = {
    0,
    25,
    27,
    30,
    18
  },
  TitanBW_atk3 = {
    0,
    24,
    28,
    31,
    17
  }
}

function TitanBW.TitanBW_rand(skill)
  local prob_table = TitanBW.multicast_table[skill.info["Skill Name"]]
  local caster = skill.caster
  if caster and caster.TitanBW_hasArcana and caster.TitanBW_hasArcana > 1 then
    prob_table = TitanBW.Arcana2_multicast_table[skill.info["Skill Name"]]
  end
  if caster and caster.TitanBW_hasArcana and caster.TitanBW_hasArcana > 3 then
    prob_table = TitanBW.Arcana4_multicast_table[skill.info["Skill Name"]]
  end
  local rand = ed.rand() * 100
  local times = #prob_table
  for i, v in ipairs(prob_table) do
    rand = rand - v
    if rand < 0 then
      times = i
      break
    end
  end
  return times
end

function TitanBW.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local info = skill.info
  local skillatk4 = caster.skills.TitanBW_atk4
  local multiplier = TitanBW.TitanBW_rand(skill)
  if not skillatk4 or not caster.config.is_boss then
  end
  if not caster.config.is_boss then
    power = power * multiplier
  end
  return power, coeff
end

function TitanBW.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local maxJumpTime = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit:isAlive() then
      maxJumpTime = maxJumpTime + 1
    end
  end
  maxJumpTime = maxJumpTime * 1.5
  local rand = ed.rand()
  local Jump_times = maxJumpTime * rand + 1
  Jump_times = math.floor(Jump_times)
  Jump_times = Jump_times + 1
  Jump_times = math.min(Jump_times, maxJumpTime)
  projectile:enableJump(Jump_times)
  projectile.can_be_influenced = false
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    if self.jumps == Jump_times then
      ret = skill.target
    else
      for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
        if unit == self.source then
        elseif unit.buff_effects.untargetable then
        elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
        else
          local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
          if min < distanceSQ then
          elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
            ret = unit
            min = distanceSQ
          end
        end
      end
    end
    return ret
  end
  
  return projectile
end

function TitanBW.DOP_in_battlefield(caster, radius, camp)
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
    return {400, 0}
  end
end

function TitanBW.skillatk2_createProjectile(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanBW_atk2
  local projectile = basefunc(skill)
  local d = {0, 0}
  if projectile then
    projectile.TitanBW_targetPosition = TitanBW.DOP_in_battlefield(caster, 150, caster.foecamp)
    projectile.position, projectile.height = skillatk2:launchPoint()
    if projectile.TitanBW_targetPosition then
      d = {
        projectile.TitanBW_targetPosition[1] - projectile.position[1],
        projectile.TitanBW_targetPosition[2] - projectile.position[2]
      }
      projectile.zSpeed = (projectile.TitanBW_targetPosition[2] - projectile.height) / math.abs((projectile.TitanBW_targetPosition[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
      projectile.max_distance = math.abs(projectile.position[1] - projectile.TitanBW_targetPosition[1])
      projectile.terminate = override(projectile.terminate, TitanBW.skillatk2_PTerminate)
      projectile.camp = caster.camp
      projectile.can_be_influenced = false
      ed.engine:addProjectile(projectile)
    end
    return nil
  end
end

function TitanBW.skillatk2_PTerminate(basefunc, self)
  local caster = self.caster
  local skillatk2s = caster.skills.TitanBW_atk2s
  local TitanBW_region
  if self.TitanBW_targetPosition and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanDragon_atk4_2.cha", {
      self.TitanBW_targetPosition[1],
      self.TitanBW_targetPosition[2]
    }, {
      caster.direction * 0.8,
      0.8
    }, nil, -1)
  end
  if caster:isAlive() and self.TitanBW_targetPosition then
    caster.TitanBW_atk2Power = 0
    skillatk2s:takeEffectAt(self.TitanBW_targetPosition, caster)
  end
  basefunc(self)
end

function TitanBW.skillatk2s_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local info = skill.info
  local skillatk4 = caster.skills.TitanBW_atk4
  local multiplier = TitanBW.TitanBW_rand(skill)
  if skillatk4 and caster.TitanBW_atk2Power and not caster.config.is_boss then
    if caster.TitanBW_atk2Power > 0 then
      power = caster.TitanBW_atk2Power
      return power, coeff
    else
      power = power * multiplier
      caster.TitanBW_atk2Power = power
      return power, coeff
    end
  end
  if not caster.config.is_boss then
    power = power * multiplier
  end
  return power, coeff
end

function TitanBW.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster then
    caster.TitanBW_atk3Power = 0
  end
end

function TitanBW.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local info = skill.info
  local skillatk4 = caster.skills.TitanBW_atk4
  local multiplier = TitanBW.TitanBW_rand(skill)
  if skillatk4 and not caster.config.is_boss then
    if caster.TitanBW_atk3Power > 0 then
      power = caster.TitanBW_atk3Power
      return power, coeff
    else
      power = power * multiplier
      caster.TitanBW_atk3Power = power
      return power, coeff
    end
  end
  if not caster.config.is_boss then
    power = power * multiplier
  end
  return power, coeff
end

function TitanBW.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanBW_atk4
  local havebuff = false
  local TitanBW_atk3Buff
  local STR = caster.attribs.STR
  local multiplier = TitanBW.TitanBW_rand(skill)
  local HAST = skill:createBuff(target).info.HAST
  local MSPD = skill:createBuff(target).info.MSPD
  if skillatk4 and caster and not caster.config.is_boss and target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 4937 then
        havebuff = true
        TitanBW_atk3Buff = tbuff
      end
    end
    if havebuff and TitanBW_atk3Buff then
      TitanBW_atk3Buff.shield = TitanBW_atk3Buff.shield
      TitanBW_atk3Buff.shield = TitanBW_atk3Buff.shield * multiplier
      TitanBW_atk3Buff:setAttribute("HAST", HAST)
      TitanBW_atk3Buff:setAttribute("MSPD", MSPD)
      if caster.TitanBW_hasArcana and caster.TitanBW_hasArcana > 2 then
        TitanBW_atk3Buff:setAttribute("AD", target.attribs.AD * 0.1 * multiplier)
        TitanBW_atk3Buff:setAttribute("AP", target.attribs.AP * 0.1 * multiplier)
        TitanBW_atk3Buff:setAttribute("ARM", target.attribs.ARM * 0.1 * multiplier)
        TitanBW_atk3Buff:setAttribute("MR", target.attribs.MR * 0.1 * multiplier)
      end
    else
      local bid = 4937
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local TitanBW_atk3Buff = target:addBuff(binfo, caster)
      if TitanBW_atk3Buff and TitanBW_atk3Buff.shield then
        TitanBW_atk3Buff.shield = TitanBW_atk3Buff.shield
        TitanBW_atk3Buff.shield = TitanBW_atk3Buff.shield * multiplier
        TitanBW_atk3Buff:setAttribute("HAST", HAST)
        TitanBW_atk3Buff:setAttribute("MSPD", MSPD)
        if caster.TitanBW_hasArcana and caster.TitanBW_hasArcana > 2 then
          TitanBW_atk3Buff:setAttribute("AD", target.attribs.AD * 0.1 * multiplier)
          TitanBW_atk3Buff:setAttribute("AP", target.attribs.AP * 0.1 * multiplier)
          TitanBW_atk3Buff:setAttribute("ARM", target.attribs.ARM * 0.1 * multiplier)
          TitanBW_atk3Buff:setAttribute("MR", target.attribs.MR * 0.1 * multiplier)
        end
      end
    end
  end
  basefunc(skill, target, source)
end

function TitanBW.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  if caster then
    local STR = caster.attribs.STR
    if STR then
      local HPR = buff.info.HPR
      buff:setAttribute("HPR", HPR)
    end
  end
  return buff
end

function TitanBW.hero_update(basefunc, hero, dt)
  local skillatk4 = hero.skills.TitanBW_atk4
  basefunc(hero, dt)
  if hero.Start_time then
    hero.Start_time = hero.Start_time + dt
  end
  if hero:isAlive() then
    if skillatk4 and not hero.TitanBW_region and not hero.config.is_summoned and hero.Start_time >= 1 then
      skillatk4.target = hero
      local TitanBW_region = skillatk4:createRegion()
      hero.TitanBW_region = TitanBW_region
      ed.engine:addRegion(TitanBW_region)
      local bid = 4938
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero:addBuff(binfo, hero)
    end
    if hero.TitanBW_region then
      hero.TitanBW_region.position = hero.position
    end
  end
end

function TitanBW.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.TitanBW_region then
    hero.TitanBW_region:finish()
  end
end

function TitanBW.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Start_time = 0
  hero.TitanBW_atk2Power = 0
  hero.TitanBW_atk3Power = 0
  hero.TitanBW_region = nil
end

function TitanBW.init_hero(hero)
  local skillult = hero.skills.TitanBW_ult
  local skillatk = hero.skills.Titan_atk
  local skillatk2 = hero.skills.TitanBW_atk2
  local skillatk2s = hero.skills.TitanBW_atk2s
  local skillatk3 = hero.skills.TitanBW_atk3
  local skillatk4 = hero.skills.TitanBW_atk4
  hero.update = override(hero.update, TitanBW.hero_update)
  hero.die = override(hero.die, TitanBW.hero_die)
  hero.reset = override(hero.reset, TitanBW.hero_reset)
  hero.TitanBW_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.power = override(skillult.power, TitanBW.skillult_power)
    skillult.createProjectile = override(skillult.createProjectile, TitanBW.skillult_createProjectile)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanBW.skillatk2_createProjectile)
  end
  if skillatk2s then
    skillatk2s.power = override(skillatk2s.power, TitanBW.skillatk2s_power)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanBW.skillatk3_start)
    skillatk3.power = override(skillatk3.power, TitanBW.skillatk3_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanBW.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanBW.skillatk4_createBuff)
  end
  return hero
end

return TitanBW.init_hero
