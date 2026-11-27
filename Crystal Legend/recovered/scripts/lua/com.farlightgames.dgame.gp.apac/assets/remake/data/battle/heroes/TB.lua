module("ed.battlehero", package.seeall)
local ed = ed
TB = {}
TB.mirrorbuff = 10004702
TB.mirrorAttribs = 10004703
TB.ultstartbuff = 10004704
TB.ultevofearbuff = 10004705
TB.TB_range_interval = 150
TB.mirror_time = 15
TB.TBult_atk_cd = 1.5
TB.atk3maxHPPercent = 0.3
TB.heroName = "TB"

function TB.skillatk3_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local ret, reason = basefunc(skill, target)
  if not ret then
    return false, reason
  elseif hero.hp / hero.attribs.HP < TB.atk3maxHPPercent then
    return true
  end
  return false, "hptoomuch"
end

function TB.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if skill.attack_counter ~= 1 or source then
  elseif target and target:isAlive() then
    caster.skillatk3havecasted = true
    skill.cd_remaining = 9999
    local myhp = caster.hp
    local myhppercent = caster.hp / caster.attribs.HP
    local myLowestPercent = skill.info["Script Arg2"] / 100
    if skill.evo_rank and skill.evo_rank >= 3 then
      myLowestPercent = myLowestPercent + skill.evo_rank3["Script Arg1"] / 100
    end
    local targethp = target.hp
    local targethppercent = target.hp / target.attribs.HP
    local targetLowestPercent = skill.info["Script Arg3"] / 100
    if myLowestPercent > targethppercent then
      targethppercent = myLowestPercent
    end
    local mymaxestpercent = skill.info["Script Arg5"] / 100
    if skill.evo_rank and 1 <= skill.evo_rank then
      mymaxestpercent = skill.info["Script Arg5"] / 100 + skill.evo_rank1["Script Arg1"] / 100
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      mymaxestpercent = skill.info["Script Arg5"] / 100 + skill.evo_rank1["Script Arg1"] / 100 + skill.evo_rank2["Script Arg1"] / 100
    end
    if targethppercent > mymaxestpercent then
      targethppercent = mymaxestpercent
    end
    if myhppercent < targetLowestPercent then
      myhppercent = targetLowestPercent
    end
    caster:takeHeal(targethppercent * caster.attribs.HP - caster.hp)
    local maxLostHP = skill.info["Script Arg4"]
    local targetLastHP = math.max(myhppercent * target.attribs.HP, target.hp - maxLostHP)
    if target.config.is_boss then
      if targetLastHP < target.hp then
        target:setHP(targetLastHP)
      end
    elseif targetLastHP > target.hp then
      target:takeHeal(targetLastHP - target.hp)
    else
      target:setHP(targetLastHP)
    end
    if 0 < targethp - targetLastHP then
      local amount = (targethp - targetLastHP) * (target.info["MP Gain Rate"] / target.attribs.HP) * (target.attribs.MPRatio * 0.01 + 1)
      target:setMP(target.mp + amount)
    end
    local originfo = skill.info
    local pic = "eff_tile_TB_atk3_2.cha"
    if caster.ultBuff_TB then
      pic = "eff_tile_TB_atk3.cha"
    end
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = pic
    })
    local projectile = ed.ProjectileCreate(skill)
    projectile.position[2] = projectile.position[2]
    projectile:enableTrack(target)
    ed.engine:addProjectile(projectile)
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = pic,
      ["Target Type"] = "self",
      ["Target Camp"] = 1,
      ["Affected Camp"] = 1
    })
    skill.target = caster
    local projectile2 = ed.ProjectileCreate(skill)
    projectile2.position = {
      target.position[1],
      target.position[2] + 5
    }
    projectile2.velocity[1] = -projectile2.velocity[1]
    projectile2:enableTrack(caster)
    ed.engine:addProjectile(projectile2)
    skill.info = originfo
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_TB_atk3.cha", {
        target.position[1],
        target.position[2] - 1
      }, {
        target.direction,
        1
      }, nil, 1)
      if caster.ultBuff_TB then
        ed.scene:playEffectOnScene("eff_impact_TB_atk3_4.cha", {
          target.position[1],
          target.position[2] - 1
        }, {
          target.direction,
          1
        }, nil, 1)
      else
        ed.scene:playEffectOnScene("eff_impact_TB_atk3_3.cha", {
          target.position[1],
          target.position[2] - 1
        }, {
          target.direction,
          1
        }, nil, 1)
      end
      ed.scene:playEffectOnScene("eff_impact_TB_atk3_2.cha", {
        caster.position[1],
        caster.position[2] - 1
      }, {
        caster.direction,
        1
      }, nil, 1)
      if caster.ultBuff_TB then
        ed.scene:playEffectOnScene("eff_impact_TB_atk3_4.cha", {
          caster.position[1],
          caster.position[2] - 1
        }, {
          caster.direction,
          1
        }, nil, 1)
      else
        ed.scene:playEffectOnScene("eff_impact_TB_atk3_3.cha", {
          caster.position[1],
          caster.position[2] - 1
        }, {
          caster.direction,
          1
        }, nil, 1)
      end
    end
  end
