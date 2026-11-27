module("ed.battlehero", package.seeall)
local ed = ed
Wolf = {}
Wolf.control_bid = 699
Wolf.anger_bid = 1000
Wolf.atk3_cd = 12
Wolf.atk3_duration = 0.3
Wolf.dot_ratio = 20
Wolf.empty_bid = 233
Wolf.extra_ratio = 10
Wolf.self_ratio = 0.5
Wolf.ult_run_time = 0.5
Wolf.buff_cha = "eff_buff_Wolf_atk4.cha"
Wolf.bleed_bid = 1006
Wolf.ult_bid = 1005

function Wolf.skillult_projectile_hit(basefunc, self, target)
  local caster = self.skill.caster
  local skillult = caster.skills.Wolf_ult
  local skillultb = caster.skills.Wolf_ultb
  if not target.feartag and target:isAlive() then
    target.feartag = true
  end
  if target == self.target and target:isAlive() then
    if not self.terminated then
      self:terminate()
    end
    skillult:startPhase(2)
  end
end

function Wolf.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile.target = target
  local distance1 = target.position[1] - caster.position[1]
  if distance1 < 0 then
    distance1 = -distance1
  end
  local v = distance1 / Wolf.ult_run_time
  if skill.target then
    local d = ed.edpSub(target.position, caster.position)
    d[2] = 0
    if d[1] == 0 and d[2] == 0 then
      projectile.velocity = {
        projectile.direction,
        0
      }
    else
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), v)
    end
  end
  projectile.height = 1
  projectile.zSpeed = 0
  projectile.hit = override(projectile.hit, Wolf.skillult_projectile_hit)
  return projectile
end

function Wolf.skillult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    if skill.target == nil or not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    if skill.target and skill.target:isAlive() then
      local bid = Wolf.ult_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = skill.caster:addBuff(binfo, skill.caster)
      buff.wolfintoshadow = true
      local caster = buff.caster
      if not caster.buff_effects.doom then
        local list = caster.buff_list
        local my_camp = caster.camp
        for i = 1, #list do
          local my_buff = list[i]
          if my_buff and (not my_buff.caster or my_buff.caster.camp ~= my_camp) and my_buff.info.Dispel then
            my_buff.timer = 0
          end
        end
      end
      if ed.run_with_scene then
        caster:setAllBuffVisible(false)
        caster:setHpVisible(false)
      end
      local distance1 = skill.target.position[1] - caster.position[1]
      if 0 > distance1 * caster.direction then
        caster.direction = -caster.direction
      end
      local position1 = caster.position[1] - caster.direction * 100
      caster.position[1] = position1
      if position1 > ed.engine.stage_rect.maxX then
        caster.position[1] = ed.engine.stage_rect.maxX
      elseif position1 < ed.engine.stage_rect.minX then
        caster.position[1] = ed.engine.stage_rect.minX
      end
      local projectile = skill:createProjectile()
      ed.engine:addProjectile(projectile)
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif skill.attack_counter == 1 then
    local target = skill.target
    local caster = skill.caster
    local position1 = target.position[1] + caster.direction * 70
    if target.buff_effects.stable or position1 > ed.engine.stage_rect.maxX or position1 < ed.engine.stage_rect.minX then
      position1 = position1 - caster.direction * 140
    end
    caster:setPosition({
      position1,
      target.position[2]
    })
    for i, buff in ipairs(caster.buff_list) do
      if buff.wolfintoshadow == true then
        buff.timer = 0
      end
    end
    if ed.run_with_scene then
      caster:setAllBuffVisible(true)
      caster:setHpVisible(true)
    end
    local effect_name = "eff_point_Wolf_ult"
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(effect_name, {
        target.position[1] + 30 * caster.direction,
        target.position[2]
      }, {
        -caster.direction,
        1
      }, nil, 1)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter == 2 then
    skill:takeEffectAt(skill.target.position)
  end
end

function Wolf.skillult_finish(basefunc, self)
  local hero = self.caster
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.feartag then
      local bid = 698
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, unit, hero)
      buff:setAttribute("fearrange", 5)
      local bsuccess = ed.Buff.checkAddBuff(binfo, self.level, unit, hero)
      if bsuccess then
        unit.feartag = nil
        unit:addBuff(buff, hero)
      end
    end
  end
  if hero.wolfatk3_times then
    local skillatk3 = hero.skills.Wolf_atk3
    skillatk3.cd_remaining = Wolf.atk3_cd
  end
  basefunc(self)
end

function Wolf.skillult_selectTarget(basefunc, skill, default)
  local max = -math.huge
  local chosen
  local caster = skill.caster
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    elseif unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
    else
      local hpremaining = -unit.hp / unit.attribs.HP
      if max < hpremaining then
        max = hpremaining
        chosen = unit
      end
    end
  end
  skill.target = chosen
  return skill.target
