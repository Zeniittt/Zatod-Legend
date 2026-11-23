module("ed.battlehero", package.seeall)
local ed = ed
TitanPiggy = {}
TitanPiggy.TitanPiggy_fashion_ID = 100841

function TitanPiggy.flip_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanPiggy_atk4
  local Max_flipDamage = caster.attribs.HP * skillatk4.info["Script Arg2"] * 0.01
  TitanPiggy.flip_buff_time = TitanPiggy.flip_buff_time + dt
  if TitanPiggy.flip_buff_time <= 2 then
    if Max_flipDamage < TitanPiggy.flip_buff_damage and TitanPiggy.flip_buff_down == false then
      buff.timer = -1
      TitanPiggy.flip_buff_down = true
    end
  else
    TitanPiggy.flip_buff_time = 0
    TitanPiggy.flip_buff_damage = 0
    TitanPiggy.flip_buff_down = false
  end
end

function TitanPiggy.skillatk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local Heal_HP = caster.attribs.HP * 0.025
  if TitanPiggy.TitanPiggy_fashion_ID and TitanPiggy.TitanPiggy_fashion_ID == caster.fashion_id then
    caster:takeHeal(Heal_HP, "hp", caster)
  end
end

function TitanPiggy.skill0and2_start(basefunc, self, target)
  local caster = self.caster
  local skillatk4 = caster.skills.TitanPiggy_atk4
  local bid = 1559
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff_atk4Self = ed.BuffCreate(binfo, caster, caster)
  local havebuff = false
  local flip_buff
  if skillatk4 and caster:isAlive() and not caster.config.is_summoned then
    buff_atk4Self.timer = skillatk4.info["Script Arg3"] + 1.5
  end
  for _, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1559 then
      havebuff = true
      flip_buff = tbuff
    end
  end
  if skillatk4 and caster:isAlive() and not caster.config.is_summoned then
    if havebuff and flip_buff.timer > 0 then
      flip_buff.timer = skillatk4.info["Script Arg3"] + 1.5
    else
      flip_buff = caster:addBuff(buff_atk4Self, caster)
      if flip_buff and caster.TitanPiggy_hasArcana > 3 then
        caster.TitanPiggy_skillatk4buff = true
        flip_buff.onRemoved = override(flip_buff.onRemoved, TitanPiggy.skillatk4buff_onRemoved)
      end
    end
  end
  basefunc(self, target)
end

function TitanPiggy.skillatk3_CastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster:isAlive() then
    if caster.taunter or caster.buff_effects.enchanted then
      return false, "Be taunt or be enchanted."
    else
      return basefunc(skill, target)
    end
  end
end

function TitanPiggy:skillatk3_selectTarget()
  local skillatk3 = self.skills.TitanPiggy_atk3
  local Atk3_unit
  if TitanPiggy.atk3_ColdDown == true then
    local maxDamage = 0
    local maxUnit
    for _, unit_list in ipairs(self.DamageList) do
      if TitanPiggy.atk3_maxDamage <= unit_list.Damage and unit_list.unit:isAlive() and unit_list.unit.camp == self.origin_foecamp then
        TitanPiggy.atk3_maxDamage = unit_list.Damage
        maxUnit = unit_list.unit
        TitanPiggy.atk3maxUnit = maxUnit
      end
    end
    if maxUnit then
      TitanPiggy.atk3maxUnit = maxUnit
    else
      TitanPiggy.atk3maxUnit = TitanPiggy.atk3maxUnit
    end
    return maxUnit
  else
    if TitanPiggy.atk3maxUnit then
      Atk3_unit = TitanPiggy.atk3maxUnit
    end
    for _, unit_list in ipairs(self.DamageList) do
      unit_list.Damage = 0
    end
    TitanPiggy.atk3_maxDamage = 0
    return Atk3_unit
  end
end

