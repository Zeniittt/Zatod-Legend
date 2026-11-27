module("ed.battlehero", package.seeall)
local ed = ed
GuildMountSPE = {}
GuildMountSPE.atk2SelfBuffID = 12003302
GuildMountSPE.reflectInterval = 0.5
GuildMountSPE.create_mirror_cd = 0.25
GuildMountSPE.mirror_lifespan = 10
GuildMountSPE.transporttime = 9.75
GuildMountSPE.mirrorbuff = 12003303
GuildMountSPE.atk3evo2 = 12003304
GuildMountSPE.mirrorbuff2 = 12003305

function GuildMountSPE.atk3_power(basefunc, self, source, target, damage_type)
  return self.caster.GuildMountSPE_atk3_projectile.GuildMountSPE_current_tick_damage, 1
end

function GuildMountSPE.atk3_projectile_update(basefunc, self, dt)
  if self.birthtick == ed.engine.ticks then
    return
  end
  self.GuildMountSPE_next_reflect_time = self.GuildMountSPE_next_reflect_time - dt
  if self.GuildMountSPE_current_tick_damage > 0 and self.GuildMountSPE_next_reflect_time <= 0 or self.GuildMountSPE_current_tick_damage > 200 then
    self.skill:takeEffectAt(self.skill.caster.position, self)
    self.GuildMountSPE_current_tick_damage = 0
    self.GuildMountSPE_next_reflect_time = GuildMountSPE.reflectInterval
  end
  ed.Entity.update(self, dt)
end

function GuildMountSPE.reset(basefunc, unit)
  basefunc(unit)
  unit.Ori_walk_GuildMountSPEed_multiplier_GuildMountSPE = unit.walk_GuildMountSPEed_multiplier
  local skill3 = unit.skills.GuildMountSPE_atk3
  if skill3 then
    unit.GuildMountSPE_need_atk3_projectile = true
  end
  local skill4 = unit.skills.GuildMountSPE_atk4
  if skill4 then
    unit.GuildMountSPE_skill4 = skill4
  end
  unit.GuildMountSPE_CreateMirror_cd_remaining = 0
  unit.GuildMountSPE_needed_mirror_target_list = {}
  unit.GuildMountSPE_mirror_list = {}
  local skill3 = unit.skills.GuildMountSPE_atk3
  unit.atk3firstperiod = true
  if skill3 and skill3.evo_rank and skill3.evo_rank >= 3 then
    unit.atk3firstperiodtime = skill3.evo_rank3["Script Arg1"]
  end
  if skill3 and skill3.evo_rank and skill3.evo_rank >= 2 then
    local bid = GuildMountSPE.atk3evo2
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff:setAttribute("HP", skill3.evo_rank2["Script Arg1"])
    unit:addBuff(buff, unit)
    unit:takeHeal(skill3.evo_rank2["Script Arg1"] * unit.config.hp_mod)
  end
end

function GuildMountSPE.getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type)
  local lost = basefunc(unit, damage, immunity, damage_type)
  local atk3_projectile = unit.GuildMountSPE_atk3_projectile
  local reduce_lost = 0
  if 0 < lost and atk3_projectile and (damage_type == "AD" or damage_type == "AP") then
    reduce_lost = lost * atk3_projectile.skill.info["Script Arg2"] * 0.01 / 3
    if atk3_projectile.skill.evo_rank and atk3_projectile.skill.evo_rank >= 1 then
      reduce_lost = lost * (atk3_projectile.skill.info["Script Arg2"] + atk3_projectile.skill.evo_rank1["Script Arg1"]) * 0.01 / 3
    end
    if atk3_projectile.skill.evo_rank and 3 <= atk3_projectile.skill.evo_rank then
      if unit.atk3firstperiod == true then
        reduce_lost = lost * (atk3_projectile.skill.info["Script Arg2"] + atk3_projectile.skill.evo_rank1["Script Arg1"]) * 0.01 * 2 / 3
      else
        reduce_lost = lost * (atk3_projectile.skill.info["Script Arg2"] + atk3_projectile.skill.evo_rank1["Script Arg1"]) * 0.01 / 3
      end
    end
    if lost < reduce_lost then
      reduce_lost = lost
    end
    atk3_projectile.GuildMountSPE_current_tick_damage = atk3_projectile.GuildMountSPE_current_tick_damage + reduce_lost
    lost = lost - reduce_lost
  end
  return lost
end

function GuildMountSPE.atk2_onAttackFrame(basefunc, skill)
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

function GuildMountSPE.atk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local shielddmg = skill.info["Script Arg2"] * caster.attribs.AD
  if target then
    for i, buff in ipairs(target.buff_list) do
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
  basefunc(skill, target, source)
end

function GuildMountSPE.atk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local bid = GuildMountSPE.atk2SelfBuffID
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

