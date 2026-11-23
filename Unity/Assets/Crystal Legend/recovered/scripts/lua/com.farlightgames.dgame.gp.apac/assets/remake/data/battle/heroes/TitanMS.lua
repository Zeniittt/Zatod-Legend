module("ed.battlehero", package.seeall)
local ed = ed
TitanMS = {}
TitanMS.TitanMS_akt4headEffectList = {
  "eff_buff_VIS_atk3a.cha",
  "eff_buff_VIS_atk3b.cha",
  "eff_buff_VIS_atk3c.cha",
  "eff_buff_VIS_atk3d.cha"
}
TitanMS.atk3_invBuff = 4709
TitanMS.atk4_Buff = 4706
TitanMS.atk4RageBuff = 4708
TitanMS.ult_invBuff = 4710
TitanMS.TitanMS_atk4BuffLimit = 3

function TitanMS.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.TitanMS_orbBuffLevel and caster.TitanMS_orbBuffLevel >= caster.TitanMS_atk4RageLimit then
    skill.info["Ignore Shield"] = true
  else
    skill.info["Ignore Shield"] = false
  end
  basefunc(skill, target)
end

function TitanMS.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  if caster.TitanMS_orbBuffLevel and caster.TitanMS_orbBuffLevel >= caster.TitanMS_atk4RageLimit and owner then
    buff:setAttribute("HPR", -math.min(target.attribs.HP / 100, caster.attribs.HP / 50))
  end
  return buff
end

function TitanMS.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = TitanMS.atk3_invBuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onDamaged = override(buff.onDamaged, TitanMS.skillatk3_buffonDamaged)
  caster:addBuff(buff, caster)
  caster.has_atk3inv = true
  basefunc(skill, target)
  if caster.TitanMS_orbBuffLevel and caster.TitanMS_orbBuffLevel >= caster.TitanMS_atk4RageLimit then
    skill.info["Ignore Shield"] = true
  else
    skill.info["Ignore Shield"] = false
  end
end

function TitanMS.skillatk3_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  if damage and 0 < damage and (damage_type == "AD" or damage_type == "AP") and not transferred then
    caster.atk4_damageAmount = caster.atk4_damageAmount + damage
    damage = 0
    transferred = true
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

function TitanMS.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if caster and target then
    if attack_counter == 0 then
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == TitanMS.atk3_invBuff then
          caster.has_atk3inv = true
        end
      end
      if not caster.has_atk3inv then
        local bid = TitanMS.atk3_invBuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, caster, caster)
        buff.onDamaged = override(buff.onDamaged, TitanMS.skillatk3_buffonDamaged)
        caster:addBuff(buff, caster)
        caster.has_atk3inv = true
      end
      skill.attack_counter = skill.attack_counter + 1
    else
      if ed.run_with_scene and target then
        local effect_name = "eff_point_TitanMS_atk3.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, target.position, {1, 1}, nil, 1)
      end
      if caster.TitanMS_orbBuffLevel and caster.TitanMS_orbBuffLevel >= caster.TitanMS_atk4RageLimit then
        target:takeDamage(250, "Holy", "mp", caster)
      end
      basefunc(skill)
    end
  end
end

function TitanMS.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanMS.atk3_invBuff then
      tbuff.timer = 0
    end
  end
end

function TitanMS.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = TitanMS.ult_invBuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff)
  if caster.TitanMS_orbBuffLevel and caster.TitanMS_orbBuffLevel >= caster.TitanMS_atk4RageLimit then
    skill.info["Ignore Shield"] = true
  else
    skill.info["Ignore Shield"] = false
  end
end

function TitanMS.skillult_power(basefunc, skill, target, source, target, damage_type)
  local power, i = basefunc(skill, target, source, target, damage_type)
  local caster = skill.caster
  local rage_rank = caster.TitanMS_orbBuffLevel
  if rage_rank and 0 < rage_rank then
    power = power * 1.15 ^ rage_rank
  end
  caster.TitanMS_ultPower = power
  return power, i
end

function TitanMS.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local target = skill.target
  if caster and attack_counter and target and attack_counter == 3 then
    if caster.TitanMS_hasArcana and caster.TitanMS_hasArcana < 4 then
      caster.TitanMS_orbBuffLevel = 0
      for _, buff in ipairs(caster.buff_list) do
        if buff.info.ID == TitanMS.atk4RageBuff then
          buff.timer = -1
          caster.TitanMS_RageBuff = false
        end
      end
    end
    for _, buff in ipairs(caster.buff_list) do
      if buff.info.ID == TitanMS.ult_invBuff then
        buff.timer = -1
      end
    end
  end
