module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossTB = {}
AwakeBossTB.mirrorbuff = 10038602
AwakeBossTB.mirrorAttribs = 10038603
AwakeBossTB.ultstarAwakeBossTBuff = 10038604
AwakeBossTB.ultevofearbuff = 10038605
AwakeBossTB.AwakeBossTB_range_interval = 150
AwakeBossTB.mirror_time = 15
AwakeBossTB.AwakeBossTBult_atk_cd = 1.5
AwakeBossTB.atk3HPPercent = 0.01
AwakeBossTB.heroName = "AwakeBossTB"

function AwakeBossTB.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local HealCount = 0
  if caster then
    for _, mirror in pairs(caster.AwakeBossTBMirrors) do
      if mirror and mirror:isAlive() then
        HealCount = HealCount + 1
      end
    end
    caster:takeHeal(HealCount * AwakeBossTB.atk3HPPercent * caster.attribs.HP, "hp", caster)
  end
end

function AwakeBossTB.update(basefunc, unit, dt)
  basefunc(unit, dt)
end

function AwakeBossTB.pasvEvobuff1_OnRemoved(basefunc, buff)
  local unit = buff.caster
  basefunc(buff)
  if unit.ulAwakeBossTBuff_AwakeBossTB == 1 then
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
    buff.onRemoved = override(buff.onRemoved, AwakeBossTB.pasvEvobuff2_OnRemoved)
  end
end

function AwakeBossTB.pasvEvobuff2_OnRemoved(basefunc, buff)
  local unit = buff.caster
  basefunc(buff)
  if unit.ulAwakeBossTBuff_AwakeBossTB == 1 then
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

function AwakeBossTB.AwakeBossTBMirror_update(basefunc, unit, dt)
  unit.mDuration_AwakeBossTB = unit.mDuration_AwakeBossTB - dt
  if unit.mDuration_AwakeBossTB <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function AwakeBossTB.skillatk2_takeEffectAt(basefunc, skill, location, source)
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
  if caster.ulAwakeBossTBuff_AwakeBossTB == 1 then
    proto._tid = 130
  end
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = caster.config.dps_mod or 1,
    summoner = caster
  }
  local AwakeBossTBMirror = ed.UnitCreate(proto, caster.camp, config)
  local bid = AwakeBossTB.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = AwakeBossTBMirror:addBuff(binfo, caster)
  local AwakeBossTBmirrortime = AwakeBossTB.mirror_time
  AwakeBossTBMirror.mDuration_AwakeBossTB = AwakeBossTBmirrortime
  AwakeBossTBMirror.update = override(AwakeBossTBMirror.update, AwakeBossTB.AwakeBossTBMirror_update)
  AwakeBossTBMirror:setDeathWithEffectOrNot(true)
  AwakeBossTBMirror.direction = caster.direction
  local locationAwakeBossTB = {
    location[1] + 10,
    location[2] + 45
  }
  ed.engine:summonUnit(AwakeBossTBMirror, locationAwakeBossTB, caster)
  table.insert(caster.AwakeBossTBMirrors, AwakeBossTBMirror)
  local AwakeBossTBmirrorattribs = skill.info["Script Arg3"] / 100
  local AttriBinfo = ed.lookupDataTable("Buff", nil, AwakeBossTB.mirrorAttribs)
  AwakeBossTB.changeBuffInfo(AttriBinfo, AwakeBossTBmirrorattribs, AwakeBossTBMirror)
  local buff = AwakeBossTBMirror:addBuff(AttriBinfo, caster)
  AwakeBossTBMirror:takeHeal(AwakeBossTBMirror.attribs.HP, "hp")
  local AwakeBossTBMirror2 = ed.UnitCreate(proto, caster.camp, config)
  local bid = AwakeBossTB.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = AwakeBossTBMirror2:addBuff(binfo, caster)
  local AwakeBossTBMirror2time = AwakeBossTB.mirror_time
  AwakeBossTBMirror2.mDuration_AwakeBossTB = AwakeBossTBMirror2time
  AwakeBossTBMirror2.update = override(AwakeBossTBMirror2.update, AwakeBossTB.AwakeBossTBMirror_update)
  AwakeBossTBMirror2:setDeathWithEffectOrNot(true)
  AwakeBossTBMirror2.direction = caster.direction
  local locationAwakeBossTB = {
    location[1] + 25,
    location[2] - 45
  }
  ed.engine:summonUnit(AwakeBossTBMirror2, locationAwakeBossTB, caster)
  table.insert(caster.AwakeBossTBMirrors, AwakeBossTBMirror2)
  local AwakeBossTBMirror2attribs = skill.info["Script Arg3"] / 100
  local AttriBinfo = ed.lookupDataTable("Buff", nil, AwakeBossTB.mirrorAttribs)
  AwakeBossTB.changeBuffInfo(AttriBinfo, AwakeBossTBMirror2attribs, AwakeBossTBMirror2)
  local buff = AwakeBossTBMirror2:addBuff(AttriBinfo, caster)
  AwakeBossTBMirror2:takeHeal(AwakeBossTBMirror2.attribs.HP, "hp")