end

function TB.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local skillatk3 = unit.skills.TB_atk3
  if skillatk3 and unit.hp / unit.attribs.HP < TB.atk3maxHPPercent and not unit.skillatk3havecasted then
    unit.global_cd = 0
    skillatk3.cd_remaining = 0
  end
end

function TB.pasvEvobuff1_OnRemoved(basefunc, buff)
  local unit = buff.caster
  basefunc(buff)
  if unit.ultBuff_TB == 1 then
    local skillpasv = unit.passive_skill_list[1]
    local bid = 10004707
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    local hast = skillpasv["Script Arg2"] * 2
    local mspd = skillpasv["Script Arg3"] * 2
    buff:setAttribute("HAST", hast)
    buff:setAttribute("MSPD", mspd)
    buff.timer = skillpasv["Script Arg4"]
    unit:addBuff(buff, unit)
    buff.onRemoved = override(buff.onRemoved, TB.pasvEvobuff2_OnRemoved)
  end
end

function TB.pasvEvobuff2_OnRemoved(basefunc, buff)
  local unit = buff.caster
  basefunc(buff)
  if unit.ultBuff_TB == 1 then
    local skillpasv = unit.passive_skill_list[1]
    local bid = 10004708
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    local hast = skillpasv["Script Arg2"] * 3
    local mspd = skillpasv["Script Arg3"] * 3
    buff:setAttribute("HAST", hast)
    buff:setAttribute("MSPD", mspd)
    unit:addBuff(buff, unit)
  end
end

