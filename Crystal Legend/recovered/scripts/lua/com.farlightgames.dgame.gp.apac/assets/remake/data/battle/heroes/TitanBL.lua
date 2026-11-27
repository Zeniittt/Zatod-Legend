module("ed.battlehero", package.seeall)
local ed = ed
TitanBL = {}
TitanBL.TitanBL_fashion_id = 101801
TitanBL.invulnerableBid = 11018001
TitanBL.HolyDmgOnBid = 11018002
TitanBL.skillatk4_buffID = 11018003
TitanBL.ult_HPRBuffID = 11018004
TitanBL.ragelosthp = 35000
TitanBL.rage2losthp = 15000
TitanBL.stage2hp = 1750000
TitanBL.stage2ragelosthp = 7500

function TitanBL.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk = caster.skills.TitanBL_atk
  if caster.HolyDmgOn then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Damage Type"] = "Holy"
    })
    basefunc(skill, target, source, shift)
    skill.info = originfo
  else
    basefunc(skill, target, source, shift)
  end
end

function TitanBL.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanBL_atk2
  local bid = TitanBL.invulnerableBid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  binfo.Time = 1.3
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.timer = 1.3
  caster:addBuff(buff)
  basefunc(skill, target)
end

function TitanBL.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanBL_atk2
  if caster.HolyDmgOn then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Damage Type"] = "Holy"
    })
    basefunc(skill, target, source, shift)
    skill.info = originfo
  else
    basefunc(skill, target, source, shift)
  end
end

function TitanBL.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanBL_atk3
  caster.atk3_target = skill.target
  local bid = TitanBL.invulnerableBid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  binfo.Time = 1
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.timer = 1
  caster:addBuff(buff)
  basefunc(skill, target)
end

function TitanBL.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanBL_atk2
  if caster.HolyDmgOn then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Damage Type"] = "Holy"
    })
    basefunc(skill, target, source, shift)
    skill.info = originfo
  else
    basefunc(skill, target, source, shift)
  end
end

function TitanBL.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = caster.atk3_target
  local attack_counter = skill.attack_counter
  if attack_counter == 0 and caster then
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
    caster.atk3_startDirection = caster.direction
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter == 1 and target and caster then
    caster:setPosition({
      target.position[1] - caster.direction * 50,
      target.position[2]
    })
    caster.atk3_endPosition = {
      caster.position[1],
      caster.position[2]
    }
    caster.direction = caster.atk3_startDirection
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter == 2 and target and caster then
    skill:takeEffectOn(target, caster)
  end
end

function TitanBL.atk4_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred)
  local hero = buff.owner
  local skillatk4 = hero.skills.TitanBL_atk4
  if hero and skillatk4 and damage_type == "AP" and skill then
    local DODG_Ratio = 0.6666
    local Dodg_rand = ed.rand()
    if DODG_Ratio >= Dodg_rand then
      dmg = 0
      hero:onHitMiss(hero)
      if do_battle_log and source.current_skill then
        btlog("%s: %s --> %s (Miss!)", source.current_skill:display(), source:display(), hero:display())
      end
      local color = hero.camp == ed.emCampEnemy and "red" or "blue"
      if hero.actor then
        ed.PopupCreate("dodge", color, hero.actor, nil, "text")
      end
    end
  end
  return dmg
end

function TitanBL.isCrlEftConflictWithUncontrollableSP(buff)
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

function TitanBL.hero_onHitMiss(basefunc, hero, skill)
  basefunc(hero, skill)
  local skillatk4 = hero.skills.TitanBL_atk4
  local HolyDmgCount = hero.HolyDmgCount
  if skillatk4 then
    hero.atk4DodgCount = hero.atk4DodgCount + 1
    if HolyDmgCount <= hero.atk4DodgCount then
      hero.HolyDmgOn = true
      hero.atk4DodgCount = 0
      local bid2 = TitanBL.HolyDmgOnBid
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, hero, hero)
      buff2.onRemoved = override(buff2.onRemoved, TitanBL.skillatk4_HolyDmgBuff_onRemoved)
      hero.HolyDmgOnBuff = hero:addBuff(buff2, hero)
      for _, tbuff in ipairs(hero.buff_list) do
        local caster = tbuff.caster
        if TitanBL.isCrlEftConflictWithUncontrollableSP(tbuff) and caster.camp ~= hero.camp then
          tbuff.timer = -1
        end
      end
    end
  end
