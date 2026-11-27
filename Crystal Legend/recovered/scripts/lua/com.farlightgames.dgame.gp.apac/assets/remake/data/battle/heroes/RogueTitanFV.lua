module("ed.battlehero", package.seeall)
local ed = ed
RogueTitanFV = {}

function RogueTitanFV.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 12003904
  local binfo = ed.lookupDataTable("Buff", nil, bid)
end

function RogueTitanFV.skillatk2_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.RogueTitanFV_ult
  if caster.current_skill == skillult or caster.hp < caster.attribs.HP * 0.45 then
    result = false
  end
  return result
end

function RogueTitanFV.skillatk2_finish(basefunc, skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12003904 then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function RogueTitanFV.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    local Target_position = RogueTitanFV.DOP_in_battlefield(caster, 175, caster.foecamp)
    if Target_position then
      caster:setPosition({
        Target_position[1],
        Target_position[2]
      })
    else
      caster:setPosition({400, 0})
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    local skillatk2s = caster.skills.RogueTitanFV_atk2s
    skillatk2s:takeEffectOn(caster)
    basefunc(skill)
  end
end

function RogueTitanFV.DOP_in_battlefield(caster, radius, camp)
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
    return caster.position
  end
end

function RogueTitanFV.isNearDest(pos1, pos2, range)
  local delta_X = pos1[1] - pos2[1]
  local delta_Y = pos1[2] - pos2[2]
  if delta_X * delta_X + delta_Y * delta_Y <= range * range then
    return true
  end
  return false
end

function RogueTitanFV.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local is_hit = basefunc(skill, target, source, shift)
  local mp_damage = 0
  local caster = skill.caster
  local skillatk3 = caster.skills.RogueTitanFV_atk3
  if skillatk3 and is_hit and target and target:isAlive() then
    local bid = 1355
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
    mp_damage = skillatk3.info["Script Arg2"]
    target:takeDamage(mp_damage, "Holy", "mp", caster, 1, 1, 0)
    target:hurt()
    if buff then
      buff.timer = -1
    end
    if ed.run_with_scene then
      local effect_name = "eff_impact_TitanFV_atk3.cha"
      if not effect_name then
        return
      end
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, target.position, {
        target.direction,
        1
      }, nil, effect_z)
    end
  end
end

function RogueTitanFV.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.RogueTitanFV_skillatk3_autotimer = hero.RogueTitanFV_skillatk3_autotimer + dt
  local skillatk3 = hero.skills.RogueTitanFV_atk3
  local RogueTitanFV_skillatk3_range = 120
  if skillatk3 and hero.RogueTitanFV_skillatk3_autotimer >= 4.25 and hero:isAlive() then
    if hero.RogueTitanFV_hasArcana and hero.RogueTitanFV_hasArcana > 1 then
      RogueTitanFV_skillatk3_range = 240
    end
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      for i, buff in ipairs(unit.buff_list) do
        if (buff.info.MSPD and buff.info.MSPD > 0 or buff.info.HAST and 0 < buff.info.HAST) and RogueTitanFV.isNearDest(hero.position, unit.position, RogueTitanFV_skillatk3_range) then
          skillatk3:takeEffectOn(unit)
          break
        end
      end
    end
    hero.RogueTitanFV_skillatk3_autotimer = 0
  end
end

function RogueTitanFV.collectBuff(basefunc, hero, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  local skillatk2 = hero.skills.RogueTitanFV_atk2
  local skillatk4 = hero.skills.RogueTitanFV_atk4
  if owner and caster and hero:isAlive() and skillatk4 then
    local negative_effects = {
      frozen = true,
      stun = true,
      immoblilize = true,
      silence = true,
      imprisonment = true,
      enchanted = true,
      fear = true,
      taunt = true,
      polymorph = true,
      slow = true,
      icefrozen = true
    }
    local buff_modified = false
    for i, effect in ipairs(buff.info["Control Effects"]) do
      if negative_effects[effect] then
        if owner ~= caster and owner.camp ~= caster.camp and owner == hero then
          buff.timer = buff.timer - skillatk4.info["Script Arg2"]
          buff_modified = true
        elseif owner ~= caster and owner.camp ~= caster.camp and owner ~= hero and owner.camp == hero.camp and hero.RogueTitanFV_hasArcana and hero.RogueTitanFV_hasArcana > 3 then
          buff.timer = buff.timer - skillatk4.info["Script Arg2"] * 0.5
          buff_modified = true
        end
        if owner ~= caster and owner.camp ~= caster.camp and owner.camp ~= hero.camp and caster.camp == hero.camp then
          buff.timer = buff.timer + skillatk4.info["Script Arg2"]
          buff_modified = true
        end
        if buff_modified then
          break
        end
      end
    end
  end
  if skillatk2 and hero.RogueTitanFV_hasArcana and hero.RogueTitanFV_hasArcana > 2 and owner == hero and buff.info["Shield Value"] and buff.info["Shield Value"] > 0 then
    buff.onDamaged = override(buff.onDamaged, RogueTitanFV.skillatk2_buffonDamaged)
  end
end

function RogueTitanFV.hero_reset(basefunc, hero)
  hero.RogueTitanFV_skillatk3_autotimer = 0
  basefunc(hero)
end

function RogueTitanFV.skillult_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 12003901
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function RogueTitanFV.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12003901 then
      tbuff.timer = -1
    end
  end
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    for i, buff in ipairs(unit.buff_list) do
      if buff.info.ID == 12003902 then
        buff.timer = -1
      end
    end
  end
  if ed.run_with_scene and skill.ult_effect_1 then
    ed.scene:removeEffect(skill.ult_effect_1, -1)
  end
end

function RogueTitanFV.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    if ed.run_with_scene then
      local effect_name = "eff_point_Enigma_ult.cha"
      local effect_z = -1
      local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, effect_z)
      skill.ult_effect_1 = effect
    end
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      if unit ~= caster and (unit.camp ~= caster.camp or not unit.manually_casting) then
        local bid = 12003902
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        unit:addBuff(binfo, caster)
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    if ed.run_with_scene then
      if skill.ult_effect_1 then
        ed.scene:removeEffect(skill.ult_effect_1, -1)
        local effect_name = "eff_point_Enigma_ult3.cha"
        local effect_z = -1
        local effect = ed.scene:playEffectOnScene(effect_name, {400, 0}, {1, 1}, nil, effect_z)
      end
      ed.scene:startCameraShakeAnimationY(5, 0.2, 5)
    end
    basefunc(skill)
  end
