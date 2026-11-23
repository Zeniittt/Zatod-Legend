local unit_list_names = {
  "unit_list",
  "projectile_list",
  "npc_list",
  "FieldNpc_list"
}
local Engine = {
  mt = {}
}
Engine.mt.__index = Engine
local instance

function Engine.getInstance()
  if not instance then
    instance = Engine.create()
  end
  return instance
end

function Engine.create()
  local self = {}
  setmetatable(self, Engine.mt)
  return self
end

function Engine:__tostring()
  local logtb = {
    "---------------------------------------\n",
    string.format("tick %d\n", self.ticks or 0)
  }
  local idx = 1
  if self.unit_list then
    for i = 1, #self.unit_list do
      local unit = self.unit_list[i]
      if unit:isAlive() then
        logtb[2 + idx] = tostring(unit)
        idx = idx + 1
      end
    end
  end
  return table.concat(logtb)
end

ed.AutoChessEngineClass = Engine
ed.AutoChessBattleEngine = Engine:getInstance()

function Engine:ctMode2String()
  return "autoChess"
end

function Engine:resetStage()
  if ed.player then
    ed.player.loots = {}
    ed.player.hpLoots = {}
  end
  self.enabled = true
  self.unitScale = 1
  self.autoChessMode = true
  self.stage_rect = {
    minX = 0,
    maxX = 800,
    minY = -120,
    maxY = 120
  }
  self.ticks = 0
  ed.tick_interval = 0.125
  self.tick_interval = ed.tick_interval
  self.operation_list = {}
  self.next_operation_index = 1
  self.unit_list = {}
  self:resetBattle()
  self.hero_id_list = {}
  self.death_count = 0
  self.speed_rate = 1
  self.enableHPSAndMPS = true
  self.push_interval_tick = 4
  do_battle_log = not do_battle_log and not ed.debug_mode and not ed.open_debug and ed.run_with_scene and ed.storage.getBool("FORCE_BATTLE_REPORT_FLAG")
  if ed.run_with_scene and not do_battle_log then
    math.randomseed(os.time())
    do_battle_log = math.random(100) <= 10
  end
  self.rect_cut = EngineRectCut
  self.rect_cut.reset()
  battle_tick.init(true)
  battle_tick.initMp()
end

function Engine:resetBattle()
  self.next_tick = 0
  self.time_limit = 90
  self.projectile_list = {}
  self.npc_list = {}
  self.FieldNpc_list = {}
  self.alive_alliance_count = 0
  self.alive_enemy_count = 0
  self.dead_alliance_count = 0
  self.dead_enemy_count = 0
  self.freeze_level = 0
  self.freeze_camp = nil
  self.running = true
  self.beingEnd = false
  self.firstEnemyDie = false
  self.unit_list = {}
  self.alive_units = {
    [ed.emCampPlayer] = {},
    [ed.emCampEnemy] = {},
    [ed.emCampBoth] = {},
    [ed.emCampNeither] = {}
  }
end

function Engine:getBattleCsvName()
  return "Battle"
end

function Engine:arenaMode()
  return false
end

function Engine:specialPveMode(...)
  return false
end

function Engine:manualBtMode()
  return false
end

function Engine:isTowerWarsMode()
  return false
end

function Engine:isStealKill()
  return false
end

local function range(hid)
  local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
  return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
end

local function sortHeroList(list)
  table.sort(list, function(a, b)
    local ra = range(a._tid)
    local rb = range(b._tid)
    if ra == rb then
      return a._tid < b._tid
    end
    return ra < rb
  end)
  local index = 1
  for i, hero in ipairs(list) do
    if hero._tid == 10001 then
      index = i
      break
    end
  end
  if index ~= 1 then
    list[1], list[index] = list[index], list[1]
  end
end

local function sortUnitList(list)
  local function range(unit)
    local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", unit.tid)
    
    return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
  end
  
  table.sort(list, function(a, b)
    if range(a) == range(b) then
      return a.tid < b.tid
    end
    return range(a) < range(b)
  end)
end

