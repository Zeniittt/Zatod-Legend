module("ed.battlehero", package.seeall)
local ed = ed
TitanSD = {}

function TitanSD.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanSD.skillatk2_start(basefunc, skill, target)
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function TitanSD.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter < 2 then
    basefunc(skill)
  else
    local originfo = skill.info
    local plusratio = skill.info["Plus Ratio"] * 1.66
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.75,
      ["Knock Back"] = 10,
      ["Plus Ratio"] = plusratio
    })
    basefunc(skill)
    skill.info = originfo
  end
end

function TitanSD.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function TitanSD.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local buff_Time = buff.timer
  local owner = buff.owner
  local skillatk3 = caster.skills.TitanSD_atk3
  local AD_value = math.min(owner.attribs.AD * skillatk3.info["Script Arg2"] * 0.01, 30000)
  local AP_value = math.min(owner.attribs.AP * skillatk3.info["Script Arg3"] * 0.01, 30000)
  if AD_value < 1 then
    AD_value = 0
  end
  if AP_value < 1 then
    AP_value = 0
  end
  buff:setAttribute("AD", -AD_value)
  buff:setAttribute("AP", -AP_value)
  if caster.TitanSD_hasArcana and caster.TitanSD_hasArcana > 2 then
    buff.timer = buff_Time + 3
  end
  if target then
    local bid = 4698
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff_s = ed.BuffCreate(binfo, caster, caster)
    buff_s:setAttribute("AD", AD_value)
    buff_s:setAttribute("AP", AP_value)
    buff_s:setAttribute("Time", caster.TitanSD_hasArcana and caster.TitanSD_hasArcana > 2 and buff_Time + 3 or buff_Time)
    caster:addBuff(buff_s, caster)
  end
  return buff
end

function TitanSD.skillatk3_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
  local caster = skill.caster
  local bid = caster.TitanSD_hasArcana and caster.TitanSD_hasArcana > 2 and 4703 or 4696
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function TitanSD.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4696 then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function TitanSD.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4696
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanSD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4696 then
      tbuff.timer = 0
    end
  end
end

function TitanSD.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if result and caster.TitanSD_ult_buff then
    result = false
  end
  return result, reason
end

function TitanSD.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  caster.TitanSD_ult_buff = true
  buff.onRemoved = override(buff.onRemoved, TitanSD.skillult_buff_onRemoved)
  return buff
end

function TitanSD.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  caster.TitanSD_ult_buff = false
end

function TitanSD.getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type)
  local lost = basefunc(unit, damage, immunity, damage_type)
  if 0 < lost and unit.TitanSD_ult_buff and damage_type == "AP" then
    local heal_value = math.min(lost, unit.attribs.HP * 0.5)
    lost = 0
    unit:takeHeal(heal_value, "hp", unit)
  end
  return lost
end

function TitanSD.skillatk_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanSD_atk4
  if target and target:isAlive() and not target.TitanSD_skillatk4_buff and skillatk4 then
    local AD_value = skillatk4.info["Script Arg2"]
    local AP_value = skillatk4.info["Script Arg3"]
    local ARM_value = skillatk4.info["Script Arg4"]
    local MR_value = skillatk4.info["Script Arg5"]
    local bid = 4700
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("AD", -AD_value)
    buff:setAttribute("AP", -AP_value)
    buff:setAttribute("ARM", -ARM_value)
    buff:setAttribute("MR", -MR_value)
    buff.onRemoved = override(buff.onRemoved, TitanSD.skillatk4_buff_onRemoved)
    target:addBuff(buff, caster)
    target.TitanSD_skillatk4_buff = true
    if caster.TitanSD_skillatk4_buffs and caster.skillatk4_buffs and caster.skillatk4_buffs.rank < 5 then
      caster.skillatk4_buffs.rank = caster.skillatk4_buffs.rank + 1
    elseif not caster.skillatk4_buffs then
      local bids = 4699
      local binfos = ed.lookupDataTable("Buff", nil, bids)
      local buffs = ed.BuffCreate(binfos, caster, caster)
      buffs:setAttribute("AD", AD_value)
      buffs:setAttribute("AP", AP_value)
      buffs:setAttribute("ARM", ARM_value)
      buffs:setAttribute("MR", MR_value)
      buffs.onRemoved = override(buffs.onRemoved, TitanSD.skillatk4_buffs_onRemoved)
      caster:addBuff(buffs, caster)
      caster.TitanSD_skillatk4_buffs = true
      caster.skillatk4_buffs = buffs
    end
  end
