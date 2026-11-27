module("ed.battlehero", package.seeall)
local ed = ed
SPE = {}
SPE.atk2SelfBuffID = 10006302
SPE.reflectInterval = 0.5
SPE.create_mirror_cd = 0.25
SPE.mirror_lifespan = 10
SPE.transporttime = 9.75
SPE.mirrorbuff = 10006303
SPE.atk3evo2 = 10006304
SPE.FashionID_1 = 631

function SPE.atk3_power(basefunc, self, source, target, damage_type)
  return self.caster.SPE_atk3_projectile.SPE_current_tick_damage, 1
end

function SPE.atk3_projectile_update(basefunc, self, dt)
  if self.birthtick == ed.engine.ticks then
    return
  end
  self.SPE_next_reflect_time = self.SPE_next_reflect_time - dt
  if self.SPE_current_tick_damage > 0 and self.SPE_next_reflect_time <= 0 or self.SPE_current_tick_damage > 200 then
    self.skill:takeEffectAt(self.skill.caster.position, self)
    self.SPE_current_tick_damage = 0
    self.SPE_next_reflect_time = SPE.reflectInterval
  end
  ed.Entity.update(self, dt)
end

function SPE.reset(basefunc, unit)
  basefunc(unit)
  unit.Ori_walk_speed_multiplier_SPE = unit.walk_speed_multiplier
  local skill3 = unit.skills.SPE_atk3
  if skill3 then
    unit.SPE_need_atk3_projectile = true
  end
  local skill4 = unit.skills.SPE_atk4
  if skill4 then
    unit.SPE_skill4 = skill4
  end
  unit.SPE_CreateMirror_cd_remaining = 0
  unit.SPE_needed_mirror_target_list = {}
  unit.SPE_mirror_list = {}
  local skill3 = unit.skills.SPE_atk3
  unit.atk3firstperiod = true
  if skill3 and skill3.evo_rank and skill3.evo_rank >= 3 then
    unit.atk3firstperiodtime = skill3.evo_rank3["Script Arg1"]
  end
  if skill3 and skill3.evo_rank and skill3.evo_rank >= 2 then
    local bid = SPE.atk3evo2
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff:setAttribute("HP", skill3.evo_rank2["Script Arg1"])
    unit:addBuff(buff, unit)
    unit:takeHeal(skill3.evo_rank2["Script Arg1"] * unit.config.hp_mod)
  end
end

function SPE.getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type)
  local lost = basefunc(unit, damage, immunity, damage_type)
  local atk3_projectile = unit.SPE_atk3_projectile
  local reduce_lost = 0
  if 0 < lost and atk3_projectile and (damage_type == "AD" or damage_type == "AP") then
    reduce_lost = lost * atk3_projectile.skill.info["Script Arg2"] * 0.01
    if atk3_projectile.skill.evo_rank and atk3_projectile.skill.evo_rank >= 1 then
      reduce_lost = lost * (atk3_projectile.skill.info["Script Arg2"] + atk3_projectile.skill.evo_rank1["Script Arg1"]) * 0.01
    end
    if atk3_projectile.skill.evo_rank and atk3_projectile.skill.evo_rank >= 3 then
      if unit.atk3firstperiod == true then
        reduce_lost = lost * (atk3_projectile.skill.info["Script Arg2"] + atk3_projectile.skill.evo_rank1["Script Arg1"]) * 0.01 * 2
      else
        reduce_lost = lost * (atk3_projectile.skill.info["Script Arg2"] + atk3_projectile.skill.evo_rank1["Script Arg1"]) * 0.01
      end
    end
    if lost < reduce_lost then
      reduce_lost = lost
    end
    atk3_projectile.SPE_current_tick_damage = atk3_projectile.SPE_current_tick_damage + reduce_lost
    lost = lost - reduce_lost
  end
  return lost
end

function SPE.atk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local info = skill.info
  if ed.run_with_scene then
    local effect_name = info["Point Effect"]
    if not effect_name then
      return
    end
    local effect_z = info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, skill.caster.position, {
      skill.caster.direction,
      1
    }, nil, effect_z)
  end
