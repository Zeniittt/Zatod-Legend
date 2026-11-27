module("ed.battlehero", package.seeall)
local ed = ed
PVEBossEM = {}
PVEBossEM.buff_inv = 10035603
PVEBossEM.buff_undead_id = 10035604
PVEBossEM.trigger_ember_interval = 0.3
PVEBossEM.interval3 = 1
PVEBossEM.interval4 = 0.4

function PVEBossEM.PVEBossEM_removeSignedBuffer(basefunc, self)
  local skillultevo = self.skills.PVEBossEM_ultevo
  local ember_list = self.ember_list_PVEBossEM
  if self.state == ed.emUnitState_Dying then
    if self.buff_effects.doom then
      for i, ember in ipairs(ember_list) do
        if skillultevo and ember.myregion and self.emberCount > 0 then
          ember.myregion.timer = 0
          self.emberCount = self.emberCount - 1
          ember:terminate()
        end
      end
      self.ember_list_PVEBossEM = {}
    end
    basefunc(self)
  end
end

function PVEBossEM.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reson = basefunc(skill, target)
  local hero = skill.caster
  local currentSkill = hero.current_skill
  local skillatk4 = hero.skills.PVEBossEM_atk4
  if result then
    if currentSkill and currentSkill == skillatk4 then
      return false, "atk4ing"
    else
      return result
    end
  end
  return result
end

function PVEBossEM.undead_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local ember_list = owner.ember_list_PVEBossEM
  local emberCount = #ember_list
  if owner.emberTime and owner.emberTime < 10 then
    owner.emberTime = owner.emberTime + dt
  end
  if owner.emberTime >= 10 then
    for i, ember in ipairs(ember_list) do
      ember.counter_down = (i - 1) * PVEBossEM.trigger_ember_interval
    end
    owner.ember_list_PVEBossEM = {}
    local bid = PVEBossEM.buff_inv
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    local hideTime = (emberCount - 1) * PVEBossEM.trigger_ember_interval
    buff.timer = hideTime + 1
    owner:addBuff(buff, owner)
    owner.global_cd = hideTime + 0.5
    owner.emberTime = 0
  end
end

function PVEBossEM.undead_buff_OnRemoved(basefunc, buff)
  local owner = buff.owner
  owner.ember_list_PVEBossEM = {}
  local skillatk4 = owner.skills.PVEBossEM_atk4
  if skillatk4 then
    local skill = owner.current_skill
    if skill == skillatk4 and not ed.engine.beingEnd then
      skill:onAttackFrame()
      skill:gotoEventIdx(2)
    end
  end
  basefunc(buff)
end

function PVEBossEM.reset(basefunc, hero)
  basefunc(hero)
  local bid = PVEBossEM.buff_undead_id
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  buff.update = override(buff.update, PVEBossEM.undead_buff_update)
  buff.onRemoved = override(buff.onRemoved, PVEBossEM.undead_buff_OnRemoved)
  hero:addBuff(buff, hero)
  hero.emberCount = 0
  hero.emberTime = 0
  hero.BossEmber_count = 3
end

function PVEBossEM.fire_update(basefunc, projectile, dt)
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

function PVEBossEM.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  attack_counter = attack_counter + 1
  skill.attack_counter = attack_counter
  local hero = skill.caster
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
    },
    {
      160 + 80 * (ed.rand() - 0.5),
      50 + 50 * (ed.rand() - 1.5)
    },
    {
      380 + 80 * (ed.rand() - 0.5),
      50 + 50 * (ed.rand() - 1.5)
    },
    {
      640 + 80 * (ed.rand() - 0.5),
      50 + 50 * (ed.rand() - 1.5)
    }
  }
  local initdir = skill.caster:getInitDir()
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 20050011 then
      hero.BossEmber_count = 4
    end
    if tbuff.info.ID == 20050012 then
      hero.BossEmber_count = 5
    end
    if tbuff.info.ID == 20050013 then
      hero.BossEmber_count = 6
    end
  end
  local BossEmber_count = hero.BossEmber_count
  if initdir == -1 then
    for i = 1, BossEmber_count do
      targetPositions[i][1] = 800 - targetPositions[i][1]
    end
  end
  hero.emberTime = 0
  local ember_list = hero.ember_list_PVEBossEM
  table.sort(targetPositions, function(a, b)
    local da = ed.edpSub(a, hero.position)
    local db = ed.edpSub(b, hero.position)
    return ed.edpLengthSQ(da) < ed.edpLengthSQ(db)
  end)
  local xySpeed = skill.info["Tile XY Speed"]
  for i = 1, BossEmber_count do
    local projectile = skill:createProjectile()
    local d = ed.edpSub(targetPositions[i], projectile.position)
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), xySpeed)
    projectile.height = 1
    local t = ed.edpLengthSQ(d) ^ 0.5 / xySpeed
    projectile.zSpeed = -1 / t
    projectile.update = override(projectile.update, PVEBossEM.fire_update)
    ed.engine:addProjectile(projectile)
    projectile.ember_id = #ember_list + 1
    ember_list[projectile.ember_id] = projectile
  end
end

function PVEBossEM.ember_update(basefunc, projectile, dt)
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
      local skillultevo = caster.skills.PVEBossEM_ultevo
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

