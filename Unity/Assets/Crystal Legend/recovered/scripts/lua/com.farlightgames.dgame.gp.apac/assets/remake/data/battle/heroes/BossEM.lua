module("ed.battlehero", package.seeall)
local ed = ed
BossEM = {}
BossEM.unitName = "BossEM"
BossEM.buff_atk4_id = 167
BossEM.buff_undead_id = 168
BossEM.buff_ult_imprison = 167
BossEM.Waiting_Buff_ID = 7
BossEM.trigger_ember_interval = 0.3
BossEM.interval3 = 1
BossEM.interval4 = 0.2

function BossEM.shield_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local ember_list = owner.ember_list
  local emberCount = #ember_list
  for i, ember in ipairs(ember_list) do
    ember.counter_down = (emberCount - i) * BossEM.trigger_ember_interval
  end
  local ember = ember_list[emberCount]
  owner.ember_list = {}
  local bid = BossEM.buff_ult_imprison
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, owner)
  local hideTime = (emberCount - 1) * BossEM.trigger_ember_interval
  buff.timer = hideTime + 1
  owner:addBuff(buff, owner)
  owner.global_cd = hideTime + 0.5
  local skillult = owner.skills[BossEM.unitName .. "_ult"]
  skillult.cd_remaining = 7
end

function BossEM.undead_buff_OnRemoved(basefunc, buff)
  local owner = buff.owner
  local skill4 = owner.skills[BossEM.unitName .. "_atk4"]
  if skill4 then
    local skill = owner.current_skill
    if skill == skill4 then
      skill:onAttackFrame()
      skill:gotoEventIdx(2)
    end
  end
  basefunc(buff)
end

function BossEM.fire_update(basefunc, projectile, dt)
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
  local h = self.height
  local aoe = self.skill.info["AOE Origin"]
  if not self.terminated and h <= 0 and aoe then
    self.skill:takeEffectAt(self.position, self.skill.caster)
    self:terminate()
  end
  if not self.terminated and h < 0 then
    self:terminate()
  end
  return self
end

function BossEM.releaseEmbersAtStart(unit)
  local skill = unit.skills[BossEM.unitName .. "_ult"]
  local targetPositions = {
    {
      640 + 80 * (ed.rand() - 0.5),
      50 * (ed.rand() - 1.5)
    },
    {
      400 + 80 * (ed.rand() - 0.5),
      50 * (ed.rand() - 1.5)
    },
    {200, -20}
  }
  local initdir = skill.caster:getInitDir()
  if initdir == -1 then
    for i = 1, 3 do
      targetPositions[i][1] = 800 - targetPositions[i][1]
    end
  end
  local xySpeed = skill.info["Tile XY Speed"]
  for i = 1, 3 do
    local projectile = skill:createProjectile()
    local d = ed.edpSub(targetPositions[i], projectile.position)
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), xySpeed)
    projectile.height = 1
    local t = ed.edpLengthSQ(d) ^ 0.5 / xySpeed
    projectile.zSpeed = -1 / t
    projectile.update = override(projectile.update, BossEM.fire_update)
    ed.engine:addProjectile(projectile)
  end
end

function BossEM.waiting_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.initted then
    return
  end
  if buff.timer > 3.5 then
    return
  end
  buff.initted = true
  BossEM.releaseEmbersAtStart(buff.owner)
end

function BossEM.reset(basefunc, hero)
  basefunc(hero)
  local bid = BossEM.buff_undead_id
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  buff.onRemoved = override(buff.onRemoved, BossEM.undead_buff_OnRemoved)
  hero:addBuff(buff, hero)
  local owner = hero
  local bid = 176
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, owner)
  owner:addBuff(buff, owner)
  local bid = BossEM.Waiting_Buff_ID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, owner)
  buff.update = override(buff.update, BossEM.waiting_buff_update)
  buff.onRemoved = override(buff.onRemoved, BossEM.shield_onRemoved)
  owner:addBuff(buff, owner)
  buff.timer = 4
  local dir = hero:getInitDir()
  hero.position[1] = 400 - 540 * dir
end

function BossEM.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  attack_counter = attack_counter + 1
  skill.attack_counter = attack_counter
  local targetPositions = {
    {
      140 + 80 * (ed.rand() - 0.5),
      50 * (ed.rand() - 1.5)
    },
    {
      400 + 80 * (ed.rand() - 0.5),
      50 * (ed.rand() - 1.5)
    },
    {
      660 + 80 * (ed.rand() - 0.5),
      50 * (ed.rand() - 1.5)
    }
  }
  local initdir = skill.caster:getInitDir()
  if initdir == -1 then
    for i = 1, 3 do
      targetPositions[i][1] = 800 - targetPositions[i][1]
    end
  end
  table.sort(targetPositions, function()
    return ed.rand() < 0.5
  end)
  local xySpeed = skill.info["Tile XY Speed"]
  for i = 1, 3 do
    local projectile = skill:createProjectile()
    local d = ed.edpSub(targetPositions[i], projectile.position)
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), xySpeed)
    projectile.height = 1
    local t = ed.edpLengthSQ(d) ^ 0.5 / xySpeed
    projectile.zSpeed = -1 / t
    projectile.update = override(projectile.update, BossEM.fire_update)
    ed.engine:addProjectile(projectile)
  end
  local skill3 = skill.caster.skills[BossEM.unitName .. "_atk3"]
  skill3.cd_remaining = 4
