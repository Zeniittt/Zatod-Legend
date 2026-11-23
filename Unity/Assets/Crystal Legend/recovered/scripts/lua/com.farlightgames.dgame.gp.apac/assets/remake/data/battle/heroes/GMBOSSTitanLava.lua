module("ed.battlehero", package.seeall)
local ed = ed
GMBOSSTitanLava = {}

function GMBOSSTitanLava.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hero_skillpasv_casted = nil
  local skillatk3 = hero.skills.GMBOSSTitanLava_atk3
  local skillatk4 = hero.skills.GMBOSSTitanLava_atk4
  if skillatk3 then
    hero.GMBOSSTitanLava_atk3_timer = 0
  end
  if skillatk4 then
    hero.GMBOSSTitanLava_atk4_count = 1
    hero.GMBOSSTitanLava_babycount = 0
  end
end

function GMBOSSTitanLava.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.GMBOSSTitanLava_atk3
  local skillatk4 = hero.skills.GMBOSSTitanLava_atk4
  if hero.hp <= hero.attribs.HP * 0.3 and not hero.hero_skillpasv_casted and skillatk4 then
    hero:addBuff(skillatk4:createBuff(hero), hero)
    hero.hero_skillpasv_casted = true
  end
  if hero.GMBOSSTitanLava_atk3_timer then
    hero.GMBOSSTitanLava_atk3_timer = hero.GMBOSSTitanLava_atk3_timer + dt
  else
    hero.GMBOSSTitanLava_atk3_timer = 0
  end
  if skillatk3 and hero.GMBOSSTitanLava_atk3_timer >= 1 and not hero.GMBOSSTitanLava_atk4_Buff then
    hero.GMBOSSTitanLava_atk3_timer = 0
    skillatk3:takeEffectAt(hero.position, hero)
  end
  if hero.GMBOSSTitanLava_atk4_timer and hero.GMBOSSTitanLava_atk4_count == 0 then
    hero.GMBOSSTitanLava_atk4_timer = hero.GMBOSSTitanLava_atk4_timer + dt
  else
    hero.GMBOSSTitanLava_atk4_timer = 0
  end
  if skillatk4 and hero.GMBOSSTitanLava_atk4_timer >= 45 then
    hero.GMBOSSTitanLava_atk4_timer = 0
    hero.GMBOSSTitanLava_atk4_count = 1
  end
  if hero.GMBOSSTitanLava_atk4_Buff and hero.GMBOSSTitanLava_atk4_timer >= 3 and 0 >= hero.GMBOSSTitanLava_babycount and hero.GMBOSSTitanLava_atk4_count == 0 then
    if hero.actor and hero.actor.node then
      hero.actor.node:setVisible(false)
    end
    hero:die()
  end
end

function GMBOSSTitanLava.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4622
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function GMBOSSTitanLava.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4622 then
      tbuff.timer = 0
    end
  end
end

function GMBOSSTitanLava.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.GMBOSSTitanLava_atk4_Buff then
    return false
  else
    return basefunc(skill, target)
  end
end

function GMBOSSTitanLava.skillult_launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  local caster = skill.caster
  position = {
    caster.position[1],
    caster.position[2]
  }
  position[1] = position[1] + 21 * direction
  if position[1] < 0 or position[1] > 800 then
    position[1] = 400 - 400 * direction
  end
  position[2] = position[2] + 10
  height = 200
  return position, height
end

