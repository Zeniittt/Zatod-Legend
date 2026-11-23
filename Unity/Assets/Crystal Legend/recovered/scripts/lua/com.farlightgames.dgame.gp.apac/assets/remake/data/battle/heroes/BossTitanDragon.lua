module("ed.battlehero", package.seeall)
local ed = ed
BossTitanDragon = {}
BossTitanDragon.ult_uncontrollableBuff = 1567
BossTitanDragon.holyshield = 4347
BossTitanDragon.rageBuffID = 4360
BossTitanDragon.ragelosthp = 100000

function BossTitanDragon.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk2 = caster.skills.BossTitanDragon_atk2
  local skillatk2As = caster.skills.BossTitanDragon_atk2As
  local originfo = skill.info
  if skillatk2 and not caster.config.is_summoned and caster:isNormal() and skill.attack_counter == 2 then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 10
    })
    if target and not target:isHasUncontrolBufEffect() then
      local bid = 1568
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    end
    local effect_name = "eff_point_TitanDragon_atk2.cha"
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(effect_name, {
        caster.position[1],
        caster.position[2]
      }, {
        caster.direction * 0.8,
        0.8
      }, nil, 1)
    end
  end
  basefunc(skill)
  skill.info = originfo
end

function BossTitanDragon.skillatk2A_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk2A = caster.skills.BossTitanDragon_atk2A
  local skillatk2As = caster.skills.BossTitanDragon_atk2As
  local originfo = skill.info
  BossTitanDragon.atk2A_caster = caster
  if skillatk2A and not caster.config.is_summoned and not caster:isNormal() and caster.name == "BossTitanDragon" then
    if target and not target:isHasUncontrolBufEffect() then
      target:hurt()
    end
    if skill.attack_counter == 2 then
      skill.info = ed.wraptable(originfo, {
        ["AOE Origin"] = "self",
        ["AOE Shape"] = "rectangle",
        ["Shape Arg1"] = 325,
        ["Shape Arg2"] = 100
      })
      if target then
        skillatk2As:takeEffectAt(caster.position, caster)
      end
      local effect_name = "eff_point_TitanDragon_atk2_a.cha"
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(effect_name, {
          caster.position[1],
          caster.position[2]
        }, {
          caster.direction * 0.8,
          0.8
        }, nil, 1)
      end
    end
  end
  basefunc(skill)
  skill.info = originfo
end

function BossTitanDragon.skillatk2As_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = BossTitanDragon.atk2A_caster
  local skillatk2 = caster.skills.BossTitanDragon_atk2
  local skillatk2A = caster.skills.BossTitanDragon_atk2A
  local skillatk2As = caster.skills.BossTitanDragon_atk2As
  if skillatk2 and skillatk2A and skillatk2As and caster.name == "BossTitanDragon" then
    buff.timer = 2 + caster.attribs.STR / 5000
  end
  return buff
end

function BossTitanDragon.skillatk3A_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3A = caster.skills.BossTitanDragon_atk3A
  local skillatk3As = caster.skills.BossTitanDragon_atk3As
  BossTitanDragon.atk3A_caster = caster
  if skillatk3A and not caster.config.is_summoned and not caster:isNormal() and skill.attack_counter == 0 and caster then
    skillatk3As:takeEffectAt(caster.position, caster)
  end
  basefunc(skill)
end

function BossTitanDragon.skillatk3As_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = BossTitanDragon.atk3A_caster
  local skillatk3 = caster.skills.BossTitanDragon_atk3
  local skillatk3A = caster.skills.BossTitanDragon_atk3A
  local skillatk3As = caster.skills.BossTitanDragon_atk3As
  local atk3A_BuffTime = skillatk3.info["Script Arg2"] + 1
  if skillatk3 and skillatk3A and skillatk3As and caster.name == "BossTitanDragon" then
    buff.timer = atk3A_BuffTime + caster.attribs.STR / 5000
  end
  return buff
