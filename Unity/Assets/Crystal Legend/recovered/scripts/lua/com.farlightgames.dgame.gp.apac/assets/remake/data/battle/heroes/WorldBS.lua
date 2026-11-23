module("ed.battlehero", package.seeall)
local ed = ed
WorldBS = {}
WorldBS.ragelosthp = 600000
WorldBS.stage2hp = 30000000
WorldBS.rage2losthp = 200000
WorldBS.stage2ragelosthp = 400000

function WorldBS.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldBS.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldBS.rage_buff_update(basefunc, buff, dt)
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

function WorldBS.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local target = skill.target
  local caster = skill.caster
  local direction = {1, 0}
  local distance = 4
  if attack_counter == 2 then
    basefunc(skill)
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
      end
      local bid = 435
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    end
  elseif attack_counter == 3 then
    if target then
      target:knockup(0.008, ed.edpMult(direction, -distance), true)
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif attack_counter == 4 then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = 1.2
    })
    basefunc(skill)
    skill.info = originfo
    if target then
      target:knockup(0.015, ed.edpMult(direction, 12), true)
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
  end
end

function WorldBS.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  if skill.target then
    for i, buff in ipairs(skill.target.buff_list) do
      if buff.info.ID == 435 and buff.caster == skill.caster then
        buff.timer = 0
      end
    end
  end
end

function WorldBS.skillatk2_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local dmg = 0
  local info = skill.info
  local caster = skill.caster
  local skillawake = caster.skills.WorldBS_awake
  local affect_field = info["Affect MP"] and "mp" or "hp"
  dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  local heal = dmg * info["Script Arg1"] / 100
  if 1 < heal or heal < 0 then
    if do_battle_log then
      btlog("  %s leeches %d %s form %s", caster:display(), heal, affect_field, target:display())
    end
    local bid = 1049
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    if skillawake and target.info.Gender == T("\229\165\179") then
      local bid = 1049
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
    end
  end
  return dmg
end

function WorldBS.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local hero = self
  local skillatk3 = hero.skills.WorldBS_atk3
  if skillatk3 then
    if unit.camp ~= hero.camp and not unit.config.is_summoned then
      local bid = 1049
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero:addBuff(binfo, hero)
      if killer_unit == hero then
        hero:addBuff(binfo, hero)
      end
    elseif unit.camp ~= hero.camp and unit.config.is_summoned and unit.proto._tid ~= 194 and unit.proto._tid ~= 205 and unit.proto._tid ~= 212 and unit.proto._tid ~= 206 then
      local bid = 1049
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero:addBuff(binfo, hero)
      if killer_unit == hero then
        hero:addBuff(binfo, hero)
      end
    end
  end
end

function WorldBS.update(basefunc, self, dt)
  local hero = self
  local skillatk4 = hero.skills.WorldBS_atk4
  local skillatk4s = hero.skills.WorldBS_atk4s
  local skillult = hero.skills.WorldBS_ult
  if skillatk4 and not hero.BSCastatk4 then
    local MinHpUnit
    local MinHp = 99999
    for i, unit in ipairs(ed.engine.unit_list) do
      if unit.camp ~= hero.camp and unit.hp / unit.attribs.HP < 0.4 and unit:isAlive() and not unit.config.is_summoned and not unit.buff_effects.untargetable and not unit.buff_effects.uncontrollable and hero.current_skill ~= hero.skills.WorldBS_ult and hero.current_skill ~= hero.skills.WorldBS_atk2 and hero.current_skill ~= hero.skills.WorldBS_atk4s then
        MinHpUnit = MinHpUnit or unit
        if MinHpUnit and MinHp > unit.hp then
          MinHp = unit.hp
          MinHpUnit = unit
        end
        hero.BSatk4Target = MinHpUnit
        hero:castSkill(skillatk4s, nil)
      end
    end
  end
  basefunc(self, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldBS.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldBS.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldBS.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldBS.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldBS.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldBS.skillatk4s_start(basefunc, skill, target)
  local hero = skill.caster
  local bid = 397
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  basefunc(skill, target)
end

function WorldBS.skillatk4s_selectTarget(basefunc, self, default)
  local selector = self:target_selector()
  local hero = self.caster
  if selector then
    self.target = hero.BSatk4Target
    return self.target
  end
  return nil
end

function WorldBS.skillatk4s_takeEffectOn(basefunc, skill, target, source)
  local hero = skill.caster
  local skillatk4 = hero.skills.WorldBS_atk4
  local succ = basefunc(skill, target, source)
  if succ then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == 399 and buff.caster == hero then
        hero:addBuff(skillatk4:createBuff(hero))
        hero.BSCastatk4 = true
        return
      end
    end
    hero.BSCastatk4 = nil
  else
    hero.BSCastatk4 = nil
  end
end

function WorldBS.skillatk4s_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 397 then
      buff.timer = 0
    end
  end
end

function WorldBS.BSatk4s_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.caster
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 398 and buff.caster == hero then
      buff.timer = 0
    end
  end
end

function WorldBS.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WorldBS.BSatk4s_buff_OnRemoved)
  return buff
end

