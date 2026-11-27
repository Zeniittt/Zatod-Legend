module("ed.battlehero", package.seeall)
local ed = ed
TS = {}
TS.ult_interval = 1
TS.atk3_interval = 0.25
TS.skillFashionId = 571
TS.fashion_buffID = 4083

function TS.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ultBuff_TS or hero.mp < 1000 then
    return false
  end
  return true
end

function TS.skillult_createBuff(basefunc, skill, target)
  local owner = skill.caster
  local buff = basefunc(skill, target)
  buff.attack_timer = 0
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("LFS", skill.evo_rank3["Script Arg3"])
  end
  buff.update = override(buff.update, TS.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, TS.skillult_buffOnRemoved)
  buff.owner.ultBuff_TS = 1
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  return buff
end

function TS.skillult_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  if timer <= 0 then
    timer = timer + TS.ult_interval
    local skillults = buff.caster.skills.TS_ults
    if skillults then
      local owner = skillults.caster
      skillults:takeEffectAt(owner.position)
    end
  end
  buff.attack_timer = timer
  if buff.owner.mp == 0 then
    buff.owner.removeBuff(buff.owner, buff)
  end
  basefunc(buff, dt)
end

function TS.skillult_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.ultBuff_TS = nil
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
end

function TS.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    local effect_moon = "eff_point_TS_ult.cha"
    local casterorigin = skill.caster.position
    ed.scene:playEffectOnScene(effect_moon, casterorigin, {
      skill.caster.direction,
      1
    }, nil, 0)
  end
end

function TS.skillatk2_findNextTaeget(basefunc, self)
  local jump_gap = 0
  local abs = math.abs
  local min = {
    0,
    math.huge
  }
  local ret
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
    else
      local times = self.affect_times[unit] or 0
      if times > min[1] then
      else
        local distanceSQ = abs(ed.edpDistanceSQ(unit.position, self.source.position) - jump_gap)
        if distanceSQ > min[2] then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = {times, distanceSQ}
        end
      end
    end
  end
  if ret then
    self:enableTrack(ret)
  end
  return ret
end

function TS.projectile_isOutOfStage(basefunc, orb)
  local isOut = false
  return isOut
end

function TS.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(9)
  projectile:enableTrack(skill.target)
  projectile.findNextTaeget = override(projectile.findNextTaeget, TS.skillatk2_findNextTaeget)
  projectile.isOutOfStage = override(projectile.isOutOfStage, TS.projectile_isOutOfStage)
  return projectile
end

function TS.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local origin = target.position
  local scale = {
    target.direction,
    1
  }
  if ed.run_with_scene then
    local effect_name = "eff_impact_TS_atk2.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, origin, scale, nil, 1)
  end
  basefunc(skill, target)
end

function TS.skillatk3_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  if timer <= 0 then
    timer = timer + TS.atk3_interval
    local skillatk3s = buff.caster.skills.TS_atk3s
    local target = skillatk3s:selectTarget()
    if target then
      skillatk3s:takeEffectOn(target, buff.owner)
    end
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function TS.skillatk3s_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default and default:isAlive() then
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
    local enchantedbyself = caster.buff_effects.enchantedbyself
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif enchanted and unit == caster then
      elseif enchantedbyself and unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
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

function TS.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = 0
  buff.update = override(buff.update, TS.skillatk3_buffUpdate)
  return buff
end

function TS.init_hero(hero)
  local skillult = hero.skills.TS_ult
  local skillults = hero.skills.TS_ults
  local skillatk2 = hero.skills.TS_atk2
  local skillatk3 = hero.skills.TS_atk3
  local skillatk3s = hero.skills.TS_atk3s
  local skillatk4 = hero.skills.TS_atk4
  if skillult then
    if skillults then
      if skillult.evo_rank and skillult.evo_rank >= 1 then
        skillults.info = ed.wraptable(skillults.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"],
          ["LFS%"] = nil
        })
      end
      if skillult.evo_rank and skillult.evo_rank >= 2 then
        skillults.info = ed.wraptable(skillults.info, {
          ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"],
          ["LFS%"] = nil
        })
      end
      if skillult.evo_rank and skillult.evo_rank >= 3 then
        skillults.info = ed.wraptable(skillults.info, {
          ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"],
          ["LFS%"] = skillult.evo_rank3["Script Arg2"]
        })
      end
    end
    skillult.createBuff = override(skillult.createBuff, TS.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TS.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TS.skillult_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, TS.skillatk2_createProjectile)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TS.skillatk2_takeEffectOn)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    if skillatk3s then
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        skillatk3s.info = ed.wraptable(skillatk3s.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        skillatk3s.info = ed.wraptable(skillatk3s.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        skillatk3s.info = ed.wraptable(skillatk3s.info, {
          ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
        })
      end
      skillatk3s.selectTarget = override(skillatk3s.selectTarget, TS.skillatk3s_selectTarget)
    end
    skillatk3.createBuff = override(skillatk3.createBuff, TS.skillatk3_createBuff)
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank3["Script Arg1"]
      })
    end
  end
  return hero
end

return TS.init_hero
