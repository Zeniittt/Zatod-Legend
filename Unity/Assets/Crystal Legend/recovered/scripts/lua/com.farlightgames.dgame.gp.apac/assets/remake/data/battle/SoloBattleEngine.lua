local base = ed.AutoChessEngineClass
local Engine = newclass(base.mt)
local instance

function Engine:getInstance()
  if not instance then
    local obj = base.create()
    setmetatable(obj, Engine.mt)
    instance = obj
  end
  return instance
end

function Engine.mt:__tostring()
  local logtb = {
    "---------------------------------------\n",
    string.format("tick %d\n", self.ticks or 0)
  }
  local idx = 1
  if self.unit_list then
    for i = 1, #self.unit_list do
      local unit = self.unit_list[i]
      if unit:isAlive() then
        logtb[2 + idx] = tostring(self.unit_list[i])
        idx = idx + 1
      end
    end
  end
  return table.concat(logtb)
end

ed.SoloBattleEngine = Engine:getInstance()

function Engine:ctMode2String()
  return "SoloMode"
end

function Engine:resetStage()
  self.enabled = true
  self.running = true
  self.beingEnd = false
  self.stage_rect = {
    minX = 0,
    maxX = 800,
    minY = -120,
    maxY = 120
  }
  self.ticks = 0
  self.next_tick = 0
  ed.tick_interval = 0.041666666666666664
  self.tick_interval = ed.tick_interval
  self.unit_list = {}
  self.projectile_list = {}
  self.FieldNpc_list = {}
  self.time_limit = 60
  self.alive_alliance_count = 0
  self.alive_enemy_count = 0
  self.alive_units = {}
  self.speed_rate = 1
  self.SoloMode = true
  self.stageId = 100001
  self.deadNum = 0
  self.stage_info = ed.lookupDataTable("Stage", self.stageId)
  self.mp_bonus = 1
  self.leftPos = ccp(235, -30)
  self.rightPos = ccp(565, -30)
  self.addSpeedMode = false
  do_battle_log = not do_battle_log and not ed.debug_mode and not ed.open_debug and ed.run_with_scene and ed.storage.getBool("FORCE_BATTLE_REPORT_FLAG")
  if ed.run_with_scene and not do_battle_log then
    math.randomseed(os.time())
    do_battle_log = math.random(100) <= 10
  end
end

function Engine:enterSolo()
  self:resetStage()
end

function Engine:addProjectile(projectile)
  if projectile then
    projectile.previous_position = {
      projectile.position[1],
      projectile.position[2]
    }
    table.insert(self.projectile_list, projectile)
    if ed.run_with_scene then
      local actor = ed.SoloProjectileActorCreate(projectile)
      ed.scene:addActor(actor)
      projectile.actor = actor
    end
  end
end

function Engine:getEndTick()
  for i = 0, 1440 do
    if self.running then
      self:tick()
    else
      return i
    end
  end
  return 1440
end

function Engine:jumpToTick(tick)
  for i = 1, tick do
    self:tick()
  end
end

function Engine:onUnitExit(unit)
  local list = self.alive_units
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  if unit.camp == ed.emCampPlayer then
    self.alive_alliance_count = self.alive_alliance_count - 1
  elseif unit.camp == ed.emCampEnemy then
    self.alive_enemy_count = self.alive_enemy_count - 1
  end
end

function Engine:addSoloUnit(unit)
  unit.previous_position = {
    unit.position[1],
    unit.position[2]
  }
  table.insert(self.unit_list, unit)
  table.insert(self.alive_units, unit)
  if unit.camp == ed.emCampPlayer then
    self.alive_alliance_count = self.alive_alliance_count + 1
    self.camp1Unit = unit
  elseif unit.camp == ed.emCampEnemy then
    self.alive_enemy_count = self.alive_enemy_count + 1
    self.camp2Unit = unit
  end
  unit:clearActor()
  unit:startWork()
  if not unit.actor and ed.run_with_scene and ed.scene.scene then
    unit.actor = ed.SoloUnitActorCreate(unit)
    ed.scene:addActor(unit.actor)
    unit.actor:update(0)
  end
end

function Engine:update(dt)
  if not self.canTick then
    return
  end
  self.next_tick = self.next_tick - dt * self.speed_rate
  if self.next_tick <= 0 then
    self:tick()
    while self.next_tick <= 0 do
      self.next_tick = self.next_tick + self.tick_interval
    end
  end
  if ed.run_with_scene and self.canTick and not self.addSpeedMode and self.ticks * self.tick_interval > 20 then
    ed.scene:setSpeedRate(2)
    self.addSpeedMode = true
    FireEvent("SoloBattleAddSpeed")
  end
end

