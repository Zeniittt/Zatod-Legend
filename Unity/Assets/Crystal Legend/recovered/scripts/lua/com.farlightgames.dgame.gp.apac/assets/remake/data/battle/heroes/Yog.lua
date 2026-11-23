module("ed.battlehero", package.seeall)
local ed = ed
Yog = {}
Yog.uncontrol_bid = 1338
Yog.ult_effect_list = {
  "eff_point_Yog_ult_front.cha",
  "eff_point_Yog_ult_up.cha",
  "eff_point_Yog_ult_back.cha"
}
Yog.san_per_hit = 200
Yog.san_trigger_bid = 1460
Yog.phantom_time = 4
Yog.phantom_tid = 265
Yog.phantom_taunt_bid = 1461
Yog.tentacle_tid = 264
Yog.tentacle_invul_bid = 1459
Yog.tentacle_time = 9
Yog.atk3_trans_stun_bid = 1462
Yog.max_decrease_ratio = 0.5
Yog.atk4_self_bid = 999
Yog.atk4_self_extraDamageValue = 0.1
Yog.san_extra_damage_base = 100
Yog.san_extra_damage_ratio = 1

function Yog.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = Yog.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function Yog.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Yog.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Yog.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 or skill.attack_counter == 2 or skill.attack_counter == 3 then
    local unit = skill:selectTarget(nil)
    if unit and unit:isAlive() then
      table.insert(skill.Yog_ult_TargetList, unit)
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(Yog.ult_effect_list[#skill.Yog_ult_TargetList], {
          unit.position[1],
          unit.position[2] + 1
        }, {1, 1}, nil, 0)
      end
    end
  else
    local damageskill, target_num, target
    if skill.attack_counter == 1 then
      damageskill = caster.skills.Yog_ultb
      target_num = 1
      if caster.manually_casting then
        ed.engine:unfreeze()
        caster.manually_casting = false
      end
    elseif skill.attack_counter == 4 then
      damageskill = caster.skills.Yog_ulta
      target_num = 2
    else
      damageskill = caster.skills.Yog_ultc
      target_num = 3
    end
    if target_num and skill.Yog_ult_TargetList[target_num] then
      target = skill.Yog_ult_TargetList[target_num]
      if target:isAlive() and damageskill then
        damageskill:takeEffectOn(target)
      end
    end
  end
  skill.attack_counter = skill.attack_counter + 1
end

function Yog.skillult_start(basefunc, self, target)
  basefunc(self, target)
  self.Yog_ult_TargetList = {}
end

function Yog.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = Yog.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function Yog.skillatk3_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Yog.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Yog.skillatk3_onAttackFrame(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  if not target then
    return
  end
  if skill.attack_counter == 0 then
    local bid = Yog.atk3_trans_stun_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Yog_atk3_in.cha", {
        target.position[1],
        target.position[2] + 1
      }, {0.75, 0.75}, nil, 0)
    end
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
  elseif skill.attack_counter == 1 then
  elseif skill.attack_counter == 2 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Yog_atk3_out.cha", {
        caster.position[1] + caster.direction * 60,
        caster.position[2]
      }, {
        0.75 * caster.direction,
        0.75
      }, nil, 0)
    end
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
  elseif skill.attack_counter == 3 then
    skill.YogTentacle_position = {
      target.position[1],
      target.position[2]
    }
    target.position = {
      caster.position[1] + caster.direction * 60,
      caster.position[2]
    }
  elseif skill.attack_counter == 4 then
    Yog.summon_tentacle(skill.caster, skill.YogTentacle_position)
  elseif skill.attack_counter == 5 then
  end
  skill.attack_counter = skill.attack_counter + 1
end

