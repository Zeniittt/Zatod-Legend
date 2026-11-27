module("ed.battlehero", package.seeall)
local ed = ed
DarkSeer = {}
DarkSeer.base = ed.Entity
DarkSeer.ult_r = 30
DarkSeer.interval = 1
DarkSeer.mirror_time = 12
DarkSeer.mirrorAttribs = 11010206
DarkSeer.mirrorbuff = 11010207
DarkSeer.atk4inv = 11010208
DarkSeer.atk4team = 11010209
DarkSeer.ultevo = 11010211
DarkSeer.fashion_1 = 101021

function DarkSeer.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill:lockCasterDirection(true)
  local caster = skill.caster
  if skill.target then
    local direction = skill.target.position[1] - caster.position[1]
    if direction * caster.direction < 0 then
      caster.direction = caster.direction * -1
    end
  end
end

function DarkSeer.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  skill:lockCasterDirection(false)
end

function DarkSeer.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster.direction
  local info = skill.info
  if attack_counter == 0 then
    if skill.target then
      skill.skillulttarget = skill.target
    else
      skill:selectTarget(nil)
      skill.skillulttarget = skill.target
    end
    if skill.skillulttarget then
      skill.targetposition = skill.skillulttarget.position
      if caster.manually_casting then
        ed.engine:unfreeze()
        caster.manually_casting = false
      end
      skill.attack_counter = skill.attack_counter + 1
      if ed.run_with_scene then
        local effect_name1 = "eff_point_DarkSeer_ult.cha"
        local effect_name2 = "eff_point_DarkSeer_ult_2.cha"
        local effect1 = ed.scene:playEffectOnScene(effect_name1, skill.targetposition, {1, 1}, nil, 1)
        local effect2 = ed.scene:playEffectOnScene(effect_name2, skill.targetposition, {1, 1}, nil, -1)
      end
      local skillults = caster.skills.DarkSeer_ults
      skillults.targetposition = skill.targetposition
      skillults.skillulttarget = skill.skillulttarget
      skillults:takeEffectAt(skill.targetposition, caster)
    else
      return
    end
  end
  if attack_counter == 1 then
    local ttype = info["Track Type"]
    local MPGR = caster.attribs.MPGainRatio or 0
    if skill.targetposition then
      skill:takeEffectAt(skill.targetposition, caster)
    end
    if MPGR then
      caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
    end
    if info["Move Forward"] ~= 0 then
      caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
    end
  end
end

function DarkSeer.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.onRemoved = override(buff.onRemoved, DarkSeer.ultbuffonRemoved)
  return buff
end

function DarkSeer.ultbuffonRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  if not ed.engine.beingEnd and not owner:isHasUncontrolBufEffect() then
    local bidevo = DarkSeer.ultevo
    local binfoevo = ed.lookupDataTable("Buff", nil, bidevo)
    local buffevo = ed.BuffCreate(binfoevo, owner, caster)
    local skillult = caster.skills.DarkSeer_ult
    buffevo:setAttribute("MSPD", skillult.evo_rank3["Script Arg1"])
    buffevo:setAttribute("HAST", skillult.evo_rank3["Script Arg1"])
    buffevo.timer = skillult.evo_rank3["Script Arg2"]
    if not owner.buff_effects.invulnerable then
      owner:addBuff(buffevo, caster)
    end
  end
end

function DarkSeer.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.targetposition = skill.targetposition
  buff.update = override(buff.update, DarkSeer.ultsbuff_update)
  return buff
end

function DarkSeer.ultsbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local time = 0.05
  local direction = {1, 0}
  local DistanceSQ = ed.edpDistanceSQ(owner.position, buff.targetposition)
  if owner.position[1] == buff.targetposition[1] then
  elseif DistanceSQ < DarkSeer.ult_r * DarkSeer.ult_r then
  else
    direction = ed.edpNormalize(ed.edpSub(owner.position, buff.targetposition))
    owner:knockup(time, ed.edpMult(direction, -3), true)
  end
end

function DarkSeer.skillatk2_selectTarget(basefunc, skill, default)
  local max = -math.huge
  local caster = skill.caster
  local chosen = caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  local enchantedbyself = caster.buff_effects.enchantedbyself
  for unit in ed.engine:foreachAliveUnit(skill.caster.camp) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    elseif enchantedbyself and unit == caster then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.building then
    elseif unit.position[1] < 0 or unit.position[1] > 800 then
    else
      local havebuff = false
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == 11010203 then
          havebuff = true
        end
      end
      if havebuff then
      else
        local initdir = caster:getInitDir()
        local v = unit.position[1]
        if initdir == 1 then
          if max < v then
            max = v
            chosen = unit
          end
        elseif initdir == -1 and max < -v then
          max = -v
          chosen = unit
        end
      end
    end
  end
  skill.target = chosen
  return chosen
