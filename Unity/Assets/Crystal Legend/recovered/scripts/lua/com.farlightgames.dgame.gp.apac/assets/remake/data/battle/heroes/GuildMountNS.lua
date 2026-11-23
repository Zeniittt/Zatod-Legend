module("ed.battlehero", package.seeall)
local ed = ed
GuildMountNS = {}
GuildMountNS.ult = 12003101
GuildMountNS.inv = 12003102
GuildMountNS.atk4 = 12003103
GuildMountNS.atk2 = 12003104
GuildMountNS.uncontrollable = 12003108
GuildMountNS.nightStartTimeMin = 15
GuildMountNS.nightStartTimeMax = 30
GuildMountNS.nightDuration = 45
GuildMountNS.nightHastBuffId = 1077

function GuildMountNS.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = GuildMountNS.uncontrollable
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
  if skill.caster.daytype and skill.caster.daytype == "day" then
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      unit:dayAndNightSwitchImpact("daytonight")
    end
  end
  skill.caster.benight = true
end

function GuildMountNS.skillult_interrupt(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    if skill.caster.daytype and skill.caster.daytype == "night" then
      for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
        unit:dayAndNightSwitchImpact("nighttoday")
      end
    end
    if ed.run_with_scene and not ed.IsMultiArena() then
      local new_effect_list = {}
      local effect_list = ed.scene.effect_list
      for i, effect in ipairs(effect_list) do
        if caster.ult_nighteffect and caster.ult_nighteffect == effect then
          effect:removeFromParentAndCleanup(true)
        else
          table.insert(new_effect_list, effect)
        end
      end
      caster.ult_nighteffect = nil
      ed.scene.effect_list = new_effect_list
    end
  end
end

function GuildMountNS.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.name == "GuildMountNS" and hero.mp < 1000 or hero.manually_casting or hero.benight then
    return false
  end
  return true
end

function GuildMountNS.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("MPR", -skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("MPR", -skill.evo_rank2["Script Arg1"])
  end
  buff.update = override(buff.update, GuildMountNS.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, GuildMountNS.skillult_buffOnRemoved)
  target.skillultbuff = buff
  return buff
end

function GuildMountNS.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.mp == 0 and buff.owner:isAlive() then
    buff.timer = -1
  end
end

function GuildMountNS.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local nighteffect = false
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit.name == "GuildMountNS" and unit:isAlive() and unit ~= caster and unit.ult_nighteffect then
      nighteffect = true
    end
  end
  if not nighteffect and ed.run_with_scene and not ed.IsMultiArena() then
    local effect_night = "eff_point_NS_night3.cha"
    local origin = {
      ed.engine.stage_rect.maxX / 2,
      0
    }
    skill.caster.ult_nighteffect = ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
  end
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(10, 0.3, 5)
  end
end

function GuildMountNS.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:enterActionStageFromOneStage(2, 86)
  if ed.run_with_scene and caster.name == "GuildMountNS" then
    local panel = caster.heroPanel
    if panel then
      local pic = "UI/DOTA-HERO/"
      pic = pic .. "GuildMountNSnight.png"
      panel:setPortrait(pic)
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == GuildMountNS.uncontrollable then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  local skillatkb = caster.skills.GuildMountNS_atkb
  if skillatkb then
    caster.basic_skill = skillatkb
    caster.attack_range = skillatkb.info["Max Range"]
    local skillatk = caster.skills.GuildMountNS_atk
    skillatk.cd_remaining = 9999
    skillatk:pause()
  end
  local skillult2 = caster.skills.GuildMountNS_ult2
  if skillult2 then
    skillult2.cd_remaining = 0
  end
end

function GuildMountNS.skillult_buffOnRemoved(basefunc, buff)
  buff.owner.emptybuff = nil
  local caster = buff.caster
  if caster.current_skill then
    caster.current_skill:finish()
  end
  caster.skillultbuff = nil
  caster.benight = false
  local stillnight = false
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit.name == "GuildMountNS" and unit:isAlive() and unit ~= caster then
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == GuildMountNS.ult then
          stillnight = true
          if caster.ult_nighteffect then
            unit.ult_nighteffect = caster.ult_nighteffect
          end
        end
      end
    end
  end
  if not stillnight then
    if ed.run_with_scene and not ed.IsMultiArena() then
      local new_effect_list = {}
      local effect_list = ed.scene.effect_list
      for i, effect in ipairs(effect_list) do
        if caster.ult_nighteffect and caster.ult_nighteffect == effect then
          effect:removeFromParentAndCleanup(true)
        else
          table.insert(new_effect_list, effect)
        end
      end
      caster.ult_nighteffect = nil
      ed.scene.effect_list = new_effect_list
    end
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      unit:dayAndNightSwitchImpact("nighttoday")
    end
    if ed.run_with_scene and not ed.IsMultiArena() then
      local effect_night = "eff_point_NS_night2.cha"
      local origin = {
        ed.engine.stage_rect.maxX / 2,
        0
      }
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
    end
    caster.ult_nighteffect = nil
  end
  caster.global_cd = 0
  local skillult3 = caster.skills.GuildMountNS_ult3
  if skillult3 then
    skillult3.cd_remaining = 0
  end
  basefunc(buff)
end

function GuildMountNS.skillult2_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = GuildMountNS.inv
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  local dir = owner:getInitDir()
  if dir == 1 then
    owner.direction = 1
  else
    owner.direction = -1
  end
  owner.startdirection = owner.direction
  basefunc(skill, target)
end

function GuildMountNS.skillult2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  return projectile
end

function GuildMountNS.skillult2_projectile_collideCheck(basefunc, self, unit)
  if self.track_target and unit ~= self.track_target then
    return false
  end
  if not self.skill.info["Tile Piercing"] then
    if unit.buff_effects.untargetable then
      return false
    end
    if unit.buffManager.invisible and unit.camp ~= self.camp then
      return false
    end
  end
  local radius = 62.5
  local d = self.position[1]
  local d0 = self.previous_position[1]
  local ux = unit.position[1] - d
  local ux0 = unit.previous_position[1] - d0
  if 0 < ux and 0 < ux0 then
    ux = ux - radius
    ux0 = ux0 - radius
  elseif ux < 0 and ux0 < 0 then
    ux = ux + radius
    ux0 = ux0 + radius
  end
  local t = -ux0 / (ux - ux0)
  if t < 0 or 1 < t then
    return false
  end
  return t
end

function GuildMountNS.skillult2_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == GuildMountNS.inv then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function GuildMountNS.skillult2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 1 then
    skill:selectTarget()
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["No Dodge"] = true
    })
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter == 0 then
    caster.oldposition = {}
    caster.oldposition[1] = caster.position[1]
    caster.oldposition[2] = caster.position[2]
    local dir = caster:getInitDir()
    if dir == 1 then
      caster.position[1] = 1
    else
      caster.position[1] = 799
    end
    caster.position[2] = skill.target and skill.target.position[2] or caster.position[2]
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    caster.position = caster.oldposition
    skill.attack_counter = skill.attack_counter + 1
  end
