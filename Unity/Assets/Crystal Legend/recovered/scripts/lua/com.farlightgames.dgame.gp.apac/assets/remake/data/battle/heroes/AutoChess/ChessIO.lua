module("ed.battlehero", package.seeall)
local ed = ed
ChessIO = {}

function ChessIO.createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableTrack(skill.target)
  return projectile
end

function ChessIO.skillatk2_selectTarget(basefunc, self, default)
  local max = -math.huge
  local selector = self:target_selector()
  local chosen
  local caster = self.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.config.is_summoned then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit == caster then
    elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
    elseif unit.attribs.STR >= caster.attribs.STR then
    elseif enchanted and unit == caster then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
        local v = selector(unit)
        if not unit.config.is_summoned and chosen and chosen.config.is_summoned then
          max = v
          chosen = unit
        elseif v > max then
          max = v
          chosen = unit
        end
      end
    end
  end
  if not chosen then
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.config.is_summoned then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          if not unit.config.is_summoned and chosen and chosen.config.is_summoned then
            max = v
            chosen = unit
          elseif v > max then
            max = v
            chosen = unit
          end
        end
      end
    end
  end
  self.target = chosen
  return self.target
end

function ChessIO.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.target then
    skill.caster.IO_atk2_target = skill.target
    skill.cd_remaining = 999
  end
  local skillatk2_1 = skill.caster.skills.IO_atk2_1
  if skillatk2_1 then
    skillatk2_1:takeEffectOn(skill.caster)
  end
end

function ChessIO.atk2_buff_onRemoved(basefunc, buff)
  local skillatk2 = buff.caster.skills.IO_atk2
  if buff.caster and buff.caster:isAlive() then
    for i, tbuff in ipairs(buff.caster.buff_list) do
      if tbuff.info.ID == 432 and tbuff.caster == buff.caster then
        local buff = tbuff
        buff.timer = 0.1
        skillatk2.cd_remaining = 0.1
        buff.caster.IO_atk2_target = nil
        break
      end
    end
  end
  basefunc(buff)
end

function ChessIO.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, ChessIO.atk2_buff_onRemoved)
  return buff
end

function ChessIO.atk2_1_buff_onRemoved(basefunc, buff)
  if buff.caster.IO_atk2_target and buff.caster.IO_atk2_target:isAlive() then
    for i, tbuff in ipairs(buff.caster.IO_atk2_target.buff_list) do
      if tbuff.info.ID == 431 and tbuff.caster == buff.caster then
        local buff = tbuff
        buff.timer = 0.1
        break
      end
    end
  end
  basefunc(buff)
end

function ChessIO.skillatk2_1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, ChessIO.atk2_1_buff_onRemoved)
  return buff
end

function ChessIO.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  if skill.caster.IO_atk2_target and skill.caster.IO_atk2_target:isAlive() then
    local skillatk2_2 = skill.caster.skills.IO_atk2_2
    if skillatk2_2 then
      skillatk2_2:takeEffectOn(skill.caster.IO_atk2_target)
    end
  end
end

function ChessIO.atk3_buffUpdate(basefunc, buff, dt)
  local dir = buff.owner:getInitDir()
  if dir ~= buff.owner.direction and not buff.owner.buff_effects.uncontrollable then
    buff.timer = 0.1
    local skillatk3_1 = buff.caster.skills.IO_atk3_1
    if skillatk3_1 then
      skillatk3_1:takeEffectOn(buff.owner)
    end
  end
  basefunc(buff, dt)
end

function ChessIO.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, ChessIO.atk3_buffUpdate)
  return buff
end

function ChessIO.skill4_buffOnDamaged(basefunc, buff, damage, damage_type)
  local info = buff.info
  local owner = buff.owner
  if damage <= 0 then
    if buff.refraction and 0 >= buff.refraction then
      owner:removeBuff(buff)
    end
    return 0
  end
  if buff.shield then
    local block = false
    local stype = buff.info["Shield Type"]
    if stype == damage_type or stype == "all" then
      buff.shield = buff.shield - damage
      local temp = buff.shield
      buff.refraction = buff.refraction - 1
      buff.shield = buff.info["Shield Value"]
      if buff.refraction and 0 >= buff.refraction then
        owner:removeBuff(buff)
      end
      local mppower = buff.caster.skills.IO_atk4.info["Script Arg3"]
      buff.caster:takeHeal(mppower, "mp", owner)
      if temp < 0 then
        return -temp
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

