module("ed.battlehero", package.seeall)
local ed = ed
BossTitanMW = {}
BossTitanMW.BossTitanMW_atk2_BuffID = 4266
BossTitanMW.BossTitanMW_atk3_BuffID = 4267
BossTitanMW.BossTitanMW_stable_BuffID = 4268
BossTitanMW.BossTitanMW_stun_BuffID = 4269
BossTitanMW.BossTitanMW_summonCheck_BuffID = 4270
BossTitanMW.SummonPos = {
  450,
  510,
  570,
  630,
  690,
  750
}
BossTitanMW.FirstSummonID = {
  282,
  282,
  281,
  281,
  278
}
BossTitanMW.SummonID = {
  281,
  282,
  278
}
BossTitanMW.SummonHPmod = 2.5
BossTitanMW.SummonDPSmod = 10

function BossTitanMW.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillenter = hero.skills.BossTitanMW_enter
  if skillenter then
    local bid = 651
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
  end
end

function BossTitanMW.skillenter_start(basefunc, skill, target)
  local caster = skill.caster
  caster.position[1] = 700
  basefunc(skill, target)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = 0
    end
  end
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function BossTitanMW.monster_onDying(basefunc, unit, skiller)
  local caster = unit.config.summoner
  if caster and caster:isAlive() then
    caster:takeDamage(unit.BossTitanMW_takedamage or 1, "Holy", "hp", skiller)
    if caster.hp < 0 then
      basefunc(unit, skiller)
      return
    end
    if caster.BossTitanMW_monster_list then
      caster.BossTitanMW_monster_list = caster.BossTitanMW_monster_list - 1
    end
    if caster.BossTitanMW_monster_list == 0 then
      for i, bbuff in ipairs(caster.buff_list) do
        if bbuff.info.ID == BossTitanMW.BossTitanMW_stable_BuffID then
          bbuff.timer = 0
        end
      end
      local binfo = ed.lookupDataTable("Buff", nil, BossTitanMW.BossTitanMW_stun_BuffID)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.onRemoved = override(buff.onRemoved, BossTitanMW.stunBuff_onRemoved)
      caster:addBuff(buff, caster)
    end
  end
  basefunc(unit, skiller)
end

function BossTitanMW.stunBuff_onRemoved(basefunc, buff)
  local caster = buff.owner
  if caster and caster:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, BossTitanMW.BossTitanMW_stable_BuffID)
    caster:addBuff(binfo, caster)
  end
  for i = 1, 5 do
    local proto = {
      _tid = BossTitanMW.FirstSummonID[i],
      _level = caster.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = BossTitanMW.SummonHPmod,
      dps_mod = BossTitanMW.SummonDPSmod
    }
    local Summoned_Monster = ed.UnitCreate(proto, caster.camp, config)
    caster.BossTitanMW_monster_list = caster.BossTitanMW_monster_list + 1
    Summoned_Monster.onDying = override(Summoned_Monster.onDying, BossTitanMW.monster_onDying)
    Summoned_Monster.takeDamage = override(Summoned_Monster.takeDamage, BossTitanMW.monster_takeDamage)
    Summoned_Monster.direction = caster.direction
    local monster_location = {
      BossTitanMW.SummonPos[i] + (ed.rand() - 0.5) * 40,
      (ed.rand() - 0.5) * 30
    }
    if caster:isAlive() then
      local take_hp = Summoned_Monster.hp * 15
      Summoned_Monster.BossTitanMW_takedamage = take_hp
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_ChessAss_appear.cha", {
          monster_location[1],
          monster_location[2]
        }, {
          caster.direction,
          1
        }, nil, 1)
      end
      ed.engine:summonUnit(Summoned_Monster, monster_location, caster, "Idle")
      local bbinfo = ed.lookupDataTable("Buff", nil, BossTitanMW.BossTitanMW_summonCheck_BuffID)
      local bbuff = Summoned_Monster:addBuff(bbinfo, caster)
    end
  end
  local skillult = caster.skills.BossTitanMW_ult
  if skillult then
    caster:castSkill(skillult)
  end
  basefunc(buff)
end