function Engine:initSoloModeAttribs(unit, params)
  if not unit or not params then
    return
  end
  unit.cardTypeCount = #params._cards or 0
  for k, v in ipairs(params._cards or {}) do
    if 0 < v._level then
      unit.cards[v._cid] = v._level
    end
  end
  for k, v in ipairs(params._cards or {}) do
    local buffId = ed.getDataTable("SoloCardSkill")[v._cid]["Buff ID"]
    if buffId ~= 0 then
      local buffTb = ed.lookupDataTable("Buff", nil, buffId)
      if v._level > #ed.getDataTable("SoloCardSkill")[v._cid]["Level Arg 1"] then
        print("level:", v._level, "is too high for card:", v._cid)
        error("error level")
      end
      local buff = ed.BuffCreate(buffTb, unit, unit, {
        rank = v._level
      })
      unit:addBuff(buff, unit)
    end
  end
  local level = 1
  for k, v in ipairs(params._card_factions or {}) do
    if 0 < v._level then
      print("faction:", v._faction, "level:", v._level)
      local buffTb = ed.lookupDataTable("Buff", nil, ed.getDataTable("SoloCardTag")[v._faction]["Buff ID"])
      local buff = ed.BuffCreate(buffTb, unit, unit, {
        rank = v._level
      })
      unit:addBuff(buff, unit)
      level = level + v._level
    end
  end
  unit.level = level
  unit:updateSoloAttrib()
end

function Engine:onPrepareJoinBattle(info)
  local pos = info.camp == 1 and self.leftPos or self.rightPos
  local unit = self:createSoloBattleUnit(info.hero, pos, info.camp)
  self:addSoloUnit(unit)
  if ed.run_with_scene then
    FireEvent("SoloBattleHeroJoin", unit, info.camp)
    if info.camp == 1 then
      self.leftUnit = unit
    else
      self.rightUnit = unit
    end
  end
  self:initSoloModeAttribs(unit, info.params)
end

function Engine:printStatistics()
end

function Engine:summonUnit(unit, position, summoner, bornActionName)
  unit.config.is_summoned = true
  unit.position = position
  self:addSoloUnit(unit)
  unit:summon(bornActionName)
  unit.config.summoner = summoner
  unit.hp = unit.attribs.HP
  unit.mp = 0
  if unit.actor then
    unit.actor:update(0)
  end
  local attribs = unit.attribs
  local enhanceRatio = summoner.attribs.MOBRatio * 0.01
  local buffId = 997
  local binfo = ed.lookupDataTable("Buff", nil, buffId)
  local buff = ed.BuffCreate(binfo, unit, summoner)
  local enhanceAttribList = {
    "HP",
    "AD",
    "AP",
    "ARM",
    "MR"
  }
  for _, attribName in ipairs(enhanceAttribList) do
    if 0 < enhanceRatio then
      buff:setAttribute(attribName, attribs[attribName] * enhanceRatio)
    end
  end
  unit:addBuff(buff, summoner)
end

function Engine:createSoloBattleUnit(hero, pos, camp)
  local camp = camp or ed.emCampPlayer
  local unit = ed.SoloUnitCreate(hero, camp)
  unit.position = {
    pos.x,
    pos.y
  }
  unit.direction = camp == ed.emCampPlayer and 1 or -1
  unit:reset()
  unit:setAction("Idle", true)
  return unit
end

function Engine:foreachAliveUnit(camp)
  local list = {}
  local a = self.alive_units
  for _, unit2 in ipairs(a) do
    if camp == 0 or unit2.camp == camp then
      table.insert(list, unit2)
    end
  end
  local i = #list + 1
  return function()
    i = i - 1
    return list[i]
  end
end

function Engine:SoloBattleEndCheck()
  if self.canTick then
    local isBattleEnd = false
    local winCamp = 1
    if self.alive_enemy_count == 0 then
      isBattleEnd = true
      for unit in self:foreachAliveUnit(ed.emCampPlayer) do
        if unit.actor then
          unit.actor:cheer()
        end
      end
    elseif 0 >= self.time_limit then
      isBattleEnd = true
      local playerHpPercent = 0
      local enemyHpPercent = 0
      for unit in self:foreachAliveUnit(ed.emCampPlayer) do
        if unit.actor then
          playerHpPercent = playerHpPercent + unit.hp / unit.attribs.HP
        end
      end
      for unit in self:foreachAliveUnit(ed.emCampEnemy) do
        if unit.actor then
          enemyHpPercent = enemyHpPercent + unit.hp / unit.attribs.HP
        end
      end
      if playerHpPercent > enemyHpPercent then
        for unit in self:foreachAliveUnit(ed.emCampPlayer) do
          if unit.actor then
            unit.actor:cheer()
          end
        end
      else
        for unit in self:foreachAliveUnit(ed.emCampEnemy) do
          if unit.actor then
            unit.actor:cheer()
          end
        end
        winCamp = -1
      end
      if ed.run_with_scene then
        FireEvent("SoloBattleTimeOut")
      end
    elseif self.alive_alliance_count == 0 then
      isBattleEnd = true
      for unit in self:foreachAliveUnit(ed.emCampEnemy) do
        if unit.actor then
          unit.actor:cheer()
        end
      end
      winCamp = -1
    end
    if isBattleEnd then
      self.canTick = false
      self.running = false
      self.enabled = false
      if ed.run_with_scene then
        FireEvent("EventSoloBattleCheckEnd", winCamp)
      end
    end
  end
