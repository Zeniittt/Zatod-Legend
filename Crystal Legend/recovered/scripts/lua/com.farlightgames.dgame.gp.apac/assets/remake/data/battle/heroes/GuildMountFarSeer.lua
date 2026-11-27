module("ed.battlehero", package.seeall)
local ed = ed
GuildMountFarSeer = {}
GuildMountFarSeer.GuildMountFarSeer_teleport_time = 0.1
GuildMountFarSeer.GuildMountFarSeer_explode_times = 99
GuildMountFarSeer.GuildMountFarSeer_explode_gap = 1
GuildMountFarSeer.GuildMountFarSeer_ballzspeed = 0
GuildMountFarSeer.GuildMountFarSeer_ultDelay = 0.5
GuildMountFarSeer.GuildMountFarSeer_stunBuff = 35

function GuildMountFarSeer.DOP_in_battlefield(caster, radius, camp)
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
  else
    return caster.position
  end
end

function GuildMountFarSeer.skillult_createProjectile(basefunc, skill)
  local ultProjectile = basefunc(skill)
  local caster = skill.caster
  ultProjectile.update = override(ultProjectile.update, GuildMountFarSeer.ultProjectile_update)
  ultProjectile.terminate = override(ultProjectile.terminate, GuildMountFarSeer.ultProjectile_terminate)
  ultProjectile.passTime = 0
  ultProjectile.height = 999
  local aim_position = GuildMountFarSeer.DOP_in_battlefield(caster, 180, caster.foecamp)
  if aim_position then
    ultProjectile.targetPosition = aim_position
    caster.ultaimPosition = aim_position
  else
    ultProjectile.targetPosition = skill.target.position
  end
  return ultProjectile
end

function GuildMountFarSeer.ultProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  projectile.passTime = projectile.passTime + dt
  if projectile.passTime >= GuildMountFarSeer.GuildMountFarSeer_ultDelay and not projectile.terminated then
    projectile.skill:takeEffectAt(projectile.targetPosition)
    projectile:terminate()
  end
end

function GuildMountFarSeer.ultProjectile_terminate(basefunc, projectile)
  local caster = projectile.caster
  local skillultb = caster.skills.GuildMountFarSeer_ultb
  if skillultb then
    skillultb.target = caster
    local region = skillultb:createRegion()
    region.position = projectile.targetPosition
    ed.engine:addRegion(region)
  end
  basefunc(projectile)
end

function GuildMountFarSeer.skillultb_createRegion(basefunc, skill)
  local ultbregion = basefunc(skill)
  ultbregion.update = override(ultbregion.update, GuildMountFarSeer.ultbregion_update)
  ultbregion.Active_Time = 0
  return ultbregion
end

function GuildMountFarSeer.ultbregion_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  local skillultc = caster.skills.GuildMountFarSeer_ultc
  if region.Active_Time then
    region.Active_Time = region.Active_Time + dt
  end
  if region.Active_Time and region.Active_Time >= 1 then
    region.Active_Time = 0
    skillultc:takeEffectAt(region.position, caster)
  end
end

function GuildMountFarSeer.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if ed.run_with_scene and caster and caster.ultaimPosition then
    local effect_name = "eff_impact_FarSeer_ult.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, caster.ultaimPosition, {1, 1}, nil, 1)
  end
end

function GuildMountFarSeer.skillatk2_createBuff(basefunc, skill, target)
  local atk2buff = basefunc(skill, target)
  atk2buff.update = override(atk2buff.update, GuildMountFarSeer.atk2buff_update)
  atk2buff.skill = skill
  local buffInfo = atk2buff.info
  local owner = atk2buff.owner
  local caster = atk2buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    atk2buff.timer = (atk2buff.timer + 1) * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    local MPRatio = skill.info.buff_info.MPRatio
    atk2buff:setAttribute("MPRatio", MPRatio - skill.evo_rank3["Script Arg1"])
  end
  return atk2buff
