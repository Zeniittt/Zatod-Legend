module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossDOOM = {}
AwakeBossDOOM.name = "AwakeBossDOOM"
AwakeBossDOOM.skillFashionId = 651
AwakeBossDOOM.fashion_healhp_index = 5000
AwakeBossDOOM.fashion_healmp_index = 50

function AwakeBossDOOM.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local powerratio = 1.5
  if self.evo_rank and self.evo_rank >= 3 then
    powerratio = 2
  end
  local caster = self.caster
  local list1 = ed.engine.alive_units[caster.camp]
  local i1 = #list1
  local i1sum = 0
  for i, tunit in ipairs(list1) do
    if not tunit.config.is_summoned then
      i1sum = i1sum + 1
    end
  end
  local list2 = ed.engine.alive_units[-caster.camp]
  local i2 = #list2
  local i2sum = 0
  for i, tunit in ipairs(list2) do
    if not tunit.config.is_summoned then
      i2sum = i2sum + 1
    end
  end
  if i1sum < i2sum then
    power = power * powerratio
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function AwakeBossDOOM.skillatk4_selectTarget(basefunc, self, default)
  local caster = self.caster
  local selector = ed.rand
  local max = -math.huge
  local chosen
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
        local v = selector(unit)
        if max < v then
          max = v
          chosen = unit
        end
      end
    end
  end
  self.target = chosen
  return self.target
end

function AwakeBossDOOM.skillatk4_eatPerformance(caster, target, type)
  if ed.run_with_scene then
    local info
    if type == 2 then
      local skillatk2 = caster.skills.AwakeBossDOOM_atk4_2
      info = skillatk2.info
    elseif type == 3 then
      local skillatk3 = caster.skills.AwakeBossDOOM_atk4_3
      info = skillatk3.info
    elseif type == 4 then
      local skillatk4 = caster.skills.AwakeBossDOOM_atk4_4
      info = skillatk4.info
    end
    local direction = caster.direction
    local location = target.position
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    local effect_name = info["Point Effect"]
    if not effect_name then
      return
    end
    local effect_z = info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, origin, {
      caster.direction,
      1
    }, nil, effect_z)
    local str = "devour"
    local color = caster.camp == ed.emCampPlayer and "blue" or "red"
    ed.PopupCreate(str, color, target.actor, nil, "text")
  end
end

function AwakeBossDOOM.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 1 then
    local target = AwakeBossDOOM.skillatk4_selectTarget(nil, skill, nil)
    if target then
      if target.info["Main Attrib"] == "AGI" then
        caster.killtype = 3
      elseif target.info["Main Attrib"] == "INT" then
        caster.killtype = 4
      elseif target.info["Main Attrib"] == "STR" then
        caster.killtype = 2
      end
      local _ = AwakeBossDOOM.skillatk4_eatPerformance(caster, target, caster.killtype)
      local targetHP = target.hp
      local damage = skill.info["Script Arg2"]
      if skill.evo_rank and 1 <= skill.evo_rank then
        damage = damage + skill.evo_rank1["Script Arg1"]
      end
      target:takeDamage(damage, "Holy", "hp", caster, 1, 1)
      local statDamage = damage * target.dPSStatisticsRatio
      caster.battledata:addDamage(statDamage, "Holy")
      skill.curDevourHP = damage
      local MPGR = caster.attribs.MPGainRatio or 0
      if MPGR then
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
      end
    else
      skill:interrupt()
      skill.cd_remaining = 1
      skill.caster.global_cd = skill.info["Global CD"] * 0.5
    end
  elseif skill.curDevourHP then
    skill.curDevourHP = nil
    if caster and caster.killtype == 3 then
      local skillatk3 = caster.skills.AwakeBossDOOM_atk4_3
      skillatk3:takeEffectOn(caster)
    elseif caster and caster.killtype == 4 then
      local skillatk4 = caster.skills.AwakeBossDOOM_atk4_4
      skillatk4:takeEffectOn(caster)
    elseif caster and caster.killtype == 2 then
      local skillatk2 = caster.skills.AwakeBossDOOM_atk4_2
      skillatk2:takeEffectOn(caster)
    end
  end
end