function GMBOSSTitanLava.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.GMBOSSTitanLava_ult
  local projectile = basefunc(skill)
  local d = {0, 0}
  if projectile then
    local target = skillult:selectTarget()
    if target then
      projectile.GMBOSSTitanLava_targetPosition = target.position
    else
      projectile.GMBOSSTitanLava_targetPosition = GMBOSSTitanLava.DOP_in_battlefield(caster, 120, caster.foecamp)
    end
    projectile.position, projectile.height = skillult:launchPoint()
    if projectile.GMBOSSTitanLava_targetPosition then
      d = {
        projectile.GMBOSSTitanLava_targetPosition[1] - projectile.position[1],
        projectile.GMBOSSTitanLava_targetPosition[2] - projectile.position[2]
      }
      projectile.zSpeed = (projectile.GMBOSSTitanLava_targetPosition[2] - projectile.height) / math.abs((projectile.GMBOSSTitanLava_targetPosition[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
      projectile.max_distance = math.abs(projectile.position[1] - projectile.GMBOSSTitanLava_targetPosition[1])
      projectile.terminate = override(projectile.terminate, GMBOSSTitanLava.skillult_PTerminate)
      projectile.camp = caster.camp
      projectile.can_be_influenced = false
      ed.engine:addProjectile(projectile)
    end
    return nil
  end
end

function GMBOSSTitanLava.DOP_in_battlefield(caster, radius, camp)
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
  end
end

function GMBOSSTitanLava.skillult_PTerminate(basefunc, self)
  local caster = self.caster
  local skillults = caster.skills.GMBOSSTitanLava_ults
  if self.GMBOSSTitanLava_targetPosition then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_TitanLava_ult.cha", {
        self.GMBOSSTitanLava_targetPosition[1],
        self.GMBOSSTitanLava_targetPosition[2]
      }, {
        caster.direction * 0.9,
        0.9
      }, nil, 1)
      ed.scene:playEffectOnScene("eff_impact_TitanLava_ult2.cha", {
        self.GMBOSSTitanLava_targetPosition[1],
        self.GMBOSSTitanLava_targetPosition[2]
      }, {
        caster.direction * 0.9,
        0.9
      }, nil, -1)
      ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
    end
    skillults:takeEffectAt(self.GMBOSSTitanLava_targetPosition, caster)
  end
  basefunc(self)
end

function GMBOSSTitanLava.skillults_takeEffectOn(basefunc, skill, target, source)
  local skillatk3 = skill.caster.skills.GMBOSSTitanLava_atk3
  if skill.caster.GMBOSSTitanLava_hasArcana and skill.caster.GMBOSSTitanLava_hasArcana > 3 and target and target:isAlive() then
    local bid = 4627
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, target)
  end
  if target and target:isAlive() then
    target:hurt()
    if skillatk3 then
      target:addBuff(skillatk3:createBuff(target))
    end
  end
  basefunc(skill, target, source)
end

function GMBOSSTitanLava.skillatk_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local skillatk3 = skill.caster.skills.GMBOSSTitanLava_atk3
  if target and target:isAlive() and skillatk3 then
    target:addBuff(skillatk3:createBuff(target))
  end
end

function GMBOSSTitanLava.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.2
  return power
end

function GMBOSSTitanLava.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local lost = buff.info.HPR - caster.attribs.AP * 0.08
  buff:setAttribute("HPR", lost)
  if caster.GMBOSSTitanLava_hasArcana and caster.GMBOSSTitanLava_hasArcana > 2 then
    buff:setAttribute("MR", math.max(-400, -target.attribs.MR * 0.25))
  end
  return buff
end

function GMBOSSTitanLava.changeBuffInfo(buffInfo, enhance, target, mode)
  local attrib_temp = {}
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
    end
  end
  if buffInfo.ID == 4626 then
    buffInfo.TEN = 10
  end
end

function GMBOSSTitanLava.init_hero(hero)
  local skillult = hero.skills.GMBOSSTitanLava_ult
  local skillatk = hero.skills.GMBOSSTitanLava_atk
  local skillatk2 = hero.skills.GMBOSSTitanLava_atk2
  local skillatk3 = hero.skills.GMBOSSTitanLava_atk3
  local skillatk4 = hero.skills.GMBOSSTitanLava_atk4
  local skillults = hero.skills.GMBOSSTitanLava_ults
  hero.GMBOSSTitanLava_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, GMBOSSTitanLava.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GMBOSSTitanLava.skillatk_takeEffectOn)
    if hero.GMBOSSTitanLava_hasArcana and hero.GMBOSSTitanLava_hasArcana > 1 then
      skillatk2.power = override(skillatk2.power, GMBOSSTitanLava.skillatk2_power)
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GMBOSSTitanLava.skillatk3_createBuff)
  end
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, GMBOSSTitanLava.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, GMBOSSTitanLava.skillult_start)
    skillult.finish = override(skillult.finish, GMBOSSTitanLava.skillult_finish)
    skillult.launchPoint = override(skillult.launchPoint, GMBOSSTitanLava.skillult_launchPoint)
    skillult.createProjectile = override(skillult.createProjectile, GMBOSSTitanLava.skillult_createProjectile)
  end
  if skillults then
    skillults.takeEffectOn = override(skillults.takeEffectOn, GMBOSSTitanLava.skillults_takeEffectOn)
  end
  hero.update = override(hero.update, GMBOSSTitanLava.hero_update)
  hero.reset = override(hero.reset, GMBOSSTitanLava.hero_reset)
  return hero
end

return GMBOSSTitanLava.init_hero
