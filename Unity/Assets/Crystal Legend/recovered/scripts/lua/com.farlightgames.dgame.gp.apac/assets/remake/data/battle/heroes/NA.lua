module("ed.battlehero", package.seeall)
local ed = ed
NA = {}
NA.ult_inv = 11001301
NA.NA_imu_distance = 40
NA.NA_yspeed_limit = 100
NA.NA_xspeed_limit = 400
NA.FashionId = 100131

function NA.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.NA_ult_originpos = {}
  caster.NA_ult_originpos[1] = caster.position[1]
  caster.NA_ult_originpos[2] = caster.position[2]
end

function NA.skillult_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    basefunc(skill)
    caster.walk_v = {0, 0}
  else
    basefunc(skill)
  end
end

function NA.set_speed(caster, target)
  local movetime = 0.5
  local position_gap = caster.position[1] - target.position[1]
  local x_gap = caster.position[1] - target.position[1]
  if x_gap <= 0 then
    x_gap = -x_gap
  end
  if x_gap > NA.NA_imu_distance then
    x_gap = x_gap - NA.NA_imu_distance
  end
  if x_gap < NA.NA_imu_distance and x_gap > -NA.NA_imu_distance then
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
  if y_v >= NA.NA_yspeed_limit then
    y_v = NA.NA_yspeed_limit
  end
  if y_v <= -NA.NA_yspeed_limit then
    y_v = -NA.NA_yspeed_limit
  end
  if position_gap < NA.NA_imu_distance and position_gap > -NA.NA_imu_distance then
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

function NA.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
    local buffimmune = ed.lookupDataTable("Buff", nil, NA.ult_inv)
    caster:addBuff(buffimmune, caster)
    NA.ult_func_hideBuffEffect(caster)
    if not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    if not skill.target then
      local info = skill.info
      skill:finish()
      return
    end
    NA.set_speed(caster, skill.target)
  elseif skill.attack_counter == 1 then
    NA.ult_func_resetBuffEffect(caster)
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
    NA.ult_func_hideBuffEffect(caster)
  elseif skill.attack_counter == 6 then
    skill.attack_counter = skill.attack_counter + 1
    caster.position = {
      caster.NA_ult_originpos[1],
      caster.NA_ult_originpos[2]
    }
    NA.ult_func_resetBuffEffect(caster)
  end
end

function NA.ult_func_hideBuffEffect(unit)
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

function NA.ult_func_resetBuffEffect(unit)
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

function NA.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and not target:isAlive() and not target.config.is_summoned and target.killer and target.killer == caster and skill.evo_rank and skill.evo_rank >= 3 then
    local mp = skill.evo_rank3["Script Arg1"]
    caster:takeHeal(mp, "mp", caster)
  end
  if not target.buff_effects.invulnerable and target:isAlive() then
    local info = skill.info
    local combo = skill.attack_counter - 1
    local name = "eff_impact_NA_ult_" .. combo .. ".cha"
    local fashionId = caster.fashion_id
    if fashionId and fashionId == NA.FashionId then
      name = "eff_impact_NA_fashion_1_ult_" .. combo .. ".cha"
    end
    if name and target.actor then
      local effect_z = info["Impact Zorder"]
      print(name)
      target.actor:addEffect(name, effect_z)
    end
  end
end

function NA.skillult_update(basefunc, skill, dt_action, dt_cd)
  if skill.casting and skill == skill.caster.current_skill and skill.current_phase_idx == 1 and skill.attack_counter == 1 then
    local caster = skill.caster
    local target = skill.target
    if not target or not target:isAlive() then
      target = skill:selectTarget(nil)
      if target then
        NA.set_speed(caster, target)
      else
        local info = skill.info
        skill:finish()
        return
      end
    end
    local position_gap = caster.position[1] - target.position[1]
    if position_gap < NA.NA_imu_distance and position_gap > -NA.NA_imu_distance and caster.action_name and not caster.action_loop then
      local elapsed = caster.action_elapsed
      if dt_action < elapsed then
        caster.walk_v = {0, 0}
        skill:startPhase(2)
      end
    end
  end
  basefunc(skill, dt_action, dt_cd)
end