end

function AwakeBossTB.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
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
    end
  end
end

function AwakeBossTB.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.mp == 0 and buff.owner:isAlive() then
    buff.owner.removeBuff(buff.owner, buff)
  end
end

function AwakeBossTB.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = buff.owner.skills.AwakeBossTB_atk
  if skillatk then
    skillatk.info = skillatk.originfo
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = 1
    owner.attack_range = owner.attack_range - AwakeBossTB.AwakeBossTB_range_interval
  end
  owner.ulAwakeBossTBuff_AwakeBossTB = nil
  basefunc(buff)
  if owner.name == "AwakeBossTB" then
    owner:hurt()
    owner:setAction("Birth", false, true)
  end
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if owner.name == "AwakeBossTB" then
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
  for i, AwakeBossTBuff in ipairs(owner.buff_list) do
    if AwakeBossTBuff.info.ID == 10004706 or AwakeBossTBuff.info.ID == 10004707 or AwakeBossTBuff.info.ID == 10004708 then
      local buff = AwakeBossTBuff
      buff.owner:removeBuff(buff)
    end
  end
end

function AwakeBossTB.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ulAwakeBossTBuff_AwakeBossTB or hero.mp < 1000 and hero.name == "AwakeBossTB" or hero.manually_casting or hero.isdemon_AwakeBossTB == true then
    return false
  end
  return true
end

function AwakeBossTB.skillult_start(basefunc, skill, target)
  local bid = AwakeBossTB.ultstarAwakeBossTBuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  AwakeBossTB.ult_func_hideBuffEffect(caster)
  caster.isdemon_AwakeBossTB = true
  basefunc(skill, target)
end

function AwakeBossTB.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local skillinfo = skill.info
  local buff = basefunc(skill, target)
  skillinfo.buff_info.Puppet = "TBult.cha"
  if caster.name ~= "AwakeBossTB" then
    skillinfo.buff_info.Puppet = false
  end
  buff.update = override(buff.update, AwakeBossTB.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, AwakeBossTB.skillult_buffOnRemoved)
  local skillatk = buff.owner.skills.AwakeBossTB_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Max Range"] = skillatk.info["Max Range"] + AwakeBossTB.AwakeBossTB_range_interval,
      CD = AwakeBossTB.AwakeBossTBult_atk_cd,
      ["Global CD"] = AwakeBossTB.AwakeBossTBult_atk_cd,
      ["Gain MP"] = 60,
      ["Track Type"] = "projectile",
      ["AOE Origin"] = false,
      ["Plus Ratio"] = 1.6,
      ["Impact Effect"] = "eff_impact_TB_atk.cha"
    })
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = AwakeBossTB.AwakeBossTBult_atk_cd
    buff.owner.attack_range = buff.owner.attack_range + AwakeBossTB.AwakeBossTB_range_interval
    buff.owner.global_cd = AwakeBossTB.AwakeBossTBult_atk_cd
  end
  buff.owner.ulAwakeBossTBuff_AwakeBossTB = 1
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "AwakeBossTB" then
        panel:setPortrait("UI/DOTA-HERO/TBult.png")
      end
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  return buff
end