function Yog.skillatk3_selectTarget(basefunc, self, default)
  local target = basefunc(self, default)
  local unit_list = {}
  local caster = self.caster
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.config.is_summoned then
    else
      table.insert(unit_list, unit)
    end
  end
  table.sort(unit_list, function(a, b)
    return a.position[1] * caster.direction < b.position[1] * caster.direction
  end)
  if #unit_list % 2 == 1 then
    self.target = unit_list[(#unit_list - 1) / 2 + 1]
  else
    self.target = unit_list[#unit_list / 2 + 1]
  end
  if target.buff_effects.untargetable or target.buffManager.invisible or target.buff_effects.invulnerable or target.buff_effects.uncontrollable then
    self.target = nil
  end
  return self.target
end

function Yog.tentacle_update(basefunc, unit, dt)
  unit.Yog_tentacle_duration = unit.Yog_tentacle_duration - dt
  if unit.Yog_tentacle_duration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function Yog.summon_tentacle(caster, position)
  local skillatk3 = caster.skills.Yog_ult
  local skillevel = {
    skillatk3.level
  }
  local dir = caster:getInitDir()
  local proto = {
    _tid = Yog.tentacle_tid,
    _level = skillatk3.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local tentacle = ed.UnitCreate(proto, caster.camp, config)
  tentacle.direction = caster.direction
  ed.engine:summonUnit(tentacle, position, caster, "Idle")
  local bid = Yog.tentacle_invul_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = tentacle:addBuff(binfo, tentacle)
  tentacle.Yog_tentacle_duration = Yog.tentacle_time
  tentacle.update = override(tentacle.update, Yog.tentacle_update)
  tentacle:setDeathWithEffectOrNot(true)
  caster.YogTentacle = tentacle
  tentacle.Father_Yog = caster
  local tentacle_skillatk = tentacle.skills.YogTentacle_atk
  tentacle_skillatk.onAttackFrame = override(tentacle_skillatk.onAttackFrame, Yog.tentacle_skillatk_onAttackFrame)
end

function Yog.tentacle_skillatk_onAttackFrame(basefunc, skill)
  local Yogfather = skill.caster.Father_Yog
  local skillatk3b = Yogfather.skills.Yog_atk3b
  if skill.target then
    skillatk3b:takeEffectOn(skill.target)
  end
end

function Yog.skillatk4_willCast(basefunc, skill)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.config.is_summoned then
    elseif unit == skill.caster then
    else
      return true
    end
  end
  return false
end

function Yog.skillatk4_takeEffectAt(basefunc, self, location, source)
  basefunc(self, location, source)
  local caster = self.caster
  local bid = Yog.atk4_self_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("Effect", "eff_buff_Yog_atk4_self.cha")
  buff.timer = 10
  buff.extraDamageValue = Yog.atk4_self_extraDamageValue
  caster:addBuff(buff, caster)
end

function Yog.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  if target and target == skill.caster then
    return false
  else
    return basefunc(skill, target, source, shift)
  end
end

function Yog.skill_san_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if not target then
  elseif not target:isAlive() then
  elseif target.config.is_summoned or target.name == "Enigma" or target.name == "Yog" then
  elseif target.isDandan_Phoenix then
  elseif target.buff_effects.fury then
  elseif target.config.is_boss then
  else
    if target.san_point > 0 and skill.Yog_san_ratio and not target.Yog_san_trigger then
      target.san_point = target.san_point - Yog.san_per_hit * skill.Yog_san_ratio
    end
    if target.san_point < 0 then
      target.san_point = 0
    end
    local caster = skill.caster
    local skillawake = caster.skills.Yog_awake
    local damage = skillawake.info["Script Arg2"] * (1000 - target.san_point) / 1000
    target:takeDamage(damage, "Holy", "hp", skill.caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function Yog.san_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.Yog_san_trigger = nil
  owner.san_point = 1000
  owner.visible_count1 = 1.5
  owner.visible_count2 = 1.5
  owner.visible_count3 = 1.5
end

function Yog.san_run_with_scene(unit, dt)
  if unit.san_point < 1000 and unit.visible_count1 <= 1.5 then
    unit:setFuryVisible(true)
    unit.visible_count1 = unit.visible_count1 - dt
  end
  if unit.visible_count1 < 0 then
    unit:setFuryVisible(nil)
    unit.visible_count1 = 99999
  end
  if unit.san_point < 500 and 1.5 >= unit.visible_count2 then
    unit:setFuryVisible(true)
    unit.visible_count2 = unit.visible_count2 - dt
  end
  if 0 > unit.visible_count2 then
    unit:setFuryVisible(nil)
    unit.visible_count2 = 99999
  end
  if unit.san_point < 100 and 1.5 >= unit.visible_count3 then
    unit:setFuryVisible(true)
    unit.visible_count3 = unit.visible_count3 - dt
  end
  if 0 > unit.visible_count3 then
    unit:setFuryVisible(nil)
    unit.visible_count3 = 99999
  end
end

function Yog.phantom_update(basefunc, unit, dt)
  unit.Yog_phantom_duration = unit.Yog_phantom_duration - dt
  if unit.Yog_phantom_duration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function Yog.phantom_create(skill, target)
  local caster = skill.caster
  local proto = {
    _tid = Yog.phantom_tid,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod and caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local YogPhantom = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = YogPhantom:addBuff(binfo, caster)
  YogPhantom.Yog_phantom_duration = Yog.phantom_time
  YogPhantom.update = override(YogPhantom.update, Yog.phantom_update)
  YogPhantom:setDeathWithEffectOrNot(true)
  YogPhantom.direction = target.direction
  local locationtb = {
    target.position[1] - 60 * target.direction,
    target.position[2]
  }
  ed.engine:summonUnit(YogPhantom, locationtb, caster, "Idle")
  local bid = Yog.phantom_taunt_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, YogPhantom)
  table.insert(caster.YogPhantoms, YogPhantom)
end

function Yog.update(basefunc, hero, dt)
  basefunc(hero, dt)
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    if unit.config.is_summoned or unit.name == "Enigma" or unit.name == "Yog" then
    elseif unit.isDandan_Phoenix then
    elseif unit.buff_effects.fury then
    elseif unit.config.is_boss then
    else
      if unit.san_point and unit.san_point == 1000 then
        unit.visible_count1 = 1.5
        unit.visible_count2 = 1.5
        unit.visible_count3 = 1.5
      end
      if unit.san_point <= 0 and not unit.Yog_san_trigger then
        unit.san_point = 0
        local bid = Yog.san_trigger_bid
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, unit, hero)
        buff.onRemoved = override(buff.onRemoved, Yog.san_buff_onRemoved)
        local buffresult = unit:addBuff(buff, hero)
        if buffresult then
          local skillawake = hero.skills.Yog_awake
          unit.Yog_san_trigger = true
          Yog.phantom_create(skillawake, unit)
        end
      end
      if ed.run_with_scene then
        Yog.san_run_with_scene(unit, dt)
      end
    end
  end
end

function Yog.takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if damage_type and damage_type == "Holy" then
    return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  end
  if type(struct_table) == "table" and struct_table.source and struct_table.source.san_point then
    struct_table.amount = struct_table.amount * (1 - Yog.max_decrease_ratio * (1000 - struct_table.source.san_point) / 1000)
    return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  elseif source and source.san_point then
    local damage = struct_table * (1 - Yog.max_decrease_ratio * (1000 - source.san_point) / 1000)
    return basefunc(self, damage, damage_type, field, source, coefficient, crit_mod, transferred)
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function Yog.hero_die(basefunc, hero, killer)
  for _, mirror in pairs(hero.YogPhantoms) do
    if mirror and mirror:isAlive() then
      mirror:die()
    end
  end
  if hero.YogTentacle then
    hero.YogTentacle:die()
  end
  basefunc(hero, killer)
end

function Yog.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.YogPhantoms = {}
end

function Yog.init_hero(hero)
  local skillult = hero.skills.Yog_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Yog.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Yog.skillult_start)
    skillult.finish = override(skillult.finish, Yog.skillult_finish)
  end
  local skillatk = hero.skills.Yog_atk
  if skillatk then
    skillatk.Yog_san_ratio = 0.8
  end
  local skillatk2 = hero.skills.Yog_atk2
  if skillatk2 then
    skillatk2.Yog_san_ratio = 1
  end
  local skillatk3 = hero.skills.Yog_atk3
  local skillatk3b = hero.skills.Yog_atk3b
  if skillatk3 and skillatk3b then
    skillatk3b.Yog_san_ratio = 0.8
    skillatk3.selectTarget = override(skillatk3.selectTarget, Yog.skillatk3_selectTarget)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Yog.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, Yog.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, Yog.skillatk3_finish)
  end
  local skillatk4 = hero.skills.Yog_atk4
  if skillatk4 then
    skillatk4.willCast = override(skillatk4.willCast, Yog.skillatk4_willCast)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, Yog.skillatk4_takeEffectAt)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Yog.skillatk4_takeEffectOn)
  end
  local skillawake = hero.skills.Yog_awake
  if skillawake then
    local skillulta = hero.skills.Yog_ulta
    local skillultb = hero.skills.Yog_ultb
    local skillultc = hero.skills.Yog_ultc
    skillulta.Yog_san_ratio = 0.8
    skillultb.Yog_san_ratio = 0.8
    skillultc.Yog_san_ratio = 0.8
    skillulta.takeEffectOn = override(skillulta.takeEffectOn, Yog.skill_san_takeEffectOn)
    skillultb.takeEffectOn = override(skillultb.takeEffectOn, Yog.skill_san_takeEffectOn)
    skillultc.takeEffectOn = override(skillultc.takeEffectOn, Yog.skill_san_takeEffectOn)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Yog.skill_san_takeEffectOn)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Yog.skill_san_takeEffectOn)
    skillatk3b.takeEffectOn = override(skillatk3b.takeEffectOn, Yog.skill_san_takeEffectOn)
    hero.takeDamage = override(hero.takeDamage, Yog.takeDamage)
    hero.update = override(hero.update, Yog.update)
    hero.die = override(hero.die, Yog.hero_die)
    hero.reset = override(hero.reset, Yog.hero_reset)
  end
  return hero
end

return Yog.init_hero