function TB.TBMirror_update(basefunc, unit, dt)
  unit.mDuration_TB = unit.mDuration_TB - dt
  if unit.mDuration_TB <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function TB.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local proto = {
    _tid = 129,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  if caster.ultBuff_TB == 1 then
    proto._tid = 130
  end
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod and caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1,
    summoner = caster
  }
  local TBMirror = ed.UnitCreate(proto, caster.camp, config)
  local bid = TB.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = TBMirror:addBuff(binfo, caster)
  local TBmirrortime = TB.mirror_time
  TBMirror.mDuration_TB = TBmirrortime
  TBMirror.update = override(TBMirror.update, TB.TBMirror_update)
  TBMirror:setDeathWithEffectOrNot(true)
  TBMirror.direction = caster.direction
  local locationtb = {
    location[1] + 10,
    location[2] + 45
  }
  ed.engine:summonUnit(TBMirror, locationtb, caster)
  table.insert(caster.TBMirrors, TBMirror)
  local TBmirrorattribs = skill.info["Script Arg3"] / 100
  if skill.evo_rank and 1 <= skill.evo_rank then
    TBmirrorattribs = TBmirrorattribs + skill.evo_rank1["Script Arg1"] / 100
  end
  if skill.evo_rank and 2 <= skill.evo_rank then
    TBmirrorattribs = TBmirrorattribs + skill.evo_rank2["Script Arg1"] / 100
  end
  local AttriBinfo = ed.lookupDataTable("Buff", nil, TB.mirrorAttribs)
  TB.changeBuffInfo(AttriBinfo, TBmirrorattribs, TBMirror)
  local buff = TBMirror:addBuff(AttriBinfo, caster)
  TBMirror:takeHeal(TBMirror.attribs.HP, "hp")
  if skill.evo_rank and skill.evo_rank >= 3 and not caster.skillultevo2 then
    local TBMirror2 = ed.UnitCreate(proto, caster.camp, config)
    local bid = TB.mirrorbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = TBMirror2:addBuff(binfo, caster)
    local TBMirror2time = TB.mirror_time
    TBMirror2.mDuration_TB = TBMirror2time
    TBMirror2.update = override(TBMirror2.update, TB.TBMirror_update)
    TBMirror2:setDeathWithEffectOrNot(true)
    TBMirror2.direction = caster.direction
    local locationtb = {
      location[1] + 25,
      location[2] - 45
    }
    ed.engine:summonUnit(TBMirror2, locationtb, caster)
    table.insert(caster.TBMirrors, TBMirror2)
    local TBMirror2attribs = skill.info["Script Arg3"] / 100
    if skill.evo_rank and 1 <= skill.evo_rank then
      TBMirror2attribs = TBMirror2attribs + skill.evo_rank1["Script Arg1"] / 100
    end
    if skill.evo_rank and 2 <= skill.evo_rank then
      TBMirror2attribs = TBMirror2attribs + skill.evo_rank2["Script Arg1"] / 100
    end
    local AttriBinfo = ed.lookupDataTable("Buff", nil, TB.mirrorAttribs)
    TB.changeBuffInfo(AttriBinfo, TBMirror2attribs, TBMirror2)
    local buff = TBMirror2:addBuff(AttriBinfo, caster)
    TBMirror2:takeHeal(TBMirror2.attribs.HP, "hp")
  end
end

function TB.changeBuffInfo(buffInfo, enhance, target)
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

function TB.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.mp == 0 and buff.owner:isAlive() then
    buff.owner.removeBuff(buff.owner, buff)
  end
end

function TB.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = buff.owner.skills.TB_atk
  if skillatk then
    skillatk.info = skillatk.originfo
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = 1
    owner.attack_range = owner.attack_range - TB.TB_range_interval
  end
  owner.ultBuff_TB = nil
  basefunc(buff)
  if owner.name == "TB" then
    owner:hurt()
    owner:setAction("Birth", false, true)
  end
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if owner.name == "TB" then
        panel:setPortrait("UI/DOTA-HERO/TB.png")
      end
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
    ed.scene:playEffectOnScene("eff_point_TB_ult.cha", {
      buff.owner.position[1],
      buff.owner.position[2] - 1
    }, {
      buff.owner.direction,
      1
    }, nil, 0)
  end
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 10004706 or tbuff.info.ID == 10004707 or tbuff.info.ID == 10004708 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function TB.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ultBuff_TB or hero.mp < 1000 and hero.name == "TB" or hero.manually_casting or hero.isdemon_TB == true then
    return false
  end
  return true
end

function TB.skillult_start(basefunc, skill, target)
  local bid = TB.ultstartbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  TB.ult_func_hideBuffEffect(caster)
  caster.isdemon_TB = true
  basefunc(skill, target)
end

function TB.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local skillinfo = skill.info
  local buff = basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("LFS", skill.evo_rank1["Script Arg1"])
  end
  skillinfo.buff_info.Puppet = "TBult.cha"
  if caster.name ~= "TB" then
    skillinfo.buff_info.Puppet = false
  end
  buff.update = override(buff.update, TB.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, TB.skillult_buffOnRemoved)
  local skillatk = buff.owner.skills.TB_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Max Range"] = skillatk.info["Max Range"] + TB.TB_range_interval,
      CD = TB.TBult_atk_cd,
      ["Global CD"] = TB.TBult_atk_cd,
      ["Gain MP"] = 60,
      ["Track Type"] = "projectile",
      ["AOE Origin"] = false,
      ["Plus Ratio"] = 1.6,
      ["Impact Effect"] = "eff_impact_TB_atk.cha"
    })
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = TB.TBult_atk_cd
    buff.owner.attack_range = buff.owner.attack_range + TB.TB_range_interval
    buff.owner.global_cd = TB.TBult_atk_cd
  end
  buff.owner.ultBuff_TB = 1
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "TB" then
        panel:setPortrait("UI/DOTA-HERO/TBult.png")
      end
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  return buff
end

