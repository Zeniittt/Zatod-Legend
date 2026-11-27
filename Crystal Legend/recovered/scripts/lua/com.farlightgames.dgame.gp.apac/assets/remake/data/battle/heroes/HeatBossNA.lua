module("ed.battlehero", package.seeall)
local ed = ed
HeatBossNA = {}
HeatBossNA.ult_inv = 12004301
HeatBossNA.HeatBossNA_imu_distance = 40
HeatBossNA.HeatBossNA_yspeed_limit = 100
HeatBossNA.HeatBossNA_xspeed_limit = 400

function HeatBossNA.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.HeatBossNA_ult_originpos = {}
  caster.HeatBossNA_ult_originpos[1] = caster.position[1]
  caster.HeatBossNA_ult_originpos[2] = caster.position[2]
end

function HeatBossNA.skillult_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    basefunc(skill)
    caster.walk_v = {0, 0}
  else
    basefunc(skill)
  end
end

function HeatBossNA.set_speed(caster, target)
  local movetime = 0.5
  local position_gap = caster.position[1] - target.position[1]
  local x_gap = caster.position[1] - target.position[1]
  if x_gap <= 0 then
    x_gap = -x_gap
  end
  if x_gap > HeatBossNA.HeatBossNA_imu_distance then
    x_gap = x_gap - HeatBossNA.HeatBossNA_imu_distance
  end
  if x_gap < HeatBossNA.HeatBossNA_imu_distance and x_gap > -HeatBossNA.HeatBossNA_imu_distance then
    x_gap = 0
  end
  local x_v = x_gap / movetime
  local y_gap = target.position[2] - caster.position[2]
  local y_v = 0
  if x_v == 0 then
    y_v = 0
  else
    y_v = y_gap / movetime
  end
  print(y_gap)
  print(y_v)
  if y_v >= HeatBossNA.HeatBossNA_yspeed_limit then
    y_v = HeatBossNA.HeatBossNA_yspeed_limit
  end
  if y_v <= -HeatBossNA.HeatBossNA_yspeed_limit then
    y_v = -HeatBossNA.HeatBossNA_yspeed_limit
  end
  if position_gap < HeatBossNA.HeatBossNA_imu_distance and position_gap > -HeatBossNA.HeatBossNA_imu_distance then
    caster.walk_v = {0, 0}
  elseif 0 < position_gap then
    caster.walk_v = {
      -x_v,
      y_v
    }
  elseif position_gap < 0 then
    caster.walk_v = {x_v, y_v}
  end
  return caster.walk_v
end

function HeatBossNA.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
    local buffimmune = ed.lookupDataTable("Buff", nil, HeatBossNA.ult_inv)
    caster:addBuff(buffimmune, caster)
    HeatBossNA.ult_func_hideBuffEffect(caster)
    if not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    if not skill.target then
      local info = skill.info
      skill:finish()
      return
    end
    HeatBossNA.set_speed(caster, skill.target)
  elseif skill.attack_counter == 1 then
    HeatBossNA.ult_func_resetBuffEffect(caster)
    basefunc(skill)
  elseif skill.attack_counter >= 2 and skill.attack_counter <= 4 then
    basefunc(skill)
  elseif skill.attack_counter == 5 then
    local originfo = skill.info
    local plusratio = skill.info["Plus Ratio"]
    local basicnum = skill.info["Basic Num"]
    skill.info = ed.wraptable(originfo, {
      ["Basic Num"] = basicnum * 2,
      ["Plus Ratio"] = plusratio * 2
    })
    basefunc(skill)
    skill.info = originfo
    HeatBossNA.ult_func_hideBuffEffect(caster)
  elseif skill.attack_counter == 6 then
    skill.attack_counter = skill.attack_counter + 1
    caster.position = {
      caster.HeatBossNA_ult_originpos[1],
      caster.HeatBossNA_ult_originpos[2]
    }
    HeatBossNA.ult_func_resetBuffEffect(caster)
  end
end

function HeatBossNA.ult_func_hideBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
end

function HeatBossNA.ult_func_resetBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(true)
      end
    end
  end
end

function HeatBossNA.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if not target.buff_effects.invulnerable and target:isAlive() then
    local info = skill.info
    local combo = skill.attack_counter - 1
    local HeatBossNAme = "eff_impact_NA_fashion_1_ult_" .. combo .. ".cha"
    if HeatBossNAme and target.actor then
      local effect_z = info["Impact Zorder"]
      target.actor:addEffect(HeatBossNAme, effect_z)
    end
  end
end

function HeatBossNA.skillult_update(basefunc, skill, dt_action, dt_cd)
  if skill.casting and skill == skill.caster.current_skill and skill.current_phase_idx == 1 and skill.attack_counter == 1 then
    local caster = skill.caster
    local target = skill.target
    if not target or not target:isAlive() then
      target = skill:selectTarget(nil)
      if target then
        HeatBossNA.set_speed(caster, target)
      else
        local info = skill.info
        skill:finish()
        return
      end
    end
    local position_gap = caster.position[1] - target.position[1]
    if position_gap < HeatBossNA.HeatBossNA_imu_distance and position_gap > -HeatBossNA.HeatBossNA_imu_distance and caster.action_HeatBossNAme and not caster.action_loop then
      local elapsed = caster.action_elapsed
      if dt_action < elapsed then
        caster.walk_v = {0, 0}
        skill:startPhase(2)
      end
    end
  end
  basefunc(skill, dt_action, dt_cd)
end

function HeatBossNA.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for _, buff in ipairs(caster.buff_list) do
    if buff.info.ID == HeatBossNA.ult_inv then
      buff.timer = 0
    end
  end
  caster.position = {
    caster.HeatBossNA_ult_originpos[1],
    caster.HeatBossNA_ult_originpos[2]
  }
