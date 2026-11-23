module("ed.battlehero", package.seeall)
local ed = ed
MonsterNian = {}
MonsterNian.uncontrollable = 10035704
MonsterNian.atk6_bid = 10035705

function MonsterNian.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hero = skill.caster
  if hero then
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 20050051 then
        buff.timer = 4
      end
      if tbuff.info.ID == 20050052 then
        buff.timer = 5
      end
      if tbuff.info.ID == 20050053 then
        buff.timer = 6
      end
    end
  end
  return buff
end

function MonsterNian.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and dmg and target and caster then
    target:takeDamage(caster.HolyDmg, "Holy", "hp", caster)
  end
  return isHit, dmg
end

function MonsterNian.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hero = skill.caster
  if hero and target then
    local TargetArm = target.attribs.ARM
    local ARM_down = 0.1
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 20050061 then
        ARM_down = 0.15
      end
      if tbuff.info.ID == 20050062 then
        ARM_down = 0.2
      end
      if tbuff.info.ID == 20050063 then
        ARM_down = 0.25
      end
      if tbuff.info.ID == 20050064 then
        ARM_down = 0.3
      end
    end
    buff:setAttribute("ARM", -ARM_down * TargetArm)
  end
  return buff
end

function MonsterNian.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if caster then
    if attack_counter == 0 then
      skill.info["X Shift"] = 150
      basefunc(skill)
    end
    if attack_counter == 1 then
      skill.info["X Shift"] = -150
      basefunc(skill)
    end
    if attack_counter == 2 then
      skill.info["X Shift"] = 150
      basefunc(skill)
    end
    if attack_counter == 3 then
      skill.info["X Shift"] = -150
      basefunc(skill)
    end
    if attack_counter == 4 then
      skill.info["X Shift"] = 0
      basefunc(skill)
    end
  end
end

function MonsterNian.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and dmg and target and caster then
    target:takeDamage(caster.HolyDmg, "Holy", "hp", caster)
  end
  return isHit, dmg
end

function MonsterNian.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and dmg and target and caster then
    target:takeDamage(caster.HolyDmg, "Holy", "hp", caster)
    local HealRatio = 0.003
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 20050071 then
        HealRatio = 0.0045
      end
      if tbuff.info.ID == 20050072 then
        HealRatio = 0.006
      end
      if tbuff.info.ID == 20050073 then
        HealRatio = 0.0075
      end
      if tbuff.info.ID == 20050074 then
        HealRatio = 0.009
      end
    end
    caster:takeHeal(HealRatio * caster.attribs.HP, "hp", caster)
  end
  return isHit, dmg
end

function MonsterNian.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if caster then
    if attack_counter == 0 then
      local JumpPosition = MonsterNian.DOP_in_battlefield(caster, 200, caster.foecamp)
      caster:setPosition(JumpPosition)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      basefunc(skill)
      if ed.run_with_scene then
        ed.scene:startCameraShakeAnimationY(20, 0.3, 5)
      end
    end
  end
end

function MonsterNian.DOP_in_battlefield(caster, radius, camp)
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
  else
    return {400, 0}
  end
end

function MonsterNian.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and dmg and target and caster then
    target:takeDamage(caster.HolyDmg, "Holy", "hp", caster)
    for i, tbuff in ipairs(target.buff_list) do
      if (not tbuff.caster or tbuff.caster.camp == target.camp) and tbuff.info.Dispel == "YES" then
        tbuff.timer = -1
      end
    end
  end
  return isHit, dmg
end

function MonsterNian.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk5 = hero.skills.MonsterNian_atk5
  if skillatk5 and hero:isAlive() then
    hero.HolyDmg = hero.hp * 0.001
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 20050081 then
        hero.HolyDmg = hero.hp * 0.0013
      end
      if tbuff.info.ID == 20050082 then
        hero.HolyDmg = hero.hp * 0.0016
      end
      if tbuff.info.ID == 20050083 then
        hero.HolyDmg = hero.hp * 0.0019
      end
      if tbuff.info.ID == 20050084 then
        hero.HolyDmg = hero.hp * 0.0022
      end
    end
  end
end

function MonsterNian.reset(basefunc, hero)
  basefunc(hero)
  local skillatk6 = hero.skills.MonsterNian_atk6
  local buff = skillatk6:createBuff(hero)
  hero:addBuff(buff, hero)
end

function MonsterNian.init_hero(hero)
  local skillult = hero.skills.MonsterNian_ult
  local skillatk = hero.skills.MonsterNian_atk
  local skillatk2 = hero.skills.MonsterNian_atk2
  local skillatk3 = hero.skills.MonsterNian_atk3
  local skillatk4 = hero.skills.MonsterNian_atk4
  local skillatk5 = hero.skills.MonsterNian_atk5
  hero.update = override(hero.update, MonsterNian.hero_update)
  hero.reset = override(hero.reset, MonsterNian.reset)
  if skillult then
    skillult.createBuff = override(skillult.createBuff, MonsterNian.skillult_createBuff)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, MonsterNian.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, MonsterNian.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, MonsterNian.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, MonsterNian.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, MonsterNian.skillatk3_takeEffectOn)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, MonsterNian.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, MonsterNian.skillatk4_takeEffectOn)
  end
  return hero
end

return MonsterNian.init_hero