end

function GuildMountNS.skillult3_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = GuildMountNS.inv
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function GuildMountNS.skillult3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:enterActionStageFromOneStage(1, 86)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == GuildMountNS.inv then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  if ed.run_with_scene and caster.name == "GuildMountNS" then
    local panel = caster.heroPanel
    if panel then
      local pic = "UI/DOTA-HERO/"
      pic = pic .. "GuildMountNS.png"
      panel:setPortrait(pic)
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
  local skillatk = caster.skills.GuildMountNS_atk
  if skillatk then
    skillatk.cd_remaining = 1.5
    caster.basic_skill = skillatk
  end
end

function GuildMountNS.skillatk2_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = GuildMountNS.atk2
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, owner)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("PIMU", skill.evo_rank1["Script Arg1"])
    buff:setAttribute("MIMU", skill.evo_rank1["Script Arg1"])
  end
  owner:addBuff(buff, owner)
  basefunc(skill, target)
end

function GuildMountNS.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == GuildMountNS.atk2 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function GuildMountNS.skillatk2_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  return buff
end

function GuildMountNS.skillatk2b_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = GuildMountNS.inv
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  owner.GuildMountNSatk2bPosition = {
    owner.position[1],
    owner.position[2],
    0
  }
  basefunc(skill, target)