end

function HeatBossNA.skillult_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local powerratio = 1
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050221 then
      powerratio = 1.15
    end
    if tbuff.info.ID == 20050222 then
      powerratio = 1.3
    end
    if tbuff.info.ID == 20050223 then
      powerratio = 1.45
    end
    if tbuff.info.ID == 20050224 then
      powerratio = 1.6
    end
  end
  power = power * powerratio
  return power
end

function HeatBossNA.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local timer = 2
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050231 then
      timer = 2.5
    end
    if tbuff.info.ID == 20050232 then
      timer = 3
    end
    if tbuff.info.ID == 20050233 then
      timer = 3.5
    end
    if tbuff.info.ID == 20050234 then
      timer = 4
    end
  end
  buff.timer = timer * math.max(0.01, 1 - TEN_final / 100)
  return buff
end

function HeatBossNA.skillatk3_createProjectile(basefunc, skill)
  local counter = 1
  local maxcounter = 1
  local origTarget = skill.target
  local caster = skill.caster
  local projectile = basefunc(skill, origTarget)
  projectile:enableTrack(origTarget)
  ed.engine:addProjectile(projectile)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050241 then
      maxcounter = 2
    end
    if tbuff.info.ID == 20050242 then
      maxcounter = 3
    end
    if tbuff.info.ID == 20050243 then
      maxcounter = 4
    end
    if tbuff.info.ID == 20050244 then
      maxcounter = 5
    end
  end
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if counter >= maxcounter then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    elseif unit == origTarget then
    else
      counter = counter + 1
      skill.target = unit
      local projectile = basefunc(skill, unit)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function HeatBossNA.skillatk3_power(basefunc, skill, source, target, damage_type)
  local origin_power = basefunc(skill, source, target, damage_type)
  local extra_power = target.mp * skill.info["Script Arg2"]
  return origin_power + extra_power, 1
end

function HeatBossNA.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and target:isAlive() then
    local mp = 0.5 * target.mp
    target:takeDamage(mp, "Holy", "mp", skill.caster)
  end
end

function HeatBossNA.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  owner.HeatBossNA_atk4_buff = true
  buff.onRemoved = override(buff.onRemoved, HeatBossNA.skillatk4_buff_onRemoved)
  return buff
end

function HeatBossNA.skillatk4_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.HeatBossNA_atk4_buff = false
  for unit in ed.engine:foreachAliveUnit(owner.foecamp) do
    unit.HeatBossNA_atk4_count = nil
  end
end

function HeatBossNA.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    source = struct_table.source
    field = struct_table.field
    amount = struct_table.amount
  end
  local dt = damage_type
  local s = source
  if self.HeatBossNA_atk4_buff then
    local skillatk4 = self.skills.HeatBossNA_atk4
    if dt == "AD" then
      if not s.HeatBossNA_atk4_count and amount and not transferred and field == "hp" and s and s:isAlive() then
        local atk4dmg = amount
        s:takeDamage(atk4dmg, dt, "hp", self, 1, 1, true)
        if not s.buff_effects.invulnerable or s.buff_effects.uncontrollable then
          local bid = 12004304
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = s:addBuff(binfo, self)
        end
        if ed.run_with_scene then
          local origin = s.position
          local scale = {
            s.direction,
            1
          }
          local effect_HeatBossNAme = "eff_impact_pierce.cha"
          if not effect_HeatBossNAme then
            return
          end
          ed.scene:playEffectOnScene(effect_HeatBossNAme, origin, scale, nil, 1)
        end
        s.HeatBossNA_atk4_count = true
      end
      return 0, false
    elseif dt == "AP" then
      local APratio = 2
      for i, tbuff in ipairs(self.buff_list) do
        if tbuff.info.ID == 20050251 then
          APratio = 1.8
        end
        if tbuff.info.ID == 20050252 then
          APratio = 1.6
        end
        if tbuff.info.ID == 20050253 then
          APratio = 1.4
        end
        if tbuff.info.ID == 20050254 then
          APratio = 1.2
        end
      end
      if type(struct_table) == "table" then
        struct_table.amount = struct_table.amount * APratio
      else
        struct_table = struct_table * APratio
      end
      return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
    else
      return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
    end
  else
    return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  end
end

function HeatBossNA.hero_true_init(hero)
  local skillult = hero.skills.HeatBossNA_ult
  local skillatk = hero.skills.HeatBossNA_atk
  local skillatk2 = hero.skills.HeatBossNA_atk2
  local skillatk3 = hero.skills.HeatBossNA_atk3
  local skillatk4 = hero.skills.HeatBossNA_atk4
  if skillult then
    skillult.start = override(skillult.start, HeatBossNA.skillult_start)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, HeatBossNA.skillult_onPhaseFinished)
    skillult.onAttackFrame = override(skillult.onAttackFrame, HeatBossNA.skillult_onAttackFrame)
    skillult.update = override(skillult.update, HeatBossNA.skillult_update)
    skillult.finish = override(skillult.finish, HeatBossNA.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, HeatBossNA.skillult_takeEffectOn)
    skillult.power = override(skillult.power, HeatBossNA.skillult_power)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, HeatBossNA.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, HeatBossNA.skillatk3_createProjectile)
    skillatk3.power = override(skillatk3.power, HeatBossNA.skillatk3_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, HeatBossNA.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, HeatBossNA.skillatk4_createBuff)
    hero.takeDamage = override(hero.takeDamage, HeatBossNA.hero_takeDamage)
  end
  return hero
end

function HeatBossNA.init_hero(hero)
  HeatBossNA.hero_true_init(hero)
  return hero
end

return HeatBossNA.init_hero
