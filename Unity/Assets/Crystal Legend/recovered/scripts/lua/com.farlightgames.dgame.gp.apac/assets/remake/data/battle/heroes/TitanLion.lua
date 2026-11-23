module("ed.battlehero", package.seeall)
local ed = ed
TitanLion = {}
TitanLion.TitanLionAtk4Bid = 1574
TitanLion.TitanLionultselfBid = 1577

function TitanLion.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanLion_atk2
  local skillatk2s = caster.skills.TitanLion_atk2s
  if skillatk2 and not caster.config.is_summoned and caster:isAlive() then
    if skill.attack_counter == 2 then
      local target = skillatk2s:selectTarget(nil)
      if target then
        local projectile = skillatk2s:createProjectile()
      end
    else
      basefunc(skill)
    end
  end
end

function TitanLion.atk2s_selectTarget(skill)
  local target = skill.target
  local maxhp = 0
  local maxunit
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.buff_effects.untargetable and 0 < caster.direction * (unit.position[1] - caster.position[1]) and maxhp <= unit.hp then
      maxunit = unit
      maxhp = unit.hp
    end
  end
  if maxunit then
    target = maxunit
    skill.target = maxunit
  end
  return target
end

function TitanLion.atk2s_createProjectile(basefunc, skill)
  local caster = skill.caster
  local target = skill.caster
  local projectile = basefunc(skill, target)
  projectile.terminate = override(projectile.terminate, TitanLion.atk2s_projectil_terminate)
  projectile.Alive_time = 10
  ed.engine:addProjectile(projectile)
end

function TitanLion.atk2s_projectile_hit(basefunc, self, target)
  local caster = self.caster
  local skill = self.skill
  local skillatk2 = caster.skills.TitanLion_atk2
  if skillatk2 and caster:isAlive() and target and target.actor then
    if target ~= skill.target then
      return
    else
      local effect_name = "eff_impact_TitanLion_atk2.cha"
      if effect_name then
        target.actor:addEffect(effect_name, -1)
      end
      if self.actor and self.actor.node then
        self.actor.node:setVisible(false)
      end
      basefunc(self, target)
    end
  end
end

function TitanLion.atk2s_projectil_terminate(basefunc, self)
  local projectile = self
  local end_position = self.position
  local caster = self.caster
  if end_position and projectile then
    local effect_name = "eff_point_TitanLion_atk2.cha"
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(effect_name, {
        end_position[1],
        end_position[2]
      }, {
        caster.direction * 0.8,
        0.8
      }, nil, 1)
    end
  end
  basefunc(self)
end

function TitanLion.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanLion_atk3
  local skillatk3s = caster.skills.TitanLion_atk3s
  local skillatk3s2 = caster.skills.TitanLion_atk3s2
  local TitanLionregion
  if skill.attack_counter == 0 and caster:isAlive() and skillatk3 and skillatk3s and skillatk3s2 and not caster.config.is_summoned then
    caster.skillatk3s_dir = caster.direction
    caster.skillatk3s_pos = {
      caster.position[1] + 5 * caster.direction,
      caster.position[2]
    }
    skillatk3s2:takeEffectOn(caster, caster)
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if 0 < caster.direction * (caster.position[1] - unit.position[1]) and not unit.buff_effects.polymorph then
        local bid = 1576
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local uncontrollable_buff = ed.BuffCreate(binfo, unit, caster)
        uncontrollable_buff.timer = caster.TitanLion_hasArcana and 2 < caster.TitanLion_hasArcana and 4 or 2
        local buff = unit:addBuff(uncontrollable_buff, caster)
      end
    end
  end
  basefunc(skill)
end

function TitanLion.skillatk3s2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.onRemoved = override(buff.onRemoved, TitanLion.defenceBuff_onRemoved)
  if caster.atk3s2_defenceBuff then
    caster.atk3s2_defenceBuff.timer = 0
    caster.atk3s2_defenceBuff = nil
  end
  caster.atk3s2_defenceBuff = buff
  local effect_name = "eff_point_TitanLion_atk3.cha"
  if ed.run_with_scene then
    if not effect_name then
      return
    end
    buff.atk3s2Effect = ed.scene:playEffectOnScene(effect_name, {
      caster.position[1],
      caster.position[2]
    }, {
      caster.direction * 0.8,
      0.8
    }, nil, 1)
  end
  return buff