end

function DarkSeer.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.DarkSeerSkillatk2buff = true
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"]
  end
  buff.update = override(buff.update, DarkSeer.skillatk2_buff_update)
  buff.attack_timer = DarkSeer.interval
  return buff
end

function DarkSeer.skillatk2_buff_update(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + DarkSeer.interval
    local skillatk2s = buff.caster.skills.DarkSeer_atk2s
    skillatk2s:takeEffectAt(owner.position, caster)
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function DarkSeer.skillatk3_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  local ID = target.info.ID
  if target.config.is_summoned then
    return isHit, dmg, Crit, lfs_amount
  end
  if isHit then
    local proto = {
      _tid = 397,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = target.fashion_id
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1,
      summoner = caster
    }
    local DarkSeerMirror = ed.UnitCreate(proto, caster.camp, config)
    local puppet = ed.lookupDataTable("Unit", "Puppet", ID)
    DarkSeerMirror:pushPuppet(puppet)
    local mirroatk = DarkSeerMirror.skills.CommonMirror_atk
    local targetSkillatkGroup = ed.getDataTable("SkillGroup")[ID][5]
    if not targetSkillatkGroup then
      return isHit, dmg, Crit, lfs_amount
    end
    local targetSkillatkinfo = ed.Skill.getSkillInfo(targetSkillatkGroup, 1)
    local skillinfo = ed.copyTable(targetSkillatkinfo)
    local buff_info
    mirroatk.info = skillinfo
    setmetatable(mirroatk.info, getmetatable(targetSkillatkinfo))
    if mirroatk.info["Buff ID"] > 0 then
      buff_info = ed.lookupDataTable("Buff", nil, mirroatk.info["Buff ID"])
    end
    local buff_patch = {}
    if buff_info then
      setmetatable(buff_patch, {__index = buff_info})
      mirroatk.info.buff_info = buff_patch
    end
    mirroatk.attack_range = mirroatk.info["Max Range"] - 5
    DarkSeerMirror:reset()
    local bid = DarkSeer.mirrorbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = DarkSeerMirror:addBuff(ed.copyTable(binfo), caster)
    DarkSeerMirror.mDuration_DarkSeer = DarkSeer.mirror_time
    DarkSeer.DarkSeer_mirrorFunction(DarkSeerMirror)
    DarkSeerMirror:setDeathWithEffectOrNot(true)
    DarkSeerMirror.direction = -caster.direction
    local locationtb = {
      target.position[1] + 200 * caster.direction,
      target.position[2]
    }
    if skill.target.buff_effects.stable or locationtb[1] > 799 or locationtb[1] < 1 then
      locationtb[1] = target.position[1] - 70 * DarkSeerMirror.direction
    end
    if skill.caster:isAlive() then
      ed.engine:summonUnit(DarkSeerMirror, locationtb, caster, "Idle")
    end
    local DarkSeermirrorattribs = skill.info["Script Arg2"] / 100
    if skill.evo_rank and skill.evo_rank >= 3 then
      DarkSeermirrorattribs = DarkSeermirrorattribs + skill.evo_rank3["Script Arg1"] / 100
    end
    local AttriBinfo = ed.lookupDataTable("Buff", nil, DarkSeer.mirrorAttribs)
    DarkSeer.changeBuffInfo(AttriBinfo, DarkSeermirrorattribs, DarkSeerMirror)
    local buffattribs = DarkSeerMirror:addBuff(ed.copyTable(AttriBinfo), caster)
    DarkSeerMirror:takeHeal(DarkSeerMirror.attribs.HP, "hp")
    table.insert(caster.summonlist_DarkSeer, DarkSeerMirror)
  end
  return isHit, dmg, Crit, lfs_amount
end

function DarkSeer.changeBuffInfo(buffInfo, enhance, target)
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

function DarkSeer.DarkSeer_mirrorFunction(unit)
  unit.update = override(unit.update, DarkSeer.DarkSeerMirror_update)
  unit.die = override(unit.die, DarkSeer.DarkSeerMirror_die)
end

function DarkSeer.DarkSeerMirror_update(basefunc, unit, dt)
  unit.mDuration_DarkSeer = unit.mDuration_DarkSeer - dt
  if unit.mDuration_DarkSeer <= 0 and unit:isAlive() then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function DarkSeer.DarkSeerMirror_die(basefunc, unit, killer)
  basefunc(unit, killer)
  local summonlist_DarkSeer = unit.config.summoner.summonlist_DarkSeer
  for i, unit in pairs(summonlist_DarkSeer) do
    if unit == unit then
      table.remove(summonlist_DarkSeer, i)
    end
  end
end

function DarkSeer.hero_die(basefunc, hero, killer)
  if hero.summonlist_DarkSeer then
    for _, copyUnit in ipairs(hero.summonlist_DarkSeer) do
      if copyUnit and copyUnit:isAlive() then
        copyUnit:die()
      end
    end
  end
  basefunc(hero, killer)
end

function DarkSeer.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.summonlist_DarkSeer = {}
end

function DarkSeer.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if target and attack_counter == 0 then
    if ed.run_with_scene then
      local effect_name = "eff_point_DarkSeer_atk4.cha"
      local fashionId = caster.fashion_id
      if fashionId and fashionId == DarkSeer.fashion_1 then
        effect_name = "eff_point_DarkSeer_fashion_1_atk4.cha"
      end
      if effect_name then
        local effect = ed.scene:playEffectOnScene(effect_name, target.position, {
          target.direction * 1,
          1
        }, nil, 1)
      end
    end
    local bid1 = DarkSeer.atk4inv
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, target, caster)
    target:addBuff(buff1, caster)
    local MPGR = caster.attribs.MPGainRatio or 0
    if MPGR then
      caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
    end
    skill.attack_counter = skill.attack_counter + 1
  end
  if target and attack_counter == 1 then
    local casterp = DarkSeer.DOP_in_battlefield(caster, 125, caster.foecamp)
    target:setPosition({
      casterp[1] + 50 * caster.direction,
      casterp[2]
    })
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == DarkSeer.atk4inv then
        local buff = tbuff
        buff.timer = -1
      end
    end
    local bid2 = DarkSeer.atk4team
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, target, caster)
    buff2:setAttribute("MSPD", skill.info["Script Arg2"])
    buff2:setAttribute("HAST", skill.info["Script Arg3"])
    if skill.evo_rank and skill.evo_rank >= 3 then
      buff2:setAttribute("MDODG", skill.evo_rank3["Script Arg1"])
    end
    target:addBuff(buff2, caster)
    if ed.run_with_scene then
      local effect_name = "eff_point_DarkSeer_atk4_2.cha"
      local fashionId = caster.fashion_id
      if fashionId and fashionId == DarkSeer.fashion_1 then
        effect_name = "eff_point_DarkSeer_fashion_1_atk4_2.cha"
      end
      if effect_name then
        local effect = ed.scene:playEffectOnScene(effect_name, target.position, {
          target.direction * 1,
          1
        }, nil, 1)
      end
    end
    skill:takeEffectAt(target.position, caster)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function DarkSeer.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    return position
  end
