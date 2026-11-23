module("ed.battlehero", package.seeall)
local ed = ed
TitanHisoka = {}
TitanHisoka.atk4_fearID = 4532
TitanHisoka.fearID = 4532
TitanHisoka.AGI_down = 4533
TitanHisoka.ULT_AGI_down = 4534
TitanHisoka.invulnerableBuff = 4535
TitanHisoka.uncontrollableBuff = 4536
TitanHisoka.TitanHisokaSkinBid = 4550
TitanHisoka.TitanHisokaSkinBid2 = 4551
TitanHisoka.TitanHisoka_fashionID = 101381

function TitanHisoka.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanHisoka_atk2
  if caster and skillatk2 then
    local invbid = TitanHisoka.uncontrollableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 1.3
    caster:addBuff(buff1, caster)
  end
end

function TitanHisoka.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local skillatk2 = caster.skills.TitanHisoka_atk2
  if caster and skillatk2 then
    local AGI_down = (100 - skillatk2.info["Script Arg2"]) / 100
    buff:setAttribute("AGI", -target.attribs.AGI * AGI_down)
  end
  buff.CreatedByHunterHunter = true
  caster.atk2BuffTimer = buff.timer
  return buff
end

function TitanHisoka.skillatk234_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanHisoka.uncontrollableBuff then
        tbuff.timer = -1
      end
    end
  end
end

function TitanHisoka.skillatk34_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster and target then
    local skillatk2 = caster.skills.TitanHisoka_atk2
    local skillatk3 = caster.skills.TitanHisoka_atk3
    local skillatk4 = caster.skills.TitanHisoka_atk4
    local bid = TitanHisoka.AGI_down
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local AGI_down = (100 - skillatk2.info["Script Arg2"]) / 100
    buff:setAttribute("AGI", -target.attribs.AGI * AGI_down)
    buff.CreatedByHunterHunter = true
    if caster.atk2BuffTimer then
      buff.timer = caster.atk2BuffTimer
    else
      buff.timer = 4 + skillatk2.level * 0.04
    end
    target:addBuff(buff, caster)
  end
  basefunc(skill, target, source, shift)
end

function TitanHisoka.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanHisoka_atk3
  if caster and skillatk3 then
    local invbid = TitanHisoka.uncontrollableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 2.5
    caster:addBuff(buff1, caster)
  end
end

function TitanHisoka.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanHisoka_atk3
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster and skillatk3 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and tbuff.info.AGI <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.AGI) + caster.attribs.AGI)
      end
    end
  end
  return power, coeff
end

function TitanHisoka.skillatk3_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local hero = skill.caster
  if hero and target then
    if target.direction == hero.direction then
      crit_mod = 999999
    end
  else
    crit_mod = crit_mod or 1
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg
end

function TitanHisoka.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanHisoka_atk4
  if caster and skillatk4 then
    local invbid = TitanHisoka.uncontrollableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    buff1.timer = 1.2
    caster:addBuff(buff1, caster)
  end
end

function TitanHisoka.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanHisoka_atk4
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster and skillatk3 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and tbuff.info.AGI <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.AGI) + caster.attribs.AGI)
      end
    end
  end
  caster.atk4_power = power
  return power, coeff
end

function TitanHisoka.skillatk4_CreateProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  projectile.terminate = override(projectile.terminate, TitanHisoka.atk4Projectile_terminate)
  projectile.atk4_get_target = false
  projectile.Targethas_TitanHisoka_atk4 = false
  caster.atk4_target = target
  return projectile
end

function TitanHisoka.atk4Projectile_terminate(basefunc, projectile)
  local caster = projectile.caster
  local target = caster.atk4_target
  if caster and target then
    caster.atk4_get_target = true
    if ed.run_with_scene then
      local effect_name = "eff_impact_TitanHisoka_atk4.cha"
      ed.scene:playEffectOnScene(effect_name, target.position, {
        -target.direction,
        1
      }, nil, 1)
    end
  end
  basefunc(projectile)
end

function TitanHisoka.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillult = caster.skills.TitanHisoka_ult
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster and skillult and caster.ult_slash then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and tbuff.info.AGI <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.AGI) + caster.attribs.AGI)
      end
    end
  end
  return power, coeff
end

function TitanHisoka.DOP_in_battlefield(caster, radius, camp)
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