function NA.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for _, buff in ipairs(caster.buff_list) do
    if buff.info.ID == NA.ult_inv then
      buff.timer = 0
    end
  end
  caster.position = {
    caster.NA_ult_originpos[1],
    caster.NA_ult_originpos[2]
  }
end

function NA.skillatk3_createProjectile(basefunc, skill)
  local Target = skill.target
  local projectile = basefunc(skill, Target)
  projectile:enableTrack(Target)
  ed.engine:addProjectile(projectile)
end

function NA.skillatk3_power(basefunc, skill, source, target, damage_type)
  local origin_power = basefunc(skill, source, target, damage_type)
  local extra_power = target.mp * skill.info["Script Arg2"]
  return origin_power + extra_power, 1
end

function NA.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and target:isAlive() and skill.evo_rank and skill.evo_rank >= 3 then
    local mp = skill.evo_rank3["Script Arg1"] / 100 * target.mp
    target:takeDamage(mp, "Holy", "mp", skill.caster)
  end
end

function NA.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local fashionId = caster.fashion_id
  if fashionId and fashionId == NA.FashionId then
    buff:setAttribute("Effect", "eff_buff_NA_fashion_1_atk4.cha")
  end
  owner.NA_atk4_buff = true
  buff.onRemoved = override(buff.onRemoved, NA.skillatk4_buff_onRemoved)
  return buff
end

function NA.skillatk4_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.NA_atk4_buff = false
  for unit in ed.engine:foreachAliveUnit(owner.foecamp) do
    unit.NA_atk4_count = nil
  end
end

function NA.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if self.NA_atk4_buff then
    local amount = struct_table
    if type(struct_table) == "table" then
      damage_type = struct_table.damage_type
      source = struct_table.source
      field = struct_table.field
      amount = struct_table.amount
    end
    local dt = damage_type
    local s = source
    local skillatk4 = self.skills.NA_atk4
    if s and s:isAlive() and not s.NA_atk4_count and amount and 0 < amount and not transferred and field == "hp" then
      local atk4arg = skillatk4.info["Script Arg2"] / 100
      if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
        atk4arg = (skillatk4.evo_rank1["Script Arg1"] + skillatk4.info["Script Arg2"]) / 100
      end
      local atk4dmg = amount * atk4arg
      s:takeDamage(atk4dmg, dt, "hp", self, 1, 1, true)
      if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
        local mpdmg = skillatk4.evo_rank3["Script Arg1"]
        s:takeDamage(mpdmg, "Holy", "mp", self, 1, 1, true)
      end
      if not s.buff_effects.invulnerable or s.buff_effects.uncontrollable then
        local bid = 11001304
        if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
          bid = 11001305
        end
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = s:addBuff(binfo, self)
      end
      if ed.run_with_scene then
        local origin = s.position
        local scale = {
          s.direction,
          1
        }
        local effect_name = "eff_impact_pierce.cha"
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, origin, scale, nil, 1)
      end
      s.NA_atk4_count = true
      return 0
    else
      return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
    end
  else
    return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  end
end

function NA.hero_true_init(hero)
  local skillult = hero.skills.NA_ult
  local skillatk = hero.skills.NA_atk
  local skillatk2 = hero.skills.NA_atk2
  local skillatk3 = hero.skills.NA_atk3
  local skillatk4 = hero.skills.NA_atk4
  if skillult then
    skillult.start = override(skillult.start, NA.skillult_start)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, NA.skillult_onPhaseFinished)
    skillult.onAttackFrame = override(skillult.onAttackFrame, NA.skillult_onAttackFrame)
    skillult.update = override(skillult.update, NA.skillult_update)
    skillult.finish = override(skillult.finish, NA.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, NA.skillult_takeEffectOn)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    local fashionId = hero.fashion_id
    if fashionId and fashionId == NA.FashionId then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Tile Art"] = "eff_tile_NA_fashion_1_atk3.cha"
      })
    end
    skillatk3.createProjectile = override(skillatk3.createProjectile, NA.skillatk3_createProjectile)
    skillatk3.power = override(skillatk3.power, NA.skillatk3_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, NA.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, NA.skillatk4_createBuff)
    hero.takeDamage = override(hero.takeDamage, NA.hero_takeDamage)
  end
  return hero
end

function NA.init_hero(hero)
  NA.hero_true_init(hero)
  return hero
end

return NA.init_hero