function ChessIO.skill4_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  buff.refraction = 0
  return basefunc(buff)
end

function ChessIO.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.refraction = skill.info["Script Arg2"]
  buff.onRemoved = override(buff.onRemoved, ChessIO.skill4_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, ChessIO.skill4_buffOnDamaged)
  return buff
end

function ChessIO.skillatk4_takeEffectOn(basefunc, skill, target)
  if target ~= skill.caster then
    basefunc(skill, target)
  end
end

function ChessIO.skillatk4_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = 453
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function ChessIO.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 453 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function ChessIO.IOult_castManualSkill(basefunc, hero)
  basefunc(hero)
  local target = hero.skills.IO_ult.target
  if target and hero.name ~= "Rubick" then
    target:unfreezeActor()
  end
end

function ChessIO.skillult_buffOnRemoved(basefunc, buff)
  if buff.caster then
    for i, tbuff in ipairs(buff.caster.buff_list) do
      if tbuff.info.ID == 440 then
        local buff = tbuff
        buff.owner:removeBuff(buff)
      end
    end
  end
  return basefunc(buff)
end

function ChessIO.skillult_onDamaged(basefunc, buff, damage, damage_type, source)
  local maxdmg = buff.owner.hp - 1
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  if maxdmg >= lastdamage or not buff.caster:isAlive() then
    return damage
  else
    damage = 0
    local hp = buff.caster.skills.IO_ult.info["Script Arg3"] * buff.caster.hp * 0.01
    buff.owner:takeHeal(hp, "hp", buff.caster, owner.name)
    buff.caster:setPosition({
      buff.owner.position[1] - 40 * buff.owner.direction,
      buff.owner.position[2]
    })
    buff.caster.IO_ult_die = true
    buff.caster.hp = 0
    buff.owner:removeBuff(buff)
    if ed.run_with_scene then
      local effect_night = "eff_point_IO_death.cha"
      local origin = buff.owner.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
    end
    return damage
  end
end

function ChessIO.skillult_buffUpdate(basefunc, buff, dt)
  if not buff.caster:isAlive() or not buff.owner:isAlive() then
    local owner = buff.owner
    owner:removeBuff(buff)
  end
  buff.caster:setPosition({
    buff.owner.position[1] - 40 * buff.owner.direction,
    buff.owner.position[2]
  })
  basefunc(buff, dt)
end

function ChessIO.skillult_createBuff(basefunc, skill, target)
  local owner = skill.caster
  local AP = owner.attribs.AP * 0.3
  local ARM = owner.attribs.ARM * 0.3
  local MCRIT = owner.attribs.MCRIT * 0.3
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, ChessIO.skillult_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, ChessIO.skillult_onDamaged)
  buff.update = override(buff.update, ChessIO.skillult_buffUpdate)
  buff:setAttribute("AP", AP)
  buff:setAttribute("ARM", ARM)
  buff:setAttribute("MCRIT", MCRIT)
  return buff
end