end

function DarkSeer.init_hero(hero)
  hero.die = override(hero.die, DarkSeer.hero_die)
  hero.reset = override(hero.reset, DarkSeer.hero_reset)
  hero.summonlist_DarkSeer = {}
  local skillult = hero.skills.DarkSeer_ult
  local skillults = hero.skills.DarkSeer_ults
  local skillatk2 = hero.skills.DarkSeer_atk2
  local skillatk2s = hero.skills.DarkSeer_atk2s
  local skillatk3 = hero.skills.DarkSeer_atk3
  local skillatk4 = hero.skills.DarkSeer_atk4
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, DarkSeer.skillult_onAttackFrame)
    skillult.start = override(skillult.start, DarkSeer.skillult_start)
    skillult.finish = override(skillult.finish, DarkSeer.skillult_finish)
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
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.createBuff = override(skillult.createBuff, DarkSeer.skillult_createBuff)
    end
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, DarkSeer.skillults_createBuff)
  end
  if skillatk2 then
    skillatk2.selectTarget = override(skillatk2.selectTarget, DarkSeer.skillatk2_selectTarget)
    skillatk2.createBuff = override(skillatk2.createBuff, DarkSeer.skillatk2_createBuff)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 and skillatk2s then
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        ["Shape Arg1"] = skillatk2.evo_rank3["Script Arg1"]
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
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, DarkSeer.skillatk3_takeEffectOn)
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
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, DarkSeer.skillatk4_onAttackFrame)
  end
  return hero
end

return DarkSeer.init_hero
