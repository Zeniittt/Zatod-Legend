module("ed.battlehero", package.seeall)
local ed = ed
Dancer = {}
Dancer.fashion_id_1 = 100431
Dancer.Dancer_atk2SelfBuffID = 11004301
Dancer.Dancer_atk4SelfBuffID = 11004305
Dancer.Dancer_atk3MatePreBuffID = 11004309
Dancer.Dancer_atk3FoePreBuffID = 11004310
Dancer.Dancer_atk3TravelBackTime = 10
Dancer.Dancer_atk3FoeFrontDis = 80
Dancer.Dancer_atk3FoeBackDis = 200
Dancer.Dancer_atk3FoeYDis = 200
Dancer.Dancer_atk3WaitTime = 0.5
Dancer.Dancer_atk3UpTime = 0.5

function Dancer.skillatk2_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if not caster.Dancer_leadingDancer then
    caster.Dancer_leadingDancer = true
    local dir = caster:getInitDir()
    caster:setPosition({
      ed.engine.stage_rect.maxX / 2 - dir * 230,
      caster.position[2]
    })
    caster.direction = dir
  end
end

function Dancer.skillultb_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local fashionId = caster.fashion_id
  if Dancer.fashion_id_1 and Dancer.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_Dancer_atk2b_fashion_1.cha")
  end
  return buff
end

function Dancer.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Dancer.Dancer_atk2SelfBuffID)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(selfBuff, caster)
  skill.selfUnctlBuff = selfBuff
  if ed.run_with_scene then
    local effect_night = "eff_point_Luna_night.cha"
    local origin = {
      ed.engine.stage_rect.maxX / 2,
      0
    }
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end

function Dancer.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  if skill.selfUnctlBuff then
    skill.caster:removeBuff(skill.selfUnctlBuff)
    skill.selfUnctlBuff = nil
  end
end

function Dancer.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk2b = caster.skills.Dancer_atk2b
  if skillatk2b then
    local binfo = skillatk2b.info.buff_info
    for unit in ed.engine:foreachAliveUnit(skillatk2b:affectedCamp()) do
      local slowBuff = ed.BuffCreate(binfo, unit, caster)
      unit:addBuff(slowBuff, caster)
    end
  end
end

function Dancer.prepareBuff_update(basefunc, buff, dt)
  local buffCaster = buff.caster
  local buffOwner = buff.owner
  if not buff.sumTime then
    buff.sumTime = 0
  end
  buff.sumTime = buff.sumTime + dt
  if buff.sumTime >= Dancer.Dancer_atk3WaitTime then
    if buff.Dancer_GoPoint and not buffOwner.buff_effects.building and not buffOwner.buff_effects.stable then
      buffOwner:knockup(0.75, {0, 0})
    else
      buff.timer = 0
    end
  end
  if buff.sumTime >= Dancer.Dancer_atk3WaitTime + Dancer.Dancer_atk3UpTime then
    if buff.Dancer_GoPoint and not buffOwner.buff_effects.building and not buffOwner.buff_effects.stable then
      buffOwner:setPosition(buff.Dancer_GoPoint)
      buffOwner:moveDrop(200)
      if ed.run_with_scene and Dancer.fashion_id_1 and Dancer.fashion_id_1 == buffCaster.fashion_id then
        local effect_name = "eff_point_Dancer_atk3b_fashion_1.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, buffOwner.position, {1, 1}, nil, 1)
      elseif ed.run_with_scene then
        local effect_name = "eff_point_Dancer_atk3b.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, buffOwner.position, {1, 1}, nil, 1)
      end
    end
    buff.timer = 0
  end
  basefunc(buff, dt)
end

function Dancer.travelBuff_update(basefunc, buff, dt)
  local travelMate = buff.owner
  local buffCaster = buff.caster
  buff.durTime = buff.durTime + dt
  if buff.durTime >= Dancer.Dancer_atk3TravelBackTime then
    local lilSkillState
    if not travelMate.manually_casting and travelMate.current_skill then
      local lilSkill = travelMate.current_skill
      local current_phase_idx = lilSkill.current_phase_idx
      local max_phase_idx = #lilSkill.phase_list
      local max_event_idx = #lilSkill.current_phase.event_list
      local next_event_idx = lilSkill.next_event_idx
      if current_phase_idx == max_phase_idx and max_event_idx < next_event_idx then
        lilSkillState = true
      end
    end
    if not travelMate.manually_casting and (travelMate.current_skill == nil or lilSkillState) then
      if buff.Dancer_nearPoint and not travelMate.buff_effects.building and not travelMate.buff_effects.stable then
        local binfo = ed.lookupDataTable("Buff", nil, Dancer.Dancer_atk3MatePreBuffID)
        local mateUpBuff = ed.BuffCreate(binfo, travelMate, buffCaster)
        mateUpBuff.update = override(mateUpBuff.update, Dancer.prepareBuff_update)
        if Dancer.fashion_id_1 and Dancer.fashion_id_1 == buffCaster.fashion_id then
          mateUpBuff:setAttribute("Effect", "eff_point_Dancer_atk3a_fashion_1.cha")
        end
        travelMate:addBuff(mateUpBuff, buffCaster)
        mateUpBuff.Dancer_GoPoint = buff.Dancer_nearPoint
      end
      buff.timer = 0
    end
  end
  basefunc(buff, dt)
