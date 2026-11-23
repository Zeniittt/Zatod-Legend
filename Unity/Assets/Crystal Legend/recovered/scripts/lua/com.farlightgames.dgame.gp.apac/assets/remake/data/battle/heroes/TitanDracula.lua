module("ed.battlehero", package.seeall)
local ed = ed
TitanDracula = {}
TitanDracula.TitanDracula_arcana2BidEnemy = 4774
TitanDracula.TitanDracula_arcana2Bid = 4775
TitanDracula.TitanDracula_arcana3Bid = 4776
TitanDracula.TitanDracula_arcana4Bid = 4777

function TitanDracula.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  basefunc(skill, target)
end

function TitanDracula.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  if owner:isAlive() and caster:isAlive() and caster.direction * (owner.position[1] - caster.position[1]) > 0 then
    local TimeRatio = 1
    local Time = buff.info.Time
    if math.abs(owner.position[1] - caster.position[1]) <= 75 then
      TimeRatio = 1.5
    elseif math.abs(owner.position[1] - caster.position[1]) <= 125 then
      TimeRatio = 1.35
    elseif math.abs(owner.position[1] - caster.position[1]) <= 175 then
      TimeRatio = 1.2
    end
    buff.info.Time = Time * TimeRatio
    buff.timer = Time * TimeRatio
  end
  return buff
end

function TitanDracula.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local PowerRatio = 1
  if target:isAlive() and caster:isAlive() and caster.direction * (target.position[1] - caster.position[1]) > 0 then
    if math.abs(target.position[1] - caster.position[1]) <= 75 then
      PowerRatio = 2
      power = power * PowerRatio
      return power * PowerRatio
    elseif math.abs(target.position[1] - caster.position[1]) <= 125 then
      PowerRatio = 1.5
      power = power * PowerRatio
      return power * PowerRatio
    elseif math.abs(target.position[1] - caster.position[1]) <= 175 then
      PowerRatio = 1.25
      power = power * PowerRatio
      return power * PowerRatio
    end
  end
  return power * PowerRatio
end

function TitanDracula.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and isHit and caster.TitanDracula_hasArcana and caster.TitanDracula_hasArcana > 2 then
    local bid2 = TitanDracula.TitanDracula_arcana2Bid
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, caster, caster)
    buff2:setAttribute("LFS", target.attribs.LFS)
    caster:addBuff(buff2, caster)
    local bid1 = TitanDracula.TitanDracula_arcana2BidEnemy
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, target, caster)
    buff1:setAttribute("LFS", -target.attribs.LFS)
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function TitanDracula.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local TimeRatio = 1
  if owner:isAlive() and caster:isAlive() then
    local Time = buff.info.Time
    if owner.hp / owner.attribs.HP <= 0.25 then
      TimeRatio = 1.5
    elseif owner.hp / owner.attribs.HP <= 0.5 then
      TimeRatio = 1.35
    elseif owner.hp / owner.attribs.HP <= 0.75 then
      TimeRatio = 1.2
    end
    buff.info.Time = Time * TimeRatio
    buff.timer = Time * TimeRatio
  end
  return buff
end

function TitanDracula.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and isHit and caster.TitanDracula_hasArcana and caster.TitanDracula_hasArcana > 2 then
    local bid2 = TitanDracula.TitanDracula_arcana2Bid
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, caster, caster)
    buff2:setAttribute("LFS", target.attribs.LFS)
    caster:addBuff(buff2, caster)
    local bid1 = TitanDracula.TitanDracula_arcana2BidEnemy
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, target, caster)
    buff1:setAttribute("LFS", -target.attribs.LFS)
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function TitanDracula.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  local KnockBackRatio = 1
  local knockBackDis = 100
  if caster and caster:isAlive() then
    if caster.hp / caster.attribs.HP >= 0.75 then
      KnockBackRatio = 1.5
    elseif caster.hp / caster.attribs.HP >= 0.5 then
      KnockBackRatio = 1.35
    elseif caster.hp / caster.attribs.HP >= 0.25 then
      KnockBackRatio = 1.2
    end
  end
  skill.info = ed.wraptable(originfo, {
    ["Knock Back"] = knockBackDis * KnockBackRatio
  })
  basefunc(skill, target)
end

function TitanDracula.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local TimeRatio = 1
  if owner:isAlive() and caster:isAlive() then
    local Time = buff.info.Time
    if caster.hp / caster.attribs.HP >= 0.75 then
      TimeRatio = 1.5
    elseif caster.hp / caster.attribs.HP >= 0.5 then
      TimeRatio = 1.35
    elseif caster.hp / caster.attribs.HP >= 0.25 then
      TimeRatio = 1.2
    end
    buff.info.Time = Time * TimeRatio
    buff.timer = Time * TimeRatio
  end
  return buff
end

function TitanDracula.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and isHit and caster.TitanDracula_hasArcana and caster.TitanDracula_hasArcana >= 2 then
    local bid2 = TitanDracula.TitanDracula_arcana2Bid
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, caster, caster)
    buff2:setAttribute("LFS", target.attribs.LFS)
    caster:addBuff(buff2, caster)
    local bid1 = TitanDracula.TitanDracula_arcana2BidEnemy
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, target, caster)
    buff1:setAttribute("LFS", -target.attribs.LFS)
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function TitanDracula.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  local HPR_Ratio = skill.info["Script Arg2"] / 100
  local skillults = caster.skills.TitanDracula_ults
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local bid = TitanDracula.TitanDracula_arcana3Bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.timer = skillults.info["Script Arg1"]
  if caster and caster.TitanDracula_hasArcana >= 3 then
    buff:setAttribute("HPR", caster.attribs.HP * (0.03 + HPR_Ratio))
  else
    buff:setAttribute("HPR", caster.attribs.HP * HPR_Ratio)
  end
  caster:addBuff(buff, caster)
  caster.arcana3buff = buff
  basefunc(skill, target)
