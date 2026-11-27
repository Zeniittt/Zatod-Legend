module("ed.battlehero", package.seeall)
local ed = ed
CG = {}
CG.CGheatEffectList = {
  "eff_buff_CG_heat_1.cha",
  "eff_buff_CG_heat_2.cha",
  "eff_buff_CG_heat_3.cha"
}
CG.atk2_deviation = 35
CG.missile_num = 3

function CG.skillult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
  end
end

function CG.skillult_finish(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.CG_atk4
  if skillatk4 then
    caster.ult_count = caster.ult_count + 1
  end
end

function CG.skillatk2b_takeEffectOn(basefunc, skill, target, source)
  local skillatk2 = skill.caster.skills.CG_atk2
  if target ~= skillatk2.atk2target then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      local bid = 11001409
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, skill.caster)
    end
    basefunc(skill, target, source)
  end
end

function CG.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2b = caster.skills.CG_atk2b
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local bid = 11001405
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    skill.target = skill:selectTarget(nil)
    skill.atk2target = skill.target
    if skill.target then
      local deviation = CG.atk2_deviation
      if skill.target.position[1] < caster.position[1] then
        deviation = CG.atk2_deviation
      end
      if skill.target.position[1] + deviation >= 750 or skill.target.position[1] + deviation <= 50 then
        deviation = -deviation
      end
      caster:setPosition({
        skill.target.position[1] + deviation,
        skill.target.position[2]
      })
      basefunc(skill)
    else
      skill:finish()
    end
  elseif attack_counter == 2 then
    skillatk2b:takeEffectAt(caster.position)
    skill:finish()
  end
end

function CG.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, buff477 in ipairs(caster.buff_list) do
    if buff477.info.ID == 11001405 then
      buff477.timer = 0
    end
  end
  local skillatk4 = caster.skills.CG_atk4
  if skillatk4 then
    caster.ult_count = caster.ult_count + 1
  end
end

function CG.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.CG_atk3_origintarget_position = {}
  caster.CG_atk3_origintarget_position[1] = skill.target.position[1]
  caster.CG_atk3_origintarget_position[2] = skill.target.position[2]
end

function CG.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.CG_atk4
  if skillatk4 then
    caster.ult_count = caster.ult_count + 1
  end
end

function CG.atk3_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  local skillatk3b = caster.skills.CG_atk3b
  skillatk3b.CG_atk3_endposition = {}
  if projectile.position[1] >= projectile.CG_atk3_startposition[1] + 100 or projectile.position[1] <= projectile.CG_atk3_startposition[1] - 100 then
    skillatk3b.CG_atk3_endposition[1] = projectile.position[1]
    skillatk3b.CG_atk3_endposition[2] = projectile.position[2]
    skillatk3b.CG_atk3_endheight = projectile.height
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_CG_atk3.cha", {
        projectile.position[1],
        projectile.position[2] - 1
      }, {
        projectile.direction,
        1
      }, skillatk3b.CG_atk3_endheight, 1)
    end
    projectile:terminate()
    skillatk3b:createProjectile()
  end
end

function CG.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, CG.atk3_projectile_update)
  projectile.CG_atk3_startposition = {}
  projectile.CG_atk3_startposition[1] = projectile.position[1]
  return projectile
end

function CG.skillatk3b_createProjectile(basefunc, skill)
  local count = CG.missile_num
  local caster = skill.caster
  for i = 1, count do
    local projectile = basefunc(skill)
    local h = skill.CG_atk3_endheight
    local v = projectile.zSpeed
    local a = skill.info["Tile Gravity"]
    local A = 0.5 * a
    local B = v
    local C = h
    local delta = B ^ 2 - 4 * A * C
    local t = (-B - delta ^ 0.5) / (2 * A)
    local target_position = {
      caster.CG_atk3_origintarget_position[1] + caster.offset_list[math.mod(caster.skill3b_count, 2) * count + i][1] * skill.caster:getInitDir(),
      caster.CG_atk3_origintarget_position[2] + caster.offset_list[math.mod(caster.skill3b_count, 2) * count + i][2]
    }
    local distance = ed.edpSub(target_position, skill.CG_atk3_endposition)
    projectile.velocity = ed.edpMult(distance, 1 / t)
    projectile.position = {
      skill.CG_atk3_endposition[1],
      skill.CG_atk3_endposition[2]
    }
    projectile.height = skill.CG_atk3_endheight
    ed.engine:addProjectile(projectile)
  end
  caster.skill3b_count = caster.skill3b_count + 1
  return nil
end

function CG.skillatk3b_takeEffectAt(basefunc, self, location, source)
  basefunc(self, location, source)
  local info = self.info
  local direction = self.caster.direction
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  if ed.run_with_scene then
    local effect_name = "eff_point_burst.cha"
    if not effect_name then
      return
    end
    local effect_z = info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, origin, {
      self.caster.direction * 0.7,
      0.7
    }, nil, effect_z)
  end
end

function CG.skillatk3b_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk3c = caster.skills.CG_atk3c
  if buff.rank >= caster.missile_stun then
    skillatk3c:takeEffectOn(owner)
    buff.timer = 0
  end
