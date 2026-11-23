module("ed.battlehero", package.seeall)
local ed = ed
UD = {}
UD.smallzombieattribs = 11002206
UD.tombstone_deviation = 150
UD.zombie_Rmin = 15
UD.zombie_Rmax = 35
UD.UD_atk2_HPheal = 4
UD.zombieDuration_UD = 15
UD.ult_interval = 2
UD.ult2_interval = 0.25
UD.fashion_id_1 = 100221

function UD.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.UD_smallzombielist = {}
  hero.UD_tombstone = nil
  hero.UD_DamageLine = hero.attribs.HP * 0.2
  local shard = hero.proto._shard
  if shard and shard._id == 1100221 and hero.shardSkillRank and hero.shardSkillRank >= 1 then
    hero.UD_DamageLine = hero.attribs.HP * 0.1
  end
  hero.UD_atk4summon_times = 0
  hero.UD_atk3totalDamage = 0
  hero.instageDamage = hero.battledata.beardmg
  hero.ultBuff_UD = nil
end

function UD.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type)
  if damage_type then
    return 1
  else
    return basefunc(hero, damage, immunity, damage_type)
  end
end

function UD.hero_takeHeal(basefunc, hero, amount, _type, source)
  basefunc(hero, 1, _type, source)
end

function UD.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.UD_smallzombielist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  if hero.UD_tombstone and hero.UD_tombstone:isAlive() then
    hero.UD_tombstone:die()
  end
  basefunc(hero, killer)
end