end

function TitanLion.defenceBuff_onRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  basefunc(buff)
  if ed.run_with_scene and buff.atk3s2Effect then
    local z = 1
    ed.scene:removeEffect(buff.atk3s2Effect, z)
  end
  if owner.name == "TitanLion" and owner.atk3s2_defenceBuff then
    owner.atk3s2_defenceBuff.timer = 0
    owner.atk3s2_defenceBuff = nil
  end
end

function TitanLion.skillatk3s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff:setAttribute("Effect", "eff_tile_TS_atk2.cha")
  buff.timer = buff.timer + 9999
  local skillatk3 = caster.skills.TitanLion_atk3
  local Shield_extarDamageValue = skillatk3.info["Script Arg3"] + math.floor(caster.attribs.STR / 1000)
  buff.extraDamageValue = -Shield_extarDamageValue / 100
  buff.checkExtraDamageCondition = override(buff.checkExtraDamageCondition, TitanLion.atk3s_buff_checkExtraDamageCondition)
  caster.atk3_defenceBuff = buff
  return buff
end

function TitanLion.atk3s_buff_checkExtraDamageCondition(basefunc, buff, source, damage_type, power)
  local damageChange = false
  local caster = buff.caster
  local owner = buff.owner
  local sourceHero = source and source.caster or source
  local skillatk3 = caster.skills.TitanLion_atk3
  local skillatk3s = caster.skills.TitanLion_atk3s
  if not (caster.name == "TitanLion" and caster:isAlive()) or not caster.atk3s2_defenceBuff then
  elseif not sourceHero then
  elseif caster.camp ~= owner.camp or caster.camp == sourceHero.camp then
  elseif not (caster.skillatk3s_pos and owner.position and sourceHero.position) or not caster.skillatk3s_dir then
  elseif caster.skillatk3s_dir * (caster.skillatk3s_pos[1] - owner.position[1]) < 0 then
  elseif (caster.skillatk3s_pos[1] - owner.position[1]) * (caster.skillatk3s_pos[1] - sourceHero.position[1]) > 0 then
  else
    damageChange = true
  end
  return damageChange
end

function TitanLion.inverseLerp(from, to, value)
  return (value - from) / (to - from)
end