function Engine:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, param)
  if nil == hero_list then
    return
  end
  self.hero_list = hero_list
  sortHeroList(hero_list)
  local unitArray = {}
  for i = 1, #hero_list do
    local proto = hero_list[i]
    local battleBonus = param.battleBonus
    if battle_tick.getMpTimePvp() then
      battleBonus = param.bonusInfo and param.bonusInfo[proto._tid] or nil
    end
    local hero
    if ed.enableMaxAttStrategy then
      hero = ed.UnitCreate(proto, ed.emCampPlayer, {
        estimate_rank = false,
        estimate_skill = false,
        estimate_max_rank = ed.enableMaxAttStrategy
      }, nil, nil, 0, param.battleBonus, {
        awakeStageBonus = param.awakeStageBonus
      })
    else
      local param = param or {}
      local mode
      local config = {
        estimate_rank = isbot,
        estimate_skill = isbot,
        estimate_max_rank = ed.enableMaxAttStrategy,
        dps_mod = 1,
        imu_mod = 1
      }
      hero = ed.UnitCreate(proto, ed.emCampPlayer, config, nil, nil, 0, param.battleBonus, {
        awakeStageBonus = param.awakeStageBonus
      })
    end
    hero.ai.will_cast_manual_skill = isbot
    table.insert(self.unit_list, hero)
    table.insert(self.hero_id_list, proto._tid)
    table.insert(unitArray, hero)
  end
  for i = 1, #unitArray do
    local bonusInfos = param.exBonus
    if bonusInfos then
      local unit = unitArray[i]
      unit:initExBonus(bonusInfos)
    end
  end
end

function Engine:onUnitBeKilled(unit)
  if unit.camp ~= ed.emCampEnemy then
    return
  end
  local energy = self.currentEnergy
  if unit.is_monster then
    self.currentEnergy = energy + self.killEnemyEnergy
  end
  if unit.is_boss then
    self.currentEnergy = energy + self.killBossEnergy
  end
end

function Engine:setSpeedRate(rate)
  self.speed_rate = rate
end

function Engine:getSpeedRate()
  return self.speed_rate
end

function Engine:update(dt)
  if not self.running then
    return
  end
  self.next_tick = self.next_tick - dt * self.speed_rate
  if self.next_tick <= 0 then
    self:tick()
    while self.next_tick <= 0 do
      self.next_tick = self.next_tick + self.tick_interval
    end
  end
end

local function runScriptString()
  if EDGetScriptString then
    local temp = EDGetScriptString()
    if temp ~= nil then
      local func = loadstring(temp)
      if func ~= nil then
        xpcall(func, EDDebug)
      end
    end
  end
end

function Engine:tick()
  if ed.enableBotMode then
    runScriptString()
  end
  local tick_interval = self.tick_interval
  self.time_limit = self.time_limit - tick_interval
  local alive_alliance_count, alive_enemy_count = 0, 0
  local dead_alliance_count, dead_enemy_count = 0, 0
  local player_list, enemy_list = {}, {}
  for _, list_name in ipairs(unit_list_names) do
    local list = self[list_name]
    local is_unit_list = list_name == "unit_list"
    for _, entity in ipairs(list) do
      if is_unit_list then
        local isAlive = entity:isAlive()
        local camp = entity.camp
        if entity.controlledTarget then
          camp = -camp
        end
        if camp == ed.emCampPlayer then
          if isAlive then
            alive_alliance_count = alive_alliance_count + 1
            table.insert(player_list, entity)
          else
            dead_alliance_count = dead_alliance_count + 1
          end
        elseif isAlive then
          alive_enemy_count = alive_enemy_count + 1
          table.insert(enemy_list, entity)
        else
          dead_enemy_count = dead_enemy_count + 1
        end
      end
      local frozen_model = entity.frozen_model
      if not entity.terminated and not frozen_model then
        entity:update(tick_interval)
      end
    end
  end
  for _, list_name in ipairs(unit_list_names) do
    local list = self[list_name]
    local new_list = {}
    for _, entity in ipairs(list) do
      if not entity.terminated then
        table.insert(new_list, entity)
      end
    end
    self[list_name] = new_list
  end
  self.alive_alliance_count = alive_alliance_count
  self.alive_enemy_count = alive_enemy_count
  self.dead_alliance_count = dead_alliance_count
  self.dead_enemy_count = dead_enemy_count
  self.alive_units[ed.emCampPlayer] = player_list
  self.alive_units[ed.emCampEnemy] = enemy_list
  if self.battle_manager then
    self.battle_manager:Update(ed.tick_interval)
  end
  if self.ticks % self.push_interval_tick == 0 then
    self:updatePush(ed.emCampPlayer, tick_interval)
    self:updatePush(ed.emCampEnemy, tick_interval)
  end
  self.ticks = self.ticks + 1
  if do_battle_log then
    btlog(tostring(self))
  end
  if ed.run_with_scene and not ed.run_chess_check then
    self:autoChessBattleEndCheck()
  else
    self:chessBattleEndCheckNew()
  end