end

function Dancer.isFarUnit(skill)
  local farUnit
  local distanceSQ = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
    else
      local unitSQ = ed.edpDistanceSQ(unit.position, caster.position)
      if distanceSQ <= unitSQ then
        distanceSQ = unitSQ
        farUnit = unit
      end
    end
  end
  return farUnit
end

function Dancer.isMinUnit(skill)
  local caster = skill.caster
  local dir = caster:getInitDir()
  local minDis = math.huge
  local minUnit
  local xRange = Dancer.Dancer_atk3FoeFrontDis + Dancer.Dancer_atk3FoeBackDis
  local yRange = Dancer.Dancer_atk3FoeYDis
  local location = caster.position
  local origin = {
    location[1] - dir * Dancer.Dancer_atk3FoeBackDis,
    location[2]
  }
  for unit in ed.engine:foreachAliveUnit(-skill:affectedCamp()) do
    if unit.buff_effects.building or unit.buff_effects.stable or unit.buff_effects.untargetable or unit.buff_effects.invulnerable or unit.buff_effects.uncontrollable or unit.buffManager.invisible then
    else
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * dir
      if skill.testPointInShape(p2, "rectangle", xRange, yRange) then
        local disSQ = ed.edpDistanceSQ(unit.position, caster.position)
        if minDis >= disSQ then
          minDis = disSQ
          minUnit = unit
        end
      end
    end
  end
  return minUnit
end