end

function TitanSD.skillatk4_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanSD_skillatk4_buff = nil
end

function TitanSD.skillatk4_buffs_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanSD_skillatk4_buffs = nil
  owner.skillatk4_buffs = nil
end

function TitanSD.skillatk_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power, i = basefunc(skill, source, target, damage_type)
  local skillatk4 = caster.skills.TitanSD_atk4
  local ap_power = 0
  if skillatk4 then
    ap_power = caster.attribs.AP * 2.2
  end
  return power + ap_power, i
end

function TitanSD.skillatk2_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power, i = basefunc(skill, source, target, damage_type)
  local skillatk4 = caster.skills.TitanSD_atk4
  local ap_power = 0
  if skillatk4 then
    ap_power = caster.attribs.AP * 2.2
  end
  power = power + ap_power
  if caster.TitanSD_hasArcana and caster.TitanSD_hasArcana > 1 then
    power = power * 1.2
  end
  return power, i
end

function TitanSD.onDying(basefunc, self, killer)
  local skillult = self.skills.TitanSD_ult
  if skillult and not self.dying_skillult_AlreadyUse and not self.config.is_boss and not self.config.is_summoned then
    self.dying_skillult_AlreadyUse = true
    for _, buff in ipairs(self.buff_list) do
      local willBeRemove = buff:isCrlEftConflictWithUncontrollable() or ed.isElementInTable("derangedOwner", buff.info["Control Effects"]) or ed.isElementInTable("enchantedbyself", buff.info["Control Effects"]) or ed.isElementInTable("stunbyself", buff.info["Control Effects"])
      if willBeRemove then
        buff.timer = -1
      end
    end
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 1
    local binfo = ed.lookupDataTable("Buff", nil, 4702)
    local buff = self:addBuff(binfo, self)
    if self.current_skill then
      self.current_skill:interrupt()
    end
    self:addBuff(skillult:createBuff(self), self)
    local heal = math.min(self.attribs.HP * 0.4, 500000)
    self:takeHeal(heal, "hp", self)
    self.global_cd = 2
  else
    basefunc(self, killer)
  end
end

function TitanSD.init_hero(hero)
  local skillult = hero.skills.TitanSD_ult
  local skillatk = hero.skills.TitanSD_atk
  local skillatk2 = hero.skills.TitanSD_atk2
  local skillatk3 = hero.skills.TitanSD_atk3
  local skillatk4 = hero.skills.TitanSD_atk4
  hero.TitanSD_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanSD.skillatk_takeEffectOn)
    skillatk.power = override(skillatk.power, TitanSD.skillatk_power)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanSD.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanSD.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanSD.skillatk_takeEffectOn)
    skillatk2.power = override(skillatk2.power, TitanSD.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanSD.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanSD.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanSD.skillatk3_createBuff)
    skillatk3.finish = override(skillatk3.finish, TitanSD.skillatk3_finish)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanSD.skillult_createBuff)
    skillult.start = override(skillult.start, TitanSD.skillult_start)
    skillult.finish = override(skillult.finish, TitanSD.skillult_finish)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanSD.getLostHPAfterImmunity)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanSD.skillult_canCastWithTarget)
  end
  if skillult and hero.TitanSD_hasArcana and hero.TitanSD_hasArcana > 3 then
    hero.onDying = override(hero.onDying, TitanSD.onDying)
  end
  hero.reset = override(hero.reset, TitanSD.hero_reset)
  return hero
end

return TitanSD.init_hero
