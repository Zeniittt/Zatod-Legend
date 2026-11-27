module("ed.battlehero", package.seeall)
local ed = ed
TitanJJ = {}
TitanJJ.ult_bleed_buff = 11017501
TitanJJ.atk3_Monitor_buff = 11017503
TitanJJ.atk3_Stun_buff = 11017504
TitanJJ.TitanJJ_fashion_id = 1101751
TitanJJ.ragelosthp = 35000
TitanJJ.rage2losthp = 15000
TitanJJ.stage2hp = 1750000
TitanJJ.stage2ragelosthp = 7500

function TitanJJ.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
end

function TitanJJ.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile.hit = override(projectile.hit, TitanJJ.skillatk2_Projectile_hit)
  return projectile
end

function TitanJJ.skillatk2_Projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  if target == skill.target then
    basefunc(projectile, target)
    projectile:terminate()
  else
    basefunc(projectile, target)
  end
end

function TitanJJ.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local AD_caster = caster.attribs.AD
  local AD_target = target.attribs.AD
  local AD_Plus = AD_caster - AD_target
  if caster.TitanJJ_hasArcana and caster.TitanJJ_hasArcana >= 2 then
    if 0 <= AD_Plus then
      AD_Plus = math.min(AD_Plus, AD_caster)
      power = power + AD_Plus * (caster.stars / 10 + 1)
    else
      AD_Plus = math.max(AD_Plus, -AD_caster * 2)
      power = power + math.abs(AD_Plus) * (caster.stars / 10)
    end
  end
  return power
end

function TitanJJ.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and caster.hasTitanJJ_atk4 then
    local skillatk4 = caster.skills.TitanJJ_atk4
    if skillatk4 then
      local MP_down = skillatk4.info["Script Arg2"]
      target:takeDamage(MP_down, "Holy", "mp", skill.caster, 1, 1)
    end
  end
end

function TitanJJ.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if TitanJJ.TitanJJ_fashion_id and TitanJJ.TitanJJ_fashion_id == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_TitanJJ_skin_atk3.cha")
  end
  if buff then
    buff.update = override(buff.update, TitanJJ.skillatk3_BuffUpdate)
    buff.onRemoved = override(buff.onRemoved, TitanJJ.skillatk3_BuffonRemoved)
  end
  return buff
end

function TitanJJ.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if not caster.atk3_power then
    caster.atk3_power = power
  else
    local info = skill.info
    local multiplier = info["Plus Ratio"]
    local base_attrib = info["Plus Attr"] and caster.attribs[info["Plus Attr"]] or 0
    caster.atk3_power = multiplier * base_attrib + info["Basic Num"]
  end
  return power, coefficient
end

function TitanJJ.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk3 = caster.skills.TitanJJ_atk3
  basefunc(skill)
  if caster.TitanJJ_hasArcana and caster.TitanJJ_hasArcana >= 3 then
    local maxMP_target, maxUnit
    local maxmp = 0
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if not unit.buff_effects.untargetable and unit ~= target and not unit.config.is_summoned and maxmp <= unit.mp then
        maxUnit = unit
        maxmp = unit.mp
      end
    end
    if maxUnit then
      maxMP_target = maxUnit
    end
    if maxMP_target then
      maxMP_target:addBuff(skillatk3:createBuff(maxMP_target))
    end
  end
end

function TitanJJ.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and caster.hasTitanJJ_atk4 then
    local skillatk4 = caster.skills.TitanJJ_atk4
    if skillatk4 then
      local MP_down = skillatk4.info["Script Arg2"]
      target:takeDamage(MP_down, "Holy", "mp", skill.caster, 1, 1)
    end
  end
end

function TitanJJ.collectMPchange(basefunc, self, config)
  local unit = config.unit
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == TitanJJ.atk3_Monitor_buff and config.mp > unit.mp then
      unit.hasTouchTitanJJATK3 = true
    end
  end
end