end

function TitanBL.skillatk4_HolyDmgBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster.HolyDmgOn then
    caster.HolyDmgOn = false
  end
end

function TitanBL.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
end

function TitanBL.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillult = caster.skills.TitanBL_ult
  local attack_counter = skill.attack_counter
  if caster and skillult and attack_counter then
    if attack_counter == 0 then
      local bid = TitanBL.invulnerableBid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      binfo.Time = 1
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.timer = 1
      caster:addBuff(buff)
      basefunc(skill)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanBL_ult.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, {400, 0}, {
            caster.direction,
            1
          }, nil, -1)
        end
      end
    end
    if attack_counter == 1 and target then
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
        skill.caster.manually_casting = false
      end
      skillult:takeEffectAt(caster.position, caster)
      local MinHPUnit
      local MinHP = math.huge
      local protal_pos
      for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
        if unit and not unit.config.is_summoned and not unit.buff_effects.untargetable and not unit.buffManager.invisible and 0 < unit.hp then
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
          MinHPUnit.position[1] - 20 * caster.direction,
          MinHPUnit.position[2] + 1
        }
      else
        caster.ult_minHPunit = target
        protal_pos = {
          target.position[1] - 20 * caster.direction,
          target.position[2] + 1
        }
      end
      caster:setPosition(protal_pos)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 2 and target then
      if caster.ult_minHPunit then
        local target = caster.ult_minHPunit
        skillult:takeEffectOn(target, caster)
        local Ult_DeadLine = target.attribs.HP * 0.15
        if target and Ult_DeadLine > target.hp then
          target:setHP(0)
          target:takeDamage(Ult_DeadLine, "Holy", "hp", caster, 1, 1)
        end
        local effect_name = "eff_impact_TitanBL_ult.cha"
        if ed.run_with_scene and effect_name then
          ed.scene:playEffectOnScene(effect_name, target.position, {
            caster.direction,
            1
          }, nil, 1)
        end
      end
      skill:finish()
    end
  end
end

function TitanBL.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillult = caster.skills.TitanBL_ult
  local originfo = skillult.info
  local attack_counter = skill.attack_counter
  if caster.HolyDmgOn then
    skill.info = ed.wraptable(originfo, {
      ["Damage Type"] = "Holy"
    })
    basefunc(skill, target, source, shift)
    skill.info = originfo
  else
    basefunc(skill, target, source, shift)
    skill.info = originfo
  end
end

function TitanBL.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanBL_atk4
  if skillatk4 and not hero.hasAtk4Buff then
    local bid = TitanBL.skillatk4_buffID
    local binfo = ed.lookupDataTable("Buff", nil, TitanBL.skillatk4_buffID)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.onDamaged = override(buff.onDamaged, TitanBL.atk4_buffonDamaged)
    hero:addBuff(buff, hero)
    hero.hasAtk4Buff = true
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanBL.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanBL.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanBL.ragelosthp
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
    while hero.lastRageHp - hero.hp >= TitanBL.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanBL.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanBL.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk4DodgCount = 0
  hero.hasAtk4Buff = false
  hero.HolyDmgCount = 6
  hero.HolyDmgOn = false
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, TitanBL.rage_buff_update)
  hero.lastrageStack = 0
end

function TitanBL.rage_buff_update(basefunc, buff, dt)
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

function TitanBL.init_hero(hero)
  hero.reset = override(hero.reset, TitanBL.hero_reset)
  hero.update = override(hero.update, TitanBL.hero_update)
  hero.onHitMiss = override(hero.onHitMiss, TitanBL.hero_onHitMiss)
  local skillatk = hero.skills.TitanBL_atk
  local skillatk2 = hero.skills.TitanBL_atk2
  local skillatk3 = hero.skills.TitanBL_atk3
  local skillatk4 = hero.skills.TitanBL_atk4
  local skillult = hero.skills.TitanBL_ult
  if skillult then
    skillult.start = override(skillult.start, TitanBL.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanBL.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanBL.skillult_takeEffectOn)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanBL.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanBL.skillatk2_start)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanBL.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanBL.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanBL.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanBL.skillatk3_takeEffectOn)
  end
  return hero
end

return TitanBL.init_hero
