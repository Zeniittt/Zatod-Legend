module("ed.battlehero", package.seeall)
local ed = ed
EM = {}
EM.buff_inv = 10005803
EM.buff_undead_id = 10005804
EM.trigger_ember_interval = 0.3
EM.interval3 = 1
EM.interval4 = 0.4
EM.emberMaxCount = 6
EM.fashion_1 = 581

function EM.EM_removeSignedBuffer(basefunc, self)
  local skillultevo = self.skills.EM_ultevo
  local ember_list = self.ember_list_EM
  if self.state == ed.emUnitState_Dying then
    if self.buff_effects.doom then
      for i, ember in ipairs(ember_list) do
        if skillultevo and ember.myregion and self.emberCount > 0 then
          ember.myregion.timer = 0
          self.emberCount = self.emberCount - 1
          ember:terminate()
        end
      end
      self.ember_list_EM = {}
    end
    basefunc(self)
  end
end

function EM.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reson = basefunc(skill, target)
  local hero = skill.caster
  local currentSkill = hero.current_skill
  local skillatk4 = hero.skills.EM_atk4
  if result then
    if currentSkill and currentSkill == skillatk4 then
      return false, "atk4ing"
    else
      return result
    end
  end
  return result
end

function EM.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity)
  local lost = basefunc(hero, damage, immunity)
  local owner = hero
  local ember_list = owner.ember_list_EM
  local emberCount = #ember_list
  if emberCount <= 0 then
    return lost
  end
  if owner.buff_effects.doom then
    return lost
  end
  if lost < owner.hp then
    return lost
  else
    for i, ember in ipairs(ember_list) do
      ember.counter_down = (i - 1) * EM.trigger_ember_interval
    end
    owner.ember_list_EM = {}
    local bid = EM.buff_inv
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    local hideTime = (emberCount - 1) * EM.trigger_ember_interval
    buff.timer = hideTime + 1
    owner:addBuff(buff, owner)
    owner.global_cd = hideTime + 0.5
    return 0
  end
  return lost
end

function EM.undead_buff_OnRemoved(basefunc, buff)
  local owner = buff.owner
  owner.ember_list_EM = {}
  local skillatk4 = owner.skills.EM_atk4
  if skillatk4 then
    local skill = owner.current_skill
    if skill == skillatk4 and not ed.engine.beingEnd then
      skill:onAttackFrame()
      skill:gotoEventIdx(2)
    end
  end
  basefunc(buff)
end

function EM.reset(basefunc, hero)
  basefunc(hero)
  local bid = EM.buff_undead_id
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  buff.onRemoved = override(buff.onRemoved, EM.undead_buff_OnRemoved)
  hero:addBuff(buff, hero)
  hero.emberCount = 0
end

function EM.fire_update(basefunc, projectile, dt)
  local self = projectile
  if self.birthtick == ed.engine.ticks then
    return
  end
  self.previous_position = {
    self.position[1],
    self.position[2]
  }
  ed.Entity.update(self, dt)
  local info = self.skill.info
  self.height = self.height + self.zSpeed * dt
  self.zSpeed = self.zSpeed + info["Tile Gravity"] * dt
  self.distance = self.distance + info["Tile XY Speed"] * dt
  local counter_down = self.counter_down
  if counter_down then
    counter_down = counter_down - dt
    if counter_down <= 0 then
      local skillult_ember_explode = self.skill.caster.skillult_ember_explode
      self.skill.caster.position = {
        self.position[1],
        self.position[2]
      }
      skillult_ember_explode:takeEffectAt(self.position)
      self:terminate()
      return self
    end
    self.counter_down = counter_down
  end
  local h = self.height
  local aoe = self.skill.info["AOE Origin"]
  if not self.terminated and h <= 0 and aoe then
    self.skill.curFire = self
    self.skill:takeEffectAt(self.position, self.skill.caster)
    self:terminate()
  end
  if not self.terminated and (self:isOutOfStage() or h < 0 or self.distance > self.max_distance) then
    self:terminate()
  end
  return self
end

function EM.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  attack_counter = attack_counter + 1
  skill.attack_counter = attack_counter
  local targetPositions = {
    {
      140 + 80 * (ed.rand() - 0.5),
      50 + 50 * (ed.rand() - 1.5)
    },
    {
      400 + 80 * (ed.rand() - 0.5),
      50 + 50 * (ed.rand() - 1.5)
    },
    {
      660 + 80 * (ed.rand() - 0.5),
      50 + 50 * (ed.rand() - 1.5)
    }
  }
  local initdir = skill.caster:getInitDir()
  if initdir == -1 then
    for i = 1, 3 do
      targetPositions[i][1] = 800 - targetPositions[i][1]
    end
  end
  local hero = skill.caster
  local ember_list = hero.ember_list_EM
  table.sort(targetPositions, function(a, b)
    local da = ed.edpSub(a, hero.position)
    local db = ed.edpSub(b, hero.position)
    return ed.edpLengthSQ(da) < ed.edpLengthSQ(db)
  end)
  local xySpeed = skill.info["Tile XY Speed"]
  for i = 1, 3 do
    local projectile = skill:createProjectile()
    local d = ed.edpSub(targetPositions[i], projectile.position)
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), xySpeed)
    projectile.height = 1
    local t = ed.edpLengthSQ(d) ^ 0.5 / xySpeed
    projectile.zSpeed = -1 / t
    projectile.update = override(projectile.update, EM.fire_update)
    ed.engine:addProjectile(projectile)
    projectile.ember_id = #ember_list + 1
    ember_list[projectile.ember_id] = projectile
  end