end

function GuildMountNS.skillatk2b_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == GuildMountNS.inv then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function GuildMountNS.skillatk2b_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.target then
    caster.position = {
      skill.target.position[1],
      skill.target.position[2] - 1
    }
  end
  if skill.attack_counter == 4 and caster.GuildMountNSatk2bPosition then
    caster.position = {
      caster.GuildMountNSatk2bPosition[1],
      caster.GuildMountNSatk2bPosition[2],
      0
    }
  end
  basefunc(skill)
end

function GuildMountNS.skillatk2b_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    return
  elseif skill.attack_counter == 5 then
    return
  end
  basefunc(skill, target)
end

function GuildMountNS.skillatk3b_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local skillatk3 = caster.skills.GuildMountNS_atk3
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      buff.timer = skillatk3.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      buff.timer = skillatk3.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
    end
  end
  buff:setAttribute("fearrange", 5)
  return buff
end

function GuildMountNS.hero_update(basefunc, self, dt)
  local skillatk4 = self.skills.GuildMountNS_atk4
  local haveskillatk4buff = false
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == GuildMountNS.atk4 then
      haveskillatk4buff = true
    end
  end
  if skillatk4 and self.daytype == "night" and not haveskillatk4buff then
    skillatk4:takeEffectOn(self)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      local hpheal = self.attribs.HP * skillatk4.evo_rank3["Script Arg1"] / 100
      self:takeHeal(hpheal, "hp", self)
    end
  end
  basefunc(self, dt)
  if self.current_skill and self.current_skill.info["Skill Name"] == "GuildMountNS_ult2" then
    self.direction = self.startdirection
  end
end

function GuildMountNS.skillatk4_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local HAST = buff.info.HAST
  local MSPD = buff.info.MSPD
  local DODG = buff.info.DODG
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HAST", HAST + skill.evo_rank1["Script Arg1"])
    buff:setAttribute("MSPD", MSPD + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("DODG", DODG + skill.evo_rank2["Script Arg1"])
  end
  buff.update = override(buff.update, GuildMountNS.skillatk4_buffUpdate)
  return buff
end

function GuildMountNS.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.daytype == "day" and buff.owner:isAlive() then
    buff.timer = -1
  end
end

function GuildMountNS.reset(basefunc, unit)
  basefunc(unit)
  unit:enterActionStageFromOneStage(1, 86)
  unit.benight = false
end

function GuildMountNS.hero_die(basefunc, hero, killer)
  local stillnight = false
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit.name == "GuildMountNS" and unit:isAlive() and unit ~= hero then
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == GuildMountNS.ult then
          stillnight = true
          if hero.ult_nighteffect then
            unit.ult_nighteffect = hero.ult_nighteffect
          end
        end
      end
    end
  end
  if not stillnight then
    if ed.run_with_scene and not ed.IsMultiArena() then
      local new_effect_list = {}
      local effect_list = ed.scene.effect_list
      for i, effect in ipairs(effect_list) do
        if hero.ult_nighteffect and hero.ult_nighteffect == effect then
          effect:removeFromParentAndCleanup(true)
          local effect_night = "eff_point_NS_night2.cha"
          local origin = {
            ed.engine.stage_rect.maxX / 2,
            0
          }
          ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
        else
          table.insert(new_effect_list, effect)
        end
      end
      hero.ult_nighteffect = nil
      ed.scene.effect_list = new_effect_list
    end
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      unit:dayAndNightSwitchImpact("nighttoday")
    end
  end
  hero.ult_nighteffect = nil
  basefunc(hero, killer)
end

function GuildMountNS.ult_func_hideBuffEffect(unit)
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

function GuildMountNS.ult_func_resetBuffEffect(unit)
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

function GuildMountNS.getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type, source, skill, field)
  local lost = basefunc(unit, damage, immunity, damage_type, source, skill, field)
  if field == "mp" then
    lost = lost * 1.5
    if unit.level < 80 then
      unit:takeDamage(lost * 200 * unit.level / 120, "Holy", "hp", source)
    end
    if unit.level >= 80 then
      unit:takeDamage(lost * 200, "Holy", "hp", source)
    end
  end
  return lost
