module("ed.battlehero", package.seeall)
local ed = ed
TC = {}

function TC.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster and caster:isAlive() then
    local proto = {
      _tid = 210,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      summoner = caster
    }
    local soul = ed.UnitCreate(proto, caster.camp, config)
    local target = skill.target
    target = target or skill:selectTarget(nil)
    if target then
      local location = target.position
      local location_soul = {
        location[1] - 60 * caster.direction,
        location[2] + 0
      }
      if location_soul[1] > 780 then
        location_soul[1] = 780
      elseif location_soul[1] < 20 then
        location_soul[1] = 20
      end
      ed.engine:summonUnit(soul, location_soul, caster)
    else
      local location = caster.position
      local location_soul = {
        location[1] - 60 * caster.direction,
        location[2] + 0
      }
      if location_soul[1] > 780 then
        location_soul[1] = 780
      elseif location_soul[1] < 20 then
        location_soul[1] = 20
      end
      ed.engine:summonUnit(soul, location_soul, caster)
    end
    soul.father = caster
    local bid = 11002101
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, soul, caster)
    soul:addBuff(buff, caster)
    table.insert(caster.TC_soul_list, soul)
  end
end

function TC.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  for _, unit in pairs(skill.caster.TC_soul_list) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
end

function TC.skillatk3_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if skill.target then
      skill.TC_moborigin = {
        skill.target.position[1],
        0
      }
    else
      skill.TC_moborigin = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_TC_atk31.cha"
      ed.scene:playEffectOnScene(effect_name, skill.TC_moborigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  else
    local skillatk31 = skill.caster.skills.TC_atk3_1
    if skillatk31 then
      skillatk31:takeEffectAt(skill.caster.position)
    end
    if skill.TC_moborigin then
      basefunc(skill, skill.TC_moborigin, source)
    end
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
    end
    if skill.TC_moborigin == nil then
      return
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_TC_atk32.cha"
      ed.scene:playEffectOnScene(effect_name, skill.TC_moborigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  end
end

function TC.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  for _, unit in pairs(skill.caster.TC_soul_list) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
end

function TC.skillatk4_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local originfo = buff.info
  local owner = buff.owner
  local ARM = owner.attribs.ARM * skill.info["Script Arg2"] / 100
  local MR = owner.attribs.MR * skill.info["Script Arg2"] / 100
  local PIMU = 0
  local MIMU = 0
  if skill.evo_rank and skill.evo_rank >= 1 then
    ARM = owner.attribs.ARM * (skill.info["Script Arg2"] + skill.evo_rank1["Script Arg1"]) / 100
    MR = owner.attribs.MR * (skill.info["Script Arg2"] + skill.evo_rank1["Script Arg1"]) / 100
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    ARM = owner.attribs.ARM * (skill.info["Script Arg2"] + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"]) / 100
    MR = owner.attribs.MR * (skill.info["Script Arg2"] + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"]) / 100
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    PIMU = skill.evo_rank3["Script Arg1"]
    MIMU = skill.evo_rank3["Script Arg1"]
  end
  buff:setAttribute("ARM", math.max(0, ARM))
  buff:setAttribute("MR", math.max(0, MR))
  buff:setAttribute("PIMU", PIMU)
  buff:setAttribute("MIMU", MIMU)
  return buff
end

function TC.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local timer = buff.timer
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local skillult = caster.skills.TC_ult
  if skillult.evo_rank and skillult.evo_rank >= 2 then
    buff.timer = timer + skillult.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function TC.skillatk4_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if ed.run_with_scene then
      local effect_night = "eff_point_TC_atk41.cha"
      local origin = skill.caster.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
    end
  elseif skill.attack_counter == 2 then
    basefunc(skill, location, source)
  end
end

function TC.skillult_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if skill.target then
      skill.TC_ult1 = {
        skill.target.position[1],
        0
      }
    else
      skill.TC_ult1 = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_TC_ult1.cha"
      ed.scene:playEffectOnScene(effect_name, skill.TC_ult1, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
    local caster = skill.caster
    local bid = 11002106
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  elseif skill.attack_counter == 3 then
    if skill.target then
      skill.TC_ult2 = {
        skill.target.position[1],
        0
      }
    else
      skill.TC_ult2 = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_TC_ult2.cha"
      ed.scene:playEffectOnScene(effect_name, skill.TC_ult2, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
    local caster = skill.caster
    local bid = 11002106
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  elseif skill.attack_counter == 5 then
    if skill.target then
      skill.TC_ult3 = {
        skill.target.position[1],
        -30
      }
    else
      skill.TC_ult3 = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_TC_ult3.cha"
      ed.scene:playEffectOnScene(effect_name, skill.TC_ult3, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
    skill.caster.ult3direction = skill.caster.direction
    local caster = skill.caster
    local bid = 11002106
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  elseif skill.attack_counter == 2 then
    if skill.TC_ult1 == nil then
      return
    end
    basefunc(skill, skill.TC_ult1, source)
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 11002106 then
        local buff = tbuff
        buff.timer = 0
      end
    end
  elseif skill.attack_counter == 4 then
    if skill.TC_ult2 == nil then
      return
    end
    local skillult2 = skill.caster.skills.TC_ult2
    if skillult2 then
      skillult2:takeEffectAt(skill.TC_ult2)
    end
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
    end
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 11002106 then
        local buff = tbuff
        buff.timer = 0
      end
    end
  elseif skill.attack_counter == 6 then
    if skill.TC_ult3 == nil then
      return
    end
    local skillult3 = skill.caster.skills.TC_ult3
    if skillult3 then
      skillult3:takeEffectAt(skill.TC_ult3, skill.caster, skill.caster.ult3direction)
    end
    skill.caster.ult3direction = nil
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 11002106 then
        local buff = tbuff
        buff.timer = 0
      end
    end
  end
end

function TC.skillult_finish(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 521 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function TC.hero_die(basefunc, hero, killer)
  for _, unit in pairs(hero.TC_soul_list) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function TC.reset(basefunc, hero)
  basefunc(hero)
  hero.TC_soul_list = {}
  hero.TC_atk4_type = 0
end

function TC.init_hero(hero)
  hero.reset = override(hero.reset, TC.reset)
  hero.die = override(hero.die, TC.hero_die)
  local skillatk2 = hero.skills.TC_atk2
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TC.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, TC.skillatk2_finish)
  end
  local skillatk3 = hero.skills.TC_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, TC.skillatk3_takeEffectAt)
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
      local skillatk31 = hero.skills.TC_atk3_1
      if skillatk31 then
        skillatk31.info = ed.wraptable(skillatk31.info, {
          ["Basic Num"] = skillatk31.info["Basic Num"] + skillatk3.evo_rank3["Script Arg1"]
        })
      end
    end
  end
  local skillatk4 = hero.skills.TC_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TC.skillatk4_createBuff)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, TC.skillatk4_takeEffectAt)
  end
  local skillult = hero.skills.TC_ult
  local skillult2 = hero.skills.TC_ult2
  local skillult3 = hero.skills.TC_ult3
  if skillult then
    skillult.finish = override(skillult.finish, TC.skillult_finish)
    skillult.takeEffectAt = override(skillult.takeEffectAt, TC.skillult_takeEffectAt)
    skillult.createBuff = override(skillult.createBuff, TC.skillult_createBuff)
    skillult2.createBuff = override(skillult2.createBuff, TC.skillult_createBuff)
    skillult3.createBuff = override(skillult3.createBuff, TC.skillult_createBuff)
  end
  if skillult.evo_rank and skillult.evo_rank >= 1 then
    skillult.info = ed.wraptable(skillult.info, {
      ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
    })
    skillult2.info = ed.wraptable(skillult2.info, {
      ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
    })
  end
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    skillult3.info = ed.wraptable(skillult3.info, {
      ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
    })
  end
  return hero
end

return TC.init_hero
