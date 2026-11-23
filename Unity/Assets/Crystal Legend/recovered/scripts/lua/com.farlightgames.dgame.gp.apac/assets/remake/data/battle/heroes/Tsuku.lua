module("ed.battlehero", package.seeall)
local ed = ed
Tsuku = {}
Tsuku.eclipse_moon = -100
Tsuku.half_moon = 0
Tsuku.full_moon = 100
Tsuku.EclipseToFull_effect = "eff_point_Tsuku_EclipseToFull"
Tsuku.FullToEclipse_effect = "eff_point_Tsuku_FullToEclipse"
Tsuku.fullmoon_bid = 1137
Tsuku.halfmoon_bid = 1139
Tsuku.eclipsemoon_bid = 1141
Tsuku.atk4_front_bid = 1145
Tsuku.atk4_back_bid = 1146
Tsuku.atk4s_front_bid = 1147
Tsuku.atk4s_back_bid = 1148
Tsuku.ult_self_bid = 1154
Tsuku.skillult2_host_bid = 1152
Tsuku.skillult2_follower_bid = 1153
Tsuku.Tsuku_mod_change_time = 2.3
Tsuku.skill2_moon_shift = 4
Tsuku.skill3_moon_shift = 3
Tsuku.skill4_moon_shift = 10
Tsuku.MoonUIPosition = {-2, 56}
Tsuku.MoonPhasePicList = {
  [1] = "UI/alpha/1080P/battle_special/tsuku_moonphase_1.png",
  [2] = "UI/alpha/1080P/battle_special/tsuku_moonphase_2.png",
  [3] = "UI/alpha/1080P/battle_special/tsuku_moonphase_3.png",
  [4] = "UI/alpha/1080P/battle_special/tsuku_moonphase_4.png"
}

function Tsuku.NewPhaseChange(hero, UIphase, direction)
  if ed.run_with_scene and (not ed.engine.multiplayerMode or not not ed.multiplayer_battle:isMyHero(hero.tid)) then
    local icon = hero.heroPanel and hero.heroPanel.btn
    local pic = Tsuku.MoonPhasePicList[UIphase]
    if icon and pic then
      local newMoon = ed.createSprite(pic, icon)
      local deltaP = Tsuku.MoonUIPosition
      local targetPosition = ccpAdd(icon:getParent():convertToWorldSpace(ccp(icon:getPosition())), ccp(deltaP[1], deltaP[2]))
      local iniPostion = ccpAdd(targetPosition, ccp(-20 * direction, 0))
      newMoon:setPosition(iniPostion)
      newMoon:setScale(1)
      ed.sceneui.ui_layer:addChild(newMoon)
      local move = CCMoveTo:create(0.6, targetPosition)
      local fade = CCFadeIn:create(0.6)
      local spawn = CCSpawn:create(ccArrayMake(move, fade))
      local action = CCEaseSineOut:create(spawn)
      newMoon:runAction(action)
      hero.Tsuku_current_phase_UI = newMoon
    end
  end
end

function Tsuku.OldPhaseDelete(hero)
  if ed.run_with_scene and (not ed.engine.multiplayerMode or not not ed.multiplayer_battle:isMyHero(hero.tid)) then
    local removePhase = hero.Tsuku_current_phase_UI
    if removePhase then
      local action = CCFadeOut:create(0.3)
      removePhase:runAction(action)
      action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
        removePhase:removeFromParentAndCleanup(true)
      end))
      removePhase:runAction(action)
      hero.Tsuku_current_phase_UI = nil
    end
  end
end

