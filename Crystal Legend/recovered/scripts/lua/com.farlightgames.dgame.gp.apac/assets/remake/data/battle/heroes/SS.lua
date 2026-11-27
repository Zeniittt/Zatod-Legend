module("ed.battlehero", package.seeall)
local ed = ed
SS = {}
SS.mirror_time = 15
SS.snakeAttribs = 10007604

function SS.SSSnake_update(basefunc, unit, dt)
  unit.mDuration_SS = unit.mDuration_SS - dt
  if unit.mDuration_SS <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function SS.createProjectile(basefunc, skill)
  local counter = 0
  local counter_max = 3
  if skill.evo_rank and skill.evo_rank >= 2 then
    counter_max = 4
  end
  if skill.evo_rank and 3 <= skill.evo_rank then
    counter_max = 5
  end
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if counter >= counter_max then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    else
      counter = counter + 1
      skill.target = unit
      local projectile = basefunc(skill, unit)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function SS.skillatk4_onAttackFrame(basefunc, skill)
  local targetposition = skill.target.position
  local caster = skill.caster
  basefunc(skill)
  if skill.target and skill.target:isAlive() and ed.run_with_scene then
    local effect_atk = "eff_point_SS_atk3.cha"
    local casterorigin = skill.target.position
    ed.scene:playEffectOnScene(effect_atk, casterorigin, {1, 1}, nil, 0)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    local bid = 10007603
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("HPR", caster.attribs.INT * 1)
    caster:addBuff(buff, caster)
  end
end

function SS.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  if skill.target then
    for i, tbuff in ipairs(skill.target.buff_list) do
      if tbuff.info.ID == 10007602 and tbuff.caster == skill.caster then
        local buff = tbuff
        buff.timer = 0.1
        break
      end
    end
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    for i, ttbuff in ipairs(skill.caster.buff_list) do
      if ttbuff.info.ID == 10007603 then
        local buff2 = ttbuff
        buff2.timer = -1
        break
      end
    end
  end
end

function SS.atk4_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk4 = caster.skills.SS_atk4
  if buff.caster.current_skill and caster.current_skill.info["Skill Name"] == "SS_atk4" then
    caster.current_skill:interrupt()
  end
  basefunc(buff)
end

function SS.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  buff.onRemoved = override(buff.onRemoved, SS.atk4_buff_onRemoved)
  return buff
end

function SS.skillatk4_takeEffectOn(basefunc, skill, target, source)
  local buff = false
  basefunc(skill, target, source)
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 10007602 then
      buff = true
      break
    end
  end
  if not buff and skill.caster.current_skill and skill.caster.current_skill.info["Skill Name"] == "SS_atk4" then
    skill.caster.current_skill:interrupt()
  end
end