end

function SPE.atk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local shielddmg = skill.info["Script Arg2"] * caster.attribs.AD
  if target then
    for i, buff in ipairs(target.buff_list) do
      if buff.cantreduce ~= true then
        if shielddmg == 0 then
          break
        end
        if buff.shield then
          if shielddmg <= buff.shield then
            buff.shield = buff.shield - shielddmg
            shielddmg = 0
          else
            shielddmg = shielddmg - buff.shield
            buff.shield = 0
            buff.timer = -1
          end
        end
      end
    end
  end
  basefunc(skill, target, source)
end

function SPE.atk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local bid = SPE.atk2SelfBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("HAST", skill.info["Script Arg3"])
  buff:setAttribute("MSPD", skill.info["Script Arg3"])
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HAST", skill.info["Script Arg3"] + skill.evo_rank2["Script Arg1"])
    buff:setAttribute("MSPD", skill.info["Script Arg3"] + skill.evo_rank2["Script Arg1"])
  end
  caster:addBuff(buff, caster)
end

function SPE.atk_takeEffectOn(basefunc, skill, target, source)
  local atk_ImpactEffect = "eff_impact_slash.cha"
  local caster = skill.caster
  local enemycount = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.config.is_summoned then
      enemycount = enemycount + 1
    end
  end
  local atk_hit, d = basefunc(skill, target, source)
  local skill4_hit
  local skill4 = skill.caster.SPE_skill4
  if skill4 then
    skill4.target = skill.target
    if skill.caster.config.is_summoned == true then
      local summonerskill4 = skill.caster.config.summoner.SPE_skill4
      if summonerskill4 then
        skill4.info["Basic Num"] = summonerskill4.info["Script Arg4"] * caster.config.summoner.attribs.AGI + summonerskill4.info["Script Arg2"] * (5 - enemycount) + summonerskill4.info["Script Arg3"]
        if summonerskill4.evo_rank and 1 <= summonerskill4.evo_rank then
          skill4.info["Basic Num"] = summonerskill4.info["Script Arg4"] * caster.config.summoner.attribs.AGI + summonerskill4.info["Script Arg2"] * (5 - enemycount) + summonerskill4.info["Script Arg3"] + summonerskill4.evo_rank1["Script Arg1"]
        end
        if summonerskill4.evo_rank and summonerskill4.evo_rank >= 2 then
          skill4.info["Basic Num"] = summonerskill4.info["Script Arg4"] * caster.config.summoner.attribs.AGI + summonerskill4.info["Script Arg2"] * (5 - enemycount) + summonerskill4.info["Script Arg3"] + summonerskill4.evo_rank1["Script Arg1"] + summonerskill4.evo_rank2["Script Arg1"]
        end
        if summonerskill4.evo_rank and summonerskill4.evo_rank >= 3 then
          skill4.info["Basic Num"] = summonerskill4.info["Script Arg4"] * caster.config.summoner.attribs.AGI + summonerskill4.info["Script Arg2"] * (5 - enemycount) + summonerskill4.info["Script Arg3"] + summonerskill4.evo_rank1["Script Arg1"] + summonerskill4.evo_rank2["Script Arg1"] + summonerskill4.evo_rank3["Script Arg1"] * caster.config.summoner.attribs.AGI
        end
      end
    else
      skill4.info["Basic Num"] = skill4.info["Script Arg4"] * caster.attribs.AGI + skill4.info["Script Arg2"] * (5 - enemycount) + skill4.info["Script Arg3"]
      if skill4.evo_rank and 1 <= skill4.evo_rank then
        skill4.info["Basic Num"] = skill4.info["Script Arg4"] * caster.attribs.AGI + skill4.info["Script Arg2"] * (5 - enemycount) + skill4.info["Script Arg3"] + skill4.evo_rank1["Script Arg1"]
      end
      if skill4.evo_rank and skill4.evo_rank >= 2 then
        skill4.info["Basic Num"] = skill4.info["Script Arg4"] * caster.attribs.AGI + skill4.info["Script Arg2"] * (5 - enemycount) + skill4.info["Script Arg3"] + skill4.evo_rank1["Script Arg1"] + skill4.evo_rank2["Script Arg1"]
      end
      if skill4.evo_rank and skill4.evo_rank >= 3 then
        skill4.info["Basic Num"] = skill4.info["Script Arg4"] * caster.attribs.AGI + skill4.info["Script Arg2"] * (5 - enemycount) + skill4.info["Script Arg3"] + skill4.evo_rank1["Script Arg1"] + skill4.evo_rank2["Script Arg1"] + skill4.evo_rank3["Script Arg1"] * caster.attribs.AGI
      end
    end
    skill4_hit = skill4:takeEffectOn(skill4.target, skill.caster)
  end
  local effect_name = not skill4_hit and atk_ImpactEffect
  if effect_name and target.actor then
    local effect_z = 0
    target.actor:addEffect(effect_name, effect_z)
  end
  return atk_hit, d