function Tsuku.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.Tsuku_firstphase_timer then
    hero.Tsuku_firstphase_timer = hero.Tsuku_firstphase_timer - dt
    if hero.Tsuku_firstphase_timer < 0 then
      hero.Tsuku_firstphase_timer = nil
      Tsuku.NewPhaseChange(hero, 3, 1)
    end
  end
  local skillawake = hero.skills.Tsuku_awake
  local skillult = hero.skills.Tsuku_ult
  if hero.current_skill ~= skillult then
    hero.Tsuku_moon_counter = hero.Tsuku_moon_counter + hero.Tsuku_moon_direction * hero.Tsuku_moon_speed
    if hero.Tsuku_moon_direction == 1 then
      if hero.Tsuku_moon_counter >= Tsuku.half_moon and hero.Tsuku_moon_phase == -1 then
        if skillawake then
          local bid = Tsuku.halfmoon_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, hero, hero)
          buff:setAttribute("ARM", skillawake.info["Script Arg2"])
          buff:setAttribute("MR", skillawake.info["Script Arg3"])
          if hero:isAlive() then
            hero:addBuff(buff, hero)
          end
        end
        Tsuku.OldPhaseDelete(hero)
        Tsuku.NewPhaseChange(hero, 4, hero.Tsuku_moon_direction)
        hero.Tsuku_moon_phase = 0
      elseif hero.Tsuku_moon_counter >= Tsuku.full_moon and hero.Tsuku_moon_phase == 0 then
        if skillawake then
          local bid = Tsuku.fullmoon_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, hero, hero)
          buff:setAttribute("AP", skillawake.info["Script Arg4"])
          if hero:isAlive() then
            hero:addBuff(buff, hero)
          end
        end
        Tsuku.OldPhaseDelete(hero)
        Tsuku.NewPhaseChange(hero, 1, hero.Tsuku_moon_direction)
        hero.Tsuku_moon_phase = 1
        hero.Tsuku_moon_counter = Tsuku.full_moon
        hero.Tsuku_moon_direction = -hero.Tsuku_moon_direction
      end
    elseif hero.Tsuku_moon_direction == -1 then
      if hero.Tsuku_moon_counter <= Tsuku.half_moon and hero.Tsuku_moon_phase == 1 then
        if skillawake then
          local bid = Tsuku.halfmoon_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, hero, hero)
          buff:setAttribute("ARM", skillawake.info["Script Arg2"])
          buff:setAttribute("MR", skillawake.info["Script Arg3"])
          if hero:isAlive() then
            hero:addBuff(buff, hero)
          end
        end
        Tsuku.OldPhaseDelete(hero)
        Tsuku.NewPhaseChange(hero, 2, hero.Tsuku_moon_direction)
        hero.Tsuku_moon_phase = 0
      elseif hero.Tsuku_moon_counter <= Tsuku.eclipse_moon and hero.Tsuku_moon_phase == 0 then
        if skillawake then
          hero:takeHeal(skillawake.info["Script Arg1"], "hp", hero)
          if ed.run_with_scene then
            ed.scene:playEffectOnScene("eff_impact_heal", hero.position, {
              hero.direction,
              1
            }, nil, 1)
          end
        end
        Tsuku.OldPhaseDelete(hero)
        Tsuku.NewPhaseChange(hero, 3, hero.Tsuku_moon_direction)
        hero.Tsuku_moon_phase = -1
        hero.Tsuku_moon_counter = Tsuku.eclipse_moon
        hero.Tsuku_moon_direction = -hero.Tsuku_moon_direction
      end
    end
  end
end

function Tsuku.ult1buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local damage = basefunc(buff, damage, damage_type, source, skill)
  if 0 < damage then
    local caster = buff.caster
    local owner = buff.owner
    local skillult1a = caster.skills.Tsuku_ult1a
    local skillult1b = caster.skills.Tsuku_ult1b
    if skill and skill.caster.name ~= "Tsuku" then
      if damage_type == "AD" then
        skillult1a:takeEffectOn(skill.caster)
      elseif damage_type == "AP" then
        skillult1b:takeEffectOn(skill.caster)
      end
    end
    if ed.run_with_scene then
      local effect_name = "eff_buff_Tsuku_ult1_counter"
      ed.scene:playEffectOnScene(effect_name, owner.position, {
        owner.direction,
        1
      }, nil, 1)
    end
  end
  return damage