function AwakeBossDOOM.skillatk4_interrupt(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 0 then
    skill.cd_remaining = 1
  end
end

function AwakeBossDOOM.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_DOOM_ult.cha"
    local origin = {400, 0}
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
  end
end

function AwakeBossDOOM.ult_buff_onRemoved(basefunc, buff)
  buff.caster.doomend = 1
  buff.caster.doom = 0
  for i, tbuff in ipairs(buff.owner.buff_list) do
    if tbuff.info.ID == 12002708 then
      local buff = tbuff
      buff.timer = 0
      break
    end
  end
  if ed.run_with_scene and buff.caster.name == "AwakeBossDOOM" then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
  basefunc(buff)
end

function AwakeBossDOOM.ult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.caster.doomend == 1 or buff.caster and (not buff.caster:isAlive() or buff.caster.mp == 0 and buff.caster.name == "AwakeBossDOOM") then
    buff.owner:removeBuff(buff)
    buff.caster.doomend = 1
    buff.caster.doom = 0
  end
  if buff.owner and 1 >= buff.owner.hp then
    for i, tbuff in ipairs(buff.owner.buff_list) do
      if tbuff.info.ID == 12002708 then
        local ownerPopupPervious = buff.owner.notPopupBattleInfo
        buff.owner.notPopupBattleInfo = true
        local hprPerDt = -buff.info.HPR * dt
        buff.owner:takeDamage(hprPerDt, "Holy", "hp", buff.caster, nil, 0, true)
        buff.owner.notPopupBattleInfo = ownerPopupPervious
        break
      end
    end
  end
end

function AwakeBossDOOM.skillult_createBuff(basefunc, skill, target)
  skill.caster.doom = 1
  skill.caster.doomend = 0
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  if skill.evo_rank and 1 <= skill.evo_rank then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  buff.update = override(buff.update, AwakeBossDOOM.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, AwakeBossDOOM.ult_buff_onRemoved)
  local owner = skill.caster
  local bid = 12002704
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff1 = ed.BuffCreate(binfo, owner, owner)
  owner:addBuff(buff1, owner)
  local undoom
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 10006509 or tbuff.info.ID == 12002709 then
        undoom = 1
        break
      end
    end
    if target.buff_effects.undoom then
      undoom = 1
    end
  end
  if undoom ~= 1 then
    local bid2 = 12002708
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, target, owner)
    target:addBuff(buff2, owner)
  end
  if ed.run_with_scene and buff.caster.name == "AwakeBossDOOM" then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  return buff
end

function AwakeBossDOOM.skillult_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  if target_type == "target" then
    if default then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      local undoom
      if unit then
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == 10006509 or tbuff.info.ID == 12002709 then
            undoom = 1
            break
          end
        end
      end
      if unit.buff_effects.undoom then
        undoom = 1
      end
      if undoom then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit.buff_effects.invulnerable then
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
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function AwakeBossDOOM.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local undoom
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 10006509 or tbuff.info.ID == 12002709 then
        undoom = 1
        break
      end
    end
    if target.buff_effects.undoom then
      undoom = 1
    end
  end
  if not basefunc(skill, target) or hero.name == "AwakeBossDOOM" and hero.mp < 500 or hero.doom == 1 or hero.manually_casting or undoom then
    return false
  end
  return true
end

function AwakeBossDOOM.skillult_interrupt(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:setMP(caster.mp + skill.info["Cost MP"] * (1 - caster.attribs.CDR / 100))
end

function AwakeBossDOOM.update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit.doomend == 1 or unit.doomend == 0 and unit.doom == 1 and unit.mp == 0 then
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 10006504 then
        local buff = tbuff
        buff.timer = 0
        unit.doomend = 1
        unit.doom = 0
        break
      end
    end
    if ed.run_with_scene and unit.name == "AwakeBossDOOM" then
      local panel = unit.heroPanel
      if panel then
        panel.mp_bar.star:setVisible(false)
        panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
      end
    end
  end
end

function AwakeBossDOOM.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function AwakeBossDOOM.init_hero(hero)
  hero.update = override(hero.update, AwakeBossDOOM.update)
  local skillult = hero.skills.AwakeBossDOOM_ult
  local skillatk2 = hero.skills.AwakeBossDOOM_atk2
  local skillatk3 = hero.skills.AwakeBossDOOM_atk3
  local skillatk4 = hero.skills.AwakeBossDOOM_atk4
  if skillult then
    skillult.createBuff = override(skillult.createBuff, AwakeBossDOOM.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, AwakeBossDOOM.skillult_canCastWithTarget)
    skillult.selectTarget = override(skillult.selectTarget, AwakeBossDOOM.skillult_selectTarget)
    skillult.start = override(skillult.start, AwakeBossDOOM.skillult_start)
    skillult.interrupt = override(skillult.interrupt, AwakeBossDOOM.skillult_interrupt)
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossDOOM.skillatk2_createBuff)
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    skillatk3.getDamage = override(skillatk3.getDamage, AwakeBossDOOM.skillatk3_getDamage)
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Gain MP"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Gain MP"] = skillatk4.evo_rank3["Script Arg1"]
      })
    end
    skillatk4.selectTarget = override(skillatk4.selectTarget, AwakeBossDOOM.skillatk4_selectTarget)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, AwakeBossDOOM.skillatk4_onAttackFrame)
    skillatk4.interrupt = override(skillatk4.interrupt, AwakeBossDOOM.skillatk4_interrupt)
  end
  return hero
end

return AwakeBossDOOM.init_hero