function TitanHisoka.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local target = skill.target
  local skillult = skill
  caster.ult_slash = false
  if attack_counter and target then
    if attack_counter == 0 then
      local bid = TitanHisoka.invulnerableBuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.CreatedByHunterHunter = true
      buff.timer = 5
      caster:addBuff(buff, caster)
      caster.ult_originPosition = {
        caster.position[1],
        caster.position[2]
      }
      local PortalPosition = TitanHisoka.DOP_in_battlefield(caster, 200, caster.foecamp)
      caster:setPosition(PortalPosition)
      skill.attack_counter = skill.attack_counter + 1
    end
    if 1 <= attack_counter and attack_counter <= 4 then
      basefunc(skill)
      local bid = TitanHisoka.ULT_AGI_down
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      local AGI_down = (100 - skillult.info["Script Arg3"]) / 100
      buff:setAttribute("AGI", -target.attribs.AGI * AGI_down)
      buff.CreatedByHunterHunter = true
      buff.timer = buff.timer + skillult.info["Script Arg4"]
      target:addBuff(buff, caster)
    end
    if attack_counter == 5 then
      local MinHPUnit
      local MinHP = math.huge
      local protal_pos
      for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
        if unit and not unit.config.is_summoned and not unit.buff_effects.untargetable and not unit.buffManager.invisible then
          local unitHP = unit.hp
          if MinHP > unitHP then
            MinHP = unitHP
            MinHPUnit = unit
          end
        end
      end
      if MinHPUnit then
        caster.ult_minHPunit = MinHPUnit
        protal_pos = {
          MinHPUnit.position[1] + 1,
          MinHPUnit.position[2] + 1
        }
      else
        protal_pos = {
          caster.position[1],
          caster.position[2]
        }
      end
      caster:setPosition(protal_pos)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 6 then
      if caster.ult_minHPunit then
        local target = caster.ult_minHPunit
        local skillults = caster.skills.TitanHisoka_ults
        caster.ult_slash = true
        skillult:takeEffectOn(target)
        skillults:takeEffectAt(target.position, caster)
        caster.ult_slash = false
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 7 then
      caster:setPosition(caster.ult_originPosition)
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == TitanHisoka.invulnerableBuff then
          tbuff.timer = -1
        end
      end
      skill.attack_counter = skill.attack_counter + 1
      skill:finish()
    end
  end
end

function TitanHisoka.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanHisoka_ult
  local skillults = skill
  buff.CreatedByHunterHunter = true
  buff:setAttribute("fearrange", 3)
  if skillult and skillults then
    local buff_FearTime = 0
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.AGI and 0 >= tbuff.info.AGI then
        buff_FearTime = buff_FearTime + math.abs(tbuff.info.AGI * 0.01)
      end
    end
    buff.timer = math.min(buff.timer + buff_FearTime, 7)
  end
  return buff
end

function TitanHisoka.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.TitanHisoka_ult
  local skillults = hero.skills.TitanHisoka_ults
  if hero.change_aoe_index then
    hero.change_aoe_index = hero.change_aoe_index + dt
    if hero.change_aoe_index == dt then
      if hero and hero.TitanHisoka_hasArcana and hero.TitanHisoka_hasArcana >= 4 then
        local originfo = skillult.info
        skillult.info = ed.wraptable(originfo, {
          ["Target Type"] = "target",
          ["AOE Origin"] = "self",
          ["AOE Shape"] = "circle",
          ["Shape Arg1"] = 800
        })
        local originfos = skillults.info
        skillults.info = ed.wraptable(originfos, {
          ["Shape Arg1"] = 275
        })
      end
      if TitanHisoka.TitanHisoka_fashionID and TitanHisoka.TitanHisoka_fashionID == hero.fashion_id then
        local bid = TitanHisoka.TitanHisokaSkinBid2
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, hero, hero)
        buff.onDamaged = override(buff.onDamaged, TitanHisoka.skinBuff_onDamaged)
        hero.skinBufftime_tick = dt
        hero:addBuff(buff, hero)
      end
    end
  end
  local target = hero.atk4_target
  if hero and target then
    local skillatk4 = hero.skills.TitanHisoka_atk4
    local skillatk4s = hero.skills.TitanHisoka_atk4s
    local buff_FearTime = skillatk4.info["Script Arg2"]
    if hero.atk4_get_target then
      hero.atk4_2ndAttack_index = hero.atk4_2ndAttack_index + dt
      if hero.atk4_2ndAttack_index >= 0.5 then
        hero.atk4_get_target = false
        hero.atk4_2ndAttack_trigger = true
        hero.atk4_2ndAttack_index = 0
      end
    end
    if hero.atk4_2ndAttack_trigger then
      hero.atk4_2ndAttack_trigger = false
      skillatk4:takeEffectOn(target, hero)
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == hero.camp and tbuff.info.AGI and 0 >= tbuff.info.AGI then
          buff_FearTime = buff_FearTime + math.abs(tbuff.info.AGI * 0.01)
        end
      end
      if hero.TitanHisoka_hasArcana and hero.TitanHisoka_hasArcana >= 3 then
        skillults:takeEffectAt(target.position, hero)
      else
        for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
          local unitdistance = ed.edpDistanceSQ(target.position, unit.position)
          if not unit.buff_effects.untargetable and not unit.buffManager.invisible and unitdistance <= 18225 then
            local bid = TitanHisoka.atk4_fearID
            local binfo = ed.lookupDataTable("Buff", nil, bid)
            local buff = ed.BuffCreate(binfo, unit, hero)
            buff.CreatedByHunterHunter = true
            buff:setAttribute("fearrange", 3)
            buff.timer = math.min(buff.timer + buff_FearTime, 7)
            unit:addBuff(buff, hero)
          end
        end
      end
    end
  end
