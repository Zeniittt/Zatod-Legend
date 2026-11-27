module("ed.battlehero", package.seeall)
local ed = ed
WorldSM = {}
WorldSM.sawakerand = 0.6
WorldSM.skillult_buffID = 1629
WorldSM.ragelosthp = 600000
WorldSM.rage2losthp = 200000
WorldSM.stage2hp = 30000000
WorldSM.stage2ragelosthp = 400000

function WorldSM.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  if killer_unit == self then
    local bid = WorldSM.skillult_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, self, self)
    self:addBuff(buff, self)
  end
end

function WorldSM.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.Boss_entercount then
    local bid = 1637
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    boss:addBuff(binfo, boss)
    boss.Boss_entercount = true
  end
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldSM.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldSM.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldSM.ragelosthp
      boss.rageStack = boss.rageStack + 1
    end
  else
    if not boss.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      boss.stage2ragebuff = boss:addBuff(binfo, boss)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      boss:addBuff(binfo2, boss)
    end
    while boss.lastRageHp - boss.hp >= WorldSM.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldSM.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldSM.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldSM.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldSM.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
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

function WorldSM.skillatk3_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if skill.target then
      skill.magnetorigin = {
        skill.target.position[1],
        -30
      }
    else
      skill.magnetorigin = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_SM_atk31.cha"
      ed.scene:playEffectOnScene(effect_name, skill.magnetorigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  else
    if skill.magnetorigin == nil then
      return
    end
    basefunc(skill, skill.magnetorigin, source)
    if ed.run_with_scene then
      local effect_name = "eff_point_SM_atk32.cha"
      ed.scene:playEffectOnScene(effect_name, skill.magnetorigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  end
end

function WorldSM.skillult_finish(basefunc, skill)
  basefunc(skill)
  skill.position1 = nil
end

function WorldSM.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.WorldSM_ult_target = skill.target
end

function WorldSM.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
  elseif skill.WorldSM_ult_target and skill.WorldSM_ult_target == skill.target and skill.WorldSM_ult_target:isAlive() then
    basefunc(skill)
  else
    skill:finish()
  end
end

function WorldSM.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  for i = 1, 6 do
    if target and target:isAlive() then
      local result, dmg, Crit = basefunc(skill, target, source, shift)
      local skillatk2 = skill.caster.skills.WorldSM_atk2
      local rand = ed.rand() < WorldSM.sawakerand
      if skillatk2 and Crit and rand then
        skillatk2:selectTarget(nil)
        if skillatk2.target then
          local projectile = skillatk2:createProjectile()
          ed.engine:addProjectile(projectile)
        end
      end
    end
  end
end

function WorldSM.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if field == "mp" then
    return 0
  else
    return basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  end
end

function WorldSM.skillatk2_takeEffectOn(basefunc, skill, target)
  local result, dmg, Crit = basefunc(skill, target)
  skill:selectTarget(nil)
  local rand = ed.rand() < WorldSM.sawakerand
  if Crit and rand and skill.target then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  end
end

function WorldSM.skillatk3_takeEffectOn(basefunc, skill, target)
  local result, dmg, Crit = basefunc(skill, target)
  local skillatk2 = skill.caster.skills.WorldSM_atk2
  skillatk2:selectTarget(nil)
  local rand = ed.rand() < WorldSM.sawakerand
  if Crit and rand and skill.target then
    local projectile = skillatk2:createProjectile()
    ed.engine:addProjectile(projectile)
  end
end

function WorldSM.skillatk4_takeEffectOn(basefunc, skill, target)
  local result, dmg, Crit = basefunc(skill, target)
  target:takeHeal(1000, "mp", skill.caster)
  local skillatk2 = skill.caster.skills.WorldSM_atk2
  skillatk2:selectTarget(nil)
  local rand = ed.rand() < WorldSM.sawakerand
  if Crit and rand and skill.target then
    local projectile = skillatk2:createProjectile()
    ed.engine:addProjectile(projectile)
  end
end

function WorldSM.init_hero(hero)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, WorldSM.hero_handleUnitDieEvent)
  hero.reset = override(hero.reset, WorldSM.hero_reset)
  hero.update = override(hero.update, WorldSM.boss_update)
  hero.takeDamage = override(hero.takeDamage, WorldSM.hero_takeDamage)
  local skillult = hero.skills.WorldSM_ult
  if skillult then
    skillult.start = override(skillult.start, WorldSM.skillult_start)
    skillult.finish = override(skillult.finish, WorldSM.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldSM.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldSM.skillult_onAttackFrame)
  end
  local skillatk2 = hero.skills.WorldSM_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldSM.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.WorldSM_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, WorldSM.skillatk3_takeEffectAt)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldSM.skillatk3_takeEffectOn)
  end
  local skillatk4 = hero.skills.WorldSM_atk4
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WorldSM.skillatk4_takeEffectOn)
  end
  return hero
end

return WorldSM.init_hero