end

function Wolf.choose_shadow_target(skill)
  local caster = skill.caster
  local chosen
  local min = math.huge
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if not unit:isHero() then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit.feartag then
    elseif unit.Wolf_ultc_chosen then
    else
      local distanceSQ = (unit.position[1] - caster.position[1]) ^ 2 + (unit.position[2] - caster.position[2]) ^ 2
      if min > distanceSQ then
        min = distanceSQ
        chosen = unit
      end
    end
  end
  return chosen
end

function Wolf.skillult_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local hplose = target.attribs.HP - target.hp
  local add_damage = math.min(hplose * 0.2, skill.info["Script Arg2"])
  if target == skill.target then
    skill.info = ed.wraptable(originfo, {
      ["No Dodge"] = true,
      ["Basic Num"] = skill.info["Basic Num"] + add_damage
    })
  else
    skill.info = ed.wraptable(originfo, {
      ["No Dodge"] = true
    })
  end
  local ret, dmg = basefunc(skill, target, source)
  if ret and not target:isAlive() and not target.config.is_summoned and target.killer and target.killer == skill.caster then
    local caster = skill.caster
    local skillultc = caster.skills.Wolf_ultc
    local chosen = Wolf.choose_shadow_target(skill)
    local shadow_target
    if chosen and chosen.position[1] >= ed.engine.stage_rect.minX and chosen.position[1] <= ed.engine.stage_rect.maxX then
      shadow_target = chosen
    else
      shadow_target = skillultc:selectTarget(nil)
    end
    if chosen then
      chosen.Wolf_ultc_chosen = true
      local skillultc = caster.skills.Wolf_ultc
      local info = skillultc.info
      local projectile = skillultc:createProjectile()
      local v = {
        info["Tile XY Speed"],
        0
      }
      projectile.height = projectile.height + 65
      projectile.target = chosen
      projectile.position = target.position
      local d = ed.edpSub(chosen.position, projectile.position)
      if d[1] == 0 and d[2] == 0 then
        projectile.velocity = {
          caster.direction,
          0
        }
      else
        projectile.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
      end
      projectile.originV = projectile.velocity
      projectile.velocity = {0, 0}
      projectile.wolfacctimer = 0.5
      ed.engine:addProjectile(projectile)
    end
  end
  return ret, dmg
end

function Wolf.skillultc_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function Wolf.skillultc_projectile_hit(basefunc, self, target)
  if target == self.target then
    self.skill:takeEffectOn(target, self)
    if target:isAlive() then
      target.Wolf_ultc_chosen = nil
    end
    if not self.terminated then
      self:terminate()
    end
  end
end

function Wolf.skillultc_projectile_update(basefunc, projectile, dt)
  projectile.wolfacctimer = projectile.wolfacctimer - dt
  if projectile.wolfacctimer <= 0 then
    projectile.velocity = projectile.originV
    projectile.height = 1
  end
  basefunc(projectile, dt)
end

function Wolf.skillultc_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, Wolf.skillultc_projectile_hit)
  projectile.update = override(projectile.update, Wolf.skillultc_projectile_update)
  return projectile
end

function Wolf.skillatk4_onRemoved(basefunc, self)
  basefunc(self)
  local owner = self.owner
  if owner.taunter then
    owner.taunter = nil
  end
end

function Wolf.skillatk4_createBuff(basefunc, self, target)
  local buff = basefunc(self, target)
  local hero = self.caster
  if target == hero then
    buff:setAttribute("Control Effects", {})
    buff:setAttribute("AD", buff.info.AD * Wolf.self_ratio)
    buff:setAttribute("HAST", buff.info.HAST * Wolf.self_ratio)
  end
  buff.onRemoved = override(buff.onRemoved, Wolf.skillatk4_onRemoved)
  return buff
end

function Wolf.skillatk4_takeEffectOn(basefunc, self, target, source, shift)
  local ret, dmg = basefunc(self, target, source, shift)
  local caster = self.caster
  local changetag
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit:isHero() then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
    else
      for i, buff in ipairs(unit.buff_list) do
        if buff.Wolf_focus then
          target.taunter = unit
          changetag = true
          break
        end
      end
    end
  end
  if not changetag then
    target.taunter = nil
  end
  return ret, dmg
end

function Wolf.skillatk4_takeEffectAt(basefunc, skill, location, source)
  local target = skill.target
  local hero = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Wolf.empty_bid)
  binfo = ed.wraptable(binfo, {
    Effect = Wolf.buff_cha
  })
  local extradamage_buff = target:addBuff(binfo, hero)
  if extradamage_buff then
    extradamage_buff.timer = 6
    extradamage_buff.Wolf_focus = true
  end
  basefunc(skill, location, source)