end

function Tsuku.skillult1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target == skill.caster then
    buff:setAttribute("Effect", "")
  end
  buff.onDamaged = override(buff.onDamaged, Tsuku.ult1buff_onDamaged)
  return buff
end

function Tsuku.ult1region_update(basefunc, self, dt)
  basefunc(self, dt)
  local caster = self.caster
  if self.timer <= 0 then
    caster.Tsuku_ult1_region = nil
  end
  local skillult = caster.skills.Tsuku_ult
  if not self.terminated and caster.foecamp ~= -self.camp then
    self:terminate()
    if caster.current_skill == skillult then
      caster.current_skill:finish()
    end
  end
end

function Tsuku.skillult1_createRegion(basefunc, skill)
  local region = basefunc(skill)
  region.update = override(region.update, Tsuku.ult1region_update)
  local caster = skill.caster
  caster.Tsuku_ult1_region = region
  return region
end

function Tsuku.ult2buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner:isAlive() then
    local count = 0
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == Tsuku.skillult2_follower_bid or buff.info.ID == Tsuku.skillult2_host_bid then
          count = count + 1
          if unit.hp < owner.hp then
            buff.timer = 0
            break
          end
        end
      end
    end
    if caster.Tsuku_ult2_hero_count and count < caster.Tsuku_ult2_hero_count then
      buff.timer = 0
      caster.Tsuku_ult2_hero_count = nil
    end
  end
  basefunc(buff, dt)
end

function Tsuku.ult2buff_onRemoved(basefunc, self)
  local owner = self.owner
  for unit in ed.engine:foreachAliveUnit(owner.camp) do
    for i, buff in ipairs(unit.buff_list) do
      if buff.info.ID == Tsuku.skillult2_follower_bid then
        unit:removeBuff(buff)
        break
      end
    end
  end
  basefunc(self)
end

function Tsuku.skillult2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Tsuku.ult2buff_update)
  buff.onRemoved = override(buff.onRemoved, Tsuku.ult2buff_onRemoved)
  buff:setAttribute("HPR", buff.info.HPR + skill.info["Script Arg1"])
  return buff
end

function Tsuku.skillult2_takeEffectOn(basefunc, self, target, source, shift)
  local caster = self.caster
  caster.Tsuku_ult2_hero_count = 1
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    for i, buff in ipairs(unit.buff_list) do
      if buff.info.ID == Tsuku.skillult2_host_bid or buff.info.ID == Tsuku.skillult2_follower_bid then
        unit:removeBuff(buff)
      end
    end
  end
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit == target then
    else
      local bid = Tsuku.skillult2_follower_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, unit, caster)
      buff:setAttribute("HPR", buff.info.HPR + self.info["Script Arg1"])
      if unit == target then
        buff:setAttribute("Effect", "")
      end
      unit:addBuff(buff, unit)
      caster.Tsuku_ult2_hero_count = caster.Tsuku_ult2_hero_count + 1
    end
  end
  basefunc(self, target, source, shift)
end

function Tsuku.skillult_canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function Tsuku.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.Tsuku_moon_counter >= 0 then
    skill:startPhase(2)
  end
end

