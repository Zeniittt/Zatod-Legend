module("ed.battlehero", package.seeall)
local ed = ed
BossSK = {}
BossSK.ult_interval = 0.4
BossSK.name = "BossSK"
BossSK.sleepBuffID = 344

function BossSK.sleep_onDamaged(basefunc, buff, damage, damage_type)
  buff.timer = 0
  local unit = buff.owner
  damage = damage * 5
  if unit.current_skill and unit.current_skill == unit.skills[BossSK.name .. "_sleep"] then
    unit.current_skill:interrupt()
    unit.skills[BossSK.name .. "_sleep"].cd_remaining = 999
  end
  unit:removeBuff(buff)
  unit:hurt()
  return basefunc(buff, damage, damage_type)
end

function BossSK.reset(basefunc, unit)
  basefunc(unit)
  local binfo = ed.lookupDataTable("Buff", nil, BossSK.sleepBuffID)
  local buff = unit:addBuff(binfo, unit)
  if buff then
    buff.onDamaged = override(buff.onDamaged, BossSK.sleep_onDamaged)
  end
  local dir = unit:getInitDir()
  unit.position[1] = 400 - 250 * dir
  unit.direction = dir
end

function BossSK.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.left > caster.right then
    caster.direction = -1
  elseif caster.left < caster.right then
    caster.direction = 1
  else
    caster.direction = -caster:getInitDir()
  end
  caster.startdirection = caster.direction
  basefunc(skill, target)
end

function BossSK.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  caster.direction = caster.startdirection
  basefunc(skill, location, source)
  caster.position1 = caster.position
  local position1 = caster.position[1] + caster.direction * 330
  if 780 < position1 then
    position1 = 780
  elseif position1 < 20 then
    position1 = 20
  end
  caster:setPosition({
    position1,
    skill.caster.position[2]
  })
  local bid = 818
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function BossSK.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local skillatk2 = skill.caster.skills[BossSK.name .. "_atk2"]
  if skill.caster.position1 then
    skill.caster.position1 = nil
  end
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 818 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function BossSK.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  caster.left = 0
  caster.right = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.position[1] > caster.position[1] and unit.position[1] - caster.position[1] < 350 then
      caster.right = caster.right + 1
    elseif unit.position[1] < caster.position[1] and caster.position[1] - unit.position[1] < 350 then
      caster.left = caster.left + 1
    end
  end
  if not basefunc(skill, target) or caster.left == 0 and caster.right == 0 then
    return false
  end
  return true
end

function BossSK.skillatk3_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.hp > hero.attribs.HP * 0.4 then
    return false
  end
  return true
end

function BossSK.skillatk3_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    local caster = skill.caster
    local bid = 816
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
  basefunc(skill, location, source)
end

function BossSK.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 816 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function BossSK.skillult_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + BossSK.ult_interval
    local skill = buff.caster.skills[BossSK.name .. "_ult"]
    local originfo = skill.info
    local origtarget = skill.target
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0,
      ["Damage Type"] = "AP",
      ["Target Camp"] = -1,
      ["Affected Camp"] = -1,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = "260",
      ["Target Type"] = "target",
      ["Impact Effect"] = "eff_impact_pierce.cha"
    })
    local target = skill:selectTarget()
    if target then
      local owner = skill.caster
      skill:takeEffectAt(owner.position)
    end
    skill.info = originfo
    skill.target = origtarget
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function BossSK.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.left > caster.right then
    caster.direction = -1
  elseif caster.left < caster.right then
    caster.direction = 1
  else
    caster.direction = -caster:getInitDir()
  end
  caster.startdirection = caster.direction
  basefunc(skill, target)
end

function BossSK.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  caster.left = 0
  caster.right = 0
  for unit in ed.engine:foreachAliveUnit(-skill:affectedCamp()) do
    if unit.position[1] > caster.position[1] and unit.position[1] - caster.position[1] < 350 then
      caster.right = caster.right + 1
    elseif unit.position[1] < caster.position[1] and caster.position[1] - unit.position[1] < 350 then
      caster.left = caster.left + 1
    end
  end
  if not basefunc(skill, target) or caster.ultBuff or caster.mp < 1000 and caster.name == "BossSK" or caster.left == 0 and caster.right == 0 then
    return false
  end
  return true