function BossTitanMW.monster_takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if not unit:isAlive() then
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
  local level = unit.level
  if damage_type == "AD" then
    defence = math.max(0, unit.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = unit.attribs.PIMU or 0
    if ed.engine.autoChessMode then
      dd = defence * 8
      dc = 0
    else
      dd = math.max(0, defence * 8)
      dc = math.max(0, defence * 8)
    end
  elseif damage_type == "AP" then
    defence = math.max(0, unit.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = unit.attribs.MIMU or 0
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
  immunity = immunity + unit.attribs.ALLIMU
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
      crit_multiplier = math.max(1, crit_multiplier - unit.attribs.CSDR * 0.01)
    elseif damage_type == "AP" then
      crit_multiplier = math.max(1, crit_multiplier - unit.attribs.MCSDR * 0.01)
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
  if ed.debug_mode and unit.camp ~= ed.emCampPlayer then
    damage = damage * ((ed.gmconfig or {}).attack_ratio or 1)
  end
  if 100 <= immunity then
    if ed.run_with_scene then
      local color = unit.camp == ed.emCampEnemy and "red" or "blue"
      local adimm = unit.attribs.PIMU >= 100
      local apimm = unit.attribs.MIMU >= 100
      local str
      if adimm and apimm or unit.attribs.ALLIMU >= 100 then
        str = "immune"
      elseif adimm then
        str = "physical_immune"
      else
        str = "magic_immune"
      end
      if not unit.notPopupBattleInfo then
        ed.PopupCreate(str, color, unit.actor, nil, "text")
      end
    end
    return 0
  end
  local buff_templist = {}
  for i, buff in ipairs(unit.buff_list) do
    buff_templist[i] = buff
  end
  for _, buff in ipairs(buff_templist) do
    if skill and skill.info["Ignore Shield"] == true and not buff.info["No Pass"] == true then
    else
      damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field)
    end
  end
  if damage <= 0 then
    return 0
  end
  if damage_type == "AD" then
    immunity = unit.attribs.PIMU or 0
  elseif damage_type == "AP" then
    immunity = unit.attribs.MIMU or 0
  elseif damage_type == "Holy" then
    immunity = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + unit.attribs.ALLIMU
  if 100 <= immunity then
    if ed.run_with_scene then
      local color = unit.camp == ed.emCampEnemy and "red" or "blue"
      local adimm = unit.attribs.PIMU >= 100
      local apimm = unit.attribs.MIMU >= 100
      local str
      if adimm and apimm or unit.attribs.ALLIMU >= 100 then
        str = "immune"
      elseif adimm then
        str = "physical_immune"
      else
        str = "magic_immune"
      end
      if not unit.notPopupBattleInfo then
        ed.PopupCreate(str, color, unit.actor, nil, "text")
      end
    end
    return 0
  end
  local lost = unit:getLostHPAfterImmunity(damage, immunity, damage_type, source, skill)
  local damage = math.min(unit.hp, lost)
  damage = damage * unit.dPSStatisticsRatio
  if do_battle_log then
    btlog("    %s lost %d %s %s", unit:display(), lost, field, bCrit and "(Crit!)" or "")
  end
  local oldLostHpPer = (unit.attribs.HP - unit.hp) / unit.attribs.HP
  if field == "hp" then
    unit:setHP(unit.hp - lost)
    if unit.hp == 0 then
      unit:onDying(source)
    else
      if unit.state == ed.emUnitState_Birth then
      elseif unit.current_skill and not unit.current_skill.info.Interruptable then
      elseif unit.buff_effects.uncontrollable then
      else
        local interruptHpRatio = unit.attribs["Interrupt HP Ratio"] / 100
        local intr = unit.attribs.INTR or 0
        local interruptProbability
        if intr == 0 then
          interruptProbability = lost <= unit.attribs.HP * interruptHpRatio and 0 or 1
        else
          interruptProbability = inverseLerp(unit.attribs.HP * interruptHpRatio, unit.attribs.HP * (interruptHpRatio + intr * 0.001), lost)
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
          unit:hurt()
          if do_battle_log then
            btlog("    %s was interrupted.", unit:display())
          end
        end
      end
      local mp_gain = lost * unit.info["MP Gain Rate"] / unit.attribs.HP * (unit.attribs.MPRatio * 0.01 + 1)
      unit:setMP(unit.mp + mp_gain * ed.engine.mp_bonus)
    end
  elseif field == "mp" then
    unit:setMP(unit.mp - lost)
  end
  unit:unfreezeActor()
  if unit.actor then
    local str = "-" .. math.floor(lost + 0.5)
    if str ~= "-0" then
      local color
      if field == "mp" then
        color = "yellow"
      elseif unit.camp == ed.emCampPlayer then
        color = "red"
      else
        color = "orange"
      end
      if not unit.notPopupBattleInfo then
        ed.PopupCreate(str, color, unit.actor, bCrit)
      end
      if unit.monster_idx then
        local lostHpPer = (unit.attribs.HP - unit.hp) / unit.attribs.HP
        ed.scene:showMonsterLoots(ed.engine.wave_id, unit, lostHpPer, oldLostHpPer)
      end
    end
  end
  if ed.IsAutoChessMode() and ed.run_with_scene and field == "hp" then
    FireEvent("EventUnitTakeDamage", source, lost)
  end
  return lost, bCrit
end

function BossTitanMW.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = 0
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, BossTitanMW.BossTitanMW_stable_BuffID)
  local buff = caster:addBuff(binfo, caster)
  for i = 1, 5 do
    local proto = {
      _tid = BossTitanMW.FirstSummonID[i],
      _level = caster.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = BossTitanMW.SummonHPmod,
      dps_mod = BossTitanMW.SummonDPSmod
    }
    local Summoned_Monster = ed.UnitCreate(proto, caster.camp, config)
    caster.BossTitanMW_monster_list = caster.BossTitanMW_monster_list + 1
    Summoned_Monster.onDying = override(Summoned_Monster.onDying, BossTitanMW.monster_onDying)
    Summoned_Monster.takeDamage = override(Summoned_Monster.takeDamage, BossTitanMW.monster_takeDamage)
    Summoned_Monster.direction = caster.direction * -1
    local monster_location = {
      BossTitanMW.SummonPos[i] + (ed.rand() - 0.5) * 40,
      (ed.rand() - 0.5) * 30
    }
    if caster:isAlive() then
      local take_hp = Summoned_Monster.hp * 2
      Summoned_Monster.BossTitanMW_takedamage = take_hp
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_ChessAss_appear.cha", {
          monster_location[1],
          monster_location[2]
        }, {
          caster.direction * -1,
          1
        }, nil, 1)
      end
      ed.engine:summonUnit(Summoned_Monster, monster_location, caster, "Idle")
      local bbinfo = ed.lookupDataTable("Buff", nil, BossTitanMW.BossTitanMW_summonCheck_BuffID)
      local bbuff = Summoned_Monster:addBuff(bbinfo, caster)
    end
  end
