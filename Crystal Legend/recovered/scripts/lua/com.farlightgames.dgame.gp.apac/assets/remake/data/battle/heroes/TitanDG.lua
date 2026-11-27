module("ed.battlehero", package.seeall)
local ed = ed
TitanDG = {}
TitanDG.LifeFlame = 4520
TitanDG.TitanDG_babyinvBuffID = 4523
TitanDG.TitanDG_fashionID = 101351

function TitanDG.skillatk2_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, TitanDG.skillatk2_buffOnDamaged)
  buff.onRemoved = override(buff.onRemoved, TitanDG.skillatk2_buffOnRemoved)
  if caster then
    caster.atk2_flameTime = buff.timer
  end
  if owner then
    owner.HasTianDG_lifeFlame = false
    local stunbid = 105
    local binfo = ed.lookupDataTable("Buff", nil, stunbid)
    local buff = ed.BuffCreate(binfo, owner, caster)
    buff.timer = skill.info["Script Arg2"]
    local con_temp = 0
    if caster.attribs.CON then
      con_temp = caster.attribs.CON
    end
    if target.attribs.TEN then
      buff.timer = math.floor(buff.timer * (1 - (target.attribs.TEN - con_temp) / 100))
    else
      buff.timer = buff.timer
    end
    owner:addBuff(buff, caster)
  end
  return buff
end

function TitanDG.skillatk2_buffOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  if caster and owner and source and (source == caster or source.config.summoner == caster) and skill and skill.info.Name ~= "TitanDG_atk" then
    buff.timer = caster.atk2_flameTime
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

function TitanDG.skillatk2_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  if caster and owner then
    owner.HasTianDG_lifeFlame = false
  end
  return basefunc(buff)
end

function TitanDG.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if caster and target and ed.run_with_scene then
    local effect_name = "eff_point_DK_atk2b.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, {
      caster.position[1] - 40 * caster.direction,
      caster.position[2]
    }, {
      caster.direction,
      1
    }, nil, 1)
  end
end

function TitanDG.skillatk3_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if caster and owner and caster.TitanDG_hasArcana and caster.TitanDG_hasArcana >= 3 then
    buff.onDamaged = override(buff.onDamaged, TitanDG.skillatk3_buffOnDamaged)
  end
  return buff
end

function TitanDG.skillatk3_buffOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = caster.info.TitanDG_atk3
  if caster and owner and source and source.camp ~= caster.camp and damage and 0 < damage and (damage_type == "AD" or damage_type == "AP") and not transferred then
    damage = math.min(damage * 0.5, caster.attribs.HP)
    transferred = true
    source:takeDamage(damage, damage_type, "hp", caster, 1, 1, transferred)
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

function TitanDG.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and target then
    local skillatk3 = caster.skills.TitanDG_atk3
    local DGbaby_lifeTime = skillatk3.info["Script Arg2"]
    if skillatk3 then
      local BabyCount = 1
      if caster.TitanDG_hasArcana and caster.TitanDG_hasArcana >= 2 then
        BabyCount = 2
      end
      local proto = {
        _tid = 316,
        _level = skill.level or 1,
        _skill_levels = {
          [1] = skill.level,
          [2] = skill.level
        },
        _stars = caster.stars,
        _rank = caster.rank
      }
      local config = {
        is_monster = true,
        is_summoned = true,
        estimate_rank = true,
        hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
        dps_mod = caster.config.dps_mod or 1
      }
      for i = 1, BabyCount do
        local TitanDGBaby = ed.UnitCreate(proto, caster.camp, config)
        TitanDGBaby.DGbaby_lifeTime = DGbaby_lifeTime
        local range_x = 65
        local range_y = 30
        local xs = 40
        local ys = 10
        local xxs = ed.rand() * 2 * range_x + xs - range_x
        local yys = ed.rand() * 2 * range_y + ys - range_y
        local location = {
          target.position[1] + xxs * target.direction,
          target.position[2] + yys
        }
        TitanDGBaby.direction = target.direction
        local DG_babyskillatk3 = TitanDGBaby.skills.TitanDGbaby_atk3
        TitanDGBaby.update = override(TitanDGBaby.update, TitanDG.TitanDGBaby_update)
        DG_babyskillatk3.onAttackFrame = override(DG_babyskillatk3.onAttackFrame, TitanDG.TitanDGBaby_atk3OnAttackFrame)
        local untargetBuffInfo = ed.lookupDataTable("Buff", nil, TitanDG.TitanDG_babyinvBuffID)
        TitanDGBaby:addBuff(untargetBuffInfo, caster)
        ed.engine:summonUnit(TitanDGBaby, location, caster)
        table.insert(caster.TitanDG_babyList, TitanDGBaby)
      end
    end
  end