end

function GuildMountFarSeer.atk2buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.explodetimes then
    buff.explodetimes = 0
  end
  if not buff.explodegap then
    buff.explodegap = GuildMountFarSeer.GuildMountFarSeer_explode_gap
  end
  if buff.explodetimes < GuildMountFarSeer.GuildMountFarSeer_explode_times then
    buff.explodegap = buff.explodegap - dt
    if 0 >= buff.explodegap then
      local caster = buff.caster
      local skillatk2b = caster.skills.GuildMountFarSeer_atk2b
      if skillatk2b then
        local owner = buff.owner
        skillatk2b:takeEffectOn(owner, caster)
        if ed.run_with_scene then
          local effect_name = "eff_impact_FarSeer_atk2b.cha"
          owner.actor:addEffect(effect_name, 1)
        end
      end
      buff.explodegap = GuildMountFarSeer.GuildMountFarSeer_explode_gap
      buff.explodetimes = buff.explodetimes + 1
    end
  else
    buff.timer = 0
  end
end

function GuildMountFarSeer.skillatk3_createBuff(basefunc, skill, target)
  local atk3buff = basefunc(skill, target)
  local buffInfo = atk3buff.info
  atk3buff.update = override(atk3buff.update, GuildMountFarSeer.atk3buff_update)
  atk3buff.skill = skill
  return atk3buff
end

function GuildMountFarSeer.atk3buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3b = caster.skills.GuildMountFarSeer_atk3b
  if not buff.gonetime then
    buff.gonetime = 0
  end
  buff.gonetime = buff.gonetime + dt
  if buff.gonetime - dt < GuildMountFarSeer.GuildMountFarSeer_teleport_time and buff.gonetime >= GuildMountFarSeer.GuildMountFarSeer_teleport_time and not owner.buff_effects.untargetable and not owner.buff_effects.invulnerable and not owner.buff_effects.uncontrollable then
    if ed.run_with_scene then
      local effect_name = "eff_point_FarSeer_atk2out.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 1)
    end
    local dir = caster:getInitDir()
    owner.direction = owner:getInitDir()
    owner.origposition = {
      owner.position[1],
      owner.position[2]
    }
    owner.position[1] = ed.engine.stage_rect.maxX / 2 + dir * (ed.engine.stage_rect.maxX / 2 - 20)
    if skillatk3b then
      skillatk3b:takeEffectOn(owner)
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_FarSeer_atk2.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 1)
    end
    local stunbuffinfo = ed.lookupDataTable("Buff", nil, GuildMountFarSeer.GuildMountFarSeer_stunBuff)
    local stunSucess = ed.Buff.checkAddBuff(stunbuffinfo, buff.skill.level, owner, caster)
    if stunSucess then
      owner:addBuff(stunbuffinfo, caster)
    end
  end
end

function GuildMountFarSeer.skillatk3b_createBuff(basefunc, skill, target)
  local atk3b_buff = basefunc(skill, target)
  local caster = atk3b_buff.caster
  local buffInfo = atk3b_buff.info
  local owner = atk3b_buff.owner
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local skillatk3 = caster.skills.GuildMountFarSeer_atk3
  if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    atk3b_buff.timer = (atk3b_buff.timer + 1) * math.max(0.01, 1 - TEN_final / 100)
  end
  return atk3b_buff
end

function GuildMountFarSeer.skillpasvb_createRegion(basefunc, skill)
  local pasvbregion = basefunc(skill)
  pasvbregion.update = override(pasvbregion.update, GuildMountFarSeer.pasvbregion_update)
  pasvbregion.terminate = override(pasvbregion.terminate, GuildMountFarSeer.pasvbregion_terminate)
  return pasvbregion
end