end

function CG.skillatk3b_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, CG.skillatk3b_buffUpdate)
  return buff
end

function CG.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skilloverheat = hero.skills.CG_overheat
  local skillult = hero.skills.CG_ult
  if ed.run_with_scene and hero.actor and (hero.CG_effectFirstTime or hero.ult_count and hero.ult_count ~= hero.ult_countlast) then
    if hero.ult_count == 0 then
      if hero.CG_preEffectID then
        hero.actor.puppet:removeEffectWithID(hero.CG_preEffectID)
      end
    elseif hero.ult_count > 0 then
      local effect_name = CG.CGheatEffectList[math.min(hero.ult_count, 3)]
      local effect_id = hero.actor:addEffect(effect_name, 1)
      if hero.CG_preEffectID then
        hero.actor.puppet:removeEffectWithID(hero.CG_preEffectID)
      end
      hero.CG_preEffectID = effect_id
      hero.ult_countlast = hero.ult_count
      hero.CG_effectFirstTime = false
    end
  end
  if skilloverheat and hero.ult_count and hero.ult_count >= 3 and hero.inoverheat == nil and hero.name == "CG" and not hero.buff_effects.stun then
    local currentSkill = hero.current_skill
    if currentSkill and currentSkill ~= skillult then
      hero:castSkill(skilloverheat, hero)
      hero.inoverheat = true
    end
  end
end

function CG.skilloverheat_start(basefunc, skill, target)
  local owner = skill.caster
  skill.caster.isWolf_LYC = true
  local bid = 11001410
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function CG.skilloverheat_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.inoverheat = nil
  caster.ult_count = 0
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == 11001410 then
      buff.timer = 0
    end
  end
end

function CG.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity)
  local skillatk4 = hero.skills.CG_atk4
  if skillatk4 then
    local reduce = skillatk4.info["Script Arg2"] * 0.01 * hero.ult_count
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      reduce = reduce + skillatk4.evo_rank3["Script Arg1"] * 0.01 * hero.ult_count
    end
    if hero.inoverheat then
      reduce = reduce + skillatk4.info["Script Arg3"] * 0.01
      if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
        reduce = reduce + skillatk4.evo_rank1["Script Arg1"] * 0.01
      end
    end
    damage = damage * (1 - reduce)
  end
  return basefunc(hero, damage, immunity)
end

function CG.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local s = source or struct_table.source
  if lost and dt == "AD" and 0 < lost and not transferred and s and s:isAlive() then
    local skillatk4 = self.skills.CG_atk4
    if self.inoverheat then
      s:takeDamage(skillatk4.evo_rank2["Script Arg1"] + skillatk4.evo_rank2["Script Arg2"] * self.attribs.AD, "AD", "hp", self, 1, 1, true)
    end
  end
  return lost
end

function CG.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.inoverheat = nil
  hero.skill3b_count = 0
  hero.ult_count = 0
  hero.missile_stun = 2
  hero.CG_effectFirstTime = true
  hero.offset_list = {
    {0, 0},
    {-45, 0},
    {-70, 30},
    {0, 0},
    {-70, -30},
    {-100, 0}
  }
end

function CG.init_hero(hero)
  local skillult = hero.skills.CG_ult
  local skillatk = hero.skills.CG_atk
  local skillatk2 = hero.skills.CG_atk2
  local skillatk2b = hero.skills.CG_atk2b
  local skillatk3 = hero.skills.CG_atk3
  local skillatk3b = hero.skills.CG_atk3b
  local skillatk4 = hero.skills.CG_atk4
  local skillawake = hero.skills.CG_awake
  local skilloverheat = hero.skills.CG_overheat
  hero.reset = override(hero.reset, CG.hero_reset)
  hero.update = override(hero.update, CG.hero_update)
  if skillult then
    skillult.finish = override(skillult.finish, CG.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, CG.skillult_onAttackFrame)
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
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, CG.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, CG.skillatk2_finish)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    if skillatk2b then
      skillatk2b.takeEffectOn = override(skillatk2b.takeEffectOn, CG.skillatk2b_takeEffectOn)
    end
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, CG.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, CG.skillatk3_finish)
    skillatk3.createProjectile = override(skillatk3.createProjectile, CG.skillatk3_createProjectile)
    if skillatk3b then
      skillatk3b.createBuff = override(skillatk3.createBuff, CG.skillatk3b_createBuff)
      skillatk3b.createProjectile = override(skillatk3b.createProjectile, CG.skillatk3b_createProjectile)
      skillatk3b.takeEffectAt = override(skillatk3b.takeEffectAt, CG.skillatk3b_takeEffectAt)
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
        })
      end
    end
  end
  if skillatk4 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, CG.hero_getLostHPAfterImmunity)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      hero.takeDamage = override(hero.takeDamage, CG.hero_takeDamage)
    end
  end
  if skilloverheat then
    skilloverheat.start = override(skilloverheat.start, CG.skilloverheat_start)
    skilloverheat.finish = override(skilloverheat.finish, CG.skilloverheat_finish)
  end
  return hero
end

return CG.init_hero