end

function TitanDracula.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if caster and caster:isAlive() then
    local region_position = {
      caster.position[1],
      0
    }
    caster.ult_region_position = region_position
    local skillultsregion = caster.skills.TitanDracula_ults
    if skill.ults_region then
      skill.ults_region:terminate()
    end
    if skillultsregion then
      skillultsregion.target = caster
      local region = skillultsregion:createRegion()
      region.position = region_position
      skill.ults_region = region
      caster.ults_region = region
      ed.engine:addRegion(region)
    end
  end
  basefunc(skill)
end

function TitanDracula.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and isHit and caster.TitanDracula_hasArcana and caster.TitanDracula_hasArcana >= 2 then
    local bid2 = TitanDracula.TitanDracula_arcana2Bid
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, caster, caster)
    buff2:setAttribute("LFS", target.attribs.LFS)
    caster:addBuff(buff2, caster)
    local bid1 = TitanDracula.TitanDracula_arcana2BidEnemy
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, target, caster)
    buff1:setAttribute("LFS", -target.attribs.LFS)
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function TitanDracula.skillults_createRegion(basefunc, skill)
  local ultregion = basefunc(skill)
  ultregion.update = override(ultregion.update, TitanDracula.ultregion_update)
  ultregion.terminate = override(ultregion.terminate, TitanDracula.ultregion_terminate)
  return ultregion
end

function TitanDracula.ultregion_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  local skillult = caster.skills.TitanDracula_ult
  if not caster.ult_hitTime then
    caster.ult_hitTime = 0
  end
  caster.ult_hitTime = dt + caster.ult_hitTime
  if caster.ult_hitTime and caster.ult_hitTime == 1.5 then
    caster.ult_hitTime = 0
    skillult:takeEffectAt(caster.position, caster)
  end
  if caster.ults_region then
    region.position = caster.position
  end
end

function TitanDracula.ultregion_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  if caster and caster.arcana3buff then
    caster.arcana3buff.timer = -1
  end
end

function TitanDracula.skills_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = power
  local caster = skill.caster
  if caster.arcana4DMG then
    power2 = power + caster.arcana4DMG / 4
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function TitanDracula.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  local damage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if type(struct_table) == "table" then
    if struct_table.source then
      local source = struct_table.source
      if struct_table.source.info.Gender == T("\229\165\179") then
        self.Gender = T("\229\165\179")
      end
    end
  elseif source and source.info.Gender == T("\229\165\179") then
    self.Gender = T("\229\165\179")
  end
  return damage, bc
end

function TitanDracula.skills_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  local skillult = self.skills.TitanDracula_ult
  if self.Gender == T("\229\165\179") and skillult then
    local reduce = skillult.info["Script Arg5"] / 100
    damage = damage * (1 - reduce)
  end
  return basefunc(self, damage, immunity)
end

function TitanDracula.hero_die(basefunc, hero)
  basefunc(hero)
  if hero.ults_region then
    hero.ults_region:terminate()
  end
end

function TitanDracula.hero_collectHPchange(basefunc, self, config)
  local unit = config.unit
  local hero = self
  if hero:isHero() and config.hp_change < 0 then
    local HP_change = -config.hp_change
    if hero.arcana4DMG then
      hero.arcana4DMG = HP_change * 0.25 + hero.arcana4DMG
      hero.arcana4DMG = math.min(hero.arcana4DMG, hero.attribs.HP)
    end
  end
end

function TitanDracula.hero_reset(basefunc, hero)
  basefunc(hero)
  if hero.TitanDracula_hasArcana and hero.TitanDracula_hasArcana >= 4 then
    hero.arcana4DMG = 0
  end
end

function TitanDracula.init_hero(hero)
  hero.die = override(hero.die, TitanDracula.hero_die)
  hero.reset = override(hero.reset, TitanDracula.hero_reset)
  hero.takeDamage = override(hero.takeDamage, TitanDracula.hero_takeDamage)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanDracula.skills_getLostHPAfterImmunity)
  local skillult = hero.skills.TitanDracula_ult
  local skillults = hero.skills.TitanDracula_ults
  local skillatk = hero.skills.TitanDracula_atk
  local skillatk2 = hero.skills.TitanDracula_atk2
  local skillatk3 = hero.skills.TitanDracula_atk3
  local skillatk4 = hero.skills.TitanDracula_atk4
  hero.TitanDracula_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if hero.TitanDracula_hasArcana and hero.TitanDracula_hasArcana >= 4 then
    hero.collectHPchange = override(hero.collectHPchange, TitanDracula.hero_collectHPchange)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanDracula.skillatk2_start)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanDracula.skillatk2_createBuff)
    skillatk2.power = override(skillatk2.power, TitanDracula.skillatk2_power)
    skillatk2.getDamage = override(skillatk2.getDamage, TitanDracula.skills_getDamage)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanDracula.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanDracula.skillatk3_createBuff)
    skillatk3.getDamage = override(skillatk3.getDamage, TitanDracula.skills_getDamage)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanDracula.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanDracula.skillatk4_start)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanDracula.skillatk4_createBuff)
    skillatk4.getDamage = override(skillatk4.getDamage, TitanDracula.skills_getDamage)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanDracula.skillatk4_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanDracula.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanDracula.skillult_onAttackFrame)
    skillult.getDamage = override(skillult.getDamage, TitanDracula.skills_getDamage)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanDracula.skillult_takeEffectOn)
  end
  if skillults then
    skillults.createRegion = override(skillults.createRegion, TitanDracula.skillults_createRegion)
  end
  return hero
end

return TitanDracula.init_hero