function UD.smallzombie_skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function UD.smallzombie_skillatk_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local atkbuff
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11002204 then
      atkbuff = true
    end
  end
  if atkbuff then
    skill:startPhase(2)
  else
    skill:startPhase(1)
  end
  skill.is_update = true
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function UD.smallzombie_die(basefunc, hero, killer)
  local UD = hero.config.summoner
  local skillatk2s = UD.skills.UD_atk2s
  local skillatk4 = UD.skills.UD_atk4
  local hp_amount = skillatk2s.info["Script Arg2"]
  local mp_amount = skillatk2s.info["Script Arg3"]
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      hp_amount = hp_amount + skillatk4.evo_rank1["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      mp_amount = mp_amount + skillatk4.evo_rank2["Script Arg1"]
    end
  end
  UD:takeHeal(hp_amount, "hp", UD)
  UD:takeHeal(mp_amount, "mp", UD)
  basefunc(hero, killer)
end

function UD.smallzombie_update(basefunc, hero, dt)
  hero.zombieDuration_UD = hero.zombieDuration_UD - dt
  if hero.zombieDuration_UD <= 0 and hero:isAlive() then
    hero:die()
  else
    basefunc(hero, dt)
  end
end

function UD.smallzombie_rebuild(basefunc, hero, mode, mealParam)
  basefunc(hero, mode, mealParam)
  if hero.attribs.HP > 3 then
    hero.attribs.HP = 3
  end
end

function UD.stombstone_rebuild(basefunc, hero, mode, mealParam)
  basefunc(hero, mode, mealParam)
end

function UD.smallzombie_takeEffectOn(basefunc, skill, target, source)
  local result, dmg = basefunc(skill, target, source)
  local smallzombie = skill.caster
  local UD = smallzombie.config.summoner
  local bid = 11002204
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = smallzombie:addBuff(binfo, smallzombie)
end

function UD.smallzombie_skillatk_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local hero = caster.config.summoner
  local skillatk2 = hero.skills.UD_atk2
  local info = skill.info
  power = hero.attribs.AP * 0.55 + skillatk2.info["Script Arg3"]
  return power, coeff
end

function UD.twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function UD.smallzombie_ai_searchTarget(basefunc, ai)
  local smallzombie = ai.owner
  local target, minDistanSQ = basefunc(ai)
  local skillatk = smallzombie.skills.smallzombie_atk2
  local distanceSQ = 9999
  local maxINT = 0
  for unit in ed.engine:foreachAliveUnit(smallzombie.foecamp) do
    if unit ~= smallzombie and not unit.buff_effects.untargetable and not unit.buffManager.invisible and not unit.config.is_summoned and unit.position[1] <= ed.engine.stage_rect.maxX and unit.position[1] >= ed.engine.stage_rect.minX then
      local int = unit.attribs.INT
      if maxINT < int then
        maxINT = int
        target = unit
        distanceSQ = UD.twoPointDistanceSQ(smallzombie.position, unit.position)
      end
    end
  end
  return target, distanceSQ
end

function UD.tombstone_atk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster.config.summoner
  local tombstone = skill.caster
  local skillatk2 = hero.skills.UD_atk2
  local dir = hero:getInitDir()
  local r = ed.rand() * (UD.zombie_Rmax - UD.zombie_Rmin) + UD.zombie_Rmin
  local angle = ed.rand() * 360
  local smallzombie_position = {
    tombstone.position[1] + r * math.cos(math.rad(angle)),
    tombstone.position[2] + r * math.sin(math.rad(angle))
  }
  local skillevel = {
    skillatk2.level,
    skillatk2.level
  }
  local proto = {
    _tid = 215,
    _level = skillatk2.level or 1,
    _skill_levels = skillevel,
    _stars = 1,
    _rank = hero.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = hero.config.dps_mod or 1
  }
  local smallzombie = ed.UnitCreate(proto, hero.camp, config)
  local smallzombie_atk2 = smallzombie.skills.smallzombie_atk2
  smallzombie.zombieDuration_UD = UD.zombieDuration_UD
  smallzombie.die = override(smallzombie.die, UD.smallzombie_die)
  smallzombie.update = override(smallzombie.update, UD.smallzombie_update)
  smallzombie.ai.searchTarget = override(smallzombie.ai.searchTarget, UD.smallzombie_ai_searchTarget)
  smallzombie.getLostHPAfterImmunity = override(smallzombie.getLostHPAfterImmunity, UD.hero_getLostHPAfterImmunity)
  smallzombie.takeHeal = override(smallzombie.takeHeal, UD.hero_takeHeal)
  smallzombie_atk2.takeEffectOn = override(smallzombie_atk2.takeEffectOn, UD.smallzombie_takeEffectOn)
  smallzombie_atk2.start = override(smallzombie_atk2.start, UD.smallzombie_skillatk_start)
  smallzombie_atk2.onPhaseFinished = override(smallzombie_atk2.onPhaseFinished, UD.smallzombie_skillatk_onPhaseFinished)
  smallzombie_atk2.power = override(smallzombie_atk2.power, UD.smallzombie_skillatk_power)
  smallzombie.rebuild = override(smallzombie.rebuild, UD.smallzombie_rebuild)
  smallzombie.direction = tombstone.direction
  local shard = hero.proto._shard
  if shard and shard._id == 1100221 then
    if hero.shardSkillRank and 2 > hero.shardSkillRank then
      tombstone:setHP(tombstone.hp - 1)
    end
  else
    tombstone:setHP(tombstone.hp - 1)
  end
  smallzombie.attribs.HP = 3
  smallzombie:setHP(3)
  ed.engine:summonUnit(smallzombie, smallzombie_position, hero)
  local bid = 11002203
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = smallzombie:addBuff(binfo, tombstone)
  local skillatk4 = hero.skills.UD_atk4
  if skillatk4 and skillatk4.evo_rank and 3 <= skillatk4.evo_rank then
    local bid1 = 11002205
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    hero:addBuff(binfo1, smallzombie)
  end
  table.insert(hero.UD_smallzombielist, smallzombie)
end

function UD.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.UD_tombstone and caster.UD_tombstone:isAlive() then
    caster.UD_tombstone:setHP(caster.UD_tombstone.hp + UD.UD_atk2_HPheal)
    if ed.run_with_scene then
      local effect_name = "eff_impact_heal.cha"
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, caster.UD_tombstone.position, {
        caster.UD_tombstone.direction,
        1
      }, nil, effect_z)
    end
  else
    local skillatk2 = caster.skills.UD_atk2
    local dir = caster:getInitDir()
    local tombstone_position = {
      ed.engine.stage_rect.minX + UD.tombstone_deviation,
      0
    }
    if dir == -1 then
      tombstone_position = {
        ed.engine.stage_rect.maxX - UD.tombstone_deviation,
        0
      }
    end
    local skillevel = {
      skillatk2.level,
      skillatk2.level
    }
    local proto = {
      _tid = 214,
      _level = skillatk2.level or 1,
      _skill_levels = skillevel,
      _stars = 1,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local tombstone = ed.UnitCreate(proto, caster.camp, config)
    tombstone.getLostHPAfterImmunity = override(tombstone.getLostHPAfterImmunity, UD.hero_getLostHPAfterImmunity)
    tombstone.takeHeal = override(tombstone.takeHeal, UD.hero_takeHeal)
    local tombstone_atk = tombstone.skills.tombstone_atk
    if skill.evo_rank and 1 <= skill.evo_rank then
      tombstone_atk.info = ed.wraptable(tombstone_atk.info, {
        ["Global CD"] = skill.evo_rank1["Script Arg1"],
        CD = skill.evo_rank1["Script Arg1"]
      })
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      tombstone_atk.info = ed.wraptable(tombstone_atk.info, {
        ["Global CD"] = skill.evo_rank2["Script Arg1"],
        CD = skill.evo_rank2["Script Arg1"]
      })
    end
    if skill.evo_rank and skill.evo_rank >= 3 then
      tombstone_atk.info = ed.wraptable(tombstone_atk.info, {
        ["Global CD"] = skill.evo_rank3["Script Arg1"],
        CD = skill.evo_rank3["Script Arg1"]
      })
    end
    tombstone_atk.onAttackFrame = override(tombstone_atk.onAttackFrame, UD.tombstone_atk_onAttackFrame)
    tombstone.direction = caster.direction
    tombstone.rebuild = override(tombstone.rebuild, UD.stombstone_rebuild)
    ed.engine:summonUnit(tombstone, tombstone_position, caster)
    local shard = caster.proto._shard
    if shard and shard._id == 1100221 and caster.shardSkillRank and 2 <= caster.shardSkillRank then
      local bid = 11002207
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = tombstone:addBuff(binfo, tombstone)
      tombstone:setHP(caster.shardSkill[2]["Script Arg1"])
    end
    local bid = 11002202
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = tombstone:addBuff(binfo, tombstone)
    caster.UD_tombstone = tombstone
  end
end

function UD.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local result, reason = basefunc(skill, target)
  if not result or hero.ultBuff_UD or hero.mp < 700 or hero.current_skill == hero.manual_skill then
    return false
  end
  return true
end

function UD.skillultswitch_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11002201 then
      tbuff.owner:removeBuff(tbuff)
    end
  end
end

function UD.skillult_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  local owner = buff.owner
  local hpheal = owner.attribs.HP * 0.02
  while timer <= 0 do
    timer = timer + UD.ult_interval
    local skillult2 = buff.caster.skills.UD_ult2
    if skillult2 then
      owner:takeHeal(hpheal, "hp", owner)
    end
    local target = skillult2:selectTarget()
    if target and owner:isAlive() then
      local owner = skillult2.caster
      skillult2:takeEffectAt(owner.position)
      buff.total_times = buff.total_times + 1
    end
  end
  buff.attack_timer = timer
  if owner.mp <= 50 and not buff.owner.current_skill then
    local skillultswitch = owner.skills.UD_ultswitch
    owner:castSkill(skillultswitch, owner)
  end
  basefunc(buff, dt)
end

function UD.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = owner.skills.UD_atk
  if skillatk then
    skillatk.info = skillatk.originfo
  end
  basefunc(buff)
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "UD" then
        panel:setPortrait("UI/DOTA-HERO/UD.png")
        if UD.fashion_id_1 and UD.fashion_id_1 == owner.fashion_id then
          panel:setPortrait("UI/DOTA-HERO/UD_fashion_1.png")
        end
      end
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
  if owner.changePeriod_UD then
    if not ed.engine.beingEnd or owner:isAlive() then
      owner:enterActionStageFromOneStage(owner:UDGetNormalPeriod(), 10022)
    end
    owner.changePeriod_UD = nil
    owner.ultBuff_UD = nil
  end
end

function UD.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
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
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("MPR", -skill.evo_rank3["Script Arg1"])
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1100221 and caster.shardSkillRank and 3 <= caster.shardSkillRank then
    buff:setAttribute("HP", caster.attribs.HP * (caster.shardSkill[3]["Script Arg1"] / 100) / (caster.config.hp_mod and caster.config.hp_mod or 1))
  end
  buff.update = override(buff.update, UD.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, UD.skillult_buffOnRemoved)
  buff.attack_timer = UD.ult2_interval
  buff.total_times = 0
  buff.owner.ultBuff_UD = true
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "UD" then
        panel:setPortrait("UI/DOTA-HERO/UDult.png")
        if UD.fashion_id_1 and UD.fashion_id_1 == caster.fashion_id then
          panel:setPortrait("UI/DOTA-HERO/UD_switch_fashion_1.png")
        end
      end
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  local skillatk = buff.owner.skills.UD_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Plus Ratio"] = 1.2
    })
  end
  return buff