end

function BossSK.skillult_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.caster
  owner.ultBuff = nil
end

function BossSK.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = 0.01
  buff.update = override(buff.update, BossSK.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, BossSK.skillult_buffOnRemoved)
  buff.owner.ultBuff = 1
  return buff
end

function BossSK.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local skillultb = skill.caster.skills[BossSK.name .. "_ultb"]
  if attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
    skillultb:takeEffectAt(skill.caster.position)
  else
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
    end
    basefunc(skill)
  end
end

function BossSK.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      caster.position1 = caster.position
      local position1 = caster.position[1] + caster.direction * 330
      if 780 < position1 then
        position1 = 780
      elseif position1 < 20 then
        position1 = 20
      end
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
    end
  else
    basefunc(skill, location, source)
  end
end

function BossSK.skillultb_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  caster.direction = caster.startdirection
  basefunc(skill, location, source)
  caster.position1 = caster.position
  local position1 = caster.position[1] + caster.direction * 330
  if 780 < position1 then
    position1 = 780
  elseif position1 < 20 then
    position1 = 20
  end
  caster:setPosition({
    position1,
    skill.caster.position[2]
  })
end

function BossSK.hero_handleUnitDieEventToAll(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 815 then
      local caster = tbuff.caster
      if caster == self then
        local skillatk4b = self.skills[BossSK.name .. "_atk4b"]
        if skillatk4b then
          skillatk4b:takeEffectAt(unit.position)
        end
      end
    end
  end
end

function BossSK.hero_update(basefunc, self, dt)
  basefunc(self, dt)
  if self.current_skill and (self.current_skill == self.skills[BossSK.name .. "_atk2"] or self.current_skill == self.skills[BossSK.name .. "_ult"]) then
    self.direction = self.startdirection
  end
end

function BossSK.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local skill = self.skills[BossSK.name .. "_atk2"]
  if skill.cd_remaining > 1 then
    skill.cd_remaining = skill.cd_remaining - 1
  else
    skill.cd_remaining = 0
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function BossSK.init_hero(hero)
  if hero.name == "BossSK" then
    hero.reset = override(hero.reset, BossSK.reset)
  end
  hero.takeDamage = override(hero.takeDamage, BossSK.hero_takeDamage)
  hero.left = 0
  hero.right = 0
  hero.update = override(hero.update, BossSK.hero_update)
  local skillult = hero.skills[BossSK.name .. "_ult"]
  if skillult then
    skillult.start = override(skillult.start, BossSK.skillult_start)
    skillult.createBuff = override(skillult.createBuff, BossSK.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BossSK.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossSK.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, BossSK.skillult_takeEffectAt)
  end
  local skillultb = hero.skills[BossSK.name .. "_ultb"]
  if skillultb then
    skillultb.takeEffectAt = override(skillultb.takeEffectAt, BossSK.skillultb_takeEffectAt)
  end
  local skillatk2 = hero.skills[BossSK.name .. "_atk2"]
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, BossSK.skillatk2_start)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, BossSK.skillatk2_takeEffectAt)
    skillatk2.finish = override(skillatk2.finish, BossSK.skillatk2_finish)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, BossSK.skillatk2_canCastWithTarget)
  end
  local skillatk3 = hero.skills[BossSK.name .. "_atk3"]
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, BossSK.skillatk3_canCastWithTarget)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, BossSK.skillatk3_takeEffectAt)
    skillatk3.finish = override(skillatk3.finish, BossSK.skillatk3_finish)
  end
  local skillatk4 = hero.skills[BossSK.name .. "_atk4"]
  if skillatk4 then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, BossSK.hero_handleUnitDieEventToAll)
  end
  return hero
end

return BossSK.init_hero