end

function BossTitanDragon.DOP_in_battlefield(caster, radius, camp)
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

function BossTitanDragon.skillatk4_launchPoint(basefunc, skill)
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
  position[2] = position[2] + 36
  height = 20
  return position, height
end

function BossTitanDragon.skillatk4_createProjectile(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.BossTitanDragon_atk4
  local skillatk4A = caster.skills.BossTitanDragon_atk4A
  local projectile = basefunc(skill)
  local d = {0, 0}
  if projectile then
    projectile.TitanDRagon_targetPosition = BossTitanDragon.DOP_in_battlefield(caster, 150, caster.foecamp)
    projectile.position, projectile.height = skillatk4:launchPoint()
    if projectile.TitanDRagon_targetPosition then
      d = {
        projectile.TitanDRagon_targetPosition[1] - projectile.position[1],
        projectile.TitanDRagon_targetPosition[2] - projectile.position[2]
      }
      projectile.zSpeed = (projectile.TitanDRagon_targetPosition[2] - projectile.height) / math.abs((projectile.TitanDRagon_targetPosition[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
      projectile.max_distance = math.abs(projectile.position[1] - projectile.TitanDRagon_targetPosition[1])
      projectile.terminate = override(projectile.terminate, BossTitanDragon.skillatk4_PTerminate)
      projectile.camp = caster.camp
      projectile.can_be_influenced = false
      BossTitanDragon.skillatk4AsPosition = projectile.TitanDRagon_targetPosition
      ed.engine:addProjectile(projectile)
    end
    return nil
  end
end

function BossTitanDragon.skillatk4_PTerminate(basefunc, self)
  local caster = self.caster
  local skillatk4s = caster.skills.BossTitanDragon_atk4s
  local skillatk4As = caster.skills.BossTitanDragon_atk4As
  local TitanDragon_region
  if self.TitanDRagon_targetPosition and caster:isNormal() and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanDragon_atk4_2.cha", {
      self.TitanDRagon_targetPosition[1],
      self.TitanDRagon_targetPosition[2]
    }, {
      caster.direction * 0.8,
      0.8
    }, nil, -1)
  end
  if caster:isAlive() and self.TitanDRagon_targetPosition then
    skillatk4s:takeEffectAt(self.TitanDRagon_targetPosition, caster)
    if caster.name == "BossTitanDragon" and not caster:isNormal() then
      skillatk4As.target = caster
      TitanDragon_region = skillatk4As:createRegion()
      caster.TitanDragon_region = TitanDragon_region
      ed.engine:addRegion(TitanDragon_region)
    end
  end
  basefunc(self)
end

function BossTitanDragon.skillatk4s_takeEffectAt(basefunc, skill, source, location)
  local caster = skill.caster
  local skillatk4s = caster.skills.BossTitanDragon_atk4s
  local originfo = skill.info
  if skillatk4s and caster.name == "BossTitanDragon" and not caster:isNormal() then
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = "1.2"
    })
  end
  basefunc(skill, source, location)
  skill.info = originfo
end

function BossTitanDragon.skillatk4As_takeRegionEffectOn(basefunc, self, unit)
  local hero = self.skill.caster
  local skillatk4As = self.skill
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  unit:addBuff(buff)
end

function BossTitanDragon.skillatk4As_createRegion(basefunc, self)
  local region = basefunc(self)
  local position = BossTitanDragon.skillatk4AsPosition
  if position then
    region.position = position
    region.takeRegionEffectOn = override(region.takeRegionEffectOn, BossTitanDragon.skillatk4As_takeRegionEffectOn)
    return region
  end
end

function BossTitanDragon.ult_func_hideBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
end

function BossTitanDragon.ult_func_resetBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(true)
      end
    end
  end
end