function TitanPiggy.skillatk3_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  if self.caster.taunter and self.info["Target Type"] ~= "self" then
    if target then
      if target.camp ~= self:targetCamp() then
        self.target = TitanPiggy.Atk3_target
        if TitanPiggy.Atk3_target then
        else
        end
      end
    else
      self.target = TitanPiggy.Atk3_target
      if TitanPiggy.Atk3_target then
      end
    end
  else
    self.target = TitanPiggy.Atk3_target
    if TitanPiggy.Atk3_target then
    end
  end
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  self:startPhase(1)
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
  local skillatk4 = caster.skills.TitanPiggy_atk4
  local bid = 1559
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff_atk4Self = ed.BuffCreate(binfo, caster, caster)
  local havebuff = false
  local flip_buff
  buff_atk4Self.timer = skillatk4.info["Script Arg3"] + 1.5
  for _, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1559 then
      havebuff = true
      flip_buff = tbuff
    end
  end
  if skillatk4 and caster:isAlive() and not caster.config.is_summoned then
    if havebuff and 0 < flip_buff.timer then
      flip_buff.timer = skillatk4.info["Script Arg3"] + 1.5
    else
      flip_buff = caster:addBuff(buff_atk4Self, caster)
      if flip_buff and caster.TitanPiggy_hasArcana > 3 then
        caster.TitanPiggy_skillatk4buff = true
        flip_buff.onRemoved = override(flip_buff.onRemoved, TitanPiggy.skillatk4buff_onRemoved)
      end
    end
  end
  return self.target
end

function TitanPiggy.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local finaldamage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if finaldamage then
    for _, Damage_list in ipairs(self.DamageList) do
      if type(struct_table) == "table" then
        if struct_table.source == Damage_list.unit then
          Damage_list.Damage = Damage_list.Damage + finaldamage
        end
      elseif source and source == Damage_list.unit then
        Damage_list.Damage = Damage_list.Damage + finaldamage
      end
    end
  end
  return finaldamage, bc
end

function TitanPiggy.hero_update(basefunc, self, dt)
  local caster = self
  local skillatk3 = caster.skills.TitanPiggy_atk3
  if self.buff_list then
    for _, tbuff in ipairs(self.buff_list) do
      if tbuff.info.HPR < 0 then
        local hpr = tbuff.info.HPR * dt
        local HPRdamage = math.min(-hpr, self.hp)
        HPRdamage = HPRdamage * self.dPSStatisticsRatio
        for _, info_list in ipairs(self.DamageList) do
          local unitconfig = info_list.unit.config
          if tbuff.caster == info_list.unit or unitconfig.is_summoned and unitconfig.summoner == tbuff.caster then
            info_list.Damage = info_list.Damage + HPRdamage
          end
        end
      end
    end
  end
  if skillatk3 and caster:isAlive() then
    if skillatk3.casting == true then
      TitanPiggy.atk3_ColdDown = false
    else
      TitanPiggy.atk3_ColdDown = true
    end
    TitanPiggy.Atk3_target = TitanPiggy.skillatk3_selectTarget(self)
    if TitanPiggy.Atk3_target then
    end
  end
  basefunc(self, dt)
end