end

function Wolf:focusTarget(default)
  local caster = self.caster
  local enchanted = caster.buff_effects.enchanted
  if self:targetCamp() ~= caster.camp then
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if not unit:isHero() then
      elseif unit.config.is_summoned then
      elseif unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit.position[1] > 800 or unit.position[1] < 0 then
      elseif enchanted and unit == caster then
      else
        for i, buff in ipairs(unit.buff_list) do
          if buff.Wolf_focus then
            self.target = unit
            break
          end
        end
      end
    end
  end
  return self.target
end

function Wolf.focus_selectTarget(basefunc, self, default)
  self.target = basefunc(self, default)
  self.target = Wolf.focusTarget(self, self.target)
  return self.target
end

function Wolf.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.target == nil or not skill.target:isAlive() then
    skill:selectTarget(nil)
  end
  if skill.attack_counter and skill.attack_counter == 0 then
    if skill.target then
      local target = skill.target
      local position2 = target.position[2] - caster.position[2]
      local position1 = target.position[1] + caster.direction * 70
      if target.buff_effects.stable or position1 > ed.engine.stage_rect.maxX or position1 < ed.engine.stage_rect.minX then
        position1 = position1 - caster.direction * 140
      end
      local distance1 = position1 - caster.position[1]
      local distance2 = target.position[2] - caster.position[2]
      if distance1 < 0 then
        distance1 = -distance1
      end
      local v = math.max(distance1 / Wolf.atk3_duration, 120)
      local time = distance1 / v
      if distance1 < 50 then
        v = 0
      end
      if time < 0.125 then
        time = 0.125
      end
      caster.temp_walk_v = {
        caster.direction * v,
        distance2 / Wolf.atk3_duration
      }
      caster.wolfatk3_trigger_timer = time
    end
    caster.walk_v = caster.temp_walk_v
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter and skill.attack_counter == 1 then
    caster.walk_v = {0, 0}
    basefunc(skill)
  end
end

function Wolf.skillatk3_start(basefunc, self, target)
  basefunc(self, target)
  local caster = self.caster
  if not caster.wolfatk3_times then
    self.caster.wolfatk3_times = 2
  end
  local target = self.target
  self.caster.wolfatk3_trigger = true
  local target = self.target
  local position2 = target.position[2] - caster.position[2]
  local position1 = target.position[1] + caster.direction * 70
  if target.buff_effects.stable or position1 > ed.engine.stage_rect.maxX or position1 < ed.engine.stage_rect.minX then
    position1 = position1 - caster.direction * 140
  end
  local distance1 = position1 - caster.position[1]
  if distance1 * caster.direction < 0 then
    caster.direction = -caster.direction
  end
  if distance1 < 0 then
    distance1 = -distance1
  end
  local v = math.max(distance1 / Wolf.atk3_duration, 120)
  local time = distance1 / v
  if distance1 < 50 then
    v = 0
  end
  if time < 0.125 then
    time = 0.125
  end
  caster.temp_walk_v = {
    caster.direction * v,
    0
  }
  caster.wolfatk3_trigger_timer = time
  self.caster.wolfatk3_trigger = true
end

function Wolf.skillatk3_finish(basefunc, self)
  basefunc(self)
  local caster = self.caster
  if caster.wolfatk3_times > 0 then
    caster.wolfatk3_times = caster.wolfatk3_times - 1
  else
    self.cd_remaining = Wolf.atk3_cd
    caster.wolfatk3_times = nil
    caster.global_cd = 3
  end
end

function Wolf.skillatk2_buff_onRemoved(basefunc, self)
  basefunc(self)
  local owner = self.owner
  local skillatk2 = self.caster.skills.Wolf_atk2
  local beardmg = owner.battledata.beardmg - self.base
  local hpr = -math.min(beardmg * Wolf.dot_ratio / 100, skillatk2.info["Script Arg1"]) / 5
  local binfo = ed.lookupDataTable("Buff", nil, Wolf.bleed_bid)
  if owner:isAlive() then
    local buff = owner:addBuff(binfo, self.caster)
    buff:setAttribute("HPR", hpr)
    self.owner:rebuild()
  end
end

function Wolf.skillatk2_createBuff(basefunc, self, target)
  local buff = basefunc(self, target)
  buff.base = target.battledata.beardmg
  buff.onRemoved = override(buff.onRemoved, Wolf.skillatk2_buff_onRemoved)
  return buff
end