function BossTitanDragon.ult_func_AngryChangeToNormal(unit)
  if not (not unit:isNormal() and unit:isAlive()) or unit.name ~= "BossTitanDragon" then
    return
  end
  unit:enterActionStageFromOneStage(unit:getNormalPeriod(), 10086)
  BossTitanDragon.isAngry = false
  if unit.TitanDragonAngryBuff and unit.TitanDragonAngryBuff.class == ed.Buff and unit.TitanDragonAngryBuff.timer > 0 then
    unit:removeBuff(unit.TitanDragonAngryBuff)
    unit.TitanDragonAngryBuff = nil
  end
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/common/mp_rage.png"))
    end
  end
end

function BossTitanDragon.ult_func_NormalChangeToAngry(unit)
  if not (unit:isNormal() and unit:isAlive()) or unit.name ~= "BossTitanDragon" then
    return
  end
  unit:enterActionStageFromOneStage(unit:getAngryPeriod(), 10086)
  BossTitanDragon.isAngry = true
  local owner = unit
  local bid = 1566
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff1 = ed.BuffCreate(binfo, owner, owner)
  local skillult = unit.skills.BossTitanDragon_ult
  local MPR = skillult.info["Script Arg2"]
  local SpeedUp = skillult.info["Script Arg3"]
  local AdArmp = skillult.info["Script Arg4"] * 0.01
  if unit.name == "BossTitanDragon" and not unit.config.is_summoned and unit:isAlive() then
    buff1:setAttribute("AD", unit.attribs.AD * AdArmp)
    buff1:setAttribute("ARMP", unit.attribs.ARMP * AdArmp)
    buff1:setAttribute("MPR", -30 + MPR)
    buff1:setAttribute("HAST", SpeedUp)
    buff1:setAttribute("MSPD", SpeedUp)
  end
  owner:addBuff(buff1, owner)
  unit.TitanDragonAngryBuff = buff1
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/common/mp_rage_2.png"))
    end
  end
end

function BossTitanDragon.ult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster:isNormal() and caster.mp < 500 then
    return false, "mp not enough"
  elseif not caster:isNormal() then
    return false, "Already Angry"
  end
  if BossTitanDragon.canCastUlt == false then
    return false, "BossTitanDragon_Ult Casting"
  end
  return basefunc(skill, target)
end

function BossTitanDragon.ult_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, BossTitanDragon.ult_uncontrollableBuff)
  local buff = caster:addBuff(binfo, caster)
  skill.TitanDragon_uncontrollableBuff = buff
  BossTitanDragon.canCastUlt = false
  if caster:isNormal() then
    skill.changeMode = "NtoA"
  else
    skill.changeMode = "AtoN"
  end
  BossTitanDragon.ult_func_hideBuffEffect(caster)
end

function BossTitanDragon.ult_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function BossTitanDragon.ult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.TitanDragon_uncontrollableBuff then
    skill.TitanDragon_uncontrollableBuff.timer = -1
    skill.TitanDragon_uncontrollableBuff = nil
  end
  if skill.changeMode == "NtoA" and caster:isNormal() then
    BossTitanDragon.ult_func_NormalChangeToAngry(caster)
  elseif skill.changeMode == "AtoN" and not caster:isNormal() then
    BossTitanDragon.ult_func_AngryChangeToNormal(caster)
  end
  skill.changeMode = nil
  BossTitanDragon.canCastUlt = true
  BossTitanDragon.ult_func_resetBuffEffect(caster)
end

function BossTitanDragon.hero_collectHPchange(basefunc, self, config)
  local unit = config.unit
  local hero = self
  if unit.camp == hero.camp and unit:isHero() and config.hp_change < 0 then
    local HP_change = -config.hp_change
    if unit == hero then
      hero:setMP(hero.mp + HP_change * 0.01)
    else
      hero:setMP(hero.mp + HP_change * 0.005)
    end
  end
end

function BossTitanDragon.Boss_holyshield_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  if damage_type == "Holy" then
    local lastdamage = basefunc(buff, damage, damage_type, source, skill, transferred, field)
    return lastdamage
  else
    return 0
  end
