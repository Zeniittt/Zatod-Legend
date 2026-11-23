module("ed.battlehero", package.seeall)
local ed = ed
CWTitan = {}
CWTitan.CWTitan_atk4hurt = 4785

function CWTitan.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.StunRatio = 0.1
end

function CWTitan.skillatk_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local ratio = ed.rand()
  if ratio < caster.StunRatio + 0.2 then
    local bid = 4782
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
  basefunc(skill, target, source)
end

function CWTitan.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  caster.StunRatio = caster.StunRatio + 0.1
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function CWTitan.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4786
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  caster.position[1] = 400 - 450 * caster:getInitDir()
  caster.walk_v = {
    250 * caster:getInitDir(),
    0
  }
  caster.StunRatio = caster.StunRatio + 0.1
  basefunc(skill, target)
end

function CWTitan.skillatk3_onAttackFrame(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  local caster = skill.caster
  local skillatk3s = caster.skills.CWTitan_atk3s
  if skill.attack_counter == 0 then
    basefunc(skill)
  elseif skill.attack_counter == 1 then
    skillatk3s:takeEffectAt(caster.position)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function CWTitan.atk4buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.hp <= 1 then
    if caster and caster ~= owner then
      owner:die(caster)
    else
      owner:die()
    end
    return
  end
  basefunc(buff, dt)
end

function CWTitan.inverseLerp(from, to, value)
  return (value - from) / (to - from)
end

function CWTitan.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred, damageinfo)
  local amount = struct_table
  local skill
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
    skill = struct_table.skill
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  if not hero:isAlive() then
    return
  end
  local defence, dd, dc, immunity, crit
  if damage_type == "AD" then
    defence = math.max(0, hero.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = hero.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, hero.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = hero.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + hero.attribs.ALLIMU
  local crit_prob = crit / (100 + dc) * crit_mod
  local bCrit = crit_prob > ed.rand()
  local crit_val
  if damage_type == "AD" then
    crit_val = source.attribs.CSD
  elseif damage_type == "AP" then
    crit_val = source.attribs.MCSD
  end
  local crit_multiplier = bCrit and (crit_val and crit_val * 0.01 + 2 or 2) or 1
  amount = math.max(0, amount)
  local damage = amount * amount / (amount + dd * coefficient)
  damage = damage * crit_multiplier * source.attribs.PDM
  if ed.debug_mode and hero.camp ~= ed.emCampPlayer then
    damage = damage * ((ed.gmconfig or {}).attack_ratio or 1)
  end
  if 100 <= immunity then
    if ed.run_with_scene then
      local color = hero.camp == ed.emCampEnemy and "red" or "blue"
      local adimm = hero.attribs.PIMU >= 100
      local apimm = hero.attribs.MIMU >= 100
      local str
      if adimm and apimm or hero.attribs.ALLIMU >= 100 then
        str = "immune"
      elseif adimm then
        str = "physical_immune"
      else
        str = "magic_immune"
      end
      ed.PopupCreate(str, color, hero.actor, nil, "text")
    end
    return 0
  end
  for _, buff in ipairs(hero.buff_list) do
    damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  end
  if damage <= 0 then
    return 0
  end
  local lost = hero:getLostHPAfterImmunity(damage, immunity, damage_type)
  local originlost = lost
  local hurtPercent = 0.1
  local isHigh
  local skillatk4a = hero.skills.CWTitan_atk4a
  local bearPercent = skillatk4a.info["Script Arg3"] / 100
  local buff_timer = skillatk4a.info["Script Arg4"]
  local bearlost
  if lost then
    isHigh = true
    if lost then
      bearlost = lost * bearPercent
      lost = lost - bearlost
    end
  end
  local damage = math.min(hero.hp, lost)
  damage = damage * hero.dPSStatisticsRatio
  if source ~= hero then
    source.battledata:addDamage(damage, damage_type)
    hero.battledata:addBearDamage(damage)
  end
  if do_battle_log then
    btlog("    %s lost %d %s %s", hero:display(), lost, field, bCrit and "(Crit!)" or "")
  end
  local oldLostHpPer = (hero.attribs.HP - hero.hp) / hero.attribs.HP
  if field == "hp" then
    hero:setHP(hero.hp - lost)
    if hero.hp == 0 then
      hero:onDying(source)
    else
      if hero.state == CWTitan.emUnitState_Birth then
      elseif hero.current_skill and not hero.current_skill.info.Interruptable then
      elseif hero.buff_effects.uncontrollable then
      else
        local interruptHpRatio = hero.attribs["Interrupt HP Ratio"] / 100
        local intr = hero.attribs.INTR or 0
        local interruptProbability
        if intr == 0 then
          interruptProbability = originlost <= hero.attribs.HP * interruptHpRatio and 0 or 1
        else
          interruptProbability = CWTitan.inverseLerp(hero.attribs.HP * interruptHpRatio, hero.attribs.HP * (interruptHpRatio + intr * 0.001), originlost)
        end
        local interrupt = false
        if interruptProbability <= 0 then
        elseif 1 <= interruptProbability then
          interrupt = true
        else
          interrupt = interruptProbability >= ed.rand()
        end
        if not interrupt then
        else
          hero:hurt()
          if do_battle_log then
            btlog("    %s was interrupted.", hero:display())
          end
        end
      end
      local mp_gain = originlost * (hero.info["MP Gain Rate"] / hero.attribs.HP) * (hero.attribs.MPRatio * 0.01 + 1)
      hero:setMP(hero.mp + mp_gain * ed.engine.mp_bonus)
    end
    if isHigh then
      local buffOriginInfo = ed.lookupDataTable("Buff", nil, CWTitan.CWTitan_atk4hurt)
      local atk4buff
      local atk4buff_time = skillatk4a.info["Script Arg4"]
      local newHPR = -bearlost / atk4buff_time
      local atk4BuffInfo = ed.wraptable(buffOriginInfo, {HPR = newHPR, Time = atk4buff_time})
      if source then
        atk4buff = ed.BuffCreate(atk4BuffInfo, hero, source)
      else
        print("no source!!")
        atk4buff = ed.BuffCreate(atk4BuffInfo, hero, hero)
      end
      atk4buff.update = override(atk4buff.update, CWTitan.atk4buff_update)
      hero:addBuff(atk4buff)
    end
  elseif field == "mp" then
    hero:setMP(hero.mp - originlost)
  end
  hero:unfreezeActor()
  if hero.actor then
    local str = "-" .. math.floor(lost + 0.5)
    if str ~= "-0" then
      local color
      if field == "mp" then
        color = "yellow"
      elseif hero.camp == ed.emCampPlayer then
        color = "red"
      else
        color = "orange"
      end
      ed.PopupCreate(str, color, hero.actor, bCrit)
      if hero.monster_idx then
        local lostHpPer = (hero.attribs.HP - hero.hp) / hero.attribs.HP
        ed.scene:showMonsterLoots(ed.engine.wave_id, hero, lostHpPer, oldLostHpPer)
      end
    end
  end
  return lost
end

function CWTitan.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk4a = self.skills.CWTitan_atk4a
  if skillatk4a and unit.camp ~= self.camp and not unit.config.is_summoned then
    for _, debuff in ipairs(self.buff_list) do
      if debuff.info.ID == CWTitan.CWTitan_atk4hurt then
        debuff.timer = 0
      end
    end
  end
end

function CWTitan.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for _, debuff in ipairs(caster.buff_list) do
    if debuff.info.ID == CWTitan.CWTitan_atk4hurt then
      debuff.timer = 0
    end
  end
  local caster = skill.caster
  local bid = 4786
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  caster.StunRatio = caster.StunRatio + 0.1
end

function CWTitan.init_hero(hero)
  local skillult = hero.skills.CWTitan_ult
  local skillatk = hero.skills.CWTitan_atk
  local skillatk2 = hero.skills.CWTitan_atk2
  local skillatk3 = hero.skills.CWTitan_atk3
  local skillatk4 = hero.skills.CWTitan_atk4
  local skillatk4a = hero.skills.CWTitan_atk4a
  hero.reset = override(hero.reset, CWTitan.hero_reset)
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, CWTitan.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, CWTitan.skillatk2_start)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, CWTitan.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, CWTitan.skillatk3_onAttackFrame)
  end
  if skillatk4a then
    hero.takeDamage = override(hero.takeDamage, CWTitan.hero_takeDamage)
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, CWTitan.hero_handleUnitDieEvent)
  end
  if skillult then
    skillult.start = override(skillult.start, CWTitan.skillult_start)
  end
  return hero
end

return CWTitan.init_hero