function Wolf.control_buff_counter(unit, dt)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    detaunt = true,
    unmanual = true,
    polymorph = true,
    doom = true,
    icefrozen = true
  }
  local skillawake = unit.skills.Wolf_awake
  local controlcount = 0
  for bufftarget in ed.engine:foreachAliveUnit(unit.camp) do
    if not bufftarget:isHero() then
    elseif bufftarget.config.is_summoned then
    else
      local negative_exist = false
      for k, v in pairs(bufftarget.buff_effects) do
        if negative_effects[k] then
          if not bufftarget.wolfcontrolbuff then
            local binfo = ed.lookupDataTable("Buff", nil, Wolf.control_bid)
            if bufftarget:isAlive() then
              local controlbuff = bufftarget:addBuff(binfo, unit)
              controlbuff:setAttribute("ARM", skillawake.info["Script Arg1"])
              controlbuff:setAttribute("MR", skillawake.info["Script Arg2"])
              bufftarget:rebuild()
            end
            bufftarget.wolfcontrolbuff = true
          end
          if not bufftarget.wolfbufftimer then
            controlcount = controlcount + 1
            bufftarget.wolfbufftimer = 2
          end
          negative_exist = true
        end
      end
      if bufftarget.wolfbufftimer then
        if 0 < bufftarget.wolfbufftimer then
          bufftarget.wolfbufftimer = bufftarget.wolfbufftimer - dt
        else
          bufftarget.wolfbufftimer = nil
        end
      end
      if bufftarget.wolfcontrolbuff and not negative_exist then
        for _, buff in ipairs(bufftarget.buff_list) do
          if buff.info.ID == Wolf.control_bid then
            buff.timer = 0
            bufftarget.wolfcontrolbuff = nil
          end
        end
      end
    end
  end
  return controlcount
end

function Wolf.hero_update(basefunc, unit, dt)
  local originD = unit.direction
  basefunc(unit, dt)
  local skillawake = unit.skills.Wolf_awake
  if skillawake then
    local controlcount = Wolf.control_buff_counter(unit, dt)
    if 0 < controlcount then
      local binfo = ed.lookupDataTable("Buff", nil, Wolf.anger_bid)
      if unit:isAlive() then
        local angerbuff = unit:addBuff(binfo, unit)
        angerbuff:setAttribute("AD", skillawake.info["Script Arg3"] * controlcount)
        unit:rebuild()
      end
    end
  end
  local current_skill = unit.current_skill
  local skillatk3 = unit.skills.Wolf_atk3
  if skillatk3 and current_skill == skillatk3 and (skillatk3.attack_counter == 1 or skillatk3.attack_counter == 2) and originD ~= unit.direction then
    unit.direction = originD
  end
  if skillatk3 and current_skill == skillatk3 and skillatk3.attack_counter == 1 and unit.wolfatk3_trigger_timer and unit.wolfatk3_trigger then
    unit.wolfatk3_trigger_timer = unit.wolfatk3_trigger_timer - dt
    if 0 >= unit.wolfatk3_trigger_timer then
      unit.wolfatk3_trigger_timer = nil
      unit.wolfatk3_trigger = nil
      unit.walk_v = {0, 0}
      skillatk3:startPhase(2)
    end
  end
end

function Wolf.init_hero(hero)
  hero.update = override(hero.update, Wolf.hero_update)
  local skillult = hero.skills.Wolf_ult
  local skillultb = hero.skills.Wolf_ultb
  local skillultc = hero.skills.Wolf_ultc
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, Wolf.skillult_createProjectile)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Wolf.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, Wolf.skillult_finish)
    skillult.selectTarget = override(skillult.selectTarget, Wolf.skillult_selectTarget)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Wolf.skillult_takeEffectOn)
    skillultc.createBuff = override(skillultc.createBuff, Wolf.skillultc_createBuff)
    skillultc.createProjectile = override(skillultc.createProjectile, Wolf.skillultc_createProjectile)
  end
  local skillatk2 = hero.skills.Wolf_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, Wolf.skillatk2_createBuff)
    skillatk2.selectTarget = override(skillatk2.selectTarget, Wolf.focus_selectTarget)
  end
  local skillatk3 = hero.skills.Wolf_atk3
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Wolf.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, Wolf.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, Wolf.skillatk3_finish)
    skillatk3.selectTarget = override(skillatk3.selectTarget, Wolf.focus_selectTarget)
  end
  local skillatk4 = hero.skills.Wolf_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Wolf.skillatk4_createBuff)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, Wolf.skillatk4_takeEffectAt)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Wolf.skillatk4_takeEffectOn)
    skillatk4.selectTarget = override(skillatk4.selectTarget, Wolf.focus_selectTarget)
  end
  return hero
end

return Wolf.init_hero