function TitanPiggy.get_LostHP_AfterImmunity(basefunc, unit, damage, immunity, damage_type, source)
  local skillatk4s = unit.skills.TitanPiggy_atk4s
  local skillatk4 = unit.skills.TitanPiggy_atk4
  if skillatk4 and skillatk4s and not unit.config.is_summoned then
    local Max_flipDamage = unit.attribs.HP * skillatk4.info["Script Arg2"] * 0.01
    for _, buff in ipairs(unit.buff_list) do
      if buff.info.ID == 1559 and buff.timer > 0 then
        if (damage_type == "AP" or damage_type == "AD") and 0 < damage and damage <= Max_flipDamage then
          local tempimmu = immunity
          immunity = 100
          local out = basefunc(unit, damage, immunity, damage_type, source)
          immunity = tempimmu
          skillatk4s.flip_damage = damage
          TitanPiggy.flip_buff_damage = damage + TitanPiggy.flip_buff_damage
          skillatk4s.power = override(skillatk4s.power, TitanPiggy.Reflect_power)
          if source then
            skillatk4s:takeEffectOn(source, unit)
            if ed.run_with_scene and unit.actor then
              local effect_name = "eff_buff_TitanPiggy_atk4_self2.cha"
              local origin = unit.position
              local effect_z = 1
              if effect_name then
                unit.actor:addEffect(effect_name, effect_z)
              end
            end
          end
          return out
        elseif (damage_type == "AP" or damage_type == "AD") and damage > Max_flipDamage then
          local tempDmg = damage
          damage = damage - Max_flipDamage
          local out = basefunc(unit, damage, immunity, damage_type, source)
          skillatk4s.flip_damage = Max_flipDamage
          TitanPiggy.flip_buff_damage = damage + TitanPiggy.flip_buff_damage
          skillatk4s.power = override(skillatk4s.power, TitanPiggy.Reflect_power)
          damage = tempDmg
          if source then
            skillatk4s:takeEffectOn(source, unit)
            if ed.run_with_scene and unit.actor then
              local effect_name = "eff_buff_TitanPiggy_atk4_self2.cha"
              local origin = unit.position
              local effect_z = 1
              if effect_name then
                unit.actor:addEffect(effect_name, effect_z)
              end
            end
          end
          return out
        end
      end
    end
  end
  return basefunc(unit, damage, immunity, damage_type, source)
end

function TitanPiggy.Reflect_power(basefunc, skill, source, target, damage_type)
  basefunc(skill, source, target, damage_type)
  local damage = skill.flip_damage
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanPiggy_atk4
  local Max_flipDamage = caster.attribs.HP * skillatk4.info["Script Arg2"] * 0.01
  local max_damage = math.min(damage, Max_flipDamage)
  return max_damage
end

function TitanPiggy.DOP_in_battlefield(caster, radius, camp)
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
  end
  if maxcount <= 0 then
    return false
  end
end

function TitanPiggy.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.TitanPiggy_ult
  local skillults1 = caster.skills.TitanPiggy_ults1
  local skillults2 = caster.skills.TitanPiggy_ults2
  if attack_counter == 0 then
    caster.TitanPiggy_oriPosition = {
      caster.position[1],
      caster.position[2]
    }
    local Enemy_position = TitanPiggy.DOP_in_battlefield(caster, 100, caster.foecamp)
    if Enemy_position then
      caster:setPosition({
        Enemy_position[1],
        Enemy_position[2]
      })
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    if skillults1 then
      skillults1:takeEffectAt(caster.position)
    end
    if skillults2 then
      skillults2:takeEffectAt(caster.position)
    end
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
    if target then
      for _, tbuff in ipairs(target.buff_list) do
        if tbuff.info.ID == 1560 then
        end
      end
    end
  elseif attack_counter == 2 then
    if skillults2 then
      skillults2:takeEffectAt(caster.position)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    if skillults2 then
      skillults2:takeEffectAt(caster.position)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 4 then
    if skillults2 then
      skillults2:takeEffectAt(caster.position)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 5 and caster.TitanPiggy_oriPosition then
    caster:setPosition({
      caster.TitanPiggy_oriPosition[1],
      caster.TitanPiggy_oriPosition[2]
    })
  end
end

function TitanPiggy.skillults2_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local distance = ((target.position[1] - hero.position[1]) ^ 2 + (target.position[2] - hero.position[2]) ^ 2) ^ 0.5
  local distanceMAX = 300
  local PiggyultRatio = distanceMAX / distance
  if 3 < PiggyultRatio then
    PiggyultRatio = 3
  elseif PiggyultRatio < 1 then
    PiggyultRatio = 1
  end
  local power = power * PiggyultRatio
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

