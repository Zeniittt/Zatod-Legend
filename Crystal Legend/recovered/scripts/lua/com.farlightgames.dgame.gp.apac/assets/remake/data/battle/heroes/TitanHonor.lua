module("ed.battlehero", package.seeall)
local ed = ed
local math = ed.math
TitanHonor = {}
TitanHonor.ult_selfBuff = 4810
TitanHonor.ult_shield_buffid = 4814
TitanHonor.invulnerableBuff = 4815

function TitanHonor.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanHonor_atk4
  if caster and caster.TitanHonor_hasArcana and caster.TitanHonor_hasArcana >= 3 and skillatk4 and isHit then
    local DmgtoShield = skillatk4.info["Script Arg2"] / 100 + 0.3
    local atk4_AddShield = dmg * DmgtoShield
    TitanHonor.add_Shield(caster, atk4_AddShield)
  end
  return isHit, dmg, Crit, lfs_amount
end

function TitanHonor.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local info = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter then
    skill:takeEffectAt(caster.position, caster)
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanHonor.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanHonor_atk4
  if caster and caster.TitanHonor_hasArcana and caster.TitanHonor_hasArcana >= 3 and skillatk4 and isHit then
    local DmgtoShield = skillatk4.info["Script Arg2"] / 100 + 0.3
    local atk4_AddShield = dmg * DmgtoShield
    TitanHonor.add_Shield(caster, atk4_AddShield)
  end
  return isHit, dmg, Crit, lfs_amount
end

function TitanHonor.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local info = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter then
    skill:takeEffectAt(caster.position, caster)
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function TitanHonor.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanHonor_atk4
  if caster and caster.TitanHonor_hasArcana and caster.TitanHonor_hasArcana >= 3 and skillatk4 and isHit then
    local DmgtoShield = skillatk4.info["Script Arg2"] / 100 + 0.3
    local atk4_AddShield = dmg * DmgtoShield
    TitanHonor.add_Shield(caster, atk4_AddShield)
  end
  return isHit, dmg, Crit, lfs_amount
end

function TitanHonor.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanHonor_atk4
  if skillatk4 and isHit then
    local DmgtoShield = skillatk4.info["Script Arg2"] / 100 + 0.3
    local atk4_AddShield = dmg * DmgtoShield
    TitanHonor.add_Shield(caster, atk4_AddShield)
  end
  return isHit, dmg, Crit, lfs_amount
end

function TitanHonor.skillatk4_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  if caster.TitanHonor_hasArcana and caster.TitanHonor_hasArcana >= 4 then
    crit_mod = 999999
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg
end

function TitanHonor.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if skill.casting then
    return false
  else
    return result, reason
  end
end

function TitanHonor.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster and caster:isAlive() then
    if caster.TitanHonor_invulnerableBuff then
      caster.TitanHonor_invulnerableBuff.timer = -1
    end
    local bid = TitanHonor.ult_selfBuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff.onDamaged = override(buff.onDamaged, TitanHonor.ultBuff_onDamaged)
    buff.onRemoved = override(buff.onRemoved, TitanHonor.ultBuff_onRemoved)
    buff.update = override(buff.update, TitanHonor.ultBuff_update)
    caster.TitanHonor_hasULtBuff = true
    if not caster.config.is_boss then
      caster:addBuff(buff, caster)
    end
  end
end

function TitanHonor.ultBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  if damage and 0 < damage then
    local originDMG = damage
    caster.TitanHonor_ultDMG = caster.TitanHonor_ultDMG + damage
    if not caster.rageStack then
      caster.rageStack = 0
    end
    if caster.TitanHonor_ultDMG > caster.INITHP * 0.2 then
      caster.rageStack = caster.rageStack + 1
      caster.rageStack = math.min(caster.rageStack, caster.maxrageStack)
      caster.TitanHonor_AD_DMG = caster.TitanHonor_ultDMG + caster.TitanHonor_AD_DMG
      caster.TitanHonor_ultDMG = 0
    end
    local mp_gain = originDMG * (caster.info["MP Gain Rate"] / caster.attribs.HP) * (caster.attribs.MPRatio * 0.01 + 1) * 0.8
    caster:setMP(caster.mp + mp_gain * ed.engine.mp_bonus)
    damage = 0
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred)
end

function TitanHonor.ultBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillult = caster.skills.TitanHonor_ult
  local ADRatio = skillult.info["Script Arg2"] / 100
  if caster.lastrageStack and caster.rageStack and caster.lastrageStack ~= caster.rageStack then
    buff:setAttribute("AD", math.min(caster.TitanHonor_AD_DMG * ADRatio, (0.3 + caster.stars * 0.02) * caster.attribs.AD))
    buff:setAttribute("HAST", math.min(15 * 1.125 ^ caster.rageStack, 30))
    buff:setAttribute("MSPD", math.min(15 * 1.125 ^ caster.rageStack, 30))
    caster:resetBuffApply(buff)
    caster.lastrageStack = caster.rageStack
    caster.lastrageStack = math.min(caster.lastrageStack, caster.maxrageStack)
    caster.TitanHonor_ultDMG = 0
  end