function AwakeBossTB.ult_func_hideBuffEffect(unit)
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

function AwakeBossTB.ult_func_reseAwakeBossTBuffEffect(unit)
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

function AwakeBossTB.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.AwakeBossTB_atk2
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
    if skillatk2 then
      skillatk2.target = caster
      skillatk2:takeEffectAt(caster.position, caster)
      for unit in ed.engine:foreachAliveUnit(caster.camp) do
        for _, buff in ipairs(unit.buff_list) do
          if buff.info.ID == AwakeBossTB.mirrorbuff and unit.proto._tid == 129 then
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

function AwakeBossTB.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local position1 = caster.position[1] - caster.direction * 127
  if position1 < 800 and 0 < position1 then
    caster.position[1] = position1
  end
  for i, AwakeBossTBuff in ipairs(skill.caster.buff_list) do
    if AwakeBossTBuff.info.ID == AwakeBossTB.ultstarAwakeBossTBuff then
      local buff = AwakeBossTBuff
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
    buff.onRemoved = override(buff.onRemoved, AwakeBossTB.pasvEvobuff1_OnRemoved)
  end
  AwakeBossTB.ult_func_reseAwakeBossTBuffEffect(caster)
  caster.isdemon_AwakeBossTB = false
end

function AwakeBossTB.hero_die(basefunc, hero, killer)
  for _, mirror in pairs(hero.AwakeBossTBMirrors) do
    if mirror and mirror:isAlive() then
      mirror:die()
    end
  end
  basefunc(hero, killer)
end

function AwakeBossTB.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.AwakeBossTBMirrors = {}
  hero.skillultevo2 = nil
  hero.dt = nil
  hero.isdemon_AwakeBossTB = false
  local skillatk3 = hero.skills.AwakeBossTB_atk3
  if skillatk3 then
    hero.skillatk3havecasted = false
  end
  local skillatk = hero.skills.AwakeBossTB_atk
  hero.attack_range = skillatk.info["Max Range"] - 5
end

function AwakeBossTB.init_hero(hero)
  hero.die = override(hero.die, AwakeBossTB.hero_die)
  hero.reset = override(hero.reset, AwakeBossTB.hero_reset)
  hero.update = override(hero.update, AwakeBossTB.update)
  hero.isdemon_AwakeBossTB = false
  local skillult = hero.skills.AwakeBossTB_ult
  local skillatk = hero.skills.AwakeBossTB_atk
  local skillatk2 = hero.skills.AwakeBossTB_atk2
  local skillatk3 = hero.skills.AwakeBossTB_atk3
  local skillpasv = hero.passive_skill_list[1]
  hero:preloadEffect("eff_point_TB_ult.cha")
  hero:preloadEffect("eff_impact_TB_atk.cha")
  hero:preloadEffect("eff_point_TB_ult3.cha")
  if skillult then
    skillult.createBuff = override(skillult.createBuff, AwakeBossTB.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, AwakeBossTB.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, AwakeBossTB.skillult_finish)
    skillult.start = override(skillult.start, AwakeBossTB.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossTB.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, AwakeBossTB.skillatk2_takeEffectAt)
  end
  hero.info.mDuration = AwakeBossTB.mirror_time
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, AwakeBossTB.skillatk3_takeEffectOn)
  end
  ed.PreloadPuppetRcs("TBult")
  return hero
end

return AwakeBossTB.init_hero
