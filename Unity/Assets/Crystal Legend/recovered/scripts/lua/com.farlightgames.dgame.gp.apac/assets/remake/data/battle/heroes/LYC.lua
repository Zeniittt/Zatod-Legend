module("ed.battlehero", package.seeall)
local ed = ed
LYC = {}
LYC.blink_distance = 70

function LYC.skillatk2b_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_Luna_night.cha"
    local origin = {
      ed.engine.stage_rect.maxX / 2,
      0
    }
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end

function LYC.skillatk2b_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(9)
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    skill.target.ishurt = true
    local jump_gap = 6400
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
      projectile:enableTrack(ret)
    end
    return ret
  end
  
  return projectile
end

function LYC.skillatk2b_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local attack_counter = skill.attack_counter
  if attack_counter == 1 and ed.run_with_scene then
    local effect_name = "eff_point_LYC_atk2_1.cha"
    if not effect_name then
      return
    end
    local effect_z = 0
    local origin = {
      target.position[1],
      target.position[2] - 1
    }
    ed.scene:playEffectOnScene(effect_name, origin, {
      skill.caster.direction,
      1
    }, nil, effect_z)
  end
end

function LYC.skillatk4_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 3 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 400,
      ["Shape Arg2"] = 200,
      ["AOE Shape"] = "rectangle",
      ["Plus Ratio"] = 0.7,
      ["Max Range"] = 400
    })
    skill.max_range_sq = 160000
    basefunc(skill)
    skill.info = originfo
    skill.max_range_sq = 19600
  elseif attack_counter == 2 then
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = 0.7
    })
    basefunc(skill)
    skill.info = originfo
  else
    basefunc(skill)
  end
end

function LYC.skillult_start(basefunc, skill, target)
  local owner = skill.caster
  skill.caster.isWolf_LYC = true
  local bid = 10008102
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function LYC.skillult_finish(basefunc, skill)
  basefunc(skill)
  skill.caster:enterActionStageFromOneStage(2, 81)
  local HP = skill.info["Script Arg2"]
  local ratio = skill.info["Script Arg3"]
  skill.caster:takeHeal(skill.info["Script Arg2"] + skill.caster.attribs.HP * ratio)
  local owner = skill.caster
  if ed.run_with_scene then
    local panel = owner.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  if ed.run_with_scene and skill.caster.name == "LYC" then
    local panel = skill.caster.heroPanel
    if panel then
      local pic = "UI/DOTA-HERO/"
      pic = pic .. "LYCult.png"
      panel:setPortrait(pic)
    end
  end
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 10008102 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  local owner = skill.caster
  local bid = 10008101
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff1 = ed.BuffCreate(binfo, owner, owner)
  local hast = buff1.info.HAST
  local mspd = buff1.info.MSPD
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff1:setAttribute("HAST", hast + skill.evo_rank1["Script Arg1"])
    buff1:setAttribute("MSPD", mspd + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff1:setAttribute("MPR", -skill.evo_rank3["Script Arg1"])
  end
  owner:addBuff(buff1, owner)
end

function LYC.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.mp < 1000 and skill.caster.name == "LYC" or skill.caster.isWolf_LYC == true then
    return false
  end
  return true
end

function LYC.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local owner = skill.caster
    local bid = 10008102
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, owner)
    basefunc(skill)
  elseif attack_counter == 1 then
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 10008102 then
        local buff = tbuff
        buff.owner:removeBuff(buff)
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function LYC.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 10008102 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function LYC.skillatk3b_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local owner = skill.caster
    local bid = 10008102
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, owner)
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    local target = skill.target
    target = target or skill:selectTarget(nil)
    skill.attack_counter = skill.attack_counter + 1
    local caster = skill.caster
    if target then
      local direction = 0 < target.position[1] - caster.position[1] and 1 or -1
      local position1 = target.position[1] - direction * LYC.blink_distance
      if target.buff_effects.stable or 799 < position1 or position1 < 1 then
        position1 = position1 - direction * LYC.blink_distance
        if 799 < position1 then
          position1 = 780
        elseif position1 < 1 then
          position1 = 10
        end
      end
      caster.position = {
        position1,
        target.position[2]
      }
    end
  else
    basefunc(skill)
  end
end

function LYC.skillatk3b_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 10008102 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function LYC.reset(basefunc, unit)
  basefunc(unit)
  unit:enterActionStageFromOneStage(1, 81)
  unit.isWolf_LYC = false
end

function LYC.power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  if skill.caster.isWolf_LYC then
    local skillult = skill.caster.skills.LYC_ult
    local ADratio = skillult.info["Script Arg4"]
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      ADratio = ADratio + skillult.evo_rank2["Script Arg1"]
    end
    if skillult then
      ret = ret + ADratio * skill.info["Plus Ratio"] * skill.caster.mp / 1000
    end
  end
  return ret
end

function LYC.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local CRIT = buff.info.CRIT
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("CRIT", CRIT + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("CRIT", CRIT + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("CRIT", CRIT + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"] + skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function LYC.skillatk4b_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 10008108
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  owner:addBuff(binfo, owner)
end

function LYC.skillatk4b_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 10008108 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function LYC.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.isWolf_LYC = false
  hero.reset = override(hero.reset, LYC.reset)
  local skillult = hero.skills.LYC_ult
  local skillatk2 = hero.skills.LYC_atk2
  local skillatk2b = hero.skills.LYC_atk2b
  local skillatk3 = hero.skills.LYC_atk3
  local skillatk3b = hero.skills.LYC_atk3b
  local skillatk4 = hero.skills.LYC_atk4
  local skillatk4b = hero.skills.LYC_atk4b
  local skillatk = hero.skills.LYC_atk
  local skillatkb = hero.skills.LYC_atkb
  if skillult then
    skillult.start = override(skillult.start, LYC.skillult_start)
    skillult.finish = override(skillult.finish, LYC.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, LYC.skillult_canCastWithTarget)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, LYC.skillatk2_createBuff)
    if skillatk2b then
      if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg2"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg2"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg2"]
        })
      end
      skillatk2b.power = override(skillatk2b.power, LYC.power)
      skillatk2b.start = override(skillatk2b.start, LYC.skillatk2b_start)
      skillatk2b.createProjectile = override(skillatk2b.createProjectile, LYC.skillatk2b_createProjectile)
      skillatk2b.takeEffectOn = override(skillatk2b.takeEffectOn, LYC.skillatk2b_takeEffectOn)
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
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, LYC.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, LYC.skillatk3_finish)
    if skillatk3b then
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg2"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg2"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg2"]
        })
      end
      skillatk3b.onAttackFrame = override(skillatk3b.onAttackFrame, LYC.skillatk3b_onAttackFrame)
      skillatk3b.power = override(skillatk3b.power, LYC.power)
      skillatk3b.finish = override(skillatk3b.finish, LYC.skillatk3b_finish)
    end
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, LYC.skillatk4_onAttackFrame)
    if skillatk4b then
      if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
        skillatk4b.info = ed.wraptable(skillatk4b.info, {
          ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
        })
      end
      if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
        skillatk4b.info = ed.wraptable(skillatk4b.info, {
          ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
        })
      end
      if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
        skillatk4b.info = ed.wraptable(skillatk4b.info, {
          ["Plus Ratio"] = skillatk4.evo_rank3["Script Arg1"]
        })
      end
      skillatk4b.power = override(skillatk4b.power, LYC.power)
    end
  end
  if skillatkb then
    skillatkb.power = override(skillatkb.power, LYC.power)
  end
  return hero
end

return LYC.init_hero