end

function BossEM.ember_update(basefunc, projectile, dt)
  local self = projectile
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
    if counter_down <= 0 then
      self.skill.caster.position = {
        self.position[1],
        self.position[2]
      }
      self.skill:takeEffectAt(self.position)
      self:terminate()
    end
    self.counter_down = counter_down
  end
  return self
end

function BossEM.skillult_takeEffectAt(basefunc, skill, location, source)
  local hero = skill.caster
  local ember_list = hero.ember_list
  local projectile = hero.skillult_ember_explode:createProjectile()
  projectile.position = {
    location[1],
    location[2]
  }
  projectile.velocity = {
    0.01 * hero:getInitDir(),
    0
  }
  projectile.update = override(projectile.update, BossEM.ember_update)
  ed.engine:addProjectile(projectile)
  ember_list[#ember_list + 1] = projectile
  projectile.i = #ember_list
  basefunc(skill, location, source)
end

function BossEM.distanceSQ(a, b)
  return ed.edpDistanceSQ(a.position, b.position) ^ 0.5
end

function BossEM.skill2_takeEffectAt(basefunc, skill, location, source)
  local list = {}
  for enemyUnit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    list[#list + 1] = enemyUnit
  end
  local caster = skill.caster
  table.sort(list, function(a, b)
    return BossEM.distanceSQ(caster, a) < BossEM.distanceSQ(caster, b)
  end)
  local info = skill.info
  local effect_name = info["Point Effect"]
  for i = 1, 2 do
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

function BossEM.skillatk3_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + BossEM.interval3
    local skill = buff.owner.skills[BossEM.unitName .. "_atk3_burn"]
    skill:takeEffectAt()
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function BossEM.skill3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = BossEM.interval3 * 0.5
  buff.update = override(buff.update, BossEM.skillatk3_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, BossEM.shield_onRemoved)
  buff.timer = 999
  skill.caster.maxShield = buff.shield
  return buff
end

function BossEM.skill4_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    buff.i = buff.i + 1
    local owner = buff.owner
    local targ
    local list = buff.attacked_list
    for enemyUnit in ed.engine:foreachAliveUnit(buff.skill:affectedCamp()) do
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
    local skill = buff.skill
    if targ then
      timer = timer + BossEM.interval4
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
      if buff.i == 3 and ed.protoAwake(owner.proto, 155) then
        local skillawake = owner.skills[BossEM.unitName .. "_awake"]
        BossEM.skill2_takeEffectAt(basefunc, skillawake, owner.position, owner)
        ed.engine:deliverBall(owner, skillawake, 1)
      end
    else
      buff.timer = BossEM.interval4
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

function BossEM.skill4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  attack_counter = attack_counter + 1
  skill.attack_counter = attack_counter
  local owner = skill.caster
  if attack_counter == 1 then
    skill.ori_pos = owner.position
    local bid = BossEM.buff_atk4_id
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    buff.update = override(buff.update, BossEM.skill4_buffUpdate)
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

function BossEM.skill4_interrupt(basefunc, skill)
  local buff = skill.buff
  if buff then
    local owner = skill.caster
    owner.direction = buff.ori_dir
    owner:removeBuff(buff)
    owner.position = skill.ori_pos
    skill.buff = nil
  end
  basefunc(skill)
end

function BossEM.skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossEM.skill6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
end

function BossEM.skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2, 155)
  end
  local skillult = caster.skills[BossEM.unitName .. "_ult"]
  skillult.cd_remaining = 0
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
end

function BossEM.init_hero(hero)
  hero.reset = override(hero.reset, BossEM.reset)
  local skillult = hero.skills[BossEM.unitName .. "_ult"]
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossEM.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, BossEM.skillult_takeEffectAt)
  end
  local skillult_ember_explode = hero.skills[BossEM.unitName .. "_ult_ember_explode"]
  if skillult_ember_explode then
    skillult_ember_explode.level = skillult.level
    hero.skillult_ember_explode = skillult_ember_explode
  end
  hero.ember_list = {}
  local skill2 = hero.skills[BossEM.unitName .. "_atk2"]
  if skill2 then
    skill2.takeEffectAt = override(skill2.takeEffectAt, BossEM.skill2_takeEffectAt)
  end
  local skill3 = hero.skills[BossEM.unitName .. "_atk3"]
  if skill3 then
    skill3.createBuff = override(skill3.createBuff, BossEM.skill3_createBuff)
  end
  local skill4 = hero.skills[BossEM.unitName .. "_atk4"]
  if skill4 then
    skill4.onAttackFrame = override(skill4.onAttackFrame, BossEM.skill4_onAttackFrame)
    skill4.interrupt = override(skill4.interrupt, BossEM.skill4_interrupt)
  end
  local skill6 = hero.skills[BossEM.unitName .. "_turn"]
  if skill6 then
    skill6.start = override(skill6.start, BossEM.skill6_start)
    skill6.finish = override(skill6.finish, BossEM.skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, BossEM.skill6_onAttackFrame)
  end
  return hero
end

return BossEM.init_hero