end

function Engine:updatePush(camp, dt)
  local list = self.alive_units[camp]
  local length = #list
  for i = 1, length do
    local unit1 = list[i]
    if not unit1.flying then
      local movable = not unit1.buff_effects.immoblilize
      local isWalking = unit1.state == ed.emUnitState_Walk
      local isIdle = unit1.state == ed.emUnitState_Idle
      if movable and (isWalking or isIdle) then
        local pushVelocity = 0
        local position = unit1.position
        local collideWith = ed.Entity.collideWith
        local isBuilding = unit1.buff_effects.building or unit1.buff_effects.building_notfix
        local stage_rect = self.stage_rect
        for j = i + 1, length do
          local unit2 = list[j]
          if not unit2.flying and collideWith(unit1, unit2) and not isBuilding then
            pushVelocity = pushVelocity + (0 < position[2] - unit2.position[2] and 30 or -30)
          end
        end
        if position[2] > stage_rect.maxY and 0 < pushVelocity then
          pushVelocity = 0
        end
        if position[2] < stage_rect.minY and pushVelocity < 0 then
          pushVelocity = 0
        end
        if pushVelocity ~= 0 then
          unit1.push = true
          position[2] = position[2] + pushVelocity * dt
          if isIdle then
            unit1:setAction("Move", true)
          end
        else
          unit1.push = false
          if isIdle then
            unit1:setAction(unit1.idleName, true)
          end
        end
      end
    end
  end
end

function Engine:freeze(camp)
  if self.freeze_level == 0 then
    if ed.run_with_scene then
      ed.scene:onSceneFreezeBegin()
    end
    for entity in self:foreachEntity() do
      entity:freeze()
    end
  end
  self.freeze_level = self.freeze_level + 1
  self.freeze_camp = camp
end

function Engine:unfreeze(force)
  if force then
    if self.freeze_level == 0 then
      self.freeze_camp = nil
      return
    else
      self.freeze_level = 1
    end
  end
  self.freeze_level = self.freeze_level - 1
  if self.freeze_level == 0 then
    self.freeze_camp = nil
    for entity in self:foreachEntity() do
      entity:unfreeze()
    end
    if ed.run_with_scene then
      ed.scene:onSceneFreezeEnd()
    end
  end
end

function Engine:cutScene(x, y, w)
  return self.rect_cut.add(x, y, w)
end

function Engine:closeCut(idx)
  self.rect_cut.remove(idx)
end

function Engine:clearCut()
  self.rect_cut.clear()
end

function Engine:addUnit(unit)
  local alive = unit:isAlive()
  unit.previous_position = {
    unit.position[1],
    unit.position[2]
  }
  table.insert(self.unit_list, unit)
  if alive then
    table.insert(self.alive_units[unit.camp], unit)
    table.insert(self.alive_units[ed.emCampBoth], unit)
    if unit.camp == 2 and unit.name == "Duckboy" then
      table.insert(self.alive_units[ed.emCampEnemy], unit)
      table.insert(self.alive_units[ed.emCampPlayer], unit)
      table.insert(self.alive_units[ed.emCampNeither], unit)
    end
    if unit.camp == ed.emCampPlayer then
      self.alive_alliance_count = self.alive_alliance_count + 1
    elseif unit.camp == ed.emCampEnemy then
      self.alive_enemy_count = self.alive_enemy_count + 1
    end
  elseif unit.camp == ed.emCampPlayer then
    self.dead_alliance_count = self.dead_alliance_count + 1
  elseif unit.camp == ed.emCampEnemy then
    self.dead_enemy_count = self.dead_enemy_count + 1
  end
  unit.index_in_engine = #self.unit_list
  unit:clearActor()
  unit:startWork()
end

function Engine:addStageUint(unit)
  table.insert(self.FieldNpc_list, unit)
end

function Engine:summonUnit(unit, position, summoner, bornActionName)
  unit.config.is_summoned = true
  unit.position = position
  self:addUnit(unit)
  unit:summon(bornActionName)
  unit.config.summoner = summoner
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
  if unit.config.summoner and unit.config.summoner.controlledTarget and unit.config.summoner.oldData then
    unit.summon_oldcamp = unit.config.summoner.oldData.camp * (unit.camp * unit.config.summoner.camp)
  end
  if summoner and summoner.campLv and (not unit.campLv or unit.campLv == 0) then
    unit.campLv = summoner.campLv
  end
end

function Engine:onNpcDie(npc)
  local list = self.npc_list
  for i, u in pairs(list) do
    if u == npc then
      table.remove(self.npc_list, i)
      break
    end
  end