end

function EM.ember_update(basefunc, projectile, dt)
  local self = projectile
  local caster = self.caster
  if self.birthtick == ed.engine.ticks then
    return
  end
  self.previous_position = {
    self.position[1],
    self.position[2]
  }
  ed.Entity.update(self, dt)
  local counter_down = self.counter_down
  if counter_down then
    counter_down = counter_down - dt
    if counter_down <= 0 or not caster:isAlive() then
      self.skill.caster.position = {
        self.position[1],
        self.position[2]
      }
      self.skill:takeEffectAt(self.position)
      local skillultevo = caster.skills.EM_ultevo
      if skillultevo and self.myregion and 0 < caster.emberCount then
        self.myregion.timer = 0
        caster.emberCount = caster.emberCount - 1
      end
      self:terminate()
    end
    self.counter_down = counter_down
  end
  return self
end

function EM.skillult_takeEffectAt(basefunc, skill, location, source)
  local hero = skill.caster
  local ember_list = hero.ember_list_EM
  local projectile = hero.skillult_ember_explode:createProjectile()
  projectile.position = {
    location[1],
    location[2]
  }
  projectile.velocity = {
    0.01 * hero:getInitDir(),
    0
  }
  projectile.update = override(projectile.update, EM.ember_update)
  ed.engine:addProjectile(projectile)
  local skillultevo = hero.skills.EM_ultevo
  if skillultevo and skill.evo_rank and skill.evo_rank >= 3 and (not ed.engine.nightmareMode or hero.emberCount <= EM.emberMaxCount) then
    skillultevo.target = skillultevo.caster
    local region = skillultevo:createRegion()
    projectile.myregion = region
    region.position = location
    ed.engine:addRegion(region)
    hero.emberCount = hero.emberCount + 1
  end
  local fire = skill.curFire
  if ember_list[fire.ember_id] then
    ember_list[fire.ember_id] = projectile
  end
  projectile.counter_down = fire.counter_down
  projectile.i = fire.ember_id
  basefunc(skill, location, source)
end

function EM.distanceSQ(a, b)
  return ed.edpDistanceSQ(a.position, b.position) ^ 0.5
end

