module("ed.battlehero", package.seeall)
local ed = ed
TitanCoco = {}
TitanCoco.skillFashionId = 100741
TitanCoco.TitanCoco_floatBuffID = 1505
TitanCoco.TitanCoco_ultBuffID = 1507
TitanCoco.TitanCoco_ult_powerratio = 1.3
TitanCoco.TitanCoco_uncontrollBuffID = 1511

function TitanCoco.DOP_in_battlefield(caster, radius, camp)
  local point_list = {}
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local x = 0
  local y = 0
  local distance = 0
  local mindistance = 999999999
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
    return false
  end
end

function TitanCoco.setUnitHeight(unit, height)
  unit.height = height
  if unit.actor then
    unit.actor.height = height
  end
end

function TitanCoco.update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function TitanCoco.reset(basefunc, hero)
  basefunc(hero)
end

function TitanCoco.skillatk_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillfashion = caster.skills.TitanCoco_Fashion
  if attack_counter == 0 then
    basefunc(skill)
    if TitanCoco.skillFashionId and TitanCoco.skillFashionId == caster.fashion_id and skillfashion then
      TitanCoco.Fashion_Sowrd(caster)
    end
  elseif attack_counter == 1 then
    if TitanCoco.skillFashionId and TitanCoco.skillFashionId == caster.fashion_id and skillfashion then
      TitanCoco.Fashion_Gun(skill)
    end
    local skillatks = skill.caster.skills.TitanCoco_atks
    if skillatks then
      skillatks.target = skillatks:selectTarget(nil)
      if skillatks.target and skillatks.target:isAlive() then
        local projectile = skillatks:createProjectile()
        ed.engine:addProjectile(projectile)
      end
    end
  end
end

function TitanCoco.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillfashion = caster.skills.TitanCoco_Fashion
  if TitanCoco.skillFashionId and TitanCoco.skillFashionId == caster.fashion_id and skillfashion then
    TitanCoco.Fashion_Gun(skill)
  end
  basefunc(skill)
end

function TitanCoco.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target.config.summoner then
    buff.timer = buff.timer * 2
    buff:setAttribute("HIT", -1000)
  end
  return buff
end

function TitanCoco.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanCoco_ult.cha"
      local position, h = skill:launchPoint()
      local caster = skill.caster
      local effect = ed.scene:playEffectOnScene(effect_name, position, {
        caster.direction * 0.85,
        0.85
      }, nil, 1, nil, nil, nil)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
    local caster = skill.caster
    local skillults = caster.skills.TitanCoco_ults
    skillults.createBuff = override(skillults.createBuff, TitanCoco.skillults_createBuff)
    skillults:takeEffectAt(caster.position, caster)
  end
end

function TitanCoco.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local stars = skill.caster.stars
  if 5 <= stars then
    buff.timer = 12 - 1 * (10 - stars)
    buff:setAttribute("MIMU", 50 - 7 * (10 - stars))
  else
    buff.timer = 7
    buff:setAttribute("MIMU", 15)
  end
  return buff
end

function TitanCoco.skillult_start(basefunc, skill, target)
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function TitanCoco.skillult_finish(basefunc, skill)
  basefunc(skill)
end

function TitanCoco.skillult_launchPoint(basefunc, skill)
  local caster = skill.caster
  local dir = caster.direction
  return {
    400 - dir * 400,
    0
  }, 0
end

function TitanCoco.skillult_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if power and target.height > 0 then
    power = power * TitanCoco.TitanCoco_ult_powerratio
  end
  local skillRemnant2 = caster.skills.TitanCoco_Remnant2
  if skillRemnant2 then
    power = power * 2
  end
  return power
end

function TitanCoco.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local haveFloatBuff
  if result and target:isAlive() then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == TitanCoco.TitanCoco_floatBuffID then
        tbuff.timer = 0
        haveFloatBuff = true
      end
    end
  end
  if haveFloatBuff and target:isAlive() then
    local bid = TitanCoco.TitanCoco_ultBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, target)
  end
end

function TitanCoco.skillatk3_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.height = 0
  if owner.actor then
    owner.actor.height = 0
  end
end

function TitanCoco.skillatk3_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.time_index then
    buff.time_index = 0
  else
    buff.time_index = buff.time_index + 1
  end
  local owner = buff.owner
  if buff.time_index <= 8 then
    TitanCoco.setUnitHeight(owner, owner.height + 5 + (1 - 2 * ed.rand()))
  else
    TitanCoco.setUnitHeight(owner, owner.height + 1 - 2 * ed.rand())
  end
end