function WorldBS.BSatk4_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.caster
  hero.BSCastatk4 = nil
  local target = hero.BSatk4Target
  for i, buff in ipairs(target.buff_list) do
    if buff.info.ID == 399 and buff.caster == hero then
      buff.timer = 0
    end
  end
end

function WorldBS.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WorldBS.BSatk4_buff_OnRemoved)
  return buff
end

function WorldBS.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local target = skill.target
  local caster = skill.caster
  if attack_counter == 0 then
    if ed.run_with_scene then
      local effect_eye = "eff_point_BS_ulteyes.cha"
      local effect_red = "eff_point_BS_ultred"
      local origin1 = {
        ed.engine.stage_rect.maxX / 2,
        0
      }
      local origin2 = caster.position
      ed.scene:playEffectOnScene(effect_eye, origin2, nil, nil, -1)
      ed.scene:playEffectOnScene(effect_red, origin1, nil, nil, -1)
    end
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
  end
end

function WorldBS.skillult_buff_update(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillults = caster.skills.WorldBS_ults
  if owner.BSultinvulnerable == true then
    owner.BSultinvulnerable = false
    skillults:takeEffectOn(owner)
  end
  if not buff.lastposition then
    buff.lastposition = {
      owner.position[1],
      owner.position[2]
    }
  end
  if buff.lastposition[1] ~= owner.position[1] or buff.lastposition[2] ~= owner.position[2] then
    owner.distanceSQ = ((owner.position[1] - buff.lastposition[1]) ^ 2 + (owner.position[2] - buff.lastposition[2]) ^ 2) ^ 0.5
    skillults:takeEffectOn(owner)
    buff.lastposition = {
      owner.position[1],
      owner.position[2]
    }
  end
  basefunc(buff, dt)
end

function WorldBS.BSult_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  buff.lastposition = nil
end

function WorldBS.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hero = skill.caster
  local skillawake = hero.skills.WorldBS_awake
  if skillawake and target.info.Gender == T("\229\165\179") then
    buff.timer = buff.timer * (1 + skillawake.info["Script Arg1"] / 100)
  end
  buff.update = override(buff.update, WorldBS.skillult_buff_update)
  buff.onRemoved = override(buff.onRemoved, WorldBS.BSult_buff_OnRemoved)
  return buff
end

function WorldBS.skillult_takeEffectOn(basefunc, skill, target, source)
  local result = basefunc(skill, target, source)
  if result then
    local caster = skill.caster
    local bid = 1047
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo.fearrange = 5
    local buff493 = target:addBuff(binfo, caster)
  end
end

function WorldBS.skillults_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillult = caster.skills.WorldBS_ult
  if target.buff_effects.invulnerable then
    target.BSultinvulnerable = true
  end
  skill.info["Basic Num"] = target.distanceSQ * 10 * (1 + skillult.info["Script Arg1"] / 100)
  basefunc(skill, target, source)
end

function WorldBS.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldBS.stage2hp and hero.hp - lost <= WorldBS.stage2hp then
    return hero.hp - WorldBS.stage2hp
  else
    return lost
  end
end

function WorldBS.init_hero(hero)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldBS.getLostHPAfterImmunity)
  hero.reset = override(hero.reset, WorldBS.reset)
  local skillatk2 = hero.skills.WorldBS_atk2
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldBS.skillatk2_onAttackFrame)
    skillatk2.getDamage = override(skillatk2.getDamage, WorldBS.skillatk2_getDamage)
    skillatk2.finish = override(skillatk2.finish, WorldBS.skillatk2_finish)
  end
  local skillatk3 = hero.skills.WorldBS_atk3
  if skillatk3 then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, WorldBS.hero_handleUnitDieEvent)
  end
  local skillatk4 = hero.skills.WorldBS_atk4
  local skillatk4s = hero.skills.WorldBS_atk4s
  if skillatk4 then
    hero.update = override(hero.update, WorldBS.update)
    skillatk4s.start = override(skillatk4s.start, WorldBS.skillatk4s_start)
    skillatk4s.selectTarget = override(skillatk4s.selectTarget, WorldBS.skillatk4s_selectTarget)
    skillatk4s.takeEffectOn = override(skillatk4s.takeEffectOn, WorldBS.skillatk4s_takeEffectOn)
    skillatk4s.createBuff = override(skillatk4s.createBuff, WorldBS.skillatk4s_createBuff)
    skillatk4.createBuff = override(skillatk4.createBuff, WorldBS.skillatk4_createBuff)
    skillatk4s.finish = override(skillatk4s.finish, WorldBS.skillatk4s_finish)
  end
  local skillult = hero.skills.WorldBS_ult
  local skillults = hero.skills.WorldBS_ults
  if skillult then
    hero:preloadEffect("eff_point_BS_ulteyes.cha")
    hero:preloadEffect("eff_point_BS_ultred.cha")
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldBS.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, WorldBS.skillult_createBuff)
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldBS.skillult_takeEffectOn)
    skillults.takeEffectOn = override(skillults.takeEffectOn, WorldBS.skillults_takeEffectOn)
  end
  return hero
end

return WorldBS.init_hero