function Dancer.skillatk3_createBuff(basefunc, skill, target)
  local travelBuff = basefunc(skill, target)
  travelBuff.update = override(travelBuff.update, Dancer.travelBuff_update)
  travelBuff.durTime = 0
  local ARM = travelBuff.info.ARM
  local MR = travelBuff.info.MR
  if skill.evo_rank and skill.evo_rank >= 1 then
    travelBuff:setAttribute("ARM", ARM + skill.evo_rank1["Script Arg1"])
    travelBuff:setAttribute("MR", MR + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    travelBuff:setAttribute("ARM", ARM + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
    travelBuff:setAttribute("MR", MR + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    travelBuff:setAttribute("AD", skill.evo_rank3["Script Arg1"])
    travelBuff:setAttribute("AP", skill.evo_rank3["Script Arg1"])
  end
  local caster = skill.caster
  local mateTarget = target
  if mateTarget and mateTarget:isAlive() and not mateTarget.buff_effects.building and not mateTarget.buff_effects.stable then
    local binfo = ed.lookupDataTable("Buff", nil, Dancer.Dancer_atk3MatePreBuffID)
    local mateUpBuff = ed.BuffCreate(binfo, mateTarget, caster)
    mateUpBuff.update = override(mateUpBuff.update, Dancer.prepareBuff_update)
    mateTarget:addBuff(mateUpBuff, caster)
    local skillatk3b = caster.skills.Dancer_atk3b
    if skillatk3b then
      local farTarget = skillatk3b:selectTarget(nil)
      if farTarget then
        local dir = caster:getInitDir()
        travelBuff.Dancer_nearPoint = {
          mateTarget.position[1],
          mateTarget.position[2]
        }
        travelBuff.Dancer_farPoint = {
          farTarget.position[1] + 60 * dir,
          mateTarget.position[2]
        }
        mateUpBuff.Dancer_GoPoint = {
          farTarget.position[1] + 60 * dir,
          mateTarget.position[2]
        }
      else
        local farUnit = Dancer.isFarUnit(skill)
        if farUnit then
          local dir = caster:getInitDir()
          travelBuff.Dancer_nearPoint = {
            mateTarget.position[1],
            mateTarget.position[2]
          }
          travelBuff.Dancer_farPoint = {
            farUnit.position[1] + 20 * dir,
            mateTarget.position[2]
          }
          mateUpBuff.Dancer_GoPoint = {
            farUnit.position[1] + 20 * dir,
            mateTarget.position[2]
          }
        else
          local dir = caster:getInitDir()
          travelBuff.Dancer_nearPoint = {
            mateTarget.position[1],
            mateTarget.position[2]
          }
          travelBuff.Dancer_farPoint = {
            mateTarget.position[1] + 200 * dir,
            mateTarget.position[2]
          }
          mateUpBuff.Dancer_GoPoint = {
            mateTarget.position[1] + 200 * dir,
            mateTarget.position[2]
          }
        end
      end
    end
  end
  local minUnit = Dancer.isMinUnit(skill)
  if minUnit then
    local binfo = ed.lookupDataTable("Buff", nil, Dancer.Dancer_atk3FoePreBuffID)
    local foeUpBuff = ed.BuffCreate(binfo, minUnit, caster)
    foeUpBuff.update = override(foeUpBuff.update, Dancer.prepareBuff_update)
    minUnit:addBuff(foeUpBuff, caster)
    foeUpBuff.Dancer_GoPoint = {
      caster.position[1] + caster:getInitDir() * 350,
      minUnit.position[2]
    }
  end
  return travelBuff
end

function Dancer.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    local binfo = ed.lookupDataTable("Buff", nil, Dancer.Dancer_atk4SelfBuffID)
    local selfBuff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(selfBuff, caster)
    skill.selfUnconBuff = selfBuff
  end
end

function Dancer.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  if skill.selfUnconBuff then
    skill.caster:removeBuff(skill.selfUnconBuff)
    skill.selfUnconBuff = nil
  end
end

function Dancer.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    if not skill.target then
      skill:interrupt()
      return
    end
    skill.attack_counter = skill.attack_counter + 1
    skill.startPos = {
      caster.position[1],
      caster.position[2]
    }
    skill.startDir = caster.direction
    local moveDir = skill.target.position[1] > caster.position[1] and -1 or 1
    caster:setPosition({
      skill.target.position[1] + moveDir * 100,
      skill.target.position[2]
    })
  elseif skill.attack_counter == 1 then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Target Type"] = "nearest"
    })
    basefunc(skill)
    skill.info = originInfo
  elseif skill.attack_counter == 2 then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Target Type"] = "nearest",
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 130
    })
    basefunc(skill)
    skill.info = originInfo
  elseif skill.attack_counter == 3 then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Track Type"] = "projectile",
      ["Target Type"] = "nearest"
    })
    basefunc(skill)
    skill.info = originInfo
  elseif skill.attack_counter == 4 then
    skill.attack_counter = skill.attack_counter + 1
    if skill.startPos and skill.startDir then
      caster:setPosition(skill.startPos)
      caster.direction = skill.startDir
      skill.startPos = nil
      skill.startDir = nil
    end
  end
end

function Dancer.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, crit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if ret and skill.attack_counter == 2 then
    local skillatk4b = caster.skills.Dancer_atk4b
    if skillatk4b then
      local binfo = skillatk4b.info.buff_info
      local bSucess, reason = ed.Buff.checkAddBuff(binfo, skill.level, target, caster)
      if bSucess then
        local buff = ed.BuffCreate(binfo, target, caster)
        target:addBuff(buff, caster)
      else
        local color = target.camp == ed.emCampEnemy and "red" or "blue"
        local text = reason == "resist" and "resist" or "miss"
        if target.actor then
          ed.PopupCreate(text, color, target.actor, nil, "text")
        end
      end
    end
  end
  return ret, dmg, crit
end

function Dancer.loveBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  if buff.timer <= 0 and not ed.engine.beingEnd then
    local caster = buff.caster
    local owner = buff.owner
    local skillultb = caster.skills.Dancer_ultb
    if skillultb then
      local binfo = skillultb.info.buff_info
      local buff = ed.BuffCreate(binfo, owner, caster)
      if Dancer.fashion_id_1 and Dancer.fashion_id_1 == caster.fashion_id then
        buff:setAttribute("Effect", "eff_buff_Dancer_atk2b_fashion_1.cha")
      end
      owner:addBuff(buff, caster)
    end
  end
end

function Dancer.skillult_createBuff(basefunc, skill, target)
  local loveBuff = basefunc(skill, target)
  local buffInfo = loveBuff.info
  local owner = loveBuff.owner
  local caster = loveBuff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if Dancer.fashion_id_1 and Dancer.fashion_id_1 == caster.fashion_id then
    loveBuff:setAttribute("Effect", "eff_buff_Dancer_atk2a_fashion_1.cha")
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    loveBuff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  loveBuff.onRemoved = override(loveBuff.onRemoved, Dancer.loveBuff_onRemoved)
  return loveBuff
end