end

function BossTitanDragon.Boss_holyshield_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  if buff.owner.BossTitanDragon_holyshield then
    buff.owner.BossTitanDragon_holyshield = nil
  end
end

function BossTitanDragon.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.BossTitanDragon_ult
  local skillults = hero.skills.BossTitanDragon_ults
  local skillatk = hero.skills.BossTitanDragon_atk
  local skillatk2A = hero.skills.BossTitanDragon_atk2A
  local skillatk3A = hero.skills.BossTitanDragon_atk3A
  local skillatk4A = hero.skills.BossTitanDragon_atk4A
  if hero:isAlive() and not hero:isNormal() and hero.name == "BossTitanDragon" then
    if skillatk.casting or skillatk2A.casting or skillatk3A.casting or skillatk4A.casting then
      hero.skillOncasting = true
    else
      hero.skillOncasting = false
    end
  end
  if skillult and hero:isAlive() and hero.mp <= 10 and hero.currentActionStage == 2 and hero.skillOncasting == false and BossTitanDragon.isAngry == true then
    BossTitanDragon.isAngry = false
    hero:castSkill(skillults, hero)
  end
  if not hero.BossTitanDragon_holyshield and hero.BossTitanDragon_holyshield_cd > 0 then
    hero.BossTitanDragon_holyshield_cd = hero.BossTitanDragon_holyshield_cd - dt
  end
  if not hero.BossTitanDragon_holyshield and hero.BossTitanDragon_holyshield_cd <= 0 then
    local bid = BossTitanDragon.holyshield
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.onDamaged = override(buff.onDamaged, BossTitanDragon.Boss_holyshield_buff_onDamaged)
    buff.onRemoved = override(buff.onRemoved, BossTitanDragon.Boss_holyshield_buff_onRemoved)
    buff.shield = 100000 * hero.holubufftimes
    hero.holubufftimes = hero.holubufftimes + 1
    hero.BossTitanDragon_holyshield = hero:addBuff(buff, hero)
    hero.BossTitanDragon_holyshield_cd = 15
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  while hero.lastRageHp - hero.hp >= BossTitanDragon.ragelosthp do
    local binfo
    local bid = BossTitanDragon.rageBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
    hero.lastRageHp = hero.lastRageHp - BossTitanDragon.ragelosthp
    hero.rageStack = hero.rageStack + 1
  end
end

function BossTitanDragon.buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  return damage
end

function BossTitanDragon.hero_die(basefunc, hero)
  basefunc(hero)
  if hero.TitanDragon_region then
    hero.TitanDragon_region:terminate()
  end
end

function BossTitanDragon.hero_reset(basefunc, hero)
  basefunc(hero)
  BossTitanDragon.isAngry = false
  hero.skillOncasting = false
  BossTitanDragon.atk3A_caster = nil
  BossTitanDragon.atk2A_caster = nil
  BossTitanDragon.canCastUlt = true
  hero.holubufftimes = 1
  if hero.currentActionStage == 2 then
    hero:enterActionStageFromOneStage(hero:getNormalPeriod(), 10086)
  end
  hero.BossTitanDragon_holyshield = false
  hero.BossTitanDragon_holyshield_cd = 0
end

