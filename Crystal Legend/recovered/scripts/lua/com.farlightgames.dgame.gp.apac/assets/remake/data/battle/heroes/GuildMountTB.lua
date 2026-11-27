module("ed.battlehero", package.seeall)
local ed = ed
GuildMountTB = {}
GuildMountTB.mirrorbuff = 10038602
GuildMountTB.mirrorAttribs = 10038603
GuildMountTB.ultstarGuildMountTBuff = 10038604
GuildMountTB.ultevofearbuff = 10038605
GuildMountTB.mirrorguildbuff = 10039901
GuildMountTB.GuildMountTB_range_interval = 150
GuildMountTB.mirror_time = 15
GuildMountTB.GuildMountTBult_atk_cd = 1.5
GuildMountTB.atk3HPAmount = 10000
GuildMountTB.heroName = "GuildMountTB"

function GuildMountTB.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local HealCount = 0
  if caster then
    for _, mirror in pairs(caster.GuildMountTBMirrors) do
      if mirror and mirror:isAlive() then
        HealCount = HealCount + 1
      end
    end
    caster:takeHeal(HealCount * GuildMountTB.atk3HPAmount, "hp", caster)
  end
end

function GuildMountTB.update(basefunc, unit, dt)
  basefunc(unit, dt)
end

function GuildMountTB.pasvEvobuff1_OnRemoved(basefunc, buff)
  local unit = buff.caster
  basefunc(buff)
  if unit.ulGuildMountTBuff_GuildMountTB == 1 then
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
    buff.onRemoved = override(buff.onRemoved, GuildMountTB.pasvEvobuff2_OnRemoved)
  end
end

function GuildMountTB.pasvEvobuff2_OnRemoved(basefunc, buff)
  local unit = buff.caster
  basefunc(buff)
  if unit.ulGuildMountTBuff_GuildMountTB == 1 then
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

function GuildMountTB.GuildMountTBMirror_update(basefunc, unit, dt)
  unit.mDuration_GuildMountTB = unit.mDuration_GuildMountTB - dt
  if unit.mDuration_GuildMountTB <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function GuildMountTB.skillatk2_takeEffectAt(basefunc, skill, location, source)
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
  if caster.ulGuildMountTBuff_GuildMountTB == 1 then
    proto._tid = 130
  end
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = caster.config.dps_mod or 1,
    summoner = caster
  }
  local GuildMountTBMirror = ed.UnitCreate(proto, caster.camp, config)
  local bid = GuildMountTB.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = GuildMountTBMirror:addBuff(binfo, caster)
  local bid = GuildMountTB.mirrorguildbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, GuildMountTBMirror, GuildMountTBMirror)
  buff.onDamaged = override(buff.onDamaged, GuildMountTB.mirror_onDamaged)
  GuildMountTBMirror:addBuff(buff, caster)
  local GuildMountTBmirrortime = GuildMountTB.mirror_time
  GuildMountTBMirror.mDuration_GuildMountTB = GuildMountTBmirrortime
  GuildMountTBMirror.update = override(GuildMountTBMirror.update, GuildMountTB.GuildMountTBMirror_update)
  GuildMountTBMirror:setDeathWithEffectOrNot(true)
  GuildMountTBMirror.direction = caster.direction
  local locationGuildMountTB = {
    location[1] + 10,
    location[2] + 45
  }
  ed.engine:summonUnit(GuildMountTBMirror, locationGuildMountTB, caster)
  table.insert(caster.GuildMountTBMirrors, GuildMountTBMirror)
  local GuildMountTBmirrorattribs = skill.info["Script Arg3"] / 200
  local AttriBinfo = ed.lookupDataTable("Buff", nil, GuildMountTB.mirrorAttribs)
  GuildMountTB.changeBuffInfo(AttriBinfo, GuildMountTBmirrorattribs, GuildMountTBMirror)
  local buff = GuildMountTBMirror:addBuff(AttriBinfo, caster)
  GuildMountTBMirror:takeHeal(GuildMountTBMirror.attribs.HP, "hp")
  local GuildMountTBMirror2 = ed.UnitCreate(proto, caster.camp, config)
  local bid = GuildMountTB.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = GuildMountTBMirror2:addBuff(binfo, caster)
  local bid = GuildMountTB.mirrorguildbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, GuildMountTBMirror2, GuildMountTBMirror2)
  buff.onDamaged = override(buff.onDamaged, GuildMountTB.mirror_onDamaged)
  GuildMountTBMirror2:addBuff(buff, caster)
  local GuildMountTBMirror2time = GuildMountTB.mirror_time
  GuildMountTBMirror2.mDuration_GuildMountTB = GuildMountTBMirror2time
  GuildMountTBMirror2.update = override(GuildMountTBMirror2.update, GuildMountTB.GuildMountTBMirror_update)
  GuildMountTBMirror2:setDeathWithEffectOrNot(true)
  GuildMountTBMirror2.direction = caster.direction
  local locationGuildMountTB = {
    location[1] + 25,
    location[2] - 45
  }
  ed.engine:summonUnit(GuildMountTBMirror2, locationGuildMountTB, caster)
  table.insert(caster.GuildMountTBMirrors, GuildMountTBMirror2)
  local GuildMountTBMirror2attribs = skill.info["Script Arg3"] / 200
  local AttriBinfo = ed.lookupDataTable("Buff", nil, GuildMountTB.mirrorAttribs)
  GuildMountTB.changeBuffInfo(AttriBinfo, GuildMountTBMirror2attribs, GuildMountTBMirror2)
  local buff = GuildMountTBMirror2:addBuff(AttriBinfo, caster)
  GuildMountTBMirror2:takeHeal(GuildMountTBMirror2.attribs.HP, "hp")