function TitanPiggy.reset(basefunc, hero)
  basefunc(hero)
  hero.DamageList = {}
  for _, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == hero.foecamp then
      hero.DamageList[#hero.DamageList + 1] = {unit = unit, Damage = 0}
    end
  end
  TitanPiggy.Atk3_target = nil
  TitanPiggy.atk3_ColdDown = true
  TitanPiggy.atk3_maxDamage = 0
  TitanPiggy.flip_buff_time = 0
  TitanPiggy.flip_buff_damage = 0
  TitanPiggy.flip_buff_down = false
  hero.origin_foecamp = hero.foecamp
  hero.TitanPiggy_skillatk4buff = false
end

function TitanPiggy.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = buff.timer + 4
  return buff
end

function TitanPiggy.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local ret, dmg = basefunc(skill, target, source)
  if dmg and target and target:isAlive() then
    local bid = 4374
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
  end
  return ret, dmg
end

function TitanPiggy.skillatk4buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.TitanPiggy_skillatk4buff = false
end

function TitanPiggy.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  if owner and caster and owner.TitanPiggy_skillatk4buff and buff.info.ID ~= 4248 and buff.info.ID ~= 4263 and buff.info.ID ~= 698 then
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
      polymorph = true,
      slow = true,
      icefrozen = true
    }
    for i, effect in ipairs(buff.info["Control Effects"]) do
      if negative_effects[effect] then
        if owner ~= caster and owner.name == "TitanPiggy" and owner.camp ~= caster.camp and caster:isAlive() then
          local flip_bid = buff.info.ID
          local flip_binfo = ed.lookupDataTable("Buff", nil, flip_bid)
          local flip_buff = ed.BuffCreate(flip_binfo, caster, caster)
          flip_buff.timer = math.min(flip_buff.timer * 0.3 + owner.attribs.STR * 3.0E-4, 6)
          for j, effect in ipairs(flip_buff.info["Control Effects"]) do
            if string.find(effect, "fear") then
              flip_buff:setAttribute("fearrange", 5)
            end
          end
          caster:addBuff(flip_buff, caster)
        end
        local bid = 1259
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        config.buff = ed.BuffCreate(binfo, owner, buff.caster)
        owner.TitanPiggy_skillatk4buff = false
        break
      end
    end
  end
end

function TitanPiggy.init_hero(hero)
  hero.reset = override(hero.reset, TitanPiggy.reset)
  hero.update = override(hero.update, TitanPiggy.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanPiggy.get_LostHP_AfterImmunity)
  hero.takeDamage = override(hero.takeDamage, TitanPiggy.hero_takeDamage)
  hero.TitanPiggy_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.TitanPiggy_ult
  local skillatk = hero.skills.TitanPiggy_atk
  local skillatk2 = hero.skills.TitanPiggy_atk2
  local skillatk3 = hero.skills.TitanPiggy_atk3
  local skillatk4 = hero.skills.TitanPiggy_atk4
  local skillatk4s = hero.skills.TitanPiggy_atk4s
  local skillults1 = hero.skills.TitanPiggy_ults1
  local skillults2 = hero.skills.TitanPiggy_ults2
  if skillatk and TitanPiggy.TitanPiggy_fashion_ID and TitanPiggy.TitanPiggy_fashion_ID == hero.fashion_id then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, TitanPiggy.skillatk_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanPiggy.skill0and2_start)
    if hero.TitanPiggy_hasArcana and hero.TitanPiggy_hasArcana > 2 then
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanPiggy.skillatk2_takeEffectOn)
    end
  end
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, TitanPiggy.skillatk3_CastWithTarget)
    skillatk3.start = override(skillatk3.start, TitanPiggy.skillatk3_start)
    if hero.TitanPiggy_hasArcana and hero.TitanPiggy_hasArcana > 1 then
      skillatk3.createBuff = override(skillatk3.createBuff, TitanPiggy.skillatk3_createBuff)
    end
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanPiggy.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanPiggy.skill0and2_start)
  end
  if skillults2 then
    skillults2.getDamage = override(skillults2.getDamage, TitanPiggy.skillults2_getDamage)
  end
  if skillatk4 and hero.TitanPiggy_hasArcana and hero.TitanPiggy_hasArcana > 3 then
    hero.collectBuff = override(hero.collectBuff, TitanPiggy.collectBuff)
  end
  return hero
end

return TitanPiggy.init_hero