function TitanJJ.skillatk3_BuffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = caster.skills.TitanJJ_atk3
  local MP_Down = skillatk3.info["Script Arg2"]
  if caster and not caster:isAlive() then
    buff.timer = -1
  end
  if owner and caster and owner.hasTouchTitanJJATK3 and MP_Down then
    owner:takeDamage(MP_Down, "Holy", "mp", caster, 1, 1)
    buff.timer = -1
    if ed.run_with_scene then
      local effect_name = "eff_impact_TitanJJ_atk3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, owner.position, {
        owner.direction * 1,
        1
      }, nil, 1)
    end
  end
end

function TitanJJ.skillatk3_BuffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = caster.skills.TitanJJ_atk3
  local StunTime = skillatk3.info["Script Arg3"]
  if caster and owner and owner:isAlive() and StunTime and owner.hp >= 1 and not ed.engine.beingEnd and not owner.buff_effects.invulnerable then
    local bid = TitanJJ.atk3_Stun_buff
    local binfo = ed.lookupDataTable("Buff", nil, TitanJJ.atk3_Stun_buff)
    local buff = ed.BuffCreate(binfo, owner, caster)
    buff.timer = StunTime
    owner:addBuff(buff, caster)
    if caster.atk3_power then
      owner:takeDamage(caster.atk3_power, "Holy", "hp", caster, 1, 1)
    else
      local info = skillatk3.info
      local multiplier = info["Plus Ratio"]
      local base_attrib = info["Plus Attr"] and caster.attribs[info["Plus Attr"]] or 0
      caster.atk3_power = multiplier * base_attrib + info["Basic Num"]
      owner:takeDamage(caster.atk3_power, "Holy", "hp", caster, 1, 1)
    end
  end
  if owner.hasTouchTitanJJATK3 then
    owner.hasTouchTitanJJATK3 = false
  end
end

function TitanJJ.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
end

function TitanJJ.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if TitanJJ.TitanJJ_fashion_id and TitanJJ.TitanJJ_fashion_id == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_TitanJJ_skin_atk4.cha")
  end
  if buff and owner then
    buff.onRemoved = override(buff.onRemoved, TitanJJ.skillatk4_BuffonRemoved)
    owner.hasTitanJJ_atk4 = true
  end
  return buff
end

function TitanJJ.skillatk4_BuffonRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  if owner then
    if ed.run_with_scene then
      local effect_name = "eff_buff_TitanJJ_atk4_2.cha"
      if TitanJJ.TitanJJ_fashion_id and TitanJJ.TitanJJ_fashion_id == caster.fashion_id then
        effect_name = "eff_buff_TitanJJ_skin_atk4_2.cha"
      end
      local effect = ed.scene:playEffectOnScene(effect_name, owner.position, {
        owner.direction * 1,
        1
      }, nil, -1)
    end
    owner.hasTitanJJ_atk4 = false
  end
end

function TitanJJ.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unit.buff_effects.invulnerable and unit.camp ~= caster.camp then
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
  else
    return {400, 0}
  end
end

function TitanJJ.skillult_willCast(basefunc, skill)
  local ret = basefunc(skill)
  if skill.casting then
    ret = false
  end
  return ret
end

function TitanJJ.skillult_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  if skill.casting then
    result = false
  end
  return result
end

function TitanJJ.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.TitanJJ_ult
  if attack_counter and 0 <= attack_counter then
    local AttackPosition = TitanJJ.DOP_in_battlefield(caster, 150, caster.foecamp)
    if AttackPosition then
      if attack_counter == 0 then
        if ed.run_with_scene then
          local effect_name1 = "eff_point_TitanJJ_ult.cha"
          if TitanJJ.TitanJJ_fashion_id and TitanJJ.TitanJJ_fashion_id == caster.fashion_id then
            effect_name1 = "eff_point_TitanJJ_skin_ult.cha"
          end
          local effect = ed.scene:playEffectOnScene(effect_name1, AttackPosition, {
            caster.direction * 1,
            1
          }, nil, 1)
          local effect_name2 = "eff_point_TitanJJ_ult_2.cha"
          if TitanJJ.TitanJJ_fashion_id and TitanJJ.TitanJJ_fashion_id == caster.fashion_id then
            effect_name2 = "eff_point_TitanJJ_skin_ult_2.cha"
          end
          local effect = ed.scene:playEffectOnScene(effect_name2, AttackPosition, {
            caster.direction * 1,
            1
          }, nil, -1)
        end
        skill.attack_counter = skill.attack_counter + 1
        if caster.manually_casting then
          ed.engine:unfreeze()
          caster.manually_casting = false
        end
      else
        skillult:takeEffectAt(AttackPosition, caster)
        skill.attack_counter = skill.attack_counter + 1
      end
    end
  end