end

function Engine:updateAllUnit(tick_interval)
  self.alive_alliance_count, self.alive_enemy_count = 0, 0
  self.alive_units = {}
  for k, entity in ipairs(self.unit_list) do
    local isAlive = entity:isAlive()
    local camp = entity.camp
    if camp == ed.emCampPlayer then
      if isAlive then
        self.alive_alliance_count = self.alive_alliance_count + 1
        table.insert(self.alive_units, entity)
      end
    elseif isAlive then
      self.alive_enemy_count = self.alive_enemy_count + 1
      table.insert(self.alive_units, entity)
    end
  end
  for k, entity in ipairs(self.unit_list) do
    if not entity.terminated then
      entity:update(tick_interval)
    end
  end
  for k, entity in ipairs(self.projectile_list) do
    if not entity.terminated then
      entity:update(tick_interval)
    end
  end
  local unit_list = {}
  for k, entity in ipairs(self.unit_list) do
    if not entity.terminated then
      table.insert(unit_list, entity)
    end
  end
  self.unit_list = unit_list
  local projectile_list = {}
  for k, entity in ipairs(self.projectile_list) do
    if not entity.terminated then
      table.insert(projectile_list, entity)
    end
  end
  self.projectile_list = projectile_list
end

function Engine:tick()
  self.time_limit = self.time_limit - self.tick_interval
  self:updateAllUnit(self.tick_interval)
  self.ticks = self.ticks + 1
  if do_battle_log then
    btlog(tostring(self))
  end
  self:battleEndCheck()
end

function Engine:exitChessCheck(result)
  self.running = false
  self.enabled = false
  self.canTick = false
  self.battleResult = result
  if ed.soloSaveChessLog then
    self:saveBattleLog()
  end
end

function Engine:battleEndCheck()
  if ed.run_with_scene then
    self:SoloBattleEndCheck()
  elseif ed.pre_check_battle then
    self:SoloBattleEndCheck()
  else
    local result = self:checkBattleResult()
    if result then
      self:exitChessCheck(result)
    end
  end
end

function Engine:getAliveUnits()
  local selfHeros = {}
  local enemyHeros = {}
  for i, unit in pairs(self.unit_list) do
    if unit.camp == ed.emCampEnemy then
      if unit:isAlive() then
        table.insert(enemyHeros, unit.insid)
      end
    elseif unit.camp == ed.emCampPlayer and unit:isAlive() then
      table.insert(selfHeros, unit.insid)
    end
  end
  return selfHeros, enemyHeros
end

function Engine:checkBattleResult()
  local result
  if self.alive_enemy_count == 0 then
    result = 0
  elseif 0 >= self.time_limit then
    local playerHpPercent = 0
    local enemyHpPercent = 0
    for unit in self:foreachAliveUnit(ed.emCampPlayer) do
      playerHpPercent = playerHpPercent + unit.hp / unit.attribs.HP
    end
    for unit in self:foreachAliveUnit(ed.emCampEnemy) do
      enemyHpPercent = enemyHpPercent + unit.hp / unit.attribs.HP
    end
    if playerHpPercent > enemyHpPercent then
      result = 0
    else
      result = 1
    end
  elseif self.alive_alliance_count == 0 then
    result = 1
  end
  return result
end

function Engine:onUnitDie(unit, killer_unit)
  local list = self.alive_units
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  if unit.camp == ed.emCampPlayer then
    self.alive_alliance_count = self.alive_alliance_count - 1
  elseif unit.camp == ed.emCampEnemy then
    self.alive_enemy_count = self.alive_enemy_count - 1
  end
  if unit == self.leftUnit or unit == self.rightUnit then
    self.deadNum = self.deadNum + 1
  end
end

function Engine:clearAllSoloUnits()
  if type(self.unit_list) == "table" then
    for _, unit in ipairs(self.unit_list) do
      unit:onUnitExitBattle()
    end
  end
  self.unit_list = {}
  for k, v in ipairs(self.projectile_list or {}) do
    v:terminate()
  end
  self.projectile_list = {}
end

function Engine:enterSoloCheck(param)
  self.canTick = true
  self:clearAllSoloUnits()
  self:resetStage()
  local self_team = param._self_team
  local oppo_team = param._oppo_team
  self:onPrepareJoinBattle({
    camp = -1,
    hero = oppo_team._hero,
    params = {
      _cards = oppo_team._cards or {},
      _card_factions = oppo_team._factions or {}
    }
  })
  self:onPrepareJoinBattle({
    camp = 1,
    hero = self_team._hero,
    params = {
      _cards = self_team._cards or {},
      _card_factions = self_team._factions or {}
    }
  })
end