end

function Engine:onUnitDie(unit, killer_unit, sureKMPR)
  if killer_unit and killer_unit.what == "petUnit" then
    killer_unit = killer_unit.owner
  end
  local list = self.alive_units[unit.camp]
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  list = self.alive_units[ed.emCampBoth]
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  for i, u in pairs(self.unit_list) do
    if u == unit then
    else
      u:handleUnitDieEventToAll(unit, killer_unit)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u == unit then
    else
      u:handleUnitDieEventToAll(unit, killer_unit)
    end
  end
  if unit.camp == ed.emCampPlayer then
    self.alive_alliance_count = self.alive_alliance_count - 1
    self.dead_alliance_count = self.dead_alliance_count + 1
  elseif unit.camp == ed.emCampEnemy then
    self.alive_enemy_count = self.alive_enemy_count - 1
    self.dead_enemy_count = self.dead_enemy_count + 1
    if ed.run_with_scene then
      ed.scene:showMonsterLoots(self.wave_id, unit)
    end
  end
  if killer_unit and not unit.config.is_summoned then
    killer_unit.battledata:addKilled(unit.tid)
  end
  if ed.run_with_scene then
    FireEvent("UnitDie", unit, killer_unit)
    ListenTimer(Timer:Once(1), function()
      FireEvent("UnitDieDelay", unit, killer_unit)
    end)
  end
end

function Engine:getBattleResult()
  local selfHeros = {}
  local enemyHeros = {}
  local bMercenary = {}
  for i, unit in pairs(self.unit_list) do
    if unit.config.is_summoned then
    else
      local hero = {}
      hero._heroid = unit.tid
      hero._hp_perc = math.ceil(unit.hp / unit.attribs.HP * 10000)
      if unit.attribs.MP == 0 then
        hero._mp_perc = 0
      else
        hero._mp_perc = math.ceil(unit.mp / unit.attribs.MP * 10000)
      end
      hero._custom_data = unit.custom_data
      if unit.camp == ed.emCampEnemy then
        if unit.index_in_team then
          enemyHeros[unit.index_in_team] = hero
        else
          table.insert(enemyHeros, hero)
        end
      elseif unit.camp == ed.emCampPlayer then
        table.insert(selfHeros, hero)
        table.insert(bMercenary, unit:isMercenary())
      end
    end
  end
  return selfHeros, enemyHeros, bMercenary
end

function Engine:getHeroPvPBattleData()
  local herosData = {}
  for i, unit in pairs(self.unit_list) do
    if unit.config.is_summoned then
    else
      local hero = {}
      hero._tid = unit.tid
      hero._damage = unit.battledata:getDamage()
      hero._kill = unit.battledata:getKillNum()
      hero._healing = unit.battledata:getTakeHeal()
      hero._suffer_damage = unit.battledata:getBearDamage()
      hero._level = unit.level
      hero._stars = unit.stars
      hero._rank = unit.rank
      hero._hp = unit.hp
      hero._camp = unit.camp
      hero._fashion_id = unit.fashion_id
      local proto = unit.proto
      if unit.proto then
        hero._proto_rank = unit.proto._rank
        if unit.proto._shard then
          hero._shard_id = unit.proto._shard._id
        end
      end
      table.insert(herosData, hero)
    end
  end
  return herosData
end

function Engine:printStatistics()
  print("==========================================")
  local unitDamage = {}
  local maxdmg = 0
  local maxlen = 0
  for i, unit in ipairs(self.unit_list) do
    maxdmg = math.max(maxdmg, unit.battledata:getDamage())
    maxlen = math.max(maxlen, #unit.name)
  end
  print("                   damage")
  for i, unit in ipairs(self.unit_list) do
    local ratio = math.floor(unit.battledata:getDamage() / maxdmg * 20)
    print(table.concat({
      unit.camp == 1 and "[+]" or "[-]",
      unit.name,
      string.rep(" ", maxlen - #unit.name + 1),
      string.rep("#", ratio),
      string.rep(" ", 21 - ratio),
      math.floor(unit.battledata:getDamage())
    }))
    if unit.camp == 1 then
      unitDamage[unit.tid] = unit.battledata:getDamage()
    end
  end
  print("==========================================")
  if self.multiplayerMode then
    ed.dreamland.Dreamland:setUnitDamage(unitDamage)
  end
end

function Engine:getPlayerTotalDamage(camp)
  local damage = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == camp then
      damage = damage + unit.battledata:getDamage()
    end
  end
  return damage
end

function Engine:saveBattleLog(checkId)
  if do_battle_log and not EDFLAGSVR then
    self.battleLog = getBtlog()
    if ed.debug_mode then
      local folder = CCFileUtils:sharedFileUtils():getWritablePath()
      local path = string.format("%s/%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"))
      if checkId then
        path = string.format("%s/%s_%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"), checkId)
      end
      local file = io.open(path, "w")
      if file then
        file:write(self.battleLog)
        file:close()
      end
    end
  end
