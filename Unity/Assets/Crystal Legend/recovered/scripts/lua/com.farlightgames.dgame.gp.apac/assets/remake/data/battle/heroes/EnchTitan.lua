module("ed.battlehero", package.seeall)
local ed = ed
EnchTitan = {}

function EnchTitan.shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.EnchTitan_shield = nil
end

function EnchTitan.add_Shield(hero, shield_vaule)
  local max = 250000
  if not hero.EnchTitan_shield then
    local bid = 4817
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local shield_buff = ed.BuffCreate(binfo, hero, hero)
    shield_buff.onRemoved = override(shield_buff.onRemoved, EnchTitan.shield_onRemoved)
    shield_buff.onDamaged = override(shield_buff.onDamaged, EnchTitan.skillult_buffonDamaged)
    shield_buff.shield = shield_vaule
    hero.EnchTitan_shield = hero:addBuff(shield_buff, hero)
    if max < shield_buff.shield then
      shield_buff.shield = max
    end
  else
    local buff = hero.EnchTitan_shield
    local shield = buff.shield
    buff.shield = shield + shield_vaule
    buff.timer = buff.info.Time
    if buff.shield <= 0 and hero.EnchTitan_shield then
      hero:removeBuff(hero.EnchTitan_shield)
    end
    if max < buff.shield then
      buff.shield = max
    end
  end
end

function EnchTitan.skillult_buffonDamaged(basefunc, buff, damage, damage_type, source, skill)
  local owner = buff.owner
  local caster = buff.caster
  if owner.camp == caster.camp and damage and 0 < damage and damage_type ~= "Heal" and source and source:isHero() and ed.rand() < 0.5 then
    local bid = 4820
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    source:addBuff(binfo, caster)
  end
  return basefunc(buff, damage, damage_type, source, skill)
end

function EnchTitan.skillult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target)
  local skillult = hero.skills.EnchTitan_ult
  local caster = skill.caster
  local heal = caster.attribs.HEAL or 0
  local power, coefficient = skill:power(source, target, "HP")
  local power = power * (1 + heal / 100)
  local ult_ShieldValue = power * (math.max((target.attribs.HealRatio or 0) / 100, -1) + 1)
  local ult_hp_gap = target.attribs.HP - target.hp
  if ult_ShieldValue > ult_hp_gap and target.camp == caster.camp and skillult and target and not target.config.is_summoned then
    local ult_AddShield = ult_ShieldValue - ult_hp_gap
    EnchTitan.add_Shield(target, ult_AddShield)
  end
end

function EnchTitan.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
  basefunc(skill, target)
end

function EnchTitan.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
  basefunc(skill, target)
end

function EnchTitan.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  if type(struct_table) == "table" then
    if struct_table.source and struct_table.source.info.Gender == T("\231\148\183") then
      self.Gender = T("\231\148\183")
      local skillatk4a = self.skills.EnchTitan_atk4a
      if skillatk4a then
        local bid = 4819
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = struct_table.source:addBuff(binfo, self)
      end
    end
  elseif source and source.info.Gender == T("\231\148\183") then
    self.Gender = T("\231\148\183")
    local skillatk4a = self.skills.EnchTitan_atk4a
    if skillatk4a then
      local bid = 4819
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = source:addBuff(binfo, self)
    end
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function EnchTitan.init_hero(hero)
  local skillult = hero.skills.EnchTitan_ult
  local skillatk = hero.skills.EnchTitan_atk
  local skillatk2 = hero.skills.EnchTitan_atk2
  local skillatk3 = hero.skills.EnchTitan_atk3
  local skillatk4 = hero.skills.EnchTitan_atk4
  local skillatk4a = hero.skills.EnchTitan_atk4a
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, EnchTitan.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, EnchTitan.skillatk2_start)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, EnchTitan.skillatk3_start)
  end
  if skillatk4a then
    hero.takeDamage = override(hero.takeDamage, EnchTitan.hero_takeDamage)
  end
  return hero
end

return EnchTitan.init_hero