function BossTitanDragon.init_hero(hero)
  hero.skillOncasting = false
  BossTitanDragon.isAngry = false
  hero.reset = override(hero.reset, BossTitanDragon.hero_reset)
  hero.update = override(hero.update, BossTitanDragon.hero_update)
  hero.die = override(hero.die, BossTitanDragon.hero_die)
  local skillult = hero.skills.BossTitanDragon_ult
  local skillults = hero.skills.BossTitanDragon_ults
  local skillatk2 = hero.skills.BossTitanDragon_atk2
  local skillatk4 = hero.skills.BossTitanDragon_atk4
  local skillatk2A = hero.skills.BossTitanDragon_atk2A
  local skillatk2As = hero.skills.BossTitanDragon_atk2As
  local skillatk3A = hero.skills.BossTitanDragon_atk3A
  local skillatk3As = hero.skills.BossTitanDragon_atk3As
  local skillatk4A = hero.skills.BossTitanDragon_atk4A
  local skillatk4As = hero.skills.BossTitanDragon_atk4As
  local skillatk4s = hero.skills.BossTitanDragon_atk4s
  if hero.name == "BossTitanDragon" then
    hero:setActionStageChangeByManual(true)
    hero.collectHPchange = override(hero.collectHPchange, BossTitanDragon.hero_collectHPchange)
  end
  if skillult and not hero.config.is_summoned then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BossTitanDragon.ult_canCastWithTarget)
    skillult.start = override(skillult.start, BossTitanDragon.ult_start)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, BossTitanDragon.ult_onPhaseFinished)
    skillult.finish = override(skillult.finish, BossTitanDragon.ult_finish)
  end
  if skillults and not hero.config.is_summoned then
    skillults.start = override(skillults.start, BossTitanDragon.ult_start)
    skillults.onPhaseFinished = override(skillults.onPhaseFinished, BossTitanDragon.ult_onPhaseFinished)
    skillults.finish = override(skillults.finish, BossTitanDragon.ult_finish)
  end
  if skillatk2 and hero.name == "BossTitanDragon" then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, BossTitanDragon.skillatk2_onAttackFrame)
  end
  if skillatk2A and not hero.config.is_summoned and hero.name == "BossTitanDragon" then
    skillatk2A.onAttackFrame = override(skillatk2A.onAttackFrame, BossTitanDragon.skillatk2A_onAttackFrame)
  end
  if skillatk2As and not hero.config.is_summoned and hero.name == "BossTitanDragon" then
    skillatk2As.createBuff = override(skillatk2As.createBuff, BossTitanDragon.skillatk2As_createBuff)
  end
  if skillatk3A and not hero.config.is_summoned and hero.name == "BossTitanDragon" then
    skillatk3A.onAttackFrame = override(skillatk3A.onAttackFrame, BossTitanDragon.skillatk3A_onAttackFrame)
  end
  if skillatk3As and not hero.config.is_summoned and hero.name == "BossTitanDragon" then
    skillatk3As.createBuff = override(skillatk3As.createBuff, BossTitanDragon.skillatk3As_createBuff)
  end
  if skillatk4 then
    skillatk4.launchPoint = override(skillatk4.launchPoint, BossTitanDragon.skillatk4_launchPoint)
    skillatk4.createProjectile = override(skillatk4.createProjectile, BossTitanDragon.skillatk4_createProjectile)
  end
  if skillatk4A and not hero.config.is_summoned and hero.name == "BossTitanDragon" then
    skillatk4A.launchPoint = override(skillatk4A.launchPoint, BossTitanDragon.skillatk4_launchPoint)
    skillatk4A.createProjectile = override(skillatk4A.createProjectile, BossTitanDragon.skillatk4_createProjectile)
  end
  if skillatk4As then
    skillatk4As.createRegion = override(skillatk4As.createRegion, BossTitanDragon.skillatk4As_createRegion)
  end
  if skillatk4s then
    skillatk4s.takeEffectAt = override(skillatk4s.takeEffectAt, BossTitanDragon.skillatk4s_takeEffectAt)
  end
  
  function hero.getNormalPeriod(unit)
    local period = 1
    return period
  end
  
  function hero.getAngryPeriod(unit)
    local period = 2
    return period
  end
  
  function hero.isNormal(unit)
    local current = unit.currentActionStage or 1
    if current == 2 then
      return false
    end
    return true
  end
  
  function hero.isAngry(unit)
    local current = unit.currentActionStage or 2
    if current == 1 then
      return false
    end
    return true
  end
  
  return hero
end

return BossTitanDragon.init_hero