function TitanLion.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred, damageinfo)
  if not hero:isAlive() or hero.buff_effects.invulnerable then
    return
  end
  local amount = struct_table
  local skillTags, skill
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
    skill = struct_table.skill
    skillTags = skill and skill.info["Skill Tags"]
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  local defence, dd, dc, immunity, crit
  local level = hero.level
  if damage_type == "AD" then
    defence = math.max(0, hero.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = hero.attribs.PIMU or 0
    dd = math.max(0, defence * 8)
    dc = math.max(0, defence * 8)
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
  if skill and skill ~= nil then
    if skill.info["Do Crit"] == "YES" then
      bCrit = true
    elseif skill.info["Do Crit"] == "NO" then
      bCrit = false
    end
  end
  local crit_val
  if damage_type == "AD" then
    crit_val = source.attribs.CSD
  elseif damage_type == "AP" then
    crit_val = source.attribs.MCSD
  end
  local crit_multiplier = 1
  if bCrit then
    crit_multiplier = crit_val and crit_val * 0.01 + 2 or 2
    if damage_type == "AD" then
      crit_multiplier = math.max(1, crit_multiplier - hero.attribs.CSDR * 0.01)
    elseif damage_type == "AP" then
      crit_multiplier = math.max(1, crit_multiplier - hero.attribs.MCSDR * 0.01)
    end
  end
  amount = math.max(0, amount or 0)
  local dp = math.max(1, amount + dd * coefficient)
  local damage = amount * amount / dp
  if dd < 0 then
    dp = amount + math.abs(dd * coefficient) / 2
    damage = amount * (1 + math.abs(dd / dp * 0.5))
  end
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
      if not hero.notPopupBattleInfo then
        ed.PopupCreate(str, color, hero.actor, nil, "text")
      end
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
  local isHigh
  local skillatk4 = hero.skills.TitanLion_atk4
  local bearMAX = skillatk4.info["Script Arg3"] + math.ceil(hero.attribs.STR) * 0.7
  local highHurt = 15000
  local bearlost
  if lost >= highHurt then
    isHigh = true
    if lost >= bearMAX then
      bearlost = bearMAX
      lost = lost - bearlost
    else
      bearlost = lost
      lost = 0
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
      if hero.state == TitanLion.emUnitState_Birth then
      elseif hero.current_skill and not hero.current_skill.info.Interruptable then
      elseif hero.buff_effects.uncontrollable then
      else
        local interruptHpRatio = hero.attribs["Interrupt HP Ratio"] / 100
        local intr = hero.attribs.INTR or 0
        local interruptProbability
        if intr == 0 then
          interruptProbability = originlost <= hero.attribs.HP * interruptHpRatio and 0 or 1
        else
          interruptProbability = TitanLion.inverseLerp(hero.attribs.HP * interruptHpRatio, hero.attribs.HP * (interruptHpRatio + intr * 0.001), originlost)
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
      local buffOriginInfo = ed.lookupDataTable("Buff", nil, TitanLion.TitanLionAtk4Bid)
      local TitanLionAtk4_buff
      local skillatk4 = hero.skills.TitanLion_atk4
      local skillatk4_time = skillatk4.info["Script Arg2"]
      local TitanLionATk4_BTime = buffOriginInfo.Time + skillatk4_time
      local newHPR = -bearlost / TitanLionATk4_BTime
      local buffawakeInfo = ed.wraptable(buffOriginInfo, {HPR = newHPR, Time = TitanLionATk4_BTime})
      if source then
        TitanLionAtk4_buff = ed.BuffCreate(buffawakeInfo, hero, source)
      else
        TitanLionAtk4_buff = ed.BuffCreate(buffawakeInfo, hero, hero)
      end
      TitanLionAtk4_buff.update = override(TitanLionAtk4_buff.update, TitanLion.TitanLionATk4Buff_update)
      hero:addBuff(TitanLionAtk4_buff)
      if hero.TitanLion_hasArcana and hero.TitanLion_hasArcana > 3 and not hero.atk4_arcana_buff then
        local bid = 4320
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, hero, hero)
        buff:setAttribute("ARM", hero.attribs.ARM * 0.45)
        buff:setAttribute("MR", hero.attribs.MR * 0.45)
        hero:addBuff(buff, hero)
        hero.atk4_arcana_buff = true
        buff.onRemoved = override(buff.onRemoved, TitanLion.atk4_arcana_buff_OnRemoved)
      end
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
  return lost, bCrit
end

function TitanLion.atk4_arcana_buff_OnRemoved(basefunc, buff)
  local owner = buff.owner
  owner.atk4_arcana_buff = false
  basefunc(buff)
end

function TitanLion.TitanLionATk4Buff_update(basefunc, buff, dt)
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

function TitanLion.ult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.ult_powerup_count = 0
  if caster.name == "TitanLion" and not caster.config.is_summoned then
    local bid = TitanLion.TitanLionultselfBid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster.TitanLionultselfBuff = caster:addBuff(buff, caster)
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanLion.TitanLionAtk4Bid then
        tbuff.timer = -1
        tbuff:onRemoved()
      end
    end
  end
end

function TitanLion.ult_finish(basefunc, skill)
  local caster = skill.caster
  if caster.name == "TitanLion" and not caster.config.is_summoned and caster:isAlive() then
    for _, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanLion.TitanLionultselfBid then
        tbuff.timer = -1
      end
    end
  end
  basefunc(skill)
end

function TitanLion.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buff_effects.untargetable then
        elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  end
  if maxcount <= 0 then
    return false
  end
end

function TitanLion.ult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.TitanLion_ult
  local skillults = caster.skills.TitanLion_ults
  local originfo = skillult.info
  if skillult and caster:isAlive() then
    if skill.attack_counter == 0 then
      caster.TitanLion_oriPosition = {
        caster.position[1],
        caster.position[2]
      }
      skillult:takeEffectAt(caster.position)
      skill.attack_counter = skill.attack_counter + 1
    elseif skill.attack_counter == 1 then
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
        skill.caster.manually_casting = false
      end
      local Enemy_position = TitanLion.DOP_in_battlefield(caster, 100, caster.foecamp)
      if Enemy_position then
        caster:setPosition({
          Enemy_position[1],
          Enemy_position[2]
        })
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif skill.attack_counter == 2 then
      skill.info = ed.wraptable(originfo, {
        ["AOE Origin"] = "self",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 200
      })
      skillult:takeEffectAt(caster.position)
      skillults:takeEffectAt(caster.position)
      skill.attack_counter = skill.attack_counter + 1
    end
  end
  skill.info = originfo
