module("ed.battlehero", package.seeall)
local ed = ed
TitanWR = {}

function TitanWR.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if caster.TitanWR_hasArcana and caster.TitanWR_hasArcana > 3 then
    local target = skill.target
    local bid = 4574
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
  basefunc(skill, target, source)
end

function TitanWR.skillults_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local originfo = skill.info
  if caster.TitanWR_hasArcana and caster.TitanWR_hasArcana > 3 then
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 4566
    })
  end
  basefunc(skill, target, source)
end

function TitanWR.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.25
  return power
end

function TitanWR.skillatk3_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  if target == skill.target then
    basefunc(projectile, target)
    projectile:terminate()
  end
end

function TitanWR.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, TitanWR.skillatk3_projectile_hit)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function TitanWR.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local hero = skill.caster
  local skillatk3 = hero.skills.TitanWR_atk3
  if hero.TitanWR_hasArcana and hero.TitanWR_hasArcana > 2 then
    local bid = 4567
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, hero)
  end
  if target.info["Main Attrib"] == "INT" then
    if hero.TitanWR_hasArcana and hero.TitanWR_hasArcana > 3 then
      local bid = 4566
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, hero)
    else
      local bid = 4565
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, hero)
    end
  end
  if skillatk3 and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_TitanWR_atk3.cha", target.position, {
      hero.direction * 0.75,
      0.75
    }, nil, -1)
  end
  basefunc(skill, target, source)
end

function TitanWR.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  if caster.TitanWR_hasArcana and caster.TitanWR_hasArcana > 3 then
    local target = skill.target
    local bid = 4574
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
  if owner and owner:isAlive() then
    local stunbid = 105
    local binfo = ed.lookupDataTable("Buff", nil, stunbid)
    local buff = ed.BuffCreate(binfo, owner, caster)
    buff.timer = skill.info["Script Arg2"]
    if target.attribs.TEN then
      buff.timer = math.floor(buff.timer * (1 - target.attribs.TEN / 100))
    else
      buff.timer = buff.timer
    end
    owner:addBuff(buff, caster)
  end
  return buff
end

function TitanWR.getRuntimeScale(basefunc, self)
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

function TitanWR.DOP_in_battlefield(caster, radius, camp)
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
    return caster.position
  end
end

function TitanWR.butterfly_ult_power(basefunc, skill, source, target)
  local caster = skill.caster
  local power, i = basefunc(skill, source, target)
  if skill.attack_counter == 1 or skill.attack_counter == 3 then
    for j, bbuff in ipairs(target.buff_list) do
      if caster.TitanAA_hasArcana and 3 < caster.TitanAA_hasArcana and bbuff.info.ID == 4566 or bbuff.info.ID == 4565 then
        if bbuff.rank then
          target.butterfly_rank = bbuff.rank
        else
          target.butterfly_rank = 0
        end
      end
    end
    if 0 < power and target.butterfly_rank then
      power = power * (1 + 0.6 * target.butterfly_rank)
    end
  end
  return power, i
end

function TitanWR.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.TitanWR_ult
  local skillults = caster.skills.TitanWR_ults
  local target = skill.target
  local WRtarget_position = TitanWR.DOP_in_battlefield(caster, 150, caster.foecamp)
  local skillRemnant = caster.skills.TitanWR_Remnant1
  if skillult then
    if attack_counter == 0 then
      WRtarget_position = TitanWR.DOP_in_battlefield(caster, 150, caster.foecamp)
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 and WRtarget_position then
      skillult:takeEffectAt(WRtarget_position, caster)
      if skillRemnant then
        skillRemnant:takeEffectAt(WRtarget_position, caster)
      end
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanWR_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, WRtarget_position, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 2 and WRtarget_position then
      skillults:takeEffectAt(WRtarget_position, caster)
      if skillRemnant then
        skillRemnant:takeEffectAt(WRtarget_position, caster)
      end
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanWR_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, WRtarget_position, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 3 and WRtarget_position then
      skillult:takeEffectAt(WRtarget_position, caster)
      if skillRemnant then
        skillRemnant:takeEffectAt(WRtarget_position, caster)
      end
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanWR_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, WRtarget_position, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanWR.init_hero(hero)
  hero.TitanWR_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillatk2 = hero.skills.TitanWR_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanWR.skillatk2_takeEffectOn)
    if hero.TitanWR_hasArcana and hero.TitanWR_hasArcana > 1 then
      skillatk2.power = override(skillatk2.power, TitanWR.skillatk2_power)
    end
  end
  local skillatk3 = hero.skills.TitanWR_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanWR.skillatk3_createProjectile)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanWR.skillatk3_takeEffectOn)
  end
  local skillatk4 = hero.skills.TitanWR_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanWR.skillatk4_CreateBuff)
  end
  local skillult = hero.skills.TitanWR_ult
  if skillult then
    hero.getRuntimeScale = override(hero.getRuntimeScale, TitanWR.getRuntimeScale)
    skillult.power = override(skillult.power, TitanWR.butterfly_ult_power)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanWR.skillult_onAttackFrame)
  end
  local skillults = hero.skills.TitanWR_ults
  if skillults then
    if hero.TitanWR_hasArcana and hero.TitanWR_hasArcana > 3 then
      skillults.info = ed.wraptable(skillults.info, {
        ["Buff ID"] = 4566
      })
    end
    skillults.takeEffectOn = override(skillults.takeEffectOn, TitanWR.skillults_takeEffectOn)
  end
  return hero
end

return TitanWR.init_hero