function PVEBossEM.skillult_takeEffectAt(basefunc, skill, location, source)
  local hero = skill.caster
  local ember_list = hero.ember_list_PVEBossEM
  local projectile = hero.skillult_ember_explode:createProjectile()
  projectile.position = {
    location[1],
    location[2]
  }
  projectile.velocity = {
    0.01 * hero:getInitDir(),
    0
  }
  projectile.update = override(projectile.update, PVEBossEM.ember_update)
  ed.engine:addProjectile(projectile)
  local skillultevo = hero.skills.PVEBossEM_ultevo
  if skillultevo and skill.evo_rank and skill.evo_rank >= 3 and (not ed.engine.nightmareMode or hero.emberCount <= PVEBossEM.emberMaxCount) then
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

function PVEBossEM.distanceSQ(a, b)
  return ed.edpDistanceSQ(a.position, b.position) ^ 0.5
end

function PVEBossEM.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local list = {}
  local caster = skill.caster
  for enemyUnit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if not enemyUnit.buff_effects.untargetable and not enemyUnit.buff_effects.invulnerable then
      list[#list + 1] = enemyUnit
    end
  end
  local caster = skill.caster
  table.sort(list, function(a, b)
    return PVEBossEM.distanceSQ(caster, a) < PVEBossEM.distanceSQ(caster, b)
  end)
  local info = skill.info
  local effect_name = info["Point Effect"]
  local max = 2
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050021 then
      max = 3
    end
    if tbuff.info.ID == 20050022 then
      max = 4
    end
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

function PVEBossEM.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function PVEBossEM.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local adratio = skill.info["Script Arg4"]
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050031 then
      adratio = adratio + 0.5
    end
    if tbuff.info.ID == 20050032 then
      adratio = adratio + 1
    end
    if tbuff.info.ID == 20050033 then
      adratio = adratio + 1.5
    end
    if tbuff.info.ID == 20050034 then
      adratio = adratio + 2
    end
  end
  local shield = buff.shield + skill.info["Script Arg2"] + adratio * caster.attribs.AD
  buff.shield = shield
  buff.attack_timer = PVEBossEM.interval3
  buff.update = override(buff.update, PVEBossEM.skillatk3_buffUpdate)
  return buff
end

function PVEBossEM.skillatk3_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  local caster = buff.caster
  while timer <= 0 do
    timer = timer + PVEBossEM.interval3
    local skill = buff.owner.skills.PVEBossEM_atk3_burn
    skill:takeEffectAt(caster.position, caster)
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function PVEBossEM.skillatk4_buffUpdate(basefunc, buff, dt)
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
      timer = timer + PVEBossEM.interval4
      list[#list + 1] = targ
      local initdir = owner:getInitDir()
      local ranDir = ed.rand() < 0.5 and initdir or -initdir
      owner.position = {
        targ.position[1] - ranDir * 100,
        targ.position[2]
      }
      owner.direction = ranDir
      skill:takeEffectAt(targ.position, owner)
      if buff.i == 3 then
        local skillatk2 = owner.skills.PVEBossEM_atk2
        skillatk2:takeEffectOn(targ, owner)
      end
    else
      buff.timer = PVEBossEM.interval4
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

function PVEBossEM.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  attack_counter = attack_counter + 1
  skill.attack_counter = attack_counter
  local owner = skill.caster
  if attack_counter == 1 then
    skill.ori_pos = owner.position
    local bid = PVEBossEM.buff_inv
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    buff.update = override(buff.update, PVEBossEM.skillatk4_buffUpdate)
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
    skill.buff = nil
  end
end

function PVEBossEM.skillatk4_interrupt(basefunc, skill)
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

function PVEBossEM.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and target and isHit then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 20050041 then
        local bid1 = 20050044
        local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
        local buff1 = ed.BuffCreate(binfo1, target, caster)
        target:addBuff(buff1, caster)
      end
      if tbuff.info.ID == 20050042 then
        local bid2 = 20050045
        local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
        local buff2 = ed.BuffCreate(binfo2, target, caster)
        target:addBuff(buff2, caster)
      end
      if tbuff.info.ID == 20050043 then
        local bid3 = 20050046
        local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
        local buff3 = ed.BuffCreate(binfo3, target, caster)
        target:addBuff(buff3, caster)
      end
    end
  end
  return isHit, dmg
end

function PVEBossEM.init_hero(hero)
  local skillult = hero.skills.PVEBossEM_ult
  local skillatk2 = hero.skills.PVEBossEM_atk2
  local skillatk3 = hero.skills.PVEBossEM_atk3
  local skillatk4 = hero.skills.PVEBossEM_atk4
  local skillult_ember_explode = hero.skills.PVEBossEM_ult_explode
  hero.reset = override(hero.reset, PVEBossEM.reset)
  hero.removeSignedBuffer = override(hero.removeSignedBuffer, PVEBossEM.PVEBossEM_removeSignedBuffer)
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, PVEBossEM.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, PVEBossEM.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, PVEBossEM.skillult_takeEffectAt)
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
  hero.ember_list_PVEBossEM = {}
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, PVEBossEM.skillatk2_takeEffectAt)
    skillatk2.createBuff = override(skillatk2.createBuff, PVEBossEM.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, PVEBossEM.skillatk3_createBuff)
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
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, PVEBossEM.skillatk4_onAttackFrame)
    skillatk4.interrupt = override(skillatk4.interrupt, PVEBossEM.skillatk4_interrupt)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, PVEBossEM.skillatk4_takeEffectOn)
  end
  return hero
end

return PVEBossEM.init_hero