function Tsuku.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    skill.ultbegin = skill.current_phase_elapsed
    local bid = Tsuku.ult_self_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter == 1 then
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
    end
    skill.caster.manually_casting = false
    local skillawake = caster.skills.Tsuku_awake
    skill.ultcharge = skill.current_phase_elapsed - skill.ultbegin
    if skill.ultcharge <= Tsuku.Tsuku_mod_change_time then
      if 0 <= caster.Tsuku_moon_counter then
        if skillawake and caster.Tsuku_moon_phase == 0 then
          local bid = Tsuku.fullmoon_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, caster, caster)
          buff:setAttribute("AP", skillawake.info["Script Arg4"])
          if caster:isAlive() then
            caster:addBuff(buff, caster)
          end
          Tsuku.OldPhaseDelete(caster)
          Tsuku.NewPhaseChange(caster, 1, caster.Tsuku_moon_direction)
        end
        skill.attack_counter = 2
        skill:startPhase(3)
        skill.next_event_idx = 0
        caster.Tsuku_moon_phase = 1
        caster.Tsuku_moon_counter = 100
        caster.Tsuku_moon_direction = -1
      else
        if skillawake and caster.Tsuku_moon_phase == 0 then
          Tsuku.OldPhaseDelete(caster)
          Tsuku.NewPhaseChange(caster, 3, caster.Tsuku_moon_direction)
          caster:takeHeal(skillawake.info["Script Arg1"], "hp", caster)
          if ed.run_with_scene then
            ed.scene:playEffectOnScene("eff_impact_heal", caster.position, {
              caster.direction,
              1
            }, nil, 1)
          end
        end
        skill.attack_counter = 3
        skill:startPhase(4)
        caster.Tsuku_moon_phase = -1
        caster.Tsuku_moon_counter = -100
        caster.Tsuku_moon_direction = 1
      end
      skill.next_event_idx = 0
    end
  elseif skill.attack_counter == 2 then
    local skillult1 = caster.skills.Tsuku_ult1
    if skillult1 then
      if caster.Tsuku_ult1_region then
        caster.Tsuku_ult1_region.timer = skillult1.info["Script Arg1"]
      else
        skillult1.target = caster
        local Tsuku_region = skillult1:createRegion()
        local midX = (ed.engine.stage_rect.maxX + ed.engine.stage_rect.minX) / 2
        local midY = (ed.engine.stage_rect.maxY + ed.engine.stage_rect.minY) / 2
        Tsuku_region.position = {midX, midY}
        ed.engine:addRegion(Tsuku_region)
      end
    end
  elseif skill.attack_counter == 3 then
    local skillult2 = caster.skills.Tsuku_ult2
    local target = skillult2:selectTarget(nil)
    if target then
      skillult2:takeEffectOn(target)
    else
      caster:takeHeal(800, "mp", caster)
    end
  end
end

function Tsuku.skillult_trigger(basefunc, skill)
  skill:onAttackFrame()
end