end

function UD.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.changePeriod_UD = true
end

function UD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_UD then
    caster:enterActionStageFromOneStage(caster:UDGetUltPeriod(), 10022)
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1100221 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    caster:takeHeal(caster.attribs.HP * (caster.shardSkill[3]["Script Arg1"] / 100), "hp")
  end
end

function UD.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local result, dmg = basefunc(skill, target, source)
  if result then
    local caster = skill.caster
    caster.UD_atk3totalDamage = caster.UD_atk3totalDamage + dmg
  end
end

function UD.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.UD_atk3s
  if skillatk3s then
    for i, unit in ipairs(caster.UD_smallzombielist) do
      if unit and unit:isAlive() then
        skillatk3s:takeEffectOn(unit)
      end
    end
    if caster.UD_tombstone and caster.UD_tombstone:isAlive() then
      skillatk3s:takeEffectOn(caster.UD_tombstone)
    end
    skillatk3s:takeEffectOn(caster)
    caster.UD_atk3totalDamage = 0
  end
end

function UD.skillatk3s_power(basefunc, skill, source, target, damage_type)
  local percent = skill.info["Script Arg2"]
  local power = skill.caster.UD_atk3totalDamage * percent / 100
  return power
end

function UD.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() and not ed.engine.beingEnd and hero.battledata.beardmg - hero.instageDamage >= hero.UD_DamageLine * (hero.UD_atk4summon_times + 1) then
    local skillatk2 = hero.skills.UD_atk2
    local dir = hero:getInitDir()
    local r = ed.rand() * (UD.zombie_Rmax - UD.zombie_Rmin) + UD.zombie_Rmin
    local angle = ed.rand() * 360
    local smallzombie_position = {
      hero.position[1] + r * math.cos(math.rad(angle)),
      hero.position[2] + r * math.sin(math.rad(angle))
    }
    local skillevel = {
      skillatk2.level,
      skillatk2.level
    }
    local proto = {
      _tid = 215,
      _level = skillatk2.level or 1,
      _skill_levels = skillevel,
      _stars = 1,
      _rank = hero.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = hero.config.dps_mod or 1
    }
    local smallzombie = ed.UnitCreate(proto, hero.camp, config)
    local smallzombie_atk2 = smallzombie.skills.smallzombie_atk2
    smallzombie.zombieDuration_UD = UD.zombieDuration_UD
    smallzombie.update = override(smallzombie.update, UD.smallzombie_update)
    smallzombie.die = override(smallzombie.die, UD.smallzombie_die)
    smallzombie.ai.searchTarget = override(smallzombie.ai.searchTarget, UD.smallzombie_ai_searchTarget)
    smallzombie.getLostHPAfterImmunity = override(smallzombie.getLostHPAfterImmunity, UD.hero_getLostHPAfterImmunity)
    smallzombie.takeHeal = override(smallzombie.takeHeal, UD.hero_takeHeal)
    smallzombie_atk2.takeEffectOn = override(smallzombie_atk2.takeEffectOn, UD.smallzombie_takeEffectOn)
    smallzombie_atk2.start = override(smallzombie_atk2.start, UD.smallzombie_skillatk_start)
    smallzombie_atk2.onPhaseFinished = override(smallzombie_atk2.onPhaseFinished, UD.smallzombie_skillatk_onPhaseFinished)
    smallzombie_atk2.power = override(smallzombie_atk2.power, UD.smallzombie_skillatk_power)
    smallzombie.direction = dir
    smallzombie.rebuild = override(smallzombie.rebuild, UD.smallzombie_rebuild)
    smallzombie.attribs.HP = 3
    smallzombie:setHP(3)
    ed.engine:summonUnit(smallzombie, smallzombie_position, hero)
    local bid = 11002203
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = smallzombie:addBuff(binfo, hero)
    if ed.run_with_scene then
      local effect_name = "eff_point_UD_atk4.cha"
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, hero.position, {
        hero.direction,
        1
      }, nil, effect_z)
    end
    table.insert(hero.UD_smallzombielist, smallzombie)
    local skillatk4 = hero.skills.UD_atk4
    if skillatk4 and skillatk4.evo_rank and 3 <= skillatk4.evo_rank then
      local bid1 = 11002205
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      hero:addBuff(binfo1, smallzombie)
    end
    hero.UD_atk4summon_times = hero.UD_atk4summon_times + 1
  end