end

function TitanDG.TitanDGBaby_update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit:isAlive() then
    if not unit.TitanDGBaby then
      unit.TitanDGBaby = 0
      unit.TitanDGBaby_dead = false
    end
    unit.TitanDGBaby = unit.TitanDGBaby + dt
    if unit.TitanDGBaby >= unit.DGbaby_lifeTime then
      unit:die()
    end
  end
end

function TitanDG.TitanDGBaby_atk3OnAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local hero = caster.config.summoner
  local target = skill.target
  if hero and caster and target then
    local skillatk2 = hero.skills.TitanDG_atk2
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == TitanDG.LifeFlame then
        target.HasTianDG_lifeFlame = true
        local con_temp = 0
        local dur = tbuff.info.Time
        if caster.attribs.CON then
          con_temp = caster.attribs.CON
        end
        if target.attribs.TEN then
          tbuff.timer = math.floor(dur * (1 - (target.attribs.TEN - con_temp) / 100))
        else
          tbuff.timer = dur
        end
      end
    end
    if target.HasTianDG_lifeFlame ~= true and skillatk2 then
      local binfo = skillatk2.info.buff_info
      local LifeFlameBuff = ed.BuffCreate(binfo, target, hero)
      LifeFlameBuff.onRemoved = override(LifeFlameBuff.onRemoved, TitanDG.skillatk2_buffOnRemoved)
      target:addBuff(LifeFlameBuff, hero)
      target.HasTianDG_lifeFlame = true
    end
  end
end

function TitanDG.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if caster and caster and target then
    local skillatk2 = caster.skills.TitanDG_atk2
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == TitanDG.LifeFlame then
        target.HasTianDG_lifeFlame = true
        local con_temp = 0
        local dur = tbuff.info.Time
        if caster.attribs.CON then
          con_temp = caster.attribs.CON
        end
        if target.attribs.TEN then
          tbuff.timer = math.floor(dur * (1 - (target.attribs.TEN - con_temp) / 100))
        else
          tbuff.timer = dur
        end
      end
    end
    if target.HasTianDG_lifeFlame ~= true and skillatk2 then
      local binfo = skillatk2.info.buff_info
      local LifeFlameBuff = ed.BuffCreate(binfo, target, caster)
      LifeFlameBuff.onRemoved = override(LifeFlameBuff.onRemoved, TitanDG.skillatk2_buffOnRemoved)
      target:addBuff(LifeFlameBuff, caster)
      target.HasTianDG_lifeFlame = true
    end
  end
end