end

function BossTitanMW.skillatk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local monster_id = math.ceil(ed.rand() * 3)
  local proto = {
    _tid = BossTitanMW.FirstSummonID[monster_id],
    _level = caster.level or 1,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = BossTitanMW.SummonHPmod,
    dps_mod = BossTitanMW.SummonDPSmod
  }
  local Summoned_Monster = ed.UnitCreate(proto, caster.camp, config)
  caster.BossTitanMW_monster_list = caster.BossTitanMW_monster_list + 1
  Summoned_Monster.onDying = override(Summoned_Monster.onDying, BossTitanMW.monster_onDying)
  Summoned_Monster.takeDamage = override(Summoned_Monster.takeDamage, BossTitanMW.monster_takeDamage)
  Summoned_Monster.direction = caster.direction
  local monster_location = {
    820,
    (ed.rand() - 0.5) * 50
  }
  if caster:isAlive() then
    local take_hp = Summoned_Monster.hp * 2
    Summoned_Monster.BossTitanMW_takedamage = take_hp
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_ChessAss_appear.cha", {
        monster_location[1],
        monster_location[2]
      }, {
        caster.direction,
        1
      }, nil, 1)
    end
    ed.engine:summonUnit(Summoned_Monster, monster_location, caster, "Idle")
  end