function TitanCoco.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.update = override(buff.update, TitanCoco.skillatk3_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, TitanCoco.skillatk3_buffOnRemoved)
  local skillRemnant1 = caster.skills.TitanCoco_Remnant1
  if skillRemnant1 then
    buff:setAttribute("ARM", target.attribs.ARM * -0.3)
    buff:setAttribute("MR", target.attribs.MR * -0.3)
  end
  return buff
end

function TitanCoco.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target:isAlive() then
    target:hurt()
  end
end

function TitanCoco.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local position = TitanCoco.DOP_in_battlefield(caster, 150, caster.foecamp)
  if position then
    local bid = TitanCoco.TitanCoco_uncontrollBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    caster.TitanCoco_atk3_position = {
      position[1],
      position[2]
    }
    basefunc(skill, target)
  else
    skill:finish()
  end
end

function TitanCoco.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, skill.caster.TitanCoco_atk3_position, source)
end

function TitanCoco.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillfashion = caster.skills.TitanCoco_Fashion
  if TitanCoco.skillFashionId and TitanCoco.skillFashionId == caster.fashion_id and skillfashion then
    TitanCoco.Fashion_Gun(skill)
  end
  basefunc(skill)
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanCoco_atk3_front.cha"
    local caster = skill.caster
    local position = caster.TitanCoco_atk3_position
    caster.TitanCoco_atk3_effect = ed.scene:playEffectOnScene(effect_name, position, {
      caster.direction,
      1
    }, nil, 0, nil, nil, nil)
    local effect_name2 = "eff_point_TitanCoco_atk3_back.cha"
    caster.TitanCoco_atk3_effect2 = ed.scene:playEffectOnScene(effect_name2, position, {
      caster.direction,
      1
    }, nil, -1, nil, nil, nil)
  end
end

function TitanCoco.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if not owner.buff_effects.stable then
    local time = dt
    owner:knockup(time * 2, ed.edpSub(caster.TitanCoco_atk4_position, owner.position), true)
  end
end

function TitanCoco.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanCoco.skillatk4_buffUpdate)
  return buff
end

function TitanCoco.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = TitanCoco.TitanCoco_uncontrollBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.TitanCoco_atk4_position = {
    caster.position[1] + caster.direction * 150,
    caster.position[2]
  }
  basefunc(skill, target)
end

function TitanCoco.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillfashion = caster.skills.TitanCoco_Fashion
  if TitanCoco.skillFashionId and TitanCoco.skillFashionId == caster.fashion_id and skillfashion then
    TitanCoco.Fashion_Sowrd(caster)
  end
  basefunc(skill)
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanCoco_atk4.cha"
    local caster = skill.caster
    local effect = ed.scene:playEffectOnScene(effect_name, caster.TitanCoco_atk4_position, {
      caster.direction,
      1
    }, nil, 1, nil, nil, nil)
  end
end

function TitanCoco.Fashion_Sowrd(hero)
  local bid = 4157
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanCoco.Fashion_Gun(skill)
  local origin_plusratio = skill.info["Plus Ratio"]
  if origin_plusratio < 2.5 then
    skill.info = ed.wraptable(skill.info, {
      ["Plus Ratio"] = origin_plusratio + 0.5
    })
  end
end

function TitanCoco.init_hero(hero)
  local skillult = hero.skills.TitanCoco_ult
  local skillults = hero.skills.TitanCoco_ults
  local skillatk = hero.skills.TitanCoco_atk
  local skillatk2 = hero.skills.TitanCoco_atk2
  local skillatk3 = hero.skills.TitanCoco_atk3
  local skillatk4 = hero.skills.TitanCoco_atk4
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, TitanCoco.skillatk_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanCoco.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanCoco.skillatk2_createBuff)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanCoco.skillult_onAttackFrame)
    skillult.launchPoint = override(skillult.launchPoint, TitanCoco.skillult_launchPoint)
    skillult.power = override(skillult.power, TitanCoco.skillult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanCoco.skillult_takeEffectOn)
    skillult.start = override(skillult.start, TitanCoco.skillult_start)
    skillult.finish = override(skillult.finish, TitanCoco.skillult_finish)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanCoco.skillatk3_createBuff)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanCoco.skillatk3_takeEffectOn)
    skillatk3.start = override(skillatk3.start, TitanCoco.skillatk3_start)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, TitanCoco.skillatk3_takeEffectAt)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanCoco.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanCoco.skillatk4_createBuff)
    skillatk4.start = override(skillatk4.start, TitanCoco.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanCoco.skillatk4_onAttackFrame)
  end
  hero.reset = override(hero.reset, TitanCoco.reset)
  return hero
end

return TitanCoco.init_hero