function TB.ult_func_hideBuffEffect(unit)
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

function TB.ult_func_resetBuffEffect(unit)
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

function TB.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TB_atk2
  if skill.attack_counter == 1 then
    local origin = {
      caster.position[1],
      caster.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_TB_ult3.cha"
      if effect_name then
        skill:selectTarget(caster)
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, origin, {
          caster.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  else
    basefunc(skill, target)
    if skill.evo_rank and skill.evo_rank >= 3 then
      for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
        if not unit.buff_effects.invulnerable and not unit.buff_effects.uncontrollable then
          local bid1 = TB.ultevofearbuff
          local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
          binfo1.fearrange = 5
          unit:addBuff(binfo1, caster)
        end
      end
    end
    if skillatk2 then
      skillatk2.target = caster
      skillatk2:takeEffectAt(caster.position, caster)
      if skill.evo_rank and 2 <= skill.evo_rank then
        for unit in ed.engine:foreachAliveUnit(caster.camp) do
          for _, buff in ipairs(unit.buff_list) do
            if buff.info.ID == TB.mirrorbuff and unit.proto._tid == 129 then
              unit:die()
              caster.skillultevo2 = true
              skillatk2:takeEffectAt({
                caster.position[1] - 50 * ed.rand(),
                caster.position[2] - 100 * ed.rand()
              }, caster)
              caster.skillultevo2 = false
            end
          end
        end
      end
    end
  end
end

function TB.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local position1 = caster.position[1] - caster.direction * 127
  if position1 < 800 and 0 < position1 then
    caster.position[1] = position1
  end
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == TB.ultstartbuff then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  local skillpasv = caster.passive_skill_list[1]
  if skillpasv then
    local bid = 10004706
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    local hast = skillpasv["Script Arg2"]
    local mspd = skillpasv["Script Arg3"]
    buff:setAttribute("HAST", hast)
    buff:setAttribute("MSPD", mspd)
    buff.timer = skillpasv["Script Arg4"]
    caster:addBuff(buff, caster)
    buff.onRemoved = override(buff.onRemoved, TB.pasvEvobuff1_OnRemoved)
  end
  TB.ult_func_resetBuffEffect(caster)
  caster.isdemon_TB = false
end

function TB.hero_die(basefunc, hero, killer)
  for _, mirror in pairs(hero.TBMirrors) do
    if mirror and mirror:isAlive() then
      mirror:die()
    end
  end
  basefunc(hero, killer)
end

function TB.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TBMirrors = {}
  hero.skillultevo2 = nil
  hero.dt = nil
  hero.isdemon_TB = false
  local skillatk3 = hero.skills.TB_atk3
  if skillatk3 then
    hero.skillatk3havecasted = false
  end
  local skillatk = hero.skills.TB_atk
  hero.attack_range = skillatk.info["Max Range"] - 5
end

function TB.init_hero(hero)
  hero.die = override(hero.die, TB.hero_die)
  hero.reset = override(hero.reset, TB.hero_reset)
  hero.update = override(hero.update, TB.update)
  hero.isdemon_TB = false
  hero.TBMirrors = {}
  local skillult = hero.skills.TB_ult
  local skillatk = hero.skills.TB_atk
  local skillatk2 = hero.skills.TB_atk2
  local skillatk3 = hero.skills.TB_atk3
  local skillpasv = hero.passive_skill_list[1]
  hero:preloadEffect("eff_point_TB_ult.cha")
  hero:preloadEffect("eff_impact_TB_atk.cha")
  hero:preloadEffect("eff_point_TB_ult3.cha")
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TB.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TB.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, TB.skillult_finish)
    skillult.start = override(skillult.start, TB.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TB.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, TB.skillatk2_takeEffectAt)
  end
  hero.info.mDuration = TB.mirror_time
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TB.skillatk3_takeEffectOn)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, TB.skillatk3_canCastWithTarget)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
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
  ed.PreloadPuppetRcs("TBult")
  return hero
end

return TB.init_hero