end

function TitanHonor.ultBuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillult = caster.skills.TitanHonor_ult
  local ShieldHealRatio = skillult.info["Script Arg3"] / 100
  caster.TitanHonor_ultDMG = 0
  caster.TitanHonor_AD_DMG = 0
  caster.lastrageStack = 0
  caster.rageStack = 0
  caster.TitanHonor_hasULtBuff = false
  if caster and caster:isAlive() then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.shield and 0 <= tbuff.shield and tbuff.info["Shield Type"] ~= "mp" then
        tbuff.timer = -1
        caster:takeHeal(tbuff.shield * ShieldHealRatio, "HP", caster)
      end
    end
  end
  basefunc(buff)
end

function TitanHonor.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function TitanHonor.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanHonor_atk4
  if caster and caster.TitanHonor_hasArcana and caster.TitanHonor_hasArcana >= 3 and skillatk4 and isHit then
    local DmgtoShield = skillatk4.info["Script Arg2"] / 100
    local atk4_AddShield = dmg * DmgtoShield
    TitanHonor.add_Shield(caster, atk4_AddShield)
  end
  return isHit, dmg, Crit, lfs_amount
end

function TitanHonor.add_Shield(hero, shield_vaule)
  if not hero.TitanHonor_shield then
    local bid = TitanHonor.ult_shield_buffid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local shield_buff = ed.BuffCreate(binfo, hero, hero)
    shield_buff.onRemoved = override(shield_buff.onRemoved, TitanHonor.shield_onRemoved)
    shield_buff.shield = shield_vaule
    hero.TitanHonor_shield = hero:addBuff(shield_buff, hero)
  else
    local buff = hero.TitanHonor_shield
    local shield = buff.shield
    buff.shield = shield + shield_vaule
    buff.timer = buff.info.Time
    if buff.shield <= 0 and hero.TitanHonor_shield then
      hero:removeBuff(hero.TitanHonor_shield)
    end
  end
end

function TitanHonor.shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanHonor_shield = nil
end

function TitanHonor.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local TotalDamage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local caster = self
  if not (caster and caster:isAlive() and TotalDamage and 0 < TotalDamage) or caster.TitanHonor_hasULtBuff then
  end
  return TotalDamage, bc
end

function TitanHonor.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanHonor_ultDMG = 0
  hero.TitanHonor_AD_DMG = 0
  hero.INITHP = hero.attribs.HP
  hero.lastrageStack = 0
  hero.rageStack = 0
  hero.maxrageStack = 5
  hero.ult_castTime = 0
  hero.ultCanCast = 0
  hero.TitanHonor_hasULtBuff = false
end

function TitanHonor.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.TitanHonor_ult
  if not hero.ult_castTime then
    hero.ult_castTime = 0
  end
  hero.ult_castTime = hero.ult_castTime + dt
  if skillult and not hero.config.is_boss and hero.ult_castTime == 1 and hero.TitanHonor_hasArcana and hero.TitanHonor_hasArcana >= 2 then
    hero.ultCanCast = 1
  end
end

function TitanHonor.hero_onDying(basefunc, self, killer)
  local caster = self
  local skillult = caster.skills.TitanHonor_ult
  if caster.ultCanCast and caster.ultCanCast > 0 then
    local bid = TitanHonor.invulnerableBuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster.TitanHonor_invulnerableBuff = caster:addBuff(buff, caster)
    caster:castSkill(skillult, caster)
    caster.ultCanCast = caster.ultCanCast - 1
    caster.can_cast_manual = false
  else
    basefunc(self, killer)
  end
end

function TitanHonor.init_hero(hero)
  local skillult = hero.skills.TitanHonor_ult
  local skillatk = hero.skills.TitanHonor_atk
  local skillatk2 = hero.skills.TitanHonor_atk2
  local skillatk3 = hero.skills.TitanHonor_atk3
  local skillatk4 = hero.skills.TitanHonor_atk4
  hero.TitanHonor_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.update = override(hero.update, TitanHonor.hero_update)
  hero.reset = override(hero.reset, TitanHonor.hero_reset)
  hero.onDying = override(hero.onDying, TitanHonor.hero_onDying)
  hero.takeDamage = override(hero.takeDamage, TitanHonor.hero_takeDamage)
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanHonor.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, TitanHonor.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanHonor.skillult_takeEffectOn)
    skillult.createBuff = override(skillult.createBuff, TitanHonor.skillult_createBuff)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanHonor.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanHonor.skillatk2_takeEffectOn)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanHonor.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanHonor.skillatk3_takeEffectOn)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanHonor.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanHonor.skillatk4_takeEffectOn)
    skillatk4.getDamage = override(skillatk4.getDamage, TitanHonor.skillatk4_getDamage)
  end
  return hero
end

return TitanHonor.init_hero