end

function TitanLion.ult_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = power
  local caster = skill.caster
  if caster.ult_powerup_count <= 4 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanLion.TitanLionAtk4Bid then
        caster.ult_powerup_count = caster.ult_powerup_count + 1
        power2 = power2 * 1.2
        tbuff.timer = -1
        tbuff:onRemoved()
      end
    end
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function TitanLion.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.TitanLion_atk3
  local skillatk3s = hero.skills.TitanLion_atk3s
  local skillatk3s2 = hero.skills.TitanLion_atk3s2
  TitanLion.Hero_time = TitanLion.Hero_time + dt
  if skillatk3 and skillatk3s and skillatk3s2 and not hero.atk3_alreadyCreateRegion then
    hero.atk3_alreadyCreateRegion = true
    skillatk3s.target = hero
    local region_teammate = skillatk3s:createRegion()
    region_teammate.position[1] = region_teammate.position[1] + 1
    hero.TitanLion_atk3region = region_teammate
    ed.engine:addRegion(region_teammate)
  end
  if TitanLion.Hero_time == 2 then
  end
end

function TitanLion.hero_die(basefunc, hero)
  basefunc(hero)
  if hero.TitanLion_region then
    hero.TitanLion_atk3region:terminate()
  end
end

function TitanLion.hero_reset(basefunc, hero)
  basefunc(hero)
  TitanLion.Hero_time = 0
end

function TitanLion.TitanLion_skillallPower(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local power_Ratio = 0.1
  local power = power * power_Ratio
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

function TitanLion.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  return power * 1.3, i
end

function TitanLion.init_hero(hero)
  hero.reset = override(hero.reset, TitanLion.hero_reset)
  hero.update = override(hero.update, TitanLion.hero_update)
  hero.die = override(hero.die, TitanLion.hero_die)
  local skillult = hero.skills.TitanLion_ult
  local skillatk2 = hero.skills.TitanLion_atk2
  local skillatk2s = hero.skills.TitanLion_atk2s
  local skillatk3 = hero.skills.TitanLion_atk3
  local skillatk3s = hero.skills.TitanLion_atk3s
  local skillatk3s2 = hero.skills.TitanLion_atk3s2
  local skillatk4 = hero.skills.TitanLion_atk4
  local skillatk4s = hero.skills.TitanLion_atk4s
  hero.TitanLion_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.getDamage = override(skillult.getDamage, TitanLion.ult_getDamage)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanLion.skillatk2_onAttackFrame)
    if hero.TitanLion_hasArcana and hero.TitanLion_hasArcana > 1 then
      skillatk2.power = override(skillatk2.power, TitanLion.skillatk2_power)
    end
  end
  if skillatk2s then
    skillatk2s.createProjectile = override(skillatk2s.createProjectile, TitanLion.atk2s_createProjectile)
    if hero.TitanLion_hasArcana and hero.TitanLion_hasArcana > 1 then
      skillatk2s.power = override(skillatk2s.power, TitanLion.skillatk2_power)
    end
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanLion.skillatk3_onAttackFrame)
  end
  if skillatk3s then
    skillatk3s.createBuff = override(skillatk3s.createBuff, TitanLion.skillatk3s_createBuff)
  end
  if skillatk3s2 then
    skillatk3s2.createBuff = override(skillatk3s2.createBuff, TitanLion.skillatk3s2_createBuff)
  end
  if skillatk4 then
    hero.takeDamage = override(hero.takeDamage, TitanLion.hero_takeDamage)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanLion.ult_start)
    skillult.finish = override(skillult.finish, TitanLion.ult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanLion.ult_onAttackFrame)
  end
  local skillnames = {
    "_ult",
    "_atk",
    "_atk2",
    "_atk3",
    "_atk2s"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["TitanLion" .. skillnames[i]]
  end
  return hero
end

return TitanLion.init_hero
