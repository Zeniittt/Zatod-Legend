module("ed.battlehero", package.seeall)
local ed = ed
SB = {}
SB.rush_speed = 550
SB.SB_Rush_Buff_ID = 10005605
SB.SB_Waiting_Buff_ID = 10005606
SB.fashion_id_1 = 561

function SB.reset(basefunc, hero)
  basefunc(hero)
  local skill = hero.skills.SB_atk2
  if skill then
    local dir = hero:getInitDir()
    hero.position[1] = 400 - 480 * dir
    local friend_list = ed.engine.alive_units[hero.camp]
    local has_friend_unit = 1 < #friend_list
    if has_friend_unit then
      local owner = hero
      local bid = SB.SB_Waiting_Buff_ID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, owner, owner)
      owner:addBuff(buff, owner)
    else
      skill.cd_remaining = 999
    end
  end
end

function SB.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local sb = skill.caster
  sb.skillatk2_SB = skill
  sb.skillatk2_affected_units_SB = {}
  local caster = skill.caster
  local eventList = skill.current_phase.event_list
  local atkFrame
  for i = 1, #eventList do
    if eventList[i].Type == "Attack" then
      atkFrame = eventList[i]
      break
    end
  end
  local time = atkFrame.Time
  local dir = caster:getInitDir()
  caster.position = {
    400 - -15 * dir - time * SB.rush_speed * dir,
    0
  }
  caster.walk_v = {
    SB.rush_speed * dir,
    0
  }
  local bid = SB.SB_Rush_Buff_ID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local owner = skill.caster
  local buff = ed.BuffCreate(binfo, owner, owner)
  buff.update = override(buff.update, SB.skillatk2_buff_update)
  owner:addBuff(buff, owner)
end

function SB.skillatk2_buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local skillatk2 = owner.skillatk2_SB
  if skillatk2 then
    local owner = skillatk2.caster
    local info = skillatk2.info
    local direction = owner.direction
    local location = owner.position
    local SpeedShifting = SB.rush_speed * dt
    local origin = {
      location[1] - SpeedShifting * direction + info["X Shift"] * direction,
      location[2]
    }
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skillatk2:affectedCamp()) do
      if unit.buff_effects.building then
      else
        local skillatk2_affected_units = owner.skillatk2_affected_units_SB
        if not skillatk2_affected_units[unit] then
          local p2 = ed.edpSub(unit.position, origin)
          p2[1] = p2[1] * direction
          if skillatk2.testPointInShape(p2, shape, arg1, arg2) then
            skillatk2_affected_units[unit] = true
            SB.skillatk2_Hit(skillatk2, owner, unit)
          end
        end
      end
    end
  end
  basefunc(buff, dt)
end

function SB.skillatk2_Hit(skillatk2, owner, unit)
  local x = unit.position[1]
  local dir = owner:getInitDir()
  local extraDis = (0 < dir and x or 800 - x) * 0.05
  local distance = math.abs(x - (390 + dir * extraDis))
  if not unit.buff_effects.stable then
    unit:knockup(math.max(0.3, distance / 400), {
      distance * dir,
      0
    })
  end
  owner.skillatk2_affected_units_SB[unit] = true
  local bid = 6
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, unit, owner)
  if ed.run_with_scene then
    local info = skillatk2.info
    local effect_name = info["Point Effect"]
    if effect_name then
      local effect_z = info["Point Zorder"] or 0
      ed.scene:playEffectOnScene(effect_name, unit.position, {
        owner.direction,
        1
      }, nil, effect_z)
    end
  end
  skillatk2:takeEffectOn(unit, owner)
end