function Dancer.newProjectile_update(basefunc, projectile, dt)
  if ed.run_with_scene and projectile.actor then
    projectile.actor.ownRotation = 0
    projectile.actor.ownScaleX = 1
    projectile.actor.ownScaleY = 1
  end
  basefunc(projectile, dt)
end

function Dancer.newProjectile_hit(basefunc, projectile, target)
  if target ~= projectile.hitTarget then
    return
  else
    basefunc(projectile, target)
    if not projectile.terminated then
      projectile:terminate()
    end
  end
end

function Dancer.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local firstTarget = skill.target
  local targetList = {}
  table.insert(targetList, firstTarget)
  local secondTarget
  local foes = {}
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit == firstTarget then
    elseif unit.buff_effects.untargetable then
    elseif unit.buff_effects.uncontrollable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
    else
      table.insert(foes, {
        unit,
        ed.rand()
      })
    end
  end
  table.sort(foes, function(a, b)
    return a[2] > b[2]
  end)
  local hero_num = #foes
  if 1 <= hero_num then
    secondTarget = foes[1][1]
    table.insert(targetList, secondTarget)
  end
  for i = 1, #targetList do
    if targetList[i] then
      local newProjectile = basefunc(skill)
      newProjectile.hitTarget = targetList[i]
      newProjectile.hit = override(newProjectile.hit, Dancer.newProjectile_hit)
      newProjectile.update = override(newProjectile.update, Dancer.newProjectile_update)
      local h = newProjectile.height - 30
      local vz = -newProjectile.zSpeed
      local t = h / vz
      local distance = ed.edpSub(targetList[i].position, newProjectile.position)
      newProjectile.velocity = ed.edpMult(distance, 1 / t)
      ed.engine:addProjectile(newProjectile)
    end
  end
  return nil
end

function Dancer.hero_reset(basefunc, hero)
  local skillult = hero.skills.Dancer_ult
  local skillatk4 = hero.skills.Dancer_atk4
  hero.Dancer_leadingDancer = nil
  if Dancer.fashion_id_1 and Dancer.fashion_id_1 == hero.fashion_id then
    if skillult then
      local originfo1 = skillult.info
      skillult.info = ed.wraptable(originfo1, {
        ["Impact Effect"] = "eff_impact_Dancer_atk2_fashion_1.cha",
        ["Tile Art"] = "eff_tile_Dancer_atk2_fashion_1.cha"
      })
    end
    if skillatk4 then
      local originfo3 = skillatk4.info
      skillatk4.info = ed.wraptable(originfo3, {
        ["Tile Art"] = "eff_tile_Dancer_atk4_fashion_1.cha"
      })
    end
  end
  basefunc(hero)
end

function Dancer.hero_setAction(basefunc, hero, action_name, loop, interrupt)
  local new_action_name = action_name
  if ed.engine.ticks and ed.engine.ticks >= 300 and new_action_name == "Death" and ed.rand() < 0.1 and hero.info.Name == "Dancer" then
    new_action_name = "Death2"
  end
  basefunc(hero, new_action_name, loop, interrupt)
end

function Dancer.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local ARM = buff.info.ARM
  local MR = buff.info.MR
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("ARM", ARM + skill.evo_rank1["Script Arg1"])
    buff:setAttribute("MR", MR + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("ARM", ARM + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
    buff:setAttribute("MR", MR + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function Dancer.init_hero(hero)
  local skillult = hero.skills.Dancer_ult
  local skillultb = hero.skills.Dancer_ultb
  local skillatk2 = hero.skills.Dancer_atk2
  local skillatk3 = hero.skills.Dancer_atk3
  local skillatk4 = hero.skills.Dancer_atk4
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    skillult.createBuff = override(skillult.createBuff, Dancer.skillult_createBuff)
    skillult.createProjectile = override(skillult.createProjectile, Dancer.skillult_createProjectile)
  end
  if skillultb then
    skillultb.createBuff = override(skillultb.createBuff, Dancer.skillultb_createBuff)
  end
  if skillatk2 then
    skillatk2.update = override(skillatk2.update, Dancer.skillatk2_update)
    skillatk2.start = override(skillatk2.start, Dancer.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, Dancer.skillatk2_finish)
    skillatk2.createBuff = override(skillatk2.createBuff, Dancer.skillatk2_createBuff)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Dancer.skillatk2_onAttackFrame)
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, Dancer.skillatk3_createBuff)
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
    skillatk4.start = override(skillatk4.start, Dancer.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, Dancer.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Dancer.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Dancer.skillatk4_takeEffectOn)
  end
  hero.reset = override(hero.reset, Dancer.hero_reset)
  hero.setAction = override(hero.setAction, Dancer.hero_setAction)
  return hero
end

return Dancer.init_hero