end

function Engine:exitStage(result, exitFlag)
  self.beingEnd = false
  self.running = false
  self.enabled = false
  self.stage_ended = true
  self.battleResult = result
  if do_battle_log then
    btlog(tostring(self))
    btlog("-----------------------------------------------------------------")
    btlog(ed.tabletostring(self.operation_list))
  end
  if ed.run_with_scene then
    self:printStatistics()
    ed.stopMusic()
    ed.scene.running = false
    self:saveBattleLog()
  end
end

function Engine:foreachAliveUnit(camp)
  local list = {}
  if camp == ed.emCampBoth then
    list = self.alive_units[ed.emCampBoth]
  else
    local a = self.alive_units[ed.emCampBoth]
    for _, unit2 in ipairs(a) do
      if unit2.camp == camp or unit2.camp == 2 then
        table.insert(list, unit2)
      end
    end
  end
  local i = #list + 1
  return function()
    i = i - 1
    return list[i]
  end
end

function Engine:foreachNpc()
  local list = self.npc_list
  local i = #list + 1
  return function()
    i = i - 1
    return list[i]
  end
end

function Engine:foreachEntity()
  local list_of_list = unit_list_names
  local i, j = 1, 1
  return function()
    repeat
      local list = self[list_of_list[i]]
      if list == nil then
        return nil
      end
      local ret = list[j]
      if j >= #list then
        i = i + 1
        j = 1
      else
        j = j + 1
      end
      if ret and not ret.terminated then
        return ret
      end
    until ret
  end
end

function Engine:addProjectile(projectile)
  if projectile then
    projectile.previous_position = {
      projectile.position[1],
      projectile.position[2]
    }
    table.insert(self.projectile_list, projectile)
    if ed.run_with_scene then
      local actor = ed.ProjectileActorCreate(projectile)
      ed.scene:addActor(actor)
      projectile.actor = actor
    end
  end
end

function Engine:addChain(chain)
  if chain then
    table.insert(self.projectile_list, chain)
  end
end

function Engine:setTimeLimit(time)
  self.left_time = time
end

function Engine:addRegion(region)
  if region then
    table.insert(self.projectile_list, region)
    if ed.run_with_scene then
      local actor = ed.baseActorCreate(region)
      ed.scene:addActor(actor)
    end
  end
end

function Engine:getUnitByIndex(index, camp)
  if self.alive_units[camp] then
    return self.alive_units[camp][index]
  end
end

function Engine:getUnitNum(camp)
  if self.alive_units[camp] then
    return #self.alive_units[camp]
  end
  return 0
end

function Engine:collectSkill(unit, skill, idx)
  for i, u in pairs(self.unit_list) do
    if u.collectSkill then
      u:collectSkill(unit, skill, idx)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectSkill then
      u:collectSkill(unit, skill, idx)
    end
  end
end

function Engine:collectSkillHit(unit, skill, target)
  for i, u in pairs(self.unit_list) do
    if u.collectSkillHit then
      u:collectSkillHit(unit, skill, target)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectSkillHit then
      u:collectSkillHit(unit, skill, target)
    end
  end
end

function Engine:listerRemoveBuff(buff)
  for i, u in pairs(self.unit_list) do
    if u.listerRemoveBuff then
      u:listerRemoveBuff(buff)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.listerRemoveBuff then
      u:listerRemoveBuff(buff)
    end
  end
end

function Engine:collectBuff(buff)
  for i, u in pairs(self.unit_list or {}) do
    if u.collectBuff then
      u:collectBuff(buff)
    end
  end
  for i, u in pairs(self.FieldNpc_list or {}) do
    if u.collectBuff then
      u:collectBuff(buff)
    end
  end
end

function Engine:collectHPchange(config)
  for i, u in pairs(self.unit_list) do
    if u.collectHPchange then
      u:collectHPchange(config)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectHPchange then
      u:collectHPchange(config)
    end
  end
end

function Engine:collectMPchange(config)
  for i, u in pairs(self.unit_list) do
    if u.collectMPchange then
      u:collectMPchange(config)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectMPchange then
      u:collectMPchange(config)
    end
  end