function EM.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local list = {}
  for enemyUnit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if not enemyUnit.buff_effects.untargetable and not enemyUnit.buff_effects.invulnerable then
      list[#list + 1] = enemyUnit
    end
  end
  local caster = skill.caster
  table.sort(list, function(a, b)
    return EM.distanceSQ(caster, a) < EM.distanceSQ(caster, b)
  end)
  local info = skill.info
  local effect_name = info["Point Effect"]
  local max = 1
  if skill.evo_rank and skill.evo_rank >= 3 then
    max = skill.evo_rank3["Script Arg1"]
  end
  for i = 1, max do
    if i <= #list then
      local targ = list[i]
      if math.abs(caster.position[1] - targ.position[1]) <= 320 then
        skill:takeEffectOn(targ, source)
        if ed.run_with_scene and effect_name then
          local effect_z = info["Point Zorder"] or 0
          ed.scene:playEffectOnScene(effect_name, targ.position, {
            caster.direction,
            1
          }, nil, effect_z)
        end
      end
    end
  end
end

function EM.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  local fashionId = caster.fashion_id
  if fashionId and fashionId == EM.fashion_1 then
    buff:setAttribute("Effect", "eff_buff_EM_fashion_1_atk2.cha")
  end
  return buff
end

function EM.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local adratio = skill.info["Script Arg4"]
  if skill.evo_rank and skill.evo_rank >= 3 then
    adratio = skill.evo_rank3["Script Arg1"]
  end
  local shield = skill.info["Script Arg2"] + adratio * caster.attribs.AD
  if skill.evo_rank and skill.evo_rank >= 1 then
    shield = shield + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    shield = shield + skill.evo_rank2["Script Arg1"]
  end
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if caster.attribs.ShieldIncrease then
    ShieldIncrease = caster.attribs.ShieldIncrease
  end
  if caster.attribs.ShieldWeak then
    ShieldWeak = caster.attribs.ShieldWeak
  end
  local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
  buff.shield = shield * (caster.config.hp_mod or 1) * shieldratio
  buff.attack_timer = EM.interval3
  buff.update = override(buff.update, EM.skillatk3_buffUpdate)
  local fashionId = caster.fashion_id
  if fashionId and fashionId == EM.fashion_1 then
    buff:setAttribute("Effect", "eff_buff_EM_fashion_1_atk3.cha")
  end
  return buff
end

function EM.skillatk3_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  local caster = buff.caster
  while timer <= 0 do
    timer = timer + EM.interval3
    local skill = buff.owner.skills.EM_atk3_burn
    skill:takeEffectAt(caster.position, caster)
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function EM.skillatk4_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    buff.i = buff.i + 1
    local owner = buff.owner
    local targ
    local list = buff.attacked_list
    for enemyUnit in ed.engine:foreachAliveUnit(buff.skill:affectedCamp()) do
      if not enemyUnit.buff_effects.untargetable and not enemyUnit.buffManager.invisible then
        local hasAttacked = false
        for _, unit in pairs(list) do
          if enemyUnit == unit then
            hasAttacked = true
            break
          end
        end
        if not hasAttacked then
          targ = enemyUnit
          break
        end
      end
    end
    local skill = buff.skill
    if targ then
      timer = timer + EM.interval4
      list[#list + 1] = targ
      local point_effect_name = buff.point_effect_name
      local initdir = owner:getInitDir()
      local ranDir = ed.rand() < 0.5 and initdir or -initdir
      owner.position = {
        targ.position[1] - ranDir * 100,
        targ.position[2]
      }
      owner.direction = ranDir
      skill:takeEffectAt(targ.position, owner)
      if buff.i == 3 and skill.evo_rank and 3 <= skill.evo_rank then
        local skillatk2 = owner.skills.EM_atk2
        skillatk2:takeEffectAt(owner.position, owner)
      end
    else
      buff.timer = EM.interval4
      timer = 999
      skill:onAttackFrame()
      skill:gotoEventIdx(2)
      owner.global_cd = 3
      owner.direction = buff.ori_dir
    end
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function EM.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  attack_counter = attack_counter + 1
  skill.attack_counter = attack_counter
  local owner = skill.caster
  if attack_counter == 1 then
    EM.skillatk4_func_hideBuffEffect(owner)
    skill.ori_pos = owner.position
    local bid = EM.buff_inv
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    buff.update = override(buff.update, EM.skillatk4_buffUpdate)
    buff.attack_timer = 0
    buff.skill = skill
    skill.buff = buff
    buff.attacked_list = {}
    buff.ori_dir = owner.direction
    buff.i = 0
    local info = skill.info
    buff.point_effect_name = info["Point Effect"]
    buff.effect_z = info["Point Zorder"] or 0
    owner:addBuff(buff, owner)
    owner:setMP(owner.mp + info["Gain MP"] * ed.engine.mp_bonus)
  elseif attack_counter == 2 then
    owner.position = skill.ori_pos
    EM.skillatk4_func_resetBuffEffect(owner)
    skill.buff = nil
  end
end

function EM.skillatk4_func_hideBuffEffect(unit)
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

function EM.skillatk4_func_resetBuffEffect(unit)
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

function EM.skillatk4_interrupt(basefunc, skill)
  local buff = skill.buff
  if buff then
    local owner = skill.caster
    owner.direction = buff.ori_dir
    buff.timer = 0
    owner.position = skill.ori_pos
    skill.buff = nil
  end
  basefunc(skill)
end

function EM.init_hero(hero)
  local skillult = hero.skills.EM_ult
  local skillatk2 = hero.skills.EM_atk2
  local skillatk3 = hero.skills.EM_atk3
  local skillatk4 = hero.skills.EM_atk4
  local skillult_ember_explode = hero.skills.EM_ult_ember_explode
  hero.reset = override(hero.reset, EM.reset)
  hero.removeSignedBuffer = override(hero.removeSignedBuffer, EM.EM_removeSignedBuffer)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, EM.hero_getLostHPAfterImmunity)
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, EM.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, EM.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, EM.skillult_takeEffectAt)
  end
  if skillult_ember_explode then
    if skillult and skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult_ember_explode.info = ed.wraptable(skillult_ember_explode.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    skillult_ember_explode.level = skillult.level
    hero.skillult_ember_explode = skillult_ember_explode
  end
  hero.ember_list_EM = {}
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, EM.skillatk2_takeEffectAt)
    skillatk2.createBuff = override(skillatk2.createBuff, EM.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, EM.skillatk3_createBuff)
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, EM.skillatk4_onAttackFrame)
    skillatk4.interrupt = override(skillatk4.interrupt, EM.skillatk4_interrupt)
  end
  if hero.fashion_id == EM.fashion_1 then
    if hero.skills.EM_atk3_burn then
      hero.skills.EM_atk3_burn.info["Impact Effect"] = "eff_impact_EM_fashion_1_atk3.cha"
    end
    if hero.skills.EM_atk4 then
      hero.skills.EM_atk4.info["Point Effect"] = "eff_point_EM_fashion_1_atk4.cha"
    end
    if skillult then
      skillult.info["Tile Art"] = "eff_tile_EM_fashion_1_ult.cha"
    end
    if hero.skills.EM_ult_ember_explode then
      hero.skills.EM_ult_ember_explode.info["Point Effect"] = "eff_point_EM_fashion_1_ult.cha"
      hero.skills.EM_ult_ember_explode.info["Tile Art"] = "eff_tile_EM_fashion_1_ult2.cha"
    end
  end
  return hero
end

return EM.init_hero