function SB.skillatk2_onAttackFrame(basefunc, skill)
  local owner = skill.caster
  for _, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == SB.SB_Rush_Buff_ID then
      local buff = tbuff
      buff.timer = -1
      break
    end
  end
  local MPGR = owner.attribs.MPGainRatio or 0
  if MPGR then
    owner:setMP(owner.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
  end
  owner.walk_v = {0, 0}
end

function SB.skillatk2_finish(basefunc, skill, target)
  local owner = skill.caster
  for _, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == SB.SB_Rush_Buff_ID then
      local buff = tbuff
      buff.timer = -1
      break
    end
  end
  basefunc(skill, target)
end

function SB.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local MSPD = buffInfo.MSPD
  local HAST = buffInfo.HAST
  local HPR = 0
  local skillatk2 = caster.skills.SB_atk2
  if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
    MSPD = MSPD + skillatk2.evo_rank2["Script Arg1"]
    HAST = HAST + skillatk2.evo_rank2["Script Arg1"]
  end
  if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    HPR = HPR + skillatk2.evo_rank3["Script Arg1"] * (1 + caster.attribs.HEAL / 100)
  end
  buff:setAttribute("MSPD", MSPD)
  buff:setAttribute("HAST", HAST)
  buff:setAttribute("HPR", HPR)
  return buff
end

function SB.skillatk2s_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local list = caster.buff_list
  local debuff_list = {}
  local my_camp = caster.camp
  for i = 1, #list do
    local buff = list[i]
    if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
      debuff_list[#debuff_list + 1] = buff
    end
  end
  for i = 1, #debuff_list do
    caster:removeBuff(debuff_list[i])
  end
end

function SB.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = buff.timer + skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function SB.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  local time = 0.18
  local distance = 40
  local direction = {1, 0}
  if isHit and dmg and 0 < dmg and target then
    if target.position[1] >= caster.position[1] then
      direction = ed.edpNormalize({1, 0})
    else
      direction = ed.edpNormalize({-1, 0})
    end
    target:knockup(time, ed.edpMult(direction, distance))
  end
  return isHit, dmg
end

function SB.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  if target then
    local position1 = target.position[1] - target.direction * 45
    caster:setPosition({
      position1,
      target.position[2]
    })
    caster.ult_target = target
  end
end

function SB.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = buff.timer + skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function SB.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  skill.target = caster.ult_target
  local target = skill.target
  if skill.attack_counter then
    if not target or target and not target:isAlive() then
      skill:finish()
    else
      local originInfo = skill.info
      skill.info = ed.wraptable(originInfo, {
        ["Max Range"] = 180,
        ["Target Type"] = "nearest"
      })
      basefunc(skill)
      skill.info = originInfo
    end
  end
end

function SB.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  skill.target = caster.ult_target
  local target = skill.target
  if not target or target and not target:isAlive() then
    skill:finish()
  end
  if skill.attack_counter then
    if target then
      local position1 = target.position[1] - target.direction * 45
      caster:setPosition({
        position1,
        target.position[2]
      })
    end
    basefunc(skill, location, source)
  end
end

function SB.init_hero(hero)
  local skillult = hero.skills.SB_ult
  local skillatk2 = hero.skills.SB_atk2
  local skillatk2s = hero.skills.SB_atk2s
  local skillatk3 = hero.skills.SB_atk3
  local skillpasv = hero.passive_skill_list[1]
  hero.reset = override(hero.reset, SB.reset)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, SB.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, SB.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, SB.skillatk2_finish)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      local originfo = skillatk2.info
      skillatk2.info = ed.wraptable(originfo, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if SB.fashion_id_1 and SB.fashion_id_1 == hero.fashion_id then
      local originfo = skillatk2.info
      skillatk2.info = ed.wraptable(originfo, {
        ["Point Effect"] = "eff_point_SB_fashion_1_atk2.cha",
        ["Impact Effect"] = "eff_impact_SB_fashion_1_atk2.cha"
      })
    end
  end
  if skillatk2s then
    skillatk2s.createBuff = override(skillatk2s.createBuff, SB.skillatk2s_createBuff)
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, SB.skillatk2s_takeEffectOn)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, SB.skillatk3_createBuff)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, SB.skillatk3_takeEffectOn)
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
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
  if skillult then
    skillult.start = override(skillult.start, SB.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, SB.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, SB.skillult_createBuff)
    skillult.takeEffectAt = override(skillult.takeEffectAt, SB.skillult_takeEffectAt)
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"],
        ["AOE Origin"] = "self",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = "120"
      })
    end
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    local num = skillpasv["Basic Num"]
    local oriattribs = hero.attribs[aname]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return SB.init_hero
