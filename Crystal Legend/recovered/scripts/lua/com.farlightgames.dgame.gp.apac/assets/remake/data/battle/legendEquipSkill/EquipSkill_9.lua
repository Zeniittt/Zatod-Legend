local class = newclass("g")
ed.LegendEquip_9 = class

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  if self.battle_time_count then
    self.battle_time_count = self.battle_time_count + dt
  end
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  local skillatk3 = self.skills.Skill_3
  if master:isAlive() and skillatk1 and skillatk3 and not self.LegendEquip_9_casted and not master.buff_effects.invulnerable and (master.hp < master.attribs.HP * 0.5 or self.battle_time_count >= 15) then
    master:addBuff(skillatk1:createBuff(master), master)
    self.LegendEquip_9_casted = true
    if skillatk3 then
      local list = master.buff_list
      local debuff_list = {}
      local my_camp = master.camp
      for i = 1, #list do
        local buff = list[i]
        if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
          debuff_list[#debuff_list + 1] = buff
        end
      end
      for i = 1, #debuff_list do
        master:removeBuff(debuff_list[i])
      end
    end
  end
  if master:isAlive() and skillatk1 and not self.LegendEquip_9_casted and not master.buff_effects.stun and not master.buff_effects.doom and not master.buff_effects.invulnerable and not master.buff_effects.frozen and not master.buff_effects.icefrozen and not master.buff_effects.fear and (master.hp < master.attribs.HP * 0.5 or self.battle_time_count >= 15) then
    master:addBuff(skillatk1:createBuff(master), master)
    self.LegendEquip_9_casted = true
    if skillatk3 then
      local list = master.buff_list
      local debuff_list = {}
      local my_camp = master.camp
      for i = 1, #list do
        local buff = list[i]
        if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
          debuff_list[#debuff_list + 1] = buff
        end
      end
      for i = 1, #debuff_list do
        master:removeBuff(debuff_list[i])
      end
    end
  end
end

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  self.LegendEquip_9_casted = false
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  if skillatk1 then
    self.battle_time_count = 0
  end
  local skillatk2 = self.skills.Skill_2
  if skillatk2 then
    master:addBuff(skillatk2:createBuff(master), master)
  end
end

function class.LegendEquip_skillatk1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if ed.run_with_scene then
    local effect = "eff_point_LegendEquip_9_2.cha"
    local position = owner.position
    ed.scene:playEffectOnScene(effect, position, {1, 1}, nil, 1)
  end
  buff.onRemoved = override(buff.onRemoved, class.LegendEquip_skillatk1_buff_onRemoved)
  return buff
end

function class.LegendEquip_skillatk1_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.owner
  caster.position = {
    caster.position[1] + (-0.5 + ed.rand()) * 40,
    caster.position[2] + (-0.5 + ed.rand()) * 40
  }
  local proto = {
    _tid = 397,
    _level = caster.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = caster.fashion_id
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1,
    summoner = caster
  }
  local LegendEquip_9_Mirror1 = ed.UnitCreate(proto, caster.camp, config)
  LegendEquip_9_Mirror1.mDuration = 16
  class.LegendEquip_9_mirrorFunction(LegendEquip_9_Mirror1)
  LegendEquip_9_Mirror1:setDeathWithEffectOrNot(true)
  local LegendEquip_9_Mirror2 = ed.UnitCreate(proto, caster.camp, config)
  LegendEquip_9_Mirror2.mDuration = 16
  class.LegendEquip_9_mirrorFunction(LegendEquip_9_Mirror2)
  LegendEquip_9_Mirror2:setDeathWithEffectOrNot(true)
  LegendEquip_9_Mirror1.direction = caster.direction
  local LegendEquip_9_Mirrorlocation = caster.position[1]
  if 780 < LegendEquip_9_Mirrorlocation then
    LegendEquip_9_Mirrorlocation = 780
  elseif LegendEquip_9_Mirrorlocation < 30 then
    LegendEquip_9_Mirrorlocation = 30
  end
  local locationtb21 = {
    LegendEquip_9_Mirrorlocation + LegendEquip_9_Mirror1.direction * 10,
    caster.position[2] + LegendEquip_9_Mirror1.direction * 20
  }
  local locationtb22 = {
    LegendEquip_9_Mirrorlocation + LegendEquip_9_Mirror2.direction * 10,
    caster.position[2] - LegendEquip_9_Mirror2.direction * 20
  }
  local ID = caster.info.ID
  local puppet = ed.lookupDataTable("Unit", "Puppet", ID)
  LegendEquip_9_Mirror1:pushPuppet(caster.puppet_stack[#caster.puppet_stack] or puppet)
  LegendEquip_9_Mirror2:pushPuppet(caster.puppet_stack[#caster.puppet_stack] or puppet)
  if ed.run_with_scene then
    local effect = "eff_point_LegendEquip_9.cha"
    ed.scene:playEffectOnScene(effect, caster.position, {1, 1}, nil, 1)
    ed.scene:playEffectOnScene(effect, locationtb21, {1, 1}, nil, 1)
    ed.scene:playEffectOnScene(effect, locationtb22, {1, 1}, nil, 1)
  end
  local mirror1atk = LegendEquip_9_Mirror1.skills.CommonMirror_atk
  local targetSkillatkGroup = ed.getDataTable("SkillGroup")[ID][5]
  if not targetSkillatkGroup then
    return isHit, dmg, Crit, lfs_amount
  end
  local targetSkillatkinfo = ed.Skill.getSkillInfo(targetSkillatkGroup, 1)
  local skillinfo = ed.copyTable(targetSkillatkinfo)
  local buff_info
  mirror1atk.info = skillinfo
  setmetatable(mirror1atk.info, getmetatable(targetSkillatkinfo))
  if mirror1atk.info["Buff ID"] > 0 then
    buff_info = ed.lookupDataTable("Buff", nil, mirror1atk.info["Buff ID"])
  end
  local buff_patch = {}
  if buff_info then
    setmetatable(buff_patch, {__index = buff_info})
    mirror1atk.info.buff_info = buff_patch
  end
  mirror1atk.attack_range = mirror1atk.info["Max Range"] - 5
  if caster.puppet_stack[#caster.puppet_stack] and caster.puppet_stack[#caster.puppet_stack] == "TBult.cha" then
    mirror1atk.originfo = mirror1atk.info
    mirror1atk.info = ed.wraptable(mirror1atk.originfo, {
      ["Max Range"] = 306,
      CD = 1.5,
      ["Global CD"] = 1.5,
      ["Gain MP"] = 0,
      ["Track Type"] = "projectile",
      ["AOE Origin"] = false,
      ["Plus Ratio"] = 1.6,
      ["Impact Effect"] = "eff_impact_TB_atk.cha"
    })
  end
  local mirror2atk = LegendEquip_9_Mirror2.skills.CommonMirror_atk
  local targetSkillatkGroup = ed.getDataTable("SkillGroup")[ID][5]
  if not targetSkillatkGroup then
    return isHit, dmg, Crit, lfs_amount
  end
  local targetSkillatkinfo = ed.Skill.getSkillInfo(targetSkillatkGroup, 1)
  local skillinfo = ed.copyTable(targetSkillatkinfo)
  local buff_info
  mirror2atk.info = skillinfo
  setmetatable(mirror2atk.info, getmetatable(targetSkillatkinfo))
  if mirror2atk.info["Buff ID"] > 0 then
    buff_info = ed.lookupDataTable("Buff", nil, mirror2atk.info["Buff ID"])
  end
  local buff_patch = {}
  if buff_info then
    setmetatable(buff_patch, {__index = buff_info})
    mirror2atk.info.buff_info = buff_patch
  end
  mirror2atk.attack_range = mirror2atk.info["Max Range"] - 5
  if caster.puppet_stack[#caster.puppet_stack] and caster.puppet_stack[#caster.puppet_stack] == "TBult.cha" then
    mirror2atk.originfo = mirror2atk.info
    mirror2atk.info = ed.wraptable(mirror2atk.originfo, {
      ["Max Range"] = 306,
      CD = 1.5,
      ["Global CD"] = 1.5,
      ["Gain MP"] = 0,
      ["Track Type"] = "projectile",
      ["AOE Origin"] = false,
      ["Plus Ratio"] = 1.6,
      ["Impact Effect"] = "eff_impact_TB_atk.cha"
    })
  end
  LegendEquip_9_Mirror1:reset()
  LegendEquip_9_Mirror2:reset()
  local bid = 10005401
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LegendEquip_9_Mirror1:addBuff(ed.copyTable(binfo), caster)
  local bid = 10005401
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LegendEquip_9_Mirror2:addBuff(ed.copyTable(binfo), caster)
  ed.engine:summonUnit(LegendEquip_9_Mirror1, locationtb21, caster, "Birth")
  ed.engine:summonUnit(LegendEquip_9_Mirror2, locationtb22, caster, "Birth")
  local AttriBinfo = ed.lookupDataTable("Buff", nil, 80000903)
  local buffattribs1 = LegendEquip_9_Mirror1:addBuff(ed.copyTable(AttriBinfo), caster)
  LegendEquip_9_Mirror1:takeHeal(LegendEquip_9_Mirror1.attribs.HP, "hp")
  local buffattribs2 = LegendEquip_9_Mirror2:addBuff(ed.copyTable(AttriBinfo), caster)
  LegendEquip_9_Mirror2:takeHeal(LegendEquip_9_Mirror2.attribs.HP, "hp")
end

function class.LegendEquip_9_mirrorFunction(unit)
  unit.update = override(unit.update, class.Mirror_update)
end

function class.Mirror_update(basefunc, unit, dt)
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 and unit:isAlive() then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function class.doInit(LegendEquip)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  local skillatk1 = LegendEquip.skills.Skill_1
  local skillatk2 = LegendEquip.skills.Skill_2
  if skillatk1 then
    skillatk1.createBuff = override(skillatk1.createBuff, class.LegendEquip_skillatk1_createBuff)
  end
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