end

function RogueTitanFV.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local bid = 1355
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, caster)
  basefunc(skill, target, source, shift)
  if buff then
    target:removeBuff(buff)
  end
end

function RogueTitanFV.skillatk2_buffonDamaged(basefunc, self, damage, damage_type, source, skill, transferred, field)
  local info = self.info
  local owner = self.owner
  field = field and field or "hp"
  if damage then
    local holyDodgeRate = 0.375
    local RogueTitanFV_RemnantSkill = owner.skills.RogueTitanFV_Remnant
    if owner and RogueTitanFV_RemnantSkill then
      holyDodgeRate = 0.475
    end
    local holyDodge = holyDodgeRate > ed.rand()
    if holyDodge and damage < 150000 then
      damage = 0
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanFV_atk2.cha"
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, owner.position, {
          owner.direction,
          1
        }, nil, effect_z)
      end
    end
  end
  if self.shield then
    local block = false
    local stype = info["Shield Type"]
    if stype == "mp" then
      if field == "mp" then
        self.shield = self.shield - damage
        if 0 > self.shield then
          self.owner:removeBuff(self)
          return -self.shield
        end
        if owner.actor then
          local color = owner.camp == ed.emCampPlayer and "blue" or "red"
          ed.PopupCreate("immune", color, owner.actor, nil, "text")
        end
        return 0
      else
        return damage
      end
    elseif stype == damage_type or stype == "all" then
      self.shield = self.shield - damage
      if 0 > self.shield then
        self.owner:removeBuff(self)
        return -self.shield
      end
      if owner.actor then
        local color = owner.camp == ed.emCampPlayer and "blue" or "red"
        local str = {
          AD = "physical_immune",
          AP = "magic_immune",
          all = "immune"
        }
        ed.PopupCreate(str[stype] or "immune", color, owner.actor, nil, "text")
      end
      return 0
    end
  end
  return damage
end

function RogueTitanFV.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.shield = buff.shield + caster.attribs.AP * 0.05
  return buff
end

function RogueTitanFV.init_hero(hero)
  local skillult = hero.skills.RogueTitanFV_ult
  local skillatk = hero.skills.RogueTitanFV_atk
  local skillatk2 = hero.skills.RogueTitanFV_atk2
  local skillatk2s = hero.skills.RogueTitanFV_atk2s
  local skillatk2b = hero.skills.RogueTitanFV_atk2b
  local skillatk2bs = hero.skills.RogueTitanFV_atk2bs
  local skillatk3 = hero.skills.RogueTitanFV_atk3
  local skillatk4 = hero.skills.RogueTitanFV_atk4
  hero.RogueTitanFV_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.reset = override(hero.reset, RogueTitanFV.hero_reset)
  hero.update = override(hero.update, RogueTitanFV.hero_update)
  hero.collectBuff = override(hero.collectBuff, RogueTitanFV.collectBuff)
  if skillatk2 then
    skillatk2.start = override(skillult.start, RogueTitanFV.skillatk2_start)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, RogueTitanFV.skillatk2_canCastWithTarget)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, RogueTitanFV.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, RogueTitanFV.skillatk2_finish)
  end
  if skillatk2s then
    skillatk2s.createBuff = override(skillatk2s.createBuff, RogueTitanFV.skillatk2s_createBuff)
  end
  if skillatk2b then
    skillatk2b.start = override(skillult.start, RogueTitanFV.skillatk2b_start)
    skillatk2b.canCastWithTarget = override(skillatk2b.canCastWithTarget, RogueTitanFV.skillatk2b_canCastWithTarget)
    skillatk2b.onAttackFrame = override(skillatk2b.onAttackFrame, RogueTitanFV.skillatk2b_onAttackFrame)
    skillatk2b.finish = override(skillatk2b.finish, RogueTitanFV.skillatk2b_finish)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, RogueTitanFV.skillatk3_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, RogueTitanFV.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, RogueTitanFV.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, RogueTitanFV.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, RogueTitanFV.skillult_finish)
  end
  return hero
end

return RogueTitanFV.init_hero
