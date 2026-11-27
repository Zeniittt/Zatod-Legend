module("ed.battlehero", package.seeall)
local ed = ed
TitanHR = {}
TitanHR.ult_point_effect = "eff_buff_TitanHR_ult.cha"
TitanHR.ult = 11018801
TitanHR.atk3_sil = 11018804
TitanHR.atk2_arcana = 11018806
TitanHR.atk4_arcana = 11018807
TitanHR.atk4_passive = 11018808
TitanHR.atk4_uncontrollable = 11018809
TitanHR.ragelosthp = 35000
TitanHR.rage2losthp = 15000
TitanHR.stage2hp = 1750000
TitanHR.stage2ragelosthp = 7500

function TitanHR.hero_castManualSkill(basefunc, hero)
  basefunc(hero)
  if ed.run_with_scene then
    local currentSkill = hero.current_skill
    if currentSkill == hero.manual_skill and currentSkill.target and not currentSkill.TitanHR_ultEffect then
      currentSkill.TitanHR_ultEffect = true
      local effect_name = TitanHR.ult_point_effect
      local target = currentSkill.target
      local position = target.position
      local height = target.height
      currentSkill.TitanHR_ult_targetEffect = ed.scene:playEffectOnScene(effect_name, position, nil, height, 1)
    end
  end
end

function TitanHR.skillult_finish(basefunc, skill)
  basefunc(skill)
  if skill.TitanHR_ultEffect then
    ed.scene:removeEffect(skill.TitanHR_ult_targetEffect, 1)
    skill.TitanHR_ultEffect = false
  end
end

function TitanHR.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local d = {0, 0}
  if projectile then
    projectile.hit = override(projectile.hit, TitanHR.skillult_projectile_hit)
    local target = skill.target
    local targetposition = target.position
    projectile.TitanHR_targetPosition = {
      targetposition[1],
      targetposition[2]
    }
    if projectile.TitanHR_targetPosition then
      d = {
        projectile.TitanHR_targetPosition[1] - projectile.position[1],
        projectile.TitanHR_targetPosition[2] - projectile.position[2]
      }
      projectile.zSpeed = (0 - projectile.height) / math.abs((projectile.TitanHR_targetPosition[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
      projectile.camp = caster.camp
      projectile.can_be_influenced = false
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end

function TitanHR.skillult_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  if target ~= skill.target then
    return
  else
    basefunc(projectile, target)
    projectile:terminate()
  end
end

function TitanHR.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local originfo = skill.info
  if skill.TitanHR_ultEffect then
    ed.scene:removeEffect(skill.TitanHR_ult_targetEffect, 1)
    skill.TitanHR_ultEffect = false
  end
  if caster.TitanHR_hasArcana and caster.TitanHR_hasArcana > 3 and not target.config.is_boss then
    local hpratio = target.hp / target.attribs.HP
    local killratio = 0.35
    if hpratio < killratio then
      skill.info = ed.wraptable(originfo, {
        ["Basic Num"] = originfo["Basic Num"] * 2,
        ["Plus Ratio"] = originfo["Plus Ratio"] * 2
      })
    end
  end
  local ret, dmg = basefunc(skill, target, source)
  skill.info = originfo
  return ret, dmg
end

function TitanHR.skillatk2_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local target = skill.target
  if caster.TitanHR_hasArcana and caster.TitanHR_hasArcana > 1 and target then
    local bid = TitanHR.atk2_arcana
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local addown = target.attribs.AD * 0.3
    local apdown = target.attribs.AP * 0.3
    local buffarcana = ed.BuffCreate(binfo, target, caster)
    buffarcana:setAttribute("AD", -math.max(0, addown))
    buffarcana:setAttribute("AP", -math.max(0, apdown))
    target:addBuff(buffarcana, caster)
  end
  return buff
end

function TitanHR.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  if projectile then
    projectile.hit = override(projectile.hit, TitanHR.skillatk2_projectile_hit)
  end
  return projectile
end

function TitanHR.skillatk2_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  if target ~= skill.target then
    return
  else
    basefunc(projectile, target)
    projectile:terminate()
  end
end

function TitanHR.skillatk3_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 5 then
    skill.info["Do Crit"] = "YES"
  else
    skill.info["Do Crit"] = nil
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  skill.info = skill.originfo
  return dmg
end

function TitanHR.skillatk4_createBuff(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanHR.atk4_uncontrollable then
      tbuff.timer = -1
    end
  end
  local buff = basefunc(skill, target)
  buff:setAttribute("PIMU", skill.info["Script Arg3"])
  local target = skill.target
  if caster.TitanHR_hasArcana and caster.TitanHR_hasArcana > 2 and target then
    local bid = TitanHR.atk4_arcana
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buffarcana = ed.BuffCreate(binfo, target, caster)
    buffarcana:setAttribute("MDODG", 10)
    target:addBuff(buffarcana, caster)
  end
  return buff
end

function TitanHR.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = TitanHR.atk4_uncontrollable
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function TitanHR.update(basefunc, self, dt)
  local skillatk4 = self.skills.TitanHR_atk4
  self.dt = self.dt and self.dt + dt or dt
  if self.dt == 1 then
    local bid = TitanHR.atk4_passive
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, self, self)
    buff:setAttribute("PIMU", skillatk4.info["Script Arg3"])
    buff:setAttribute("DODG", skillatk4.info["Script Arg2"])
    self:addBuff(buff, self)
  end
  basefunc(self, dt)
end

function TitanHR.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.dt = nil
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, TitanHR.rage_buff_update)
  hero.lastrageStack = 0
end

function TitanHR.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanHR.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanHR.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanHR.ragelosthp
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
    while hero.lastRageHp - hero.hp >= TitanHR.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanHR.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanHR.rage_buff_update(basefunc, buff, dt)
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

function TitanHR.init_hero(hero)
  hero.TitanHR_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.TitanHR_ult
  local skillatk2 = hero.skills.TitanHR_atk2
  local skillatk3 = hero.skills.TitanHR_atk3
  local skillatk4 = hero.skills.TitanHR_atk4
  if hero.name == "TitanHR" then
    hero.castManualSkill = override(hero.castManualSkill, TitanHR.hero_castManualSkill)
  end
  hero.reset = override(hero.reset, TitanHR.hero_reset)
  hero.update = override(hero.update, TitanHR.hero_update)
  if skillult then
    skillult.finish = override(skillult.finish, TitanHR.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanHR.skillult_takeEffectOn)
    skillult.createProjectile = override(skillult.createProjectile, TitanHR.skillult_createProjectile)
    skillult.info["No Dodge"] = true
    if hero.TitanHR_hasArcana and hero.TitanHR_hasArcana > 3 then
      skillult.info["Ignore Shield"] = true
    end
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanHR.skillatk2_createProjectile)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanHR.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.originfo = skillatk3.info
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanHR.skillatk4_createBuff)
    skillatk4.start = override(skillatk4.start, TitanHR.skillatk4_start)
    hero.update = override(hero.update, TitanHR.update)
  end
  return hero
end

return TitanHR.init_hero