function GuildMountFarSeer.pasvbregion_update(basefunc, region, dt)
  basefunc(region, dt)
  if not region.effecton then
    if ed.run_with_scene then
      local effect_name1 = "eff_point_FarSeer_pasv_front.cha"
      local effect1 = ed.scene:playEffectOnScene(effect_name1, region.position, {1, 1}, nil, 1)
      local effect_name2 = "eff_point_FarSeer_pasv_back.cha"
      local effect2 = ed.scene:playEffectOnScene(effect_name2, region.position, {1, 1}, nil, -1)
      region.scene_effect1 = effect1
      region.scene_effect2 = effect2
    end
    region.effecton = true
  end
end

function GuildMountFarSeer.skillpasvb_createBuff(basefunc, skill, target)
  local pasvbbuff = basefunc(skill, target)
  local caster = pasvbbuff.caster
  local buff_MR = pasvbbuff.info.MR
  local skillpasv = caster.skills.GuildMountFarSeer_pasv
  if skillpasv and skillpasv.evo_rank and skillpasv.evo_rank >= 1 then
    pasvbbuff:setAttribute("ARM", buff_MR)
  end
  if skillpasv and skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
    pasvbbuff:setAttribute("MR", buff_MR - caster.attribs.AP * skillpasv.evo_rank2["Script Arg1"])
    pasvbbuff:setAttribute("ARM", buff_MR - caster.attribs.AP * skillpasv.evo_rank2["Script Arg1"])
  end
  return pasvbbuff
end

function GuildMountFarSeer.pasvbregion_terminate(basefunc, region)
  if ed.run_with_scene then
    if region.scene_effect1 then
      ed.scene:removeEffect(region.scene_effect1, 1)
    end
    if region.scene_effect2 then
      ed.scene:removeEffect(region.scene_effect2, -1)
    end
  end
  basefunc(region)
end

function GuildMountFarSeer.skillpasv_createProjectile(basefunc, skill)
  local pasvProjectile = basefunc(skill)
  pasvProjectile.update = override(pasvProjectile.update, GuildMountFarSeer.pasvProjectile_update)
  pasvProjectile.terminate = override(pasvProjectile.terminate, GuildMountFarSeer.pasvProjectile_terminate)
  local dir = skill.caster:getInitDir()
  local max_distance = ed.engine.stage_rect.maxX / 2 * (1 - dir)
  local far_unit
  local target = skill.target
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
      break
    end
    if unit.config.is_summoned then
      break
    end
    if unit.position[1] * dir > max_distance * dir then
      max_distance = unit.position[1]
      far_unit = unit
    end
  end
  if far_unit then
    if far_unit.position[1] > ed.engine.stage_rect.maxX / 2 then
      pasvProjectile.dest = {
        far_unit.position[1] - 25,
        0
      }
    else
      pasvProjectile.dest = {
        far_unit.position[1] + 25,
        0
      }
    end
  else
    pasvProjectile.dest = {
      target.position[1],
      0
    }
  end
  pasvProjectile.zSpeed = GuildMountFarSeer.GuildMountFarSeer_ballzspeed
  local t = 0.465
  local h = pasvProjectile.height
  pasvProjectile.gravity = 2 * (-h - GuildMountFarSeer.GuildMountFarSeer_ballzspeed * t) / t ^ 2
  pasvProjectile.sumtime = 0
  local distance = ed.edpSub(pasvProjectile.dest, pasvProjectile.position)
  pasvProjectile.velocity = ed.edpMult(distance, 1 / t)
  return pasvProjectile
end

function GuildMountFarSeer.pasvProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  projectile.previous_position = {
    projectile.position[1],
    projectile.position[2]
  }
  ed.Entity.update(projectile, dt)
  local info = projectile.skill.info
  projectile.sumtime = projectile.sumtime + dt
  projectile.height = projectile.height + GuildMountFarSeer.GuildMountFarSeer_ballzspeed * projectile.sumtime + 0.5 * projectile.gravity * projectile.sumtime ^ 2
  projectile.zSpeed = projectile.zSpeed + projectile.gravity * dt
  local h = projectile.height
  if not projectile.terminated and (h <= 0 or projectile:isOutOfStage()) then
    projectile:terminate()
  end
