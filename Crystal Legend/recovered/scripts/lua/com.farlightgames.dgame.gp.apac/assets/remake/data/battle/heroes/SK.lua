module("ed.battlehero", package.seeall)
local ed = ed
SK = {}
SK.ult_interval = 0.5
SK.fashion_id_1 = 831

function SK.calculateDirection(caster)
  local SK_left = 0
  local SK_right = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    local dx = unit.position[1] - caster.position[1]
    if unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
      if 0 < dx then
        SK_right = SK_right + 1
      else
        SK_left = SK_left + 1
      end
    end
  end
  if SK_right < SK_left then
    return -1
  elseif SK_right > SK_left then
    return 1
  else
    return -caster:getInitDir()
  end
end

function SK.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  caster.direction = SK.calculateDirection(caster)
  caster.startdirection = caster.direction
  skill.casterDirectionLocked = true
  basefunc(skill, target)
end

function SK.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  caster.direction = caster.startdirection
  caster.position1 = caster.position
  local position1 = caster.position[1] + caster.direction * 300
  if position1 > ed.engine.stage_rect.maxX - 20 then
    position1 = ed.engine.stage_rect.maxX - 20
  elseif position1 < ed.engine.stage_rect.minX + 20 then
    position1 = ed.engine.stage_rect.minX + 20
  end
  basefunc(skill)
  caster:setPosition({
    position1,
    caster.position[2]
  })
  local bid = 10008306
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  skill.casterDirectionLocked = false
end

function SK.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.SK_atk4
  if isHit and dmg and 0 < dmg and skillatk4 and skillatk4.evo_rank and skillatk4.evo_rank >= 3 and target and not target.buff_effects.building then
    target:addBuff(skillatk4:createBuff(target))
  end
  return isHit, dmg
end

function SK.skillatk2_finish(basefunc, skill)
  skill.casterDirectionLocked = false
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 10008306 then
      tbuff.timer = -1
    end
  end
end

function SK.skillatk3_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    local caster = skill.caster
    local bid = 10008307
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  if skill.attack_counter == 9 then
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 10008307 then
        tbuff.timer = -1
      end
    end
    return
  end
  basefunc(skill, location, source)
end

function SK.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HAST", -skill.evo_rank3["Script Arg1"])
    buff:setAttribute("MSPD", -skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function SK.hero_handleUnitDieEventToAll(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk4 = self.skills.SK_atk4
  local skillatk2 = self.skills.SK_atk2
  local skillatk4b = self.skills.SK_atk4b
  local skillult = self.skills.SK_ult
  if self.current_skill and skillatk4 and skillatk2 then
    if self.current_skill == skillatk4 and skillatk4b then
      skillatk4b:takeEffectAt(unit.position)
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 and self.current_skill == skillatk2 and skillatk4b then
      skillatk4b:takeEffectAt(unit.position)
    end
    if skillult and skillult.evo_rank and skillult.evo_rank >= 3 and self.current_skill == skillult and skillult.attack_counter < 1 and skillatk4b then
      skillatk4b:takeEffectAt(unit.position)
    end
  end
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 10008304 then
      local caster = tbuff.caster
      if skillatk4b then
        skillatk4b:takeEffectAt(unit.position)
      end
    end
  end
end

function SK.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  caster.direction = SK.calculateDirection(caster)
  caster.startdirection = caster.direction
  skill.casterDirectionLocked = true
  basefunc(skill, target)
end

function SK.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillatk2 = caster.skills.SK_atk2
  if attack_counter == 0 then
    caster.direction = caster.startdirection
    caster.position1 = caster.position
    if skillatk2 and skill.evo_rank and skill.evo_rank >= 3 then
      skillatk2:takeEffectAt(caster.position)
    end
    if skill.target then
      local position1 = caster.position[1] + caster.direction * 300
      if position1 > ed.engine.stage_rect.maxX - 20 then
        position1 = ed.engine.stage_rect.maxX - 20
      elseif position1 < ed.engine.stage_rect.minX + 20 then
        position1 = ed.engine.stage_rect.minX + 20
      end
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
    end
    basefunc(skill)
    skill.casterDirectionLocked = false
  else
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
    end
    local bid = 10008308
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local EarthquakeBuff = ed.BuffCreate(binfo, caster, caster)
    EarthquakeBuff.attack_timer = 0
    EarthquakeBuff.update = override(EarthquakeBuff.update, SK.skillult_Earthquake_buffUpdate)
    caster:addBuff(EarthquakeBuff, caster)
    skill.attack_counter = skill.attack_counter + 1
    skill.casterDirectionLocked = false
  end
end

function SK.skillult_finish(basefunc, skill)
  skill.casterDirectionLocked = false
  basefunc(skill)
end

function SK.skillult_Earthquake_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  local caster = buff.caster
  while timer <= 0 do
    timer = timer + SK.ult_interval
    local skillultb = caster.skills.SK_ultb
    if skillultb then
      skillultb:takeEffectAt(caster.position, caster)
    end
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function SK.hero_update(basefunc, self, dt)
  basefunc(self, dt)
  if self.current_skill and (self.current_skill.info["Skill Name"] == "SK_atk2" or self.current_skill.info["Skill Name"] == "SK_ult") then
    self.direction = self.startdirection
  end
end

function SK.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.skillatk4_target = nil
end

function SK.hero_true_init(hero)
  hero.update = override(hero.update, SK.hero_update)
  hero.reset = override(hero.reset, SK.hero_reset)
  local skillult = hero.skills.SK_ult
  local skillatk = hero.skills.SK_atk
  local skillultb = hero.skills.SK_ultb
  local skillatk2 = hero.skills.SK_atk2
  local skillatk3 = hero.skills.SK_atk3
  local skillatk4 = hero.skills.SK_atk4
  local skillatk4b = hero.skills.SK_atk4b
  if skillult then
    skillult.start = override(skillult.start, SK.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, SK.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, SK.skillult_finish)
    if skillultb then
      if skillult.evo_rank and skillult.evo_rank >= 1 then
        skillultb.info = ed.wraptable(skillultb.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
        })
      end
      if skillult.evo_rank and skillult.evo_rank >= 2 then
        skillultb.info = ed.wraptable(skillultb.info, {
          ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
        })
      end
    end
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, SK.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, SK.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, SK.skillatk2_takeEffectOn)
    skillatk2.finish = override(skillatk2.finish, SK.skillatk2_finish)
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
    if SK.fashion_id_1 and SK.fashion_id_1 == hero.fashion_id then
      local originfo1 = skillatk2.info
      skillatk2.info = ed.wraptable(originfo1, {
        ["Point Effect"] = "eff_point_SK_fashion_1_atk2.cha"
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, SK.skillatk3_createBuff)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, SK.skillatk3_takeEffectAt)
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
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      local buff_info = skillatk4.info.buff_info
      skillatk4.info = ed.wraptable(skillatk4.info, {
        buff_info = ed.wraptable(buff_info, {
          Time = buff_info.Time + skillatk4.evo_rank2["Script Arg1"]
        })
      })
    end
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, SK.hero_handleUnitDieEventToAll)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4b and skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4b.info = ed.wraptable(skillatk4b.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if SK.fashion_id_1 and SK.fashion_id_1 == hero.fashion_id then
      local originfo1 = skillatk4.info
      skillatk4.info = ed.wraptable(originfo1, {
        ["Point Effect"] = "eff_point_SK_fashion_1_atk4.cha"
      })
    end
  end
  return hero
end

function SK.init_hero(hero)
  SK.hero_true_init(hero)
  return hero
end

return SK.init_hero