function ChessIO.basefunc1(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  if (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) and skill.attack_counter == 1 then
    skill:selectTarget(nil)
  end
  if not skill.target or skill.target.buff_effects.invulnerable then
    skill.caster.current_skill:interrupt()
    return
  end
  local info = skill.info
  local caster = skill.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    skill:takeEffectAt(skill.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function ChessIO.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    if skill.target == nil or not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    if skill.caster.manually_casting and skill.attack_counter == 1 then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
    if skill.target and skill.target:isAlive() then
      skill.target:addBuff(skill:createBuff(skill.target))
      for i, tbuff in ipairs(skill.target.buff_list) do
        if tbuff.info.ID == 441 and skill.target:isAlive() then
          local bid = 440
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = skill.caster:addBuff(binfo, skill.caster)
          local skillult2 = skill.caster.skills.IO_ult2
          if skill.target then
            skillult2:takeEffectAt(skill.target.position)
          end
          local caster = skill.caster
          if not caster.buff_effects.doom then
            local list = caster.buff_list
            local my_camp = caster.camp
            for i = 1, #list do
              local my_buff = list[i]
              if my_buff and (not my_buff.caster or my_buff.caster.camp ~= my_camp) then
                my_buff.timer = 0
              end
            end
          end
          break
        end
      end
    end
  elseif attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
    local caster = skill.caster
    if (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) and skill.attack_counter == 1 then
      skill:selectTarget(nil)
    end
    if not skill.target then
      return
    end
    local info = skill.info
    local caster = skill.caster
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    if info["Move Forward"] ~= 0 then
      caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
    end
    caster:setHpVisible(false)
    local skillatk2 = caster.skills.IO_atk2
    if caster and caster:isAlive() then
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 432 and tbuff.caster == caster then
          local buff = tbuff
          buff.timer = 0.1
          break
        end
      end
    end
    if caster.IO_atk2_target and caster.IO_atk2_target:isAlive() then
      for i, tbuff in ipairs(caster.IO_atk2_target.buff_list) do
        if tbuff.info.ID == 431 and tbuff.caster == caster then
          local buff = tbuff
          buff.timer = 0.1
          break
        end
      end
    end
    if ed.run_with_scene then
      local effect_night = "eff_point_IO_ult_2.cha"
      local origin = skill.target.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
      local effect_night = "eff_point_IO_ult.cha"
      local origin = skill.target.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
    end
  end
end

function ChessIO.skillult_selectTarget(basefunc, skill, default)
  local selector = skill:target_selector()
  local hero = skill.caster
  if selector and hero.IO_atk2_target and hero.IO_atk2_target.name ~= "Phoenix" and hero.IO_atk2_target.name ~= "SNK" and hero.IO_atk2_target.name ~= "GT" and hero.IO_atk2_target.name ~= "LYC" then
    skill.target = hero.IO_atk2_target
    return skill.target
  end
  local max = -math.huge
  local selector = skill:target_selector()
  local chosen
  local caster = skill.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.config.is_summoned then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit.name == "Phoenix" or unit.name == "SNK" or unit.name == "GT" or unit.name == "LYC" then
    elseif unit == caster then
    elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
    elseif enchanted and unit == caster then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
        local v = selector(unit)
        if not unit.config.is_summoned and chosen and chosen.config.is_summoned then
          max = v
          chosen = unit
        elseif v > max then
          max = v
          chosen = unit
        end
      end
    end
  end
  skill.target = chosen
  return skill.target
end

function ChessIO.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.buff_effects.untargetable or hero.buff_effects.invulnerable then
    return false
  end
  return true
end

function ChessIO.reset(basefunc, hero)
  basefunc(hero)
  hero.IO_atk2_target = nil
  hero.IO_spirit_list = {}
  hero.IO_ult_die = nil
  hero:setHpVisible(true)
end

function ChessIO.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.hp <= 1 then
    hero:onDying()
  end
end

function ChessIO.setAction(basefunc, self, action_name, loop, interrupt)
  if self.IO_ult_die == true and action_name == "Death" then
    action_name = "Death2"
  end
  basefunc(self, action_name, loop, interrupt)
end

function ChessIO.init_hero(hero)
  hero.IO_spirit_list = {}
  hero.update = override(hero.update, ChessIO.hero_update)
  hero.reset = override(hero.reset, ChessIO.reset)
  local skillatk2 = hero.skills.IO_atk2
  local skillatk2_1 = hero.skills.IO_atk2_1
  local skillatk3 = hero.skills.IO_atk3
  local skillatk4 = hero.skills.IO_atk4
  local skillult = hero.skills.IO_ult
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, ChessIO.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, ChessIO.skillatk2_createBuff)
    skillatk2.selectTarget = override(skillatk2.selectTarget, ChessIO.skillatk2_selectTarget)
  end
  if skillatk2_1 then
    skillatk2_1.createBuff = override(skillatk2_1.createBuff, ChessIO.skillatk2_1_createBuff)
  end
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, ChessIO.skillatk3_takeEffectAt)
    skillatk3.createBuff = override(skillatk3.createBuff, ChessIO.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, ChessIO.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, ChessIO.skillatk4_takeEffectOn)
    skillatk4.start = override(skillatk4.start, ChessIO.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, ChessIO.skillatk4_finish)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessIO.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, ChessIO.skillult_createBuff)
    skillult.selectTarget = override(skillult.selectTarget, ChessIO.skillult_selectTarget)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, ChessIO.skillult_canCastWithTarget)
    hero.castManualSkill = override(hero.castManualSkill, ChessIO.IOult_castManualSkill)
    hero.setAction = override(hero.setAction, ChessIO.setAction)
  end
  local skillatk = hero.skills.Earth_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, ChessIO.createProjectile)
  end
  return hero
end

return ChessIO.init_hero