function Tsuku.skillult_interrupt(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end

function Tsuku.skillult_onPhaseFinished(basefunc, skill)
  local current_phase_idx = skill.current_phase_idx
  local caster = skill.caster
  local skillawake = caster.skills.Tsuku_awake
  if current_phase_idx == 1 then
    if skillawake then
      local bid = Tsuku.fullmoon_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff:setAttribute("AP", skillawake.info["Script Arg4"])
      if caster:isAlive() then
        caster:addBuff(buff, caster)
      end
      local bid = Tsuku.halfmoon_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff:setAttribute("ARM", skillawake.info["Script Arg2"])
      buff:setAttribute("MR", skillawake.info["Script Arg3"])
      if caster:isAlive() then
        caster:addBuff(buff, caster)
      end
    end
    skill.attack_counter = 2
    skill:startPhase(3)
    Tsuku.OldPhaseDelete(caster)
    Tsuku.NewPhaseChange(caster, 1, caster.Tsuku_moon_direction)
    caster.Tsuku_moon_phase = 1
    caster.Tsuku_moon_counter = 100
    caster.Tsuku_moon_direction = -1
  end
  if current_phase_idx == 2 then
    if skillawake then
      caster:takeHeal(skillawake.info["Script Arg1"], "hp", caster)
      if ed.run_with_scene then
        local effect = "eff_impact_heal"
        ed.scene:playEffectOnScene(effect, caster.position, {
          caster.direction,
          1
        }, nil, 1)
      end
      local bid = Tsuku.halfmoon_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff:setAttribute("ARM", skillawake.info["Script Arg2"])
      buff:setAttribute("MR", skillawake.info["Script Arg3"])
      if caster:isAlive() then
        caster:addBuff(buff, caster)
      end
    end
    skill.attack_counter = 3
    skill:startPhase(4)
    Tsuku.OldPhaseDelete(caster)
    Tsuku.NewPhaseChange(caster, 3, caster.Tsuku_moon_direction)
    caster.Tsuku_moon_phase = -1
    caster.Tsuku_moon_counter = -100
    caster.Tsuku_moon_direction = 1
  end
  if current_phase_idx == 3 or current_phase_idx == 4 then
    skill:finish()
  end
end

function Tsuku.skillult_finish(basefunc, self)
  local caster = self.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == Tsuku.ult_self_bid then
      caster:removeBuff(buff)
      break
    end
  end
  basefunc(self)
end

function Tsuku.skillatk2_takeEffectOn(basefunc, self, target, source, shift)
  local caster = self.caster
  if caster.Tsuku_moon_direction == -1 then
    caster.Tsuku_moon_counter = caster.Tsuku_moon_counter + Tsuku.skill2_moon_shift * caster.Tsuku_moon_direction
  end
  basefunc(self, target, source, shift)
end

function Tsuku.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    caster.Tsuku_atk3_herolist = {}
    caster.Tsuku_atk3_effectlist = {}
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      else
        table.insert(caster.Tsuku_atk3_herolist, unit)
        if ed.run_with_scene then
          local effect_name = "eff_chain_Tsuku_atk3"
          local Xdistance = unit.position[1] - caster.position[1]
          if Xdistance < 0 then
            Xdistance = -Xdistance
          end
          local Xscale = Xdistance / 550
          local endPos = unit.position
          local startPos = caster.position
          local deg = -math.deg(math.atan2(endPos[2] - startPos[2], endPos[1] - startPos[1]))
          local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {Xscale, 1}, nil, -1, nil, nil, deg)
          table.insert(caster.Tsuku_atk3_effectlist, effect)
        end
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter == 1 then
    for i, unit in ipairs(caster.Tsuku_atk3_herolist) do
      if not unit.buff_effects.invulnerable then
        skill:takeEffectOn(unit)
      end
    end
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
  end
end

function Tsuku.skillatk3_createBuff(basefunc, self, target)
  local buff = basefunc(self, target)
  local hero = self.caster
  for i, unit in ipairs(hero.Tsuku_atk3_herolist) do
    if target.position[1] > hero.position[1] and unit.position[1] < target.position[1] or target.position[1] < hero.position[1] and unit.position[1] > target.position[1] then
      buff.timer = 3
    else
    end
  end
  return buff
end

function Tsuku.skillatk3_takeEffectOn(basefunc, self, target, source, shift)
  local caster = self.caster
  if caster.Tsuku_moon_direction == 1 then
    caster.Tsuku_moon_counter = caster.Tsuku_moon_counter + Tsuku.skill3_moon_shift * caster.Tsuku_moon_direction
  end
  basefunc(self, target, source, shift)
end

