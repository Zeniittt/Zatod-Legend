module("ed.battlehero", package.seeall)
local ed = ed
TitanAA = {}

function TitanAA.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  local skillatk3 = hero.skills.TitanAA_atk3
  local skillatk4s2 = hero.skills.TitanAA_atk4s2
  if skillatk3 and lost and 0 < lost then
    local resist_value = skillatk3.info["Script Arg2"]
    if lost >= resist_value then
      lost = lost - resist_value
    else
      lost = 0
    end
    if source and source:isAlive() and skillatk4s2 and source.camp ~= hero.camp then
      if hero.TitanAA_hasArcana and hero.TitanAA_hasArcana > 2 then
        for i, buff in ipairs(source.buff_list) do
          if (hero.TitanAA_hasArcana and hero.TitanAA_hasArcana > 3 and buff.info.ID == 4454 or buff.info.ID == 4450) and 3 <= buff.rank and ed.rand() < 0.04 * buff.rank then
            local bid = 4448
            local binfo = ed.lookupDataTable("Buff", nil, bid)
            source:addBuff(binfo, hero)
          end
        end
      end
      local skillRemnant = hero.skills.TitanAA_Remnant1
      if skillRemnant then
        source:addBuff(skillatk4s2:createBuff(source))
      end
      source:addBuff(skillatk4s2:createBuff(source))
    end
  end
  return lost
end

function TitanAA.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk3 = hero.skills.TitanAA_atk3
  local skillatk4 = hero.skills.TitanAA_atk4
  local skillatk4s2 = hero.skills.TitanAA_atk4s2
  hero.TitanAA_atk4_region = nil
  if skillatk3 then
    local bid = 4452
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
  end
  if hero.TitanAA_hasArcana and hero.TitanAA_hasArcana > 3 and skillatk4s2 then
    local originInfo = skillatk4s2.info
    skillatk4s2.info = ed.wraptable(originInfo, {
      ["Buff ID"] = 4454
    })
  end
end

function TitanAA.skillult_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4451
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanAA.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4451 then
      tbuff.timer = -1
    end
  end
end

function TitanAA.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanAA_atk4
  local d = {0, 0}
  projectile.TitanAA_targetPosition = TitanAA.DOP_in_battlefield(caster, 200, caster.foecamp)
  projectile.position, projectile.height = skillatk4:launchPoint()
  projectile.TitanAA_targetPosition[1] = projectile.TitanAA_targetPosition[1] - caster.direction * 200
  if projectile.TitanAA_targetPosition then
    d = {
      projectile.TitanAA_targetPosition[1] - projectile.position[1],
      projectile.TitanAA_targetPosition[2] - projectile.position[2]
    }
    local s = ((projectile.TitanAA_targetPosition[1] - projectile.position[1]) ^ 2 + (projectile.TitanAA_targetPosition[2] - projectile.position[2]) ^ 2) ^ 0.5
    local t = s / skill.info["Tile XY Speed"]
    projectile.zSpeed = (projectile.TitanAA_targetPosition[2] - projectile.height - 0.5 * skill.info["Tile Gravity"] * t ^ 2) / t
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
    projectile.max_distance = math.abs(projectile.position[1] - projectile.TitanAA_targetPosition[1])
    projectile.camp = caster.camp
    projectile.can_be_influenced = false
    projectile.update = override(projectile.update, TitanAA.atk4_projectile_update)
    projectile.terminate = override(projectile.terminate, TitanAA.atk4_projectile_terminate)
    projectile.isOutOfStage = override(projectile.isOutOfStage, TitanAA.atk4_projectile_isOutOfStage)
    ed.engine:addProjectile(projectile)
  end
end

function TitanAA.atk4_projectile_isOutOfStage(basefunc, projectile)
  local isOut = basefunc(projectile)
  if projectile.position[1] > 900 or projectile.position[1] < -100 then
    return isOut
  end
end

function TitanAA.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unit.config.is_summoned then
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
    position = {400, 0}
    return position
  end
end

function TitanAA.atk4_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 10 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Lich_atk2.cha", {
        projectile.position[1],
        projectile.position[2] - 1
      }, {
        projectile.direction,
        1
      }, nil, 0)
      ed.scene:startCameraShakeAnimationY(5, 0.2, 5)
    end
    projectile:terminate()
  end
end

function TitanAA.atk4_projectile_terminate(basefunc, self)
  local caster = self.caster
  local skillatk4s = caster.skills.TitanAA_atk4s
  local TitanAA_region
  if caster.name == "TitanAA" and self.position and not caster.TitanAA_atk4_region then
    skillatk4s.target = caster
    TitanAA_region = skillatk4s:createRegion()
    TitanAA_region.terminate = override(TitanAA_region.terminate, TitanAA.TitanAA_region_terminate)
    TitanAA_region.update = override(TitanAA_region.update, TitanAA.TitanAA_region_update)
    TitanAA_region.position = self.position
    ed.engine:addRegion(TitanAA_region)
    caster.TitanAA_atk4_region = true
  end
  basefunc(self)