end

function Engine:enterAutoChess(param)
  self:resetStage()
  self:initAutoChessParam(param)
  self.push_interval_tick = 4
end

function Engine:initAutoChessParam(param)
  self.wave_id = 1
  self.autoChessMode = true
  self.stage_rect = {
    minX = 0,
    maxX = 800,
    minY = -240,
    maxY = 240
  }
  self.stage_info = ed.lookupDataTable("Stage", param.stageId)
  self.mp_bonus = self.stage_info["MP Bonus"]
end

function Engine:addChessUnit(unit, withEffect)
  local alive = unit:isAlive()
  unit.previous_position = {
    unit.position[1],
    unit.position[2]
  }
  table.insert(self.unit_list, unit)
  if alive then
    table.insert(self.alive_units[unit.camp], unit)
    table.insert(self.alive_units[ed.emCampBoth], unit)
    if unit.camp == ed.emCampPlayer then
      self.alive_alliance_count = self.alive_alliance_count + 1
    elseif unit.camp == ed.emCampEnemy then
      self.alive_enemy_count = self.alive_enemy_count + 1
    end
  elseif unit.camp == ed.emCampPlayer then
    self.dead_alliance_count = self.dead_alliance_count + 1
  elseif unit.camp == ed.emCampEnemy then
    self.dead_enemy_count = self.dead_enemy_count + 1
  end
  unit.index_in_engine = #self.unit_list
  unit:clearActor()
  unit:startWork()
  if not unit.actor and ed.run_with_scene then
    if ed.scene.scene then
      unit.actor = ed.UnitActorCreate(unit)
      ed.scene:addActor(unit.actor)
      unit.actor:update(0)
    end
    local origin = {
      unit.position[1],
      unit.position[2]
    }
    if withEffect then
      local effect_name1 = "eff_UI_Chess_hero_evolution.cha"
      local effect_name2 = "eff_UI_Chess_hero_evolution2.cha"
      ed.scene:playEffectOnScene(effect_name1, origin, {
        unit.direction * 0.85,
        0.85
      }, nil, 1)
      ed.scene:playEffectOnScene(effect_name2, origin, {
        unit.direction * 0.85,
        0.85
      }, nil, -1)
    end
  end
end

function Engine:clearAllChessUnits()
  if type(self.unit_list) == "table" then
    for _, unit in ipairs(self.unit_list) do
      unit:onUnitExitBattle()
    end
  end
  self.unit_list = {}
end

function Engine:onUnitExit(unit)
  local list = self.alive_units[unit.camp]
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  list = self.alive_units[ed.emCampBoth]
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  if unit.camp == ed.emCampPlayer then
    self.alive_alliance_count = self.alive_alliance_count - 1
    self.dead_alliance_count = self.dead_alliance_count + 1
  elseif unit.camp == ed.emCampEnemy then
    self.alive_enemy_count = self.alive_enemy_count - 1
    self.dead_enemy_count = self.dead_enemy_count + 1
  end
end

function Engine:runChessPrepareOperations()
  local ulist = self.unit_list
  
  local function doOpCall(opp)
    local op = opp.op
    if op == ed.opPrepareJoinBattle then
      local hero = opp.hero
      local pos = opp.pos
      if not hero or not pos then
        return
      end
      local info = {
        hero = hero,
        pos = pos,
        camp = opp.camp
      }
      self:onPrepareJoinBattle(info)
    end
    if op == ed.opPrepareUndoJoinBattle then
      local insid = opp.insid
      for _, unit in ipairs(ulist) do
        if unit.insid == insid then
          unit:onUnitExitBattle(true)
          break
        end
      end
    end
  end
  
  local curtick = self.ticks
  local oplist = self.operation_list
  local opindex = self.next_operation_index
  while oplist[opindex] do
    local opp = oplist[opindex]
    if opp.tick == curtick then
      doOpCall(opp)
      opindex = opindex + 1
    else
      break
    end
  end
  self.next_operation_index = opindex
end