end

function TitanMS.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.TitanMS_hasArcana and caster.TitanMS_hasArcana < 4 then
    caster.TitanMS_orbBuffLevel = 0
    for _, buff in ipairs(caster.buff_list) do
      if buff.info.ID == TitanMS.atk4RageBuff then
        buff.timer = -1
        caster.TitanMS_RageBuff = false
      end
    end
  end
  for _, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanMS.ult_invBuff then
      buff.timer = -1
    end
  end
end

function TitanMS.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanMS_atk4
  local skillult = hero.skills.TitanMS_ult
  if skillatk4 and hero:isAlive() and not skillult.casting and hero.atk4_damageAmount and hero.atk4_damageAmount >= math.min(hero.attribs.HP * 0.2, 30000) then
    hero.TitanMS_orbBuffLevel = hero.TitanMS_orbBuffLevel + 1
    hero.TitanMS_orbBuffLevel = math.min(hero.TitanMS_orbBuffLevel, TitanMS.TitanMS_atk4BuffLimit)
    hero.atk4_damageAmount = 0
  end
end

function TitanMS.hero_collectHPchange(basefunc, self, config)
  local unit = config.unit
  local hero = self
  if unit.camp == hero.camp and unit:isHero() and config.hp_change < 0 then
    local HP_change = -config.hp_change
    if unit == hero then
      self.atk4_damageAmount = HP_change + self.atk4_damageAmount
    elseif hero.TitanMS_hasArcana and hero.TitanMS_hasArcana > 2 then
      self.atk4_damageAmount = HP_change * 0.4 + self.atk4_damageAmount
    end
  end
end

function TitanMS.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanMS_orbBuffLevel = 0
  hero.TitanMS_effectBuffNumPre = 0
  hero.TitanMS_effectFirstTime = true
  hero.WorldMed_awake_list = {}
  hero.TitanMS_RageBuff = false
  hero.TitanMS_preEffectID = nil
  hero.atk4_damageAmount = 1
  hero.TitanMS_ultPower = 1
  local bid = TitanMS.atk4_Buff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  buff.update = override(buff.update, TitanMS.skillatk4_buff_update)
  hero:addBuff(buff, hero)
  local skillatk4 = hero.skills.TitanMS_atk4
  if skillatk4 and not hero.config.is_boss then
    local atk4_Ratio = skillatk4.info["Script Arg2"] / 100
    local rage_Ratio = skillatk4.info["Script Arg3"] / 100
    hero.TitanMS_atk4_AD = hero.attribs.AD * atk4_Ratio
    hero.TitanMS_atk4_ARMP = hero.attribs.ARMP * atk4_Ratio
    hero.TitanMS_atk4_ARM = hero.attribs.ARM * atk4_Ratio
    hero.TitanMS_atk4_MR = hero.attribs.MR * atk4_Ratio
    hero.TitanMS_atk4_HIT = hero.attribs.HIT * atk4_Ratio
    hero.TitanMS_atk4_DODG = hero.attribs.DODG * atk4_Ratio
    hero.TitanMS_rage_AD = hero.attribs.CRIT * rage_Ratio
    hero.TitanMS_rage_LFS = hero.attribs.LFS * rage_Ratio
  elseif skillatk4 and hero.config.is_boss then
    local atk4_Ratio = skillatk4.info["Script Arg2"] / 100
    local rage_Ratio = skillatk4.info["Script Arg3"] / 100
    hero.TitanMS_atk4_AD = hero.attribs.AD * atk4_Ratio
    hero.TitanMS_atk4_ARM = hero.attribs.ARM * atk4_Ratio
    hero.TitanMS_atk4_MR = hero.attribs.MR * atk4_Ratio
    hero.TitanMS_rage_AD = hero.attribs.CRIT * rage_Ratio
  end
  hero.TitanMS_atk4RageLimit = 3
  if hero.TitanMS_hasArcana and 3 <= hero.TitanMS_hasArcana then
    hero.TitanMS_atk4RageLimit = 2
  end
end