function TitanDG.skillatk4_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skillatk4 = caster.skills.TitanDG_atk4
  local HealRatio = skillatk4.info["Script Arg2"] / 100
  if skillatk4 and target then
    local MinHPUnit
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit and not unit.buff_effects.invisible and unit:isHero() then
        local unitHP = unit.hp
        local MinHP = math.huge
        if unitHP < MinHP then
          MinHP = unitHP
          MinHPUnit = unit
        end
      end
    end
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == TitanDG.LifeFlame and tbuff.timer > 0 then
        tbuff.timer = -1
        damage_type = "Holy"
        power = power * math.min(HealRatio, 1.5)
        if MinHPUnit then
          MinHPUnit:takeHeal(power * math.min(HealRatio, 1.5), "hp", caster)
        end
      end
    end
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function TitanDG.isCrlEftConflictWithUncontrollableSP(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function TitanDG.skillult_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if caster and owner then
    if caster.TitanDG_hasArcana and caster.TitanDG_hasArcana >= 4 then
      buff.timer = buff.timer + 5
    end
    caster.ultBuffTime = buff.timer
    owner.TitanDG_ultBuff = true
    if owner.config.is_summoned then
      buff.timer = -1
    end
    buff.onRemoved = override(buff.onRemoved, TitanDG.TitanDG_ultbuffonRemoved)
    if TitanDG.TitanDG_fashionID and caster.fashion_id == TitanDG.TitanDG_fashionID then
      local fashion_ult_Ratio = 0.3
      buff:setAttribute("AD", owner.attribs.AD * fashion_ult_Ratio)
      buff:setAttribute("AP", owner.attribs.AP * fashion_ult_Ratio)
      buff:setAttribute("ARM", owner.attribs.ARM * fashion_ult_Ratio)
      buff:setAttribute("MR", owner.attribs.MR * fashion_ult_Ratio)
      buff:setAttribute("Shader", "FireShader")
    end
  end
  return buff
end

function TitanDG.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanDG_ult
  if skillult and caster and caster:isAlive() then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.config.is_summoned then
      else
        local list = unit.buff_list
        local debuff_list = {}
        local my_camp = caster.camp
        for i = 1, #list do
          local buff = list[i]
          local info = buff.info
          if buff and (not buff.caster or buff.caster.camp ~= my_camp) and (TitanDG.isCrlEftConflictWithUncontrollableSP(buff) or buff.info.Dispel == "YES") then
            debuff_list[#debuff_list + 1] = buff
          end
        end
        for i = 1, #debuff_list do
          unit:removeBuff(debuff_list[i])
        end
      end
    end
  end
end

function TitanDG.TitanDG_ultbuffonRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner and owner.TitanDG_ultBuff then
    owner.TitanDG_ultBuff = false
  end
end

function TitanDG.hero_collectBuff(basefunc, self, config)
  if config then
    local buff = config.buff
    local owner = buff.owner
    local caster = buff.caster
    local hero = self
    local skillult = hero.skills.TitanDG_ult
    if skillult and owner and owner.TitanDG_ultBuff and (not caster or type(caster.tid) ~= "number" or not (caster.tid > 100000)) and hero:isAlive() and not buff.TitanDG_trigger then
      if (TitanDG.isCrlEftConflictWithUncontrollableSP(buff) or buff.info.Dispel == "YES") and caster.camp ~= hero.camp and caster.camp ~= owner.camp then
        local TitanDG_ult_TimeRatio = skillult.info["Script Arg2"] / 100
        TitanDG_ult_TimeRatio = TitanDG_ult_TimeRatio + hero.fashion_ult_Ratio
        buff.timer = buff.timer * (1 - TitanDG_ult_TimeRatio)
      end
      local TitanDG_ultRatio = skillult.info["Script Arg3"] / 100
      local info = buff.info
      local attribs = owner.attribs
      local buff_attribs = {}
      TitanDG_ultRatio = TitanDG_ultRatio + hero.fashion_ult_Ratio
      for name, value in pairs(info) do
        if name == "HP" or name == "MP" or name == "HPR" or name == "MPR" or name == "ALLMIMU" or name == "STR" or name == "AGI" or name == "INT" or name == "CDR" or name == "Time" then
        elseif not value or value and type(value) == "number" and 0 <= value then
        elseif attribs[name] then
          if not buff_attribs[name] then
            buff_attribs[name] = value
          else
            buff_attribs[name] = value + buff_attribs[name]
          end
        end
      end
      if not owner.config.is_boss then
        for name, value in pairs(buff_attribs) do
          buff:setAttribute(name, -value * TitanDG_ultRatio)
        end
      end
      buff.TitanDG_trigger = true
    end
  end
end

function TitanDG.hero_die(basefunc, hero, killer)
  for _, unit in ipairs(hero.TitanDG_babyList) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function TitanDG.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanDG_babyList = {}
  if TitanDG.TitanDG_fashionID and hero.fashion_id == TitanDG.TitanDG_fashionID then
    hero.fashion_ult_Ratio = 0.3
  else
    hero.fashion_ult_Ratio = 0
  end
end

function TitanDG.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.TitanDG_ult
  local skillatk = hero.skills.TitanDG_atk
  local skillatk2 = hero.skills.TitanDG_atk2
  local skillatk3 = hero.skills.TitanDG_atk3
  local skillatk4 = hero.skills.TitanDG_atk4
end

function TitanDG.init_hero(hero)
  hero.reset = override(hero.reset, TitanDG.hero_reset)
  hero.update = override(hero.update, TitanDG.hero_update)
  hero.collectBuff = override(hero.collectBuff, TitanDG.hero_collectBuff)
  hero.die = override(hero.die, TitanDG.hero_die)
  hero.TitanDG_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.TitanDG_ult
  local skillatk = hero.skills.TitanDG_atk
  local skillatk2 = hero.skills.TitanDG_atk2
  local skillatk3 = hero.skills.TitanDG_atk3
  local skillatk4 = hero.skills.TitanDG_atk4
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanDG.skillult_CreateBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanDG.skillult_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanDG.skillatk2_CreateBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanDG.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanDG.skillatk3_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanDG.skillatk3_CreateBuff)
  end
  if skillatk4 then
    skillatk4.getDamage = override(skillatk4.getDamage, TitanDG.skillatk4_getDamage)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanDG.skillatk4_onAttackFrame)
  end
  return hero
end

return TitanDG.init_hero