function Engine:onPrepareJoinBattle(info, isCheck)
  local pos = info.pos
  local chessHero = info.hero
  local hero = {
    _tid = chessHero:getChessId(),
    _insid = chessHero:getHeroInsid(),
    still_show = info.still_show,
    show_tag = info.show_tag,
    show_pet = info.show_pet
  }
  local chessPet = chessHero:getEquipChessPet()
  if chessPet and info.addPet then
    hero._pet = {
      _insid = chessPet:getChessPetInsid(),
      _pid = chessPet:getChessPetId()
    }
  end
  if chessPet and info.show_pet then
    hero.pid = chessPet:getChessPetId()
  end
  local unit = self:createChessBattleUnit(hero, pos, info.camp)
  local isTagEffect, tags = false, {}
  if isCheck then
    isTagEffect, tags = self:checkChessTagEffect(hero._tid)
  end
  self:addChessUnit(unit, info.withEffect)
  FireEvent("EventChessUpdateTag", isTagEffect, tags)
end

function Engine:delChessUnitFromBattle(insid)
  local ulist = self.unit_list
  for i, unit in ipairs(ulist) do
    if unit.insid == insid then
      unit:onUnitExitBattle(true)
      table.remove(self.unit_list, i)
      break
    end
  end
  FireEvent("EventChessUpdateTag", false)
end

function Engine:moveChessUnitFromBattle(insid, pos)
  local ulist = self.unit_list
  for _, unit in ipairs(ulist) do
    if unit.insid == insid then
      unit.position = {
        pos.x,
        pos.y
      }
      break
    end
  end
end

function Engine:createChessBattleUnit(hero, pos, camp)
  local config = {
    estimate_rank = false,
    estimate_skill = true,
    estimate_max_rank = false
  }
  local dynaData = {_mp_perc = 0}
  local camp = camp or ed.emCampPlayer
  local unit = ed.ChessUnitCreate(hero, camp, config, dynaData)
  unit.position = {
    pos.x,
    pos.y
  }
  unit.direction = camp == ed.emCampPlayer and 1 or -1
  unit:reset()
  unit:setAction("Idle", true)
  if unit.manual_skill then
    unit.manual_skill.cd_remaining = 0
  end
  return unit
end

function Engine:createChessNpcUnit(selfPowers, oppoPowers)
  local proto = {_tid = 100001, _level = 1}
  local config = {
    estimate_rank = true,
    estimate_skill = true,
    estimate_max_rank = false
  }
  local unit = ed.ChessUnitCreate(proto, ed.emCampPlayer, config)
  local selfSkillLists = {}
  for k, v in ipairs(selfPowers or {}) do
    for _, skill in ipairs(v._battle_skills or {}) do
      table.insert(selfSkillLists, skill)
    end
  end
  unit.dyncSkillLists = selfSkillLists
  unit:reset()
  self:addStageUint(unit)
  unit.position = {
    self.stage_rect.maxX / 2,
    0
  }
  local eunit = ed.ChessUnitCreate(proto, ed.emCampEnemy, config)
  local oppoSkillLists = {}
  for k, v in ipairs(oppoPowers or {}) do
    for _, skill in ipairs(v._battle_skills or {}) do
      table.insert(oppoSkillLists, skill)
    end
  end
  eunit.dyncSkillLists = oppoSkillLists
  eunit:reset()
  self:addStageUint(eunit)
  unit.position = {
    self.stage_rect.maxX / 2,
    0
  }
end

function Engine:clearChessNpc(...)
  for _, unit in ipairs(self.FieldNpc_list) do
    unit:onUnitExitBattle()
  end
  self.FieldNpc_list = {}
end

function Engine:autoChessBattleEndCheck()
  if ed.AutoChessManager:getBattleEndCheck() then
    local isBattleEnd = false
    if self.alive_enemy_count == 0 then
      isBattleEnd = true
      for unit in self:foreachAliveUnit(ed.emCampPlayer) do
        if unit.actor then
          unit.actor:cheer()
        end
      end
    elseif 0 >= self.time_limit then
      isBattleEnd = true
    elseif self.alive_alliance_count == 0 then
      isBattleEnd = true
    end
    if isBattleEnd then
      ed.AutoChessManager:enterStage(ed.AutoChessManager.GAMESTAGE.WAITTING)
      ed.AutoChessManager:stopBattleEndCheck()
      ed.AutoChessManager:handlerBattleConfirm()
      FireEvent("EventChessBattleCheckEnd")
    end
  end
end

function Engine:getChessTagData(camp)
  local heroList = {}
  local tagData = {
    race = {},
    ability = {}
  }
  for _, unit in ipairs(self.unit_list) do
    if unit.camp == camp then
      local heroId = unit.info["Hero ID"]
      if not ed.isElementInTable(heroId, heroList) then
        table.insert(heroList, heroId)
        local raceTags = unit.info["Race Tag"]
        for _, tag in ipairs(raceTags) do
          if tagData.race[tag] == nil then
            tagData.race[tag] = 0
          end
          tagData.race[tag] = tagData.race[tag] + 1
        end
        local abilityTags = unit.info["Ability Tag"]
        for _, tag in ipairs(abilityTags) do
          if tagData.ability[tag] == nil then
            tagData.ability[tag] = 0
          end
          tagData.ability[tag] = tagData.ability[tag] + 1
        end
      end
    end
  end
  return tagData