function TitanMS.skillatk4_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanMS_atk4
  local atk4_Ratio = 1
  local rage_Ratio = 1
  caster.TitanMS_orbBuffLevel = math.min(caster.TitanMS_orbBuffLevel, TitanMS.TitanMS_atk4BuffLimit)
  if caster.TitanMS_effectFirstTime or caster.TitanMS_orbBuffLevel ~= caster.TitanMS_effectBuffNumPre then
    if ed.run_with_scene and caster.actor then
      local effect_name = TitanMS.TitanMS_akt4headEffectList[caster.TitanMS_orbBuffLevel + 1]
      local effect_id = caster.actor:addEffect(effect_name, 1)
      if caster.TitanMS_preEffectID then
        caster.actor.puppet:removeEffectWithID(caster.TitanMS_preEffectID)
      end
      caster.TitanMS_preEffectID = effect_id
    end
    if skillatk4 then
      if not caster.config.is_boss then
        buff:setAttribute("AD", caster.TitanMS_atk4_AD * caster.TitanMS_orbBuffLevel ^ 1.1)
        buff:setAttribute("ARMP", caster.TitanMS_atk4_ARMP * caster.TitanMS_orbBuffLevel ^ 1.1)
        buff:setAttribute("ARM", caster.TitanMS_atk4_ARM * caster.TitanMS_orbBuffLevel ^ 1.1)
        buff:setAttribute("MR", caster.TitanMS_atk4_MR * caster.TitanMS_orbBuffLevel ^ 1.1)
        buff:setAttribute("HIT", caster.TitanMS_atk4_HIT * caster.TitanMS_orbBuffLevel ^ 1.1)
        buff:setAttribute("DODG", caster.TitanMS_atk4_DODG * caster.TitanMS_orbBuffLevel ^ 1.1)
        caster:resetBuffApply(buff)
        caster.TitanMS_effectFirstTime = false
        caster.TitanMS_effectBuffNumPre = caster.TitanMS_orbBuffLevel
      else
        buff:setAttribute("AD", caster.TitanMS_atk4_AD * caster.TitanMS_orbBuffLevel ^ 1.1)
        buff:setAttribute("ARM", caster.TitanMS_atk4_ARM * caster.TitanMS_orbBuffLevel ^ 1.1)
        buff:setAttribute("MR", caster.TitanMS_atk4_MR * caster.TitanMS_orbBuffLevel ^ 1.1)
        caster:resetBuffApply(buff)
        caster.TitanMS_effectFirstTime = false
        caster.TitanMS_effectBuffNumPre = caster.TitanMS_orbBuffLevel
      end
    end
  elseif caster.TitanMS_orbBuffLevel == caster.TitanMS_effectBuffNunPre and caster.TitanMS_orbBuffLevel >= caster.TitanMS_atk4RageLimit and not caster.TitanMS_RageBuff then
    local bid = TitanMS.atk4RageBuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    if skillatk4 then
      if not caster.config.is_boss then
        buff:setAttribute("AD", caster.TitanMS_rage_AD)
        buff:setAttribute("LFS", caster.TitanMS_rage_LFS)
        caster:addBuff(buff)
        caster.TitanMS_RageBuff = true
      else
        buff:setAttribute("AD", caster.TitanMS_rage_AD)
        caster:addBuff(buff)
        caster.TitanMS_RageBuff = true
      end
    end
  end
  if not caster:isAlive() then
    buff.timer = -1
  end
end

function TitanMS.init_hero(hero)
  hero.update = override(hero.update, TitanMS.hero_update)
  hero.reset = override(hero.reset, TitanMS.hero_reset)
  hero.TitanMS_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillatk = hero.skills.TitanMS_atk
  local skillatk2 = hero.skills.TitanMS_atk2
  local skillatk3 = hero.skills.TitanMS_atk3
  local skillatk4 = hero.skills.TitanMS_atk4
  local skillult = hero.skills.TitanMS_ult
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanMS.skillatk2_start)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanMS.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanMS.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanMS.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, TitanMS.skillatk3_finish)
  end
  if skillatk4 then
    hero.collectHPchange = override(hero.collectHPchange, TitanMS.hero_collectHPchange)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanMS.skillult_start)
    skillult.power = override(skillult.power, TitanMS.skillult_power)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanMS.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, TitanMS.skillult_finish)
  end
  return hero
end

return TitanMS.init_hero
