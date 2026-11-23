module("ed.battlehero", package.seeall)
local ed = ed
TitanSil = {}

function TitanSil.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanSil.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4582
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanSil.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4582 then
      tbuff.timer = 0
    end
  end
end

function TitanSil.isCrlEftConflictWithUncontrollableSP(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function TitanSil.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local bid = 4529
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  owner:addBuff(binfo, caster)
  buff.onDamaged = override(buff.onDamaged, TitanSil.skillults_buff_onDamaged)
  return buff
end

function TitanSil.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if target and target:isAlive() then
    if target.TitanSil_skillatk2s_count and target.TitanSil_skillatk2s_count > 0 then
      target.TitanSil_skillatk2s_count = target.TitanSil_skillatk2s_count + 3
    else
      local bid = 4583
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, skill.caster)
      target.TitanSil_skillatk2s_count = 3
      if buff then
        buff.update = override(buff.update, TitanSil.skillatk2s_buff_update)
        buff.onDamaged = override(buff.onDamaged, TitanSil.skillatk2s_buff_onDamaged)
      end
    end
  end
end

function TitanSil.skillatk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanSil_atk4
  local target = skillatk4:selectTarget()
  if target and target:isAlive() then
    skillatk4:takeEffectOn(target, caster)
    if ed.run_with_scene then
      local effect_name = "eff_impact_heal.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
        caster.direction * 1,
        1
      }, nil, 1)
    end
  end
end

function TitanSil.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, TitanSil.skillatk3_projectile_hit)
  return projectile
end

function TitanSil.skillatk3_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target == skill.target then
    basefunc(projectile, target)
    projectile:terminate()
  else
    return nil
  end
end

function TitanSil.skillatk4_isnegative_effect(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    polymorph = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function TitanSil.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit = basefunc(skill, target, source, shift)
  if isHit and target then
    if caster.TitanSil_hasArcana and caster.TitanSil_hasArcana > 1 then
      target:takeHeal(75, "mp", caster)
    end
    local list = target.buff_list
    for i = 1, #list do
      local buff = list[i]
      if buff and buff.owner == target and target.camp == caster.camp and TitanSil.skillatk4_isnegative_effect(buff) and buff.timer <= 12 then
        buff.owner:removeBuff(buff)
      end
    end
  end
end

function TitanSil.skillults2_createRegion(basefunc, skill)
  local region = basefunc(skill)
  region.buff_trigger_time = 1.5
  region.update = override(region.update, TitanSil.skillult_region_update)
  return region
end

function TitanSil.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
end

function TitanSil.skillult_region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  local skillults = caster.skills.TitanSil_ults
  region.buff_trigger_time = region.buff_trigger_time + dt
  if region.buff_trigger_time > 2.5 then
    skillults:takeEffectAt(region.position, caster)
    region.buff_trigger_time = 0
  end
end

function TitanSil.DOP_in_battlefield(caster, radius, camp)
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

function TitanSil.skillults_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillults = caster.skills.TitanSil_ults
  local bid = 4595
  local ran = ed.rand()
  if 0.86 < ran then
    bid = 4595
  elseif 0.71 < ran then
    bid = 4596
  elseif 0.57 < ran then
    bid = 4597
  elseif 0.43 < ran then
    bid = 4598
  elseif 0.29 < ran then
    bid = 4599
  elseif 0.14 < ran then
    bid = 4600
  else
    bid = 4601
  end
  if target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    if bid == 4597 then
      binfo.fearrange = 5
    end
    local buff = ed.BuffCreate(binfo, target, caster)
    buff.timer = skillults.info["Script Arg2"] * math.min(1 - (target.attribs.TEN - caster.attribs.CON) / 100, 3)
    target:addBuff(buff, caster)
  end
  basefunc(skill, target, source)
end

function TitanSil.onDying(basefunc, hero, killer)
  local skillults2 = hero.skills.TitanSil_ults2
  if skillults2 and not hero.dying_already_cast then
    hero.dying_already_cast = true
    skillults2.target = hero
    local region = skillults2:createRegion()
    region.position = hero.position
    ed.engine:addRegion(region)
  end
  basefunc(hero, killer)
end

function TitanSil.getRuntimeScale(basefunc, self)
  if self.isScaleActionRunning then
    local dt = self.dt_action
    self.scaleActionRunningTime = self.scaleActionRunningTime + dt
    if self.scaleActionRunningTime > self.scaleActionDuration then
      local scale = self.scaleActionScaleValue
      return self.direction * scale, scale
    else
      local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
      return self.direction * scale, scale
    end
  end
  if not self.isScaleActionRunning then
    local m = self.manually_casting
    return self.direction * (m and 1.05 or 1), m and 1.05 or 1
  end
end

function TitanSil.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.caster.TitanSil_ult_target = skill.target
  projectile.hit = override(projectile.hit, TitanSil.projectile_hit)
  projectile.terminate = override(projectile.terminate, TitanSil.projectile_Terminate)
  projectile.update = override(projectile.update, TitanSil.skillult_projectile_update)
  return projectile
end

function TitanSil.skillult_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if projectile.height < 10 and not projectile.terminated then
    projectile:terminate()
  end
end

function TitanSil.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target == skill.target then
    basefunc(projectile, target)
    projectile:terminate()
  else
    return nil
  end
end

function TitanSil.projectile_Terminate(basefunc, self)
  local caster = self.caster
  local skillults2 = caster.skills.TitanSil_ults2
  if skillults2 then
    skillults2.target = caster
    local TitanSil_region = skillults2:createRegion()
    local position = {
      self.position[1],
      self.position[2]
    }
    TitanSil_region.position = position
    ed.engine:addRegion(TitanSil_region)
    caster.TitanSil_ult_target = nil
  end
  basefunc(self)
end

function TitanSil.init_hero(hero)
  local skillult = hero.skills.TitanSil_ult
  local skillults = hero.skills.TitanSil_ults
  local skillults2 = hero.skills.TitanSil_ults2
  local skillatk2 = hero.skills.TitanSil_atk2
  local skillatk3 = hero.skills.TitanSil_atk3
  local skillatk4 = hero.skills.TitanSil_atk4
  hero.TitanSil_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["No Dodge"] = true,
      ["Ignore Shield"] = true
    })
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanSil.skillatk3_createProjectile)
  end
  if skillatk3 and hero.TitanSil_hasArcana and hero.TitanSil_hasArcana > 3 then
    skillatk3.info = ed.wraptable(skillatk3.info, {
      ["AOE Origin"] = "target",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 125
    })
  end
  if skillatk4 and skillatk3 and skillatk2 and skillult then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanSil.skillatk_onAttackFrame)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanSil.skillatk_onAttackFrame)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanSil.skillatk_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanSil.skillatk4_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanSil.skillult_start)
    skillult.finish = override(skillult.finish, TitanSil.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanSil.skillult_onAttackFrame)
    skillult.createProjectile = override(skillult.createProjectile, TitanSil.skillult_createProjectile)
    hero.getRuntimeScale = override(hero.getRuntimeScale, TitanSil.getRuntimeScale)
  end
  if skillults then
    skillults.takeEffectOn = override(skillults.takeEffectOn, TitanSil.skillults_takeEffectOn)
  end
  if skillults2 then
    skillults2.createRegion = override(skillults2.createRegion, TitanSil.skillults2_createRegion)
  end
  if hero.TitanSil_hasArcana and hero.TitanSil_hasArcana > 2 then
    hero.onDying = override(hero.onDying, TitanSil.onDying)
  end
  hero.reset = override(hero.reset, TitanSil.hero_reset)
  return hero
end

return TitanSil.init_hero