end

function Engine:checkChessTagEffect(hid)
  local tagData = self:getChessTagData(ed.emCampPlayer)
  local raceTags = tagData.race
  local abilityTags = tagData.ability
  local chessTags = {}
  local chessRaceTags = ed.getChessUnitRaceTags(hid)
  local chessAbilityTags = ed.getChessUnitAbilityTags(hid)
  local isTagEffect = false
  for _, tag in pairs(chessRaceTags) do
    local raceNum = raceTags[tag] or 0
    local abilityNum = abilityTags[tag] or 0
    local totalNum = raceNum + abilityNum + 1
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    for _, config in ipairs(tagConfig) do
      if totalNum >= config.min and totalNum <= config.max then
        isTagEffect = true
        chessTags[#chessTags + 1] = tag
      end
    end
  end
  for _, tag in pairs(chessAbilityTags) do
    local raceNum = raceTags[tag] or 0
    local abilityNum = abilityTags[tag] or 0
    local totalNum = raceNum + abilityNum + 1
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    for _, config in ipairs(tagConfig) do
      if totalNum >= config.min and totalNum <= config.max then
        isTagEffect = true
        chessTags[#chessTags + 1] = tag
      end
    end
  end
  return isTagEffect, chessTags
end

function Engine:exitChessCheck(result)
  self.beingEnd = false
  self.running = false
  self.enabled = false
  self.stage_ended = true
  self.battleResult = result
  if ed.autoSaveChessLog then
    self:saveBattleLog()
  end
end

function Engine:getChessBattleResult()
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

function Engine:chessBattleEndCheckNew()
  if self.alive_enemy_count == 0 then
    self.beingEnd = true
    self:exitChessCheck(0)
  elseif 0 >= self.time_limit then
    self.beingEnd = true
    self:exitChessCheck(0)
  elseif self.alive_alliance_count == 0 then
    self:exitChessCheck(1)
  end
end

function Engine:collectSkillStart(unit, skill, target)
end

function Engine:enterAutoChessCheck(param)
  self.unit_list = {}
  self:resetStage()
  self:initAutoChessParam({stageId = 100001})
  self.autoChessMode = true
  self.push_interval_tick = 4
  self.time_limit = 120
  local heroPos = {
    pos_9 = ccp(105, -43),
    pos_5 = ccp(140, 10),
    pos_1 = ccp(170, 45),
    pos_10 = ccp(175, -43),
    pos_6 = ccp(202, 10),
    pos_2 = ccp(225, 45),
    pos_11 = ccp(245, -43),
    pos_7 = ccp(265, 10),
    pos_3 = ccp(280, 45),
    pos_12 = ccp(320, -43),
    pos_8 = ccp(330, 10),
    pos_4 = ccp(340, 45)
  }
  local self_team = param.self_team
  local oppo_team = param.oppo_team
  local selfPowers = param.self_powers
  local oppoPowers = param.oppo_powers
  for i, hero in ipairs(oppo_team._heroes or {}) do
    local heroData = {
      _tid = hero._hid,
      _insid = hero._insid
    }
    if hero._pet then
      heroData._pet = {
        _insid = hero._pet._insid,
        _pid = hero._pet._pid
      }
    end
    local posIndex = oppo_team._positions[i]
    local pos = heroPos["pos_" .. posIndex]
    pos = ccp(800 - pos.x, pos.y)
    local chessUnit = self:createChessBattleUnit(heroData, pos, ed.emCampEnemy)
    self:addChessUnit(chessUnit)
  end
  for i, hero in ipairs(self_team._heroes or {}) do
    local heroData = {
      _tid = hero._hid,
      _insid = hero._insid
    }
    if hero._pet then
      heroData._pet = {
        _insid = hero._pet._insid,
        _pid = hero._pet._pid
      }
    end
    local posIndex = self_team._positions[i]
    local pos = heroPos["pos_" .. posIndex]
    local chessUnit = self:createChessBattleUnit(heroData, pos, ed.emCampPlayer)
    self:addChessUnit(chessUnit)
  end
  self:clearChessNpc()
  self:createChessNpcUnit(selfPowers, oppoPowers)
end