end

function SPE.Mirror_update(basefunc, unit, dt)
  unit.mDuration_SPE = unit.mDuration_SPE - dt
  local heroCount = 0
  for u in ed.engine:foreachAliveUnit(unit.camp) do
    if not u.config.is_summoned then
      heroCount = heroCount + 1
    end
  end
  if heroCount <= 0 or unit.mDuration_SPE <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function SPE.Mirror_die(basefunc, unit, killer)
  basefunc(unit, killer)
  local list = unit.SPE_host.SPE_mirror_list
  for i = 1, #list do
    if list[i] == unit then
      list[i] = list[#list]
      list[#list] = nil
      break
    end
  end
end

function SPE.Mirror_ai_searchTarget(basefunc, ai)
  local owner = ai.owner
  local unit = owner.SPEMirror_target
  if unit and unit:isAlive() and unit ~= owner and not unit.buff_effects.untargetable and not unit.buffManager.invisible and not owner.buff_effects.enchanted then
    local p0 = owner.position
    local p1 = unit.position
    local x = p0[1] - p1[1]
    local y = p0[2] - p1[2]
    local distanceSQ = x * x + y * y
    return unit, distanceSQ
  else
    owner.SPEMirror_target = nil
  end
  return basefunc(ai)
end

function SPE.ult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.info.ID == 183 then
      unit:die()
    end
  end
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if not unit.config.is_summoned and not unit.buff_effects.hide and unit.position[1] >= 0 and unit.position[1] <= 800 then
      table.insert(caster.SPE_needed_mirror_target_list, unit)
    end
  end
  caster.SPE_Ultrecord = SPE.transporttime
  if ed.run_with_scene then
    local effect_name = "eff_point_SPE_ult_bottom.cha"
    local effect_z = -1
    ed.scene:playEffectOnScene(effect_name, {
      ed.engine.stage_rect.maxX / 2,
      -30
    }, {
      caster.direction,
      1
    }, nil, effect_z)
  end
end

function SPE.update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit.SPE_need_atk3_projectile then
    unit.SPE_need_atk3_projectile = false
    local skill3 = unit.skills.SPE_atk3
    if skill3 then
      local projectile = skill3:createProjectile()
      projectile.position = {400, 0}
      projectile.update = override(projectile.update, SPE.atk3_projectile_update)
      ed.engine:addProjectile(projectile)
      unit.SPE_atk3_projectile = projectile
      projectile.SPE_next_reflect_time = SPE.reflectInterval
      projectile.SPE_current_tick_damage = 0
    end
  end
  local skillult = unit.skills.SPE_ult
  unit.SPE_CreateMirror_cd_remaining = unit.SPE_CreateMirror_cd_remaining - dt
  local list = unit.SPE_needed_mirror_target_list
  if 0 < #list and 0 >= unit.SPE_CreateMirror_cd_remaining then
    unit.SPE_CreateMirror_cd_remaining = SPE.create_mirror_cd
    local target = list[#list]
    list[#list] = nil
    local skill = unit.skills.SPE_ult
    local caster = unit
    local proto = {
      _tid = 183,
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
      estimate_skill = true,
      hp_mod = caster.config.hp_mod or 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local SPEMirror = ed.UnitCreate(proto, caster.camp, config)
    SPEMirror.mDuration_SPE = SPE.mirror_lifespan
    SPEMirror.update = override(SPEMirror.update, SPE.Mirror_update)
    SPEMirror.die = override(SPEMirror.die, SPE.Mirror_die)
    local name = "SPEMirror"
    local skillatk = SPEMirror.skills[name .. "_atk"]
    local skill4 = SPEMirror.skills[name .. "_atk4"]
    if skillatk and skill4 then
      SPEMirror.SPE_skill4 = skill4
      skillatk.takeEffectOn = override(skillatk.takeEffectOn, SPE.atk_takeEffectOn)
    end
    SPEMirror:setDeathWithEffectOrNot(true)
    local mirror_position = {
      target.position[1] + target.direction * 60,
      target.position[2]
    }
    if mirror_position[1] > 799 then
      mirror_position[1] = 799
    end
    if mirror_position[1] < 1 then
      mirror_position[1] = 1
    end
    SPEMirror.direction = -target.direction
    SPEMirror:pushPuppet("SPEMirror2.cha" or "SPEMirror.cha")
    local fashionId = caster.fashion_id
    if fashionId and fashionId == SPE.FashionID_1 then
      SPEMirror:pushPuppet("SPE_fashion_1_Mirror.cha")
    end
    SPEMirror:reset()
    ed.engine:summonUnit(SPEMirror, mirror_position, caster)
    SPEMirror.SPEMirror_target = target
    SPEMirror.ai.searchTarget = override(SPEMirror.ai.searchTarget, SPE.Mirror_ai_searchTarget)
    SPEMirror.SPE_host = caster
    table.insert(caster.SPE_mirror_list, SPEMirror)
    local SPEmirrorattribs = skill.info["Script Arg3"] / 100
    if skill.evo_rank and 1 <= skill.evo_rank then
      SPEmirrorattribs = SPEmirrorattribs + skill.evo_rank1["Script Arg1"] / 100
    end
    if skill.evo_rank and 2 <= skill.evo_rank then
      SPEmirrorattribs = SPEmirrorattribs + skill.evo_rank2["Script Arg1"] / 100
    end
    local AttriBinfo = ed.lookupDataTable("Buff", nil, SPE.mirrorbuff)
    SPE.changeBuffInfo(AttriBinfo, SPEmirrorattribs, SPEMirror)
    local buff = SPEMirror:addBuff(AttriBinfo, caster)
    SPEMirror:takeHeal(SPEMirror.attribs.HP, "hp")
    if ed.run_with_scene then
      local effect_name = "eff_point_SPE_ult.cha"
      local fashionId = caster.fashion_id
      if fashionId and fashionId == SPE.FashionID_1 then
        effect_name = "eff_point_SPE_fashion_1_ult.cha"
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, mirror_position, {
        SPEMirror.direction,
        1
      }, nil, effect_z)
      ed.scene:startCameraShakeAnimationY(2, 0.1, 2)
    end
    if skill.evo_rank and skill.evo_rank >= 3 then
      target:takeDamage(skill.evo_rank3["Script Arg1"], "Holy", "mp", skill.caster)
    end
  end
  if unit.actor and ed.engine.ticks % 4 == 0 then
    local enemycount = 0
    for unit in ed.engine:foreachAliveUnit(unit.foecamp) do
      if not unit.config.is_summoned then
        enemycount = enemycount + 1
      end
    end
    local ninjitsuEffectRate = unit.skills.SPE_atk4 and 4 * (5 - enemycount) or 0
    if ninjitsuEffectRate ~= unit.lastParticleEffectRate_SPE then
      local hasParticleSystem = unit.actor.puppetName == "SPE.cha" or unit.actor.puppetName == "SPE2.cha"
      if hasParticleSystem then
        local particleSystem = unit.actor.particle_stack.SPE_atk4
        particleSystem:setEmissionRate(ninjitsuEffectRate)
      end
      unit.lastParticleEffectRate_SPE = ninjitsuEffectRate
    end
  end
  if unit.SPE_Ultrecord then
    unit.SPE_Ultrecord = unit.SPE_Ultrecord - dt
  end
  if unit.SPE_Ultrecord and 0 > unit.SPE_Ultrecord then
    local weakest_target, tracking_mirror
    local min_hpperc = math.huge
    local new_mirror_list = {}
    for i, mirror in ipairs(unit.SPE_mirror_list) do
      new_mirror_list[i] = mirror
      local target = mirror.SPEMirror_target
      if target and target:isAlive() then
        local percent = target.hp / target.attribs.HP
        if min_hpperc > percent then
          weakest_target = target
          tracking_mirror = mirror
          min_hpperc = percent
        end
      end
    end
    if weakest_target then
      local origin_pos = {
        unit.position[1],
        unit.position[2]
      }
      unit.position = {
        tracking_mirror.position[1],
        tracking_mirror.position[2]
      }
      unit.direction = tracking_mirror.direction
      tracking_mirror:die()
      if ed.run_with_scene then
        local effect_name = "eff_launch_SPE_transport.cha"
        local fashionId = unit.fashion_id
        if fashionId and fashionId == SPE.FashionID_1 then
          effect_name = "eff_launch_SPE_fashion_1_transport.cha"
        end
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, {
          origin_pos[1],
          origin_pos[2] - 1
        }, {
          unit.direction,
          1
        }, nil, effect_z)
        effect_name = "eff_point_SPE_transport.cha"
        if fashionId and fashionId == SPE.FashionID_1 then
          effect_name = "eff_point_SPE_fashion_1_transport.cha"
        end
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, {
          unit.position[1],
          unit.position[2] - 1
        }, {
          unit.direction,
          1
        }, nil, effect_z)
      end
    end
    unit.SPE_Ultrecord = nil
  end
  if unit.atk3firstperiodtime then
    unit.atk3firstperiodtime = unit.atk3firstperiodtime - dt
  end
  if unit.atk3firstperiodtime and 0 >= unit.atk3firstperiodtime then
    unit.atk3firstperiod = false
  end
end

function SPE.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function SPE.init_hero(hero)
  local skillult = hero.skills.SPE_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, SPE.ult_takeEffectAt)
  end
  if skillult then
    hero.reset = override(hero.reset, SPE.reset)
    hero.update = override(hero.update, SPE.update)
  end
  local skill2 = hero.skills.SPE_atk2
  if skill2 then
    skill2.onAttackFrame = override(skill2.onAttackFrame, SPE.atk2_onAttackFrame)
    skill2.takeEffectOn = override(skill2.takeEffectOn, SPE.atk2_takeEffectOn)
    skill2.finish = override(skill2.finish, SPE.atk2_finish)
    if skill2.evo_rank and skill2.evo_rank >= 1 then
      skill2.info = ed.wraptable(skill2.info, {
        ["Plus Ratio"] = skill2.evo_rank1["Script Arg1"]
      })
    end
    if skill2.evo_rank and skill2.evo_rank >= 3 then
      skill2.info = ed.wraptable(skill2.info, {
        ["Plus Ratio"] = skill2.evo_rank3["Script Arg1"]
      })
    end
    if SPE.FashionID_1 and SPE.FashionID_1 == hero.fashion_id then
      skill2.info = ed.wraptable(skill2.info, {
        ["Point Effect"] = "eff_point_SPE_fashion_1_atk2.cha",
        ["Impact Effect"] = "eff_impact_SPE_fashion_1_atk2.cha"
      })
    end
  end
  local skill3 = hero.skills.SPE_atk3
  if skill3 then
    if SPE.FashionID_1 and SPE.FashionID_1 == hero.fashion_id then
      skill3.info = ed.wraptable(skill3.info, {
        ["Impact Effect"] = "eff_impact_SPE_fashion_1_atk3.cha"
      })
    end
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, SPE.getLostHPAfterImmunity)
    skill3.power = override(skill3.power, SPE.atk3_power)
  end
  local skillatk = hero.skills.SPE_atk
  local skill4 = hero.skills.SPE_atk4
  if skillatk and skill4 then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SPE.atk_takeEffectOn)
  end
  return hero
end

return SPE.init_hero