end

function TitanJJ.skillult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local BleedTime = skill.info["Script Arg3"]
  local BleedNum = skill.info["Script Arg2"]
  if caster and caster.hasTitanJJ_atk4 then
    local skillatk4 = caster.skills.TitanJJ_atk4
    if skillatk4 then
      local MP_down = skillatk4.info["Script Arg2"]
      target:takeDamage(MP_down, "Holy", "mp", skill.caster, 1, 1)
    end
  end
  if caster.TitanJJ_hasArcana and caster.TitanJJ_hasArcana >= 4 then
    local AD_caster = caster.attribs.AD
    local AD_target = target.attribs.AD
    local AD_Plus = AD_caster - AD_target
    if 0 <= AD_Plus then
      AD_Plus = math.min(AD_Plus, AD_caster)
      AD_Plus = AD_Plus * (caster.stars / 10 + 1)
      target:takeDamage(AD_Plus, "Holy", "hp", skill.caster, 1, 1)
    else
      AD_Plus = math.max(AD_Plus, -AD_caster * 2)
      AD_Plus = math.abs(AD_Plus * (caster.stars / 10))
      target:takeDamage(AD_Plus, "Holy", "hp", skill.caster, 1, 1)
    end
  end
end

function TitanJJ.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanJJ.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanJJ.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanJJ.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= TitanJJ.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanJJ.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanJJ.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, TitanJJ.rage_buff_update)
  hero.lastrageStack = 0
end

function TitanJJ.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function TitanJJ.init_hero(hero)
  local skillatk = hero.skills.TitanJJ_atk
  local skillult = hero.skills.TitanJJ_ult
  local skillatk2 = hero.skills.TitanJJ_atk2
  local skillatk3 = hero.skills.TitanJJ_atk3
  local skillatk4 = hero.skills.TitanJJ_atk4
  hero.TitanJJ_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.update = override(hero.update, TitanJJ.hero_update)
  hero.reset = override(hero.reset, TitanJJ.hero_reset)
  hero.collectMPchange = override(hero.collectMPchange, TitanJJ.collectMPchange)
  if skillult then
    skillult.willCast = override(skillult.willCast, TitanJJ.skillult_willCast)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanJJ.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanJJ.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanJJ.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanJJ.skillatk2_takeEffectOn)
    skillatk2.start = override(skillatk2.start, TitanJJ.skillatk2_start)
    skillatk2.power = override(skillatk2.power, TitanJJ.skillatk2_power)
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanJJ.skillatk2_createProjectile)
    if TitanJJ.TitanJJ_fashion_id and TitanJJ.TitanJJ_fashion_id == hero.fashion_id then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Tile Art"] = "eff_tile_TitanJJ_skin_atk2.cha"
      })
    end
  end
  if skillatk3 then
    skillatk3.power = override(skillatk3.power, TitanJJ.skillatk3_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanJJ.skillatk3_takeEffectOn)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanJJ.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanJJ.skillatk3_createBuff)
    if TitanJJ.TitanJJ_fashion_id and TitanJJ.TitanJJ_fashion_id == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Impact Effect"] = "eff_impact_TitanJJ_skin_atk3.cha"
      })
    end
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanJJ.skillatk4_createBuff)
    skillatk4.start = override(skillatk4.start, TitanJJ.skillatk4_start)
  end
  return hero
end

return TitanJJ.init_hero