end

function UD.init_hero(hero)
  local skillult = hero.skills.UD_ult
  local skillult2 = hero.skills.UD_ult2
  local skillatk2 = hero.skills.UD_atk2
  local skillatk3 = hero.skills.UD_atk3
  local skillatk3s = hero.skills.UD_atk3s
  local skillatk4 = hero.skills.UD_atk4
  hero:setActionStageChangeByManual(true)
  hero.UD_smallzombielist = {}
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, UD.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, UD.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, UD.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, UD.skillult_finish)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, UD.skillatk2_onAttackFrame)
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
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, UD.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, UD.skillatk3_finish)
    skillatk3s.power = override(skillatk3s.power, UD.skillatk3s_power)
  end
  if skillatk4 then
    hero.update = override(hero.update, UD.hero_update)
  end
  local skillultswitch = hero.skills.UD_ultswitch
  if skillultswitch then
    skillultswitch.finish = override(skillultswitch.finish, UD.skillultswitch_finish)
  end
  hero.reset = override(hero.reset, UD.hero_reset)
  hero.die = override(hero.die, UD.hero_die)
  
  function hero.UDGetNormalPeriod(unit)
    if UD.fashion_id_1 and UD.fashion_id_1 == hero.fashion_id then
      return 3
    end
    return 1
  end
  
  function hero.UDGetUltPeriod(unit)
    if UD.fashion_id_1 and UD.fashion_id_1 == hero.fashion_id then
      return 4
    end
    return 2
  end
  
  if UD.fashion_id_1 and UD.fashion_id_1 == hero.fashion_id then
    hero:enterActionStageFromOneStage(hero:UDGetNormalPeriod(), 10022)
  end
  return hero
end

return UD.init_hero