end

function GuildMountTB.mirror_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  local owner = buff.owner
  local summoner = owner.config.summoner
  if summoner then
    dmg = dmg * 0.45
  end
  return dmg
end

function GuildMountTB.collectHPchange(basefunc, self, config)
  if config.unit.config.summoner and config.unit.config.summoner == self and config.hp_change < 0 then
    self:takeDamage(-config.hp_change / self.attribs.PDM, "Holy", "hp", self)
  end
end

function GuildMountTB.changeBuffInfo(buffInfo, enhance, target)
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

function GuildMountTB.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.mp == 0 and buff.owner:isAlive() then
    buff.owner.removeBuff(buff.owner, buff)
  end
end

function GuildMountTB.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = buff.owner.skills.GuildMountTB_atk
  if skillatk then
    skillatk.info = skillatk.originfo
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = 1
    owner.attack_range = owner.attack_range - GuildMountTB.GuildMountTB_range_interval
  end
  owner.ulGuildMountTBuff_GuildMountTB = nil
  basefunc(buff)
  if owner.name == "GuildMountTB" then
    owner:hurt()
    owner:setAction("Birth", false, true)
  end
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if owner.name == "GuildMountTB" then
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
  for i, GuildMountTBuff in ipairs(owner.buff_list) do
    if GuildMountTBuff.info.ID == 10004706 or GuildMountTBuff.info.ID == 10004707 or GuildMountTBuff.info.ID == 10004708 then
      local buff = GuildMountTBuff
      buff.owner:removeBuff(buff)
    end
  end
end

function GuildMountTB.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ulGuildMountTBuff_GuildMountTB or hero.mp < 1000 and hero.name == "GuildMountTB" or hero.manually_casting or hero.isdemon_GuildMountTB == true then
    return false
  end
  return true
end

function GuildMountTB.skillult_start(basefunc, skill, target)
  local bid = GuildMountTB.ultstarGuildMountTBuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  GuildMountTB.ult_func_hideBuffEffect(caster)
  caster.isdemon_GuildMountTB = true
  basefunc(skill, target)
end