end

function GuildMountNS.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, GuildMountNS.getLostHPAfterImmunity)
  local skillult = hero.skills.GuildMountNS_ult
  local skillult2 = hero.skills.GuildMountNS_ult2
  local skillult3 = hero.skills.GuildMountNS_ult3
  local skillatk2 = hero.skills.GuildMountNS_atk2
  local skillatk2b = hero.skills.GuildMountNS_atk2b
  local skillatk3 = hero.skills.GuildMountNS_atk3
  local skillatk3b = hero.skills.GuildMountNS_atk3b
  local skillatk4 = hero.skills.GuildMountNS_atk4
  if hero.name == "GuildMountNS" then
    hero.die = override(hero.die, GuildMountNS.hero_die)
    hero.reset = override(hero.reset, GuildMountNS.reset)
  end
  if skillult then
    skillult.start = override(skillult.start, GuildMountNS.skillult_start)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, GuildMountNS.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, GuildMountNS.skillult_createBuff)
    skillult.finish = override(skillult.finish, GuildMountNS.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GuildMountNS.skillult_onAttackFrame)
    skillult.interrupt = override(skillult.interrupt, GuildMountNS.skillult_interrupt)
  end
  if skillult2 then
    skillult2.onAttackFrame = override(skillult2.onAttackFrame, GuildMountNS.skillult2_onAttackFrame)
    skillult2.start = override(skillult2.start, GuildMountNS.skillult2_start)
    skillult2.finish = override(skillult2.finish, GuildMountNS.skillult2_finish)
    skillult2.createProjectile = override(skillult2.createProjectile, GuildMountNS.skillult2_createProjectile)
    if skillult and skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult2.info = ed.wraptable(skillult2.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillult3 then
    skillult3.start = override(skillult3.start, GuildMountNS.skillult3_start)
    skillult3.finish = override(skillult3.finish, GuildMountNS.skillult3_finish)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, GuildMountNS.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, GuildMountNS.skillatk2_finish)
    skillatk2.createBuff = override(skillatk2.createBuff, GuildMountNS.skillatk2_createBuff)
  end
  if skillatk2b then
    skillatk2b.onAttackFrame = override(skillatk2b.onAttackFrame, GuildMountNS.skillatk2b_onAttackFrame)
    skillatk2b.takeEffectOn = override(skillatk2b.takeEffectOn, GuildMountNS.skillatk2b_takeEffectOn)
    skillatk2b.start = override(skillatk2b.start, GuildMountNS.skillatk2b_start)
    skillatk2b.finish = override(skillatk2b.finish, GuildMountNS.skillatk2b_finish)
    if skillatk2 then
      if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
        })
      end
    end
  end
  if skillatk3b then
    skillatk3b.createBuff = override(skillatk3b.createBuff, GuildMountNS.skillatk3b_createBuff)
    if skillatk3 and skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3b.info = ed.wraptable(skillatk3b.info, {
        ["Shape Arg1"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk4 then
    hero.update = override(hero.update, GuildMountNS.hero_update)
    skillatk4.createBuff = override(skillatk4.createBuff, GuildMountNS.skillatk4_createBuff)
  end
  return hero
end

return GuildMountNS.init_hero