function Tsuku.skillatk3_interrupt(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 and caster.Tsuku_atk3_effectlist then
    for i, effect in ipairs(caster.Tsuku_atk3_effectlist) do
      ed.scene:removeEffect(effect, -1)
    end
  end
  basefunc(skill)
end

function Tsuku.skillatk4_start(basefunc, self, target)
  local caster = self.caster
  local skillatk4s = caster.skills.Tsuku_atk4s
  skillatk4s.cd_remaining = skillatk4s.info.CD
  basefunc(self, target)
end

function Tsuku.skillatk4_interrupt(basefunc, self)
  local caster = self.caster
  local skillatk4s = caster.skills.Tsuku_atk4s
  skillatk4s.cd_remaining = skillatk4s.info.CD * 0.5
  basefunc(self)
end

function Tsuku.skillatk4_buff_onDamaged(basefunc, self, damage, damage_type, source, skill)
  local damage = basefunc(self, damage, damage_type, source, skill)
  if 0 < damage and source and source:isAlive() then
    local caster = self.owner
    local skillatk4 = caster.skills.Tsuku_atk4
    damage = skillatk4.info["Script Arg2"] * damage
    if ed.run_with_scene then
      local effect_name = "eff_point_Tsuku_atk4_break"
      ed.scene:playEffectOnScene(effect_name, caster.position, {
        caster.direction,
        1
      }, nil, 1)
    end
  end
  return damage
end

function Tsuku.skillatk4_buff_onRemoved(basefunc, self)
  local owner = self.owner
  for i, buff in ipairs(owner.buff_list) do
    if buff.info.ID == Tsuku.atk4_back_bid then
      owner:removeBuff(buff)
      break
    end
  end
  basefunc(self)
end

function Tsuku.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Tsuku.skillatk4_buff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, Tsuku.skillatk4_buff_onRemoved)
  return buff
end

function Tsuku.skillatk4_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local ret, reason = basefunc(skill, target)
  if not ret then
    return false, reason
  elseif hero.Tsuku_moon_direction == 1 then
    return true
  end
  return false, "not right time"
end

function Tsuku.skillatk4_takeEffectOn(basefunc, self, target, source, shift)
  local ret, dmg = basefunc(self, target, source, shift)
  local caster = self.caster
  caster.Tsuku_moon_counter = caster.Tsuku_moon_counter + Tsuku.skill4_moon_shift * caster.Tsuku_moon_direction
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == Tsuku.atk4_front_bid then
      local bid = Tsuku.atk4_back_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
      break
    end
  end
  return ret, dmg
end

function Tsuku.skillatk4s_start(basefunc, self, target)
  local caster = self.caster
  local skillatk4 = caster.skills.Tsuku_atk4
  skillatk4.cd_remaining = skillatk4.info.CD
  basefunc(self, target)
end

function Tsuku.skillatk4s_interrupt(basefunc, self)
  local caster = self.caster
  local skillatk4 = caster.skills.Tsuku_atk4
  skillatk4.cd_remaining = skillatk4.info.CD * 0.5
  basefunc(self)
end

function Tsuku.skillatk4s_buff_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred)
  local damage = basefunc(self, damage, damage_type, source, skill, transferred)
  if 0 < damage and source and source:isAlive() then
    local caster = self.owner
    if caster then
      local skillatk4s = caster.skills.Tsuku_atk4
      local takedamage = math.min(skillatk4s.info["Script Arg2"] * damage, skillatk4s.info["Script Arg3"])
      if source then
        source:takeDamage(takedamage, "Holy", "hp", source)
      end
      if ed.run_with_scene then
        local effect_name = "eff_point_Tsuku_atk4s_break"
        ed.scene:playEffectOnScene(effect_name, source.position, {
          caster.direction,
          1
        }, nil, 1)
      end
    end
  end
  return damage
end

function Tsuku.skillatk4s_buff_onRemoved(basefunc, self)
  local owner = self.owner
  for i, buff in ipairs(owner.buff_list) do
    if buff.info.ID == Tsuku.atk4_back_bid then
      owner:removeBuff(buff)
      break
    end
  end
  basefunc(self)
end

function Tsuku.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Tsuku.skillatk4s_buff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, Tsuku.skillatk4s_buff_onRemoved)
  return buff
end

function Tsuku.skillatk4s_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local ret, reason = basefunc(skill, target)
  if not ret then
    return false, reason
  elseif hero.Tsuku_moon_direction == -1 then
    return true
  end
  return false, "not right time"
end