end

function TitanHisoka.skinBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if damage and damage > caster.hp and (damage_type == "AP" or damage_type == "AD") then
    local buffOriginInfo = ed.lookupDataTable("Buff", nil, TitanHisoka.TitanHisokaSkinBid)
    local TitanHisokaSkinBuff
    local TitanHisokaSkin_BTime = 5
    local restHP = caster.hp
    local newHPR = -damage / TitanHisokaSkin_BTime
    local buffawakeInfo = ed.wraptable(buffOriginInfo, {HPR = newHPR, Time = TitanHisokaSkin_BTime})
    if source then
      TitanHisokaSkinBuff = ed.BuffCreate(buffawakeInfo, caster, source)
    else
      TitanHisokaSkinBuff = ed.BuffCreate(buffawakeInfo, caster, caster)
    end
    TitanHisokaSkinBuff.update = override(TitanHisokaSkinBuff.update, TitanHisoka.TitanHisokaSkinBuff_update)
    caster:addBuff(TitanHisokaSkinBuff, caster)
    damage = 1
    return damage
  end
  return damage
end

function TitanHisoka.TitanHisokaSkinBuff_update(basefunc, buff, dt)
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

function TitanHisoka.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.change_aoe_index = 0
  hero.atk4_2ndAttack_index = 0
end

function TitanHisoka.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  if TitanHisoka.TitanHisoka_fashionID and TitanHisoka.TitanHisoka_fashionID == self.fashion_id then
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.info.ID == TitanHisoka.TitanHisokaSkinBid then
        tbuff.timer = -1
        self.hasTitanHisokaSkinBuff = true
      end
    end
    if killer_unit == self and self.hasTitanHisokaSkinBuff then
      for i, tbuff in ipairs(self.buff_list) do
        if tbuff.info.ID == TitanHisoka.TitanHisokaSkinBid then
          tbuff.timer = -1
          self.hasTitanHisokaSkinBuff = false
        end
      end
    end
  end
end

function TitanHisoka.init_hero(hero)
  hero.reset = override(hero.reset, TitanHisoka.hero_reset)
  hero.update = override(hero.update, TitanHisoka.hero_update)
  hero.TitanHisoka_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if TitanHisoka.TitanHisoka_fashionID and TitanHisoka.TitanHisoka_fashionID == hero.fashion_id then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, TitanHisoka.hero_handleUnitDieEvent)
  end
  local skillult = hero.skills.TitanHisoka_ult
  local skillatk = hero.skills.TitanHisoka_atk
  local skillatk2 = hero.skills.TitanHisoka_atk2
  local skillatk3 = hero.skills.TitanHisoka_atk3
  local skillatk4 = hero.skills.TitanHisoka_atk4
  local skillults = hero.skills.TitanHisoka_ults
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanHisoka.skillatk2_start)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanHisoka.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanHisoka.skillatk234_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanHisoka.skillatk3_start)
    skillatk3.power = override(skillatk3.power, TitanHisoka.skillatk3_power)
    skillatk3.getDamage = override(skillatk3.getDamage, TitanHisoka.skillatk3_getDamage)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanHisoka.skillatk234_onAttackFrame)
    if hero.TitanHisoka_hasArcana and hero.TitanHisoka_hasArcana >= 2 then
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanHisoka.skillatk34_takeEffectOn)
    end
  end
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, TitanHisoka.skillatk4_power)
    skillatk4.createProjectile = override(skillatk4.createProjectile, TitanHisoka.skillatk4_CreateProjectile)
    skillatk4.start = override(skillatk4.start, TitanHisoka.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanHisoka.skillatk234_onAttackFrame)
    if hero.TitanHisoka_hasArcana and hero.TitanHisoka_hasArcana >= 2 then
      skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanHisoka.skillatk34_takeEffectOn)
    end
  end
  if skillult then
    skillult.power = override(skillult.power, TitanHisoka.skillult_power)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanHisoka.skillult_onAttackFrame)
  end
  if skillults then
    skillults.createBuff = override(skillult.createBuff, TitanHisoka.skillults_createBuff)
  end
  return hero
end

return TitanHisoka.init_hero