function GuildMountSPE.atk_takeEffectOn(basefunc, skill, target, source)
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
  local skill4 = skill.caster.GuildMountSPE_skill4
  if skill4 then
    skill4.target = skill.target
    if skill.caster.config.is_summoned == true then
      local summonerskill4 = skill.caster.config.summoner.GuildMountSPE_skill4
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

function GuildMountSPE.Mirror_update(basefunc, unit, dt)
  unit.mDuration_GuildMountSPE = unit.mDuration_GuildMountSPE - dt
  local heroCount = 0
  for u in ed.engine:foreachAliveUnit(unit.camp) do
    if not u.config.is_summoned then
      heroCount = heroCount + 1
    end
  end
  if heroCount <= 0 or unit.mDuration_GuildMountSPE <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function GuildMountSPE.Mirror_die(basefunc, unit, killer)
  basefunc(unit, killer)
  local list = unit.GuildMountSPE_host.GuildMountSPE_mirror_list
  for i = 1, #list do
    if list[i] == unit then
      list[i] = list[#list]
      list[#list] = nil
      break
    end
  end
end

function GuildMountSPE.Mirror_ai_searchTarget(basefunc, ai)
  local owner = ai.owner
  local unit = owner.GuildMountSPEMirror_target
  if unit and unit:isAlive() and unit ~= owner and not unit.buff_effects.untargetable and not unit.buffManager.invisible and not owner.buff_effects.enchanted then
    local p0 = owner.position
    local p1 = unit.position
    local x = p0[1] - p1[1]
    local y = p0[2] - p1[2]
    local distanceSQ = x * x + y * y
    return unit, distanceSQ
  else
    owner.GuildMountSPEMirror_target = nil
  end
  return basefunc(ai)
end

function GuildMountSPE.ult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.info.ID == 183 then
      unit:die()
    end
  end
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if not unit.config.is_summoned and unit.position[1] >= 0 and unit.position[1] <= 800 then
      table.insert(caster.GuildMountSPE_needed_mirror_target_list, unit)
    end
  end
  caster.GuildMountSPE_Ultrecord = GuildMountSPE.transporttime
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

function GuildMountSPE.update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit.GuildMountSPE_need_atk3_projectile then
    unit.GuildMountSPE_need_atk3_projectile = false
    local skill3 = unit.skills.GuildMountSPE_atk3
    if skill3 then
      local projectile = skill3:createProjectile()
      projectile.position = {400, 0}
      projectile.update = override(projectile.update, GuildMountSPE.atk3_projectile_update)
      ed.engine:addProjectile(projectile)
      unit.GuildMountSPE_atk3_projectile = projectile
      projectile.GuildMountSPE_next_reflect_time = GuildMountSPE.reflectInterval
      projectile.GuildMountSPE_current_tick_damage = 0
    end
  end
  local skillult = unit.skills.GuildMountSPE_ult
  unit.GuildMountSPE_CreateMirror_cd_remaining = unit.GuildMountSPE_CreateMirror_cd_remaining - dt
  local list = unit.GuildMountSPE_needed_mirror_target_list
  if 0 < #list and 0 >= unit.GuildMountSPE_CreateMirror_cd_remaining then
    unit.GuildMountSPE_CreateMirror_cd_remaining = GuildMountSPE.create_mirror_cd
    local target = list[#list]
    list[#list] = nil
    local skill = unit.skills.GuildMountSPE_ult
    local caster = unit
    local proto = {
      _tid = 200034,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      estimate_skill = true,
      hp_mod = caster.config.hp_mod or 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local GuildMountSPEMirror = ed.UnitCreate(proto, caster.camp, config)
    GuildMountSPEMirror.mDuration_GuildMountSPE = GuildMountSPE.mirror_lifespan
    GuildMountSPEMirror.update = override(GuildMountSPEMirror.update, GuildMountSPE.Mirror_update)
    GuildMountSPEMirror.die = override(GuildMountSPEMirror.die, GuildMountSPE.Mirror_die)
    local name = "GMSPEMirror"
    local skillatk = GuildMountSPEMirror.skills[name .. "_atk"]
    local skill4 = GuildMountSPEMirror.skills[name .. "_atk4"]
    if skillatk and skill4 then
      GuildMountSPEMirror.GuildMountSPE_skill4 = skill4
      skillatk.takeEffectOn = override(skillatk.takeEffectOn, GuildMountSPE.atk_takeEffectOn)
    end
    GuildMountSPEMirror:setDeathWithEffectOrNot(true)
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
    GuildMountSPEMirror.direction = -target.direction
    GuildMountSPEMirror:pushPuppet("GuildMountSPE_Mirror.cha")
    GuildMountSPEMirror:reset()
    ed.engine:summonUnit(GuildMountSPEMirror, mirror_position, caster)
    GuildMountSPEMirror.GuildMountSPEMirror_target = target
    GuildMountSPEMirror.ai.searchTarget = override(GuildMountSPEMirror.ai.searchTarget, GuildMountSPE.Mirror_ai_searchTarget)
    GuildMountSPEMirror.GuildMountSPE_host = caster
    table.insert(caster.GuildMountSPE_mirror_list, GuildMountSPEMirror)
    local GuildMountSPEmirrorattribs = skill.info["Script Arg3"] / 100
    if skill.evo_rank and 1 <= skill.evo_rank then
      GuildMountSPEmirrorattribs = GuildMountSPEmirrorattribs + skill.evo_rank1["Script Arg1"] / 100
    end
    if skill.evo_rank and 2 <= skill.evo_rank then
      GuildMountSPEmirrorattribs = GuildMountSPEmirrorattribs + skill.evo_rank2["Script Arg1"] / 100
    end
    local AttriBinfo = ed.lookupDataTable("Buff", nil, GuildMountSPE.mirrorbuff)
    GuildMountSPE.changeBuffInfo(AttriBinfo, GuildMountSPEmirrorattribs, GuildMountSPEMirror)
    local buff = GuildMountSPEMirror:addBuff(AttriBinfo, caster)
    GuildMountSPEMirror:takeHeal(GuildMountSPEMirror.attribs.HP, "hp")
    local bid2 = GuildMountSPE.mirrorbuff2
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, GuildMountSPEMirror, caster)
    buff2.onDamaged = override(buff2.onDamaged, GuildMountSPE.mirror_onDamaged)
    GuildMountSPEMirror:addBuff(buff2, caster)
    if ed.run_with_scene then
      local effect_name = "eff_point_SPE_fashion_1_ult.cha"
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, mirror_position, {
        GuildMountSPEMirror.direction,
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
    if not unit.skills.GuildMountSPE_atk4 or not (4 * (5 - enemycount)) then
      local ninjitsuEffectRate = 0
    end
  end
  if unit.GuildMountSPE_Ultrecord then
    unit.GuildMountSPE_Ultrecord = unit.GuildMountSPE_Ultrecord - dt
  end
  if unit.GuildMountSPE_Ultrecord and 0 > unit.GuildMountSPE_Ultrecord then
    local weakest_target, tracking_mirror
    local min_hpperc = math.huge
    local new_mirror_list = {}
    for i, mirror in ipairs(unit.GuildMountSPE_mirror_list) do
      new_mirror_list[i] = mirror
      local target = mirror.GuildMountSPEMirror_target
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
        local effect_name = "eff_launch_SPE_fashion_1_transport.cha"
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, {
          origin_pos[1],
          origin_pos[2] - 1
        }, {
          unit.direction,
          1
        }, nil, effect_z)
        effect_name = "eff_point_SPE_fashion_1_transport.cha"
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
    unit.GuildMountSPE_Ultrecord = nil
  end
  if unit.atk3firstperiodtime then
    unit.atk3firstperiodtime = unit.atk3firstperiodtime - dt
  end
  if unit.atk3firstperiodtime and 0 >= unit.atk3firstperiodtime then
    unit.atk3firstperiod = false
  end
end

function GuildMountSPE.mirror_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  local owner = buff.owner
  local summoner = owner.config.summoner
  if summoner then
    dmg = dmg * 0.35
    summoner:takeDamage(dmg / summoner.attribs.PDM, "Holy", "hp", summoner)
  end
  return dmg
end

function GuildMountSPE.changeBuffInfo(buffInfo, enhance, target)
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

function GuildMountSPE.init_hero(hero)
  local skillult = hero.skills.GuildMountSPE_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, GuildMountSPE.ult_takeEffectAt)
  end
  if skillult then
    hero.reset = override(hero.reset, GuildMountSPE.reset)
    hero.update = override(hero.update, GuildMountSPE.update)
  end
  local skill2 = hero.skills.GuildMountSPE_atk2
  if skill2 then
    skill2.onAttackFrame = override(skill2.onAttackFrame, GuildMountSPE.atk2_onAttackFrame)
    skill2.takeEffectOn = override(skill2.takeEffectOn, GuildMountSPE.atk2_takeEffectOn)
    skill2.finish = override(skill2.finish, GuildMountSPE.atk2_finish)
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
  end
  local skill3 = hero.skills.GuildMountSPE_atk3
  if skill3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, GuildMountSPE.getLostHPAfterImmunity)
    skill3.power = override(skill3.power, GuildMountSPE.atk3_power)
  end
  local skillatk = hero.skills.GuildMountSPE_atk
  local skill4 = hero.skills.GuildMountSPE_atk4
  if skillatk and skill4 then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, GuildMountSPE.atk_takeEffectOn)
  end
  return hero
end

return GuildMountSPE.init_hero