end

function GuildMountFarSeer.pasvProjectile_terminate(basefunc, projectile)
  local caster = projectile.caster
  local skillpasvb = caster.skills.GuildMountFarSeer_pasvb
  if skillpasvb then
    skillpasvb.target = caster
    local region = skillpasvb:createRegion()
    region.position = projectile.dest
    ed.engine:addRegion(region)
  end
  basefunc(projectile)
end

function GuildMountFarSeer.init_hero(hero)
  local skillult = hero.skills.GuildMountFarSeer_ult
  local skillultb = hero.skills.GuildMountFarSeer_ultb
  local skillultc = hero.skills.GuildMountFarSeer_ultc
  local skillatk2 = hero.skills.GuildMountFarSeer_atk2
  local skillatk2b = hero.skills.GuildMountFarSeer_atk2b
  local skillatk3 = hero.skills.GuildMountFarSeer_atk3
  local skillatk3b = hero.skills.GuildMountFarSeer_atk3b
  local skillpasv = hero.skills.GuildMountFarSeer_pasv
  local skillpasvb = hero.skills.GuildMountFarSeer_pasvb
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, GuildMountFarSeer.skillult_createProjectile)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GuildMountFarSeer.skillult_onAttackFrame)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      local Plus_Ratio = skillult.info["Plus Ratio"]
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"] + Plus_Ratio
      })
      if skillultc then
        local Plus_Ratio = skillultc.info["Plus Ratio"]
        skillultc.info = ed.wraptable(skillultc.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"] + Plus_Ratio
        })
      end
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Shape Arg1"] = 200
      })
      if skillultb then
        skillultb.info = ed.wraptable(skillultb.info, {
          ["Shape Arg1"] = 200
        })
      end
      if skillultc then
        skillultc.info = ed.wraptable(skillultc.info, {
          ["Shape Arg1"] = 200
        })
      end
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 and skillultb then
      local ultRegionTime = skillultb.info["Script Arg1"]
      skillultb.info = ed.wraptable(skillultb.info, {
        ["Script Arg1"] = ultRegionTime + 1
      })
    end
  end
  if skillultb then
    skillultb.createRegion = override(skillultb.createRegion, GuildMountFarSeer.skillultb_createRegion)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, GuildMountFarSeer.skillatk2_createBuff)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      local Plus_Ratio = skillatk2.info["Plus Ratio"]
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"] + Plus_Ratio
      })
      if skillatk2b then
        local Plus_Ratio = skillatk2b.info["Plus Ratio"]
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"] + Plus_Ratio
        })
      end
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GuildMountFarSeer.skillatk3_createBuff)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 and skillatk3b then
      skillatk3b.info = ed.wraptable(skillatk3b.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3b and skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3b.info = ed.wraptable(skillatk3b.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk3b then
    skillatk3b.createBuff = override(skillatk3b.createBuff, GuildMountFarSeer.skillatk3b_createBuff)
  end
  if skillpasv and skillpasvb then
    skillpasv.createProjectile = override(skillpasv.createProjectile, GuildMountFarSeer.skillpasv_createProjectile)
    skillpasvb.createRegion = override(skillpasvb.createRegion, GuildMountFarSeer.skillpasvb_createRegion)
    skillpasvb.createBuff = override(skillpasvb.createBuff, GuildMountFarSeer.skillpasvb_createBuff)
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 and skillpasvb then
      local pasvbRegionTime = skillpasvb.info["Script Arg1"]
      skillpasvb.info = ed.wraptable(skillpasvb.info, {
        ["Script Arg1"] = pasvbRegionTime + 1
      })
    end
  end
  return hero
end

return GuildMountFarSeer.init_hero