function SS.skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local target = skill.target
  local skillult = caster.skills.SS_ult
  local proto = {
    _tid = 173,
    _level = skillult.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local SSSnake1 = ed.UnitCreate(proto, caster.camp, config)
  SSSnake1.mDuration_SS = SS.mirror_time
  SSSnake1.update = override(SSSnake1.update, SS.SSSnake_update)
  SSSnake1:setDeathWithEffectOrNot(true)
  SSSnake1.direction = caster.direction
  local SSSnake1_atk = SSSnake1.skills.SSSnake_atk
  if SSSnake1_atk then
    if skill.evo_rank and 1 <= skill.evo_rank then
      SSSnake1_atk.info = ed.wraptable(SSSnake1_atk.info, {
        ["Plus Ratio"] = skill.evo_rank1["Script Arg1"]
      })
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      SSSnake1_atk.info = ed.wraptable(SSSnake1_atk.info, {
        ["Plus Ratio"] = skill.evo_rank2["Script Arg1"]
      })
    end
  end
  local SSSnake2 = ed.UnitCreate(proto, caster.camp, config)
  SSSnake2.mDuration_SS = SS.mirror_time
  SSSnake2.update = override(SSSnake2.update, SS.SSSnake_update)
  SSSnake2:setDeathWithEffectOrNot(true)
  SSSnake2.direction = caster.direction
  local SSSnake2_atk = SSSnake2.skills.SSSnake_atk
  if SSSnake2_atk then
    if skill.evo_rank and 1 <= skill.evo_rank then
      SSSnake2_atk.info = ed.wraptable(SSSnake2_atk.info, {
        ["Plus Ratio"] = skill.evo_rank1["Script Arg1"]
      })
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      SSSnake2_atk.info = ed.wraptable(SSSnake2_atk.info, {
        ["Plus Ratio"] = skill.evo_rank2["Script Arg1"]
      })
    end
  end
  local SSSnake3 = ed.UnitCreate(proto, caster.camp, config)
  SSSnake3.mDuration_SS = SS.mirror_time
  SSSnake3.update = override(SSSnake3.update, SS.SSSnake_update)
  SSSnake3:setDeathWithEffectOrNot(true)
  SSSnake3.direction = caster.direction
  local SSSnake3_atk = SSSnake3.skills.SSSnake_atk
  if SSSnake3_atk then
    if skill.evo_rank and 1 <= skill.evo_rank then
      SSSnake3_atk.info = ed.wraptable(SSSnake3_atk.info, {
        ["Plus Ratio"] = skill.evo_rank1["Script Arg1"]
      })
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      SSSnake3_atk.info = ed.wraptable(SSSnake3_atk.info, {
        ["Plus Ratio"] = skill.evo_rank2["Script Arg1"]
      })
    end
  end
  local locationss1, locationss2, locationss3, locationss4
  locationss1 = {
    target.position[1] - SSSnake3.direction * 30,
    target.position[2] + SSSnake1.direction * 30
  }
  locationss2 = {
    target.position[1] + SSSnake3.direction * 30,
    target.position[2] - SSSnake2.direction * 30
  }
  locationss3 = {
    target.position[1] - SSSnake3.direction * 60,
    target.position[2] - SSSnake2.direction * 10
  }
  locationss4 = {
    target.position[1] + SSSnake3.direction * 60,
    target.position[2] + SSSnake1.direction * 10
  }
  ed.engine:summonUnit(SSSnake1, locationss1, caster)
  SSSnake1.father = caster
  if caster.sslist == nil then
    caster.sslist = {}
  end
  local snake_attribs = skill.info["Script Arg2"] * 0.01
  local AttriBinfo = ed.lookupDataTable("Buff", nil, SS.snakeAttribs)
  SS.changeBuffInfo(AttriBinfo, snake_attribs, SSSnake1)
  local buff = SSSnake1:addBuff(AttriBinfo, caster)
  SSSnake1:setHP(SSSnake1.attribs.HP)
  table.insert(caster.sslist, SSSnake1)
  ed.engine:summonUnit(SSSnake2, locationss2, caster)
  SSSnake2.father = caster
  if caster.sslist == nil then
    caster.sslist = {}
  end
  local snake_attribs = skill.info["Script Arg2"] * 0.01
  local AttriBinfo = ed.lookupDataTable("Buff", nil, SS.snakeAttribs)
  SS.changeBuffInfo(AttriBinfo, snake_attribs, SSSnake2)
  local buff = SSSnake2:addBuff(AttriBinfo, caster)
  SSSnake2:setHP(SSSnake2.attribs.HP)
  table.insert(caster.sslist, SSSnake2)
  ed.engine:summonUnit(SSSnake3, locationss3, caster)
  SSSnake3.father = caster
  if caster.sslist == nil then
    caster.sslist = {}
  end
  local snake_attribs = skill.info["Script Arg2"] * 0.01
  local AttriBinfo = ed.lookupDataTable("Buff", nil, SS.snakeAttribs)
  SS.changeBuffInfo(AttriBinfo, snake_attribs, SSSnake3)
  local buff = SSSnake3:addBuff(AttriBinfo, caster)
  SSSnake3:setHP(SSSnake3.attribs.HP)
  table.insert(caster.sslist, SSSnake3)
  if skill.evo_rank and skill.evo_rank >= 3 then
    local SSSnake4 = ed.UnitCreate(proto, caster.camp, config)
    SSSnake4.mDuration_SS = SS.mirror_time
    SSSnake4.update = override(SSSnake4.update, SS.SSSnake_update)
    SSSnake4:setDeathWithEffectOrNot(true)
    SSSnake4.direction = caster.direction
    local SSSnake4_atk = SSSnake4.skills.SSSnake_atk
    if SSSnake4_atk then
      if skill.evo_rank and 1 <= skill.evo_rank then
        SSSnake4_atk.info = ed.wraptable(SSSnake4_atk.info, {
          ["Plus Ratio"] = skill.evo_rank1["Script Arg1"]
        })
      end
      if skill.evo_rank and skill.evo_rank >= 2 then
        SSSnake4_atk.info = ed.wraptable(SSSnake4_atk.info, {
          ["Plus Ratio"] = skill.evo_rank2["Script Arg1"]
        })
      end
    end
    ed.engine:summonUnit(SSSnake4, locationss4, caster)
    SSSnake4.father = caster
    if caster.sslist == nil then
      caster.sslist = {}
    end
    local snake_attribs = skill.info["Script Arg2"] * 0.01
    local AttriBinfo = ed.lookupDataTable("Buff", nil, SS.snakeAttribs)
    SS.changeBuffInfo(AttriBinfo, snake_attribs, SSSnake4)
    local buff = SSSnake4:addBuff(AttriBinfo, caster)
    SSSnake4:setHP(SSSnake4.attribs.HP)
    table.insert(caster.sslist, SSSnake4)
  end
end

function SS.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function SS.hero_die(basefunc, hero, killer)
  if hero.sslist then
    for i, sssnake in ipairs(hero.sslist) do
      if sssnake and sssnake:isAlive() then
        sssnake:die()
      end
    end
  end
  basefunc(hero, killer)
end

function SS.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("MR", -50)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = 4
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = 5
  end
  return buff
end

function SS.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.SS_atk4
  if skillatk4 and skillatk4.casting then
    return false
  end
  return basefunc(skill, target)
end

function SS.init_hero(hero)
  hero.die = override(hero.die, SS.hero_die)
  local skillatk2 = hero.skills.SS_atk2
  local skillatk3 = hero.skills.SS_atk3
  local skillatk4 = hero.skills.SS_atk4
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, SS.createProjectile)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, SS.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, SS.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, SS.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, SS.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, SS.skillatk4_takeEffectOn)
  end
  local skillult = hero.skills.SS_ult
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, SS.skillult_canCastWithTarget)
    skillult.takeEffectAt = override(skillult.takeEffectAt, SS.skillult_takeEffectAt)
  end
  return hero
end

return SS.init_hero