end

function BossTitanMW.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 and ed.run_with_scene then
    local effectx = "eff_point_TitanMW_ult.cha"
    local effect = ed.scene:playEffectOnScene(effectx, caster.position, {
      caster.direction,
      1
    }, nil, -1)
  end
  basefunc(skill)
  if skill.attack_counter == 2 then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit ~= caster then
        local proto = {
          _tid = unit.info.ID,
          _level = caster.level or 1,
          _stars = caster.stars,
          _rank = caster.rank
        }
        local config = {
          is_monster = true,
          estimate_rank = true,
          hp_mod = BossTitanMW.SummonHPmod,
          dps_mod = BossTitanMW.SummonDPSmod
        }
        local Summoned_Monster = ed.UnitCreate(proto, caster.camp, config)
        Summoned_Monster.hp = unit.hp * 0.75
        caster.BossTitanMW_monster_list = caster.BossTitanMW_monster_list + 1
        Summoned_Monster.onDying = override(Summoned_Monster.onDying, BossTitanMW.monster_onDying)
        Summoned_Monster.takeDamage = override(Summoned_Monster.takeDamage, BossTitanMW.monster_takeDamage)
        Summoned_Monster.direction = caster.direction
        local monster_location = {
          unit.position[1] + 50,
          (ed.rand() - 0.5) * 50
        }
        if caster:isAlive() then
          local take_hp = Summoned_Monster.hp * 2
          Summoned_Monster.BossTitanMW_takedamage = take_hp
          if ed.run_with_scene then
            ed.scene:playEffectOnScene("eff_point_ChessAss_appear.cha", {
              monster_location[1],
              monster_location[2]
            }, {
              caster.direction,
              1
            }, nil, 1)
          end
          ed.engine:summonUnit(Summoned_Monster, monster_location, caster, "Idle")
        end
      end
    end
  end
end

function BossTitanMW.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if target and target:isAlive() and target ~= caster then
    for i, bbuff in ipairs(target.buff_list) do
      if bbuff.info.ID == BossTitanMW.BossTitanMW_atk2_BuffID then
        if target.info.ID == 281 then
          target:takeHeal(target.attribs.HP / 3 * 2)
        else
          target:takeHeal(target.attribs.HP / 2)
        end
        return ret, dmg, Crit, lfs_amount
      end
    end
    local HPbinfo = ed.lookupDataTable("Buff", nil, BossTitanMW.BossTitanMW_atk2_BuffID)
    local HPbuff = ed.BuffCreate(HPbinfo, target, caster)
    local heal_hp = target.attribs.HP
    HPbuff:setAttribute("HP", heal_hp)
    if target.info.ID == 281 then
      HPbuff:setAttribute("HP", 2 * heal_hp)
      heal_hp = heal_hp * 2
    elseif target.info.ID == 282 then
      HPbuff:setAttribute("AD", target.attribs.AD)
    elseif target.info.ID == 278 then
      HPbuff:setAttribute("MIMU", 50)
    end
    target:addBuff(HPbuff, caster)
    target:takeHeal(heal_hp, "hp", caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function BossTitanMW.init_hero(hero)
  local skillatk = hero.skills.BossTitanMW_atk
  local skillatk2 = hero.skills.BossTitanMW_atk2
  local skillatk3 = hero.skills.BossTitanMW_atk3
  local skillult = hero.skills.BossTitanMW_ult
  local skillenter = hero.skills.BossTitanMW_enter
  hero.reset = override(hero.reset, BossTitanMW.hero_reset)
  hero.BossTitanMW_monster_list = 0
  if skillenter then
    skillenter.start = override(skillenter.start, BossTitanMW.skillenter_start)
    skillenter.finish = override(skillenter.finish, BossTitanMW.skillenter_finish)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossTitanMW.skillult_onAttackFrame)
  end
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, BossTitanMW.skillatk_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, BossTitanMW.skillatk2_takeEffectOn)
  end
  return hero
end

return BossTitanMW.init_hero