end

function TitanAA.TitanAA_region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  local skillatk4s = caster.skills.TitanAA_atk4s
  local skillatk4s2 = caster.skills.TitanAA_atk4s2
  if not region.damage_time then
    region.damage_time = 1.8
  end
  if not region.totalTime then
    region.totalTime = 0
  end
  region.totalTime = region.totalTime + dt
  if region.damage_time and region.damage_time > 2.5 and region.totalTime < skillatk4s.info["Script Arg1"] - 0.75 then
    skillatk4s2:takeEffectAt(region.position, caster)
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanAA_atk4s.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, region.position, {1, 1}, nil, 1)
    end
    region.damage_time = 0
  else
    region.damage_time = region.damage_time + dt
  end
end

function TitanAA.TitanAA_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  region.damage_time = nil
  region.totalTime = nil
  if caster.TitanAA_atk4_region then
    caster.TitanAA_atk4_region = nil
  end
end

function TitanAA.skillatk4s2_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local caster = skill.caster
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local ret, dmg = basefunc(skill, target, source)
  if target and target:isAlive() and not target.config.is_boss then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.MSPD and buff.info.MSPD > 0 or buff.info.HAST and 0 < buff.info.HAST then
        buff:setAttribute("MSPD", 0)
        buff:setAttribute("HAST", 0)
        target:resetBuffApply(buff)
      end
    end
  end
  return ret, dmg
end

function TitanAA.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
end

function TitanAA.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local caster = skill.caster
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local ret, dmg = basefunc(skill, target, source)
  if dmg and target and target:isAlive() then
    local bid = caster.TitanAA_hasArcana and caster.TitanAA_hasArcana > 3 and 4454 or 4450
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
    target:addBuff(binfo, caster)
  end
  return ret, dmg
end

function TitanAA.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4357
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanAA.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 4357 then
      tbuff.timer = -1
    end
  end
end

function TitanAA.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local curse_rank = 0
  local skillult = caster.skills.TitanAA_ult
  local attack_counter = skill.attack_counter
  if target and target:isAlive() and attack_counter == 3 then
    local bid = 4447
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local fbuff = ed.BuffCreate(binfo, target, caster)
    for i, bbuff in ipairs(target.buff_list) do
      if (caster.TitanAA_hasArcana and 3 < caster.TitanAA_hasArcana and bbuff.info.ID == 4454 or bbuff.info.ID == 4450) and bbuff.rank >= 1 then
        curse_rank = bbuff.rank
        bbuff.timer = -1
      end
    end
    local frozen_time = skillult.info["Script Arg2"] * curse_rank
    if 2 < frozen_time then
      fbuff.timer = frozen_time
    end
    if caster.TitanAA_hasArcana and caster.TitanAA_hasArcana > 1 then
      fbuff:setAttribute("MPRatio", -100)
      fbuff:setAttribute("MPGRatio", -100)
    end
    target:addBuff(fbuff, caster)
  end
  return buff
end

function TitanAA.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  skill.info["No Dodge"] = true
  if attack_counter == 0 then
    basefunc(skill)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(3, 0.3, 6)
    end
  elseif attack_counter == 1 then
    basefunc(skill)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(3, 0.3, 6)
    end
  elseif attack_counter == 2 then
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(3, 0.3, 6)
    end
    basefunc(skill)
  end
end

function TitanAA.init_hero(hero)
  local skillult = hero.skills.TitanAA_ult
  local skillatk = hero.skills.TitanAA_atk
  local skillatk2 = hero.skills.TitanAA_atk2
  local skillatk3 = hero.skills.TitanAA_atk3
  local skillatk4 = hero.skills.TitanAA_atk4
  local skillatk4s2 = hero.skills.TitanAA_atk4s2
  hero.TitanAA_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.reset = override(hero.reset, TitanAA.hero_reset)
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanAA.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanAA.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanAA.getLostHPAfterImmunity)
  end
  if skillatk4 then
    skillatk4.createProjectile = override(skillatk4.createProjectile, TitanAA.skillatk4_createProjectile)
    skillatk4.start = override(skillult.start, TitanAA.skillatk4_start)
    skillatk4.finish = override(skillult.finish, TitanAA.skillatk4_finish)
  end
  if skillatk4s2 then
    skillatk4s2.takeEffectOn = override(skillatk4s2.takeEffectOn, TitanAA.skillatk4s2_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanAA.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanAA.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, TitanAA.skillult_createBuff)
    skillult.finish = override(skillult.finish, TitanAA.skillult_finish)
  end
  return hero
end

return TitanAA.init_hero