function GuildMountTB.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local skillinfo = skill.info
  local buff = basefunc(skill, target)
  skillinfo.buff_info.Puppet = "TBult.cha"
  if caster.name ~= "GuildMountTB" then
    skillinfo.buff_info.Puppet = false
  end
  buff.update = override(buff.update, GuildMountTB.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, GuildMountTB.skillult_buffOnRemoved)
  local skillatk = buff.owner.skills.GuildMountTB_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Max Range"] = skillatk.info["Max Range"] + GuildMountTB.GuildMountTB_range_interval,
      CD = GuildMountTB.GuildMountTBult_atk_cd,
      ["Global CD"] = GuildMountTB.GuildMountTBult_atk_cd,
      ["Gain MP"] = 60,
      ["Track Type"] = "projectile",
      ["AOE Origin"] = false,
      ["Plus Ratio"] = 1.6,
      ["Impact Effect"] = "eff_impact_TB_atk.cha"
    })
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = GuildMountTB.GuildMountTBult_atk_cd
    buff.owner.attack_range = buff.owner.attack_range + GuildMountTB.GuildMountTB_range_interval
    buff.owner.global_cd = GuildMountTB.GuildMountTBult_atk_cd
  end
  buff.owner.ulGuildMountTBuff_GuildMountTB = 1
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "GuildMountTB" then
        panel:setPortrait("UI/DOTA-HERO/TBult.png")
      end
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  return buff
end

function GuildMountTB.ult_func_hideBuffEffect(unit)
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

function GuildMountTB.ult_func_reseGuildMountTBuffEffect(unit)
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

function GuildMountTB.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.GuildMountTB_atk2
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
          if buff.info.ID == GuildMountTB.mirrorbuff and unit.proto._tid == 129 then
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

function GuildMountTB.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local position1 = caster.position[1] - caster.direction * 127
  if position1 < 800 and 0 < position1 then
    caster.position[1] = position1
  end
  for i, GuildMountTBuff in ipairs(skill.caster.buff_list) do
    if GuildMountTBuff.info.ID == GuildMountTB.ultstarGuildMountTBuff then
      local buff = GuildMountTBuff
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
    buff.onRemoved = override(buff.onRemoved, GuildMountTB.pasvEvobuff1_OnRemoved)
  end
  GuildMountTB.ult_func_reseGuildMountTBuffEffect(caster)
  caster.isdemon_GuildMountTB = false
end

function GuildMountTB.hero_die(basefunc, hero, killer)
  for _, mirror in pairs(hero.GuildMountTBMirrors) do
    if mirror and mirror:isAlive() then
      mirror:die()
    end
  end
  basefunc(hero, killer)
end

function GuildMountTB.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.GuildMountTBMirrors = {}
  hero.skillultevo2 = nil
  hero.dt = nil
  hero.isdemon_GuildMountTB = false
  local skillatk3 = hero.skills.GuildMountTB_atk3
  if skillatk3 then
    hero.skillatk3havecasted = false
  end
  local skillatk = hero.skills.GuildMountTB_atk
  hero.attack_range = skillatk.info["Max Range"] - 5
end

function GuildMountTB.init_hero(hero)
  hero.die = override(hero.die, GuildMountTB.hero_die)
  hero.reset = override(hero.reset, GuildMountTB.hero_reset)
  hero.update = override(hero.update, GuildMountTB.update)
  hero.isdemon_GuildMountTB = false
  local skillult = hero.skills.GuildMountTB_ult
  local skillatk = hero.skills.GuildMountTB_atk
  local skillatk2 = hero.skills.GuildMountTB_atk2
  local skillatk3 = hero.skills.GuildMountTB_atk3
  local skillpasv = hero.passive_skill_list[1]
  hero:preloadEffect("eff_point_TB_ult.cha")
  hero:preloadEffect("eff_impact_TB_atk.cha")
  hero:preloadEffect("eff_point_TB_ult3.cha")
  if skillult then
    skillult.createBuff = override(skillult.createBuff, GuildMountTB.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, GuildMountTB.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, GuildMountTB.skillult_finish)
    skillult.start = override(skillult.start, GuildMountTB.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, GuildMountTB.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, GuildMountTB.skillatk2_takeEffectAt)
  end
  hero.info.mDuration = GuildMountTB.mirror_time
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, GuildMountTB.skillatk3_takeEffectOn)
  end
  hero.collectHPchange = override(hero.collectHPchange, GuildMountTB.collectHPchange)
  ed.PreloadPuppetRcs("TBult")
  return hero
end

return GuildMountTB.init_hero