function Tsuku.skillatk4s_takeEffectOn(basefunc, self, target, source, shift)
  local ret, dmg = basefunc(self, target, source, shift)
  local caster = self.caster
  caster.Tsuku_moon_counter = caster.Tsuku_moon_counter + Tsuku.skill4_moon_shift * caster.Tsuku_moon_direction
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == Tsuku.atk4s_front_bid then
      local bid = Tsuku.atk4s_back_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
      break
    end
  end
  return ret, dmg
end

function Tsuku.reset(basefunc, hero)
  basefunc(hero)
  hero.Tsuku_atk3_herolist = {}
  hero.Tsuku_atk3_effectlist = {}
  hero.Tsuku_firstphase_timer = 0.25
  hero.Tsuku_moon_direction = 1
  hero.Tsuku_moon_phase = -1
  hero.Tsuku_moon_counter = -100
  hero.Tsuku_moon_speed = 1
end

function Tsuku.init_hero(hero)
  hero.reset = override(hero.reset, Tsuku.reset)
  hero.update = override(hero.update, Tsuku.update)
  local ult = hero.skills.Tsuku_ult
  local ult1 = hero.skills.Tsuku_ult1
  local ult2 = hero.skills.Tsuku_ult2
  if ult then
    ult.info["No Speeder"] = true
    ult.canTrigger = override(ult.canTrigger, Tsuku.skillult_canTrigger)
    ult.start = override(ult.start, Tsuku.skillult_start)
    ult.onAttackFrame = override(ult.onAttackFrame, Tsuku.skillult_onAttackFrame)
    ult.trigger = override(ult.trigger, Tsuku.skillult_trigger)
    ult.interrupt = override(ult.interrupt, Tsuku.skillult_interrupt)
    ult.onPhaseFinished = override(ult.onPhaseFinished, Tsuku.skillult_onPhaseFinished)
    ult.finish = override(ult.finish, Tsuku.skillult_finish)
    ult1.createBuff = override(ult1.createBuff, Tsuku.skillult1_createBuff)
    ult1.createRegion = override(ult1.createRegion, Tsuku.skillult1_createRegion)
    ult2.createBuff = override(ult2.createBuff, Tsuku.skillult2_createBuff)
    ult2.takeEffectOn = override(ult2.takeEffectOn, Tsuku.skillult2_takeEffectOn)
  end
  local skillatk2 = hero.skills.Tsuku_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Tsuku.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.Tsuku_atk3
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Tsuku.skillatk3_onAttackFrame)
    skillatk3.interrupt = override(skillatk3.interrupt, Tsuku.skillatk3_interrupt)
    skillatk3.createBuff = override(skillatk3.createBuff, Tsuku.skillatk3_createBuff)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Tsuku.skillatk3_takeEffectOn)
  end
  local skillatk4 = hero.skills.Tsuku_atk4
  local skillatk4s = hero.skills.Tsuku_atk4s
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, Tsuku.skillatk4_start)
    skillatk4.interrupt = override(skillatk4.interrupt, Tsuku.skillatk4_interrupt)
    skillatk4.createBuff = override(skillatk4.createBuff, Tsuku.skillatk4_createBuff)
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, Tsuku.skillatk4_canCastWithTarget)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Tsuku.skillatk4_takeEffectOn)
    skillatk4s.start = override(skillatk4s.start, Tsuku.skillatk4s_start)
    skillatk4s.interrupt = override(skillatk4s.interrupt, Tsuku.skillatk4s_interrupt)
    skillatk4s.createBuff = override(skillatk4s.createBuff, Tsuku.skillatk4s_createBuff)
    skillatk4s.canCastWithTarget = override(skillatk4s.canCastWithTarget, Tsuku.skillatk4s_canCastWithTarget)
    skillatk4s.takeEffectOn = override(skillatk4s.takeEffectOn, Tsuku.skillatk4s_takeEffectOn)
  end
  return hero
end

return Tsuku.init_hero
