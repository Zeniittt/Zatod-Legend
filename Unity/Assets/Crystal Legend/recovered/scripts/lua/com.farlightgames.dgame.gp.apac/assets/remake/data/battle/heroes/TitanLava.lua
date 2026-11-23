module("ed.battlehero", package.seeall)
local ed = ed
TitanLava = {}
TitanLava.ragelosthp = 35000
TitanLava.rage2losthp = 15000
TitanLava.stage2hp = 1750000
TitanLava.stage2ragelosthp = 7500

function TitanLava.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk3 = hero.skills.TitanLava_atk3
  local skillatk4 = hero.skills.TitanLava_atk4
  if skillatk4 then
    local bid = 11015003
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, TitanLava.rage_buff_update)
  hero.lastrageStack = 0
end

function TitanLava.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.TitanLava_atk3
  local skillatk4 = hero.skills.TitanLava_atk4
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanLava.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanLava.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanLava.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= TitanLava.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanLava.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanLava.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
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

function TitanLava.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 11015001
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanLava.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11015001 then
      tbuff.timer = 0
    end
  end
end

function TitanLava.skillult_launchPoint(basefunc, skill)
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

function TitanLava.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanLava_ult
  local projectile = basefunc(skill)
  local d = {0, 0}
  if projectile then
    local target = skillult:selectTarget()
    if target then
      projectile.TitanLava_targetPosition = target.position
    else
      projectile.TitanLava_targetPosition = TitanLava.DOP_in_battlefield(caster, 120, caster.foecamp)
    end
    projectile.position, projectile.height = skillult:launchPoint()
    if projectile.TitanLava_targetPosition then
      d = {
        projectile.TitanLava_targetPosition[1] - projectile.position[1],
        projectile.TitanLava_targetPosition[2] - projectile.position[2]
      }
      projectile.zSpeed = (projectile.TitanLava_targetPosition[2] - projectile.height) / math.abs((projectile.TitanLava_targetPosition[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
      projectile.max_distance = math.abs(projectile.position[1] - projectile.TitanLava_targetPosition[1])
      projectile.terminate = override(projectile.terminate, TitanLava.skillult_PTerminate)
      projectile.camp = caster.camp
      projectile.can_be_influenced = false
      ed.engine:addProjectile(projectile)
    end
    return nil
  end
end

function TitanLava.DOP_in_battlefield(caster, radius, camp)
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

function TitanLava.skillult_PTerminate(basefunc, self)
  local caster = self.caster
  local skillults = caster.skills.TitanLava_ults
  if self.TitanLava_targetPosition then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_TitanLava_ult.cha", {
        self.TitanLava_targetPosition[1],
        self.TitanLava_targetPosition[2]
      }, {
        caster.direction * 0.9,
        0.9
      }, nil, 1)
      ed.scene:playEffectOnScene("eff_impact_TitanLava_ult2.cha", {
        self.TitanLava_targetPosition[1],
        self.TitanLava_targetPosition[2]
      }, {
        caster.direction * 0.9,
        0.9
      }, nil, -1)
      ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
    end
    skillults:takeEffectAt(self.TitanLava_targetPosition, caster)
  end
  basefunc(self)
end

function TitanLava.skillults_takeEffectOn(basefunc, skill, target, source)
  local skillatk3 = skill.caster.skills.TitanLava_atk3
  if target and target:isAlive() then
    target:hurt()
    if skillatk3 then
      target:addBuff(skillatk3:createBuff(target))
    end
  end
  basefunc(skill, target, source)
end

function TitanLava.skillatk_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local skillatk3 = skill.caster.skills.TitanLava_atk3
  if target and target:isAlive() and skillatk3 then
    target:addBuff(skillatk3:createBuff(target))
  end
end

function TitanLava.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local lost = buff.info.HPR - caster.attribs.AP * 0.08
  buff:setAttribute("HPR", lost)
  return buff
end

function TitanLava.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill, field)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill, field)
  local skillatk4 = hero.skills.TitanLava_atk4
  if lost and 0 < lost and skillatk4 and damage_type == "Holy" and field == "hp" then
    lost = lost * 1.99
  end
  return lost
end

function TitanLava.init_hero(hero)
  local skillult = hero.skills.TitanLava_ult
  local skillatk = hero.skills.TitanLava_atk
  local skillatk2 = hero.skills.TitanLava_atk2
  local skillatk3 = hero.skills.TitanLava_atk3
  local skillatk4 = hero.skills.TitanLava_atk4
  local skillults = hero.skills.TitanLava_ults
  hero.TitanLava_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.start = override(skillult.start, TitanLava.skillult_start)
    skillult.finish = override(skillult.finish, TitanLava.skillult_finish)
    skillult.launchPoint = override(skillult.launchPoint, TitanLava.skillult_launchPoint)
    skillult.createProjectile = override(skillult.createProjectile, TitanLava.skillult_createProjectile)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanLava.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanLava.skillatk_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanLava.skillatk3_createBuff)
  end
  if skillatk4 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanLava.getLostHPAfterImmunity)
  end
  if skillults then
    skillults.takeEffectOn = override(skillults.takeEffectOn, TitanLava.skillults_takeEffectOn)
  end
  hero.update = override(hero.update, TitanLava.hero_update)
  hero.reset = override(hero.reset, TitanLava.hero_reset)
  return hero
end

return TitanLava.init_hero
